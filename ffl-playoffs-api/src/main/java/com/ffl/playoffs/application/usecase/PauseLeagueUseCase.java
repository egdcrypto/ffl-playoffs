package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.port.LeagueRepository;

import java.util.UUID;

/**
 * Use case for pausing an active league.
 * All deadlines are suspended, players cannot make selections.
 */
public class PauseLeagueUseCase {

    private final LeagueRepository leagueRepository;

    public PauseLeagueUseCase(LeagueRepository leagueRepository) {
        this.leagueRepository = leagueRepository;
    }

    /**
     * Pauses a league.
     *
     * @param command The pause command
     * @return The paused league
     * @throws LeagueNotFoundException if league not found
     * @throws IllegalStateException if league cannot be paused
     */
    public League execute(PauseLeagueCommand command) {
        League league = leagueRepository.findById(command.getLeagueId())
                .orElseThrow(() -> new LeagueNotFoundException(command.getLeagueId()));

        league.pause();

        return leagueRepository.save(league);
    }

    public static class PauseLeagueCommand {
        private final UUID leagueId;

        public PauseLeagueCommand(UUID leagueId) {
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
