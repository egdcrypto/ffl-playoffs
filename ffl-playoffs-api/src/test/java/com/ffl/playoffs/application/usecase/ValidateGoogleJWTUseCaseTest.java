package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.UserRepository;
import com.ffl.playoffs.infrastructure.auth.GoogleJwtClaims;
import com.ffl.playoffs.infrastructure.auth.GoogleJwtValidator;
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
@DisplayName("ValidateGoogleJWTUseCase Tests")
class ValidateGoogleJWTUseCaseTest {

    @Mock
    private GoogleJwtValidator jwtValidator;

    @Mock
    private UserRepository userRepository;

    @Captor
    private ArgumentCaptor<User> userCaptor;

    private ValidateGoogleJWTUseCase useCase;

    private String validToken;
    private GoogleJwtClaims claims;
    private User existingUser;

    @BeforeEach
    void setUp() {
        useCase = new ValidateGoogleJWTUseCase(jwtValidator, userRepository);

        validToken = "valid.jwt.token";
        claims = new GoogleJwtClaims("google-123", "test@example.com", "Test User");

        existingUser = new User("test@example.com", "Test User", "google-123", Role.PLAYER);
        existingUser.setId(UUID.randomUUID());
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should validate JWT and return existing user")
        void shouldValidateJWTAndReturnExistingUser() {
            // Arrange
            ValidateGoogleJWTUseCase.ValidateJWTCommand command =
                    new ValidateGoogleJWTUseCase.ValidateJWTCommand(validToken);

            when(jwtValidator.validateAndExtractClaims(validToken)).thenReturn(claims);
            when(userRepository.findByGoogleId("google-123")).thenReturn(Optional.of(existingUser));
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            ValidateGoogleJWTUseCase.ValidationResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertTrue(result.isValid());
            assertNotNull(result.getUser());
            assertEquals("test@example.com", result.getUser().getEmail());
            assertEquals("Authentication successful", result.getMessage());
        }

        @Test
        @DisplayName("should throw exception when JWT is invalid")
        void shouldThrowExceptionWhenJWTIsInvalid() {
            // Arrange
            String invalidToken = "invalid.jwt.token";
            ValidateGoogleJWTUseCase.ValidateJWTCommand command =
                    new ValidateGoogleJWTUseCase.ValidateJWTCommand(invalidToken);

            when(jwtValidator.validateAndExtractClaims(invalidToken)).thenReturn(null);

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Invalid JWT token"));
            verify(userRepository, never()).findByGoogleId(any());
        }

        @Test
        @DisplayName("should create new user on first login")
        void shouldCreateNewUserOnFirstLogin() {
            // Arrange
            ValidateGoogleJWTUseCase.ValidateJWTCommand command =
                    new ValidateGoogleJWTUseCase.ValidateJWTCommand(validToken);

            when(jwtValidator.validateAndExtractClaims(validToken)).thenReturn(claims);
            when(userRepository.findByGoogleId("google-123")).thenReturn(Optional.empty());
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            ValidateGoogleJWTUseCase.ValidationResult result = useCase.execute(command);

            // Assert
            assertTrue(result.isValid());
            assertNotNull(result.getUser());
            assertEquals("test@example.com", result.getUser().getEmail());
            assertEquals("Test User", result.getUser().getName());
            assertEquals(Role.PLAYER, result.getUser().getRole());

            // Verify user was saved twice (once for creation, once for lastLogin update)
            verify(userRepository, times(2)).save(any(User.class));
        }

        @Test
        @DisplayName("should update lastLogin for existing user")
        void shouldUpdateLastLoginForExistingUser() {
            // Arrange
            ValidateGoogleJWTUseCase.ValidateJWTCommand command =
                    new ValidateGoogleJWTUseCase.ValidateJWTCommand(validToken);

            when(jwtValidator.validateAndExtractClaims(validToken)).thenReturn(claims);
            when(userRepository.findByGoogleId("google-123")).thenReturn(Optional.of(existingUser));
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(userRepository).save(userCaptor.capture());
            User savedUser = userCaptor.getValue();
            assertNotNull(savedUser.getLastLoginAt());
        }

        @Test
        @DisplayName("should assign PLAYER role to new users")
        void shouldAssignPlayerRoleToNewUsers() {
            // Arrange
            ValidateGoogleJWTUseCase.ValidateJWTCommand command =
                    new ValidateGoogleJWTUseCase.ValidateJWTCommand(validToken);

            when(jwtValidator.validateAndExtractClaims(validToken)).thenReturn(claims);
            when(userRepository.findByGoogleId("google-123")).thenReturn(Optional.empty());
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            ValidateGoogleJWTUseCase.ValidationResult result = useCase.execute(command);

            // Assert
            assertEquals(Role.PLAYER, result.getUser().getRole());
        }
    }

    @Nested
    @DisplayName("ValidateJWTCommand")
    class ValidateJWTCommandTests {

        @Test
        @DisplayName("should create command with token")
        void shouldCreateCommandWithToken() {
            // Arrange & Act
            ValidateGoogleJWTUseCase.ValidateJWTCommand command =
                    new ValidateGoogleJWTUseCase.ValidateJWTCommand(validToken);

            // Assert
            assertEquals(validToken, command.getToken());
        }
    }

    @Nested
    @DisplayName("ValidationResult")
    class ValidationResultTests {

        @Test
        @DisplayName("should create result with all fields")
        void shouldCreateResultWithAllFields() {
            // Arrange & Act
            ValidateGoogleJWTUseCase.ValidationResult result =
                    new ValidateGoogleJWTUseCase.ValidationResult(existingUser, true, "Success");

            // Assert
            assertEquals(existingUser, result.getUser());
            assertTrue(result.isValid());
            assertEquals("Success", result.getMessage());
        }

        @Test
        @DisplayName("should handle invalid result")
        void shouldHandleInvalidResult() {
            // Arrange & Act
            ValidateGoogleJWTUseCase.ValidationResult result =
                    new ValidateGoogleJWTUseCase.ValidationResult(null, false, "Failed");

            // Assert
            assertNull(result.getUser());
            assertFalse(result.isValid());
            assertEquals("Failed", result.getMessage());
        }
    }
}
