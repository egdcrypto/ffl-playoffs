package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.model.RosterLockStatus;

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
     * Find all rosters for a league/game
     * @param leagueId the league/game ID
     * @return list of rosters in the league
     */
    List<Roster> findByLeagueId(UUID leagueId);

    /**
     * Find all rosters in a league with a specific lock status
     * @param leagueId the league/game ID
     * @param lockStatus the lock status to filter by
     * @return list of rosters matching the criteria
     */
    List<Roster> findByLeagueIdAndLockStatus(UUID leagueId, RosterLockStatus lockStatus);

    /**
     * Count rosters by league and lock status
     * @param leagueId the league/game ID
     * @param lockStatus the lock status to count
     * @return count of matching rosters
     */
    long countByLeagueIdAndLockStatus(UUID leagueId, RosterLockStatus lockStatus);

    /**
     * Save a roster
     * @param roster the roster to save
     * @return the saved roster
     */
    Roster save(Roster roster);

    /**
     * Save multiple rosters
     * @param rosters the rosters to save
     * @return the saved rosters
     */
    List<Roster> saveAll(List<Roster> rosters);
}
