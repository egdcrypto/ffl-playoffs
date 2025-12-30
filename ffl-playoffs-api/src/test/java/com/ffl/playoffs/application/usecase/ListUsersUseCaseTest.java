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

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

/**
 * Integration tests for ListUsersUseCase
 */
@DisplayName("ListUsersUseCase Integration Tests")
class ListUsersUseCaseTest extends IntegrationTestBase {

    @Autowired
    private UserRepository userRepository;

    private ListUsersUseCase useCase;
    private AccessControlService accessControlService;

    @org.junit.jupiter.api.BeforeEach
    void setUp() {
        accessControlService = new AccessControlService();
        useCase = new ListUsersUseCase(userRepository, accessControlService);
    }

    private User createAndSaveUser(String email, String name, String googleId, Role role) {
        User user = new User(email, name, googleId, role);
        return userRepository.save(user);
    }

    @Nested
    @DisplayName("list all users")
    class ListAllUsers {

        @Test
        @DisplayName("super admin can list all users")
        void superAdminCanListAllUsers() {
            // Given
            User superAdmin = createAndSaveUser("super@example.com", "Super Admin", "google-super", Role.SUPER_ADMIN);
            createAndSaveUser("admin@example.com", "Admin", "google-admin", Role.ADMIN);
            createAndSaveUser("player@example.com", "Player", "google-player", Role.PLAYER);

            var command = new ListUsersUseCase.ListUsersCommand(superAdmin.getId());

            // When
            List<User> users = useCase.execute(command);

            // Then
            assertThat(users).hasSize(3);
        }

        @Test
        @DisplayName("admin cannot list all users")
        void adminCannotListAllUsers() {
            // Given
            User admin = createAndSaveUser("admin@example.com", "Admin", "google-admin", Role.ADMIN);

            var command = new ListUsersUseCase.ListUsersCommand(admin.getId());

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(AccessControlService.AccessDeniedException.class)
                    .hasMessageContaining("Only super admin");
        }

        @Test
        @DisplayName("player cannot list users")
        void playerCannotListUsers() {
            // Given
            User player = createAndSaveUser("player@example.com", "Player", "google-player", Role.PLAYER);

            var command = new ListUsersUseCase.ListUsersCommand(player.getId());

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(AccessControlService.AccessDeniedException.class);
        }
    }

    @Nested
    @DisplayName("filter by role")
    class FilterByRole {

        @Test
        @DisplayName("can filter by ADMIN role")
        void canFilterByAdminRole() {
            // Given
            User superAdmin = createAndSaveUser("super@example.com", "Super Admin", "google-super", Role.SUPER_ADMIN);
            createAndSaveUser("admin1@example.com", "Admin 1", "google-admin1", Role.ADMIN);
            createAndSaveUser("admin2@example.com", "Admin 2", "google-admin2", Role.ADMIN);
            createAndSaveUser("player@example.com", "Player", "google-player", Role.PLAYER);

            var command = new ListUsersUseCase.ListUsersCommand(
                    superAdmin.getId(), Role.ADMIN, false
            );

            // When
            List<User> users = useCase.execute(command);

            // Then
            assertThat(users).hasSize(2);
            assertThat(users).allMatch(u -> u.getRole() == Role.ADMIN);
        }

        @Test
        @DisplayName("can filter by PLAYER role")
        void canFilterByPlayerRole() {
            // Given
            User superAdmin = createAndSaveUser("super@example.com", "Super Admin", "google-super", Role.SUPER_ADMIN);
            createAndSaveUser("admin@example.com", "Admin", "google-admin", Role.ADMIN);
            createAndSaveUser("player1@example.com", "Player 1", "google-player1", Role.PLAYER);
            createAndSaveUser("player2@example.com", "Player 2", "google-player2", Role.PLAYER);
            createAndSaveUser("player3@example.com", "Player 3", "google-player3", Role.PLAYER);

            var command = new ListUsersUseCase.ListUsersCommand(
                    superAdmin.getId(), Role.PLAYER, false
            );

            // When
            List<User> users = useCase.execute(command);

            // Then
            assertThat(users).hasSize(3);
            assertThat(users).allMatch(u -> u.getRole() == Role.PLAYER);
        }
    }

    @Nested
    @DisplayName("filter by active status")
    class FilterByActiveStatus {

        @Test
        @DisplayName("can filter active users only")
        void canFilterActiveUsersOnly() {
            // Given
            User superAdmin = createAndSaveUser("super@example.com", "Super Admin", "google-super", Role.SUPER_ADMIN);
            User activePlayer = createAndSaveUser("active@example.com", "Active Player", "google-active", Role.PLAYER);
            User inactivePlayer = createAndSaveUser("inactive@example.com", "Inactive Player", "google-inactive", Role.PLAYER);
            inactivePlayer.deactivate();
            userRepository.save(inactivePlayer);

            var command = new ListUsersUseCase.ListUsersCommand(
                    superAdmin.getId(), null, true
            );

            // When
            List<User> users = useCase.execute(command);

            // Then
            assertThat(users).hasSize(2); // super admin and active player
            assertThat(users).allMatch(User::isActive);
        }

        @Test
        @DisplayName("can get all users including inactive")
        void canGetAllUsersIncludingInactive() {
            // Given
            User superAdmin = createAndSaveUser("super@example.com", "Super Admin", "google-super", Role.SUPER_ADMIN);
            createAndSaveUser("active@example.com", "Active Player", "google-active", Role.PLAYER);
            User inactivePlayer = createAndSaveUser("inactive@example.com", "Inactive Player", "google-inactive", Role.PLAYER);
            inactivePlayer.deactivate();
            userRepository.save(inactivePlayer);

            var command = new ListUsersUseCase.ListUsersCommand(
                    superAdmin.getId(), null, false
            );

            // When
            List<User> users = useCase.execute(command);

            // Then
            assertThat(users).hasSize(3);
        }
    }

    @Nested
    @DisplayName("combined filters")
    class CombinedFilters {

        @Test
        @DisplayName("can filter by role and active status")
        void canFilterByRoleAndActiveStatus() {
            // Given
            User superAdmin = createAndSaveUser("super@example.com", "Super Admin", "google-super", Role.SUPER_ADMIN);
            createAndSaveUser("admin-active@example.com", "Active Admin", "google-aa", Role.ADMIN);
            User inactiveAdmin = createAndSaveUser("admin-inactive@example.com", "Inactive Admin", "google-ia", Role.ADMIN);
            inactiveAdmin.deactivate();
            userRepository.save(inactiveAdmin);
            createAndSaveUser("player@example.com", "Player", "google-player", Role.PLAYER);

            var command = new ListUsersUseCase.ListUsersCommand(
                    superAdmin.getId(), Role.ADMIN, true
            );

            // When
            List<User> users = useCase.execute(command);

            // Then
            assertThat(users).hasSize(1);
            assertThat(users.get(0).getEmail()).isEqualTo("admin-active@example.com");
        }
    }

    @Nested
    @DisplayName("validation")
    class Validation {

        @Test
        @DisplayName("should throw when requester not found")
        void shouldThrowWhenRequesterNotFound() {
            // Given
            var command = new ListUsersUseCase.ListUsersCommand(java.util.UUID.randomUUID());

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Requester not found");
        }
    }
}
