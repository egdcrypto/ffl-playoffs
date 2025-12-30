package com.ffl.playoffs.infrastructure.persistence.mongodb.mapper;

import com.ffl.playoffs.domain.aggregate.PerformanceMetricSnapshot;
import com.ffl.playoffs.domain.model.performance.MetricType;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.PerformanceMetricSnapshotDocument;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Mapper between PerformanceMetricSnapshot domain aggregate and MongoDB document.
 */
@Component
public class PerformanceMetricSnapshotMapper {

    public PerformanceMetricSnapshotDocument toDocument(PerformanceMetricSnapshot snapshot) {
        if (snapshot == null) return null;

        return PerformanceMetricSnapshotDocument.builder()
                .id(snapshot.getId() != null ? snapshot.getId().toString() : null)
                .timestamp(snapshot.getTimestamp())
                .source(snapshot.getSource())
                .service(snapshot.getService())
                .endpoint(snapshot.getEndpoint())
                .metrics(toMetricStrings(snapshot.getMetrics()))
                .tags(snapshot.getTags())
                .build();
    }

    public PerformanceMetricSnapshot toDomain(PerformanceMetricSnapshotDocument doc) {
        if (doc == null) return null;

        return PerformanceMetricSnapshot.builder()
                .id(doc.getId() != null ? UUID.fromString(doc.getId()) : null)
                .timestamp(doc.getTimestamp())
                .source(doc.getSource())
                .service(doc.getService())
                .endpoint(doc.getEndpoint())
                .metrics(toMetricTypes(doc.getMetrics()))
                .tags(doc.getTags() != null ? new HashMap<>(doc.getTags()) : new HashMap<>())
                .build();
    }

    private Map<String, Double> toMetricStrings(Map<MetricType, Double> metrics) {
        if (metrics == null) return null;

        return metrics.entrySet().stream()
                .collect(Collectors.toMap(
                        e -> e.getKey().getCode(),
                        Map.Entry::getValue
                ));
    }

    private Map<MetricType, Double> toMetricTypes(Map<String, Double> metrics) {
        if (metrics == null) return new HashMap<>();

        Map<MetricType, Double> result = new HashMap<>();
        for (Map.Entry<String, Double> entry : metrics.entrySet()) {
            try {
                MetricType type = MetricType.fromCode(entry.getKey());
                result.put(type, entry.getValue());
            } catch (IllegalArgumentException e) {
                // Skip unknown metric types
            }
        }
        return result;
    }
}
