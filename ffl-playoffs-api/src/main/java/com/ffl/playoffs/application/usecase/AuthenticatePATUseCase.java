package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.AuthSession;
import com.ffl.playoffs.domain.model.auth.AuthToken;
import com.ffl.playoffs.domain.model.auth.AuthenticationContext;
import com.ffl.playoffs.domain.port.AuthSessionRepository;
import com.ffl.playoffs.domain.service.AuthenticationService;

import java.util.Objects;

/**
 * Use case for authenticating via Personal Access Token.
 * Creates an auth session upon successful authentication.
 */
public class AuthenticatePATUseCase {

    private final AuthenticationService authenticationService;
    private final AuthSessionRepository authSessionRepository;

    public AuthenticatePATUseCase(
            AuthenticationService authenticationService,
            AuthSessionRepository authSessionRepository) {
        this.authenticationService = authenticationService;
        this.authSessionRepository = authSessionRepository;
    }

    /**
     * Execute PAT authentication
     */
    public AuthenticationResponse execute(AuthenticatePATCommand command) {
        Objects.requireNonNull(command, "command cannot be null");
        Objects.requireNonNull(command.getToken(), "token cannot be null");

        // Authenticate the token
        AuthToken token = AuthToken.of(command.getToken());

        if (!token.isPAT()) {
            return AuthenticationResponse.failure("Invalid token type - expected PAT");
        }

        AuthenticationContext context = authenticationService.authenticatePAT(token.getRawToken());

        if (!context.isAuthenticated()) {
            return AuthenticationResponse.failure(
                    context.getErrorMessage().orElse("Authentication failed")
            );
        }

        // Create auth session for PAT
        AuthSession session = null;
        if (context.getPat().isPresent()) {
            session = AuthSession.forPAT(
                    context.getPat().get().getId(),
                    context.getPat().get().getName(),
                    command.getIpAddress(),
                    command.getUserAgent()
            );
            authSessionRepository.save(session);
        }

        return AuthenticationResponse.success(context, session);
    }

    /**
     * Command object for PAT authentication
     */
    public static class AuthenticatePATCommand {
        private final String token;
        private String ipAddress;
        private String userAgent;

        public AuthenticatePATCommand(String token) {
            this.token = Objects.requireNonNull(token, "token cannot be null");
        }

        public String getToken() {
            return token;
        }

        public String getIpAddress() {
            return ipAddress;
        }

        public void setIpAddress(String ipAddress) {
            this.ipAddress = ipAddress;
        }

        public String getUserAgent() {
            return userAgent;
        }

        public void setUserAgent(String userAgent) {
            this.userAgent = userAgent;
        }
    }

    /**
     * Response object for authentication
     */
    public static class AuthenticationResponse {
        private final boolean success;
        private final AuthenticationContext context;
        private final AuthSession session;
        private final String errorMessage;

        private AuthenticationResponse(
                boolean success,
                AuthenticationContext context,
                AuthSession session,
                String errorMessage) {
            this.success = success;
            this.context = context;
            this.session = session;
            this.errorMessage = errorMessage;
        }

        public static AuthenticationResponse success(AuthenticationContext context, AuthSession session) {
            return new AuthenticationResponse(true, context, session, null);
        }

        public static AuthenticationResponse failure(String errorMessage) {
            return new AuthenticationResponse(false, null, null, errorMessage);
        }

        public boolean isSuccess() {
            return success;
        }

        public AuthenticationContext getContext() {
            return context;
        }

        public AuthSession getSession() {
            return session;
        }

        public String getErrorMessage() {
            return errorMessage;
        }
    }
}
