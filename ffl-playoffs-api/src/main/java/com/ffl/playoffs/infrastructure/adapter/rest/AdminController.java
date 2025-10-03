package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.service.ApplicationService;
import com.ffl.playoffs.domain.model.Score;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

/**
 * REST controller for admin operations.
 */
@RestController
@RequestMapping("/api/admin")
public class AdminController {
    
    private final ApplicationService applicationService;

    public AdminController(ApplicationService applicationService) {
        this.applicationService = applicationService;
    }

    @PostMapping("/games/{gameId}/calculate-scores")
    public ResponseEntity<Map<UUID, Score>> calculateScores(
            @PathVariable UUID gameId,
            @RequestBody CalculateScoresRequest request) {
        Map<UUID, Score> scores = applicationService.calculateScores(
            gameId,
            request.getWeekNumber(),
            request.getNflWeek(),
            request.getSeason()
        );
        return ResponseEntity.ok(scores);
    }

    // Request DTOs
    public static class CalculateScoresRequest {
        private Integer weekNumber;
        private Integer nflWeek;
        private Integer season;

        public Integer getWeekNumber() { return weekNumber; }
        public void setWeekNumber(Integer weekNumber) { this.weekNumber = weekNumber; }

        public Integer getNflWeek() { return nflWeek; }
        public void setNflWeek(Integer nflWeek) { this.nflWeek = nflWeek; }

        public Integer getSeason() { return season; }
        public void setSeason(Integer season) { this.season = season; }
    }
}
