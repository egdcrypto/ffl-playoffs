package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.World;
import com.ffl.playoffs.domain.port.WorldRepository;

import java.util.UUID;

/**
 * Use case for managing world lifecycle transitions.
 * Application layer - orchestrates world status changes.
 */
public class WorldLifecycleUseCase {

    private final WorldRepository worldRepository;

    public WorldLifecycleUseCase(WorldRepository worldRepository) {
        this.worldRepository = worldRepository;
    }

    /**
     * Submits a world for review
     */
    public World submitForReview(UUID worldId) {
        World world = findWorld(worldId);
        world.submitForReview();
        return worldRepository.save(world);
    }

    /**
     * Approves a world after review
     */
    public World approve(UUID worldId) {
        World world = findWorld(worldId);
        world.approve();
        return worldRepository.save(world);
    }

    /**
     * Rejects a world after review
     */
    public World reject(UUID worldId) {
        World world = findWorld(worldId);
        world.reject();
        return worldRepository.save(world);
    }

    /**
     * Deploys a world
     */
    public World deploy(UUID worldId) {
        World world = findWorld(worldId);
        world.deploy();
        return worldRepository.save(world);
    }

    /**
     * Undeploys a world
     */
    public World undeploy(UUID worldId) {
        World world = findWorld(worldId);
        world.undeploy();
        return worldRepository.save(world);
    }

    /**
     * Archives a world
     */
    public World archive(UUID worldId) {
        World world = findWorld(worldId);
        world.archive();
        return worldRepository.save(world);
    }

    /**
     * Makes a world public
     */
    public World makePublic(UUID worldId) {
        World world = findWorld(worldId);
        world.makePublic();
        return worldRepository.save(world);
    }

    /**
     * Makes a world private
     */
    public World makePrivate(UUID worldId) {
        World world = findWorld(worldId);
        world.makePrivate();
        return worldRepository.save(world);
    }

    private World findWorld(UUID worldId) {
        return worldRepository.findById(worldId)
                .orElseThrow(() -> new IllegalArgumentException("World not found: " + worldId));
    }
}
