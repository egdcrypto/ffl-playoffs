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
@DisplayName("CancelLeagueUseCase Tests")
class CancelLeagueUseCaseTest {

    @Mock
    private LeagueRepository leagueRepository;

    private CancelLeagueUseCase useCase;

    @Captor
    private ArgumentCaptor<League> leagueCaptor;

    private UUID leagueId;
    private String cancellationReason;

    @BeforeEach
    void setUp() {
        useCase = new CancelLeagueUseCase(leagueRepository);

        leagueId = UUID.randomUUID();
        cancellationReason = "League cancelled due to insufficient players";
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @ParameterizedTest
        @EnumSource(value = LeagueStatus.class, names = {"DRAFT", "WAITING_FOR_PLAYERS", "ACTIVE", "INACTIVE", "PAUSED"})
        @DisplayName("should cancel league successfully when status allows cancellation")
        void shouldCancelLeagueSuccessfully(LeagueStatus status) {
            // Arrange
            League cancellableLeague = new League();
            cancellableLeague.setId(leagueId);
            cancellableLeague.setName("Cancellable League");
            cancellableLeague.setStatus(status);

            CancelLeagueUseCase.CancelLeagueCommand command =
                    new CancelLeagueUseCase.CancelLeagueCommand(leagueId, cancellationReason);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(cancellableLeague));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(LeagueStatus.CANCELLED, result.getStatus());
            assertEquals(cancellationReason, result.getCancellationReason());

            verify(leagueRepository).save(leagueCaptor.capture());
            assertEquals(LeagueStatus.CANCELLED, leagueCaptor.getValue().getStatus());
        }

        @Test
        @DisplayName("should throw LeagueNotFoundException when league not found")
        void shouldThrowLeagueNotFoundException() {
            // Arrange
            UUID unknownLeagueId = UUID.randomUUID();
            CancelLeagueUseCase.CancelLeagueCommand command =
                    new CancelLeagueUseCase.CancelLeagueCommand(unknownLeagueId, cancellationReason);

            when(leagueRepository.findById(unknownLeagueId)).thenReturn(Optional.empty());

            // Act & Assert
            CancelLeagueUseCase.LeagueNotFoundException exception = assertThrows(
                    CancelLeagueUseCase.LeagueNotFoundException.class,
                    () -> useCase.execute(command)
            );

            assertEquals(unknownLeagueId, exception.getLeagueId());
            assertTrue(exception.getMessage().contains(unknownLeagueId.toString()));
            verify(leagueRepository, never()).save(any());
        }

        @ParameterizedTest
        @EnumSource(value = LeagueStatus.class, names = {"COMPLETED", "CANCELLED", "ARCHIVED"})
        @DisplayName("should throw exception when league status is terminal")
        void shouldThrowExceptionWhenLeagueIsTerminal(LeagueStatus status) {
            // Arrange
            League terminalLeague = new League();
            terminalLeague.setId(leagueId);
            terminalLeague.setName("Terminal League");
            terminalLeague.setStatus(status);

            CancelLeagueUseCase.CancelLeagueCommand command =
                    new CancelLeagueUseCase.CancelLeagueCommand(leagueId, cancellationReason);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(terminalLeague));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("cannot be cancelled"));
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should preserve cancellation reason in league")
        void shouldPreserveCancellationReason() {
            // Arrange
            League activeLeague = new League();
            activeLeague.setId(leagueId);
            activeLeague.setName("Active League");
            activeLeague.setStatus(LeagueStatus.ACTIVE);

            String customReason = "Season ended early";
            CancelLeagueUseCase.CancelLeagueCommand command =
                    new CancelLeagueUseCase.CancelLeagueCommand(leagueId, customReason);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(activeLeague));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertEquals(customReason, result.getCancellationReason());
        }

        @Test
        @DisplayName("should save league after cancellation")
        void shouldSaveLeagueAfterCancellation() {
            // Arrange
            League draftLeague = new League();
            draftLeague.setId(leagueId);
            draftLeague.setName("Draft League");
            draftLeague.setStatus(LeagueStatus.DRAFT);

            CancelLeagueUseCase.CancelLeagueCommand command =
                    new CancelLeagueUseCase.CancelLeagueCommand(leagueId, cancellationReason);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(draftLeague));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(leagueRepository, times(1)).save(any(League.class));
        }
    }
}
