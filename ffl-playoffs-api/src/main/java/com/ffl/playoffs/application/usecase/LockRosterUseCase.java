package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.port.RosterRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Use case for locking a roster to prevent further modifications
 * Validates roster is complete before locking
 */
public class LockRosterUseCase {

    private final RosterRepository rosterRepository;

    public LockRosterUseCase(RosterRepository rosterRepository) {
        this.rosterRepository = rosterRepository;
    }

    /**
     * Locks a roster after validating it's complete
     *
     * @param command The lock roster command
     * @return LockRosterResult with status and details
     * @throws IllegalArgumentException if roster not found
     * @throws IllegalStateException if roster is already locked
     * @throws IllegalStateException if roster is incomplete
     */
    public LockRosterResult execute(LockRosterCommand command) {
        // Find roster
        Roster roster = rosterRepository.findById(command.getRosterId())
                .orElseThrow(() -> new IllegalArgumentException("Roster not found"));

        // Validate roster is not already locked
        if (roster.isLocked()) {
            throw new IllegalStateException("Roster is already locked");
        }

        // Validate roster is complete
        if (!roster.isComplete()) {
            List<Position> missingPositions = roster.getMissingPositions();
            throw new IllegalStateException(
                    "Cannot lock incomplete roster. Missing positions: " + missingPositions
            );
        }

        // Lock the roster
        LocalDateTime lockTime = command.getLockTime() != null
                ? command.getLockTime()
                : LocalDateTime.now();
        roster.lockRoster(lockTime);

        // Save roster
        Roster savedRoster = rosterRepository.save(roster);

        return new LockRosterResult(
                savedRoster.getId(),
                true,
                savedRoster.getLockedAt()
        );
    }

    /**
     * Command object for locking a roster
     */
    public static class LockRosterCommand {
        private final UUID rosterId;
        private final LocalDateTime lockTime;

        public LockRosterCommand(UUID rosterId) {
            this(rosterId, null);
        }

        public LockRosterCommand(UUID rosterId, LocalDateTime lockTime) {
            this.rosterId = rosterId;
            this.lockTime = lockTime;
        }

        public UUID getRosterId() {
            return rosterId;
        }

        public LocalDateTime getLockTime() {
            return lockTime;
        }
    }

    /**
     * Result object for lock operation
     */
    public static class LockRosterResult {
        private final UUID rosterId;
        private final boolean locked;
        private final LocalDateTime lockedAt;

        public LockRosterResult(UUID rosterId, boolean locked, LocalDateTime lockedAt) {
            this.rosterId = rosterId;
            this.locked = locked;
            this.lockedAt = lockedAt;
        }

        public UUID getRosterId() {
            return rosterId;
        }

        public boolean isLocked() {
            return locked;
        }

        public LocalDateTime getLockedAt() {
            return lockedAt;
        }
    }
}
