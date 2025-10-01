package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.League;
import com.ffl.playoffs.domain.model.RosterConfiguration;
import com.ffl.playoffs.domain.model.ScoringRules;
import com.ffl.playoffs.domain.port.LeagueRepository;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Use case for configuring or updating an existing league
 * Enforces configuration lock rules - changes only allowed before first game starts
 */
public class ConfigureLeagueUseCase {

    private final LeagueRepository leagueRepository;

    public ConfigureLeagueUseCase(LeagueRepository leagueRepository) {
        this.leagueRepository = leagueRepository;
    }

    /**
     * Configures a league with updated settings.
     * Will throw ConfigurationLockedException if league configuration is locked.
     *
     * @param command The configure league command
     * @return The updated League entity
     * @throws IllegalArgumentException if league not found
     * @throws IllegalArgumentException if user is not the league owner
     * @throws League.ConfigurationLockedException if configuration is locked
     */
    public League execute(ConfigureLeagueCommand command) {
        // Find league
        League league = leagueRepository.findById(command.getLeagueId())
                .orElseThrow(() -> new IllegalArgumentException("League not found"));

        // Verify ownership
        if (!league.getOwnerId().equals(command.getOwnerId())) {
            throw new IllegalArgumentException("Only the league owner can configure the league");
        }

        LocalDateTime now = LocalDateTime.now();

        // Update name if provided
        if (command.getName() != null) {
            league.setName(command.getName(), now);
        }

        // Update description if provided
        if (command.getDescription() != null) {
            league.setDescription(command.getDescription(), now);
        }

        // Update week configuration if provided
        if (command.getStartingWeek() != null && command.getNumberOfWeeks() != null) {
            league.setStartingWeekAndDuration(command.getStartingWeek(), command.getNumberOfWeeks());
        } else if (command.getStartingWeek() != null) {
            league.setStartingWeek(command.getStartingWeek(), now);
        } else if (command.getNumberOfWeeks() != null) {
            league.setNumberOfWeeks(command.getNumberOfWeeks(), now);
        }

        // Update roster configuration if provided
        if (command.getRosterConfiguration() != null) {
            command.getRosterConfiguration().validate();
            league.setRosterConfiguration(command.getRosterConfiguration(), now);
        }

        // Update scoring rules if provided
        if (command.getScoringRules() != null) {
            league.setScoringRules(command.getScoringRules(), now);
        }

        // Persist updated league
        return leagueRepository.save(league);
    }

    /**
     * Command object for configuring a league
     */
    public static class ConfigureLeagueCommand {
        private final UUID leagueId;
        private final UUID ownerId;
        private String name;
        private String description;
        private Integer startingWeek;
        private Integer numberOfWeeks;
        private RosterConfiguration rosterConfiguration;
        private ScoringRules scoringRules;

        public ConfigureLeagueCommand(UUID leagueId, UUID ownerId) {
            this.leagueId = leagueId;
            this.ownerId = ownerId;
        }

        // Getters and Setters
        public UUID getLeagueId() {
            return leagueId;
        }

        public UUID getOwnerId() {
            return ownerId;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public Integer getStartingWeek() {
            return startingWeek;
        }

        public void setStartingWeek(Integer startingWeek) {
            this.startingWeek = startingWeek;
        }

        public Integer getNumberOfWeeks() {
            return numberOfWeeks;
        }

        public void setNumberOfWeeks(Integer numberOfWeeks) {
            this.numberOfWeeks = numberOfWeeks;
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
    }
}
