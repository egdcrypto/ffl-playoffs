package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.IntegrationTestBase;
import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.UserRepository;
import com.ffl.playoffs.domain.service.AccessControlService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

/**
 * Integration tests for UpdateUserUseCase
 */
@DisplayName("UpdateUserUseCase Integration Tests")
class UpdateUserUseCaseTest extends IntegrationTestBase {

    @Autowired
    private UserRepository userRepository;

    private UpdateUserUseCase useCase;
    private AccessControlService accessControlService;

    @org.junit.jupiter.api.BeforeEach
    void setUp() {
        accessControlService = new AccessControlService();
        useCase = new UpdateUserUseCase(userRepository, accessControlService);
    }

    private User createAndSaveUser(String email, String name, String googleId, Role role) {
        User user = new User(email, name, googleId, role);
        return userRepository.save(user);
    }

    @Nested
    @DisplayName("self update")
    class SelfUpdate {

        @Test
        @DisplayName("user can update their own name")
        void userCanUpdateOwnName() {
            // Given
            User user = createAndSaveUser("self@example.com", "Original Name", "google-self", Role.PLAYER);
            var command = new UpdateUserUseCase.UpdateUserCommand(
                    user.getId(), user.getId(), "Updated Name", null
            );

            // When
            User updated = useCase.execute(command);

            // Then
            assertThat(updated.getName()).isEqualTo("Updated Name");
            assertThat(updated.getEmail()).isEqualTo("self@example.com");
        }

        @Test
        @DisplayName("user can update their own email")
        void userCanUpdateOwnEmail() {
            // Given
            User user = createAndSaveUser("old@example.com", "Test User", "google-email", Role.PLAYER);
            var command = new UpdateUserUseCase.UpdateUserCommand(
                    user.getId(), user.getId(), null, "new@example.com"
            );

            // When
            User updated = useCase.execute(command);

            // Then
            assertThat(updated.getEmail()).isEqualTo("new@example.com");
        }
    }

    @Nested
    @DisplayName("super admin update")
    class SuperAdminUpdate {

        @Test
        @DisplayName("super admin can update any user")
        void superAdminCanUpdateAnyUser() {
            // Given
            User superAdmin = createAndSaveUser("super@example.com", "Super Admin", "google-super", Role.SUPER_ADMIN);
            User player = createAndSaveUser("player@example.com", "Player", "google-player", Role.PLAYER);

            var command = new UpdateUserUseCase.UpdateUserCommand(
                    player.getId(), superAdmin.getId(), "Updated Player Name", null
            );

            // When
            User updated = useCase.execute(command);

            // Then
            assertThat(updated.getName()).isEqualTo("Updated Player Name");
        }

        @Test
        @DisplayName("super admin can update admin")
        void superAdminCanUpdateAdmin() {
            // Given
            User superAdmin = createAndSaveUser("super@example.com", "Super Admin", "google-super", Role.SUPER_ADMIN);
            User admin = createAndSaveUser("admin@example.com", "Admin", "google-admin", Role.ADMIN);

            var command = new UpdateUserUseCase.UpdateUserCommand(
                    admin.getId(), superAdmin.getId(), "Updated Admin Name", null
            );

            // When
            User updated = useCase.execute(command);

            // Then
            assertThat(updated.getName()).isEqualTo("Updated Admin Name");
        }
    }

    @Nested
    @DisplayName("unauthorized update")
    class UnauthorizedUpdate {

        @Test
        @DisplayName("player cannot update another user")
        void playerCannotUpdateAnotherUser() {
            // Given
            User player1 = createAndSaveUser("player1@example.com", "Player 1", "google-p1", Role.PLAYER);
            User player2 = createAndSaveUser("player2@example.com", "Player 2", "google-p2", Role.PLAYER);

            var command = new UpdateUserUseCase.UpdateUserCommand(
                    player2.getId(), player1.getId(), "Hacked Name", null
            );

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(AccessControlService.AccessDeniedException.class);
        }

        @Test
        @DisplayName("admin cannot update another admin")
        void adminCannotUpdateAnotherAdmin() {
            // Given
            User admin1 = createAndSaveUser("admin1@example.com", "Admin 1", "google-a1", Role.ADMIN);
            User admin2 = createAndSaveUser("admin2@example.com", "Admin 2", "google-a2", Role.ADMIN);

            var command = new UpdateUserUseCase.UpdateUserCommand(
                    admin2.getId(), admin1.getId(), "Hacked Name", null
            );

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(AccessControlService.AccessDeniedException.class);
        }

        @Test
        @DisplayName("admin cannot update super admin")
        void adminCannotUpdateSuperAdmin() {
            // Given
            User admin = createAndSaveUser("admin@example.com", "Admin", "google-admin", Role.ADMIN);
            User superAdmin = createAndSaveUser("super@example.com", "Super Admin", "google-super", Role.SUPER_ADMIN);

            var command = new UpdateUserUseCase.UpdateUserCommand(
                    superAdmin.getId(), admin.getId(), "Hacked Name", null
            );

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(AccessControlService.AccessDeniedException.class);
        }
    }

    @Nested
    @DisplayName("validation")
    class Validation {

        @Test
        @DisplayName("should reject duplicate email")
        void shouldRejectDuplicateEmail() {
            // Given
            User user1 = createAndSaveUser("user1@example.com", "User 1", "google-u1", Role.PLAYER);
            User user2 = createAndSaveUser("user2@example.com", "User 2", "google-u2", Role.PLAYER);

            var command = new UpdateUserUseCase.UpdateUserCommand(
                    user2.getId(), user2.getId(), null, "user1@example.com"
            );

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Email already in use");
        }

        @Test
        @DisplayName("should throw when updater not found")
        void shouldThrowWhenUpdaterNotFound() {
            // Given
            User user = createAndSaveUser("user@example.com", "User", "google-u", Role.PLAYER);
            var command = new UpdateUserUseCase.UpdateUserCommand(
                    user.getId(), java.util.UUID.randomUUID(), "New Name", null
            );

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Updater not found");
        }

        @Test
        @DisplayName("should throw when target user not found")
        void shouldThrowWhenTargetNotFound() {
            // Given
            User updater = createAndSaveUser("updater@example.com", "Updater", "google-up", Role.SUPER_ADMIN);
            var command = new UpdateUserUseCase.UpdateUserCommand(
                    java.util.UUID.randomUUID(), updater.getId(), "New Name", null
            );

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("User not found");
        }
    }
}
