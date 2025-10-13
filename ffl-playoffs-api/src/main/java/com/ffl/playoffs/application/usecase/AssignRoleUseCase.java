package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.model.User;
import com.ffl.playoffs.domain.port.UserRepository;

import java.util.UUID;

/**
 * Use case for assigning or changing a user's role
 * Only SUPER_ADMIN can assign roles
 */
public class AssignRoleUseCase {

    private final UserRepository userRepository;

    public AssignRoleUseCase(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    /**
     * Assigns a role to a user
     *
     * @param command The assign role command
     * @return The updated User
     * @throws IllegalArgumentException if user not found
     * @throws IllegalStateException if assigner is not authorized
     */
    public User execute(AssignRoleCommand command) {
        // Find the user to update
        User user = userRepository.findById(command.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        // Find the user performing the action
        User assigner = userRepository.findById(command.getAssignedBy())
                .orElseThrow(() -> new IllegalArgumentException("Assigner not found"));

        // Validate assigner has permission
        if (!assigner.isSuperAdmin()) {
            throw new IllegalStateException("Only SUPER_ADMIN can assign roles");
        }

        // Assign new role
        user.setRole(command.getNewRole());

        // Save and return
        return userRepository.save(user);
    }

    /**
     * Command object for assigning a role
     */
    public static class AssignRoleCommand {
        private final UUID userId;
        private final Role newRole;
        private final UUID assignedBy;

        public AssignRoleCommand(UUID userId, Role newRole, UUID assignedBy) {
            this.userId = userId;
            this.newRole = newRole;
            this.assignedBy = assignedBy;
        }

        public UUID getUserId() {
            return userId;
        }

        public Role getNewRole() {
            return newRole;
        }

        public UUID getAssignedBy() {
            return assignedBy;
        }
    }
}
