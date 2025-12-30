package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.loadtest.*;
import lombok.*;

import java.time.Duration;
import java.time.Instant;
import java.util.*;

/**
 * Aggregate root representing a single execution of a load test.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LoadTestRun {
    private UUID id;
    private UUID scenarioId;
    private UUID worldId;
    private LoadTestStatus status;
    private LoadTestConfiguration configuration;
    private Instant startTime;
    private Instant endTime;
    private List<LoadTestMetric> metrics;
    private Map<MetricType, LoadTestThreshold.ThresholdResult> thresholdResults;
    private Integer totalRequests;
    private Integer successfulRequests;
    private Integer failedRequests;
    private String errorMessage;
    private String triggeredBy;
    private Instant createdAt;
    private Instant updatedAt;

    /**
     * Create a new load test run for a scenario.
     */
    public static LoadTestRun create(UUID scenarioId, UUID worldId, LoadTestConfiguration configuration) {
        Objects.requireNonNull(scenarioId, "Scenario ID is required");
        Objects.requireNonNull(worldId, "World ID is required");

        LoadTestRun run = new LoadTestRun();
        run.id = UUID.randomUUID();
        run.scenarioId = scenarioId;
        run.worldId = worldId;
        run.status = LoadTestStatus.PENDING;
        run.configuration = configuration;
        run.metrics = new ArrayList<>();
        run.thresholdResults = new HashMap<>();
        run.totalRequests = 0;
        run.successfulRequests = 0;
        run.failedRequests = 0;
        run.createdAt = Instant.now();
        run.updatedAt = Instant.now();

        return run;
    }

    /**
     * Start the test run.
     */
    public void start() {
        if (status != LoadTestStatus.PENDING && status != LoadTestStatus.SCHEDULED) {
            throw new IllegalStateException("Cannot start test run in status: " + status);
        }
        this.status = LoadTestStatus.RUNNING;
        this.startTime = Instant.now();
        this.updatedAt = Instant.now();
    }

    /**
     * Complete the test run successfully.
     */
    public void complete() {
        if (status != LoadTestStatus.RUNNING) {
            throw new IllegalStateException("Cannot complete test run in status: " + status);
        }
        this.status = LoadTestStatus.COMPLETED;
        this.endTime = Instant.now();
        this.updatedAt = Instant.now();
        evaluateThresholds();
    }

    /**
     * Mark the test run as failed.
     */
    public void fail(String errorMessage) {
        this.status = LoadTestStatus.FAILED;
        this.errorMessage = errorMessage;
        this.endTime = Instant.now();
        this.updatedAt = Instant.now();
    }

    /**
     * Cancel the test run.
     */
    public void cancel() {
        if (status == LoadTestStatus.COMPLETED || status == LoadTestStatus.FAILED) {
            throw new IllegalStateException("Cannot cancel test run in status: " + status);
        }
        this.status = LoadTestStatus.CANCELLED;
        this.endTime = Instant.now();
        this.updatedAt = Instant.now();
    }

    /**
     * Mark as timed out.
     */
    public void timeout() {
        this.status = LoadTestStatus.TIMED_OUT;
        this.errorMessage = "Test run exceeded configured timeout";
        this.endTime = Instant.now();
        this.updatedAt = Instant.now();
    }

    /**
     * Record a metric from the test.
     */
    public void recordMetric(LoadTestMetric metric) {
        if (metrics == null) {
            metrics = new ArrayList<>();
        }
        metrics.add(metric);
        this.updatedAt = Instant.now();
    }

    /**
     * Record request counts.
     */
    public void recordRequests(int total, int successful, int failed) {
        this.totalRequests = total;
        this.successfulRequests = successful;
        this.failedRequests = failed;
        this.updatedAt = Instant.now();
    }

    /**
     * Increment request counts.
     */
    public void incrementRequests(boolean success) {
        this.totalRequests++;
        if (success) {
            this.successfulRequests++;
        } else {
            this.failedRequests++;
        }
        this.updatedAt = Instant.now();
    }

    /**
     * Evaluate thresholds against recorded metrics.
     */
    public void evaluateThresholds() {
        if (configuration == null || metrics == null) {
            return;
        }

        Map<MetricType, Double> latestMetrics = new HashMap<>();
        for (LoadTestMetric metric : metrics) {
            latestMetrics.put(metric.getType(), metric.getValue());
        }

        for (Map.Entry<MetricType, LoadTestThreshold> entry :
                configuration.getThresholds().entrySet()) {
            MetricType type = entry.getKey();
            LoadTestThreshold threshold = entry.getValue();
            Double value = latestMetrics.get(type);
            thresholdResults.put(type, threshold.evaluate(value));
        }
    }

    /**
     * Get the duration of the test run.
     */
    public Duration getDuration() {
        if (startTime == null) {
            return Duration.ZERO;
        }
        Instant end = endTime != null ? endTime : Instant.now();
        return Duration.between(startTime, end);
    }

    /**
     * Get success rate as a percentage.
     */
    public Double getSuccessRate() {
        if (totalRequests == null || totalRequests == 0) {
            return 0.0;
        }
        return (successfulRequests.doubleValue() / totalRequests) * 100;
    }

    /**
     * Check if all thresholds passed.
     */
    public boolean allThresholdsPassed() {
        if (thresholdResults == null || thresholdResults.isEmpty()) {
            return true;
        }
        return thresholdResults.values().stream()
                .noneMatch(r -> r == LoadTestThreshold.ThresholdResult.FAILURE);
    }

    /**
     * Check if any threshold has a warning.
     */
    public boolean hasThresholdWarnings() {
        if (thresholdResults == null) {
            return false;
        }
        return thresholdResults.values().stream()
                .anyMatch(r -> r == LoadTestThreshold.ThresholdResult.WARNING);
    }

    /**
     * Get metrics by type.
     */
    public List<LoadTestMetric> getMetricsByType(MetricType type) {
        if (metrics == null) {
            return Collections.emptyList();
        }
        return metrics.stream()
                .filter(m -> m.getType() == type)
                .toList();
    }

    /**
     * Get the latest metric value for a type.
     */
    public Optional<LoadTestMetric> getLatestMetric(MetricType type) {
        if (metrics == null) {
            return Optional.empty();
        }
        return metrics.stream()
                .filter(m -> m.getType() == type)
                .max(Comparator.comparing(LoadTestMetric::getTimestamp));
    }
}
