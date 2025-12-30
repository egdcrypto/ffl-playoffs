package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.ABTest;
import com.ffl.playoffs.domain.model.ABTestStatus;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for ABTest aggregate
 * Port in hexagonal architecture
 */
public interface ABTestRepository {

    /**
     * Find A/B test by ID
     * @param id the test ID
     * @return Optional containing the test if found
     */
    Optional<ABTest> findById(UUID id);

    /**
     * Find A/B test by name
     * @param name the test name
     * @return Optional containing the test if found
     */
    Optional<ABTest> findByName(String name);

    /**
     * Find all A/B tests
     * @return list of all tests
     */
    List<ABTest> findAll();

    /**
     * Find A/B tests by character
     * @param characterId the character ID
     * @return list of tests for the character
     */
    List<ABTest> findByCharacterId(UUID characterId);

    /**
     * Find A/B tests by status
     * @param status the test status
     * @return list of tests with the specified status
     */
    List<ABTest> findByStatus(ABTestStatus status);

    /**
     * Find currently running A/B tests
     * @return list of running tests
     */
    List<ABTest> findRunning();

    /**
     * Find running A/B test for a character (only one allowed at a time)
     * @param characterId the character ID
     * @return Optional containing the running test if found
     */
    Optional<ABTest> findRunningByCharacterId(UUID characterId);

    /**
     * Save an A/B test
     * @param test the test to save
     * @return the saved test
     */
    ABTest save(ABTest test);

    /**
     * Delete an A/B test
     * @param id the test ID
     */
    void deleteById(UUID id);
}
