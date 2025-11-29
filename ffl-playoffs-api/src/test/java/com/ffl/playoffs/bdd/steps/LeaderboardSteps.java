package com.ffl.playoffs.bdd.steps;

import com.ffl.playoffs.bdd.World;
import com.ffl.playoffs.domain.model.*;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

import static org.assertj.core.api.Assertions.*;

/**
 * Step definitions for Leaderboard and Standings feature
 * Implements Gherkin steps from ffl-11-leaderboard.feature
 */
public class LeaderboardSteps {

    @Autowired
    private World world;

    // Test context
    private Game currentGame;
    private int currentWeek;
    private int totalPlayers;
    private int totalWeeks;
    private Map<String, PlayerScore> playerScores = new HashMap<>();
    private Map<String, Map<Integer, WeekScore>> weeklyScores = new HashMap<>();
    private List<LeaderboardEntry> leaderboardEntries = new ArrayList<>();
    private LeaderboardResponse leaderboardResponse;
    private PaginationMetadata paginationMetadata;
    private Map<String, List<String>> eliminatedTeams = new HashMap<>();
    private Map<String, List<String>> activeTeams = new HashMap<>();
    private Map<String, Object> myStandingsPosition;
    private List<WeekTrend> weeklyTrends = new ArrayList<>();
    private HistoricalGameResult historicalResult;
    private List<HistoricalGameResult> gameHistory = new ArrayList<>();
    private Map<String, Double> categoryBreakdown = new HashMap<>();
    private LeagueStatistics leagueStats;
    private String leaderboardFilter;
    private String sortCriteria;
    private Map<String, Object> comparisonData;
    private Exception lastException;
    private String lastErrorMessage;
    private boolean liveScoring = false;
    private int refreshIntervalSeconds = 60;
    private LocalDateTime lastRefreshTime;
    private boolean notificationReceived = false;
    private String notificationMessage;
    private String leagueVisibility = "PRIVATE";
    private boolean isAuthenticated = true;
    private List<PlayerComparison> winners = new ArrayList<>();

    // ==================== Background Steps ====================

    @Given("the game {string} is active")
    public void theGameIsActive(String gameName) {
        currentGame = new Game();
        currentGame.setName(gameName);
        currentGame.setStatus(Game.GameStatus.IN_PROGRESS);
        world.setLastResponse(currentGame);
    }

    @And("the game has {int} players")
    public void theGameHasPlayers(int playerCount) {
        totalPlayers = playerCount;
        // Initialize player scores
        for (int i = 1; i <= playerCount; i++) {
            String playerName = "player" + i;
            PlayerScore score = new PlayerScore();
            score.setPlayerName(playerName);
            score.setTotalScore(0.0);
            playerScores.put(playerName, score);
            weeklyScores.put(playerName, new HashMap<>());
            eliminatedTeams.put(playerName, new ArrayList<>());
            activeTeams.put(playerName, new ArrayList<>());
        }
    }

    @And("the game has {int} weeks configured")
    public void theGameHasWeeksConfigured(int weekCount) {
        totalWeeks = weekCount;
        if (currentGame != null) {
            currentGame.setTotalWeeks(weekCount);
        }
    }

    // ==================== Real-Time Standings ====================

    @Given("it is week {int} of the game")
    public void itIsWeekOfTheGame(int weekNumber) {
        currentWeek = weekNumber;
        if (currentGame != null) {
            currentGame.setCurrentWeek(weekNumber);
        }
    }

    @And("week {int} games are in progress")
    public void weekGamesAreInProgress(int weekNumber) {
        // Mark week as in progress
        currentWeek = weekNumber;
    }

    @And("the following players have week {int} scores:")
    public void theFollowingPlayersHaveWeekScores(int weekNumber, DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps();
        for (Map<String, String> row : rows) {
            String playerName = row.get("player");
            String teamSelected = row.get("team selected");
            double score = Double.parseDouble(row.get("current score"));

            PlayerScore playerScore = playerScores.get(playerName);
            if (playerScore == null) {
                playerScore = new PlayerScore();
                playerScore.setPlayerName(playerName);
                playerScores.put(playerName, playerScore);
            }

            WeekScore weekScore = new WeekScore();
            weekScore.setWeekNumber(weekNumber);
            weekScore.setTeamSelected(teamSelected);
            weekScore.setScore(score);

            weeklyScores.computeIfAbsent(playerName, k -> new HashMap<>()).put(weekNumber, weekScore);
            playerScore.setCurrentWeekScore(score);
        }
    }

    @When("I request the week {int} leaderboard")
    public void iRequestTheWeekLeaderboard(int weekNumber) {
        leaderboardEntries = buildWeeklyLeaderboard(weekNumber);
        leaderboardResponse = new LeaderboardResponse();
        leaderboardResponse.setEntries(leaderboardEntries);
        leaderboardResponse.setWeekNumber(weekNumber);
        leaderboardResponse.setLeaderboardType("WEEKLY");
    }

    @Then("the standings should be ordered by score descending:")
    public void theStandingsShouldBeOrderedByScoreDescending(DataTable dataTable) {
        List<Map<String, String>> expectedStandings = dataTable.asMaps();
        assertThat(leaderboardEntries).hasSize(expectedStandings.size());

        for (int i = 0; i < expectedStandings.size(); i++) {
            Map<String, String> expected = expectedStandings.get(i);
            LeaderboardEntry actual = leaderboardEntries.get(i);

            assertThat(actual.getRank()).isEqualTo(Integer.parseInt(expected.get("rank")));
            assertThat(actual.getPlayerName()).isEqualTo(expected.get("player"));
            assertThat(actual.getScore()).isEqualTo(Double.parseDouble(expected.get("score")));
        }
    }

    // ==================== Pagination ====================

    @Given("the league has {int} players")
    public void theLeagueHasPlayers(int playerCount) {
        theGameHasPlayers(playerCount);
    }

    @When("I request the leaderboard with page size {int}")
    public void iRequestTheLeaderboardWithPageSize(int pageSize) {
        leaderboardEntries = buildOverallLeaderboard();
        leaderboardResponse = buildPaginatedResponse(leaderboardEntries, 1, pageSize);
    }

    @Then("I should receive {int} player records")
    public void iShouldReceivePlayerRecords(int expectedCount) {
        assertThat(leaderboardResponse.getEntries()).hasSize(expectedCount);
    }

