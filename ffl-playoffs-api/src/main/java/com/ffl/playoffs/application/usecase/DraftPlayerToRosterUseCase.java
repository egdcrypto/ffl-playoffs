package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.NFLPlayer;
import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.exception.RosterOperationException;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.RosterSlot;
import com.ffl.playoffs.domain.port.NFLPlayerRepository;
import com.ffl.playoffs.domain.port.RosterRepository;

import java.util.UUID;

/**
 * Use case for drafting an NFL player to a roster slot.
 *
 * ONE-TIME DRAFT MODEL:
 * - Players can only be drafted before first game starts
 * - Roster is permanently locked after first game
 * - Multiple league players CAN draft the same NFL player (no ownership)
 * - Position eligibility is validated (FLEX, SUPERFLEX rules)
 * - Duplicate players on same roster are not allowed
 */
public class DraftPlayerToRosterUseCase {

    private final RosterRepository rosterRepository;
    private final NFLPlayerRepository nflPlayerRepository;

    public DraftPlayerToRosterUseCase(
            RosterRepository rosterRepository,
            NFLPlayerRepository nflPlayerRepository) {
        this.rosterRepository = rosterRepository;
        this.nflPlayerRepository = nflPlayerRepository;
    }

    /**
     * Drafts an NFL player to a specific roster slot.
     *
     * @param command the draft command
     * @return the result of the draft operation
     * @throws RosterOperationException if the draft fails
     */
    public DraftResult execute(DraftCommand command) {
        // Find roster
        Roster roster = rosterRepository.findById(command.getRosterId())
                .orElseThrow(RosterOperationException::rosterNotFound);

        // Check roster is not locked (one-time draft model)
        if (roster.isLocked()) {
            throw RosterOperationException.rosterPermanentlyLocked();
        }

        // Find the slot
        RosterSlot slot = roster.getSlots().stream()
                .filter(s -> s.getId().equals(command.getSlotId()))
                .findFirst()
                .orElseThrow(() -> RosterOperationException.slotNotFound(command.getSlotId().toString()));

        // Find NFL player
        NFLPlayer player = nflPlayerRepository.findById(command.getNflPlayerId())
                .orElseThrow(() -> RosterOperationException.playerNotFound(command.getNflPlayerId()));

        // Validate player is active
        String playerStatus = player.getStatus();
        boolean hasWarning = false;
        String warningMessage = null;

        if ("RETIRED".equalsIgnoreCase(playerStatus) || "INACTIVE".equalsIgnoreCase(playerStatus)) {
            throw RosterOperationException.playerInactive(player.getName(), playerStatus);
        }

        if ("INJURED_RESERVE".equalsIgnoreCase(playerStatus) || "IR".equalsIgnoreCase(playerStatus)) {
            hasWarning = true;
            warningMessage = String.format("%s is on Injured Reserve and may not play", player.getName());
        }

        // Check if player is already on roster
        if (roster.hasPlayer(command.getNflPlayerId())) {
            String existingPosition = roster.getSlots().stream()
                    .filter(s -> s.isFilled() && s.getNflPlayerId().equals(command.getNflPlayerId()))
                    .map(s -> s.getPosition().name())
                    .findFirst()
                    .orElse("UNKNOWN");
            throw RosterOperationException.playerAlreadyDrafted(player.getName(), existingPosition);
        }

        // Validate position eligibility
        if (!Position.canFillSlot(player.getPosition(), slot.getPosition())) {
            if (slot.getPosition() == Position.FLEX) {
                throw RosterOperationException.notEligibleForFlex(player.getPosition().name());
            } else if (slot.getPosition() == Position.SUPERFLEX) {
                throw RosterOperationException.notEligibleForSuperflex(player.getPosition().name());
            } else {
                throw RosterOperationException.positionMismatch(
                        player.getName(),
                        player.getPosition().name(),
                        slot.getPosition().name()
                );
            }
        }

        // Clear slot if already filled (replacement)
        if (slot.isFilled()) {
            slot.clearPlayer();
        }

        // Assign player to slot
        slot.assignPlayer(command.getNflPlayerId(), player.getPosition());

        // Save roster
        Roster savedRoster = rosterRepository.save(roster);

        return DraftResult.builder()
                .success(true)
                .rosterId(savedRoster.getId())
                .slotId(slot.getId())
                .nflPlayerId(player.getId())
                .playerName(player.getName())
                .playerPosition(player.getPosition())
                .slotPosition(slot.getPosition())
                .rosterCompletion(String.format("%d/%d", savedRoster.getFilledSlotCount(), savedRoster.getTotalSlotCount()))
                .isRosterComplete(savedRoster.isComplete())
                .hasWarning(hasWarning)
                .warningMessage(warningMessage)
                .build();
    }

