package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.AIDirectorDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Spring Data MongoDB repository for AI Director
 */
@Repository
public interface AIDirectorMongoRepository extends MongoRepository<AIDirectorDocument, UUID> {

    Optional<AIDirectorDocument> findByLeagueId(UUID leagueId);

    List<AIDirectorDocument> findByStatus(String status);

    @Query("{ 'activeStallConditionIds': { $exists: true, $ne: [] } }")
    List<AIDirectorDocument> findWithActiveStalls();

    @Query("{ 'pendingActionIds': { $exists: true, $ne: [] } }")
    List<AIDirectorDocument> findWithPendingActions();

    @Query("{ 'lastActivityAt': { $lt: ?0 }, 'status': 'active' }")
    List<AIDirectorDocument> findInactiveSince(Instant threshold);

    boolean existsByLeagueId(UUID leagueId);

    void deleteByLeagueId(UUID leagueId);
}
