package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.NFLPlayer;
import com.ffl.playoffs.domain.model.Position;

import java.util.List;
import java.util.Optional;

/**
 * Port interface for NFL Player persistence
 * Domain defines the contract, infrastructure implements it
 * No framework dependencies in this interface
 */
public interface NFLPlayerRepository {

    /**
     * Find an NFL player by their ID
     * @param id the NFL player ID
     * @return Optional containing the player if found
     */
    Optional<NFLPlayer> findById(Long id);

    /**
     * Find all NFL players
     * @return list of all NFL players
     */
    List<NFLPlayer> findAll();

    /**
     * Find NFL players by position
     * @param position the position to filter by
     * @return list of players at that position
     */
    List<NFLPlayer> findByPosition(Position position);

    /**
     * Find NFL players by team
     * @param teamCode the NFL team code (e.g., "KC", "SF")
     * @return list of players on that team
     */
    List<NFLPlayer> findByTeam(String teamCode);

    /**
     * Find active NFL players
     * @return list of active players
     */
    List<NFLPlayer> findActivePlayer();

    /**
     * Save an NFL player
     * @param player the player to save
     * @return the saved player
     */
    NFLPlayer save(NFLPlayer player);

    /**
     * Save multiple NFL players
     * @param players the players to save
     * @return list of saved players
     */
    List<NFLPlayer> saveAll(List<NFLPlayer> players);

    /**
     * Check if a player exists by ID
     * @param id the player ID
     * @return true if player exists
     */
    boolean existsById(Long id);
}
