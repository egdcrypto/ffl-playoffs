package com.ffl.playoffs.domain.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("ScoringRules Domain Entity Tests")
class ScoringRulesTest {

    @Nested
    @DisplayName("Construction and Defaults")
    class ConstructionAndDefaults {

        @Test
        @DisplayName("should create scoring rules with default constructor")
        void shouldCreateScoringRulesWithDefaultConstructor() {
            // When
            ScoringRules rules = new ScoringRules();

            // Then
            assertThat(rules.getId()).isNotNull();
        }

        @Test
        @DisplayName("should create scoring rules with game ID")
        void shouldCreateScoringRulesWithGameId() {
            // Given
            UUID gameId = UUID.randomUUID();

            // When
            ScoringRules rules = new ScoringRules(gameId);

            // Then
            assertThat(rules.getGameId()).isEqualTo(gameId);
        }

        @Test
        @DisplayName("should set default offensive scoring")
        void shouldSetDefaultOffensiveScoring() {
            // When
            ScoringRules rules = new ScoringRules();

            // Then
            assertThat(rules.getPassingTouchdownPoints()).isEqualTo(4.0);
            assertThat(rules.getRushingTouchdownPoints()).isEqualTo(6.0);
            assertThat(rules.getReceivingTouchdownPoints()).isEqualTo(6.0);
            assertThat(rules.getPassingYardsPerPoint()).isEqualTo(25.0);
            assertThat(rules.getRushingYardsPerPoint()).isEqualTo(10.0);
            assertThat(rules.getReceivingYardsPerPoint()).isEqualTo(10.0);
        }

        @Test
        @DisplayName("should set default PPR scoring")
        void shouldSetDefaultPPRScoring() {
            // When
            ScoringRules rules = new ScoringRules();

            // Then
            assertThat(rules.getReceptionPoints()).isEqualTo(1.0);
            assertThat(rules.getTwoPointConversionPoints()).isEqualTo(2.0);
        }

        @Test
        @DisplayName("should set default negative scoring")
        void shouldSetDefaultNegativeScoring() {
            // When
            ScoringRules rules = new ScoringRules();

            // Then
            assertThat(rules.getInterceptionThrownPoints()).isEqualTo(-2.0);
            assertThat(rules.getFumbleLostPoints()).isEqualTo(-2.0);
        }

        @Test
        @DisplayName("should set default field goal scoring")
        void shouldSetDefaultFieldGoalScoring() {
            // When
            ScoringRules rules = new ScoringRules();

            // Then
            assertThat(rules.getFieldGoalUnder40Points()).isEqualTo(3.0);
            assertThat(rules.getFieldGoal40To49Points()).isEqualTo(4.0);
            assertThat(rules.getFieldGoal50PlusPoints()).isEqualTo(5.0);
            assertThat(rules.getExtraPointPoints()).isEqualTo(1.0);
        }

        @Test
        @DisplayName("should set default defensive scoring")
        void shouldSetDefaultDefensiveScoring() {
            // When
            ScoringRules rules = new ScoringRules();

            // Then
            assertThat(rules.getSackPoints()).isEqualTo(1.0);
            assertThat(rules.getInterceptionPoints()).isEqualTo(2.0);
            assertThat(rules.getFumbleRecoveryPoints()).isEqualTo(2.0);
            assertThat(rules.getSafetyPoints()).isEqualTo(2.0);
            assertThat(rules.getDefensiveTouchdownPoints()).isEqualTo(6.0);
        }

        @Test
        @DisplayName("should set default points allowed tiers")
        void shouldSetDefaultPointsAllowedTiers() {
            // When
            ScoringRules rules = new ScoringRules();

            // Then
            assertThat(rules.getPointsAllowed0Points()).isEqualTo(10.0);
            assertThat(rules.getPointsAllowed1To6Points()).isEqualTo(7.0);
            assertThat(rules.getPointsAllowed7To13Points()).isEqualTo(4.0);
            assertThat(rules.getPointsAllowed14To20Points()).isEqualTo(1.0);
            assertThat(rules.getPointsAllowed21To27Points()).isEqualTo(0.0);
            assertThat(rules.getPointsAllowed28PlusPoints()).isEqualTo(-1.0);
        }

        @Test
        @DisplayName("should set default yards allowed tiers")
        void shouldSetDefaultYardsAllowedTiers() {
            // When
            ScoringRules rules = new ScoringRules();

            // Then
            assertThat(rules.getYardsAllowedUnder100Points()).isEqualTo(5.0);
            assertThat(rules.getYardsAllowed100To199Points()).isEqualTo(3.0);
            assertThat(rules.getYardsAllowed200To299Points()).isEqualTo(2.0);
            assertThat(rules.getYardsAllowed300To349Points()).isEqualTo(0.0);
            assertThat(rules.getYardsAllowed350To399Points()).isEqualTo(-1.0);
            assertThat(rules.getYardsAllowed400To449Points()).isEqualTo(-3.0);
            assertThat(rules.getYardsAllowed450To499Points()).isEqualTo(-5.0);
            assertThat(rules.getYardsAllowed500To549Points()).isEqualTo(-6.0);
            assertThat(rules.getYardsAllowed550PlusPoints()).isEqualTo(-7.0);
        }
    }

