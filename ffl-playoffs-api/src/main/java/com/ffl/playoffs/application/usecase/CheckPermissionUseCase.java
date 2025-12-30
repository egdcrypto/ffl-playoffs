package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.Permission;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.UserRepository;
import com.ffl.playoffs.domain.service.AccessControlService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Set;
import java.util.UUID;

/**
 * Use case for checking user permissions
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class CheckPermissionUseCase {

    private final UserRepository userRepository;
    private final AccessControlService accessControlService;

    /**
     * Check if user has a specific permission
     * @param userId the user ID
     * @param permission the permission to check
     * @return true if user has the permission
     */
    public boolean hasPermission(UUID userId, Permission permission) {
        log.debug("Checking permission {} for user {}", permission, userId);

        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return false;
        }

        return accessControlService.hasPermission(user, permission);
    }

    /**
     * Check if user has the required role
     * @param userId the user ID
     * @param requiredRole the required role
     * @return true if user has the role or higher
     */
    public boolean hasRole(UUID userId, Role requiredRole) {
        log.debug("Checking role {} for user {}", requiredRole, userId);

        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return false;
        }

        return user.hasRole(requiredRole);
    }

    /**
     * Get all permissions for a user
     * @param userId the user ID
     * @return set of permissions, empty if user not found
     */
    public Set<Permission> getPermissions(UUID userId) {
        log.debug("Getting permissions for user {}", userId);

        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return Set.of();
        }

        return user.getPermissions();
    }

    /**
     * Check if user can access a league
     * @param userId the user ID
     * @param leagueId the league ID
     * @param isOwner true if user is the league owner
     * @param isMember true if user is a league member
     * @return true if user can access the league
     */
    public boolean canAccessLeague(UUID userId, UUID leagueId, boolean isOwner, boolean isMember) {
        log.debug("Checking league access for user {} on league {}", userId, leagueId);

        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return false;
        }

        return accessControlService.canAccessLeague(user, leagueId, isOwner, isMember);
    }

    /**
     * Check if user can manage a league
     * @param userId the user ID
     * @param leagueId the league ID
     * @param isOwner true if user is the league owner
     * @return true if user can manage the league
     */
    public boolean canManageLeague(UUID userId, UUID leagueId, boolean isOwner) {
        log.debug("Checking league management for user {} on league {}", userId, leagueId);

        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return false;
        }

        return accessControlService.canManageLeague(user, leagueId, isOwner);
    }
}
