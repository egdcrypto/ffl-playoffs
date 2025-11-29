package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.NFLPlayer;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.port.NFLPlayerRepository;
import com.ffl.playoffs.domain.port.RosterRepository;

import java.util.UUID;

/**
 * Use case for adding an NFL player to a specific roster slot
 * Validates player eligibility and position compatibility
 */
public class AddNFLPlayerToSlotUseCase {

    private final RosterRepository rosterRepository;
    private final NFLPlayerRepository nflPlayerRepository;

    public AddNFLPlayerToSlotUseCase(
            RosterRepository rosterRepository,
            NFLPlayerRepository nflPlayerRepository) {
        this.rosterRepository = rosterRepository;
        this.nflPlayerRepository = nflPlayerRepository;
    }

    /**
     * Adds an NFL player to a roster slot
     *
     * @param command The add player command
     * @return The updated Roster entity
     * @throws IllegalArgumentException if roster or slot not found
     * @throws IllegalArgumentException if player not found
     * @throws IllegalStateException if roster is locked
     * @throws IllegalStateException if player is already on roster
     */
    public Roster execute(AddNFLPlayerToSlotCommand command) {
        // Find roster
        Roster roster = rosterRepository.findById(command.getRosterId())
                .orElseThrow(() -> new IllegalArgumentException("Roster not found"));

        // Find NFL player
        NFLPlayer nflPlayer = nflPlayerRepository.findById(command.getNflPlayerId())
                .orElseThrow(() -> new IllegalArgumentException("NFL player not found"));

        // Validate player is active
        if (!nflPlayer.isActive()) {
            throw new IllegalStateException("Player is not active: " + nflPlayer.getStatus());
        }

        // Assign player to slot
        roster.assignPlayerToSlot(
                command.getSlotId(),
                nflPlayer.getId(),
                nflPlayer.getPosition()
        );

        // Save and return
        return rosterRepository.save(roster);
    }

    /**
     * Command object for adding NFL player to slot
     */
    public static class AddNFLPlayerToSlotCommand {
        private final UUID rosterId;
        private final UUID slotId;
        private final Long nflPlayerId;

        public AddNFLPlayerToSlotCommand(UUID rosterId, UUID slotId, Long nflPlayerId) {
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
    }
}
