package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.narrative.NarrativePhase;
import com.ffl.playoffs.domain.model.narrative.StoryArc;
import com.ffl.playoffs.domain.model.narrative.StoryArcStatus;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository port for Story Arc persistence
 */
public interface StoryArcRepository {

    /**
     * Save a story arc
     */
    StoryArc save(StoryArc arc);

    /**
     * Find a story arc by ID
     */
    Optional<StoryArc> findById(UUID id);

    /**
     * Find all story arcs for a league
     */
    List<StoryArc> findByLeagueId(UUID leagueId);

    /**
     * Find story arcs by status
     */
    List<StoryArc> findByLeagueIdAndStatus(UUID leagueId, StoryArcStatus status);

    /**
     * Find active story arcs for a league
     */
    List<StoryArc> findActiveByLeagueId(UUID leagueId);

    /**
     * Find story arcs by phase
     */
    List<StoryArc> findByLeagueIdAndCurrentPhase(UUID leagueId, NarrativePhase phase);

    /**
     * Find story arcs involving a player
     */
    List<StoryArc> findByLeagueIdAndInvolvedPlayerId(UUID leagueId, UUID playerId);

    /**
     * Find completed story arcs
     */
    List<StoryArc> findCompletedByLeagueId(UUID leagueId);

    /**
     * Find archived story arcs
     */
    List<StoryArc> findArchivedByLeagueId(UUID leagueId);

    /**
     * Count story arcs by status for a league
     */
    long countByLeagueIdAndStatus(UUID leagueId, StoryArcStatus status);

    /**
     * Count active story arcs for a league
     */
    long countActiveByLeagueId(UUID leagueId);

    /**
     * Delete a story arc
     */
    void delete(UUID id);

    /**
     * Delete all story arcs for a league
     */
    void deleteByLeagueId(UUID leagueId);
}
