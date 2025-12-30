package com.ffl.playoffs.domain.event;

import com.ffl.playoffs.domain.model.AlertSeverity;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LogAlertCreatedEvent {
    private UUID alertId;
    private String name;
    private String query;
    private int threshold;
    private int windowMinutes;
    private AlertSeverity severity;
    private List<String> channels;
    private UUID createdBy;
    private LocalDateTime timestamp;
}
