package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("InviteAdminUseCase Tests")
class InviteAdminUseCaseTest {

    @Mock
    private UserRepository userRepository;

    @Captor
    private ArgumentCaptor<User> userCaptor;

    private InviteAdminUseCase useCase;

    private UUID superAdminId;

    @BeforeEach
    void setUp() {
        useCase = new InviteAdminUseCase(userRepository);
        superAdminId = UUID.randomUUID();
    }

    private User createSuperAdmin() {
        User superAdmin = new User("superadmin@test.com", "Super Admin", "google123", Role.SUPER_ADMIN);
        superAdmin.setId(superAdminId);
        return superAdmin;
    }

    private User createRegularAdmin() {
        User admin = new User("admin@test.com", "Regular Admin", "google456", Role.ADMIN);
        admin.setId(UUID.randomUUID());
        return admin;
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should invite admin successfully when inviter is super admin")
        void shouldInviteAdminSuccessfullyWhenInviterIsSuperAdmin() {
            // Arrange
            User superAdmin = createSuperAdmin();
            String newAdminEmail = "newadmin@test.com";
            String newAdminName = "New Admin";

            InviteAdminUseCase.InviteAdminCommand command =
                    new InviteAdminUseCase.InviteAdminCommand(newAdminEmail, newAdminName, superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(userRepository.findByEmail(newAdminEmail)).thenReturn(Optional.empty());
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            InviteAdminUseCase.InviteAdminResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertNotNull(result.getAdmin());
            assertNotNull(result.getInvitationToken());
            assertEquals(newAdminEmail, result.getAdmin().getEmail());
            assertEquals(newAdminName, result.getAdmin().getName());
            assertEquals(Role.ADMIN, result.getAdmin().getRole());
            verify(userRepository).save(userCaptor.capture());
            assertEquals(Role.ADMIN, userCaptor.getValue().getRole());
        }

        @Test
        @DisplayName("should throw exception when inviter not found")
        void shouldThrowExceptionWhenInviterNotFound() {
            // Arrange
            UUID unknownUserId = UUID.randomUUID();
            InviteAdminUseCase.InviteAdminCommand command =
                    new InviteAdminUseCase.InviteAdminCommand("new@test.com", "New Admin", unknownUserId);

            when(userRepository.findById(unknownUserId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Inviter not found"));
            verify(userRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when inviter is not super admin")
        void shouldThrowExceptionWhenInviterIsNotSuperAdmin() {
            // Arrange
            User regularAdmin = createRegularAdmin();

            InviteAdminUseCase.InviteAdminCommand command =
                    new InviteAdminUseCase.InviteAdminCommand("new@test.com", "New Admin", regularAdmin.getId());

            when(userRepository.findById(regularAdmin.getId())).thenReturn(Optional.of(regularAdmin));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Only SUPER_ADMIN can invite admins"));
            verify(userRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when email already exists")
        void shouldThrowExceptionWhenEmailAlreadyExists() {
            // Arrange
            User superAdmin = createSuperAdmin();
            String existingEmail = "existing@test.com";
            User existingUser = new User(existingEmail, "Existing User", "google789", Role.PLAYER);

            InviteAdminUseCase.InviteAdminCommand command =
                    new InviteAdminUseCase.InviteAdminCommand(existingEmail, "New Admin", superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(userRepository.findByEmail(existingEmail)).thenReturn(Optional.of(existingUser));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("already exists"));
            verify(userRepository, never()).save(any());
        }

        @Test
        @DisplayName("should generate invitation token starting with admin_invite_")
        void shouldGenerateInvitationToken() {
            // Arrange
            User superAdmin = createSuperAdmin();
            InviteAdminUseCase.InviteAdminCommand command =
                    new InviteAdminUseCase.InviteAdminCommand("new@test.com", "New Admin", superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(userRepository.findByEmail("new@test.com")).thenReturn(Optional.empty());
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            InviteAdminUseCase.InviteAdminResult result = useCase.execute(command);

            // Assert
            assertNotNull(result.getInvitationToken());
            assertTrue(result.getInvitationToken().startsWith("admin_invite_"));
        }
    }

    @Nested
    @DisplayName("InviteAdminCommand")
    class InviteAdminCommandTests {

        @Test
        @DisplayName("should create command with all fields")
        void shouldCreateCommandWithAllFields() {
            // Arrange & Act
            InviteAdminUseCase.InviteAdminCommand command =
                    new InviteAdminUseCase.InviteAdminCommand(
                            "admin@test.com", "Admin User", superAdminId);

            // Assert
            assertEquals("admin@test.com", command.getEmail());
            assertEquals("Admin User", command.getName());
            assertEquals(superAdminId, command.getInvitedBy());
        }
    }

    @Nested
    @DisplayName("InviteAdminResult")
    class InviteAdminResultTests {

        @Test
        @DisplayName("should create result with admin and token")
        void shouldCreateResultWithAdminAndToken() {
            // Arrange
            User admin = new User("admin@test.com", "Admin User", null, Role.ADMIN);
            String token = "admin_invite_test123";

            // Act
            InviteAdminUseCase.InviteAdminResult result =
                    new InviteAdminUseCase.InviteAdminResult(admin, token);

            // Assert
            assertEquals(admin, result.getAdmin());
            assertEquals(token, result.getInvitationToken());
        }
    }
}
