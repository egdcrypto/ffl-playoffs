package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.TeamSelection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Port interface for TeamSelection persistence
 * Domain defines the contract, infrastructure implements it
 *
 * IMPORTANT: This is a DOMAIN PORT and must only depend on domain entities.
 * NO dependencies on application layer (DTOs, Page, PageRequest).
 *
 * Pagination and DTO mapping should be handled in the application layer.
 */
public interface TeamSelectionRepository {

    /**
     * Save a team selection
     * @param teamSelection the domain entity to save
     * @return the saved domain entity
     */
    TeamSelection save(TeamSelection teamSelection);

    /**
     * Find a team selection by ID
     * @param id the selection ID
     * @return Optional containing the domain entity if found
     */
    Optional<TeamSelection> findById(UUID id);

    /**
     * Find all selections for a player
     * Application layer handles pagination if needed
     *
     * @param playerId the player ID
     * @return list of all team selections for the player
     */
    List<TeamSelection> findByPlayerId(UUID playerId);

    /**
     * Find selection for a specific player and week
     * @param playerId the player ID
     * @param week the week number
     * @return Optional containing the domain entity if found
     */
    Optional<TeamSelection> findByPlayerIdAndWeek(UUID playerId, int week);

    /**
     * Find all selections for a game
     * Application layer handles pagination if needed
     *
     * @param gameId the game ID
     * @return list of all team selections for the game
     */
    List<TeamSelection> findByGameId(UUID gameId);

    /**
     * Find all selections for a game and week
     * @param gameId the game ID
     * @param week the week number
     * @return list of all team selections for the game and week
     */
    List<TeamSelection> findByGameIdAndWeek(UUID gameId, int week);

    /**
     * Check if a player has already selected a specific team
     * @param playerId the player ID
     * @param teamName the team name
     * @return true if the player has already selected this team
     */
    boolean hasPlayerSelectedTeam(UUID playerId, String teamName);

    /**
     * Count selections for a player
     * @param playerId the player ID
     * @return number of selections
     */
    long countByPlayerId(UUID playerId);

    /**
     * Delete a team selection
     * @param id the selection ID
     */
    void delete(UUID id);

    /**
     * Delete all selections for a player
     * @param playerId the player ID
     */
    void deleteByPlayerId(UUID playerId);

    /**
     * Count selections for a specific week
     * @param weekId the week ID
     * @return number of selections for that week
     */
    long countByWeekId(UUID weekId);

    /**
     * Find all selections for a specific week
     * @param weekId the week ID
     * @return list of all team selections for the week
     */
    List<TeamSelection> findByWeekId(UUID weekId);
}
