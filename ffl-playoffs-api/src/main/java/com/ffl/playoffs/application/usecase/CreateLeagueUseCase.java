package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.model.RosterConfiguration;
import com.ffl.playoffs.domain.model.ScoringRules;
import com.ffl.playoffs.domain.port.LeagueRepository;

import java.util.UUID;

/**
 * Use case for creating a new fantasy football league
 * Application layer orchestrates domain logic
 */
public class CreateLeagueUseCase {

    private final LeagueRepository leagueRepository;

    public CreateLeagueUseCase(LeagueRepository leagueRepository) {
        this.leagueRepository = leagueRepository;
    }

    /**
     * Creates a new league with the provided configuration
     *
     * @param command The create league command containing all necessary data
     * @return The newly created League entity
     * @throws IllegalArgumentException if league code already exists
     * @throws IllegalArgumentException if week configuration is invalid
     */
    public League execute(CreateLeagueCommand command) {
        // Validate unique league code
        if (leagueRepository.existsByCode(command.getCode())) {
            throw new IllegalArgumentException("League code already exists: " + command.getCode());
        }

        // Create league entity with validation
        League league = new League(
            command.getName(),
            command.getCode(),
            command.getOwnerId(),
            command.getStartingWeek(),
            command.getNumberOfWeeks()
        );

        // Set optional fields
        if (command.getDescription() != null) {
            league.setDescription(command.getDescription());
        }

        // Set roster configuration
        if (command.getRosterConfiguration() != null) {
            league.setRosterConfiguration(command.getRosterConfiguration());
        } else {
            // Use standard roster configuration if not provided
            league.setRosterConfiguration(RosterConfiguration.standardRoster());
        }

        // Set scoring rules
        if (command.getScoringRules() != null) {
            league.setScoringRules(command.getScoringRules());
        } else {
            // Use default scoring rules if not provided
            league.setScoringRules(new ScoringRules());
        }

        // Set first game start time if provided
        if (command.getFirstGameStartTime() != null) {
            league.setFirstGameStartTime(command.getFirstGameStartTime());
        }

        // Set status to waiting for players
        league.setStatus(League.LeagueStatus.WAITING_FOR_PLAYERS);

        // Persist league
        return leagueRepository.save(league);
    }

    /**
     * Command object containing all data needed to create a league
     */
    public static class CreateLeagueCommand {
        private final String name;
        private final String code;
        private final UUID ownerId;
        private final Integer startingWeek;
        private final Integer numberOfWeeks;
        private String description;
        private RosterConfiguration rosterConfiguration;
        private ScoringRules scoringRules;
        private java.time.LocalDateTime firstGameStartTime;

        public CreateLeagueCommand(
                String name,
                String code,
                UUID ownerId,
                Integer startingWeek,
                Integer numberOfWeeks) {
            this.name = name;
            this.code = code;
            this.ownerId = ownerId;
            this.startingWeek = startingWeek;
            this.numberOfWeeks = numberOfWeeks;
        }

        // Getters
        public String getName() {
            return name;
        }

        public String getCode() {
            return code;
        }

        public UUID getOwnerId() {
            return ownerId;
        }

        public Integer getStartingWeek() {
            return startingWeek;
        }

        public Integer getNumberOfWeeks() {
            return numberOfWeeks;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public RosterConfiguration getRosterConfiguration() {
            return rosterConfiguration;
        }

        public void setRosterConfiguration(RosterConfiguration rosterConfiguration) {
            this.rosterConfiguration = rosterConfiguration;
        }

        public ScoringRules getScoringRules() {
            return scoringRules;
        }

        public void setScoringRules(ScoringRules scoringRules) {
            this.scoringRules = scoringRules;
        }

        public java.time.LocalDateTime getFirstGameStartTime() {
            return firstGameStartTime;
        }

        public void setFirstGameStartTime(java.time.LocalDateTime firstGameStartTime) {
            this.firstGameStartTime = firstGameStartTime;
        }
    }
}
