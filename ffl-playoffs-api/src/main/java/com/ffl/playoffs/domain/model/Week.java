package com.ffl.playoffs.domain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Week {
    private Long id;
    private Long gameId;
    private Integer weekNumber;
    private LocalDateTime startTime;
    private LocalDateTime lockTime;
    private LocalDateTime endTime;
    private WeekStatus status;
    
    @Builder.Default
    private Set<TeamSelection> selections = new HashSet<>();
    
    public enum WeekStatus {
        UPCOMING,
        OPEN,
        LOCKED,
        COMPLETED
    }
    
    public boolean isOpen() {
        return this.status == WeekStatus.OPEN;
    }
    
    public boolean canAcceptSelections() {
        return this.status == WeekStatus.OPEN && 
               LocalDateTime.now().isBefore(this.lockTime);
    }
    
    public void lock() {
        this.status = WeekStatus.LOCKED;
    }
    
    public void complete() {
        this.status = WeekStatus.COMPLETED;
    }
}
