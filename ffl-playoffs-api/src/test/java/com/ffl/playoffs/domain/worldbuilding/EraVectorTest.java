package com.ffl.playoffs.domain.worldbuilding;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("EraVector Tests")
class EraVectorTest {

    @Test
    @DisplayName("Should create era vector with valid values")
    void shouldCreateEraVectorWithValidValues() {
        EraVector vector = EraVector.builder()
            .baseEra(Era.RENAISSANCE)
            .technologyLevel(0.2)
            .magicalPresence(0.1)
            .culturalComplexity(0.6)
            .build();

        assertEquals(Era.RENAISSANCE, vector.getBaseEra());
        assertEquals(0.2, vector.getTechnologyLevel());
        assertEquals(0.1, vector.getMagicalPresence());
        assertEquals(0.6, vector.getCulturalComplexity());
    }

    @Test
    @DisplayName("Should require base era")
    void shouldRequireBaseEra() {
        EraVector.Builder builder = EraVector.builder();
        builder.baseEra(null);

        assertThrows(NullPointerException.class, builder::build);
    }

    @Test
    @DisplayName("Should reject values out of range")
    void shouldRejectValuesOutOfRange() {
        assertThrows(IllegalArgumentException.class, () ->
            EraVector.builder()
                .baseEra(Era.MEDIEVAL)
                .technologyLevel(1.5)
                .build()
        );
    }

    @Test
    @DisplayName("Should detect high magic setting")
    void shouldDetectHighMagicSetting() {
        EraVector highMagic = EraVector.builder()
            .baseEra(Era.MEDIEVAL)
            .magicalPresence(0.9)
            .build();

        assertTrue(highMagic.isHighMagic());
        assertFalse(highMagic.isLowMagic());
    }

    @Test
    @DisplayName("Should detect low magic setting")
    void shouldDetectLowMagicSetting() {
        EraVector lowMagic = EraVector.builder()
            .baseEra(Era.MEDIEVAL)
            .magicalPresence(0.1)
            .build();

        assertTrue(lowMagic.isLowMagic());
        assertFalse(lowMagic.isHighMagic());
    }

    @Test
    @DisplayName("Should detect fantasy setting")
    void shouldDetectFantasySetting() {
        EraVector fantasy = EraVector.builder()
            .baseEra(Era.MEDIEVAL)
            .magicalPresence(0.5)
            .build();

        assertTrue(fantasy.isFantasySetting());
    }

    @Test
    @DisplayName("Should detect sci-fi setting")
    void shouldDetectSciFiSetting() {
        EraVector sciFi = EraVector.builder()
            .baseEra(Era.FUTURISTIC)
            .technologyLevel(0.9)
            .magicalPresence(0.0)
            .build();

        assertTrue(sciFi.isSciFiSetting());
        assertFalse(sciFi.isFantasySetting());
    }

    @Test
    @DisplayName("Should detect anachronistic technology")
    void shouldDetectAnachronisticTechnology() {
        EraVector anachronistic = EraVector.builder()
            .baseEra(Era.MEDIEVAL)
            .technologyLevel(0.8)
            .build();

        assertTrue(anachronistic.isAnachronistic());
    }

    @Test
    @DisplayName("Should not flag appropriate technology as anachronistic")
    void shouldNotFlagAppropriateTechnology() {
        EraVector appropriate = EraVector.builder()
            .baseEra(Era.MEDIEVAL)
            .technologyLevel(0.2)
            .build();

        assertFalse(appropriate.isAnachronistic());
    }

    @Test
    @DisplayName("Should create default medieval configuration")
    void shouldCreateDefaultMedieval() {
        EraVector medieval = EraVector.defaultMedieval();

        assertEquals(Era.MEDIEVAL, medieval.getBaseEra());
        assertEquals(0.2, medieval.getTechnologyLevel());
        assertEquals(0.5, medieval.getMagicalPresence());
        assertEquals(0.4, medieval.getCulturalComplexity());
    }

    @Test
    @DisplayName("Should calculate world complexity")
    void shouldCalculateWorldComplexity() {
        EraVector vector = EraVector.builder()
            .baseEra(Era.MEDIEVAL)
            .technologyLevel(0.3)
            .magicalPresence(0.6)
            .culturalComplexity(0.9)
            .build();

        double expected = (0.3 + 0.6 + 0.9) / 3.0;
        assertEquals(expected, vector.getWorldComplexity(), 0.001);
    }

    @Test
    @DisplayName("Should implement equals and hashCode correctly")
    void shouldImplementEqualsAndHashCode() {
        EraVector vector1 = EraVector.builder()
            .baseEra(Era.MEDIEVAL)
            .technologyLevel(0.3)
            .build();
        EraVector vector2 = EraVector.builder()
            .baseEra(Era.MEDIEVAL)
            .technologyLevel(0.3)
            .build();
        EraVector vector3 = EraVector.builder()
            .baseEra(Era.RENAISSANCE)
            .technologyLevel(0.3)
            .build();

        assertEquals(vector1, vector2);
        assertEquals(vector1.hashCode(), vector2.hashCode());
        assertNotEquals(vector1, vector3);
    }
}
