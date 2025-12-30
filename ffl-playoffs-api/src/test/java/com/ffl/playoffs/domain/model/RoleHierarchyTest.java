package com.ffl.playoffs.domain.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for RoleHierarchy
 */
class RoleHierarchyTest {

    @Nested
    @DisplayName("getLevel")
    class GetLevel {

        @Test
        @DisplayName("should return 0 for PLAYER")
        void shouldReturn0ForPlayer() {
            assertEquals(0, RoleHierarchy.getLevel(Role.PLAYER));
        }

        @Test
        @DisplayName("should return 1 for ADMIN")
        void shouldReturn1ForAdmin() {
            assertEquals(1, RoleHierarchy.getLevel(Role.ADMIN));
        }

        @Test
        @DisplayName("should return 2 for SUPER_ADMIN")
        void shouldReturn2ForSuperAdmin() {
            assertEquals(2, RoleHierarchy.getLevel(Role.SUPER_ADMIN));
        }
    }

    @Nested
    @DisplayName("isAtLeast")
    class IsAtLeast {

        @ParameterizedTest
        @DisplayName("should correctly compare role levels")
        @CsvSource({
                "SUPER_ADMIN, SUPER_ADMIN, true",
                "SUPER_ADMIN, ADMIN, true",
                "SUPER_ADMIN, PLAYER, true",
                "ADMIN, SUPER_ADMIN, false",
                "ADMIN, ADMIN, true",
                "ADMIN, PLAYER, true",
                "PLAYER, SUPER_ADMIN, false",
                "PLAYER, ADMIN, false",
                "PLAYER, PLAYER, true"
        })
        void shouldCorrectlyCompareRoleLevels(Role role1, Role role2, boolean expected) {
            assertEquals(expected, RoleHierarchy.isAtLeast(role1, role2));
        }
    }

    @Nested
    @DisplayName("isHigherThan")
    class IsHigherThan {

        @ParameterizedTest
        @DisplayName("should correctly check if role is higher")
        @CsvSource({
                "SUPER_ADMIN, ADMIN, true",
                "SUPER_ADMIN, PLAYER, true",
                "SUPER_ADMIN, SUPER_ADMIN, false",
                "ADMIN, PLAYER, true",
                "ADMIN, ADMIN, false",
                "PLAYER, PLAYER, false"
        })
        void shouldCorrectlyCheckIfHigher(Role role1, Role role2, boolean expected) {
            assertEquals(expected, RoleHierarchy.isHigherThan(role1, role2));
        }
    }

    @Nested
    @DisplayName("hasPermission")
    class HasPermission {

        @Test
        @DisplayName("SUPER_ADMIN should have all permissions")
        void superAdminShouldHaveAllPermissions() {
            for (Permission permission : Permission.values()) {
                assertTrue(RoleHierarchy.hasPermission(Role.SUPER_ADMIN, permission),
                        "SUPER_ADMIN should have permission: " + permission);
            }
        }

        @Test
        @DisplayName("ADMIN should have admin and player permissions")
        void adminShouldHaveAdminAndPlayerPermissions() {
            assertTrue(RoleHierarchy.hasPermission(Role.ADMIN, Permission.CREATE_LEAGUE));
            assertTrue(RoleHierarchy.hasPermission(Role.ADMIN, Permission.INVITE_PLAYERS));
            assertTrue(RoleHierarchy.hasPermission(Role.ADMIN, Permission.VIEW_LEAGUE_STANDINGS));
        }

        @Test
        @DisplayName("ADMIN should not have super admin permissions")
        void adminShouldNotHaveSuperAdminPermissions() {
            assertFalse(RoleHierarchy.hasPermission(Role.ADMIN, Permission.MANAGE_ADMINS));
            assertFalse(RoleHierarchy.hasPermission(Role.ADMIN, Permission.VIEW_ALL_LEAGUES));
            assertFalse(RoleHierarchy.hasPermission(Role.ADMIN, Permission.AUDIT_SYSTEM));
        }

        @Test
        @DisplayName("PLAYER should only have player permissions")
        void playerShouldOnlyHavePlayerPermissions() {
            assertTrue(RoleHierarchy.hasPermission(Role.PLAYER, Permission.VIEW_LEAGUE_STANDINGS));
            assertTrue(RoleHierarchy.hasPermission(Role.PLAYER, Permission.BUILD_ROSTER));
            assertFalse(RoleHierarchy.hasPermission(Role.PLAYER, Permission.CREATE_LEAGUE));
            assertFalse(RoleHierarchy.hasPermission(Role.PLAYER, Permission.INVITE_PLAYERS));
        }
    }

    @Nested
    @DisplayName("getPermissions")
    class GetPermissions {

