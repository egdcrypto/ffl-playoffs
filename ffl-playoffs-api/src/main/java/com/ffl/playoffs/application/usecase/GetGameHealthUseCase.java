package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.aggregate.Week;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.TeamSelectionRepository;
import com.ffl.playoffs.domain.port.WeekRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Use case for getting the health status of a league/game.
 * Provides statistics about players, selections, and data integration.
 */
public class GetGameHealthUseCase {

    private final LeagueRepository leagueRepository;
    private final WeekRepository weekRepository;
    private final TeamSelectionRepository teamSelectionRepository;

    public GetGameHealthUseCase(
            LeagueRepository leagueRepository,
            WeekRepository weekRepository,
            TeamSelectionRepository teamSelectionRepository) {
        this.leagueRepository = leagueRepository;
        this.weekRepository = weekRepository;
        this.teamSelectionRepository = teamSelectionRepository;
    }

    /**
     * Gets the game health status for a league.
     *
     * @param command The get health command
     * @return The game health status
     * @throws LeagueNotFoundException if league not found
     */
    public GameHealthStatus execute(GetGameHealthCommand command) {
        League league = leagueRepository.findById(command.getLeagueId())
                .orElseThrow(() -> new LeagueNotFoundException(command.getLeagueId()));

        // Get weeks for the league
        List<Week> weeks = weekRepository.findByLeagueId(league.getId());

        // Get current week
        Week currentWeek = weekRepository.findCurrentWeek(league.getId()).orElse(null);

        // Calculate statistics
        int totalPlayers = league.getPlayers() != null ? league.getPlayers().size() : 0;
        int weeksCompleted = (int) weeks.stream().filter(Week::isCompleted).count();
        int weeksRemaining = league.getNumberOfWeeks() - weeksCompleted;

        // Get selection counts for current week
        int activeSelections = 0;
        int missedSelections = 0;

        if (currentWeek != null) {
            long selectionCount = teamSelectionRepository.countByWeekId(currentWeek.getId());
            activeSelections = (int) selectionCount;
            missedSelections = totalPlayers - activeSelections;
        }

        // Build the result
        return new GameHealthStatus(
                league.getId(),
                league.getName(),
                league.getStatus().name(),
                totalPlayers,
                activeSelections,
                missedSelections,
                currentWeek != null ? currentWeek.getGameWeekNumber() : null,
                weeksRemaining,
                DataIntegrationStatus.HEALTHY, // Placeholder - would check actual data sync status
                LocalDateTime.now() // Placeholder for last score calculation time
        );
    }

    public static class GetGameHealthCommand {
        private final UUID leagueId;

        public GetGameHealthCommand(UUID leagueId) {
            this.leagueId = leagueId;
        }

        public UUID getLeagueId() {
            return leagueId;
        }
    }

    public static class GameHealthStatus {
        private final UUID leagueId;
        private final String leagueName;
        private final String status;
        private final int totalPlayers;
        private final int activeSelections;
        private final int missedSelections;
        private final Integer currentWeek;
        private final int weeksRemaining;
        private final DataIntegrationStatus dataIntegrationStatus;
        private final LocalDateTime lastScoreCalculation;

        public GameHealthStatus(
                UUID leagueId,
                String leagueName,
                String status,
                int totalPlayers,
                int activeSelections,
                int missedSelections,
                Integer currentWeek,
                int weeksRemaining,
                DataIntegrationStatus dataIntegrationStatus,
                LocalDateTime lastScoreCalculation) {
            this.leagueId = leagueId;
            this.leagueName = leagueName;
            this.status = status;
            this.totalPlayers = totalPlayers;
            this.activeSelections = activeSelections;
            this.missedSelections = missedSelections;
            this.currentWeek = currentWeek;
            this.weeksRemaining = weeksRemaining;
            this.dataIntegrationStatus = dataIntegrationStatus;
            this.lastScoreCalculation = lastScoreCalculation;
        }

        public UUID getLeagueId() {
            return leagueId;
        }

        public String getLeagueName() {
            return leagueName;
        }

        public String getStatus() {
            return status;
        }

        public int getTotalPlayers() {
            return totalPlayers;
        }

        public int getActiveSelections() {
            return activeSelections;
        }

        public int getMissedSelections() {
            return missedSelections;
        }

        public Integer getCurrentWeek() {
            return currentWeek;
        }

        public int getWeeksRemaining() {
            return weeksRemaining;
        }

        public DataIntegrationStatus getDataIntegrationStatus() {
            return dataIntegrationStatus;
        }

        public LocalDateTime getLastScoreCalculation() {
            return lastScoreCalculation;
        }

        public String getActiveSelectionsDisplay() {
            return activeSelections + " of " + totalPlayers;
        }
    }

    public enum DataIntegrationStatus {
        HEALTHY,
        DEGRADED,
        UNHEALTHY
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
}
