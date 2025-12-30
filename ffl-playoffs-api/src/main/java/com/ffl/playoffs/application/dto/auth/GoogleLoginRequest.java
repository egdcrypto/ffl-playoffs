package com.ffl.playoffs.application.dto.auth;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Request DTO for Google OAuth login
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GoogleLoginRequest {

    @NotBlank(message = "Google ID token is required")
    private String idToken;
}
