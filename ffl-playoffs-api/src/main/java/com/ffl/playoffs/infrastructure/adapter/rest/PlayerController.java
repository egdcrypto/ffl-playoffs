package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.PlayerDTO;
import com.ffl.playoffs.application.dto.TeamSelectionDTO;
import com.ffl.playoffs.application.service.ApplicationService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

/**
 * REST controller for player operations.
 */
@RestController
@RequestMapping("/api/players")
public class PlayerController {
    
    private final ApplicationService applicationService;

    public PlayerController(ApplicationService applicationService) {
        this.applicationService = applicationService;
    }

    @PostMapping("/invite")
    public ResponseEntity<PlayerDTO> invitePlayer(@RequestBody InvitePlayerRequest request) {
        PlayerDTO player = applicationService.invitePlayer(
            request.getGameId(),
            request.getName(),
            request.getEmail()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(player);
    }

    @PostMapping("/{playerId}/selections")
    public ResponseEntity<TeamSelectionDTO> selectTeam(
            @PathVariable UUID playerId,
            @RequestBody SelectTeamRequest request) {
        TeamSelectionDTO selection = applicationService.selectTeam(
            playerId,
            request.getWeekId(),
            request.getTeamCode()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(selection);
    }

    @GetMapping("/{id}")
    public ResponseEntity<PlayerDTO> getPlayer(@PathVariable UUID id) {
        // This would call a use case to fetch the player
        return ResponseEntity.ok().build();
    }

    // Request DTOs
    public static class InvitePlayerRequest {
        private UUID gameId;
        private String name;
        private String email;

        public UUID getGameId() { return gameId; }
        public void setGameId(UUID gameId) { this.gameId = gameId; }

        public String getName() { return name; }
        public void setName(String name) { this.name = name; }

        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
    }

    public static class SelectTeamRequest {
        private UUID weekId;
        private String teamCode;

        public UUID getWeekId() { return weekId; }
        public void setWeekId(UUID weekId) { this.weekId = weekId; }

        public String getTeamCode() { return teamCode; }
        public void setTeamCode(String teamCode) { this.teamCode = teamCode; }
    }
}
