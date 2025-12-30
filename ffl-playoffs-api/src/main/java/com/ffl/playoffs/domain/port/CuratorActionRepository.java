package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.narrative.CuratorAction;
import com.ffl.playoffs.domain.model.narrative.CuratorActionType;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository port for Curator Action persistence
 */
public interface CuratorActionRepository {

    /**
     * Save a curator action
     */
    CuratorAction save(CuratorAction action);

    /**
     * Find a curator action by ID
     */
    Optional<CuratorAction> findById(UUID id);

    /**
     * Find all curator actions for a league
     */
    List<CuratorAction> findByLeagueId(UUID leagueId);

    /**
     * Find pending curator actions for a league
     */
    List<CuratorAction> findPendingByLeagueId(UUID leagueId);

    /**
     * Find in-progress curator actions for a league
     */
    List<CuratorAction> findInProgressByLeagueId(UUID leagueId);

    /**
     * Find completed curator actions for a league
     */
    List<CuratorAction> findCompletedByLeagueId(UUID leagueId);

    /**
     * Find curator actions by type
     */
    List<CuratorAction> findByLeagueIdAndType(UUID leagueId, CuratorActionType type);

    /**
     * Find curator actions by status
     */
    List<CuratorAction> findByLeagueIdAndStatus(UUID leagueId, CuratorAction.ActionStatus status);

    /**
     * Find automated curator actions for a league
     */
    List<CuratorAction> findAutomatedByLeagueId(UUID leagueId);

    /**
     * Find manual curator actions for a league
     */
    List<CuratorAction> findManualByLeagueId(UUID leagueId);

    /**
     * Find curator actions initiated by a user
     */
    List<CuratorAction> findByInitiatedBy(UUID userId);

    /**
     * Find curator actions related to a stall condition
     */
    List<CuratorAction> findByRelatedStallConditionId(UUID stallConditionId);

    /**
     * Find curator actions related to a story arc
     */
    List<CuratorAction> findByRelatedStoryArcId(UUID storyArcId);

    /**
     * Find curator actions targeting a player
     */
    List<CuratorAction> findByTargetPlayerId(UUID playerId);

    /**
     * Find recent curator actions for a league
     */
    List<CuratorAction> findRecentByLeagueId(UUID leagueId, int limit);

    /**
     * Count pending curator actions for a league
     */
    long countPendingByLeagueId(UUID leagueId);

    /**
     * Count curator actions by type for a league
     */
    long countByLeagueIdAndType(UUID leagueId, CuratorActionType type);

    /**
     * Count curator actions by status for a league
     */
    long countByLeagueIdAndStatus(UUID leagueId, CuratorAction.ActionStatus status);

    /**
     * Delete a curator action
     */
    void delete(UUID id);

    /**
     * Delete all curator actions for a league
     */
    void deleteByLeagueId(UUID leagueId);

    /**
     * Delete completed curator actions older than specified hours
     */
    void deleteCompletedOlderThan(UUID leagueId, int hours);
}
