package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.NotificationPreferenceDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * Spring Data MongoDB repository for NotificationPreferenceDocument
 * Infrastructure layer - MongoDB specific
 */
@Repository
public interface NotificationPreferenceMongoRepository extends MongoRepository<NotificationPreferenceDocument, String> {

    /**
     * Find notification preferences by user ID
     * @param userId the user ID
     * @return Optional containing the preference document if found
     */
    Optional<NotificationPreferenceDocument> findByUserId(String userId);

    /**
     * Delete notification preferences by user ID
     * @param userId the user ID
     */
    void deleteByUserId(String userId);

    /**
     * Check if preferences exist for a user
     * @param userId the user ID
     * @return true if preferences exist
     */
    boolean existsByUserId(String userId);
}
