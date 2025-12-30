package com.ffl.playoffs.infrastructure.scheduler;

import com.ffl.playoffs.application.service.LiveScoringService;
import com.ffl.playoffs.application.service.PushNotificationService;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.NflLiveDataPort;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicLong;

/**
 * Scheduler for live score polling
 * Polls NFL data source every 30 seconds during active games
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class LiveScoringScheduler {

    private final LiveScoringService liveScoringService;
    private final NflLiveDataPort nflLiveDataPort;
    private final LeagueRepository leagueRepository;
    private final PushNotificationService notificationService;

    @Value("${ffl.live-scoring.enabled:true}")
    private boolean liveScoringEnabled;

    @Value("${ffl.live-scoring.poll-interval-ms:30000}")
    private long pollIntervalMs;

    @Value("${ffl.nfl.current-season:2024}")
    private int currentSeason;

    @Value("${ffl.nfl.current-week:1}")
    private int currentWeek;

    // Prevent overlapping poll executions
    private final AtomicBoolean pollInProgress = new AtomicBoolean(false);

    // Track poll timing for backpressure detection
    private final AtomicLong lastPollDurationMs = new AtomicLong(0);
    private static final long BACKPRESSURE_THRESHOLD_MS = 25000; // 25 seconds

    // Rate limit tracking for NFL data source
    private volatile boolean isRateLimited = false;
    private volatile LocalDateTime rateLimitClearsAt = null;

    /**
     * Main polling task - runs every 30 seconds
     * Fetches live stats and updates scores for all active leagues
     */
    @Scheduled(fixedRateString = "${ffl.live-scoring.poll-interval-ms:30000}")
    public void pollLiveScores() {
        if (!liveScoringEnabled) {
            return;
        }

        // Skip if previous poll still running (backpressure)
        if (!pollInProgress.compareAndSet(false, true)) {
            log.warn("Previous poll still in progress, skipping this cycle");
            return;
        }

        // Check rate limiting
        if (isRateLimited && rateLimitClearsAt != null && LocalDateTime.now().isBefore(rateLimitClearsAt)) {
            log.debug("Rate limited, skipping poll until {}", rateLimitClearsAt);
            pollInProgress.set(false);
            return;
        }

        long startTime = System.currentTimeMillis();

        try {
            // Check if any games are in progress
            List<UUID> gamesInProgress = nflLiveDataPort.getGamesInProgress(currentWeek, currentSeason);

            if (gamesInProgress.isEmpty()) {
                log.debug("No games in progress for week {} season {}", currentWeek, currentSeason);
                return;
            }

            log.info("Polling {} games in progress for week {} season {}",
                    gamesInProgress.size(), currentWeek, currentSeason);

            // Get all active leagues and poll for each
            var activeLeagues = leagueRepository.findActiveLeagues();

            for (var league : activeLeagues) {
                try {
                    liveScoringService.pollAndUpdateScores(currentWeek, currentSeason, league.getId().toString());
                } catch (Exception e) {
                    log.error("Error polling scores for league {}: {}", league.getId(), e.getMessage());
                }
            }

            // Clear rate limit flag on success
            isRateLimited = false;
            rateLimitClearsAt = null;

        } catch (RateLimitException e) {
            handleRateLimit(e);
        } catch (Exception e) {
            log.error("Error during live score poll: {}", e.getMessage(), e);
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            lastPollDurationMs.set(duration);

            if (duration > BACKPRESSURE_THRESHOLD_MS) {
                log.warn("Poll took {}ms, exceeding backpressure threshold of {}ms",
                        duration, BACKPRESSURE_THRESHOLD_MS);
            }

            pollInProgress.set(false);
            log.debug("Poll completed in {}ms", duration);
        }
    }

    /**
     * Flush pending push notifications every 2 minutes
     */
    @Scheduled(fixedRate = 120000)
    public void flushNotifications() {
        if (!liveScoringEnabled) {
            return;
        }

        try {
            notificationService.flushPendingNotifications();
        } catch (Exception e) {
            log.error("Error flushing notifications: {}", e.getMessage());
        }
    }

    /**
     * Health check - log polling status every 5 minutes
     */
    @Scheduled(fixedRate = 300000)
    public void logPollingStatus() {
        if (!liveScoringEnabled) {
            log.info("Live scoring is disabled");
            return;
        }

        log.info("Live scoring status: enabled={}, lastPollDuration={}ms, rateLimited={}",
                liveScoringEnabled, lastPollDurationMs.get(), isRateLimited);

        if (nflLiveDataPort.isAvailable()) {
            log.info("NFL data source: available, lastFetch={}",
                    nflLiveDataPort.getLastFetchTimestamp());
        } else {
            log.warn("NFL data source: unavailable");
        }
    }

    private void handleRateLimit(RateLimitException e) {
        isRateLimited = true;
        rateLimitClearsAt = LocalDateTime.now().plusSeconds(e.getRetryAfterSeconds());
        log.warn("Rate limited by NFL data source, resuming at {}", rateLimitClearsAt);
    }

    /**
     * Manually trigger a poll (for testing/admin use)
     */
    public void triggerPoll() {
        log.info("Manual poll triggered");
        pollLiveScores();
    }

    /**
     * Get current polling status
     */
    public PollingStatus getPollingStatus() {
        return new PollingStatus(
                liveScoringEnabled,
                pollInProgress.get(),
                lastPollDurationMs.get(),
                isRateLimited,
                rateLimitClearsAt,
                nflLiveDataPort.isAvailable()
        );
    }

    /**
     * Update current week (for week transitions)
     */
    public void setCurrentWeek(int week) {
        this.currentWeek = week;
        log.info("Updated current week to {}", week);
    }

    public record PollingStatus(
            boolean enabled,
            boolean pollInProgress,
            long lastPollDurationMs,
            boolean rateLimited,
            LocalDateTime rateLimitClearsAt,
            boolean dataSourceAvailable
    ) {}

    public static class RateLimitException extends RuntimeException {
        private final int retryAfterSeconds;

        public RateLimitException(int retryAfterSeconds) {
            super("Rate limited");
            this.retryAfterSeconds = retryAfterSeconds;
        }

        public int getRetryAfterSeconds() {
            return retryAfterSeconds;
        }
    }
}
