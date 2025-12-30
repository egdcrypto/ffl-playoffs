package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.World;
import com.ffl.playoffs.domain.port.WorldRepository;

import java.util.UUID;

/**
 * Use case for deleting a world.
 * Application layer - orchestrates world deletion.
 */
public class DeleteWorldUseCase {

    private final WorldRepository worldRepository;

    public DeleteWorldUseCase(WorldRepository worldRepository) {
        this.worldRepository = worldRepository;
    }

    /**
     * Executes the delete world use case
     * @param command the command containing world deletion parameters
     * @throws IllegalArgumentException if world not found
     * @throws IllegalStateException if world cannot be deleted
     */
    public void execute(DeleteWorldCommand command) {
        World world = worldRepository.findById(command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("World not found: " + command.getWorldId()));

        // Check if world can be deleted
        if (!world.canDelete()) {
            throw new IllegalStateException("World cannot be deleted in current status: " + world.getStatus() +
                    ". Only DRAFT worlds can be deleted.");
        }

        // Delete the world
        worldRepository.deleteById(command.getWorldId());
    }

    /**
     * Command for deleting a world
     */
    public static class DeleteWorldCommand {
        private final UUID worldId;

        public DeleteWorldCommand(UUID worldId) {
            this.worldId = worldId;
        }

        public UUID getWorldId() {
            return worldId;
        }
    }
}
