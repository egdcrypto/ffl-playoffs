package com.ffl.playoffs.infrastructure.persistence.mongodb.repository;

import com.ffl.playoffs.infrastructure.persistence.mongodb.document.LiveScoreDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for Live Score documents
 * Provides access to the 'live_scores' collection
 */
@Repository
public interface MongoLiveScoreRepository extends MongoRepository<LiveScoreDocument, String> {

    /**
     * Find current live score for a league player
     */
    Optional<LiveScoreDocument> findByLeaguePlayerId(String leaguePlayerId);

    /**
     * Find all live scores for a league
     */
    List<LiveScoreDocument> findByLeagueId(String leagueId);

    /**
     * Find live scores for a league ordered by score descending
     */
    List<LiveScoreDocument> findByLeagueIdOrderByCurrentScoreDesc(String leagueId);

    /**
     * Find live scores updated since a specific time
     */
    List<LiveScoreDocument> findByLeagueIdAndUpdatedAtAfter(String leagueId, LocalDateTime since);

    /**
     * Find live scores by status
     */
    List<LiveScoreDocument> findByLeagueIdAndStatus(String leagueId, String status);

    /**
     * Get most recent update time for a league
     */
    @Query(value = "{ 'league_id': ?0 }", sort = "{ 'updated_at': -1 }")
    Optional<LiveScoreDocument> findTopByLeagueIdOrderByUpdatedAtDesc(String leagueId);

    /**
     * Delete all live scores for a league (cleanup)
     */
    void deleteByLeagueId(String leagueId);

    /**
     * Count active live scores for a league
     */
    long countByLeagueIdAndStatus(String leagueId, String status);
}
