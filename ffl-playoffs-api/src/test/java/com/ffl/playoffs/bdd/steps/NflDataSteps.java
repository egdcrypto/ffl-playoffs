package com.ffl.playoffs.bdd.steps;

import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.nfl.NFLGameDTO;
import com.ffl.playoffs.application.dto.nfl.NFLPlayerDTO;
import com.ffl.playoffs.application.dto.nfl.PlayerStatsDTO;
import com.ffl.playoffs.application.service.NFLGameService;
import com.ffl.playoffs.application.service.NFLPlayerService;
import com.ffl.playoffs.application.service.PlayerStatsService;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.NFLGameDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.NFLPlayerDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.PlayerStatsDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoNFLGameRepository;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoNFLPlayerRepository;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoPlayerStatsRepository;
import io.cucumber.java.Before;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

public class NflDataSteps {

    @Autowired
    private NFLPlayerService playerService;

    @Autowired
    private NFLGameService gameService;

    @Autowired
    private PlayerStatsService statsService;

    @Autowired
    private MongoNFLPlayerRepository playerRepository;

    @Autowired
    private MongoNFLGameRepository gameRepository;

    @Autowired
    private MongoPlayerStatsRepository statsRepository;

    // Response holders
    private Page<NFLPlayerDTO> playersPage;
    private NFLPlayerDTO playerResponse;
    private List<NFLGameDTO> gamesResponse;
    private NFLGameDTO gameResponse;
    private List<PlayerStatsDTO> statsResponse;
    private PlayerStatsDTO singleStatsResponse;

    @Before
    public void setUp() {
        // Clear test data before each scenario
        playerRepository.deleteAll();
        gameRepository.deleteAll();
        statsRepository.deleteAll();
    }

    @Given("the NFL data has been synced")
    public void theNflDataHasBeenSynced() {
        // Seed test data
        seedTestPlayers();
        seedTestGames();
        seedTestStats();
    }

    @Given("a player with ID {string} exists")
    public void aPlayerWithIdExists(String playerId) {
        NFLPlayerDocument player = NFLPlayerDocument.builder()
                .playerId(playerId)
                .name("Patrick Mahomes")
                .firstName("Patrick")
                .lastName("Mahomes")
                .position("QB")
                .team("KC")
                .jerseyNumber(15)
                .status("ACTIVE")
                .build();
        playerRepository.save(player);
    }

    @Given("a game with ID {string} exists")
    public void aGameWithIdExists(String gameId) {
        NFLGameDocument game = NFLGameDocument.builder()
                .gameId(gameId)
                .season(2024)
                .week(15)
                .homeTeam("KC")
                .awayTeam("BUF")
                .homeScore(27)
                .awayScore(24)
                .gameTime(LocalDateTime.of(2024, 12, 15, 13, 0))
                .status("FINAL")
                .build();
        gameRepository.save(game);
    }

    @Given("a player with ID {string} has stats for season {int} week {int}")
    public void aPlayerHasStatsForSeasonWeek(String playerId, int season, int week) {
        // First ensure player exists
        aPlayerWithIdExists(playerId);

        // Then add stats
        PlayerStatsDocument stats = PlayerStatsDocument.builder()
                .playerId(playerId)
                .playerName("Patrick Mahomes")
                .season(season)
                .week(week)
                .team("KC")
                .position("QB")
                .passingYards(350)
                .passingTds(3)
                .interceptions(1)
                .rushingYards(25)
                .build();
        statsRepository.save(stats);
    }

    @Given("multiple players exist in the database")
    public void multiplePlayersExistInTheDatabase() {
        seedTestPlayers();
    }

