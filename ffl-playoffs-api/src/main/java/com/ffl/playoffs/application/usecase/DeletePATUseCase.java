package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;
import com.ffl.playoffs.domain.port.UserRepository;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Use case for permanently deleting a Personal Access Token
 * PAT record is PERMANENTLY removed from database
 * Cannot be recovered after deletion
 * Only SUPER_ADMIN users can delete PATs
 *
 * Use revoke instead of delete if you want to preserve audit trail
 */
public class DeletePATUseCase {

    private final PersonalAccessTokenRepository tokenRepository;
    private final UserRepository userRepository;

    public DeletePATUseCase(
            PersonalAccessTokenRepository tokenRepository,
            UserRepository userRepository) {
        this.tokenRepository = tokenRepository;
        this.userRepository = userRepository;
    }

    /**
     * Permanently deletes a Personal Access Token
     * PAT record is removed from database and cannot be recovered
     * Audit log entry should be created before calling this (in infrastructure layer)
     *
     * @param command The delete PAT command
     * @return DeletePATResult with deletion details
     * @throws IllegalArgumentException if PAT not found or user not found
     * @throws SecurityException if user lacks SUPER_ADMIN role
     */
    public DeletePATResult execute(DeletePATCommand command) {
        // Validate user exists and has SUPER_ADMIN role
        User user = userRepository.findById(command.getDeletedBy())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (!user.isSuperAdmin()) {
            throw new SecurityException("Only SUPER_ADMIN users can delete Personal Access Tokens");
        }

        // Find PAT (to get metadata before deletion)
        PersonalAccessToken pat = tokenRepository.findById(command.getPatId())
                .orElseThrow(() -> new IllegalArgumentException("PAT not found"));

        // Store metadata for result
        UUID patId = pat.getId();
        String patName = pat.getName();

        // Permanently delete PAT
        tokenRepository.deleteById(command.getPatId());

        // Return result
        return new DeletePATResult(
                patId,
                patName,
                true,
                LocalDateTime.now(),
                command.getDeletedBy()
        );
    }

    /**
     * Command object for deleting a PAT
     */
    public static class DeletePATCommand {
        private final UUID patId;
        private final UUID deletedBy;

        public DeletePATCommand(UUID patId, UUID deletedBy) {
            this.patId = patId;
            this.deletedBy = deletedBy;
        }

        public UUID getPatId() {
            return patId;
        }

        public UUID getDeletedBy() {
            return deletedBy;
        }
    }

    /**
     * Result object for PAT deletion
     */
    public static class DeletePATResult {
        private final UUID patId;
        private final String patName;
        private final boolean deleted;
        private final LocalDateTime deletedAt;
        private final UUID deletedBy;

        public DeletePATResult(UUID patId, String patName, boolean deleted,
                             LocalDateTime deletedAt, UUID deletedBy) {
            this.patId = patId;
            this.patName = patName;
            this.deleted = deleted;
            this.deletedAt = deletedAt;
            this.deletedBy = deletedBy;
        }

        public UUID getPatId() {
            return patId;
        }

        public String getPatName() {
            return patName;
        }

        public boolean isDeleted() {
            return deleted;
        }

        public LocalDateTime getDeletedAt() {
            return deletedAt;
        }

        public UUID getDeletedBy() {
            return deletedBy;
        }
    }
}
