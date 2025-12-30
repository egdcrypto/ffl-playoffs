package com.ffl.playoffs.domain.service;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.Permission;
import com.ffl.playoffs.domain.model.Role;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for AccessControlService
 */
class AccessControlServiceTest {

    private AccessControlService accessControlService;

    @BeforeEach
    void setUp() {
        accessControlService = new AccessControlService();
    }

    private User createUser(Role role, boolean active) {
        User user = new User("test@example.com", "Test User", "google-123", role);
        if (!active) {
            user.deactivate();
        }
        return user;
    }

    @Nested
    @DisplayName("hasPermission")
    class HasPermission {

        @Test
        @DisplayName("should return true for valid permission")
        void shouldReturnTrueForValidPermission() {
            User admin = createUser(Role.ADMIN, true);
            assertTrue(accessControlService.hasPermission(admin, Permission.CREATE_LEAGUE));
        }

        @Test
        @DisplayName("should return false for insufficient permission")
        void shouldReturnFalseForInsufficientPermission() {
            User player = createUser(Role.PLAYER, true);
            assertFalse(accessControlService.hasPermission(player, Permission.CREATE_LEAGUE));
        }

        @Test
        @DisplayName("should return false for inactive user")
        void shouldReturnFalseForInactiveUser() {
            User admin = createUser(Role.ADMIN, false);
            assertFalse(accessControlService.hasPermission(admin, Permission.CREATE_LEAGUE));
        }

        @Test
        @DisplayName("should return false for null user")
        void shouldReturnFalseForNullUser() {
            assertFalse(accessControlService.hasPermission(null, Permission.CREATE_LEAGUE));
        }
    }

    @Nested
    @DisplayName("canAccessLeague")
    class CanAccessLeague {

        private final UUID leagueId = UUID.randomUUID();

        @Test
        @DisplayName("SUPER_ADMIN can access any league")
        void superAdminCanAccessAnyLeague() {
            User superAdmin = createUser(Role.SUPER_ADMIN, true);
            assertTrue(accessControlService.canAccessLeague(superAdmin, leagueId, false, false));
        }

        @Test
        @DisplayName("ADMIN can access owned leagues")
        void adminCanAccessOwnedLeagues() {
            User admin = createUser(Role.ADMIN, true);
            assertTrue(accessControlService.canAccessLeague(admin, leagueId, true, false));
        }

        @Test
        @DisplayName("ADMIN cannot access non-owned leagues")
        void adminCannotAccessNonOwnedLeagues() {
            User admin = createUser(Role.ADMIN, true);
            assertFalse(accessControlService.canAccessLeague(admin, leagueId, false, false));
        }

        @Test
        @DisplayName("ADMIN can access leagues they are members of")
        void adminCanAccessMemberLeagues() {
            User admin = createUser(Role.ADMIN, true);
            assertTrue(accessControlService.canAccessLeague(admin, leagueId, false, true));
        }

        @Test
        @DisplayName("PLAYER can access member leagues")
        void playerCanAccessMemberLeagues() {
            User player = createUser(Role.PLAYER, true);
            assertTrue(accessControlService.canAccessLeague(player, leagueId, false, true));
        }

        @Test
        @DisplayName("PLAYER cannot access non-member leagues")
        void playerCannotAccessNonMemberLeagues() {
            User player = createUser(Role.PLAYER, true);
            assertFalse(accessControlService.canAccessLeague(player, leagueId, false, false));
        }
    }

    @Nested
    @DisplayName("canManageLeague")
    class CanManageLeague {

        private final UUID leagueId = UUID.randomUUID();

        @Test
        @DisplayName("SUPER_ADMIN can manage any league")
        void superAdminCanManageAnyLeague() {
            User superAdmin = createUser(Role.SUPER_ADMIN, true);
            assertTrue(accessControlService.canManageLeague(superAdmin, leagueId, false));
        }

        @Test
        @DisplayName("ADMIN can manage owned leagues")
        void adminCanManageOwnedLeagues() {
            User admin = createUser(Role.ADMIN, true);
            assertTrue(accessControlService.canManageLeague(admin, leagueId, true));
        }

