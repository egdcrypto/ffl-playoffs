package com.ffl.playoffs.domain.model;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.HashMap;
import java.util.Map;

import static org.assertj.core.api.Assertions.*;

@DisplayName("RosterConfiguration Value Object Tests")
class RosterConfigurationTest {

    @Nested
    @DisplayName("Construction")
    class Construction {

        @Test
        @DisplayName("should create empty configuration with default constructor")
        void shouldCreateEmptyConfigurationWithDefaultConstructor() {
            // When
            RosterConfiguration config = new RosterConfiguration();

            // Then
            assertThat(config.getTotalSlots()).isEqualTo(0);
            assertThat(config.getPositionSlots()).isEmpty();
        }

        @Test
        @DisplayName("should create standard roster configuration")
        void shouldCreateStandardRosterConfiguration() {
            // When
            RosterConfiguration config = RosterConfiguration.standardRoster();

            // Then
            assertThat(config.getPositionSlots(Position.QB)).isEqualTo(1);
            assertThat(config.getPositionSlots(Position.RB)).isEqualTo(2);
            assertThat(config.getPositionSlots(Position.WR)).isEqualTo(2);
            assertThat(config.getPositionSlots(Position.TE)).isEqualTo(1);
            assertThat(config.getPositionSlots(Position.FLEX)).isEqualTo(1);
            assertThat(config.getPositionSlots(Position.K)).isEqualTo(1);
            assertThat(config.getPositionSlots(Position.DEF)).isEqualTo(1);
            assertThat(config.getTotalSlots()).isEqualTo(9);
        }

        @Test
        @DisplayName("should create superflex roster configuration")
        void shouldCreateSuperflexRosterConfiguration() {
            // When
            RosterConfiguration config = RosterConfiguration.superflexRoster();

            // Then
            assertThat(config.getPositionSlots(Position.QB)).isEqualTo(1);
            assertThat(config.getPositionSlots(Position.RB)).isEqualTo(2);
            assertThat(config.getPositionSlots(Position.WR)).isEqualTo(2);
            assertThat(config.getPositionSlots(Position.TE)).isEqualTo(1);
            assertThat(config.getPositionSlots(Position.FLEX)).isEqualTo(1);
            assertThat(config.getPositionSlots(Position.SUPERFLEX)).isEqualTo(1);
            assertThat(config.getPositionSlots(Position.K)).isEqualTo(1);
            assertThat(config.getPositionSlots(Position.DEF)).isEqualTo(1);
            assertThat(config.getTotalSlots()).isEqualTo(10);
        }
    }

    @Nested
    @DisplayName("Position Slots Management")
    class PositionSlotsManagement {

        private RosterConfiguration config;

        @BeforeEach
        void setUp() {
            config = new RosterConfiguration();
        }

        @Test
        @DisplayName("should set position slots")
        void shouldSetPositionSlots() {
            // When
            config.setPositionSlots(Position.QB, 2);

            // Then
            assertThat(config.getPositionSlots(Position.QB)).isEqualTo(2);
            assertThat(config.getTotalSlots()).isEqualTo(2);
        }

        @Test
        @DisplayName("should update total slots when adding positions")
        void shouldUpdateTotalSlotsWhenAddingPositions() {
            // When
            config.setPositionSlots(Position.QB, 1);
            config.setPositionSlots(Position.RB, 2);
            config.setPositionSlots(Position.WR, 3);

            // Then
            assertThat(config.getTotalSlots()).isEqualTo(6);
        }

        @Test
        @DisplayName("should remove position when setting count to 0")
        void shouldRemovePositionWhenSettingCountToZero() {
            // Given
            config.setPositionSlots(Position.QB, 2);
            assertThat(config.hasPosition(Position.QB)).isTrue();

            // When
            config.setPositionSlots(Position.QB, 0);

            // Then
            assertThat(config.hasPosition(Position.QB)).isFalse();
            assertThat(config.getTotalSlots()).isEqualTo(0);
        }

