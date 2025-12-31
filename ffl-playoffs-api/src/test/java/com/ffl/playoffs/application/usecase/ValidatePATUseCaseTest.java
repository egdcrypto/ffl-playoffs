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
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ValidatePATUseCase Tests")
class ValidatePATUseCaseTest {

    @Mock
    private PersonalAccessTokenRepository tokenRepository;

    @Mock
    private UserRepository userRepository;

    private ValidatePATUseCase useCase;

    private UUID userId;

    @BeforeEach
    void setUp() {
        useCase = new ValidatePATUseCase(tokenRepository, userRepository);
        userId = UUID.randomUUID();
    }

    private PersonalAccessToken createValidToken() {
        PersonalAccessToken pat = new PersonalAccessToken(
                "Test PAT",
                "abc123",
                "hashedToken",
                PATScope.ADMIN,
                LocalDateTime.now().plusDays(30),
                userId.toString()
        );
        return pat;
    }

    private PersonalAccessToken createExpiredToken() {
        PersonalAccessToken pat = new PersonalAccessToken(
                "Expired PAT",
                "expired123",
                "hashedToken",
                PATScope.ADMIN,
                LocalDateTime.now().minusDays(1),
                userId.toString()
        );
        return pat;
    }

    private PersonalAccessToken createRevokedToken() {
        PersonalAccessToken pat = new PersonalAccessToken(
                "Revoked PAT",
                "revoked123",
                "hashedToken",
                PATScope.ADMIN,
                LocalDateTime.now().plusDays(30),
                userId.toString()
        );
        pat.revoke();
        return pat;
    }

    private User createUser() {
        User user = new User("user@test.com", "Test User", "google123", Role.ADMIN);
        user.setId(userId);
        return user;
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should validate valid token successfully")
        void shouldValidateValidTokenSuccessfully() {
            // Arrange
            PersonalAccessToken pat = createValidToken();
            User user = createUser();
            String fullToken = "pat_abc123_secretpart";

            ValidatePATUseCase.ValidatePATCommand command =
                    new ValidatePATUseCase.ValidatePATCommand(fullToken);

            when(tokenRepository.findByTokenIdentifier("abc123")).thenReturn(Optional.of(pat));
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));
            when(userRepository.findById(userId)).thenReturn(Optional.of(user));

            // Act
            ValidatePATUseCase.ValidationResult result = useCase.execute(command);

