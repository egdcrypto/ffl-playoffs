package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.LiveScoreStatus;
import com.ffl.playoffs.domain.model.ScoreUpdate;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Repository port for live score operations
 * Handles caching and persistence of live score data
 */
public interface LiveScoreRepository {

    /**
     * Save a score update
     * @param scoreUpdate the score update to save
     */
    void save(ScoreUpdate scoreUpdate);

    /**
     * Save multiple score updates in a batch
     * @param scoreUpdates the list of score updates
     */
    void saveAll(List<ScoreUpdate> scoreUpdates);

    /**
     * Get the latest score for a league player
     * @param leaguePlayerId the league player ID
     * @return the current score if present
     */
    Optional<BigDecimal> getCurrentScore(String leaguePlayerId);

    /**
     * Get all current scores for a league
     * @param leagueId the league ID
     * @return map of leaguePlayerId to current score
     */
    Map<String, BigDecimal> getAllScoresForLeague(String leagueId);

    /**
     * Get the score status for a league player
     * @param leaguePlayerId the league player ID
     * @return the live score status
     */
    LiveScoreStatus getScoreStatus(String leaguePlayerId);

    /**
     * Update the status for a league player's score
     * @param leaguePlayerId the league player ID
     * @param status the new status
     */
    void updateScoreStatus(String leaguePlayerId, LiveScoreStatus status);

    /**
     * Get recent score updates for a league player
     * @param leaguePlayerId the league player ID
     * @param since only get updates after this time
     * @return list of score updates
     */
    List<ScoreUpdate> getRecentUpdates(String leaguePlayerId, LocalDateTime since);

    /**
     * Get recent score updates for a league
     * @param leagueId the league ID
     * @param since only get updates after this time
     * @return list of score updates
     */
    List<ScoreUpdate> getRecentLeagueUpdates(String leagueId, LocalDateTime since);

    /**
     * Check if an update with this idempotency key already exists
     * @param idempotencyKey the idempotency key
     * @return true if already processed
     */
    boolean isDuplicateUpdate(String idempotencyKey);

    /**
     * Mark an idempotency key as processed
     * @param idempotencyKey the idempotency key
     */
    void markIdempotencyKey(String idempotencyKey);

    /**
     * Get the last update timestamp for a league
     * @param leagueId the league ID
     * @return the last update time if any
     */
    Optional<LocalDateTime> getLastUpdateTime(String leagueId);

    /**
     * Clear cached scores for a league (e.g., at end of week)
     * @param leagueId the league ID
     */
    void clearCache(String leagueId);
}
