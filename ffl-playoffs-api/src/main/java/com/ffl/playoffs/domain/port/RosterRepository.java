package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.Roster;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for Roster aggregate
 * Port in hexagonal architecture
 */
public interface RosterRepository {

    /**
     * Find roster by ID
     * @param id the roster ID
     * @return Optional containing the roster if found
     */
    Optional<Roster> findById(UUID id);

    /**
     * Find roster by league player ID
     * @param leaguePlayerId the league player ID
     * @return Optional containing the roster if found
     */
    Optional<Roster> findByLeaguePlayerId(UUID leaguePlayerId);

    /**
     * Save a roster
     * @param roster the roster to save
     * @return the saved roster
     */
    Roster save(Roster roster);
}
