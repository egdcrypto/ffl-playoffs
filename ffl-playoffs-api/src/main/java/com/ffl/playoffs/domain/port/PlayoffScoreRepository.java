package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.PlayoffRound;
import com.ffl.playoffs.domain.model.RosterScore;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for playoff scores
 * Port in hexagonal architecture
 */
public interface PlayoffScoreRepository {

    /**
     * Find score by ID
     * @param id the score ID
     * @return Optional containing the score if found
     */
    Optional<RosterScore> findById(UUID id);

    /**
     * Find score for a player in a specific round
     * @param leaguePlayerId the league player ID
     * @param round the playoff round
     * @return Optional containing the score if found
     */
    Optional<RosterScore> findByPlayerIdAndRound(UUID leaguePlayerId, PlayoffRound round);

    /**
     * Find all scores for a specific round in a league
     * @param leagueId the league ID
     * @param round the playoff round
     * @return list of scores
     */
    List<RosterScore> findByLeagueIdAndRound(UUID leagueId, PlayoffRound round);

    /**
     * Find all scores for a player across all rounds
     * @param leaguePlayerId the league player ID
     * @return list of scores
     */
    List<RosterScore> findByPlayerId(UUID leaguePlayerId);

    /**
     * Get cumulative scores for all players in a league
     * @param leagueId the league ID
     * @return map of player ID to cumulative score
     */
    Map<UUID, BigDecimal> getCumulativeScores(UUID leagueId);

    /**
     * Save a score
     * @param score the score to save
     * @return the saved score
     */
    RosterScore save(RosterScore score);

    /**
     * Save multiple scores
     * @param scores the scores to save
     * @return the saved scores
     */
    List<RosterScore> saveAll(List<RosterScore> scores);

    /**
     * Delete a score
     * @param id the score ID
     */
    void deleteById(UUID id);

    /**
     * Delete all scores for a player
     * @param leaguePlayerId the league player ID
     */
    void deleteByPlayerId(UUID leaguePlayerId);
}
