package com.ffl.playoffs.domain.model;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("Score Domain Entity Tests")
class ScoreTest {

    @Nested
    @DisplayName("Construction")
    class Construction {

        @Test
        @DisplayName("should create score with default constructor")
        void shouldCreateScoreWithDefaultConstructor() {
            // When
            Score score = new Score();

            // Then
            assertThat(score.getId()).isNotNull();
            assertThat(score.getTotalPoints()).isEqualTo(0);
            assertThat(score.getOffensivePoints()).isEqualTo(0);
            assertThat(score.getDefensivePoints()).isEqualTo(0);
            assertThat(score.getFieldGoalPoints()).isEqualTo(0);
            assertThat(score.isWin()).isFalse();
        }

        @Test
        @DisplayName("should create score with team selection ID")
        void shouldCreateScoreWithTeamSelectionId() {
            // Given
            UUID teamSelectionId = UUID.randomUUID();

            // When
            Score score = new Score(teamSelectionId);

            // Then
            assertThat(score.getTeamSelectionId()).isEqualTo(teamSelectionId);
            assertThat(score.getTotalPoints()).isEqualTo(0);
        }
    }

    @Nested
    @DisplayName("Point Calculation")
    class PointCalculation {

        private Score score;

        @BeforeEach
        void setUp() {
            score = new Score();
        }

        @Test
        @DisplayName("should calculate total points correctly")
        void shouldCalculateTotalPointsCorrectly() {
            // Given
            score.setOffensivePoints(20);
            score.setDefensivePoints(10);
            score.setFieldGoalPoints(5);

            // When
            score.calculateTotalPoints();

            // Then
            assertThat(score.getTotalPoints()).isEqualTo(35);
        }

        @Test
        @DisplayName("should add offensive points and recalculate total")
        void shouldAddOffensivePointsAndRecalculateTotal() {
            // Given
            score.setOffensivePoints(10);

            // When
            score.addOffensivePoints(15);

            // Then
            assertThat(score.getOffensivePoints()).isEqualTo(25);
            assertThat(score.getTotalPoints()).isEqualTo(25);
        }

        @Test
        @DisplayName("should add defensive points and recalculate total")
        void shouldAddDefensivePointsAndRecalculateTotal() {
            // Given
            score.setDefensivePoints(5);

            // When
            score.addDefensivePoints(8);

            // Then
            assertThat(score.getDefensivePoints()).isEqualTo(13);
            assertThat(score.getTotalPoints()).isEqualTo(13);
        }

        @Test
        @DisplayName("should add field goal points and recalculate total")
        void shouldAddFieldGoalPointsAndRecalculateTotal() {
            // Given
            score.setFieldGoalPoints(3);

            // When
            score.addFieldGoalPoints(5);

            // Then
            assertThat(score.getFieldGoalPoints()).isEqualTo(8);
            assertThat(score.getTotalPoints()).isEqualTo(8);
        }

        @Test
        @DisplayName("should recalculate total when adding to multiple categories")
        void shouldRecalculateTotalWhenAddingToMultipleCategories() {
            // When
            score.addOffensivePoints(20);
            score.addDefensivePoints(10);
            score.addFieldGoalPoints(5);

            // Then
            assertThat(score.getTotalPoints()).isEqualTo(35);
        }

        @Test
        @DisplayName("should handle negative points correctly")
        void shouldHandleNegativePointsCorrectly() {
            // Given
            score.setOffensivePoints(10);

            // When
            score.addOffensivePoints(-5);

            // Then
            assertThat(score.getOffensivePoints()).isEqualTo(5);
            assertThat(score.getTotalPoints()).isEqualTo(5);
        }
    }

    @Nested
    @DisplayName("Win/Loss Tracking")
    class WinLossTracking {

        private Score score;

        @BeforeEach
        void setUp() {
            score = new Score();
        }

        @Test
        @DisplayName("should record win")
        void shouldRecordWin() {
            // When
            score.recordWin();

            // Then
            assertThat(score.isWin()).isTrue();
        }

        @Test
        @DisplayName("should record loss")
        void shouldRecordLoss() {
            // Given
            score.recordWin();
            assertThat(score.isWin()).isTrue();

            // When
            score.recordLoss();

            // Then
            assertThat(score.isWin()).isFalse();
        }

        @Test
        @DisplayName("should default to loss")
        void shouldDefaultToLoss() {
            // Then
            assertThat(score.isWin()).isFalse();
        }
    }

    @Nested
    @DisplayName("Opponent Tracking")
    class OpponentTracking {

        @Test
        @DisplayName("should set and get opponent team code")
        void shouldSetAndGetOpponentTeamCode() {
            // Given
            Score score = new Score();
            String opponentCode = "TEAM_B";

            // When
            score.setOpponentTeamCode(opponentCode);

            // Then
            assertThat(score.getOpponentTeamCode()).isEqualTo(opponentCode);
        }
    }

    @Nested
    @DisplayName("Getters and Setters")
    class GettersAndSetters {

        private Score score;

        @BeforeEach
        void setUp() {
            score = new Score();
        }

        @Test
        @DisplayName("should set and get offensive points")
        void shouldSetAndGetOffensivePoints() {
            // When
            score.setOffensivePoints(42);

            // Then
            assertThat(score.getOffensivePoints()).isEqualTo(42);
        }

        @Test
        @DisplayName("should set and get defensive points")
        void shouldSetAndGetDefensivePoints() {
            // When
            score.setDefensivePoints(15);

            // Then
            assertThat(score.getDefensivePoints()).isEqualTo(15);
        }

        @Test
        @DisplayName("should set and get field goal points")
        void shouldSetAndGetFieldGoalPoints() {
            // When
            score.setFieldGoalPoints(12);

            // Then
            assertThat(score.getFieldGoalPoints()).isEqualTo(12);
        }

        @Test
        @DisplayName("should set and get total points directly")
        void shouldSetAndGetTotalPointsDirectly() {
            // When
            score.setTotalPoints(100);

            // Then
            assertThat(score.getTotalPoints()).isEqualTo(100);
        }

        @Test
        @DisplayName("should set and get team selection ID")
        void shouldSetAndGetTeamSelectionId() {
            // Given
            UUID teamSelectionId = UUID.randomUUID();

            // When
            score.setTeamSelectionId(teamSelectionId);

            // Then
            assertThat(score.getTeamSelectionId()).isEqualTo(teamSelectionId);
        }
    }
}
