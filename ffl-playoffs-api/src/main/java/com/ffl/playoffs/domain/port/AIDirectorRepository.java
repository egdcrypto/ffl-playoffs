package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.narrative.AIDirector;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository port for AI Director persistence
 */
public interface AIDirectorRepository {

    /**
     * Save an AI Director
     */
    AIDirector save(AIDirector director);

    /**
     * Find an AI Director by ID
     */
    Optional<AIDirector> findById(UUID id);

    /**
     * Find an AI Director by league ID
     */
    Optional<AIDirector> findByLeagueId(UUID leagueId);

    /**
     * Find all active AI Directors
     */
    List<AIDirector> findAllActive();

    /**
     * Find AI Directors with active stall conditions
     */
    List<AIDirector> findWithActiveStalls();

    /**
     * Find AI Directors with pending actions
     */
    List<AIDirector> findWithPendingActions();

    /**
     * Find inactive AI Directors
     */
    List<AIDirector> findInactive(int thresholdHours);

    /**
     * Check if a director exists for a league
     */
    boolean existsByLeagueId(UUID leagueId);

    /**
     * Delete an AI Director
     */
    void delete(UUID id);

    /**
     * Delete an AI Director by league ID
     */
    void deleteByLeagueId(UUID leagueId);
}
