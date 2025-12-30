package com.ffl.playoffs.domain.model.world;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("WorldStatus Enum Tests")
class WorldStatusTest {

    @Test
    @DisplayName("should have correct code and description")
    void shouldHaveCorrectCodeAndDescription() {
        assertThat(WorldStatus.CREATED.getCode()).isEqualTo("created");
        assertThat(WorldStatus.CREATED.getDescription()).isEqualTo("World created but not configured");

        assertThat(WorldStatus.ACTIVE.getCode()).isEqualTo("active");
        assertThat(WorldStatus.ACTIVE.getDescription()).isEqualTo("World active, season in progress");
    }

    @Test
    @DisplayName("should allow valid transitions from CREATED")
    void shouldAllowValidTransitionsFromCreated() {
        assertThat(WorldStatus.CREATED.canTransitionTo(WorldStatus.CONFIGURING)).isTrue();
        assertThat(WorldStatus.CREATED.canTransitionTo(WorldStatus.CANCELLED)).isTrue();

        assertThat(WorldStatus.CREATED.canTransitionTo(WorldStatus.ACTIVE)).isFalse();
        assertThat(WorldStatus.CREATED.canTransitionTo(WorldStatus.COMPLETED)).isFalse();
    }

    @Test
    @DisplayName("should allow valid transitions from CONFIGURING")
    void shouldAllowValidTransitionsFromConfiguring() {
        assertThat(WorldStatus.CONFIGURING.canTransitionTo(WorldStatus.READY)).isTrue();
        assertThat(WorldStatus.CONFIGURING.canTransitionTo(WorldStatus.CANCELLED)).isTrue();

        assertThat(WorldStatus.CONFIGURING.canTransitionTo(WorldStatus.ACTIVE)).isFalse();
    }

    @Test
    @DisplayName("should allow valid transitions from READY")
    void shouldAllowValidTransitionsFromReady() {
        assertThat(WorldStatus.READY.canTransitionTo(WorldStatus.ACTIVE)).isTrue();
        assertThat(WorldStatus.READY.canTransitionTo(WorldStatus.CANCELLED)).isTrue();

        assertThat(WorldStatus.READY.canTransitionTo(WorldStatus.COMPLETED)).isFalse();
    }

    @Test
    @DisplayName("should allow valid transitions from ACTIVE")
    void shouldAllowValidTransitionsFromActive() {
        assertThat(WorldStatus.ACTIVE.canTransitionTo(WorldStatus.PAUSED)).isTrue();
        assertThat(WorldStatus.ACTIVE.canTransitionTo(WorldStatus.COMPLETED)).isTrue();
        assertThat(WorldStatus.ACTIVE.canTransitionTo(WorldStatus.CANCELLED)).isTrue();

        assertThat(WorldStatus.ACTIVE.canTransitionTo(WorldStatus.READY)).isFalse();
    }

    @Test
    @DisplayName("should allow resume from PAUSED")
    void shouldAllowResumeFromPaused() {
        assertThat(WorldStatus.PAUSED.canTransitionTo(WorldStatus.ACTIVE)).isTrue();
        assertThat(WorldStatus.PAUSED.canTransitionTo(WorldStatus.CANCELLED)).isTrue();

        assertThat(WorldStatus.PAUSED.canTransitionTo(WorldStatus.COMPLETED)).isFalse();
    }

    @Test
    @DisplayName("should not allow transitions from terminal states")
    void shouldNotAllowTransitionsFromTerminalStates() {
        assertThat(WorldStatus.COMPLETED.canTransitionTo(WorldStatus.ACTIVE)).isFalse();
        assertThat(WorldStatus.COMPLETED.canTransitionTo(WorldStatus.CANCELLED)).isFalse();

        assertThat(WorldStatus.CANCELLED.canTransitionTo(WorldStatus.ACTIVE)).isFalse();
        assertThat(WorldStatus.CANCELLED.canTransitionTo(WorldStatus.COMPLETED)).isFalse();
    }

    @Test
    @DisplayName("should correctly identify terminal states")
    void shouldCorrectlyIdentifyTerminalStates() {
        assertThat(WorldStatus.COMPLETED.isTerminal()).isTrue();
        assertThat(WorldStatus.CANCELLED.isTerminal()).isTrue();

        assertThat(WorldStatus.CREATED.isTerminal()).isFalse();
        assertThat(WorldStatus.ACTIVE.isTerminal()).isFalse();
        assertThat(WorldStatus.PAUSED.isTerminal()).isFalse();
    }

    @Test
    @DisplayName("should correctly identify running state")
    void shouldCorrectlyIdentifyRunningState() {
        assertThat(WorldStatus.ACTIVE.isRunning()).isTrue();

        assertThat(WorldStatus.CREATED.isRunning()).isFalse();
        assertThat(WorldStatus.PAUSED.isRunning()).isFalse();
        assertThat(WorldStatus.COMPLETED.isRunning()).isFalse();
    }
}
