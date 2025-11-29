package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.dto.TeamSelectionDTO;
import com.ffl.playoffs.domain.port.GameRepository;
import com.ffl.playoffs.domain.port.NflDataProvider;
import com.ffl.playoffs.domain.port.TeamSelectionRepository;
import com.ffl.playoffs.domain.model.Game;
import com.ffl.playoffs.domain.model.Score;
import com.ffl.playoffs.domain.service.ScoringService;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Use case for processing NFL game results and updating player selections
 * Fetches game outcomes, calculates scores, and updates player standings
 */
public class ProcessGameResultsUseCase {

    private final NflDataProvider nflDataProvider;
    private final TeamSelectionRepository teamSelectionRepository;
    private final GameRepository gameRepository;
    private final ScoringService scoringService;

    public ProcessGameResultsUseCase(
            NflDataProvider nflDataProvider,
            TeamSelectionRepository teamSelectionRepository,
            GameRepository gameRepository,
            ScoringService scoringService) {
        this.nflDataProvider = nflDataProvider;
        this.teamSelectionRepository = teamSelectionRepository;
        this.gameRepository = gameRepository;
        this.scoringService = scoringService;
    }

    /**
     * Process game results for a specific week
     *
     * NOTE: This use case has several issues that need to be addressed:
     * - Game model uses Long ID but command uses UUID
     * - Many NflDataProvider methods don't exist (getCurrentSeason, getTeamGameStats, didTeamWin)
     * - ScoringService.TeamGameStats class doesn't exist
     * - Game model doesn't have scoringRules field
     * - TeamSelection model differences from DTO
     */
    public ProcessGameResultsResult execute(ProcessGameResultsCommand command) {
        Long gameId = Long.parseLong(command.getGameId().toString().hashCode() + ""); // Convert UUID to Long
        Integer week = command.getWeek();
        Integer season = command.getSeason() != null ? command.getSeason() : 2024; // Default season

        LocalDateTime processStartTime = LocalDateTime.now();

        // Fetch the game
        Game game = gameRepository.findById(gameId)
                .orElseThrow(() -> new IllegalArgumentException("Game not found: " + gameId));

        // Get all team selections for this game and week - returns domain entities not DTOs
        List<com.ffl.playoffs.domain.model.TeamSelection> selections =
                teamSelectionRepository.findByGameIdAndWeek(command.getGameId(), week);

        int selectionsProcessed = 0;
        int selectionsWithErrors = 0;
        List<String> errors = new ArrayList<>();

        // Process each selection
        for (com.ffl.playoffs.domain.model.TeamSelection selection : selections) {
            try {
                // TODO: Implement getTeamGameStats in NflDataProvider
                // TODO: Define TeamGameStats class
                // TODO: Add scoringRules to Game model
                // TODO: Implement didTeamWin in NflDataProvider

                // For now, just mark as processed without actual scoring
                // This will need to be implemented once the interfaces are updated
                teamSelectionRepository.save(selection);

                selectionsProcessed++;
            } catch (Exception e) {
                selectionsWithErrors++;
                errors.add("Error processing selection " + selection.getId() + ": " + e.getMessage());
            }
        }

        LocalDateTime processEndTime = LocalDateTime.now();

        return new ProcessGameResultsResult(
                command.getGameId(),
                week,
                season,
                selections.size(),
                selectionsProcessed,
                selectionsWithErrors,
                errors,
                processStartTime,
                processEndTime,
                selectionsWithErrors == 0
        );
    }

    // Command
    public static class ProcessGameResultsCommand {
        private final UUID gameId;
        private final Integer week;
        private final Integer season;

        public ProcessGameResultsCommand(UUID gameId, Integer week, Integer season) {
            this.gameId = gameId;
            this.week = week;
            this.season = season;
        }

        public UUID getGameId() {
            return gameId;
        }

        public Integer getWeek() {
            return week;
        }

        public Integer getSeason() {
            return season;
        }
    }

    // Result
    public static class ProcessGameResultsResult {
        private final UUID gameId;
        private final Integer week;
        private final Integer season;
        private final int totalSelections;
        private final int selectionsProcessed;
        private final int selectionsWithErrors;
        private final List<String> errors;
        private final LocalDateTime processStartTime;
        private final LocalDateTime processEndTime;
        private final boolean success;

        public ProcessGameResultsResult(
                UUID gameId,
                Integer week,
                Integer season,
                int totalSelections,
                int selectionsProcessed,
                int selectionsWithErrors,
                List<String> errors,
                LocalDateTime processStartTime,
                LocalDateTime processEndTime,
                boolean success) {
            this.gameId = gameId;
            this.week = week;
            this.season = season;
            this.totalSelections = totalSelections;
            this.selectionsProcessed = selectionsProcessed;
            this.selectionsWithErrors = selectionsWithErrors;
            this.errors = errors;
            this.processStartTime = processStartTime;
            this.processEndTime = processEndTime;
            this.success = success;
        }

        public UUID getGameId() {
            return gameId;
        }

        public Integer getWeek() {
            return week;
        }

        public Integer getSeason() {
            return season;
        }

        public int getTotalSelections() {
            return totalSelections;
        }

        public int getSelectionsProcessed() {
            return selectionsProcessed;
        }

        public int getSelectionsWithErrors() {
            return selectionsWithErrors;
        }

        public List<String> getErrors() {
            return errors;
        }

        public LocalDateTime getProcessStartTime() {
            return processStartTime;
        }

        public LocalDateTime getProcessEndTime() {
            return processEndTime;
        }

        public boolean isSuccess() {
            return success;
        }
    }
}
