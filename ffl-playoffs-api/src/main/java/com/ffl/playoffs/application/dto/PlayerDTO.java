package com.ffl.playoffs.application.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Data Transfer Object for Player.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PlayerDTO {
    private UUID id;
    private UUID gameId;
    private String name;
    private String email;
    private String status;
    private LocalDateTime joinedAt;
    private Integer totalScore;
    private boolean isEliminated;
    private List<TeamSelectionDTO> teamSelections;
}
