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
@DisplayName("RevokePATUseCase Tests")
class RevokePATUseCaseTest {

    @Mock
    private PersonalAccessTokenRepository tokenRepository;

    @Mock
    private UserRepository userRepository;

    @Captor
    private ArgumentCaptor<PersonalAccessToken> patCaptor;

    private RevokePATUseCase useCase;

    private UUID superAdminId;
    private UUID regularUserId;
    private UUID patId;
    private User superAdmin;
    private User regularUser;
    private PersonalAccessToken pat;

    @BeforeEach
    void setUp() {
        useCase = new RevokePATUseCase(tokenRepository, userRepository);

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
        pat.setCreatedBy(superAdminId.toString());
        pat.setCreatedAt(LocalDateTime.now().minusDays(1));
        pat.setRevoked(false);
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should revoke PAT successfully")
        void shouldRevokePATSuccessfully() {
            // Arrange
            RevokePATUseCase.RevokePATCommand command =
                    new RevokePATUseCase.RevokePATCommand(patId, superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.findById(patId)).thenReturn(Optional.of(pat));
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            RevokePATUseCase.RevokePATResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertTrue(result.isRevoked());
            assertEquals(patId, result.getPatId());
            assertEquals("Test PAT", result.getPatName());
            assertEquals(superAdminId, result.getRevokedBy());
            assertNotNull(result.getRevokedAt());
        }

        @Test
        @DisplayName("should throw exception when user not found")
        void shouldThrowExceptionWhenUserNotFound() {
            // Arrange
            UUID unknownUserId = UUID.randomUUID();
            RevokePATUseCase.RevokePATCommand command =
                    new RevokePATUseCase.RevokePATCommand(patId, unknownUserId);

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
            RevokePATUseCase.RevokePATCommand command =
                    new RevokePATUseCase.RevokePATCommand(patId, regularUserId);

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
            RevokePATUseCase.RevokePATCommand command =
                    new RevokePATUseCase.RevokePATCommand(unknownPatId, superAdminId);

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
        @DisplayName("should throw exception when PAT already revoked")
        void shouldThrowExceptionWhenPATAlreadyRevoked() {
            // Arrange
            pat.setRevoked(true);

            RevokePATUseCase.RevokePATCommand command =
                    new RevokePATUseCase.RevokePATCommand(patId, superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.findById(patId)).thenReturn(Optional.of(pat));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Cannot revoke PAT"));
            verify(tokenRepository, never()).save(any());
        }

        @Test
        @DisplayName("should save revoked PAT to repository")
        void shouldSaveRevokedPATToRepository() {
            // Arrange
            RevokePATUseCase.RevokePATCommand command =
                    new RevokePATUseCase.RevokePATCommand(patId, superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.findById(patId)).thenReturn(Optional.of(pat));
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(tokenRepository, times(1)).save(patCaptor.capture());
            PersonalAccessToken savedPat = patCaptor.getValue();
            assertTrue(savedPat.isRevoked());
        }

        @Test
        @DisplayName("should return correct metadata in result")
        void shouldReturnCorrectMetadataInResult() {
            // Arrange
            pat.setName("Custom PAT Name");

            RevokePATUseCase.RevokePATCommand command =
                    new RevokePATUseCase.RevokePATCommand(patId, superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.findById(patId)).thenReturn(Optional.of(pat));
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));

            LocalDateTime beforeExecution = LocalDateTime.now();

            // Act
            RevokePATUseCase.RevokePATResult result = useCase.execute(command);

            LocalDateTime afterExecution = LocalDateTime.now();

            // Assert
            assertEquals(patId, result.getPatId());
            assertEquals("Custom PAT Name", result.getPatName());
            assertTrue(result.isRevoked());
            assertTrue(result.getRevokedAt().isAfter(beforeExecution.minusSeconds(1)));
            assertTrue(result.getRevokedAt().isBefore(afterExecution.plusSeconds(1)));
            assertEquals(superAdminId, result.getRevokedBy());
        }
    }

    @Nested
    @DisplayName("RevokePATCommand")
    class RevokePATCommandTests {

        @Test
        @DisplayName("should create command with patId and revokedBy")
        void shouldCreateCommandWithPatIdAndRevokedBy() {
            // Arrange & Act
            RevokePATUseCase.RevokePATCommand command =
                    new RevokePATUseCase.RevokePATCommand(patId, superAdminId);

            // Assert
            assertEquals(patId, command.getPatId());
            assertEquals(superAdminId, command.getRevokedBy());
        }
    }

    @Nested
    @DisplayName("RevokePATResult")
    class RevokePATResultTests {

        @Test
        @DisplayName("should create result with all fields")
        void shouldCreateResultWithAllFields() {
            // Arrange
            LocalDateTime revokedAt = LocalDateTime.now();

            // Act
            RevokePATUseCase.RevokePATResult result =
                    new RevokePATUseCase.RevokePATResult(patId, "Test PAT", true, revokedAt, superAdminId);

            // Assert
            assertEquals(patId, result.getPatId());
            assertEquals("Test PAT", result.getPatName());
            assertTrue(result.isRevoked());
            assertEquals(revokedAt, result.getRevokedAt());
            assertEquals(superAdminId, result.getRevokedBy());
        }

        @Test
        @DisplayName("should handle false revoked flag")
        void shouldHandleFalseRevokedFlag() {
            // Arrange & Act
            RevokePATUseCase.RevokePATResult result =
                    new RevokePATUseCase.RevokePATResult(patId, "Test PAT", false, null, superAdminId);

            // Assert
            assertFalse(result.isRevoked());
            assertNull(result.getRevokedAt());
        }
    }
}
