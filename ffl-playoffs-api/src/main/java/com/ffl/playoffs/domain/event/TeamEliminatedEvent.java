package com.ffl.playoffs.domain.event;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TeamEliminatedEvent {
    private Long playerId;
    private Long gameId;
    private Long weekId;
    private String playerEmail;
    private String playerName;
    private Integer rank;
    private Double finalScore;
    private LocalDateTime eliminatedAt;
}
