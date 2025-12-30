package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.IntegrationTestBase;
import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.Permission;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.UserRepository;
import com.ffl.playoffs.domain.service.AccessControlService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Set;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Integration tests for CheckPermissionUseCase
 */
@DisplayName("CheckPermissionUseCase Integration Tests")
class CheckPermissionUseCaseTest extends IntegrationTestBase {

    @Autowired
    private UserRepository userRepository;

    private CheckPermissionUseCase useCase;
    private AccessControlService accessControlService;

    @org.junit.jupiter.api.BeforeEach
    void setUp() {
        accessControlService = new AccessControlService();
        useCase = new CheckPermissionUseCase(userRepository, accessControlService);
    }

    private User createAndSaveUser(String email, String name, String googleId, Role role) {
        User user = new User(email, name, googleId, role);
        return userRepository.save(user);
    }

    @Nested
    @DisplayName("hasPermission")
    class HasPermission {

        @Test
        @DisplayName("super admin has all permissions")
        void superAdminHasAllPermissions() {
            // Given
            User superAdmin = createAndSaveUser("super@example.com", "Super Admin", "google-super", Role.SUPER_ADMIN);

            // Then
            assertThat(useCase.hasPermission(superAdmin.getId(), Permission.VIEW_LEAGUE_STANDINGS)).isTrue();
            assertThat(useCase.hasPermission(superAdmin.getId(), Permission.CREATE_LEAGUE)).isTrue();
            assertThat(useCase.hasPermission(superAdmin.getId(), Permission.MANAGE_ADMINS)).isTrue();
            assertThat(useCase.hasPermission(superAdmin.getId(), Permission.VIEW_ALL_LEAGUES)).isTrue();
        }

        @Test
        @DisplayName("admin has admin and player permissions")
        void adminHasAdminAndPlayerPermissions() {
            // Given
            User admin = createAndSaveUser("admin@example.com", "Admin", "google-admin", Role.ADMIN);

            // Then
            assertThat(useCase.hasPermission(admin.getId(), Permission.VIEW_LEAGUE_STANDINGS)).isTrue();
            assertThat(useCase.hasPermission(admin.getId(), Permission.CREATE_LEAGUE)).isTrue();
            assertThat(useCase.hasPermission(admin.getId(), Permission.MANAGE_ADMINS)).isFalse();
            assertThat(useCase.hasPermission(admin.getId(), Permission.VIEW_ALL_LEAGUES)).isFalse();
        }

        @Test
        @DisplayName("player has only player permissions")
        void playerHasOnlyPlayerPermissions() {
            // Given
            User player = createAndSaveUser("player@example.com", "Player", "google-player", Role.PLAYER);

            // Then
            assertThat(useCase.hasPermission(player.getId(), Permission.VIEW_LEAGUE_STANDINGS)).isTrue();
            assertThat(useCase.hasPermission(player.getId(), Permission.BUILD_ROSTER)).isTrue();
            assertThat(useCase.hasPermission(player.getId(), Permission.CREATE_LEAGUE)).isFalse();
            assertThat(useCase.hasPermission(player.getId(), Permission.MANAGE_ADMINS)).isFalse();
        }

        @Test
        @DisplayName("returns false for nonexistent user")
        void returnsFalseForNonexistentUser() {
            // When/Then
            assertThat(useCase.hasPermission(UUID.randomUUID(), Permission.VIEW_LEAGUE_STANDINGS)).isFalse();
        }
    }

    @Nested
    @DisplayName("hasRole")
    class HasRole {

        @Test
        @DisplayName("super admin has all roles")
        void superAdminHasAllRoles() {
            // Given
            User superAdmin = createAndSaveUser("super@example.com", "Super Admin", "google-super", Role.SUPER_ADMIN);

            // Then
            assertThat(useCase.hasRole(superAdmin.getId(), Role.PLAYER)).isTrue();
            assertThat(useCase.hasRole(superAdmin.getId(), Role.ADMIN)).isTrue();
            assertThat(useCase.hasRole(superAdmin.getId(), Role.SUPER_ADMIN)).isTrue();
        }

        @Test
        @DisplayName("admin has admin and player roles")
        void adminHasAdminAndPlayerRoles() {
            // Given
            User admin = createAndSaveUser("admin@example.com", "Admin", "google-admin", Role.ADMIN);

            // Then
            assertThat(useCase.hasRole(admin.getId(), Role.PLAYER)).isTrue();
            assertThat(useCase.hasRole(admin.getId(), Role.ADMIN)).isTrue();
            assertThat(useCase.hasRole(admin.getId(), Role.SUPER_ADMIN)).isFalse();
        }

        @Test
        @DisplayName("player has only player role")
        void playerHasOnlyPlayerRole() {
            // Given
            User player = createAndSaveUser("player@example.com", "Player", "google-player", Role.PLAYER);

            // Then
            assertThat(useCase.hasRole(player.getId(), Role.PLAYER)).isTrue();
            assertThat(useCase.hasRole(player.getId(), Role.ADMIN)).isFalse();
            assertThat(useCase.hasRole(player.getId(), Role.SUPER_ADMIN)).isFalse();
        }

