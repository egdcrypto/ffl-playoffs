package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.performance.DashboardWidget;
import com.ffl.playoffs.domain.model.performance.MetricType;
import lombok.*;

import java.time.Instant;
import java.util.*;

/**
 * Aggregate root for customizable performance dashboards.
 * Manages widget configuration and layout for admin users.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PerformanceDashboard {
    private UUID id;
    private String name;
    private String description;
    private UUID ownerId;
    private boolean isDefault;
    private boolean isShared;
    private String defaultTimeRange;
    private List<DashboardWidget> widgets;
    private Instant createdAt;
    private Instant updatedAt;

    /**
     * Create a new dashboard.
     */
    public static PerformanceDashboard create(String name, UUID ownerId) {
        Objects.requireNonNull(name, "Dashboard name is required");
        Objects.requireNonNull(ownerId, "Owner ID is required");

        PerformanceDashboard dashboard = new PerformanceDashboard();
        dashboard.id = UUID.randomUUID();
        dashboard.name = name;
        dashboard.ownerId = ownerId;
        dashboard.isDefault = false;
        dashboard.isShared = false;
        dashboard.defaultTimeRange = "1h";
        dashboard.widgets = new ArrayList<>();
        dashboard.createdAt = Instant.now();
        dashboard.updatedAt = Instant.now();

        return dashboard;
    }

    /**
     * Create a default dashboard with standard monitoring widgets.
     */
    public static PerformanceDashboard createDefault(UUID ownerId) {
        PerformanceDashboard dashboard = create("Performance Overview", ownerId);
        dashboard.isDefault = true;
        dashboard.description = "Default performance monitoring dashboard";

        // Add default widgets
        dashboard.addWidget(DashboardWidget.create(
                "Health Score", DashboardWidget.WidgetType.GAUGE, MetricType.OVERALL_HEALTH_SCORE)
                .withPosition(0, 0).withSize(2, 2));

        dashboard.addWidget(DashboardWidget.create(
                "Active Users", DashboardWidget.WidgetType.COUNTER, MetricType.ACTIVE_USERS)
                .withPosition(2, 0).withSize(1, 1));

        dashboard.addWidget(DashboardWidget.create(
                "Requests/sec", DashboardWidget.WidgetType.SPARKLINE, MetricType.REQUESTS_PER_SECOND)
                .withPosition(3, 0).withSize(2, 1));

        dashboard.addWidget(DashboardWidget.create(
                "Response Time", DashboardWidget.WidgetType.LINE_CHART, MetricType.AVERAGE_RESPONSE_TIME)
                .withPosition(0, 2).withSize(3, 2));

        dashboard.addWidget(DashboardWidget.create(
                "Error Rate", DashboardWidget.WidgetType.LINE_CHART, MetricType.ERROR_RATE)
                .withPosition(3, 2).withSize(2, 2));

        dashboard.addWidget(DashboardWidget.create(
                "CPU Usage", DashboardWidget.WidgetType.GAUGE, MetricType.CPU_UTILIZATION)
                .withPosition(0, 4).withSize(1, 1));

        dashboard.addWidget(DashboardWidget.create(
                "Memory Usage", DashboardWidget.WidgetType.GAUGE, MetricType.MEMORY_UTILIZATION)
                .withPosition(1, 4).withSize(1, 1));

        return dashboard;
    }

    /**
     * Add a widget to the dashboard.
     */
    public void addWidget(DashboardWidget widget) {
        Objects.requireNonNull(widget, "Widget is required");
        if (this.widgets == null) {
            this.widgets = new ArrayList<>();
        }
        this.widgets.add(widget);
        this.updatedAt = Instant.now();
    }

    /**
     * Remove a widget by ID.
     */
    public boolean removeWidget(UUID widgetId) {
        if (this.widgets == null || widgetId == null) {
            return false;
        }
        boolean removed = this.widgets.removeIf(w -> w.getId().equals(widgetId));
        if (removed) {
            this.updatedAt = Instant.now();
        }
        return removed;
    }

    /**
     * Update a widget's position.
     */
    public void updateWidgetPosition(UUID widgetId, Integer x, Integer y) {
        Objects.requireNonNull(widgetId, "Widget ID is required");
        if (this.widgets == null) return;

        for (int i = 0; i < this.widgets.size(); i++) {
            if (this.widgets.get(i).getId().equals(widgetId)) {
                this.widgets.set(i, this.widgets.get(i).withPosition(x, y));
                this.updatedAt = Instant.now();
                return;
            }
        }
    }

    /**
     * Update a widget's size.
     */
    public void updateWidgetSize(UUID widgetId, Integer width, Integer height) {
        Objects.requireNonNull(widgetId, "Widget ID is required");
        if (this.widgets == null) return;

        for (int i = 0; i < this.widgets.size(); i++) {
            if (this.widgets.get(i).getId().equals(widgetId)) {
                this.widgets.set(i, this.widgets.get(i).withSize(width, height));
                this.updatedAt = Instant.now();
                return;
            }
        }
    }

    /**
     * Set the default time range for all widgets.
     */
    public void setDefaultTimeRange(String timeRange) {
        Objects.requireNonNull(timeRange, "Time range is required");
        this.defaultTimeRange = timeRange;
        this.updatedAt = Instant.now();
    }

    /**
     * Update the dashboard name.
     */
    public void updateName(String name) {
        Objects.requireNonNull(name, "Name is required");
        if (name.isBlank()) {
            throw new IllegalArgumentException("Name cannot be blank");
        }
        this.name = name;
        this.updatedAt = Instant.now();
    }

    /**
     * Update the dashboard description.
     */
    public void updateDescription(String description) {
        this.description = description;
        this.updatedAt = Instant.now();
    }

    /**
     * Share the dashboard with other users.
     */
    public void share() {
        this.isShared = true;
        this.updatedAt = Instant.now();
    }

    /**
     * Unshare the dashboard.
     */
    public void unshare() {
        this.isShared = false;
        this.updatedAt = Instant.now();
    }

    /**
     * Mark as default dashboard for the user.
     */
    public void markAsDefault() {
        this.isDefault = true;
        this.updatedAt = Instant.now();
    }

    /**
     * Unmark as default dashboard.
     */
    public void unmarkAsDefault() {
        this.isDefault = false;
        this.updatedAt = Instant.now();
    }

    /**
     * Get the widget count.
     */
    public int getWidgetCount() {
        return widgets != null ? widgets.size() : 0;
    }

    /**
     * Check if the dashboard is owned by a specific user.
     */
    public boolean isOwnedBy(UUID userId) {
        return ownerId != null && ownerId.equals(userId);
    }
}
