package com.ffl.playoffs.domain.event;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ABTestConcludedEvent {
    private UUID testId;
    private String name;
    private String winner;
    private double statisticalSignificance;
    private Map<String, Double> variantMetrics;
    private int totalSamples;
    private LocalDateTime timestamp;
}
