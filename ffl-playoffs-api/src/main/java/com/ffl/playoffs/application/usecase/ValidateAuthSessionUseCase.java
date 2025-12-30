package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.auth.AuthSession;
import com.ffl.playoffs.domain.model.auth.Permission;
import com.ffl.playoffs.domain.port.AuthSessionRepository;
import com.ffl.playoffs.domain.port.UserRepository;

import java.util.Set;

/**
 * Use case for validating authentication sessions
 * Validates session token and checks permissions
 */
public class ValidateAuthSessionUseCase {

    private final AuthSessionRepository sessionRepository;
    private final UserRepository userRepository;

    public ValidateAuthSessionUseCase(AuthSessionRepository sessionRepository,
                                       UserRepository userRepository) {
        this.sessionRepository = sessionRepository;
        this.userRepository = userRepository;
    }

    /**
     * Validate a session token
     * @param command the validation command
     * @return validation result
     */
    public ValidationResult execute(ValidateSessionCommand command) {
        // Find session by token
        AuthSession session = sessionRepository.findBySessionToken(command.getSessionToken())
                .orElse(null);

        if (session == null) {
            return ValidationResult.invalid("Session not found");
        }

        // Check if session is valid
        if (!session.isValid()) {
            if (session.isExpired()) {
                session.markExpired();
                sessionRepository.save(session);
                return ValidationResult.invalid("Session has expired");
            }
            return ValidationResult.invalid("Session is not active");
        }

        // Check required permissions if specified
        if (command.getRequiredPermissions() != null && !command.getRequiredPermissions().isEmpty()) {
            if (!session.hasAllPermissions(command.getRequiredPermissions())) {
                return ValidationResult.insufficientPermissions(
                        "Missing required permissions",
                        session.getPermissions()
                );
            }
        }

        // Update last activity
        session.updateLastActivity();
        sessionRepository.save(session);

        // Get user if this is a user session
        User user = null;
        if (session.isUserSession() && session.getUserId() != null) {
            user = userRepository.findById(session.getUserId()).orElse(null);
        }

        return ValidationResult.valid(session, user);
    }

    /**
     * Command for validating session
     */
    public static class ValidateSessionCommand {
        private final String sessionToken;
        private final Set<Permission> requiredPermissions;

        public ValidateSessionCommand(String sessionToken) {
            this(sessionToken, null);
        }

        public ValidateSessionCommand(String sessionToken, Set<Permission> requiredPermissions) {
            this.sessionToken = sessionToken;
            this.requiredPermissions = requiredPermissions;
        }

        public String getSessionToken() {
            return sessionToken;
        }

        public Set<Permission> getRequiredPermissions() {
            return requiredPermissions;
        }
    }

    /**
     * Result of session validation
     */
    public static class ValidationResult {
        private final boolean valid;
        private final AuthSession session;
        private final User user;
        private final String message;
        private final Set<Permission> actualPermissions;
        private final boolean insufficientPermissions;

        private ValidationResult(boolean valid, AuthSession session, User user,
                                  String message, Set<Permission> actualPermissions,
                                  boolean insufficientPermissions) {
            this.valid = valid;
            this.session = session;
            this.user = user;
            this.message = message;
            this.actualPermissions = actualPermissions;
            this.insufficientPermissions = insufficientPermissions;
        }

        public static ValidationResult valid(AuthSession session, User user) {
            return new ValidationResult(true, session, user, "Session is valid",
                    session.getPermissions(), false);
        }

        public static ValidationResult invalid(String message) {
            return new ValidationResult(false, null, null, message, null, false);
        }

        public static ValidationResult insufficientPermissions(String message, Set<Permission> actualPermissions) {
            return new ValidationResult(false, null, null, message, actualPermissions, true);
        }

        public boolean isValid() {
            return valid;
        }

        public AuthSession getSession() {
            return session;
        }

        public User getUser() {
            return user;
        }

        public String getMessage() {
            return message;
        }

        public Set<Permission> getActualPermissions() {
            return actualPermissions;
        }

        public boolean isInsufficientPermissions() {
            return insufficientPermissions;
        }
    }
}
