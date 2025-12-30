package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.performance.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("PerformanceAlert Aggregate Tests")
class PerformanceAlertTest {

    private UUID userId;
    private AlertThreshold threshold;

    @BeforeEach
    void setUp() {
        userId = UUID.randomUUID();
        threshold = AlertThreshold.of(
                MetricType.CPU_UTILIZATION,
                AlertCondition.ABOVE,
                80.0,
                AlertSeverity.WARNING
        );
    }

    @Nested
    @DisplayName("Creation Tests")
    class CreationTests {

        @Test
        @DisplayName("should create alert with required fields")
        void shouldCreateAlertWithRequiredFields() {
            PerformanceAlert alert = PerformanceAlert.create(
                    "High CPU Alert",
                    "Alert when CPU exceeds 80%",
                    threshold,
                    userId
            );

            assertThat(alert.getId()).isNotNull();
            assertThat(alert.getName()).isEqualTo("High CPU Alert");
            assertThat(alert.getDescription()).isEqualTo("Alert when CPU exceeds 80%");
            assertThat(alert.getThreshold()).isEqualTo(threshold);
            assertThat(alert.isEnabled()).isTrue();
            assertThat(alert.getStatus()).isEqualTo(AlertStatus.RESOLVED);
            assertThat(alert.getCreatedBy()).isEqualTo(userId);
            assertThat(alert.getCreatedAt()).isNotNull();
        }

        @Test
        @DisplayName("should have default escalation policy")
        void shouldHaveDefaultEscalationPolicy() {
            PerformanceAlert alert = PerformanceAlert.create("Test", null, threshold, userId);

            assertThat(alert.getEscalationPolicy()).isNotNull();
            assertThat(alert.getEscalationPolicy().getLevelCount()).isGreaterThan(0);
        }

        @Test
        @DisplayName("should have default notification channel")
        void shouldHaveDefaultNotificationChannel() {
            PerformanceAlert alert = PerformanceAlert.create("Test", null, threshold, userId);

            assertThat(alert.getNotificationChannels()).contains(NotificationChannel.EMAIL);
        }
    }

    @Nested
    @DisplayName("Lifecycle Tests")
    class LifecycleTests {

        @Test
        @DisplayName("should trigger alert")
        void shouldTriggerAlert() {
            PerformanceAlert alert = PerformanceAlert.create("Test", null, threshold, userId);

            alert.trigger();

            assertThat(alert.getStatus()).isEqualTo(AlertStatus.ACTIVE);
            assertThat(alert.getTriggeredAt()).isNotNull();
        }

        @Test
        @DisplayName("should not trigger disabled alert")
        void shouldNotTriggerDisabledAlert() {
            PerformanceAlert alert = PerformanceAlert.create("Test", null, threshold, userId);
            alert.disable();

            assertThatThrownBy(alert::trigger)
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("disabled");
        }

        @Test
        @DisplayName("should acknowledge active alert")
        void shouldAcknowledgeActiveAlert() {
            PerformanceAlert alert = PerformanceAlert.create("Test", null, threshold, userId);
            alert.trigger();

            UUID ackUser = UUID.randomUUID();
            alert.acknowledge(ackUser);

            assertThat(alert.getStatus()).isEqualTo(AlertStatus.ACKNOWLEDGED);
            assertThat(alert.getAcknowledgedBy()).isEqualTo(ackUser);
            assertThat(alert.getAcknowledgedAt()).isNotNull();
        }

        @Test
        @DisplayName("should not acknowledge non-active alert")
        void shouldNotAcknowledgeNonActiveAlert() {
            PerformanceAlert alert = PerformanceAlert.create("Test", null, threshold, userId);

            assertThatThrownBy(() -> alert.acknowledge(UUID.randomUUID()))
                    .isInstanceOf(IllegalStateException.class);
        }

        @Test
        @DisplayName("should resolve acknowledged alert")
        void shouldResolveAcknowledgedAlert() {
            PerformanceAlert alert = PerformanceAlert.create("Test", null, threshold, userId);
            alert.trigger();
            alert.acknowledge(userId);

            UUID resolveUser = UUID.randomUUID();
            alert.resolve(resolveUser, "Fixed the issue");

            assertThat(alert.getStatus()).isEqualTo(AlertStatus.RESOLVED);
            assertThat(alert.getResolvedBy()).isEqualTo(resolveUser);
            assertThat(alert.getResolutionNote()).isEqualTo("Fixed the issue");
        }

