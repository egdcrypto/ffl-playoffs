package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.AuthSession;
import com.ffl.playoffs.domain.port.AuthSessionRepository;

import java.util.List;
import java.util.Objects;
import java.util.UUID;

/**
 * Use case for terminating authentication sessions.
 * Supports terminating single sessions or all sessions for a user.
 */
public class TerminateSessionUseCase {

    private final AuthSessionRepository authSessionRepository;

    public TerminateSessionUseCase(AuthSessionRepository authSessionRepository) {
        this.authSessionRepository = authSessionRepository;
    }

    /**
     * Terminate a specific session
     */
    public TerminateResponse terminateSession(UUID sessionId, String reason) {
        Objects.requireNonNull(sessionId, "sessionId cannot be null");

        return authSessionRepository.findById(sessionId)
                .map(session -> {
                    if (!session.isActive()) {
                        return TerminateResponse.failure("Session is already terminated");
                    }
                    session.terminate(reason != null ? reason : "User requested logout");
                    authSessionRepository.save(session);
                    return TerminateResponse.success(1);
                })
                .orElse(TerminateResponse.failure("Session not found"));
    }

    /**
     * Terminate all active sessions for a principal
     */
    public TerminateResponse terminateAllSessions(UUID principalId, String reason) {
        Objects.requireNonNull(principalId, "principalId cannot be null");

        List<AuthSession> activeSessions = authSessionRepository.findActiveByPrincipalId(principalId);

        if (activeSessions.isEmpty()) {
            return TerminateResponse.success(0);
        }

        String terminationReason = reason != null ? reason : "All sessions terminated";

        for (AuthSession session : activeSessions) {
            session.terminate(terminationReason);
            authSessionRepository.save(session);
        }

        return TerminateResponse.success(activeSessions.size());
    }

    /**
     * Terminate all sessions except the current one
     */
    public TerminateResponse terminateOtherSessions(UUID principalId, UUID currentSessionId, String reason) {
        Objects.requireNonNull(principalId, "principalId cannot be null");
        Objects.requireNonNull(currentSessionId, "currentSessionId cannot be null");

        List<AuthSession> activeSessions = authSessionRepository.findActiveByPrincipalId(principalId);

        String terminationReason = reason != null ? reason : "Logged out from other devices";
        int count = 0;

        for (AuthSession session : activeSessions) {
            if (!session.getId().equals(currentSessionId)) {
                session.terminate(terminationReason);
                authSessionRepository.save(session);
                count++;
            }
        }

        return TerminateResponse.success(count);
    }

    /**
     * Response object for termination operations
     */
    public static class TerminateResponse {
        private final boolean success;
        private final int terminatedCount;
        private final String errorMessage;

        private TerminateResponse(boolean success, int terminatedCount, String errorMessage) {
            this.success = success;
            this.terminatedCount = terminatedCount;
            this.errorMessage = errorMessage;
        }

        public static TerminateResponse success(int count) {
            return new TerminateResponse(true, count, null);
        }

        public static TerminateResponse failure(String errorMessage) {
            return new TerminateResponse(false, 0, errorMessage);
        }

        public boolean isSuccess() {
            return success;
        }

        public int getTerminatedCount() {
            return terminatedCount;
        }

        public String getErrorMessage() {
            return errorMessage;
        }
    }
}