        @Test
        @DisplayName("ADMIN cannot manage non-owned leagues")
        void adminCannotManageNonOwnedLeagues() {
            User admin = createUser(Role.ADMIN, true);
            assertFalse(accessControlService.canManageLeague(admin, leagueId, false));
        }

        @Test
        @DisplayName("PLAYER cannot manage any league")
        void playerCannotManageLeagues() {
            User player = createUser(Role.PLAYER, true);
            assertFalse(accessControlService.canManageLeague(player, leagueId, true));
        }
    }

    @Nested
    @DisplayName("canViewSystemWideData")
    class CanViewSystemWideData {

        @Test
        @DisplayName("Only SUPER_ADMIN can view system-wide data")
        void onlySuperAdminCanViewSystemWideData() {
            assertTrue(accessControlService.canViewSystemWideData(createUser(Role.SUPER_ADMIN, true)));
            assertFalse(accessControlService.canViewSystemWideData(createUser(Role.ADMIN, true)));
            assertFalse(accessControlService.canViewSystemWideData(createUser(Role.PLAYER, true)));
        }
    }

    @Nested
    @DisplayName("canManageAdmins")
    class CanManageAdmins {

        @Test
        @DisplayName("Only SUPER_ADMIN can manage admins")
        void onlySuperAdminCanManageAdmins() {
            assertTrue(accessControlService.canManageAdmins(createUser(Role.SUPER_ADMIN, true)));
            assertFalse(accessControlService.canManageAdmins(createUser(Role.ADMIN, true)));
            assertFalse(accessControlService.canManageAdmins(createUser(Role.PLAYER, true)));
        }
    }

    @Nested
    @DisplayName("canCreateLeagues")
    class CanCreateLeagues {

        @Test
        @DisplayName("ADMIN and SUPER_ADMIN can create leagues")
        void adminAndSuperAdminCanCreateLeagues() {
            assertTrue(accessControlService.canCreateLeagues(createUser(Role.SUPER_ADMIN, true)));
            assertTrue(accessControlService.canCreateLeagues(createUser(Role.ADMIN, true)));
            assertFalse(accessControlService.canCreateLeagues(createUser(Role.PLAYER, true)));
        }
    }

    @Nested
    @DisplayName("requireRole")
    class RequireRole {

        @Test
        @DisplayName("should not throw for sufficient role")
        void shouldNotThrowForSufficientRole() {
            User admin = createUser(Role.ADMIN, true);
            assertDoesNotThrow(() -> accessControlService.requireRole(admin, Role.PLAYER));
            assertDoesNotThrow(() -> accessControlService.requireRole(admin, Role.ADMIN));
        }

        @Test
        @DisplayName("should throw for insufficient role")
        void shouldThrowForInsufficientRole() {
            User player = createUser(Role.PLAYER, true);
            assertThrows(AccessControlService.AccessDeniedException.class,
                    () -> accessControlService.requireRole(player, Role.ADMIN));
        }

        @Test
        @DisplayName("should throw for inactive user")
        void shouldThrowForInactiveUser() {
            User admin = createUser(Role.ADMIN, false);
            assertThrows(AccessControlService.AccessDeniedException.class,
                    () -> accessControlService.requireRole(admin, Role.PLAYER));
        }
    }

    @Nested
    @DisplayName("requirePermission")
    class RequirePermission {

        @Test
        @DisplayName("should not throw for valid permission")
        void shouldNotThrowForValidPermission() {
            User admin = createUser(Role.ADMIN, true);
            assertDoesNotThrow(() -> accessControlService.requirePermission(admin, Permission.CREATE_LEAGUE));
        }

        @Test
        @DisplayName("should throw for insufficient permission")
        void shouldThrowForInsufficientPermission() {
            User player = createUser(Role.PLAYER, true);
            assertThrows(AccessControlService.AccessDeniedException.class,
                    () -> accessControlService.requirePermission(player, Permission.CREATE_LEAGUE));
        }
    }
}
