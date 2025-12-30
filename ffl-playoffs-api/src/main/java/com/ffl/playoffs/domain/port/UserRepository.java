package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.Role;

import java.util.List;
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
     * Find all users
     * @return list of all users
     */
    List<User> findAll();

    /**
     * Find all users with a specific role
     * @param role the role to filter by
     * @return list of users with the specified role
     */
    List<User> findByRole(Role role);

    /**
     * Find all active users
     * @return list of active users
     */
    List<User> findByActiveTrue();

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

    /**
     * Check if user exists by email
     * @param email the email
     * @return true if user exists
     */
    boolean existsByEmail(String email);

    /**
     * Delete a user by ID
     * @param id the user ID
     */
    void deleteById(UUID id);

    /**
     * Count users by role
     * @param role the role to count
     * @return count of users with the role
     */
    long countByRole(Role role);
}
