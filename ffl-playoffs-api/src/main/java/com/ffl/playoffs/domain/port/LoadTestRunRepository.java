package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.LoadTestRun;
import com.ffl.playoffs.domain.model.loadtest.LoadTestStatus;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for LoadTestRun aggregate.
 * Port in hexagonal architecture.
 */
public interface LoadTestRunRepository {

    /**
     * Find run by ID.
     */
    Optional<LoadTestRun> findById(UUID id);

    /**
     * Find all runs for a scenario.
     */
    List<LoadTestRun> findByScenarioId(UUID scenarioId);

    /**
     * Find all runs for a world.
     */
    List<LoadTestRun> findByWorldId(UUID worldId);

    /**
     * Find runs by status.
     */
    List<LoadTestRun> findByStatus(LoadTestStatus status);

    /**
     * Find running tests for a world.
     */
    Optional<LoadTestRun> findRunningByWorldId(UUID worldId);

    /**
     * Find recent runs for a world.
     */
    List<LoadTestRun> findRecentByWorldId(UUID worldId, int limit);

    /**
     * Find runs in a time range.
     */
    List<LoadTestRun> findByWorldIdAndTimeRange(UUID worldId, Instant startTime, Instant endTime);

    /**
     * Save a run.
     */
    LoadTestRun save(LoadTestRun run);

    /**
     * Delete a run.
     */
    void deleteById(UUID id);

    /**
     * Delete old runs.
     */
    void deleteByWorldIdOlderThan(UUID worldId, Instant cutoffTime);
}
