package com.ffl.playoffs.infrastructure.persistence.mongodb.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.Set;

/**
 * MongoDB document for PerformanceAlert aggregate.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "performance_alerts")
public class PerformanceAlertDocument {
    @Id
    private String id;

    private String name;
    private String description;

    // Threshold configuration
    private ThresholdSubDocument threshold;

    // Escalation policy
    private EscalationPolicySubDocument escalationPolicy;

    private Set<String> notificationChannels;

    private boolean enabled;

    @Indexed
    private String status;

    @Indexed
    private Instant triggeredAt;
    private Instant acknowledgedAt;
    private String acknowledgedBy;
    private Instant resolvedAt;
    private String resolvedBy;
    private String resolutionNote;

    private Instant suppressedUntil;
    private String suppressionReason;

    @Indexed
    private Instant createdAt;
    private String createdBy;
    private Instant updatedAt;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ThresholdSubDocument {
        private String metricType;
        private String condition;
        private Double threshold;
        private Long durationSeconds;
        private String severity;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class EscalationPolicySubDocument {
        private String name;
        private List<EscalationLevelSubDocument> levels;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class EscalationLevelSubDocument {
        private Long afterSeconds;
        private String notifyRole;
        private String channel;
    }
}
