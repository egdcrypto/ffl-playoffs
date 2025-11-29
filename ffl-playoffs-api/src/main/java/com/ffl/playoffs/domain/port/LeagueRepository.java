package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.League;
import java.util.Optional;
import java.util.UUID;
import java.util.List;

/**
 * Repository interface for League aggregate
 * Port in hexagonal architecture
 */
public interface LeagueRepository {

    /**
     * Find league by ID
     * @param id the league ID
     * @return Optional containing the league if found
     */
    Optional<League> findById(UUID id);

    /**
     * Find league by unique code
     * @param code the league code
     * @return Optional containing the league if found
     */
    Optional<League> findByCode(String code);

    /**
     * Find all leagues
     * @return list of all leagues
     */
    List<League> findAll();

    /**
     * Find all leagues created by an admin
     * @param adminId the admin user ID
     * @return list of leagues
     */
    List<League> findByAdminId(UUID adminId);

    /**
     * Check if league code exists
     * @param code the league code
     * @return true if code exists
     */
    boolean existsByCode(String code);

    /**
     * Save a league
     * @param league the league to save
     * @return the saved league
     */
    League save(League league);

    /**
     * Delete a league
     * @param id the league ID
     */
    void deleteById(UUID id);
}
