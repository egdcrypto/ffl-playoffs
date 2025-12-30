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
@DisplayName("CompleteLeagueUseCase Tests")
class CompleteLeagueUseCaseTest {

    @Mock
    private LeagueRepository leagueRepository;

    private CompleteLeagueUseCase useCase;

    @Captor
    private ArgumentCaptor<League> leagueCaptor;

    private UUID leagueId;
    private League activeLeague;

    @BeforeEach
    void setUp() {
        useCase = new CompleteLeagueUseCase(leagueRepository);

        leagueId = UUID.randomUUID();

        activeLeague = new League();
        activeLeague.setId(leagueId);
        activeLeague.setName("Active League");
        activeLeague.setStatus(LeagueStatus.ACTIVE);
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should complete active league successfully")
        void shouldCompleteActiveLeagueSuccessfully() {
            // Arrange
            CompleteLeagueUseCase.CompleteLeagueCommand command =
                    new CompleteLeagueUseCase.CompleteLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(activeLeague));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(LeagueStatus.COMPLETED, result.getStatus());
            assertNotNull(result.getCompletedAt());

            verify(leagueRepository).save(leagueCaptor.capture());
            assertEquals(LeagueStatus.COMPLETED, leagueCaptor.getValue().getStatus());
        }

        @Test
        @DisplayName("should throw LeagueNotFoundException when league not found")
        void shouldThrowLeagueNotFoundException() {
            // Arrange
            UUID unknownLeagueId = UUID.randomUUID();
            CompleteLeagueUseCase.CompleteLeagueCommand command =
                    new CompleteLeagueUseCase.CompleteLeagueCommand(unknownLeagueId);

            when(leagueRepository.findById(unknownLeagueId)).thenReturn(Optional.empty());

            // Act & Assert
            CompleteLeagueUseCase.LeagueNotFoundException exception = assertThrows(
                    CompleteLeagueUseCase.LeagueNotFoundException.class,
                    () -> useCase.execute(command)
            );

            assertEquals(unknownLeagueId, exception.getLeagueId());
            assertTrue(exception.getMessage().contains(unknownLeagueId.toString()));
            verify(leagueRepository, never()).save(any());
        }

        @ParameterizedTest
        @EnumSource(value = LeagueStatus.class, mode = EnumSource.Mode.EXCLUDE, names = {"ACTIVE"})
        @DisplayName("should throw exception when league is not active")
        void shouldThrowExceptionWhenLeagueNotActive(LeagueStatus status) {
            // Arrange
            League nonActiveLeague = new League();
            nonActiveLeague.setId(leagueId);
            nonActiveLeague.setName("Non-active League");
            nonActiveLeague.setStatus(status);

            CompleteLeagueUseCase.CompleteLeagueCommand command =
                    new CompleteLeagueUseCase.CompleteLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(nonActiveLeague));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("active"));
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should set completedAt timestamp when completing")
        void shouldSetCompletedAtTimestamp() {
            // Arrange
            CompleteLeagueUseCase.CompleteLeagueCommand command =
                    new CompleteLeagueUseCase.CompleteLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(activeLeague));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertNotNull(result.getCompletedAt());
        }

        @Test
        @DisplayName("should save league after completing")
        void shouldSaveLeagueAfterCompleting() {
            // Arrange
            CompleteLeagueUseCase.CompleteLeagueCommand command =
                    new CompleteLeagueUseCase.CompleteLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(activeLeague));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(leagueRepository, times(1)).save(any(League.class));
        }
    }
}
