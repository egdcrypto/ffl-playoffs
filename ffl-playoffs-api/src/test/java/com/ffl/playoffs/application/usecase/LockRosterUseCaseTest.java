package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.IntegrationTestBase;
import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.RosterConfiguration;
import com.ffl.playoffs.domain.model.RosterLockStatus;
import com.ffl.playoffs.domain.port.RosterRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

/**
 * Integration tests for LockRosterUseCase
 * Tests roster locking functionality for the one-time draft model
 */
@DisplayName("LockRosterUseCase Integration Tests")
class LockRosterUseCaseTest extends IntegrationTestBase {

    @Autowired
    private RosterRepository rosterRepository;

    private LockRosterUseCase useCase;
    private UUID testLeaguePlayerId;
    private UUID testGameId;

    @Override
    protected void baseSetUp() {
        super.baseSetUp();
        useCase = new LockRosterUseCase(rosterRepository);
        testLeaguePlayerId = UUID.randomUUID();
        testGameId = UUID.randomUUID();
    }

    private Roster createCompleteRoster() {
        RosterConfiguration config = RosterConfiguration.standard();
        Roster roster = new Roster(testLeaguePlayerId, testGameId, config);

        // Fill all slots with NFL players
        roster.getSlots().forEach(slot -> {
            long playerId = Math.abs(UUID.randomUUID().hashCode());
            slot.assignPlayer(playerId, slot.getPosition());
        });

        return rosterRepository.save(roster);
    }

    private Roster createIncompleteRoster() {
        RosterConfiguration config = RosterConfiguration.standard();
        Roster roster = new Roster(testLeaguePlayerId, testGameId, config);

        // Only fill some slots (leave QB and K empty)
        roster.getSlots().stream()
                .filter(slot -> slot.getPosition() != Position.QB && slot.getPosition() != Position.K)
                .forEach(slot -> {
                    long playerId = Math.abs(UUID.randomUUID().hashCode());
                    slot.assignPlayer(playerId, slot.getPosition());
                });

        return rosterRepository.save(roster);
    }

    @Test
    @DisplayName("Should lock complete roster with LOCKED status")
    void shouldLockCompleteRoster() {
        // Given
        Roster roster = createCompleteRoster();
        LocalDateTime lockTime = LocalDateTime.of(2024, 9, 5, 20, 0);

        var command = new LockRosterUseCase.LockRosterCommand(roster.getId(), lockTime);

        // When
        LockRosterUseCase.LockRosterResult result = useCase.execute(command);

        // Then
        assertThat(result.isLocked()).isTrue();
        assertThat(result.getLockedAt()).isEqualTo(lockTime);
        assertThat(result.getLockStatus()).isEqualTo(RosterLockStatus.LOCKED);
        assertThat(result.getMissingPositions()).isEmpty();
        assertThat(result.isComplete()).isTrue();

        // Verify persistence
        Roster savedRoster = rosterRepository.findById(roster.getId()).orElse(null);
        assertThat(savedRoster).isNotNull();
        assertThat(savedRoster.isLocked()).isTrue();
        assertThat(savedRoster.getLockStatus()).isEqualTo(RosterLockStatus.LOCKED);
        assertThat(savedRoster.getLockedAt()).isEqualTo(lockTime);
    }

    @Test
    @DisplayName("Should reject locking incomplete roster with execute method")
    void shouldRejectLockingIncompleteRoster() {
        // Given
        Roster roster = createIncompleteRoster();

        var command = new LockRosterUseCase.LockRosterCommand(roster.getId());

        // When/Then
        assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("Cannot lock incomplete roster")
                .hasMessageContaining("Missing positions");
    }

    @Test
    @DisplayName("Should lock incomplete roster at deadline with LOCKED_INCOMPLETE status")
    void shouldLockIncompleteRosterAtDeadline() {
        // Given
        Roster roster = createIncompleteRoster();
        LocalDateTime lockTime = LocalDateTime.of(2024, 9, 5, 20, 0);

        var command = new LockRosterUseCase.LockAtDeadlineCommand(roster.getId(), lockTime);

        // When
        LockRosterUseCase.LockRosterResult result = useCase.executeAtDeadline(command);

        // Then
        assertThat(result.isLocked()).isTrue();
        assertThat(result.getLockedAt()).isEqualTo(lockTime);
        assertThat(result.getLockStatus()).isEqualTo(RosterLockStatus.LOCKED_INCOMPLETE);
        assertThat(result.getMissingPositions()).contains(Position.QB, Position.K);
        assertThat(result.isIncomplete()).isTrue();

        // Verify persistence
        Roster savedRoster = rosterRepository.findById(roster.getId()).orElse(null);
        assertThat(savedRoster).isNotNull();
        assertThat(savedRoster.isLocked()).isTrue();
        assertThat(savedRoster.getLockStatus()).isEqualTo(RosterLockStatus.LOCKED_INCOMPLETE);
    }

    @Test
    @DisplayName("Should lock complete roster at deadline with LOCKED status")
    void shouldLockCompleteRosterAtDeadline() {
        // Given
        Roster roster = createCompleteRoster();
        LocalDateTime lockTime = LocalDateTime.of(2024, 9, 5, 20, 0);

        var command = new LockRosterUseCase.LockAtDeadlineCommand(roster.getId(), lockTime);

        // When
        LockRosterUseCase.LockRosterResult result = useCase.executeAtDeadline(command);

        // Then
        assertThat(result.isLocked()).isTrue();
        assertThat(result.getLockStatus()).isEqualTo(RosterLockStatus.LOCKED);
        assertThat(result.isComplete()).isTrue();
    }

    @Test
    @DisplayName("Should throw exception when trying to lock already locked roster")
    void shouldThrowExceptionWhenRosterAlreadyLocked() {
        // Given
        Roster roster = createCompleteRoster();

        // First lock
        var command1 = new LockRosterUseCase.LockRosterCommand(roster.getId());
        useCase.execute(command1);

        // Try to lock again
        var command2 = new LockRosterUseCase.LockRosterCommand(roster.getId());

        // When/Then
        assertThatThrownBy(() -> useCase.execute(command2))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("already locked");
    }

    @Test
    @DisplayName("Should throw exception when roster not found")
    void shouldThrowExceptionWhenRosterNotFound() {
        // Given
        UUID nonExistentId = UUID.randomUUID();
        var command = new LockRosterUseCase.LockRosterCommand(nonExistentId);

        // When/Then
        assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Roster not found");
    }

    @Test
    @DisplayName("Should use current time when lock time not provided")
    void shouldUseCurrentTimeWhenNotProvided() {
        // Given
        Roster roster = createCompleteRoster();
        LocalDateTime beforeLock = LocalDateTime.now().minusSeconds(1);

        var command = new LockRosterUseCase.LockRosterCommand(roster.getId());

        // When
        LockRosterUseCase.LockRosterResult result = useCase.execute(command);

        // Then
        assertThat(result.getLockedAt()).isAfter(beforeLock);
        assertThat(result.getLockedAt()).isBefore(LocalDateTime.now().plusSeconds(1));
    }
}
