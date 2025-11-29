package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.usecase.*;
import com.ffl.playoffs.domain.model.PATScope;
import com.ffl.playoffs.domain.model.Role;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;

/**
 * SuperAdmin REST API
 * Provides endpoints for system-wide administration
 * Only accessible by users with SUPER_ADMIN role
 */
@RestController
@RequestMapping("/api/v1/superadmin")
@RequiredArgsConstructor
@Tag(name = "SuperAdmin", description = "System administration APIs for super admins")
@SecurityRequirement(name = "bearer-jwt")
public class SuperAdminController {

    private final InviteAdminUseCase inviteAdminUseCase;
    private final CreateSuperAdminUseCase createSuperAdminUseCase;
    private final CreatePATUseCase createPATUseCase;
    private final ListPATsUseCase listPATsUseCase;
    private final RevokePATUseCase revokePATUseCase;
    private final RotatePATUseCase rotatePATUseCase;
    private final DeletePATUseCase deletePATUseCase;
    // TODO: Inject other use cases when implemented:
    // - RevokeAdminUseCase
    // - ListAdminsUseCase
    // - ListAllLeaguesUseCase

    // ========================
    // Bootstrap Setup
    // ========================

    @PostMapping("/bootstrap")
    @Operation(
            summary = "Create first super admin",
            description = "Creates the first super admin account using bootstrap PAT. " +
                    "This endpoint requires a valid bootstrap PAT with ADMIN scope. " +
                    "Used for initial system setup only."
    )
    public ResponseEntity<CreateSuperAdminResponse> createSuperAdmin(
            @RequestBody CreateSuperAdminRequest request) {

        // NOTE: Authentication is handled by Envoy using the bootstrap PAT
        // The request will only reach here if the PAT is valid and has ADMIN scope

        CreateSuperAdminUseCase.CreateSuperAdminCommand command =
                new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                        request.getEmail(),
                        request.getGoogleId(),
                        request.getName()
                );

        CreateSuperAdminUseCase.CreateSuperAdminResult result = createSuperAdminUseCase.execute(command);

        CreateSuperAdminResponse response = new CreateSuperAdminResponse(
                result.getId(),
                result.getEmail(),
                result.getName(),
                result.getGoogleId(),
                result.getRole().toString(),
                result.getCreatedAt(),
                "First super admin account created successfully. " +
                        "Please revoke the bootstrap PAT and create a new PAT for ongoing operations."
        );

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    // ========================
    // Admin Management
    // ========================

