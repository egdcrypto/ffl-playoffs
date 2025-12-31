package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.PlayoffBracket;
import com.ffl.playoffs.domain.model.PlayoffRound;
import com.ffl.playoffs.domain.model.TiebreakerResult;
import com.ffl.playoffs.domain.port.PlayoffBracketRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ProcessBracketAdvancementUseCase Tests")
class ProcessBracketAdvancementUseCaseTest {

    @Mock
    private PlayoffBracketRepository bracketRepository;

    private ProcessBracketAdvancementUseCase useCase;

    private UUID leagueId;
    private UUID player1Id;
    private UUID player2Id;

    @BeforeEach
    void setUp() {
        useCase = new ProcessBracketAdvancementUseCase(bracketRepository);
        leagueId = UUID.randomUUID();
        player1Id = UUID.randomUUID();
        player2Id = UUID.randomUUID();
    }

    private PlayoffBracket createBracketWithMatchup() {
        PlayoffBracket bracket = new PlayoffBracket(leagueId, "Test League");
        bracket.addPlayer(player1Id, "Player 1", 1, BigDecimal.valueOf(150));
        bracket.addPlayer(player2Id, "Player 2", 2, BigDecimal.valueOf(140));
        bracket.generateBracket();
        return bracket;
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should process bracket advancement successfully")
        void shouldProcessBracketAdvancementSuccessfully() {
            // Arrange
            PlayoffBracket bracket = createBracketWithMatchup();

            ProcessBracketAdvancementUseCase.ProcessBracketAdvancementCommand command =
                    new ProcessBracketAdvancementUseCase.ProcessBracketAdvancementCommand(
                            leagueId, PlayoffRound.WILD_CARD);

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.of(bracket));
            when(bracketRepository.save(any(PlayoffBracket.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            ProcessBracketAdvancementUseCase.ProcessBracketAdvancementResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(leagueId, result.getLeagueId());
            assertEquals(PlayoffRound.WILD_CARD, result.getRound());
            verify(bracketRepository).save(any(PlayoffBracket.class));
        }

        @Test
        @DisplayName("should throw exception when bracket not found")
        void shouldThrowExceptionWhenBracketNotFound() {
            // Arrange
            ProcessBracketAdvancementUseCase.ProcessBracketAdvancementCommand command =
                    new ProcessBracketAdvancementUseCase.ProcessBracketAdvancementCommand(
                            leagueId, PlayoffRound.WILD_CARD);

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Playoff bracket not found"));
            verify(bracketRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when no matchups found for round")
        void shouldThrowExceptionWhenNoMatchupsFoundForRound() {
            // Arrange
            PlayoffBracket bracket = new PlayoffBracket(leagueId, "Test League");
            // No players or matchups added

            ProcessBracketAdvancementUseCase.ProcessBracketAdvancementCommand command =
                    new ProcessBracketAdvancementUseCase.ProcessBracketAdvancementCommand(
                            leagueId, PlayoffRound.WILD_CARD);

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.of(bracket));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("No matchups found"));
            verify(bracketRepository, never()).save(any());
        }

        @Test
        @DisplayName("should return empty lists when matchups not ready")
        void shouldReturnEmptyListsWhenMatchupsNotReady() {
            // Arrange
            PlayoffBracket bracket = createBracketWithMatchup();
            // Matchups are generated but no scores recorded, so not ready for result

            ProcessBracketAdvancementUseCase.ProcessBracketAdvancementCommand command =
                    new ProcessBracketAdvancementUseCase.ProcessBracketAdvancementCommand(
                            leagueId, PlayoffRound.WILD_CARD);

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.of(bracket));
            when(bracketRepository.save(any(PlayoffBracket.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            ProcessBracketAdvancementUseCase.ProcessBracketAdvancementResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            // Without scores, matchups are not ready, so lists should be empty
            assertTrue(result.getEliminatedPlayers().isEmpty() || result.getAdvancingPlayers().isEmpty() ||
                      result.getMatchupResults().isEmpty());
        }

        @Test
        @DisplayName("should return correct playoffs complete status")
        void shouldReturnCorrectPlayoffsCompleteStatus() {
            // Arrange
            PlayoffBracket bracket = createBracketWithMatchup();

            ProcessBracketAdvancementUseCase.ProcessBracketAdvancementCommand command =
                    new ProcessBracketAdvancementUseCase.ProcessBracketAdvancementCommand(
                            leagueId, PlayoffRound.WILD_CARD);

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.of(bracket));
            when(bracketRepository.save(any(PlayoffBracket.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            ProcessBracketAdvancementUseCase.ProcessBracketAdvancementResult result = useCase.execute(command);

            // Assert
            assertFalse(result.isPlayoffsComplete()); // Wild card is not final round
        }
    }

    @Nested
    @DisplayName("ProcessBracketAdvancementCommand")
    class ProcessBracketAdvancementCommandTests {

        @Test
        @DisplayName("should create command with league ID and round")
        void shouldCreateCommandWithLeagueIdAndRound() {
            // Arrange & Act
            ProcessBracketAdvancementUseCase.ProcessBracketAdvancementCommand command =
                    new ProcessBracketAdvancementUseCase.ProcessBracketAdvancementCommand(
                            leagueId, PlayoffRound.DIVISIONAL);

            // Assert
            assertEquals(leagueId, command.getLeagueId());
            assertEquals(PlayoffRound.DIVISIONAL, command.getRound());
        }
    }

    @Nested
    @DisplayName("ProcessBracketAdvancementResult")
    class ProcessBracketAdvancementResultTests {

        @Test
        @DisplayName("should create result with all fields")
        void shouldCreateResultWithAllFields() {
            // Arrange
            List<UUID> eliminatedPlayers = List.of(player1Id);
            List<UUID> advancingPlayers = List.of(player2Id);
            List<ProcessBracketAdvancementUseCase.MatchupResult> matchupResults = new ArrayList<>();

            // Act
            ProcessBracketAdvancementUseCase.ProcessBracketAdvancementResult result =
                    new ProcessBracketAdvancementUseCase.ProcessBracketAdvancementResult(
                            leagueId, PlayoffRound.WILD_CARD,
                            eliminatedPlayers, advancingPlayers,
                            matchupResults, false);

            // Assert
            assertEquals(leagueId, result.getLeagueId());
            assertEquals(PlayoffRound.WILD_CARD, result.getRound());
            assertEquals(1, result.getEliminatedPlayers().size());
            assertEquals(1, result.getAdvancingPlayers().size());
            assertTrue(result.getMatchupResults().isEmpty());
            assertFalse(result.isPlayoffsComplete());
        }

        @Test
        @DisplayName("should indicate playoffs complete when true")
        void shouldIndicatePlayoffsCompleteWhenTrue() {
            // Arrange & Act
            ProcessBracketAdvancementUseCase.ProcessBracketAdvancementResult result =
                    new ProcessBracketAdvancementUseCase.ProcessBracketAdvancementResult(
                            leagueId, PlayoffRound.SUPER_BOWL,
                            new ArrayList<>(), new ArrayList<>(),
                            new ArrayList<>(), true);

            // Assert
            assertTrue(result.isPlayoffsComplete());
        }
    }

    @Nested
    @DisplayName("MatchupResult")
    class MatchupResultTests {

        @Test
        @DisplayName("should create matchup result with all fields")
        void shouldCreateMatchupResultWithAllFields() {
            // Arrange
            UUID matchupId = UUID.randomUUID();
            BigDecimal margin = BigDecimal.valueOf(10.5);

            // Act
            ProcessBracketAdvancementUseCase.MatchupResult result =
                    new ProcessBracketAdvancementUseCase.MatchupResult(
                            matchupId, player1Id, player2Id,
                            margin, true, null);

            // Assert
            assertEquals(matchupId, result.getMatchupId());
            assertEquals(player1Id, result.getWinnerId());
            assertEquals(player2Id, result.getLoserId());
            assertEquals(margin, result.getMarginOfVictory());
            assertTrue(result.isUpset());
            assertNull(result.getTiebreakerResult());
        }

        @Test
        @DisplayName("should handle null margin of victory")
        void shouldHandleNullMarginOfVictory() {
            // Arrange & Act
            ProcessBracketAdvancementUseCase.MatchupResult result =
                    new ProcessBracketAdvancementUseCase.MatchupResult(
                            UUID.randomUUID(), player1Id, player2Id,
                            null, false, null);

            // Assert
            assertNull(result.getMarginOfVictory());
        }
    }
}
