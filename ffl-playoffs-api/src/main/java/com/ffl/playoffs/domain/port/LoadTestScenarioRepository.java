package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.LoadTestScenario;
import com.ffl.playoffs.domain.model.loadtest.LoadTestType;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for LoadTestScenario aggregate.
 * Port in hexagonal architecture.
 */
public interface LoadTestScenarioRepository {

    /**
     * Find scenario by ID.
     */
    Optional<LoadTestScenario> findById(UUID id);

    /**
     * Find all scenarios for a world.
     */
    List<LoadTestScenario> findByWorldId(UUID worldId);

    /**
     * Find enabled scenarios for a world.
     */
    List<LoadTestScenario> findEnabledByWorldId(UUID worldId);

    /**
     * Find scenarios by type.
     */
    List<LoadTestScenario> findByTestType(LoadTestType testType);

    /**
     * Find scenarios by tag.
     */
    List<LoadTestScenario> findByTag(String tag);

    /**
     * Save a scenario.
     */
    LoadTestScenario save(LoadTestScenario scenario);

    /**
     * Delete a scenario.
     */
    void deleteById(UUID id);

    /**
     * Check if scenario exists.
     */
    boolean existsById(UUID id);
}
