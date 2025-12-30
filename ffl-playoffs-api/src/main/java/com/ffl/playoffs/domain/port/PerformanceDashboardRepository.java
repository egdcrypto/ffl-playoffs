package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.PerformanceDashboard;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository port for PerformanceDashboard aggregate.
 */
public interface PerformanceDashboardRepository {

    /**
     * Save or update a dashboard.
     */
    PerformanceDashboard save(PerformanceDashboard dashboard);

    /**
     * Find dashboard by ID.
     */
    Optional<PerformanceDashboard> findById(UUID id);

    /**
     * Find dashboards owned by a user.
     */
    List<PerformanceDashboard> findByOwnerId(UUID ownerId);

    /**
     * Find the default dashboard for a user.
     */
    Optional<PerformanceDashboard> findDefaultByOwnerId(UUID ownerId);

    /**
     * Find all shared dashboards.
     */
    List<PerformanceDashboard> findAllShared();

    /**
     * Find dashboards accessible to a user (owned + shared).
     */
    List<PerformanceDashboard> findAccessibleByUserId(UUID userId);

    /**
     * Check if a dashboard name exists for a user.
     */
    boolean existsByNameAndOwnerId(String name, UUID ownerId);

    /**
     * Delete a dashboard.
     */
    void deleteById(UUID id);
}
