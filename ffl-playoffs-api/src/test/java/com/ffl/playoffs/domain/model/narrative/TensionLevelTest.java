package com.ffl.playoffs.domain.model.narrative;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("TensionLevel Enum Tests")
class TensionLevelTest {

    @Test
    @DisplayName("should have exactly five levels")
    void shouldHaveExactlyFiveLevels() {
        assertThat(TensionLevel.values()).hasSize(5);
    }

    @Test
    @DisplayName("should have correct codes")
    void shouldHaveCorrectCodes() {
        assertThat(TensionLevel.MINIMAL.getCode()).isEqualTo("minimal");
        assertThat(TensionLevel.LOW.getCode()).isEqualTo("low");
        assertThat(TensionLevel.MODERATE.getCode()).isEqualTo("moderate");
        assertThat(TensionLevel.HIGH.getCode()).isEqualTo("high");
        assertThat(TensionLevel.CRITICAL.getCode()).isEqualTo("critical");
    }

    @Nested
    @DisplayName("fromScore tests")
    class FromScoreTests {

        @Test
        @DisplayName("should resolve MINIMAL for scores 0-19")
        void shouldResolveMinimalForScores0To19() {
            assertThat(TensionLevel.fromScore(0)).isEqualTo(TensionLevel.MINIMAL);
            assertThat(TensionLevel.fromScore(10)).isEqualTo(TensionLevel.MINIMAL);
            assertThat(TensionLevel.fromScore(19)).isEqualTo(TensionLevel.MINIMAL);
        }

        @Test
        @DisplayName("should resolve LOW for scores 20-39")
        void shouldResolveLowForScores20To39() {
            assertThat(TensionLevel.fromScore(20)).isEqualTo(TensionLevel.LOW);
            assertThat(TensionLevel.fromScore(30)).isEqualTo(TensionLevel.LOW);
            assertThat(TensionLevel.fromScore(39)).isEqualTo(TensionLevel.LOW);
        }

        @Test
        @DisplayName("should resolve MODERATE for scores 40-59")
        void shouldResolveModerateForScores40To59() {
            assertThat(TensionLevel.fromScore(40)).isEqualTo(TensionLevel.MODERATE);
            assertThat(TensionLevel.fromScore(50)).isEqualTo(TensionLevel.MODERATE);
            assertThat(TensionLevel.fromScore(59)).isEqualTo(TensionLevel.MODERATE);
        }

        @Test
        @DisplayName("should resolve HIGH for scores 60-79")
        void shouldResolveHighForScores60To79() {
            assertThat(TensionLevel.fromScore(60)).isEqualTo(TensionLevel.HIGH);
            assertThat(TensionLevel.fromScore(70)).isEqualTo(TensionLevel.HIGH);
            assertThat(TensionLevel.fromScore(79)).isEqualTo(TensionLevel.HIGH);
        }

        @Test
        @DisplayName("should resolve CRITICAL for scores 80-100")
        void shouldResolveCriticalForScores80To100() {
            assertThat(TensionLevel.fromScore(80)).isEqualTo(TensionLevel.CRITICAL);
            assertThat(TensionLevel.fromScore(90)).isEqualTo(TensionLevel.CRITICAL);
            assertThat(TensionLevel.fromScore(100)).isEqualTo(TensionLevel.CRITICAL);
        }

        @Test
        @DisplayName("should clamp negative scores to 0")
        void shouldClampNegativeScoresTo0() {
            assertThat(TensionLevel.fromScore(-10)).isEqualTo(TensionLevel.MINIMAL);
        }

        @Test
        @DisplayName("should clamp scores over 100 to 100")
        void shouldClampScoresOver100To100() {
            assertThat(TensionLevel.fromScore(150)).isEqualTo(TensionLevel.CRITICAL);
        }
    }

    @Nested
    @DisplayName("fromCode tests")
    class FromCodeTests {

