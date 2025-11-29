package com.ffl.playoffs.bdd.steps;

import com.ffl.playoffs.application.dto.nfl.NFLGameDTO;
import com.ffl.playoffs.application.service.NFLGameService;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.NFLGameDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoNFLGameRepository;
import io.cucumber.java.Before;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Cucumber step definitions for FFL-18: NFL Game Schedules
 * Integration tests for retrieving and managing NFL game schedules
 */
public class NflGameScheduleSteps {

    @Autowired
    private NFLGameService gameService;

    @Autowired
    private MongoNFLGameRepository gameRepository;

    // Response holders
    private List<NFLGameDTO> gamesResponse;
    private NFLGameDTO gameResponse;
    private Integer currentSeason;
    private String testGameId;

    @Before
    public void setUp() {
        // Clear test data before each scenario
        gameRepository.deleteAll();
    }

    // Background steps
    @Given("the NFL game schedule data is available")
    public void theNflGameScheduleDataIsAvailable() {
        // Seed basic test data
        seedBasicTestGames();
    }

    @Given("the current NFL season is {int}")
    public void theCurrentNflSeasonIs(Integer season) {
        this.currentSeason = season;
    }

    // Retrieve Full Season Schedule
    @When("I fetch all games for season {int}")
    public void iFetchAllGamesForSeason(Integer season) {
        gamesResponse = gameRepository.findBySeason(season).stream()
                .map(NFLGameDTO::fromDocument)
                .collect(Collectors.toList());
    }

    @Then("the response includes games for the {int} season")
    public void theResponseIncludesGamesForTheSeason(Integer season) {
        assertNotNull(gamesResponse);
        assertFalse(gamesResponse.isEmpty());
        assertTrue(gamesResponse.stream().allMatch(g -> season.equals(g.getSeason())));
    }

    @Then("each game includes basic game information")
    public void eachGameIncludesBasicGameInformation() {
        assertNotNull(gamesResponse);
        for (NFLGameDTO game : gamesResponse) {
            assertNotNull(game.getGameId());
            assertNotNull(game.getSeason());
            assertNotNull(game.getWeek());
            assertNotNull(game.getHomeTeam());
            assertNotNull(game.getAwayTeam());
            assertNotNull(game.getGameTime());
        }
    }

    // Filter schedule by specific week
    @Given("games exist for week {int}")
    public void gamesExistForWeek(Integer week) {
        seedGamesForWeek(currentSeason, week);
    }

    @When("I request the schedule for week {int}")
    public void iRequestTheScheduleForWeek(Integer week) {
        gamesResponse = gameService.getGamesByWeek(currentSeason, week);
    }

    @Then("the response includes only week {int} games")
    public void theResponseIncludesOnlyWeekGames(Integer week) {
        assertNotNull(gamesResponse);
        assertFalse(gamesResponse.isEmpty());
        assertTrue(gamesResponse.stream().allMatch(g -> week.equals(g.getWeek())));
    }

    @Then("games are sorted by date and time")
    public void gamesAreSortedByDateAndTime() {
        assertNotNull(gamesResponse);
        for (int i = 0; i < gamesResponse.size() - 1; i++) {
            LocalDateTime current = gamesResponse.get(i).getGameTime();
            LocalDateTime next = gamesResponse.get(i + 1).getGameTime();
            if (current != null && next != null) {
                assertTrue(current.isBefore(next) || current.equals(next),
                        "Games should be sorted by date and time");
            }
        }
    }

    // Game Status Tracking - Scheduled Game
    @Given("a game is scheduled between {string} and {string}")
    public void aGameIsScheduledBetween(String awayTeam, String homeTeam) {
        NFLGameDocument game = NFLGameDocument.builder()
                .gameId("2024-15-" + awayTeam + "-" + homeTeam)
                .season(currentSeason)
                .week(15)
                .homeTeam(homeTeam)
                .awayTeam(awayTeam)
                .gameTime(LocalDateTime.of(2024, 12, 22, 16, 25))
                .status("SCHEDULED")
                .venue("Highmark Stadium")
                .build();
        gameRepository.save(game);
        testGameId = game.getGameId();
    }

