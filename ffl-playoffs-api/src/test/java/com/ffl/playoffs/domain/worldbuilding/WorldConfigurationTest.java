package com.ffl.playoffs.domain.worldbuilding;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("WorldConfiguration Tests")
class WorldConfigurationTest {

    @Test
    @DisplayName("Should create world configuration with all required fields")
    void shouldCreateWorldConfigurationWithRequiredFields() {
        DimensionalConfiguration dimensions = DimensionalConfiguration.builder()
            .tragedyLevel(0.9)
            .romanceIntensity(0.9)
            .hopeIndex(0.2)
            .build();

        EraVector eraVector = EraVector.builder()
            .baseEra(Era.RENAISSANCE)
            .technologyLevel(0.2)
            .magicalPresence(0.1)
            .build();

        WorldConfiguration config = WorldConfiguration.builder()
            .name("Romeo and Juliet")
            .description("Star-crossed lovers in Verona")
            .dimensions(dimensions)
            .eraVector(eraVector)
            .build();

        assertNotNull(config.getId());
        assertEquals("Romeo and Juliet", config.getName());
        assertEquals("Star-crossed lovers in Verona", config.getDescription());
        assertEquals(dimensions, config.getDimensions());
        assertEquals(eraVector, config.getEraVector());
        assertNotNull(config.getCreatedAt());
    }

    @Test
    @DisplayName("Should require name")
    void shouldRequireName() {
        DimensionalConfiguration dimensions = DimensionalConfiguration.neutral();
        EraVector eraVector = EraVector.defaultMedieval();

        assertThrows(NullPointerException.class, () ->
            WorldConfiguration.builder()
                .dimensions(dimensions)
                .eraVector(eraVector)
                .build()
        );
    }

    @Test
    @DisplayName("Should require dimensions")
    void shouldRequireDimensions() {
        EraVector eraVector = EraVector.defaultMedieval();

        assertThrows(NullPointerException.class, () ->
            WorldConfiguration.builder()
                .name("Test")
                .eraVector(eraVector)
                .build()
        );
    }

    @Test
    @DisplayName("Should require era vector")
    void shouldRequireEraVector() {
        DimensionalConfiguration dimensions = DimensionalConfiguration.neutral();

        assertThrows(NullPointerException.class, () ->
            WorldConfiguration.builder()
                .name("Test")
                .dimensions(dimensions)
                .build()
        );
    }

    @Test
    @DisplayName("Should detect dark fantasy setting")
    void shouldDetectDarkFantasySetting() {
        DimensionalConfiguration grimdark = DimensionalConfiguration.builder()
            .tragedyLevel(0.9)
            .hopeIndex(0.1)
            .build();

        EraVector fantasy = EraVector.builder()
            .baseEra(Era.MEDIEVAL)
            .magicalPresence(0.5)
            .build();

        WorldConfiguration config = WorldConfiguration.builder()
            .name("Dark Fantasy World")
            .dimensions(grimdark)
            .eraVector(fantasy)
            .build();

        assertTrue(config.isDarkFantasy());
    }

    @Test
    @DisplayName("Should detect high fantasy setting")
    void shouldDetectHighFantasySetting() {
        DimensionalConfiguration optimistic = DimensionalConfiguration.builder()
            .tragedyLevel(0.2)
            .hopeIndex(0.9)
            .build();

        EraVector highMagic = EraVector.builder()
            .baseEra(Era.MEDIEVAL)
            .magicalPresence(0.9)
            .build();

        WorldConfiguration config = WorldConfiguration.builder()
            .name("High Fantasy World")
            .dimensions(optimistic)
            .eraVector(highMagic)
            .build();

        assertTrue(config.isHighFantasy());
    }

    @Test
    @DisplayName("Should detect romantic setting")
    void shouldDetectRomanticSetting() {
        DimensionalConfiguration romantic = DimensionalConfiguration.builder()
            .romanceIntensity(0.9)
            .build();

        EraVector era = EraVector.defaultMedieval();

        WorldConfiguration config = WorldConfiguration.builder()
            .name("Romance World")
            .dimensions(romantic)
            .eraVector(era)
            .build();

        assertTrue(config.isRomantic());
    }

    @Test
    @DisplayName("Should detect historical drama setting")
    void shouldDetectHistoricalDramaSetting() {
        DimensionalConfiguration realistic = DimensionalConfiguration.builder()
            .verisimilitude(0.9)
            .build();

        EraVector historical = EraVector.builder()
            .baseEra(Era.RENAISSANCE)
            .magicalPresence(0.0)
            .build();

        WorldConfiguration config = WorldConfiguration.builder()
            .name("Historical Drama")
            .dimensions(realistic)
            .eraVector(historical)
            .build();

        assertTrue(config.isHistoricalDrama());
    }

