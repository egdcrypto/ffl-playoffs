package com.ffl.playoffs.domain.model.auth;

import com.ffl.playoffs.domain.model.Role;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.Set;

import static org.assertj.core.api.Assertions.*;

@DisplayName("Permission Enum Tests")
class PermissionTest {

    @Test
    @DisplayName("should have expected number of permissions")
    void shouldHaveExpectedPermissions() {
        assertThat(Permission.values().length).isGreaterThan(20);
    }

    @Test
    @DisplayName("each permission should have unique code")
    void eachPermissionShouldHaveUniqueCode() {
        Set<String> codes = new java.util.HashSet<>();
        for (Permission permission : Permission.values()) {
            assertThat(codes.add(permission.getCode()))
                    .withFailMessage("Duplicate code found: " + permission.getCode())
                    .isTrue();
        }
    }

    @Nested
    @DisplayName("fromCode tests")
    class FromCodeTests {

        @Test
        @DisplayName("should resolve permission from code")
        void shouldResolveFromCode() {
            assertThat(Permission.fromCode("view_users")).isEqualTo(Permission.VIEW_USERS);
            assertThat(Permission.fromCode("create_league")).isEqualTo(Permission.CREATE_LEAGUE);
            assertThat(Permission.fromCode("build_roster")).isEqualTo(Permission.BUILD_ROSTER);
        }

        @Test
        @DisplayName("should resolve from code case insensitively")
        void shouldResolveFromCodeCaseInsensitively() {
            assertThat(Permission.fromCode("VIEW_USERS")).isEqualTo(Permission.VIEW_USERS);
            assertThat(Permission.fromCode("Create_League")).isEqualTo(Permission.CREATE_LEAGUE);
        }

        @Test
        @DisplayName("should throw exception for unknown code")
        void shouldThrowExceptionForUnknownCode() {
            assertThatThrownBy(() -> Permission.fromCode("unknown_permission"))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Unknown permission code");
        }
    }

    @Nested
    @DisplayName("getByCategory tests")
    class GetByCategoryTests {

        @Test
        @DisplayName("should get all user management permissions")
        void shouldGetAllUserManagementPermissions() {
            Set<Permission> permissions = Permission.getByCategory(Permission.PermissionCategory.USER_MANAGEMENT);
            assertThat(permissions).contains(
                    Permission.VIEW_USERS,
                    Permission.CREATE_USERS,
                    Permission.UPDATE_USERS,
                    Permission.DELETE_USERS,
                    Permission.ASSIGN_ROLES
            );
        }

        @Test
        @DisplayName("should get all player permissions")
        void shouldGetAllPlayerPermissions() {
            Set<Permission> permissions = Permission.getByCategory(Permission.PermissionCategory.PLAYER);
            assertThat(permissions).contains(
                    Permission.VIEW_ROSTER,
                    Permission.BUILD_ROSTER,
                    Permission.VIEW_STANDINGS,
                    Permission.VIEW_SCORES
            );
        }
    }

    @Nested
    @DisplayName("getDefaultPermissionsForRole tests")
    class GetDefaultPermissionsForRoleTests {

        @Test
        @DisplayName("SUPER_ADMIN should have all permissions")
        void superAdminShouldHaveAllPermissions() {
            Set<Permission> permissions = Permission.getDefaultPermissionsForRole(Role.SUPER_ADMIN);
            assertThat(permissions).containsExactlyInAnyOrder(Permission.values());
        }

        @Test
        @DisplayName("ADMIN should have league management and player permissions")
        void adminShouldHaveLeagueAndPlayerPermissions() {
            Set<Permission> permissions = Permission.getDefaultPermissionsForRole(Role.ADMIN);

            // Should have league management permissions
            assertThat(permissions).contains(
                    Permission.CREATE_LEAGUE,
                    Permission.VIEW_LEAGUES,
                    Permission.UPDATE_LEAGUE,
                    Permission.DELETE_LEAGUE,
                    Permission.CONFIGURE_LEAGUE,
                    Permission.INVITE_PLAYERS
            );

            // Should have player permissions
            assertThat(permissions).contains(
                    Permission.VIEW_ROSTER,
                    Permission.BUILD_ROSTER,
                    Permission.VIEW_STANDINGS,
                    Permission.VIEW_SCORES
            );

            // Should NOT have super admin specific permissions
            assertThat(permissions).doesNotContain(
                    Permission.INVITE_ADMINS,
                    Permission.UPDATE_SYSTEM_CONFIG
            );
        }

        @Test
        @DisplayName("PLAYER should have only player permissions")
        void playerShouldHaveOnlyPlayerPermissions() {
            Set<Permission> permissions = Permission.getDefaultPermissionsForRole(Role.PLAYER);

            // Should have player permissions
            assertThat(permissions).contains(
                    Permission.VIEW_ROSTER,
                    Permission.BUILD_ROSTER,
                    Permission.VIEW_STANDINGS,
                    Permission.VIEW_SCORES
            );

            // Should NOT have admin permissions
            assertThat(permissions).doesNotContain(
                    Permission.CREATE_LEAGUE,
                    Permission.INVITE_ADMINS,
                    Permission.VIEW_USERS
            );
        }
    }

    @Nested
    @DisplayName("permission category tests")
    class PermissionCategoryTests {

        @Test
        @DisplayName("isSystemPermission should return true for system category")
        void isSystemPermissionShouldReturnTrueForSystemCategory() {
            assertThat(Permission.VIEW_SYSTEM_CONFIG.isSystemPermission()).isTrue();
            assertThat(Permission.UPDATE_SYSTEM_CONFIG.isSystemPermission()).isTrue();
            assertThat(Permission.SYNC_NFL_DATA.isSystemPermission()).isTrue();
            assertThat(Permission.VIEW_AUDIT_LOGS.isSystemPermission()).isTrue();

            assertThat(Permission.VIEW_USERS.isSystemPermission()).isFalse();
            assertThat(Permission.BUILD_ROSTER.isSystemPermission()).isFalse();
        }

        @Test
        @DisplayName("isAdminOnly should return true for admin-restricted categories")
        void isAdminOnlyShouldReturnTrueForAdminCategories() {
            assertThat(Permission.VIEW_USERS.isAdminOnly()).isTrue();
            assertThat(Permission.INVITE_ADMINS.isAdminOnly()).isTrue();
            assertThat(Permission.UPDATE_SYSTEM_CONFIG.isAdminOnly()).isTrue();

            assertThat(Permission.BUILD_ROSTER.isAdminOnly()).isFalse();
            assertThat(Permission.VIEW_STANDINGS.isAdminOnly()).isFalse();
        }
    }

    @Nested
    @DisplayName("PermissionCategory tests")
    class PermissionCategoryEnumTests {

        @Test
        @DisplayName("should have display names")
        void shouldHaveDisplayNames() {
            assertThat(Permission.PermissionCategory.USER_MANAGEMENT.getDisplayName()).isEqualTo("User Management");
            assertThat(Permission.PermissionCategory.ADMIN.getDisplayName()).isEqualTo("Administration");
            assertThat(Permission.PermissionCategory.PLAYER.getDisplayName()).isEqualTo("Player");
        }
    }
}
