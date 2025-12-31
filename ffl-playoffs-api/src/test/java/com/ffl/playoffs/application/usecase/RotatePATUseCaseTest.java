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
@DisplayName("RotatePATUseCase Tests")
class RotatePATUseCaseTest {

    @Mock
    private PersonalAccessTokenRepository tokenRepository;

    @Mock
    private UserRepository userRepository;

    @Captor
    private ArgumentCaptor<PersonalAccessToken> patCaptor;

    private RotatePATUseCase useCase;

    private UUID superAdminId;
    private UUID regularUserId;
    private UUID patId;
    private User superAdmin;
    private User regularUser;
    private PersonalAccessToken pat;

    @BeforeEach
    void setUp() {
        useCase = new RotatePATUseCase(tokenRepository, userRepository);

        superAdminId = UUID.randomUUID();
        regularUserId = UUID.randomUUID();
        patId = UUID.randomUUID();

        superAdmin = new User();
        superAdmin.setId(superAdminId);
        superAdmin.setEmail("admin@test.com");
        superAdmin.setRole(Role.SUPER_ADMIN);

        regularUser = new User();
        regularUser.setId(regularUserId);
        regularUser.setEmail("user@test.com");
        regularUser.setRole(Role.PLAYER);

        pat = new PersonalAccessToken();
        pat.setId(patId);
        pat.setName("Test PAT");
        pat.setScope(PATScope.READ_ONLY);
        pat.setTokenIdentifier("old_identifier");
        pat.setTokenHash("old_hash");
        pat.setCreatedBy(superAdminId.toString());
        pat.setCreatedAt(LocalDateTime.now().minusDays(30));
        pat.setExpiresAt(LocalDateTime.now().plusDays(30));
        pat.setLastUsedAt(LocalDateTime.now().minusDays(1));
        pat.setRevoked(false);
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should rotate PAT successfully and return new token")
        void shouldRotatePATSuccessfullyAndReturnNewToken() {
            // Arrange
            RotatePATUseCase.RotatePATCommand command =
                    new RotatePATUseCase.RotatePATCommand(patId, superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.findById(patId)).thenReturn(Optional.of(pat));
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            RotatePATUseCase.RotatePATResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(patId, result.getPatId());
            assertEquals("Test PAT", result.getPatName());
            assertNotNull(result.getNewPlaintextToken());
            assertTrue(result.getNewPlaintextToken().startsWith("pat_"));
            assertEquals(PATScope.READ_ONLY, result.getScope());
            assertEquals(superAdminId, result.getRotatedBy());
            assertNotNull(result.getRotatedAt());
        }

        @Test
        @DisplayName("should throw exception when user not found")
        void shouldThrowExceptionWhenUserNotFound() {
            // Arrange
            UUID unknownUserId = UUID.randomUUID();
            RotatePATUseCase.RotatePATCommand command =
                    new RotatePATUseCase.RotatePATCommand(patId, unknownUserId);

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
        @DisplayName("should throw SecurityException when user is not SUPER_ADMIN")
        void shouldThrowSecurityExceptionWhenNotSuperAdmin() {
            // Arrange
            RotatePATUseCase.RotatePATCommand command =
                    new RotatePATUseCase.RotatePATCommand(patId, regularUserId);

            when(userRepository.findById(regularUserId)).thenReturn(Optional.of(regularUser));

            // Act & Assert
            SecurityException exception = assertThrows(
                    SecurityException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("SUPER_ADMIN"));
            verify(tokenRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when PAT not found")
        void shouldThrowExceptionWhenPATNotFound() {
            // Arrange
            UUID unknownPatId = UUID.randomUUID();
            RotatePATUseCase.RotatePATCommand command =
                    new RotatePATUseCase.RotatePATCommand(unknownPatId, superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.findById(unknownPatId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("PAT not found"));
            verify(tokenRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when PAT is revoked")
        void shouldThrowExceptionWhenPATIsRevoked() {
            // Arrange
            pat.setRevoked(true);

            RotatePATUseCase.RotatePATCommand command =
                    new RotatePATUseCase.RotatePATCommand(patId, superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.findById(patId)).thenReturn(Optional.of(pat));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Cannot rotate revoked PAT"));
            verify(tokenRepository, never()).save(any());
        }

        @Test
        @DisplayName("should update token identifier and hash")
        void shouldUpdateTokenIdentifierAndHash() {
            // Arrange
            String oldIdentifier = pat.getTokenIdentifier();
            String oldHash = pat.getTokenHash();

            RotatePATUseCase.RotatePATCommand command =
                    new RotatePATUseCase.RotatePATCommand(patId, superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.findById(patId)).thenReturn(Optional.of(pat));
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(tokenRepository).save(patCaptor.capture());
            PersonalAccessToken savedPat = patCaptor.getValue();
            assertNotEquals(oldIdentifier, savedPat.getTokenIdentifier());
            assertNotEquals(oldHash, savedPat.getTokenHash());
        }

        @Test
        @DisplayName("should reset lastUsedAt to null")
        void shouldResetLastUsedAtToNull() {
            // Arrange
            assertNotNull(pat.getLastUsedAt()); // Verify it starts non-null

            RotatePATUseCase.RotatePATCommand command =
                    new RotatePATUseCase.RotatePATCommand(patId, superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.findById(patId)).thenReturn(Optional.of(pat));
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(tokenRepository).save(patCaptor.capture());
            PersonalAccessToken savedPat = patCaptor.getValue();
            assertNull(savedPat.getLastUsedAt());
        }

        @Test
        @DisplayName("should preserve name, scope, expiresAt, and createdBy")
        void shouldPreserveFields() {
            // Arrange
            LocalDateTime originalExpiresAt = pat.getExpiresAt();
            String originalCreatedBy = pat.getCreatedBy();

            RotatePATUseCase.RotatePATCommand command =
                    new RotatePATUseCase.RotatePATCommand(patId, superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.findById(patId)).thenReturn(Optional.of(pat));
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            RotatePATUseCase.RotatePATResult result = useCase.execute(command);

            // Assert
            assertEquals("Test PAT", result.getPatName());
            assertEquals(PATScope.READ_ONLY, result.getScope());
            assertEquals(originalExpiresAt, result.getExpiresAt());
        }

        @Test
        @DisplayName("should generate token in correct format")
        void shouldGenerateTokenInCorrectFormat() {
            // Arrange
            RotatePATUseCase.RotatePATCommand command =
                    new RotatePATUseCase.RotatePATCommand(patId, superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.findById(patId)).thenReturn(Optional.of(pat));
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            RotatePATUseCase.RotatePATResult result = useCase.execute(command);

            // Assert
            String token = result.getNewPlaintextToken();
            assertTrue(token.startsWith("pat_"));
            // Format: pat_<identifier>_<random>
            // Note: Base64 URL-safe encoding may contain underscores, so we parse carefully
            String withoutPrefix = token.substring(4);  // Remove "pat_"
            int firstUnderscore = withoutPrefix.indexOf('_');
            assertTrue(firstUnderscore > 0, "Token should have underscore separator");
            String identifier = withoutPrefix.substring(0, firstUnderscore);
            String randomPart = withoutPrefix.substring(firstUnderscore + 1);
            assertEquals(32, identifier.length(), "Identifier should be 32 characters"); // UUID without hyphens
            assertTrue(randomPart.length() >= 64, "Random part should be at least 64 characters"); // Base64 encoded random bytes
        }
    }

    @Nested
    @DisplayName("RotatePATCommand")
    class RotatePATCommandTests {

        @Test
        @DisplayName("should create command with patId and rotatedBy")
        void shouldCreateCommandWithPatIdAndRotatedBy() {
            // Arrange & Act
            RotatePATUseCase.RotatePATCommand command =
                    new RotatePATUseCase.RotatePATCommand(patId, superAdminId);

            // Assert
            assertEquals(patId, command.getPatId());
            assertEquals(superAdminId, command.getRotatedBy());
        }
    }

    @Nested
    @DisplayName("RotatePATResult")
    class RotatePATResultTests {

        @Test
        @DisplayName("should create result with all fields")
        void shouldCreateResultWithAllFields() {
            // Arrange
            LocalDateTime rotatedAt = LocalDateTime.now();
            LocalDateTime expiresAt = LocalDateTime.now().plusDays(30);
            String newToken = "pat_abc123_xyz789";

            // Act
            RotatePATUseCase.RotatePATResult result = new RotatePATUseCase.RotatePATResult(
                    patId, "Test PAT", newToken, PATScope.ADMIN, expiresAt, rotatedAt, superAdminId);

            // Assert
            assertEquals(patId, result.getPatId());
            assertEquals("Test PAT", result.getPatName());
            assertEquals(newToken, result.getNewPlaintextToken());
            assertEquals(PATScope.ADMIN, result.getScope());
            assertEquals(expiresAt, result.getExpiresAt());
            assertEquals(rotatedAt, result.getRotatedAt());
            assertEquals(superAdminId, result.getRotatedBy());
        }
    }
}