        @Test
        @DisplayName("should throw exception for negative position count")
        void shouldThrowExceptionForNegativePositionCount() {
            // When/Then
            assertThatThrownBy(() -> config.setPositionSlots(Position.QB, -1))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("cannot be negative");
        }

        @Test
        @DisplayName("should return 0 for positions not configured")
        void shouldReturnZeroForPositionsNotConfigured() {
            // When
            int count = config.getPositionSlots(Position.QB);

            // Then
            assertThat(count).isEqualTo(0);
        }

        @Test
        @DisplayName("hasPosition should return true for configured positions")
        void hasPositionShouldReturnTrueForConfiguredPositions() {
            // Given
            config.setPositionSlots(Position.QB, 1);

            // Then
            assertThat(config.hasPosition(Position.QB)).isTrue();
        }

        @Test
        @DisplayName("hasPosition should return false for unconfigured positions")
        void hasPositionShouldReturnFalseForUnconfiguredPositions() {
            // Then
            assertThat(config.hasPosition(Position.QB)).isFalse();
        }

        @Test
        @DisplayName("should overwrite existing position count")
        void shouldOverwriteExistingPositionCount() {
            // Given
            config.setPositionSlots(Position.QB, 1);

            // When
            config.setPositionSlots(Position.QB, 3);

            // Then
            assertThat(config.getPositionSlots(Position.QB)).isEqualTo(3);
            assertThat(config.getTotalSlots()).isEqualTo(3);
        }
    }

    @Nested
    @DisplayName("Validation")
    class Validation {

        @Test
        @DisplayName("should validate roster with at least 1 position")
        void shouldValidateRosterWithAtLeastOnePosition() {
            // Given
            RosterConfiguration config = new RosterConfiguration();
            config.setPositionSlots(Position.QB, 1);

            // When/Then
            assertThatCode(() -> config.validate())
                .doesNotThrowAnyException();
        }

        @Test
        @DisplayName("should reject empty roster")
        void shouldRejectEmptyRoster() {
            // Given
            RosterConfiguration config = new RosterConfiguration();

            // When/Then
            assertThatThrownBy(() -> config.validate())
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("at least one position slot");
        }

        @Test
        @DisplayName("should reject roster with more than 20 total slots")
        void shouldRejectRosterWithMoreThan20TotalSlots() {
            // Given
            RosterConfiguration config = new RosterConfiguration();
            config.setPositionSlots(Position.QB, 21);

            // When/Then
            assertThatThrownBy(() -> config.validate())
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("cannot exceed 20 total slots");
        }

        @Test
        @DisplayName("should accept roster with exactly 20 slots")
        void shouldAcceptRosterWithExactly20Slots() {
            // Given
            RosterConfiguration config = new RosterConfiguration();
            config.setPositionSlots(Position.QB, 5);
            config.setPositionSlots(Position.RB, 5);
            config.setPositionSlots(Position.WR, 5);
            config.setPositionSlots(Position.TE, 5);

            // When/Then
            assertThatCode(() -> config.validate())
                .doesNotThrowAnyException();
        }

        @Test
        @DisplayName("should require at least 1 QB or SUPERFLEX")
        void shouldRequireAtLeastOneQBOrSuperflex() {
            // Given - roster with no QB or SUPERFLEX
            RosterConfiguration config = new RosterConfiguration();
            config.setPositionSlots(Position.RB, 2);
            config.setPositionSlots(Position.WR, 2);

            // When/Then
            assertThatThrownBy(() -> config.validate())
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("at least 1 QB or 1 SUPERFLEX");
        }

        @Test
        @DisplayName("should accept roster with QB but no SUPERFLEX")
        void shouldAcceptRosterWithQBButNoSuperflex() {
            // Given
            RosterConfiguration config = new RosterConfiguration();
            config.setPositionSlots(Position.QB, 1);

            // When/Then
            assertThatCode(() -> config.validate())
                .doesNotThrowAnyException();
        }

