package com.ffl.playoffs.infrastructure.persistence.mongodb.repository;

import com.ffl.playoffs.infrastructure.persistence.mongodb.document.ScoreUpdateDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for Score Update documents
 * Provides access to the 'score_updates' collection
 */
@Repository
public interface MongoScoreUpdateRepository extends MongoRepository<ScoreUpdateDocument, String> {

    /**
     * Find score updates for a player since a specific time
     */
    List<ScoreUpdateDocument> findByLeaguePlayerIdAndTimestampAfterOrderByTimestampDesc(
            String leaguePlayerId, LocalDateTime since);

    /**
     * Find score updates for a league since a specific time
     */
    List<ScoreUpdateDocument> findByLeagueIdAndTimestampAfterOrderByTimestampDesc(
            String leagueId, LocalDateTime since);

    /**
     * Check if idempotency key exists (for duplicate detection)
     */
    boolean existsByIdempotencyKey(String idempotencyKey);

    /**
     * Find by idempotency key
     */
    Optional<ScoreUpdateDocument> findByIdempotencyKey(String idempotencyKey);

    /**
     * Get recent updates for a player (last N)
     */
    List<ScoreUpdateDocument> findTop10ByLeaguePlayerIdOrderByTimestampDesc(String leaguePlayerId);

    /**
     * Delete old updates (cleanup older than threshold)
     */
    void deleteByTimestampBefore(LocalDateTime before);

    /**
     * Count updates for a player in a time window
     */
    long countByLeaguePlayerIdAndTimestampBetween(
            String leaguePlayerId, LocalDateTime start, LocalDateTime end);
}
