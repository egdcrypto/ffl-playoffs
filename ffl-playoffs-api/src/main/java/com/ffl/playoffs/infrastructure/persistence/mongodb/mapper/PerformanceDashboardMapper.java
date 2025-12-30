package com.ffl.playoffs.infrastructure.persistence.mongodb.mapper;

import com.ffl.playoffs.domain.aggregate.PerformanceDashboard;
import com.ffl.playoffs.domain.model.performance.DashboardWidget;
import com.ffl.playoffs.domain.model.performance.MetricType;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.PerformanceDashboardDocument;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Mapper between PerformanceDashboard domain aggregate and MongoDB document.
 */
@Component
public class PerformanceDashboardMapper {

    public PerformanceDashboardDocument toDocument(PerformanceDashboard dashboard) {
        if (dashboard == null) return null;

        return PerformanceDashboardDocument.builder()
                .id(dashboard.getId() != null ? dashboard.getId().toString() : null)
                .name(dashboard.getName())
                .description(dashboard.getDescription())
                .ownerId(dashboard.getOwnerId() != null ? dashboard.getOwnerId().toString() : null)
                .isDefault(dashboard.isDefault())
                .isShared(dashboard.isShared())
                .defaultTimeRange(dashboard.getDefaultTimeRange())
                .widgets(toWidgetSubDocuments(dashboard.getWidgets()))
                .createdAt(dashboard.getCreatedAt())
                .updatedAt(dashboard.getUpdatedAt())
                .build();
    }

    public PerformanceDashboard toDomain(PerformanceDashboardDocument doc) {
        if (doc == null) return null;

        return PerformanceDashboard.builder()
                .id(doc.getId() != null ? UUID.fromString(doc.getId()) : null)
                .name(doc.getName())
                .description(doc.getDescription())
                .ownerId(doc.getOwnerId() != null ? UUID.fromString(doc.getOwnerId()) : null)
                .isDefault(doc.isDefault())
                .isShared(doc.isShared())
                .defaultTimeRange(doc.getDefaultTimeRange())
                .widgets(toWidgets(doc.getWidgets()))
                .createdAt(doc.getCreatedAt())
                .updatedAt(doc.getUpdatedAt())
                .build();
    }

    private List<PerformanceDashboardDocument.WidgetSubDocument> toWidgetSubDocuments(List<DashboardWidget> widgets) {
        if (widgets == null) return null;

        return widgets.stream()
                .map(widget -> PerformanceDashboardDocument.WidgetSubDocument.builder()
                        .id(widget.getId() != null ? widget.getId().toString() : null)
                        .title(widget.getTitle())
                        .type(widget.getType().name())
                        .metricType(widget.getMetricType().getCode())
                        .positionX(widget.getPositionX())
                        .positionY(widget.getPositionY())
                        .width(widget.getWidth())
                        .height(widget.getHeight())
                        .timeRange(widget.getTimeRange())
                        .build())
                .collect(Collectors.toList());
    }

    private List<DashboardWidget> toWidgets(List<PerformanceDashboardDocument.WidgetSubDocument> docs) {
        if (docs == null) return new ArrayList<>();

        return docs.stream()
                .map(doc -> {
                    DashboardWidget widget = DashboardWidget.create(
                            doc.getTitle(),
                            DashboardWidget.WidgetType.valueOf(doc.getType()),
                            MetricType.fromCode(doc.getMetricType()),
                            doc.getPositionX(),
                            doc.getPositionY(),
                            doc.getWidth(),
                            doc.getHeight()
                    );
                    if (doc.getTimeRange() != null) {
                        widget = widget.withTimeRange(doc.getTimeRange());
                    }
                    return widget;
                })
                .collect(Collectors.toList());
    }
}
