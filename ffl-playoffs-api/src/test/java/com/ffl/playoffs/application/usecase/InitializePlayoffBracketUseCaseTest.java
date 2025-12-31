package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.aggregate.PlayoffBracket;
import com.ffl.playoffs.domain.model.TiebreakerConfiguration;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.PlayoffBracketRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("InitializePlayoffBracketUseCase Tests")
class InitializePlayoffBracketUseCaseTest {

    @Mock
    private PlayoffBracketRepository bracketRepository;

    @Mock
    private LeagueRepository leagueRepository;

    @Mock
    private LeaguePlayerRepository leaguePlayerRepository;

    @Captor
    private ArgumentCaptor<PlayoffBracket> bracketCaptor;

    private InitializePlayoffBracketUseCase useCase;

    private UUID leagueId;
    private UUID player1Id;
    private UUID player2Id;

    @BeforeEach
    void setUp() {
        useCase = new InitializePlayoffBracketUseCase(bracketRepository, leagueRepository, leaguePlayerRepository);
        leagueId = UUID.randomUUID();
        player1Id = UUID.randomUUID();
        player2Id = UUID.randomUUID();
    }

    private League createLeague() {
        League league = new League();
        league.setId(leagueId);
        league.setName("Test League");
        return league;
    }

    private List<InitializePlayoffBracketUseCase.PlayerSeed> createPlayerSeedings() {
        return List.of(
            new InitializePlayoffBracketUseCase.PlayerSeed(
                player1Id, "Player 1", 1, BigDecimal.valueOf(150)
            ),
            new InitializePlayoffBracketUseCase.PlayerSeed(
                player2Id, "Player 2", 2, BigDecimal.valueOf(140)
            )
        );
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should initialize bracket successfully")
        void shouldInitializeBracketSuccessfully() {
            // Arrange
            League league = createLeague();
            List<InitializePlayoffBracketUseCase.PlayerSeed> playerSeedings = createPlayerSeedings();

            InitializePlayoffBracketUseCase.InitializePlayoffBracketCommand command =
                    new InitializePlayoffBracketUseCase.InitializePlayoffBracketCommand(leagueId, playerSeedings);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(bracketRepository.existsByLeagueId(leagueId)).thenReturn(false);
            when(bracketRepository.save(any(PlayoffBracket.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            PlayoffBracket result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(leagueId, result.getLeagueId());
            assertEquals("Test League", result.getLeagueName());
            assertEquals(2, result.getPlayerEntries().size());
            verify(bracketRepository).save(any(PlayoffBracket.class));
        }

        @Test
        @DisplayName("should set custom tiebreaker configuration when provided")
        void shouldSetCustomTiebreakerConfigurationWhenProvided() {
            // Arrange
            League league = createLeague();
            List<InitializePlayoffBracketUseCase.PlayerSeed> playerSeedings = createPlayerSeedings();
            TiebreakerConfiguration customConfig = TiebreakerConfiguration.defaultConfiguration();

            InitializePlayoffBracketUseCase.InitializePlayoffBracketCommand command =
                    new InitializePlayoffBracketUseCase.InitializePlayoffBracketCommand(
                            leagueId, playerSeedings, customConfig);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(bracketRepository.existsByLeagueId(leagueId)).thenReturn(false);
            when(bracketRepository.save(any(PlayoffBracket.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            PlayoffBracket result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertNotNull(result.getTiebreakerConfiguration());
        }

        @Test
        @DisplayName("should throw exception when league not found")
        void shouldThrowExceptionWhenLeagueNotFound() {
            // Arrange
            List<InitializePlayoffBracketUseCase.PlayerSeed> playerSeedings = createPlayerSeedings();

            InitializePlayoffBracketUseCase.InitializePlayoffBracketCommand command =
                    new InitializePlayoffBracketUseCase.InitializePlayoffBracketCommand(leagueId, playerSeedings);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("League not found"));
            verify(bracketRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when bracket already exists")
        void shouldThrowExceptionWhenBracketAlreadyExists() {
            // Arrange
            League league = createLeague();
            List<InitializePlayoffBracketUseCase.PlayerSeed> playerSeedings = createPlayerSeedings();

            InitializePlayoffBracketUseCase.InitializePlayoffBracketCommand command =
                    new InitializePlayoffBracketUseCase.InitializePlayoffBracketCommand(leagueId, playerSeedings);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(bracketRepository.existsByLeagueId(leagueId)).thenReturn(true);

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("already exists"));
            verify(bracketRepository, never()).save(any());
        }

        @Test
        @DisplayName("should sort players by seed")
        void shouldSortPlayersBySeed() {
            // Arrange
            League league = createLeague();
            // Provide seeds in reverse order
            List<InitializePlayoffBracketUseCase.PlayerSeed> playerSeedings = List.of(
                new InitializePlayoffBracketUseCase.PlayerSeed(player2Id, "Player 2", 2, BigDecimal.valueOf(140)),
                new InitializePlayoffBracketUseCase.PlayerSeed(player1Id, "Player 1", 1, BigDecimal.valueOf(150))
            );

            InitializePlayoffBracketUseCase.InitializePlayoffBracketCommand command =
                    new InitializePlayoffBracketUseCase.InitializePlayoffBracketCommand(leagueId, playerSeedings);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(bracketRepository.existsByLeagueId(leagueId)).thenReturn(false);
            when(bracketRepository.save(bracketCaptor.capture())).thenAnswer(inv -> inv.getArgument(0));

            // Act
            PlayoffBracket result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            PlayoffBracket savedBracket = bracketCaptor.getValue();
            // Verify that players are added correctly
            assertTrue(savedBracket.getPlayerEntries().containsKey(player1Id));
            assertTrue(savedBracket.getPlayerEntries().containsKey(player2Id));
        }

        @Test
        @DisplayName("should generate bracket matchups")
        void shouldGenerateBracketMatchups() {
            // Arrange
            League league = createLeague();
            List<InitializePlayoffBracketUseCase.PlayerSeed> playerSeedings = createPlayerSeedings();

            InitializePlayoffBracketUseCase.InitializePlayoffBracketCommand command =
                    new InitializePlayoffBracketUseCase.InitializePlayoffBracketCommand(leagueId, playerSeedings);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(bracketRepository.existsByLeagueId(leagueId)).thenReturn(false);
            when(bracketRepository.save(any(PlayoffBracket.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            PlayoffBracket result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            // With 2 players, there should be 1 matchup in wild card round
            assertEquals(1, result.getMatchupsForRound(
                com.ffl.playoffs.domain.model.PlayoffRound.WILD_CARD).size());
        }
    }

    @Nested
    @DisplayName("InitializePlayoffBracketCommand")
    class InitializePlayoffBracketCommandTests {

        @Test
        @DisplayName("should create command without tiebreaker configuration")
        void shouldCreateCommandWithoutTiebreakerConfiguration() {
            // Arrange
            List<InitializePlayoffBracketUseCase.PlayerSeed> playerSeedings = createPlayerSeedings();

            // Act
            InitializePlayoffBracketUseCase.InitializePlayoffBracketCommand command =
                    new InitializePlayoffBracketUseCase.InitializePlayoffBracketCommand(leagueId, playerSeedings);

            // Assert
            assertEquals(leagueId, command.getLeagueId());
            assertEquals(2, command.getPlayerSeedings().size());
            assertNull(command.getTiebreakerConfiguration());
        }

        @Test
        @DisplayName("should create command with tiebreaker configuration")
        void shouldCreateCommandWithTiebreakerConfiguration() {
            // Arrange
            List<InitializePlayoffBracketUseCase.PlayerSeed> playerSeedings = createPlayerSeedings();
            TiebreakerConfiguration config = TiebreakerConfiguration.defaultConfiguration();

            // Act
            InitializePlayoffBracketUseCase.InitializePlayoffBracketCommand command =
                    new InitializePlayoffBracketUseCase.InitializePlayoffBracketCommand(
                            leagueId, playerSeedings, config);

            // Assert
            assertEquals(leagueId, command.getLeagueId());
            assertEquals(2, command.getPlayerSeedings().size());
            assertNotNull(command.getTiebreakerConfiguration());
        }
    }

    @Nested
    @DisplayName("PlayerSeed")
    class PlayerSeedTests {

        @Test
        @DisplayName("should create player seed with all fields")
        void shouldCreatePlayerSeedWithAllFields() {
            // Arrange & Act
            InitializePlayoffBracketUseCase.PlayerSeed playerSeed =
                    new InitializePlayoffBracketUseCase.PlayerSeed(
                            player1Id, "Test Player", 3, BigDecimal.valueOf(125.5));

            // Assert
            assertEquals(player1Id, playerSeed.getPlayerId());
            assertEquals("Test Player", playerSeed.getPlayerName());
            assertEquals(3, playerSeed.getSeed());
            assertEquals(BigDecimal.valueOf(125.5), playerSeed.getRegularSeasonScore());
        }
    }
}
