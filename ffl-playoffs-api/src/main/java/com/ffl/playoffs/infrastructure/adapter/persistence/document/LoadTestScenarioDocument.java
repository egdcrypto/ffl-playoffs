package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;
import java.util.List;
import java.util.Map;

/**
 * MongoDB document for LoadTestScenario aggregate.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "load_test_scenarios")
public class LoadTestScenarioDocument {

    @Id
    private String id;

    @Indexed
    private String worldId;

    private String name;
    private String description;
    private String testType;
    private LoadTestConfigurationEmbedded configuration;
    private List<String> tags;
    private boolean enabled;
    private Integer priority;
    private Instant createdAt;
    private Instant updatedAt;
    private String createdBy;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class LoadTestConfigurationEmbedded {
        private String name;
        private String testType;
        private ConcurrencySettingsEmbedded concurrencySettings;
        private List<String> targetEndpoints;
        private Map<String, LoadTestThresholdEmbedded> thresholds;
        private Long timeoutSeconds;
        private Integer maxRetries;
        private boolean collectDetailedMetrics;
        private Map<String, String> customParameters;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ConcurrencySettingsEmbedded {
        private Integer initialUsers;
        private Integer maxUsers;
        private Integer rampUpUsers;
        private Long rampUpDurationSeconds;
        private Long holdDurationSeconds;
        private Long rampDownDurationSeconds;
        private Integer targetRequestsPerSecond;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class LoadTestThresholdEmbedded {
        private String metricType;
        private Double warningThreshold;
        private Double failureThreshold;
        private String direction;
        private boolean required;
    }
}
