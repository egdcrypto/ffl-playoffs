package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.LoadTestRun;
import com.ffl.playoffs.domain.aggregate.WorldLoadTest;
import com.ffl.playoffs.domain.port.LoadTestRunRepository;
import com.ffl.playoffs.domain.port.WorldLoadTestRepository;
import lombok.Builder;
import lombok.Getter;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Use case for retrieving load test results.
 */
public class GetLoadTestResultsUseCase {

    private final WorldLoadTestRepository worldLoadTestRepository;
    private final LoadTestRunRepository runRepository;

    public GetLoadTestResultsUseCase(WorldLoadTestRepository worldLoadTestRepository,
                                     LoadTestRunRepository runRepository) {
        this.worldLoadTestRepository = worldLoadTestRepository;
        this.runRepository = runRepository;
    }

    /**
     * Get world load test summary.
     */
    public Optional<WorldLoadTest> getWorldLoadTest(UUID worldId) {
        return worldLoadTestRepository.findByWorldId(worldId);
    }

    /**
     * Get a specific run by ID.
     */
    public Optional<LoadTestRun> getRun(UUID runId) {
        return runRepository.findById(runId);
    }

    /**
     * Get recent runs for a world.
     */
    public List<LoadTestRun> getRecentRuns(UUID worldId, int limit) {
        return runRepository.findRecentByWorldId(worldId, limit);
    }

    /**
     * Get runs in a time range.
     */
    public List<LoadTestRun> getRunsInRange(UUID worldId, Instant startTime, Instant endTime) {
        return runRepository.findByWorldIdAndTimeRange(worldId, startTime, endTime);
    }

    /**
     * Get load test summary.
     */
    public LoadTestSummary getSummary(UUID worldId) {
        WorldLoadTest worldLoadTest = worldLoadTestRepository.findByWorldId(worldId)
                .orElseThrow(() -> new IllegalArgumentException("World load test not found: " + worldId));

        List<LoadTestRun> recentRuns = runRepository.findRecentByWorldId(worldId, 10);

        return LoadTestSummary.builder()
                .worldId(worldId)
                .overallStatus(worldLoadTest.getOverallStatus())
                .isRunning(worldLoadTest.isRunning())
                .totalRunsCompleted(worldLoadTest.getTotalRunsCompleted())
                .totalRunsFailed(worldLoadTest.getTotalRunsFailed())
                .lastRunAt(worldLoadTest.getLastRunAt())
                .averageRunDuration(worldLoadTest.getAverageRunDuration())
                .recentRuns(recentRuns)
                .build();
    }

    @Getter
    @Builder
    public static class LoadTestSummary {
        private final UUID worldId;
        private final WorldLoadTest.WorldLoadTestStatus overallStatus;
        private final boolean isRunning;
        private final Integer totalRunsCompleted;
        private final Integer totalRunsFailed;
        private final Instant lastRunAt;
        private final java.time.Duration averageRunDuration;
        private final List<LoadTestRun> recentRuns;
    }
}
