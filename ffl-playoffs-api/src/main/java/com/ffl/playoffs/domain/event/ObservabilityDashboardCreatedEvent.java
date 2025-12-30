package com.ffl.playoffs.domain.event;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ObservabilityDashboardCreatedEvent {
    private UUID dashboardId;
    private String name;
    private int panelCount;
    private UUID createdBy;
    private LocalDateTime timestamp;
}