    @When("I fetch the game details")
    public void iFetchTheGameDetails() {
        Optional<NFLGameDTO> result = gameService.getGameById(testGameId);
        gameResponse = result.orElse(null);
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
        assertFalse(gameResponse.getHomeTeam().isEmpty());
        assertFalse(gameResponse.getAwayTeam().isEmpty());
    }

    @Then("scores are null for scheduled games")
    public void scoresAreNullForScheduledGames() {
        assertNotNull(gameResponse);
        assertNull(gameResponse.getHomeScore());
        assertNull(gameResponse.getAwayScore());
    }

    // Detect when game starts
    @Given("a game with status {string}")
    public void aGameWithStatus(String status) {
        NFLGameDocument game = NFLGameDocument.builder()
                .gameId("2024-15-TEST-GAME")
                .season(currentSeason)
                .week(15)
                .homeTeam("KC")
                .awayTeam("BUF")
                .gameTime(LocalDateTime.of(2024, 12, 22, 16, 25))
                .status(status)
                .build();
        gameRepository.save(game);
        testGameId = game.getGameId();
    }

    @When("the game status is updated to {string}")
    public void theGameStatusIsUpdatedTo(String newStatus) {
        Optional<NFLGameDocument> gameOpt = gameRepository.findByGameId(testGameId);
        if (gameOpt.isPresent()) {
            NFLGameDocument game = gameOpt.get();
            game.setStatus(newStatus);
            if ("IN_PROGRESS".equals(newStatus)) {
                game.setHomeScore(0);
                game.setAwayScore(0);
                game.setQuarter("Q1");
            }
            gameRepository.save(game);
        }
    }

    @Then("the game status changes to {string}")
    public void theGameStatusChangesTo(String expectedStatus) {
        Optional<NFLGameDTO> result = gameService.getGameById(testGameId);
        gameResponse = result.orElse(null);
        assertNotNull(gameResponse);
        assertEquals(expectedStatus, gameResponse.getStatus());
    }

    @Then("scores start updating")
    public void scoresStartUpdating() {
        assertNotNull(gameResponse);
        assertNotNull(gameResponse.getHomeScore());
        assertNotNull(gameResponse.getAwayScore());
    }

    // Detect when game completes
    @When("the game is marked as {string}")
    public void theGameIsMarkedAs(String status) {
        Optional<NFLGameDocument> gameOpt = gameRepository.findByGameId(testGameId);
        if (gameOpt.isPresent()) {
            NFLGameDocument game = gameOpt.get();
            game.setStatus(status);
            if ("FINAL".equals(status)) {
                game.setHomeScore(27);
                game.setAwayScore(24);
                game.setQuarter("FINAL");
            }
            gameRepository.save(game);
        }
    }

    @Then("the final scores are recorded")
    public void theFinalScoresAreRecorded() {
        Optional<NFLGameDTO> result = gameService.getGameById(testGameId);
        gameResponse = result.orElse(null);
        assertNotNull(gameResponse);
        assertNotNull(gameResponse.getHomeScore());
        assertNotNull(gameResponse.getAwayScore());
        assertTrue(gameResponse.getHomeScore() > 0 || gameResponse.getAwayScore() > 0);
    }

    // Handle overtime games
    @Given("a game is in overtime")
    public void aGameIsInOvertime() {
        NFLGameDocument game = NFLGameDocument.builder()
                .gameId("2024-15-OT-GAME")
                .season(currentSeason)
                .week(15)
                .homeTeam("KC")
                .awayTeam("BUF")
                .gameTime(LocalDateTime.of(2024, 12, 22, 16, 25))
                .status("IN_PROGRESS")
                .quarter("OT")
                .timeRemaining("10:00")
                .homeScore(24)
                .awayScore(24)
                .build();
        gameRepository.save(game);
        testGameId = game.getGameId();
    }

    @Then("the quarter field shows {string}")
    public void theQuarterFieldShows(String expectedQuarter) {
        assertNotNull(gameResponse);
        assertEquals(expectedQuarter, gameResponse.getQuarter());
    }

