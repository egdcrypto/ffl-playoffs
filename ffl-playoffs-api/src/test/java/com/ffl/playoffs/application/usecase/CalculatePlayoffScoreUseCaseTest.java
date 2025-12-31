package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.PlayoffBracket;
import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.model.PlayoffRound;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.RosterScore;
import com.ffl.playoffs.domain.model.RosterSlot;
import com.ffl.playoffs.domain.port.NflDataProvider;
import com.ffl.playoffs.domain.port.PlayoffBracketRepository;
import com.ffl.playoffs.domain.port.PlayoffScoreRepository;
import com.ffl.playoffs.domain.port.RosterRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.*;

import org.mockito.Mockito;

@ExtendWith(MockitoExtension.class)
@DisplayName("CalculatePlayoffScoreUseCase Tests")
class CalculatePlayoffScoreUseCaseTest {

    @Mock
    private PlayoffBracketRepository bracketRepository;

    @Mock
    private RosterRepository rosterRepository;

    @Mock
    private PlayoffScoreRepository scoreRepository;

    @Mock
    private NflDataProvider nflDataProvider;

    private CalculatePlayoffScoreUseCase useCase;

    private UUID leagueId;
    private UUID leaguePlayerId;
    private UUID rosterId;

    @BeforeEach
    void setUp() {
        useCase = new CalculatePlayoffScoreUseCase(
                bracketRepository,
                rosterRepository,
                scoreRepository,
                nflDataProvider
        );

        leagueId = UUID.randomUUID();
        leaguePlayerId = UUID.randomUUID();
        rosterId = UUID.randomUUID();
    }

    private PlayoffBracket createBracketWithPlayer(boolean eliminated) {
        PlayoffBracket bracket = new PlayoffBracket(leagueId, "Test League");
        bracket.addPlayer(leaguePlayerId, "Test Player", 1, BigDecimal.valueOf(100));
        if (eliminated) {
            // Mark player as eliminated by simulating elimination
            PlayoffBracket.PlayerBracketEntry entry = bracket.getPlayerEntries().get(leaguePlayerId);
            entry.eliminate(PlayoffRound.WILD_CARD, UUID.randomUUID());
        }
        return bracket;
    }

    private Roster createLockedRoster() {
        Roster roster = new Roster();
        roster.setLeaguePlayerId(leaguePlayerId);
        roster.setLocked(true);

        // Add a slot with a player
        RosterSlot slot = new RosterSlot(roster.getId(), Position.QB, 1);
        slot.assignPlayer(12345L, Position.QB);
        roster.getSlots().add(slot);

        return roster;
    }

    private Roster createUnlockedRoster() {
        Roster roster = new Roster();
        roster.setLeaguePlayerId(leaguePlayerId);
        roster.setLocked(false);
        return roster;
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should calculate score for valid roster")
        void shouldCalculateScoreForValidRoster() {
            // Arrange
            PlayoffBracket bracket = createBracketWithPlayer(false);
            Roster roster = createLockedRoster();

            CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand command =
                    new CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand(
                            leagueId, leaguePlayerId, PlayoffRound.WILD_CARD, 15);

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.of(bracket));
            when(rosterRepository.findByLeaguePlayerId(leaguePlayerId)).thenReturn(Optional.of(roster));
            lenient().when(nflDataProvider.getPlayerStats(anyLong(), anyInt())).thenReturn(createPlayerStats());
            when(bracketRepository.save(any(PlayoffBracket.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            RosterScore result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(leaguePlayerId, result.getLeaguePlayerId());
            assertEquals(PlayoffRound.WILD_CARD, result.getRound());
            verify(scoreRepository).save(any(RosterScore.class));
            verify(bracketRepository).save(any(PlayoffBracket.class));
        }

        @Test
        @DisplayName("should throw exception when bracket not found")
        void shouldThrowExceptionWhenBracketNotFound() {
            // Arrange
            CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand command =
                    new CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand(
                            leagueId, leaguePlayerId, PlayoffRound.WILD_CARD, 15);

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Playoff bracket not found"));
            verify(rosterRepository, never()).findByLeaguePlayerId(any());
        }

        @Test
        @DisplayName("should throw exception when player is eliminated")
        void shouldThrowExceptionWhenPlayerIsEliminated() {
            // Arrange
            PlayoffBracket bracket = createBracketWithPlayer(true);

            CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand command =
                    new CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand(
                            leagueId, leaguePlayerId, PlayoffRound.WILD_CARD, 15);

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.of(bracket));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("eliminated"));
            verify(rosterRepository, never()).findByLeaguePlayerId(any());
        }

        @Test
        @DisplayName("should throw exception when roster not found")
        void shouldThrowExceptionWhenRosterNotFound() {
            // Arrange
            PlayoffBracket bracket = createBracketWithPlayer(false);

            CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand command =
                    new CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand(
                            leagueId, leaguePlayerId, PlayoffRound.WILD_CARD, 15);

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.of(bracket));
            when(rosterRepository.findByLeaguePlayerId(leaguePlayerId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Roster not found"));
        }

        @Test
        @DisplayName("should throw exception when roster not locked")
        void shouldThrowExceptionWhenRosterNotLocked() {
            // Arrange
            PlayoffBracket bracket = createBracketWithPlayer(false);
            Roster roster = createUnlockedRoster();

            CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand command =
                    new CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand(
                            leagueId, leaguePlayerId, PlayoffRound.WILD_CARD, 15);

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.of(bracket));
            when(rosterRepository.findByLeaguePlayerId(leaguePlayerId)).thenReturn(Optional.of(roster));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("locked"));
        }

