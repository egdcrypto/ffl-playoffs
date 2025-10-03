package com.ffl.playoffs.domain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Score {
    private Long id;
    private Long playerId;
    private Long weekId;
    private Double totalScore;
    private Integer rank;
    private LocalDateTime calculatedAt;
    private boolean isEliminated;
    
    public void markAsEliminated() {
        this.isEliminated = true;
    }
}