    @Test
    @DisplayName("Should provide convenience methods for common properties")
    void shouldProvideConvenienceMethods() {
        DimensionalConfiguration dimensions = DimensionalConfiguration.builder()
            .tragedyLevel(0.8)
            .hopeIndex(0.3)
            .build();

        EraVector eraVector = EraVector.builder()
            .baseEra(Era.MEDIEVAL)
            .magicalPresence(0.7)
            .build();

        WorldConfiguration config = WorldConfiguration.builder()
            .name("Test")
            .dimensions(dimensions)
            .eraVector(eraVector)
            .build();

        assertEquals(Era.MEDIEVAL, config.getBaseEra());
        assertEquals(0.8, config.getTragedyLevel());
        assertEquals(0.3, config.getHopeIndex());
        assertEquals(0.7, config.getMagicalPresence());
    }

    @Test
    @DisplayName("Should create copy with updated dimensions")
    void shouldCreateCopyWithUpdatedDimensions() {
        WorldConfiguration original = WorldConfiguration.builder()
            .name("Original")
            .dimensions(DimensionalConfiguration.neutral())
            .eraVector(EraVector.defaultMedieval())
            .build();

        DimensionalConfiguration newDimensions = DimensionalConfiguration.builder()
            .tragedyLevel(0.9)
            .build();

        WorldConfiguration updated = original.withDimensions(newDimensions);

        assertEquals(original.getId(), updated.getId());
        assertEquals(original.getName(), updated.getName());
        assertEquals(newDimensions, updated.getDimensions());
        assertEquals(original.getEraVector(), updated.getEraVector());
    }

    @Test
    @DisplayName("Should create copy with updated era vector")
    void shouldCreateCopyWithUpdatedEraVector() {
        WorldConfiguration original = WorldConfiguration.builder()
            .name("Original")
            .dimensions(DimensionalConfiguration.neutral())
            .eraVector(EraVector.defaultMedieval())
            .build();

        EraVector newEra = EraVector.builder()
            .baseEra(Era.FUTURISTIC)
            .technologyLevel(0.9)
            .build();

        WorldConfiguration updated = original.withEraVector(newEra);

        assertEquals(original.getId(), updated.getId());
        assertEquals(original.getName(), updated.getName());
        assertEquals(original.getDimensions(), updated.getDimensions());
        assertEquals(newEra, updated.getEraVector());
    }

    @Test
    @DisplayName("Should calculate narrative complexity")
    void shouldCalculateNarrativeComplexity() {
        DimensionalConfiguration dimensions = DimensionalConfiguration.builder()
            .tragedyLevel(0.8)
            .chaosFactor(0.6)
            .romanceIntensity(0.4)
            .violenceGraphicness(0.6)
            .build();

        EraVector eraVector = EraVector.builder()
            .baseEra(Era.MEDIEVAL)
            .technologyLevel(0.3)
            .magicalPresence(0.6)
            .culturalComplexity(0.9)
            .build();

        WorldConfiguration config = WorldConfiguration.builder()
            .name("Test")
            .dimensions(dimensions)
            .eraVector(eraVector)
            .build();

        double expectedDimensionIntensity = (0.8 + 0.6 + 0.4 + 0.6) / 4.0;
        double expectedWorldComplexity = (0.3 + 0.6 + 0.9) / 3.0;
        double expectedNarrativeComplexity = (expectedDimensionIntensity + expectedWorldComplexity) / 2.0;

        assertEquals(expectedNarrativeComplexity, config.getNarrativeComplexity(), 0.001);
    }

    @Test
    @DisplayName("Should use ID for equals and hashCode")
    void shouldUseIdForEqualsAndHashCode() {
        UUID id = UUID.randomUUID();

        WorldConfiguration config1 = WorldConfiguration.builder()
            .id(id)
            .name("Config 1")
            .dimensions(DimensionalConfiguration.neutral())
            .eraVector(EraVector.defaultMedieval())
            .build();

        WorldConfiguration config2 = WorldConfiguration.builder()
            .id(id)
            .name("Config 2")
            .dimensions(DimensionalConfiguration.builder().tragedyLevel(0.9).build())
            .eraVector(EraVector.builder().baseEra(Era.FUTURISTIC).build())
            .build();

        WorldConfiguration config3 = WorldConfiguration.builder()
            .name("Config 1")
            .dimensions(DimensionalConfiguration.neutral())
            .eraVector(EraVector.defaultMedieval())
            .build();

        assertEquals(config1, config2);
        assertEquals(config1.hashCode(), config2.hashCode());
        assertNotEquals(config1, config3);
    }
}
