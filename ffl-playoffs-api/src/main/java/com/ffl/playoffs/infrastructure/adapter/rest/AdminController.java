package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.usecase.CalculateScoresUseCase;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/admin")
@RequiredArgsConstructor
@Tag(name = "Admin", description = "Administrative APIs for game management")
public class AdminController {

    private final CalculateScoresUseCase calculateScoresUseCase;

    @PostMapping("/games/{gameId}/calculate-scores")
    @Operation(summary = "Calculate scores", description = "Triggers score calculation for a specific game week")
    public ResponseEntity<Void> calculateScores(
            @PathVariable String gameId,
            @RequestParam Integer week) {
        calculateScoresUseCase.execute(gameId, week);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/games/{gameId}/advance-week")
    @Operation(summary = "Advance to next week", description = "Advances the game to the next week")
    public ResponseEntity<Void> advanceWeek(@PathVariable String gameId) {
        // TODO: Implement advanceWeek use case
        return ResponseEntity.ok().build();
    }

    @GetMapping("/games/{gameId}/status")
    @Operation(summary = "Get game status", description = "Retrieves current status and statistics of a game")
    public ResponseEntity<?> getGameStatus(@PathVariable String gameId) {
        // TODO: Implement getGameStatus use case
        return ResponseEntity.ok().build();
    }
}
