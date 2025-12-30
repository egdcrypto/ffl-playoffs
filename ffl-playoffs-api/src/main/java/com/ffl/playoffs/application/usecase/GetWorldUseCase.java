package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.World;
import com.ffl.playoffs.domain.model.world.WorldStatus;
import com.ffl.playoffs.domain.port.WorldRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Use case for retrieving world information
 * Application layer orchestrates domain logic
 */
public class GetWorldUseCase {

    private final WorldRepository worldRepository;

    public GetWorldUseCase(WorldRepository worldRepository) {
        this.worldRepository = worldRepository;
    }

    /**
     * Get a world by ID
     *
     * @param worldId The world ID
     * @return Optional containing the world if found
     */
    public Optional<World> getById(UUID worldId) {
        return worldRepository.findById(worldId);
    }

    /**
     * Get a world by name
     *
     * @param name The world name
     * @return Optional containing the world if found
     */
    public Optional<World> getByName(String name) {
        return worldRepository.findByName(name);
    }

    /**
     * Get all worlds
     *
     * @return List of all worlds
     */
    public List<World> getAll() {
        return worldRepository.findAll();
    }

    /**
     * Get worlds by status
     *
     * @param status The world status
     * @return List of matching worlds
     */
    public List<World> getByStatus(WorldStatus status) {
        return worldRepository.findByStatus(status);
    }

    /**
     * Get worlds by season
     *
     * @param season The NFL season year
     * @return List of worlds for the season
     */
    public List<World> getBySeason(Integer season) {
        return worldRepository.findBySeason(season);
    }

    /**
     * Get active worlds
     *
     * @return List of active worlds
     */
    public List<World> getActiveWorlds() {
        return worldRepository.findActiveWorlds();
    }

    /**
     * Get world containing a specific league
     *
     * @param leagueId The league ID
     * @return Optional containing the world if found
     */
    public Optional<World> getByLeagueId(UUID leagueId) {
        return worldRepository.findByLeagueId(leagueId);
    }

    /**
     * Get worlds created by a user
     *
     * @param userId The creator user ID
     * @return List of worlds created by the user
     */
    public List<World> getByCreator(UUID userId) {
        return worldRepository.findByCreatedBy(userId);
    }
}
