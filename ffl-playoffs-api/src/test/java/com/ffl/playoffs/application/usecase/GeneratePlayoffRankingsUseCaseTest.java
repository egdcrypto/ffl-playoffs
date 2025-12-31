package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.PlayoffBracket;
import com.ffl.playoffs.domain.model.PlayoffRanking;
import com.ffl.playoffs.domain.model.PlayoffRound;
import com.ffl.playoffs.domain.port.PlayoffBracketRepository;
import com.ffl.playoffs.domain.port.PlayoffRankingRepository;
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
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("GeneratePlayoffRankingsUseCase Tests")
class GeneratePlayoffRankingsUseCaseTest {

    @Mock
    private PlayoffBracketRepository bracketRepository;

    @Mock
    private PlayoffRankingRepository rankingRepository;

    private GeneratePlayoffRankingsUseCase useCase;

    private UUID leagueId;
    private UUID playerId;

    @BeforeEach
    void setUp() {
        useCase = new GeneratePlayoffRankingsUseCase(bracketRepository, rankingRepository);
        leagueId = UUID.randomUUID();
        playerId = UUID.randomUUID();
    }

    private PlayoffBracket createBracketWithPlayers() {
        PlayoffBracket bracket = new PlayoffBracket(leagueId, "Test League");
        bracket.addPlayer(playerId, "Player 1", 1, BigDecimal.valueOf(100));
        bracket.addPlayer(UUID.randomUUID(), "Player 2", 2, BigDecimal.valueOf(90));
        return bracket;
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should generate rankings successfully")
        void shouldGenerateRankingsSuccessfully() {
            // Arrange
            PlayoffBracket bracket = createBracketWithPlayers();
            GeneratePlayoffRankingsUseCase.GenerateRankingsCommand command =
                    new GeneratePlayoffRankingsUseCase.GenerateRankingsCommand(
                            leagueId, PlayoffRound.WILD_CARD, false);

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.of(bracket));
            when(bracketRepository.save(any(PlayoffBracket.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            GeneratePlayoffRankingsUseCase.GenerateRankingsResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(leagueId, result.getLeagueId());
            assertEquals(PlayoffRound.WILD_CARD, result.getRound());
            assertFalse(result.isCumulative());
            verify(rankingRepository).saveAll(anyList());
            verify(bracketRepository).save(any(PlayoffBracket.class));
        }

        @Test
        @DisplayName("should generate cumulative rankings")
        void shouldGenerateCumulativeRankings() {
            // Arrange
            PlayoffBracket bracket = createBracketWithPlayers();
            GeneratePlayoffRankingsUseCase.GenerateRankingsCommand command =
                    new GeneratePlayoffRankingsUseCase.GenerateRankingsCommand(
                            leagueId, PlayoffRound.DIVISIONAL, true);

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.of(bracket));
            when(bracketRepository.save(any(PlayoffBracket.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            GeneratePlayoffRankingsUseCase.GenerateRankingsResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertTrue(result.isCumulative());
            assertEquals(PlayoffRound.DIVISIONAL, result.getRound());
        }

        @Test
        @DisplayName("should throw exception when bracket not found")
        void shouldThrowExceptionWhenBracketNotFound() {
            // Arrange
            GeneratePlayoffRankingsUseCase.GenerateRankingsCommand command =
                    new GeneratePlayoffRankingsUseCase.GenerateRankingsCommand(
                            leagueId, PlayoffRound.WILD_CARD, false);

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Playoff bracket not found"));
            verify(rankingRepository, never()).saveAll(anyList());
        }

        @Test
        @DisplayName("should save rankings to repository")
        void shouldSaveRankingsToRepository() {
            // Arrange
            PlayoffBracket bracket = createBracketWithPlayers();
            GeneratePlayoffRankingsUseCase.GenerateRankingsCommand command =
                    new GeneratePlayoffRankingsUseCase.GenerateRankingsCommand(
                            leagueId, PlayoffRound.WILD_CARD, false);

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.of(bracket));
            when(bracketRepository.save(any(PlayoffBracket.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(rankingRepository, times(1)).saveAll(anyList());
        }
    }

    @Nested
    @DisplayName("getCurrentRankings")
    class GetCurrentRankings {

        @Test
        @DisplayName("should return current rankings from repository")
        void shouldReturnCurrentRankingsFromRepository() {
            // Arrange
            List<PlayoffRanking> expectedRankings = List.of(
                    PlayoffRanking.builder()
                            .leaguePlayerId(playerId)
                            .rank(1)
                            .score(BigDecimal.valueOf(150))
                            .build()
            );

            GeneratePlayoffRankingsUseCase.GenerateRankingsCommand command =
                    new GeneratePlayoffRankingsUseCase.GenerateRankingsCommand(
                            leagueId, PlayoffRound.WILD_CARD, false);

            when(rankingRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.WILD_CARD, false))
                    .thenReturn(expectedRankings);

            // Act
            List<PlayoffRanking> result = useCase.getCurrentRankings(command);

            // Assert
            assertNotNull(result);
            assertEquals(1, result.size());
            assertEquals(playerId, result.get(0).getLeaguePlayerId());
        }

        @Test
        @DisplayName("should return empty list when no rankings exist")
        void shouldReturnEmptyListWhenNoRankingsExist() {
            // Arrange
            GeneratePlayoffRankingsUseCase.GenerateRankingsCommand command =
                    new GeneratePlayoffRankingsUseCase.GenerateRankingsCommand(
                            leagueId, PlayoffRound.WILD_CARD, false);

            when(rankingRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.WILD_CARD, false))
                    .thenReturn(new ArrayList<>());

            // Act
            List<PlayoffRanking> result = useCase.getCurrentRankings(command);

            // Assert
            assertNotNull(result);
            assertTrue(result.isEmpty());
        }
    }

    @Nested
    @DisplayName("getPlayerRankingHistory")
    class GetPlayerRankingHistory {

        @Test
        @DisplayName("should return ranking history for player")
        void shouldReturnRankingHistoryForPlayer() {
            // Arrange
            List<PlayoffRanking> expectedHistory = List.of(
                    PlayoffRanking.builder()
                            .leaguePlayerId(playerId)
                            .round(PlayoffRound.WILD_CARD)
                            .rank(1)
                            .build(),
                    PlayoffRanking.builder()
                            .leaguePlayerId(playerId)
                            .round(PlayoffRound.DIVISIONAL)
                            .rank(2)
                            .build()
            );

            when(rankingRepository.findByPlayerId(playerId)).thenReturn(expectedHistory);

            // Act
            List<PlayoffRanking> result = useCase.getPlayerRankingHistory(playerId);

            // Assert
            assertNotNull(result);
            assertEquals(2, result.size());
        }

        @Test
        @DisplayName("should return empty list for player with no history")
        void shouldReturnEmptyListForPlayerWithNoHistory() {
            // Arrange
            UUID unknownPlayerId = UUID.randomUUID();
            when(rankingRepository.findByPlayerId(unknownPlayerId)).thenReturn(new ArrayList<>());

            // Act
            List<PlayoffRanking> result = useCase.getPlayerRankingHistory(unknownPlayerId);

            // Assert
            assertNotNull(result);
            assertTrue(result.isEmpty());
        }
    }

    @Nested
    @DisplayName("GenerateRankingsCommand")
    class GenerateRankingsCommandTests {

        @Test
        @DisplayName("should create command with all fields")
        void shouldCreateCommandWithAllFields() {
            // Arrange & Act
            GeneratePlayoffRankingsUseCase.GenerateRankingsCommand command =
                    new GeneratePlayoffRankingsUseCase.GenerateRankingsCommand(
                            leagueId, PlayoffRound.SUPER_BOWL, true);

            // Assert
            assertEquals(leagueId, command.getLeagueId());
            assertEquals(PlayoffRound.SUPER_BOWL, command.getRound());
            assertTrue(command.isCumulative());
        }
    }

    @Nested
    @DisplayName("GenerateRankingsResult")
    class GenerateRankingsResultTests {

        @Test
        @DisplayName("should create result with all fields")
        void shouldCreateResultWithAllFields() {
            // Arrange
            List<PlayoffRanking> rankings = List.of(
                    PlayoffRanking.builder().leaguePlayerId(playerId).rank(1).build()
            );

            // Act
            GeneratePlayoffRankingsUseCase.GenerateRankingsResult result =
                    new GeneratePlayoffRankingsUseCase.GenerateRankingsResult(
                            leagueId, PlayoffRound.DIVISIONAL, true, rankings);

            // Assert
            assertEquals(leagueId, result.getLeagueId());
            assertEquals(PlayoffRound.DIVISIONAL, result.getRound());
            assertTrue(result.isCumulative());
            assertEquals(1, result.getRankings().size());
        }

        @Test
        @DisplayName("should handle empty rankings list")
        void shouldHandleEmptyRankingsList() {
            // Arrange & Act
            GeneratePlayoffRankingsUseCase.GenerateRankingsResult result =
                    new GeneratePlayoffRankingsUseCase.GenerateRankingsResult(
                            leagueId, PlayoffRound.WILD_CARD, false, new ArrayList<>());

            // Assert
            assertTrue(result.getRankings().isEmpty());
        }
    }
}
