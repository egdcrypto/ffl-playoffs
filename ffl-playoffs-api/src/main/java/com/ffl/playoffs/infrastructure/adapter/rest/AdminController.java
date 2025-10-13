package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.service.ApplicationService;
import com.ffl.playoffs.domain.model.Score;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {
    private final ApplicationService applicationService;
    
    @PostMapping("/weeks/{weekId}/calculate-scores")
    public ResponseEntity<List<Score>> calculateScores(
            @PathVariable Long weekId,
            @RequestParam int season) {
        List<Score> scores = applicationService.calculateScores(weekId, season);
        return ResponseEntity.ok(scores);
    }
}
