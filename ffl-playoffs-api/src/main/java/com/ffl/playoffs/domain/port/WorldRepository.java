package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.World;
import com.ffl.playoffs.domain.model.world.WorldStatus;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for World aggregate
 * Port in hexagonal architecture
 */
public interface WorldRepository {

    /**
     * Find world by ID
     * @param id the world ID
     * @return Optional containing the world if found
     */
    Optional<World> findById(UUID id);

    /**
     * Find world by name
     * @param name the world name
     * @return Optional containing the world if found
     */
    Optional<World> findByName(String name);

    /**
     * Find all worlds
     * @return list of all worlds
     */
    List<World> findAll();

    /**
     * Find worlds by status
     * @param status the world status
     * @return list of worlds with the given status
     */
    List<World> findByStatus(WorldStatus status);

    /**
     * Find worlds by season
     * @param season the NFL season year
     * @return list of worlds for the given season
     */
    List<World> findBySeason(Integer season);

    /**
     * Find worlds by season and status
     * @param season the NFL season year
     * @param status the world status
     * @return list of matching worlds
     */
    List<World> findBySeasonAndStatus(Integer season, WorldStatus status);

    /**
     * Find worlds created by a user
     * @param userId the creator user ID
     * @return list of worlds created by the user
     */
    List<World> findByCreatedBy(UUID userId);

    /**
     * Find active worlds (status = ACTIVE)
     * @return list of active worlds
     */
    List<World> findActiveWorlds();

    /**
     * Find world containing a specific league
     * @param leagueId the league ID
     * @return Optional containing the world if found
     */
    Optional<World> findByLeagueId(UUID leagueId);

    /**
     * Check if world name already exists
     * @param name the world name
     * @return true if name exists
     */
    boolean existsByName(String name);

    /**
     * Check if a world exists for a given season
     * @param season the NFL season year
     * @return true if world exists for the season
     */
    boolean existsBySeason(Integer season);

    /**
     * Save a world
     * @param world the world to save
     * @return the saved world
     */
    World save(World world);

    /**
     * Delete a world by ID
     * @param id the world ID
     */
    void deleteById(UUID id);

    /**
     * Count worlds by status
     * @param status the world status
     * @return count of worlds with the given status
     */
    long countByStatus(WorldStatus status);

    /**
     * Count all worlds
     * @return total count of worlds
     */
    long count();
}
