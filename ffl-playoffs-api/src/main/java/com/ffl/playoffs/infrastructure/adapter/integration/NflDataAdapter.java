package com.ffl.playoffs.infrastructure.adapter.integration;

import com.ffl.playoffs.domain.port.NflDataProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class NflDataAdapter implements NflDataProvider {

    // TODO: Inject HTTP client or external API client
    // private final RestTemplate restTemplate;
    // private final WebClient webClient;

    @Override
    public List<String> getPlayoffTeams(int season, int week) {
        // TODO: Call external NFL API to get playoff teams for a given season and week
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public Map<String, Integer> getTeamScore(String teamCode, int season, int week) {
        // TODO: Call external NFL API to get team score details
        // Returns map with scoring breakdown (touchdowns, fieldGoals, etc.)
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public boolean isTeamEliminated(String teamCode, int season, int week) {
        // TODO: Determine if a team has been eliminated from playoffs
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public List<Map<String, Object>> getWeekSchedule(int season, int week) {
        // TODO: Get schedule for a specific week
        throw new UnsupportedOperationException("Not yet implemented");
    }
}
