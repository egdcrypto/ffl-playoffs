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
public class HumanEvaluationCompletedEvent {
    private UUID evaluationId;
    private UUID conversationId;
    private Map<String, Double> aggregatedScores;
    private int evaluatorCount;
    private double interRaterReliability;
    private LocalDateTime timestamp;
}
