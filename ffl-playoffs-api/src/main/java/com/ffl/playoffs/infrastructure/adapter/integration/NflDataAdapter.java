package com.ffl.playoffs.infrastructure.adapter.integration;

import com.ffl.playoffs.domain.port.NflDataProvider;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.util.*;

/**
 * Adapter for NFL data integration.
 * This is a mock implementation that will be replaced with actual API integration.
 */
@Component
public class NflDataAdapter implements NflDataProvider {
    
    private static final Set<String> VALID_TEAM_CODES = Set.of(
        "ARI", "ATL", "BAL", "BUF", "CAR", "CHI", "CIN", "CLE",
        "DAL", "DEN", "DET", "GB", "HOU", "IND", "JAX", "KC",
        "LAC", "LAR", "LV", "MIA", "MIN", "NE", "NO", "NYG",
        "NYJ", "PHI", "PIT", "SEA", "SF", "TB", "TEN", "WAS"
    );

    @Override
    public Map<String, Object> getTeamStats(String teamCode, int nflWeek, int season) {
        // Mock implementation - returns sample data
        Map<String, Object> stats = new HashMap<>();
        stats.put("teamCode", teamCode);
        stats.put("week", nflWeek);
        stats.put("season", season);
        
        // Mock stats
        stats.put("passingYards", 250.0);
        stats.put("passingTouchdowns", 2.0);
        stats.put("interceptions", 1.0);
        stats.put("rushingYards", 120.0);
        stats.put("rushingTouchdowns", 1.0);
        stats.put("receivingYards", 280.0);
        stats.put("receivingTouchdowns", 2.0);
        stats.put("receptions", 20.0);
        stats.put("fieldGoalsMade", 2.0);
        stats.put("extraPointsMade", 3.0);
        stats.put("sacks", 3.0);
        stats.put("fumblesRecovered", 1.0);
        stats.put("pointsAllowed", 21.0);
        
        return stats;
    }

    @Override
    public List<String> getTeamsPlayingInWeek(int nflWeek, int season) {
        // Mock implementation - returns all teams
        return new ArrayList<>(VALID_TEAM_CODES);
    }

    @Override
    public boolean isValidTeamCode(String teamCode) {
        return VALID_TEAM_CODES.contains(teamCode);
    }

    @Override
    public int getCurrentNflWeek(LocalDate date) {
        // Mock implementation - simple calculation
        // In real implementation, this would use actual NFL schedule
        LocalDate seasonStart = LocalDate.of(date.getYear(), 9, 1);
        long daysSinceStart = java.time.temporal.ChronoUnit.DAYS.between(seasonStart, date);
        return (int) (daysSinceStart / 7) + 1;
    }
}
