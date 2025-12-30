package com.ffl.playoffs.domain.service;

import com.ffl.playoffs.domain.model.auth.AuthToken;
import com.ffl.playoffs.domain.model.auth.AuthenticationContext;

/**
 * Domain service interface for authentication operations.
 * Infrastructure layer provides the implementation.
 */
public interface AuthenticationService {

    /**
     * Authenticate a token (JWT or PAT)
     * @param token the auth token to validate
     * @return AuthenticationContext with the result
     */
    AuthenticationContext authenticate(AuthToken token);

    /**
     * Authenticate a Google OAuth JWT token
     * @param jwtToken the JWT token string
     * @return AuthenticationContext with user context or error
     */
    AuthenticationContext authenticateGoogleJwt(String jwtToken);

    /**
     * Authenticate a Personal Access Token
     * @param patToken the PAT token string
     * @return AuthenticationContext with PAT context or error
     */
    AuthenticationContext authenticatePAT(String patToken);

    /**
     * Check if the service is operational
     * @return true if service is ready
     */
    boolean isAvailable();
}
