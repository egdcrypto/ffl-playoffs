package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.world.World;
import com.ffl.playoffs.domain.port.WorldRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

/**
 * Use case for archiving a World.
 */
public class ArchiveWorldUseCase {

    private final WorldRepository repository;

    public ArchiveWorldUseCase(WorldRepository repository) {
        this.repository = repository;
    }

    /**
     * Archives a world.
     *
     * @param command The archive command
     * @return The archived World
     * @throws IllegalArgumentException if world not found
     * @throws IllegalStateException if archiver lacks permission or world cannot be archived
     */
    public World execute(ArchiveWorldCommand command) {
        World world = repository.findById(command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("World not found: " + command.getWorldId()));

        // Verify the archiver is the primary owner
        if (!world.isPrimaryOwner(command.getArchivedBy())) {
            throw new IllegalStateException("Only the primary owner can archive the world");
        }

        // Archive the world
        world.archive();

        return repository.save(world);
    }

    @Getter
    @Builder
    public static class ArchiveWorldCommand {
        private final UUID worldId;
        private final UUID archivedBy;
    }
}
