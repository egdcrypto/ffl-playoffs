package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.World;
import com.ffl.playoffs.domain.port.WorldRepository;

import java.util.UUID;

/**
 * Use case for activating a world to start the season
 * Application layer orchestrates domain logic
 */
public class ActivateWorldUseCase {

    private final WorldRepository worldRepository;

    public ActivateWorldUseCase(WorldRepository worldRepository) {
        this.worldRepository = worldRepository;
    }

    /**
     * Activates a world to start the season
     *
     * @param worldId The ID of the world to activate
     * @return The activated World
     * @throws IllegalArgumentException if world not found
     * @throws IllegalStateException if world cannot be activated
     */
    public World execute(UUID worldId) {
        World world = worldRepository.findById(worldId)
                .orElseThrow(() -> new IllegalArgumentException("World not found: " + worldId));

        // If world is in CREATED or CONFIGURING state, mark it ready first
        if (world.isConfigurable()) {
            world.markReady();
        }

        // Activate the world
        world.activate();

        return worldRepository.save(world);
    }
}