    @PostMapping("/admins/invite")
    @Operation(summary = "Invite admin", description = "Invites a new admin to the system. Only SUPER_ADMIN can perform this action.")
    public ResponseEntity<InviteAdminResponse> inviteAdmin(
            @RequestBody InviteAdminRequest request,
            @RequestAttribute("userId") UUID currentUserId) {

        InviteAdminUseCase.InviteAdminCommand command = new InviteAdminUseCase.InviteAdminCommand(
                request.getEmail(),
                request.getName(),
                currentUserId
        );

        InviteAdminUseCase.InviteAdminResult result = inviteAdminUseCase.execute(command);

        InviteAdminResponse response = new InviteAdminResponse(
                result.getAdmin().getId(),
                result.getAdmin().getEmail(),
                result.getAdmin().getName(),
                result.getInvitationToken(),
                "Admin invitation created successfully"
        );

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @DeleteMapping("/admins/{adminId}")
    @Operation(summary = "Revoke admin", description = "Revokes admin privileges from a user. Only SUPER_ADMIN can perform this action.")
    public ResponseEntity<Map<String, String>> revokeAdmin(
            @PathVariable UUID adminId,
            @RequestAttribute("userId") UUID currentUserId) {
        // TODO: Implement RevokeAdminUseCase
        // - Verify current user is SUPER_ADMIN
        // - Find admin user by ID
        // - Change role to PLAYER
        // - Return success response
        return ResponseEntity.ok(Map.of("message", "TODO: Implement RevokeAdminUseCase"));
    }

    @GetMapping("/admins")
    @Operation(summary = "List admins", description = "Lists all admin users in the system")
    public ResponseEntity<?> listAdmins(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        // TODO: Implement ListAdminsUseCase
        // - Query all users with ADMIN role
        // - Return paginated list with: id, email, name, created_at, last_login_at
        return ResponseEntity.ok(Map.of("message", "TODO: Implement ListAdminsUseCase"));
    }

    // ========================
    // League Visibility
    // ========================

    @GetMapping("/leagues")
    @Operation(summary = "View all leagues", description = "Lists all leagues in the system. Only SUPER_ADMIN has access.")
    public ResponseEntity<?> listAllLeagues(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        // TODO: Implement ListAllLeaguesUseCase
        // - Query all leagues across the system
        // - Return paginated list with: id, name, admin_id, player_count, created_at, status
        return ResponseEntity.ok(Map.of("message", "TODO: Implement ListAllLeaguesUseCase"));
    }

    // ========================
    // Personal Access Token (PAT) Management
    // ========================

    @PostMapping("/pats")
    @Operation(
            summary = "Create PAT",
            description = "Creates a new Personal Access Token for API authentication. " +
                    "Returns the plaintext token ONLY on creation. Store it securely - it cannot be retrieved again.")
    public ResponseEntity<CreatePATResponse> createPAT(
            @RequestBody CreatePATRequest request,
            @RequestAttribute("userId") UUID currentUserId) {

        // Parse scope from string
        PATScope scope = PATScope.valueOf(request.getScope().toUpperCase());

        // Parse expiration date (ISO-8601 format)
        LocalDateTime expiresAt = request.getExpiresAt() != null ?
                LocalDateTime.parse(request.getExpiresAt()) : null;

        // Create command
        CreatePATUseCase.CreatePATCommand command = new CreatePATUseCase.CreatePATCommand(
                request.getName(),
                scope,
                expiresAt,
                currentUserId
        );

        // Execute use case
        CreatePATUseCase.CreatePATResult result = createPATUseCase.execute(command);

        // Build response
        CreatePATResponse response = new CreatePATResponse(
                result.getId(),
                result.getName(),
                result.getPlaintextToken(),  // ⚠️ ONLY TIME TOKEN IS VISIBLE
                result.getScope().name(),
                result.getExpiresAt() != null ? result.getExpiresAt().toString() : null,
                "✅ PAT created successfully. Save this token - it will not be shown again."
        );

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/pats")
    @Operation(summary = "List PATs", description = "Lists all Personal Access Tokens. Does NOT return token secrets.")
    public ResponseEntity<?> listPATs(
            @RequestParam(defaultValue = "all") String filter,
            @RequestAttribute("userId") UUID currentUserId) {

        // Parse filter type
        ListPATsUseCase.FilterType filterType;
        try {
            filterType = ListPATsUseCase.FilterType.valueOf(filter.toUpperCase());
        } catch (IllegalArgumentException e) {
            filterType = ListPATsUseCase.FilterType.ALL;
        }

        // Create command
        ListPATsUseCase.ListPATsCommand command = new ListPATsUseCase.ListPATsCommand(
                currentUserId,
                filterType
        );

        // Execute use case
        ListPATsUseCase.ListPATsResult result = listPATsUseCase.execute(command);

        // Return PAT summaries (NO plaintext tokens or hashes)
        return ResponseEntity.ok(result);
    }

    @DeleteMapping("/pats/{patId}")
    @Operation(summary = "Revoke PAT", description = "Revokes a Personal Access Token, preventing future use")
    public ResponseEntity<Map<String, String>> revokePAT(
            @PathVariable UUID patId,
            @RequestAttribute("userId") UUID currentUserId) {

        // Create command
        RevokePATUseCase.RevokePATCommand command = new RevokePATUseCase.RevokePATCommand(
                patId,
                currentUserId
        );

        // Execute use case
        RevokePATUseCase.RevokePATResult result = revokePATUseCase.execute(command);

        return ResponseEntity.ok(Map.of(
                "message", "PAT '" + result.getPatName() + "' revoked successfully",
                "patId", result.getPatId().toString(),
                "revokedAt", result.getRevokedAt().toString()
        ));
    }

    @PostMapping("/pats/{patId}/rotate")
    @Operation(
            summary = "Rotate PAT",
            description = "Rotates a PAT by generating a new token secret while keeping the same ID and name. " +
                    "Returns the new plaintext token ONLY once.")
    public ResponseEntity<CreatePATResponse> rotatePAT(
            @PathVariable UUID patId,
            @RequestAttribute("userId") UUID currentUserId) {

        // Create command
        RotatePATUseCase.RotatePATCommand command = new RotatePATUseCase.RotatePATCommand(
                patId,
                currentUserId
        );

        // Execute use case
        RotatePATUseCase.RotatePATResult result = rotatePATUseCase.execute(command);

        // Build response
        CreatePATResponse response = new CreatePATResponse(
                result.getPatId(),
                result.getPatName(),
                result.getNewPlaintextToken(),  // ⚠️ ONLY TIME NEW TOKEN IS VISIBLE
                result.getScope().name(),
                result.getExpiresAt() != null ? result.getExpiresAt().toString() : null,
                "✅ PAT rotated successfully. Save the new token - it will not be shown again. Old token is now invalid."
        );

        return ResponseEntity.ok(response);
    }

    // ========================
    // Request/Response DTOs
    // ========================

    public static class CreateSuperAdminRequest {
        private String email;
        private String googleId;
        private String name;

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public String getGoogleId() {
            return googleId;
        }

        public void setGoogleId(String googleId) {
            this.googleId = googleId;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }
    }

    public static class CreateSuperAdminResponse {
        private final UUID userId;
        private final String email;
        private final String name;
        private final String googleId;
        private final String role;
        private final LocalDateTime createdAt;
        private final String message;

        public CreateSuperAdminResponse(UUID userId, String email, String name,
                                       String googleId, String role, LocalDateTime createdAt,
                                       String message) {
            this.userId = userId;
            this.email = email;
            this.name = name;
            this.googleId = googleId;
            this.role = role;
            this.createdAt = createdAt;
            this.message = message;
        }

        public UUID getUserId() {
            return userId;
        }

        public String getEmail() {
            return email;
        }

        public String getName() {
            return name;
        }

        public String getGoogleId() {
            return googleId;
        }

        public String getRole() {
            return role;
        }

        public LocalDateTime getCreatedAt() {
            return createdAt;
        }

        public String getMessage() {
            return message;
        }
    }

    public static class InviteAdminRequest {
        private String email;
        private String name;

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }
    }

    public static class InviteAdminResponse {
        private final UUID adminId;
        private final String email;
        private final String name;
        private final String invitationToken;
        private final String message;

        public InviteAdminResponse(UUID adminId, String email, String name,
                                  String invitationToken, String message) {
            this.adminId = adminId;
            this.email = email;
            this.name = name;
            this.invitationToken = invitationToken;
            this.message = message;
        }

        public UUID getAdminId() {
            return adminId;
        }

        public String getEmail() {
            return email;
        }

        public String getName() {
            return name;
        }

        public String getInvitationToken() {
            return invitationToken;
        }

        public String getMessage() {
            return message;
        }
    }

    public static class CreatePATRequest {
        private String name;
        private String scope;  // READ_ONLY, WRITE, ADMIN
        private String expiresAt;  // ISO-8601 format or null for no expiry

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getScope() {
            return scope;
        }

        public void setScope(String scope) {
            this.scope = scope;
        }

        public String getExpiresAt() {
            return expiresAt;
        }

        public void setExpiresAt(String expiresAt) {
            this.expiresAt = expiresAt;
        }
    }

    public static class CreatePATResponse {
        private final UUID id;
        private final String name;
        private final String token;  // Plaintext - only visible on creation/rotation
        private final String scope;
        private final String expiresAt;
        private final String message;

        public CreatePATResponse(UUID id, String name, String token,
                                String scope, String expiresAt, String message) {
            this.id = id;
            this.name = name;
            this.token = token;
            this.scope = scope;
            this.expiresAt = expiresAt;
            this.message = message;
        }

        public UUID getId() {
            return id;
        }

        public String getName() {
            return name;
        }

        public String getToken() {
            return token;
        }

        public String getScope() {
            return scope;
        }

        public String getExpiresAt() {
            return expiresAt;
        }

        public String getMessage() {
            return message;
        }
    }
}
