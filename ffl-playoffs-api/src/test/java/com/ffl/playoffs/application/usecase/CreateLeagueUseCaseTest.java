package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.model.LeagueStatus;
import com.ffl.playoffs.domain.model.RosterConfiguration;
import com.ffl.playoffs.domain.model.ScoringRules;
import com.ffl.playoffs.domain.port.LeagueRepository;
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
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CreateLeagueUseCase Tests")
class CreateLeagueUseCaseTest {

    @Mock
    private LeagueRepository leagueRepository;

    private CreateLeagueUseCase useCase;

    @Captor
    private ArgumentCaptor<League> leagueCaptor;

    private UUID ownerId;
    private String leagueName;
    private String leagueCode;

    @BeforeEach
    void setUp() {
        useCase = new CreateLeagueUseCase(leagueRepository);

        ownerId = UUID.randomUUID();
        leagueName = "Test Fantasy League";
        leagueCode = "TEST123";
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should create league successfully with required fields")
        void shouldCreateLeagueSuccessfully() {
            // Arrange
            CreateLeagueUseCase.CreateLeagueCommand command =
                    new CreateLeagueUseCase.CreateLeagueCommand(
                            leagueName, leagueCode, ownerId, 15, 3);

            when(leagueRepository.existsByCode(leagueCode)).thenReturn(false);
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(leagueName, result.getName());
            assertEquals(leagueCode, result.getCode());
            assertEquals(ownerId, result.getOwnerId());
            assertEquals(15, result.getStartingWeek());
            assertEquals(3, result.getNumberOfWeeks());
            assertEquals(LeagueStatus.WAITING_FOR_PLAYERS, result.getStatus());

            verify(leagueRepository).save(leagueCaptor.capture());
            assertNotNull(leagueCaptor.getValue());
        }

        @Test
        @DisplayName("should throw exception when league code already exists")
        void shouldThrowExceptionWhenCodeExists() {
            // Arrange
            CreateLeagueUseCase.CreateLeagueCommand command =
                    new CreateLeagueUseCase.CreateLeagueCommand(
                            leagueName, leagueCode, ownerId, 15, 3);

            when(leagueRepository.existsByCode(leagueCode)).thenReturn(true);

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("already exists"));
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should use default roster configuration when not provided")
        void shouldUseDefaultRosterConfig() {
            // Arrange
            CreateLeagueUseCase.CreateLeagueCommand command =
                    new CreateLeagueUseCase.CreateLeagueCommand(
                            leagueName, leagueCode, ownerId, 15, 3);

            when(leagueRepository.existsByCode(leagueCode)).thenReturn(false);
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertNotNull(result.getRosterConfiguration());
        }

        @Test
        @DisplayName("should use custom roster configuration when provided")
        void shouldUseCustomRosterConfig() {
            // Arrange
            CreateLeagueUseCase.CreateLeagueCommand command =
                    new CreateLeagueUseCase.CreateLeagueCommand(
                            leagueName, leagueCode, ownerId, 15, 3);
            RosterConfiguration customConfig = RosterConfiguration.standardRoster();
            command.setRosterConfiguration(customConfig);

            when(leagueRepository.existsByCode(leagueCode)).thenReturn(false);
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertEquals(customConfig, result.getRosterConfiguration());
        }

        @Test
        @DisplayName("should use default scoring rules when not provided")
        void shouldUseDefaultScoringRules() {
            // Arrange
            CreateLeagueUseCase.CreateLeagueCommand command =
                    new CreateLeagueUseCase.CreateLeagueCommand(
                            leagueName, leagueCode, ownerId, 15, 3);

            when(leagueRepository.existsByCode(leagueCode)).thenReturn(false);
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertNotNull(result.getScoringRules());
        }

        @Test
        @DisplayName("should set description when provided")
        void shouldSetDescriptionWhenProvided() {
            // Arrange
            String description = "A test league description";
            CreateLeagueUseCase.CreateLeagueCommand command =
                    new CreateLeagueUseCase.CreateLeagueCommand(
                            leagueName, leagueCode, ownerId, 15, 3);
            command.setDescription(description);

            when(leagueRepository.existsByCode(leagueCode)).thenReturn(false);
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertEquals(description, result.getDescription());
        }

        @Test
        @DisplayName("should set first game start time when provided")
        void shouldSetFirstGameStartTime() {
            // Arrange
            LocalDateTime gameTime = LocalDateTime.now().plusDays(7);
            CreateLeagueUseCase.CreateLeagueCommand command =
                    new CreateLeagueUseCase.CreateLeagueCommand(
                            leagueName, leagueCode, ownerId, 15, 3);
            command.setFirstGameStartTime(gameTime);

            when(leagueRepository.existsByCode(leagueCode)).thenReturn(false);
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertEquals(gameTime, result.getFirstGameStartTime());
        }

        @Test
        @DisplayName("should set status to WAITING_FOR_PLAYERS")
        void shouldSetStatusToWaitingForPlayers() {
            // Arrange
            CreateLeagueUseCase.CreateLeagueCommand command =
                    new CreateLeagueUseCase.CreateLeagueCommand(
                            leagueName, leagueCode, ownerId, 15, 3);

            when(leagueRepository.existsByCode(leagueCode)).thenReturn(false);
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertEquals(LeagueStatus.WAITING_FOR_PLAYERS, result.getStatus());
        }
    }
}
