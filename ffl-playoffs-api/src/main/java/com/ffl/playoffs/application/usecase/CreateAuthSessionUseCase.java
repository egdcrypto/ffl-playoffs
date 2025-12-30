package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.auth.AuthSession;
import com.ffl.playoffs.domain.model.auth.Permission;
import com.ffl.playoffs.domain.port.AuthSessionRepository;
import com.ffl.playoffs.domain.port.UserRepository;

import java.util.Set;
import java.util.UUID;

/**
 * Use case for creating authentication sessions
 * Creates session after successful Google OAuth or PAT authentication
 */
public class CreateAuthSessionUseCase {

    private final AuthSessionRepository sessionRepository;
    private final UserRepository userRepository;

    public CreateAuthSessionUseCase(AuthSessionRepository sessionRepository,
                                     UserRepository userRepository) {
        this.sessionRepository = sessionRepository;
        this.userRepository = userRepository;
    }

    /**
     * Create a session for Google OAuth authentication
     * @param command the session creation command
     * @return result containing the new session
     */
    public CreateSessionResult executeForGoogleAuth(CreateGoogleSessionCommand command) {
        // Find user by ID
        User user = userRepository.findById(command.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + command.getUserId()));

        // Get permissions for user's role
        Set<Permission> permissions = Permission.getDefaultPermissionsForRole(user.getRole());

        // Create session
        AuthSession session = AuthSession.createGoogleSession(
                user.getId(),
                user.getGoogleId(),
                permissions,
                command.getIpAddress(),
                command.getUserAgent()
        );

        // Save session
        AuthSession saved = sessionRepository.save(session);

        return new CreateSessionResult(saved, user);
    }

    /**
     * Create a session for PAT authentication
     * @param command the session creation command
     * @return result containing the new session
     */
    public CreateSessionResult executeForPATAuth(CreatePATSessionCommand command) {
        // Create session with PAT permissions
        AuthSession session = AuthSession.createPATSession(
                command.getPatId(),
                command.getPermissions(),
                command.getIpAddress(),
                command.getUserAgent()
        );

        // Save session
        AuthSession saved = sessionRepository.save(session);

        return new CreateSessionResult(saved, null);
    }

    /**
     * Command for creating Google OAuth session
     */
    public static class CreateGoogleSessionCommand {
        private final UUID userId;
        private final String ipAddress;
        private final String userAgent;

        public CreateGoogleSessionCommand(UUID userId, String ipAddress, String userAgent) {
            this.userId = userId;
            this.ipAddress = ipAddress;
            this.userAgent = userAgent;
        }

        public UUID getUserId() {
            return userId;
        }

        public String getIpAddress() {
            return ipAddress;
        }

        public String getUserAgent() {
            return userAgent;
        }
    }

    /**
     * Command for creating PAT session
     */
    public static class CreatePATSessionCommand {
        private final UUID patId;
        private final Set<Permission> permissions;
        private final String ipAddress;
        private final String userAgent;

        public CreatePATSessionCommand(UUID patId, Set<Permission> permissions,
                                        String ipAddress, String userAgent) {
            this.patId = patId;
            this.permissions = permissions;
            this.ipAddress = ipAddress;
            this.userAgent = userAgent;
        }

        public UUID getPatId() {
            return patId;
        }

        public Set<Permission> getPermissions() {
            return permissions;
        }

        public String getIpAddress() {
            return ipAddress;
        }

        public String getUserAgent() {
            return userAgent;
        }
    }

    /**
     * Result of session creation
     */
    public static class CreateSessionResult {
        private final AuthSession session;
        private final User user;

        public CreateSessionResult(AuthSession session, User user) {
            this.session = session;
            this.user = user;
        }

        public AuthSession getSession() {
            return session;
        }

        public User getUser() {
            return user;
        }

        public String getSessionToken() {
            return session.getSessionToken();
        }

        public String getRefreshToken() {
            return session.getRefreshToken();
        }
    }
}
