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

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CreateUserAccountUseCase Tests")
class CreateUserAccountUseCaseTest {

    @Mock
    private UserRepository userRepository;

    @Captor
    private ArgumentCaptor<User> userCaptor;

    private CreateUserAccountUseCase useCase;

    @BeforeEach
    void setUp() {
        useCase = new CreateUserAccountUseCase(userRepository);
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should create user successfully with all fields")
        void shouldCreateUserSuccessfullyWithAllFields() {
            // Arrange
            CreateUserAccountUseCase.CreateUserCommand command =
                    new CreateUserAccountUseCase.CreateUserCommand(
                            "test@example.com", "Test User", "google123", Role.ADMIN);

            when(userRepository.findByEmail("test@example.com")).thenReturn(Optional.empty());
            when(userRepository.existsByGoogleId("google123")).thenReturn(false);
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            User result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals("test@example.com", result.getEmail());
            assertEquals("Test User", result.getName());
            assertEquals("google123", result.getGoogleId());
            assertEquals(Role.ADMIN, result.getRole());
            verify(userRepository).save(userCaptor.capture());
            assertEquals("test@example.com", userCaptor.getValue().getEmail());
        }

        @Test
        @DisplayName("should create user with default PLAYER role when role is null")
        void shouldCreateUserWithDefaultPlayerRoleWhenRoleIsNull() {
            // Arrange
            CreateUserAccountUseCase.CreateUserCommand command =
                    new CreateUserAccountUseCase.CreateUserCommand(
                            "player@example.com", "Player User", "google456", null);

            when(userRepository.findByEmail("player@example.com")).thenReturn(Optional.empty());
            when(userRepository.existsByGoogleId("google456")).thenReturn(false);
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            User result = useCase.execute(command);

            // Assert
            assertEquals(Role.PLAYER, result.getRole());
        }

        @Test
        @DisplayName("should create user without Google ID")
        void shouldCreateUserWithoutGoogleId() {
            // Arrange
            CreateUserAccountUseCase.CreateUserCommand command =
                    new CreateUserAccountUseCase.CreateUserCommand(
                            "nogoogle@example.com", "No Google User", null, Role.PLAYER);

            when(userRepository.findByEmail("nogoogle@example.com")).thenReturn(Optional.empty());
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            User result = useCase.execute(command);

            // Assert
            assertNull(result.getGoogleId());
            verify(userRepository, never()).existsByGoogleId(any());
        }

        @Test
        @DisplayName("should throw exception when email already exists")
        void shouldThrowExceptionWhenEmailAlreadyExists() {
            // Arrange
            User existingUser = new User("existing@example.com", "Existing User", "google999", Role.PLAYER);
            CreateUserAccountUseCase.CreateUserCommand command =
                    new CreateUserAccountUseCase.CreateUserCommand(
                            "existing@example.com", "New User", "google123", Role.PLAYER);

            when(userRepository.findByEmail("existing@example.com")).thenReturn(Optional.of(existingUser));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("User with email already exists"));
            assertTrue(exception.getMessage().contains("existing@example.com"));
            verify(userRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when Google ID already exists")
        void shouldThrowExceptionWhenGoogleIdAlreadyExists() {
            // Arrange
            CreateUserAccountUseCase.CreateUserCommand command =
                    new CreateUserAccountUseCase.CreateUserCommand(
                            "new@example.com", "New User", "existinggoogle", Role.PLAYER);

            when(userRepository.findByEmail("new@example.com")).thenReturn(Optional.empty());
            when(userRepository.existsByGoogleId("existinggoogle")).thenReturn(true);

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("User with Google ID already exists"));
            verify(userRepository, never()).save(any());
        }

        @Test
        @DisplayName("should create user with SUPER_ADMIN role")
        void shouldCreateUserWithSuperAdminRole() {
            // Arrange
            CreateUserAccountUseCase.CreateUserCommand command =
                    new CreateUserAccountUseCase.CreateUserCommand(
                            "superadmin@example.com", "Super Admin", "google789", Role.SUPER_ADMIN);

            when(userRepository.findByEmail("superadmin@example.com")).thenReturn(Optional.empty());
            when(userRepository.existsByGoogleId("google789")).thenReturn(false);
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            User result = useCase.execute(command);

            // Assert
            assertEquals(Role.SUPER_ADMIN, result.getRole());
        }
    }

    @Nested
    @DisplayName("CreateUserCommand")
    class CreateUserCommandTests {

        @Test
        @DisplayName("should create command with all fields using 4-arg constructor")
        void shouldCreateCommandWithAllFields() {
            // Arrange & Act
            CreateUserAccountUseCase.CreateUserCommand command =
                    new CreateUserAccountUseCase.CreateUserCommand(
                            "test@example.com", "Test User", "google123", Role.ADMIN);

            // Assert
            assertEquals("test@example.com", command.getEmail());
            assertEquals("Test User", command.getName());
            assertEquals("google123", command.getGoogleId());
            assertEquals(Role.ADMIN, command.getRole());
        }

        @Test
        @DisplayName("should create command with default PLAYER role using 3-arg constructor")
        void shouldCreateCommandWithDefaultPlayerRole() {
            // Arrange & Act
            CreateUserAccountUseCase.CreateUserCommand command =
                    new CreateUserAccountUseCase.CreateUserCommand(
                            "player@example.com", "Player User", "google456");

            // Assert
            assertEquals("player@example.com", command.getEmail());
            assertEquals("Player User", command.getName());
            assertEquals("google456", command.getGoogleId());
            assertEquals(Role.PLAYER, command.getRole());
        }

        @Test
        @DisplayName("should allow null Google ID in command")
        void shouldAllowNullGoogleIdInCommand() {
            // Arrange & Act
            CreateUserAccountUseCase.CreateUserCommand command =
                    new CreateUserAccountUseCase.CreateUserCommand(
                            "test@example.com", "Test User", null, Role.PLAYER);

            // Assert
            assertNull(command.getGoogleId());
        }
    }
}
