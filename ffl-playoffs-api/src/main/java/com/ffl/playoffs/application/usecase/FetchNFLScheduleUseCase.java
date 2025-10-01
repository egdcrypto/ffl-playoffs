package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.port.NflDataProvider;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * Use case for fetching NFL schedule data
 * Retrieves playoff schedule information from external NFL data provider
 */
public class FetchNFLScheduleUseCase {

    private final NflDataProvider nflDataProvider;

    public FetchNFLScheduleUseCase(NflDataProvider nflDataProvider) {
        this.nflDataProvider = nflDataProvider;
    }

    /**
     * Fetch schedule for a specific week
     */
    public ScheduleResult execute(FetchScheduleCommand command) {
        Integer week = command.getWeek() != null ? command.getWeek() : nflDataProvider.getCurrentWeek();
        Integer season = command.getSeason() != null ? command.getSeason() : nflDataProvider.getCurrentSeason();

        List<String> playoffTeams = nflDataProvider.getPlayoffTeams(week, season);

        return new ScheduleResult(week, season, playoffTeams);
    }

    /**
     * Fetch current playoff teams for current week
     */
    public ScheduleResult executeCurrentWeek() {
        Integer currentWeek = nflDataProvider.getCurrentWeek();
        Integer currentSeason = nflDataProvider.getCurrentSeason();

        List<String> playoffTeams = nflDataProvider.getPlayoffTeams(currentWeek, currentSeason);

        return new ScheduleResult(currentWeek, currentSeason, playoffTeams);
    }

    // Command
    public static class FetchScheduleCommand {
        private final Integer week;
        private final Integer season;

        public FetchScheduleCommand(Integer week, Integer season) {
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
    public static class ScheduleResult {
        private final Integer week;
        private final Integer season;
        private final List<String> playoffTeams;

        public ScheduleResult(Integer week, Integer season, List<String> playoffTeams) {
            this.week = week;
            this.season = season;
            this.playoffTeams = playoffTeams;
        }

        public Integer getWeek() {
            return week;
        }

        public Integer getSeason() {
            return season;
        }

        public List<String> getPlayoffTeams() {
            return playoffTeams;
        }
    }
}
