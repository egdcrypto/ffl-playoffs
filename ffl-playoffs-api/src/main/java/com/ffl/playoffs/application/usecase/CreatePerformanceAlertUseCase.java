package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.PerformanceAlert;
import com.ffl.playoffs.domain.model.performance.*;
import com.ffl.playoffs.domain.port.PerformanceAlertRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.time.Duration;
import java.util.Set;
import java.util.UUID;

/**
 * Use case for creating performance alert configurations.
 */
@Slf4j
@RequiredArgsConstructor
public class CreatePerformanceAlertUseCase {

    private final PerformanceAlertRepository alertRepository;

    public PerformanceAlert execute(Command command) {
        log.info("Creating performance alert: {}", command.name());

        // Build threshold
        AlertThreshold threshold = AlertThreshold.of(
                command.metricType(),
                command.condition(),
                command.thresholdValue(),
                command.duration() != null ? command.duration() : Duration.ZERO,
                command.severity()
        );

        // Create alert
        PerformanceAlert alert = PerformanceAlert.create(
                command.name(),
                command.description(),
                threshold,
                command.createdBy()
        );

        // Add notification channels if specified
        if (command.notificationChannels() != null) {
            for (NotificationChannel channel : command.notificationChannels()) {
                alert.addNotificationChannel(channel);
            }
        }

        // Set escalation policy if provided
        if (command.escalationPolicy() != null) {
            alert.updateEscalationPolicy(command.escalationPolicy());
        }

        // Save and return
        PerformanceAlert saved = alertRepository.save(alert);
        log.info("Created performance alert with ID: {}", saved.getId());

        return saved;
    }

    public record Command(
            String name,
            String description,
            MetricType metricType,
            AlertCondition condition,
            Double thresholdValue,
            Duration duration,
            AlertSeverity severity,
            Set<NotificationChannel> notificationChannels,
            EscalationPolicy escalationPolicy,
            UUID createdBy
    ) {}
}
