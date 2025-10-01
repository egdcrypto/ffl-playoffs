package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.port.NflDataProvider;
import com.ffl.playoffs.domain.service.ScoringService.TeamGameStats;

/**
 * Use case for fetching NFL player statistics
 * Retrieves player performance data from external NFL data provider
 */
public class FetchPlayerStatsUseCase {

    private final NflDataProvider nflDataProvider;

    public FetchPlayerStatsUseCase(NflDataProvider nflDataProvider) {
        this.nflDataProvider = nflDataProvider;
    }

    /**
     * Fetch player stats for a specific team and week
     */
    public PlayerStatsResult execute(FetchPlayerStatsCommand command) {
        String teamCode = command.getTeamCode();
        Integer week = command.getWeek() != null ? command.getWeek() : nflDataProvider.getCurrentWeek();
        Integer season = command.getSeason() != null ? command.getSeason() : nflDataProvider.getCurrentSeason();

        TeamGameStats stats = nflDataProvider.getTeamGameStats(teamCode, week, season);
        String teamName = nflDataProvider.getTeamName(teamCode);
        boolean didWin = nflDataProvider.didTeamWin(teamCode, week, season);

        return new PlayerStatsResult(teamCode, teamName, week, season, stats, didWin);
    }

    // Command
    public static class FetchPlayerStatsCommand {
        private final String teamCode;
        private final Integer week;
        private final Integer season;

        public FetchPlayerStatsCommand(String teamCode, Integer week, Integer season) {
            this.teamCode = teamCode;
            this.week = week;
            this.season = season;
        }

        public String getTeamCode() {
            return teamCode;
        }

        public Integer getWeek() {
            return week;
        }

        public Integer getSeason() {
            return season;
        }
    }

    // Result
    public static class PlayerStatsResult {
        private final String teamCode;
        private final String teamName;
        private final Integer week;
        private final Integer season;
        private final TeamGameStats stats;
        private final boolean didWin;

        public PlayerStatsResult(String teamCode, String teamName, Integer week, Integer season,
                                TeamGameStats stats, boolean didWin) {
            this.teamCode = teamCode;
            this.teamName = teamName;
            this.week = week;
            this.season = season;
            this.stats = stats;
            this.didWin = didWin;
        }

        public String getTeamCode() {
            return teamCode;
        }

        public String getTeamName() {
            return teamName;
        }

        public Integer getWeek() {
            return week;
        }

        public Integer getSeason() {
            return season;
        }

        public TeamGameStats getStats() {
            return stats;
        }

        public boolean isDidWin() {
            return didWin;
        }
    }
}
