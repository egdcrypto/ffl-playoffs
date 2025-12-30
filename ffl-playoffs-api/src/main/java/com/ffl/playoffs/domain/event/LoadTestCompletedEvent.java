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
public class LoadTestCompletedEvent {
    private UUID testId;
    private UUID characterId;
    private int concurrentConversations;
    private double avgLatencyMs;
    private double p50LatencyMs;
    private double p95LatencyMs;
    private double p99LatencyMs;
    private double errorRatePercent;
    private double qualityDegradation;
    private boolean passed;
    private LocalDateTime timestamp;
}
