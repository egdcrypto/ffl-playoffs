package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.Alert;
import com.ffl.playoffs.domain.model.AlertSeverity;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for Alert aggregate
 * Port in hexagonal architecture
 */
public interface AlertRepository {

    /**
     * Find alert by ID
     * @param id the alert ID
     * @return Optional containing the alert if found
     */
    Optional<Alert> findById(UUID id);

    /**
     * Find all alerts
     * @return list of all alerts
     */
    List<Alert> findAll();

    /**
     * Find all active alerts (not resolved and not snoozed)
     * @return list of active alerts
     */
    List<Alert> findAllActive();

    /**
     * Find alerts by severity
     * @param severity the severity level
     * @return list of alerts with the specified severity
     */
    List<Alert> findBySeverity(AlertSeverity severity);

    /**
     * Find alerts by source system
     * @param source the source system identifier
     * @return list of alerts from the source
     */
    List<Alert> findBySource(String source);

    /**
     * Find unacknowledged alerts
     * @return list of unacknowledged alerts
     */
    List<Alert> findUnacknowledged();

    /**
     * Count active alerts by severity
     * @param severity the severity level
     * @return count of active alerts
     */
    long countActiveBySeverity(AlertSeverity severity);

    /**
     * Save an alert
     * @param alert the alert to save
     * @return the saved alert
     */
    Alert save(Alert alert);

    /**
     * Delete an alert
     * @param id the alert ID
     */
    void deleteById(UUID id);
}
