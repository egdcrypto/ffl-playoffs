package com.ffl.playoffs.infrastructure.adapter.integration.cache;

import com.ffl.playoffs.domain.port.NflDataProvider;
import com.ffl.playoffs.infrastructure.config.cache.CacheTTLConfig;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.cache.CacheManager;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Cache Warming Service
 *
 * Pre-fetches and caches data before peak traffic times to maximize cache hit rates.
 *
 * Warming strategies:
 * - Pre-game warming: Fetch player/schedule data before Sunday games
 * - Popular data warming: Pre-cache frequently accessed players
 * - Daily warming: Refresh long-TTL data daily
 *
 * Runs scheduled jobs to keep cache "warm" and reduce API calls during games.
 */
@Service
@Slf4j
public class CacheWarmingService {

    private final NflDataProvider nflDataProvider;
    private final CacheManager cacheManager;

    private static final ZoneId ET_ZONE = ZoneId.of("America/New_York");
    private static final int CURRENT_SEASON = 2024;

    private final AtomicBoolean warmingInProgress = new AtomicBoolean(false);

    public CacheWarmingService(
            @Qualifier("sportsDataIoAdapter") NflDataProvider nflDataProvider,
            CacheManager cacheManager) {
        this.nflDataProvider = nflDataProvider;
        this.cacheManager = cacheManager;
    }

    /**
     * Pre-game cache warming - runs Sunday at 12:00 PM ET
     * Warms cache before the 1:00 PM ET games start
     */
    @Scheduled(cron = "0 0 12 * * SUN", zone = "America/New_York")
    public void warmCacheBeforeSundayGames() {
        log.info("Starting pre-game cache warming for Sunday games");
        warmGameDayCache();
    }

    /**
     * Thursday Night Football warming - runs Thursday at 7:00 PM ET
     */
    @Scheduled(cron = "0 0 19 * * THU", zone = "America/New_York")
    public void warmCacheBeforeThursdayGame() {
        log.info("Starting pre-game cache warming for Thursday Night Football");
        warmGameDayCache();
    }

    /**
     * Monday Night Football warming - runs Monday at 7:00 PM ET
     */
    @Scheduled(cron = "0 0 19 * * MON", zone = "America/New_York")
    public void warmCacheBeforeMondayGame() {
        log.info("Starting pre-game cache warming for Monday Night Football");
        warmGameDayCache();
    }

    /**
     * Daily cache warming - runs at 6:00 AM ET
     * Refreshes long-TTL data (player profiles, playoff teams)
     */
    @Scheduled(cron = "0 0 6 * * *", zone = "America/New_York")
    public void dailyCacheWarming() {
        log.info("Starting daily cache warming");
        warmDailyCache();
    }

    /**
     * Warm cache with game day data
     */
    @Async
    public void warmGameDayCache() {
        if (!warmingInProgress.compareAndSet(false, true)) {
            log.warn("Cache warming already in progress, skipping");
            return;
        }

        try {
            long startTime = System.currentTimeMillis();
            int currentWeek = getCurrentNFLWeek();

            log.info("Warming cache for NFL week {}", currentWeek);

            // 1. Warm playoff teams
            warmPlayoffTeams();

            // 2. Warm week schedule
            warmWeekSchedule(currentWeek);

            // 3. Warm team player stats for playoff teams
            warmTeamPlayerStats(currentWeek);

            long duration = System.currentTimeMillis() - startTime;
            log.info("Game day cache warming completed in {} ms", duration);

        } catch (Exception e) {
            log.error("Error during game day cache warming", e);
        } finally {
            warmingInProgress.set(false);
        }
    }

    /**
     * Warm cache with daily data
     */
    @Async
    public void warmDailyCache() {
        if (!warmingInProgress.compareAndSet(false, true)) {
            log.warn("Cache warming already in progress, skipping");
            return;
        }

        try {
            long startTime = System.currentTimeMillis();

            // Warm playoff teams (changes rarely during playoffs)
            warmPlayoffTeams();

            long duration = System.currentTimeMillis() - startTime;
            log.info("Daily cache warming completed in {} ms", duration);

        } catch (Exception e) {
            log.error("Error during daily cache warming", e);
        } finally {
            warmingInProgress.set(false);
        }
    }

    /**
     * Warm playoff teams cache
     */
    private void warmPlayoffTeams() {
        try {
            log.debug("Warming playoff teams cache");
            List<String> teams = nflDataProvider.getPlayoffTeams(CURRENT_SEASON);
            log.info("Cached {} playoff teams", teams.size());
        } catch (Exception e) {
            log.error("Error warming playoff teams cache", e);
        }
    }

    /**
     * Warm week schedule cache
     */
    private void warmWeekSchedule(int week) {
        try {
            log.debug("Warming schedule cache for week {}", week);
            var schedule = nflDataProvider.getWeekSchedule(week, CURRENT_SEASON);
            log.info("Cached schedule for week {} with {} games", week, schedule.size());
        } catch (Exception e) {
            log.error("Error warming schedule cache for week {}", week, e);
        }
    }

    /**
     * Warm team player stats for playoff teams
     */
    private void warmTeamPlayerStats(int week) {
        try {
            List<String> playoffTeams = nflDataProvider.getPlayoffTeams(CURRENT_SEASON);

            for (String team : playoffTeams) {
                try {
                    log.debug("Warming player stats cache for team {} week {}", team, week);
                    nflDataProvider.getTeamPlayerStats(team, week, CURRENT_SEASON);
                    Thread.sleep(100); // Rate limit protection
                } catch (Exception e) {
                    log.error("Error warming stats for team {}", team, e);
                }
            }

            log.info("Cached player stats for {} playoff teams", playoffTeams.size());
        } catch (Exception e) {
            log.error("Error warming team player stats", e);
        }
    }

    /**
     * Manually trigger cache warming (for admin use)
     */
    public void triggerManualWarming() {
        log.info("Manual cache warming triggered");
        warmGameDayCache();
    }

    /**
     * Get current NFL week (simplified - would need proper calculation)
     */
    private int getCurrentNFLWeek() {
        // In production, this would calculate based on NFL season start date
        // For playoffs, we're in weeks 18-22
        LocalDateTime now = LocalDateTime.now(ET_ZONE);

        // Simplified logic - return 18 for Wild Card, 19 for Divisional, etc.
        // In real implementation, this would check against NFL schedule
        return 18;
    }

    /**
     * Check if cache warming is currently running
     */
    public boolean isWarmingInProgress() {
        return warmingInProgress.get();
    }

    /**
     * Clear all caches (for admin use)
     */
    public void clearAllCaches() {
        log.info("Clearing all caches");
        for (CacheTTLConfig config : CacheTTLConfig.values()) {
            try {
                var cache = cacheManager.getCache(config.getCacheName());
                if (cache != null) {
                    cache.clear();
                }
            } catch (Exception e) {
                log.error("Error clearing cache: {}", config.getCacheName(), e);
            }
        }
        log.info("All caches cleared");
    }
}
