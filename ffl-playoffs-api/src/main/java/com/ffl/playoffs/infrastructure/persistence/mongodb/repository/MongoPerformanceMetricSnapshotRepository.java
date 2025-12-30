package com.ffl.playoffs.infrastructure.persistence.mongodb.repository;

import com.ffl.playoffs.infrastructure.persistence.mongodb.document.PerformanceMetricSnapshotDocument;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for PerformanceMetricSnapshotDocument.
 */
@Repository
public interface MongoPerformanceMetricSnapshotRepository extends MongoRepository<PerformanceMetricSnapshotDocument, String> {

    Optional<PerformanceMetricSnapshotDocument> findTopByOrderByTimestampDesc();

    Optional<PerformanceMetricSnapshotDocument> findTopByServiceOrderByTimestampDesc(String service);

    List<PerformanceMetricSnapshotDocument> findByTimestampBetween(Instant start, Instant end);

    List<PerformanceMetricSnapshotDocument> findByTimestampBetween(Instant start, Instant end, Sort sort);

    List<PerformanceMetricSnapshotDocument> findByServiceAndTimestampBetween(String service, Instant start, Instant end);

    List<PerformanceMetricSnapshotDocument> findByEndpointAndTimestampBetween(String endpoint, Instant start, Instant end);

    long countByTimestampBetween(Instant start, Instant end);

    long deleteByTimestampBefore(Instant timestamp);
}
