package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.exception.RosterOperationException;
import com.ffl.playoffs.domain.model.RosterSlot;
import com.ffl.playoffs.domain.port.RosterRepository;

import java.util.UUID;

/**
 * Use case for dropping an NFL player from a roster slot.
 * Only allowed before roster is locked (first game starts).
 *
 * Key rules:
 * - Player can only be dropped before roster deadline
 * - Once first game starts, roster is permanently locked
 * - Dropping a player frees the slot for another selection
 * - The dropped player remains available for all league players
 */
public class DropPlayerFromRosterUseCase {

    private final RosterRepository rosterRepository;

    public DropPlayerFromRosterUseCase(RosterRepository rosterRepository) {
        this.rosterRepository = rosterRepository;
    }

    /**
     * Drops an NFL player from the roster.
     *
     * @param command the drop command
     * @return the result of the drop operation
     * @throws RosterOperationException if the drop fails
     */
    public DropResult execute(DropCommand command) {
        // Find roster
        Roster roster = rosterRepository.findById(command.getRosterId())
                .orElseThrow(() -> new RosterOperationException(
                        RosterOperationException.ErrorCode.ROSTER_NOT_FOUND,
                        "Roster not found"));

        // Check roster is not locked
        if (roster.isLocked()) {
            throw RosterOperationException.rosterLocked();
        }

        // Find slot with the player
        RosterSlot slot = roster.getSlots().stream()
                .filter(s -> s.isFilled() && s.getNflPlayerId().equals(command.getNflPlayerId()))
                .findFirst()
                .orElseThrow(() -> new RosterOperationException(
                        RosterOperationException.ErrorCode.PLAYER_NOT_FOUND,
                        "Player not found on roster"));

        // Store position for result
        String droppedFromPosition = slot.getPosition().name();

        // Clear the slot
        slot.clearPlayer();

        // Save roster
        Roster savedRoster = rosterRepository.save(roster);

        return DropResult.builder()
                .success(true)
                .rosterId(savedRoster.getId())
                .slotId(slot.getId())
                .droppedPlayerId(command.getNflPlayerId())
                .droppedFromPosition(droppedFromPosition)
                .rosterCompletion(String.format("%d/%d", savedRoster.getFilledSlotCount(), savedRoster.getTotalSlotCount()))
                .build();
    }

    /**
     * Command for dropping a player
     */
    public static class DropCommand {
        private final UUID rosterId;
        private final Long nflPlayerId;

        public DropCommand(UUID rosterId, Long nflPlayerId) {
            this.rosterId = rosterId;
            this.nflPlayerId = nflPlayerId;
        }

        public UUID getRosterId() {
            return rosterId;
        }

        public Long getNflPlayerId() {
            return nflPlayerId;
        }

        public static DropCommandBuilder builder() {
            return new DropCommandBuilder();
        }

        public static class DropCommandBuilder {
            private UUID rosterId;
            private Long nflPlayerId;

            public DropCommandBuilder rosterId(UUID rosterId) {
                this.rosterId = rosterId;
                return this;
            }

            public DropCommandBuilder nflPlayerId(Long nflPlayerId) {
                this.nflPlayerId = nflPlayerId;
                return this;
            }

            public DropCommand build() {
                return new DropCommand(rosterId, nflPlayerId);
            }
        }
    }

    /**
     * Result of a drop operation
     */
    public static class DropResult {
        private final boolean success;
        private final UUID rosterId;
        private final UUID slotId;
        private final Long droppedPlayerId;
        private final String droppedFromPosition;
        private final String rosterCompletion;

        private DropResult(Builder builder) {
            this.success = builder.success;
            this.rosterId = builder.rosterId;
            this.slotId = builder.slotId;
            this.droppedPlayerId = builder.droppedPlayerId;
            this.droppedFromPosition = builder.droppedFromPosition;
            this.rosterCompletion = builder.rosterCompletion;
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

        public String getDroppedFromPosition() {
            return droppedFromPosition;
        }

        public String getRosterCompletion() {
            return rosterCompletion;
        }

        public static class Builder {
            private boolean success;
            private UUID rosterId;
            private UUID slotId;
            private Long droppedPlayerId;
            private String droppedFromPosition;
            private String rosterCompletion;

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

            public Builder droppedFromPosition(String droppedFromPosition) {
                this.droppedFromPosition = droppedFromPosition;
                return this;
            }

            public Builder rosterCompletion(String rosterCompletion) {
                this.rosterCompletion = rosterCompletion;
                return this;
            }

            public DropResult build() {
                return new DropResult(this);
            }
        }
    }
}
