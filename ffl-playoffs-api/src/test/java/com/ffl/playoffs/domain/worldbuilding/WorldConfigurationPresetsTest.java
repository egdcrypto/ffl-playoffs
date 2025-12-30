package com.ffl.playoffs.domain.worldbuilding;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("WorldConfigurationPresets Tests")
class WorldConfigurationPresetsTest {

    @Test
    @DisplayName("Shakespearean Tragedy should have high tragedy and romance")
    void shakespeareanTragedy() {
        WorldConfiguration config = WorldConfigurationPresets.shakespeareanTragedy();

        assertEquals("Shakespearean Tragedy", config.getName());
        assertEquals(Era.RENAISSANCE, config.getBaseEra());
        assertTrue(config.getTragedyLevel() >= 0.8);
        assertTrue(config.getDimensions().getRomanceIntensity() >= 0.8);
        assertTrue(config.getHopeIndex() <= 0.3);
        assertTrue(config.isRomantic());
    }

    @Test
    @DisplayName("Fairy Tale should be optimistic with high magic")
    void fairyTale() {
        WorldConfiguration config = WorldConfigurationPresets.fairyTale();

        assertEquals("Fairy Tale", config.getName());
        assertEquals(Era.MEDIEVAL, config.getBaseEra());
        assertTrue(config.getHopeIndex() >= 0.8);
        assertTrue(config.getMagicalPresence() >= 0.7);
        assertTrue(config.getEraVector().isHighMagic());
    }

    @Test
    @DisplayName("Grimdark Fantasy should be dark with high violence")
    void grimdarkFantasy() {
        WorldConfiguration config = WorldConfigurationPresets.grimdarkFantasy();

        assertEquals("Grimdark Fantasy", config.getName());
        assertTrue(config.getDimensions().isGrimdark());
        assertTrue(config.getDimensions().getViolenceGraphicness() >= 0.8);
        assertTrue(config.isDarkFantasy());
    }

    @Test
    @DisplayName("High Fantasy should be magical and hopeful")
    void highFantasy() {
        WorldConfiguration config = WorldConfigurationPresets.highFantasy();

        assertEquals("High Fantasy", config.getName());
        assertEquals(Era.MEDIEVAL, config.getBaseEra());
        assertTrue(config.getMagicalPresence() >= 0.8);
        assertTrue(config.getHopeIndex() >= 0.7);
        assertTrue(config.isHighFantasy());
    }

    @Test
    @DisplayName("Historical Drama should be realistic with no magic")
    void historicalDrama() {
        WorldConfiguration config = WorldConfigurationPresets.historicalDrama();

        assertEquals("Historical Drama", config.getName());
        assertTrue(config.getDimensions().getVerisimilitude() >= 0.8);
        assertEquals(0.0, config.getMagicalPresence());
        assertTrue(config.isHistoricalDrama());
    }

    @Test
    @DisplayName("Space Opera should be futuristic with high technology")
    void spaceOpera() {
        WorldConfiguration config = WorldConfigurationPresets.spaceOpera();

        assertEquals("Space Opera", config.getName());
        assertEquals(Era.FUTURISTIC, config.getBaseEra());
        assertTrue(config.getEraVector().getTechnologyLevel() >= 0.8);
        assertEquals(0.0, config.getMagicalPresence());
        assertTrue(config.getEraVector().isSciFiSetting());
    }

    @Test
    @DisplayName("Gothic Horror should be dark and tragic")
    void gothicHorror() {
        WorldConfiguration config = WorldConfigurationPresets.gothicHorror();

        assertEquals("Gothic Horror", config.getName());
        assertEquals(Era.INDUSTRIAL, config.getBaseEra());
        assertTrue(config.getTragedyLevel() >= 0.7);
        assertTrue(config.getHopeIndex() <= 0.3);
    }

    @Test
    @DisplayName("Arthurian Legend should be chivalric medieval")
    void arthurianLegend() {
        WorldConfiguration config = WorldConfigurationPresets.arthurianLegend();

        assertEquals("Arthurian Legend", config.getName());
        assertEquals(Era.MEDIEVAL, config.getBaseEra());
        assertTrue(config.getDimensions().getRomanceIntensity() >= 0.6);
        assertTrue(config.getMagicalPresence() >= 0.4);
    }

    @Test
    @DisplayName("Greek Mythology should be ancient with gods and magic")
    void greekMythology() {
        WorldConfiguration config = WorldConfigurationPresets.greekMythology();

        assertEquals("Greek Mythology", config.getName());
        assertEquals(Era.ANCIENT, config.getBaseEra());
        assertTrue(config.getMagicalPresence() >= 0.7);
        assertTrue(config.getTragedyLevel() >= 0.6);
    }

    @Test
    @DisplayName("Dystopian Future should be oppressive and technological")
    void dystopianFuture() {
        WorldConfiguration config = WorldConfigurationPresets.dystopianFuture();

        assertEquals("Dystopian Future", config.getName());
        assertEquals(Era.FUTURISTIC, config.getBaseEra());
        assertTrue(config.getEraVector().getTechnologyLevel() >= 0.7);
        assertTrue(config.getHopeIndex() <= 0.4);
        assertEquals(0.0, config.getMagicalPresence());
    }

    @Test
    @DisplayName("All presets should have valid configurations")
    void allPresetsShouldBeValid() {
        WorldConfiguration[] presets = {
            WorldConfigurationPresets.shakespeareanTragedy(),
            WorldConfigurationPresets.fairyTale(),
            WorldConfigurationPresets.grimdarkFantasy(),
            WorldConfigurationPresets.highFantasy(),
            WorldConfigurationPresets.historicalDrama(),
            WorldConfigurationPresets.spaceOpera(),
            WorldConfigurationPresets.gothicHorror(),
            WorldConfigurationPresets.arthurianLegend(),
            WorldConfigurationPresets.greekMythology(),
            WorldConfigurationPresets.dystopianFuture()
        };

        for (WorldConfiguration preset : presets) {
            assertNotNull(preset.getId());
            assertNotNull(preset.getName());
            assertFalse(preset.getName().isEmpty());
            assertNotNull(preset.getDescription());
            assertNotNull(preset.getDimensions());
            assertNotNull(preset.getEraVector());
            assertNotNull(preset.getCreatedAt());

            // Validate all dimension values are in range
            DimensionalConfiguration dim = preset.getDimensions();
            assertTrue(dim.getTragedyLevel() >= 0.0 && dim.getTragedyLevel() <= 1.0);
            assertTrue(dim.getChaosFactor() >= 0.0 && dim.getChaosFactor() <= 1.0);
            assertTrue(dim.getRomanceIntensity() >= 0.0 && dim.getRomanceIntensity() <= 1.0);
            assertTrue(dim.getHopeIndex() >= 0.0 && dim.getHopeIndex() <= 1.0);
            assertTrue(dim.getVerisimilitude() >= 0.0 && dim.getVerisimilitude() <= 1.0);
            assertTrue(dim.getViolenceGraphicness() >= 0.0 && dim.getViolenceGraphicness() <= 1.0);

            // Validate all era vector values are in range
            EraVector era = preset.getEraVector();
            assertNotNull(era.getBaseEra());
            assertTrue(era.getTechnologyLevel() >= 0.0 && era.getTechnologyLevel() <= 1.0);
            assertTrue(era.getMagicalPresence() >= 0.0 && era.getMagicalPresence() <= 1.0);
            assertTrue(era.getCulturalComplexity() >= 0.0 && era.getCulturalComplexity() <= 1.0);
        }
    }
}
