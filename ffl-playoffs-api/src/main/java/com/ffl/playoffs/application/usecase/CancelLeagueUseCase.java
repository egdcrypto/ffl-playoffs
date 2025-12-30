package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.port.LeagueRepository;

import java.util.UUID;

/**
 * Use case for cancelling a league.
 * All selections are preserved for reference, no further actions allowed.
 */
public class CancelLeagueUseCase {

    private final LeagueRepository leagueRepository;

    public CancelLeagueUseCase(LeagueRepository leagueRepository) {
        this.leagueRepository = leagueRepository;
    }

    /**
     * Cancels a league with a reason.
     *
     * @param command The cancellation command
     * @return The cancelled league
     * @throws LeagueNotFoundException if league not found
     * @throws IllegalStateException if league cannot be cancelled
     */
    public League execute(CancelLeagueCommand command) {
        League league = leagueRepository.findById(command.getLeagueId())
                .orElseThrow(() -> new LeagueNotFoundException(command.getLeagueId()));

        league.cancel(command.getReason());

        return leagueRepository.save(league);
    }

    public static class CancelLeagueCommand {
        private final UUID leagueId;
        private final String reason;

        public CancelLeagueCommand(UUID leagueId, String reason) {
            this.leagueId = leagueId;
            this.reason = reason;
        }

        public UUID getLeagueId() {
            return leagueId;
        }

        public String getReason() {
            return reason;
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
