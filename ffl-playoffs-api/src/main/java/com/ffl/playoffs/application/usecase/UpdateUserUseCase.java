package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.UserRepository;
import com.ffl.playoffs.domain.service.AccessControlService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.UUID;

/**
 * Use case for updating user information
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class UpdateUserUseCase {

    private final UserRepository userRepository;
    private final AccessControlService accessControlService;

    /**
     * Updates a user's profile information
     * @param command the update command
     * @return the updated user
     * @throws IllegalArgumentException if user not found
     * @throws AccessControlService.AccessDeniedException if not authorized
     */
    public User execute(UpdateUserCommand command) {
        log.info("Updating user: {}", command.getUserId());

        // Find the user performing the update
        User updater = userRepository.findById(command.getUpdatedBy())
                .orElseThrow(() -> new IllegalArgumentException("Updater not found"));

        // Find the user to update
        User userToUpdate = userRepository.findById(command.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        // Check permissions - users can update themselves, admins can update users they manage
        if (!canUpdate(updater, userToUpdate)) {
            throw new AccessControlService.AccessDeniedException("Not authorized to update this user");
        }

        // Apply updates
        if (command.getName() != null) {
            userToUpdate.setName(command.getName());
        }
        if (command.getEmail() != null) {
            // Check if email is already taken
            userRepository.findByEmail(command.getEmail())
                    .filter(u -> !u.getId().equals(userToUpdate.getId()))
                    .ifPresent(u -> {
                        throw new IllegalStateException("Email already in use");
                    });
            userToUpdate.setEmail(command.getEmail());
        }

        User saved = userRepository.save(userToUpdate);
        log.info("User {} updated successfully", saved.getId());
        return saved;
    }

    private boolean canUpdate(User updater, User target) {
        // Users can update themselves
        if (updater.getId().equals(target.getId())) {
            return true;
        }
        // Super admin can update anyone
        if (updater.isSuperAdmin()) {
            return true;
        }
        // Admins cannot update other admins or super admins
        return false;
    }

    /**
     * Command object for updating a user
     */
    public static class UpdateUserCommand {
        private final UUID userId;
        private final UUID updatedBy;
        private final String name;
        private final String email;

        public UpdateUserCommand(UUID userId, UUID updatedBy, String name, String email) {
            this.userId = userId;
            this.updatedBy = updatedBy;
            this.name = name;
            this.email = email;
        }

        public UUID getUserId() {
            return userId;
        }

        public UUID getUpdatedBy() {
            return updatedBy;
        }

        public String getName() {
            return name;
        }

        public String getEmail() {
            return email;
        }
    }
}
