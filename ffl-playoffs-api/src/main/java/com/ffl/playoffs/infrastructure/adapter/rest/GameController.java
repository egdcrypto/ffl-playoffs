package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.GameDTO;
import com.ffl.playoffs.application.usecase.CreateGameUseCase;
import com.ffl.playoffs.domain.model.Game;
import com.ffl.playoffs.domain.port.GameRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * REST controller for game-related endpoints.
 */
@RestController
@RequestMapping("/api/games")
@RequiredArgsConstructor
public class GameController {

    private final CreateGameUseCase createGameUseCase;
    private final GameRepository gameRepository;

    @PostMapping
    public ResponseEntity<GameDTO> createGame(@RequestBody CreateGameRequest request) {
        Game game = createGameUseCase.execute(request.getName(), request.getCreatorId());
        return ResponseEntity.status(HttpStatus.CREATED).body(mapToDTO(game));
    }

    @GetMapping("/{id}")
    public ResponseEntity<GameDTO> getGame(@PathVariable UUID id) {
        return gameRepository.findById(id)
                .map(game -> ResponseEntity.ok(mapToDTO(game)))
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping
    public ResponseEntity<List<GameDTO>> getAllGames() {
        List<GameDTO> games = gameRepository.findAll().stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(games);
    }

    private GameDTO mapToDTO(Game game) {
        return GameDTO.builder()
                .id(game.getId())
                .name(game.getName())
                .creatorId(game.getCreatorId())
                .createdAt(game.getCreatedAt())
                .status(game.getStatus().name())
                .currentWeek(game.getCurrentWeek())
                .build();
    }

    public static class CreateGameRequest {
        private String name;
        private UUID creatorId;

        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public UUID getCreatorId() { return creatorId; }
        public void setCreatorId(UUID creatorId) { this.creatorId = creatorId; }
    }
}
