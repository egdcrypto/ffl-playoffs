package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.NFLPlayer;
import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.exception.RosterOperationException;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.RosterSlot;
import com.ffl.playoffs.domain.port.NFLPlayerRepository;
import com.ffl.playoffs.domain.port.RosterRepository;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Use case for retrieving roster details including player information.
 * Provides complete roster status for display in UI.
 */
public class GetRosterDetailsUseCase {

    private final RosterRepository rosterRepository;
    private final NFLPlayerRepository nflPlayerRepository;

    public GetRosterDetailsUseCase(
            RosterRepository rosterRepository,
            NFLPlayerRepository nflPlayerRepository) {
        this.rosterRepository = rosterRepository;
        this.nflPlayerRepository = nflPlayerRepository;
    }

    /**
     * Gets detailed roster information including player data.
     *
     * @param command the query command
     * @return detailed roster information
     * @throws RosterOperationException if roster not found
     */
    public RosterDetails execute(GetRosterCommand command) {
        // Find roster
        Roster roster = rosterRepository.findById(command.getRosterId())
                .orElseThrow(() -> new RosterOperationException(
                        RosterOperationException.ErrorCode.ROSTER_NOT_FOUND,
                        "Roster not found"));

        // Get player IDs from slots
        Set<Long> playerIds = roster.getSlots().stream()
                .filter(RosterSlot::isFilled)
                .map(RosterSlot::getNflPlayerId)
                .collect(Collectors.toSet());

        // Fetch player details
        Map<Long, NFLPlayer> playersMap = new HashMap<>();
        for (Long playerId : playerIds) {
            nflPlayerRepository.findById(playerId).ifPresent(p -> playersMap.put(playerId, p));
        }

        // Build slot details
        List<SlotDetail> slotDetails = roster.getSlots().stream()
                .map(slot -> buildSlotDetail(slot, playersMap))
                .collect(Collectors.toList());

        // Calculate completion
        int filledSlots = roster.getFilledSlotCount();
        int totalSlots = roster.getTotalSlotCount();
        String completion = String.format("%d/%d", filledSlots, totalSlots);

        // Determine status
        RosterStatus status;
        if (roster.isComplete()) {
            status = RosterStatus.READY;
        } else if (roster.isLocked()) {
            status = RosterStatus.INCOMPLETE_LOCKED;
        } else {
            status = RosterStatus.INCOMPLETE;
        }

        // Build lock warning if applicable
        String lockWarning = null;
        String timeUntilLock = null;
        if (!roster.isLocked() && roster.getRosterDeadline() != null) {
            LocalDateTime now = LocalDateTime.now();
            if (now.isBefore(roster.getRosterDeadline())) {
                Duration duration = Duration.between(now, roster.getRosterDeadline());
                long hours = duration.toHours();
                long minutes = duration.toMinutesPart();

                if (hours < 24) {
                    timeUntilLock = String.format("%d hours %d minutes", hours, minutes);
                    lockWarning = String.format("PERMANENT ROSTER LOCK in %s", timeUntilLock);
                }
            }
        }

        return RosterDetails.builder()
                .rosterId(roster.getId())
                .leaguePlayerId(roster.getLeaguePlayerId())
                .gameId(roster.getGameId())
                .slots(slotDetails)
                .completion(completion)
                .filledSlots(filledSlots)
                .totalSlots(totalSlots)
                .status(status)
                .isLocked(roster.isLocked())
                .lockedAt(roster.getLockedAt())
                .rosterDeadline(roster.getRosterDeadline())
                .lockWarning(lockWarning)
                .timeUntilLock(timeUntilLock)
                .build();
    }