        @Test
        @DisplayName("should resolve from code")
        void shouldResolveFromCode() {
            assertThat(TensionLevel.fromCode("minimal")).isEqualTo(TensionLevel.MINIMAL);
            assertThat(TensionLevel.fromCode("low")).isEqualTo(TensionLevel.LOW);
            assertThat(TensionLevel.fromCode("moderate")).isEqualTo(TensionLevel.MODERATE);
            assertThat(TensionLevel.fromCode("high")).isEqualTo(TensionLevel.HIGH);
            assertThat(TensionLevel.fromCode("critical")).isEqualTo(TensionLevel.CRITICAL);
        }

        @Test
        @DisplayName("should throw exception for unknown code")
        void shouldThrowExceptionForUnknownCode() {
            assertThatThrownBy(() -> TensionLevel.fromCode("unknown"))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Unknown tension level code");
        }
    }

    @Nested
    @DisplayName("escalate tests")
    class EscalateTests {

        @Test
        @DisplayName("escalate should move to next higher level")
        void escalateShouldMoveToNextHigherLevel() {
            assertThat(TensionLevel.MINIMAL.escalate()).isEqualTo(TensionLevel.LOW);
            assertThat(TensionLevel.LOW.escalate()).isEqualTo(TensionLevel.MODERATE);
            assertThat(TensionLevel.MODERATE.escalate()).isEqualTo(TensionLevel.HIGH);
            assertThat(TensionLevel.HIGH.escalate()).isEqualTo(TensionLevel.CRITICAL);
            assertThat(TensionLevel.CRITICAL.escalate()).isEqualTo(TensionLevel.CRITICAL);
        }
    }

    @Nested
    @DisplayName("deescalate tests")
    class DeescalateTests {

        @Test
        @DisplayName("deescalate should move to next lower level")
        void deescalateShouldMoveToNextLowerLevel() {
            assertThat(TensionLevel.CRITICAL.deescalate()).isEqualTo(TensionLevel.HIGH);
            assertThat(TensionLevel.HIGH.deescalate()).isEqualTo(TensionLevel.MODERATE);
            assertThat(TensionLevel.MODERATE.deescalate()).isEqualTo(TensionLevel.LOW);
            assertThat(TensionLevel.LOW.deescalate()).isEqualTo(TensionLevel.MINIMAL);
            assertThat(TensionLevel.MINIMAL.deescalate()).isEqualTo(TensionLevel.MINIMAL);
        }
    }

    @Nested
    @DisplayName("status check tests")
    class StatusCheckTests {

        @Test
        @DisplayName("requiresAttention should return true for HIGH and CRITICAL")
        void requiresAttentionShouldReturnTrueForHighAndCritical() {
            assertThat(TensionLevel.MINIMAL.requiresAttention()).isFalse();
            assertThat(TensionLevel.LOW.requiresAttention()).isFalse();
            assertThat(TensionLevel.MODERATE.requiresAttention()).isFalse();
            assertThat(TensionLevel.HIGH.requiresAttention()).isTrue();
            assertThat(TensionLevel.CRITICAL.requiresAttention()).isTrue();
        }

        @Test
        @DisplayName("isStallRisk should return true for MINIMAL and LOW")
        void isStallRiskShouldReturnTrueForMinimalAndLow() {
            assertThat(TensionLevel.MINIMAL.isStallRisk()).isTrue();
            assertThat(TensionLevel.LOW.isStallRisk()).isTrue();
            assertThat(TensionLevel.MODERATE.isStallRisk()).isFalse();
            assertThat(TensionLevel.HIGH.isStallRisk()).isFalse();
            assertThat(TensionLevel.CRITICAL.isStallRisk()).isFalse();
        }

        @Test
        @DisplayName("recommendsCuratorIntervention should return true for MINIMAL and CRITICAL")
        void recommendsCuratorInterventionShouldReturnTrueForMinimalAndCritical() {
            assertThat(TensionLevel.MINIMAL.recommendsCuratorIntervention()).isTrue();
            assertThat(TensionLevel.LOW.recommendsCuratorIntervention()).isFalse();
            assertThat(TensionLevel.MODERATE.recommendsCuratorIntervention()).isFalse();
            assertThat(TensionLevel.HIGH.recommendsCuratorIntervention()).isFalse();
            assertThat(TensionLevel.CRITICAL.recommendsCuratorIntervention()).isTrue();
        }
    }
}
