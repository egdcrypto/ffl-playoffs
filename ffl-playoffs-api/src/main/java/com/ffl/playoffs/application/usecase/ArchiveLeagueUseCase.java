package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.port.LeagueRepository;

import java.util.UUID;

/**
 * Use case for archiving a completed league.
 * Data is preserved for historical viewing, no modifications allowed.
 */
public class ArchiveLeagueUseCase {

    private final LeagueRepository leagueRepository;

    public ArchiveLeagueUseCase(LeagueRepository leagueRepository) {
        this.leagueRepository = leagueRepository;
    }

    /**
     * Archives a completed league.
     *
     * @param command The archive command
     * @return The archived league
     * @throws LeagueNotFoundException if league not found
     * @throws IllegalStateException if league cannot be archived
     */
    public League execute(ArchiveLeagueCommand command) {
        League league = leagueRepository.findById(command.getLeagueId())
                .orElseThrow(() -> new LeagueNotFoundException(command.getLeagueId()));

        league.archive();

        return leagueRepository.save(league);
    }

    public static class ArchiveLeagueCommand {
        private final UUID leagueId;

        public ArchiveLeagueCommand(UUID leagueId) {
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
