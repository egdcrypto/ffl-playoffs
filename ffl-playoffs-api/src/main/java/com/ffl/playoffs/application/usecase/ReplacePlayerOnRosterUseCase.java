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
 * Use case for replacing an NFL player with another on the roster.
 * Combines drop and draft in a single atomic operation.
 * Only allowed before roster is locked (first game starts).
 *
 * Key rules:
 * - Player can only be replaced before roster deadline
 * - New player must be eligible for the slot position
 * - New player cannot already be on the roster
 * - The replaced player remains available for all league players
 */
public class ReplacePlayerOnRosterUseCase {

    private final RosterRepository rosterRepository;
    private final NFLPlayerRepository nflPlayerRepository;

    public ReplacePlayerOnRosterUseCase(
            RosterRepository rosterRepository,
            NFLPlayerRepository nflPlayerRepository) {
        this.rosterRepository = rosterRepository;
        this.nflPlayerRepository = nflPlayerRepository;
    }

    /**
     * Replaces an NFL player with another on the roster.
     *
     * @param command the replace command
     * @return the result of the replace operation
     * @throws RosterOperationException if the replace fails
     */
    public ReplaceResult execute(ReplaceCommand command) {
        // Find roster
        Roster roster = rosterRepository.findById(command.getRosterId())
                .orElseThrow(() -> new RosterOperationException(
                        RosterOperationException.ErrorCode.ROSTER_NOT_FOUND,
                        "Roster not found"));

        // Check roster is not locked
        if (roster.isLocked()) {
            throw RosterOperationException.rosterLocked();
        }

        // Find slot with the player to drop
        RosterSlot slot = roster.getSlots().stream()
                .filter(s -> s.isFilled() && s.getNflPlayerId().equals(command.getDropPlayerId()))
                .findFirst()
                .orElseThrow(() -> new RosterOperationException(
                        RosterOperationException.ErrorCode.PLAYER_NOT_FOUND,
                        "Player to replace not found on roster"));

        // Find new NFL player
        NFLPlayer newPlayer = nflPlayerRepository.findById(command.getAddPlayerId())
                .orElseThrow(() -> RosterOperationException.playerNotFound(command.getAddPlayerId()));

        // Validate new player is active
        String playerStatus = newPlayer.getStatus();
        boolean hasWarning = false;
        String warningMessage = null;

        if ("RETIRED".equalsIgnoreCase(playerStatus) || "INACTIVE".equalsIgnoreCase(playerStatus)) {
            throw RosterOperationException.playerInactive(newPlayer.getName(), playerStatus);
        }

        if ("INJURED_RESERVE".equalsIgnoreCase(playerStatus) || "IR".equalsIgnoreCase(playerStatus)) {
            hasWarning = true;
            warningMessage = String.format("%s is on Injured Reserve", newPlayer.getName());
        }

        // Check if new player is already on roster (but not in the slot we're replacing)
        boolean playerAlreadyOnRoster = roster.getSlots().stream()
                .filter(s -> !s.getId().equals(slot.getId()))
                .anyMatch(s -> s.isFilled() && s.getNflPlayerId().equals(command.getAddPlayerId()));

        if (playerAlreadyOnRoster) {
            String existingPosition = roster.getSlots().stream()
                    .filter(s -> s.isFilled() && s.getNflPlayerId().equals(command.getAddPlayerId()))
                    .map(s -> s.getPosition().name())
                    .findFirst()
                    .orElse("UNKNOWN");
            throw RosterOperationException.playerAlreadyDrafted(newPlayer.getName(), existingPosition);
        }

        // Validate new player's position eligibility for the slot
        if (!Position.canFillSlot(newPlayer.getPosition(), slot.getPosition())) {
            if (slot.getPosition() == Position.FLEX) {
                throw RosterOperationException.notEligibleForFlex(newPlayer.getPosition().name());
            } else if (slot.getPosition() == Position.SUPERFLEX) {
                throw RosterOperationException.notEligibleForSuperflex(newPlayer.getPosition().name());
            } else {
                throw RosterOperationException.positionMismatch(
                        newPlayer.getName(),
                        newPlayer.getPosition().name(),
                        slot.getPosition().name()
                );
            }
        }

        // Perform the replacement
        Long droppedPlayerId = slot.getNflPlayerId();
        slot.clearPlayer();
        slot.assignPlayer(command.getAddPlayerId(), newPlayer.getPosition());

        // Save roster
        Roster savedRoster = rosterRepository.save(roster);

        return ReplaceResult.builder()
                .success(true)
                .rosterId(savedRoster.getId())
                .slotId(slot.getId())
                .droppedPlayerId(droppedPlayerId)
                .addedPlayerId(newPlayer.getId())
                .addedPlayerName(newPlayer.getName())
                .slotPosition(slot.getPosition())
                .rosterCompletion(String.format("%d/%d", savedRoster.getFilledSlotCount(), savedRoster.getTotalSlotCount()))
                .hasWarning(hasWarning)
                .warningMessage(warningMessage)
                .build();
    }