        @Test
        @DisplayName("SUPER_ADMIN should have all permissions")
        void superAdminShouldHaveAllPermissions() {
            Set<Permission> permissions = RoleHierarchy.getPermissions(Role.SUPER_ADMIN);
            assertEquals(Permission.values().length, permissions.size());
        }

        @Test
        @DisplayName("PLAYER should have limited permissions")
        void playerShouldHaveLimitedPermissions() {
            Set<Permission> permissions = RoleHierarchy.getPermissions(Role.PLAYER);
            assertTrue(permissions.contains(Permission.VIEW_LEAGUE_STANDINGS));
            assertTrue(permissions.contains(Permission.BUILD_ROSTER));
            assertFalse(permissions.contains(Permission.CREATE_LEAGUE));
        }
    }

    @Nested
    @DisplayName("getManageableRoles")
    class GetManageableRoles {

        @Test
        @DisplayName("SUPER_ADMIN can manage ADMIN and PLAYER")
        void superAdminCanManageAdminAndPlayer() {
            Set<Role> manageable = RoleHierarchy.getManageableRoles(Role.SUPER_ADMIN);
            assertTrue(manageable.contains(Role.ADMIN));
            assertTrue(manageable.contains(Role.PLAYER));
            assertFalse(manageable.contains(Role.SUPER_ADMIN));
        }

        @Test
        @DisplayName("ADMIN can manage PLAYER only")
        void adminCanManagePlayerOnly() {
            Set<Role> manageable = RoleHierarchy.getManageableRoles(Role.ADMIN);
            assertTrue(manageable.contains(Role.PLAYER));
            assertFalse(manageable.contains(Role.ADMIN));
        }

        @Test
        @DisplayName("PLAYER cannot manage any role")
        void playerCannotManageAnyRole() {
            Set<Role> manageable = RoleHierarchy.getManageableRoles(Role.PLAYER);
            assertTrue(manageable.isEmpty());
        }
    }

    @Nested
    @DisplayName("canAssignRole")
    class CanAssignRole {

        @Test
        @DisplayName("SUPER_ADMIN can assign ADMIN role")
        void superAdminCanAssignAdmin() {
            assertTrue(RoleHierarchy.canAssignRole(Role.SUPER_ADMIN, Role.ADMIN));
        }

        @Test
        @DisplayName("SUPER_ADMIN can assign PLAYER role")
        void superAdminCanAssignPlayer() {
            assertTrue(RoleHierarchy.canAssignRole(Role.SUPER_ADMIN, Role.PLAYER));
        }

        @Test
        @DisplayName("SUPER_ADMIN cannot assign SUPER_ADMIN role")
        void superAdminCannotAssignSuperAdmin() {
            assertFalse(RoleHierarchy.canAssignRole(Role.SUPER_ADMIN, Role.SUPER_ADMIN));
        }

        @Test
        @DisplayName("ADMIN cannot assign any role")
        void adminCannotAssignRoles() {
            assertFalse(RoleHierarchy.canAssignRole(Role.ADMIN, Role.PLAYER));
            assertFalse(RoleHierarchy.canAssignRole(Role.ADMIN, Role.ADMIN));
        }

        @Test
        @DisplayName("PLAYER cannot assign any role")
        void playerCannotAssignRoles() {
            assertFalse(RoleHierarchy.canAssignRole(Role.PLAYER, Role.PLAYER));
        }
    }

    @Nested
    @DisplayName("canInvite")
    class CanInvite {

        @Test
        @DisplayName("SUPER_ADMIN can invite ADMIN")
        void superAdminCanInviteAdmin() {
            assertTrue(RoleHierarchy.canInvite(Role.SUPER_ADMIN, Role.ADMIN));
        }

        @Test
        @DisplayName("SUPER_ADMIN cannot invite PLAYER directly")
        void superAdminCannotInvitePlayerDirectly() {
            assertFalse(RoleHierarchy.canInvite(Role.SUPER_ADMIN, Role.PLAYER));
        }

        @Test
        @DisplayName("ADMIN can invite PLAYER")
        void adminCanInvitePlayer() {
            assertTrue(RoleHierarchy.canInvite(Role.ADMIN, Role.PLAYER));
        }

        @Test
        @DisplayName("ADMIN cannot invite ADMIN")
        void adminCannotInviteAdmin() {
            assertFalse(RoleHierarchy.canInvite(Role.ADMIN, Role.ADMIN));
        }

        @Test
        @DisplayName("PLAYER cannot invite anyone")
        void playerCannotInvite() {
            assertFalse(RoleHierarchy.canInvite(Role.PLAYER, Role.PLAYER));
            assertFalse(RoleHierarchy.canInvite(Role.PLAYER, Role.ADMIN));
        }
    }
}