    /**
     * Command for drafting a player
     */
    public static class DraftCommand {
        private final UUID rosterId;
        private final UUID slotId;
        private final Long nflPlayerId;

        public DraftCommand(UUID rosterId, UUID slotId, Long nflPlayerId) {
            this.rosterId = rosterId;
            this.slotId = slotId;
            this.nflPlayerId = nflPlayerId;
        }

        public UUID getRosterId() {
            return rosterId;
        }

        public UUID getSlotId() {
            return slotId;
        }

        public Long getNflPlayerId() {
            return nflPlayerId;
        }

        public static Builder builder() {
            return new Builder();
        }

        public static class Builder {
            private UUID rosterId;
            private UUID slotId;
            private Long nflPlayerId;

            public Builder rosterId(UUID rosterId) {
                this.rosterId = rosterId;
                return this;
            }

            public Builder slotId(UUID slotId) {
                this.slotId = slotId;
                return this;
            }

            public Builder nflPlayerId(Long nflPlayerId) {
                this.nflPlayerId = nflPlayerId;
                return this;
            }

            public DraftCommand build() {
                return new DraftCommand(rosterId, slotId, nflPlayerId);
            }
        }
    }

    /**
     * Result of a draft operation
     */
    public static class DraftResult {
        private final boolean success;
        private final UUID rosterId;
        private final UUID slotId;
        private final Long nflPlayerId;
        private final String playerName;
        private final Position playerPosition;
        private final Position slotPosition;
        private final String rosterCompletion;
        private final boolean isRosterComplete;
        private final boolean hasWarning;
        private final String warningMessage;

        private DraftResult(Builder builder) {
            this.success = builder.success;
            this.rosterId = builder.rosterId;
            this.slotId = builder.slotId;
            this.nflPlayerId = builder.nflPlayerId;
            this.playerName = builder.playerName;
            this.playerPosition = builder.playerPosition;
            this.slotPosition = builder.slotPosition;
            this.rosterCompletion = builder.rosterCompletion;
            this.isRosterComplete = builder.isRosterComplete;
            this.hasWarning = builder.hasWarning;
            this.warningMessage = builder.warningMessage;
        }

        public boolean isSuccess() {
            return success;
        }

        public UUID getRosterId() {
            return rosterId;
        }

        public UUID getSlotId() {
            return slotId;
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

        public Position getSlotPosition() {
            return slotPosition;
        }

        public String getRosterCompletion() {
            return rosterCompletion;
        }

        public boolean isRosterComplete() {
            return isRosterComplete;
        }

        public boolean hasWarning() {
            return hasWarning;
        }

        public String getWarningMessage() {
            return warningMessage;
        }

        public static Builder builder() {
            return new Builder();
        }

        public static class Builder {
            private boolean success;
            private UUID rosterId;
            private UUID slotId;
            private Long nflPlayerId;
            private String playerName;
            private Position playerPosition;
            private Position slotPosition;
            private String rosterCompletion;
            private boolean isRosterComplete;
            private boolean hasWarning;
            private String warningMessage;

            public Builder success(boolean success) {
                this.success = success;
                return this;
            }

            public Builder rosterId(UUID rosterId) {
                this.rosterId = rosterId;
                return this;
            }

            public Builder slotId(UUID slotId) {
                this.slotId = slotId;
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

            public Builder slotPosition(Position slotPosition) {
                this.slotPosition = slotPosition;
                return this;
            }

            public Builder rosterCompletion(String rosterCompletion) {
                this.rosterCompletion = rosterCompletion;
                return this;
            }

            public Builder isRosterComplete(boolean isRosterComplete) {
                this.isRosterComplete = isRosterComplete;
                return this;
            }

            public Builder hasWarning(boolean hasWarning) {
                this.hasWarning = hasWarning;
                return this;
            }

            public Builder warningMessage(String warningMessage) {
                this.warningMessage = warningMessage;
                return this;
            }

            public DraftResult build() {
                return new DraftResult(this);
            }
        }
    }
}
