package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.model.LeagueStatus;
import com.ffl.playoffs.domain.port.LeagueRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.EnumSource;
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
@DisplayName("ResumeLeagueUseCase Tests")
class ResumeLeagueUseCaseTest {

    @Mock
    private LeagueRepository leagueRepository;

    private ResumeLeagueUseCase useCase;

    @Captor
    private ArgumentCaptor<League> leagueCaptor;

    private UUID leagueId;
    private League pausedLeague;

    @BeforeEach
    void setUp() {
        useCase = new ResumeLeagueUseCase(leagueRepository);

        leagueId = UUID.randomUUID();

        pausedLeague = new League();
        pausedLeague.setId(leagueId);
        pausedLeague.setName("Paused League");
        pausedLeague.setStatus(LeagueStatus.PAUSED);
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should resume paused league successfully")
        void shouldResumePausedLeagueSuccessfully() {
            // Arrange
            ResumeLeagueUseCase.ResumeLeagueCommand command =
                    new ResumeLeagueUseCase.ResumeLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(pausedLeague));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(LeagueStatus.ACTIVE, result.getStatus());

            verify(leagueRepository).save(leagueCaptor.capture());
            assertEquals(LeagueStatus.ACTIVE, leagueCaptor.getValue().getStatus());
        }

        @Test
        @DisplayName("should throw LeagueNotFoundException when league not found")
        void shouldThrowLeagueNotFoundException() {
            // Arrange
            UUID unknownLeagueId = UUID.randomUUID();
            ResumeLeagueUseCase.ResumeLeagueCommand command =
                    new ResumeLeagueUseCase.ResumeLeagueCommand(unknownLeagueId);

            when(leagueRepository.findById(unknownLeagueId)).thenReturn(Optional.empty());

            // Act & Assert
            ResumeLeagueUseCase.LeagueNotFoundException exception = assertThrows(
                    ResumeLeagueUseCase.LeagueNotFoundException.class,
                    () -> useCase.execute(command)
            );

            assertEquals(unknownLeagueId, exception.getLeagueId());
            assertTrue(exception.getMessage().contains(unknownLeagueId.toString()));
            verify(leagueRepository, never()).save(any());
        }

        @ParameterizedTest
        @EnumSource(value = LeagueStatus.class, mode = EnumSource.Mode.EXCLUDE, names = {"PAUSED"})
        @DisplayName("should throw exception when league is not paused")
        void shouldThrowExceptionWhenLeagueNotPaused(LeagueStatus status) {
            // Arrange
            League nonPausedLeague = new League();
            nonPausedLeague.setId(leagueId);
            nonPausedLeague.setName("Non-paused League");
            nonPausedLeague.setStatus(status);

            ResumeLeagueUseCase.ResumeLeagueCommand command =
                    new ResumeLeagueUseCase.ResumeLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(nonPausedLeague));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("cannot be resumed"));
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should clear pausedAt timestamp when resuming")
        void shouldClearPausedAtTimestamp() {
            // Arrange
            ResumeLeagueUseCase.ResumeLeagueCommand command =
                    new ResumeLeagueUseCase.ResumeLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(pausedLeague));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertNull(result.getPausedAt());
        }

        @Test
        @DisplayName("should save league after resuming")
        void shouldSaveLeagueAfterResuming() {
            // Arrange
            ResumeLeagueUseCase.ResumeLeagueCommand command =
                    new ResumeLeagueUseCase.ResumeLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(pausedLeague));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(leagueRepository, times(1)).save(any(League.class));
        }
    }
}