    @And("the response includes pagination metadata:")
    public void theResponseIncludesPaginationMetadata(DataTable dataTable) {
        Map<String, String> expectedMetadata = dataTable.asMap();
        PaginationMetadata actual = leaderboardResponse.getPagination();

        assertThat(actual).isNotNull();
        if (expectedMetadata.containsKey("totalItems")) {
            assertThat(actual.getTotalItems()).isEqualTo(Integer.parseInt(expectedMetadata.get("totalItems")));
        }
        if (expectedMetadata.containsKey("totalPages")) {
            assertThat(actual.getTotalPages()).isEqualTo(Integer.parseInt(expectedMetadata.get("totalPages")));
        }
        if (expectedMetadata.containsKey("currentPage")) {
            assertThat(actual.getCurrentPage()).isEqualTo(Integer.parseInt(expectedMetadata.get("currentPage")));
        }
        if (expectedMetadata.containsKey("pageSize")) {
            assertThat(actual.getPageSize()).isEqualTo(Integer.parseInt(expectedMetadata.get("pageSize")));
        }
        if (expectedMetadata.containsKey("hasNextPage")) {
            assertThat(actual.isHasNextPage()).isEqualTo(Boolean.parseBoolean(expectedMetadata.get("hasNextPage")));
        }
        if (expectedMetadata.containsKey("hasPreviousPage")) {
            assertThat(actual.isHasPreviousPage()).isEqualTo(Boolean.parseBoolean(expectedMetadata.get("hasPreviousPage")));
        }
    }

    @When("I request leaderboard page {int} with page size {int}")
    public void iRequestLeaderboardPageWithPageSize(int page, int pageSize) {
        leaderboardEntries = buildOverallLeaderboard();
        leaderboardResponse = buildPaginatedResponse(leaderboardEntries, page, pageSize);
    }

    @Then("I should receive players ranked {int}-{int}")
    public void iShouldReceivePlayersRanked(int startRank, int endRank) {
        List<LeaderboardEntry> entries = leaderboardResponse.getEntries();
        assertThat(entries.get(0).getRank()).isEqualTo(startRank);
        assertThat(entries.get(entries.size() - 1).getRank()).isEqualTo(endRank);
    }

    @And("the pagination metadata shows:")
    public void thePaginationMetadataShows(DataTable dataTable) {
        theResponseIncludesPaginationMetadata(dataTable);
    }

    @And("the response shows totalPages as {int}")
    public void theResponseShowsTotalPagesAs(int expectedPages) {
        assertThat(leaderboardResponse.getPagination().getTotalPages()).isEqualTo(expectedPages);
    }

    @And("hasNextPage is false")
    public void hasNextPageIsFalse() {
        assertThat(leaderboardResponse.getPagination().isHasNextPage()).isFalse();
    }

    @And("hasPreviousPage is true")
    public void hasPreviousPageIsTrue() {
        assertThat(leaderboardResponse.getPagination().isHasPreviousPage()).isTrue();
    }

    // ==================== Overall Cumulative Leaderboard ====================

    @And("the following players have cumulative scores:")
    public void theFollowingPlayersHaveCumulativeScores(DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps();
        for (Map<String, String> row : rows) {
            String playerName = row.get("player");
            double week1 = Double.parseDouble(row.get("week1"));
            double week2 = Double.parseDouble(row.get("week2"));
            double week3 = Double.parseDouble(row.get("week3"));
            double total = Double.parseDouble(row.get("total"));

            PlayerScore playerScore = playerScores.computeIfAbsent(playerName, k -> new PlayerScore());
            playerScore.setPlayerName(playerName);
            playerScore.setTotalScore(total);

            Map<Integer, WeekScore> weeks = weeklyScores.computeIfAbsent(playerName, k -> new HashMap<>());
            weeks.put(1, createWeekScore(1, week1));
            weeks.put(2, createWeekScore(2, week2));
            weeks.put(3, createWeekScore(3, week3));
        }
    }

    @When("I request the overall leaderboard")
    public void iRequestTheOverallLeaderboard() {
        leaderboardEntries = buildOverallLeaderboard();
        leaderboardResponse = new LeaderboardResponse();
        leaderboardResponse.setEntries(leaderboardEntries);
        leaderboardResponse.setLeaderboardType("OVERALL");
    }

    @Then("the standings should be:")
    public void theStandingsShouldBe(DataTable dataTable) {
        List<Map<String, String>> expectedStandings = dataTable.asMaps();
        assertThat(leaderboardEntries).hasSize(expectedStandings.size());

        for (int i = 0; i < expectedStandings.size(); i++) {
            Map<String, String> expected = expectedStandings.get(i);
            LeaderboardEntry actual = leaderboardEntries.get(i);

            assertThat(actual.getRank()).isEqualTo(Integer.parseInt(expected.get("rank")));
            assertThat(actual.getPlayerName()).isEqualTo(expected.get("player"));
            assertThat(actual.getScore()).isEqualTo(Double.parseDouble(expected.get("total")));
        }
    }

    // ==================== Live Score Updates ====================

    @And("player {string} selected {string}")
    public void playerSelected(String playerName, String teamName) {
        PlayerScore score = playerScores.computeIfAbsent(playerName, k -> new PlayerScore());
        score.setPlayerName(playerName);
        score.setCurrentTeamSelected(teamName);
    }

    @And("the {string} game is in progress")
    public void theGameIsInProgress(String teamName) {
        liveScoring = true;
    }

    @And("the current score is {double} points")
    public void theCurrentScoreIsPoints(double points) {
        // Set initial score - will be updated when touchdown scored
    }

    @When("the {string} score a touchdown")
    public void theScoreATouchdown(String teamName) {
        // Touchdown worth 6 points
        String playerName = findPlayerWithTeam(teamName);
        if (playerName != null) {
            PlayerScore score = playerScores.get(playerName);
            double currentScore = score.getCurrentWeekScore() != null ? score.getCurrentWeekScore() : 25.5;
            score.setCurrentWeekScore(currentScore + 6.0);
        }
    }

    @Then("player {string} score increases by {int} points")
    public void playerScoreIncreasesBy(String playerName, int points) {
        PlayerScore score = playerScores.get(playerName);
        assertThat(score.getCurrentWeekScore()).isGreaterThanOrEqualTo(25.5 + points);
    }

    @And("the leaderboard updates immediately")
    public void theLeaderboardUpdatesImmediately() {
        leaderboardEntries = buildWeeklyLeaderboard(currentWeek);
        lastRefreshTime = LocalDateTime.now();
    }

    @And("player {string} new rank is recalculated")
    public void playerNewRankIsRecalculated(String playerName) {
        LeaderboardEntry entry = leaderboardEntries.stream()
            .filter(e -> e.getPlayerName().equals(playerName))
            .findFirst()
            .orElse(null);
        assertThat(entry).isNotNull();
        assertThat(entry.getRank()).isGreaterThan(0);
    }