    /**
     * Build slot detail from roster slot and player data
     */
    private SlotDetail buildSlotDetail(RosterSlot slot, Map<Long, NFLPlayer> playersMap) {
        SlotDetail.Builder builder = SlotDetail.builder()
                .slotId(slot.getId())
                .position(slot.getPosition())
                .slotLabel(slot.getSlotLabel())
                .slotOrder(slot.getSlotOrder())
                .isFilled(slot.isFilled());

        if (slot.isFilled() && playersMap.containsKey(slot.getNflPlayerId())) {
            NFLPlayer player = playersMap.get(slot.getNflPlayerId());
            builder.nflPlayerId(player.getId())
                    .playerName(player.getName())
                    .playerPosition(player.getPosition())
                    .playerTeam(player.getNflTeamAbbreviation())
                    .playerStatus(player.getStatus());
        }

        return builder.build();
    }

    /**
     * Command for getting roster details
     */
    public static class GetRosterCommand {
        private final UUID rosterId;

        public GetRosterCommand(UUID rosterId) {
            this.rosterId = rosterId;
        }

        public UUID getRosterId() {
            return rosterId;
        }
    }

    /**
     * Roster status enum
     */
    public enum RosterStatus {
        READY,           // Complete and ready
        INCOMPLETE,      // Has empty slots
        INCOMPLETE_LOCKED // Incomplete but locked
    }

    /**
     * Detailed slot information
     */
    public static class SlotDetail {
        private final UUID slotId;
        private final Position position;
        private final String slotLabel;
        private final Integer slotOrder;
        private final boolean isFilled;
        private final Long nflPlayerId;
        private final String playerName;
        private final Position playerPosition;
        private final String playerTeam;
        private final String playerStatus;

        private SlotDetail(Builder builder) {
            this.slotId = builder.slotId;
            this.position = builder.position;
            this.slotLabel = builder.slotLabel;
            this.slotOrder = builder.slotOrder;
            this.isFilled = builder.isFilled;
            this.nflPlayerId = builder.nflPlayerId;
            this.playerName = builder.playerName;
            this.playerPosition = builder.playerPosition;
            this.playerTeam = builder.playerTeam;
            this.playerStatus = builder.playerStatus;
        }

        public static Builder builder() {
            return new Builder();
        }

        public UUID getSlotId() {
            return slotId;
        }

        public Position getPosition() {
            return position;
        }

        public String getSlotLabel() {
            return slotLabel;
        }

        public Integer getSlotOrder() {
            return slotOrder;
        }

        public boolean isFilled() {
            return isFilled;
        }

        public Long getNflPlayerId() {
            return nflPlayerId;
        }

        public String getPlayerName() {
            return playerName;
        }

        public Position getPlayerPosition() {
            return playerPosition;
        }

        public String getPlayerTeam() {
            return playerTeam;
        }

        public String getPlayerStatus() {
            return playerStatus;
        }

        public static class Builder {
            private UUID slotId;
            private Position position;
            private String slotLabel;
            private Integer slotOrder;
            private boolean isFilled;
            private Long nflPlayerId;
            private String playerName;
            private Position playerPosition;
            private String playerTeam;
            private String playerStatus;

            public Builder slotId(UUID slotId) {
                this.slotId = slotId;
                return this;
            }

            public Builder position(Position position) {
                this.position = position;
                return this;
            }

            public Builder slotLabel(String slotLabel) {
                this.slotLabel = slotLabel;
                return this;
            }

            public Builder slotOrder(Integer slotOrder) {
                this.slotOrder = slotOrder;
                return this;
            }

            public Builder isFilled(boolean isFilled) {
                this.isFilled = isFilled;
                return this;
            }

            public Builder nflPlayerId(Long nflPlayerId) {
                this.nflPlayerId = nflPlayerId;
                return this;
            }

            public Builder playerName(String playerName) {
                this.playerName = playerName;
                return this;
            }

            public Builder playerPosition(Position playerPosition) {
                this.playerPosition = playerPosition;
                return this;
            }

            public Builder playerTeam(String playerTeam) {
                this.playerTeam = playerTeam;
                return this;
            }

            public Builder playerStatus(String playerStatus) {
                this.playerStatus = playerStatus;
                return this;
            }

            public SlotDetail build() {
                return new SlotDetail(this);
            }
        }
    }

