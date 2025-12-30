package com.ffl.playoffs.domain.event;

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
public class ABTestCreatedEvent {
    private UUID testId;
    private String name;
    private UUID characterId;
    private List<String> variantNames;
    private String successMetric;
    private int durationDays;
    private UUID createdBy;
    private LocalDateTime timestamp;
}
