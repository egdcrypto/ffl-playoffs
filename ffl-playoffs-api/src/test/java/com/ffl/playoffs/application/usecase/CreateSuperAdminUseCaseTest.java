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
@DisplayName("CreateSuperAdminUseCase Tests")
class CreateSuperAdminUseCaseTest {

    @Mock
    private UserRepository userRepository;

    @Captor
    private ArgumentCaptor<User> userCaptor;

    private CreateSuperAdminUseCase useCase;

    @BeforeEach
    void setUp() {
        useCase = new CreateSuperAdminUseCase(userRepository);
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should create super admin successfully")
        void shouldCreateSuperAdminSuccessfully() {
            // Arrange
            CreateSuperAdminUseCase.CreateSuperAdminCommand command =
                    new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                            "admin@test.com", "google123", "Super Admin");

            when(userRepository.findByEmail("admin@test.com")).thenReturn(Optional.empty());
            when(userRepository.findByGoogleId("google123")).thenReturn(Optional.empty());
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            CreateSuperAdminUseCase.CreateSuperAdminResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertNotNull(result.getId());
            assertEquals("admin@test.com", result.getEmail());
            assertEquals("Super Admin", result.getName());
            assertEquals("google123", result.getGoogleId());
            assertEquals(Role.SUPER_ADMIN, result.getRole());
            assertNotNull(result.getCreatedAt());
            verify(userRepository).save(userCaptor.capture());
            assertEquals(Role.SUPER_ADMIN, userCaptor.getValue().getRole());
        }

        @Test
        @DisplayName("should extract name from email when not provided")
        void shouldExtractNameFromEmailWhenNotProvided() {
            // Arrange
            CreateSuperAdminUseCase.CreateSuperAdminCommand command =
                    new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                            "john.doe@example.com", "google456", null);

            when(userRepository.findByEmail("john.doe@example.com")).thenReturn(Optional.empty());
            when(userRepository.findByGoogleId("google456")).thenReturn(Optional.empty());
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            CreateSuperAdminUseCase.CreateSuperAdminResult result = useCase.execute(command);

            // Assert
            assertEquals("john.doe", result.getName());
        }

        @Test
        @DisplayName("should throw exception when email is empty")
        void shouldThrowExceptionWhenEmailIsEmpty() {
            // Arrange
            CreateSuperAdminUseCase.CreateSuperAdminCommand command =
                    new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                            "", "google123", "Admin");

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Email cannot be empty"));
            verify(userRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when email format is invalid")
        void shouldThrowExceptionWhenEmailFormatIsInvalid() {
            // Arrange
            CreateSuperAdminUseCase.CreateSuperAdminCommand command =
                    new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                            "invalid-email", "google123", "Admin");

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Invalid email format"));
            verify(userRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when googleId is empty")
        void shouldThrowExceptionWhenGoogleIdIsEmpty() {
            // Arrange
            CreateSuperAdminUseCase.CreateSuperAdminCommand command =
                    new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                            "admin@test.com", "", "Admin");

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Google ID cannot be empty"));
            verify(userRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when email already exists")
        void shouldThrowExceptionWhenEmailAlreadyExists() {
            // Arrange
            User existingUser = new User("admin@test.com", "Existing", "existinggoogle", Role.ADMIN);
            CreateSuperAdminUseCase.CreateSuperAdminCommand command =
                    new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                            "admin@test.com", "google123", "Admin");

            when(userRepository.findByEmail("admin@test.com")).thenReturn(Optional.of(existingUser));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("User with email"));
            assertTrue(exception.getMessage().contains("already exists"));
            verify(userRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when googleId already exists")
        void shouldThrowExceptionWhenGoogleIdAlreadyExists() {
            // Arrange
            User existingUser = new User("other@test.com", "Existing", "google123", Role.ADMIN);
            CreateSuperAdminUseCase.CreateSuperAdminCommand command =
                    new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                            "admin@test.com", "google123", "Admin");

            when(userRepository.findByEmail("admin@test.com")).thenReturn(Optional.empty());
            when(userRepository.findByGoogleId("google123")).thenReturn(Optional.of(existingUser));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Google ID"));
            assertTrue(exception.getMessage().contains("already exists"));
            verify(userRepository, never()).save(any());
        }
    }

    @Nested
    @DisplayName("CreateSuperAdminCommand")
    class CreateSuperAdminCommandTests {

        @Test
        @DisplayName("should create command with all fields")
        void shouldCreateCommandWithAllFields() {
            // Arrange & Act
            CreateSuperAdminUseCase.CreateSuperAdminCommand command =
                    new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                            "admin@test.com", "google123", "Admin Name");

            // Assert
            assertEquals("admin@test.com", command.getEmail());
            assertEquals("google123", command.getGoogleId());
            assertEquals("Admin Name", command.getName());
        }

        @Test
        @DisplayName("should allow null name")
        void shouldAllowNullName() {
            // Arrange & Act
            CreateSuperAdminUseCase.CreateSuperAdminCommand command =
                    new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                            "admin@test.com", "google123", null);

            // Assert
            assertNull(command.getName());
        }
    }

    @Nested
    @DisplayName("CreateSuperAdminResult")
    class CreateSuperAdminResultTests {

        @Test
        @DisplayName("should create result with all fields")
        void shouldCreateResultWithAllFields() {
            // Arrange
            java.util.UUID id = java.util.UUID.randomUUID();
            java.time.LocalDateTime createdAt = java.time.LocalDateTime.now();

            // Act
            CreateSuperAdminUseCase.CreateSuperAdminResult result =
                    new CreateSuperAdminUseCase.CreateSuperAdminResult(
                            id, "admin@test.com", "Admin Name",
                            "google123", Role.SUPER_ADMIN, createdAt);

            // Assert
            assertEquals(id, result.getId());
            assertEquals("admin@test.com", result.getEmail());
            assertEquals("Admin Name", result.getName());
            assertEquals("google123", result.getGoogleId());
            assertEquals(Role.SUPER_ADMIN, result.getRole());
            assertEquals(createdAt, result.getCreatedAt());
        }
    }
}
