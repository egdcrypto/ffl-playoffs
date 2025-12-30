package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.aggregate.Week;
import com.ffl.playoffs.domain.model.WeekStatus;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.WeekRepository;

import java.time.DayOfWeek;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Use case for activating a league to start the game.
 * Creates week entities and transitions league to ACTIVE status.
 */
public class ActivateLeagueUseCase {

    private final LeagueRepository leagueRepository;
    private final WeekRepository weekRepository;

    public ActivateLeagueUseCase(LeagueRepository leagueRepository, WeekRepository weekRepository) {
        this.leagueRepository = leagueRepository;
        this.weekRepository = weekRepository;
    }

    /**
     * Activates a league.
     *
     * @param command The activation command
     * @return The result containing the activated league and created weeks
     * @throws LeagueNotFoundException if league not found
     * @throws League.InsufficientPlayersException if not enough players
     * @throws League.IncompleteConfigurationException if configuration is incomplete
     */
    public ActivateLeagueResult execute(ActivateLeagueCommand command) {
        // Find the league
        League league = leagueRepository.findById(command.getLeagueId())
                .orElseThrow(() -> new LeagueNotFoundException(command.getLeagueId()));

        // Activate the league (validates minimum players and configuration)
        league.activate();

        // Create week entities for the league
        List<Week> weeks = createWeeksForLeague(league);

        // Save weeks (first week is already set to ACTIVE in createWeeksForLeague)
        List<Week> savedWeeks = weekRepository.saveAll(weeks);

        // Save the league
        League savedLeague = leagueRepository.save(league);

        return new ActivateLeagueResult(savedLeague, savedWeeks);
    }

    /**
     * Creates Week entities for all weeks in the league's duration.
     */
    private List<Week> createWeeksForLeague(League league) {
        List<Week> weeks = new ArrayList<>();

        for (int gameWeek = 1; gameWeek <= league.getNumberOfWeeks(); gameWeek++) {
            int nflWeek = league.getStartingWeek() + gameWeek - 1;

            Week week = new Week(
                    league.getId(),
                    gameWeek,
                    nflWeek,
                    calculateDefaultDeadline(nflWeek)
            );

            // First week starts as ACTIVE, others as UPCOMING
            if (gameWeek == 1) {
                week.setStatus(WeekStatus.ACTIVE);
            }

            weeks.add(week);
        }

        return weeks;
    }

    /**
     * Calculates the default pick deadline for an NFL week.
     * Default is Sunday 1PM ET of that NFL week.
     */
    private LocalDateTime calculateDefaultDeadline(int nflWeek) {
        // For simplicity, calculate based on NFL season start
        // In a real implementation, this would look up the actual NFL schedule
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime nextSunday = now.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY));
        return nextSunday.with(LocalTime.of(13, 0)); // 1 PM
    }

    /**
     * Command for activating a league.
     */
    public static class ActivateLeagueCommand {
        private final UUID leagueId;

        public ActivateLeagueCommand(UUID leagueId) {
            this.leagueId = leagueId;
        }

        public UUID getLeagueId() {
            return leagueId;
        }
    }

    /**
     * Result of activating a league.
     */
    public static class ActivateLeagueResult {
        private final League league;
        private final List<Week> weeks;

        public ActivateLeagueResult(League league, List<Week> weeks) {
            this.league = league;
            this.weeks = weeks;
        }

        public League getLeague() {
            return league;
        }

        public List<Week> getWeeks() {
            return weeks;
        }
    }

    /**
     * Exception thrown when league is not found.
     */
    public static class LeagueNotFoundException extends RuntimeException {
        private final UUID leagueId;

        public LeagueNotFoundException(UUID leagueId) {
            super("League not found: " + leagueId);
            this.leagueId = leagueId;
        }

        public UUID getLeagueId() {
            return leagueId;
        }
    }
}
