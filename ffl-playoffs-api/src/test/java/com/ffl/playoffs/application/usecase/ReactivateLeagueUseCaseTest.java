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
@DisplayName("ReactivateLeagueUseCase Tests")
class ReactivateLeagueUseCaseTest {

    @Mock
    private LeagueRepository leagueRepository;

    private ReactivateLeagueUseCase useCase;

    @Captor
    private ArgumentCaptor<League> leagueCaptor;

    private UUID leagueId;
    private League inactiveLeague;

    @BeforeEach
    void setUp() {
        useCase = new ReactivateLeagueUseCase(leagueRepository);

        leagueId = UUID.randomUUID();

        inactiveLeague = new League();
        inactiveLeague.setId(leagueId);
        inactiveLeague.setName("Inactive League");
        inactiveLeague.setStatus(LeagueStatus.INACTIVE);
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should reactivate inactive league successfully")
        void shouldReactivateInactiveLeagueSuccessfully() {
            // Arrange
            ReactivateLeagueUseCase.ReactivateLeagueCommand command =
                    new ReactivateLeagueUseCase.ReactivateLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(inactiveLeague));
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
            ReactivateLeagueUseCase.ReactivateLeagueCommand command =
                    new ReactivateLeagueUseCase.ReactivateLeagueCommand(unknownLeagueId);

            when(leagueRepository.findById(unknownLeagueId)).thenReturn(Optional.empty());

            // Act & Assert
            ReactivateLeagueUseCase.LeagueNotFoundException exception = assertThrows(
                    ReactivateLeagueUseCase.LeagueNotFoundException.class,
                    () -> useCase.execute(command)
            );

            assertEquals(unknownLeagueId, exception.getLeagueId());
            assertTrue(exception.getMessage().contains(unknownLeagueId.toString()));
            verify(leagueRepository, never()).save(any());
        }

        @ParameterizedTest
        @EnumSource(value = LeagueStatus.class, mode = EnumSource.Mode.EXCLUDE, names = {"INACTIVE"})
        @DisplayName("should throw exception when league is not inactive")
        void shouldThrowExceptionWhenLeagueNotInactive(LeagueStatus status) {
            // Arrange
            League nonInactiveLeague = new League();
            nonInactiveLeague.setId(leagueId);
            nonInactiveLeague.setName("Non-inactive League");
            nonInactiveLeague.setStatus(status);

            ReactivateLeagueUseCase.ReactivateLeagueCommand command =
                    new ReactivateLeagueUseCase.ReactivateLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(nonInactiveLeague));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("reactivated"));
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should save league after reactivating")
        void shouldSaveLeagueAfterReactivating() {
            // Arrange
            ReactivateLeagueUseCase.ReactivateLeagueCommand command =
                    new ReactivateLeagueUseCase.ReactivateLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(inactiveLeague));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(leagueRepository, times(1)).save(any(League.class));
        }
    }
}
