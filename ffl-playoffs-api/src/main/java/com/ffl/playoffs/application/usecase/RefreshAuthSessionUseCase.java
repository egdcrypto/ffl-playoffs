package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.auth.AuthSession;
import com.ffl.playoffs.domain.port.AuthSessionRepository;

/**
 * Use case for refreshing authentication sessions
 * Extends session validity using refresh token
 */
public class RefreshAuthSessionUseCase {

    private final AuthSessionRepository sessionRepository;

    public RefreshAuthSessionUseCase(AuthSessionRepository sessionRepository) {
        this.sessionRepository = sessionRepository;
    }

    /**
     * Refresh a session using refresh token
     * @param command the refresh command
     * @return result with new session token
     */
    public RefreshResult execute(RefreshSessionCommand command) {
        // Find session by refresh token
        AuthSession session = sessionRepository.findByRefreshToken(command.getRefreshToken())
                .orElse(null);

        if (session == null) {
            return RefreshResult.failure("Invalid refresh token");
        }

        // Check if refresh token is still valid
        if (session.isRefreshExpired()) {
            return RefreshResult.failure("Refresh token has expired");
        }

        // Check if session can be refreshed
        if (!session.getStatus().canRefresh()) {
            return RefreshResult.failure("Session cannot be refreshed in current state");
        }

        try {
            // Refresh the session
            String newSessionToken = session.refresh();

            // Save updated session
            sessionRepository.save(session);

            return RefreshResult.success(session, newSessionToken);
        } catch (IllegalStateException e) {
            return RefreshResult.failure(e.getMessage());
        }
    }

    /**
     * Command for refreshing session
     */
    public static class RefreshSessionCommand {
        private final String refreshToken;

        public RefreshSessionCommand(String refreshToken) {
            this.refreshToken = refreshToken;
        }

        public String getRefreshToken() {
            return refreshToken;
        }
    }

    /**
     * Result of session refresh
     */
    public static class RefreshResult {
        private final boolean success;
        private final AuthSession session;
        private final String newSessionToken;
        private final String errorMessage;

        private RefreshResult(boolean success, AuthSession session,
                               String newSessionToken, String errorMessage) {
            this.success = success;
            this.session = session;
            this.newSessionToken = newSessionToken;
            this.errorMessage = errorMessage;
        }

        public static RefreshResult success(AuthSession session, String newSessionToken) {
            return new RefreshResult(true, session, newSessionToken, null);
        }

        public static RefreshResult failure(String errorMessage) {
            return new RefreshResult(false, null, null, errorMessage);
        }

        public boolean isSuccess() {
            return success;
        }

        public AuthSession getSession() {
            return session;
        }

        public String getNewSessionToken() {
            return newSessionToken;
        }

        public String getErrorMessage() {
            return errorMessage;
        }
    }
}
