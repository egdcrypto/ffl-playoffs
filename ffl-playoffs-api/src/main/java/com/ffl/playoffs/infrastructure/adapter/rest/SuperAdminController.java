package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.usecase.InviteAdminUseCase;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

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
    // TODO: Inject other use cases when implemented:
    // - RevokeAdminUseCase
    // - ListAdminsUseCase
    // - ListAllLeaguesUseCase
    // - CreatePATUseCase
    // - ListPATsUseCase
    // - RevokePATUseCase
    // - RotatePATUseCase

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
        // TODO: Implement CreatePATUseCase
        // - Generate unique token: pat_<identifier>_<secret>
        // - Hash the token with BCrypt
        // - Store: name, identifier, hash, scope, expiry, created_by
        // - Return plaintext token (ONLY time it's visible)

        String plaintextToken = "pat_example_secret";  // TODO: Generate actual token

        CreatePATResponse response = new CreatePATResponse(
                UUID.randomUUID(),  // TODO: Use real PAT ID
                request.getName(),
                plaintextToken,
                request.getScope(),
                request.getExpiresAt(),
                "WARNING: Save this token now - you won't be able to see it again"
        );

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/pats")
    @Operation(summary = "List PATs", description = "Lists all Personal Access Tokens. Does NOT return token secrets.")
    public ResponseEntity<?> listPATs(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        // TODO: Implement ListPATsUseCase
        // - Query all PATs
        // - Return: id, name, scope, created_at, expires_at, last_used_at, revoked
        // - NEVER return token hash or plaintext
        return ResponseEntity.ok(Map.of("message", "TODO: Implement ListPATsUseCase"));
    }

    @DeleteMapping("/pats/{patId}")
    @Operation(summary = "Revoke PAT", description = "Revokes a Personal Access Token, preventing future use")
    public ResponseEntity<Map<String, String>> revokePAT(
            @PathVariable UUID patId,
            @RequestAttribute("userId") UUID currentUserId) {
        // TODO: Implement RevokePATUseCase
        // - Find PAT by ID
        // - Mark as revoked
        // - Return success message
        return ResponseEntity.ok(Map.of("message", "TODO: Implement RevokePATUseCase"));
    }

    @PostMapping("/pats/{patId}/rotate")
    @Operation(
            summary = "Rotate PAT",
            description = "Rotates a PAT by generating a new token secret while keeping the same ID and name. " +
                    "Returns the new plaintext token ONLY once.")
    public ResponseEntity<CreatePATResponse> rotatePAT(
            @PathVariable UUID patId,
            @RequestAttribute("userId") UUID currentUserId) {
        // TODO: Implement RotatePATUseCase
        // - Find existing PAT
        // - Generate new token secret
        // - Update token hash
        // - Return new plaintext token (ONLY time it's visible)
        return ResponseEntity.ok(new CreatePATResponse(
                patId,
                "rotated-token",
                "pat_rotated_secret",
                null,
                null,
                "TODO: Implement RotatePATUseCase"
        ));
    }

    // ========================
    // Request/Response DTOs
    // ========================

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
