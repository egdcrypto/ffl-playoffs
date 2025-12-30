package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.LoadTestRun;
import com.ffl.playoffs.domain.aggregate.WorldLoadTest;
import com.ffl.playoffs.domain.model.loadtest.LoadTestMetric;
import com.ffl.playoffs.domain.port.LoadTestRunRepository;
import com.ffl.playoffs.domain.port.WorldLoadTestRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.List;
import java.util.UUID;

/**
 * Use case for completing a load test run.
 */
public class CompleteLoadTestUseCase {

    private final WorldLoadTestRepository worldLoadTestRepository;
    private final LoadTestRunRepository runRepository;

    public CompleteLoadTestUseCase(WorldLoadTestRepository worldLoadTestRepository,
                                   LoadTestRunRepository runRepository) {
        this.worldLoadTestRepository = worldLoadTestRepository;
        this.runRepository = runRepository;
    }

    /**
     * Completes a load test run with results.
     *
     * @param command The complete test command
     * @return The updated LoadTestRun
     * @throws IllegalArgumentException if run not found
     */
    public LoadTestRun execute(CompleteLoadTestCommand command) {
        // Find the run
        LoadTestRun run = runRepository.findById(command.getRunId())
                .orElseThrow(() -> new IllegalArgumentException("Run not found: " + command.getRunId()));

        // Record final metrics
        if (command.getMetrics() != null) {
            command.getMetrics().forEach(run::recordMetric);
        }

        // Record request counts
        if (command.getTotalRequests() != null) {
            run.recordRequests(
                    command.getTotalRequests(),
                    command.getSuccessfulRequests() != null ? command.getSuccessfulRequests() : 0,
                    command.getFailedRequests() != null ? command.getFailedRequests() : 0
            );
        }

        // Complete the run
        run.complete();

        // Update world load test
        WorldLoadTest worldLoadTest = worldLoadTestRepository.findByWorldId(run.getWorldId())
                .orElseThrow(() -> new IllegalStateException("World load test not found"));
        worldLoadTest.completeCurrentRun();

        // Save both
        LoadTestRun savedRun = runRepository.save(run);
        worldLoadTestRepository.save(worldLoadTest);

        return savedRun;
    }

    @Getter
    @Builder
    public static class CompleteLoadTestCommand {
        private final UUID runId;
        private final List<LoadTestMetric> metrics;
        private final Integer totalRequests;
        private final Integer successfulRequests;
        private final Integer failedRequests;
    }
}
