package com.ffl.playoffs.infrastructure.auth;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Collections;

/**
 * Validates Google OAuth JWT tokens
 * Uses Google's official library to verify JWT signatures
 */
@Component
public class GoogleJwtValidator {

    private static final Logger logger = LoggerFactory.getLogger(GoogleJwtValidator.class);
    private static final String GOOGLE_ISSUER = "accounts.google.com";
    private static final String GOOGLE_ISSUER_HTTPS = "https://accounts.google.com";

    private final GoogleIdTokenVerifier verifier;

    public GoogleJwtValidator(@Value("${google.oauth.client-id}") String clientId) {
        this.verifier = new GoogleIdTokenVerifier.Builder(
                new NetHttpTransport(),
                new GsonFactory())
                .setAudience(Collections.singletonList(clientId))
                .setIssuer(GOOGLE_ISSUER)
                .build();
    }

    /**
     * Validates Google JWT token and extracts claims
     *
     * Performs the following validations:
     * 1. Verifies JWT signature using Google's public keys
     * 2. Validates JWT is not expired
     * 3. Validates issuer is "accounts.google.com"
     * 4. Validates audience matches client ID
     * 5. Extracts user email and Google ID from claims
     *
     * @param token the JWT token string
     * @return GoogleJwtClaims if valid, null if invalid
     */
    public GoogleJwtClaims validateAndExtractClaims(String token) {
        try {
            // Verify the token
            GoogleIdToken idToken = verifier.verify(token);
            if (idToken == null) {
                logger.warn("Invalid Google JWT token: verification failed");
                return null;
            }

            // Extract payload
            GoogleIdToken.Payload payload = idToken.getPayload();

            // Validate issuer
            String issuer = payload.getIssuer();
            if (!GOOGLE_ISSUER.equals(issuer) && !GOOGLE_ISSUER_HTTPS.equals(issuer)) {
                logger.warn("Invalid issuer: {}", issuer);
                return null;
            }

            // Extract claims
            String googleId = payload.getSubject();
            String email = payload.getEmail();
            String name = (String) payload.get("name");
            Boolean emailVerified = payload.getEmailVerified();

            // Validate required fields
            if (googleId == null || email == null) {
                logger.warn("Missing required fields in JWT payload");
                return null;
            }

            // Validate email is verified
            if (emailVerified == null || !emailVerified) {
                logger.warn("Email not verified for user: {}", email);
                return null;
            }

            logger.debug("Google JWT validated successfully for email: {}", email);
            return new GoogleJwtClaims(googleId, email, name);

        } catch (Exception e) {
            logger.error("Error validating Google JWT token", e);
            return null;
        }
    }
}
