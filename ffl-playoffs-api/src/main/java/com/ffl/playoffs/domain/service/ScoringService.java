package com.ffl.playoffs.domain.service;

import com.ffl.playoffs.domain.model.Score;
import com.ffl.playoffs.domain.model.TeamSelection;

import java.util.List;
import java.util.Map;

public interface ScoringService {
    /**
     * Calculate score for a specific team selection based on player stats
     */
    Double calculateTeamScore(TeamSelection selection, Map<String, Object> playerStats);
    
    /**
     * Calculate scores for all selections in a week
     */
    List<Score> calculateWeekScores(Long weekId, Map<Long, Map<String, Object>> selectionStats);
    
    /**
     * Determine which players should be eliminated based on scores
     */
    List<Long> determineEliminatedPlayers(List<Score> scores);
    
    /**
     * Rank players by score (1 = highest score)
     */
    void rankScores(List<Score> scores);
}
