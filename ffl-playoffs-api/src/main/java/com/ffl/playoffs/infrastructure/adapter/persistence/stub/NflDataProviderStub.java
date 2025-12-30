package com.ffl.playoffs.infrastructure.adapter.persistence.stub;

import com.ffl.playoffs.domain.port.NflDataProvider;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * Stub implementation of NflDataProvider for testing and development
 */
@Component
@Qualifier("sportsDataIoAdapter")
public class NflDataProviderStub implements NflDataProvider {

    @Override
    public List<String> getPlayoffTeams(int season) {
        return List.of("KC", "BUF", "BAL", "HOU", "CLE", "MIA", "PIT",
                       "SF", "DAL", "DET", "TB", "PHI", "LAR", "GB");
    }

    @Override
    public Map<String, Object> getTeamPlayerStats(String teamAbbreviation, int week, int season) {
        return Collections.emptyMap();
    }

    @Override
    public List<Map<String, Object>> getWeekSchedule(int week, int season) {
        return Collections.emptyList();
    }

    @Override
    public boolean isTeamPlaying(String teamAbbreviation, int week, int season) {
        return true;
    }

    @Override
    public Map<String, Object> getPlayerStats(Long playerId, int week) {
        return Collections.emptyMap();
    }
}
