package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.PlayoffMatchup;
import com.ffl.playoffs.domain.model.MatchupStatus;
import com.ffl.playoffs.domain.model.PlayoffRound;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for PlayoffMatchup entities
 * Port in hexagonal architecture
 */
public interface PlayoffMatchupRepository {

    /**
     * Find matchup by ID
     * @param id the matchup ID
     * @return Optional containing the matchup if found
     */
    Optional<PlayoffMatchup> findById(UUID id);

    /**
     * Find all matchups for a bracket
     * @param bracketId the bracket ID
     * @return list of matchups
     */
    List<PlayoffMatchup> findByBracketId(UUID bracketId);

    /**
     * Find all matchups for a bracket and round
     * @param bracketId the bracket ID
     * @param round the playoff round
     * @return list of matchups
     */
    List<PlayoffMatchup> findByBracketIdAndRound(UUID bracketId, PlayoffRound round);

    /**
     * Find matchups by status
     * @param bracketId the bracket ID
     * @param status the matchup status
     * @return list of matchups
     */
    List<PlayoffMatchup> findByBracketIdAndStatus(UUID bracketId, MatchupStatus status);

    /**
     * Find matchup for a specific player in a round
     * @param bracketId the bracket ID
     * @param playerId the player ID
     * @param round the playoff round
     * @return Optional containing the matchup if found
     */
    Optional<PlayoffMatchup> findByBracketIdAndPlayerIdAndRound(UUID bracketId, UUID playerId, PlayoffRound round);

    /**
     * Find all matchups flagged as upsets
     * @param bracketId the bracket ID
     * @return list of upset matchups
     */
    List<PlayoffMatchup> findUpsets(UUID bracketId);

    /**
     * Save a matchup
     * @param matchup the matchup to save
     * @return the saved matchup
     */
    PlayoffMatchup save(PlayoffMatchup matchup);

    /**
     * Save multiple matchups
     * @param matchups the matchups to save
     * @return the saved matchups
     */
    List<PlayoffMatchup> saveAll(List<PlayoffMatchup> matchups);

    /**
     * Delete a matchup
     * @param id the matchup ID
     */
    void deleteById(UUID id);
}
