package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.PerformanceMetricSnapshot;
import com.ffl.playoffs.domain.model.performance.MetricType;
import com.ffl.playoffs.domain.port.PerformanceMetricRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.time.Duration;
import java.time.Instant;
import java.util.Map;

/**
 * Use case for recording performance metric snapshots.
 */
@Slf4j
@RequiredArgsConstructor
public class RecordPerformanceMetricsUseCase {

    private final PerformanceMetricRepository metricRepository;

    /**
     * Record a new metric snapshot.
     */
    public PerformanceMetricSnapshot execute(Command command) {
        log.debug("Recording metrics for service: {}", command.service());

        PerformanceMetricSnapshot snapshot = PerformanceMetricSnapshot.create(
                command.source(),
                command.service(),
                command.metrics()
        );

        if (command.endpoint() != null) {
            snapshot.setEndpoint(command.endpoint());
        }

        if (command.tags() != null) {
            command.tags().forEach(snapshot::addTag);
        }

        PerformanceMetricSnapshot saved = metricRepository.save(snapshot);
        log.debug("Recorded metric snapshot with ID: {}", saved.getId());

        return saved;
    }

    /**
     * Clean up old metrics based on retention policy.
     */
    public long cleanupOldMetrics(Duration retention) {
        Instant cutoff = Instant.now().minus(retention);
        log.info("Cleaning up metrics older than {}", cutoff);

        long deleted = metricRepository.deleteOlderThan(cutoff);
        log.info("Deleted {} old metric snapshots", deleted);

        return deleted;
    }

    public record Command(
            String source,
            String service,
            String endpoint,
            Map<MetricType, Double> metrics,
            Map<String, String> tags
    ) {}
}
