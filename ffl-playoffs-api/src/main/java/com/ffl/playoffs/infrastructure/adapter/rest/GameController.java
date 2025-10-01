package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.GameDTO;
import com.ffl.playoffs.application.usecase.CreateGameUseCase;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/v1/games")
@RequiredArgsConstructor
@Tag(name = "Game Management", description = "APIs for managing playoff games")
public class GameController {

    private final CreateGameUseCase createGameUseCase;

    @PostMapping
    @Operation(summary = "Create a new game", description = "Creates a new playoff game with specified configuration")
    public ResponseEntity<GameDTO> createGame(@Valid @RequestBody GameDTO gameDTO) {
        GameDTO createdGame = createGameUseCase.execute(gameDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdGame);
    }

    @GetMapping("/{gameId}")
    @Operation(summary = "Get game details", description = "Retrieves details of a specific game")
    public ResponseEntity<GameDTO> getGame(@PathVariable String gameId) {
        // TODO: Implement getGame use case
        return ResponseEntity.ok().build();
    }

    @GetMapping
    @Operation(summary = "List all games", description = "Retrieves a list of all games")
    public ResponseEntity<?> listGames() {
        // TODO: Implement listGames use case
        return ResponseEntity.ok().build();
    }
}
