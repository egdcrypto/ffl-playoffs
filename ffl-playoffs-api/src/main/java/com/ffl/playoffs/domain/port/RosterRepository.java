package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.Roster;
import java.util.List;
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
     * Find all rosters for a league
     * @param leagueId the league ID
     * @return list of rosters for the league
     */
    List<Roster> findByLeagueId(String leagueId);

    /**
     * Save a roster
     * @param roster the roster to save
     * @return the saved roster
     */
    Roster save(Roster roster);
}
