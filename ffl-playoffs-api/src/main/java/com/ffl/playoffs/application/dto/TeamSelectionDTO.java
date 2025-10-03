package com.ffl.playoffs.application.dto;

import com.ffl.playoffs.domain.model.TeamSelection;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TeamSelectionDTO {
    private Long id;
    private Long playerId;
    private Long weekId;
    private String nflTeam;
    private LocalDateTime selectedAt;
    private Double score;
    private String status;
    
    public static TeamSelectionDTO fromDomain(TeamSelection selection) {
        return TeamSelectionDTO.builder()
                .id(selection.getId())
                .playerId(selection.getPlayerId())
                .weekId(selection.getWeekId())
                .nflTeam(selection.getNflTeam())
                .selectedAt(selection.getSelectedAt())
                .score(selection.getScore())
                .status(selection.getStatus().name())
                .build();
    }
}
