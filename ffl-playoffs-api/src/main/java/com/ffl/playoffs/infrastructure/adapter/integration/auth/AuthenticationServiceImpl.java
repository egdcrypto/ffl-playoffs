package com.ffl.playoffs.infrastructure.adapter.integration.auth;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.domain.model.auth.AuthToken;
import com.ffl.playoffs.domain.model.auth.AuthenticationContext;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import com.ffl.playoffs.domain.service.AuthenticationService;
import com.ffl.playoffs.infrastructure.auth.GoogleJwtClaims;
import com.ffl.playoffs.infrastructure.auth.GoogleJwtValidator;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

/**
 * Implementation of AuthenticationService.
 * Delegates to GoogleJwtValidator for JWT validation and handles PAT validation.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AuthenticationServiceImpl implements AuthenticationService {

    private final GoogleJwtValidator googleJwtValidator;
    private final UserRepository userRepository;
    private final PersonalAccessTokenRepository patRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    @Override
    public AuthenticationContext authenticate(AuthToken token) {
        if (token.isPAT()) {
            return authenticatePAT(token.getRawToken());
        } else {
            return authenticateGoogleJwt(token.getRawToken());
        }
    }

    @Override
    public AuthenticationContext authenticateGoogleJwt(String jwtToken) {
        log.debug("Authenticating Google JWT token");

        try {
            // Validate JWT and extract claims
            GoogleJwtClaims claims = googleJwtValidator.validateAndExtractClaims(jwtToken);

            if (claims == null) {
                return AuthenticationContext.failure("Invalid or expired JWT token");
            }

            // Find user by Google ID
            Optional<User> userOpt = userRepository.findByGoogleId(claims.getGoogleId());

            if (userOpt.isEmpty()) {
                log.warn("No user found for Google ID: {}", claims.getGoogleId());
                return AuthenticationContext.failure("User not registered");
            }

            User user = userOpt.get();

            // Check if user is active
            if (!user.isActive()) {
                log.warn("Inactive user attempted login: {}", user.getEmail());
                return AuthenticationContext.failure("User account is deactivated");
            }

            // Update last login
            user.updateLastLogin();
            userRepository.save(user);

            log.info("Successfully authenticated user: {}", user.getEmail());
            return AuthenticationContext.forUser(user);

        } catch (Exception e) {
            log.error("JWT authentication error", e);
            return AuthenticationContext.failure("Authentication error: " + e.getMessage());
        }
    }

    @Override
    public AuthenticationContext authenticatePAT(String patToken) {
        log.debug("Authenticating PAT token");

        try {
            // Extract identifier from PAT (format: pat_<identifier>_<secret>)
            if (!patToken.startsWith("pat_")) {
                return AuthenticationContext.failure("Invalid PAT format");
            }

            String tokenBody = patToken.substring(4); // Remove "pat_" prefix
            int lastUnderscore = tokenBody.lastIndexOf('_');

            if (lastUnderscore == -1) {
                return AuthenticationContext.failure("Invalid PAT format");
            }

            String tokenIdentifier = tokenBody.substring(0, lastUnderscore);

            // Find PAT by identifier
            Optional<PersonalAccessToken> patOpt = patRepository.findByTokenIdentifier(tokenIdentifier);

            if (patOpt.isEmpty()) {
                log.warn("PAT not found for identifier: {}", tokenIdentifier);
                return AuthenticationContext.failure("Invalid PAT");
            }

            PersonalAccessToken pat = patOpt.get();

            // Verify token hash
            if (!passwordEncoder.matches(patToken, pat.getTokenHash())) {
                log.warn("PAT hash mismatch for: {}", pat.getName());
                return AuthenticationContext.failure("Invalid PAT");
            }

            // Check if PAT is valid
            if (!pat.isValid()) {
                if (pat.isRevoked()) {
                    log.warn("Revoked PAT used: {}", pat.getName());
                    return AuthenticationContext.failure("PAT has been revoked");
                }
                if (pat.isExpired()) {
                    log.warn("Expired PAT used: {}", pat.getName());
                    return AuthenticationContext.failure("PAT has expired");
                }
                return AuthenticationContext.failure("Invalid PAT");
            }

            // Update last used timestamp
            pat.updateLastUsed();
            patRepository.save(pat);

            log.info("Successfully authenticated PAT: {}", pat.getName());
            return AuthenticationContext.forPAT(pat);

        } catch (Exception e) {
            log.error("PAT authentication error", e);
            return AuthenticationContext.failure("Authentication error: " + e.getMessage());
        }
    }

    @Override
    public boolean isAvailable() {
        return true;
    }
}