    // Recognize all possible game statuses
    @Given("games with various statuses exist")
    public void gamesWithVariousStatusesExist() {
        List<NFLGameDocument> games = new ArrayList<>();

        games.add(NFLGameDocument.builder()
                .gameId("2024-15-SCHEDULED-1")
                .season(currentSeason)
                .week(15)
                .homeTeam("KC")
                .awayTeam("BUF")
                .status("SCHEDULED")
                .gameTime(LocalDateTime.of(2024, 12, 22, 16, 25))
                .build());

        games.add(NFLGameDocument.builder()
                .gameId("2024-15-IN_PROGRESS-1")
                .season(currentSeason)
                .week(15)
                .homeTeam("SF")
                .awayTeam("SEA")
                .status("IN_PROGRESS")
                .quarter("Q3")
                .gameTime(LocalDateTime.of(2024, 12, 22, 13, 0))
                .build());

        games.add(NFLGameDocument.builder()
                .gameId("2024-15-FINAL-1")
                .season(currentSeason)
                .week(15)
                .homeTeam("DAL")
                .awayTeam("PHI")
                .status("FINAL")
                .homeScore(27)
                .awayScore(24)
                .gameTime(LocalDateTime.of(2024, 12, 22, 10, 0))
                .build());

        gameRepository.saveAll(games);
    }

    @When("I query games by status {string}")
    public void iQueryGamesByStatus(String status) {
        gamesResponse = gameService.getGamesByStatus(status);
    }

    @Then("I receive only scheduled games")
    public void iReceiveOnlyScheduledGames() {
        assertNotNull(gamesResponse);
        assertFalse(gamesResponse.isEmpty());
        assertTrue(gamesResponse.stream().allMatch(g -> "SCHEDULED".equals(g.getStatus())));
    }

    @Then("I receive only in-progress games")
    public void iReceiveOnlyInProgressGames() {
        assertNotNull(gamesResponse);
        assertFalse(gamesResponse.isEmpty());
        assertTrue(gamesResponse.stream().allMatch(g -> "IN_PROGRESS".equals(g.getStatus())));
    }

    @Then("I receive only completed games")
    public void iReceiveOnlyCompletedGames() {
        assertNotNull(gamesResponse);
        assertFalse(gamesResponse.isEmpty());
        assertTrue(gamesResponse.stream().allMatch(g -> "FINAL".equals(g.getStatus())));
    }

    // Get schedule for specific NFL week
    @Given("week {int} has {int} games")
    public void weekHasGames(Integer week, Integer gameCount) {
        seedGamesForWeek(currentSeason, week, gameCount);
    }

    @When("I request games for season {int} week {int}")
    public void iRequestGamesForSeasonWeek(Integer season, Integer week) {
        gamesResponse = gameService.getGamesByWeek(season, week);
    }

    @Then("I receive {int} games")
    public void iReceiveGames(Integer expectedCount) {
        assertNotNull(gamesResponse);
        assertEquals(expectedCount, gamesResponse.size());
    }

    @Then("all games are for week {int}")
    public void allGamesAreForWeek(Integer week) {
        assertNotNull(gamesResponse);
        assertTrue(gamesResponse.stream().allMatch(g -> week.equals(g.getWeek())));
    }

    // Track game time remaining
    @Given("a game is in progress in quarter {int}")
    public void aGameIsInProgressInQuarter(Integer quarter) {
        NFLGameDocument game = NFLGameDocument.builder()
                .gameId("2024-15-LIVE-GAME")
                .season(currentSeason)
                .week(15)
                .homeTeam("KC")
                .awayTeam("BUF")
                .gameTime(LocalDateTime.of(2024, 12, 22, 16, 25))
                .status("IN_PROGRESS")
                .quarter("Q" + quarter)
                .timeRemaining("8:42")
                .homeScore(14)
                .awayScore(10)
                .build();
        gameRepository.save(game);
        testGameId = game.getGameId();
    }

