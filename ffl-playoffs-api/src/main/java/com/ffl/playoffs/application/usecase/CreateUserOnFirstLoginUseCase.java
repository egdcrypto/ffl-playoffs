package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.LeaguePlayer;
import com.ffl.playoffs.domain.model.PlayerInvitation;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import com.ffl.playoffs.domain.port.PlayerInvitationRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Use case for creating a user account on first OAuth login.
 * Handles the auto-creation flow when a user authenticates for the first time.
 *
 * This use case:
 * 1. Checks if user already exists by Google ID
 * 2. If new user, checks for pending player invitations
 * 3. Creates user with PLAYER role (default)
 * 4. Auto-accepts pending invitations and adds user to leagues
 */
public class CreateUserOnFirstLoginUseCase {

    private static final Logger log = LoggerFactory.getLogger(CreateUserOnFirstLoginUseCase.class);

    private final UserRepository userRepository;
    private final PlayerInvitationRepository invitationRepository;
    private final LeaguePlayerRepository leaguePlayerRepository;

    public CreateUserOnFirstLoginUseCase(
            UserRepository userRepository,
            PlayerInvitationRepository invitationRepository,
            LeaguePlayerRepository leaguePlayerRepository) {
        this.userRepository = userRepository;
        this.invitationRepository = invitationRepository;
        this.leaguePlayerRepository = leaguePlayerRepository;
    }

    /**
     * Processes a first-time OAuth login and creates user if needed.
     *
     * @param command The OAuth login command with user details from Google
     * @return The result containing the user and any accepted invitations
     */
    public FirstLoginResult execute(OAuthLoginCommand command) {
        log.info("Processing first login for email: {}, googleId: {}", command.getEmail(), command.getGoogleId());

        // Check if user already exists by Google ID
        Optional<User> existingUser = userRepository.findByGoogleId(command.getGoogleId());
        if (existingUser.isPresent()) {
            log.info("User already exists with Google ID: {}", command.getGoogleId());
            User user = existingUser.get();
            user.updateLastLogin();
            userRepository.save(user);
            return new FirstLoginResult(user, List.of(), false);
        }

        // Check if user exists by email (might have been pre-created)
        Optional<User> existingByEmail = userRepository.findByEmail(command.getEmail());
        if (existingByEmail.isPresent()) {
            log.info("User exists by email, linking Google ID: {}", command.getEmail());
            User user = existingByEmail.get();
            user.setGoogleId(command.getGoogleId());
            if (command.getName() != null && user.getName() == null) {
                user.setName(command.getName());
            }
            user.updateLastLogin();
            userRepository.save(user);
            return new FirstLoginResult(user, List.of(), false);
        }

        // Find pending invitations for this email
        List<PlayerInvitation> pendingInvitations = invitationRepository.findPendingByEmail(command.getEmail());

        // Create new user with PLAYER role
        User newUser = new User(
                command.getEmail(),
                command.getName(),
                command.getGoogleId(),
                Role.PLAYER
        );
        User savedUser = userRepository.save(newUser);
        log.info("Created new user: {} with role PLAYER", savedUser.getId());

        // Process pending invitations
        List<PlayerInvitation> acceptedInvitations = new ArrayList<>();
        for (PlayerInvitation invitation : pendingInvitations) {
            if (invitation.canBeAccepted()) {
                try {
                    // Accept the invitation
                    invitation.accept(savedUser.getId());
                    invitationRepository.save(invitation);

                    // Create league player entry
                    LeaguePlayer leaguePlayer = new LeaguePlayer(savedUser.getId(), invitation.getLeagueId());
                    leaguePlayer.setStatus(LeaguePlayer.LeaguePlayerStatus.ACTIVE);
                    leaguePlayer.setJoinedAt(java.time.LocalDateTime.now());
                    leaguePlayerRepository.save(leaguePlayer);

                    acceptedInvitations.add(invitation);
                    log.info("Auto-accepted invitation to league {} for user {}",
                            invitation.getLeagueId(), savedUser.getId());
                } catch (Exception e) {
                    log.warn("Failed to accept invitation {}: {}", invitation.getId(), e.getMessage());
                }
            }
        }

        savedUser.updateLastLogin();
        userRepository.save(savedUser);

        return new FirstLoginResult(savedUser, acceptedInvitations, true);
    }

    /**
     * Command object for OAuth login
     */
    public static class OAuthLoginCommand {
        private final String email;
        private final String googleId;
        private final String name;
        private final String pictureUrl;

        public OAuthLoginCommand(String email, String googleId, String name, String pictureUrl) {
            this.email = email;
            this.googleId = googleId;
            this.name = name;
            this.pictureUrl = pictureUrl;
        }

        public String getEmail() {
            return email;
        }

        public String getGoogleId() {
            return googleId;
        }

        public String getName() {
            return name;
        }

        public String getPictureUrl() {
            return pictureUrl;
        }
    }

    /**
     * Result of first login processing
     */
    public static class FirstLoginResult {
        private final User user;
        private final List<PlayerInvitation> acceptedInvitations;
        private final boolean newUserCreated;

        public FirstLoginResult(User user, List<PlayerInvitation> acceptedInvitations, boolean newUserCreated) {
            this.user = user;
            this.acceptedInvitations = acceptedInvitations;
            this.newUserCreated = newUserCreated;
        }

        public User getUser() {
            return user;
        }

        public List<PlayerInvitation> getAcceptedInvitations() {
            return acceptedInvitations;
        }

        public boolean isNewUserCreated() {
            return newUserCreated;
        }
    }
}
