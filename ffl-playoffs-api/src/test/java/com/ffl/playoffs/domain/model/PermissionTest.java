package com.ffl.playoffs.domain.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for Permission enum
 */
class PermissionTest {

    @Nested
    @DisplayName("getMinimumRole")
    class GetMinimumRole {

        @Test
        @DisplayName("Player permissions require PLAYER role")
        void playerPermissionsRequirePlayerRole() {
            assertEquals(Role.PLAYER, Permission.VIEW_LEAGUE_STANDINGS.getMinimumRole());
            assertEquals(Role.PLAYER, Permission.BUILD_ROSTER.getMinimumRole());
            assertEquals(Role.PLAYER, Permission.VIEW_LEAGUE_SCORES.getMinimumRole());
        }

        @Test
        @DisplayName("Admin permissions require ADMIN role")
        void adminPermissionsRequireAdminRole() {
            assertEquals(Role.ADMIN, Permission.CREATE_LEAGUE.getMinimumRole());
            assertEquals(Role.ADMIN, Permission.INVITE_PLAYERS.getMinimumRole());
            assertEquals(Role.ADMIN, Permission.MANAGE_OWN_LEAGUE.getMinimumRole());
        }

        @Test
        @DisplayName("Super admin permissions require SUPER_ADMIN role")
        void superAdminPermissionsRequireSuperAdminRole() {
            assertEquals(Role.SUPER_ADMIN, Permission.VIEW_ALL_LEAGUES.getMinimumRole());
            assertEquals(Role.SUPER_ADMIN, Permission.MANAGE_ADMINS.getMinimumRole());
            assertEquals(Role.SUPER_ADMIN, Permission.AUDIT_SYSTEM.getMinimumRole());
        }
    }

    @Nested
    @DisplayName("isGrantedTo")
    class IsGrantedTo {

        @Test
        @DisplayName("Player permissions are granted to all roles")
        void playerPermissionsGrantedToAllRoles() {
            assertTrue(Permission.VIEW_LEAGUE_STANDINGS.isGrantedTo(Role.PLAYER));
            assertTrue(Permission.VIEW_LEAGUE_STANDINGS.isGrantedTo(Role.ADMIN));
            assertTrue(Permission.VIEW_LEAGUE_STANDINGS.isGrantedTo(Role.SUPER_ADMIN));
        }

        @Test
        @DisplayName("Admin permissions are granted to ADMIN and SUPER_ADMIN")
        void adminPermissionsGrantedToAdminAndSuperAdmin() {
            assertFalse(Permission.CREATE_LEAGUE.isGrantedTo(Role.PLAYER));
            assertTrue(Permission.CREATE_LEAGUE.isGrantedTo(Role.ADMIN));
            assertTrue(Permission.CREATE_LEAGUE.isGrantedTo(Role.SUPER_ADMIN));
        }

        @Test
        @DisplayName("Super admin permissions are granted only to SUPER_ADMIN")
        void superAdminPermissionsGrantedOnlyToSuperAdmin() {
            assertFalse(Permission.MANAGE_ADMINS.isGrantedTo(Role.PLAYER));
            assertFalse(Permission.MANAGE_ADMINS.isGrantedTo(Role.ADMIN));
            assertTrue(Permission.MANAGE_ADMINS.isGrantedTo(Role.SUPER_ADMIN));
        }
    }
}