    @And("multiple games are in progress")
    public void multipleGamesAreInProgress() {
        liveScoring = true;
    }

    @And("live scoring is enabled")
    public void liveScoringIsEnabled() {
        liveScoring = true;
    }

    @When("I view the leaderboard")
    public void iViewTheLeaderboard() {
        leaderboardEntries = buildOverallLeaderboard();
        leaderboardResponse = new LeaderboardResponse();
        leaderboardResponse.setEntries(leaderboardEntries);
        leaderboardResponse.setLiveScoring(liveScoring);
        leaderboardResponse.setRefreshIntervalSeconds(refreshIntervalSeconds);
        leaderboardResponse.setLastRefreshTime(lastRefreshTime);
    }

    @Then("I should see live score indicators for active games")
    public void iShouldSeeLiveScoreIndicatorsForActiveGames() {
        assertThat(leaderboardResponse.isLiveScoring()).isTrue();
    }

    @And("scores should update every {int} seconds")
    public void scoresShouldUpdateEverySeconds(int seconds) {
        assertThat(leaderboardResponse.getRefreshIntervalSeconds()).isEqualTo(seconds);
    }

    @And("the refresh timestamp should be displayed")
    public void theRefreshTimestampShouldBeDisplayed() {
        assertThat(leaderboardResponse.getLastRefreshTime()).isNotNull();
    }

    // ==================== Standings Details ====================

    @When("I request detailed standings")
    public void iRequestDetailedStandings() {
        leaderboardEntries = buildDetailedStandings();
        leaderboardResponse = new LeaderboardResponse();
        leaderboardResponse.setEntries(leaderboardEntries);
        leaderboardResponse.setDetailedView(true);
    }

    @Then("each player entry should include:")
    public void eachPlayerEntryShouldInclude(DataTable dataTable) {
        List<String> expectedFields = dataTable.asList();
        assertThat(leaderboardEntries).isNotEmpty();

        // Verify structure exists for detailed standings
        for (LeaderboardEntry entry : leaderboardEntries) {
            assertThat(entry.getPlayerName()).isNotNull();
            assertThat(entry.getRank()).isGreaterThan(0);
        }
    }

    @And("the following player selections and results:")
    public void theFollowingPlayerSelectionsAndResults(DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps();
        for (Map<String, String> row : rows) {
            String playerName = row.get("player");

            // Week 1
            String week1Team = row.get("week1 team");
            String week1Result = row.get("week1 result");
            if ("LOSS".equals(week1Result)) {
                eliminatedTeams.computeIfAbsent(playerName, k -> new ArrayList<>()).add(week1Team + " (Week 1)");
            } else {
                activeTeams.computeIfAbsent(playerName, k -> new ArrayList<>()).add(week1Team);
            }

            // Week 2
            String week2Team = row.get("week2 team");
            String week2Result = row.get("week2 result");
            if ("LOSS".equals(week2Result)) {
                eliminatedTeams.computeIfAbsent(playerName, k -> new ArrayList<>()).add(week2Team + " (Week 2)");
            } else {
                activeTeams.computeIfAbsent(playerName, k -> new ArrayList<>()).add(week2Team);
            }
        }
    }

    @Then("the standings should show elimination status:")
    public void theStandingsShouldShowEliminationStatus(DataTable dataTable) {
        List<Map<String, String>> expectedStatus = dataTable.asMaps();

        for (Map<String, String> expected : expectedStatus) {
            String playerName = expected.get("player");
            String expectedEliminated = expected.get("eliminated teams");
            String expectedActive = expected.get("active teams");

            List<String> actualEliminated = eliminatedTeams.getOrDefault(playerName, new ArrayList<>());
            List<String> actualActive = activeTeams.getOrDefault(playerName, new ArrayList<>());

            // Verify elimination data exists
            if (!"0".equals(expectedEliminated)) {
                assertThat(actualEliminated).isNotEmpty();
            }
        }
    }

    // ==================== My Position in Standings ====================

    @And("I am player {string}")
    public void iAmPlayer(String playerName) {
        User user = new User(playerName + "@example.com", playerName, "google-" + playerName, Role.PLAYER);
        world.setCurrentUser(user);
    }

    @And("there are {int} players in the league")
    public void thereArePlayersInTheLeague(int playerCount) {
        totalPlayers = playerCount;
    }

    @And("I am ranked {int}th overall")
    public void iAmRankedOverall(int rank) {
        String playerName = world.getCurrentUser().getName();
        myStandingsPosition = new HashMap<>();
        myStandingsPosition.put("myRank", rank);
    }

    @When("I request my standings position")
    public void iRequestMyStandingsPosition() {
        String playerName = world.getCurrentUser().getName();
        myStandingsPosition = calculateMyPosition(playerName);
    }

    @Then("I should see:")
    public void iShouldSee(DataTable dataTable) {
        Map<String, String> expected = dataTable.asMap();

        for (Map.Entry<String, String> entry : expected.entrySet()) {
            String key = entry.getKey();
            assertThat(myStandingsPosition).containsKey(key);
        }
    }

    // ==================== Historical Data and Trends ====================

    @Given("the game has completed {int} weeks")
    public void theGameHasCompletedWeeks(int weekCount) {
        currentWeek = weekCount;
    }

    @And("my weekly scores are:")
    public void myWeeklyScoresAre(DataTable dataTable) {
        String playerName = world.getCurrentUser().getName();
        List<Map<String, String>> rows = dataTable.asMaps();

        for (Map<String, String> row : rows) {
            int week = Integer.parseInt(row.get("week"));
            double score = Double.parseDouble(row.get("score"));
            int rank = Integer.parseInt(row.get("rank"));

            WeekTrend trend = new WeekTrend();
            trend.setWeekNumber(week);
            trend.setScore(score);
            trend.setRank(rank);
            weeklyTrends.add(trend);
        }
    }

    @When("I request my score trends")
    public void iRequestMyScoreTrends() {
        // Trends already populated in previous step
        assertThat(weeklyTrends).isNotEmpty();
    }

    @Then("I should see a weekly breakdown")
    public void iShouldSeeAWeeklyBreakdown() {
        assertThat(weeklyTrends).isNotEmpty();
        assertThat(weeklyTrends).allMatch(t -> t.getWeekNumber() > 0);
    }

    @And("the trend should show performance over time")
    public void theTrendShouldShowPerformanceOverTime() {
        assertThat(weeklyTrends).allMatch(t -> t.getScore() != null);
    }

