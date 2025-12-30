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
public class TestSuiteExecutedEvent {
    private UUID suiteId;
    private UUID runId;
    private String suiteName;
    private int passedCount;
    private int failedCount;
    private int skippedCount;
    private double passRate;
    private long executionTimeMs;
    private UUID executedBy;
    private LocalDateTime timestamp;
}