    @Then("the quarter field shows the current quarter")
    public void theQuarterFieldShowsTheCurrentQuarter() {
        assertNotNull(gameResponse);
        assertNotNull(gameResponse.getQuarter());
        assertTrue(gameResponse.getQuarter().startsWith("Q") || "OT".equals(gameResponse.getQuarter()));
    }

    @Then("time remaining information is available")
    public void timeRemainingInformationIsAvailable() {
        assertNotNull(gameResponse);
        assertNotNull(gameResponse.getTimeRemaining());
    }

    // Handle halftime
    @Given("a game is at halftime")
    public void aGameIsAtHalftime() {
        NFLGameDocument game = NFLGameDocument.builder()
                .gameId("2024-15-HALFTIME-GAME")
                .season(currentSeason)
                .week(15)
                .homeTeam("KC")
                .awayTeam("BUF")
                .gameTime(LocalDateTime.of(2024, 12, 22, 16, 25))
                .status("HALFTIME")
                .quarter("Q2")
                .homeScore(14)
                .awayScore(10)
                .build();
        gameRepository.save(game);
        testGameId = game.getGameId();
    }

    @Then("the status shows {string}")
    public void theStatusShows(String expectedStatus) {
        assertNotNull(gameResponse);
        assertEquals(expectedStatus, gameResponse.getStatus());
    }

    // Handle game postponement
    @Given("a scheduled game exists")
    public void aScheduledGameExists() {
        NFLGameDocument game = NFLGameDocument.builder()
                .gameId("2024-15-POSTPONED-GAME")
                .season(currentSeason)
                .week(15)
                .homeTeam("KC")
                .awayTeam("BUF")
                .gameTime(LocalDateTime.of(2024, 12, 22, 16, 25))
                .status("SCHEDULED")
                .build();
        gameRepository.save(game);
        testGameId = game.getGameId();
    }

    @When("the game is postponed to a new time")
    public void theGameIsPostponedToANewTime() {
        Optional<NFLGameDocument> gameOpt = gameRepository.findByGameId(testGameId);
        if (gameOpt.isPresent()) {
            NFLGameDocument game = gameOpt.get();
            game.setStatus("POSTPONED");
            game.setGameTime(LocalDateTime.of(2024, 12, 23, 16, 25));
            gameRepository.save(game);
        }
    }

    @Then("the game time is updated")
    public void theGameTimeIsUpdated() {
        Optional<NFLGameDTO> result = gameService.getGameById(testGameId);
        gameResponse = result.orElse(null);
        assertNotNull(gameResponse);
        assertNotNull(gameResponse.getGameTime());
    }

    // Handle game cancellation
    @When("the game is cancelled")
    public void theGameIsCancelled() {
        Optional<NFLGameDocument> gameOpt = gameRepository.findByGameId(testGameId);
        if (gameOpt.isPresent()) {
            NFLGameDocument game = gameOpt.get();
            game.setStatus("CANCELLED");
            gameRepository.save(game);
        }
    }

    // Stadium and Venue Information
    @Given("a game with venue information exists")
    public void aGameWithVenueInformationExists() {
        NFLGameDocument game = NFLGameDocument.builder()
                .gameId("2024-15-VENUE-GAME")
                .season(currentSeason)
                .week(15)
                .homeTeam("KC")
                .awayTeam("BUF")
                .gameTime(LocalDateTime.of(2024, 12, 22, 16, 25))
                .status("SCHEDULED")
                .venue("Arrowhead Stadium")
                .build();
        gameRepository.save(game);
        testGameId = game.getGameId();
    }

    @Then("stadium information is included")
    public void stadiumInformationIsIncluded() {
        assertNotNull(gameResponse);
        assertNotNull(gameResponse.getVenue());
        assertFalse(gameResponse.getVenue().isEmpty());
    }

