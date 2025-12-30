package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.port.LeagueRepository;

import java.util.UUID;

/**
 * Use case for reactivating an inactive league.
 * Players can make selections again from the current week.
 */
public class ReactivateLeagueUseCase {

    private final LeagueRepository leagueRepository;

    public ReactivateLeagueUseCase(LeagueRepository leagueRepository) {
        this.leagueRepository = leagueRepository;
    }

    /**
     * Reactivates a league.
     *
     * @param command The reactivation command
     * @return The reactivated league
     * @throws LeagueNotFoundException if league not found
     * @throws IllegalStateException if league cannot be reactivated
     */
    public League execute(ReactivateLeagueCommand command) {
        League league = leagueRepository.findById(command.getLeagueId())
                .orElseThrow(() -> new LeagueNotFoundException(command.getLeagueId()));

        league.reactivate();

        return leagueRepository.save(league);
    }

    public static class ReactivateLeagueCommand {
        private final UUID leagueId;

        public ReactivateLeagueCommand(UUID leagueId) {
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
