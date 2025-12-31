package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.PlayoffBracket;
import com.ffl.playoffs.domain.aggregate.PlayoffMatchup;
import com.ffl.playoffs.domain.model.PlayoffRound;
import com.ffl.playoffs.domain.port.PlayoffBracketRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("GetMatchupDetailsUseCase Tests")
class GetMatchupDetailsUseCaseTest {

    @Mock
    private PlayoffBracketRepository bracketRepository;

    private GetMatchupDetailsUseCase useCase;

    private UUID leagueId;
    private UUID player1Id;
    private UUID player2Id;
    private UUID matchupId;

    @BeforeEach
    void setUp() {
        useCase = new GetMatchupDetailsUseCase(bracketRepository);
        leagueId = UUID.randomUUID();
        player1Id = UUID.randomUUID();
        player2Id = UUID.randomUUID();
        matchupId = UUID.randomUUID();
    }

    private PlayoffBracket createBracketWithMatchup() {
        PlayoffBracket bracket = new PlayoffBracket(leagueId, "Test League");
        bracket.addPlayer(player1Id, "Player 1", 1, BigDecimal.valueOf(100));
        bracket.addPlayer(player2Id, "Player 2", 2, BigDecimal.valueOf(90));

        // Generate bracket which creates matchups based on seeding (1v2 with 2 players)
        bracket.generateBracket();

        return bracket;
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should get matchup details by matchup ID")
        void shouldGetMatchupDetailsByMatchupId() {
            // Arrange
            PlayoffBracket bracket = createBracketWithMatchup();
            PlayoffMatchup matchup = bracket.getMatchupsForRound(PlayoffRound.WILD_CARD).get(0);

            GetMatchupDetailsUseCase.GetMatchupDetailsCommand command =
                    new GetMatchupDetailsUseCase.GetMatchupDetailsCommand(
                            leagueId, PlayoffRound.WILD_CARD, matchup.getId());

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.of(bracket));

            // Act
            GetMatchupDetailsUseCase.MatchupDetailsResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(matchup.getId(), result.getMatchupId());
            assertEquals(PlayoffRound.WILD_CARD, result.getRound());
            assertNotNull(result.getPlayer1());
            assertNotNull(result.getPlayer2());
        }

        @Test
        @DisplayName("should get matchup details by player ID")
        void shouldGetMatchupDetailsByPlayerId() {
            // Arrange
            PlayoffBracket bracket = createBracketWithMatchup();

            GetMatchupDetailsUseCase.GetMatchupDetailsCommand command =
                    GetMatchupDetailsUseCase.GetMatchupDetailsCommand.forPlayer(
                            leagueId, PlayoffRound.WILD_CARD, player1Id);

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.of(bracket));

            // Act
            GetMatchupDetailsUseCase.MatchupDetailsResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(player1Id, result.getPlayer1().getPlayerId());
        }

        @Test
        @DisplayName("should throw exception when bracket not found")
        void shouldThrowExceptionWhenBracketNotFound() {
            // Arrange
            GetMatchupDetailsUseCase.GetMatchupDetailsCommand command =
                    new GetMatchupDetailsUseCase.GetMatchupDetailsCommand(
                            leagueId, PlayoffRound.WILD_CARD, matchupId);

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Playoff bracket not found"));
        }

        @Test
        @DisplayName("should throw exception when neither matchupId nor playerId provided")
        void shouldThrowExceptionWhenNoIdentifierProvided() {
            // Arrange
            PlayoffBracket bracket = createBracketWithMatchup();

            GetMatchupDetailsUseCase.GetMatchupDetailsCommand command =
                    new GetMatchupDetailsUseCase.GetMatchupDetailsCommand(
                            leagueId, PlayoffRound.WILD_CARD, null, null);

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.of(bracket));

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Either matchupId or playerId must be provided"));
        }

        @Test
        @DisplayName("should throw exception when matchup not found")
        void shouldThrowExceptionWhenMatchupNotFound() {
            // Arrange
            PlayoffBracket bracket = createBracketWithMatchup();
            UUID unknownMatchupId = UUID.randomUUID();

            GetMatchupDetailsUseCase.GetMatchupDetailsCommand command =
                    new GetMatchupDetailsUseCase.GetMatchupDetailsCommand(
                            leagueId, PlayoffRound.WILD_CARD, unknownMatchupId);

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.of(bracket));

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Matchup not found"));
        }

        @Test
        @DisplayName("should return player details correctly")
        void shouldReturnPlayerDetailsCorrectly() {
            // Arrange
            PlayoffBracket bracket = createBracketWithMatchup();
            PlayoffMatchup matchup = bracket.getMatchupsForRound(PlayoffRound.WILD_CARD).get(0);

            GetMatchupDetailsUseCase.GetMatchupDetailsCommand command =
                    new GetMatchupDetailsUseCase.GetMatchupDetailsCommand(
                            leagueId, PlayoffRound.WILD_CARD, matchup.getId());

            when(bracketRepository.findByLeagueId(leagueId)).thenReturn(Optional.of(bracket));

            // Act
            GetMatchupDetailsUseCase.MatchupDetailsResult result = useCase.execute(command);

            // Assert
            assertEquals("Player 1", result.getPlayer1().getPlayerName());
            assertEquals(1, result.getPlayer1().getSeed());
            assertEquals("Player 2", result.getPlayer2().getPlayerName());
            assertEquals(2, result.getPlayer2().getSeed());
        }
    }

    @Nested
    @DisplayName("GetMatchupDetailsCommand")
    class GetMatchupDetailsCommandTests {

        @Test
        @DisplayName("should create command with matchup ID")
        void shouldCreateCommandWithMatchupId() {
            // Arrange & Act
            GetMatchupDetailsUseCase.GetMatchupDetailsCommand command =
                    new GetMatchupDetailsUseCase.GetMatchupDetailsCommand(
                            leagueId, PlayoffRound.DIVISIONAL, matchupId);

            // Assert
            assertEquals(leagueId, command.getLeagueId());
            assertEquals(PlayoffRound.DIVISIONAL, command.getRound());
            assertEquals(matchupId, command.getMatchupId());
            assertNull(command.getPlayerId());
        }

        @Test
        @DisplayName("should create command for player")
        void shouldCreateCommandForPlayer() {
            // Arrange & Act
            GetMatchupDetailsUseCase.GetMatchupDetailsCommand command =
                    GetMatchupDetailsUseCase.GetMatchupDetailsCommand.forPlayer(
                            leagueId, PlayoffRound.CONFERENCE, player1Id);

            // Assert
            assertEquals(leagueId, command.getLeagueId());
            assertEquals(PlayoffRound.CONFERENCE, command.getRound());
            assertNull(command.getMatchupId());
            assertEquals(player1Id, command.getPlayerId());
        }
    }

    @Nested
    @DisplayName("PlayerMatchupDetails")
    class PlayerMatchupDetailsTests {

        @Test
        @DisplayName("should create player details with all fields")
        void shouldCreatePlayerDetailsWithAllFields() {
            // Arrange & Act
            GetMatchupDetailsUseCase.PlayerMatchupDetails details =
                    new GetMatchupDetailsUseCase.PlayerMatchupDetails(
                            player1Id, "Test Player", 3,
                            BigDecimal.valueOf(150.5), 5, true);

            // Assert
            assertEquals(player1Id, details.getPlayerId());
            assertEquals("Test Player", details.getPlayerName());
            assertEquals(3, details.getSeed());
            assertEquals(BigDecimal.valueOf(150.5), details.getTotalScore());
            assertEquals(5, details.getPlayersRemaining());
            assertTrue(details.isComplete());
        }
    }
}
