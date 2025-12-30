package com.ffl.playoffs.infrastructure.persistence.mongodb.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;
import java.util.Map;

/**
 * MongoDB document for PerformanceMetricSnapshot aggregate.
 * Stores time-series performance data for monitoring and analysis.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "performance_metrics")
@CompoundIndex(name = "service_timestamp_idx", def = "{'service': 1, 'timestamp': -1}")
@CompoundIndex(name = "endpoint_timestamp_idx", def = "{'endpoint': 1, 'timestamp': -1}")
public class PerformanceMetricSnapshotDocument {
    @Id
    private String id;

    @Indexed
    private Instant timestamp;

    @Indexed
    private String source;

    @Indexed
    private String service;

    @Indexed
    private String endpoint;

    /**
     * Map of metric type code to value.
     * e.g., {"cpu_utilization": 75.5, "memory_utilization": 60.2}
     */
    private Map<String, Double> metrics;

    /**
     * Additional tags for filtering and grouping.
     * e.g., {"environment": "production", "region": "us-east-1"}
     */
    private Map<String, String> tags;
}
