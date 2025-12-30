package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.LoadTestRun;
import com.ffl.playoffs.domain.aggregate.LoadTestScenario;
import com.ffl.playoffs.domain.aggregate.WorldLoadTest;
import com.ffl.playoffs.domain.port.LoadTestRunRepository;
import com.ffl.playoffs.domain.port.LoadTestScenarioRepository;
import com.ffl.playoffs.domain.port.WorldLoadTestRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

/**
 * Use case for starting a load test run.
 */
public class StartLoadTestUseCase {

    private final WorldLoadTestRepository worldLoadTestRepository;
    private final LoadTestScenarioRepository scenarioRepository;
    private final LoadTestRunRepository runRepository;

    public StartLoadTestUseCase(WorldLoadTestRepository worldLoadTestRepository,
                                LoadTestScenarioRepository scenarioRepository,
                                LoadTestRunRepository runRepository) {
        this.worldLoadTestRepository = worldLoadTestRepository;
        this.scenarioRepository = scenarioRepository;
        this.runRepository = runRepository;
    }

    /**
     * Starts a new load test run for a scenario.
     *
     * @param command The start test command
     * @return The created LoadTestRun
     * @throws IllegalArgumentException if world load test or scenario not found
     * @throws IllegalStateException if a test is already running
     */
    public LoadTestRun execute(StartLoadTestCommand command) {
        // Get or create world load test
        WorldLoadTest worldLoadTest = worldLoadTestRepository.findByWorldId(command.getWorldId())
                .orElseGet(() -> {
                    WorldLoadTest newWorldLoadTest = WorldLoadTest.create(command.getWorldId(), null);
                    return worldLoadTestRepository.save(newWorldLoadTest);
                });

        // Check if test already running
        if (worldLoadTest.isRunning()) {
            throw new IllegalStateException("A load test is already running for this world");
        }

        // Get scenario
        LoadTestScenario scenario = scenarioRepository.findById(command.getScenarioId())
                .orElseThrow(() -> new IllegalArgumentException("Scenario not found: " + command.getScenarioId()));

        // Verify scenario belongs to this world
        if (!scenario.getWorldId().equals(command.getWorldId())) {
            throw new IllegalArgumentException("Scenario does not belong to this world");
        }

        // Start the run
        LoadTestRun run = worldLoadTest.startRun(command.getScenarioId());

        // Set triggered by
        if (command.getTriggeredBy() != null) {
            run.setTriggeredBy(command.getTriggeredBy());
        }

        // Save both
        LoadTestRun savedRun = runRepository.save(run);
        worldLoadTestRepository.save(worldLoadTest);

        return savedRun;
    }

    @Getter
    @Builder
    public static class StartLoadTestCommand {
        private final UUID worldId;
        private final UUID scenarioId;
        private final String triggeredBy;
    }
}
