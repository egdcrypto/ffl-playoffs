package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.RosterStatus;
import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.exception.RosterOperationException;
import com.ffl.playoffs.domain.port.RosterRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Use case for locking a roster to prevent further modifications.
 *
 * ONE-TIME DRAFT MODEL:
 * - Rosters are PERMANENTLY locked when first game starts
 * - Supports locking incomplete rosters (player scores 0 for empty positions)
 * - No unlock functionality - this is strictly enforced
 */
public class LockRosterUseCase {

    private final RosterRepository rosterRepository;

    public LockRosterUseCase(RosterRepository rosterRepository) {
        this.rosterRepository = rosterRepository;
    }

    /**
     * Locks a roster permanently.
     *
     * In the one-time draft model:
     * - Complete rosters are locked with status LOCKED
     * - Incomplete rosters are locked with status LOCKED_INCOMPLETE
     * - Player will score 0 for empty positions all season
     *
     * @param command The lock roster command
     * @return LockRosterResult with status and details
     * @throws RosterOperationException if roster not found or already locked
     */
    public LockRosterResult execute(LockRosterCommand command) {
        // Find roster
        Roster roster = rosterRepository.findById(command.getRosterId())
                .orElseThrow(RosterOperationException::rosterNotFound);

        // Validate roster is not already locked
        if (roster.isLocked()) {
            throw RosterOperationException.rosterAlreadyLocked();
        }

        // Check if roster is complete (for informational purposes)
        boolean isComplete = roster.isComplete();
        List<Position> missingPositions = roster.getMissingPositions();

        // If forceIncomplete is false and roster is incomplete, fail
        // This allows the UI to warn users before accidentally locking incomplete rosters
        if (!command.isAllowIncomplete() && !isComplete) {
            throw new RosterOperationException(
                    RosterOperationException.ErrorCode.ROSTER_INCOMPLETE,
                    String.format("Roster is incomplete. Missing positions: %s. Use allowIncomplete=true to lock anyway.",
                            missingPositions)
            );
        }

        // Lock the roster (will set status to LOCKED or LOCKED_INCOMPLETE)
        LocalDateTime lockTime = command.getLockTime() != null
                ? command.getLockTime()
                : LocalDateTime.now();
        roster.lockRoster(lockTime);

        // Save roster
        Roster savedRoster = rosterRepository.save(roster);

        // Build warning message for incomplete rosters
        String warningMessage = null;
        if (!isComplete) {
            warningMessage = String.format(
                    "Your roster is incomplete and permanently locked - you will receive 0 points for %s for all weeks",
                    missingPositions
            );
        }

        return LockRosterResult.builder()
                .rosterId(savedRoster.getId())
                .locked(true)
                .lockedAt(savedRoster.getLockedAt())
                .status(savedRoster.getStatus())
                .isComplete(isComplete)
                .missingPositions(missingPositions)
                .warningMessage(warningMessage)
                .build();
    }

    /**
     * Command object for locking a roster
     */
    public static class LockRosterCommand {
        private final UUID rosterId;
        private final LocalDateTime lockTime;
        private final boolean allowIncomplete;

        public LockRosterCommand(UUID rosterId) {
            this(rosterId, null, false);
        }

        public LockRosterCommand(UUID rosterId, LocalDateTime lockTime) {
            this(rosterId, lockTime, false);
        }

        public LockRosterCommand(UUID rosterId, LocalDateTime lockTime, boolean allowIncomplete) {
            this.rosterId = rosterId;
            this.lockTime = lockTime;
            this.allowIncomplete = allowIncomplete;
        }

        public UUID getRosterId() {
            return rosterId;
        }

        public LocalDateTime getLockTime() {
            return lockTime;
        }

        public boolean isAllowIncomplete() {
            return allowIncomplete;
        }

        public static Builder builder() {
            return new Builder();
        }

        public static class Builder {
            private UUID rosterId;
            private LocalDateTime lockTime;
            private boolean allowIncomplete = false;

            public Builder rosterId(UUID rosterId) {
                this.rosterId = rosterId;
                return this;
            }

            public Builder lockTime(LocalDateTime lockTime) {
                this.lockTime = lockTime;
                return this;
            }

            public Builder allowIncomplete(boolean allowIncomplete) {
                this.allowIncomplete = allowIncomplete;
                return this;
            }

            public LockRosterCommand build() {
                return new LockRosterCommand(rosterId, lockTime, allowIncomplete);
            }
        }
    }

    /**
     * Result object for lock operation
     */
    public static class LockRosterResult {
        private final UUID rosterId;
        private final boolean locked;
        private final LocalDateTime lockedAt;
        private final RosterStatus status;
        private final boolean isComplete;
        private final List<Position> missingPositions;
        private final String warningMessage;

        private LockRosterResult(Builder builder) {
            this.rosterId = builder.rosterId;
            this.locked = builder.locked;
            this.lockedAt = builder.lockedAt;
            this.status = builder.status;
            this.isComplete = builder.isComplete;
            this.missingPositions = builder.missingPositions;
            this.warningMessage = builder.warningMessage;
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

        public RosterStatus getStatus() {
            return status;
        }

        public boolean isComplete() {
            return isComplete;
        }

        public List<Position> getMissingPositions() {
            return missingPositions;
        }

        public String getWarningMessage() {
            return warningMessage;
        }

        public static Builder builder() {
            return new Builder();
        }

        public static class Builder {
            private UUID rosterId;
            private boolean locked;
            private LocalDateTime lockedAt;
            private RosterStatus status;
            private boolean isComplete;
            private List<Position> missingPositions;
            private String warningMessage;

            public Builder rosterId(UUID rosterId) {
                this.rosterId = rosterId;
                return this;
            }

            public Builder locked(boolean locked) {
                this.locked = locked;
                return this;
            }

            public Builder lockedAt(LocalDateTime lockedAt) {
                this.lockedAt = lockedAt;
                return this;
            }

            public Builder status(RosterStatus status) {
                this.status = status;
                return this;
            }

            public Builder isComplete(boolean isComplete) {
                this.isComplete = isComplete;
                return this;
            }

            public Builder missingPositions(List<Position> missingPositions) {
                this.missingPositions = missingPositions;
                return this;
            }

            public Builder warningMessage(String warningMessage) {
                this.warningMessage = warningMessage;
                return this;
            }

            public LockRosterResult build() {
                return new LockRosterResult(this);
            }
        }
    }
}
