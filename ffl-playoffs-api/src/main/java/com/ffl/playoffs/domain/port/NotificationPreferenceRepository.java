package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.NotificationPreference;

import java.util.Optional;
import java.util.UUID;

/**
 * Port interface for NotificationPreference persistence.
 * Domain defines the contract, infrastructure implements it.
 */
public interface NotificationPreferenceRepository {

    /**
     * Save or update notification preferences
     *
     * @param preference the notification preference to save
     * @return the saved notification preference
     */
    NotificationPreference save(NotificationPreference preference);

    /**
     * Find notification preferences by user ID
     *
     * @param userId the user ID
     * @return optional containing the preferences if found
     */
    Optional<NotificationPreference> findByUserId(String userId);

    /**
     * Find notification preferences by ID
     *
     * @param id the preference ID
     * @return optional containing the preferences if found
     */
    Optional<NotificationPreference> findById(UUID id);

    /**
     * Delete notification preferences for a user
     *
     * @param userId the user ID
     */
    void deleteByUserId(String userId);

    /**
     * Check if preferences exist for a user
     *
     * @param userId the user ID
     * @return true if preferences exist
     */
    boolean existsByUserId(String userId);
}
