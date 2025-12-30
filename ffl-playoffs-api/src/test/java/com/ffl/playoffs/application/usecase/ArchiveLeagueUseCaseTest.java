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
@DisplayName("ArchiveLeagueUseCase Tests")
class ArchiveLeagueUseCaseTest {

    @Mock
    private LeagueRepository leagueRepository;

    private ArchiveLeagueUseCase useCase;

    @Captor
    private ArgumentCaptor<League> leagueCaptor;

    private UUID leagueId;
    private League completedLeague;

    @BeforeEach
    void setUp() {
        useCase = new ArchiveLeagueUseCase(leagueRepository);

        leagueId = UUID.randomUUID();

        completedLeague = new League();
        completedLeague.setId(leagueId);
        completedLeague.setName("Completed League");
        completedLeague.setStatus(LeagueStatus.COMPLETED);
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should archive completed league successfully")
        void shouldArchiveCompletedLeagueSuccessfully() {
            // Arrange
            ArchiveLeagueUseCase.ArchiveLeagueCommand command =
                    new ArchiveLeagueUseCase.ArchiveLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(completedLeague));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(LeagueStatus.ARCHIVED, result.getStatus());
            assertNotNull(result.getArchivedAt());

            verify(leagueRepository).save(leagueCaptor.capture());
            assertEquals(LeagueStatus.ARCHIVED, leagueCaptor.getValue().getStatus());
        }

        @Test
        @DisplayName("should throw LeagueNotFoundException when league not found")
        void shouldThrowLeagueNotFoundException() {
            // Arrange
            UUID unknownLeagueId = UUID.randomUUID();
            ArchiveLeagueUseCase.ArchiveLeagueCommand command =
                    new ArchiveLeagueUseCase.ArchiveLeagueCommand(unknownLeagueId);

            when(leagueRepository.findById(unknownLeagueId)).thenReturn(Optional.empty());

            // Act & Assert
            ArchiveLeagueUseCase.LeagueNotFoundException exception = assertThrows(
                    ArchiveLeagueUseCase.LeagueNotFoundException.class,
                    () -> useCase.execute(command)
            );

            assertEquals(unknownLeagueId, exception.getLeagueId());
            assertTrue(exception.getMessage().contains(unknownLeagueId.toString()));
            verify(leagueRepository, never()).save(any());
        }

        @ParameterizedTest
        @EnumSource(value = LeagueStatus.class, mode = EnumSource.Mode.EXCLUDE, names = {"COMPLETED"})
        @DisplayName("should throw exception when league status cannot be archived")
        void shouldThrowExceptionWhenLeagueCannotBeArchived(LeagueStatus status) {
            // Arrange
            League nonArchivableLeague = new League();
            nonArchivableLeague.setId(leagueId);
            nonArchivableLeague.setName("Non-archivable League");
            nonArchivableLeague.setStatus(status);

            ArchiveLeagueUseCase.ArchiveLeagueCommand command =
                    new ArchiveLeagueUseCase.ArchiveLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(nonArchivableLeague));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("cannot be archived"));
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should set archivedAt timestamp when archiving")
        void shouldSetArchivedAtTimestamp() {
            // Arrange
            ArchiveLeagueUseCase.ArchiveLeagueCommand command =
                    new ArchiveLeagueUseCase.ArchiveLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(completedLeague));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertNotNull(result.getArchivedAt());
        }

        @Test
        @DisplayName("should save league after archiving")
        void shouldSaveLeagueAfterArchiving() {
            // Arrange
            ArchiveLeagueUseCase.ArchiveLeagueCommand command =
                    new ArchiveLeagueUseCase.ArchiveLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(completedLeague));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(leagueRepository, times(1)).save(any(League.class));
        }
    }
}
