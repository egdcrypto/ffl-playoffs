package com.ffl.playoffs.infrastructure.persistence.mongodb.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;
import java.util.List;

/**
 * MongoDB document for PerformanceDashboard aggregate.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "performance_dashboards")
@CompoundIndex(name = "owner_default_idx", def = "{'ownerId': 1, 'isDefault': 1}")
public class PerformanceDashboardDocument {
    @Id
    private String id;

    private String name;
    private String description;

    @Indexed
    private String ownerId;

    private boolean isDefault;

    @Indexed
    private boolean isShared;

    private String defaultTimeRange;

    private List<WidgetSubDocument> widgets;

    private Instant createdAt;
    private Instant updatedAt;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class WidgetSubDocument {
        private String id;
        private String title;
        private String type;
        private String metricType;
        private Integer positionX;
        private Integer positionY;
        private Integer width;
        private Integer height;
        private String timeRange;
    }
}
