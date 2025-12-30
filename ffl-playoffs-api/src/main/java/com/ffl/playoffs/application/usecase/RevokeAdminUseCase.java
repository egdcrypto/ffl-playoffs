package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.UserRepository;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Use case for revoking admin privileges from a user
 * Only SUPER_ADMIN can revoke admin privileges
 */
public class RevokeAdminUseCase {

    private final UserRepository userRepository;

    public RevokeAdminUseCase(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    /**
     * Revokes admin privileges from a user by changing their role to PLAYER
     *
     * @param command The revoke admin command
     * @return Result containing the updated user info
     * @throws IllegalArgumentException if current user or target user not found
     * @throws IllegalStateException if current user is not SUPER_ADMIN
     * @throws IllegalStateException if target user is not an ADMIN
     * @throws IllegalStateException if trying to revoke own privileges
     */
    public RevokeAdminResult execute(RevokeAdminCommand command) {
        // Verify current user is SUPER_ADMIN
        User currentUser = userRepository.findById(command.getCurrentUserId())
                .orElseThrow(() -> new IllegalArgumentException("Current user not found"));

        if (!currentUser.isSuperAdmin()) {
            throw new IllegalStateException("Only SUPER_ADMIN can revoke admin privileges");
        }

        // Prevent self-revocation
        if (command.getAdminId().equals(command.getCurrentUserId())) {
            throw new IllegalStateException("Cannot revoke your own admin privileges");
        }

        // Find target admin
        User adminToRevoke = userRepository.findById(command.getAdminId())
                .orElseThrow(() -> new IllegalArgumentException("Admin user not found: " + command.getAdminId()));

        // Verify target is actually an admin
        if (adminToRevoke.getRole() != Role.ADMIN) {
            throw new IllegalStateException("User is not an admin: " + adminToRevoke.getEmail());
        }

        // Revoke admin privileges by changing role to PLAYER
        adminToRevoke.setRole(Role.PLAYER);
        adminToRevoke = userRepository.save(adminToRevoke);

        return new RevokeAdminResult(
                adminToRevoke.getId(),
                adminToRevoke.getEmail(),
                adminToRevoke.getName(),
                LocalDateTime.now()
        );
    }

    /**
     * Command object for revoking admin privileges
     */
    public static class RevokeAdminCommand {
        private final UUID adminId;
        private final UUID currentUserId;

        public RevokeAdminCommand(UUID adminId, UUID currentUserId) {
            this.adminId = adminId;
            this.currentUserId = currentUserId;
        }

        public UUID getAdminId() {
            return adminId;
        }

        public UUID getCurrentUserId() {
            return currentUserId;
        }
    }

    /**
     * Result object containing the revoked admin info
     */
    public static class RevokeAdminResult {
        private final UUID userId;
        private final String email;
        private final String name;
        private final LocalDateTime revokedAt;

        public RevokeAdminResult(UUID userId, String email, String name, LocalDateTime revokedAt) {
            this.userId = userId;
            this.email = email;
            this.name = name;
            this.revokedAt = revokedAt;
        }

        public UUID getUserId() {
            return userId;
        }

        public String getEmail() {
            return email;
        }

        public String getName() {
            return name;
        }

        public LocalDateTime getRevokedAt() {
            return revokedAt;
        }
    }
}