    /**
     * Command for replacing a player
     */
    public static class ReplaceCommand {
        private final UUID rosterId;
        private final Long dropPlayerId;
        private final Long addPlayerId;

        public ReplaceCommand(UUID rosterId, Long dropPlayerId, Long addPlayerId) {
            this.rosterId = rosterId;
            this.dropPlayerId = dropPlayerId;
            this.addPlayerId = addPlayerId;
        }

        public UUID getRosterId() {
            return rosterId;
        }

        public Long getDropPlayerId() {
            return dropPlayerId;
        }

        public Long getAddPlayerId() {
            return addPlayerId;
        }

        public static ReplaceCommandBuilder builder() {
            return new ReplaceCommandBuilder();
        }

        public static class ReplaceCommandBuilder {
            private UUID rosterId;
            private Long dropPlayerId;
            private Long addPlayerId;

            public ReplaceCommandBuilder rosterId(UUID rosterId) {
                this.rosterId = rosterId;
                return this;
            }

            public ReplaceCommandBuilder dropPlayerId(Long dropPlayerId) {
                this.dropPlayerId = dropPlayerId;
                return this;
            }

            public ReplaceCommandBuilder addPlayerId(Long addPlayerId) {
                this.addPlayerId = addPlayerId;
                return this;
            }

            public ReplaceCommand build() {
                return new ReplaceCommand(rosterId, dropPlayerId, addPlayerId);
            }
        }
    }

    /**
     * Result of a replace operation
     */
    public static class ReplaceResult {
        private final boolean success;
        private final UUID rosterId;
        private final UUID slotId;
        private final Long droppedPlayerId;
        private final Long addedPlayerId;
        private final String addedPlayerName;
        private final Position slotPosition;
        private final String rosterCompletion;
        private final boolean hasWarning;
        private final String warningMessage;

        private ReplaceResult(Builder builder) {
            this.success = builder.success;
            this.rosterId = builder.rosterId;
            this.slotId = builder.slotId;
            this.droppedPlayerId = builder.droppedPlayerId;
            this.addedPlayerId = builder.addedPlayerId;
            this.addedPlayerName = builder.addedPlayerName;
            this.slotPosition = builder.slotPosition;
            this.rosterCompletion = builder.rosterCompletion;
            this.hasWarning = builder.hasWarning;
            this.warningMessage = builder.warningMessage;
        }

        public static Builder builder() {
            return new Builder();
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

        public Long getDroppedPlayerId() {
            return droppedPlayerId;
        }

        public Long getAddedPlayerId() {
            return addedPlayerId;
        }

        public String getAddedPlayerName() {
            return addedPlayerName;
        }

        public Position getSlotPosition() {
            return slotPosition;
        }

        public String getRosterCompletion() {
            return rosterCompletion;
        }

        public boolean hasWarning() {
            return hasWarning;
        }

        public String getWarningMessage() {
            return warningMessage;
        }

        public static class Builder {
            private boolean success;
            private UUID rosterId;
            private UUID slotId;
            private Long droppedPlayerId;
            private Long addedPlayerId;
            private String addedPlayerName;
            private Position slotPosition;
            private String rosterCompletion;
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

            public Builder droppedPlayerId(Long droppedPlayerId) {
                this.droppedPlayerId = droppedPlayerId;
                return this;
            }

            public Builder addedPlayerId(Long addedPlayerId) {
                this.addedPlayerId = addedPlayerId;
                return this;
            }

            public Builder addedPlayerName(String addedPlayerName) {
                this.addedPlayerName = addedPlayerName;
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

            public Builder hasWarning(boolean hasWarning) {
                this.hasWarning = hasWarning;
                return this;
            }

            public Builder warningMessage(String warningMessage) {
                this.warningMessage = warningMessage;
                return this;
            }

            public ReplaceResult build() {
                return new ReplaceResult(this);
            }
        }
    }
}
