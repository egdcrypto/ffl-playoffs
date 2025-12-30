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

    /**
     * Check if user exists by email
     * @param email the email
     * @return true if user exists
     */
    boolean existsByEmail(String email);

    /**
     * Find all users with a specific role
     * @param role the role string
     * @return list of users with the specified role
     */
    java.util.List<UserDocument> findByRole(String role);

    /**
     * Find all active users
     * @return list of active users
     */
    java.util.List<UserDocument> findByActiveTrue();

    /**
     * Count users by role
     * @param role the role string
     * @return count of users with the role
     */
    long countByRole(String role);
}
