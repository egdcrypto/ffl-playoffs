package com.ffl.playoffs.domain.model.loadtest;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.ToString;

import java.time.Duration;
import java.util.*;

/**
 * Immutable value object representing the configuration for a load test.
 */
@Getter
@ToString
@EqualsAndHashCode
public final class LoadTestConfiguration {
    private final String name;
    private final LoadTestType testType;
    private final ConcurrencySettings concurrencySettings;
    private final List<String> targetEndpoints;
    private final Map<MetricType, LoadTestThreshold> thresholds;
    private final Duration timeout;
    private final Integer maxRetries;
    private final boolean collectDetailedMetrics;
    private final Map<String, String> customParameters;

    private LoadTestConfiguration(String name, LoadTestType testType,
                                  ConcurrencySettings concurrencySettings,
                                  List<String> targetEndpoints,
                                  Map<MetricType, LoadTestThreshold> thresholds,
                                  Duration timeout, Integer maxRetries,
                                  boolean collectDetailedMetrics,
                                  Map<String, String> customParameters) {
        this.name = Objects.requireNonNull(name, "Name is required");
        this.testType = testType != null ? testType : LoadTestType.STRESS;
        this.concurrencySettings = concurrencySettings != null ?
                concurrencySettings : ConcurrencySettings.defaultSettings();
        this.targetEndpoints = targetEndpoints != null ?
                List.copyOf(targetEndpoints) : Collections.emptyList();
        this.thresholds = thresholds != null ?
                Map.copyOf(thresholds) : Collections.emptyMap();
        this.timeout = timeout != null ? timeout : Duration.ofMinutes(30);
        this.maxRetries = maxRetries != null ? maxRetries : 3;
        this.collectDetailedMetrics = collectDetailedMetrics;
        this.customParameters = customParameters != null ?
                Map.copyOf(customParameters) : Collections.emptyMap();
    }

    public static LoadTestConfiguration create(String name, LoadTestType testType) {
        return new LoadTestConfiguration(name, testType, null, null, null,
                null, null, true, null);
    }

    public static LoadTestConfiguration create(String name, LoadTestType testType,
                                               ConcurrencySettings concurrencySettings) {
        return new LoadTestConfiguration(name, testType, concurrencySettings, null, null,
                null, null, true, null);
    }

    public static Builder builder(String name) {
        return new Builder(name);
    }

    /**
     * Get threshold for a specific metric type.
     */
    public Optional<LoadTestThreshold> getThreshold(MetricType metricType) {
        return Optional.ofNullable(thresholds.get(metricType));
    }

    /**
     * Check if configuration has required thresholds.
     */
    public boolean hasRequiredThresholds() {
        return thresholds.values().stream().anyMatch(LoadTestThreshold::isRequired);
    }

    public static class Builder {
        private final String name;
        private LoadTestType testType = LoadTestType.STRESS;
        private ConcurrencySettings concurrencySettings;
        private List<String> targetEndpoints = new ArrayList<>();
        private Map<MetricType, LoadTestThreshold> thresholds = new HashMap<>();
        private Duration timeout = Duration.ofMinutes(30);
        private Integer maxRetries = 3;
        private boolean collectDetailedMetrics = true;
        private Map<String, String> customParameters = new HashMap<>();

        private Builder(String name) {
            this.name = name;
        }

        public Builder testType(LoadTestType testType) {
            this.testType = testType;
            return this;
        }

        public Builder concurrencySettings(ConcurrencySettings settings) {
            this.concurrencySettings = settings;
            return this;
        }

        public Builder addEndpoint(String endpoint) {
            this.targetEndpoints.add(endpoint);
            return this;
        }

        public Builder addThreshold(LoadTestThreshold threshold) {
            this.thresholds.put(threshold.getMetricType(), threshold);
            return this;
        }

        public Builder timeout(Duration timeout) {
            this.timeout = timeout;
            return this;
        }

        public Builder maxRetries(int retries) {
            this.maxRetries = retries;
            return this;
        }

        public Builder collectDetailedMetrics(boolean collect) {
            this.collectDetailedMetrics = collect;
            return this;
        }

        public Builder customParameter(String key, String value) {
            this.customParameters.put(key, value);
            return this;
        }

        public LoadTestConfiguration build() {
            return new LoadTestConfiguration(name, testType, concurrencySettings,
                    targetEndpoints, thresholds, timeout, maxRetries,
                    collectDetailedMetrics, customParameters);
        }
    }
}
