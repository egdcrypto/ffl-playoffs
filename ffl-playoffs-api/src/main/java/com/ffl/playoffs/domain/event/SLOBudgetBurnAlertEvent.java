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
public class SLOBudgetBurnAlertEvent {
    private UUID sloId;
    private String sloName;
    private double burnRate;
    private double remainingBudgetPercent;
    private double estimatedHoursUntilExhaustion;
    private LocalDateTime timestamp;
}
