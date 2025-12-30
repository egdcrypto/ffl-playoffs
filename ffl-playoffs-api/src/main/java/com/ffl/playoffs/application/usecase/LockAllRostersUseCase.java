package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.model.RosterStatus;
import com.ffl.playoffs.domain.port.RosterRepository;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Use case for locking all rosters for a game at the deadline.
 *
 * ONE-TIME DRAFT MODEL:
 * - Called when the roster lock deadline passes (before first game starts)
 * - Locks ALL rosters, complete or incomplete
 * - Incomplete rosters are locked with LOCKED_INCOMPLETE status
 * - Players with incomplete rosters will score 0 for empty positions all season
 * - No unlock functionality exists - this is strictly enforced
 */
public class LockAllRostersUseCase {

    private final RosterRepository rosterRepository;

    public LockAllRostersUseCase(RosterRepository rosterRepository) {
        this.rosterRepository = rosterRepository;
    }

    /**
     * Locks all rosters for a game at the specified deadline time.
     *
     * @param command The lock all rosters command
     * @return LockAllRostersResult with summary of lock operations
     */
    public LockAllRostersResult execute(LockAllRostersCommand command) {
        LocalDateTime lockTime = command.getLockTime() != null
                ? command.getLockTime()
                : LocalDateTime.now();

        // Find all unlocked rosters for the game
        List<Roster> unlockedRosters = rosterRepository.findByGameIdAndIsLockedFalse(command.getGameId());

        List<RosterLockSummary> lockedRosters = new ArrayList<>();
        int completeCount = 0;
        int incompleteCount = 0;

        for (Roster roster : unlockedRosters) {
            boolean isComplete = roster.isComplete();

            // Lock the roster (handles setting appropriate status)
            roster.lockRoster(lockTime);
            rosterRepository.save(roster);

            if (isComplete) {
                completeCount++;
            } else {
                incompleteCount++;
            }

            lockedRosters.add(new RosterLockSummary(
                    roster.getId(),
                    roster.getLeaguePlayerId(),
                    roster.getStatus(),
                    isComplete,
                    roster.getMissingPositions().size()
            ));
        }

        return LockAllRostersResult.builder()
                .gameId(command.getGameId())
                .lockTime(lockTime)
                .totalRostersLocked(lockedRosters.size())
                .completeRosters(completeCount)
                .incompleteRosters(incompleteCount)
                .rosterSummaries(lockedRosters)
                .build();
    }

    /**
     * Command for locking all rosters
     */
    public static class LockAllRostersCommand {
        private final UUID gameId;
        private final LocalDateTime lockTime;

        public LockAllRostersCommand(UUID gameId) {
            this(gameId, null);
        }

        public LockAllRostersCommand(UUID gameId, LocalDateTime lockTime) {
            this.gameId = gameId;
            this.lockTime = lockTime;
        }

        public UUID getGameId() {
            return gameId;
        }

        public LocalDateTime getLockTime() {
            return lockTime;
        }
    }

    /**
     * Summary for a single roster lock
     */
    public static class RosterLockSummary {
        private final UUID rosterId;
        private final UUID leaguePlayerId;
        private final RosterStatus status;
        private final boolean isComplete;
        private final int emptySlotCount;

        public RosterLockSummary(UUID rosterId, UUID leaguePlayerId, RosterStatus status,
                                 boolean isComplete, int emptySlotCount) {
            this.rosterId = rosterId;
            this.leaguePlayerId = leaguePlayerId;
            this.status = status;
            this.isComplete = isComplete;
            this.emptySlotCount = emptySlotCount;
        }

        public UUID getRosterId() {
            return rosterId;
        }

        public UUID getLeaguePlayerId() {
            return leaguePlayerId;
        }

        public RosterStatus getStatus() {
            return status;
        }

        public boolean isComplete() {
            return isComplete;
        }

        public int getEmptySlotCount() {
            return emptySlotCount;
        }
    }

    /**
     * Result of batch lock operation
     */
    public static class LockAllRostersResult {
        private final UUID gameId;
        private final LocalDateTime lockTime;
        private final int totalRostersLocked;
        private final int completeRosters;
        private final int incompleteRosters;
        private final List<RosterLockSummary> rosterSummaries;

        private LockAllRostersResult(Builder builder) {
            this.gameId = builder.gameId;
            this.lockTime = builder.lockTime;
            this.totalRostersLocked = builder.totalRostersLocked;
            this.completeRosters = builder.completeRosters;
            this.incompleteRosters = builder.incompleteRosters;
            this.rosterSummaries = builder.rosterSummaries;
        }

        public UUID getGameId() {
            return gameId;
        }

        public LocalDateTime getLockTime() {
            return lockTime;
        }

        public int getTotalRostersLocked() {
            return totalRostersLocked;
        }

        public int getCompleteRosters() {
            return completeRosters;
        }

        public int getIncompleteRosters() {
            return incompleteRosters;
        }

        public List<RosterLockSummary> getRosterSummaries() {
            return rosterSummaries;
        }

        public static Builder builder() {
            return new Builder();
        }

        public static class Builder {
            private UUID gameId;
            private LocalDateTime lockTime;
            private int totalRostersLocked;
            private int completeRosters;
            private int incompleteRosters;
            private List<RosterLockSummary> rosterSummaries;

            public Builder gameId(UUID gameId) {
                this.gameId = gameId;
                return this;
            }

            public Builder lockTime(LocalDateTime lockTime) {
                this.lockTime = lockTime;
                return this;
            }

            public Builder totalRostersLocked(int totalRostersLocked) {
                this.totalRostersLocked = totalRostersLocked;
                return this;
            }

            public Builder completeRosters(int completeRosters) {
                this.completeRosters = completeRosters;
                return this;
            }

            public Builder incompleteRosters(int incompleteRosters) {
                this.incompleteRosters = incompleteRosters;
                return this;
            }

            public Builder rosterSummaries(List<RosterLockSummary> rosterSummaries) {
                this.rosterSummaries = rosterSummaries;
                return this;
            }

            public LockAllRostersResult build() {
                return new LockAllRostersResult(this);
            }
        }
    }
}
