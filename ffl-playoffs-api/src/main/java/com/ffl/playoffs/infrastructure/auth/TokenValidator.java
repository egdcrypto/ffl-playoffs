package com.ffl.playoffs.infrastructure.auth;

/**
 * Token validator interface
 * Validates both Google JWT tokens and Personal Access Tokens (PATs)
 */
public interface TokenValidator {

    /**
     * Validates a Google JWT token
     *
     * Performs the following validations:
     * 1. Verifies JWT signature using Google's public keys
     * 2. Validates JWT is not expired
     * 3. Validates issuer is "accounts.google.com"
     * 4. Extracts user email and Google ID from JWT claims
     * 5. Queries database to find user by Google ID
     * 6. Updates user's last login timestamp
     *
     * @param token the Google JWT token
     * @return AuthenticationResult with user context or error
     */
    AuthenticationResult validateGoogleJWT(String token);

    /**
     * Validates a Personal Access Token (PAT)
     *
     * Performs the following validations:
     * 1. Hashes the token with bcrypt
     * 2. Queries PersonalAccessToken table by token hash
     * 3. Validates PAT is not expired
     * 4. Validates PAT is not revoked
     * 5. Updates lastUsedAt timestamp
     *
     * @param token the PAT token (starts with "pat_" prefix)
     * @return AuthenticationResult with PAT context or error
     */
    AuthenticationResult validatePAT(String token);
}
