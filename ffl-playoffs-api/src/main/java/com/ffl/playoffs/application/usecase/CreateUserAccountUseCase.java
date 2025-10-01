package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.model.User;
import com.ffl.playoffs.domain.port.UserRepository;

/**
 * Use case for creating a new user account
 * Used for manual user creation by administrators
 */
public class CreateUserAccountUseCase {

    private final UserRepository userRepository;

    public CreateUserAccountUseCase(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    /**
     * Creates a new user account
     *
     * @param command The create user command
     * @return The newly created User
     * @throws IllegalStateException if user with email or Google ID already exists
     */
    public User execute(CreateUserCommand command) {
        // Check if user already exists by email
        if (userRepository.findByEmail(command.getEmail()).isPresent()) {
            throw new IllegalStateException("User with email already exists: " + command.getEmail());
        }

        // Check if Google ID is provided and not already used
        if (command.getGoogleId() != null && userRepository.existsByGoogleId(command.getGoogleId())) {
            throw new IllegalStateException("User with Google ID already exists");
        }

        // Create new user
        User user = new User(
                command.getEmail(),
                command.getName(),
                command.getGoogleId(),
                command.getRole() != null ? command.getRole() : Role.PLAYER
        );

        // Save and return
        return userRepository.save(user);
    }

    /**
     * Command object for creating a user
     */
    public static class CreateUserCommand {
        private final String email;
        private final String name;
        private final String googleId;
        private final Role role;

        public CreateUserCommand(String email, String name, String googleId, Role role) {
            this.email = email;
            this.name = name;
            this.googleId = googleId;
            this.role = role;
        }

        public CreateUserCommand(String email, String name, String googleId) {
            this(email, name, googleId, Role.PLAYER);
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
    }
}
