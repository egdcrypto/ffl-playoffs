package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.CuratorActionDocument;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

/**
 * Spring Data MongoDB repository for Curator Action
 */
@Repository
public interface CuratorActionMongoRepository extends MongoRepository<CuratorActionDocument, UUID> {

    List<CuratorActionDocument> findByLeagueId(UUID leagueId);

    List<CuratorActionDocument> findByLeagueIdAndStatus(UUID leagueId, String status);

    List<CuratorActionDocument> findByLeagueIdAndType(UUID leagueId, String type);

    List<CuratorActionDocument> findByLeagueIdAndAutomatedTrue(UUID leagueId);

    List<CuratorActionDocument> findByLeagueIdAndAutomatedFalse(UUID leagueId);

    List<CuratorActionDocument> findByInitiatedBy(UUID userId);

    List<CuratorActionDocument> findByRelatedStallConditionId(UUID stallConditionId);

    List<CuratorActionDocument> findByRelatedStoryArcId(UUID storyArcId);

    @Query("{ 'targetPlayerIds': ?0 }")
    List<CuratorActionDocument> findByTargetPlayerId(UUID playerId);

    List<CuratorActionDocument> findByLeagueIdOrderByCreatedAtDesc(UUID leagueId, Pageable pageable);

    long countByLeagueIdAndStatus(UUID leagueId, String status);

    long countByLeagueIdAndType(UUID leagueId, String type);

    void deleteByLeagueId(UUID leagueId);

    @Query(value = "{ 'leagueId': ?0, 'status': 'COMPLETED', 'completedAt': { $lt: ?1 } }", delete = true)
    void deleteCompletedOlderThan(UUID leagueId, Instant threshold);
}
