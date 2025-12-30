package com.ffl.playoffs.application.dto.auth;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Response DTO containing JWT tokens after successful authentication
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TokenResponse {

    private String accessToken;
    private String refreshToken;
    private String tokenType;
    private long expiresIn;

    public static TokenResponse of(String accessToken, String refreshToken, long expiresIn) {
        return TokenResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .tokenType("Bearer")
                .expiresIn(expiresIn)
                .build();
    }
}
