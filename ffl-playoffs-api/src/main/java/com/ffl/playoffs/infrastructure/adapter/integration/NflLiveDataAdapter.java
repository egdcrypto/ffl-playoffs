package com.ffl.playoffs.infrastructure.adapter.integration;

import com.ffl.playoffs.domain.model.PlayerStats;
import com.ffl.playoffs.domain.model.nfl.NFLGameStatus;
import com.ffl.playoffs.domain.port.NflLiveDataPort;
import com.ffl.playoffs.infrastructure.scheduler.LiveScoringScheduler.RateLimitException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

/**
 * Infrastructure adapter for fetching live NFL data
 * Implements resilient data fetching with caching and error handling
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class NflLiveDataAdapter implements NflLiveDataPort {

    private final RestTemplate restTemplate;

    @Value("${ffl.nfl.data-source.url:https://api.nfl.com}")
    private String dataSourceUrl;

    @Value("${ffl.nfl.data-source.timeout-ms:10000}")
    private int timeoutMs;

    // Cache for resilience
    private final Map<String, CachedData<List<PlayerStats>>> statsCache = new ConcurrentHashMap<>();
    private final Map<UUID, CachedData<NFLGameStatus>> gameStatusCache = new ConcurrentHashMap<>();

    private static final long CACHE_TTL_MS = 30000; // 30 seconds
    private static final long STALE_CACHE_TTL_MS = 300000; // 5 minutes for stale data

    private final AtomicLong lastFetchTimestamp = new AtomicLong(0);
    private volatile boolean dataSourceAvailable = true;

    @Override
    public List<PlayerStats> fetchLivePlayerStats(int week, int season) {
        String cacheKey = String.format("stats-%d-%d", week, season);

        try {
            // TODO: Replace with actual NFL API call
            // This is a placeholder implementation
            List<PlayerStats> stats = fetchStatsFromSource(week, season);

            // Update cache
            statsCache.put(cacheKey, new CachedData<>(stats, System.currentTimeMillis()));
            lastFetchTimestamp.set(System.currentTimeMillis());
            dataSourceAvailable = true;

            return stats;

        } catch (HttpClientErrorException e) {
            if (e.getStatusCode() == HttpStatus.TOO_MANY_REQUESTS) {
                int retryAfter = parseRetryAfter(e);
                throw new RateLimitException(retryAfter);
            }
            return handleFetchError(cacheKey, e);

        } catch (RestClientException e) {
            return handleFetchError(cacheKey, e);
        }
    }

    @Override
    public List<PlayerStats> fetchGamePlayerStats(UUID nflGameId) {
        String cacheKey = "game-stats-" + nflGameId;

        try {
            // TODO: Replace with actual API call
            List<PlayerStats> stats = fetchGameStatsFromSource(nflGameId);
            statsCache.put(cacheKey, new CachedData<>(stats, System.currentTimeMillis()));
            return stats;

        } catch (RestClientException e) {
            return handleFetchError(cacheKey, e);
        }
    }

    @Override
    public Map<Long, PlayerStats> fetchPlayerStats(List<Long> nflPlayerIds, int week, int season) {
        Map<Long, PlayerStats> result = new HashMap<>();

        // Fetch all stats for the week and filter
        List<PlayerStats> allStats = fetchLivePlayerStats(week, season);

        for (PlayerStats stats : allStats) {
            if (nflPlayerIds.contains(stats.getNflPlayerId())) {
                result.put(stats.getNflPlayerId(), stats);
            }
        }

        return result;
    }

    @Override
    public Optional<NFLGameStatus> getGameStatus(UUID nflGameId) {
        CachedData<NFLGameStatus> cached = gameStatusCache.get(nflGameId);

        if (cached != null && !cached.isExpired(CACHE_TTL_MS)) {
            return Optional.of(cached.data());
        }

        try {
            // TODO: Replace with actual API call
            NFLGameStatus status = fetchGameStatusFromSource(nflGameId);
            gameStatusCache.put(nflGameId, new CachedData<>(status, System.currentTimeMillis()));
            return Optional.of(status);

        } catch (RestClientException e) {
            log.error("Error fetching game status for {}: {}", nflGameId, e.getMessage());

            // Return stale cached data if available
            if (cached != null && !cached.isExpired(STALE_CACHE_TTL_MS)) {
                log.warn("Using stale cached status for game {}", nflGameId);
                return Optional.of(cached.data());
            }

            return Optional.empty();
        }
    }

    @Override
    public Map<UUID, NFLGameStatus> getAllGameStatuses(int week, int season) {
        Map<UUID, NFLGameStatus> statuses = new HashMap<>();

        try {
            // TODO: Replace with actual API call to get all game statuses
            // For now, return cached statuses
            gameStatusCache.forEach((gameId, cached) -> {
                if (!cached.isExpired(CACHE_TTL_MS)) {
                    statuses.put(gameId, cached.data());
                }
            });

        } catch (Exception e) {
            log.error("Error fetching all game statuses: {}", e.getMessage());
        }

        return statuses;
    }

    @Override
    public List<UUID> getGamesInProgress(int week, int season) {
        List<UUID> inProgress = new ArrayList<>();

        Map<UUID, NFLGameStatus> allStatuses = getAllGameStatuses(week, season);

        for (Map.Entry<UUID, NFLGameStatus> entry : allStatuses.entrySet()) {
            if (entry.getValue().isActive()) {
                inProgress.add(entry.getKey());
            }
        }

        return inProgress;
    }

    @Override
    public Optional<String> getGameClock(UUID nflGameId) {
        // TODO: Implement actual API call
        return Optional.of("3Q 8:42");
    }

    @Override
    public Optional<Map<String, Integer>> getGameScore(UUID nflGameId) {
        // TODO: Implement actual API call
        return Optional.of(Map.of("homeScore", 21, "awayScore", 14));
    }

    @Override
    public boolean isAvailable() {
        return dataSourceAvailable;
    }

    @Override
    public long getLastFetchTimestamp() {
        return lastFetchTimestamp.get();
    }

    // Private helper methods

    private List<PlayerStats> fetchStatsFromSource(int week, int season) {
        // TODO: Implement actual HTTP call to NFL data source
        // String url = String.format("%s/stats/week/%d/season/%d", dataSourceUrl, week, season);
        // return restTemplate.getForObject(url, StatsResponse.class).getStats();

        // Placeholder - returns empty list
        log.debug("Fetching stats for week {} season {} (placeholder)", week, season);
        return new ArrayList<>();
    }

    private List<PlayerStats> fetchGameStatsFromSource(UUID nflGameId) {
        // TODO: Implement actual HTTP call
        log.debug("Fetching stats for game {} (placeholder)", nflGameId);
        return new ArrayList<>();
    }

    private NFLGameStatus fetchGameStatusFromSource(UUID nflGameId) {
        // TODO: Implement actual HTTP call
        log.debug("Fetching game status for {} (placeholder)", nflGameId);
        return NFLGameStatus.SCHEDULED;
    }

    private List<PlayerStats> handleFetchError(String cacheKey, Exception e) {
        log.error("Error fetching live stats: {}", e.getMessage());
        dataSourceAvailable = false;

        // Try to return cached data
        CachedData<List<PlayerStats>> cached = statsCache.get(cacheKey);
        if (cached != null && !cached.isExpired(STALE_CACHE_TTL_MS)) {
            log.warn("Using stale cached stats for {}", cacheKey);
            return cached.data();
        }

        return new ArrayList<>();
    }

    private int parseRetryAfter(HttpClientErrorException e) {
        String retryAfterHeader = e.getResponseHeaders() != null ?
                e.getResponseHeaders().getFirst("Retry-After") : null;

        if (retryAfterHeader != null) {
            try {
                return Integer.parseInt(retryAfterHeader);
            } catch (NumberFormatException ex) {
                // Default to 120 seconds
            }
        }
        return 120;
    }

    private record CachedData<T>(T data, long cachedAt) {
        boolean isExpired(long ttlMs) {
            return System.currentTimeMillis() - cachedAt > ttlMs;
        }
    }
}
