package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.WeekDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for WeekDocument
 * Infrastructure layer - MongoDB specific
 */
@Repository
public interface WeekMongoRepository extends MongoRepository<WeekDocument, String> {

    /**
     * Find all weeks for a league, ordered by game week number
     */
    List<WeekDocument> findByLeagueIdOrderByGameWeekNumberAsc(String leagueId);

    /**
     * Find week by league ID and game week number
     */
    Optional<WeekDocument> findByLeagueIdAndGameWeekNumber(String leagueId, Integer gameWeekNumber);

    /**
     * Find week by league ID and NFL week number
     */
    Optional<WeekDocument> findByLeagueIdAndNflWeekNumber(String leagueId, Integer nflWeekNumber);

    /**
     * Find current active or locked week for a league
     */
    @Query(value = "{ 'leagueId': ?0, 'status': { $in: ['ACTIVE', 'LOCKED'] } }")
    Optional<WeekDocument> findCurrentWeek(String leagueId);

    /**
     * Find all weeks with a specific status for a league
     */
    List<WeekDocument> findByLeagueIdAndStatus(String leagueId, String status);

    /**
     * Check if weeks exist for a league
     */
    boolean existsByLeagueId(String leagueId);

    /**
     * Count weeks for a league
     */
    long countByLeagueId(String leagueId);

    /**
     * Delete all weeks for a league
     */
    void deleteByLeagueId(String leagueId);
}
