package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.PlayerDTO;
import com.ffl.playoffs.application.usecase.InvitePlayerUseCase;
import com.ffl.playoffs.application.usecase.SelectTeamUseCase;
import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.model.TeamSelection;
import com.ffl.playoffs.domain.port.PlayerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * REST controller for player-related endpoints.
 */
@RestController
@RequestMapping("/api/players")
@RequiredArgsConstructor
public class PlayerController {

    private final InvitePlayerUseCase invitePlayerUseCase;
    private final SelectTeamUseCase selectTeamUseCase;
    private final PlayerRepository playerRepository;

    @PostMapping("/invite")
    public ResponseEntity<PlayerDTO> invitePlayer(@RequestBody InvitePlayerRequest request) {
        Player player = invitePlayerUseCase.execute(
                request.getGameId(),
                request.getPlayerName(),
                request.getEmail()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(mapToDTO(player));
    }

    @PostMapping("/{playerId}/select-team")
    public ResponseEntity<Void> selectTeam(
            @PathVariable UUID playerId,
            @RequestBody SelectTeamRequest request) {
        selectTeamUseCase.execute(playerId, request.getWeekNumber(), request.getNflTeam());
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{id}")
    public ResponseEntity<PlayerDTO> getPlayer(@PathVariable UUID id) {
        return playerRepository.findById(id)
                .map(player -> ResponseEntity.ok(mapToDTO(player)))
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/game/{gameId}")
    public ResponseEntity<List<PlayerDTO>> getPlayersByGame(@PathVariable UUID gameId) {
        List<PlayerDTO> players = playerRepository.findByGameId(gameId).stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(players);
    }

    private PlayerDTO mapToDTO(Player player) {
        return PlayerDTO.builder()
                .id(player.getId())
                .gameId(player.getGameId())
                .name(player.getName())
                .email(player.getEmail())
                .status(player.getStatus().name())
                .joinedAt(player.getJoinedAt())
                .totalScore(player.getTotalScore())
                .isEliminated(player.isEliminated())
                .build();
    }

    public static class InvitePlayerRequest {
        private UUID gameId;
        private String playerName;
        private String email;

        public UUID getGameId() { return gameId; }
        public void setGameId(UUID gameId) { this.gameId = gameId; }
        public String getPlayerName() { return playerName; }
        public void setPlayerName(String playerName) { this.playerName = playerName; }
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
    }

    public static class SelectTeamRequest {
        private Integer weekNumber;
        private String nflTeam;

        public Integer getWeekNumber() { return weekNumber; }
        public void setWeekNumber(Integer weekNumber) { this.weekNumber = weekNumber; }
        public String getNflTeam() { return nflTeam; }
        public void setNflTeam(String nflTeam) { this.nflTeam = nflTeam; }
    }
}