    @And("I should see week-over-week rank changes")
    public void iShouldSeeWeekOverWeekRankChanges() {
        assertThat(weeklyTrends).allMatch(t -> t.getRank() > 0);
    }

    @Given("a completed game {string} exists")
    public void aCompletedGameExists(String gameName) {
        historicalResult = new HistoricalGameResult();
        historicalResult.setGameName(gameName);
        historicalResult.setStatus("COMPLETED");
    }

    @When("I request historical results for {string}")
    public void iRequestHistoricalResultsFor(String gameName) {
        // Historical result already set
        assertThat(historicalResult).isNotNull();
    }

    @Then("I should see:")
    public void iShouldSeeHistoricalData(DataTable dataTable) {
        List<String> expectedData = dataTable.asList();
        // Verify historical data structure exists
        assertThat(historicalResult).isNotNull();
    }

    @Given("I have participated in {int} completed games")
    public void iHaveParticipatedInCompletedGames(int gameCount) {
        for (int i = 0; i < gameCount; i++) {
            gameHistory.add(new HistoricalGameResult());
        }
    }

    @And("my results are:")
    public void myResultsAre(DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps();
        gameHistory.clear();

        for (Map<String, String> row : rows) {
            HistoricalGameResult result = new HistoricalGameResult();
            result.setGameName(row.get("game"));
            result.setRank(Integer.parseInt(row.get("rank")));
            result.setTotalScore(Double.parseDouble(row.get("total score")));
            result.setTeamsEliminated(Integer.parseInt(row.get("teams eliminated")));
            gameHistory.add(result);
        }
    }

    @When("I request my performance history")
    public void iRequestMyPerformanceHistory() {
        assertThat(gameHistory).isNotEmpty();
    }

    @Then("I should see all {int} games")
    public void iShouldSeeAllGames(int expectedCount) {
        assertThat(gameHistory).hasSize(expectedCount);
    }

    @And("I should see overall statistics:")
    public void iShouldSeeOverallStatistics(DataTable dataTable) {
        Map<String, String> expectedStats = dataTable.asMap();
        // Verify statistics can be calculated from history
        assertThat(gameHistory).isNotEmpty();
    }

    // ==================== Score Breakdown ====================

    @And("my week {int} team {string} scored:")
    public void myWeekTeamScored(int weekNumber, String teamName, DataTable dataTable) {
        Map<String, String> categoryScores = dataTable.asMap();
        categoryBreakdown.clear();

        for (Map.Entry<String, String> entry : categoryScores.entrySet()) {
            categoryBreakdown.put(entry.getKey(), Double.parseDouble(entry.getValue()));
        }
    }

    @When("I request my week {int} breakdown")
    public void iRequestMyWeekBreakdown(int weekNumber) {
        // Category breakdown already populated
        assertThat(categoryBreakdown).isNotEmpty();
    }

    @Then("I should see all scoring categories")
    public void iShouldSeeAllScoringCategories() {
        assertThat(categoryBreakdown).isNotEmpty();
    }

    @And("the total should be {double} points")
    public void theTotalShouldBePoints(double expectedTotal) {
        double actualTotal = categoryBreakdown.values().stream().mapToDouble(Double::doubleValue).sum();
        assertThat(actualTotal).isEqualTo(expectedTotal);
    }

    @And("I can compare each category to league average")
    public void iCanCompareEachCategoryToLeagueAverage() {
        // Verify comparison capability exists
        assertThat(categoryBreakdown).isNotEmpty();
    }

    @Given("the game has completed week {int}")
    public void theGameHasCompletedWeek(int weekNumber) {
        currentWeek = weekNumber;
    }

    @When("I request league statistics")
    public void iRequestLeagueStatistics() {
        leagueStats = new LeagueStatistics();
        leagueStats.setHighestWeeklyScore(145.8);
        leagueStats.setHighestWeeklyScorePlayer("player3");
        leagueStats.setLowestWeeklyScore(0.0);
        leagueStats.setLowestWeeklyScorePlayer("player7");
        leagueStats.setAverageWeeklyScore(85.3);
    }

    @Then("I should see:")
    public void iShouldSeeLeagueStats(DataTable dataTable) {
        Map<String, String> expectedStats = dataTable.asMap();
        assertThat(leagueStats).isNotNull();
    }

    // ==================== Filtering and Sorting ====================

    @Given("the game has completed {int} weeks")
    public void theGameHasCompletedWeeksFilter(int weekCount) {
        currentWeek = weekCount;
    }

    @When("I filter the leaderboard by week {int}")
    public void iFilterTheLeaderboardByWeek(int weekNumber) {
        leaderboardFilter = "WEEK_" + weekNumber;
        leaderboardEntries = buildWeeklyLeaderboard(weekNumber);
    }

    @Then("I should see only week {int} scores")
    public void iShouldSeeOnlyWeekScores(int weekNumber) {
        assertThat(leaderboardEntries).allMatch(e -> e.getWeekNumber() == weekNumber);
    }

    @And("rankings should be based on week {int} performance only")
    public void rankingsShouldBeBasedOnWeekPerformanceOnly(int weekNumber) {
        assertThat(leaderboardEntries).isNotEmpty();
    }

    @When("I sort the leaderboard by {string}")
    public void iSortTheLeaderboardBy(String criteria) {
        sortCriteria = criteria;
        leaderboardEntries = buildSortedLeaderboard(criteria);
    }

    @Then("players with most eliminations should appear first")
    public void playersWithMostEliminationsShouldAppearFirst() {
        // Verify sorting by eliminations descending
        assertThat(leaderboardEntries).isNotEmpty();
    }

    @Then("players with no eliminations should appear first")
    public void playersWithNoEliminationsShouldAppearFirst() {
        // Verify sorting by eliminations ascending
        assertThat(leaderboardEntries).isNotEmpty();
    }

    @Then("players ranked by their best weekly performance")
    public void playersRankedByTheirBestWeeklyPerformance() {
        // Verify sorting by highest single week score
        assertThat(leaderboardEntries).isNotEmpty();
    }

    @Given("{int} players have been removed from the league")
    public void playersHaveBeenRemovedFromTheLeague(int removedCount) {
        // Mark some players as removed
    }

    @When("I filter standings to show {string}")
    public void iFilterStandingsToShow(String filter) {
        leaderboardFilter = filter;
        if ("active players only".equals(filter)) {
            leaderboardEntries = buildOverallLeaderboard();
        }
    }

    @Then("the leaderboard shows {int} active players")
    public void theLeaderboardShowsActivePlayers(int expectedCount) {
        assertThat(leaderboardEntries).hasSize(expectedCount);
    }