        @Test
        @DisplayName("should accept roster with SUPERFLEX but no QB")
        void shouldAcceptRosterWithSuperflexButNoQB() {
            // Given
            RosterConfiguration config = new RosterConfiguration();
            config.setPositionSlots(Position.SUPERFLEX, 1);

            // When/Then
            assertThatCode(() -> config.validate())
                .doesNotThrowAnyException();
        }
    }

    @Nested
    @DisplayName("Total Slots Calculation")
    class TotalSlotsCalculation {

        @Test
        @DisplayName("should calculate total slots correctly")
        void shouldCalculateTotalSlotsCorrectly() {
            // Given
            RosterConfiguration config = new RosterConfiguration();
            config.setPositionSlots(Position.QB, 1);
            config.setPositionSlots(Position.RB, 2);
            config.setPositionSlots(Position.WR, 3);

            // When
            config.calculateTotalSlots();

            // Then
            assertThat(config.getTotalSlots()).isEqualTo(6);
        }

        @Test
        @DisplayName("should recalculate when position is removed")
        void shouldRecalculateWhenPositionIsRemoved() {
            // Given
            RosterConfiguration config = new RosterConfiguration();
            config.setPositionSlots(Position.QB, 1);
            config.setPositionSlots(Position.RB, 2);
            assertThat(config.getTotalSlots()).isEqualTo(3);

            // When
            config.setPositionSlots(Position.QB, 0);

            // Then
            assertThat(config.getTotalSlots()).isEqualTo(2);
        }
    }

    @Nested
    @DisplayName("Defensive Copy")
    class DefensiveCopy {

        @Test
        @DisplayName("getPositionSlots should return defensive copy")
        void getPositionSlotsShouldReturnDefensiveCopy() {
            // Given
            RosterConfiguration config = new RosterConfiguration();
            config.setPositionSlots(Position.QB, 1);

            // When
            Map<Position, Integer> slots = config.getPositionSlots();
            slots.put(Position.RB, 999); // Try to modify returned map

            // Then
            assertThat(config.getPositionSlots(Position.RB)).isEqualTo(0);
            assertThat(config.getTotalSlots()).isEqualTo(1);
        }

        @Test
        @DisplayName("setPositionSlotsMap should create defensive copy")
        void setPositionSlotsMapShouldCreateDefensiveCopy() {
            // Given
            RosterConfiguration config = new RosterConfiguration();
            Map<Position, Integer> slots = new HashMap<>();
            slots.put(Position.QB, 1);
            slots.put(Position.RB, 2);

            // When
            config.setPositionSlotsMap(slots);
            slots.put(Position.WR, 999); // Try to modify original map

            // Then
            assertThat(config.getPositionSlots(Position.WR)).isEqualTo(0);
            assertThat(config.getTotalSlots()).isEqualTo(3);
        }

        @Test
        @DisplayName("setPositionSlotsMap should recalculate total")
        void setPositionSlotsMapShouldRecalculateTotal() {
            // Given
            RosterConfiguration config = new RosterConfiguration();
            Map<Position, Integer> slots = new HashMap<>();
            slots.put(Position.QB, 1);
            slots.put(Position.RB, 2);
            slots.put(Position.WR, 3);

            // When
            config.setPositionSlotsMap(slots);

            // Then
            assertThat(config.getTotalSlots()).isEqualTo(6);
        }
    }

    @Nested
    @DisplayName("toString Method")
    class ToStringMethod {

        @Test
        @DisplayName("should generate readable string representation")
        void shouldGenerateReadableStringRepresentation() {
            // Given
            RosterConfiguration config = RosterConfiguration.standardRoster();

            // When
            String str = config.toString();

            // Then
            assertThat(str)
                .contains("Roster Configuration")
                .contains("Total");
        }
    }
}
