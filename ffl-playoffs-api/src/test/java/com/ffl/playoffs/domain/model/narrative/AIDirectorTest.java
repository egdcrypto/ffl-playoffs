package com.ffl.playoffs.domain.model.narrative;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("AIDirector Tests")
class AIDirectorTest {

    private UUID leagueId;

    @BeforeEach
    void setUp() {
        leagueId = UUID.randomUUID();
    }

    @Nested
    @DisplayName("create tests")
    class CreateTests {

        @Test
        @DisplayName("should create AI Director with default values")
        void shouldCreateAIDirectorWithDefaultValues() {
            AIDirector director = AIDirector.create(leagueId);

            assertThat(director.getId()).isNotNull();
            assertThat(director.getLeagueId()).isEqualTo(leagueId);
            assertThat(director.getCurrentPhase()).isEqualTo(NarrativePhase.SETUP);
            assertThat(director.getCurrentTensionLevel()).isEqualTo(TensionLevel.MODERATE);
            assertThat(director.getTensionScore()).isEqualTo(50);
            assertThat(director.getStatus()).isEqualTo(AIDirector.DirectorStatus.ACTIVE);
            assertThat(director.isAutomationEnabled()).isTrue();
            assertThat(director.isOperational()).isTrue();
        }

        @Test
        @DisplayName("should throw exception for null leagueId")
        void shouldThrowExceptionForNullLeagueId() {
            assertThatThrownBy(() -> AIDirector.create(null))
                    .isInstanceOf(NullPointerException.class);
        }
    }

    @Nested
    @DisplayName("tension management tests")
    class TensionManagementTests {

        @Test
        @DisplayName("should update tension score and level")
        void shouldUpdateTensionScoreAndLevel() {
            AIDirector director = AIDirector.create(leagueId);

            director.updateTension(85);

            assertThat(director.getTensionScore()).isEqualTo(85);
            assertThat(director.getCurrentTensionLevel()).isEqualTo(TensionLevel.CRITICAL);
        }

        @Test
        @DisplayName("should clamp tension score to valid range")
        void shouldClampTensionScoreToValidRange() {
            AIDirector director = AIDirector.create(leagueId);

            director.updateTension(150);
            assertThat(director.getTensionScore()).isEqualTo(100);

            director.updateTension(-10);
            assertThat(director.getTensionScore()).isEqualTo(0);
        }

        @Test
        @DisplayName("should apply tension impact with phase multiplier")
        void shouldApplyTensionImpactWithPhaseMultiplier() {
            AIDirector director = AIDirector.create(leagueId);
            // Initial: 50, SETUP phase has 0.5 multiplier
            // Impact of 20 * 0.5 = 10

            director.applyTensionImpact(20);

            assertThat(director.getTensionScore()).isEqualTo(60);
        }

        @Test
        @DisplayName("isTensionCritical should return true when at critical level")
        void isTensionCriticalShouldReturnTrueWhenAtCriticalLevel() {
            AIDirector director = AIDirector.create(leagueId);

            director.updateTension(90);

            assertThat(director.isTensionCritical()).isTrue();
        }

        @Test
        @DisplayName("isTensionLow should return true when tension is low")
        void isTensionLowShouldReturnTrueWhenTensionIsLow() {
            AIDirector director = AIDirector.create(leagueId);

            director.updateTension(15);

            assertThat(director.isTensionLow()).isTrue();
        }
    }

    @Nested
    @DisplayName("phase management tests")
    class PhaseManagementTests {

        @Test
        @DisplayName("should advance to next phase")
        void shouldAdvanceToNextPhase() {
            AIDirector director = AIDirector.create(leagueId);

            director.advancePhase();

            assertThat(director.getCurrentPhase()).isEqualTo(NarrativePhase.RISING_ACTION);
        }

        @Test
        @DisplayName("should throw exception when advancing past RESOLUTION")
        void shouldThrowExceptionWhenAdvancingPastResolution() {
            AIDirector director = AIDirector.create(leagueId);
            director.overridePhase(NarrativePhase.RESOLUTION);

            assertThatThrownBy(() -> director.advancePhase())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot advance beyond RESOLUTION");
        }

        @Test
        @DisplayName("should override phase directly")
        void shouldOverridePhaseDirectly() {
            AIDirector director = AIDirector.create(leagueId);

            director.overridePhase(NarrativePhase.CLIMAX);

            assertThat(director.getCurrentPhase()).isEqualTo(NarrativePhase.CLIMAX);
        }

        @Test
        @DisplayName("should throw exception when advancing while not operational")
        void shouldThrowExceptionWhenAdvancingWhileNotOperational() {
            AIDirector director = AIDirector.create(leagueId);
            director.pause();

            assertThatThrownBy(() -> director.advancePhase())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("not operational");
        }
    }

    @Nested
    @DisplayName("story arc management tests")
    class StoryArcManagementTests {

        @Test
        @DisplayName("should set and clear active story arc")
        void shouldSetAndClearActiveStoryArc() {
            AIDirector director = AIDirector.create(leagueId);
            UUID arcId = UUID.randomUUID();

            director.setActiveStoryArc(arcId);
            assertThat(director.hasActiveStoryArc()).isTrue();
            assertThat(director.getActiveStoryArcId()).isEqualTo(arcId);

            director.clearActiveStoryArc();
            assertThat(director.hasActiveStoryArc()).isFalse();
            assertThat(director.getActiveStoryArcId()).isNull();
        }

