package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.PATScope;
import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;
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

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CreateBootstrapPATUseCase Tests")
class CreateBootstrapPATUseCaseTest {

    @Mock
    private PersonalAccessTokenRepository tokenRepository;

    @Captor
    private ArgumentCaptor<PersonalAccessToken> tokenCaptor;

    private CreateBootstrapPATUseCase useCase;

    @BeforeEach
    void setUp() {
        useCase = new CreateBootstrapPATUseCase(tokenRepository);
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should create bootstrap PAT successfully")
        void shouldCreateBootstrapPATSuccessfully() {
            // Arrange
            when(tokenRepository.existsByName("bootstrap")).thenReturn(false);
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            CreateBootstrapPATUseCase.CreateBootstrapPATResult result = useCase.execute();

            // Assert
            assertNotNull(result);
            assertNotNull(result.getId());
            assertEquals("bootstrap", result.getName());
            assertNotNull(result.getPlaintextToken());
            assertEquals(PATScope.ADMIN, result.getScope());
            assertEquals("SYSTEM", result.getCreatedBy());
            assertNotNull(result.getExpiresAt());
            assertNotNull(result.getCreatedAt());
            verify(tokenRepository).save(tokenCaptor.capture());
            assertEquals("bootstrap", tokenCaptor.getValue().getName());
        }

        @Test
        @DisplayName("should generate token with correct format")
        void shouldGenerateTokenWithCorrectFormat() {
            // Arrange
            when(tokenRepository.existsByName("bootstrap")).thenReturn(false);
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            CreateBootstrapPATUseCase.CreateBootstrapPATResult result = useCase.execute();

            // Assert
            String token = result.getPlaintextToken();
            assertTrue(token.startsWith("pat_"));
            // Format: pat_<identifier>_<random>
            // Note: Base64 URL-safe encoding may contain underscores, so we split with limit
            String withoutPrefix = token.substring(4);  // Remove "pat_"
            int firstUnderscore = withoutPrefix.indexOf('_');
            assertTrue(firstUnderscore > 0, "Token should have underscore separator");
            String identifier = withoutPrefix.substring(0, firstUnderscore);
            String randomPart = withoutPrefix.substring(firstUnderscore + 1);
            // Identifier should be 32 characters (UUID without hyphens)
            assertEquals(32, identifier.length(), "Identifier should be 32 characters");
            // Random part should be 64 characters (Base64 of 48 bytes without padding)
            assertTrue(randomPart.length() >= 64, "Random part should be at least 64 characters");
        }

        @Test
        @DisplayName("should set expiration to one year from now")
        void shouldSetExpirationToOneYearFromNow() {
            // Arrange
            when(tokenRepository.existsByName("bootstrap")).thenReturn(false);
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));
            LocalDateTime beforeExecution = LocalDateTime.now();

            // Act
            CreateBootstrapPATUseCase.CreateBootstrapPATResult result = useCase.execute();

            // Assert
            LocalDateTime expectedMin = beforeExecution.plusYears(1).minusMinutes(1);
            LocalDateTime expectedMax = beforeExecution.plusYears(1).plusMinutes(1);
            assertTrue(result.getExpiresAt().isAfter(expectedMin));
            assertTrue(result.getExpiresAt().isBefore(expectedMax));
        }

        @Test
        @DisplayName("should throw exception when bootstrap PAT already exists")
        void shouldThrowExceptionWhenBootstrapPATAlreadyExists() {
            // Arrange
            when(tokenRepository.existsByName("bootstrap")).thenReturn(true);

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute()
            );

            assertTrue(exception.getMessage().contains("Bootstrap PAT already exists"));
            verify(tokenRepository, never()).save(any());
        }

        @Test
        @DisplayName("should save PAT with ADMIN scope")
        void shouldSavePATWithAdminScope() {
            // Arrange
            when(tokenRepository.existsByName("bootstrap")).thenReturn(false);
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute();

            // Assert
            verify(tokenRepository).save(tokenCaptor.capture());
            assertEquals(PATScope.ADMIN, tokenCaptor.getValue().getScope());
        }

        @Test
        @DisplayName("should save PAT with SYSTEM as creator")
        void shouldSavePATWithSystemAsCreator() {
            // Arrange
            when(tokenRepository.existsByName("bootstrap")).thenReturn(false);
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute();

            // Assert
            verify(tokenRepository).save(tokenCaptor.capture());
            assertEquals("SYSTEM", tokenCaptor.getValue().getCreatedBy());
        }

        @Test
        @DisplayName("should save PAT with hashed token")
        void shouldSavePATWithHashedToken() {
            // Arrange
            when(tokenRepository.existsByName("bootstrap")).thenReturn(false);
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            CreateBootstrapPATUseCase.CreateBootstrapPATResult result = useCase.execute();

            // Assert
            verify(tokenRepository).save(tokenCaptor.capture());
            String tokenHash = tokenCaptor.getValue().getTokenHash();
            assertNotNull(tokenHash);
            // BCrypt hash starts with $2a$ or $2b$
            assertTrue(tokenHash.startsWith("$2"));
            // Hash should be different from plaintext
            assertNotEquals(result.getPlaintextToken(), tokenHash);
        }
    }

    @Nested
    @DisplayName("CreateBootstrapPATResult")
    class CreateBootstrapPATResultTests {

        @Test
        @DisplayName("should create result with all fields")
        void shouldCreateResultWithAllFields() {
            // Arrange
            java.util.UUID id = java.util.UUID.randomUUID();
            LocalDateTime expiresAt = LocalDateTime.now().plusYears(1);
            LocalDateTime createdAt = LocalDateTime.now();

            // Act
            CreateBootstrapPATUseCase.CreateBootstrapPATResult result =
                    new CreateBootstrapPATUseCase.CreateBootstrapPATResult(
                            id, "bootstrap", "pat_abc_xyz", PATScope.ADMIN,
                            expiresAt, "SYSTEM", createdAt);

            // Assert
            assertEquals(id, result.getId());
            assertEquals("bootstrap", result.getName());
            assertEquals("pat_abc_xyz", result.getPlaintextToken());
            assertEquals(PATScope.ADMIN, result.getScope());
            assertEquals(expiresAt, result.getExpiresAt());
            assertEquals("SYSTEM", result.getCreatedBy());
            assertEquals(createdAt, result.getCreatedAt());
        }
    }
}
