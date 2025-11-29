package com.ffl.playoffs.infrastructure.persistence.mongodb.repository;

import com.ffl.playoffs.infrastructure.persistence.mongodb.document.NFLGameDocument;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for NFL Game documents
 * Provides access to the 'nfl_games' collection
 */
@Repository
public interface MongoNFLGameRepository extends MongoRepository<NFLGameDocument, String> {

    /**
     * Find a game by its external game ID
     * @param gameId the external game ID
     * @return Optional containing the game if found
     */
    Optional<NFLGameDocument> findByGameId(String gameId);

    /**
     * Find all games for a specific season
     * @param season the NFL season year
     * @return list of games in that season
     */
    List<NFLGameDocument> findBySeason(Integer season);

    /**
     * Find all games for a specific season with pagination
     * @param season the NFL season year
     * @param pageable pagination info
     * @return page of games in that season
     */
    Page<NFLGameDocument> findBySeason(Integer season, Pageable pageable);

    /**
     * Find all games for a specific week in a season
     * @param season the NFL season year
     * @param week the week number
     * @return list of games for that week
     */
    List<NFLGameDocument> findBySeasonAndWeek(Integer season, Integer week);

    /**
     * Find all games involving a specific team in a season
     * @param team the team abbreviation
     * @param season the NFL season year
     * @return list of games involving that team
     */
    @Query("{ $and: [ { 'season': ?1 }, { $or: [ { 'home_team': ?0 }, { 'away_team': ?0 } ] } ] }")
    List<NFLGameDocument> findByTeamAndSeason(String team, Integer season);

    /**
     * Find all games with a specific status
     * @param status the game status (e.g., "SCHEDULED", "IN_PROGRESS", "FINAL")
     * @return list of games with that status
     */
    List<NFLGameDocument> findByStatus(String status);

    /**
     * Find all games that are currently active (in progress or at halftime)
     * @return list of active games
     */
    @Query("{ 'status': { $in: ['IN_PROGRESS', 'HALFTIME'] } }")
    List<NFLGameDocument> findActiveGames();

    /**
     * Find all games scheduled for a specific week
     * @param season the NFL season year
     * @param week the week number
     * @param status the game status
     * @return list of matching games
     */
    List<NFLGameDocument> findBySeasonAndWeekAndStatus(Integer season, Integer week, String status);

    /**
     * Count games by season
     * @param season the NFL season year
     * @return count of games in that season
     */
    long countBySeason(Integer season);

    /**
     * Count games by season and week
     * @param season the NFL season year
     * @param week the week number
     * @return count of games for that week
     */
    long countBySeasonAndWeek(Integer season, Integer week);

    /**
     * Check if a game exists by game ID
     * @param gameId the external game ID
     * @return true if the game exists
     */
    boolean existsByGameId(String gameId);
}
