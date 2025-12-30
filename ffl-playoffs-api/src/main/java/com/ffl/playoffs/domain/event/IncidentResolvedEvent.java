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
public class IncidentResolvedEvent {
    private UUID incidentId;
    private String incidentNumber;
    private String resolution;
    private long durationMinutes;
    private UUID resolvedBy;
    private LocalDateTime timestamp;
}
