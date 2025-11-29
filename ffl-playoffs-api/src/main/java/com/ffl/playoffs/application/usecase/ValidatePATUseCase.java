package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.PATScope;
import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.domain.model.User;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;
import com.ffl.playoffs.domain.port.UserRepository;

/**
 * Use case for validating Personal Access Tokens
 * Checks token validity, expiration, and scope
 */
public class ValidatePATUseCase {

    private final PersonalAccessTokenRepository tokenRepository;
    private final UserRepository userRepository;

    public ValidatePATUseCase(
            PersonalAccessTokenRepository tokenRepository,
            UserRepository userRepository) {
        this.tokenRepository = tokenRepository;
        this.userRepository = userRepository;
    }

    /**
     * Validates a PAT and returns validation result
     * Updates last used timestamp if valid
     *
     * @param command The PAT validation command
     * @return ValidationResult with token validity and user context
     * @throws IllegalArgumentException if token not found
     */
    public ValidationResult execute(ValidatePATCommand command) {
        // Extract token identifier from full token (first part before the secret)
        String tokenIdentifier = extractTokenIdentifier(command.getToken());

        // Find PAT by identifier
        PersonalAccessToken pat = tokenRepository.findByTokenIdentifier(tokenIdentifier)
                .orElseThrow(() -> new IllegalArgumentException("Invalid token"));

        // Validate token (checks expiration and revoked status)
        try {
            pat.validateOrThrow();
        } catch (PersonalAccessToken.InvalidTokenException e) {
            return new ValidationResult(null, null, false, e.getMessage(), null);
        }

        // Check if required scope is met (if specified)
        if (command.getRequiredScope() != null && !pat.hasScope(command.getRequiredScope())) {
            return new ValidationResult(
                    pat,
                    null,
                    false,
                    "Insufficient scope. Required: " + command.getRequiredScope() + ", Has: " + pat.getScope(),
                    pat.getScope()
            );
        }

        // Update last used timestamp
        pat.updateLastUsed();
        tokenRepository.save(pat);

        // Get user who created this PAT (if not SYSTEM)
        User user = null;
        if (!"SYSTEM".equals(pat.getCreatedBy())) {
            user = userRepository.findById(java.util.UUID.fromString(pat.getCreatedBy()))
                    .orElse(null);
        }

        return new ValidationResult(pat, user, true, "Token is valid", pat.getScope());
    }

    private String extractTokenIdentifier(String fullToken) {
        // PAT format: pat_<identifier>_<secret>
        // We need to extract the identifier part
        if (!fullToken.startsWith("pat_")) {
            throw new IllegalArgumentException("Invalid PAT format");
        }

        String[] parts = fullToken.split("_", 3);
        if (parts.length < 2) {
            throw new IllegalArgumentException("Invalid PAT format");
        }

        return parts[1];  // Return the identifier part
    }

    /**
     * Command object for PAT validation
     */
    public static class ValidatePATCommand {
        private final String token;
        private final PATScope requiredScope;

        public ValidatePATCommand(String token) {
            this(token, null);
        }

        public ValidatePATCommand(String token, PATScope requiredScope) {
            this.token = token;
            this.requiredScope = requiredScope;
        }

        public String getToken() {
            return token;
        }

        public PATScope getRequiredScope() {
            return requiredScope;
        }
    }

    /**
     * Result object containing validation outcome
     */
    public static class ValidationResult {
        private final PersonalAccessToken token;
        private final User user;
        private final boolean valid;
        private final String message;
        private final PATScope scope;

        public ValidationResult(PersonalAccessToken token, User user, boolean valid,
                              String message, PATScope scope) {
            this.token = token;
            this.user = user;
            this.valid = valid;
            this.message = message;
            this.scope = scope;
        }

        public PersonalAccessToken getToken() {
            return token;
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

        public PATScope getScope() {
            return scope;
        }
    }
}