    @Given("there are games currently in progress")
    public void thereAreGamesCurrentlyInProgress() {
        NFLGameDocument activeGame = NFLGameDocument.builder()
                .gameId("2024-15-SF-SEA")
                .season(2024)
                .week(15)
                .homeTeam("SF")
                .awayTeam("SEA")
                .homeScore(14)
                .awayScore(10)
                .status("IN_PROGRESS")
                .quarter("Q3")
                .timeRemaining("8:42")
                .build();
        gameRepository.save(activeGame);
    }

    @When("I request players for team {string}")
    public void iRequestPlayersForTeam(String team) {
        playersPage = playerService.getPlayersByTeam(team, 0, 50);
    }

    @When("I request games for season {int} week {int}")
    public void iRequestGamesForSeasonWeek(int season, int week) {
        gamesResponse = gameService.getGamesByWeek(season, week);
    }

    @When("I request stats for season {int} week {int}")
    public void iRequestStatsForSeasonWeek(int season, int week) {
        statsResponse = statsService.getAllStatsByWeek(season, week);
    }

    @When("I request player with ID {string}")
    public void iRequestPlayerWithId(String playerId) {
        Optional<NFLPlayerDTO> result = playerService.getPlayerById(playerId);
        playerResponse = result.orElse(null);
    }

    @When("I request game with ID {string}")
    public void iRequestGameWithId(String gameId) {
        Optional<NFLGameDTO> result = gameService.getGameById(gameId);
        gameResponse = result.orElse(null);
    }

    @When("I request stats for player {string} in season {int} week {int}")
    public void iRequestStatsForPlayerInSeasonWeek(String playerId, int season, int week) {
        Optional<PlayerStatsDTO> result = statsService.getStatsByPlayerAndWeek(playerId, season, week);
        singleStatsResponse = result.orElse(null);
    }

    @When("I search for players with name {string}")
    public void iSearchForPlayersWithName(String name) {
        playersPage = playerService.searchPlayersByName(name, 0, 20);
    }

    @When("I request active games")
    public void iRequestActiveGames() {
        gamesResponse = gameService.getActiveGames();
    }

    @Then("I should receive a list of Kansas City Chiefs players")
    public void iShouldReceiveKansasCityChiefsPlayers() {
        assertNotNull(playersPage);
        assertFalse(playersPage.getContent().isEmpty());
        assertTrue(playersPage.getContent().stream()
                .allMatch(p -> "KC".equals(p.getTeam())));
    }

    @Then("I should receive {int} games")
    public void iShouldReceiveGames(int expectedCount) {
        assertNotNull(gamesResponse);
        assertEquals(expectedCount, gamesResponse.size());
    }

    @Then("I should receive player statistics")
    public void iShouldReceivePlayerStatistics() {
        assertNotNull(statsResponse);
        assertFalse(statsResponse.isEmpty());
    }

    @Then("I should receive the player details")
    public void iShouldReceiveThePlayerDetails() {
        assertNotNull(playerResponse);
    }

    @Then("the player should have a name")
    public void thePlayerShouldHaveAName() {
        assertNotNull(playerResponse.getName());
        assertFalse(playerResponse.getName().isEmpty());
    }

    @Then("the player should have a position")
    public void thePlayerShouldHaveAPosition() {
        assertNotNull(playerResponse.getPosition());
    }

    @Then("the player should have a team")
    public void thePlayerShouldHaveATeam() {
        assertNotNull(playerResponse.getTeam());
    }

    @Then("I should receive the game details")
    public void iShouldReceiveTheGameDetails() {
        assertNotNull(gameResponse);
    }

    @Then("the game should have home and away teams")
    public void theGameShouldHaveHomeAndAwayTeams() {
        assertNotNull(gameResponse.getHomeTeam());
        assertNotNull(gameResponse.getAwayTeam());
    }

    @Then("the game should have a status")
    public void theGameShouldHaveAStatus() {
        assertNotNull(gameResponse.getStatus());
    }

    @Then("I should receive the player's weekly statistics")
    public void iShouldReceiveThePlayersWeeklyStatistics() {
        assertNotNull(singleStatsResponse);
    }

