package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.LeaguePlayer;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;

import java.util.UUID;

/**
 * Use case for accepting a player invitation to join a league
 * Updates LeaguePlayer status from INVITED to ACTIVE
 */
public class AcceptPlayerInvitationUseCase {

    private final LeaguePlayerRepository leaguePlayerRepository;

    public AcceptPlayerInvitationUseCase(LeaguePlayerRepository leaguePlayerRepository) {
        this.leaguePlayerRepository = leaguePlayerRepository;
    }

    /**
     * Accepts a player invitation to join a league
     *
     * @param command The accept invitation command
     * @return The updated LeaguePlayer
     * @throws IllegalArgumentException if league player not found
     * @throws IllegalStateException if invitation token doesn't match
     * @throws IllegalStateException if invitation is not in INVITED status
     */
    public LeaguePlayer execute(AcceptPlayerInvitationCommand command) {
        // Find league player by ID
        LeaguePlayer leaguePlayer = leaguePlayerRepository.findById(command.getLeaguePlayerId())
                .orElseThrow(() -> new IllegalArgumentException("League player invitation not found"));

        // Verify invitation token matches
        if (leaguePlayer.getInvitationToken() != null &&
            !leaguePlayer.getInvitationToken().equals(command.getInvitationToken())) {
            throw new IllegalStateException("Invalid invitation token");
        }

        // Accept the invitation (transitions status to ACTIVE)
        leaguePlayer.acceptInvitation();

        // Save and return
        return leaguePlayerRepository.save(leaguePlayer);
    }

    /**
     * Command object for accepting player invitation
     */
    public static class AcceptPlayerInvitationCommand {
        private final UUID leaguePlayerId;
        private final String invitationToken;

        public AcceptPlayerInvitationCommand(UUID leaguePlayerId, String invitationToken) {
            this.leaguePlayerId = leaguePlayerId;
            this.invitationToken = invitationToken;
        }

        public UUID getLeaguePlayerId() {
            return leaguePlayerId;
        }

        public String getInvitationToken() {
            return invitationToken;
        }
    }
}
