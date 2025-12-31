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
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("UpdatePATLastUsedUseCase Tests")
class UpdatePATLastUsedUseCaseTest {

    @Mock
    private PersonalAccessTokenRepository tokenRepository;

    @Captor
    private ArgumentCaptor<PersonalAccessToken> patCaptor;

    private UpdatePATLastUsedUseCase useCase;

    private UUID patId;
    private PersonalAccessToken pat;

    @BeforeEach
    void setUp() {
        useCase = new UpdatePATLastUsedUseCase(tokenRepository);

        patId = UUID.randomUUID();

        pat = new PersonalAccessToken();
        pat.setId(patId);
        pat.setName("Test PAT");
        pat.setScope(PATScope.READ_ONLY);
        pat.setCreatedBy(UUID.randomUUID().toString());
        pat.setCreatedAt(LocalDateTime.now().minusDays(30));
        pat.setLastUsedAt(LocalDateTime.now().minusDays(1));
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should update last used timestamp successfully")
        void shouldUpdateLastUsedTimestampSuccessfully() {
            // Arrange
            UpdatePATLastUsedUseCase.UpdatePATLastUsedCommand command =
                    new UpdatePATLastUsedUseCase.UpdatePATLastUsedCommand(patId);

            when(tokenRepository.findById(patId)).thenReturn(Optional.of(pat));
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));

            LocalDateTime beforeExecution = LocalDateTime.now();

            // Act
            UpdatePATLastUsedUseCase.UpdatePATLastUsedResult result = useCase.execute(command);

            LocalDateTime afterExecution = LocalDateTime.now();

            // Assert
            assertNotNull(result);
            assertEquals(patId, result.getPatId());
            assertEquals("Test PAT", result.getPatName());
            assertNotNull(result.getLastUsedAt());
            assertTrue(result.getLastUsedAt().isAfter(beforeExecution.minusSeconds(1)));
            assertTrue(result.getLastUsedAt().isBefore(afterExecution.plusSeconds(1)));
        }

        @Test
        @DisplayName("should throw exception when PAT not found")
        void shouldThrowExceptionWhenPATNotFound() {
            // Arrange
            UUID unknownPatId = UUID.randomUUID();
            UpdatePATLastUsedUseCase.UpdatePATLastUsedCommand command =
                    new UpdatePATLastUsedUseCase.UpdatePATLastUsedCommand(unknownPatId);

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
        @DisplayName("should save PAT with updated lastUsedAt")
        void shouldSavePATWithUpdatedLastUsedAt() {
            // Arrange
            LocalDateTime oldLastUsedAt = pat.getLastUsedAt();

            UpdatePATLastUsedUseCase.UpdatePATLastUsedCommand command =
                    new UpdatePATLastUsedUseCase.UpdatePATLastUsedCommand(patId);

            when(tokenRepository.findById(patId)).thenReturn(Optional.of(pat));
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(tokenRepository).save(patCaptor.capture());
            PersonalAccessToken savedPat = patCaptor.getValue();
            assertNotNull(savedPat.getLastUsedAt());
            assertTrue(savedPat.getLastUsedAt().isAfter(oldLastUsedAt));
        }

        @Test
        @DisplayName("should update PAT with null lastUsedAt")
        void shouldUpdatePATWithNullLastUsedAt() {
            // Arrange
            pat.setLastUsedAt(null);

            UpdatePATLastUsedUseCase.UpdatePATLastUsedCommand command =
                    new UpdatePATLastUsedUseCase.UpdatePATLastUsedCommand(patId);

            when(tokenRepository.findById(patId)).thenReturn(Optional.of(pat));
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            UpdatePATLastUsedUseCase.UpdatePATLastUsedResult result = useCase.execute(command);

            // Assert
            assertNotNull(result.getLastUsedAt());
        }

        @Test
        @DisplayName("should call repository save")
        void shouldCallRepositorySave() {
            // Arrange
            UpdatePATLastUsedUseCase.UpdatePATLastUsedCommand command =
                    new UpdatePATLastUsedUseCase.UpdatePATLastUsedCommand(patId);

            when(tokenRepository.findById(patId)).thenReturn(Optional.of(pat));
            when(tokenRepository.save(any(PersonalAccessToken.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(tokenRepository, times(1)).save(any(PersonalAccessToken.class));
        }
    }

    @Nested
    @DisplayName("UpdatePATLastUsedCommand")
    class UpdatePATLastUsedCommandTests {

        @Test
        @DisplayName("should create command with patId")
        void shouldCreateCommandWithPatId() {
            // Arrange & Act
            UpdatePATLastUsedUseCase.UpdatePATLastUsedCommand command =
                    new UpdatePATLastUsedUseCase.UpdatePATLastUsedCommand(patId);

            // Assert
            assertEquals(patId, command.getPatId());
        }
    }

    @Nested
    @DisplayName("UpdatePATLastUsedResult")
    class UpdatePATLastUsedResultTests {

        @Test
        @DisplayName("should create result with all fields")
        void shouldCreateResultWithAllFields() {
            // Arrange
            LocalDateTime lastUsedAt = LocalDateTime.now();

            // Act
            UpdatePATLastUsedUseCase.UpdatePATLastUsedResult result =
                    new UpdatePATLastUsedUseCase.UpdatePATLastUsedResult(patId, "Test PAT", lastUsedAt);

            // Assert
            assertEquals(patId, result.getPatId());
            assertEquals("Test PAT", result.getPatName());
            assertEquals(lastUsedAt, result.getLastUsedAt());
        }

        @Test
        @DisplayName("should handle null lastUsedAt")
        void shouldHandleNullLastUsedAt() {
            // Arrange & Act
            UpdatePATLastUsedUseCase.UpdatePATLastUsedResult result =
                    new UpdatePATLastUsedUseCase.UpdatePATLastUsedResult(patId, "Test PAT", null);

            // Assert
            assertNull(result.getLastUsedAt());
        }
    }
}