    // Get active games for polling
    @Given("there are games in progress")
    public void thereAreGamesInProgress() {
        List<NFLGameDocument> games = new ArrayList<>();

        games.add(NFLGameDocument.builder()
                .gameId("2024-15-ACTIVE-1")
                .season(currentSeason)
                .week(15)
                .homeTeam("KC")
                .awayTeam("BUF")
                .status("IN_PROGRESS")
                .quarter("Q3")
                .gameTime(LocalDateTime.of(2024, 12, 22, 16, 25))
                .build());

        games.add(NFLGameDocument.builder()
                .gameId("2024-15-ACTIVE-2")
                .season(currentSeason)
                .week(15)
                .homeTeam("SF")
                .awayTeam("SEA")
                .status("HALFTIME")
                .gameTime(LocalDateTime.of(2024, 12, 22, 13, 0))
                .build());

        gameRepository.saveAll(games);
    }

    @When("I request active games")
    public void iRequestActiveGames() {
        gamesResponse = gameService.getActiveGames();
    }

    @Then("I receive only games with IN_PROGRESS or HALFTIME status")
    public void iReceiveOnlyGamesWithInProgressOrHalftimeStatus() {
        assertNotNull(gamesResponse);
        assertFalse(gamesResponse.isEmpty());
        assertTrue(gamesResponse.stream()
                .allMatch(g -> "IN_PROGRESS".equals(g.getStatus()) || "HALFTIME".equals(g.getStatus())));
    }

    @Then("these games require live stats polling")
    public void theseGamesRequireLiveStatsPolling() {
        assertNotNull(gamesResponse);
        // Games with IN_PROGRESS or HALFTIME status require polling
        assertTrue(gamesResponse.stream()
                .allMatch(g -> "IN_PROGRESS".equals(g.getStatus()) || "HALFTIME".equals(g.getStatus())));
    }

    // Historical Schedule Data
    @Given("week {int} games are all completed")
    public void weekGamesAreAllCompleted(Integer week) {
        List<NFLGameDocument> games = new ArrayList<>();

        for (int i = 0; i < 16; i++) {
            games.add(NFLGameDocument.builder()
                    .gameId("2024-" + week + "-FINAL-" + i)
                    .season(currentSeason)
                    .week(week)
                    .homeTeam("TEAM" + (i * 2))
                    .awayTeam("TEAM" + (i * 2 + 1))
                    .status("FINAL")
                    .homeScore(20 + i)
                    .awayScore(17 + i)
                    .gameTime(LocalDateTime.of(2024, 12, 15, 13, 0))
                    .build());
        }

        gameRepository.saveAll(games);
    }

    @Then("all games have status {string}")
    public void allGamesHaveStatus(String expectedStatus) {
        assertNotNull(gamesResponse);
        assertFalse(gamesResponse.isEmpty());
        assertTrue(gamesResponse.stream().allMatch(g -> expectedStatus.equals(g.getStatus())));
    }

    // Multi-week Schedule View
    @Given("weeks {int} through {int} have game data")
    public void weeksThroughHaveGameData(Integer startWeek, Integer endWeek) {
        for (int week = startWeek; week <= endWeek; week++) {
            seedGamesForWeek(currentSeason, week, 16);
        }
    }

    @Then("the response includes games from all weeks")
    public void theResponseIncludesGamesFromAllWeeks() {
        assertNotNull(gamesResponse);
        assertFalse(gamesResponse.isEmpty());
        // Verify we have games from multiple weeks
        long distinctWeeks = gamesResponse.stream()
                .map(NFLGameDTO::getWeek)
                .distinct()
                .count();
        assertTrue(distinctWeeks > 1);
    }

    @Then("games are grouped by week")
    public void gamesAreGroupedByWeek() {
        assertNotNull(gamesResponse);
        // Games should be sorted by week and time
        for (int i = 0; i < gamesResponse.size() - 1; i++) {
            NFLGameDTO current = gamesResponse.get(i);
            NFLGameDTO next = gamesResponse.get(i + 1);
            assertTrue(current.getWeek() <= next.getWeek());
        }
    }

    // Error Handling
    @When("I request schedule for week {int}")
    public void iRequestScheduleForWeek(Integer week) {
        gamesResponse = gameService.getGamesByWeek(currentSeason, week);
    }

