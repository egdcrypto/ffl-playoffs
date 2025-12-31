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
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("DeletePATUseCase Tests")
class DeletePATUseCaseTest {

    @Mock
    private PersonalAccessTokenRepository tokenRepository;

    @Mock
    private UserRepository userRepository;

    private DeletePATUseCase useCase;

    private UUID superAdminId;
    private UUID regularUserId;
    private UUID patId;
    private User superAdmin;
    private User regularUser;
    private PersonalAccessToken pat;

    @BeforeEach
    void setUp() {
        useCase = new DeletePATUseCase(tokenRepository, userRepository);

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
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should delete PAT successfully")
        void shouldDeletePATSuccessfully() {
            // Arrange
            DeletePATUseCase.DeletePATCommand command =
                    new DeletePATUseCase.DeletePATCommand(patId, superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.findById(patId)).thenReturn(Optional.of(pat));

            // Act
            DeletePATUseCase.DeletePATResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertTrue(result.isDeleted());
            assertEquals(patId, result.getPatId());
            assertEquals("Test PAT", result.getPatName());
            assertEquals(superAdminId, result.getDeletedBy());
            assertNotNull(result.getDeletedAt());

            verify(tokenRepository).deleteById(patId);
        }

        @Test
        @DisplayName("should throw exception when user not found")
        void shouldThrowExceptionWhenUserNotFound() {
            // Arrange
            UUID unknownUserId = UUID.randomUUID();
            DeletePATUseCase.DeletePATCommand command =
                    new DeletePATUseCase.DeletePATCommand(patId, unknownUserId);

            when(userRepository.findById(unknownUserId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("User not found"));
            verify(tokenRepository, never()).deleteById(any());
        }

        @Test
        @DisplayName("should throw SecurityException when user is not SUPER_ADMIN")
        void shouldThrowSecurityExceptionWhenNotSuperAdmin() {
            // Arrange
            DeletePATUseCase.DeletePATCommand command =
                    new DeletePATUseCase.DeletePATCommand(patId, regularUserId);

            when(userRepository.findById(regularUserId)).thenReturn(Optional.of(regularUser));

            // Act & Assert
            SecurityException exception = assertThrows(
                    SecurityException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("SUPER_ADMIN"));
            verify(tokenRepository, never()).deleteById(any());
        }

        @Test
        @DisplayName("should throw exception when PAT not found")
        void shouldThrowExceptionWhenPATNotFound() {
            // Arrange
            UUID unknownPatId = UUID.randomUUID();
            DeletePATUseCase.DeletePATCommand command =
                    new DeletePATUseCase.DeletePATCommand(unknownPatId, superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.findById(unknownPatId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("PAT not found"));
            verify(tokenRepository, never()).deleteById(any());
        }

        @Test
        @DisplayName("should return correct metadata in result")
        void shouldReturnCorrectMetadataInResult() {
            // Arrange
            pat.setName("Custom PAT Name");

            DeletePATUseCase.DeletePATCommand command =
                    new DeletePATUseCase.DeletePATCommand(patId, superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.findById(patId)).thenReturn(Optional.of(pat));

            LocalDateTime beforeExecution = LocalDateTime.now();

            // Act
            DeletePATUseCase.DeletePATResult result = useCase.execute(command);

            LocalDateTime afterExecution = LocalDateTime.now();

            // Assert
            assertEquals(patId, result.getPatId());
            assertEquals("Custom PAT Name", result.getPatName());
            assertTrue(result.isDeleted());
            assertTrue(result.getDeletedAt().isAfter(beforeExecution.minusSeconds(1)));
            assertTrue(result.getDeletedAt().isBefore(afterExecution.plusSeconds(1)));
            assertEquals(superAdminId, result.getDeletedBy());
        }

        @Test
        @DisplayName("should call deleteById on repository")
        void shouldCallDeleteByIdOnRepository() {
            // Arrange
            DeletePATUseCase.DeletePATCommand command =
                    new DeletePATUseCase.DeletePATCommand(patId, superAdminId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.findById(patId)).thenReturn(Optional.of(pat));

            // Act
            useCase.execute(command);

            // Assert
            verify(tokenRepository, times(1)).deleteById(patId);
        }
    }

    @Nested
    @DisplayName("DeletePATCommand")
    class DeletePATCommandTests {

        @Test
        @DisplayName("should create command with patId and deletedBy")
        void shouldCreateCommandWithPatIdAndDeletedBy() {
            // Arrange & Act
            DeletePATUseCase.DeletePATCommand command =
                    new DeletePATUseCase.DeletePATCommand(patId, superAdminId);

            // Assert
            assertEquals(patId, command.getPatId());
            assertEquals(superAdminId, command.getDeletedBy());
        }
    }

    @Nested
    @DisplayName("DeletePATResult")
    class DeletePATResultTests {

        @Test
        @DisplayName("should create result with all fields")
        void shouldCreateResultWithAllFields() {
            // Arrange
            LocalDateTime deletedAt = LocalDateTime.now();

            // Act
            DeletePATUseCase.DeletePATResult result =
                    new DeletePATUseCase.DeletePATResult(patId, "Test PAT", true, deletedAt, superAdminId);

            // Assert
            assertEquals(patId, result.getPatId());
            assertEquals("Test PAT", result.getPatName());
            assertTrue(result.isDeleted());
            assertEquals(deletedAt, result.getDeletedAt());
            assertEquals(superAdminId, result.getDeletedBy());
        }

        @Test
        @DisplayName("should handle false deleted flag")
        void shouldHandleFalseDeletedFlag() {
            // Arrange & Act
            DeletePATUseCase.DeletePATResult result =
                    new DeletePATUseCase.DeletePATResult(patId, "Test PAT", false, null, superAdminId);

            // Assert
            assertFalse(result.isDeleted());
            assertNull(result.getDeletedAt());
        }
    }
}
