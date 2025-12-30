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
public class HumanEvaluationRequestedEvent {
    private UUID evaluationId;
    private UUID conversationId;
    private List<String> evaluatorEmails;
    private List<String> criteria;
    private UUID requestedBy;
    private LocalDateTime timestamp;
}
