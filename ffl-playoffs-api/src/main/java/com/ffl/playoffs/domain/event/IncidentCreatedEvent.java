package com.ffl.playoffs.domain.event;

import com.ffl.playoffs.domain.model.IncidentSeverity;
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
public class IncidentCreatedEvent {
    private UUID incidentId;
    private String incidentNumber;
    private String title;
    private IncidentSeverity severity;
    private UUID triggeredByAlertId;
    private LocalDateTime timestamp;
}
