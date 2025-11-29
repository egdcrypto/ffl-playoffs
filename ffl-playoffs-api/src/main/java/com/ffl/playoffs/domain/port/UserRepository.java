package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.User;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for User aggregate
 * Port in hexagonal architecture
 */
public interface UserRepository {

    /**
     * Find user by ID
     * @param id the user ID
     * @return Optional containing the user if found
     */
    Optional<User> findById(UUID id);

    /**
     * Find user by Google ID
     * @param googleId the Google ID from OAuth token
     * @return Optional containing the user if found
     */
    Optional<User> findByGoogleId(String googleId);

    /**
     * Find user by email address
     * @param email the user's email
     * @return Optional containing the user if found
     */
    Optional<User> findByEmail(String email);

    /**
     * Save a user
     * @param user the user to save
     * @return the saved user
     */
    User save(User user);

    /**
     * Check if user exists by Google ID
     * @param googleId the Google ID
     * @return true if user exists
     */
    boolean existsByGoogleId(String googleId);
}
