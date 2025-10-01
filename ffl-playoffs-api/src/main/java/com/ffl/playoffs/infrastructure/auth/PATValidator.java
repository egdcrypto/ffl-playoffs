package com.ffl.playoffs.infrastructure.auth;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

/**
 * Validates Personal Access Tokens (PATs)
 * Handles token hashing with bcrypt and token identifier extraction
 *
 * PAT Token Format: pat_<identifier>_<random-part>
 * - identifier: UUID for quick lookup (not sensitive, stored in DB)
 * - random-part: Cryptographically secure random data
 * - Full token is hashed with bcrypt for storage
 */
@Component
public class PATValidator {

    private static final Logger logger = LoggerFactory.getLogger(PATValidator.class);
    private static final String PAT_PREFIX = "pat_";
    private final BCryptPasswordEncoder encoder;

    public PATValidator() {
        this.encoder = new BCryptPasswordEncoder();
    }

    /**
     * Extracts the token identifier from a PAT token
     * Token format: pat_<identifier>_<random-part>
     *
     * @param token the full PAT token
     * @return the identifier part, or null if invalid format
     */
    public String extractTokenIdentifier(String token) {
        try {
            if (!token.startsWith(PAT_PREFIX)) {
                return null;
            }

            // Remove pat_ prefix
            String withoutPrefix = token.substring(PAT_PREFIX.length());

            // Extract identifier (everything before the second underscore)
            int secondUnderscore = withoutPrefix.indexOf('_');
            if (secondUnderscore == -1) {
                return null;
            }

            return withoutPrefix.substring(0, secondUnderscore);
        } catch (Exception e) {
            logger.error("Error extracting token identifier", e);
            return null;
        }
    }

    /**
     * Verifies a plaintext token against a stored bcrypt hash
     *
     * @param plaintext the plaintext token
     * @param hash the stored bcrypt hash
     * @return true if token matches hash
     */
    public boolean verifyToken(String plaintext, String hash) {
        try {
            return encoder.matches(plaintext, hash);
        } catch (Exception e) {
            logger.error("Error verifying PAT token", e);
            return false;
        }
    }

    /**
     * Hashes a token for storage (used when creating new PATs)
     *
     * @param token the plaintext token
     * @return the bcrypt hash for storage
     */
    public String hashForStorage(String token) {
        return encoder.encode(token);
    }

    /**
     * Generates a new PAT token with identifier
     * Format: pat_<uuid>_<random-64-chars>
     *
     * @return the generated token (plaintext)
     */
    public String generateToken() {
        String identifier = java.util.UUID.randomUUID().toString().replace("-", "");
        String randomPart = generateRandomString(64);
        return PAT_PREFIX + identifier + "_" + randomPart;
    }

    /**
     * Generates a cryptographically secure random string
     */
    private String generateRandomString(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        java.security.SecureRandom random = new java.security.SecureRandom();
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }
}
