package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.application.dto.LeaderboardEntryDTO;
import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.PageRequest;

import java.util.UUID;

/**
 * Port interface for Leaderboard data retrieval
 * Domain defines the contract, infrastructure implements it
 * No framework dependencies in this interface
 */
public interface LeaderboardRepository {

    /**
     * Get leaderboard for a game with pagination
     * @param gameId the game ID
     * @param pageRequest pagination parameters
     * @return paginated leaderboard entries sorted by rank
     */
    Page<LeaderboardEntryDTO> findByGameId(UUID gameId, PageRequest pageRequest);

    /**
     * Get leaderboard for a specific week with pagination
     * @param gameId the game ID
     * @param week the week number
     * @param pageRequest pagination parameters
     * @return paginated leaderboard entries for the specified week
     */
    Page<LeaderboardEntryDTO> findByGameIdAndWeek(UUID gameId, int week, PageRequest pageRequest);

    /**
     * Get leaderboard for active (non-eliminated) players only
     * @param gameId the game ID
     * @param pageRequest pagination parameters
     * @return paginated leaderboard entries for active players only
     */
    Page<LeaderboardEntryDTO> findActivePlayersByGameId(UUID gameId, PageRequest pageRequest);

    /**
     * Get leaderboard for eliminated players only
     * @param gameId the game ID
     * @param pageRequest pagination parameters
     * @return paginated leaderboard entries for eliminated players only
     */
    Page<LeaderboardEntryDTO> findEliminatedPlayersByGameId(UUID gameId, PageRequest pageRequest);
}
