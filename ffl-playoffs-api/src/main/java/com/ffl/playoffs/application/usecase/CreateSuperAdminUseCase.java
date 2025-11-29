package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.model.User;
import com.ffl.playoffs.domain.port.UserRepository;

import java.util.Optional;

/**
 * Use case for creating the first super admin account via bootstrap PAT
 * This endpoint can ONLY be accessed with a valid bootstrap PAT (ADMIN scope)
 * Used to create the first super admin account when the system is newly deployed
 */
public class CreateSuperAdminUseCase {

    private final UserRepository userRepository;

    public CreateSuperAdminUseCase(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    /**
     * Creates the first super admin account
     *
     * @param command The create super admin command
     * @return CreateSuperAdminResult with the created user
     * @throws IllegalArgumentException if user input is invalid
     * @throws IllegalStateException if user with email/googleId already exists
     */
    public CreateSuperAdminResult execute(CreateSuperAdminCommand command) {
        // Validate inputs
        validateCommand(command);

        // Check if user with email already exists
        Optional<User> existingUserByEmail = userRepository.findByEmail(command.getEmail());
        if (existingUserByEmail.isPresent()) {
            throw new IllegalStateException("User with email '" + command.getEmail() + "' already exists");
        }

        // Check if user with googleId already exists
        Optional<User> existingUserByGoogleId = userRepository.findByGoogleId(command.getGoogleId());
        if (existingUserByGoogleId.isPresent()) {
            throw new IllegalStateException("User with Google ID '" + command.getGoogleId() + "' already exists");
        }

        // Create the super admin user
        User superAdmin = new User(
                command.getEmail(),
                command.getName() != null ? command.getName() : extractNameFromEmail(command.getEmail()),
                command.getGoogleId(),
                Role.SUPER_ADMIN
        );

        // Save the user
        User savedUser = userRepository.save(superAdmin);

        return new CreateSuperAdminResult(
                savedUser.getId(),
                savedUser.getEmail(),
                savedUser.getName(),
                savedUser.getGoogleId(),
                savedUser.getRole(),
                savedUser.getCreatedAt()
        );
    }

    /**
     * Validates the create super admin command inputs
     */
    private void validateCommand(CreateSuperAdminCommand command) {
        if (command.getEmail() == null || command.getEmail().trim().isEmpty()) {
            throw new IllegalArgumentException("Email cannot be empty");
        }

        // Basic email format validation
        if (!command.getEmail().contains("@")) {
            throw new IllegalArgumentException("Invalid email format");
        }

        if (command.getGoogleId() == null || command.getGoogleId().trim().isEmpty()) {
            throw new IllegalArgumentException("Google ID cannot be empty");
        }
    }

    /**
     * Extracts a name from email address (before @)
     * Used as fallback if name is not provided
     */
    private String extractNameFromEmail(String email) {
        int atIndex = email.indexOf('@');
        if (atIndex > 0) {
            return email.substring(0, atIndex);
        }
        return email;
    }

    /**
     * Command object for creating a super admin
     */
    public static class CreateSuperAdminCommand {
        private final String email;
        private final String googleId;
        private final String name;

        public CreateSuperAdminCommand(String email, String googleId, String name) {
            this.email = email;
            this.googleId = googleId;
            this.name = name;
        }

        public String getEmail() {
            return email;
        }

        public String getGoogleId() {
            return googleId;
        }

        public String getName() {
            return name;
        }
    }

    /**
     * Result object containing created super admin user
     */
    public static class CreateSuperAdminResult {
        private final java.util.UUID id;
        private final String email;
        private final String name;
        private final String googleId;
        private final Role role;
        private final java.time.LocalDateTime createdAt;

        public CreateSuperAdminResult(java.util.UUID id, String email, String name,
                                     String googleId, Role role, java.time.LocalDateTime createdAt) {
            this.id = id;
            this.email = email;
            this.name = name;
            this.googleId = googleId;
            this.role = role;
            this.createdAt = createdAt;
        }

        public java.util.UUID getId() {
            return id;
        }

        public String getEmail() {
            return email;
        }

        public String getName() {
            return name;
        }

        public String getGoogleId() {
            return googleId;
        }

        public Role getRole() {
            return role;
        }

        public java.time.LocalDateTime getCreatedAt() {
            return createdAt;
        }
    }
}
