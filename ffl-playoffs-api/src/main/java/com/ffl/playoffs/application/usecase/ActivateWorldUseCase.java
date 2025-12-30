package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.world.World;
import com.ffl.playoffs.domain.port.WorldRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

/**
 * Use case for activating a World.
 */
public class ActivateWorldUseCase {

    private final WorldRepository repository;

    public ActivateWorldUseCase(WorldRepository repository) {
        this.repository = repository;
    }

    /**
     * Activates a world.
     *
     * @param command The activation command
     * @return The activated World
     * @throws IllegalArgumentException if world not found
     * @throws IllegalStateException if activator lacks permission or world cannot be activated
     */
    public World execute(ActivateWorldCommand command) {
        World world = repository.findById(command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("World not found: " + command.getWorldId()));

        // Verify the activator is the primary owner
        if (!world.isPrimaryOwner(command.getActivatedBy())) {
            throw new IllegalStateException("Only the primary owner can activate the world");
        }

        // Activate the world
        world.activate();

        return repository.save(world);
    }

    @Getter
    @Builder
    public static class ActivateWorldCommand {
        private final UUID worldId;
        private final UUID activatedBy;
    }
}
