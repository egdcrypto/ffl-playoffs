package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.WorldLoadTest;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for WorldLoadTest aggregate.
 * Port in hexagonal architecture.
 */
public interface WorldLoadTestRepository {

    /**
     * Find world load test by ID.
     */
    Optional<WorldLoadTest> findById(UUID id);

    /**
     * Find world load test by world ID.
     */
    Optional<WorldLoadTest> findByWorldId(UUID worldId);

    /**
     * Find all world load tests.
     */
    List<WorldLoadTest> findAll();

    /**
     * Find world load tests by status.
     */
    List<WorldLoadTest> findByStatus(WorldLoadTest.WorldLoadTestStatus status);

    /**
     * Check if world load test exists for world.
     */
    boolean existsByWorldId(UUID worldId);

    /**
     * Save world load test.
     */
    WorldLoadTest save(WorldLoadTest worldLoadTest);

    /**
     * Delete world load test.
     */
    void deleteById(UUID id);

    /**
     * Delete world load test by world ID.
     */
    void deleteByWorldId(UUID worldId);
}