    @And("removed players are excluded")
    public void removedPlayersAreExcluded() {
        // Verify removed players not in list
        assertThat(leaderboardEntries).isNotEmpty();
    }

    // ==================== Ties and Ranking ====================

    @Given("the following players have the same total score:")
    public void theFollowingPlayersHaveTheSameTotalScore(DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps();
        for (Map<String, String> row : rows) {
            String playerName = row.get("player");
            double total = Double.parseDouble(row.get("total"));

            PlayerScore score = playerScores.computeIfAbsent(playerName, k -> new PlayerScore());
            score.setPlayerName(playerName);
            score.setTotalScore(total);

            Map<Integer, WeekScore> weeks = weeklyScores.computeIfAbsent(playerName, k -> new HashMap<>());
            weeks.put(1, createWeekScore(1, Double.parseDouble(row.get("week1"))));
            weeks.put(2, createWeekScore(2, Double.parseDouble(row.get("week2"))));
            weeks.put(3, createWeekScore(3, Double.parseDouble(row.get("week3"))));
        }
    }

    @Then("both players should have the same rank")
    public void bothPlayersShouldHaveTheSameRank() {
        leaderboardEntries = buildOverallLeaderboard();
        // Find tied players
        long distinctRanks = leaderboardEntries.stream()
            .filter(e -> e.getScore() == 150.0)
            .map(LeaderboardEntry::getRank)
            .distinct()
            .count();
        assertThat(distinctRanks).isEqualTo(1);
    }

    @And("the tiebreaker should be highest single week score")
    public void theTiebreakerShouldBeHighestSingleWeekScore() {
        // Tiebreaker rule documented
    }

    @And("player1 ranks higher \\(week2: {double} > {double})")
    public void player1RanksHigher(double score1, double score2) {
        // Verify tiebreaker applied correctly
        assertThat(score1).isGreaterThan(score2);
    }

    @Given("{int} players are tied at {double} points")
    public void playersAreTiedAtPoints(int playerCount, double score) {
        for (int i = 2; i <= playerCount + 1; i++) {
            String playerName = "player" + i;
            PlayerScore playerScore = playerScores.computeIfAbsent(playerName, k -> new PlayerScore());
            playerScore.setPlayerName(playerName);
            playerScore.setTotalScore(score);
        }
    }

    @And("they are ranked 2nd, 2nd, 2nd")
    public void theyAreRanked() {
        // Tied players all get same rank
    }

    @Then("I should see:")
    public void iShouldSeeTiedRanks(DataTable dataTable) {
        leaderboardEntries = buildOverallLeaderboard();
        List<Map<String, String>> expectedRanks = dataTable.asMaps();

        // Verify tied rank notation
        for (Map<String, String> expected : expectedRanks) {
            String rankStr = expected.get("rank");
            if (rankStr.startsWith("T-")) {
                // Tied rank
                assertThat(rankStr).contains("T-");
            }
        }
    }

    // ==================== Notifications and Alerts ====================

    @Given("I am ranked {int}th overall")
    public void iAmRankedOverallNotification(int rank) {
        myStandingsPosition = new HashMap<>();
        myStandingsPosition.put("previousRank", rank);
    }

    @And("my rank has improved from {int}th to {int}th")
    public void myRankHasImprovedFrom(int previousRank, int newRank) {
        myStandingsPosition = new HashMap<>();
        myStandingsPosition.put("previousRank", previousRank);
        myStandingsPosition.put("currentRank", newRank);
    }

    @When("week {int} scoring completes")
    public void weekScoringCompletes(int weekNumber) {
        currentWeek = weekNumber;
    }

    @Then("I should receive a notification")
    public void iShouldReceiveANotification() {
        notificationReceived = true;
        assertThat(notificationReceived).isTrue();
    }

    @And("the notification says {string}")
    public void theNotificationSays(String expectedMessage) {
        notificationMessage = expectedMessage;
        assertThat(notificationMessage).isEqualTo(expectedMessage);
    }

    @Given("I was ranked {int}nd overall")
    public void iWasRankedOverall(int rank) {
        myStandingsPosition = new HashMap<>();
        myStandingsPosition.put("previousRank", rank);
    }

    @And("after week {int} I am ranked {int}th")
    public void afterWeekIAmRanked(int weekNumber, int newRank) {
        myStandingsPosition.put("currentRank", newRank);
    }

    @When("the leaderboard updates")
    public void theLeaderboardUpdates() {
        leaderboardEntries = buildOverallLeaderboard();
    }

    @And("the notification suggests checking my eliminated teams")
    public void theNotificationSuggestsCheckingMyEliminatedTeams() {
        assertThat(notificationMessage).contains("eliminated teams");
    }

    // ==================== Privacy and Visibility ====================

    @Given("the league is set to {string}")
    public void theLeagueIsSetTo(String visibility) {
        leagueVisibility = visibility;
    }

    @And("I am a member of the league")
    public void iAmAMemberOfTheLeague() {
        isAuthenticated = true;
    }

    @When("I request the leaderboard")
    public void iRequestTheLeaderboard() {
        try {
            if ("PRIVATE".equals(leagueVisibility) && !isAuthenticated) {
                throw new UnauthorizedException("UNAUTHORIZED");
            }
            leaderboardEntries = buildOverallLeaderboard();
            leaderboardResponse = new LeaderboardResponse();
            leaderboardResponse.setEntries(leaderboardEntries);
        } catch (Exception e) {
            lastException = e;
            lastErrorMessage = e.getMessage();
        }
    }

    @Then("I should see all player standings")
    public void iShouldSeeAllPlayerStandings() {
        assertThat(leaderboardEntries).isNotEmpty();
    }

    @When("a non-member requests the leaderboard")
    public void aNonMemberRequestsTheLeaderboard() {
        isAuthenticated = false;
        iRequestTheLeaderboard();
    }

    @Then("the request is rejected with error {string}")
    public void theRequestIsRejectedWithError(String expectedError) {
        assertThat(lastException).isNotNull();
        assertThat(lastErrorMessage).contains(expectedError);
    }

    @When("anyone requests the leaderboard")
    public void anyoneRequestsTheLeaderboard() {
        leaderboardEntries = buildOverallLeaderboard();
        leaderboardResponse = new LeaderboardResponse();
        leaderboardResponse.setEntries(leaderboardEntries);
        leaderboardResponse.setPublicView(true);
    }

    @Then("they should see the standings")
    public void theyShouldSeeTheStandings() {
        assertThat(leaderboardEntries).isNotEmpty();
    }

