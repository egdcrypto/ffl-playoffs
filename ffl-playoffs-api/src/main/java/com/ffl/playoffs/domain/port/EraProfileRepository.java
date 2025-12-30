package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.EraProfile;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for EraProfile aggregate.
 * Port in hexagonal architecture - defines the contract for era profile persistence.
 */
public interface EraProfileRepository {

    /**
     * Find era profile by ID
     * @param id the era profile ID
     * @return Optional containing the era profile if found
     */
    Optional<EraProfile> findById(UUID id);

    /**
     * Find all era profiles for a specific world
     * @param worldId the world ID
     * @return list of era profiles for the world
     */
    List<EraProfile> findByWorldId(UUID worldId);

    /**
     * Find all era profiles
     * @return list of all era profiles
     */
    List<EraProfile> findAll();

    /**
     * Find era profiles by status
     * @param status the era status (DRAFT, PENDING_REVIEW, APPROVED, LOCKED)
     * @return list of era profiles with the given status
     */
    List<EraProfile> findByStatus(EraProfile.EraStatus status);

    /**
     * Find era profiles created by a specific user
     * @param userId the user ID
     * @return list of era profiles created by the user
     */
    List<EraProfile> findByCreatedBy(UUID userId);

    /**
     * Find locked era profiles for a world
     * @param worldId the world ID
     * @return list of locked era profiles for the world
     */
    List<EraProfile> findLockedByWorldId(UUID worldId);

    /**
     * Check if an era profile exists by ID
     * @param id the era profile ID
     * @return true if era profile exists
     */
    boolean existsById(UUID id);

    /**
     * Save an era profile
     * @param eraProfile the era profile to save
     * @return the saved era profile
     */
    EraProfile save(EraProfile eraProfile);

    /**
     * Delete an era profile by ID
     * @param id the era profile ID
     */
    void deleteById(UUID id);

    /**
     * Delete all era profiles for a world
     * @param worldId the world ID
     */
    void deleteByWorldId(UUID worldId);

    /**
     * Count era profiles by world ID
     * @param worldId the world ID
     * @return the count of era profiles
     */
    long countByWorldId(UUID worldId);
}
