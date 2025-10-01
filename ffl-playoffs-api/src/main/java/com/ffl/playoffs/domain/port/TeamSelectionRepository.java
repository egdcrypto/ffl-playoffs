package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.PageRequest;
import com.ffl.playoffs.application.dto.TeamSelectionDTO;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Port interface for TeamSelection persistence
 * Domain defines the contract, infrastructure implements it
 * No framework dependencies in this interface
 */
public interface TeamSelectionRepository {

    /**
     * Save a team selection
     * @param teamSelection the selection to save
     * @return the saved selection
     */
    TeamSelectionDTO save(TeamSelectionDTO teamSelection);

    /**
     * Find a team selection by ID
     * @param id the selection ID
     * @return Optional containing the selection if found
     */
    Optional<TeamSelectionDTO> findById(UUID id);

    /**
     * Find all selections for a player with pagination
     * @param playerId the player ID
     * @param pageRequest pagination parameters
     * @return paginated list of team selections
     */
    Page<TeamSelectionDTO> findByPlayerId(UUID playerId, PageRequest pageRequest);

    /**
     * Find all selections for a player (unpaginated)
     * @param playerId the player ID
     * @return list of all team selections for the player
     */
    List<TeamSelectionDTO> findByPlayerId(UUID playerId);

    /**
     * Find selection for a specific player and week
     * @param playerId the player ID
     * @param week the week number
     * @return Optional containing the selection if found
     */
    Optional<TeamSelectionDTO> findByPlayerIdAndWeek(UUID playerId, int week);

    /**
     * Find all selections for a game with pagination
     * @param gameId the game ID
     * @param pageRequest pagination parameters
     * @return paginated list of team selections
     */
    Page<TeamSelectionDTO> findByGameId(UUID gameId, PageRequest pageRequest);

    /**
     * Check if a player has already selected a specific team
     * @param playerId the player ID
     * @param teamName the team name
     * @return true if the player has already selected this team
     */
    boolean hasPlayerSelectedTeam(UUID playerId, String teamName);

    /**
     * Delete a team selection
     * @param id the selection ID
     */
    void delete(UUID id);
}
