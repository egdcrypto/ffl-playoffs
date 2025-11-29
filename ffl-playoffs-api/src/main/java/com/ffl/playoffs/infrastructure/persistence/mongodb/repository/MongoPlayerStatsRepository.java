package com.ffl.playoffs.infrastructure.persistence.mongodb.repository;

import com.ffl.playoffs.infrastructure.persistence.mongodb.document.PlayerStatsDocument;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for Player Stats documents
 * Provides access to the 'player_stats' collection
 */
@Repository
public interface MongoPlayerStatsRepository extends MongoRepository<PlayerStatsDocument, String> {

    /**
     * Find stats for a specific player in a specific week
     * @param playerId the player ID
     * @param season the NFL season year
     * @param week the week number
     * @return Optional containing the stats if found
     */
    Optional<PlayerStatsDocument> findByPlayerIdAndSeasonAndWeek(String playerId, Integer season, Integer week);

    /**
     * Find all stats for a specific player in a season
     * @param playerId the player ID
     * @param season the NFL season year
     * @return list of weekly stats for the player
     */
    List<PlayerStatsDocument> findByPlayerIdAndSeason(String playerId, Integer season);

    /**
     * Find all stats for a specific player
     * @param playerId the player ID
     * @return list of all stats for the player
     */
    List<PlayerStatsDocument> findByPlayerId(String playerId);

    /**
     * Find all stats for a specific player with pagination
     * @param playerId the player ID
     * @param pageable pagination info
     * @return page of stats for the player
     */
    Page<PlayerStatsDocument> findByPlayerId(String playerId, Pageable pageable);

    /**
     * Find all stats for a specific week in a season
     * @param season the NFL season year
     * @param week the week number
     * @return list of all player stats for that week
     */
    List<PlayerStatsDocument> findBySeasonAndWeek(Integer season, Integer week);

    /**
     * Find all stats for a specific week with pagination
     * @param season the NFL season year
     * @param week the week number
     * @param pageable pagination info
     * @return page of player stats for that week
     */
    Page<PlayerStatsDocument> findBySeasonAndWeek(Integer season, Integer week, Pageable pageable);

    /**
     * Find stats for players at a specific position in a week
     * @param position the position (e.g., "QB")
     * @param season the NFL season year
     * @param week the week number
     * @return list of stats for players at that position
     */
    List<PlayerStatsDocument> findByPositionAndSeasonAndWeek(String position, Integer season, Integer week);

    /**
     * Find stats for a specific team in a week
     * @param team the team abbreviation
     * @param season the NFL season year
     * @param week the week number
     * @return list of stats for players on that team
     */
    List<PlayerStatsDocument> findByTeamAndSeasonAndWeek(String team, Integer season, Integer week);

    /**
     * Find top scorers for a week based on total touchdowns
     * @param season the NFL season year
     * @param week the week number
     * @param pageable pagination info
     * @return page of top scorers
     */
    @Query(value = "{ 'season': ?0, 'week': ?1 }",
           sort = "{ 'passing_tds': -1, 'rushing_tds': -1, 'receiving_tds': -1 }")
    Page<PlayerStatsDocument> findTopScorersByWeek(Integer season, Integer week, Pageable pageable);

    /**
     * Count stats by season
     * @param season the NFL season year
     * @return count of stat records for that season
     */
    long countBySeason(Integer season);

    /**
     * Count stats by season and week
     * @param season the NFL season year
     * @param week the week number
     * @return count of stat records for that week
     */
    long countBySeasonAndWeek(Integer season, Integer week);

    /**
     * Check if stats exist for a player in a specific week
     * @param playerId the player ID
     * @param season the NFL season year
     * @param week the week number
     * @return true if stats exist
     */
    boolean existsByPlayerIdAndSeasonAndWeek(String playerId, Integer season, Integer week);
}
