package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.PATScope;
import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.model.User;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.UUID;

/**
 * Use case for creating a new Personal Access Token
 * Only SUPER_ADMIN users can create PATs
 * Returns plaintext token ONCE (never stored or shown again)
 */
@Service
public class CreatePATUseCase {

    private final PersonalAccessTokenRepository tokenRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final SecureRandom secureRandom;

    public CreatePATUseCase(
            PersonalAccessTokenRepository tokenRepository,
            UserRepository userRepository,
            PasswordEncoder passwordEncoder) {
        this.tokenRepository = tokenRepository;
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.secureRandom = new SecureRandom();
    }

    /**
     * Creates a new Personal Access Token
     *
     * @param command The create PAT command
     * @return CreatePATResult with plaintext token (ONLY TIME)
     * @throws IllegalArgumentException if user not found or invalid input
     * @throws SecurityException if user lacks SUPER_ADMIN role
     * @throws IllegalStateException if PAT name already exists
     */
    public CreatePATResult execute(CreatePATCommand command) {
        // Validate user exists and has SUPER_ADMIN role
        User user = userRepository.findById(command.getCreatedBy())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (!user.isSuperAdmin()) {
            throw new SecurityException("Only SUPER_ADMIN users can create Personal Access Tokens");
        }

        // Validate inputs
        validateCommand(command);

        // Check if PAT name already exists
        if (tokenRepository.existsByName(command.getName())) {
            throw new IllegalStateException("PAT with name '" + command.getName() + "' already exists");
        }

        // Generate token: pat_<identifier>_<random>
        String tokenIdentifier = generateTokenIdentifier();
        String randomPart = generateRandomPart();
        String plaintextToken = "pat_" + tokenIdentifier + "_" + randomPart;

        // Hash the full token using BCrypt
        String tokenHash = hashToken(plaintextToken);

        // Create PAT entity
        PersonalAccessToken pat = new PersonalAccessToken(
                command.getName(),
                tokenIdentifier,
                tokenHash,
                command.getScope(),
                command.getExpiresAt(),
                command.getCreatedBy().toString()
        );

        // Save PAT
        PersonalAccessToken savedPat = tokenRepository.save(pat);

        // Return result with plaintext token (ONLY TIME)
        return new CreatePATResult(
                savedPat.getId(),
                savedPat.getName(),
                plaintextToken,  // ONLY TIME RETURNED
                savedPat.getScope(),
                savedPat.getExpiresAt(),
                UUID.fromString(savedPat.getCreatedBy()),
                savedPat.getCreatedAt()
        );
    }

    /**
     * Validates the create PAT command inputs
     */
    private void validateCommand(CreatePATCommand command) {
        if (command.getName() == null || command.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("PAT name cannot be empty");
        }

        if (command.getScope() == null) {
            throw new IllegalArgumentException("PAT scope cannot be null");
        }

        if (command.getExpiresAt() != null && command.getExpiresAt().isBefore(LocalDateTime.now())) {
            throw new IllegalArgumentException("PAT expiration must be in the future");
        }

        if (command.getCreatedBy() == null) {
            throw new IllegalArgumentException("Creator user ID cannot be null");
        }
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
     * Uses Spring Security's PasswordEncoder (BCryptPasswordEncoder)
     * with cost factor 12 as specified in PAT_MANAGEMENT.md
     *
     * @param token The plaintext token to hash
     * @return BCrypt hash of the token
     */
    private String hashToken(String token) {
        return passwordEncoder.encode(token);
    }

    /**
     * Command object for creating a PAT
     */
    public static class CreatePATCommand {
        private final String name;
        private final PATScope scope;
        private final LocalDateTime expiresAt;
        private final UUID createdBy;

        public CreatePATCommand(String name, PATScope scope, LocalDateTime expiresAt, UUID createdBy) {
            this.name = name;
            this.scope = scope;
            this.expiresAt = expiresAt;
            this.createdBy = createdBy;
        }

        public String getName() {
            return name;
        }

        public PATScope getScope() {
            return scope;
        }

        public LocalDateTime getExpiresAt() {
            return expiresAt;
        }

        public UUID getCreatedBy() {
            return createdBy;
        }
    }

    /**
     * Result object containing created PAT with PLAINTEXT TOKEN
     * SECURITY: The plaintextToken field contains the actual token and should:
     * - NEVER be logged
     * - NEVER be stored in database
     * - ONLY be returned once in API response
     * - Be immediately discarded after display
     */
    public static class CreatePATResult {
        private final UUID id;
        private final String name;
        private final String plaintextToken;  // ⚠️ SENSITIVE - show only once
        private final PATScope scope;
        private final LocalDateTime expiresAt;
        private final UUID createdBy;
        private final LocalDateTime createdAt;

        public CreatePATResult(UUID id, String name, String plaintextToken, PATScope scope,
                             LocalDateTime expiresAt, UUID createdBy, LocalDateTime createdAt) {
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

        public UUID getCreatedBy() {
            return createdBy;
        }

        public LocalDateTime getCreatedAt() {
            return createdAt;
        }
    }
}
