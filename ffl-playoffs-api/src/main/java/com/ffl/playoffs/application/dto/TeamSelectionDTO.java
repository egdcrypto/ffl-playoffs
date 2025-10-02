package com.ffl.playoffs.application.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Data Transfer Object for TeamSelection.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TeamSelectionDTO {
    private UUID id;
    private UUID playerId;
    private Integer weekNumber;
    private String nflTeam;
    private LocalDateTime selectedAt;
    private Integer pointsEarned;
    private boolean isScored;
}
