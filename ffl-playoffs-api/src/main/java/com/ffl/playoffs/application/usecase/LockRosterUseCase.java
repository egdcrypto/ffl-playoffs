package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.RosterLockStatus;
import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.port.RosterRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Use case for locking a roster to prevent further modifications.
 * Supports both complete roster locking and deadline-based locking (which allows incomplete rosters).
 * In the one-time draft model, rosters are permanently locked once the deadline passes.
 */
public class LockRosterUseCase {

    private final RosterRepository rosterRepository;

    public LockRosterUseCase(RosterRepository rosterRepository) {
        this.rosterRepository = rosterRepository;
    }

    /**
     * Locks a roster after validating it's complete.
     * Use this for manual roster locking where completion is required.
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
                savedRoster.getLockedAt(),
                savedRoster.getLockStatus(),
                savedRoster.getMissingPositions()
        );
    }

    /**
     * Locks a roster at the deadline, regardless of completeness.
     * Incomplete rosters will be locked with LOCKED_INCOMPLETE status.
     * This is used when the roster lock deadline passes automatically.
     *
     * @param command The lock at deadline command
     * @return LockRosterResult with status and details
     * @throws IllegalArgumentException if roster not found
     * @throws IllegalStateException if roster is already locked
     */
    public LockRosterResult executeAtDeadline(LockAtDeadlineCommand command) {
        // Find roster
        Roster roster = rosterRepository.findById(command.getRosterId())
                .orElseThrow(() -> new IllegalArgumentException("Roster not found"));

        // Validate roster is not already locked
        if (roster.isLocked()) {
            throw new IllegalStateException("Roster is already locked");
        }

        // Lock the roster at deadline (allows incomplete rosters)
        LocalDateTime lockTime = command.getLockTime() != null
                ? command.getLockTime()
                : LocalDateTime.now();
        RosterLockStatus lockStatus = roster.lockAtDeadline(lockTime);

        // Save roster
        Roster savedRoster = rosterRepository.save(roster);

        return new LockRosterResult(
                savedRoster.getId(),
                true,
                savedRoster.getLockedAt(),
                lockStatus,
                savedRoster.getMissingPositions()
        );
    }

    /**
     * Command object for locking a roster (requires complete roster)
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
     * Command object for locking a roster at deadline (allows incomplete rosters)
     */
    public static class LockAtDeadlineCommand {
        private final UUID rosterId;
        private final LocalDateTime lockTime;

        public LockAtDeadlineCommand(UUID rosterId) {
            this(rosterId, null);
        }

        public LockAtDeadlineCommand(UUID rosterId, LocalDateTime lockTime) {
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
        private final RosterLockStatus lockStatus;
        private final List<Position> missingPositions;

        public LockRosterResult(UUID rosterId, boolean locked, LocalDateTime lockedAt,
                               RosterLockStatus lockStatus, List<Position> missingPositions) {
            this.rosterId = rosterId;
            this.locked = locked;
            this.lockedAt = lockedAt;
            this.lockStatus = lockStatus;
            this.missingPositions = missingPositions;
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

        public RosterLockStatus getLockStatus() {
            return lockStatus;
        }

        public List<Position> getMissingPositions() {
            return missingPositions;
        }

        public boolean isComplete() {
            return lockStatus == RosterLockStatus.LOCKED;
        }

        public boolean isIncomplete() {
            return lockStatus == RosterLockStatus.LOCKED_INCOMPLETE;
        }
    }
}
