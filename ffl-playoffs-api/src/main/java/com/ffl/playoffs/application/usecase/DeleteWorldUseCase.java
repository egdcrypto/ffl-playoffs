package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.world.World;
import com.ffl.playoffs.domain.port.WorldRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

/**
 * Use case for deleting (soft-delete) a World.
 */
public class DeleteWorldUseCase {

    private final WorldRepository repository;

    public DeleteWorldUseCase(WorldRepository repository) {
        this.repository = repository;
    }

    /**
     * Marks a world as deleted (soft delete).
     *
     * @param command The delete command
     * @return The deleted World
     * @throws IllegalArgumentException if world not found
     * @throws IllegalStateException if deleter lacks permission
     */
    public World execute(DeleteWorldCommand command) {
        World world = repository.findById(command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("World not found: " + command.getWorldId()));

        // Verify the deleter is the primary owner
        if (!world.isPrimaryOwner(command.getDeletedBy())) {
            throw new IllegalStateException("Only the primary owner can delete the world");
        }

        // Soft delete - mark as deleted
        world.markDeleted();

        return repository.save(world);
    }

    /**
     * Permanently deletes a world (hard delete).
     * Should only be used for cleanup operations.
     *
     * @param worldId The world ID to delete
     * @throws IllegalArgumentException if world not found
     */
    public void hardDelete(UUID worldId) {
        if (!repository.existsById(worldId)) {
            throw new IllegalArgumentException("World not found: " + worldId);
        }
        repository.deleteById(worldId);
    }

    @Getter
    @Builder
    public static class DeleteWorldCommand {
        private final UUID worldId;
        private final UUID deletedBy;
    }
}