    @Then("the stats should include fantasy points")
    public void theStatsShouldIncludeFantasyPoints() {
        assertNotNull(singleStatsResponse.getFantasyPoints());
        assertNotNull(singleStatsResponse.getPprFantasyPoints());
        assertNotNull(singleStatsResponse.getHalfPprFantasyPoints());
    }

    @Then("I should receive players matching the search criteria")
    public void iShouldReceivePlayersMatchingTheSearchCriteria() {
        assertNotNull(playersPage);
        assertFalse(playersPage.getContent().isEmpty());
    }

    @Then("I should receive only games with IN_PROGRESS or HALFTIME status")
    public void iShouldReceiveOnlyActiveGames() {
        assertNotNull(gamesResponse);
        assertFalse(gamesResponse.isEmpty());
        assertTrue(gamesResponse.stream()
                .allMatch(g -> "IN_PROGRESS".equals(g.getStatus()) || "HALFTIME".equals(g.getStatus())));
    }

    // Helper methods to seed test data
    private void seedTestPlayers() {
        List<NFLPlayerDocument> players = new ArrayList<>();

        players.add(NFLPlayerDocument.builder()
                .playerId("12345")
                .name("Patrick Mahomes")
                .firstName("Patrick")
                .lastName("Mahomes")
                .position("QB")
                .team("KC")
                .jerseyNumber(15)
                .status("ACTIVE")
                .build());

        players.add(NFLPlayerDocument.builder()
                .playerId("12346")
                .name("Travis Kelce")
                .firstName("Travis")
                .lastName("Kelce")
                .position("TE")
                .team("KC")
                .jerseyNumber(87)
                .status("ACTIVE")
                .build());

        players.add(NFLPlayerDocument.builder()
                .playerId("12347")
                .name("Josh Allen")
                .firstName("Josh")
                .lastName("Allen")
                .position("QB")
                .team("BUF")
                .jerseyNumber(17)
                .status("ACTIVE")
                .build());

        playerRepository.saveAll(players);
    }

    private void seedTestGames() {
        List<NFLGameDocument> games = new ArrayList<>();

        // Create 16 games for week 15
        String[] teams = {"KC", "BUF", "SF", "PHI", "DAL", "MIA", "DET", "GB",
                          "SEA", "LAR", "MIN", "CHI", "BAL", "CIN", "CLE", "PIT",
                          "JAX", "TEN", "HOU", "IND", "LV", "LAC", "DEN", "NYJ",
                          "NE", "NYG", "WAS", "ARI", "ATL", "NO", "TB", "CAR"};

        for (int i = 0; i < 16; i++) {
            games.add(NFLGameDocument.builder()
                    .gameId("2024-15-" + teams[i*2] + "-" + teams[i*2+1])
                    .season(2024)
                    .week(15)
                    .homeTeam(teams[i*2])
                    .awayTeam(teams[i*2+1])
                    .status("SCHEDULED")
                    .gameTime(LocalDateTime.of(2024, 12, 15, 13, 0).plusHours(i % 4))
                    .build());
        }

        gameRepository.saveAll(games);
    }

    private void seedTestStats() {
        List<PlayerStatsDocument> stats = new ArrayList<>();

        stats.add(PlayerStatsDocument.builder()
                .playerId("12345")
                .playerName("Patrick Mahomes")
                .season(2024)
                .week(15)
                .team("KC")
                .position("QB")
                .passingYards(350)
                .passingTds(3)
                .interceptions(1)
                .rushingYards(25)
                .build());

        stats.add(PlayerStatsDocument.builder()
                .playerId("12346")
                .playerName("Travis Kelce")
                .season(2024)
                .week(15)
                .team("KC")
                .position("TE")
                .receptions(8)
                .receivingYards(95)
                .receivingTds(1)
                .targets(12)
                .build());

        statsRepository.saveAll(stats);
    }
}
