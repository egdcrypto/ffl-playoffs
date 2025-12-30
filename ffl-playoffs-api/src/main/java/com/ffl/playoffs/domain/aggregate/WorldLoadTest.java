package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.loadtest.*;
import lombok.*;

import java.time.Duration;
import java.time.Instant;
import java.util.*;

/**
 * Aggregate root for managing load testing for a world.
 * Tracks scenarios, runs, and overall testing status.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WorldLoadTest {
    private UUID id;
    private UUID worldId;
    private String worldName;
    private List<LoadTestScenario> scenarios;
    private List<LoadTestRun> recentRuns;
    private LoadTestRun currentRun;
    private WorldLoadTestStatus overallStatus;
    private Instant lastRunAt;
    private Integer totalRunsCompleted;
    private Integer totalRunsFailed;
    private Duration averageRunDuration;
    private Map<String, String> metadata;
    private Instant createdAt;
    private Instant updatedAt;

    /**
     * Create a new world load test aggregate.
     */
    public static WorldLoadTest create(UUID worldId, String worldName) {
        Objects.requireNonNull(worldId, "World ID is required");

        WorldLoadTest worldLoadTest = new WorldLoadTest();
        worldLoadTest.id = UUID.randomUUID();
        worldLoadTest.worldId = worldId;
        worldLoadTest.worldName = worldName;
        worldLoadTest.scenarios = new ArrayList<>();
        worldLoadTest.recentRuns = new ArrayList<>();
        worldLoadTest.overallStatus = WorldLoadTestStatus.IDLE;
        worldLoadTest.totalRunsCompleted = 0;
        worldLoadTest.totalRunsFailed = 0;
        worldLoadTest.metadata = new HashMap<>();
        worldLoadTest.createdAt = Instant.now();
        worldLoadTest.updatedAt = Instant.now();

        return worldLoadTest;
    }

    /**
     * Add a new test scenario.
     */
    public void addScenario(LoadTestScenario scenario) {
        Objects.requireNonNull(scenario, "Scenario is required");
        if (scenarios == null) {
            scenarios = new ArrayList<>();
        }
        scenarios.add(scenario);
        this.updatedAt = Instant.now();
    }

    /**
     * Remove a test scenario.
     */
    public boolean removeScenario(UUID scenarioId) {
        if (scenarios == null || scenarioId == null) {
            return false;
        }
        boolean removed = scenarios.removeIf(s -> s.getId().equals(scenarioId));
        if (removed) {
            this.updatedAt = Instant.now();
        }
        return removed;
    }

    /**
     * Get a scenario by ID.
     */
    public Optional<LoadTestScenario> getScenario(UUID scenarioId) {
        if (scenarios == null) {
            return Optional.empty();
        }
        return scenarios.stream()
                .filter(s -> s.getId().equals(scenarioId))
                .findFirst();
    }

    /**
     * Get all enabled scenarios.
     */
    public List<LoadTestScenario> getEnabledScenarios() {
        if (scenarios == null) {
            return Collections.emptyList();
        }
        return scenarios.stream()
                .filter(LoadTestScenario::isEnabled)
                .toList();
    }

    /**
     * Start a new test run for a scenario.
     */
    public LoadTestRun startRun(UUID scenarioId) {
        if (currentRun != null && currentRun.getStatus() == LoadTestStatus.RUNNING) {
            throw new IllegalStateException("A test run is already in progress");
        }

        LoadTestScenario scenario = getScenario(scenarioId)
                .orElseThrow(() -> new IllegalArgumentException("Scenario not found: " + scenarioId));

        if (!scenario.isEnabled()) {
            throw new IllegalStateException("Cannot run disabled scenario: " + scenario.getName());
        }

        LoadTestRun run = LoadTestRun.create(scenarioId, worldId, scenario.getConfiguration());
        run.start();

        this.currentRun = run;
        this.overallStatus = WorldLoadTestStatus.RUNNING;
        this.updatedAt = Instant.now();

        return run;
    }

    /**
     * Complete the current test run.
     */
    public void completeCurrentRun() {
        if (currentRun == null) {
            throw new IllegalStateException("No test run in progress");
        }

        currentRun.complete();
        addToRecentRuns(currentRun);

        this.totalRunsCompleted++;
        this.lastRunAt = Instant.now();
        updateAverageRunDuration(currentRun.getDuration());

        this.overallStatus = currentRun.allThresholdsPassed() ?
                WorldLoadTestStatus.PASSED : WorldLoadTestStatus.FAILED;
        this.currentRun = null;
        this.updatedAt = Instant.now();
    }

    /**
     * Fail the current test run.
     */
    public void failCurrentRun(String errorMessage) {
        if (currentRun == null) {
            throw new IllegalStateException("No test run in progress");
        }

        currentRun.fail(errorMessage);
        addToRecentRuns(currentRun);

        this.totalRunsFailed++;
        this.lastRunAt = Instant.now();
        this.overallStatus = WorldLoadTestStatus.FAILED;
        this.currentRun = null;
        this.updatedAt = Instant.now();
    }

    /**
     * Cancel the current test run.
     */
    public void cancelCurrentRun() {
        if (currentRun == null) {
            throw new IllegalStateException("No test run in progress");
        }

        currentRun.cancel();
        addToRecentRuns(currentRun);

        this.overallStatus = WorldLoadTestStatus.IDLE;
        this.currentRun = null;
        this.updatedAt = Instant.now();
    }

    /**
     * Check if a test is currently running.
     */
    public boolean isRunning() {
        return currentRun != null && currentRun.getStatus() == LoadTestStatus.RUNNING;
    }

    /**
     * Get scenarios by tag.
     */
    public List<LoadTestScenario> getScenariosByTag(String tag) {
        if (scenarios == null) {
            return Collections.emptyList();
        }
        return scenarios.stream()
                .filter(s -> s.hasTag(tag))
                .toList();
    }

    /**
     * Get scenarios by type.
     */
    public List<LoadTestScenario> getScenariosByType(LoadTestType type) {
        if (scenarios == null) {
            return Collections.emptyList();
        }
        return scenarios.stream()
                .filter(s -> s.getTestType() == type)
                .toList();
    }

    /**
     * Get the most recent successful run.
     */
    public Optional<LoadTestRun> getLastSuccessfulRun() {
        if (recentRuns == null) {
            return Optional.empty();
        }
        return recentRuns.stream()
                .filter(r -> r.getStatus() == LoadTestStatus.COMPLETED && r.allThresholdsPassed())
                .max(Comparator.comparing(LoadTestRun::getEndTime));
    }

    /**
     * Get the most recent failed run.
     */
    public Optional<LoadTestRun> getLastFailedRun() {
        if (recentRuns == null) {
            return Optional.empty();
        }
        return recentRuns.stream()
                .filter(r -> r.getStatus() == LoadTestStatus.FAILED ||
                        (r.getStatus() == LoadTestStatus.COMPLETED && !r.allThresholdsPassed()))
                .max(Comparator.comparing(LoadTestRun::getEndTime));
    }

    /**
     * Set metadata value.
     */
    public void setMetadata(String key, String value) {
        if (metadata == null) {
            metadata = new HashMap<>();
        }
        metadata.put(key, value);
        this.updatedAt = Instant.now();
    }

    /**
     * Get metadata value.
     */
    public Optional<String> getMetadata(String key) {
        if (metadata == null) {
            return Optional.empty();
        }
        return Optional.ofNullable(metadata.get(key));
    }

    private void addToRecentRuns(LoadTestRun run) {
        if (recentRuns == null) {
            recentRuns = new ArrayList<>();
        }
        recentRuns.add(0, run);
        // Keep only last 100 runs
        if (recentRuns.size() > 100) {
            recentRuns = new ArrayList<>(recentRuns.subList(0, 100));
        }
    }

    private void updateAverageRunDuration(Duration newDuration) {
        if (averageRunDuration == null) {
            averageRunDuration = newDuration;
        } else {
            long totalRuns = totalRunsCompleted + totalRunsFailed;
            long avgMillis = averageRunDuration.toMillis();
            long newAvgMillis = ((avgMillis * (totalRuns - 1)) + newDuration.toMillis()) / totalRuns;
            averageRunDuration = Duration.ofMillis(newAvgMillis);
        }
    }

    public enum WorldLoadTestStatus {
        IDLE,
        RUNNING,
        PASSED,
        FAILED,
        WARNING
    }
}
