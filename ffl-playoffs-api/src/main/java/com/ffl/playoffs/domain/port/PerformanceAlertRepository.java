package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.PerformanceAlert;
import com.ffl.playoffs.domain.model.performance.AlertSeverity;
import com.ffl.playoffs.domain.model.performance.AlertStatus;
import com.ffl.playoffs.domain.model.performance.MetricType;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository port for PerformanceAlert aggregate.
 */
public interface PerformanceAlertRepository {

    /**
     * Save or update an alert.
     */
    PerformanceAlert save(PerformanceAlert alert);

    /**
     * Find alert by ID.
     */
    Optional<PerformanceAlert> findById(UUID id);

    /**
     * Find all alerts.
     */
    List<PerformanceAlert> findAll();

    /**
     * Find alerts by status.
     */
    List<PerformanceAlert> findByStatus(AlertStatus status);

    /**
     * Find alerts by severity.
     */
    List<PerformanceAlert> findBySeverity(AlertSeverity severity);

    /**
     * Find alerts by metric type.
     */
    List<PerformanceAlert> findByMetricType(MetricType metricType);

    /**
     * Find all enabled alerts.
     */
    List<PerformanceAlert> findAllEnabled();

    /**
     * Find active alerts (triggered and not resolved).
     */
    List<PerformanceAlert> findActiveAlerts();

    /**
     * Find alerts created by a user.
     */
    List<PerformanceAlert> findByCreatedBy(UUID userId);

    /**
     * Count active alerts.
     */
    long countActiveAlerts();

    /**
     * Delete an alert.
     */
    void deleteById(UUID id);
}
