package com.ffl.playoffs.domain.event;

import com.ffl.playoffs.domain.model.AlertSeverity;
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
public class AlertTriggeredEvent {
    private UUID alertId;
    private UUID ruleId;
    private String ruleName;
    private AlertSeverity severity;
    private double currentValue;
    private double threshold;
    private LocalDateTime timestamp;
}
