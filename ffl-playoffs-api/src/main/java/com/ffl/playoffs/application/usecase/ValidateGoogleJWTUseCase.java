package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.model.User;
import com.ffl.playoffs.domain.port.UserRepository;
import com.ffl.playoffs.infrastructure.auth.GoogleJwtValidator;
import com.ffl.playoffs.infrastructure.auth.GoogleJwtClaims;

/**
 * Use case for validating Google JWT tokens and creating/updating user accounts
 * Handles OAuth authentication flow
 */
public class ValidateGoogleJWTUseCase {

    private final GoogleJwtValidator jwtValidator;
    private final UserRepository userRepository;

    public ValidateGoogleJWTUseCase(GoogleJwtValidator jwtValidator, UserRepository userRepository) {
        this.jwtValidator = jwtValidator;
        this.userRepository = userRepository;
    }

    /**
     * Validates a Google JWT token and returns authenticated user
     * Creates a new user account if this is first login
     *
     * @param command The JWT validation command
     * @return ValidationResult with user and authentication status
     * @throws IllegalArgumentException if token is invalid
     */
    public ValidationResult execute(ValidateJWTCommand command) {
        // Validate JWT and extract claims
        GoogleJwtClaims claims = jwtValidator.validate(command.getToken());

        // Find or create user
        User user = userRepository.findByGoogleId(claims.getGoogleId())
                .orElseGet(() -> createNewUser(claims));

        // Update last login
        user.updateLastLogin();
        user = userRepository.save(user);

        return new ValidationResult(user, true, "Authentication successful");
    }

    private User createNewUser(GoogleJwtClaims claims) {
        // New users get PLAYER role by default
        // Admin/SuperAdmin roles must be assigned by existing SuperAdmin
        User newUser = new User(
                claims.getEmail(),
                claims.getName(),
                claims.getGoogleId(),
                Role.PLAYER
        );

        return userRepository.save(newUser);
    }

    /**
     * Command object for JWT validation
     */
    public static class ValidateJWTCommand {
        private final String token;

        public ValidateJWTCommand(String token) {
            this.token = token;
        }

        public String getToken() {
            return token;
        }
    }

    /**
     * Result object containing validation outcome
     */
    public static class ValidationResult {
        private final User user;
        private final boolean valid;
        private final String message;

        public ValidationResult(User user, boolean valid, String message) {
            this.user = user;
            this.valid = valid;
            this.message = message;
        }

        public User getUser() {
            return user;
        }

        public boolean isValid() {
            return valid;
        }

        public String getMessage() {
            return message;
        }
    }
}
