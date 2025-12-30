package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.model.LeagueStatus;
import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.WeekRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.EnumSource;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("DeleteLeagueUseCase Tests")
class DeleteLeagueUseCaseTest {

    @Mock
    private LeagueRepository leagueRepository;

    @Mock
    private WeekRepository weekRepository;

    private DeleteLeagueUseCase useCase;

    private UUID leagueId;
    private League draftLeague;

    @BeforeEach
    void setUp() {
        useCase = new DeleteLeagueUseCase(leagueRepository, weekRepository);

        leagueId = UUID.randomUUID();

        draftLeague = new League();
        draftLeague.setId(leagueId);
        draftLeague.setName("Draft League");
        draftLeague.setStatus(LeagueStatus.DRAFT);
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should delete draft league successfully")
        void shouldDeleteDraftLeagueSuccessfully() {
            // Arrange
            DeleteLeagueUseCase.DeleteLeagueCommand command =
                    new DeleteLeagueUseCase.DeleteLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(draftLeague));

            // Act
            useCase.execute(command);

            // Assert
            verify(weekRepository).deleteByLeagueId(leagueId);
            verify(leagueRepository).deleteById(leagueId);
        }

        @Test
        @DisplayName("should throw LeagueNotFoundException when league not found")
        void shouldThrowLeagueNotFoundException() {
            // Arrange
            UUID unknownLeagueId = UUID.randomUUID();
            DeleteLeagueUseCase.DeleteLeagueCommand command =
                    new DeleteLeagueUseCase.DeleteLeagueCommand(unknownLeagueId);

            when(leagueRepository.findById(unknownLeagueId)).thenReturn(Optional.empty());

            // Act & Assert
            DeleteLeagueUseCase.LeagueNotFoundException exception = assertThrows(
                    DeleteLeagueUseCase.LeagueNotFoundException.class,
                    () -> useCase.execute(command)
            );

            assertEquals(unknownLeagueId, exception.getLeagueId());
            assertTrue(exception.getMessage().contains(unknownLeagueId.toString()));
            verify(leagueRepository, never()).deleteById(any());
            verify(weekRepository, never()).deleteByLeagueId(any());
        }

        @ParameterizedTest
        @EnumSource(value = LeagueStatus.class, mode = EnumSource.Mode.EXCLUDE, names = {"DRAFT"})
        @DisplayName("should throw exception when league is not in DRAFT status")
        void shouldThrowExceptionWhenLeagueNotDraft(LeagueStatus status) {
            // Arrange
            League nonDraftLeague = new League();
            nonDraftLeague.setId(leagueId);
            nonDraftLeague.setName("Non-draft League");
            nonDraftLeague.setStatus(status);

            DeleteLeagueUseCase.DeleteLeagueCommand command =
                    new DeleteLeagueUseCase.DeleteLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(nonDraftLeague));

            // Act & Assert
            League.CannotDeleteLeagueException exception = assertThrows(
                    League.CannotDeleteLeagueException.class,
                    () -> useCase.execute(command)
            );

            assertEquals("CANNOT_DELETE_ACTIVE_LEAGUE", exception.getErrorCode());
            verify(leagueRepository, never()).deleteById(any());
            verify(weekRepository, never()).deleteByLeagueId(any());
        }

        @Test
        @DisplayName("should throw exception when league has players")
        void shouldThrowExceptionWhenLeagueHasPlayers() {
            // Arrange
            League leagueWithPlayers = new League();
            leagueWithPlayers.setId(leagueId);
            leagueWithPlayers.setName("League With Players");
            leagueWithPlayers.setStatus(LeagueStatus.DRAFT);

            Player player = Player.builder()
                    .id(1L)
                    .email("player@test.com")
                    .displayName("Test Player")
                    .build();
            leagueWithPlayers.getPlayers().add(player);

            DeleteLeagueUseCase.DeleteLeagueCommand command =
                    new DeleteLeagueUseCase.DeleteLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(leagueWithPlayers));

            // Act & Assert
            League.CannotDeleteLeagueException exception = assertThrows(
                    League.CannotDeleteLeagueException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("players"));
            verify(leagueRepository, never()).deleteById(any());
            verify(weekRepository, never()).deleteByLeagueId(any());
        }

        @Test
        @DisplayName("should delete weeks before deleting league")
        void shouldDeleteWeeksBeforeLeague() {
            // Arrange
            DeleteLeagueUseCase.DeleteLeagueCommand command =
                    new DeleteLeagueUseCase.DeleteLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(draftLeague));

            // Act
            useCase.execute(command);

            // Assert - verify order of operations
            var inOrder = inOrder(weekRepository, leagueRepository);
            inOrder.verify(weekRepository).deleteByLeagueId(leagueId);
            inOrder.verify(leagueRepository).deleteById(leagueId);
        }
    }
}
