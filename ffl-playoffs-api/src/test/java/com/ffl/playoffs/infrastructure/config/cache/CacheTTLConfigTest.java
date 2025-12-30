package com.ffl.playoffs.infrastructure.config.cache;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.EnumSource;

import java.time.Duration;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for CacheTTLConfig
 */
class CacheTTLConfigTest {

    @Test
    void shouldBuildSinglePartKey() {
        // Given
        CacheTTLConfig config = CacheTTLConfig.PLAYOFF_TEAMS;

        // When
        String key = config.buildKeySingle("2024");

        // Then
        assertEquals("playoff_teams:2024", key);
    }

    @Test
    void shouldBuildMultiplePartKey() {
        // Given
        CacheTTLConfig config = CacheTTLConfig.PLAYER_PROFILE;

        // When
        String key = config.buildKeyMultiple("KC", "18", "2024");

        // Then
        assertEquals("player:KC:18:2024", key);
    }

    @Test
    void shouldBuildKeyWithEnvironment() {
        // Given
        CacheTTLConfig config = CacheTTLConfig.SCHEDULE;

        // When
        String key = config.buildKeyWithEnv("prod", "18", "2024");

        // Then
        assertEquals("prod:schedule:18:2024", key);
    }

    @Test
    void shouldBuildKeyFromArray() {
        // Given
        CacheTTLConfig config = CacheTTLConfig.SCHEDULE;
        String[] parts = {"18", "2024"};

        // When
        String key = config.buildKey(parts);

        // Then
        assertEquals("schedule:18:2024", key);
    }

    @Test
    void shouldFindConfigByCacheName() {
        // When
        CacheTTLConfig config = CacheTTLConfig.fromCacheName("live_stats");

        // Then
        assertEquals(CacheTTLConfig.LIVE_STATS, config);
    }

    @Test
    void shouldReturnDefaultConfigForUnknownCacheName() {
        // When
        CacheTTLConfig config = CacheTTLConfig.fromCacheName("unknown");

        // Then
        assertEquals(CacheTTLConfig.PLAYER_PROFILE, config);
    }

    @Test
    void shouldHaveLiveStatsWith30SecondTTL() {
        // Given
        CacheTTLConfig config = CacheTTLConfig.LIVE_STATS;

        // Then
        assertEquals(30, config.getRedisTTLSeconds());
        assertEquals(Duration.ofSeconds(30), config.getRedisTTL());
    }

    @Test
    void shouldHavePlayerProfileWith24HourTTL() {
        // Given
        CacheTTLConfig config = CacheTTLConfig.PLAYER_PROFILE;

        // Then
        assertEquals(Duration.ofHours(24), config.getRedisTTL());
        assertEquals(86400, config.getRedisTTLSeconds());
    }

    @Test
    void shouldHaveCaffeineTTLShorterThanRedisTTL() {
        // For each config, Caffeine (L1) TTL should be <= Redis (L2) TTL
        for (CacheTTLConfig config : CacheTTLConfig.values()) {
            assertTrue(config.getCaffeineTTL().compareTo(config.getRedisTTL()) <= 0,
                    config.name() + " Caffeine TTL should be <= Redis TTL");
        }
    }

    @ParameterizedTest
    @EnumSource(CacheTTLConfig.class)
    void shouldHaveNonEmptyCacheName(CacheTTLConfig config) {
        // Then
        assertNotNull(config.getCacheName());
        assertFalse(config.getCacheName().isEmpty());
    }

    @ParameterizedTest
    @EnumSource(CacheTTLConfig.class)
    void shouldHavePositiveTTLValues(CacheTTLConfig config) {
        // Then
        assertTrue(config.getRedisTTL().toSeconds() > 0);
        assertTrue(config.getCaffeineTTL().toSeconds() > 0);
    }

    @Test
    void shouldHaveScheduleLiveShorterThanRegularSchedule() {
        // Given
        CacheTTLConfig regular = CacheTTLConfig.SCHEDULE;
        CacheTTLConfig live = CacheTTLConfig.SCHEDULE_LIVE;

        // Then
        assertTrue(live.getRedisTTL().compareTo(regular.getRedisTTL()) < 0,
                "Schedule live TTL should be shorter than regular schedule TTL");
    }

    @Test
    void shouldHaveFinalStatsWithLongerTTLForStatCorrections() {
        // Given
        CacheTTLConfig finalStats = CacheTTLConfig.FINAL_STATS;

        // Then - 48 hours for stat correction window
        assertEquals(Duration.ofHours(48), finalStats.getRedisTTL());
    }
}
