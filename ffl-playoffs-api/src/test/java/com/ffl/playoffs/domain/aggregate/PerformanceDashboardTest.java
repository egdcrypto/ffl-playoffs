package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.performance.DashboardWidget;
import com.ffl.playoffs.domain.model.performance.MetricType;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("PerformanceDashboard Aggregate Tests")
class PerformanceDashboardTest {

    private UUID userId;

    @BeforeEach
    void setUp() {
        userId = UUID.randomUUID();
    }

    @Nested
    @DisplayName("Creation Tests")
    class CreationTests {

        @Test
        @DisplayName("should create dashboard with required fields")
        void shouldCreateDashboardWithRequiredFields() {
            PerformanceDashboard dashboard = PerformanceDashboard.create("My Dashboard", userId);

            assertThat(dashboard.getId()).isNotNull();
            assertThat(dashboard.getName()).isEqualTo("My Dashboard");
            assertThat(dashboard.getOwnerId()).isEqualTo(userId);
            assertThat(dashboard.isDefault()).isFalse();
            assertThat(dashboard.isShared()).isFalse();
            assertThat(dashboard.getDefaultTimeRange()).isEqualTo("1h");
            assertThat(dashboard.getWidgetCount()).isZero();
        }

        @Test
        @DisplayName("should create default dashboard with widgets")
        void shouldCreateDefaultDashboardWithWidgets() {
            PerformanceDashboard dashboard = PerformanceDashboard.createDefault(userId);

            assertThat(dashboard.getName()).isEqualTo("Performance Overview");
            assertThat(dashboard.isDefault()).isTrue();
            assertThat(dashboard.getWidgetCount()).isGreaterThan(0);
        }

        @Test
        @DisplayName("should throw for null name")
        void shouldThrowForNullName() {
            assertThatThrownBy(() -> PerformanceDashboard.create(null, userId))
                    .isInstanceOf(NullPointerException.class);
        }

        @Test
        @DisplayName("should throw for null owner")
        void shouldThrowForNullOwner() {
            assertThatThrownBy(() -> PerformanceDashboard.create("Test", null))
                    .isInstanceOf(NullPointerException.class);
        }
    }

    @Nested
    @DisplayName("Widget Management Tests")
    class WidgetManagementTests {

        @Test
        @DisplayName("should add widget")
        void shouldAddWidget() {
            PerformanceDashboard dashboard = PerformanceDashboard.create("Test", userId);
            DashboardWidget widget = DashboardWidget.create(
                    "CPU Chart",
                    DashboardWidget.WidgetType.LINE_CHART,
                    MetricType.CPU_UTILIZATION
            );

            dashboard.addWidget(widget);

            assertThat(dashboard.getWidgetCount()).isEqualTo(1);
            assertThat(dashboard.getWidgets().get(0).getTitle()).isEqualTo("CPU Chart");
        }

        @Test
        @DisplayName("should remove widget by ID")
        void shouldRemoveWidgetById() {
            PerformanceDashboard dashboard = PerformanceDashboard.create("Test", userId);
            DashboardWidget widget = DashboardWidget.create(
                    "CPU Chart",
                    DashboardWidget.WidgetType.LINE_CHART,
                    MetricType.CPU_UTILIZATION
            );
            dashboard.addWidget(widget);

            boolean removed = dashboard.removeWidget(widget.getId());

            assertThat(removed).isTrue();
            assertThat(dashboard.getWidgetCount()).isZero();
        }

        @Test
        @DisplayName("should return false when removing non-existent widget")
        void shouldReturnFalseWhenRemovingNonExistentWidget() {
            PerformanceDashboard dashboard = PerformanceDashboard.create("Test", userId);

            boolean removed = dashboard.removeWidget(UUID.randomUUID());

            assertThat(removed).isFalse();
        }

