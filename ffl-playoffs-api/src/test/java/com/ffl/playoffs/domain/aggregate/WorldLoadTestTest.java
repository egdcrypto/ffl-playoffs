package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.loadtest.LoadTestStatus;
import com.ffl.playoffs.domain.model.loadtest.LoadTestType;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("WorldLoadTest Aggregate Tests")
class WorldLoadTestTest {

    @Test
    @DisplayName("should create world load test with required fields")
    void shouldCreateWorldLoadTestWithRequiredFields() {
        UUID worldId = UUID.randomUUID();

        WorldLoadTest worldLoadTest = WorldLoadTest.create(worldId, "Test World");

        assertThat(worldLoadTest.getId()).isNotNull();
        assertThat(worldLoadTest.getWorldId()).isEqualTo(worldId);
        assertThat(worldLoadTest.getWorldName()).isEqualTo("Test World");
        assertThat(worldLoadTest.getScenarios()).isEmpty();
        assertThat(worldLoadTest.getRecentRuns()).isEmpty();
        assertThat(worldLoadTest.getCurrentRun()).isNull();
        assertThat(worldLoadTest.getOverallStatus()).isEqualTo(WorldLoadTest.WorldLoadTestStatus.IDLE);
        assertThat(worldLoadTest.getTotalRunsCompleted()).isEqualTo(0);
        assertThat(worldLoadTest.getTotalRunsFailed()).isEqualTo(0);
        assertThat(worldLoadTest.getCreatedAt()).isNotNull();
    }

    @Test
    @DisplayName("should throw when world ID is null")
    void shouldThrowWhenWorldIdIsNull() {
        assertThatNullPointerException()
                .isThrownBy(() -> WorldLoadTest.create(null, "Test"))
                .withMessage("World ID is required");
    }

    @Test
    @DisplayName("should add scenario")
    void shouldAddScenario() {
        WorldLoadTest worldLoadTest = createWorldLoadTest();
        LoadTestScenario scenario = LoadTestScenario.create(worldLoadTest.getWorldId(), "Test Scenario", LoadTestType.STRESS);

        worldLoadTest.addScenario(scenario);

        assertThat(worldLoadTest.getScenarios()).hasSize(1);
        assertThat(worldLoadTest.getScenarios()).contains(scenario);
    }

    @Test
    @DisplayName("should throw when adding null scenario")
    void shouldThrowWhenAddingNullScenario() {
        WorldLoadTest worldLoadTest = createWorldLoadTest();

        assertThatNullPointerException()
                .isThrownBy(() -> worldLoadTest.addScenario(null))
                .withMessage("Scenario is required");
    }

    @Test
    @DisplayName("should remove scenario")
    void shouldRemoveScenario() {
        WorldLoadTest worldLoadTest = createWorldLoadTest();
        LoadTestScenario scenario = LoadTestScenario.create(worldLoadTest.getWorldId(), "Test Scenario", LoadTestType.STRESS);
        worldLoadTest.addScenario(scenario);

        boolean removed = worldLoadTest.removeScenario(scenario.getId());

        assertThat(removed).isTrue();
        assertThat(worldLoadTest.getScenarios()).isEmpty();
    }

    @Test
    @DisplayName("should return false when removing non-existent scenario")
    void shouldReturnFalseWhenRemovingNonExistentScenario() {
        WorldLoadTest worldLoadTest = createWorldLoadTest();

        boolean removed = worldLoadTest.removeScenario(UUID.randomUUID());

        assertThat(removed).isFalse();
    }

    @Test
    @DisplayName("should get scenario by ID")
    void shouldGetScenarioById() {
        WorldLoadTest worldLoadTest = createWorldLoadTest();
        LoadTestScenario scenario = LoadTestScenario.create(worldLoadTest.getWorldId(), "Test Scenario", LoadTestType.STRESS);
        worldLoadTest.addScenario(scenario);

        assertThat(worldLoadTest.getScenario(scenario.getId()))
                .isPresent()
                .hasValue(scenario);
    }

    @Test
    @DisplayName("should return empty when scenario not found")
    void shouldReturnEmptyWhenScenarioNotFound() {
        WorldLoadTest worldLoadTest = createWorldLoadTest();

        assertThat(worldLoadTest.getScenario(UUID.randomUUID())).isEmpty();
    }

    @Test
    @DisplayName("should get enabled scenarios")
    void shouldGetEnabledScenarios() {
        WorldLoadTest worldLoadTest = createWorldLoadTest();
        LoadTestScenario enabledScenario = LoadTestScenario.create(worldLoadTest.getWorldId(), "Enabled", LoadTestType.STRESS);
        LoadTestScenario disabledScenario = LoadTestScenario.create(worldLoadTest.getWorldId(), "Disabled", LoadTestType.STRESS);
        disabledScenario.disable();

        worldLoadTest.addScenario(enabledScenario);
        worldLoadTest.addScenario(disabledScenario);

        assertThat(worldLoadTest.getEnabledScenarios()).hasSize(1);
        assertThat(worldLoadTest.getEnabledScenarios()).contains(enabledScenario);
    }

