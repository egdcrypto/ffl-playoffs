package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.DashboardLayout;

import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for DashboardLayout aggregate
 * Port in hexagonal architecture
 */
public interface DashboardLayoutRepository {

    /**
     * Find dashboard layout by ID
     * @param id the layout ID
     * @return Optional containing the layout if found
     */
    Optional<DashboardLayout> findById(UUID id);

    /**
     * Find dashboard layout by admin ID
     * @param adminId the admin user ID
     * @return Optional containing the layout if found
     */
    Optional<DashboardLayout> findByAdminId(UUID adminId);

    /**
     * Save a dashboard layout
     * @param layout the layout to save
     * @return the saved layout
     */
    DashboardLayout save(DashboardLayout layout);

    /**
     * Delete a dashboard layout
     * @param id the layout ID
     */
    void deleteById(UUID id);

    /**
     * Delete dashboard layout for an admin
     * @param adminId the admin user ID
     */
    void deleteByAdminId(UUID adminId);
}