    @Then("no games are returned")
    public void noGamesAreReturned() {
        assertNotNull(gamesResponse);
        assertTrue(gamesResponse.isEmpty());
    }

    // Primetime Games
    @Given("week {int} includes primetime games")
    public void weekIncludesPrimetimeGames(Integer week) {
        List<NFLGameDocument> games = new ArrayList<>();

        games.add(NFLGameDocument.builder()
                .gameId("2024-" + week + "-SNF")
                .season(currentSeason)
                .week(week)
                .homeTeam("KC")
                .awayTeam("BUF")
                .status("SCHEDULED")
                .gameTime(LocalDateTime.of(2024, 12, 22, 20, 20))
                .broadcastNetwork("NBC")
                .build());

        games.add(NFLGameDocument.builder()
                .gameId("2024-" + week + "-MNF")
                .season(currentSeason)
                .week(week)
                .homeTeam("SF")
                .awayTeam("DAL")
                .status("SCHEDULED")
                .gameTime(LocalDateTime.of(2024, 12, 23, 20, 15))
                .broadcastNetwork("ESPN")
                .build());

        games.add(NFLGameDocument.builder()
                .gameId("2024-" + week + "-TNF")
                .season(currentSeason)
                .week(week)
                .homeTeam("PHI")
                .awayTeam("SEA")
                .status("SCHEDULED")
                .gameTime(LocalDateTime.of(2024, 12, 19, 20, 15))
                .broadcastNetwork("Amazon")
                .build());

        gameRepository.saveAll(games);
    }

    @Then("some games have broadcast network information")
    public void someGamesHaveBroadcastNetworkInformation() {
        assertNotNull(gamesResponse);
        assertFalse(gamesResponse.isEmpty());
        assertTrue(gamesResponse.stream().anyMatch(g -> g.getBroadcastNetwork() != null));
    }

    @Then("networks include CBS, FOX, NBC, ESPN, or Amazon")
    public void networksIncludeCbsFoxNbcEspnOrAmazon() {
        assertNotNull(gamesResponse);
        List<String> validNetworks = List.of("CBS", "FOX", "NBC", "ESPN", "Amazon");
        assertTrue(gamesResponse.stream()
                .filter(g -> g.getBroadcastNetwork() != null)
                .allMatch(g -> validNetworks.contains(g.getBroadcastNetwork())));
    }

    // Helper methods
    private void seedBasicTestGames() {
        List<NFLGameDocument> games = new ArrayList<>();

        games.add(NFLGameDocument.builder()
                .gameId("2024-1-KC-BUF")
                .season(2024)
                .week(1)
                .homeTeam("BUF")
                .awayTeam("KC")
                .gameTime(LocalDateTime.of(2024, 9, 5, 20, 20))
                .status("SCHEDULED")
                .build());

        gameRepository.saveAll(games);
    }

    private void seedGamesForWeek(Integer season, Integer week) {
        seedGamesForWeek(season, week, 16);
    }

    private void seedGamesForWeek(Integer season, Integer week, Integer gameCount) {
        List<NFLGameDocument> games = new ArrayList<>();
        String[] teams = {"KC", "BUF", "SF", "PHI", "DAL", "MIA", "DET", "GB",
                "SEA", "LAR", "MIN", "CHI", "BAL", "CIN", "CLE", "PIT",
                "JAX", "TEN", "HOU", "IND", "LV", "LAC", "DEN", "NYJ",
                "NE", "NYG", "WAS", "ARI", "ATL", "NO", "TB", "CAR"};

        for (int i = 0; i < gameCount; i++) {
            games.add(NFLGameDocument.builder()
                    .gameId(season + "-" + week + "-" + teams[i % 32] + "-" + teams[(i + 1) % 32])
                    .season(season)
                    .week(week)
                    .homeTeam(teams[i % 32])
                    .awayTeam(teams[(i + 1) % 32])
                    .status("SCHEDULED")
                    .gameTime(LocalDateTime.of(2024, 12, 15 + (week - 15), 13, 0).plusHours(i % 4))
                    .build());
        }

        gameRepository.saveAll(games);
    }
}
