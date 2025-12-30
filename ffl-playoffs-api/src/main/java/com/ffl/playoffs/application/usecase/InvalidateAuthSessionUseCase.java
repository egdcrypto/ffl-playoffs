package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.auth.AuthSession;
import com.ffl.playoffs.domain.port.AuthSessionRepository;

import java.util.UUID;

/**
 * Use case for invalidating authentication sessions
 * Handles logout and session revocation
 */
public class InvalidateAuthSessionUseCase {

    private final AuthSessionRepository sessionRepository;

    public InvalidateAuthSessionUseCase(AuthSessionRepository sessionRepository) {
        this.sessionRepository = sessionRepository;
    }

    /**
     * Invalidate a session by token (user logout)
     * @param command the invalidation command
     * @return result of the operation
     */
    public InvalidateResult executeByToken(InvalidateByTokenCommand command) {
        // Find session by token
        AuthSession session = sessionRepository.findBySessionToken(command.getSessionToken())
                .orElse(null);

        if (session == null) {
            return InvalidateResult.notFound("Session not found");
        }

        try {
            session.invalidate();
            sessionRepository.save(session);
            return InvalidateResult.success("Session invalidated successfully");
        } catch (IllegalStateException e) {
            return InvalidateResult.failure(e.getMessage());
        }
    }

    /**
     * Revoke a session by ID (admin action)
     * @param command the revocation command
     * @return result of the operation
     */
    public InvalidateResult executeRevoke(RevokeSessionCommand command) {
        // Find session by ID
        AuthSession session = sessionRepository.findById(command.getSessionId())
                .orElse(null);

        if (session == null) {
            return InvalidateResult.notFound("Session not found");
        }

        try {
            session.revoke();
            sessionRepository.save(session);
            return InvalidateResult.success("Session revoked successfully");
        } catch (IllegalStateException e) {
            return InvalidateResult.failure(e.getMessage());
        }
    }

    /**
     * Invalidate all sessions for a user (force logout all)
     * @param command the invalidate all command
     * @return result of the operation
     */
    public InvalidateAllResult executeInvalidateAll(InvalidateAllByUserCommand command) {
        int invalidatedCount = sessionRepository.invalidateAllByUserId(command.getUserId());
        return new InvalidateAllResult(true, invalidatedCount,
                "Invalidated " + invalidatedCount + " sessions");
    }

    /**
     * Command for invalidating by token
     */
    public static class InvalidateByTokenCommand {
        private final String sessionToken;

        public InvalidateByTokenCommand(String sessionToken) {
            this.sessionToken = sessionToken;
        }

        public String getSessionToken() {
            return sessionToken;
        }
    }

    /**
     * Command for revoking by session ID
     */
    public static class RevokeSessionCommand {
        private final UUID sessionId;

        public RevokeSessionCommand(UUID sessionId) {
            this.sessionId = sessionId;
        }

        public UUID getSessionId() {
            return sessionId;
        }
    }

    /**
     * Command for invalidating all user sessions
     */
    public static class InvalidateAllByUserCommand {
        private final UUID userId;

        public InvalidateAllByUserCommand(UUID userId) {
            this.userId = userId;
        }

        public UUID getUserId() {
            return userId;
        }
    }

    /**
     * Result of single session invalidation
     */
    public static class InvalidateResult {
        private final boolean success;
        private final boolean notFound;
        private final String message;

        private InvalidateResult(boolean success, boolean notFound, String message) {
            this.success = success;
            this.notFound = notFound;
            this.message = message;
        }

        public static InvalidateResult success(String message) {
            return new InvalidateResult(true, false, message);
        }

        public static InvalidateResult failure(String message) {
            return new InvalidateResult(false, false, message);
        }

        public static InvalidateResult notFound(String message) {
            return new InvalidateResult(false, true, message);
        }

        public boolean isSuccess() {
            return success;
        }

        public boolean isNotFound() {
            return notFound;
        }

        public String getMessage() {
            return message;
        }
    }

    /**
     * Result of invalidating all sessions
     */
    public static class InvalidateAllResult {
        private final boolean success;
        private final int invalidatedCount;
        private final String message;

        public InvalidateAllResult(boolean success, int invalidatedCount, String message) {
            this.success = success;
            this.invalidatedCount = invalidatedCount;
            this.message = message;
        }

        public boolean isSuccess() {
            return success;
        }

        public int getInvalidatedCount() {
            return invalidatedCount;
        }

        public String getMessage() {
            return message;
        }
    }
}
