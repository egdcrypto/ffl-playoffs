package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.PlayerDTO;
import com.ffl.playoffs.application.dto.TeamSelectionDTO;
import com.ffl.playoffs.application.usecase.InvitePlayerUseCase;
import com.ffl.playoffs.application.usecase.SelectTeamUseCase;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/v1/players")
@RequiredArgsConstructor
@Tag(name = "Player Management", description = "APIs for managing players and team selections")
public class PlayerController {

    private final InvitePlayerUseCase invitePlayerUseCase;
    private final SelectTeamUseCase selectTeamUseCase;

    @PostMapping("/invite")
    @Operation(summary = "Invite a player", description = "Sends an invitation to a player to join a game")
    public ResponseEntity<PlayerDTO> invitePlayer(@Valid @RequestBody PlayerDTO playerDTO) {
        PlayerDTO invitedPlayer = invitePlayerUseCase.execute(playerDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(invitedPlayer);
    }

    @PostMapping("/{playerId}/teams")
    @Operation(summary = "Select a team", description = "Allows a player to select a team for a specific week")
    public ResponseEntity<TeamSelectionDTO> selectTeam(
            @PathVariable String playerId,
            @Valid @RequestBody TeamSelectionDTO teamSelectionDTO) {
        TeamSelectionDTO selection = selectTeamUseCase.execute(teamSelectionDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(selection);
    }

    @GetMapping("/{playerId}")
    @Operation(summary = "Get player details", description = "Retrieves details of a specific player")
    public ResponseEntity<PlayerDTO> getPlayer(@PathVariable String playerId) {
        // TODO: Implement getPlayer use case
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{playerId}/teams")
    @Operation(summary = "Get player's team selections", description = "Retrieves all team selections for a player")
    public ResponseEntity<?> getPlayerTeamSelections(@PathVariable String playerId) {
        // TODO: Implement getPlayerTeamSelections use case
        return ResponseEntity.ok().build();
    }
}
