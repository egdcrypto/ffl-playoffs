package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.model.LeaguePlayer;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import com.ffl.playoffs.domain.port.LeagueRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

/**
 * Use case for removing a player from a league.
 * Archives the player's team selections and removes access.
 */
@Service
public class RemovePlayerFromLeagueUseCase {

    private final LeagueRepository leagueRepository;
    private final LeaguePlayerRepository leaguePlayerRepository;

    public RemovePlayerFromLeagueUseCase(
            LeagueRepository leagueRepository,
            LeaguePlayerRepository leaguePlayerRepository) {
        this.leagueRepository = leagueRepository;
        this.leaguePlayerRepository = leaguePlayerRepository;
    }

    /**
     * Removes a player from a league.
     * The player's team selections are archived but not deleted.
     *
     * @param command The remove command
     * @return The updated LeaguePlayer with REMOVED status
     * @throws IllegalArgumentException if league or player not found
     * @throws UnauthorizedLeagueAccessException if admin doesn't own the league
     */
    @Transactional
    public LeaguePlayer execute(RemovePlayerCommand command) {
        // Find the league
        League league = leagueRepository.findById(command.getLeagueId())
                .orElseThrow(() -> new IllegalArgumentException(
                    "League not found: " + command.getLeagueId()));

        // Validate admin owns the league
        if (!league.getOwnerId().equals(command.getAdminUserId())) {
            throw new UnauthorizedLeagueAccessException(
                "Admin does not own this league");
        }

        // Find the league player membership
        LeaguePlayer leaguePlayer = leaguePlayerRepository
                .findByUserIdAndLeagueId(command.getPlayerUserId(), command.getLeagueId())
                .orElseThrow(() -> new IllegalArgumentException(
                    "Player is not a member of this league"));

        // Remove the player (changes status to REMOVED)
        leaguePlayer.remove();

        // Note: Team selections are preserved with REMOVED status for historical records
        // The TeamSelection repository can filter by LeaguePlayer status

        return leaguePlayerRepository.save(leaguePlayer);
    }

    /**
     * Command object for removing a player
     */
    public static class RemovePlayerCommand {
        private final UUID leagueId;
        private final UUID playerUserId;
        private final UUID adminUserId;

        public RemovePlayerCommand(UUID leagueId, UUID playerUserId, UUID adminUserId) {
            this.leagueId = leagueId;
            this.playerUserId = playerUserId;
            this.adminUserId = adminUserId;
        }

        public UUID getLeagueId() { return leagueId; }
        public UUID getPlayerUserId() { return playerUserId; }
        public UUID getAdminUserId() { return adminUserId; }
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
