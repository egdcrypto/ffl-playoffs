package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.TeamSelectionDTO;
import com.ffl.playoffs.application.service.ApplicationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/players")
@RequiredArgsConstructor
public class PlayerController {
    private final ApplicationService applicationService;
    
    @PostMapping("/{playerId}/selections")
    public ResponseEntity<TeamSelectionDTO> selectTeam(
            @PathVariable Long playerId,
            @RequestBody SelectTeamRequest request) {
        TeamSelectionDTO selection = applicationService.selectTeam(
                playerId,
                request.getWeekId(),
                request.getNflTeam()
        );
        return ResponseEntity.ok(selection);
    }
}

class SelectTeamRequest {
    private Long weekId;
    private String nflTeam;
    
    public Long getWeekId() { return weekId; }
    public void setWeekId(Long weekId) { this.weekId = weekId; }
    public String getNflTeam() { return nflTeam; }
    public void setNflTeam(String nflTeam) { this.nflTeam = nflTeam; }
}