        @Test
        @DisplayName("should update widget position")
        void shouldUpdateWidgetPosition() {
            PerformanceDashboard dashboard = PerformanceDashboard.create("Test", userId);
            DashboardWidget widget = DashboardWidget.create(
                    "CPU Chart",
                    DashboardWidget.WidgetType.LINE_CHART,
                    MetricType.CPU_UTILIZATION
            );
            dashboard.addWidget(widget);

            dashboard.updateWidgetPosition(widget.getId(), 5, 10);

            assertThat(dashboard.getWidgets().get(0).getPositionX()).isEqualTo(5);
            assertThat(dashboard.getWidgets().get(0).getPositionY()).isEqualTo(10);
        }

        @Test
        @DisplayName("should update widget size")
        void shouldUpdateWidgetSize() {
            PerformanceDashboard dashboard = PerformanceDashboard.create("Test", userId);
            DashboardWidget widget = DashboardWidget.create(
                    "CPU Chart",
                    DashboardWidget.WidgetType.LINE_CHART,
                    MetricType.CPU_UTILIZATION
            );
            dashboard.addWidget(widget);

            dashboard.updateWidgetSize(widget.getId(), 3, 2);

            assertThat(dashboard.getWidgets().get(0).getWidth()).isEqualTo(3);
            assertThat(dashboard.getWidgets().get(0).getHeight()).isEqualTo(2);
        }
    }

    @Nested
    @DisplayName("Dashboard Settings Tests")
    class DashboardSettingsTests {

        @Test
        @DisplayName("should update name")
        void shouldUpdateName() {
            PerformanceDashboard dashboard = PerformanceDashboard.create("Old Name", userId);

            dashboard.updateName("New Name");

            assertThat(dashboard.getName()).isEqualTo("New Name");
        }

        @Test
        @DisplayName("should throw for blank name")
        void shouldThrowForBlankName() {
            PerformanceDashboard dashboard = PerformanceDashboard.create("Test", userId);

            assertThatThrownBy(() -> dashboard.updateName("   "))
                    .isInstanceOf(IllegalArgumentException.class);
        }

        @Test
        @DisplayName("should update description")
        void shouldUpdateDescription() {
            PerformanceDashboard dashboard = PerformanceDashboard.create("Test", userId);

            dashboard.updateDescription("My custom dashboard");

            assertThat(dashboard.getDescription()).isEqualTo("My custom dashboard");
        }

        @Test
        @DisplayName("should set default time range")
        void shouldSetDefaultTimeRange() {
            PerformanceDashboard dashboard = PerformanceDashboard.create("Test", userId);

            dashboard.setDefaultTimeRange("24h");

            assertThat(dashboard.getDefaultTimeRange()).isEqualTo("24h");
        }
    }

    @Nested
    @DisplayName("Sharing Tests")
    class SharingTests {

        @Test
        @DisplayName("should share dashboard")
        void shouldShareDashboard() {
            PerformanceDashboard dashboard = PerformanceDashboard.create("Test", userId);

            dashboard.share();

            assertThat(dashboard.isShared()).isTrue();
        }

        @Test
        @DisplayName("should unshare dashboard")
        void shouldUnshareDashboard() {
            PerformanceDashboard dashboard = PerformanceDashboard.create("Test", userId);
            dashboard.share();

            dashboard.unshare();

            assertThat(dashboard.isShared()).isFalse();
        }
    }

    @Nested
    @DisplayName("Default Dashboard Tests")
    class DefaultDashboardTests {

        @Test
        @DisplayName("should mark as default")
        void shouldMarkAsDefault() {
            PerformanceDashboard dashboard = PerformanceDashboard.create("Test", userId);

            dashboard.markAsDefault();

            assertThat(dashboard.isDefault()).isTrue();
        }

        @Test
        @DisplayName("should unmark as default")
        void shouldUnmarkAsDefault() {
            PerformanceDashboard dashboard = PerformanceDashboard.createDefault(userId);

            dashboard.unmarkAsDefault();

            assertThat(dashboard.isDefault()).isFalse();
        }
    }

    @Test
    @DisplayName("should check ownership correctly")
    void shouldCheckOwnershipCorrectly() {
        PerformanceDashboard dashboard = PerformanceDashboard.create("Test", userId);

        assertThat(dashboard.isOwnedBy(userId)).isTrue();
        assertThat(dashboard.isOwnedBy(UUID.randomUUID())).isFalse();
    }
}
