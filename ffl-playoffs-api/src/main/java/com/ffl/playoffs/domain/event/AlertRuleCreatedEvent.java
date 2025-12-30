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
public class AlertRuleCreatedEvent {
    private UUID ruleId;
    private String name;
    private String condition;
    private AlertSeverity severity;
    private UUID createdBy;
    private LocalDateTime timestamp;
}
