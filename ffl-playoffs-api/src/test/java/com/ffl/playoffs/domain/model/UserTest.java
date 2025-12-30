package com.ffl.playoffs.domain.model;

import com.ffl.playoffs.domain.aggregate.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;

import static org.assertj.core.api.Assertions.*;

@DisplayName("User Domain Entity Tests")
class UserTest {

    @Nested
    @DisplayName("Construction")
    class Construction {

        @Test
        @DisplayName("should create user with default constructor")
        void shouldCreateUserWithDefaultConstructor() {
            // When
            User user = new User();

            // Then
            assertThat(user.getId()).isNotNull();
            assertThat(user.getCreatedAt()).isNotNull();
            assertThat(user.isActive()).isTrue();
        }

        @Test
        @DisplayName("should create user with full constructor")
        void shouldCreateUserWithFullConstructor() {
            // Given
            String email = "test@example.com";
            String name = "Test User";
            String googleId = "google-123";
            Role role = Role.ADMIN;

            // When
            User user = new User(email, name, googleId, role);

            // Then
            assertThat(user.getId()).isNotNull();
            assertThat(user.getEmail()).isEqualTo(email);
            assertThat(user.getName()).isEqualTo(name);
            assertThat(user.getGoogleId()).isEqualTo(googleId);
            assertThat(user.getRole()).isEqualTo(role);
            assertThat(user.getCreatedAt()).isNotNull();
            assertThat(user.isActive()).isTrue();
            assertThat(user.getLastLoginAt()).isNull();
        }
    }

    @Nested
    @DisplayName("Role Hierarchy")
    class RoleHierarchy {

        @Test
        @DisplayName("SUPER_ADMIN should have all role permissions")
        void superAdminShouldHaveAllRolePermissions() {
            // Given
            User superAdmin = new User("admin@example.com", "Super Admin", "google-1", Role.SUPER_ADMIN);

            // Then
            assertThat(superAdmin.hasRole(Role.SUPER_ADMIN)).isTrue();
            assertThat(superAdmin.hasRole(Role.ADMIN)).isTrue();
            assertThat(superAdmin.hasRole(Role.PLAYER)).isTrue();
        }

        @Test
        @DisplayName("ADMIN should have ADMIN and PLAYER permissions but not SUPER_ADMIN")
        void adminShouldHaveAdminAndPlayerPermissions() {
            // Given
            User admin = new User("admin@example.com", "Admin", "google-2", Role.ADMIN);

            // Then
            assertThat(admin.hasRole(Role.ADMIN)).isTrue();
            assertThat(admin.hasRole(Role.PLAYER)).isTrue();
            assertThat(admin.hasRole(Role.SUPER_ADMIN)).isFalse();
        }

        @Test
        @DisplayName("PLAYER should only have PLAYER permissions")
        void playerShouldOnlyHavePlayerPermissions() {
            // Given
            User player = new User("player@example.com", "Player", "google-3", Role.PLAYER);

            // Then
            assertThat(player.hasRole(Role.PLAYER)).isTrue();
            assertThat(player.hasRole(Role.ADMIN)).isFalse();
            assertThat(player.hasRole(Role.SUPER_ADMIN)).isFalse();
        }

        @Test
        @DisplayName("isSuperAdmin should return true only for SUPER_ADMIN role")
        void isSuperAdminShouldReturnTrueOnlyForSuperAdmin() {
            // Given
            User superAdmin = new User("super@example.com", "Super", "google-1", Role.SUPER_ADMIN);
            User admin = new User("admin@example.com", "Admin", "google-2", Role.ADMIN);
            User player = new User("player@example.com", "Player", "google-3", Role.PLAYER);

            // Then
            assertThat(superAdmin.isSuperAdmin()).isTrue();
            assertThat(admin.isSuperAdmin()).isFalse();
            assertThat(player.isSuperAdmin()).isFalse();
        }

        @Test
        @DisplayName("isAdmin should return true for ADMIN and SUPER_ADMIN")
        void isAdminShouldReturnTrueForAdminAndSuperAdmin() {
            // Given
            User superAdmin = new User("super@example.com", "Super", "google-1", Role.SUPER_ADMIN);
            User admin = new User("admin@example.com", "Admin", "google-2", Role.ADMIN);
            User player = new User("player@example.com", "Player", "google-3", Role.PLAYER);

            // Then
            assertThat(superAdmin.isAdmin()).isTrue();
            assertThat(admin.isAdmin()).isTrue();
            assertThat(player.isAdmin()).isFalse();
        }
    }

