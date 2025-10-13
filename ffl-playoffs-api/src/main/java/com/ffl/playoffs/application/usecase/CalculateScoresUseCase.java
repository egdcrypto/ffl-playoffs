package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.Score;
import com.ffl.playoffs.domain.port.NflDataProvider;
import com.ffl.playoffs.domain.service.ScoringService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CalculateScoresUseCase {
    private final ScoringService scoringService;
    private final NflDataProvider nflDataProvider;
    
    public List<Score> execute(Long weekId, int season) {
        // Fetch player stats from NFL data provider
        Map<Long, Map<String, Object>> selectionStats = fetchSelectionStats(weekId, season);
        
        // Calculate scores
        List<Score> scores = scoringService.calculateWeekScores(weekId, selectionStats);
        
        // Rank scores
        scoringService.rankScores(scores);
        
        // Determine eliminations
        List<Long> eliminatedPlayerIds = scoringService.determineEliminatedPlayers(scores);
        
        // Mark eliminated players
        scores.forEach(score -> {
            if (eliminatedPlayerIds.contains(score.getPlayerId())) {
                score.markAsEliminated();
            }
        });
        
        // TODO: Save scores and publish elimination events
        
        return scores;
    }
    
    private Map<Long, Map<String, Object>> fetchSelectionStats(Long weekId, int season) {
        // TODO: Implement stats fetching
        return Map.of();
    }
}