    @Test
    @DisplayName("should start run for scenario")
    void shouldStartRunForScenario() {
        WorldLoadTest worldLoadTest = createWorldLoadTest();
        LoadTestScenario scenario = LoadTestScenario.create(worldLoadTest.getWorldId(), "Test Scenario", LoadTestType.STRESS);
        worldLoadTest.addScenario(scenario);

        LoadTestRun run = worldLoadTest.startRun(scenario.getId());

        assertThat(run).isNotNull();
        assertThat(run.getScenarioId()).isEqualTo(scenario.getId());
        assertThat(run.getWorldId()).isEqualTo(worldLoadTest.getWorldId());
        assertThat(run.getStatus()).isEqualTo(LoadTestStatus.RUNNING);
        assertThat(worldLoadTest.getCurrentRun()).isEqualTo(run);
        assertThat(worldLoadTest.getOverallStatus()).isEqualTo(WorldLoadTest.WorldLoadTestStatus.RUNNING);
        assertThat(worldLoadTest.isRunning()).isTrue();
    }

    @Test
    @DisplayName("should throw when starting run with run already in progress")
    void shouldThrowWhenStartingRunWithRunAlreadyInProgress() {
        WorldLoadTest worldLoadTest = createWorldLoadTest();
        LoadTestScenario scenario = LoadTestScenario.create(worldLoadTest.getWorldId(), "Test Scenario", LoadTestType.STRESS);
        worldLoadTest.addScenario(scenario);
        worldLoadTest.startRun(scenario.getId());

        assertThatIllegalStateException()
                .isThrownBy(() -> worldLoadTest.startRun(scenario.getId()))
                .withMessage("A test run is already in progress");
    }

    @Test
    @DisplayName("should throw when starting run for non-existent scenario")
    void shouldThrowWhenStartingRunForNonExistentScenario() {
        WorldLoadTest worldLoadTest = createWorldLoadTest();
        UUID nonExistentScenarioId = UUID.randomUUID();

        assertThatIllegalArgumentException()
                .isThrownBy(() -> worldLoadTest.startRun(nonExistentScenarioId))
                .withMessageContaining("Scenario not found");
    }

    @Test
    @DisplayName("should throw when starting run for disabled scenario")
    void shouldThrowWhenStartingRunForDisabledScenario() {
        WorldLoadTest worldLoadTest = createWorldLoadTest();
        LoadTestScenario scenario = LoadTestScenario.create(worldLoadTest.getWorldId(), "Disabled Scenario", LoadTestType.STRESS);
        scenario.disable();
        worldLoadTest.addScenario(scenario);

        assertThatIllegalStateException()
                .isThrownBy(() -> worldLoadTest.startRun(scenario.getId()))
                .withMessageContaining("Cannot run disabled scenario");
    }

    @Test
    @DisplayName("should complete current run")
    void shouldCompleteCurrentRun() {
        WorldLoadTest worldLoadTest = createWorldLoadTest();
        LoadTestScenario scenario = LoadTestScenario.create(worldLoadTest.getWorldId(), "Test Scenario", LoadTestType.STRESS);
        worldLoadTest.addScenario(scenario);
        worldLoadTest.startRun(scenario.getId());

        worldLoadTest.completeCurrentRun();

        assertThat(worldLoadTest.getCurrentRun()).isNull();
        assertThat(worldLoadTest.isRunning()).isFalse();
        assertThat(worldLoadTest.getTotalRunsCompleted()).isEqualTo(1);
        assertThat(worldLoadTest.getLastRunAt()).isNotNull();
        assertThat(worldLoadTest.getRecentRuns()).hasSize(1);
        assertThat(worldLoadTest.getOverallStatus()).isEqualTo(WorldLoadTest.WorldLoadTestStatus.PASSED);
    }

    @Test
    @DisplayName("should throw when completing with no run in progress")
    void shouldThrowWhenCompletingWithNoRunInProgress() {
        WorldLoadTest worldLoadTest = createWorldLoadTest();

        assertThatIllegalStateException()
                .isThrownBy(worldLoadTest::completeCurrentRun)
                .withMessage("No test run in progress");
    }

