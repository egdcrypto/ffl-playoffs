package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.port.LeagueRepository;

import java.util.UUID;

/**
 * Use case for marking a league as completed.
 * Final standings are calculated, no further modifications allowed.
 */
public class CompleteLeagueUseCase {

    private final LeagueRepository leagueRepository;

    public CompleteLeagueUseCase(LeagueRepository leagueRepository) {
        this.leagueRepository = leagueRepository;
    }

    /**
     * Completes a league.
     *
     * @param command The completion command
     * @return The completed league
     * @throws LeagueNotFoundException if league not found
     * @throws IllegalStateException if league cannot be completed
     */
    public League execute(CompleteLeagueCommand command) {
        League league = leagueRepository.findById(command.getLeagueId())
                .orElseThrow(() -> new LeagueNotFoundException(command.getLeagueId()));

        league.complete();

        return leagueRepository.save(league);
    }

    public static class CompleteLeagueCommand {
        private final UUID leagueId;

        public CompleteLeagueCommand(UUID leagueId) {
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
