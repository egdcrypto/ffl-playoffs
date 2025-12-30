package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.PlayoffBracket;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for PlayoffBracket aggregate
 * Port in hexagonal architecture
 */
public interface PlayoffBracketRepository {

    /**
     * Find playoff bracket by ID
     * @param id the bracket ID
     * @return Optional containing the bracket if found
     */
    Optional<PlayoffBracket> findById(UUID id);

    /**
     * Find playoff bracket by league ID
     * @param leagueId the league ID
     * @return Optional containing the bracket if found
     */
    Optional<PlayoffBracket> findByLeagueId(UUID leagueId);

    /**
     * Find all active playoff brackets (not completed)
     * @return list of active brackets
     */
    List<PlayoffBracket> findAllActive();

    /**
     * Find all playoff brackets
     * @return list of all brackets
     */
    List<PlayoffBracket> findAll();

    /**
     * Save a playoff bracket
     * @param bracket the bracket to save
     * @return the saved bracket
     */
    PlayoffBracket save(PlayoffBracket bracket);

    /**
     * Delete a playoff bracket
     * @param id the bracket ID
     */
    void deleteById(UUID id);

    /**
     * Check if a bracket exists for a league
     * @param leagueId the league ID
     * @return true if bracket exists
     */
    boolean existsByLeagueId(UUID leagueId);
}
