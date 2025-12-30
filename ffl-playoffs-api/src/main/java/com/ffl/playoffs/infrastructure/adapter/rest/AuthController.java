package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.auth.*;
import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.port.UserRepository;
import com.ffl.playoffs.infrastructure.auth.AuthenticationResult;
import com.ffl.playoffs.infrastructure.auth.JwtTokenService;
import com.ffl.playoffs.infrastructure.auth.TokenValidator;
import io.jsonwebtoken.Claims;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

/**
 * Authentication Controller
 * Handles Google OAuth login, token validation, refresh, and user info endpoints
 */
@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
@Tag(name = "Authentication", description = "APIs for user authentication and token management")
public class AuthController {

    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);

    private final TokenValidator tokenValidator;
    private final JwtTokenService jwtTokenService;
    private final UserRepository userRepository;

    /**
     * Google OAuth login endpoint
     * Validates Google ID token and issues application JWT tokens
     */
    @PostMapping("/google/login")
    @Operation(summary = "Login with Google OAuth",
               description = "Validates Google ID token and returns application access and refresh tokens")
    public ResponseEntity<TokenResponse> googleLogin(@Valid @RequestBody GoogleLoginRequest request) {
        logger.debug("Processing Google OAuth login");

        AuthenticationResult result = tokenValidator.validateGoogleJWT(request.getIdToken());

        if (!result.isAuthenticated()) {
            logger.warn("Google OAuth login failed: {}", result.getErrorMessage());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        User user = result.getUser();
        if (user == null) {
            logger.error("Authentication succeeded but user is null");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }

        // Generate application JWT tokens
        String accessToken = jwtTokenService.generateAccessToken(user);
        String refreshToken = jwtTokenService.generateRefreshToken(user);

        logger.info("Google OAuth login successful for user: {}", user.getEmail());

        return ResponseEntity.ok(TokenResponse.of(
                accessToken,
                refreshToken,
                jwtTokenService.getAccessTokenExpirationSeconds()
        ));
    }

    /**
     * Token validation endpoint for Envoy ext_authz
     * Validates both application JWT tokens and PAT tokens
     */
    @GetMapping("/validate-token")
    @Operation(summary = "Validate token",
               description = "Validates access token or PAT for Envoy ext_authz integration")
    public ResponseEntity<TokenValidationResponse> validateToken(
            @RequestHeader(value = "Authorization", required = false) String authHeader) {

        if (authHeader == null || authHeader.isBlank()) {
            logger.debug("No authorization header provided");
            return ResponseEntity.ok(TokenValidationResponse.invalid("No authorization header"));
        }

        String token = extractToken(authHeader);
        if (token == null) {
            logger.debug("Invalid authorization header format");
            return ResponseEntity.ok(TokenValidationResponse.invalid("Invalid authorization header format"));
        }

        // Check if it's a PAT token
        if (token.startsWith("pat_")) {
            return validatePATToken(token);
        }

        // Otherwise, treat as application JWT
        return validateJwtToken(token);
    }

    /**
     * Token refresh endpoint
     * Exchanges a valid refresh token for new access and refresh tokens
     */
    @PostMapping("/refresh")
    @Operation(summary = "Refresh tokens",
               description = "Exchanges a valid refresh token for new access and refresh tokens")
    public ResponseEntity<TokenResponse> refreshToken(@Valid @RequestBody RefreshTokenRequest request) {
        logger.debug("Processing token refresh request");

        Claims claims = jwtTokenService.validateRefreshToken(request.getRefreshToken());
        if (claims == null) {
            logger.warn("Invalid or expired refresh token");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        UUID userId = jwtTokenService.extractUserId(claims);
        User user = userRepository.findById(userId).orElse(null);

        if (user == null) {
            logger.warn("User not found for refresh token: {}", userId);
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        if (!user.isActive()) {
            logger.warn("User account is deactivated: {}", user.getEmail());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        // Generate new tokens
        String accessToken = jwtTokenService.generateAccessToken(user);
        String refreshToken = jwtTokenService.generateRefreshToken(user);

        logger.info("Token refresh successful for user: {}", user.getEmail());

        return ResponseEntity.ok(TokenResponse.of(
                accessToken,
                refreshToken,
                jwtTokenService.getAccessTokenExpirationSeconds()
        ));
    }

    /**
     * Get current user info endpoint
     * Returns information about the currently authenticated user
     */
    @GetMapping("/me")
    @Operation(summary = "Get current user info",
               description = "Returns information about the currently authenticated user",
               security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<UserInfoResponse> getCurrentUser(
            @RequestHeader(value = "Authorization", required = false) String authHeader) {

        if (authHeader == null || authHeader.isBlank()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        String token = extractToken(authHeader);
        if (token == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        // Validate JWT token
        Claims claims = jwtTokenService.validateAccessToken(token);
        if (claims == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        UUID userId = jwtTokenService.extractUserId(claims);
        User user = userRepository.findById(userId).orElse(null);

        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        return ResponseEntity.ok(UserInfoResponse.builder()
                .id(user.getId())
                .email(user.getEmail())
                .name(user.getName())
                .role(user.getRole() != null ? user.getRole().name() : null)
                .createdAt(user.getCreatedAt())
                .lastLoginAt(user.getLastLoginAt())
                .active(user.isActive())
                .build());
    }

    private String extractToken(String authHeader) {
        if (authHeader.startsWith("Bearer ")) {
            return authHeader.substring(7);
        }
        // Also support direct token for PAT
        if (authHeader.startsWith("pat_")) {
            return authHeader;
        }
        return null;
    }

    private ResponseEntity<TokenValidationResponse> validatePATToken(String token) {
        AuthenticationResult result = tokenValidator.validatePAT(token);

        if (!result.isAuthenticated()) {
            logger.debug("PAT validation failed: {}", result.getErrorMessage());
            return ResponseEntity.ok(TokenValidationResponse.invalid(result.getErrorMessage()));
        }

        // For PAT, we return the PAT name as identifier
        // The PAT has an associated user that can be used for authorization
        if (result.getPat() != null) {
            var pat = result.getPat();
            UUID userId = null;
            // Try to parse createdBy as UUID (user ID)
            if (pat.getCreatedBy() != null && !"SYSTEM".equals(pat.getCreatedBy())) {
                try {
                    userId = UUID.fromString(pat.getCreatedBy());
                } catch (IllegalArgumentException e) {
                    logger.debug("PAT createdBy is not a valid UUID: {}", pat.getCreatedBy());
                }
            }
            return ResponseEntity.ok(TokenValidationResponse.builder()
                    .valid(true)
                    .userId(userId)
                    .email(pat.getName()) // Using PAT name as identifier
                    .role("PAT") // Indicate this is a PAT authentication
                    .build());
        }

        return ResponseEntity.ok(TokenValidationResponse.invalid("PAT validation failed"));
    }

    private ResponseEntity<TokenValidationResponse> validateJwtToken(String token) {
        Claims claims = jwtTokenService.validateAccessToken(token);

        if (claims == null) {
            logger.debug("JWT validation failed");
            return ResponseEntity.ok(TokenValidationResponse.invalid("Invalid or expired token"));
        }

        UUID userId = jwtTokenService.extractUserId(claims);
        String email = claims.get("email", String.class);
        String role = claims.get("role", String.class);

        return ResponseEntity.ok(TokenValidationResponse.valid(userId, email, role));
    }
}
