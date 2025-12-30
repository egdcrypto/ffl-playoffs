package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.world.World;
import com.ffl.playoffs.domain.model.world.WorldSettings;
import com.ffl.playoffs.domain.model.world.WorldVisibility;
import com.ffl.playoffs.domain.port.WorldRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

/**
 * Use case for creating a new World.
 */
public class CreateWorldUseCase {

    private final WorldRepository repository;

    public CreateWorldUseCase(WorldRepository repository) {
        this.repository = repository;
    }

    /**
     * Creates a new world.
     *
     * @param command The creation command
     * @return The created World
     * @throws IllegalArgumentException if code already exists
     */
    public World execute(CreateWorldCommand command) {
        // Validate unique code
        if (repository.existsByCode(command.getCode())) {
            throw new IllegalArgumentException("World code already exists: " + command.getCode());
        }

        // Create the world
        World world = World.create(
                command.getName(),
                command.getCode(),
                command.getOwnerId()
        );

        // Set optional properties
        if (command.getDescription() != null) {
            world.setDescription(command.getDescription());
        }

        if (command.getVisibility() != null) {
            world.setVisibility(command.getVisibility());
        }

        if (command.getSettings() != null) {
            command.getSettings().validate();
            world.setSettings(command.getSettings());
        }

        // Auto-activate if requested
        if (command.isAutoActivate()) {
            world.activate();
        }

        return repository.save(world);
    }

    @Getter
    @Builder
    public static class CreateWorldCommand {
        private final String name;
        private final String code;
        private final UUID ownerId;
        private final String description;
        private final WorldVisibility visibility;
        private final WorldSettings settings;
        @Builder.Default
        private final boolean autoActivate = false;
    }
}
