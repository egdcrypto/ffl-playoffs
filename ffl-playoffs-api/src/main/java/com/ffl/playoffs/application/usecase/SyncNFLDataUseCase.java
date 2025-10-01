package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.port.NflDataProvider;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Use case for synchronizing NFL data from external sources
 * Fetches and caches NFL schedules, team data, and game results
 */
public class SyncNFLDataUseCase {

    private final NflDataProvider nflDataProvider;

    public SyncNFLDataUseCase(NflDataProvider nflDataProvider) {
        this.nflDataProvider = nflDataProvider;
    }

    /**
     * Synchronize NFL data for current week
     */
    public SyncResult executeCurrentWeek() {
        Integer currentWeek = nflDataProvider.getCurrentWeek();
        Integer currentSeason = nflDataProvider.getCurrentSeason();

        return execute(new SyncNFLDataCommand(currentWeek, currentSeason));
    }

    /**
     * Synchronize NFL data for a specific week and season
     */
    public SyncResult execute(SyncNFLDataCommand command) {
        Integer week = command.getWeek();
        Integer season = command.getSeason();
        LocalDateTime syncStartTime = LocalDateTime.now();

        // Fetch playoff teams for the week
        List<String> playoffTeams = nflDataProvider.getPlayoffTeams(week, season);

        // Track sync statistics
        int teamsProcessed = 0;
        int teamsSynced = playoffTeams.size();

        for (String teamCode : playoffTeams) {
            try {
                // Sync would typically involve fetching and storing team stats
                // For now, we're just validating the data is accessible
                String teamName = nflDataProvider.getTeamName(teamCode);
                teamsProcessed++;
            } catch (Exception e) {
                // Log error but continue syncing other teams
                System.err.println("Error syncing team " + teamCode + ": " + e.getMessage());
            }
        }

        LocalDateTime syncEndTime = LocalDateTime.now();

        return new SyncResult(
            week,
            season,
            teamsSynced,
            teamsProcessed,
            syncStartTime,
            syncEndTime,
            teamsProcessed == teamsSynced
        );
    }

    // Command
    public static class SyncNFLDataCommand {
        private final Integer week;
        private final Integer season;

        public SyncNFLDataCommand(Integer week, Integer season) {
            this.week = week;
            this.season = season;
        }

        public Integer getWeek() {
            return week;
        }

        public Integer getSeason() {
            return season;
        }
    }

    // Result
    public static class SyncResult {
        private final Integer week;
        private final Integer season;
        private final int totalTeams;
        private final int teamsProcessed;
        private final LocalDateTime syncStartTime;
        private final LocalDateTime syncEndTime;
        private final boolean success;

        public SyncResult(Integer week, Integer season, int totalTeams, int teamsProcessed,
                         LocalDateTime syncStartTime, LocalDateTime syncEndTime, boolean success) {
            this.week = week;
            this.season = season;
            this.totalTeams = totalTeams;
            this.teamsProcessed = teamsProcessed;
            this.syncStartTime = syncStartTime;
            this.syncEndTime = syncEndTime;
            this.success = success;
        }

        public Integer getWeek() {
            return week;
        }

        public Integer getSeason() {
            return season;
        }

        public int getTotalTeams() {
            return totalTeams;
        }

        public int getTeamsProcessed() {
            return teamsProcessed;
        }

        public LocalDateTime getSyncStartTime() {
            return syncStartTime;
        }

        public LocalDateTime getSyncEndTime() {
            return syncEndTime;
        }

        public boolean isSuccess() {
            return success;
        }
    }
}