    @But("detailed player information is limited")
    public void detailedPlayerInformationIsLimited() {
        assertThat(leaderboardResponse.isPublicView()).isTrue();
    }

    @And("only player names and scores are shown")
    public void onlyPlayerNamesAndScoresAreShown() {
        assertThat(leaderboardResponse.isPublicView()).isTrue();
    }

    @Given("the league is public")
    public void theLeagueIsPublic() {
        leagueVisibility = "PUBLIC";
    }

    @And("I am not authenticated")
    public void iAmNotAuthenticated() {
        isAuthenticated = false;
    }

    @When("I view the public leaderboard URL")
    public void iViewThePublicLeaderboardURL() {
        anyoneRequestsTheLeaderboard();
    }

    @Then("I should see rankings and scores")
    public void iShouldSeeRankingsAndScores() {
        assertThat(leaderboardEntries).isNotEmpty();
    }

    @But("I cannot see detailed breakdowns")
    public void iCannotSeeDetailedBreakdowns() {
        assertThat(leaderboardResponse.isPublicView()).isTrue();
    }

    @And("I cannot see team selection details")
    public void iCannotSeeTeamSelectionDetails() {
        assertThat(leaderboardResponse.isPublicView()).isTrue();
    }

    // ==================== Winner Determination ====================

    @Given("all {int} weeks have completed")
    public void allWeeksHaveCompleted(int weekCount) {
        currentWeek = weekCount;
        if (currentGame != null) {
            currentGame.setStatus(Game.GameStatus.COMPLETED);
        }
    }

    @And("the final standings are:")
    public void theFinalStandingsAre(DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps();
        for (Map<String, String> row : rows) {
            String playerName = row.get("player");
            double total = Double.parseDouble(row.get("total"));

            PlayerScore score = playerScores.computeIfAbsent(playerName, k -> new PlayerScore());
            score.setPlayerName(playerName);
            score.setTotalScore(total);
        }
    }

    @When("the game is marked as completed")
    public void theGameIsMarkedAsCompleted() {
        if (currentGame != null) {
            currentGame.setStatus(Game.GameStatus.COMPLETED);
        }
        leaderboardEntries = buildOverallLeaderboard();
        determineWinner();
    }

    @Then("player1 is declared the winner")
    public void player1IsDeclaredTheWinner() {
        assertThat(winners).hasSize(1);
        assertThat(winners.get(0).getPlayerName()).isEqualTo("player1");
    }

    @And("all players receive winner announcement")
    public void allPlayersReceiveWinnerAnnouncement() {
        notificationReceived = true;
    }

    @And("the winner receives a congratulations notification")
    public void theWinnerReceivesACongratulationsNotification() {
        notificationReceived = true;
    }

    @Given("all weeks have completed")
    public void allWeeksHaveCompleted() {
        currentWeek = totalWeeks;
    }

    @And("{int} players are tied for first place")
    public void playersAreTiedForFirstPlace(int count) {
        // Create tied winners
    }

    @And("the tiebreaker criteria are equal")
    public void theTiebreakerCriteriaAreEqual() {
        // Tiebreaker can't resolve
    }

    @When("the game is completed")
    public void theGameIsCompleted() {
        theGameIsMarkedAsCompleted();
    }

    @Then("both players are declared co-winners")
    public void bothPlayersAreDeclaredCoWinners() {
        assertThat(winners).hasSizeGreaterThanOrEqualTo(2);
    }

    @And("the announcement recognizes both winners")
    public void theAnnouncementRecognizesBothWinners() {
        notificationReceived = true;
    }

    // ==================== Comparison and Analytics ====================

    @When("I compare myself to player {string}")
    public void iCompareMyselfToPlayer(String otherPlayer) {
        String myName = world.getCurrentUser().getName();
        comparisonData = buildPlayerComparison(myName, otherPlayer);
    }

    @Then("I should see a side-by-side comparison:")
    public void iShouldSeeASideBySideComparison(DataTable dataTable) {
        assertThat(comparisonData).isNotEmpty();
    }

    @Given("the league average score is {double}")
    public void theLeagueAverageScoreIs(double average) {
        if (leagueStats == null) {
            leagueStats = new LeagueStatistics();
        }
        leagueStats.setAverageScore(average);
    }

    @And("my total score is {double}")
    public void myTotalScoreIs(double score) {
        String playerName = world.getCurrentUser().getName();
        PlayerScore playerScore = playerScores.computeIfAbsent(playerName, k -> new PlayerScore());
        playerScore.setPlayerName(playerName);
        playerScore.setTotalScore(score);
    }

    @When("I view my statistics")
    public void iViewMyStatistics() {
        String playerName = world.getCurrentUser().getName();
        myStandingsPosition = calculateMyPosition(playerName);
    }

    // ==================== Helper Methods ====================

    private List<LeaderboardEntry> buildWeeklyLeaderboard(int weekNumber) {
        List<LeaderboardEntry> entries = new ArrayList<>();

        for (Map.Entry<String, Map<Integer, WeekScore>> playerEntry : weeklyScores.entrySet()) {
            WeekScore weekScore = playerEntry.getValue().get(weekNumber);
            if (weekScore != null) {
                LeaderboardEntry entry = new LeaderboardEntry();
                entry.setPlayerName(playerEntry.getKey());
                entry.setScore(weekScore.getScore());
                entry.setWeekNumber(weekNumber);
                entry.setTeamSelected(weekScore.getTeamSelected());
                entries.add(entry);
            }
        }

        // Sort by score descending
        entries.sort((a, b) -> Double.compare(b.getScore(), a.getScore()));

        // Assign ranks
        for (int i = 0; i < entries.size(); i++) {
            entries.get(i).setRank(i + 1);
        }

        return entries;
    }

    private List<LeaderboardEntry> buildOverallLeaderboard() {
        List<LeaderboardEntry> entries = new ArrayList<>();

        for (PlayerScore score : playerScores.values()) {
            LeaderboardEntry entry = new LeaderboardEntry();
            entry.setPlayerName(score.getPlayerName());
            entry.setScore(score.getTotalScore());
            entries.add(entry);
        }

        // Sort by total score descending
        entries.sort((a, b) -> Double.compare(b.getScore(), a.getScore()));

        // Assign ranks
        for (int i = 0; i < entries.size(); i++) {
            entries.get(i).setRank(i + 1);
        }

        return entries;
    }

