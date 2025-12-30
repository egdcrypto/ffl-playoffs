package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.LoadTestRun;
import com.ffl.playoffs.domain.model.loadtest.LoadTestMetric;
import com.ffl.playoffs.domain.model.loadtest.LoadTestStatus;
import com.ffl.playoffs.domain.port.LoadTestRunRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.List;
import java.util.UUID;

/**
 * Use case for recording metrics during a load test run.
 */
public class RecordLoadTestMetricsUseCase {

    private final LoadTestRunRepository runRepository;

    public RecordLoadTestMetricsUseCase(LoadTestRunRepository runRepository) {
        this.runRepository = runRepository;
    }

    /**
     * Records metrics for an ongoing load test run.
     *
     * @param command The record metrics command
     * @return The updated LoadTestRun
     * @throws IllegalArgumentException if run not found
     * @throws IllegalStateException if run is not in running state
     */
    public LoadTestRun execute(RecordMetricsCommand command) {
        // Find the run
        LoadTestRun run = runRepository.findById(command.getRunId())
                .orElseThrow(() -> new IllegalArgumentException("Run not found: " + command.getRunId()));

        // Verify run is still running
        if (run.getStatus() != LoadTestStatus.RUNNING) {
            throw new IllegalStateException("Cannot record metrics for run in status: " + run.getStatus());
        }

        // Record metrics
        if (command.getMetrics() != null) {
            command.getMetrics().forEach(run::recordMetric);
        }

        // Record request counts if provided
        if (command.getIncrementSuccessful() != null && command.getIncrementSuccessful()) {
            run.incrementRequests(true);
        }
        if (command.getIncrementFailed() != null && command.getIncrementFailed()) {
            run.incrementRequests(false);
        }

        // Save and return
        return runRepository.save(run);
    }

    @Getter
    @Builder
    public static class RecordMetricsCommand {
        private final UUID runId;
        private final List<LoadTestMetric> metrics;
        private final Boolean incrementSuccessful;
        private final Boolean incrementFailed;
    }
}