        @Test
        @DisplayName("should handle empty slot")
        void shouldHandleEmptySlot() {
            // Arrange
            PlayoffBracket bracket = createBracketWithPlayer(false);
            Roster roster = new Roster();
            roster.setLeaguePlayerId(leaguePlayerId);
            roster.setLocked(true);
            // Add empty slot
            RosterSlot emptySlot = new RosterSlot(roster.getId(), Position.QB, 1);
            roster.getSlots().add(emptySlot);

            CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand command =
                    new CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand(
                            leagueId, leaguePlayerId, PlayoffRound.WILD_CARD, 15);

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.of(bracket));
            when(rosterRepository.findByLeaguePlayerId(leaguePlayerId)).thenReturn(Optional.of(roster));
            when(bracketRepository.save(any(PlayoffBracket.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            RosterScore result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            // No calls to NflDataProvider for empty slots
            verify(nflDataProvider, never()).getPlayerStats(anyLong(), anyInt());
        }

        @Test
        @DisplayName("should use default scoring config when not provided")
        void shouldUseDefaultScoringConfigWhenNotProvided() {
            // Arrange
            PlayoffBracket bracket = createBracketWithPlayer(false);
            Roster roster = createLockedRoster();

            CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand command =
                    new CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand(
                            leagueId, leaguePlayerId, PlayoffRound.WILD_CARD, 15);

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.of(bracket));
            when(rosterRepository.findByLeaguePlayerId(leaguePlayerId)).thenReturn(Optional.of(roster));
            lenient().when(nflDataProvider.getPlayerStats(anyLong(), anyInt())).thenReturn(createPlayerStats());
            when(bracketRepository.save(any(PlayoffBracket.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            RosterScore result = useCase.execute(command);

            // Assert
            assertNotNull(result);
        }

        @Test
        @DisplayName("should handle null player stats from provider")
        void shouldHandleNullPlayerStatsFromProvider() {
            // Arrange
            PlayoffBracket bracket = createBracketWithPlayer(false);
            Roster roster = createLockedRoster();

            CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand command =
                    new CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand(
                            leagueId, leaguePlayerId, PlayoffRound.WILD_CARD, 15);

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.of(bracket));
            when(rosterRepository.findByLeaguePlayerId(leaguePlayerId)).thenReturn(Optional.of(roster));
            lenient().when(nflDataProvider.getPlayerStats(anyLong(), anyInt())).thenReturn(null);
            when(bracketRepository.save(any(PlayoffBracket.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            RosterScore result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            verify(scoreRepository).save(any(RosterScore.class));
        }

        @Test
        @DisplayName("should handle player on bye week")
        void shouldHandlePlayerOnByeWeek() {
            // Arrange
            PlayoffBracket bracket = createBracketWithPlayer(false);
            Roster roster = createLockedRoster();

            Map<String, Object> byeStats = new HashMap<>();
            byeStats.put("onBye", true);
            byeStats.put("playerName", "Test Player");
            byeStats.put("team", "KC");

            CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand command =
                    new CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand(
                            leagueId, leaguePlayerId, PlayoffRound.WILD_CARD, 15);

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.of(bracket));
            when(rosterRepository.findByLeaguePlayerId(leaguePlayerId)).thenReturn(Optional.of(roster));
            lenient().when(nflDataProvider.getPlayerStats(anyLong(), anyInt())).thenReturn(byeStats);
            when(bracketRepository.save(any(PlayoffBracket.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            RosterScore result = useCase.execute(command);

            // Assert
            assertNotNull(result);
        }
    }

    @Nested
    @DisplayName("CalculatePlayoffScoreCommand")
    class CalculatePlayoffScoreCommandTests {

        @Test
        @DisplayName("should create command with all fields")
        void shouldCreateCommandWithAllFields() {
            // Arrange & Act
            CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand command =
                    new CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand(
                            leagueId, leaguePlayerId, PlayoffRound.DIVISIONAL, 16);

            // Assert
            assertEquals(leagueId, command.getLeagueId());
            assertEquals(leaguePlayerId, command.getLeaguePlayerId());
            assertEquals(PlayoffRound.DIVISIONAL, command.getRound());
            assertEquals(16, command.getNflWeek());
            assertNull(command.getScoringConfig());
        }

        @Test
        @DisplayName("should create command with scoring config")
        void shouldCreateCommandWithScoringConfig() {
            // Arrange & Act
            CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand command =
                    new CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand(
                            leagueId, leaguePlayerId, PlayoffRound.CONFERENCE, 17, null);

            // Assert
            assertEquals(leagueId, command.getLeagueId());
            assertEquals(leaguePlayerId, command.getLeaguePlayerId());
            assertEquals(PlayoffRound.CONFERENCE, command.getRound());
            assertEquals(17, command.getNflWeek());
        }
    }

    private Map<String, Object> createPlayerStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("playerName", "Patrick Mahomes");
        stats.put("team", "KC");
        stats.put("passingYards", 300);
        stats.put("passingTouchdowns", 3);
        stats.put("interceptions", 1);
        return stats;
    }
}