        @Test
        @DisplayName("should record story beat generated")
        void shouldRecordStoryBeatGenerated() {
            AIDirector director = AIDirector.create(leagueId);

            director.recordStoryBeatGenerated();
            director.recordStoryBeatGenerated();

            assertThat(director.getTotalStoryBeatsGenerated()).isEqualTo(2);
        }
    }

    @Nested
    @DisplayName("stall detection tests")
    class StallDetectionTests {

        @Test
        @DisplayName("should register and resolve stall conditions")
        void shouldRegisterAndResolveStallConditions() {
            AIDirector director = AIDirector.create(leagueId);
            UUID stallId = UUID.randomUUID();

            director.registerStallCondition(stallId);
            assertThat(director.hasActiveStalls()).isTrue();
            assertThat(director.getActiveStallCount()).isEqualTo(1);

            director.resolveStallCondition(stallId);
            assertThat(director.hasActiveStalls()).isFalse();
            assertThat(director.getActiveStallCount()).isEqualTo(0);
        }

        @Test
        @DisplayName("should track total stalls detected")
        void shouldTrackTotalStallsDetected() {
            AIDirector director = AIDirector.create(leagueId);

            director.registerStallCondition(UUID.randomUUID());
            director.registerStallCondition(UUID.randomUUID());

            assertThat(director.getTotalStallsDetected()).isEqualTo(2);
        }
    }

    @Nested
    @DisplayName("curator action tests")
    class CuratorActionTests {

        @Test
        @DisplayName("should queue and complete actions")
        void shouldQueueAndCompleteActions() {
            AIDirector director = AIDirector.create(leagueId);
            UUID actionId = UUID.randomUUID();

            director.queueAction(actionId);
            assertThat(director.hasPendingActions()).isTrue();
            assertThat(director.getPendingActionCount()).isEqualTo(1);

            director.completeAction(actionId);
            assertThat(director.hasPendingActions()).isFalse();
            assertThat(director.getTotalActionsExecuted()).isEqualTo(1);
        }
    }

    @Nested
    @DisplayName("director control tests")
    class DirectorControlTests {

        @Test
        @DisplayName("should pause and resume")
        void shouldPauseAndResume() {
            AIDirector director = AIDirector.create(leagueId);

            director.pause();
            assertThat(director.getStatus()).isEqualTo(AIDirector.DirectorStatus.PAUSED);
            assertThat(director.isOperational()).isFalse();

            director.resume();
            assertThat(director.getStatus()).isEqualTo(AIDirector.DirectorStatus.ACTIVE);
            assertThat(director.isOperational()).isTrue();
        }

        @Test
        @DisplayName("should suspend and reactivate")
        void shouldSuspendAndReactivate() {
            AIDirector director = AIDirector.create(leagueId);

            director.suspend();
            assertThat(director.getStatus()).isEqualTo(AIDirector.DirectorStatus.SUSPENDED);
            assertThat(director.isAutomationEnabled()).isFalse();

            director.reactivate();
            assertThat(director.getStatus()).isEqualTo(AIDirector.DirectorStatus.ACTIVE);
        }

        @Test
        @DisplayName("should enable and disable automation")
        void shouldEnableAndDisableAutomation() {
            AIDirector director = AIDirector.create(leagueId);

            director.disableAutomation();
            assertThat(director.isAutomationEnabled()).isFalse();
            assertThat(director.canRunAutomation()).isFalse();

            director.enableAutomation();
            assertThat(director.isAutomationEnabled()).isTrue();
            assertThat(director.canRunAutomation()).isTrue();
        }

        @Test
        @DisplayName("should throw exception when pausing non-active director")
        void shouldThrowExceptionWhenPausingNonActiveDirector() {
            AIDirector director = AIDirector.create(leagueId);
            director.pause();

            assertThatThrownBy(() -> director.pause())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Can only pause active arcs");
        }

        @Test
        @DisplayName("should throw exception when resuming non-paused director")
        void shouldThrowExceptionWhenResumingNonPausedDirector() {
            AIDirector director = AIDirector.create(leagueId);

            assertThatThrownBy(() -> director.resume())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Can only resume paused director");
        }
    }

    @Nested
    @DisplayName("configuration tests")
    class ConfigurationTests {

        @Test
        @DisplayName("should update stall detection threshold")
        void shouldUpdateStallDetectionThreshold() {
            AIDirector director = AIDirector.create(leagueId);

            director.setStallDetectionThreshold(48);

            assertThat(director.getStallDetectionThresholdHours()).isEqualTo(48);
        }

        @Test
        @DisplayName("should throw exception for invalid threshold")
        void shouldThrowExceptionForInvalidThreshold() {
            AIDirector director = AIDirector.create(leagueId);

            assertThatThrownBy(() -> director.setStallDetectionThreshold(0))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("at least 1 hour");
        }

        @Test
        @DisplayName("should update tension target")
        void shouldUpdateTensionTarget() {
            AIDirector director = AIDirector.create(leagueId);

            director.setTensionTarget(75);

            assertThat(director.getTensionTargetScore()).isEqualTo(75);
        }

        @Test
        @DisplayName("should throw exception for invalid tension target")
        void shouldThrowExceptionForInvalidTensionTarget() {
            AIDirector director = AIDirector.create(leagueId);

            assertThatThrownBy(() -> director.setTensionTarget(150))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("between 0 and 100");
        }
    }
}
