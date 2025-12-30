package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.model.auth.AuthSession;
import com.ffl.playoffs.domain.model.auth.Permission;
import com.ffl.playoffs.domain.port.AuthSessionRepository;
import com.ffl.playoffs.domain.port.UserRepository;

import java.util.Set;
import java.util.UUID;

/**
 * Use case for checking user permissions
 * Validates if a user or session has required permissions
 */
public class CheckPermissionUseCase {

    private final AuthSessionRepository sessionRepository;
    private final UserRepository userRepository;

    public CheckPermissionUseCase(AuthSessionRepository sessionRepository,
                                   UserRepository userRepository) {
        this.sessionRepository = sessionRepository;
        this.userRepository = userRepository;
    }

    /**
     * Check if a session has required permission
     * @param command the permission check command
     * @return result of the permission check
     */
    public CheckResult executeBySession(CheckBySessionCommand command) {
        // Find session
        AuthSession session = sessionRepository.findBySessionToken(command.getSessionToken())
                .orElse(null);

        if (session == null) {
            return CheckResult.denied("Session not found");
        }

        if (!session.isValid()) {
            return CheckResult.denied("Session is not valid");
        }

        boolean hasPermission = session.hasPermission(command.getRequiredPermission());
        if (hasPermission) {
            return CheckResult.allowed(session.getPermissions());
        }

        return CheckResult.denied("Permission denied: " + command.getRequiredPermission().getCode());
    }

    /**
     * Check if a session has all required permissions
     * @param command the permissions check command
     * @return result of the permission check
     */
    public CheckResult executeBySessionMultiple(CheckBySessionMultipleCommand command) {
        // Find session
        AuthSession session = sessionRepository.findBySessionToken(command.getSessionToken())
                .orElse(null);

        if (session == null) {
            return CheckResult.denied("Session not found");
        }

        if (!session.isValid()) {
            return CheckResult.denied("Session is not valid");
        }

        boolean hasAllPermissions = session.hasAllPermissions(command.getRequiredPermissions());
        if (hasAllPermissions) {
            return CheckResult.allowed(session.getPermissions());
        }

        return CheckResult.denied("Missing required permissions");
    }

    /**
     * Check if a user has required permission based on role
     * @param command the permission check command
     * @return result of the permission check
     */
    public CheckResult executeByUser(CheckByUserCommand command) {
        // Find user
        User user = userRepository.findById(command.getUserId())
                .orElse(null);

        if (user == null) {
            return CheckResult.denied("User not found");
        }

        if (!user.isActive()) {
            return CheckResult.denied("User is not active");
        }

        Set<Permission> userPermissions = Permission.getDefaultPermissionsForRole(user.getRole());
        boolean hasPermission = userPermissions.contains(command.getRequiredPermission());

        if (hasPermission) {
            return CheckResult.allowed(userPermissions);
        }

        return CheckResult.denied("Permission denied: " + command.getRequiredPermission().getCode());
    }

    /**
     * Check if a user has required role
     * @param command the role check command
     * @return result of the role check
     */
    public CheckResult executeByRole(CheckByRoleCommand command) {
        // Find user
        User user = userRepository.findById(command.getUserId())
                .orElse(null);

        if (user == null) {
            return CheckResult.denied("User not found");
        }

        if (!user.isActive()) {
            return CheckResult.denied("User is not active");
        }

        if (user.hasRole(command.getRequiredRole())) {
            return CheckResult.allowed(Permission.getDefaultPermissionsForRole(user.getRole()));
        }

        return CheckResult.denied("Role denied: requires " + command.getRequiredRole().name());
    }

    /**
     * Command for checking single permission by session
     */
    public static class CheckBySessionCommand {
        private final String sessionToken;
        private final Permission requiredPermission;

        public CheckBySessionCommand(String sessionToken, Permission requiredPermission) {
            this.sessionToken = sessionToken;
            this.requiredPermission = requiredPermission;
        }

        public String getSessionToken() {
            return sessionToken;
        }

        public Permission getRequiredPermission() {
            return requiredPermission;
        }
    }

    /**
     * Command for checking multiple permissions by session
     */
    public static class CheckBySessionMultipleCommand {
        private final String sessionToken;
        private final Set<Permission> requiredPermissions;

        public CheckBySessionMultipleCommand(String sessionToken, Set<Permission> requiredPermissions) {
            this.sessionToken = sessionToken;
            this.requiredPermissions = requiredPermissions;
        }

        public String getSessionToken() {
            return sessionToken;
        }

        public Set<Permission> getRequiredPermissions() {
            return requiredPermissions;
        }
    }

    /**
     * Command for checking permission by user
     */
    public static class CheckByUserCommand {
        private final UUID userId;
        private final Permission requiredPermission;

        public CheckByUserCommand(UUID userId, Permission requiredPermission) {
            this.userId = userId;
            this.requiredPermission = requiredPermission;
        }

        public UUID getUserId() {
            return userId;
        }

        public Permission getRequiredPermission() {
            return requiredPermission;
        }
    }

    /**
     * Command for checking role
     */
    public static class CheckByRoleCommand {
        private final UUID userId;
        private final Role requiredRole;

        public CheckByRoleCommand(UUID userId, Role requiredRole) {
            this.userId = userId;
            this.requiredRole = requiredRole;
        }

        public UUID getUserId() {
            return userId;
        }

        public Role getRequiredRole() {
            return requiredRole;
        }
    }

    /**
     * Result of permission check
     */
    public static class CheckResult {
        private final boolean allowed;
        private final String message;
        private final Set<Permission> actualPermissions;

        private CheckResult(boolean allowed, String message, Set<Permission> actualPermissions) {
            this.allowed = allowed;
            this.message = message;
            this.actualPermissions = actualPermissions;
        }

        public static CheckResult allowed(Set<Permission> actualPermissions) {
            return new CheckResult(true, "Permission granted", actualPermissions);
        }

        public static CheckResult denied(String message) {
            return new CheckResult(false, message, null);
        }

        public boolean isAllowed() {
            return allowed;
        }

        public boolean isDenied() {
            return !allowed;
        }

        public String getMessage() {
            return message;
        }

        public Set<Permission> getActualPermissions() {
            return actualPermissions;
        }
    }
}
