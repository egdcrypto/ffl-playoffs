package com.ffl.playoffs.application.dto.auth;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Response DTO containing current user information
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserInfoResponse {

    private UUID id;
    private String email;
    private String name;
    private String role;
    private LocalDateTime createdAt;
    private LocalDateTime lastLoginAt;
    private boolean active;
}
