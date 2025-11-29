package com.ffl.playoffs.domain.service;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.util.Base64;

/**
 * Service for generating and hashing Personal Access Tokens
 * Implements cryptographically secure token generation and bcrypt hashing
 */
@Service
public class PATTokenGenerator {

    private static final String TOKEN_PREFIX = "pat_";
    private static final int TOKEN_IDENTIFIER_BYTES = 16;  // 128 bits for identifier
    private static final int TOKEN_SECRET_BYTES = 32;      // 256 bits for secret
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();
    private final BCryptPasswordEncoder passwordEncoder;

    public PATTokenGenerator() {
        this.passwordEncoder = new BCryptPasswordEncoder(10);  // BCrypt strength 10
    }

    /**
     * Generates a new PAT token with format: pat_<identifier>_<secret>
     * @return TokenPair containing the full token and identifier
     */
    public TokenPair generateToken() {
        // Generate cryptographically secure random bytes
        byte[] identifierBytes = new byte[TOKEN_IDENTIFIER_BYTES];
        byte[] secretBytes = new byte[TOKEN_SECRET_BYTES];

        SECURE_RANDOM.nextBytes(identifierBytes);
        SECURE_RANDOM.nextBytes(secretBytes);

        // Encode to URL-safe base64 without padding
        String identifier = base64UrlEncode(identifierBytes);
        String secret = base64UrlEncode(secretBytes);

        // Construct full token: pat_<identifier>_<secret>
        String fullToken = TOKEN_PREFIX + identifier + "_" + secret;

        return new TokenPair(fullToken, identifier);
    }

    /**
     * Hashes a PAT token using bcrypt
     * @param token the plaintext token
     * @return bcrypt hash of the token
     */
    public String hashToken(String token) {
        if (token == null || token.trim().isEmpty()) {
            throw new IllegalArgumentException("Token cannot be null or empty");
        }
        return passwordEncoder.encode(token);
    }

    /**
     * Verifies a plaintext token against a bcrypt hash
     * @param plaintextToken the plaintext token
     * @param tokenHash the bcrypt hash
     * @return true if token matches hash
     */
    public boolean verifyToken(String plaintextToken, String tokenHash) {
        if (plaintextToken == null || tokenHash == null) {
            return false;
        }
        return passwordEncoder.matches(plaintextToken, tokenHash);
    }

    /**
     * Encodes bytes to URL-safe base64 without padding
     */
    private String base64UrlEncode(byte[] bytes) {
        return Base64.getUrlEncoder()
                .withoutPadding()
                .encodeToString(bytes);
    }

    /**
     * Container for token and identifier pair
     */
    public static class TokenPair {
        private final String fullToken;
        private final String identifier;

        public TokenPair(String fullToken, String identifier) {
            this.fullToken = fullToken;
            this.identifier = identifier;
        }

        /**
         * Gets the full plaintext token (pat_<identifier>_<secret>)
         * This should only be shown to the user once upon creation
         */
        public String getFullToken() {
            return fullToken;
        }

        /**
         * Gets the identifier portion of the token
         * This is stored in the database for quick lookup
         */
        public String getIdentifier() {
            return identifier;
        }
    }
}
