package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.port.LeagueRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

/**
 * Use case for cloning settings from an existing league to a new league.
 * Copies scoring rules, roster configuration, and other settings.
 */
@Service
public class CloneLeagueSettingsUseCase {

    private final LeagueRepository leagueRepository;

    public CloneLeagueSettingsUseCase(LeagueRepository leagueRepository) {
        this.leagueRepository = leagueRepository;
    }

    /**
     * Creates a new league by cloning settings from an existing league.
     *
     * @param command The clone command
     * @return The newly created league with cloned settings
     * @throws IllegalArgumentException if source league not found
     * @throws UnauthorizedLeagueAccessException if admin doesn't own the source league
     */
    @Transactional
    public League execute(CloneLeagueCommand command) {
        // Find the source league
        League sourceLeague = leagueRepository.findById(command.getSourceLeagueId())
                .orElseThrow(() -> new IllegalArgumentException(
                    "Source league not found: " + command.getSourceLeagueId()));

        // Validate admin owns the source league
        if (!sourceLeague.getOwnerId().equals(command.getAdminUserId())) {
            throw new UnauthorizedLeagueAccessException(
                "Admin does not own the source league");
        }

        // Check that new league code is unique
        if (leagueRepository.existsByCode(command.getNewLeagueCode())) {
            throw new IllegalArgumentException(
                "League code already exists: " + command.getNewLeagueCode());
        }

        // Create new league with cloned settings
        League newLeague = new League(
                command.getNewLeagueName(),
                command.getNewLeagueCode(),
                command.getAdminUserId(),
                command.getStartingWeek() != null ? command.getStartingWeek() : sourceLeague.getStartingWeek(),
                command.getNumberOfWeeks() != null ? command.getNumberOfWeeks() : sourceLeague.getNumberOfWeeks()
        );

        // Clone description if provided, otherwise use source
        if (command.getDescription() != null) {
            newLeague.setDescription(command.getDescription());
        } else if (sourceLeague.getDescription() != null) {
            newLeague.setDescription("Cloned from: " + sourceLeague.getName());
        }

        // Clone roster configuration
        if (sourceLeague.getRosterConfiguration() != null) {
            newLeague.setRosterConfiguration(sourceLeague.getRosterConfiguration());
        }

        // Clone scoring rules (using the copy method for immutable value objects)
        if (sourceLeague.getScoringRules() != null) {
            newLeague.setScoringRules(sourceLeague.getScoringRules().copy());
        }

        // Status is DRAFT by default

        // Save and return the new league
        return leagueRepository.save(newLeague);
    }

    /**
     * Command object for cloning a league
     */
    public static class CloneLeagueCommand {
        private final UUID sourceLeagueId;
        private final String newLeagueName;
        private final String newLeagueCode;
        private final UUID adminUserId;
        private String description;
        private Integer startingWeek;
        private Integer numberOfWeeks;

        public CloneLeagueCommand(UUID sourceLeagueId, String newLeagueName,
                                  String newLeagueCode, UUID adminUserId) {
            this.sourceLeagueId = sourceLeagueId;
            this.newLeagueName = newLeagueName;
            this.newLeagueCode = newLeagueCode;
            this.adminUserId = adminUserId;
        }

        public UUID getSourceLeagueId() { return sourceLeagueId; }
        public String getNewLeagueName() { return newLeagueName; }
        public String getNewLeagueCode() { return newLeagueCode; }
        public UUID getAdminUserId() { return adminUserId; }
        public String getDescription() { return description; }
        public Integer getStartingWeek() { return startingWeek; }
        public Integer getNumberOfWeeks() { return numberOfWeeks; }

        public void setDescription(String description) { this.description = description; }
        public void setStartingWeek(Integer startingWeek) { this.startingWeek = startingWeek; }
        public void setNumberOfWeeks(Integer numberOfWeeks) { this.numberOfWeeks = numberOfWeeks; }
    }

    /**
     * Exception for unauthorized league access
     */
    public static class UnauthorizedLeagueAccessException extends RuntimeException {
        public UnauthorizedLeagueAccessException(String message) {
            super(message);
        }

        public String getErrorCode() {
            return "UNAUTHORIZED_LEAGUE_ACCESS";
        }
    }
}
