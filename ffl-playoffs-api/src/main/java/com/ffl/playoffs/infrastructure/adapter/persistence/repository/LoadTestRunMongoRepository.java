package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.LoadTestRunDocument;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for LoadTestRunDocument.
 */
@Repository
public interface LoadTestRunMongoRepository extends MongoRepository<LoadTestRunDocument, String> {

    List<LoadTestRunDocument> findByScenarioId(String scenarioId);

    List<LoadTestRunDocument> findByWorldId(String worldId);

    List<LoadTestRunDocument> findByStatus(String status);

    Optional<LoadTestRunDocument> findByWorldIdAndStatus(String worldId, String status);

    List<LoadTestRunDocument> findByWorldIdOrderByCreatedAtDesc(String worldId, Pageable pageable);

    List<LoadTestRunDocument> findByWorldIdAndStartTimeBetween(String worldId, Instant startTime, Instant endTime);

    void deleteByWorldIdAndCreatedAtBefore(String worldId, Instant cutoffTime);
}
