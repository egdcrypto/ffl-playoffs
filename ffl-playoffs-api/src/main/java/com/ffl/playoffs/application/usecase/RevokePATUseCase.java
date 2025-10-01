package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.domain.model.User;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;
import com.ffl.playoffs.domain.port.UserRepository;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Use case for revoking a Personal Access Token
 * Immediately disables the token while preserving audit trail
 * Only SUPER_ADMIN users can revoke PATs
 */
public class RevokePATUseCase {

    private final PersonalAccessTokenRepository tokenRepository;
    private final UserRepository userRepository;

    public RevokePATUseCase(
            PersonalAccessTokenRepository tokenRepository,
            UserRepository userRepository) {
        this.tokenRepository = tokenRepository;
        this.userRepository = userRepository;
    }

    /**
     * Revokes a Personal Access Token
     * Token is immediately rejected by auth service
     * PAT record remains in database for audit purposes
     *
     * @param command The revoke PAT command
     * @return RevokePATResult with revocation details
     * @throws IllegalArgumentException if PAT not found or user not found
     * @throws SecurityException if user lacks SUPER_ADMIN role
     * @throws IllegalStateException if PAT is already revoked
     */
    public RevokePATResult execute(RevokePATCommand command) {
        // Validate user exists and has SUPER_ADMIN role
        User user = userRepository.findById(command.getRevokedBy())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (!user.isSuperAdmin()) {
            throw new SecurityException("Only SUPER_ADMIN users can revoke Personal Access Tokens");
        }

        // Find PAT
        PersonalAccessToken pat = tokenRepository.findById(command.getPatId())
                .orElseThrow(() -> new IllegalArgumentException("PAT not found"));

        // Revoke the PAT (domain method handles already-revoked check)
        try {
            pat.revoke();
        } catch (IllegalStateException e) {
            throw new IllegalStateException("Cannot revoke PAT: " + e.getMessage());
        }

        // Save revoked PAT
        PersonalAccessToken revokedPat = tokenRepository.save(pat);

        // Return result
        return new RevokePATResult(
                revokedPat.getId(),
                revokedPat.getName(),
                true,
                LocalDateTime.now(),
                command.getRevokedBy()
        );
    }

    /**
     * Command object for revoking a PAT
     */
    public static class RevokePATCommand {
        private final UUID patId;
        private final UUID revokedBy;

        public RevokePATCommand(UUID patId, UUID revokedBy) {
            this.patId = patId;
            this.revokedBy = revokedBy;
        }

        public UUID getPatId() {
            return patId;
        }

        public UUID getRevokedBy() {
            return revokedBy;
        }
    }

    /**
     * Result object for PAT revocation
     */
    public static class RevokePATResult {
        private final UUID patId;
        private final String patName;
        private final boolean revoked;
        private final LocalDateTime revokedAt;
        private final UUID revokedBy;

        public RevokePATResult(UUID patId, String patName, boolean revoked,
                             LocalDateTime revokedAt, UUID revokedBy) {
            this.patId = patId;
            this.patName = patName;
            this.revoked = revoked;
            this.revokedAt = revokedAt;
            this.revokedBy = revokedBy;
        }

        public UUID getPatId() {
            return patId;
        }

        public String getPatName() {
            return patName;
        }

        public boolean isRevoked() {
            return revoked;
        }

        public LocalDateTime getRevokedAt() {
            return revokedAt;
        }

        public UUID getRevokedBy() {
            return revokedBy;
        }
    }
}
