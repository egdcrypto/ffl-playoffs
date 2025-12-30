package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.WeekRepository;

import java.util.UUID;

/**
 * Use case for deleting a draft league.
 * Only DRAFT leagues with no players can be deleted.
 */
public class DeleteLeagueUseCase {

    private final LeagueRepository leagueRepository;
    private final WeekRepository weekRepository;

    public DeleteLeagueUseCase(LeagueRepository leagueRepository, WeekRepository weekRepository) {
        this.leagueRepository = leagueRepository;
        this.weekRepository = weekRepository;
    }

    /**
     * Deletes a draft league.
     *
     * @param command The delete command
     * @throws LeagueNotFoundException if league not found
     * @throws League.CannotDeleteLeagueException if league cannot be deleted
     */
    public void execute(DeleteLeagueCommand command) {
        League league = leagueRepository.findById(command.getLeagueId())
                .orElseThrow(() -> new LeagueNotFoundException(command.getLeagueId()));

        // Validate league can be deleted
        league.validateCanDelete();

        // Delete any weeks (shouldn't exist for draft leagues, but cleanup just in case)
        weekRepository.deleteByLeagueId(league.getId());

        // Delete the league
        leagueRepository.deleteById(league.getId());
    }

    public static class DeleteLeagueCommand {
        private final UUID leagueId;

        public DeleteLeagueCommand(UUID leagueId) {
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
