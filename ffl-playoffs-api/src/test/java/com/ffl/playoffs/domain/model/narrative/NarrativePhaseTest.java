package com.ffl.playoffs.domain.model.narrative;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("NarrativePhase Enum Tests")
class NarrativePhaseTest {

    @Test
    @DisplayName("should have exactly five phases")
    void shouldHaveExactlyFivePhases() {
        assertThat(NarrativePhase.values()).hasSize(5);
    }

    @Test
    @DisplayName("should have correct codes")
    void shouldHaveCorrectCodes() {
        assertThat(NarrativePhase.SETUP.getCode()).isEqualTo("setup");
        assertThat(NarrativePhase.RISING_ACTION.getCode()).isEqualTo("rising_action");
        assertThat(NarrativePhase.CLIMAX.getCode()).isEqualTo("climax");
        assertThat(NarrativePhase.FALLING_ACTION.getCode()).isEqualTo("falling_action");
        assertThat(NarrativePhase.RESOLUTION.getCode()).isEqualTo("resolution");
    }

    @Nested
    @DisplayName("fromCode tests")
    class FromCodeTests {

        @Test
        @DisplayName("should resolve from code")
        void shouldResolveFromCode() {
            assertThat(NarrativePhase.fromCode("setup")).isEqualTo(NarrativePhase.SETUP);
            assertThat(NarrativePhase.fromCode("rising_action")).isEqualTo(NarrativePhase.RISING_ACTION);
            assertThat(NarrativePhase.fromCode("climax")).isEqualTo(NarrativePhase.CLIMAX);
            assertThat(NarrativePhase.fromCode("falling_action")).isEqualTo(NarrativePhase.FALLING_ACTION);
            assertThat(NarrativePhase.fromCode("resolution")).isEqualTo(NarrativePhase.RESOLUTION);
        }

        @Test
        @DisplayName("should resolve from code case insensitively")
        void shouldResolveFromCodeCaseInsensitively() {
            assertThat(NarrativePhase.fromCode("SETUP")).isEqualTo(NarrativePhase.SETUP);
            assertThat(NarrativePhase.fromCode("Rising_Action")).isEqualTo(NarrativePhase.RISING_ACTION);
        }

        @Test
        @DisplayName("should throw exception for unknown code")
        void shouldThrowExceptionForUnknownCode() {
            assertThatThrownBy(() -> NarrativePhase.fromCode("unknown"))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Unknown narrative phase code");
        }
    }

    @Nested
    @DisplayName("phase category tests")
    class PhaseCategoryTests {

        @Test
        @DisplayName("isEarlyPhase should return true for SETUP and RISING_ACTION")
        void isEarlyPhaseShouldReturnTrueForSetupAndRisingAction() {
            assertThat(NarrativePhase.SETUP.isEarlyPhase()).isTrue();
            assertThat(NarrativePhase.RISING_ACTION.isEarlyPhase()).isTrue();
            assertThat(NarrativePhase.CLIMAX.isEarlyPhase()).isFalse();
            assertThat(NarrativePhase.FALLING_ACTION.isEarlyPhase()).isFalse();
            assertThat(NarrativePhase.RESOLUTION.isEarlyPhase()).isFalse();
        }

        @Test
        @DisplayName("isPeakPhase should return true only for CLIMAX")
        void isPeakPhaseShouldReturnTrueOnlyForClimax() {
            assertThat(NarrativePhase.SETUP.isPeakPhase()).isFalse();
            assertThat(NarrativePhase.RISING_ACTION.isPeakPhase()).isFalse();
            assertThat(NarrativePhase.CLIMAX.isPeakPhase()).isTrue();
            assertThat(NarrativePhase.FALLING_ACTION.isPeakPhase()).isFalse();
            assertThat(NarrativePhase.RESOLUTION.isPeakPhase()).isFalse();
        }

