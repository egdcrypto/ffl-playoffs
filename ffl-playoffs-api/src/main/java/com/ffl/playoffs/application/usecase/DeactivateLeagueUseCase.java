package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.port.LeagueRepository;

import java.util.UUID;

/**
 * Use case for deactivating an active league.
 * Players cannot make new selections, but existing selections are preserved.
 */
public class DeactivateLeagueUseCase {

    private final LeagueRepository leagueRepository;

    public DeactivateLeagueUseCase(LeagueRepository leagueRepository) {
        this.leagueRepository = leagueRepository;
    }

    /**
     * Deactivates a league.
     *
     * @param command The deactivation command
     * @return The deactivated league
     * @throws LeagueNotFoundException if league not found
     * @throws IllegalStateException if league cannot be deactivated
     */
    public League execute(DeactivateLeagueCommand command) {
        League league = leagueRepository.findById(command.getLeagueId())
                .orElseThrow(() -> new LeagueNotFoundException(command.getLeagueId()));

        league.deactivate();

        return leagueRepository.save(league);
    }

    public static class DeactivateLeagueCommand {
        private final UUID leagueId;

        public DeactivateLeagueCommand(UUID leagueId) {
            this.leagueId = leagueId;
        }

        public UUID getLeagueId() {
            return leagueId;
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
}
