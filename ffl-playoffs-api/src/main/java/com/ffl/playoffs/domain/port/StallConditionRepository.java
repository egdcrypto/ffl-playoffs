package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.narrative.StallCondition;
import com.ffl.playoffs.domain.model.narrative.StallConditionType;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository port for Stall Condition persistence
 */
public interface StallConditionRepository {

    /**
     * Save a stall condition
     */
    StallCondition save(StallCondition condition);

    /**
     * Find a stall condition by ID
     */
    Optional<StallCondition> findById(UUID id);

    /**
     * Find all stall conditions for a league
     */
    List<StallCondition> findByLeagueId(UUID leagueId);

    /**
     * Find active (unresolved) stall conditions for a league
     */
    List<StallCondition> findActiveByLeagueId(UUID leagueId);

    /**
     * Find resolved stall conditions for a league
     */
    List<StallCondition> findResolvedByLeagueId(UUID leagueId);

    /**
     * Find stall conditions by type
     */
    List<StallCondition> findByLeagueIdAndType(UUID leagueId, StallConditionType type);

    /**
     * Find stall conditions by severity
     */
    List<StallCondition> findByLeagueIdAndSeverity(UUID leagueId, StallConditionType.SeverityLevel severity);

    /**
     * Find stall conditions affecting a player
     */
    List<StallCondition> findByLeagueIdAndAffectedPlayerId(UUID leagueId, UUID playerId);

    /**
     * Find stall conditions exceeding threshold
     */
    List<StallCondition> findExceedingThreshold(UUID leagueId);

    /**
     * Find stall conditions requiring immediate attention
     */
    List<StallCondition> findRequiringImmediateAttention(UUID leagueId);

    /**
     * Count active stall conditions for a league
     */
    long countActiveByLeagueId(UUID leagueId);

    /**
     * Count stall conditions by type for a league
     */
    long countByLeagueIdAndType(UUID leagueId, StallConditionType type);

    /**
     * Delete a stall condition
     */
    void delete(UUID id);

    /**
     * Delete all stall conditions for a league
     */
    void deleteByLeagueId(UUID leagueId);

    /**
     * Delete resolved stall conditions older than specified hours
     */
    void deleteResolvedOlderThan(UUID leagueId, int hours);
}
