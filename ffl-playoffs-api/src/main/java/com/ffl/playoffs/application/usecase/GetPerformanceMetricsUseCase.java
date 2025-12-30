package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.PerformanceMetricSnapshot;
import com.ffl.playoffs.domain.model.performance.MetricType;
import com.ffl.playoffs.domain.port.PerformanceMetricRepository;
import com.ffl.playoffs.domain.port.PerformanceMetricRepository.AggregatedMetric;
import com.ffl.playoffs.domain.port.PerformanceMetricRepository.AggregationInterval;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.Optional;

/**
 * Use case for retrieving and querying performance metrics.
 */
@Slf4j
@RequiredArgsConstructor
public class GetPerformanceMetricsUseCase {

    private final PerformanceMetricRepository metricRepository;

    /**
     * Get the latest metrics snapshot.
     */
    public Optional<PerformanceMetricSnapshot> getLatest() {
        log.debug("Getting latest performance metrics");
        return metricRepository.findLatest();
    }

    /**
     * Get the latest metrics for a specific service.
     */
    public Optional<PerformanceMetricSnapshot> getLatestByService(String service) {
        log.debug("Getting latest performance metrics for service: {}", service);
        return metricRepository.findLatestByService(service);
    }

    /**
     * Get metrics for the last N minutes.
     */
    public List<PerformanceMetricSnapshot> getRecentMetrics(int minutes) {
        Instant start = Instant.now().minus(Duration.ofMinutes(minutes));
        Instant end = Instant.now();
        log.debug("Getting metrics for last {} minutes", minutes);
        return metricRepository.findByTimeRange(start, end);
    }

    /**
     * Get metrics for a time range.
     */
    public List<PerformanceMetricSnapshot> getByTimeRange(Instant start, Instant end) {
        log.debug("Getting metrics from {} to {}", start, end);
        return metricRepository.findByTimeRange(start, end);
    }

    /**
     * Get metrics for a service within a time range.
     */
    public List<PerformanceMetricSnapshot> getByServiceAndTimeRange(String service, Instant start, Instant end) {
        log.debug("Getting metrics for service {} from {} to {}", service, start, end);
        return metricRepository.findByServiceAndTimeRange(service, start, end);
    }

    /**
     * Get aggregated metrics for charting.
     */
    public List<AggregatedMetric> getAggregatedMetrics(MetricType type, Instant start, Instant end,
                                                       AggregationInterval interval) {
        log.debug("Getting aggregated {} metrics from {} to {} at {} interval",
                type, start, end, interval);
        return metricRepository.getAggregatedMetrics(type, start, end, interval);
    }

    /**
     * Calculate current health score based on latest metrics.
     */
    public Optional<Double> getCurrentHealthScore() {
        return getLatest().map(PerformanceMetricSnapshot::calculateHealthScore);
    }

    /**
     * Get count of metrics in a time range.
     */
    public long getMetricsCount(Instant start, Instant end) {
        return metricRepository.countByTimeRange(start, end);
    }
}
