package com.ffl.playoffs.infrastructure.auth;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Primary;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

/**
 * Test implementation of GoogleJwtValidator for use in BDD tests
 * Recognizes test token patterns and returns appropriate claims
 */
@Component
@Primary
@Profile("test")
public class TestGoogleJwtValidator extends GoogleJwtValidator {

    private static final Logger logger = LoggerFactory.getLogger(TestGoogleJwtValidator.class);

    public TestGoogleJwtValidator() {
        super("test-client-id-for-testing");
    }

    @Override
    public GoogleJwtClaims validateAndExtractClaims(String token) {
        logger.debug("TestGoogleJwtValidator validating token: {}", token);

        // Handle test token patterns
        if (token == null || token.isBlank()) {
            return null;
        }

        // Valid Google JWT token
        if ("valid-google-jwt-token".equals(token)) {
            return new GoogleJwtClaims("google-123", "test@example.com", "Test User");
        }

        // Expired token
        if ("expired-google-jwt-token".equals(token)) {
            logger.warn("Token is expired");
            return null;
        }

        // Invalid signature
        if ("invalid-signature-jwt-token".equals(token)) {
            logger.warn("Token has invalid signature");
            return null;
        }

        // Token with non-Google issuer
        if (token.startsWith("jwt-with-issuer-")) {
            String issuer = token.substring("jwt-with-issuer-".length());
            if (!"accounts.google.com".equals(issuer) && !"https://accounts.google.com".equals(issuer)) {
                logger.warn("Invalid issuer: {}", issuer);
                return null;
            }
            return new GoogleJwtClaims("google-123", "test@example.com", "Test User");
        }

        // New user token (for user creation tests)
        if (token.contains("new-user")) {
            return new GoogleJwtClaims("google-new-user", "newuser@example.com", "New User");
        }

        // Default: treat as invalid token
        logger.warn("Unknown test token pattern: {}", token);
        return null;
    }
}
