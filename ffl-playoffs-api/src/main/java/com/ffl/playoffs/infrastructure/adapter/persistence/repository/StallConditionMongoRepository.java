package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.StallConditionDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

/**
 * Spring Data MongoDB repository for Stall Condition
 */
@Repository
public interface StallConditionMongoRepository extends MongoRepository<StallConditionDocument, UUID> {

    List<StallConditionDocument> findByLeagueId(UUID leagueId);

    List<StallConditionDocument> findByLeagueIdAndResolvedFalse(UUID leagueId);

    List<StallConditionDocument> findByLeagueIdAndResolvedTrue(UUID leagueId);

    List<StallConditionDocument> findByLeagueIdAndType(UUID leagueId, String type);

    List<StallConditionDocument> findByLeagueIdAndSeverity(UUID leagueId, String severity);

    @Query("{ 'leagueId': ?0, 'affectedPlayerIds': ?1 }")
    List<StallConditionDocument> findByLeagueIdAndAffectedPlayerId(UUID leagueId, UUID playerId);

    long countByLeagueIdAndResolvedFalse(UUID leagueId);

    long countByLeagueIdAndType(UUID leagueId, String type);

    void deleteByLeagueId(UUID leagueId);

    @Query(value = "{ 'leagueId': ?0, 'resolved': true, 'resolvedAt': { $lt: ?1 } }", delete = true)
    void deleteResolvedOlderThan(UUID leagueId, Instant threshold);
}
