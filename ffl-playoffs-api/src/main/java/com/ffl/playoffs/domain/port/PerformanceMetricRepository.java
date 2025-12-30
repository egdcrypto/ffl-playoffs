package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.PerformanceMetricSnapshot;
import com.ffl.playoffs.domain.model.performance.MetricType;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository port for PerformanceMetricSnapshot aggregate.
 */
public interface PerformanceMetricRepository {

    /**
     * Save a metric snapshot.
     */
    PerformanceMetricSnapshot save(PerformanceMetricSnapshot snapshot);

    /**
     * Find snapshot by ID.
     */
    Optional<PerformanceMetricSnapshot> findById(UUID id);

    /**
     * Find the latest snapshot.
     */
    Optional<PerformanceMetricSnapshot> findLatest();

    /**
     * Find the latest snapshot for a service.
     */
    Optional<PerformanceMetricSnapshot> findLatestByService(String service);

    /**
     * Find snapshots in a time range.
     */
    List<PerformanceMetricSnapshot> findByTimeRange(Instant start, Instant end);

    /**
     * Find snapshots for a service in a time range.
     */
    List<PerformanceMetricSnapshot> findByServiceAndTimeRange(String service, Instant start, Instant end);

    /**
     * Find snapshots for an endpoint in a time range.
     */
    List<PerformanceMetricSnapshot> findByEndpointAndTimeRange(String endpoint, Instant start, Instant end);

    /**
     * Get aggregated metric values over a time range.
     */
    List<AggregatedMetric> getAggregatedMetrics(MetricType type, Instant start, Instant end,
                                                AggregationInterval interval);

    /**
     * Delete snapshots older than a given timestamp.
     */
    long deleteOlderThan(Instant timestamp);

    /**
     * Count snapshots in a time range.
     */
    long countByTimeRange(Instant start, Instant end);

    /**
     * Aggregated metric result.
     */
    record AggregatedMetric(
            Instant timestamp,
            Double avg,
            Double min,
            Double max,
            Double sum,
            Long count
    ) {}

    /**
     * Aggregation interval.
     */
    enum AggregationInterval {
        MINUTE,
        FIVE_MINUTES,
        HOUR,
        DAY
    }
}