            // Assert
            assertTrue(result.isValid());
            assertEquals("Token is valid", result.getMessage());
            assertNotNull(result.getToken());
            assertNotNull(result.getUser());
            assertEquals(PATScope.ADMIN, result.getScope());
            verify(tokenRepository).save(any(PersonalAccessToken.class));
        }

        @Test
        @DisplayName("should throw exception for invalid token format")
        void shouldThrowExceptionForInvalidTokenFormat() {
            // Arrange
            String invalidToken = "invalid_format";
            ValidatePATUseCase.ValidatePATCommand command =
                    new ValidatePATUseCase.ValidatePATCommand(invalidToken);

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Invalid PAT format"));
        }

        @Test
        @DisplayName("should throw exception when token not found")
        void shouldThrowExceptionWhenTokenNotFound() {
            // Arrange
            String fullToken = "pat_unknown123_secretpart";
            ValidatePATUseCase.ValidatePATCommand command =
                    new ValidatePATUseCase.ValidatePATCommand(fullToken);

            when(tokenRepository.findByTokenIdentifier("unknown123")).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Invalid token"));
        }

        @Test
        @DisplayName("should return invalid result for expired token")
        void shouldReturnInvalidResultForExpiredToken() {
            // Arrange
            PersonalAccessToken expiredPat = createExpiredToken();
            String fullToken = "pat_expired123_secretpart";

            ValidatePATUseCase.ValidatePATCommand command =
                    new ValidatePATUseCase.ValidatePATCommand(fullToken);

            when(tokenRepository.findByTokenIdentifier("expired123")).thenReturn(Optional.of(expiredPat));

            // Act
            ValidatePATUseCase.ValidationResult result = useCase.execute(command);

            // Assert
            assertFalse(result.isValid());
            assertTrue(result.getMessage().contains("expired"));
            verify(tokenRepository, never()).save(any());
        }

        @Test
        @DisplayName("should return invalid result for revoked token")
        void shouldReturnInvalidResultForRevokedToken() {
            // Arrange
            PersonalAccessToken revokedPat = createRevokedToken();
            String fullToken = "pat_revoked123_secretpart";

            ValidatePATUseCase.ValidatePATCommand command =
                    new ValidatePATUseCase.ValidatePATCommand(fullToken);

            when(tokenRepository.findByTokenIdentifier("revoked123")).thenReturn(Optional.of(revokedPat));

            // Act
            ValidatePATUseCase.ValidationResult result = useCase.execute(command);

            // Assert
            assertFalse(result.isValid());
            assertTrue(result.getMessage().contains("revoked"));
            verify(tokenRepository, never()).save(any());
        }

        @Test
        @DisplayName("should return invalid result for insufficient scope")
        void shouldReturnInvalidResultForInsufficientScope() {
            // Arrange
            PersonalAccessToken readOnlyPat = new PersonalAccessToken(
                    "Read Only PAT",
                    "readonly123",
                    "hashedToken",
                    PATScope.READ_ONLY,
                    LocalDateTime.now().plusDays(30),
                    userId.toString()
            );
            String fullToken = "pat_readonly123_secretpart";

            ValidatePATUseCase.ValidatePATCommand command =
                    new ValidatePATUseCase.ValidatePATCommand(fullToken, PATScope.ADMIN);

            when(tokenRepository.findByTokenIdentifier("readonly123")).thenReturn(Optional.of(readOnlyPat));

            // Act
            ValidatePATUseCase.ValidationResult result = useCase.execute(command);

            // Assert
            assertFalse(result.isValid());
            assertTrue(result.getMessage().contains("Insufficient scope"));
            assertEquals(PATScope.READ_ONLY, result.getScope());
        }

        @Test
        @DisplayName("should not lookup user for SYSTEM created tokens")
        void shouldNotLookupUserForSystemCreatedTokens() {
            // Arrange
            PersonalAccessToken systemPat = new PersonalAccessToken(
                    "System PAT",
                    "system123",
                    "hashedToken",
                    PATScope.ADMIN,
                    LocalDateTime.now().plusDays(30),
                    "SYSTEM"
            );
            String fullToken = "pat_system123_secretpart";

            ValidatePATUseCase.ValidatePATCommand command =
                    new ValidatePATUseCase.ValidatePATCommand(fullToken);

            when(tokenRepository.findByTokenIdentifier("system123")).thenReturn(Optional.of(systemPat));
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            ValidatePATUseCase.ValidationResult result = useCase.execute(command);

            // Assert
            assertTrue(result.isValid());
            assertNull(result.getUser());
            verify(userRepository, never()).findById(any(UUID.class));
        }

        @Test
        @DisplayName("should update last used timestamp on valid token")
        void shouldUpdateLastUsedTimestampOnValidToken() {
            // Arrange
            PersonalAccessToken pat = createValidToken();
            LocalDateTime beforeValidation = pat.getLastUsedAt();
            String fullToken = "pat_abc123_secretpart";

            ValidatePATUseCase.ValidatePATCommand command =
                    new ValidatePATUseCase.ValidatePATCommand(fullToken);

            when(tokenRepository.findByTokenIdentifier("abc123")).thenReturn(Optional.of(pat));
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));
            when(userRepository.findById(userId)).thenReturn(Optional.empty());

            // Act
            useCase.execute(command);

            // Assert
            verify(tokenRepository).save(pat);
            // Last used should be updated (not null anymore)
            assertNotEquals(beforeValidation, pat.getLastUsedAt());
        }
    }

    @Nested
    @DisplayName("ValidatePATCommand")
    class ValidatePATCommandTests {

        @Test
        @DisplayName("should create command with token only")
        void shouldCreateCommandWithTokenOnly() {
            // Arrange & Act
            ValidatePATUseCase.ValidatePATCommand command =
                    new ValidatePATUseCase.ValidatePATCommand("pat_test_secret");

            // Assert
            assertEquals("pat_test_secret", command.getToken());
            assertNull(command.getRequiredScope());
        }

        @Test
        @DisplayName("should create command with token and required scope")
        void shouldCreateCommandWithTokenAndRequiredScope() {
            // Arrange & Act
            ValidatePATUseCase.ValidatePATCommand command =
                    new ValidatePATUseCase.ValidatePATCommand("pat_test_secret", PATScope.WRITE);

            // Assert
            assertEquals("pat_test_secret", command.getToken());
            assertEquals(PATScope.WRITE, command.getRequiredScope());
        }
    }

    @Nested
    @DisplayName("ValidationResult")
    class ValidationResultTests {

        @Test
        @DisplayName("should create valid result with all fields")
        void shouldCreateValidResultWithAllFields() {
            // Arrange
            PersonalAccessToken pat = createValidToken();
            User user = createUser();

            // Act
            ValidatePATUseCase.ValidationResult result =
                    new ValidatePATUseCase.ValidationResult(
                            pat, user, true, "Token is valid", PATScope.ADMIN);

            // Assert
            assertEquals(pat, result.getToken());
            assertEquals(user, result.getUser());
            assertTrue(result.isValid());
            assertEquals("Token is valid", result.getMessage());
            assertEquals(PATScope.ADMIN, result.getScope());
        }

        @Test
        @DisplayName("should create invalid result")
        void shouldCreateInvalidResult() {
            // Arrange & Act
            ValidatePATUseCase.ValidationResult result =
                    new ValidatePATUseCase.ValidationResult(
                            null, null, false, "Token has expired", null);

            // Assert
            assertNull(result.getToken());
            assertNull(result.getUser());
            assertFalse(result.isValid());
            assertEquals("Token has expired", result.getMessage());
            assertNull(result.getScope());
        }
    }
}
