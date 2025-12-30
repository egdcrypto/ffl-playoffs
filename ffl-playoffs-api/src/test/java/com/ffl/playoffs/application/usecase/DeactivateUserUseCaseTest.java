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
 * Integration tests for DeactivateUserUseCase
 */
@DisplayName("DeactivateUserUseCase Integration Tests")
class DeactivateUserUseCaseTest extends IntegrationTestBase {

    @Autowired
    private UserRepository userRepository;

    private DeactivateUserUseCase useCase;
    private AccessControlService accessControlService;

    @org.junit.jupiter.api.BeforeEach
    void setUp() {
        accessControlService = new AccessControlService();
        useCase = new DeactivateUserUseCase(userRepository, accessControlService);
    }

    private User createAndSaveUser(String email, String name, String googleId, Role role) {
        User user = new User(email, name, googleId, role);
        return userRepository.save(user);
    }

    @Nested
    @DisplayName("deactivate")
    class Deactivate {

        @Test
        @DisplayName("super admin can deactivate player")
        void superAdminCanDeactivatePlayer() {
            // Given
            User superAdmin = createAndSaveUser("super@example.com", "Super Admin", "google-super", Role.SUPER_ADMIN);
            User player = createAndSaveUser("player@example.com", "Player", "google-player", Role.PLAYER);

            var command = new DeactivateUserUseCase.DeactivateUserCommand(
                    player.getId(), superAdmin.getId()
            );

            // When
            User deactivated = useCase.execute(command);

            // Then
            assertThat(deactivated.isActive()).isFalse();

            // Verify persistence
            User retrieved = userRepository.findById(player.getId()).orElse(null);
            assertThat(retrieved).isNotNull();
            assertThat(retrieved.isActive()).isFalse();
        }

        @Test
        @DisplayName("super admin can deactivate admin")
        void superAdminCanDeactivateAdmin() {
            // Given
            User superAdmin = createAndSaveUser("super@example.com", "Super Admin", "google-super", Role.SUPER_ADMIN);
            User admin = createAndSaveUser("admin@example.com", "Admin", "google-admin", Role.ADMIN);

            var command = new DeactivateUserUseCase.DeactivateUserCommand(
                    admin.getId(), superAdmin.getId()
            );

            // When
            User deactivated = useCase.execute(command);

            // Then
            assertThat(deactivated.isActive()).isFalse();
        }

        @Test
        @DisplayName("admin cannot deactivate users")
        void adminCannotDeactivateUsers() {
            // Given
            User admin = createAndSaveUser("admin@example.com", "Admin", "google-admin", Role.ADMIN);
            User player = createAndSaveUser("player@example.com", "Player", "google-player", Role.PLAYER);

            var command = new DeactivateUserUseCase.DeactivateUserCommand(
                    player.getId(), admin.getId()
            );

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(AccessControlService.AccessDeniedException.class);
        }

        @Test
        @DisplayName("player cannot deactivate users")
        void playerCannotDeactivateUsers() {
            // Given
            User player1 = createAndSaveUser("player1@example.com", "Player 1", "google-p1", Role.PLAYER);
            User player2 = createAndSaveUser("player2@example.com", "Player 2", "google-p2", Role.PLAYER);

            var command = new DeactivateUserUseCase.DeactivateUserCommand(
                    player2.getId(), player1.getId()
            );

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(AccessControlService.AccessDeniedException.class);
        }

        @Test
        @DisplayName("super admin cannot deactivate themselves")
        void superAdminCannotDeactivateThemselves() {
            // Given
            User superAdmin = createAndSaveUser("super@example.com", "Super Admin", "google-super", Role.SUPER_ADMIN);

            var command = new DeactivateUserUseCase.DeactivateUserCommand(
                    superAdmin.getId(), superAdmin.getId()
            );

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot deactivate your own account");
        }

        @Test
        @DisplayName("cannot deactivate another super admin")
        void cannotDeactivateAnotherSuperAdmin() {
            // Given
            User superAdmin1 = createAndSaveUser("super1@example.com", "Super Admin 1", "google-s1", Role.SUPER_ADMIN);
            User superAdmin2 = createAndSaveUser("super2@example.com", "Super Admin 2", "google-s2", Role.SUPER_ADMIN);

            var command = new DeactivateUserUseCase.DeactivateUserCommand(
                    superAdmin2.getId(), superAdmin1.getId()
            );

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(AccessControlService.AccessDeniedException.class)
                    .hasMessageContaining("Cannot deactivate a super admin");
        }
    }

    @Nested
    @DisplayName("reactivate")
    class Reactivate {

        @Test
        @DisplayName("super admin can reactivate user")
        void superAdminCanReactivateUser() {
            // Given
            User superAdmin = createAndSaveUser("super@example.com", "Super Admin", "google-super", Role.SUPER_ADMIN);
            User player = createAndSaveUser("player@example.com", "Player", "google-player", Role.PLAYER);
            player.deactivate();
            userRepository.save(player);

            var command = new DeactivateUserUseCase.DeactivateUserCommand(
                    player.getId(), superAdmin.getId()
            );

            // When
            User reactivated = useCase.reactivate(command);

            // Then
            assertThat(reactivated.isActive()).isTrue();

            // Verify persistence
            User retrieved = userRepository.findById(player.getId()).orElse(null);
            assertThat(retrieved).isNotNull();
            assertThat(retrieved.isActive()).isTrue();
        }

        @Test
        @DisplayName("admin cannot reactivate users")
        void adminCannotReactivateUsers() {
            // Given
            User admin = createAndSaveUser("admin@example.com", "Admin", "google-admin", Role.ADMIN);
            User player = createAndSaveUser("player@example.com", "Player", "google-player", Role.PLAYER);
            player.deactivate();
            userRepository.save(player);

            var command = new DeactivateUserUseCase.DeactivateUserCommand(
                    player.getId(), admin.getId()
            );

            // When/Then
            assertThatThrownBy(() -> useCase.reactivate(command))
                    .isInstanceOf(AccessControlService.AccessDeniedException.class);
        }
    }

    @Nested
    @DisplayName("validation")
    class Validation {

        @Test
        @DisplayName("should throw when deactivator not found")
        void shouldThrowWhenDeactivatorNotFound() {
            // Given
            User player = createAndSaveUser("player@example.com", "Player", "google-player", Role.PLAYER);
            var command = new DeactivateUserUseCase.DeactivateUserCommand(
                    player.getId(), java.util.UUID.randomUUID()
            );

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Deactivator not found");
        }

        @Test
        @DisplayName("should throw when target user not found")
        void shouldThrowWhenTargetNotFound() {
            // Given
            User superAdmin = createAndSaveUser("super@example.com", "Super Admin", "google-super", Role.SUPER_ADMIN);
            var command = new DeactivateUserUseCase.DeactivateUserCommand(
                    java.util.UUID.randomUUID(), superAdmin.getId()
            );

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("User not found");
        }
    }
}
