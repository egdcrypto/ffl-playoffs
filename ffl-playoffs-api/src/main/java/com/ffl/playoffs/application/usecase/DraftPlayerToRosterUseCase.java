package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.NFLPlayer;
import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.exception.RosterOperationException;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.RosterSlot;
import com.ffl.playoffs.domain.port.NFLPlayerRepository;
import com.ffl.playoffs.domain.port.RosterRepository;

import java.util.List;
import java.util.UUID;

/**
 * Use case for drafting an NFL player to a roster slot.
 * Implements the one-time draft model where players are selected before the season starts.
 *
 * Key rules:
 * - Players can be drafted to standard position slots or FLEX/SUPERFLEX
 * - Position eligibility is validated (e.g., QB can't go in FLEX but can in SUPERFLEX)
 * - Same player cannot be drafted twice to different positions on same roster
 * - Multiple league players CAN draft the same NFL player (no ownership model)
 * - Roster must not be locked (first game hasn't started)
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
                .orElseThrow(() -> new RosterOperationException(
                        RosterOperationException.ErrorCode.ROSTER_NOT_FOUND,
                        "Roster not found"));

        // Check roster is not locked
        if (roster.isLocked()) {
            throw RosterOperationException.rosterLocked();
        }

        // Find NFL player
        NFLPlayer nflPlayer = nflPlayerRepository.findById(command.getNflPlayerId())
                .orElseThrow(() -> RosterOperationException.playerNotFound(command.getNflPlayerId()));

        // Validate player is active (allow IR players with warning)
        String playerStatus = nflPlayer.getStatus();
        boolean hasWarning = false;
        String warningMessage = null;

        if ("RETIRED".equalsIgnoreCase(playerStatus) || "INACTIVE".equalsIgnoreCase(playerStatus)) {
            throw RosterOperationException.playerInactive(nflPlayer.getName(), playerStatus);
        }

        if ("INJURED_RESERVE".equalsIgnoreCase(playerStatus) || "IR".equalsIgnoreCase(playerStatus)) {
            hasWarning = true;
            warningMessage = String.format("%s is on Injured Reserve", nflPlayer.getName());
        }

        // Check if player is already on roster
        if (roster.hasPlayer(command.getNflPlayerId())) {
            String existingPosition = findPlayerPosition(roster, command.getNflPlayerId());
            throw RosterOperationException.playerAlreadyDrafted(nflPlayer.getName(), existingPosition);
        }

        // Find target slot
        RosterSlot targetSlot = findAvailableSlot(roster, command.getSlotPosition());
        if (targetSlot == null) {
            throw RosterOperationException.positionLimitExceeded(
                    command.getSlotPosition().name(),
                    countFilledSlots(roster, command.getSlotPosition()),
                    countTotalSlots(roster, command.getSlotPosition())
            );
        }

        // Validate position eligibility
        validatePositionEligibility(nflPlayer, command.getSlotPosition());

        // Assign player to slot
        targetSlot.assignPlayer(command.getNflPlayerId(), nflPlayer.getPosition());

        // Save roster
        Roster savedRoster = rosterRepository.save(roster);

        // Build result
        return DraftResult.builder()
                .success(true)
                .rosterId(savedRoster.getId())
                .slotId(targetSlot.getId())
                .nflPlayerId(nflPlayer.getId())
                .playerName(nflPlayer.getName())
                .slotPosition(command.getSlotPosition())
                .rosterCompletion(String.format("%d/%d", savedRoster.getFilledSlotCount(), savedRoster.getTotalSlotCount()))
                .hasWarning(hasWarning)
                .warningMessage(warningMessage)
                .build();
    }

    /**
     * Find the position where a player is already drafted
     */
    private String findPlayerPosition(Roster roster, Long nflPlayerId) {
        return roster.getSlots().stream()
                .filter(slot -> slot.isFilled() && slot.getNflPlayerId().equals(nflPlayerId))
                .map(slot -> slot.getPosition().name())
                .findFirst()
                .orElse("UNKNOWN");
    }

    /**
     * Find an available slot for the given position
     */
    private RosterSlot findAvailableSlot(Roster roster, Position slotPosition) {
        return roster.getSlots().stream()
                .filter(slot -> slot.getPosition() == slotPosition && slot.isEmpty())
                .findFirst()
                .orElse(null);
    }

    /**
     * Count filled slots for a position
     */
    private int countFilledSlots(Roster roster, Position position) {
        return (int) roster.getSlots().stream()
                .filter(slot -> slot.getPosition() == position && slot.isFilled())
                .count();
    }

    /**
     * Count total slots for a position
     */
    private int countTotalSlots(Roster roster, Position position) {
        return (int) roster.getSlots().stream()
                .filter(slot -> slot.getPosition() == position)
                .count();
    }

    /**
     * Validate that the player's position can fill the slot
     */
    private void validatePositionEligibility(NFLPlayer player, Position slotPosition) {
        Position playerPosition = player.getPosition();

        // Check if player position can fill slot
        if (!Position.canFillSlot(playerPosition, slotPosition)) {
            if (slotPosition == Position.FLEX) {
                throw RosterOperationException.notEligibleForFlex(playerPosition.name());
            } else if (slotPosition == Position.SUPERFLEX) {
                throw RosterOperationException.notEligibleForSuperflex(playerPosition.name());
            } else {
                throw RosterOperationException.positionMismatch(
                        player.getName(),
                        playerPosition.name(),
                        slotPosition.name()
                );
            }
        }
    }

    /**
     * Command for drafting a player
     */
    public static class DraftCommand {
        private final UUID rosterId;
        private final Long nflPlayerId;
        private final Position slotPosition;

        public DraftCommand(UUID rosterId, Long nflPlayerId, Position slotPosition) {
            this.rosterId = rosterId;
            this.nflPlayerId = nflPlayerId;
            this.slotPosition = slotPosition;
        }

        public UUID getRosterId() {
            return rosterId;
        }

        public Long getNflPlayerId() {
            return nflPlayerId;
        }

        public Position getSlotPosition() {
            return slotPosition;
        }

        public static DraftCommandBuilder builder() {
            return new DraftCommandBuilder();
        }

        public static class DraftCommandBuilder {
            private UUID rosterId;
            private Long nflPlayerId;
            private Position slotPosition;

            public DraftCommandBuilder rosterId(UUID rosterId) {
                this.rosterId = rosterId;
                return this;
            }

            public DraftCommandBuilder nflPlayerId(Long nflPlayerId) {
                this.nflPlayerId = nflPlayerId;
                return this;
            }

            public DraftCommandBuilder slotPosition(Position slotPosition) {
                this.slotPosition = slotPosition;
                return this;
            }

            public DraftCommand build() {
                return new DraftCommand(rosterId, nflPlayerId, slotPosition);
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
        private final Position slotPosition;
        private final String rosterCompletion;
        private final boolean hasWarning;
        private final String warningMessage;

        private DraftResult(Builder builder) {
            this.success = builder.success;
            this.rosterId = builder.rosterId;
            this.slotId = builder.slotId;
            this.nflPlayerId = builder.nflPlayerId;
            this.playerName = builder.playerName;
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

        public Long getNflPlayerId() {
            return nflPlayerId;
        }

        public String getPlayerName() {
            return playerName;
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
            private Long nflPlayerId;
            private String playerName;
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

            public Builder nflPlayerId(Long nflPlayerId) {
                this.nflPlayerId = nflPlayerId;
                return this;
            }

            public Builder playerName(String playerName) {
                this.playerName = playerName;
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

            public DraftResult build() {
                return new DraftResult(this);
            }
        }
    }
}
