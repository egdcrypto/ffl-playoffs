package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.usecase.*;
import com.ffl.playoffs.domain.model.AdminAction;
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
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

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

    private final SendAdminInvitationUseCase sendAdminInvitationUseCase;
    private final AcceptAdminInvitationUseCase acceptAdminInvitationUseCase;
    private final ListAdminsUseCase listAdminsUseCase;
    private final RevokeAdminUseCase revokeAdminUseCase;
    private final GetAdminAuditLogsUseCase getAdminAuditLogsUseCase;
    private final CreateSuperAdminUseCase createSuperAdminUseCase;
    private final CreatePATUseCase createPATUseCase;
    private final ListPATsUseCase listPATsUseCase;
    private final RevokePATUseCase revokePATUseCase;
    private final RotatePATUseCase rotatePATUseCase;

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
    // Admin Invitation Management
    // ========================

    @PostMapping("/invitations")
    @Operation(
            summary = "Send admin invitation",
            description = "Sends an admin invitation to the specified email. Only SUPER_ADMIN can perform this action."
    )
    public ResponseEntity<?> sendAdminInvitation(
            @RequestBody SendAdminInvitationRequest request,
            @RequestAttribute("userId") UUID currentUserId) {

        try {
            // Check for attempt to create SUPER_ADMIN invitation
            if (request.getTargetRole() != null &&
                    request.getTargetRole().equalsIgnoreCase("SUPER_ADMIN")) {
                return ResponseEntity.badRequest().body(Map.of(
                        "errorCode", "INVALID_ROLE",
                        "message", "Cannot create SUPER_ADMIN invitation. SUPER_ADMIN can only be bootstrapped via configuration."
                ));
            }

            SendAdminInvitationUseCase.SendAdminInvitationCommand command =
                    new SendAdminInvitationUseCase.SendAdminInvitationCommand(
                            request.getEmail(),
                            currentUserId
                    );

            SendAdminInvitationUseCase.SendAdminInvitationResult result =
                    sendAdminInvitationUseCase.execute(command);

            SendAdminInvitationResponse response = new SendAdminInvitationResponse(
                    result.getInvitationId(),
                    result.getEmail(),
                    result.getInvitationToken(),
                    result.getExpiresAt(),
                    result.getMessage()
            );

            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (SendAdminInvitationUseCase.InvitationException e) {
            HttpStatus status = switch (e.getErrorCode()) {
                case "FORBIDDEN" -> HttpStatus.FORBIDDEN;
                case "INVALID_ROLE", "USER_ALREADY_ADMIN", "PENDING_INVITATION_EXISTS" -> HttpStatus.CONFLICT;
                default -> HttpStatus.BAD_REQUEST;
            };
            return ResponseEntity.status(status).body(Map.of(
                    "errorCode", e.getErrorCode(),
                    "message", e.getMessage()
            ));
        }
    }

    @GetMapping("/invitations/{token}/accept")
    @Operation(
            summary = "Accept admin invitation",
            description = "Accepts an admin invitation. Called after Google OAuth authentication."
    )
    public ResponseEntity<?> acceptAdminInvitation(
            @PathVariable String token,
            @RequestParam String googleEmail,
            @RequestParam String googleId,
            @RequestParam(required = false) String displayName) {

        try {
            AcceptAdminInvitationUseCase.AcceptAdminInvitationCommand command =
                    new AcceptAdminInvitationUseCase.AcceptAdminInvitationCommand(
                            token,
                            googleEmail,
                            googleId,
                            displayName
                    );

            AcceptAdminInvitationUseCase.AcceptAdminInvitationResult result =
                    acceptAdminInvitationUseCase.execute(command);

            AcceptAdminInvitationResponse response = new AcceptAdminInvitationResponse(
                    result.getUserId(),
                    result.getEmail(),
                    result.getName(),
                    result.getRole().name(),
                    result.isNewUser(),
                    result.isUpgraded(),
                    result.getAcceptedAt(),
                    result.isNewUser() ?
                            "New admin account created successfully" :
                            "User upgraded to admin successfully"
            );

            return ResponseEntity.ok(response);
        } catch (AcceptAdminInvitationUseCase.InvitationException e) {
            HttpStatus status = switch (e.getErrorCode()) {
                case "INVITATION_NOT_FOUND" -> HttpStatus.NOT_FOUND;
                case "INVITATION_EXPIRED" -> HttpStatus.GONE;
                case "EMAIL_MISMATCH" -> HttpStatus.BAD_REQUEST;
                case "USER_ALREADY_ADMIN" -> HttpStatus.CONFLICT;
                default -> HttpStatus.BAD_REQUEST;
            };
            return ResponseEntity.status(status).body(Map.of(
                    "errorCode", e.getErrorCode(),
                    "message", e.getMessage()
            ));
        }
    }

    // ========================
    // Admin Management
    // ========================

    @GetMapping("/admins")
    @Operation(
            summary = "List all admins",
            description = "Lists all admin users in the system. Only SUPER_ADMIN can access this."
    )
    public ResponseEntity<?> listAdmins(
            @RequestAttribute("userId") UUID currentUserId) {

        try {
            ListAdminsUseCase.ListAdminsCommand command =
                    new ListAdminsUseCase.ListAdminsCommand(currentUserId);

            ListAdminsUseCase.ListAdminsResult result = listAdminsUseCase.execute(command);

            List<AdminSummaryResponse> admins = result.getAdmins().stream()
                    .map(admin -> new AdminSummaryResponse(
                            admin.getId(),
                            admin.getEmail(),
                            admin.getName(),
                            admin.getGoogleId(),
                            admin.getCreatedAt(),
                            admin.getLastLoginAt(),
                            admin.isActive()
                    ))
                    .collect(Collectors.toList());

            return ResponseEntity.ok(Map.of(
                    "admins", admins,
                    "totalCount", result.getTotalCount()
            ));
        } catch (IllegalStateException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                    "errorCode", "FORBIDDEN",
                    "message", e.getMessage()
            ));
        }
    }

    @DeleteMapping("/admins/{email}")
    @Operation(
            summary = "Revoke admin privileges",
            description = "Revokes admin privileges from a user. User is downgraded to PLAYER. " +
                    "Only SUPER_ADMIN can perform this action."
    )
    public ResponseEntity<?> revokeAdmin(
            @PathVariable String email,
            @RequestAttribute("userId") UUID currentUserId) {

        try {
            RevokeAdminUseCase.RevokeAdminCommand command =
                    new RevokeAdminUseCase.RevokeAdminCommand(email, currentUserId);

            RevokeAdminUseCase.RevokeAdminResult result = revokeAdminUseCase.execute(command);

            return ResponseEntity.ok(Map.of(
                    "userId", result.getUserId(),
                    "email", result.getEmail(),
                    "affectedLeagues", result.getAffectedLeagues(),
                    "revokedAt", result.getRevokedAt().toString(),
                    "message", result.getMessage()
            ));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of(
                    "errorCode", "ADMIN_NOT_FOUND",
                    "message", e.getMessage()
            ));
        } catch (IllegalStateException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                    "errorCode", "FORBIDDEN",
                    "message", e.getMessage()
            ));
        }
    }

    // ========================
    // Audit Logs
    // ========================

    @GetMapping("/audit-logs")
    @Operation(
            summary = "View admin audit logs",
            description = "Returns all admin actions with timestamps. Only SUPER_ADMIN can access this."
    )
    public ResponseEntity<?> getAuditLogs(
            @RequestAttribute("userId") UUID currentUserId,
            @RequestParam(required = false) UUID adminId,
            @RequestParam(required = false) String action,
            @RequestParam(defaultValue = "0") int offset,
            @RequestParam(defaultValue = "50") int limit) {

        try {
            GetAdminAuditLogsUseCase.GetAdminAuditLogsCommand.Builder builder =
                    GetAdminAuditLogsUseCase.GetAdminAuditLogsCommand.builder(currentUserId)
                            .offset(offset)
                            .limit(limit);

            if (adminId != null) {
                builder.adminId(adminId);
            }
            if (action != null) {
                try {
                    builder.action(AdminAction.valueOf(action.toUpperCase()));
                } catch (IllegalArgumentException ignored) {
                    // Invalid action, ignore filter
                }
            }

            GetAdminAuditLogsUseCase.GetAdminAuditLogsResult result =
                    getAdminAuditLogsUseCase.execute(builder.build());

            List<Map<String, Object>> logs = result.getLogs().stream()
                    .map(log -> Map.<String, Object>of(
                            "id", log.getId(),
                            "adminId", log.getAdminId(),
                            "adminEmail", log.getAdminEmail(),
                            "action", log.getAction().name(),
                            "targetId", log.getTargetId() != null ? log.getTargetId().toString() : "",
                            "targetType", log.getTargetType() != null ? log.getTargetType() : "",
                            "timestamp", log.getTimestamp().toString()
                    ))
                    .collect(Collectors.toList());

            return ResponseEntity.ok(Map.of(
                    "logs", logs,
                    "totalCount", result.getTotalCount(),
                    "offset", offset,
                    "limit", limit
            ));
        } catch (IllegalStateException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                    "errorCode", "FORBIDDEN",
                    "message", e.getMessage()
            ));
        }
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

        PATScope scope = PATScope.valueOf(request.getScope().toUpperCase());
        LocalDateTime expiresAt = request.getExpiresAt() != null ?
                LocalDateTime.parse(request.getExpiresAt()) : null;

        CreatePATUseCase.CreatePATCommand command = new CreatePATUseCase.CreatePATCommand(
                request.getName(),
                scope,
                expiresAt,
                currentUserId
        );

        CreatePATUseCase.CreatePATResult result = createPATUseCase.execute(command);

        CreatePATResponse response = new CreatePATResponse(
                result.getId(),
                result.getName(),
                result.getPlaintextToken(),
                result.getScope().name(),
                result.getExpiresAt() != null ? result.getExpiresAt().toString() : null,
                "PAT created successfully. Save this token - it will not be shown again."
        );

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/pats")
    @Operation(summary = "List PATs", description = "Lists all Personal Access Tokens. Does NOT return token secrets.")
    public ResponseEntity<?> listPATs(
            @RequestParam(defaultValue = "all") String filter,
            @RequestAttribute("userId") UUID currentUserId) {

        ListPATsUseCase.FilterType filterType;
        try {
            filterType = ListPATsUseCase.FilterType.valueOf(filter.toUpperCase());
        } catch (IllegalArgumentException e) {
            filterType = ListPATsUseCase.FilterType.ALL;
        }

        ListPATsUseCase.ListPATsCommand command = new ListPATsUseCase.ListPATsCommand(
                currentUserId,
                filterType
        );

        ListPATsUseCase.ListPATsResult result = listPATsUseCase.execute(command);

        return ResponseEntity.ok(result);
    }

    @DeleteMapping("/pats/{patId}")
    @Operation(summary = "Revoke PAT", description = "Revokes a Personal Access Token, preventing future use")
    public ResponseEntity<Map<String, String>> revokePAT(
            @PathVariable UUID patId,
            @RequestAttribute("userId") UUID currentUserId) {

        RevokePATUseCase.RevokePATCommand command = new RevokePATUseCase.RevokePATCommand(
                patId,
                currentUserId
        );

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

        RotatePATUseCase.RotatePATCommand command = new RotatePATUseCase.RotatePATCommand(
                patId,
                currentUserId
        );

        RotatePATUseCase.RotatePATResult result = rotatePATUseCase.execute(command);

        CreatePATResponse response = new CreatePATResponse(
                result.getPatId(),
                result.getPatName(),
                result.getNewPlaintextToken(),
                result.getScope().name(),
                result.getExpiresAt() != null ? result.getExpiresAt().toString() : null,
                "PAT rotated successfully. Save the new token - it will not be shown again. Old token is now invalid."
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

        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        public String getGoogleId() { return googleId; }
        public void setGoogleId(String googleId) { this.googleId = googleId; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
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

        public UUID getUserId() { return userId; }
        public String getEmail() { return email; }
        public String getName() { return name; }
        public String getGoogleId() { return googleId; }
        public String getRole() { return role; }
        public LocalDateTime getCreatedAt() { return createdAt; }
        public String getMessage() { return message; }
    }

    public static class SendAdminInvitationRequest {
        private String email;
        private String targetRole;

        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        public String getTargetRole() { return targetRole; }
        public void setTargetRole(String targetRole) { this.targetRole = targetRole; }
    }

    public static class SendAdminInvitationResponse {
        private final UUID invitationId;
        private final String email;
        private final String invitationToken;
        private final LocalDateTime expiresAt;
        private final String message;

        public SendAdminInvitationResponse(UUID invitationId, String email, String invitationToken,
                                            LocalDateTime expiresAt, String message) {
            this.invitationId = invitationId;
            this.email = email;
            this.invitationToken = invitationToken;
            this.expiresAt = expiresAt;
            this.message = message;
        }

        public UUID getInvitationId() { return invitationId; }
        public String getEmail() { return email; }
        public String getInvitationToken() { return invitationToken; }
        public LocalDateTime getExpiresAt() { return expiresAt; }
        public String getMessage() { return message; }
    }

    public static class AcceptAdminInvitationResponse {
        private final UUID userId;
        private final String email;
        private final String name;
        private final String role;
        private final boolean newUser;
        private final boolean upgraded;
        private final LocalDateTime acceptedAt;
        private final String message;

        public AcceptAdminInvitationResponse(UUID userId, String email, String name, String role,
                                              boolean newUser, boolean upgraded, LocalDateTime acceptedAt,
                                              String message) {
            this.userId = userId;
            this.email = email;
            this.name = name;
            this.role = role;
            this.newUser = newUser;
            this.upgraded = upgraded;
            this.acceptedAt = acceptedAt;
            this.message = message;
        }

        public UUID getUserId() { return userId; }
        public String getEmail() { return email; }
        public String getName() { return name; }
        public String getRole() { return role; }
        public boolean isNewUser() { return newUser; }
        public boolean isUpgraded() { return upgraded; }
        public LocalDateTime getAcceptedAt() { return acceptedAt; }
        public String getMessage() { return message; }
    }

    public static class AdminSummaryResponse {
        private final UUID id;
        private final String email;
        private final String name;
        private final String googleId;
        private final LocalDateTime createdAt;
        private final LocalDateTime lastLoginAt;
        private final boolean active;

        public AdminSummaryResponse(UUID id, String email, String name, String googleId,
                                     LocalDateTime createdAt, LocalDateTime lastLoginAt, boolean active) {
            this.id = id;
            this.email = email;
            this.name = name;
            this.googleId = googleId;
            this.createdAt = createdAt;
            this.lastLoginAt = lastLoginAt;
            this.active = active;
        }

        public UUID getId() { return id; }
        public String getEmail() { return email; }
        public String getName() { return name; }
        public String getGoogleId() { return googleId; }
        public LocalDateTime getCreatedAt() { return createdAt; }
        public LocalDateTime getLastLoginAt() { return lastLoginAt; }
        public boolean isActive() { return active; }
    }

    public static class CreatePATRequest {
        private String name;
        private String scope;
        private String expiresAt;

        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public String getScope() { return scope; }
        public void setScope(String scope) { this.scope = scope; }
        public String getExpiresAt() { return expiresAt; }
        public void setExpiresAt(String expiresAt) { this.expiresAt = expiresAt; }
    }

    public static class CreatePATResponse {
        private final UUID id;
        private final String name;
        private final String token;
        private final String scope;
        private final String expiresAt;
        private final String message;

        public CreatePATResponse(UUID id, String name, String token, String scope,
                                  String expiresAt, String message) {
            this.id = id;
            this.name = name;
            this.token = token;
            this.scope = scope;
            this.expiresAt = expiresAt;
            this.message = message;
        }

        public UUID getId() { return id; }
        public String getName() { return name; }
        public String getToken() { return token; }
        public String getScope() { return scope; }
        public String getExpiresAt() { return expiresAt; }
        public String getMessage() { return message; }
    }
}