        @Test
        @DisplayName("isConcludingPhase should return true for FALLING_ACTION and RESOLUTION")
        void isConcludingPhaseShouldReturnTrueForFallingActionAndResolution() {
            assertThat(NarrativePhase.SETUP.isConcludingPhase()).isFalse();
            assertThat(NarrativePhase.RISING_ACTION.isConcludingPhase()).isFalse();
            assertThat(NarrativePhase.CLIMAX.isConcludingPhase()).isFalse();
            assertThat(NarrativePhase.FALLING_ACTION.isConcludingPhase()).isTrue();
            assertThat(NarrativePhase.RESOLUTION.isConcludingPhase()).isTrue();
        }
    }

    @Nested
    @DisplayName("transition tests")
    class TransitionTests {

        @Test
        @DisplayName("getNextPhase should return correct next phase")
        void getNextPhaseShouldReturnCorrectNextPhase() {
            assertThat(NarrativePhase.SETUP.getNextPhase()).isEqualTo(NarrativePhase.RISING_ACTION);
            assertThat(NarrativePhase.RISING_ACTION.getNextPhase()).isEqualTo(NarrativePhase.CLIMAX);
            assertThat(NarrativePhase.CLIMAX.getNextPhase()).isEqualTo(NarrativePhase.FALLING_ACTION);
            assertThat(NarrativePhase.FALLING_ACTION.getNextPhase()).isEqualTo(NarrativePhase.RESOLUTION);
            assertThat(NarrativePhase.RESOLUTION.getNextPhase()).isNull();
        }

        @Test
        @DisplayName("getPreviousPhase should return correct previous phase")
        void getPreviousPhaseShouldReturnCorrectPreviousPhase() {
            assertThat(NarrativePhase.SETUP.getPreviousPhase()).isNull();
            assertThat(NarrativePhase.RISING_ACTION.getPreviousPhase()).isEqualTo(NarrativePhase.SETUP);
            assertThat(NarrativePhase.CLIMAX.getPreviousPhase()).isEqualTo(NarrativePhase.RISING_ACTION);
            assertThat(NarrativePhase.FALLING_ACTION.getPreviousPhase()).isEqualTo(NarrativePhase.CLIMAX);
            assertThat(NarrativePhase.RESOLUTION.getPreviousPhase()).isEqualTo(NarrativePhase.FALLING_ACTION);
        }
    }

    @Nested
    @DisplayName("tension multiplier tests")
    class TensionMultiplierTests {

        @Test
        @DisplayName("getTensionMultiplier should return correct values")
        void getTensionMultiplierShouldReturnCorrectValues() {
            assertThat(NarrativePhase.SETUP.getTensionMultiplier()).isEqualTo(0.5);
            assertThat(NarrativePhase.RISING_ACTION.getTensionMultiplier()).isEqualTo(1.0);
            assertThat(NarrativePhase.CLIMAX.getTensionMultiplier()).isEqualTo(1.5);
            assertThat(NarrativePhase.FALLING_ACTION.getTensionMultiplier()).isEqualTo(1.2);
            assertThat(NarrativePhase.RESOLUTION.getTensionMultiplier()).isEqualTo(0.8);
        }
    }

    @Nested
    @DisplayName("allowsMajorEvents tests")
    class AllowsMajorEventsTests {

        @Test
        @DisplayName("allowsMajorEvents should return false only for RESOLUTION")
        void allowsMajorEventsShouldReturnFalseOnlyForResolution() {
            assertThat(NarrativePhase.SETUP.allowsMajorEvents()).isTrue();
            assertThat(NarrativePhase.RISING_ACTION.allowsMajorEvents()).isTrue();
            assertThat(NarrativePhase.CLIMAX.allowsMajorEvents()).isTrue();
            assertThat(NarrativePhase.FALLING_ACTION.allowsMajorEvents()).isTrue();
            assertThat(NarrativePhase.RESOLUTION.allowsMajorEvents()).isFalse();
        }
    }
}
