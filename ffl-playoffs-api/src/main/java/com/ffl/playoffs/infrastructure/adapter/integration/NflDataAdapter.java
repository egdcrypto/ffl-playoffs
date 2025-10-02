package com.ffl.playoffs.infrastructure.adapter.integration;

import com.ffl.playoffs.domain.model.Score;
import com.ffl.playoffs.domain.port.NflDataProvider;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.List;
import java.util.UUID;

/**
 * Adapter for NFL data integration.
 * This is a stub implementation that should be replaced with actual NFL API integration.
 */
@Component
public class NflDataAdapter implements NflDataProvider {

    @Override
    public Score getTeamScore(String nflTeam, Integer weekNumber) {
        // Stub implementation - replace with actual NFL API call
        return Score.builder()
                .id(UUID.randomUUID())
                .nflTeam(nflTeam)
                .weekNumber(weekNumber)
                .points(0)
                .breakdown(Score.ScoreBreakdown.builder()
                        .touchdowns(0)
                        .fieldGoals(0)
                        .safeties(0)
                        .extraPoints(0)
                        .twoPointConversions(0)
                        .build())
                .build();
    }

    @Override
    public List<String> getPlayoffTeams(Integer year) {
        // Stub implementation - replace with actual NFL API call
        return Arrays.asList(
                "KC", "BUF", "BAL", "HOU", "DET", "TB", "PHI",
                "LAR", "GB", "MIN", "PIT", "DAL", "LAC", "MIA"
        );
    }

    @Override
    public List<String> getAvailableTeamsForWeek(Integer weekNumber) {
        // Stub implementation - replace with actual logic
        return getPlayoffTeams(2024);
    }

    @Override
    public boolean isTeamInPlayoffs(String nflTeam, Integer year) {
        // Stub implementation - replace with actual NFL API call
        return getPlayoffTeams(year).contains(nflTeam);
    }
}
