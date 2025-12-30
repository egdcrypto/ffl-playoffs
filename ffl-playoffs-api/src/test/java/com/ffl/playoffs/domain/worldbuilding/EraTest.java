package com.ffl.playoffs.domain.worldbuilding;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Era Enum Tests")
class EraTest {

    @Test
    @DisplayName("Should have correct display names")
    void shouldHaveCorrectDisplayNames() {
        assertEquals("Medieval", Era.MEDIEVAL.getDisplayName());
        assertEquals("Renaissance", Era.RENAISSANCE.getDisplayName());
        assertEquals("Futuristic", Era.FUTURISTIC.getDisplayName());
    }

    @Test
    @DisplayName("Should have descriptions")
    void shouldHaveDescriptions() {
        assertNotNull(Era.MEDIEVAL.getDescription());
        assertFalse(Era.MEDIEVAL.getDescription().isEmpty());
    }

    @Test
    @DisplayName("Should correctly compare eras chronologically")
    void shouldCorrectlyCompareErasChronologically() {
        assertTrue(Era.PREHISTORIC.isBefore(Era.ANCIENT));
        assertTrue(Era.MEDIEVAL.isBefore(Era.RENAISSANCE));
        assertTrue(Era.MODERN.isAfter(Era.INDUSTRIAL));
        assertTrue(Era.FUTURISTIC.isAfter(Era.MODERN));
    }

    @Test
    @DisplayName("Should identify historical eras")
    void shouldIdentifyHistoricalEras() {
        assertTrue(Era.PREHISTORIC.isHistorical());
        assertTrue(Era.ANCIENT.isHistorical());
        assertTrue(Era.MEDIEVAL.isHistorical());
        assertTrue(Era.RENAISSANCE.isHistorical());
        assertTrue(Era.INDUSTRIAL.isHistorical());
        assertFalse(Era.MODERN.isHistorical());
        assertFalse(Era.FUTURISTIC.isHistorical());
    }

    @Test
    @DisplayName("Should identify fantasy-friendly eras")
    void shouldIdentifyFantasyFriendlyEras() {
        assertTrue(Era.ANCIENT.isFantasyFriendly());
        assertTrue(Era.MEDIEVAL.isFantasyFriendly());
        assertTrue(Era.RENAISSANCE.isFantasyFriendly());
        assertFalse(Era.PREHISTORIC.isFantasyFriendly());
        assertFalse(Era.INDUSTRIAL.isFantasyFriendly());
        assertFalse(Era.MODERN.isFantasyFriendly());
        assertFalse(Era.FUTURISTIC.isFantasyFriendly());
    }

    @Test
    @DisplayName("Should have all expected eras")
    void shouldHaveAllExpectedEras() {
        Era[] eras = Era.values();
        assertEquals(7, eras.length);

        assertEquals(Era.PREHISTORIC, eras[0]);
        assertEquals(Era.ANCIENT, eras[1]);
        assertEquals(Era.MEDIEVAL, eras[2]);
        assertEquals(Era.RENAISSANCE, eras[3]);
        assertEquals(Era.INDUSTRIAL, eras[4]);
        assertEquals(Era.MODERN, eras[5]);
        assertEquals(Era.FUTURISTIC, eras[6]);
    }
}
