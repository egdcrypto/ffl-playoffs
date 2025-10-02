package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.*;

import java.util.List;
import java.util.Optional;

/**
 * Port (interface) for NFL data integration via SportsData.io Fantasy API.
 * This defines the contract for fetching individual NFL player statistics,
 * defensive team statistics, game metadata, and player information.
 *
 * Designed for traditional fantasy football (individual player-based scoring),
 * not survivor pool (team selection).
 *
 * @see <a href="docs/NFL_DATA_INTEGRATION_PROPOSAL.md">NFL Data Integration Proposal</a>
 */
public interface NflDataProvider {

    // ==================== PLAYER STATS ====================

    /**
     * Fetch individual NFL player stats for a specific week.
     * Returns stats for ALL players who played in the specified week.
     *
     * @param nflWeek NFL week number (1-22)
     * @return List of player statistics for all games in that week
     */
    List<PlayerStats> getPlayerStatsByWeek(Integer nflWeek);

    /**
     * Fetch individual NFL player stats for a specific player in a specific week.
     *
     * @param nflPlayerId SportsData.io player ID
     * @param nflWeek NFL week number (1-22)
     * @return Player statistics for that week, or empty if player didn't play
     */
    Optional<PlayerStats> getPlayerStats(String nflPlayerId, Integer nflWeek);

    /**
     * Fetch individual NFL player stats for a specific game.
     *
     * @param nflPlayerId SportsData.io player ID
     * @param nflGameId SportsData.io game ID
     * @return Player statistics for that game, or empty if player didn't play
     */
    Optional<PlayerStats> getPlayerStatsForGame(String nflPlayerId, String nflGameId);

    // ==================== DEFENSIVE STATS ====================

    /**
     * Fetch team defense stats for a specific week.
     * Returns defensive stats for ALL teams in the specified week.
     *
     * @param nflWeek NFL week number (1-22)
     * @return List of defensive statistics for all teams in that week
     */
    List<DefensiveStats> getDefensiveStatsByWeek(Integer nflWeek);

    /**
     * Fetch team defense stats for a specific team in a specific week.
     *
     * @param nflTeam NFL team abbreviation (e.g., "KC", "BUF")
     * @param nflWeek NFL week number (1-22)
     * @return Defensive statistics for that team in that week
     */
    Optional<DefensiveStats> getDefensiveStats(String nflTeam, Integer nflWeek);

    /**
     * Fetch team defense stats for a specific game.
     *
     * @param nflTeam NFL team abbreviation
     * @param nflGameId SportsData.io game ID
     * @return Defensive statistics for that team in that game
     */
    Optional<DefensiveStats> getDefensiveStatsForGame(String nflTeam, String nflGameId);

    // ==================== KICKER STATS ====================

    /**
     * Fetch kicker stats for a specific week.
     *
     * @param nflWeek NFL week number (1-22)
     * @return List of kicker statistics for all kickers in that week
     */
    List<KickerStats> getKickerStatsByWeek(Integer nflWeek);

    /**
     * Fetch kicker stats for a specific kicker in a specific week.
     *
     * @param nflPlayerId SportsData.io player ID
     * @param nflWeek NFL week number (1-22)
     * @return Kicker statistics for that week
     */
    Optional<KickerStats> getKickerStats(String nflPlayerId, Integer nflWeek);

    // ==================== GAME METADATA ====================

    /**
     * Fetch all NFL games for a specific week.
     *
     * @param nflWeek NFL week number (1-22)
     * @return List of all games in that week with metadata
     */
    List<NflGame> getGamesByWeek(Integer nflWeek);

    /**
     * Fetch specific NFL game metadata.
     *
     * @param nflGameId SportsData.io game ID
     * @return Game metadata including status, scores, teams
     */
    Optional<NflGame> getGame(String nflGameId);

    /**
     * Check if games are currently live (in progress).
     * Used to determine if real-time polling should be active.
     *
     * @param nflWeek NFL week number (1-22)
     * @return True if any games in that week are currently in progress
     */
    boolean hasLiveGames(Integer nflWeek);

    // ==================== PLAYER SEARCH ====================

    /**
     * Search for NFL players by name.
     * Used for roster building UI to find players.
     *
     * @param nameQuery Partial player name (e.g., "Mahomes")
     * @param position Optional position filter (QB, RB, WR, TE, K, DEF)
     * @param limit Maximum number of results
     * @return List of matching players with metadata
     */
    List<NflPlayer> searchPlayers(String nameQuery, Optional<Position> position, Integer limit);

    /**
     * Get all active NFL players for a specific position.
     * Used for roster building UI to show position-specific player lists.
     *
     * @param position Player position (QB, RB, WR, TE, K, DEF)
     * @return List of all active players for that position
     */
    List<NflPlayer> getPlayersByPosition(Position position);

    /**
     * Get NFL player profile by ID.
     *
     * @param nflPlayerId SportsData.io player ID
     * @return Player profile with metadata (name, team, position, etc.)
     */
    Optional<NflPlayer> getPlayerById(String nflPlayerId);

    // ==================== NEWS & INJURIES ====================

    /**
     * Fetch latest news for a specific player.
     *
     * @param nflPlayerId SportsData.io player ID
     * @return List of news items for that player
     */
    List<PlayerNews> getPlayerNews(String nflPlayerId);

    /**
     * Fetch injury status for a specific player.
     *
     * @param nflPlayerId SportsData.io player ID
     * @return Injury status (Out, Doubtful, Questionable, Healthy)
     */
    Optional<InjuryStatus> getPlayerInjuryStatus(String nflPlayerId);

    /**
     * Fetch injury report for all players in a specific week.
     *
     * @param nflWeek NFL week number (1-22)
     * @return List of injury reports for that week
     */
    List<InjuryReport> getInjuryReportByWeek(Integer nflWeek);
}
