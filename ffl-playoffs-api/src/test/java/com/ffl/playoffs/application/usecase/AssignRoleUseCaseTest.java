package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.EnumSource;
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
@DisplayName("AssignRoleUseCase Tests")
class AssignRoleUseCaseTest {

    @Mock
    private UserRepository userRepository;

    private AssignRoleUseCase useCase;

    @Captor
    private ArgumentCaptor<User> userCaptor;

    private UUID userId;
    private UUID assignerId;
    private User targetUser;
    private User superAdminAssigner;

    @BeforeEach
    void setUp() {
        useCase = new AssignRoleUseCase(userRepository);

        userId = UUID.randomUUID();
        assignerId = UUID.randomUUID();

        // Create target user with PLAYER role
        targetUser = new User();
        targetUser.setId(userId);
        targetUser.setEmail("target@test.com");
        targetUser.setName("Target User");
        targetUser.setRole(Role.PLAYER);

        // Create super admin assigner
        superAdminAssigner = new User();
        superAdminAssigner.setId(assignerId);
        superAdminAssigner.setEmail("superadmin@test.com");
        superAdminAssigner.setName("Super Admin");
        superAdminAssigner.setRole(Role.SUPER_ADMIN);
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should assign role successfully with SUPER_ADMIN")
        void shouldAssignRoleSuccessfully() {
            // Arrange
            AssignRoleUseCase.AssignRoleCommand command =
                    new AssignRoleUseCase.AssignRoleCommand(userId, Role.ADMIN, assignerId);

            when(userRepository.findById(userId)).thenReturn(Optional.of(targetUser));
            when(userRepository.findById(assignerId)).thenReturn(Optional.of(superAdminAssigner));
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            User result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(Role.ADMIN, result.getRole());

            verify(userRepository).save(userCaptor.capture());
            assertEquals(Role.ADMIN, userCaptor.getValue().getRole());
        }

        @ParameterizedTest
        @EnumSource(Role.class)
        @DisplayName("should allow assigning any role by SUPER_ADMIN")
        void shouldAllowAssigningAnyRole(Role newRole) {
            // Arrange
            AssignRoleUseCase.AssignRoleCommand command =
                    new AssignRoleUseCase.AssignRoleCommand(userId, newRole, assignerId);

            when(userRepository.findById(userId)).thenReturn(Optional.of(targetUser));
            when(userRepository.findById(assignerId)).thenReturn(Optional.of(superAdminAssigner));
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            User result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(newRole, result.getRole());
        }

        @Test
        @DisplayName("should throw exception when user not found")
        void shouldThrowExceptionWhenUserNotFound() {
            // Arrange
            UUID unknownUserId = UUID.randomUUID();
            AssignRoleUseCase.AssignRoleCommand command =
                    new AssignRoleUseCase.AssignRoleCommand(unknownUserId, Role.ADMIN, assignerId);

            when(userRepository.findById(unknownUserId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("User not found"));
            verify(userRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when assigner not found")
        void shouldThrowExceptionWhenAssignerNotFound() {
            // Arrange
            UUID unknownAssignerId = UUID.randomUUID();
            AssignRoleUseCase.AssignRoleCommand command =
                    new AssignRoleUseCase.AssignRoleCommand(userId, Role.ADMIN, unknownAssignerId);

            when(userRepository.findById(userId)).thenReturn(Optional.of(targetUser));
            when(userRepository.findById(unknownAssignerId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Assigner not found"));
            verify(userRepository, never()).save(any());
        }

        @ParameterizedTest
        @EnumSource(value = Role.class, mode = EnumSource.Mode.EXCLUDE, names = {"SUPER_ADMIN"})
        @DisplayName("should throw exception when assigner is not SUPER_ADMIN")
        void shouldThrowExceptionWhenAssignerNotSuperAdmin(Role nonSuperAdminRole) {
            // Arrange
            User nonSuperAdminAssigner = new User();
            nonSuperAdminAssigner.setId(assignerId);
            nonSuperAdminAssigner.setEmail("nonsuperadmin@test.com");
            nonSuperAdminAssigner.setName("Non Super Admin");
            nonSuperAdminAssigner.setRole(nonSuperAdminRole);

            AssignRoleUseCase.AssignRoleCommand command =
                    new AssignRoleUseCase.AssignRoleCommand(userId, Role.ADMIN, assignerId);

            when(userRepository.findById(userId)).thenReturn(Optional.of(targetUser));
            when(userRepository.findById(assignerId)).thenReturn(Optional.of(nonSuperAdminAssigner));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("SUPER_ADMIN"));
            verify(userRepository, never()).save(any());
        }

        @Test
        @DisplayName("should save user after assigning role")
        void shouldSaveUserAfterAssigningRole() {
            // Arrange
            AssignRoleUseCase.AssignRoleCommand command =
                    new AssignRoleUseCase.AssignRoleCommand(userId, Role.ADMIN, assignerId);

            when(userRepository.findById(userId)).thenReturn(Optional.of(targetUser));
            when(userRepository.findById(assignerId)).thenReturn(Optional.of(superAdminAssigner));
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(userRepository, times(1)).save(any(User.class));
        }

        @Test
        @DisplayName("should preserve user properties when assigning role")
        void shouldPreserveUserPropertiesWhenAssigningRole() {
            // Arrange
            AssignRoleUseCase.AssignRoleCommand command =
                    new AssignRoleUseCase.AssignRoleCommand(userId, Role.ADMIN, assignerId);

            when(userRepository.findById(userId)).thenReturn(Optional.of(targetUser));
            when(userRepository.findById(assignerId)).thenReturn(Optional.of(superAdminAssigner));
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            User result = useCase.execute(command);

            // Assert
            assertEquals(userId, result.getId());
            assertEquals("target@test.com", result.getEmail());
            assertEquals("Target User", result.getName());
            assertEquals(Role.ADMIN, result.getRole());
        }
    }

    @Nested
    @DisplayName("AssignRoleCommand")
    class CommandTests {

        @Test
        @DisplayName("should create command with all fields")
        void shouldCreateCommandWithAllFields() {
            // Arrange & Act
            AssignRoleUseCase.AssignRoleCommand command =
                    new AssignRoleUseCase.AssignRoleCommand(userId, Role.ADMIN, assignerId);

            // Assert
            assertEquals(userId, command.getUserId());
            assertEquals(Role.ADMIN, command.getNewRole());
            assertEquals(assignerId, command.getAssignedBy());
        }
    }
}
