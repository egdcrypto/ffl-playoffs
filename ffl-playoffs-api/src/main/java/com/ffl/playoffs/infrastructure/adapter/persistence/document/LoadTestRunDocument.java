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
 * MongoDB document for LoadTestRun aggregate.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "load_test_runs")
public class LoadTestRunDocument {

    @Id
    private String id;

    @Indexed
    private String scenarioId;

    @Indexed
    private String worldId;

    @Indexed
    private String status;

    private LoadTestScenarioDocument.LoadTestConfigurationEmbedded configuration;
    private Instant startTime;
    private Instant endTime;
    private List<LoadTestMetricEmbedded> metrics;
    private Map<String, String> thresholdResults;
    private Integer totalRequests;
    private Integer successfulRequests;
    private Integer failedRequests;
    private String errorMessage;
    private String triggeredBy;
    private Instant createdAt;
    private Instant updatedAt;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class LoadTestMetricEmbedded {
        private String type;
        private Double value;
        private Double minValue;
        private Double maxValue;
        private Instant timestamp;
        private String label;
    }
}