    @Nested
    @DisplayName("Activation and Deactivation")
    class ActivationAndDeactivation {

        @Test
        @DisplayName("should deactivate user")
        void shouldDeactivateUser() {
            // Given
            User user = new User("test@example.com", "Test", "google-1", Role.PLAYER);
            assertThat(user.isActive()).isTrue();

            // When
            user.deactivate();

            // Then
            assertThat(user.isActive()).isFalse();
        }

        @Test
        @DisplayName("should activate user")
        void shouldActivateUser() {
            // Given
            User user = new User("test@example.com", "Test", "google-1", Role.PLAYER);
            user.deactivate();
            assertThat(user.isActive()).isFalse();

            // When
            user.activate();

            // Then
            assertThat(user.isActive()).isTrue();
        }

        @Test
        @DisplayName("should allow multiple deactivate calls")
        void shouldAllowMultipleDeactivateCalls() {
            // Given
            User user = new User("test@example.com", "Test", "google-1", Role.PLAYER);

            // When
            user.deactivate();
            user.deactivate();

            // Then
            assertThat(user.isActive()).isFalse();
        }

        @Test
        @DisplayName("should allow multiple activate calls")
        void shouldAllowMultipleActivateCalls() {
            // Given
            User user = new User("test@example.com", "Test", "google-1", Role.PLAYER);

            // When
            user.activate();
            user.activate();

            // Then
            assertThat(user.isActive()).isTrue();
        }
    }

    @Nested
    @DisplayName("Last Login Tracking")
    class LastLoginTracking {

        @Test
        @DisplayName("should update last login timestamp")
        void shouldUpdateLastLoginTimestamp() {
            // Given
            User user = new User("test@example.com", "Test", "google-1", Role.PLAYER);
            assertThat(user.getLastLoginAt()).isNull();

            LocalDateTime beforeUpdate = LocalDateTime.now();

            // When
            user.updateLastLogin();

            // Then
            assertThat(user.getLastLoginAt()).isNotNull();
            assertThat(user.getLastLoginAt()).isAfterOrEqualTo(beforeUpdate);
        }

        @Test
        @DisplayName("should update last login multiple times")
        void shouldUpdateLastLoginMultipleTimes() throws InterruptedException {
            // Given
            User user = new User("test@example.com", "Test", "google-1", Role.PLAYER);

            // When
            user.updateLastLogin();
            LocalDateTime firstLogin = user.getLastLoginAt();

            Thread.sleep(10); // Ensure time passes

            user.updateLastLogin();
            LocalDateTime secondLogin = user.getLastLoginAt();

            // Then
            assertThat(secondLogin).isAfterOrEqualTo(firstLogin);
        }
    }

    @Nested
    @DisplayName("Getters and Setters")
    class GettersAndSetters {

        private User user;

        @BeforeEach
        void setUp() {
            user = new User();
        }

        @Test
        @DisplayName("should get and set email")
        void shouldGetAndSetEmail() {
            // Given
            String email = "new@example.com";

            // When
            user.setEmail(email);

            // Then
            assertThat(user.getEmail()).isEqualTo(email);
        }

        @Test
        @DisplayName("should get and set name")
        void shouldGetAndSetName() {
            // Given
            String name = "New Name";

            // When
            user.setName(name);

            // Then
            assertThat(user.getName()).isEqualTo(name);
        }

        @Test
        @DisplayName("should get and set googleId")
        void shouldGetAndSetGoogleId() {
            // Given
            String googleId = "new-google-id";

            // When
            user.setGoogleId(googleId);

            // Then
            assertThat(user.getGoogleId()).isEqualTo(googleId);
        }

        @Test
        @DisplayName("should get and set role")
        void shouldGetAndSetRole() {
            // Given
            Role role = Role.ADMIN;

            // When
            user.setRole(role);

            // Then
            assertThat(user.getRole()).isEqualTo(role);
        }

        @Test
        @DisplayName("should get and set active status")
        void shouldGetAndSetActiveStatus() {
            // When
            user.setActive(false);

            // Then
            assertThat(user.isActive()).isFalse();
        }
    }
}
