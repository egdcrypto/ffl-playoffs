package com.ffl.playoffs.domain.worldbuilding;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("DimensionalConfiguration Tests")
class DimensionalConfigurationTest {

    @Test
    @DisplayName("Should create configuration with valid values")
    void shouldCreateConfigurationWithValidValues() {
        DimensionalConfiguration config = DimensionalConfiguration.builder()
            .tragedyLevel(0.9)
            .chaosFactor(0.3)
            .romanceIntensity(0.9)
            .hopeIndex(0.2)
            .verisimilitude(0.6)
            .violenceGraphicness(0.5)
            .build();

        assertEquals(0.9, config.getTragedyLevel());
        assertEquals(0.3, config.getChaosFactor());
        assertEquals(0.9, config.getRomanceIntensity());
        assertEquals(0.2, config.getHopeIndex());
        assertEquals(0.6, config.getVerisimilitude());
        assertEquals(0.5, config.getViolenceGraphicness());
    }

    @Test
    @DisplayName("Should reject values below 0.0")
    void shouldRejectValuesBelowZero() {
        assertThrows(IllegalArgumentException.class, () ->
            DimensionalConfiguration.builder()
                .tragedyLevel(-0.1)
                .build()
        );
    }

    @Test
    @DisplayName("Should reject values above 1.0")
    void shouldRejectValuesAboveOne() {
        assertThrows(IllegalArgumentException.class, () ->
            DimensionalConfiguration.builder()
                .hopeIndex(1.1)
                .build()
        );
    }

    @Test
    @DisplayName("Should accept boundary values 0.0 and 1.0")
    void shouldAcceptBoundaryValues() {
        DimensionalConfiguration config = DimensionalConfiguration.builder()
            .tragedyLevel(0.0)
            .chaosFactor(1.0)
            .romanceIntensity(0.0)
            .hopeIndex(1.0)
            .verisimilitude(0.0)
            .violenceGraphicness(1.0)
            .build();

        assertEquals(0.0, config.getTragedyLevel());
        assertEquals(1.0, config.getChaosFactor());
    }

    @Test
    @DisplayName("Should detect grimdark configuration")
    void shouldDetectGrimdarkConfiguration() {
        DimensionalConfiguration grimdark = DimensionalConfiguration.builder()
            .tragedyLevel(0.9)
            .hopeIndex(0.1)
            .build();

        assertTrue(grimdark.isGrimdark());
        assertFalse(grimdark.isOptimistic());
    }

    @Test
    @DisplayName("Should detect optimistic configuration")
    void shouldDetectOptimisticConfiguration() {
        DimensionalConfiguration optimistic = DimensionalConfiguration.builder()
            .tragedyLevel(0.1)
            .hopeIndex(0.9)
            .build();

        assertTrue(optimistic.isOptimistic());
        assertFalse(optimistic.isGrimdark());
    }

    @Test
    @DisplayName("Should detect romance-focused configuration")
    void shouldDetectRomanceFocusedConfiguration() {
        DimensionalConfiguration romantic = DimensionalConfiguration.builder()
            .romanceIntensity(0.8)
            .build();

        assertTrue(romantic.isRomanceFocused());
    }

    @Test
    @DisplayName("Should create neutral configuration")
    void shouldCreateNeutralConfiguration() {
        DimensionalConfiguration neutral = DimensionalConfiguration.neutral();

        assertEquals(0.5, neutral.getTragedyLevel());
        assertEquals(0.5, neutral.getChaosFactor());
        assertEquals(0.5, neutral.getRomanceIntensity());
        assertEquals(0.5, neutral.getHopeIndex());
        assertEquals(0.5, neutral.getVerisimilitude());
        assertEquals(0.5, neutral.getViolenceGraphicness());
    }

    @Test
    @DisplayName("Should calculate narrative intensity")
    void shouldCalculateNarrativeIntensity() {
        DimensionalConfiguration config = DimensionalConfiguration.builder()
            .tragedyLevel(0.8)
            .chaosFactor(0.6)
            .romanceIntensity(0.4)
            .violenceGraphicness(0.6)
            .build();

        double expected = (0.8 + 0.6 + 0.4 + 0.6) / 4.0;
        assertEquals(expected, config.getNarrativeIntensity(), 0.001);
    }

    @Test
    @DisplayName("Should implement equals and hashCode correctly")
    void shouldImplementEqualsAndHashCode() {
        DimensionalConfiguration config1 = DimensionalConfiguration.builder()
            .tragedyLevel(0.5)
            .build();
        DimensionalConfiguration config2 = DimensionalConfiguration.builder()
            .tragedyLevel(0.5)
            .build();
        DimensionalConfiguration config3 = DimensionalConfiguration.builder()
            .tragedyLevel(0.6)
            .build();

        assertEquals(config1, config2);
        assertEquals(config1.hashCode(), config2.hashCode());
        assertNotEquals(config1, config3);
    }
}
