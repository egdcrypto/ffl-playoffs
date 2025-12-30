package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.PerformanceAlert;
import com.ffl.playoffs.domain.model.performance.AlertStatus;
import com.ffl.playoffs.domain.port.PerformanceAlertRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Use case for managing performance alert lifecycle.
 */
@Slf4j
@RequiredArgsConstructor
public class ManagePerformanceAlertUseCase {

    private final PerformanceAlertRepository alertRepository;

    /**
     * Get all alerts.
     */
    public List<PerformanceAlert> getAllAlerts() {
        return alertRepository.findAll();
    }

    /**
     * Get alert by ID.
     */
    public Optional<PerformanceAlert> getAlertById(UUID id) {
        return alertRepository.findById(id);
    }

    /**
     * Get active alerts (triggered and not yet resolved).
     */
    public List<PerformanceAlert> getActiveAlerts() {
        return alertRepository.findActiveAlerts();
    }

    /**
     * Get alerts by status.
     */
    public List<PerformanceAlert> getAlertsByStatus(AlertStatus status) {
        return alertRepository.findByStatus(status);
    }

    /**
     * Acknowledge an active alert.
     */
    public PerformanceAlert acknowledgeAlert(UUID alertId, UUID userId) {
        log.info("Acknowledging alert {} by user {}", alertId, userId);

        PerformanceAlert alert = alertRepository.findById(alertId)
                .orElseThrow(() -> new IllegalArgumentException("Alert not found: " + alertId));

        alert.acknowledge(userId);
        return alertRepository.save(alert);
    }

    /**
     * Resolve an alert.
     */
    public PerformanceAlert resolveAlert(UUID alertId, UUID userId, String note) {
        log.info("Resolving alert {} by user {}", alertId, userId);

        PerformanceAlert alert = alertRepository.findById(alertId)
                .orElseThrow(() -> new IllegalArgumentException("Alert not found: " + alertId));

        alert.resolve(userId, note);
        return alertRepository.save(alert);
    }

    /**
     * Suppress an alert for a duration.
     */
    public PerformanceAlert suppressAlert(UUID alertId, Instant until, String reason) {
        log.info("Suppressing alert {} until {}", alertId, until);

        PerformanceAlert alert = alertRepository.findById(alertId)
                .orElseThrow(() -> new IllegalArgumentException("Alert not found: " + alertId));

        alert.suppress(until, reason);
        return alertRepository.save(alert);
    }

    /**
     * Enable an alert.
     */
    public PerformanceAlert enableAlert(UUID alertId) {
        log.info("Enabling alert {}", alertId);

        PerformanceAlert alert = alertRepository.findById(alertId)
                .orElseThrow(() -> new IllegalArgumentException("Alert not found: " + alertId));

        alert.enable();
        return alertRepository.save(alert);
    }

    /**
     * Disable an alert.
     */
    public PerformanceAlert disableAlert(UUID alertId) {
        log.info("Disabling alert {}", alertId);

        PerformanceAlert alert = alertRepository.findById(alertId)
                .orElseThrow(() -> new IllegalArgumentException("Alert not found: " + alertId));

        alert.disable();
        return alertRepository.save(alert);
    }

    /**
     * Delete an alert.
     */
    public void deleteAlert(UUID alertId) {
        log.info("Deleting alert {}", alertId);
        alertRepository.deleteById(alertId);
    }

    /**
     * Get count of active alerts.
     */
    public long getActiveAlertCount() {
        return alertRepository.countActiveAlerts();
    }
}
