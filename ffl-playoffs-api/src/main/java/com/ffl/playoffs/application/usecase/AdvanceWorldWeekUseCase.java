package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.World;
import com.ffl.playoffs.domain.port.WorldRepository;

import java.util.UUID;

/**
 * Use case for advancing a world to the next week
 * Application layer orchestrates domain logic
 */
public class AdvanceWorldWeekUseCase {

    private final WorldRepository worldRepository;

    public AdvanceWorldWeekUseCase(WorldRepository worldRepository) {
        this.worldRepository = worldRepository;
    }

    /**
     * Advances the world to the next week
     *
     * @param worldId The ID of the world to advance
     * @return The updated World with new week
     * @throws IllegalArgumentException if world not found
     * @throws IllegalStateException if world is not active or already at last week
     */
    public World execute(UUID worldId) {
        World world = worldRepository.findById(worldId)
                .orElseThrow(() -> new IllegalArgumentException("World not found: " + worldId));

        world.advanceWeek();

        return worldRepository.save(world);
    }
}
