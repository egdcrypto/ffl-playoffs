package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.usecase.CalculateScoresUseCase;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

/**
 * REST controller for admin operations.
 */
@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
public class AdminController {

    private final CalculateScoresUseCase calculateScoresUseCase;

    @PostMapping("/games/{gameId}/calculate-scores")
    public ResponseEntity<Void> calculateScores(
            @PathVariable UUID gameId,
            @RequestParam Integer weekNumber) {
        calculateScoresUseCase.execute(gameId, weekNumber);
        return ResponseEntity.ok().build();
    }
}
