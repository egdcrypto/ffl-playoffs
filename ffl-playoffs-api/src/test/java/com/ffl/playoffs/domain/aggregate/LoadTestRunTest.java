package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.loadtest.*;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.Duration;
import java.time.Instant;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("LoadTestRun Aggregate Tests")
class LoadTestRunTest {

    @Test
    @DisplayName("should create run with required fields")
    void shouldCreateRunWithRequiredFields() {
        UUID scenarioId = UUID.randomUUID();
        UUID worldId = UUID.randomUUID();
        LoadTestConfiguration config = LoadTestConfiguration.create("Test", LoadTestType.STRESS);

        LoadTestRun run = LoadTestRun.create(scenarioId, worldId, config);

        assertThat(run.getId()).isNotNull();
        assertThat(run.getScenarioId()).isEqualTo(scenarioId);
        assertThat(run.getWorldId()).isEqualTo(worldId);
        assertThat(run.getStatus()).isEqualTo(LoadTestStatus.PENDING);
        assertThat(run.getConfiguration()).isEqualTo(config);
        assertThat(run.getMetrics()).isEmpty();
        assertThat(run.getThresholdResults()).isEmpty();
        assertThat(run.getTotalRequests()).isEqualTo(0);
        assertThat(run.getSuccessfulRequests()).isEqualTo(0);
        assertThat(run.getFailedRequests()).isEqualTo(0);
        assertThat(run.getCreatedAt()).isNotNull();
    }

    @Test
    @DisplayName("should throw when scenario ID is null")
    void shouldThrowWhenScenarioIdIsNull() {
        assertThatNullPointerException()
                .isThrownBy(() -> LoadTestRun.create(null, UUID.randomUUID(), null))
                .withMessage("Scenario ID is required");
    }

    @Test
    @DisplayName("should throw when world ID is null")
    void shouldThrowWhenWorldIdIsNull() {
        assertThatNullPointerException()
                .isThrownBy(() -> LoadTestRun.create(UUID.randomUUID(), null, null))
                .withMessage("World ID is required");
    }

    @Test
    @DisplayName("should start run from pending state")
    void shouldStartRunFromPendingState() {
        LoadTestRun run = createRun();

        run.start();

        assertThat(run.getStatus()).isEqualTo(LoadTestStatus.RUNNING);
        assertThat(run.getStartTime()).isNotNull();
    }

    @Test
    @DisplayName("should throw when starting run in invalid state")
    void shouldThrowWhenStartingRunInInvalidState() {
        LoadTestRun run = createRun();
        run.start();
        run.complete();

        assertThatIllegalStateException()
                .isThrownBy(run::start)
                .withMessageContaining("Cannot start test run in status");
    }

    @Test
    @DisplayName("should complete run from running state")
    void shouldCompleteRunFromRunningState() {
        LoadTestRun run = createRun();
        run.start();

        run.complete();

        assertThat(run.getStatus()).isEqualTo(LoadTestStatus.COMPLETED);
        assertThat(run.getEndTime()).isNotNull();
    }

    @Test
    @DisplayName("should throw when completing run not in running state")
    void shouldThrowWhenCompletingRunNotInRunningState() {
        LoadTestRun run = createRun();

        assertThatIllegalStateException()
                .isThrownBy(run::complete)
                .withMessageContaining("Cannot complete test run in status");
    }

    @Test
    @DisplayName("should fail run with error message")
    void shouldFailRunWithErrorMessage() {
        LoadTestRun run = createRun();
        run.start();

        run.fail("Connection timeout");

        assertThat(run.getStatus()).isEqualTo(LoadTestStatus.FAILED);
        assertThat(run.getErrorMessage()).isEqualTo("Connection timeout");
        assertThat(run.getEndTime()).isNotNull();
    }

    @Test
    @DisplayName("should cancel run")
    void shouldCancelRun() {
        LoadTestRun run = createRun();
        run.start();

        run.cancel();

        assertThat(run.getStatus()).isEqualTo(LoadTestStatus.CANCELLED);
        assertThat(run.getEndTime()).isNotNull();
    }

    @Test
    @DisplayName("should throw when cancelling completed run")
    void shouldThrowWhenCancellingCompletedRun() {
        LoadTestRun run = createRun();
        run.start();
        run.complete();

        assertThatIllegalStateException()
                .isThrownBy(run::cancel)
                .withMessageContaining("Cannot cancel test run in status");
    }

    @Test
    @DisplayName("should timeout run")
    void shouldTimeoutRun() {
        LoadTestRun run = createRun();
        run.start();

        run.timeout();

        assertThat(run.getStatus()).isEqualTo(LoadTestStatus.TIMED_OUT);
        assertThat(run.getErrorMessage()).isEqualTo("Test run exceeded configured timeout");
        assertThat(run.getEndTime()).isNotNull();
    }

