package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.PlayoffRanking;
import com.ffl.playoffs.domain.model.PlayoffRound;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for playoff rankings
 * Port in hexagonal architecture
 */
public interface PlayoffRankingRepository {

    /**
     * Find ranking for a player in a specific round
     * @param leaguePlayerId the league player ID
     * @param round the playoff round
     * @param isCumulative whether this is a cumulative ranking
     * @return Optional containing the ranking if found
     */
    Optional<PlayoffRanking> findByPlayerIdAndRound(UUID leaguePlayerId, PlayoffRound round, boolean isCumulative);

    /**
     * Find all rankings for a specific round
     * @param leagueId the league ID
     * @param round the playoff round
     * @param isCumulative whether these are cumulative rankings
     * @return list of rankings sorted by rank
     */
    List<PlayoffRanking> findByLeagueIdAndRound(UUID leagueId, PlayoffRound round, boolean isCumulative);

    /**
     * Find ranking history for a player
     * @param leaguePlayerId the league player ID
     * @return list of rankings across all rounds
     */
    List<PlayoffRanking> findByPlayerId(UUID leaguePlayerId);

    /**
     * Find current cumulative rankings for a league
     * @param leagueId the league ID
     * @return list of current cumulative rankings sorted by rank
     */
    List<PlayoffRanking> findCurrentCumulativeRankings(UUID leagueId);

    /**
     * Save a ranking
     * @param ranking the ranking to save
     * @return the saved ranking
     */
    PlayoffRanking save(PlayoffRanking ranking);

    /**
     * Save multiple rankings
     * @param rankings the rankings to save
     * @return the saved rankings
     */
    List<PlayoffRanking> saveAll(List<PlayoffRanking> rankings);

    /**
     * Delete rankings for a specific round
     * @param leagueId the league ID
     * @param round the playoff round
     */
    void deleteByLeagueIdAndRound(UUID leagueId, PlayoffRound round);
}