    /**
     * Complete roster details
     */
    public static class RosterDetails {
        private final UUID rosterId;
        private final UUID leaguePlayerId;
        private final UUID gameId;
        private final List<SlotDetail> slots;
        private final String completion;
        private final int filledSlots;
        private final int totalSlots;
        private final RosterStatus status;
        private final boolean isLocked;
        private final LocalDateTime lockedAt;
        private final LocalDateTime rosterDeadline;
        private final String lockWarning;
        private final String timeUntilLock;

        private RosterDetails(Builder builder) {
            this.rosterId = builder.rosterId;
            this.leaguePlayerId = builder.leaguePlayerId;
            this.gameId = builder.gameId;
            this.slots = builder.slots;
            this.completion = builder.completion;
            this.filledSlots = builder.filledSlots;
            this.totalSlots = builder.totalSlots;
            this.status = builder.status;
            this.isLocked = builder.isLocked;
            this.lockedAt = builder.lockedAt;
            this.rosterDeadline = builder.rosterDeadline;
            this.lockWarning = builder.lockWarning;
            this.timeUntilLock = builder.timeUntilLock;
        }

        public static Builder builder() {
            return new Builder();
        }

        public UUID getRosterId() {
            return rosterId;
        }

        public UUID getLeaguePlayerId() {
            return leaguePlayerId;
        }

        public UUID getGameId() {
            return gameId;
        }

        public List<SlotDetail> getSlots() {
            return slots;
        }

        public String getCompletion() {
            return completion;
        }

        public int getFilledSlots() {
            return filledSlots;
        }

        public int getTotalSlots() {
            return totalSlots;
        }

        public RosterStatus getStatus() {
            return status;
        }

        public boolean isLocked() {
            return isLocked;
        }

        public LocalDateTime getLockedAt() {
            return lockedAt;
        }

        public LocalDateTime getRosterDeadline() {
            return rosterDeadline;
        }

        public String getLockWarning() {
            return lockWarning;
        }

        public String getTimeUntilLock() {
            return timeUntilLock;
        }

        public static class Builder {
            private UUID rosterId;
            private UUID leaguePlayerId;
            private UUID gameId;
            private List<SlotDetail> slots = new ArrayList<>();
            private String completion;
            private int filledSlots;
            private int totalSlots;
            private RosterStatus status;
            private boolean isLocked;
            private LocalDateTime lockedAt;
            private LocalDateTime rosterDeadline;
            private String lockWarning;
            private String timeUntilLock;

            public Builder rosterId(UUID rosterId) {
                this.rosterId = rosterId;
                return this;
            }

            public Builder leaguePlayerId(UUID leaguePlayerId) {
                this.leaguePlayerId = leaguePlayerId;
                return this;
            }

            public Builder gameId(UUID gameId) {
                this.gameId = gameId;
                return this;
            }

            public Builder slots(List<SlotDetail> slots) {
                this.slots = slots;
                return this;
            }

            public Builder completion(String completion) {
                this.completion = completion;
                return this;
            }

            public Builder filledSlots(int filledSlots) {
                this.filledSlots = filledSlots;
                return this;
            }

            public Builder totalSlots(int totalSlots) {
                this.totalSlots = totalSlots;
                return this;
            }

            public Builder status(RosterStatus status) {
                this.status = status;
                return this;
            }

            public Builder isLocked(boolean isLocked) {
                this.isLocked = isLocked;
                return this;
            }

            public Builder lockedAt(LocalDateTime lockedAt) {
                this.lockedAt = lockedAt;
                return this;
            }

            public Builder rosterDeadline(LocalDateTime rosterDeadline) {
                this.rosterDeadline = rosterDeadline;
                return this;
            }

            public Builder lockWarning(String lockWarning) {
                this.lockWarning = lockWarning;
                return this;
            }

            public Builder timeUntilLock(String timeUntilLock) {
                this.timeUntilLock = timeUntilLock;
                return this;
            }

            public RosterDetails build() {
                return new RosterDetails(this);
            }
        }
    }
}
