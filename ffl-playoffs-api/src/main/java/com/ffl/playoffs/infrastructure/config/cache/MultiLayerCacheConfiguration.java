package com.ffl.playoffs.infrastructure.config.cache;

import com.github.benmanes.caffeine.cache.Caffeine;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.caffeine.CaffeineCacheManager;
import org.springframework.cache.support.CompositeCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.cache.RedisCacheManager;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.RedisSerializationContext;

import java.time.Duration;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

/**
 * Multi-Layer Cache Configuration
 *
 * Implements two-layer caching:
 * - Layer 1 (L1): Caffeine - In-memory, fastest, per-instance
 * - Layer 2 (L2): Redis - Distributed, shared across instances
 *
 * Cache Flow:
 * Request -> L1 (Caffeine) -> L2 (Redis) -> API/DB -> Cache -> Response
 *
 * TTL Strategy:
 * - L1 has shorter TTL for freshness
 * - L2 has longer TTL for performance
 *
 * Hexagonal Architecture: Infrastructure layer configuration
 */
@Configuration
@EnableCaching
@Slf4j
public class MultiLayerCacheConfiguration {

    /**
     * Primary composite cache manager that combines Caffeine (L1) and Redis (L2)
     */
    @Bean
    @Primary
    public CacheManager cacheManager(
            CacheManager caffeineCacheManager,
            CacheManager redisCacheManager) {

        CompositeCacheManager compositeCacheManager = new CompositeCacheManager();
        compositeCacheManager.setCacheManagers(Arrays.asList(
                caffeineCacheManager,  // L1 - checked first
                redisCacheManager      // L2 - fallback
        ));
        compositeCacheManager.setFallbackToNoOpCache(false);

        log.info("Multi-layer cache configured: Caffeine (L1) + Redis (L2)");
        return compositeCacheManager;
    }

    /**
     * Caffeine cache manager (L1 - In-memory)
     * Short TTL for freshness, limited size to control memory
     */
    @Bean("caffeineCacheManager")
    public CacheManager caffeineCacheManager() {
        CaffeineCacheManager cacheManager = new CaffeineCacheManager();

        // Configure with per-cache settings
        cacheManager.setCaffeine(Caffeine.newBuilder()
                .maximumSize(10000)  // Max entries across all caches
                .recordStats()       // Enable stats for monitoring
        );

        // Register all cache names from TTL config
        String[] cacheNames = Arrays.stream(CacheTTLConfig.values())
                .map(CacheTTLConfig::getCacheName)
                .toArray(String[]::new);
        cacheManager.setCacheNames(Arrays.asList(cacheNames));

        log.info("Caffeine L1 cache configured with {} caches", cacheNames.length);
        return cacheManager;
    }

    /**
     * Redis cache manager (L2 - Distributed)
     * Longer TTL for performance, shared across instances
     */
    @Bean("redisCacheManager")
    public CacheManager redisCacheManager(RedisConnectionFactory connectionFactory) {
        // Default cache configuration
        RedisCacheConfiguration defaultConfig = RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofHours(1))  // Default 1 hour TTL
                .serializeValuesWith(RedisSerializationContext.SerializationPair
                        .fromSerializer(new GenericJackson2JsonRedisSerializer()))
                .disableCachingNullValues();

        // Per-cache TTL configurations
        Map<String, RedisCacheConfiguration> cacheConfigs = new HashMap<>();
        for (CacheTTLConfig config : CacheTTLConfig.values()) {
            cacheConfigs.put(
                    config.getCacheName(),
                    defaultConfig.entryTtl(config.getRedisTTL())
            );
        }

        RedisCacheManager cacheManager = RedisCacheManager.builder(connectionFactory)
                .cacheDefaults(defaultConfig)
                .withInitialCacheConfigurations(cacheConfigs)
                .enableStatistics()
                .build();

        log.info("Redis L2 cache configured with {} per-cache TTL settings", cacheConfigs.size());
        return cacheManager;
    }

    /**
     * Custom Caffeine cache builder with per-cache TTL
     * Used for fine-grained control over individual caches
     */
    @Bean
    public Map<String, Caffeine<Object, Object>> caffeineCacheBuilders() {
        Map<String, Caffeine<Object, Object>> builders = new HashMap<>();

        for (CacheTTLConfig config : CacheTTLConfig.values()) {
            builders.put(config.getCacheName(), Caffeine.newBuilder()
                    .expireAfterWrite(config.getCaffeineTTL())
                    .maximumSize(getMaxSizeForCache(config))
                    .recordStats()
            );
        }

        return builders;
    }

    /**
     * Get maximum cache size based on data type
     */
    private long getMaxSizeForCache(CacheTTLConfig config) {
        return switch (config) {
            case LIVE_STATS -> 100;       // Limited live game data
            case NEWS -> 500;             // News items
            case SCHEDULE -> 50;          // Weekly schedules
            case SCHEDULE_LIVE -> 50;     // Live schedules
            case PLAYER_PROFILE -> 5000;  // Many players
            case FINAL_STATS -> 200;      // Final game stats
            case PERMANENT -> 1000;       // Permanent data
            case SEARCH -> 1000;          // Search results
            case TEAM_ROSTER -> 100;      // Team rosters
            case PLAYOFF_TEAMS -> 20;     // Playoff teams (very limited)
            case INJURY_REPORT -> 200;    // Injury reports
        };
    }
}
