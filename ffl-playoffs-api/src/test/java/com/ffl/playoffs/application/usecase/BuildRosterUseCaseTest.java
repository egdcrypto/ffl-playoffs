package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.model.RosterConfiguration;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.RosterRepository;
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
@DisplayName("BuildRosterUseCase Tests")
class BuildRosterUseCaseTest {

    @Mock
    private LeagueRepository leagueRepository;

    @Mock
    private RosterRepository rosterRepository;

    private BuildRosterUseCase useCase;

    @Captor
    private ArgumentCaptor<Roster> rosterCaptor;

    private UUID leagueId;
    private UUID leaguePlayerId;
    private League league;
    private RosterConfiguration rosterConfig;

    @BeforeEach
    void setUp() {
        useCase = new BuildRosterUseCase(leagueRepository, rosterRepository);

        leagueId = UUID.randomUUID();
        leaguePlayerId = UUID.randomUUID();

        rosterConfig = RosterConfiguration.standardRoster();

        league = new League();
        league.setId(leagueId);
        league.setName("Test League");
        league.setRosterConfiguration(rosterConfig);
        league.setFirstGameStartTime(LocalDateTime.now().plusDays(7));
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should build roster successfully with valid league and player")
        void shouldBuildRosterSuccessfully() {
            // Arrange
            BuildRosterUseCase.BuildRosterCommand command =
                    new BuildRosterUseCase.BuildRosterCommand(leagueId, leaguePlayerId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(rosterRepository.findByLeaguePlayerId(leaguePlayerId)).thenReturn(Optional.empty());
            when(rosterRepository.save(any(Roster.class))).thenAnswer(invocation -> invocation.getArgument(0));

            // Act
            Roster result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(leaguePlayerId, result.getLeaguePlayerId());
            assertEquals(leagueId, result.getGameId());

            verify(rosterRepository).save(rosterCaptor.capture());
            Roster savedRoster = rosterCaptor.getValue();
            assertNotNull(savedRoster.getSlots());
            assertFalse(savedRoster.getSlots().isEmpty());
        }

        @Test
        @DisplayName("should throw exception when league not found")
        void shouldThrowExceptionWhenLeagueNotFound() {
            // Arrange
            BuildRosterUseCase.BuildRosterCommand command =
                    new BuildRosterUseCase.BuildRosterCommand(leagueId, leaguePlayerId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertEquals("League not found", exception.getMessage());
            verify(rosterRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when league has no roster configuration")
        void shouldThrowExceptionWhenNoRosterConfiguration() {
            // Arrange
            League leagueWithoutConfig = new League();
            leagueWithoutConfig.setId(leagueId);
            leagueWithoutConfig.setName("League Without Config");
            leagueWithoutConfig.setRosterConfiguration(null);

            BuildRosterUseCase.BuildRosterCommand command =
                    new BuildRosterUseCase.BuildRosterCommand(leagueId, leaguePlayerId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(leagueWithoutConfig));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertEquals("League has no roster configuration defined", exception.getMessage());
            verify(rosterRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when roster already exists for player")
        void shouldThrowExceptionWhenRosterAlreadyExists() {
            // Arrange
            Roster existingRoster = new Roster(leaguePlayerId, leagueId, rosterConfig);

            BuildRosterUseCase.BuildRosterCommand command =
                    new BuildRosterUseCase.BuildRosterCommand(leagueId, leaguePlayerId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(rosterRepository.findByLeaguePlayerId(leaguePlayerId)).thenReturn(Optional.of(existingRoster));

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertEquals("Roster already exists for this player in this league", exception.getMessage());
            verify(rosterRepository, never()).save(any());
        }

        @Test
        @DisplayName("should set roster deadline from command when provided")
        void shouldSetRosterDeadlineFromCommand() {
            // Arrange
            LocalDateTime customDeadline = LocalDateTime.now().plusDays(3);
            BuildRosterUseCase.BuildRosterCommand command =
                    new BuildRosterUseCase.BuildRosterCommand(leagueId, leaguePlayerId);
            command.setRosterDeadline(customDeadline);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(rosterRepository.findByLeaguePlayerId(leaguePlayerId)).thenReturn(Optional.empty());
            when(rosterRepository.save(any(Roster.class))).thenAnswer(invocation -> invocation.getArgument(0));

            // Act
            Roster result = useCase.execute(command);

            // Assert
            verify(rosterRepository).save(rosterCaptor.capture());
            Roster savedRoster = rosterCaptor.getValue();
            assertEquals(customDeadline, savedRoster.getRosterDeadline());
        }

        @Test
        @DisplayName("should default roster deadline to league first game start time")
        void shouldDefaultDeadlineToFirstGameStartTime() {
            // Arrange
            LocalDateTime firstGameTime = LocalDateTime.now().plusDays(7);
            League leagueWithGameTime = new League();
            leagueWithGameTime.setId(leagueId);
            leagueWithGameTime.setName("Test League");
            leagueWithGameTime.setRosterConfiguration(rosterConfig);
            leagueWithGameTime.setFirstGameStartTime(firstGameTime);

            BuildRosterUseCase.BuildRosterCommand command =
                    new BuildRosterUseCase.BuildRosterCommand(leagueId, leaguePlayerId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(leagueWithGameTime));
            when(rosterRepository.findByLeaguePlayerId(leaguePlayerId)).thenReturn(Optional.empty());
            when(rosterRepository.save(any(Roster.class))).thenAnswer(invocation -> invocation.getArgument(0));

            // Act
            Roster result = useCase.execute(command);

            // Assert
            verify(rosterRepository).save(rosterCaptor.capture());
            Roster savedRoster = rosterCaptor.getValue();
            assertEquals(firstGameTime, savedRoster.getRosterDeadline());
        }

        @Test
        @DisplayName("should create roster with slots from configuration")
        void shouldCreateRosterWithSlotsFromConfiguration() {
            // Arrange
            BuildRosterUseCase.BuildRosterCommand command =
                    new BuildRosterUseCase.BuildRosterCommand(leagueId, leaguePlayerId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(rosterRepository.findByLeaguePlayerId(leaguePlayerId)).thenReturn(Optional.empty());
            when(rosterRepository.save(any(Roster.class))).thenAnswer(invocation -> invocation.getArgument(0));

            // Act
            Roster result = useCase.execute(command);

            // Assert
            assertNotNull(result.getSlots());
            assertTrue(result.getSlots().size() > 0);
        }
    }
}
