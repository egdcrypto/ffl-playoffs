package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.aggregate.Week;
import com.ffl.playoffs.domain.model.WeekStatus;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.WeekRepository;

import java.util.Optional;
import java.util.UUID;

/**
 * Use case for manually advancing a league to the next week.
 * Validates that all games are complete and scores calculated before advancing.
 */
public class AdvanceWeekUseCase {

    private final LeagueRepository leagueRepository;
    private final WeekRepository weekRepository;

    public AdvanceWeekUseCase(LeagueRepository leagueRepository, WeekRepository weekRepository) {
        this.leagueRepository = leagueRepository;
        this.weekRepository = weekRepository;
    }

    /**
     * Advances a league to the next week.
     *
     * @param command The advance week command
     * @return The result containing updated league and weeks
     * @throws LeagueNotFoundException if league not found
     * @throws WeekNotCompleteException if current week has games in progress
     * @throws ScoresNotCalculatedException if scores are not calculated
     * @throws IllegalStateException if league is not active or already on final week
     */
    public AdvanceWeekResult execute(AdvanceWeekCommand command) {
        League league = leagueRepository.findById(command.getLeagueId())
                .orElseThrow(() -> new LeagueNotFoundException(command.getLeagueId()));

        if (!league.isActive()) {
            throw new IllegalStateException("Can only advance week for active leagues");
        }

        // Get current week
        Optional<Week> currentWeekOpt = weekRepository.findCurrentWeek(league.getId());
        if (currentWeekOpt.isEmpty()) {
            throw new IllegalStateException("No active week found for league");
        }

        Week currentWeek = currentWeekOpt.get();

        // Validate all games are completed
        if (currentWeek.getGamesInProgress() != null && currentWeek.getGamesInProgress() > 0) {
            throw new WeekNotCompleteException(
                    "Cannot advance: " + currentWeek.getGamesInProgress() + " games still in progress",
                    currentWeek.getGamesInProgress()
            );
        }

        if (!currentWeek.areAllGamesCompleted()) {
            throw new WeekNotCompleteException(
                    "Cannot advance: not all games have completed",
                    0
            );
        }

        // Check if scores are calculated (week should be COMPLETED status)
        if (currentWeek.getStatus() != WeekStatus.COMPLETED && currentWeek.getStatus() != WeekStatus.LOCKED) {
            throw new ScoresNotCalculatedException("Cannot advance: scores have not been calculated");
        }

        // Complete the current week if it's LOCKED
        if (currentWeek.getStatus() == WeekStatus.LOCKED) {
            currentWeek.complete();
            weekRepository.save(currentWeek);
        }

        // Check if this is the final week
        if (league.isOnFinalWeek()) {
            // Complete the league
            league.complete();
            leagueRepository.save(league);
            return new AdvanceWeekResult(league, currentWeek, null, true);
        }

        // Advance the league to next week
        league.advanceWeek();

        // Activate the next week
        Optional<Week> nextWeekOpt = weekRepository.findByLeagueIdAndGameWeekNumber(
                league.getId(),
                league.getCurrentGameWeek()
        );

        Week nextWeek = null;
        if (nextWeekOpt.isPresent()) {
            nextWeek = nextWeekOpt.get();
            if (nextWeek.getStatus() == WeekStatus.UPCOMING) {
                nextWeek.activate();
                weekRepository.save(nextWeek);
            }
        }

        leagueRepository.save(league);

        return new AdvanceWeekResult(league, currentWeek, nextWeek, false);
    }

    public static class AdvanceWeekCommand {
        private final UUID leagueId;

        public AdvanceWeekCommand(UUID leagueId) {
            this.leagueId = leagueId;
        }

        public UUID getLeagueId() {
            return leagueId;
        }
    }

    public static class AdvanceWeekResult {
        private final League league;
        private final Week previousWeek;
        private final Week currentWeek;
        private final boolean leagueCompleted;

        public AdvanceWeekResult(League league, Week previousWeek, Week currentWeek, boolean leagueCompleted) {
            this.league = league;
            this.previousWeek = previousWeek;
            this.currentWeek = currentWeek;
            this.leagueCompleted = leagueCompleted;
        }

        public League getLeague() {
            return league;
        }

        public Week getPreviousWeek() {
            return previousWeek;
        }

        public Week getCurrentWeek() {
            return currentWeek;
        }

        public boolean isLeagueCompleted() {
            return leagueCompleted;
        }
    }

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

    public static class WeekNotCompleteException extends RuntimeException {
        private final int gamesInProgress;

        public WeekNotCompleteException(String message, int gamesInProgress) {
            super(message);
            this.gamesInProgress = gamesInProgress;
        }

        public int getGamesInProgress() {
            return gamesInProgress;
        }

        public String getErrorCode() {
            return "WEEK_NOT_COMPLETE";
        }
    }

    public static class ScoresNotCalculatedException extends RuntimeException {
        public ScoresNotCalculatedException(String message) {
            super(message);
        }

        public String getErrorCode() {
            return "SCORES_NOT_CALCULATED";
        }
    }
}
