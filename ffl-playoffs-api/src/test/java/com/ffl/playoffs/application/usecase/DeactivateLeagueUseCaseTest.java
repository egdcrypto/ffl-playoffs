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
@DisplayName("DeactivateLeagueUseCase Tests")
class DeactivateLeagueUseCaseTest {

    @Mock
    private LeagueRepository leagueRepository;

    private DeactivateLeagueUseCase useCase;

    @Captor
    private ArgumentCaptor<League> leagueCaptor;

    private UUID leagueId;
    private League activeLeague;

    @BeforeEach
    void setUp() {
        useCase = new DeactivateLeagueUseCase(leagueRepository);

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
        @DisplayName("should deactivate active league successfully")
        void shouldDeactivateActiveLeagueSuccessfully() {
            // Arrange
            DeactivateLeagueUseCase.DeactivateLeagueCommand command =
                    new DeactivateLeagueUseCase.DeactivateLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(activeLeague));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(LeagueStatus.INACTIVE, result.getStatus());

            verify(leagueRepository).save(leagueCaptor.capture());
            assertEquals(LeagueStatus.INACTIVE, leagueCaptor.getValue().getStatus());
        }

        @Test
        @DisplayName("should throw LeagueNotFoundException when league not found")
        void shouldThrowLeagueNotFoundException() {
            // Arrange
            UUID unknownLeagueId = UUID.randomUUID();
            DeactivateLeagueUseCase.DeactivateLeagueCommand command =
                    new DeactivateLeagueUseCase.DeactivateLeagueCommand(unknownLeagueId);

            when(leagueRepository.findById(unknownLeagueId)).thenReturn(Optional.empty());

            // Act & Assert
            DeactivateLeagueUseCase.LeagueNotFoundException exception = assertThrows(
                    DeactivateLeagueUseCase.LeagueNotFoundException.class,
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

            DeactivateLeagueUseCase.DeactivateLeagueCommand command =
                    new DeactivateLeagueUseCase.DeactivateLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(nonActiveLeague));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("cannot be deactivated"));
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should save league after deactivating")
        void shouldSaveLeagueAfterDeactivating() {
            // Arrange
            DeactivateLeagueUseCase.DeactivateLeagueCommand command =
                    new DeactivateLeagueUseCase.DeactivateLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(activeLeague));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(leagueRepository, times(1)).save(any(League.class));
        }
    }
}
