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
public class TeamSelection {
    private Long id;
    private Long playerId;
    private Long weekId;
    private String nflTeam;
    private LocalDateTime selectedAt;
    private Double score;
    private SelectionStatus status;
    
    public enum SelectionStatus {
        PENDING,
        LOCKED,
        SCORED
    }
    
    public boolean isPending() {
        return this.status == SelectionStatus.PENDING;
    }
    
    public void lock() {
        this.status = SelectionStatus.LOCKED;
    }
    
    public void setScore(Double score) {
        this.score = score;
        this.status = SelectionStatus.SCORED;
    }
}
