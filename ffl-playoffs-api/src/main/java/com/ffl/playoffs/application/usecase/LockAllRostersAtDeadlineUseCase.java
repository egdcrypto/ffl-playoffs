package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.event.RosterLockedEvent;
import com.ffl.playoffs.domain.model.RosterLockStatus;
import com.ffl.playoffs.domain.port.RosterRepository;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Use case for locking all rosters in a league at the deadline.
 * This implements the one-time draft model where all rosters are permanently
 * locked when the roster deadline passes.
 *
 * Rosters with all positions filled receive LOCKED status.
 * Rosters with missing positions receive LOCKED_INCOMPLETE status.
 */
public class LockAllRostersAtDeadlineUseCase {

    private final RosterRepository rosterRepository;

    public LockAllRostersAtDeadlineUseCase(RosterRepository rosterRepository) {
        this.rosterRepository = rosterRepository;
    }

    /**
     * Locks all unlocked rosters in a league at the deadline.
     *
     * @param command The command containing league ID and lock time
     * @return Result containing lock summary and events
     */
    public LockAllRostersResult execute(LockAllRostersCommand command) {
        UUID leagueId = command.getLeagueId();
        LocalDateTime lockTime = command.getLockTime() != null
                ? command.getLockTime()
                : LocalDateTime.now();

        // Find all unlocked rosters in the league
        List<Roster> unlockedRosters = rosterRepository.findByLeagueIdAndLockStatus(
                leagueId, RosterLockStatus.UNLOCKED);

        if (unlockedRosters.isEmpty()) {
            return new LockAllRostersResult(
                    leagueId,
                    lockTime,
                    0, 0, 0,
                    List.of(),
                    "No unlocked rosters found"
            );
        }

        List<RosterLockedEvent> events = new ArrayList<>();
        int completeCount = 0;
        int incompleteCount = 0;

        // Lock each roster
        for (Roster roster : unlockedRosters) {
            RosterLockStatus lockStatus = roster.lockAtDeadline(lockTime);

            // Create domain event
            RosterLockedEvent event;
            if (lockStatus == RosterLockStatus.LOCKED) {
                completeCount++;
                event = RosterLockedEvent.forCompleteLock(
                        roster.getId(),
                        roster.getLeaguePlayerId(),
                        leagueId,
                        lockTime,
                        roster.getTotalSlotCount(),
                        true
                );
            } else {
                incompleteCount++;
                event = RosterLockedEvent.forIncompleteLock(
                        roster.getId(),
                        roster.getLeaguePlayerId(),
                        leagueId,
                        lockTime,
                        roster.getMissingPositions(),
                        roster.getFilledSlotCount(),
                        roster.getTotalSlotCount()
                );
            }
            events.add(event);
        }

        // Save all rosters
        rosterRepository.saveAll(unlockedRosters);

        return new LockAllRostersResult(
                leagueId,
                lockTime,
                unlockedRosters.size(),
                completeCount,
                incompleteCount,
                events,
                String.format("Locked %d rosters: %d complete, %d incomplete",
                        unlockedRosters.size(), completeCount, incompleteCount)
        );
    }

    /**
     * Command object for locking all rosters at deadline
     */
    public static class LockAllRostersCommand {
        private final UUID leagueId;
        private final LocalDateTime lockTime;

        public LockAllRostersCommand(UUID leagueId) {
            this(leagueId, null);
        }

        public LockAllRostersCommand(UUID leagueId, LocalDateTime lockTime) {
            this.leagueId = leagueId;
            this.lockTime = lockTime;
        }

        public UUID getLeagueId() {
            return leagueId;
        }

        public LocalDateTime getLockTime() {
            return lockTime;
        }
    }

    /**
     * Result object containing lock operation summary
     */
    public static class LockAllRostersResult {
        private final UUID leagueId;
        private final LocalDateTime lockedAt;
        private final int totalRostersLocked;
        private final int completeRostersCount;
        private final int incompleteRostersCount;
        private final List<RosterLockedEvent> events;
        private final String message;

        public LockAllRostersResult(
                UUID leagueId,
                LocalDateTime lockedAt,
                int totalRostersLocked,
                int completeRostersCount,
                int incompleteRostersCount,
                List<RosterLockedEvent> events,
                String message) {
            this.leagueId = leagueId;
            this.lockedAt = lockedAt;
            this.totalRostersLocked = totalRostersLocked;
            this.completeRostersCount = completeRostersCount;
            this.incompleteRostersCount = incompleteRostersCount;
            this.events = events;
            this.message = message;
        }

        public UUID getLeagueId() {
            return leagueId;
        }

        public LocalDateTime getLockedAt() {
            return lockedAt;
        }

        public int getTotalRostersLocked() {
            return totalRostersLocked;
        }

        public int getCompleteRostersCount() {
            return completeRostersCount;
        }

        public int getIncompleteRostersCount() {
            return incompleteRostersCount;
        }

        public List<RosterLockedEvent> getEvents() {
            return events;
        }

        public String getMessage() {
            return message;
        }

        public boolean hasIncompleteRosters() {
            return incompleteRostersCount > 0;
        }
    }
}
