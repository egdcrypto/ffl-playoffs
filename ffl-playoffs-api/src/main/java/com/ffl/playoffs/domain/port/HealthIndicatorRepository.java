package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.HealthIndicator;
import com.ffl.playoffs.domain.model.HealthStatus;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface for HealthIndicator aggregate
 * Port in hexagonal architecture
 */
public interface HealthIndicatorRepository {

    /**
     * Find health indicator by ID
     * @param id the indicator ID
     * @return Optional containing the indicator if found
     */
    Optional<HealthIndicator> findById(String id);

    /**
     * Find all health indicators
     * @return list of all health indicators
     */
    List<HealthIndicator> findAll();

    /**
     * Find health indicators by status
     * @param status the health status
     * @return list of indicators with the specified status
     */
    List<HealthIndicator> findByStatus(HealthStatus status);

    /**
     * Find degraded health indicators (WARNING or CRITICAL status)
     * @return list of degraded indicators
     */
    List<HealthIndicator> findDegraded();

    /**
     * Find health indicators that depend on the given indicator
     * @param indicatorId the indicator ID to find dependents for
     * @return list of dependent indicators
     */
    List<HealthIndicator> findDependents(String indicatorId);

    /**
     * Calculate overall system health status
     * @return the overall health status
     */
    HealthStatus calculateOverallStatus();

    /**
     * Save a health indicator
     * @param indicator the indicator to save
     * @return the saved indicator
     */
    HealthIndicator save(HealthIndicator indicator);

    /**
     * Delete a health indicator
     * @param id the indicator ID
     */
    void deleteById(String id);
}
