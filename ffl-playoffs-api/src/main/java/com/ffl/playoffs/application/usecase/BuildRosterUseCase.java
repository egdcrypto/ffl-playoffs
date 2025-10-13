package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.League;
import com.ffl.playoffs.domain.model.Roster;
import com.ffl.playoffs.domain.model.RosterConfiguration;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.RosterRepository;

import java.util.UUID;

/**
 * Use case for building/initializing a player's roster in a league
 * Creates a new roster with slots based on the league's roster configuration
 */
public class BuildRosterUseCase {

    private final LeagueRepository leagueRepository;
    private final RosterRepository rosterRepository;

    public BuildRosterUseCase(
            LeagueRepository leagueRepository,
            RosterRepository rosterRepository) {
        this.leagueRepository = leagueRepository;
        this.rosterRepository = rosterRepository;
    }

    /**
     * Builds a new roster for a league player based on the league's configuration.
     * Creates all roster slots according to the position requirements.
     *
     * @param command The build roster command
     * @return The newly created Roster entity
     * @throws IllegalArgumentException if league not found
     * @throws IllegalArgumentException if roster already exists for player
     * @throws IllegalStateException if league has no roster configuration
     */
    public Roster execute(BuildRosterCommand command) {
        // Find league
        League league = leagueRepository.findById(command.getLeagueId())
                .orElseThrow(() -> new IllegalArgumentException("League not found"));

        // Validate league has roster configuration
        if (league.getRosterConfiguration() == null) {
            throw new IllegalStateException("League has no roster configuration defined");
        }

        // Check if roster already exists for this player
        if (rosterRepository.existsByLeaguePlayerId(command.getLeaguePlayerId())) {
            throw new IllegalArgumentException("Roster already exists for this player in this league");
        }

        // Get roster configuration
        RosterConfiguration config = league.getRosterConfiguration();
        config.validate();

        // Create roster with slots
        Roster roster = new Roster(
                command.getLeaguePlayerId(),
                command.getLeagueId(),
                config
        );

        // Set roster deadline if provided
        if (command.getRosterDeadline() != null) {
            roster.setRosterDeadline(command.getRosterDeadline());
        } else if (league.getFirstGameStartTime() != null) {
            // Default to first game start time
            roster.setRosterDeadline(league.getFirstGameStartTime());
        }

        // Persist roster
        return rosterRepository.save(roster);
    }

    /**
     * Command object for building a roster
     */
    public static class BuildRosterCommand {
        private final UUID leagueId;
        private final UUID leaguePlayerId;
        private java.time.LocalDateTime rosterDeadline;

        public BuildRosterCommand(UUID leagueId, UUID leaguePlayerId) {
            this.leagueId = leagueId;
            this.leaguePlayerId = leaguePlayerId;
        }

        public UUID getLeagueId() {
            return leagueId;
        }

        public UUID getLeaguePlayerId() {
            return leaguePlayerId;
        }

        public java.time.LocalDateTime getRosterDeadline() {
            return rosterDeadline;
        }

        public void setRosterDeadline(java.time.LocalDateTime rosterDeadline) {
            this.rosterDeadline = rosterDeadline;
        }
    }
}
