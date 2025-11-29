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
    private Page<NFLGameDTO> gamesPage;

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

    // FFL-18 specific step definitions

    @Given("the NFL game schedule data is available")
    public void theNflGameScheduleDataIsAvailable() {
        // This is already handled by setUp() and seedTestGames()
        seedTestGames();
    }

    @Given("the current NFL season is {int}")
    public void theCurrentNflSeasonIs(int season) {
        // This is a context step, no action needed
    }

    @When("I fetch all games for season {int}")
    public void iFetchAllGamesForSeason(int season) {
        gamesPage = gameService.getGames(season, null, 0, 100);
    }

    @Then("the response includes games for the {int} season")
    public void theResponseIncludesGamesForSeason(int season) {
        assertNotNull(gamesPage);
        assertFalse(gamesPage.getContent().isEmpty());
        assertTrue(gamesPage.getContent().stream()
                .allMatch(g -> g.getSeason().equals(season)));
    }

    @Then("each game includes basic game information")
    public void eachGameIncludesBasicGameInformation() {
        assertNotNull(gamesPage);
        gamesPage.getContent().forEach(game -> {
            assertNotNull(game.getGameId());
            assertNotNull(game.getSeason());
            assertNotNull(game.getWeek());
            assertNotNull(game.getHomeTeam());
            assertNotNull(game.getAwayTeam());
        });
    }

    @Given("games exist for week {int}")
    public void gamesExistForWeek(int week) {
        // Already handled by seedTestGames() which creates games for week 15
    }

    @When("I request the schedule for week {int}")
    public void iRequestTheScheduleForWeek(int week) {
        gamesResponse = gameService.getGamesByWeek(2024, week);
    }

    @Then("the response includes only week {int} games")
    public void theResponseIncludesOnlyWeekGames(int week) {
        assertNotNull(gamesResponse);
        assertTrue(gamesResponse.stream()
                .allMatch(g -> g.getWeek().equals(week)));
    }

    @Then("games are sorted by date and time")
    public void gamesAreSortedByDateAndTime() {
        assertNotNull(gamesResponse);
        // Verify games are in chronological order
        for (int i = 0; i < gamesResponse.size() - 1; i++) {
            LocalDateTime current = gamesResponse.get(i).getGameTime();
            LocalDateTime next = gamesResponse.get(i + 1).getGameTime();
            if (current != null && next != null) {
                assertTrue(current.isBefore(next) || current.isEqual(next));
            }
        }
    }

    @Given("a game is scheduled between {string} and {string}")
    public void aGameIsScheduledBetween(String homeTeam, String awayTeam) {
        NFLGameDocument game = NFLGameDocument.builder()
                .gameId("2024-15-" + homeTeam + "-" + awayTeam)
                .season(2024)
                .week(15)
                .homeTeam(homeTeam)
                .awayTeam(awayTeam)
                .gameTime(LocalDateTime.of(2024, 12, 15, 13, 0))
                .status("SCHEDULED")
                .build();
        gameRepository.save(game);
    }

    @When("I fetch the game details")
    public void iFetchTheGameDetails() {
        // Assuming we're fetching the first game in the repository
        List<NFLGameDocument> games = gameRepository.findAll();
        if (!games.isEmpty()) {
            gameResponse = NFLGameDTO.fromDocument(games.get(0));
        }
    }

    @Then("the game status is {string}")
    public void theGameStatusIs(String expectedStatus) {
        assertNotNull(gameResponse);
        assertEquals(expectedStatus, gameResponse.getStatus());
    }

    @Then("the game includes home and away teams")
    public void theGameIncludesHomeAndAwayTeams() {
        assertNotNull(gameResponse);
        assertNotNull(gameResponse.getHomeTeam());
        assertNotNull(gameResponse.getAwayTeam());
    }

    @Then("scores are null for scheduled games")
    public void scoresAreNullForScheduledGames() {
        assertNotNull(gameResponse);
        if ("SCHEDULED".equals(gameResponse.getStatus())) {
            // Scores can be null or 0 for scheduled games
            assertTrue(gameResponse.getHomeScore() == null || gameResponse.getHomeScore() == 0);
            assertTrue(gameResponse.getAwayScore() == null || gameResponse.getAwayScore() == 0);
        }
    }

    @Given("a game with status {string}")
    public void aGameWithStatus(String status) {
        NFLGameDocument game = NFLGameDocument.builder()
                .gameId("2024-15-TEST-GAME")
                .season(2024)
                .week(15)
                .homeTeam("KC")
                .awayTeam("BUF")
                .gameTime(LocalDateTime.of(2024, 12, 15, 13, 0))
                .status(status)
                .build();
        gameRepository.save(game);
    }

    @When("the game status is updated to {string}")
    public void theGameStatusIsUpdatedTo(String newStatus) {
        NFLGameDocument game = gameRepository.findByGameId("2024-15-TEST-GAME").orElseThrow();
        game.setStatus(newStatus);
        if ("IN_PROGRESS".equals(newStatus)) {
            game.setHomeScore(0);
            game.setAwayScore(0);
        }
        gameRepository.save(game);
    }

    @Then("the game status changes to {string}")
    public void theGameStatusChangesTo(String expectedStatus) {
        NFLGameDocument game = gameRepository.findByGameId("2024-15-TEST-GAME").orElseThrow();
        assertEquals(expectedStatus, game.getStatus());
    }

    @Then("scores start updating")
    public void scoresStartUpdating() {
        NFLGameDocument game = gameRepository.findByGameId("2024-15-TEST-GAME").orElseThrow();
        assertNotNull(game.getHomeScore());
        assertNotNull(game.getAwayScore());
    }

    @When("the game is marked as {string}")
    public void theGameIsMarkedAs(String status) {
        NFLGameDocument game = gameRepository.findByGameId("2024-15-TEST-GAME").orElseThrow();
        game.setStatus(status);
        if ("FINAL".equals(status)) {
            game.setHomeScore(31);
            game.setAwayScore(27);
        }
        gameRepository.save(game);
    }

    @Then("the final scores are recorded")
    public void theFinalScoresAreRecorded() {
        NFLGameDocument game = gameRepository.findByGameId("2024-15-TEST-GAME").orElseThrow();
        assertNotNull(game.getHomeScore());
        assertNotNull(game.getAwayScore());
        assertTrue(game.getHomeScore() > 0 || game.getAwayScore() > 0);
    }

    @Given("a game is in overtime")
    public void aGameIsInOvertime() {
        NFLGameDocument game = NFLGameDocument.builder()
                .gameId("2024-15-OT-GAME")
                .season(2024)
                .week(15)
                .homeTeam("KC")
                .awayTeam("BUF")
                .gameTime(LocalDateTime.of(2024, 12, 15, 13, 0))
                .status("IN_PROGRESS")
                .quarter("OT")
                .homeScore(27)
                .awayScore(27)
                .build();
        gameRepository.save(game);
        gameResponse = NFLGameDTO.fromDocument(game);
    }

    @Then("the quarter field shows {string}")
    public void theQuarterFieldShows(String expectedQuarter) {
        assertNotNull(gameResponse);
        assertEquals(expectedQuarter, gameResponse.getQuarter());
    }

    @Given("games with various statuses exist")
    public void gamesWithVariousStatusesExist() {
        gameRepository.save(NFLGameDocument.builder()
                .gameId("2024-15-SCHEDULED")
                .season(2024)
                .week(15)
                .homeTeam("KC")
                .awayTeam("BUF")
                .status("SCHEDULED")
                .build());

        gameRepository.save(NFLGameDocument.builder()
                .gameId("2024-15-IN-PROGRESS")
                .season(2024)
                .week(15)
                .homeTeam("SF")
                .awayTeam("SEA")
                .status("IN_PROGRESS")
                .build());

        gameRepository.save(NFLGameDocument.builder()
                .gameId("2024-15-FINAL")
                .season(2024)
                .week(15)
                .homeTeam("DAL")
                .awayTeam("PHI")
                .status("FINAL")
                .build());
    }

    @When("I query games by status {string}")
    public void iQueryGamesByStatus(String status) {
        gamesResponse = gameService.getGamesByStatus(status);
    }

    @Then("I receive only scheduled games")
    public void iReceiveOnlyScheduledGames() {
        assertNotNull(gamesResponse);
        assertTrue(gamesResponse.stream()
                .allMatch(g -> "SCHEDULED".equals(g.getStatus())));
    }

    @Then("I receive only in-progress games")
    public void iReceiveOnlyInProgressGames() {
        assertNotNull(gamesResponse);
        assertTrue(gamesResponse.stream()
                .allMatch(g -> "IN_PROGRESS".equals(g.getStatus())));
    }

    @Then("I receive only completed games")
    public void iReceiveOnlyCompletedGames() {
        assertNotNull(gamesResponse);
        assertTrue(gamesResponse.stream()
                .allMatch(g -> "FINAL".equals(g.getStatus())));
    }

    @Given("week {int} has {int} games")
    public void weekHasGames(int week, int gameCount) {
        // Seed with exact number of games
        gameRepository.deleteAll();
        for (int i = 0; i < gameCount; i++) {
            gameRepository.save(NFLGameDocument.builder()
                    .gameId("2024-" + week + "-GAME-" + i)
                    .season(2024)
                    .week(week)
                    .homeTeam("TEAM" + (i * 2))
                    .awayTeam("TEAM" + (i * 2 + 1))
                    .status("SCHEDULED")
                    .build());
        }
    }

    @Then("all games are for week {int}")
    public void allGamesAreForWeek(int week) {
        assertNotNull(gamesResponse);
        assertTrue(gamesResponse.stream()
                .allMatch(g -> g.getWeek().equals(week)));
    }

    @Given("a game is in progress in quarter {int}")
    public void aGameIsInProgressInQuarter(int quarter) {
        NFLGameDocument game = NFLGameDocument.builder()
                .gameId("2024-15-QUARTER-GAME")
                .season(2024)
                .week(15)
                .homeTeam("KC")
                .awayTeam("BUF")
                .status("IN_PROGRESS")
                .quarter("Q" + quarter)
                .timeRemaining("10:30")
                .homeScore(14)
                .awayScore(10)
                .build();
        gameRepository.save(game);
        gameResponse = NFLGameDTO.fromDocument(game);
    }

    @Then("the quarter field shows the current quarter")
    public void theQuarterFieldShowsTheCurrentQuarter() {
        assertNotNull(gameResponse);
        assertNotNull(gameResponse.getQuarter());
        assertTrue(gameResponse.getQuarter().matches("Q[1-4]|OT"));
    }

    @Then("time remaining information is available")
    public void timeRemainingInformationIsAvailable() {
        assertNotNull(gameResponse);
        assertNotNull(gameResponse.getTimeRemaining());
    }

    @Given("a game is at halftime")
    public void aGameIsAtHalftime() {
        NFLGameDocument game = NFLGameDocument.builder()
                .gameId("2024-15-HALFTIME-GAME")
                .season(2024)
                .week(15)
                .homeTeam("KC")
                .awayTeam("BUF")
                .status("HALFTIME")
                .quarter("Half")
                .timeRemaining("00:00")
                .homeScore(14)
                .awayScore(10)
                .build();
        gameRepository.save(game);
        gameResponse = NFLGameDTO.fromDocument(game);
    }

    @Then("the status shows {string}")
    public void theStatusShows(String expectedStatus) {
        assertNotNull(gameResponse);
        assertEquals(expectedStatus, gameResponse.getStatus());
    }

    @Given("a scheduled game exists")
    public void aScheduledGameExists() {
        NFLGameDocument game = NFLGameDocument.builder()
                .gameId("2024-15-SCHEDULED-GAME")
                .season(2024)
                .week(15)
                .homeTeam("KC")
                .awayTeam("BUF")
                .gameTime(LocalDateTime.of(2024, 12, 15, 13, 0))
                .status("SCHEDULED")
                .build();
        gameRepository.save(game);
    }

    @When("the game is postponed to a new time")
    public void theGameIsPostponedToANewTime() {
        NFLGameDocument game = gameRepository.findByGameId("2024-15-SCHEDULED-GAME").orElseThrow();
        game.setStatus("POSTPONED");
        game.setGameTime(LocalDateTime.of(2024, 12, 16, 19, 0));
        gameRepository.save(game);
        gameResponse = NFLGameDTO.fromDocument(game);
    }

    @Then("the game time is updated")
    public void theGameTimeIsUpdated() {
        assertNotNull(gameResponse);
        assertNotNull(gameResponse.getGameTime());
        // Verify it's different from original time
        LocalDateTime expectedNewTime = LocalDateTime.of(2024, 12, 16, 19, 0);
        assertEquals(expectedNewTime, gameResponse.getGameTime());
    }

    @When("the game is cancelled")
    public void theGameIsCancelled() {
        NFLGameDocument game = gameRepository.findByGameId("2024-15-SCHEDULED-GAME").orElseThrow();
        game.setStatus("CANCELLED");
        gameRepository.save(game);
        gameResponse = NFLGameDTO.fromDocument(game);
    }

    @Given("a game with venue information exists")
    public void aGameWithVenueInformationExists() {
        NFLGameDocument game = NFLGameDocument.builder()
                .gameId("2024-15-VENUE-GAME")
                .season(2024)
                .week(15)
                .homeTeam("KC")
                .awayTeam("BUF")
                .venue("Arrowhead Stadium")
                .stadiumId("1")
                .stadiumType("Outdoor")
                .playingSurface("Grass")
                .status("SCHEDULED")
                .build();
        gameRepository.save(game);
        gameResponse = NFLGameDTO.fromDocument(game);
    }

    @Then("stadium information is included")
    public void stadiumInformationIsIncluded() {
        assertNotNull(gameResponse);
        assertNotNull(gameResponse.getVenue());
    }

    @Then("these games require live stats polling")
    public void theseGamesRequireLiveStatsPolling() {
        // This is a business logic assertion - active games need polling
        assertNotNull(gamesResponse);
        assertTrue(gamesResponse.stream()
                .allMatch(g -> "IN_PROGRESS".equals(g.getStatus()) || "HALFTIME".equals(g.getStatus())));
    }

    @Given("week {int} games are all completed")
    public void weekGamesAreAllCompleted(int week) {
        gameRepository.save(NFLGameDocument.builder()
                .gameId("2024-" + week + "-COMPLETED-1")
                .season(2024)
                .week(week)
                .homeTeam("KC")
                .awayTeam("BUF")
                .status("FINAL")
                .homeScore(31)
                .awayScore(27)
                .build());
    }

    @Then("all games have status {string}")
    public void allGamesHaveStatus(String expectedStatus) {
        assertNotNull(gamesResponse);
        assertTrue(gamesResponse.stream()
                .allMatch(g -> expectedStatus.equals(g.getStatus())));
    }

    @Given("weeks {int} through {int} have game data")
    public void weeksThroughHaveGameData(int startWeek, int endWeek) {
        for (int week = startWeek; week <= endWeek; week++) {
            gameRepository.save(NFLGameDocument.builder()
                    .gameId("2024-" + week + "-GAME-1")
                    .season(2024)
                    .week(week)
                    .homeTeam("KC")
                    .awayTeam("BUF")
                    .status("SCHEDULED")
                    .build());
        }
    }

    @Then("the response includes games from all weeks")
    public void theResponseIncludesGamesFromAllWeeks() {
        assertNotNull(gamesPage);
        assertFalse(gamesPage.getContent().isEmpty());
    }

    @Then("games are grouped by week")
    public void gamesAreGroupedByWeek() {
        // Games should be sorted by week
        assertNotNull(gamesPage);
        // Verify we have games from multiple weeks
        long distinctWeeks = gamesPage.getContent().stream()
                .map(NFLGameDTO::getWeek)
                .distinct()
                .count();
        assertTrue(distinctWeeks > 1);
    }

    @When("I request schedule for week {int}")
    public void iRequestScheduleForWeek(int week) {
        gamesResponse = gameService.getGamesByWeek(2024, week);
    }

    @Then("no games are returned")
    public void noGamesAreReturned() {
        assertNotNull(gamesResponse);
        assertTrue(gamesResponse.isEmpty());
    }

    @Given("week {int} includes primetime games")
    public void weekIncludesPrimetimeGames(int week) {
        gameRepository.save(NFLGameDocument.builder()
                .gameId("2024-" + week + "-SNF")
                .season(2024)
                .week(week)
                .homeTeam("KC")
                .awayTeam("BUF")
                .broadcastNetwork("NBC")
                .status("SCHEDULED")
                .build());

        gameRepository.save(NFLGameDocument.builder()
                .gameId("2024-" + week + "-MNF")
                .season(2024)
                .week(week)
                .homeTeam("SF")
                .awayTeam("SEA")
                .broadcastNetwork("ESPN")
                .status("SCHEDULED")
                .build());
    }

    @When("I request games for week {int}")
    public void iRequestGamesForWeek(int week) {
        gamesResponse = gameService.getGamesByWeek(2024, week);
    }

    @Then("some games have broadcast network information")
    public void someGamesHaveBroadcastNetworkInformation() {
        assertNotNull(gamesResponse);
        assertTrue(gamesResponse.stream()
                .anyMatch(g -> g.getBroadcastNetwork() != null));
    }

    @Then("networks include CBS, FOX, NBC, ESPN, or Amazon")
    public void networksIncludeCbsFoxNbcEspnOrAmazon() {
        assertNotNull(gamesResponse);
        List<String> validNetworks = List.of("CBS", "FOX", "NBC", "ESPN", "Amazon", "ABC");
        assertTrue(gamesResponse.stream()
                .filter(g -> g.getBroadcastNetwork() != null)
                .allMatch(g -> validNetworks.stream()
                        .anyMatch(network -> g.getBroadcastNetwork().contains(network))));
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