    @Test
    @DisplayName("should record metrics")
    void shouldRecordMetrics() {
        LoadTestRun run = createRun();
        LoadTestMetric metric1 = LoadTestMetric.create(MetricType.RESPONSE_TIME_AVG, 150.0);
        LoadTestMetric metric2 = LoadTestMetric.create(MetricType.THROUGHPUT, 1000.0);

        run.recordMetric(metric1);
        run.recordMetric(metric2);

        assertThat(run.getMetrics()).hasSize(2);
        assertThat(run.getMetrics()).containsExactly(metric1, metric2);
    }

    @Test
    @DisplayName("should record request counts")
    void shouldRecordRequestCounts() {
        LoadTestRun run = createRun();

        run.recordRequests(1000, 950, 50);

        assertThat(run.getTotalRequests()).isEqualTo(1000);
        assertThat(run.getSuccessfulRequests()).isEqualTo(950);
        assertThat(run.getFailedRequests()).isEqualTo(50);
    }

    @Test
    @DisplayName("should increment request counts")
    void shouldIncrementRequestCounts() {
        LoadTestRun run = createRun();

        run.incrementRequests(true);
        run.incrementRequests(true);
        run.incrementRequests(false);

        assertThat(run.getTotalRequests()).isEqualTo(3);
        assertThat(run.getSuccessfulRequests()).isEqualTo(2);
        assertThat(run.getFailedRequests()).isEqualTo(1);
    }

    @Test
    @DisplayName("should calculate success rate")
    void shouldCalculateSuccessRate() {
        LoadTestRun run = createRun();
        run.recordRequests(100, 95, 5);

        assertThat(run.getSuccessRate()).isEqualTo(95.0);
    }

    @Test
    @DisplayName("should return zero success rate when no requests")
    void shouldReturnZeroSuccessRateWhenNoRequests() {
        LoadTestRun run = createRun();

        assertThat(run.getSuccessRate()).isEqualTo(0.0);
    }

    @Test
    @DisplayName("should get metrics by type")
    void shouldGetMetricsByType() {
        LoadTestRun run = createRun();
        run.recordMetric(LoadTestMetric.create(MetricType.RESPONSE_TIME_AVG, 100.0));
        run.recordMetric(LoadTestMetric.create(MetricType.RESPONSE_TIME_AVG, 110.0));
        run.recordMetric(LoadTestMetric.create(MetricType.THROUGHPUT, 500.0));

        assertThat(run.getMetricsByType(MetricType.RESPONSE_TIME_AVG)).hasSize(2);
        assertThat(run.getMetricsByType(MetricType.THROUGHPUT)).hasSize(1);
        assertThat(run.getMetricsByType(MetricType.ERROR_RATE)).isEmpty();
    }

    @Test
    @DisplayName("should get latest metric for type")
    void shouldGetLatestMetricForType() throws InterruptedException {
        LoadTestRun run = createRun();
        run.recordMetric(LoadTestMetric.create(MetricType.RESPONSE_TIME_AVG, 100.0));
        Thread.sleep(10); // Ensure different timestamp
        LoadTestMetric latestMetric = LoadTestMetric.create(MetricType.RESPONSE_TIME_AVG, 150.0);
        run.recordMetric(latestMetric);

        assertThat(run.getLatestMetric(MetricType.RESPONSE_TIME_AVG))
                .isPresent()
                .hasValueSatisfying(m -> assertThat(m.getValue()).isEqualTo(150.0));
    }

    @Test
    @DisplayName("should calculate duration")
    void shouldCalculateDuration() throws InterruptedException {
        LoadTestRun run = createRun();

        // Duration should be zero before starting
        assertThat(run.getDuration()).isEqualTo(Duration.ZERO);

        run.start();
        Thread.sleep(50);

        // Duration should be positive while running
        assertThat(run.getDuration().toMillis()).isGreaterThanOrEqualTo(50);
    }

    @Test
    @DisplayName("should check threshold pass status")
    void shouldCheckThresholdPassStatus() {
        LoadTestRun run = createRun();

        // No thresholds means all passed
        assertThat(run.allThresholdsPassed()).isTrue();
        assertThat(run.hasThresholdWarnings()).isFalse();
    }

    private LoadTestRun createRun() {
        return LoadTestRun.create(
                UUID.randomUUID(),
                UUID.randomUUID(),
                LoadTestConfiguration.create("Test", LoadTestType.STRESS)
        );
    }
}