        @Test
        @DisplayName("returns false for nonexistent user")
        void returnsFalseForNonexistentUser() {
            // When/Then
            assertThat(useCase.hasRole(UUID.randomUUID(), Role.PLAYER)).isFalse();
        }
    }

    @Nested
    @DisplayName("getPermissions")
    class GetPermissions {

        @Test
        @DisplayName("returns all permissions for super admin")
        void returnsAllPermissionsForSuperAdmin() {
            // Given
            User superAdmin = createAndSaveUser("super@example.com", "Super Admin", "google-super", Role.SUPER_ADMIN);

            // When
            Set<Permission> permissions = useCase.getPermissions(superAdmin.getId());

            // Then
            assertThat(permissions).hasSize(Permission.values().length);
            assertThat(permissions).contains(Permission.MANAGE_ADMINS, Permission.CREATE_LEAGUE, Permission.VIEW_LEAGUE_STANDINGS);
        }

        @Test
        @DisplayName("returns limited permissions for player")
        void returnsLimitedPermissionsForPlayer() {
            // Given
            User player = createAndSaveUser("player@example.com", "Player", "google-player", Role.PLAYER);

            // When
            Set<Permission> permissions = useCase.getPermissions(player.getId());

            // Then
            assertThat(permissions).contains(Permission.VIEW_LEAGUE_STANDINGS, Permission.BUILD_ROSTER);
            assertThat(permissions).doesNotContain(Permission.CREATE_LEAGUE, Permission.MANAGE_ADMINS);
        }

        @Test
        @DisplayName("returns empty set for nonexistent user")
        void returnsEmptySetForNonexistentUser() {
            // When
            Set<Permission> permissions = useCase.getPermissions(UUID.randomUUID());

            // Then
            assertThat(permissions).isEmpty();
        }
    }

    @Nested
    @DisplayName("canAccessLeague")
    class CanAccessLeague {

        private final UUID leagueId = UUID.randomUUID();

        @Test
        @DisplayName("super admin can access any league")
        void superAdminCanAccessAnyLeague() {
            // Given
            User superAdmin = createAndSaveUser("super@example.com", "Super Admin", "google-super", Role.SUPER_ADMIN);

            // Then
            assertThat(useCase.canAccessLeague(superAdmin.getId(), leagueId, false, false)).isTrue();
        }

        @Test
        @DisplayName("owner can access their league")
        void ownerCanAccessTheirLeague() {
            // Given
            User admin = createAndSaveUser("admin@example.com", "Admin", "google-admin", Role.ADMIN);

            // Then
            assertThat(useCase.canAccessLeague(admin.getId(), leagueId, true, false)).isTrue();
        }

        @Test
        @DisplayName("member can access their league")
        void memberCanAccessTheirLeague() {
            // Given
            User player = createAndSaveUser("player@example.com", "Player", "google-player", Role.PLAYER);

            // Then
            assertThat(useCase.canAccessLeague(player.getId(), leagueId, false, true)).isTrue();
        }

        @Test
        @DisplayName("non-member cannot access league")
        void nonMemberCannotAccessLeague() {
            // Given
            User player = createAndSaveUser("player@example.com", "Player", "google-player", Role.PLAYER);

            // Then
            assertThat(useCase.canAccessLeague(player.getId(), leagueId, false, false)).isFalse();
        }

        @Test
        @DisplayName("returns false for nonexistent user")
        void returnsFalseForNonexistentUser() {
            // When/Then
            assertThat(useCase.canAccessLeague(UUID.randomUUID(), leagueId, false, false)).isFalse();
        }
    }

    @Nested
    @DisplayName("canManageLeague")
    class CanManageLeague {

        private final UUID leagueId = UUID.randomUUID();

        @Test
        @DisplayName("super admin can manage any league")
        void superAdminCanManageAnyLeague() {
            // Given
            User superAdmin = createAndSaveUser("super@example.com", "Super Admin", "google-super", Role.SUPER_ADMIN);

            // Then
            assertThat(useCase.canManageLeague(superAdmin.getId(), leagueId, false)).isTrue();
        }

        @Test
        @DisplayName("owner can manage their league")
        void ownerCanManageTheirLeague() {
            // Given
            User admin = createAndSaveUser("admin@example.com", "Admin", "google-admin", Role.ADMIN);

            // Then
            assertThat(useCase.canManageLeague(admin.getId(), leagueId, true)).isTrue();
        }

        @Test
        @DisplayName("admin cannot manage non-owned league")
        void adminCannotManageNonOwnedLeague() {
            // Given
            User admin = createAndSaveUser("admin@example.com", "Admin", "google-admin", Role.ADMIN);

            // Then
            assertThat(useCase.canManageLeague(admin.getId(), leagueId, false)).isFalse();
        }

        @Test
        @DisplayName("player cannot manage any league")
        void playerCannotManageAnyLeague() {
            // Given
            User player = createAndSaveUser("player@example.com", "Player", "google-player", Role.PLAYER);

            // Then
            assertThat(useCase.canManageLeague(player.getId(), leagueId, true)).isFalse();
        }

        @Test
        @DisplayName("returns false for nonexistent user")
        void returnsFalseForNonexistentUser() {
            // When/Then
            assertThat(useCase.canManageLeague(UUID.randomUUID(), leagueId, true)).isFalse();
        }
    }
}