        @Test
        @DisplayName("should resolve active alert directly")
        void shouldResolveActiveAlertDirectly() {
            PerformanceAlert alert = PerformanceAlert.create("Test", null, threshold, userId);
            alert.trigger();

            alert.resolve(userId, "Auto-resolved");

            assertThat(alert.getStatus()).isEqualTo(AlertStatus.RESOLVED);
        }
    }

    @Nested
    @DisplayName("Suppression Tests")
    class SuppressionTests {

        @Test
        @DisplayName("should suppress alert")
        void shouldSuppressAlert() {
            PerformanceAlert alert = PerformanceAlert.create("Test", null, threshold, userId);
            Instant until = Instant.now().plus(1, ChronoUnit.HOURS);

            alert.suppress(until, "Maintenance window");

            assertThat(alert.isSuppressed()).isTrue();
            assertThat(alert.getSuppressedUntil()).isEqualTo(until);
            assertThat(alert.getSuppressionReason()).isEqualTo("Maintenance window");
        }

        @Test
        @DisplayName("should not allow past suppression time")
        void shouldNotAllowPastSuppressionTime() {
            PerformanceAlert alert = PerformanceAlert.create("Test", null, threshold, userId);
            Instant pastTime = Instant.now().minus(1, ChronoUnit.HOURS);

            assertThatThrownBy(() -> alert.suppress(pastTime, "reason"))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("future");
        }

        @Test
        @DisplayName("should clear suppression")
        void shouldClearSuppression() {
            PerformanceAlert alert = PerformanceAlert.create("Test", null, threshold, userId);
            alert.suppress(Instant.now().plus(1, ChronoUnit.HOURS), "reason");

            alert.clearSuppression();

            assertThat(alert.isSuppressed()).isFalse();
            assertThat(alert.getSuppressedUntil()).isNull();
        }

        @Test
        @DisplayName("should not trigger during suppression")
        void shouldNotTriggerDuringSuppression() {
            PerformanceAlert alert = PerformanceAlert.create("Test", null, threshold, userId);
            alert.suppress(Instant.now().plus(1, ChronoUnit.HOURS), "reason");

            alert.trigger();

            assertThat(alert.getStatus()).isEqualTo(AlertStatus.RESOLVED); // Should not change
        }
    }

    @Nested
    @DisplayName("Threshold Check Tests")
    class ThresholdCheckTests {

        @Test
        @DisplayName("should detect threshold triggered")
        void shouldDetectThresholdTriggered() {
            PerformanceAlert alert = PerformanceAlert.create("Test", null, threshold, userId);

            MetricValue high = MetricValue.of(MetricType.CPU_UTILIZATION, 85.0, "%");
            MetricValue low = MetricValue.of(MetricType.CPU_UTILIZATION, 75.0, "%");

            assertThat(alert.isThresholdTriggered(high, null)).isTrue();
            assertThat(alert.isThresholdTriggered(low, null)).isFalse();
        }

        @Test
        @DisplayName("should ignore mismatched metric type")
        void shouldIgnoreMismatchedMetricType() {
            PerformanceAlert alert = PerformanceAlert.create("Test", null, threshold, userId);

            MetricValue wrongType = MetricValue.of(MetricType.MEMORY_UTILIZATION, 95.0, "%");

            assertThat(alert.isThresholdTriggered(wrongType, null)).isFalse();
        }
    }

    @Nested
    @DisplayName("Enable/Disable Tests")
    class EnableDisableTests {

        @Test
        @DisplayName("should enable alert")
        void shouldEnableAlert() {
            PerformanceAlert alert = PerformanceAlert.create("Test", null, threshold, userId);
            alert.disable();

            alert.enable();

            assertThat(alert.isEnabled()).isTrue();
        }

        @Test
        @DisplayName("should disable alert")
        void shouldDisableAlert() {
            PerformanceAlert alert = PerformanceAlert.create("Test", null, threshold, userId);

            alert.disable();

            assertThat(alert.isEnabled()).isFalse();
        }
    }
}
