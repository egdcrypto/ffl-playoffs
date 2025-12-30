package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.RosterLockStatus;
import com.ffl.playoffs.domain.port.RosterRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Use case for retrieving a roster lock status report for a league.
 * Provides administrators with visibility into roster lock status across all players.
 */
public class GetRosterLockStatusReportUseCase {

    private final RosterRepository rosterRepository;

    public GetRosterLockStatusReportUseCase(RosterRepository rosterRepository) {
        this.rosterRepository = rosterRepository;
    }

    /**
     * Generates a roster lock status report for a league.
     *
     * @param command The command containing league ID
     * @return Report with status counts and player details
     */
    public RosterLockStatusReport execute(GetReportCommand command) {
        UUID leagueId = command.getLeagueId();

        // Get all rosters in the league
        List<Roster> allRosters = rosterRepository.findByLeagueId(leagueId);

        if (allRosters.isEmpty()) {
            return new RosterLockStatusReport(
                    leagueId,
                    0, 0, 0, 0,
                    List.of(),
                    LocalDateTime.now()
            );
        }

        // Count by status
        Map<RosterLockStatus, Long> statusCounts = allRosters.stream()
                .collect(Collectors.groupingBy(
                        Roster::getLockStatus,
                        Collectors.counting()
                ));

        int unlockedCount = statusCounts.getOrDefault(RosterLockStatus.UNLOCKED, 0L).intValue();
        int lockedCount = statusCounts.getOrDefault(RosterLockStatus.LOCKED, 0L).intValue();
        int lockedIncompleteCount = statusCounts.getOrDefault(RosterLockStatus.LOCKED_INCOMPLETE, 0L).intValue();

        // Build player status details
        List<PlayerRosterStatus> playerStatuses = allRosters.stream()
                .map(roster -> new PlayerRosterStatus(
                        roster.getId(),
                        roster.getLeaguePlayerId(),
                        roster.getLockStatus(),
                        roster.isLocked(),
                        roster.getLockedAt(),
                        roster.getFilledSlotCount(),
                        roster.getTotalSlotCount(),
                        roster.getMissingPositions()
                ))
                .collect(Collectors.toList());

        return new RosterLockStatusReport(
                leagueId,
                allRosters.size(),
                unlockedCount,
                lockedCount,
                lockedIncompleteCount,
                playerStatuses,
                LocalDateTime.now()
        );
    }

    /**
     * Command object for getting report
     */
    public static class GetReportCommand {
        private final UUID leagueId;

        public GetReportCommand(UUID leagueId) {
            this.leagueId = leagueId;
        }

        public UUID getLeagueId() {
            return leagueId;
        }
    }

    /**
     * Individual player roster status
     */
    public static class PlayerRosterStatus {
        private final UUID rosterId;
        private final UUID leaguePlayerId;
        private final RosterLockStatus lockStatus;
        private final boolean isLocked;
        private final LocalDateTime lockedAt;
        private final int filledSlotCount;
        private final int totalSlotCount;
        private final List<Position> missingPositions;

        public PlayerRosterStatus(
                UUID rosterId,
                UUID leaguePlayerId,
                RosterLockStatus lockStatus,
                boolean isLocked,
                LocalDateTime lockedAt,
                int filledSlotCount,
                int totalSlotCount,
                List<Position> missingPositions) {
            this.rosterId = rosterId;
            this.leaguePlayerId = leaguePlayerId;
            this.lockStatus = lockStatus;
            this.isLocked = isLocked;
            this.lockedAt = lockedAt;
            this.filledSlotCount = filledSlotCount;
            this.totalSlotCount = totalSlotCount;
            this.missingPositions = missingPositions;
        }

        public UUID getRosterId() {
            return rosterId;
        }

        public UUID getLeaguePlayerId() {
            return leaguePlayerId;
        }

        public RosterLockStatus getLockStatus() {
            return lockStatus;
        }

        public boolean isLocked() {
            return isLocked;
        }

        public LocalDateTime getLockedAt() {
            return lockedAt;
        }

        public int getFilledSlotCount() {
            return filledSlotCount;
        }

        public int getTotalSlotCount() {
            return totalSlotCount;
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

        public String getCompletionPercentage() {
            if (totalSlotCount == 0) return "0%";
            int percentage = (filledSlotCount * 100) / totalSlotCount;
            return percentage + "%";
        }
    }

    /**
     * Complete report with status summary and player details
     */
    public static class RosterLockStatusReport {
        private final UUID leagueId;
        private final int totalRosters;
        private final int unlockedCount;
        private final int lockedCompleteCount;
        private final int lockedIncompleteCount;
        private final List<PlayerRosterStatus> playerStatuses;
        private final LocalDateTime generatedAt;

        public RosterLockStatusReport(
                UUID leagueId,
                int totalRosters,
                int unlockedCount,
                int lockedCompleteCount,
                int lockedIncompleteCount,
                List<PlayerRosterStatus> playerStatuses,
                LocalDateTime generatedAt) {
            this.leagueId = leagueId;
            this.totalRosters = totalRosters;
            this.unlockedCount = unlockedCount;
            this.lockedCompleteCount = lockedCompleteCount;
            this.lockedIncompleteCount = lockedIncompleteCount;
            this.playerStatuses = playerStatuses;
            this.generatedAt = generatedAt;
        }

        public UUID getLeagueId() {
            return leagueId;
        }

        public int getTotalRosters() {
            return totalRosters;
        }

        public int getUnlockedCount() {
            return unlockedCount;
        }

        public int getLockedCompleteCount() {
            return lockedCompleteCount;
        }

        public int getLockedIncompleteCount() {
            return lockedIncompleteCount;
        }

        public int getTotalLockedCount() {
            return lockedCompleteCount + lockedIncompleteCount;
        }

        public List<PlayerRosterStatus> getPlayerStatuses() {
            return playerStatuses;
        }

        public LocalDateTime getGeneratedAt() {
            return generatedAt;
        }

        /**
         * Returns only players with incomplete rosters
         */
        public List<PlayerRosterStatus> getIncompleteRosters() {
            return playerStatuses.stream()
                    .filter(PlayerRosterStatus::isIncomplete)
                    .collect(Collectors.toList());
        }

        /**
         * Returns only players with unlocked rosters
         */
        public List<PlayerRosterStatus> getUnlockedRosters() {
            return playerStatuses.stream()
                    .filter(status -> status.getLockStatus() == RosterLockStatus.UNLOCKED)
                    .collect(Collectors.toList());
        }

        /**
         * Checks if all rosters are locked
         */
        public boolean allRostersLocked() {
            return unlockedCount == 0;
        }

        /**
         * Gets the status message for display
         */
        public String getStatusMessage() {
            if (totalRosters == 0) {
                return "No rosters in this league";
            }
            if (allRostersLocked()) {
                if (lockedIncompleteCount > 0) {
                    return String.format("All rosters locked: %d complete, %d incomplete",
                            lockedCompleteCount, lockedIncompleteCount);
                }
                return String.format("All %d rosters locked and complete", totalRosters);
            }
            return String.format("%d of %d rosters still unlocked", unlockedCount, totalRosters);
        }
    }
}
