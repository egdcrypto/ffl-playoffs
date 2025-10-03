package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.GameDTO;
import com.ffl.playoffs.application.service.ApplicationService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * REST controller for game operations.
 */
@RestController
@RequestMapping("/api/games")
public class GameController {
    
    private final ApplicationService applicationService;

    public GameController(ApplicationService applicationService) {
        this.applicationService = applicationService;
    }

    @PostMapping
    public ResponseEntity<GameDTO> createGame(@RequestBody CreateGameRequest request) {
        GameDTO game = applicationService.createGame(
            request.getName(),
            request.getStartDate(),
            request.getEndDate(),
            request.getCreatorId()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(game);
    }

    @GetMapping("/{id}")
    public ResponseEntity<GameDTO> getGame(@PathVariable UUID id) {
        // This would call a use case to fetch the game
        return ResponseEntity.ok().build();
    }

    @PostMapping("/{id}/start")
    public ResponseEntity<Void> startGame(@PathVariable UUID id) {
        // This would call a use case to start the game
        return ResponseEntity.ok().build();
    }

    // Request DTOs
    public static class CreateGameRequest {
        private String name;
        private LocalDateTime startDate;
        private LocalDateTime endDate;
        private UUID creatorId;

        public String getName() { return name; }
        public void setName(String name) { this.name = name; }

        public LocalDateTime getStartDate() { return startDate; }
        public void setStartDate(LocalDateTime startDate) { this.startDate = startDate; }

        public LocalDateTime getEndDate() { return endDate; }
        public void setEndDate(LocalDateTime endDate) { this.endDate = endDate; }

        public UUID getCreatorId() { return creatorId; }
        public void setCreatorId(UUID creatorId) { this.creatorId = creatorId; }
    }
}
