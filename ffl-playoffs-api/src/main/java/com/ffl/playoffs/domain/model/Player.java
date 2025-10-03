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
public class Player {
    private Long id;
    private String email;
    private String displayName;
    private String googleId;
    private LocalDateTime joinedAt;
    private PlayerStatus status;
    
    public enum PlayerStatus {
        ACTIVE,
        ELIMINATED,
        WITHDRAWN
    }
    
    public boolean isActive() {
        return this.status == PlayerStatus.ACTIVE;
    }
    
    public void eliminate() {
        this.status = PlayerStatus.ELIMINATED;
    }
}
