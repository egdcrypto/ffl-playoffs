package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.PATScope;
import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;
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

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CreatePATUseCase Tests")
class CreatePATUseCaseTest {

    @Mock
    private PersonalAccessTokenRepository tokenRepository;

    @Mock
    private UserRepository userRepository;

    @Captor
    private ArgumentCaptor<PersonalAccessToken> tokenCaptor;

    private CreatePATUseCase useCase;

    private UUID superAdminId;

    @BeforeEach
    void setUp() {
        useCase = new CreatePATUseCase(tokenRepository, userRepository);
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
        @DisplayName("should create PAT successfully when user is super admin")
        void shouldCreatePATSuccessfullyWhenUserIsSuperAdmin() {
            // Arrange
            User superAdmin = createSuperAdmin();
            String patName = "Test PAT";
            LocalDateTime expiresAt = LocalDateTime.now().plusDays(30);

            CreatePATUseCase.CreatePATCommand command = new CreatePATUseCase.CreatePATCommand(
                    patName, PATScope.ADMIN, expiresAt, superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.existsByName(patName)).thenReturn(false);
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            CreatePATUseCase.CreatePATResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertNotNull(result.getId());
            assertEquals(patName, result.getName());
            assertNotNull(result.getPlaintextToken());
            assertTrue(result.getPlaintextToken().startsWith("pat_"));
            assertEquals(PATScope.ADMIN, result.getScope());
            assertEquals(expiresAt, result.getExpiresAt());
            assertEquals(superAdminId, result.getCreatedBy());
            verify(tokenRepository).save(tokenCaptor.capture());
            assertNotNull(tokenCaptor.getValue().getTokenHash());
        }

        @Test
        @DisplayName("should throw exception when user not found")
        void shouldThrowExceptionWhenUserNotFound() {
            // Arrange
            UUID unknownUserId = UUID.randomUUID();
            CreatePATUseCase.CreatePATCommand command = new CreatePATUseCase.CreatePATCommand(
                    "Test PAT", PATScope.ADMIN, LocalDateTime.now().plusDays(30), unknownUserId);

            when(userRepository.findById(unknownUserId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("User not found"));
            verify(tokenRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when user is not super admin")
        void shouldThrowExceptionWhenUserIsNotSuperAdmin() {
            // Arrange
            User regularAdmin = createRegularAdmin();
            CreatePATUseCase.CreatePATCommand command = new CreatePATUseCase.CreatePATCommand(
                    "Test PAT", PATScope.ADMIN, LocalDateTime.now().plusDays(30), regularAdmin.getId());

            when(userRepository.findById(regularAdmin.getId())).thenReturn(Optional.of(regularAdmin));

            // Act & Assert
            SecurityException exception = assertThrows(
                    SecurityException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Only SUPER_ADMIN"));
            verify(tokenRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when PAT name already exists")
        void shouldThrowExceptionWhenPATNameAlreadyExists() {
            // Arrange
            User superAdmin = createSuperAdmin();
            String existingName = "Existing PAT";
            CreatePATUseCase.CreatePATCommand command = new CreatePATUseCase.CreatePATCommand(
                    existingName, PATScope.ADMIN, LocalDateTime.now().plusDays(30), superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.existsByName(existingName)).thenReturn(true);

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("already exists"));
            verify(tokenRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when PAT name is empty")
        void shouldThrowExceptionWhenPATNameIsEmpty() {
            // Arrange
            User superAdmin = createSuperAdmin();
            CreatePATUseCase.CreatePATCommand command = new CreatePATUseCase.CreatePATCommand(
                    "", PATScope.ADMIN, LocalDateTime.now().plusDays(30), superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("name cannot be empty"));
        }

        @Test
        @DisplayName("should throw exception when scope is null")
        void shouldThrowExceptionWhenScopeIsNull() {
            // Arrange
            User superAdmin = createSuperAdmin();
            CreatePATUseCase.CreatePATCommand command = new CreatePATUseCase.CreatePATCommand(
                    "Test PAT", null, LocalDateTime.now().plusDays(30), superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("scope cannot be null"));
        }

        @Test
        @DisplayName("should throw exception when expiration is in the past")
        void shouldThrowExceptionWhenExpirationIsInThePast() {
            // Arrange
            User superAdmin = createSuperAdmin();
            CreatePATUseCase.CreatePATCommand command = new CreatePATUseCase.CreatePATCommand(
                    "Test PAT", PATScope.ADMIN, LocalDateTime.now().minusDays(1), superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("expiration must be in the future"));
        }

        @Test
        @DisplayName("should allow null expiration for non-expiring tokens")
        void shouldAllowNullExpirationForNonExpiringTokens() {
            // Arrange
            User superAdmin = createSuperAdmin();
            CreatePATUseCase.CreatePATCommand command = new CreatePATUseCase.CreatePATCommand(
                    "Non-expiring PAT", PATScope.READ_ONLY, null, superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.existsByName("Non-expiring PAT")).thenReturn(false);
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            CreatePATUseCase.CreatePATResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertNull(result.getExpiresAt());
        }

        @Test
        @DisplayName("should generate token with correct format")
        void shouldGenerateTokenWithCorrectFormat() {
            // Arrange
            User superAdmin = createSuperAdmin();
            CreatePATUseCase.CreatePATCommand command = new CreatePATUseCase.CreatePATCommand(
                    "Token Format Test", PATScope.WRITE, LocalDateTime.now().plusDays(30), superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.existsByName("Token Format Test")).thenReturn(false);
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            CreatePATUseCase.CreatePATResult result = useCase.execute(command);

            // Assert
            String token = result.getPlaintextToken();
            assertTrue(token.startsWith("pat_"));
            // Format: pat_<identifier>_<random>
            String[] parts = token.split("_");
            assertEquals(3, parts.length);
            assertEquals("pat", parts[0]);
        }
    }

    @Nested
    @DisplayName("CreatePATCommand")
    class CreatePATCommandTests {

        @Test
        @DisplayName("should create command with all fields")
        void shouldCreateCommandWithAllFields() {
            // Arrange
            LocalDateTime expiresAt = LocalDateTime.now().plusDays(30);

            // Act
            CreatePATUseCase.CreatePATCommand command = new CreatePATUseCase.CreatePATCommand(
                    "Test PAT", PATScope.ADMIN, expiresAt, superAdminId);

            // Assert
            assertEquals("Test PAT", command.getName());
            assertEquals(PATScope.ADMIN, command.getScope());
            assertEquals(expiresAt, command.getExpiresAt());
            assertEquals(superAdminId, command.getCreatedBy());
        }
    }

    @Nested
    @DisplayName("CreatePATResult")
    class CreatePATResultTests {

        @Test
        @DisplayName("should create result with all fields")
        void shouldCreateResultWithAllFields() {
            // Arrange
            UUID patId = UUID.randomUUID();
            LocalDateTime expiresAt = LocalDateTime.now().plusDays(30);
            LocalDateTime createdAt = LocalDateTime.now();

            // Act
            CreatePATUseCase.CreatePATResult result = new CreatePATUseCase.CreatePATResult(
                    patId, "Test PAT", "pat_abc_xyz", PATScope.ADMIN,
                    expiresAt, superAdminId, createdAt);

            // Assert
            assertEquals(patId, result.getId());
            assertEquals("Test PAT", result.getName());
            assertEquals("pat_abc_xyz", result.getPlaintextToken());
            assertEquals(PATScope.ADMIN, result.getScope());
            assertEquals(expiresAt, result.getExpiresAt());
            assertEquals(superAdminId, result.getCreatedBy());
            assertEquals(createdAt, result.getCreatedAt());
        }
    }
}
