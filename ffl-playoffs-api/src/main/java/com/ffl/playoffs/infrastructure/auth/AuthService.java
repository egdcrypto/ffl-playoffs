package com.ffl.playoffs.infrastructure.auth;

import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.domain.aggregate.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * Authentication service for Envoy ext_authz protocol
 * Listens on localhost:9191 and validates Google JWT and PAT tokens
 *
 * This service is called by Envoy's External Authorization (ext_authz) filter
 * for every incoming request. It validates the token and returns user/service
 * context headers that Envoy forwards to the main API.
 */
@RestController
@RequestMapping("/auth")
public class AuthService {

    private static final Logger logger = LoggerFactory.getLogger(AuthService.class);
    private static final String AUTHORIZATION_HEADER = "Authorization";
    private static final String BEARER_PREFIX = "Bearer ";
    private static final String PAT_PREFIX = "pat_";

    private final TokenValidator tokenValidator;

    @Autowired
    public AuthService(TokenValidator tokenValidator) {
        this.tokenValidator = tokenValidator;
    }

    /**
     * Main authorization endpoint called by Envoy ext_authz filter
     *
     * Envoy sends the original request headers here for validation.
     * Returns HTTP 200 with context headers if authorized, or HTTP 403 if forbidden.
     *
     * @param headers All headers from the original request
     * @return ResponseEntity with authorization decision and context headers
     */
    @PostMapping("/check")
    public ResponseEntity<Map<String, String>> checkAuthorization(
            @RequestHeader Map<String, String> headers) {

        logger.debug("Auth check request received with headers: {}", headers.keySet());

        try {
            // Extract Authorization header
            String authHeader = extractAuthHeader(headers);
            if (authHeader == null) {
                logger.warn("Missing Authorization header");
                return unauthorized("Missing authentication token");
            }

            // Extract token from Bearer scheme
            String token = extractToken(authHeader);
            if (token == null) {
                logger.warn("Malformed Authorization header");
                return forbidden("Malformed Authorization header");
            }

            // Detect token type and validate
            AuthenticationResult result;
            if (token.startsWith(PAT_PREFIX)) {
                logger.debug("Detected PAT token");
                result = tokenValidator.validatePAT(token);
            } else {
                logger.debug("Detected Google JWT token");
                result = tokenValidator.validateGoogleJWT(token);
            }

            if (result.isAuthenticated()) {
                logger.info("Authentication successful for: {}", result.getIdentifier());
                return authorized(result);
            } else {
                logger.warn("Authentication failed: {}", result.getErrorMessage());
                return forbidden(result.getErrorMessage());
            }

        } catch (Exception e) {
            logger.error("Authentication error", e);
            return forbidden("Authentication error: " + e.getMessage());
        }
    }

    /**
     * Health check endpoint
     * @return OK if service is running
     */
    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> health() {
        Map<String, String> response = new HashMap<>();
        response.put("status", "UP");
        response.put("service", "auth-service");
        return ResponseEntity.ok(response);
    }

    /**
     * Extracts Authorization header from request headers (case-insensitive)
     */
    private String extractAuthHeader(Map<String, String> headers) {
        // Check case-insensitive
        for (Map.Entry<String, String> entry : headers.entrySet()) {
            if (entry.getKey().equalsIgnoreCase(AUTHORIZATION_HEADER)) {
                return entry.getValue();
            }
        }
        return null;
    }

    /**
     * Extracts token from Bearer scheme
     * Expects format: "Bearer <token>"
     */
    private String extractToken(String authHeader) {
        if (authHeader == null || !authHeader.startsWith(BEARER_PREFIX)) {
            return null;
        }
        String token = authHeader.substring(BEARER_PREFIX.length()).trim();
        return token.isEmpty() ? null : token;
    }

    /**
     * Returns authorized response with user/service context headers
     */
    private ResponseEntity<Map<String, String>> authorized(AuthenticationResult result) {
        Map<String, String> headers = new HashMap<>();

        if (result.getUser() != null) {
            // Google OAuth user authentication
            User user = result.getUser();
            headers.put("X-User-Id", user.getId().toString());
            headers.put("X-User-Email", user.getEmail());
            headers.put("X-User-Role", user.getRole().name());
            headers.put("X-Google-Id", user.getGoogleId());
            headers.put("X-Auth-Type", "USER");
        } else if (result.getPat() != null) {
            // PAT service authentication
            PersonalAccessToken pat = result.getPat();
            headers.put("X-Service-Id", pat.getName());
            headers.put("X-PAT-Scope", pat.getScope().name());
            headers.put("X-PAT-Id", pat.getId().toString());
            headers.put("X-Auth-Type", "PAT");
        }

        logger.debug("Authorized with headers: {}", headers);
        return ResponseEntity.ok(headers);
    }

    /**
     * Returns unauthorized response (401)
     */
    private ResponseEntity<Map<String, String>> unauthorized(String message) {
        Map<String, String> body = new HashMap<>();
        body.put("error", "Unauthorized");
        body.put("message", message);
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(body);
    }

    /**
     * Returns forbidden response (403)
     * Envoy will convert this to 401 for the client
     */
    private ResponseEntity<Map<String, String>> forbidden(String message) {
        Map<String, String> body = new HashMap<>();
        body.put("error", "Forbidden");
        body.put("message", message);
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(body);
    }
}
