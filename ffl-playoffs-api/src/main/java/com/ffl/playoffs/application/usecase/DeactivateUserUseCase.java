package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.port.UserRepository;
import com.ffl.playoffs.domain.service.AccessControlService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.UUID;

/**
 * Use case for deactivating user accounts
 * Only SUPER_ADMIN can deactivate users
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class DeactivateUserUseCase {

    private final UserRepository userRepository;
    private final AccessControlService accessControlService;

    /**
     * Deactivates a user account
     * @param command the deactivate command
     * @return the deactivated user
     * @throws IllegalArgumentException if user not found
     * @throws AccessControlService.AccessDeniedException if not authorized
     */
    public User execute(DeactivateUserCommand command) {
        log.info("Deactivating user: {}", command.getUserId());

        // Find the user performing the action
        User deactivator = userRepository.findById(command.getDeactivatedBy())
                .orElseThrow(() -> new IllegalArgumentException("Deactivator not found"));

        // Only super admin can deactivate users
        accessControlService.requirePermission(deactivator,
                com.ffl.playoffs.domain.model.Permission.MANAGE_ADMINS);

        // Find the user to deactivate
        User userToDeactivate = userRepository.findById(command.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        // Cannot deactivate yourself
        if (deactivator.getId().equals(userToDeactivate.getId())) {
            throw new IllegalStateException("Cannot deactivate your own account");
        }

        // Cannot deactivate another super admin
        if (userToDeactivate.isSuperAdmin()) {
            throw new AccessControlService.AccessDeniedException("Cannot deactivate a super admin");
        }

        // Deactivate the user
        userToDeactivate.deactivate();

        User saved = userRepository.save(userToDeactivate);
        log.info("User {} deactivated successfully", saved.getId());
        return saved;
    }

    /**
     * Reactivates a user account
     * @param command the reactivate command
     * @return the reactivated user
     */
    public User reactivate(DeactivateUserCommand command) {
        log.info("Reactivating user: {}", command.getUserId());

        User reactivator = userRepository.findById(command.getDeactivatedBy())
                .orElseThrow(() -> new IllegalArgumentException("Reactivator not found"));

        accessControlService.requirePermission(reactivator,
                com.ffl.playoffs.domain.model.Permission.MANAGE_ADMINS);

        User userToReactivate = userRepository.findById(command.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        userToReactivate.activate();

        User saved = userRepository.save(userToReactivate);
        log.info("User {} reactivated successfully", saved.getId());
        return saved;
    }

    /**
     * Command object for deactivating a user
     */
    public static class DeactivateUserCommand {
        private final UUID userId;
        private final UUID deactivatedBy;

        public DeactivateUserCommand(UUID userId, UUID deactivatedBy) {
            this.userId = userId;
            this.deactivatedBy = deactivatedBy;
        }

        public UUID getUserId() {
            return userId;
        }

        public UUID getDeactivatedBy() {
            return deactivatedBy;
        }
    }
}
