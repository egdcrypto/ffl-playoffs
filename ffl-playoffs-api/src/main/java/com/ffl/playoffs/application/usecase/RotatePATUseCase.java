package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.domain.model.User;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.UUID;

/**
 * Use case for rotating a Personal Access Token
 * Generates a new token while preserving name, scope, expiration, and metadata
 * Old token is IMMEDIATELY invalidated
 * Returns new plaintext token ONCE
 * Only SUPER_ADMIN users can rotate PATs
 */
public class RotatePATUseCase {

    private final PersonalAccessTokenRepository tokenRepository;
    private final UserRepository userRepository;
    private final SecureRandom secureRandom;
    private final BCryptPasswordEncoder passwordEncoder;

    public RotatePATUseCase(
            PersonalAccessTokenRepository tokenRepository,
            UserRepository userRepository) {
        this.tokenRepository = tokenRepository;
        this.userRepository = userRepository;
        this.secureRandom = new SecureRandom();
        this.passwordEncoder = new BCryptPasswordEncoder(12);  // BCrypt strength 12 for PATs
    }

    /**
     * Rotates a Personal Access Token by generating a new token
     * Old token becomes invalid immediately
     * Preserves: name, scope, expiresAt, createdBy, createdAt
     * Resets: lastUsedAt to null
     * Returns: new plaintext token (ONLY TIME)
     *
     * @param command The rotate PAT command
     * @return RotatePATResult with new plaintext token (ONLY TIME)
     * @throws IllegalArgumentException if PAT not found or user not found
     * @throws SecurityException if user lacks SUPER_ADMIN role
     * @throws IllegalStateException if PAT is revoked
     */
    public RotatePATResult execute(RotatePATCommand command) {
        // Validate user exists and has SUPER_ADMIN role
        User user = userRepository.findById(command.getRotatedBy())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (!user.isSuperAdmin()) {
            throw new SecurityException("Only SUPER_ADMIN users can rotate Personal Access Tokens");
        }

        // Find PAT
        PersonalAccessToken pat = tokenRepository.findById(command.getPatId())
                .orElseThrow(() -> new IllegalArgumentException("PAT not found"));

        // Cannot rotate revoked PAT
        if (pat.isRevoked()) {
            throw new IllegalStateException("Cannot rotate revoked PAT. Create a new PAT instead.");
        }

        // Generate new token: pat_<identifier>_<random>
        String newTokenIdentifier = generateTokenIdentifier();
        String newRandomPart = generateRandomPart();
        String newPlaintextToken = "pat_" + newTokenIdentifier + "_" + newRandomPart;

        // Hash the new full token using BCrypt
        String newTokenHash = hashToken(newPlaintextToken);

        // Update PAT with new token (atomic operation)
        pat.setTokenIdentifier(newTokenIdentifier);
        pat.setTokenHash(newTokenHash);
        pat.setLastUsedAt(null);  // Reset last used timestamp

        // Save updated PAT
        PersonalAccessToken rotatedPat = tokenRepository.save(pat);

        // Return result with new plaintext token (ONLY TIME)
        return new RotatePATResult(
                rotatedPat.getId(),
                rotatedPat.getName(),
                newPlaintextToken,  // ⚠️ ONLY TIME RETURNED
                rotatedPat.getScope(),
                rotatedPat.getExpiresAt(),
                LocalDateTime.now(),
                command.getRotatedBy()
        );
    }

    /**
     * Generates cryptographically secure token identifier (32 characters)
     * Uses UUID without hyphens for efficient database lookup
     *
     * @return 32-character hex string
     */
    private String generateTokenIdentifier() {
        UUID uuid = UUID.randomUUID();
        return uuid.toString().replace("-", "");
    }

    /**
     * Generates cryptographically secure random part (64 characters)
     * Uses Base64 URL-safe encoding of random bytes
     *
     * @return 64+ character random string
     */
    private String generateRandomPart() {
        byte[] randomBytes = new byte[48];  // 48 bytes = 64 Base64 characters
        secureRandom.nextBytes(randomBytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(randomBytes);
    }

    /**
     * Hashes the token using BCrypt
     * Uses BCrypt with cost factor 12 as specified in PAT_MANAGEMENT.md
     *
     * @param token The plaintext token to hash
     * @return BCrypt hash of the token
     */
    private String hashToken(String token) {
        return passwordEncoder.encode(token);
    }

    /**
     * Command object for rotating a PAT
     */
    public static class RotatePATCommand {
        private final UUID patId;
        private final UUID rotatedBy;

        public RotatePATCommand(UUID patId, UUID rotatedBy) {
            this.patId = patId;
            this.rotatedBy = rotatedBy;
        }

        public UUID getPatId() {
            return patId;
        }

        public UUID getRotatedBy() {
            return rotatedBy;
        }
    }

    /**
     * Result object containing rotated PAT with NEW PLAINTEXT TOKEN
     * SECURITY: The newPlaintextToken field contains the actual token and should:
     * - NEVER be logged
     * - NEVER be stored in database
     * - ONLY be returned once in API response
     * - Be immediately discarded after display
     */
    public static class RotatePATResult {
        private final UUID patId;
        private final String patName;
        private final String newPlaintextToken;  // ⚠️ SENSITIVE - show only once
        private final com.ffl.playoffs.domain.model.PATScope scope;
        private final LocalDateTime expiresAt;
        private final LocalDateTime rotatedAt;
        private final UUID rotatedBy;

        public RotatePATResult(UUID patId, String patName, String newPlaintextToken,
                             com.ffl.playoffs.domain.model.PATScope scope, LocalDateTime expiresAt,
                             LocalDateTime rotatedAt, UUID rotatedBy) {
            this.patId = patId;
            this.patName = patName;
            this.newPlaintextToken = newPlaintextToken;
            this.scope = scope;
            this.expiresAt = expiresAt;
            this.rotatedAt = rotatedAt;
            this.rotatedBy = rotatedBy;
        }

        public UUID getPatId() {
            return patId;
        }

        public String getPatName() {
            return patName;
        }

        /**
         * Gets the new plaintext token after rotation
         * ⚠️ SECURITY WARNING: This token should NEVER be logged or stored
         * @return the new plaintext token (shown ONLY ONCE)
         */
        public String getNewPlaintextToken() {
            return newPlaintextToken;
        }

        public com.ffl.playoffs.domain.model.PATScope getScope() {
            return scope;
        }

        public LocalDateTime getExpiresAt() {
            return expiresAt;
        }

        public LocalDateTime getRotatedAt() {
            return rotatedAt;
        }

        public UUID getRotatedBy() {
            return rotatedBy;
        }
    }
}
