package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.performance.MetricType;
import com.ffl.playoffs.domain.model.performance.MetricValue;
import lombok.*;

import java.time.Instant;
import java.util.*;

/**
 * Aggregate root for storing and querying performance metric snapshots.
 * Represents a collection of metrics captured at a point in time.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PerformanceMetricSnapshot {
    private UUID id;
    private Instant timestamp;
    private String source;
    private String service;
    private String endpoint;
    private Map<MetricType, Double> metrics;
    private Map<String, String> tags;

    /**
     * Create a new metric snapshot.
     */
    public static PerformanceMetricSnapshot create(String source, String service) {
        PerformanceMetricSnapshot snapshot = new PerformanceMetricSnapshot();
        snapshot.id = UUID.randomUUID();
        snapshot.timestamp = Instant.now();
        snapshot.source = source;
        snapshot.service = service;
        snapshot.metrics = new HashMap<>();
        snapshot.tags = new HashMap<>();
        return snapshot;
    }

    /**
     * Create a snapshot with all metrics.
     */
    public static PerformanceMetricSnapshot create(String source, String service,
                                                   Map<MetricType, Double> metrics) {
        PerformanceMetricSnapshot snapshot = create(source, service);
        snapshot.metrics = new HashMap<>(metrics);
        return snapshot;
    }

    /**
     * Add or update a metric value.
     */
    public void recordMetric(MetricType type, Double value) {
        Objects.requireNonNull(type, "Metric type is required");
        if (this.metrics == null) {
            this.metrics = new HashMap<>();
        }
        this.metrics.put(type, value);
    }

    /**
     * Add or update a metric from a MetricValue.
     */
    public void recordMetric(MetricValue metricValue) {
        Objects.requireNonNull(metricValue, "Metric value is required");
        recordMetric(metricValue.getType(), metricValue.getValue());
    }

    /**
     * Add a tag for additional context.
     */
    public void addTag(String key, String value) {
        Objects.requireNonNull(key, "Tag key is required");
        if (this.tags == null) {
            this.tags = new HashMap<>();
        }
        this.tags.put(key, value);
    }

    /**
     * Get a specific metric value.
     */
    public Optional<Double> getMetric(MetricType type) {
        if (metrics == null) {
            return Optional.empty();
        }
        return Optional.ofNullable(metrics.get(type));
    }

    /**
     * Get a MetricValue for a specific type.
     */
    public Optional<MetricValue> getMetricValue(MetricType type) {
        return getMetric(type)
                .map(value -> MetricValue.of(type, value, getUnitForType(type), timestamp, source));
    }

    /**
     * Calculate overall health score from component metrics.
     */
    public Double calculateHealthScore() {
        double score = 100.0;

        // Deduct for high error rate
        Optional<Double> errorRate = getMetric(MetricType.ERROR_RATE);
        if (errorRate.isPresent()) {
            score -= errorRate.get() * 5; // 1% error = 5 point deduction
        }

        // Deduct for high response time
        Optional<Double> responseTime = getMetric(MetricType.AVERAGE_RESPONSE_TIME);
        if (responseTime.isPresent() && responseTime.get() > 200) {
            score -= (responseTime.get() - 200) / 100; // Deduct 1 point per 100ms over 200ms
        }

        // Deduct for high CPU usage
        Optional<Double> cpuUsage = getMetric(MetricType.CPU_UTILIZATION);
        if (cpuUsage.isPresent() && cpuUsage.get() > 80) {
            score -= (cpuUsage.get() - 80); // Deduct points for CPU over 80%
        }

        // Deduct for high memory usage
        Optional<Double> memoryUsage = getMetric(MetricType.MEMORY_UTILIZATION);
        if (memoryUsage.isPresent() && memoryUsage.get() > 80) {
            score -= (memoryUsage.get() - 80); // Deduct points for memory over 80%
        }

        return Math.max(0, Math.min(100, score));
    }

    /**
     * Check if any metric exceeds its threshold.
     */
    public List<MetricType> getMetricsExceedingThresholds(Map<MetricType, Double> thresholds) {
        if (metrics == null || thresholds == null) {
            return Collections.emptyList();
        }

        List<MetricType> exceeding = new ArrayList<>();
        for (Map.Entry<MetricType, Double> entry : thresholds.entrySet()) {
            Double currentValue = metrics.get(entry.getKey());
            if (currentValue != null && currentValue > entry.getValue()) {
                exceeding.add(entry.getKey());
            }
        }
        return exceeding;
    }

    /**
     * Get unit for a metric type.
     */
    private String getUnitForType(MetricType type) {
        return switch (type.getCategory()) {
            case LATENCY -> "ms";
            case THROUGHPUT -> "req/s";
            case ERROR, INFRASTRUCTURE, AVAILABILITY -> "%";
            default -> "";
        };
    }

    /**
     * Check if this snapshot has a specific tag.
     */
    public boolean hasTag(String key, String value) {
        return tags != null && value.equals(tags.get(key));
    }

    /**
     * Get the age of this snapshot.
     */
    public java.time.Duration getAge() {
        return java.time.Duration.between(timestamp, Instant.now());
    }
}
