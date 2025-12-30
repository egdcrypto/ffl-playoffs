package com.ffl.playoffs.application.dto.auth;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

/**
 * Response DTO for token validation (used by Envoy ext_authz)
 * Returns minimal information needed for authorization decisions
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TokenValidationResponse {

    private boolean valid;
    private UUID userId;
    private String email;
    private String role;
    private String error;

    public static TokenValidationResponse valid(UUID userId, String email, String role) {
        return TokenValidationResponse.builder()
                .valid(true)
                .userId(userId)
                .email(email)
                .role(role)
                .build();
    }

    public static TokenValidationResponse invalid(String error) {
        return TokenValidationResponse.builder()
                .valid(false)
                .error(error)
                .build();
    }
}
