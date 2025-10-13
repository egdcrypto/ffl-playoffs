package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.UserDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * Spring Data MongoDB repository for UserDocument
 * Infrastructure layer - MongoDB specific
 */
@Repository
public interface UserMongoRepository extends MongoRepository<UserDocument, String> {

    /**
     * Find user by Google ID
     * @param googleId the Google OAuth ID
     * @return Optional containing the user document if found
     */
    Optional<UserDocument> findByGoogleId(String googleId);

    /**
     * Find user by email address
     * @param email the user's email
     * @return Optional containing the user document if found
     */
    Optional<UserDocument> findByEmail(String email);

    /**
     * Check if user exists by Google ID
     * @param googleId the Google ID
     * @return true if user exists
     */
    boolean existsByGoogleId(String googleId);
}
