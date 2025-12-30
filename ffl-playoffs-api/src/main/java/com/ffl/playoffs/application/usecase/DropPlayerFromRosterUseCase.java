package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.exception.RosterOperationException;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.RosterSlot;
import com.ffl.playoffs.domain.port.RosterRepository;

import java.util.UUID;

/**
 * Use case for dropping (removing) an NFL player from a roster slot.
 *
 * ONE-TIME DRAFT MODEL:
 * - Players can only be dropped before first game starts
 * - After roster lock, NO changes allowed - player stays on roster
 * - Even injured players cannot be dropped after lock
 */
public class DropPlayerFromRosterUseCase {

    private final RosterRepository rosterRepository;

    public DropPlayerFromRosterUseCase(RosterRepository rosterRepository) {
        this.rosterRepository = rosterRepository;
    }

    /**
     * Drops a player from a roster slot.
     *
     * @param command the drop command
     * @return the result of the drop operation
     * @throws RosterOperationException if the drop fails
     */
    public DropResult execute(DropCommand command) {
        // Find roster
        Roster roster = rosterRepository.findById(command.getRosterId())
                .orElseThrow(RosterOperationException::rosterNotFound);

        // Check roster is not locked (one-time draft model)
        if (roster.isLocked()) {
            throw RosterOperationException.rosterPermanentlyLocked();
        }

        // Find the slot with the player
        RosterSlot slot = roster.getSlots().stream()
                .filter(s -> s.isFilled() && s.getNflPlayerId().equals(command.getNflPlayerId()))
                .findFirst()
                .orElseThrow(() -> new RosterOperationException(
                        RosterOperationException.ErrorCode.PLAYER_NOT_FOUND,
                        "Player not found on roster"));

        // Store info before clearing
        Long droppedPlayerId = slot.getNflPlayerId();
        Position slotPosition = slot.getPosition();

        // Clear the slot
        slot.clearPlayer();

        // Save roster
        Roster savedRoster = rosterRepository.save(roster);

        return DropResult.builder()
                .success(true)
                .rosterId(savedRoster.getId())
                .slotId(slot.getId())
                .droppedPlayerId(droppedPlayerId)
                .slotPosition(slotPosition)
                .rosterCompletion(String.format("%d/%d", savedRoster.getFilledSlotCount(), savedRoster.getTotalSlotCount()))
                .isRosterComplete(savedRoster.isComplete())
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

        public static Builder builder() {
            return new Builder();
        }

        public static class Builder {
            private UUID rosterId;
            private Long nflPlayerId;

            public Builder rosterId(UUID rosterId) {
                this.rosterId = rosterId;
                return this;
            }

            public Builder nflPlayerId(Long nflPlayerId) {
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
        private final Position slotPosition;
        private final String rosterCompletion;
        private final boolean isRosterComplete;

        private DropResult(Builder builder) {
            this.success = builder.success;
            this.rosterId = builder.rosterId;
            this.slotId = builder.slotId;
            this.droppedPlayerId = builder.droppedPlayerId;
            this.slotPosition = builder.slotPosition;
            this.rosterCompletion = builder.rosterCompletion;
            this.isRosterComplete = builder.isRosterComplete;
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

        public Position getSlotPosition() {
            return slotPosition;
        }

        public String getRosterCompletion() {
            return rosterCompletion;
        }

        public boolean isRosterComplete() {
            return isRosterComplete;
        }

        public static Builder builder() {
            return new Builder();
        }

        public static class Builder {
            private boolean success;
            private UUID rosterId;
            private UUID slotId;
            private Long droppedPlayerId;
            private Position slotPosition;
            private String rosterCompletion;
            private boolean isRosterComplete;

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

            public DropResult build() {
                return new DropResult(this);
            }
        }
    }
}