    @Test
    @DisplayName("should fail current run")
    void shouldFailCurrentRun() {
        WorldLoadTest worldLoadTest = createWorldLoadTest();
        LoadTestScenario scenario = LoadTestScenario.create(worldLoadTest.getWorldId(), "Test Scenario", LoadTestType.STRESS);
        worldLoadTest.addScenario(scenario);
        worldLoadTest.startRun(scenario.getId());

        worldLoadTest.failCurrentRun("Connection error");

        assertThat(worldLoadTest.getCurrentRun()).isNull();
        assertThat(worldLoadTest.isRunning()).isFalse();
        assertThat(worldLoadTest.getTotalRunsFailed()).isEqualTo(1);
        assertThat(worldLoadTest.getOverallStatus()).isEqualTo(WorldLoadTest.WorldLoadTestStatus.FAILED);
        assertThat(worldLoadTest.getRecentRuns()).hasSize(1);
        assertThat(worldLoadTest.getRecentRuns().get(0).getErrorMessage()).isEqualTo("Connection error");
    }

    @Test
    @DisplayName("should cancel current run")
    void shouldCancelCurrentRun() {
        WorldLoadTest worldLoadTest = createWorldLoadTest();
        LoadTestScenario scenario = LoadTestScenario.create(worldLoadTest.getWorldId(), "Test Scenario", LoadTestType.STRESS);
        worldLoadTest.addScenario(scenario);
        worldLoadTest.startRun(scenario.getId());

        worldLoadTest.cancelCurrentRun();

        assertThat(worldLoadTest.getCurrentRun()).isNull();
        assertThat(worldLoadTest.isRunning()).isFalse();
        assertThat(worldLoadTest.getOverallStatus()).isEqualTo(WorldLoadTest.WorldLoadTestStatus.IDLE);
        assertThat(worldLoadTest.getRecentRuns()).hasSize(1);
    }

    @Test
    @DisplayName("should get scenarios by tag")
    void shouldGetScenariosByTag() {
        WorldLoadTest worldLoadTest = createWorldLoadTest();
        LoadTestScenario scenario1 = LoadTestScenario.create(worldLoadTest.getWorldId(), "API Test", LoadTestType.STRESS);
        scenario1.addTag("api");
        scenario1.addTag("critical");
        LoadTestScenario scenario2 = LoadTestScenario.create(worldLoadTest.getWorldId(), "UI Test", LoadTestType.STRESS);
        scenario2.addTag("ui");

        worldLoadTest.addScenario(scenario1);
        worldLoadTest.addScenario(scenario2);

        assertThat(worldLoadTest.getScenariosByTag("api")).hasSize(1).contains(scenario1);
        assertThat(worldLoadTest.getScenariosByTag("critical")).hasSize(1).contains(scenario1);
        assertThat(worldLoadTest.getScenariosByTag("ui")).hasSize(1).contains(scenario2);
        assertThat(worldLoadTest.getScenariosByTag("nonexistent")).isEmpty();
    }

    @Test
    @DisplayName("should get scenarios by type")
    void shouldGetScenariosByType() {
        WorldLoadTest worldLoadTest = createWorldLoadTest();
        LoadTestScenario stressScenario = LoadTestScenario.create(worldLoadTest.getWorldId(), "Stress", LoadTestType.STRESS);
        LoadTestScenario soakScenario = LoadTestScenario.create(worldLoadTest.getWorldId(), "Soak", LoadTestType.SOAK);

        worldLoadTest.addScenario(stressScenario);
        worldLoadTest.addScenario(soakScenario);

        assertThat(worldLoadTest.getScenariosByType(LoadTestType.STRESS)).hasSize(1).contains(stressScenario);
        assertThat(worldLoadTest.getScenariosByType(LoadTestType.SOAK)).hasSize(1).contains(soakScenario);
        assertThat(worldLoadTest.getScenariosByType(LoadTestType.SPIKE)).isEmpty();
    }

    @Test
    @DisplayName("should set and get metadata")
    void shouldSetAndGetMetadata() {
        WorldLoadTest worldLoadTest = createWorldLoadTest();

        worldLoadTest.setMetadata("environment", "staging");
        worldLoadTest.setMetadata("version", "1.0.0");

        assertThat(worldLoadTest.getMetadata("environment")).isPresent().hasValue("staging");
        assertThat(worldLoadTest.getMetadata("version")).isPresent().hasValue("1.0.0");
        assertThat(worldLoadTest.getMetadata("nonexistent")).isEmpty();
    }

    @Test
    @DisplayName("should track average run duration")
    void shouldTrackAverageRunDuration() {
        WorldLoadTest worldLoadTest = createWorldLoadTest();
        LoadTestScenario scenario = LoadTestScenario.create(worldLoadTest.getWorldId(), "Test", LoadTestType.STRESS);
        worldLoadTest.addScenario(scenario);

        // First run
        worldLoadTest.startRun(scenario.getId());
        worldLoadTest.completeCurrentRun();
        assertThat(worldLoadTest.getAverageRunDuration()).isNotNull();
    }

    private WorldLoadTest createWorldLoadTest() {
        return WorldLoadTest.create(UUID.randomUUID(), "Test World");
    }
}
