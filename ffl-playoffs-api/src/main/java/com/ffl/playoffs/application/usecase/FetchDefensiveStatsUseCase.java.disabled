package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.port.NflDataProvider;
import com.ffl.playoffs.domain.service.ScoringService.TeamGameStats;

/**
 * Use case for fetching NFL defensive statistics
 * Retrieves defensive performance data for teams from external NFL data provider
 */
public class FetchDefensiveStatsUseCase {

    private final NflDataProvider nflDataProvider;

    public FetchDefensiveStatsUseCase(NflDataProvider nflDataProvider) {
        this.nflDataProvider = nflDataProvider;
    }

    /**
     * Fetch defensive stats for a specific team and week
     */
    public DefensiveStatsResult execute(FetchDefensiveStatsCommand command) {
        String teamCode = command.getTeamCode();
        Integer week = command.getWeek() != null ? command.getWeek() : nflDataProvider.getCurrentWeek();
        Integer season = command.getSeason() != null ? command.getSeason() : nflDataProvider.getCurrentSeason();

        TeamGameStats stats = nflDataProvider.getTeamGameStats(teamCode, week, season);
        String teamName = nflDataProvider.getTeamName(teamCode);

        // Extract defensive-specific stats
        DefensiveStats defensiveStats = new DefensiveStats(
                stats.getSacks(),
                stats.getInterceptions(),
                stats.getFumbleRecoveries(),
                stats.getSafeties(),
                stats.getDefensiveTouchdowns(),
                stats.getPointsAllowed()
        );

        return new DefensiveStatsResult(teamCode, teamName, week, season, defensiveStats);
    }

    // Command
    public static class FetchDefensiveStatsCommand {
        private final String teamCode;
        private final Integer week;
        private final Integer season;

        public FetchDefensiveStatsCommand(String teamCode, Integer week, Integer season) {
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

    // Defensive Stats Value Object
    public static class DefensiveStats {
        private final int sacks;
        private final int interceptions;
        private final int fumbleRecoveries;
        private final int safeties;
        private final int defensiveTouchdowns;
        private final int pointsAllowed;

        public DefensiveStats(int sacks, int interceptions, int fumbleRecoveries,
                            int safeties, int defensiveTouchdowns, int pointsAllowed) {
            this.sacks = sacks;
            this.interceptions = interceptions;
            this.fumbleRecoveries = fumbleRecoveries;
            this.safeties = safeties;
            this.defensiveTouchdowns = defensiveTouchdowns;
            this.pointsAllowed = pointsAllowed;
        }

        public int getSacks() {
            return sacks;
        }

        public int getInterceptions() {
            return interceptions;
        }

        public int getFumbleRecoveries() {
            return fumbleRecoveries;
        }

        public int getSafeties() {
            return safeties;
        }

        public int getDefensiveTouchdowns() {
            return defensiveTouchdowns;
        }

        public int getPointsAllowed() {
            return pointsAllowed;
        }
    }

    // Result
    public static class DefensiveStatsResult {
        private final String teamCode;
        private final String teamName;
        private final Integer week;
        private final Integer season;
        private final DefensiveStats defensiveStats;

        public DefensiveStatsResult(String teamCode, String teamName, Integer week, Integer season,
                                   DefensiveStats defensiveStats) {
            this.teamCode = teamCode;
            this.teamName = teamName;
            this.week = week;
            this.season = season;
            this.defensiveStats = defensiveStats;
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

        public DefensiveStats getDefensiveStats() {
            return defensiveStats;
        }
    }
}
