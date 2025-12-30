package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.world.World;
import com.ffl.playoffs.domain.model.world.WorldSettings;
import com.ffl.playoffs.domain.model.world.WorldVisibility;
import com.ffl.playoffs.domain.port.WorldRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

/**
 * Use case for updating a World.
 */
public class UpdateWorldUseCase {

    private final WorldRepository repository;

    public UpdateWorldUseCase(WorldRepository repository) {
        this.repository = repository;
    }

    /**
     * Updates a world.
     *
     * @param command The update command
     * @return The updated World
     * @throws IllegalArgumentException if world not found or updater lacks permission
     */
    public World execute(UpdateWorldCommand command) {
        World world = repository.findById(command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("World not found: " + command.getWorldId()));

        // Verify the updater is the primary owner
        if (!world.isPrimaryOwner(command.getUpdatedBy())) {
            throw new IllegalStateException("Only the primary owner can update the world");
        }

        // Update fields if provided
        if (command.getName() != null) {
            world.updateName(command.getName());
        }

        if (command.getDescription() != null) {
            world.updateDescription(command.getDescription());
        }

        if (command.getVisibility() != null) {
            world.updateVisibility(command.getVisibility());
        }

        if (command.getSettings() != null) {
            world.updateSettings(command.getSettings());
        }

        return repository.save(world);
    }

    @Getter
    @Builder
    public static class UpdateWorldCommand {
        private final UUID worldId;
        private final UUID updatedBy;
        private final String name;
        private final String description;
        private final WorldVisibility visibility;
        private final WorldSettings settings;
    }
}
