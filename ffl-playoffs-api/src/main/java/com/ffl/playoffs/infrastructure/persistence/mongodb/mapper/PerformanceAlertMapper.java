package com.ffl.playoffs.infrastructure.persistence.mongodb.mapper;

import com.ffl.playoffs.domain.aggregate.PerformanceAlert;
import com.ffl.playoffs.domain.model.performance.*;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.PerformanceAlertDocument;
import org.springframework.stereotype.Component;

import java.time.Duration;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Mapper between PerformanceAlert domain aggregate and MongoDB document.
 */
@Component
public class PerformanceAlertMapper {

    public PerformanceAlertDocument toDocument(PerformanceAlert alert) {
        if (alert == null) return null;

        return PerformanceAlertDocument.builder()
                .id(alert.getId() != null ? alert.getId().toString() : null)
                .name(alert.getName())
                .description(alert.getDescription())
                .threshold(toThresholdSubDocument(alert.getThreshold()))
                .escalationPolicy(toEscalationPolicySubDocument(alert.getEscalationPolicy()))
                .notificationChannels(toChannelStrings(alert.getNotificationChannels()))
                .enabled(alert.isEnabled())
                .status(alert.getStatus() != null ? alert.getStatus().getCode() : null)
                .triggeredAt(alert.getTriggeredAt())
                .acknowledgedAt(alert.getAcknowledgedAt())
                .acknowledgedBy(alert.getAcknowledgedBy() != null ? alert.getAcknowledgedBy().toString() : null)
                .resolvedAt(alert.getResolvedAt())
                .resolvedBy(alert.getResolvedBy() != null ? alert.getResolvedBy().toString() : null)
                .resolutionNote(alert.getResolutionNote())
                .suppressedUntil(alert.getSuppressedUntil())
                .suppressionReason(alert.getSuppressionReason())
                .createdAt(alert.getCreatedAt())
                .createdBy(alert.getCreatedBy() != null ? alert.getCreatedBy().toString() : null)
                .updatedAt(alert.getUpdatedAt())
                .build();
    }

    public PerformanceAlert toDomain(PerformanceAlertDocument doc) {
        if (doc == null) return null;

        return PerformanceAlert.builder()
                .id(doc.getId() != null ? UUID.fromString(doc.getId()) : null)
                .name(doc.getName())
                .description(doc.getDescription())
                .threshold(toThreshold(doc.getThreshold()))
                .escalationPolicy(toEscalationPolicy(doc.getEscalationPolicy()))
                .notificationChannels(toChannels(doc.getNotificationChannels()))
                .enabled(doc.isEnabled())
                .status(doc.getStatus() != null ? AlertStatus.fromCode(doc.getStatus()) : null)
                .triggeredAt(doc.getTriggeredAt())
                .acknowledgedAt(doc.getAcknowledgedAt())
                .acknowledgedBy(doc.getAcknowledgedBy() != null ? UUID.fromString(doc.getAcknowledgedBy()) : null)
                .resolvedAt(doc.getResolvedAt())
                .resolvedBy(doc.getResolvedBy() != null ? UUID.fromString(doc.getResolvedBy()) : null)
                .resolutionNote(doc.getResolutionNote())
                .suppressedUntil(doc.getSuppressedUntil())
                .suppressionReason(doc.getSuppressionReason())
                .createdAt(doc.getCreatedAt())
                .createdBy(doc.getCreatedBy() != null ? UUID.fromString(doc.getCreatedBy()) : null)
                .updatedAt(doc.getUpdatedAt())
                .build();
    }

    private PerformanceAlertDocument.ThresholdSubDocument toThresholdSubDocument(AlertThreshold threshold) {
        if (threshold == null) return null;

        return PerformanceAlertDocument.ThresholdSubDocument.builder()
                .metricType(threshold.getMetricType().getCode())
                .condition(threshold.getCondition().getCode())
                .threshold(threshold.getThreshold())
                .durationSeconds(threshold.getDuration() != null ? threshold.getDuration().getSeconds() : 0L)
                .severity(threshold.getSeverity().getCode())
                .build();
    }

    private AlertThreshold toThreshold(PerformanceAlertDocument.ThresholdSubDocument doc) {
        if (doc == null) return null;

        return AlertThreshold.of(
                MetricType.fromCode(doc.getMetricType()),
                AlertCondition.fromCode(doc.getCondition()),
                doc.getThreshold(),
                Duration.ofSeconds(doc.getDurationSeconds() != null ? doc.getDurationSeconds() : 0),
                AlertSeverity.fromCode(doc.getSeverity())
        );
    }

    private PerformanceAlertDocument.EscalationPolicySubDocument toEscalationPolicySubDocument(EscalationPolicy policy) {
        if (policy == null) return null;

        List<PerformanceAlertDocument.EscalationLevelSubDocument> levels = policy.getLevels().stream()
                .map(level -> PerformanceAlertDocument.EscalationLevelSubDocument.builder()
                        .afterSeconds(level.getAfterDuration().getSeconds())
                        .notifyRole(level.getNotifyRole())
                        .channel(level.getChannel().getCode())
                        .build())
                .collect(Collectors.toList());

        return PerformanceAlertDocument.EscalationPolicySubDocument.builder()
                .name(policy.getName())
                .levels(levels)
                .build();
    }

    private EscalationPolicy toEscalationPolicy(PerformanceAlertDocument.EscalationPolicySubDocument doc) {
        if (doc == null) return EscalationPolicy.defaultPolicy();

        List<EscalationPolicy.EscalationLevel> levels = doc.getLevels().stream()
                .map(level -> EscalationPolicy.EscalationLevel.of(
                        Duration.ofSeconds(level.getAfterSeconds()),
                        level.getNotifyRole(),
                        NotificationChannel.fromCode(level.getChannel())
                ))
                .collect(Collectors.toList());

        return EscalationPolicy.of(doc.getName(), levels);
    }

    private Set<String> toChannelStrings(Set<NotificationChannel> channels) {
        if (channels == null) return null;
        return channels.stream()
                .map(NotificationChannel::getCode)
                .collect(Collectors.toSet());
    }

    private Set<NotificationChannel> toChannels(Set<String> codes) {
        if (codes == null) return null;
        return codes.stream()
                .map(NotificationChannel::fromCode)
                .collect(Collectors.toSet());
    }
}
