package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.world.World;
import com.ffl.playoffs.domain.port.WorldRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

/**
 * Use case for transferring primary ownership of a World.
 */
public class TransferWorldOwnershipUseCase {

    private final WorldRepository repository;

    public TransferWorldOwnershipUseCase(WorldRepository repository) {
        this.repository = repository;
    }

    /**
     * Transfers primary ownership to a new owner.
     *
     * @param command The transfer command
     * @return The updated World
     * @throws IllegalArgumentException if world not found
     * @throws IllegalStateException if current owner is not the primary owner
     */
    public World execute(TransferOwnershipCommand command) {
        World world = repository.findById(command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("World not found: " + command.getWorldId()));

        // Verify the current owner is the primary owner
        if (!world.isPrimaryOwner(command.getCurrentOwnerId())) {
            throw new IllegalStateException("Only the current primary owner can transfer ownership");
        }

        // Verify new owner is different
        if (command.getCurrentOwnerId().equals(command.getNewOwnerId())) {
            throw new IllegalArgumentException("New owner must be different from current owner");
        }

        // Transfer ownership
        world.transferPrimaryOwnership(command.getNewOwnerId());

        return repository.save(world);
    }

    @Getter
    @Builder
    public static class TransferOwnershipCommand {
        private final UUID worldId;
        private final UUID currentOwnerId;
        private final UUID newOwnerId;
    }
}