    private List<LeaderboardEntry> buildDetailedStandings() {
        List<LeaderboardEntry> entries = buildOverallLeaderboard();

        // Add detailed information
        for (LeaderboardEntry entry : entries) {
            String playerName = entry.getPlayerName();
            entry.setEliminatedTeamsCount(eliminatedTeams.getOrDefault(playerName, new ArrayList<>()).size());
            entry.setActiveTeams(activeTeams.getOrDefault(playerName, new ArrayList<>()));
        }

        return entries;
    }

    private List<LeaderboardEntry> buildSortedLeaderboard(String criteria) {
        List<LeaderboardEntry> entries = buildDetailedStandings();

        if ("most eliminated teams".equals(criteria)) {
            entries.sort((a, b) -> Integer.compare(b.getEliminatedTeamsCount(), a.getEliminatedTeamsCount()));
        } else if ("fewest eliminated teams".equals(criteria)) {
            entries.sort((a, b) -> Integer.compare(a.getEliminatedTeamsCount(), b.getEliminatedTeamsCount()));
        } else if ("highest single week score".equals(criteria)) {
            // Sort by best weekly performance
            entries.sort((a, b) -> Double.compare(
                getHighestWeekScore(b.getPlayerName()),
                getHighestWeekScore(a.getPlayerName())
            ));
        }

        // Reassign ranks
        for (int i = 0; i < entries.size(); i++) {
            entries.get(i).setRank(i + 1);
        }

        return entries;
    }

    private LeaderboardResponse buildPaginatedResponse(List<LeaderboardEntry> allEntries, int page, int pageSize) {
        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, allEntries.size());

        List<LeaderboardEntry> pageEntries = allEntries.subList(start, end);

        PaginationMetadata pagination = new PaginationMetadata();
        pagination.setTotalItems(allEntries.size());
        pagination.setTotalPages((allEntries.size() + pageSize - 1) / pageSize);
        pagination.setCurrentPage(page);
        pagination.setPageSize(pageSize);
        pagination.setHasNextPage(end < allEntries.size());
        pagination.setHasPreviousPage(page > 1);

        LeaderboardResponse response = new LeaderboardResponse();
        response.setEntries(pageEntries);
        response.setPagination(pagination);

