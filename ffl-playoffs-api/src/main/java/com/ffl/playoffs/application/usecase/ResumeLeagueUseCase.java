package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.port.LeagueRepository;

import java.util.UUID;

/**
 * Use case for resuming a paused league.
 * Deadlines should be recalculated based on current date.
 */
public class ResumeLeagueUseCase {

    private final LeagueRepository leagueRepository;

    public ResumeLeagueUseCase(LeagueRepository leagueRepository) {
        this.leagueRepository = leagueRepository;
    }

    /**
     * Resumes a league.
     *
     * @param command The resume command
     * @return The resumed league
     * @throws LeagueNotFoundException if league not found
     * @throws IllegalStateException if league cannot be resumed
     */
    public League execute(ResumeLeagueCommand command) {
        League league = leagueRepository.findById(command.getLeagueId())
                .orElseThrow(() -> new LeagueNotFoundException(command.getLeagueId()));

        league.resume();

        return leagueRepository.save(league);
    }

    public static class ResumeLeagueCommand {
        private final UUID leagueId;

        public ResumeLeagueCommand(UUID leagueId) {
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
