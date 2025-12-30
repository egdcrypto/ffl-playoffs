package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.StandalonePlayerDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for StandalonePlayerDocument
 * Infrastructure layer - MongoDB specific
 */
@Repository
public interface PlayerMongoRepository extends MongoRepository<StandalonePlayerDocument, String> {

    /**
     * Find player by email address
     * @param email the player's email
     * @return Optional containing the player document if found
     */
    Optional<StandalonePlayerDocument> findByEmail(String email);

    /**
     * Find player by Google ID
     * @param googleId the Google OAuth ID
     * @return Optional containing the player document if found
     */
    Optional<StandalonePlayerDocument> findByGoogleId(String googleId);

    /**
     * Check if player exists by email
     * @param email the email to check
     * @return true if exists
     */
    boolean existsByEmail(String email);

    /**
     * Check if player exists by Google ID
     * @param googleId the Google ID to check
     * @return true if exists
     */
    boolean existsByGoogleId(String googleId);
}