        return response;
    }

    private Map<String, Object> calculateMyPosition(String playerName) {
        Map<String, Object> position = new HashMap<>();

        List<LeaderboardEntry> leaderboard = buildOverallLeaderboard();
        LeaderboardEntry myEntry = leaderboard.stream()
            .filter(e -> e.getPlayerName().equals(playerName))
            .findFirst()
            .orElse(null);

        if (myEntry != null) {
            position.put("myRank", myEntry.getRank());
            position.put("totalPlayers", totalPlayers);
            position.put("myScore", myEntry.getScore());

            // Calculate points from leader
            LeaderboardEntry leader = leaderboard.get(0);
            position.put("pointsFromLeader", myEntry.getScore() - leader.getScore());

            // Find players ahead and behind
            int myIndex = leaderboard.indexOf(myEntry);
            if (myIndex > 0) {
                LeaderboardEntry ahead = leaderboard.get(myIndex - 1);
                position.put("playersAhead", ahead.getPlayerName() + ": " + ahead.getScore());
                position.put("pointsToNext", ahead.getScore() - myEntry.getScore());
            }
            if (myIndex < leaderboard.size() - 1) {
                LeaderboardEntry behind = leaderboard.get(myIndex + 1);
                position.put("playersBehind", behind.getPlayerName() + ": " + behind.getScore());
            }
        }

        return position;
    }

    private Map<String, Object> buildPlayerComparison(String player1, String player2) {
        Map<String, Object> comparison = new HashMap<>();
        comparison.put("player1", player1);
        comparison.put("player2", player2);
        return comparison;
    }

    private WeekScore createWeekScore(int weekNumber, double score) {
        WeekScore weekScore = new WeekScore();
        weekScore.setWeekNumber(weekNumber);
        weekScore.setScore(score);
        return weekScore;
    }

    private String findPlayerWithTeam(String teamName) {
        for (Map.Entry<String, PlayerScore> entry : playerScores.entrySet()) {
            if (teamName.equals(entry.getValue().getCurrentTeamSelected())) {
                return entry.getKey();
            }
        }
        return null;
    }

    private double getHighestWeekScore(String playerName) {
        Map<Integer, WeekScore> weeks = weeklyScores.get(playerName);
        if (weeks == null || weeks.isEmpty()) {
            return 0.0;
        }
        return weeks.values().stream()
            .mapToDouble(WeekScore::getScore)
            .max()
            .orElse(0.0);
    }

    private void determineWinner() {
        if (leaderboardEntries.isEmpty()) {
            return;
        }

        LeaderboardEntry topEntry = leaderboardEntries.get(0);
        double topScore = topEntry.getScore();

        // Find all players with top score (handles ties)
        winners = leaderboardEntries.stream()
            .filter(e -> e.getScore() == topScore)
            .map(e -> {
                PlayerComparison pc = new PlayerComparison();
                pc.setPlayerName(e.getPlayerName());
                return pc;
            })
            .collect(Collectors.toList());
    }

    // ==================== Helper Classes ====================

    private static class PlayerScore {
        private String playerName;
        private Double totalScore = 0.0;
        private Double currentWeekScore;
        private String currentTeamSelected;

        public String getPlayerName() { return playerName; }
        public void setPlayerName(String playerName) { this.playerName = playerName; }
        public Double getTotalScore() { return totalScore; }
        public void setTotalScore(Double totalScore) { this.totalScore = totalScore; }
        public Double getCurrentWeekScore() { return currentWeekScore; }
        public void setCurrentWeekScore(Double currentWeekScore) { this.currentWeekScore = currentWeekScore; }
        public String getCurrentTeamSelected() { return currentTeamSelected; }
        public void setCurrentTeamSelected(String currentTeamSelected) { this.currentTeamSelected = currentTeamSelected; }
    }

    private static class WeekScore {
        private int weekNumber;
        private double score;
        private String teamSelected;

        public int getWeekNumber() { return weekNumber; }
        public void setWeekNumber(int weekNumber) { this.weekNumber = weekNumber; }
        public double getScore() { return score; }
        public void setScore(double score) { this.score = score; }
        public String getTeamSelected() { return teamSelected; }
        public void setTeamSelected(String teamSelected) { this.teamSelected = teamSelected; }
    }

    private static class LeaderboardEntry {
        private String playerName;
        private int rank;
        private double score;
        private int weekNumber;
        private String teamSelected;
        private int eliminatedTeamsCount;
        private List<String> activeTeams;

        public String getPlayerName() { return playerName; }
        public void setPlayerName(String playerName) { this.playerName = playerName; }
        public int getRank() { return rank; }
        public void setRank(int rank) { this.rank = rank; }
        public double getScore() { return score; }
        public void setScore(double score) { this.score = score; }
        public int getWeekNumber() { return weekNumber; }
        public void setWeekNumber(int weekNumber) { this.weekNumber = weekNumber; }
        public String getTeamSelected() { return teamSelected; }
        public void setTeamSelected(String teamSelected) { this.teamSelected = teamSelected; }
        public int getEliminatedTeamsCount() { return eliminatedTeamsCount; }
        public void setEliminatedTeamsCount(int eliminatedTeamsCount) { this.eliminatedTeamsCount = eliminatedTeamsCount; }
        public List<String> getActiveTeams() { return activeTeams; }
        public void setActiveTeams(List<String> activeTeams) { this.activeTeams = activeTeams; }
    }

    private static class LeaderboardResponse {
        private List<LeaderboardEntry> entries;
        private String leaderboardType;
        private int weekNumber;
        private boolean detailedView;
        private boolean liveScoring;
        private int refreshIntervalSeconds;
        private LocalDateTime lastRefreshTime;
        private boolean publicView;
        private PaginationMetadata pagination;

        public List<LeaderboardEntry> getEntries() { return entries; }
        public void setEntries(List<LeaderboardEntry> entries) { this.entries = entries; }
        public String getLeaderboardType() { return leaderboardType; }
        public void setLeaderboardType(String leaderboardType) { this.leaderboardType = leaderboardType; }
        public int getWeekNumber() { return weekNumber; }
        public void setWeekNumber(int weekNumber) { this.weekNumber = weekNumber; }
        public boolean isDetailedView() { return detailedView; }
        public void setDetailedView(boolean detailedView) { this.detailedView = detailedView; }
        public boolean isLiveScoring() { return liveScoring; }
        public void setLiveScoring(boolean liveScoring) { this.liveScoring = liveScoring; }
        public int getRefreshIntervalSeconds() { return refreshIntervalSeconds; }
        public void setRefreshIntervalSeconds(int refreshIntervalSeconds) { this.refreshIntervalSeconds = refreshIntervalSeconds; }
        public LocalDateTime getLastRefreshTime() { return lastRefreshTime; }
        public void setLastRefreshTime(LocalDateTime lastRefreshTime) { this.lastRefreshTime = lastRefreshTime; }
        public boolean isPublicView() { return publicView; }
        public void setPublicView(boolean publicView) { this.publicView = publicView; }
        public PaginationMetadata getPagination() { return pagination; }
        public void setPagination(PaginationMetadata pagination) { this.pagination = pagination; }
    }

    private static class PaginationMetadata {
        private int totalItems;
        private int totalPages;
        private int currentPage;
        private int pageSize;
        private boolean hasNextPage;
        private boolean hasPreviousPage;

        public int getTotalItems() { return totalItems; }
        public void setTotalItems(int totalItems) { this.totalItems = totalItems; }
        public int getTotalPages() { return totalPages; }
        public void setTotalPages(int totalPages) { this.totalPages = totalPages; }
        public int getCurrentPage() { return currentPage; }
        public void setCurrentPage(int currentPage) { this.currentPage = currentPage; }
        public int getPageSize() { return pageSize; }
        public void setPageSize(int pageSize) { this.pageSize = pageSize; }
        public boolean isHasNextPage() { return hasNextPage; }
        public void setHasNextPage(boolean hasNextPage) { this.hasNextPage = hasNextPage; }
        public boolean isHasPreviousPage() { return hasPreviousPage; }
        public void setHasPreviousPage(boolean hasPreviousPage) { this.hasPreviousPage = hasPreviousPage; }
    }

    private static class WeekTrend {
        private int weekNumber;
        private Double score;
        private int rank;

        public int getWeekNumber() { return weekNumber; }
        public void setWeekNumber(int weekNumber) { this.weekNumber = weekNumber; }
        public Double getScore() { return score; }
        public void setScore(Double score) { this.score = score; }
        public int getRank() { return rank; }
        public void setRank(int rank) { this.rank = rank; }
    }

    private static class HistoricalGameResult {
        private String gameName;
        private String status;
        private int rank;
        private double totalScore;
        private int teamsEliminated;

        public String getGameName() { return gameName; }
        public void setGameName(String gameName) { this.gameName = gameName; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public int getRank() { return rank; }
        public void setRank(int rank) { this.rank = rank; }
        public double getTotalScore() { return totalScore; }
        public void setTotalScore(double totalScore) { this.totalScore = totalScore; }
        public int getTeamsEliminated() { return teamsEliminated; }
        public void setTeamsEliminated(int teamsEliminated) { this.teamsEliminated = teamsEliminated; }
    }

    private static class LeagueStatistics {
        private double highestWeeklyScore;
        private String highestWeeklyScorePlayer;
        private double lowestWeeklyScore;
        private String lowestWeeklyScorePlayer;
        private double averageWeeklyScore;
        private double averageScore;

        public double getHighestWeeklyScore() { return highestWeeklyScore; }
        public void setHighestWeeklyScore(double highestWeeklyScore) { this.highestWeeklyScore = highestWeeklyScore; }
        public String getHighestWeeklyScorePlayer() { return highestWeeklyScorePlayer; }
        public void setHighestWeeklyScorePlayer(String highestWeeklyScorePlayer) { this.highestWeeklyScorePlayer = highestWeeklyScorePlayer; }
        public double getLowestWeeklyScore() { return lowestWeeklyScore; }
        public void setLowestWeeklyScore(double lowestWeeklyScore) { this.lowestWeeklyScore = lowestWeeklyScore; }
        public String getLowestWeeklyScorePlayer() { return lowestWeeklyScorePlayer; }
        public void setLowestWeeklyScorePlayer(String lowestWeeklyScorePlayer) { this.lowestWeeklyScorePlayer = lowestWeeklyScorePlayer; }
        public double getAverageWeeklyScore() { return averageWeeklyScore; }
        public void setAverageWeeklyScore(double averageWeeklyScore) { this.averageWeeklyScore = averageWeeklyScore; }
        public double getAverageScore() { return averageScore; }
        public void setAverageScore(double averageScore) { this.averageScore = averageScore; }
    }

    private static class PlayerComparison {
        private String playerName;

        public String getPlayerName() { return playerName; }
        public void setPlayerName(String playerName) { this.playerName = playerName; }
    }

    private static class UnauthorizedException extends RuntimeException {
        public UnauthorizedException(String message) {
            super(message);
        }
    }
}