    @Nested
    @DisplayName("Custom Scoring Configuration")
    class CustomScoringConfiguration {

        @Test
        @DisplayName("should allow custom passing touchdown points")
        void shouldAllowCustomPassingTouchdownPoints() {
            // Given
            ScoringRules rules = new ScoringRules();

            // When
            rules.setPassingTouchdownPoints(6.0);

            // Then
            assertThat(rules.getPassingTouchdownPoints()).isEqualTo(6.0);
        }

        @Test
        @DisplayName("should allow Half-PPR configuration")
        void shouldAllowHalfPPRConfiguration() {
            // Given
            ScoringRules rules = new ScoringRules();

            // When
            rules.setReceptionPoints(0.5);

            // Then
            assertThat(rules.getReceptionPoints()).isEqualTo(0.5);
        }

        @Test
        @DisplayName("should allow Zero-PPR configuration")
        void shouldAllowZeroPPRConfiguration() {
            // Given
            ScoringRules rules = new ScoringRules();

            // When
            rules.setReceptionPoints(0.0);

            // Then
            assertThat(rules.getReceptionPoints()).isEqualTo(0.0);
        }

        @Test
        @DisplayName("should allow custom field goal scoring")
        void shouldAllowCustomFieldGoalScoring() {
            // Given
            ScoringRules rules = new ScoringRules();

            // When
            rules.setFieldGoalUnder40Points(2.5);
            rules.setFieldGoal40To49Points(3.5);
            rules.setFieldGoal50PlusPoints(6.0);

            // Then
            assertThat(rules.getFieldGoalUnder40Points()).isEqualTo(2.5);
            assertThat(rules.getFieldGoal40To49Points()).isEqualTo(3.5);
            assertThat(rules.getFieldGoal50PlusPoints()).isEqualTo(6.0);
        }

        @Test
        @DisplayName("should allow custom defensive scoring")
        void shouldAllowCustomDefensiveScoring() {
            // Given
            ScoringRules rules = new ScoringRules();

            // When
            rules.setSackPoints(1.5);
            rules.setInterceptionPoints(3.0);
            rules.setDefensiveTouchdownPoints(7.0);

            // Then
            assertThat(rules.getSackPoints()).isEqualTo(1.5);
            assertThat(rules.getInterceptionPoints()).isEqualTo(3.0);
            assertThat(rules.getDefensiveTouchdownPoints()).isEqualTo(7.0);
        }

        @Test
        @DisplayName("should allow custom yards per point ratios")
        void shouldAllowCustomYardsPerPointRatios() {
            // Given
            ScoringRules rules = new ScoringRules();

            // When
            rules.setPassingYardsPerPoint(20.0);
            rules.setRushingYardsPerPoint(8.0);
            rules.setReceivingYardsPerPoint(8.0);

            // Then
            assertThat(rules.getPassingYardsPerPoint()).isEqualTo(20.0);
            assertThat(rules.getRushingYardsPerPoint()).isEqualTo(8.0);
            assertThat(rules.getReceivingYardsPerPoint()).isEqualTo(8.0);
        }

        @Test
        @DisplayName("should allow custom points allowed tiers")
        void shouldAllowCustomPointsAllowedTiers() {
            // Given
            ScoringRules rules = new ScoringRules();

            // When
            rules.setPointsAllowed0Points(15.0);
            rules.setPointsAllowed28PlusPoints(-5.0);

            // Then
            assertThat(rules.getPointsAllowed0Points()).isEqualTo(15.0);
            assertThat(rules.getPointsAllowed28PlusPoints()).isEqualTo(-5.0);
        }

        @Test
        @DisplayName("should allow custom yards allowed tiers")
        void shouldAllowCustomYardsAllowedTiers() {
            // Given
            ScoringRules rules = new ScoringRules();

            // When
            rules.setYardsAllowedUnder100Points(10.0);
            rules.setYardsAllowed550PlusPoints(-10.0);

            // Then
            assertThat(rules.getYardsAllowedUnder100Points()).isEqualTo(10.0);
            assertThat(rules.getYardsAllowed550PlusPoints()).isEqualTo(-10.0);
        }
    }

    @Nested
    @DisplayName("Getters and Setters")
    class GettersAndSetters {

        @Test
        @DisplayName("should get and set game ID")
        void shouldGetAndSetGameId() {
            // Given
            ScoringRules rules = new ScoringRules();
            UUID gameId = UUID.randomUUID();

            // When
            rules.setGameId(gameId);

            // Then
            assertThat(rules.getGameId()).isEqualTo(gameId);
        }

        @Test
        @DisplayName("should get and set ID")
        void shouldGetAndSetId() {
            // Given
            ScoringRules rules = new ScoringRules();
            UUID id = UUID.randomUUID();

            // When
            rules.setId(id);

            // Then
            assertThat(rules.getId()).isEqualTo(id);
        }
    }
}
