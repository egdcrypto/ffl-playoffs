package com.ffl.playoffs.domain.model.performance;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.ToString;

import java.util.Objects;
import java.util.UUID;

/**
 * Immutable value object representing a dashboard widget configuration.
 */
@Getter
@ToString
@EqualsAndHashCode
public final class DashboardWidget {
    private final UUID id;
    private final String title;
    private final WidgetType type;
    private final MetricType metricType;
    private final Integer positionX;
    private final Integer positionY;
    private final Integer width;
    private final Integer height;
    private final String timeRange;

    private DashboardWidget(UUID id, String title, WidgetType type, MetricType metricType,
                           Integer positionX, Integer positionY, Integer width, Integer height,
                           String timeRange) {
        this.id = id != null ? id : UUID.randomUUID();
        this.title = Objects.requireNonNull(title, "Widget title is required");
        this.type = Objects.requireNonNull(type, "Widget type is required");
        this.metricType = Objects.requireNonNull(metricType, "Metric type is required");
        this.positionX = positionX != null ? positionX : 0;
        this.positionY = positionY != null ? positionY : 0;
        this.width = width != null ? width : 1;
        this.height = height != null ? height : 1;
        this.timeRange = timeRange != null ? timeRange : "1h";
    }

    public static DashboardWidget create(String title, WidgetType type, MetricType metricType) {
        return new DashboardWidget(null, title, type, metricType, 0, 0, 1, 1, "1h");
    }

    public static DashboardWidget create(String title, WidgetType type, MetricType metricType,
                                         Integer positionX, Integer positionY, Integer width, Integer height) {
        return new DashboardWidget(null, title, type, metricType, positionX, positionY, width, height, "1h");
    }

    public DashboardWidget withPosition(Integer x, Integer y) {
        return new DashboardWidget(this.id, this.title, this.type, this.metricType,
                                   x, y, this.width, this.height, this.timeRange);
    }

    public DashboardWidget withSize(Integer width, Integer height) {
        return new DashboardWidget(this.id, this.title, this.type, this.metricType,
                                   this.positionX, this.positionY, width, height, this.timeRange);
    }

    public DashboardWidget withTimeRange(String timeRange) {
        return new DashboardWidget(this.id, this.title, this.type, this.metricType,
                                   this.positionX, this.positionY, this.width, this.height, timeRange);
    }

    public enum WidgetType {
        LINE_CHART,
        BAR_CHART,
        GAUGE,
        SPARKLINE,
        COUNTER,
        TABLE,
        HEATMAP
    }
}
