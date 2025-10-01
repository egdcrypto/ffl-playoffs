package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Use case for updating the last used timestamp of a Personal Access Token
 * Called by auth service after successful token validation
 * Does not require user authorization (called during authentication)
 */
public class UpdatePATLastUsedUseCase {

    private final PersonalAccessTokenRepository tokenRepository;

    public UpdatePATLastUsedUseCase(PersonalAccessTokenRepository tokenRepository) {
        this.tokenRepository = tokenRepository;
    }

    /**
     * Updates the last used timestamp for a PAT
     * This is called by the auth service after successful validation
     *
     * @param command The update command
     * @return UpdatePATLastUsedResult with updated timestamp
     * @throws IllegalArgumentException if PAT not found
     */
    public UpdatePATLastUsedResult execute(UpdatePATLastUsedCommand command) {
        // Find PAT
        PersonalAccessToken pat = tokenRepository.findById(command.getPatId())
                .orElseThrow(() -> new IllegalArgumentException("PAT not found"));

        // Update last used timestamp
        LocalDateTime now = LocalDateTime.now();
        pat.setLastUsedAt(now);

        // Save updated PAT
        PersonalAccessToken updatedPat = tokenRepository.save(pat);

        // Return result
        return new UpdatePATLastUsedResult(
                updatedPat.getId(),
                updatedPat.getName(),
                updatedPat.getLastUsedAt()
        );
    }

    /**
     * Command object for updating PAT last used timestamp
     */
    public static class UpdatePATLastUsedCommand {
        private final UUID patId;

        public UpdatePATLastUsedCommand(UUID patId) {
            this.patId = patId;
        }

        public UUID getPatId() {
            return patId;
        }
    }

    /**
     * Result object for PAT last used update
     */
    public static class UpdatePATLastUsedResult {
        private final UUID patId;
        private final String patName;
        private final LocalDateTime lastUsedAt;

        public UpdatePATLastUsedResult(UUID patId, String patName, LocalDateTime lastUsedAt) {
            this.patId = patId;
            this.patName = patName;
            this.lastUsedAt = lastUsedAt;
        }

        public UUID getPatId() {
            return patId;
        }

        public String getPatName() {
            return patName;
        }

        public LocalDateTime getLastUsedAt() {
            return lastUsedAt;
        }
    }
}
