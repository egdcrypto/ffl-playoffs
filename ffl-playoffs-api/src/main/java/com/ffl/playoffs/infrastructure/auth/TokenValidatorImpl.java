package com.ffl.playoffs.infrastructure.auth;

import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Implementation of TokenValidator
 * Delegates to specific validators for Google JWT and PAT tokens
 */
@Component
public class TokenValidatorImpl implements TokenValidator {

    private static final Logger logger = LoggerFactory.getLogger(TokenValidatorImpl.class);

    private final GoogleJwtValidator googleJwtValidator;
    private final PATValidator patValidator;
    private final UserRepository userRepository;
    private final PersonalAccessTokenRepository patRepository;

    @Autowired
    public TokenValidatorImpl(
            GoogleJwtValidator googleJwtValidator,
            PATValidator patValidator,
            UserRepository userRepository,
            PersonalAccessTokenRepository patRepository) {
        this.googleJwtValidator = googleJwtValidator;
        this.patValidator = patValidator;
        this.userRepository = userRepository;
        this.patRepository = patRepository;
    }

    @Override
    public AuthenticationResult validateGoogleJWT(String token) {
        logger.debug("Validating Google JWT token");

        try {
            // Validate JWT signature and claims
            GoogleJwtClaims claims = googleJwtValidator.validateAndExtractClaims(token);
            if (claims == null) {
                return AuthenticationResult.failure("Invalid JWT token");
            }

            // Find user by Google ID
            User user = userRepository.findByGoogleId(claims.getGoogleId())
                    .orElse(null);

            if (user == null) {
                logger.warn("User not found for Google ID: {}", claims.getGoogleId());
                return AuthenticationResult.failure("User not found");
            }

            if (!user.isActive()) {
                logger.warn("User account is deactivated: {}", user.getEmail());
                return AuthenticationResult.failure("User account is deactivated");
            }

            // Update last login timestamp
            user.updateLastLogin();
            userRepository.save(user);

            logger.info("Google JWT validation successful for user: {}", user.getEmail());
            return AuthenticationResult.success(user);

        } catch (Exception e) {
            logger.error("Google JWT validation error", e);
            return AuthenticationResult.failure("JWT validation failed: " + e.getMessage());
        }
    }

    @Override
    public AuthenticationResult validatePAT(String token) {
        logger.debug("Validating PAT token");

        try {
            // Validate PAT format: pat_<identifier>_<random>
            if (!token.startsWith("pat_")) {
                return AuthenticationResult.failure("Invalid PAT format");
            }

            // Extract token identifier (second part after pat_)
            String tokenIdentifier = patValidator.extractTokenIdentifier(token);
            if (tokenIdentifier == null) {
                return AuthenticationResult.failure("Invalid PAT format");
            }

            // Find PAT by identifier
            PersonalAccessToken pat = patRepository.findByTokenIdentifier(tokenIdentifier)
                    .orElse(null);

            if (pat == null) {
                logger.warn("PAT not found in database for identifier: {}", tokenIdentifier);
                return AuthenticationResult.failure("Invalid PAT token");
            }

            // Verify token against stored hash using bcrypt
            if (!patValidator.verifyToken(token, pat.getTokenHash())) {
                logger.warn("PAT token verification failed");
                return AuthenticationResult.failure("Invalid PAT token");
            }

            // Validate PAT is not revoked or expired
            try {
                pat.validateOrThrow();
            } catch (PersonalAccessToken.InvalidTokenException e) {
                logger.warn("PAT validation failed: {}", e.getMessage());
                return AuthenticationResult.failure(e.getMessage());
            }

            // Update last used timestamp
            pat.updateLastUsed();
            patRepository.save(pat);

            logger.info("PAT validation successful for: {}", pat.getName());
            return AuthenticationResult.success(pat);

        } catch (Exception e) {
            logger.error("PAT validation error", e);
            return AuthenticationResult.failure("PAT validation failed: " + e.getMessage());
        }
    }
}
