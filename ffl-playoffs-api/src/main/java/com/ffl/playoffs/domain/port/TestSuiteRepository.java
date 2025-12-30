package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.TestSuite;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for TestSuite aggregate
 * Port in hexagonal architecture
 */
public interface TestSuiteRepository {

    /**
     * Find test suite by ID
     * @param id the suite ID
     * @return Optional containing the suite if found
     */
    Optional<TestSuite> findById(UUID id);

    /**
     * Find test suite by name
     * @param name the suite name
     * @return Optional containing the suite if found
     */
    Optional<TestSuite> findByName(String name);

    /**
     * Find all test suites
     * @return list of all suites
     */
    List<TestSuite> findAll();

    /**
     * Find test suites by character
     * @param characterId the character ID
     * @return list of suites for the character
     */
    List<TestSuite> findByCharacterId(UUID characterId);

    /**
     * Find scheduled test suites
     * @return list of suites with schedules
     */
    List<TestSuite> findScheduled();

    /**
     * Find test suites created by an admin
     * @param adminId the admin ID
     * @return list of suites created by the admin
     */
    List<TestSuite> findByCreatedBy(UUID adminId);

    /**
     * Save a test suite
     * @param suite the suite to save
     * @return the saved suite
     */
    TestSuite save(TestSuite suite);

    /**
     * Delete a test suite
     * @param id the suite ID
     */
    void deleteById(UUID id);
}
