package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.PATScope;
import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.UUID;

/**
 * Use case for creating the bootstrap Personal Access Token
 * This is a special PAT used for initial system setup - created by SYSTEM
 * Returns plaintext token ONCE (never stored or shown again)
 */
public class CreateBootstrapPATUseCase {

    private static final String BOOTSTRAP_PAT_NAME = "bootstrap";
    private static final String SYSTEM_CREATOR = "SYSTEM";
    private static final int BCRYPT_COST = 12;

    private final PersonalAccessTokenRepository tokenRepository;
    private final BCryptPasswordEncoder passwordEncoder;
    private final SecureRandom secureRandom;

    public CreateBootstrapPATUseCase(PersonalAccessTokenRepository tokenRepository) {
        this.tokenRepository = tokenRepository;
        this.passwordEncoder = new BCryptPasswordEncoder(BCRYPT_COST);
        this.secureRandom = new SecureRandom();
    }

    /**
     * Creates the bootstrap Personal Access Token
     * Can only be created once - prevents duplicate bootstrap PATs
     *
     * @return CreateBootstrapPATResult with plaintext token (ONLY TIME)
     * @throws IllegalStateException if bootstrap PAT already exists
     */
    public CreateBootstrapPATResult execute() {
        // Check if bootstrap PAT already exists
        if (tokenRepository.existsByName(BOOTSTRAP_PAT_NAME)) {
            throw new IllegalStateException("Bootstrap PAT already exists");
        }

        // Generate token: pat_<identifier>_<random>
        String tokenIdentifier = generateTokenIdentifier();
        String randomPart = generateRandomPart();
        String plaintextToken = "pat_" + tokenIdentifier + "_" + randomPart;

        // Hash the full token using BCrypt
        String tokenHash = passwordEncoder.encode(plaintextToken);

        // Set expiration to 1 year from now
        LocalDateTime expiresAt = LocalDateTime.now().plusYears(1);

        // Create PAT entity
        PersonalAccessToken pat = new PersonalAccessToken(
                BOOTSTRAP_PAT_NAME,
                tokenIdentifier,
                tokenHash,
                PATScope.ADMIN,
                expiresAt,
                SYSTEM_CREATOR
        );

        // Save PAT
        PersonalAccessToken savedPat = tokenRepository.save(pat);

        // Return result with plaintext token (ONLY TIME)
        return new CreateBootstrapPATResult(
                savedPat.getId(),
                savedPat.getName(),
                plaintextToken,  // ONLY TIME RETURNED
                savedPat.getScope(),
                savedPat.getExpiresAt(),
                savedPat.getCreatedBy(),
                savedPat.getCreatedAt()
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
     * Result object containing created bootstrap PAT with PLAINTEXT TOKEN
     * SECURITY: The plaintextToken field contains the actual token and should:
     * - NEVER be logged
     * - NEVER be stored in database
     * - ONLY be returned once in console output
     * - Be immediately discarded after display
     */
    public static class CreateBootstrapPATResult {
        private final UUID id;
        private final String name;
        private final String plaintextToken;  // ⚠️ SENSITIVE - show only once
        private final PATScope scope;
        private final LocalDateTime expiresAt;
        private final String createdBy;
        private final LocalDateTime createdAt;

        public CreateBootstrapPATResult(UUID id, String name, String plaintextToken, PATScope scope,
                                       LocalDateTime expiresAt, String createdBy, LocalDateTime createdAt) {
            this.id = id;
            this.name = name;
            this.plaintextToken = plaintextToken;
            this.scope = scope;
            this.expiresAt = expiresAt;
            this.createdBy = createdBy;
            this.createdAt = createdAt;
        }

        public UUID getId() {
            return id;
        }

        public String getName() {
            return name;
        }

        /**
         * Gets the plaintext token
         * ⚠️ SECURITY WARNING: This token should NEVER be logged or stored
         * @return the plaintext token (shown ONLY ONCE)
         */
        public String getPlaintextToken() {
            return plaintextToken;
        }

        public PATScope getScope() {
            return scope;
        }

        public LocalDateTime getExpiresAt() {
            return expiresAt;
        }

        public String getCreatedBy() {
            return createdBy;
        }

        public LocalDateTime getCreatedAt() {
            return createdAt;
        }
    }
}
