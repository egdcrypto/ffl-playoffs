package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.SyntheticTest;
import com.ffl.playoffs.domain.model.SyntheticTestType;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for SyntheticTest aggregate
 * Port in hexagonal architecture
 */
public interface SyntheticTestRepository {

    /**
     * Find synthetic test by ID
     * @param id the test ID
     * @return Optional containing the test if found
     */
    Optional<SyntheticTest> findById(UUID id);

    /**
     * Find synthetic test by name
     * @param name the test name
     * @return Optional containing the test if found
     */
    Optional<SyntheticTest> findByName(String name);

    /**
     * Find all synthetic tests
     * @return list of all tests
     */
    List<SyntheticTest> findAll();

    /**
     * Find enabled synthetic tests
     * @return list of enabled tests
     */
    List<SyntheticTest> findEnabled();

    /**
     * Find synthetic tests by type
     * @param type the test type
     * @return list of tests with the specified type
     */
    List<SyntheticTest> findByType(SyntheticTestType type);

    /**
     * Find synthetic tests by location
     * @param location the test location
     * @return list of tests running from the specified location
     */
    List<SyntheticTest> findByLocation(String location);

    /**
     * Find failing synthetic tests
     * @return list of tests that failed their last run
     */
    List<SyntheticTest> findFailing();

    /**
     * Find unhealthy synthetic tests (uptime below threshold)
     * @param uptimeThreshold minimum uptime percentage
     * @return list of unhealthy tests
     */
    List<SyntheticTest> findUnhealthy(double uptimeThreshold);

    /**
     * Save a synthetic test
     * @param test the test to save
     * @return the saved test
     */
    SyntheticTest save(SyntheticTest test);

    /**
     * Delete a synthetic test
     * @param id the test ID
     */
    void deleteById(UUID id);
}
