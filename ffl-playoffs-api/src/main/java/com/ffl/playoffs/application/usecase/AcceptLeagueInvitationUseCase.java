package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.LeaguePlayer;
import com.ffl.playoffs.domain.model.PlayerInvitation;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.PlayerInvitationRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;
import java.util.UUID;

/**
 * Use case for accepting a league invitation.
 * Handles both new users (via Google OAuth) and existing users joining a new league.
 */
@Service
public class AcceptLeagueInvitationUseCase {

    private final PlayerInvitationRepository invitationRepository;
    private final LeagueRepository leagueRepository;
    private final UserRepository userRepository;
    private final LeaguePlayerRepository leaguePlayerRepository;

    public AcceptLeagueInvitationUseCase(
            PlayerInvitationRepository invitationRepository,
            LeagueRepository leagueRepository,
            UserRepository userRepository,
            LeaguePlayerRepository leaguePlayerRepository) {
        this.invitationRepository = invitationRepository;
        this.leagueRepository = leagueRepository;
        this.userRepository = userRepository;
        this.leaguePlayerRepository = leaguePlayerRepository;
    }

    /**
     * Accepts an invitation using the invitation token.
     *
     * @param command The accept command with token and user info
     * @return Result containing the user and league player
     * @throws IllegalArgumentException if invitation not found
     * @throws PlayerInvitation.InvitationException if invitation cannot be accepted
     */
    @Transactional
    public AcceptInvitationResult execute(AcceptInvitationCommand command) {
        // Find invitation by token
        PlayerInvitation invitation = invitationRepository.findByToken(command.getInvitationToken())
                .orElseThrow(() -> new IllegalArgumentException(
                    "Invitation not found with token: " + command.getInvitationToken()));

        // Validate email matches
        if (!invitation.getEmail().equalsIgnoreCase(command.getEmail())) {
            throw new IllegalArgumentException(
                "Email does not match invitation");
        }

        // Check if user already exists
        Optional<User> existingUser = userRepository.findByEmail(command.getEmail());
        User user;
        boolean isNewUser = false;

        if (existingUser.isPresent()) {
            user = existingUser.get();
            // Update Google ID if not already set
            if (command.getGoogleId() != null && user.getGoogleId() == null) {
                user.setGoogleId(command.getGoogleId());
                user = userRepository.save(user);
            }
        } else {
            // Create new user
            user = new User();
            user.setEmail(command.getEmail());
            user.setName(command.getDisplayName());
            user.setGoogleId(command.getGoogleId());
            user.setRole(Role.PLAYER);
            user = userRepository.save(user);
            isNewUser = true;
        }

        // Accept the invitation (this validates expiration, etc.)
        invitation.accept(user.getId());
        invitationRepository.save(invitation);

        // Check if user is already a member of the league
        Optional<LeaguePlayer> existingMembership =
            leaguePlayerRepository.findByUserIdAndLeagueId(user.getId(), invitation.getLeagueId());

        LeaguePlayer leaguePlayer;
        if (existingMembership.isPresent()) {
            leaguePlayer = existingMembership.get();
            // Reactivate if previously removed or inactive
            if (leaguePlayer.getStatus() == LeaguePlayer.LeaguePlayerStatus.REMOVED ||
                leaguePlayer.getStatus() == LeaguePlayer.LeaguePlayerStatus.INACTIVE) {
                leaguePlayer.reactivate();
                leaguePlayer = leaguePlayerRepository.save(leaguePlayer);
            }
        } else {
            // Create new league membership
            leaguePlayer = new LeaguePlayer(user.getId(), invitation.getLeagueId());
            leaguePlayer.acceptInvitation();
            leaguePlayer = leaguePlayerRepository.save(leaguePlayer);
        }

        // Get the league for the result
        League league = leagueRepository.findById(invitation.getLeagueId())
                .orElseThrow(() -> new IllegalArgumentException("League not found"));

        return new AcceptInvitationResult(user, leaguePlayer, league, invitation, isNewUser);
    }

    /**
     * Command object for accepting an invitation
     */
    public static class AcceptInvitationCommand {
        private final String invitationToken;
        private final String email;
        private final String displayName;
        private final String googleId;

        public AcceptInvitationCommand(String invitationToken, String email,
                                       String displayName, String googleId) {
            this.invitationToken = invitationToken;
            this.email = email;
            this.displayName = displayName;
            this.googleId = googleId;
        }

        public String getInvitationToken() {
            return invitationToken;
        }

        public String getEmail() {
            return email;
        }

        public String getDisplayName() {
            return displayName;
        }

        public String getGoogleId() {
            return googleId;
        }
    }

    /**
     * Result object containing the user and league player
     */
    public static class AcceptInvitationResult {
        private final User user;
        private final LeaguePlayer leaguePlayer;
        private final League league;
        private final PlayerInvitation invitation;
        private final boolean newUser;

        public AcceptInvitationResult(User user, LeaguePlayer leaguePlayer,
                                      League league, PlayerInvitation invitation,
                                      boolean newUser) {
            this.user = user;
            this.leaguePlayer = leaguePlayer;
            this.league = league;
            this.invitation = invitation;
            this.newUser = newUser;
        }

        public User getUser() {
            return user;
        }

        public LeaguePlayer getLeaguePlayer() {
            return leaguePlayer;
        }

        public League getLeague() {
            return league;
        }

        public PlayerInvitation getInvitation() {
            return invitation;
        }

        public boolean isNewUser() {
            return newUser;
        }
    }
}
