package com.ffl.playoffs.infrastructure.config.cache;

import java.time.Duration;

/**
 * Cache TTL (Time-To-Live) Configuration
 *
 * Defines TTL strategies for different data types based on update frequency:
 * - LIVE_STATS: 30 seconds (during games for real-time updates)
 * - NEWS: 15 minutes (frequently updated)
 * - SCHEDULE: 1 hour (relatively stable, 5 min during games)
 * - PLAYER_PROFILE: 24 hours (rarely changes)
 * - FINAL_STATS: 48 hours (for stat corrections), then permanent
 * - SEARCH_RESULTS: 1 hour
 */
public enum CacheTTLConfig {

    /**
     * Live game stats - updated every 30 seconds during games
     */
    LIVE_STATS("live_stats", Duration.ofSeconds(30), Duration.ofSeconds(15)),

    /**
     * News and injury updates - refreshed every 15 minutes
     */
    NEWS("news", Duration.ofMinutes(15), Duration.ofMinutes(5)),

    /**
     * Weekly schedule - 1 hour normally, 5 minutes during games
     */
    SCHEDULE("schedule", Duration.ofHours(1), Duration.ofMinutes(30)),

    /**
     * Schedule during live games - more frequent updates
     */
    SCHEDULE_LIVE("schedule_live", Duration.ofMinutes(5), Duration.ofMinutes(2)),

    /**
     * Player profile data - 24 hours (name, team, position)
     */
    PLAYER_PROFILE("player", Duration.ofHours(24), Duration.ofHours(4)),

    /**
     * Final game stats - 48 hours for stat correction window
     */
    FINAL_STATS("final_stats", Duration.ofHours(48), Duration.ofHours(12)),

    /**
     * Permanent cache - no expiration (after stat corrections applied)
     */
    PERMANENT("permanent", Duration.ofDays(365), Duration.ofDays(30)),

    /**
     * Search results - 1 hour
     */
    SEARCH("search", Duration.ofHours(1), Duration.ofMinutes(15)),

    /**
     * Team roster data - 6 hours
     */
    TEAM_ROSTER("team_roster", Duration.ofHours(6), Duration.ofHours(1)),

    /**
     * Playoff teams list - 24 hours (changes rarely during playoffs)
     */
    PLAYOFF_TEAMS("playoff_teams", Duration.ofHours(24), Duration.ofHours(4)),

    /**
     * Injury report - 1 hour (updated officially at 4 PM ET)
     */
    INJURY_REPORT("injuries", Duration.ofHours(1), Duration.ofMinutes(15));

    private final String cacheName;
    private final Duration redisTTL;
    private final Duration caffeineTTL;

    CacheTTLConfig(String cacheName, Duration redisTTL, Duration caffeineTTL) {
        this.cacheName = cacheName;
        this.redisTTL = redisTTL;
        this.caffeineTTL = caffeineTTL;
    }

    public String getCacheName() {
        return cacheName;
    }

    /**
     * Get Redis TTL (L2 cache - longer duration)
     */
    public Duration getRedisTTL() {
        return redisTTL;
    }

    /**
     * Get Caffeine TTL (L1 cache - shorter duration for freshness)
     */
    public Duration getCaffeineTTL() {
        return caffeineTTL;
    }

    /**
     * Get Redis TTL in seconds
     */
    public long getRedisTTLSeconds() {
        return redisTTL.getSeconds();
    }

    /**
     * Get Caffeine TTL in seconds
     */
    public long getCaffeineTTLSeconds() {
        return caffeineTTL.getSeconds();
    }

    /**
     * Build the full cache key with prefix (array variant)
     */
    public String buildKey(String[] parts) {
        StringBuilder key = new StringBuilder(cacheName);
        for (String part : parts) {
            key.append(":").append(part);
        }
        return key.toString();
    }

    /**
     * Build cache key with single part
     */
    public String buildKeySingle(String part) {
        return cacheName + ":" + part;
    }

    /**
     * Build cache key with multiple parts
     */
    public String buildKeyMultiple(String... parts) {
        StringBuilder key = new StringBuilder(cacheName);
        for (String part : parts) {
            key.append(":").append(part);
        }
        return key.toString();
    }

    /**
     * Build environment-prefixed cache key
     */
    public String buildKeyWithEnv(String environment, String... parts) {
        StringBuilder key = new StringBuilder(environment).append(":").append(cacheName);
        for (String part : parts) {
            key.append(":").append(part);
        }
        return key.toString();
    }

    /**
     * Get cache config by cache name
     */
    public static CacheTTLConfig fromCacheName(String cacheName) {
        for (CacheTTLConfig config : values()) {
            if (config.cacheName.equals(cacheName)) {
                return config;
            }
        }
        return PLAYER_PROFILE; // Default TTL
    }
}
