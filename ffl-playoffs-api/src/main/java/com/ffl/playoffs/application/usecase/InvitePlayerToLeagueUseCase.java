package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.model.PlayerInvitation;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.PlayerInvitationRepository;
import org.springframework.stereotype.Service;

import java.util.UUID;

/**
 * Use case for inviting a player to a specific league.
 * Validates admin ownership and prevents duplicate invitations.
 */
@Service
public class InvitePlayerToLeagueUseCase {

    private final LeagueRepository leagueRepository;
    private final PlayerInvitationRepository invitationRepository;

    public InvitePlayerToLeagueUseCase(
            LeagueRepository leagueRepository,
            PlayerInvitationRepository invitationRepository) {
        this.leagueRepository = leagueRepository;
        this.invitationRepository = invitationRepository;
    }

    /**
     * Invites a player to a league.
     *
     * @param command The invitation command
     * @return The created invitation
     * @throws IllegalArgumentException if league not found
     * @throws UnauthorizedLeagueAccessException if admin doesn't own the league
     * @throws DuplicateInvitationException if pending invitation already exists
     */
    public PlayerInvitation execute(InvitePlayerCommand command) {
        // Find the league
        League league = leagueRepository.findById(command.getLeagueId())
                .orElseThrow(() -> new IllegalArgumentException(
                    "League not found: " + command.getLeagueId()));

        // Validate admin owns the league
        if (!league.getOwnerId().equals(command.getAdminUserId())) {
            throw new UnauthorizedLeagueAccessException(
                "Admin does not own this league");
        }

        // Check for existing pending invitation
        if (invitationRepository.existsPendingByEmailAndLeague(
                command.getEmail(), command.getLeagueId())) {
            throw new DuplicateInvitationException(
                "A pending invitation already exists for this email and league");
        }

        // Create the invitation
        PlayerInvitation invitation = new PlayerInvitation(
                command.getLeagueId(),
                league.getName(),
                command.getEmail(),
                command.getAdminUserId()
        );

        // Save and return
        return invitationRepository.save(invitation);
    }

    /**
     * Command object for inviting a player
     */
    public static class InvitePlayerCommand {
        private final UUID leagueId;
        private final String email;
        private final UUID adminUserId;

        public InvitePlayerCommand(UUID leagueId, String email, UUID adminUserId) {
            this.leagueId = leagueId;
            this.email = email;
            this.adminUserId = adminUserId;
        }

        public UUID getLeagueId() {
            return leagueId;
        }

        public String getEmail() {
            return email;
        }

        public UUID getAdminUserId() {
            return adminUserId;
        }
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

    /**
     * Exception for duplicate invitation attempts
     */
    public static class DuplicateInvitationException extends RuntimeException {
        public DuplicateInvitationException(String message) {
            super(message);
        }

        public String getErrorCode() {
            return "INVITATION_ALREADY_EXISTS";
        }
    }
}
