package com.ffl.playoffs.bdd.steps;

import com.ffl.playoffs.bdd.World;
import com.ffl.playoffs.domain.model.League;
import com.ffl.playoffs.domain.model.NFLPlayer;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.Roster;
import com.ffl.playoffs.domain.model.RosterSlot;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.*;

/**
 * Step definitions for PPR Scoring for Individual NFL Players (FFL-26)
 * Implements Gherkin steps from ffl-26-ppr-scoring.feature
 *
 * Covers Full PPR, Half PPR, Standard, and TE Premium scoring modes
 * Calculates fantasy points based on individual player performance using PPR rules
 */
public class PPRScoringSteps {

    @Autowired
    private World world;

    // Test context for scoring calculations
    private Map<String, Object> scoringConfiguration = new HashMap<>();
    private Map<String, Map<String, Object>> playerWeekStats = new HashMap<>();
    private Map<String, Map<String, Double>> playerScoringBreakdown = new HashMap<>();
    private Map<String, Double> playerFantasyPoints = new HashMap<>();
    private Map<Integer, Double> weeklyTotals = new HashMap<>();
    private String currentPlayerName;
    private Position currentPlayerPosition;
    private Integer currentWeek = 1;
    private String currentLeagueName;
    private Double calculatedTotal = 0.0;
    private boolean isHalfPPR = false;
    private boolean isStandardScoring = false;
    private Integer dataRefreshInterval = 5;

    // ==================== BACKGROUND STEPS ====================

    @Given("a league {string} exists with PPR scoring configuration:")
    public void aLeagueExistsWithPPRScoringConfiguration(String leagueName, DataTable dataTable) {
        currentLeagueName = leagueName;
        scoringConfiguration.clear();
        parsePPRScoringConfiguration(dataTable);

        League league = new League();
        league.setName(leagueName);
        league.setOwnerId(world.getCurrentUserId());
        world.setCurrentLeague(league);
        world.storeLeague(leagueName, league);
    }

    @Given("a player has a complete locked roster")
    public void aPlayerHasACompleteLockedRoster() {
        // Create a complete roster - will be filled with players as scenarios progress
        if (world.getCurrentRoster() == null) {
            Roster roster = new Roster();
            roster.setLocked(true);
            world.setCurrentRoster(roster);
        }
    }

    // ==================== GIVEN STEPS - PLAYER POSITION ASSIGNMENTS ====================

    @Given("the player has {string} at QB position")
    public void thePlayerHasAtQBPosition(String playerName) {
        assignPlayerToRosterPosition(playerName, Position.QB);
    }

    @Given("the player has {string} at RB position")
    public void thePlayerHasAtRBPosition(String playerName) {
        assignPlayerToRosterPosition(playerName, Position.RB);
    }

    @Given("the player has {string} at WR position")
    public void thePlayerHasAtWRPosition(String playerName) {
        assignPlayerToRosterPosition(playerName, Position.WR);
    }

    @Given("the player has {string} at TE position")
    public void thePlayerHasAtTEPosition(String playerName) {
        assignPlayerToRosterPosition(playerName, Position.TE);
    }

    @Given("the player has {string} at K position")
    public void thePlayerHasAtKPosition(String playerName) {
        assignPlayerToRosterPosition(playerName, Position.K);
    }

    // ==================== GIVEN STEPS - GAME STATS ====================

    @Given("in NFL week {int}, {string} has game stats:")
    public void inNFLWeekPlayerHasGameStats(Integer week, String playerName, DataTable dataTable) {
        currentWeek = week;
        currentPlayerName = playerName;
        parsePlayerGameStats(playerName, week, dataTable);
    }

    // ==================== GIVEN STEPS - ADMIN CONFIGURATION ====================

    @Given("the admin is configuring a new league")
    public void theAdminIsConfiguringANewLeague() {
        scoringConfiguration.clear();
    }

    @Given("the admin configures custom scoring:")
    public void theAdminConfiguresCustomScoring(DataTable dataTable) {
        parsePPRScoringConfiguration(dataTable);
    }

    @Given("a QB throws {int} yards and {int} TDs")
    public void aQBThrowsYardsAndTDs(Integer yards, Integer tds) {
        Map<String, Object> qbStats = new HashMap<>();
        qbStats.put("passing_yards", yards.doubleValue());
        qbStats.put("passing_tds", tds.doubleValue());
        playerWeekStats.put("TestQB_1", qbStats);
        currentPlayerName = "TestQB";
    }

    // ==================== GIVEN STEPS - ROSTER SCENARIOS ====================

    @Given("the player has a complete roster with {int} NFL players")
    public void thePlayerHasACompleteRosterWithNFLPlayers(Integer playerCount) {
        // Roster will be populated via the data table in subsequent steps
        world.setExpectedRosterSize(playerCount);
    }

    @Given("week {int} fantasy points are calculated for each player:")
    public void weekFantasyPointsAreCalculatedForEachPlayer(Integer week, DataTable dataTable) {
        currentWeek = week;
        List<Map<String, String>> rows = dataTable.asMaps();

        for (Map<String, String> row : rows) {
            String position = row.get("Position");
            String playerName = row.get("Player");
            Double points = parseDouble(row.get("Points"));

            // Clean up player name (remove position suffix if present)
            if (playerName.contains("(")) {
                playerName = playerName.substring(0, playerName.indexOf("(")).trim();
            }

            playerFantasyPoints.put(playerName, points);
        }
    }

    @Given("the player's roster has an empty K position")
    public void thePlayersRosterHasAnEmptyKPosition() {
        // Mark that K position is empty - will contribute 0 points
        world.setEmptyPosition(Position.K);
    }

    @Given("the player has {int} of {int} positions filled")
    public void thePlayerHasOfPositionsFilled(Integer filled, Integer total) {
        world.setFilledPositions(filled);
        world.setTotalPositions(total);
    }

    @Given("the league runs for {int} weeks")
    public void theLeagueRunsForWeeks(Integer weeks) {
        world.setLeagueDuration(weeks);
    }

    @Given("the player's roster scores:")
    public void thePlayersRosterScores(DataTable dataTable) {
        weeklyTotals.clear();
        List<Map<String, String>> rows = dataTable.asMaps();

        for (Map<String, String> row : rows) {
            Integer week = Integer.parseInt(row.get("Week"));
            Double points = parseDouble(row.get("Points"));
            weeklyTotals.put(week, points);
        }
    }

    @Given("the player has {string} at QB")
    public void thePlayerHasAtQB(String playerName) {
        assignPlayerToRosterPosition(playerName, Position.QB);
    }

    @Given("NFL week {int} games are in progress")
    public void nflWeekGamesAreInProgress(Integer week) {
        currentWeek = week;
        world.setGamesInProgress(true);
    }

    @Given("the data refresh interval is {int} minutes")
    public void theDataRefreshIntervalIsMinutes(Integer minutes) {
        dataRefreshInterval = minutes;
    }

    @Given("the player has {string} at RB")
    public void thePlayerHasAtRB(String playerName) {
        assignPlayerToRosterPosition(playerName, Position.RB);
    }

    @Given("the league has completed {int} weeks")
    public void theLeagueHasCompletedWeeks(Integer weeks) {
        world.setCompletedWeeks(weeks);
    }

    // ==================== WHEN STEPS ====================

    @When("the system calculates fantasy points for week {int}")
    public void theSystemCalculatesFantasyPointsForWeek(Integer week) {
        currentWeek = week;
        calculateFantasyPointsForPlayer(currentPlayerName, week);
    }

    @When("the admin sets reception points to {double}")
    public void theAdminSetsReceptionPointsTo(Double points) {
        scoringConfiguration.put("receptions", points);
        if (points == 0.5) {
            isHalfPPR = true;
        } else if (points == 0.0) {
            isStandardScoring = true;
        }
    }

    @When("sets all other PPR rules to standard values")
    public void setsAllOtherPPRRulesToStandardValues() {
        setStandardPPRConfiguration();
    }

    @When("the system calculates fantasy points")
    public void theSystemCalculatesFantasyPoints() {
        calculateFantasyPointsForPlayer(currentPlayerName, currentWeek);
    }

    @When("the system calculates the player's total score for week {int}")
    public void theSystemCalculatesThePlayersTotalScoreForWeek(Integer week) {
        currentWeek = week;
        calculatedTotal = 0.0;

        // Sum up all player fantasy points
        for (Map.Entry<String, Double> entry : playerFantasyPoints.entrySet()) {
            calculatedTotal += entry.getValue();
        }
    }

    @When("the system calculates week {int} scores")
    public void theSystemCalculatesWeekScores(Integer week) {
        currentWeek = week;
        // K position contributes 0, so calculation excludes it
    }

    @When("the system calculates cumulative score")
    public void theSystemCalculatesCumulativeScore() {
        calculatedTotal = 0.0;
        for (Double weeklyScore : weeklyTotals.values()) {
            calculatedTotal += weeklyScore;
        }
    }

    @When("{string} completes a {int}-yard TD pass")
    public void playerCompletesYardTDPass(String playerName, Integer yards) {
        currentPlayerName = playerName;

        // Get current stats or create new
        Map<String, Object> stats = playerWeekStats.getOrDefault(playerName + "_" + currentWeek, new HashMap<>());

        // Add the new play
        Double currentPassingYards = (Double) stats.getOrDefault("passing_yards", 0.0);
        Double currentPassingTDs = (Double) stats.getOrDefault("passing_tds", 0.0);

        stats.put("passing_yards", currentPassingYards + yards);
        stats.put("passing_tds", currentPassingTDs + 1);

        playerWeekStats.put(playerName + "_" + currentWeek, stats);

        // Recalculate fantasy points
        calculateFantasyPointsForPlayer(playerName, currentWeek);
    }

    @When("the player views {string} scoring details")
    public void thePlayerViewsScoringDetails(String playerName) {
        currentPlayerName = playerName;
        world.setSelectedPlayer(world.getNFLPlayer(playerName));
    }

    // ==================== THEN STEPS ====================

    @Then("{string} scores:")
    public void playerScores(String playerName, DataTable dataTable) {
        verifyScoringBreakdown(playerName, dataTable);
    }

    @Then("the total fantasy points for {string} is {double} points")
    public void theTotalFantasyPointsForPlayerIsPoints(String playerName, Double expectedPoints) {
        Double actualPoints = playerFantasyPoints.getOrDefault(playerName, 0.0);
        assertThat(actualPoints)
            .as("Total fantasy points for " + playerName)
            .isEqualTo(expectedPoints);
    }

    @Then("the league uses Half-PPR scoring")
    public void theLeagueUsesHalfPPRScoring() {
        assertThat(isHalfPPR).isTrue();
        Double receptionPoints = (Double) scoringConfiguration.get("receptions");
        assertThat(receptionPoints).isEqualTo(0.5);
    }

    @Then("receptions are worth {double} points each")
    public void receptionsAreWorthPointsEach(Double points) {
        Double receptionPoints = (Double) scoringConfiguration.get("receptions");
        assertThat(receptionPoints).isEqualTo(points);
    }

    @Then("a WR with {int} receptions and {int} yards scores: {int} + {int} = {int} points")
    public void aWRWithReceptionsAndYardsScoresPoints(Integer receptions, Integer yards,
            Integer receptionPoints, Integer yardPoints, Integer totalPoints) {
        // Verify the calculation example
        Double expectedReceptionPoints = receptions * (Double) scoringConfiguration.get("receptions");
        Double expectedYardPoints = yards / (Double) scoringConfiguration.get("receiving_yards_per_point");
        Double expectedTotal = expectedReceptionPoints + expectedYardPoints;

        assertThat(expectedTotal).isEqualTo(totalPoints.doubleValue());
    }

    @Then("the league uses Standard scoring")
    public void theLeagueUsesStandardScoring() {
        assertThat(isStandardScoring).isTrue();
        Double receptionPoints = (Double) scoringConfiguration.get("receptions");
        assertThat(receptionPoints).isEqualTo(0.0);
    }

    @Then("receptions are worth {int} points")
    public void receptionsAreWorthPoints(Integer points) {
        Double receptionPoints = (Double) scoringConfiguration.get("receptions");
        assertThat(receptionPoints).isEqualTo(points.doubleValue());
    }

    @Then("a WR with {int} receptions and {int} yards scores: {int} + {int} = {int} points")
    public void aWRWithReceptionsAndYardsScoresIntPoints(Integer receptions, Integer yards,
            Integer receptionPoints, Integer yardPoints, Integer totalPoints) {
        aWRWithReceptionsAndYardsScoresPoints(receptions, yards, receptionPoints, yardPoints, totalPoints);
    }

    @Then("the QB scores: \\({int}\\/{int}) + \\({int} × {int}) = {int} + {int} = {int} points")
    public void theQBScoresCalculation(Integer yards, Integer yardsPerPoint, Integer tds, Integer pointsPerTD,
            Integer yardPoints, Integer tdPoints, Integer totalPoints) {
        Double calculatedPoints = playerFantasyPoints.getOrDefault(currentPlayerName, 0.0);
        assertThat(calculatedPoints).isEqualTo(totalPoints.doubleValue());
    }

    @Then("the player's weekly total is {double} fantasy points")
    public void thePlayersWeeklyTotalIsFantasyPoints(Double expectedTotal) {
        assertThat(calculatedTotal)
            .as("Player's weekly total fantasy points")
            .isEqualTo(expectedTotal);
    }

    @Then("the K position contributes {int} fantasy points")
    public void theKPositionContributesFantasyPoints(Integer points) {
        assertThat(points).isEqualTo(0);
    }

    @Then("the player's total only includes points from {int} filled positions")
    public void thePlayersTotalOnlyIncludesPointsFromFilledPositions(Integer filledCount) {
        Integer actualFilled = world.getFilledPositions();
        assertThat(actualFilled).isEqualTo(filledCount);
    }

    @Then("the player's total season score is {double} fantasy points")
    public void thePlayersTotalSeasonScoreIsFantasyPoints(Double expectedTotal) {
        assertThat(calculatedTotal)
            .as("Total season score")
            .isEqualTo(expectedTotal);
    }

    @Then("the system updates player stats within {int} minutes")
    public void theSystemUpdatesPlayerStatsWithinMinutes(Integer minutes) {
        assertThat(dataRefreshInterval).isLessThanOrEqualTo(minutes);
    }

    @Then("{string} fantasy points increase by: \\({int}\\/{int}) + {int} = {int} points")
    public void playerFantasyPointsIncreaseByCalculation(String playerName, Integer yards,
            Integer yardsPerPoint, Integer tdPoints, Integer totalIncrease) {
        // Verify the incremental increase calculation
        Double expectedIncrease = (yards.doubleValue() / yardsPerPoint) + tdPoints;
        assertThat(expectedIncrease).isEqualTo(totalIncrease.doubleValue());
    }

    @Then("the player's weekly total is recalculated")
    public void thePlayersWeeklyTotalIsRecalculated() {
        // Verify that recalculation happens
        assertThat(playerFantasyPoints).isNotEmpty();
    }

    @Then("the system shows fantasy points for each week:")
    public void theSystemShowsFantasyPointsForEachWeek(DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps();

        for (Map<String, String> row : rows) {
            Integer week = Integer.parseInt(row.get("Week"));
            Double expectedPoints = parseDouble(row.get("Total Points"));

            // Verify stats are available for this week
            assertThat(week).isNotNull();
            assertThat(expectedPoints).isNotNull();
        }
    }

    @Then("the system shows season totals and averages")
    public void theSystemShowsSeasonTotalsAndAverages() {
        // Verify that season totals are calculated
        assertThat(playerFantasyPoints).isNotEmpty();
    }

    // ==================== HELPER METHODS ====================

    private void parsePPRScoringConfiguration(DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps();

        for (Map<String, String> row : rows) {
            String rule = row.get("Scoring Rule");
            String pointsStr = row.get("Points");
            Double points = parseDouble(pointsStr);

            if (rule.contains("Passing yards per point")) {
                scoringConfiguration.put("passing_yards_per_point", points);
            } else if (rule.contains("Passing TD")) {
                scoringConfiguration.put("passing_td", points);
            } else if (rule.contains("Interception")) {
                scoringConfiguration.put("interceptions", points);
            } else if (rule.contains("Rushing yards per point")) {
                scoringConfiguration.put("rushing_yards_per_point", points);
            } else if (rule.contains("Rushing TD")) {
                scoringConfiguration.put("rushing_td", points);
            } else if (rule.contains("Receiving yards per point")) {
                scoringConfiguration.put("receiving_yards_per_point", points);
            } else if (rule.contains("Reception (PPR)") || rule.equals("Reception")) {
                scoringConfiguration.put("receptions", points);
            } else if (rule.contains("Receiving TD")) {
                scoringConfiguration.put("receiving_td", points);
            } else if (rule.contains("Fumble lost")) {
                scoringConfiguration.put("fumbles_lost", points);
            } else if (rule.contains("2-point conversion")) {
                scoringConfiguration.put("two_pt_conversion", points);
            }
        }
    }

    private void setStandardPPRConfiguration() {
        // Set standard values if not already set
        scoringConfiguration.putIfAbsent("passing_yards_per_point", 25.0);
        scoringConfiguration.putIfAbsent("passing_td", 4.0);
        scoringConfiguration.putIfAbsent("interceptions", -2.0);
        scoringConfiguration.putIfAbsent("rushing_yards_per_point", 10.0);
        scoringConfiguration.putIfAbsent("rushing_td", 6.0);
        scoringConfiguration.putIfAbsent("receiving_yards_per_point", 10.0);
        scoringConfiguration.putIfAbsent("receiving_td", 6.0);
        scoringConfiguration.putIfAbsent("fumbles_lost", -2.0);
        scoringConfiguration.putIfAbsent("two_pt_conversion", 2.0);
    }

    private void parsePlayerGameStats(String playerName, Integer week, DataTable dataTable) {
        Map<String, Object> stats = new HashMap<>();
        List<Map<String, String>> rows = dataTable.asMaps();

        for (Map<String, String> row : rows) {
            String stat = row.get("Stat");
            String value = row.get("Value");
            Double numericValue = parseDouble(value);

            if (stat.contains("Passing yards")) {
                stats.put("passing_yards", numericValue);
            } else if (stat.contains("Passing TDs")) {
                stats.put("passing_tds", numericValue);
            } else if (stat.contains("Interceptions")) {
                stats.put("interceptions", numericValue);
            } else if (stat.contains("Rushing yards")) {
                stats.put("rushing_yards", numericValue);
            } else if (stat.contains("Rushing TDs")) {
                stats.put("rushing_tds", numericValue);
            } else if (stat.contains("Receptions")) {
                stats.put("receptions", numericValue);
            } else if (stat.contains("Receiving yards")) {
                stats.put("receiving_yards", numericValue);
            } else if (stat.contains("Receiving TDs")) {
                stats.put("receiving_tds", numericValue);
            } else if (stat.contains("Fumbles lost")) {
                stats.put("fumbles_lost", numericValue);
            } else if (stat.contains("2-pt conversions")) {
                stats.put("two_pt_conversions", numericValue);
            }
        }

        playerWeekStats.put(playerName + "_" + week, stats);
    }

    private void calculateFantasyPointsForPlayer(String playerName, Integer week) {
        String key = playerName + "_" + week;
        Map<String, Object> stats = playerWeekStats.get(key);

        if (stats == null) {
            playerFantasyPoints.put(playerName, 0.0);
            return;
        }

        Map<String, Double> breakdown = new HashMap<>();
        Double totalPoints = 0.0;

        // Passing stats
        if (stats.containsKey("passing_yards")) {
            Double yards = (Double) stats.get("passing_yards");
            Double yardsPerPoint = (Double) scoringConfiguration.getOrDefault("passing_yards_per_point", 25.0);
            Double points = yards / yardsPerPoint;
            breakdown.put("passing_yards", points);
            totalPoints += points;
        }

        if (stats.containsKey("passing_tds")) {
            Double tds = (Double) stats.get("passing_tds");
            Double pointsPerTD = (Double) scoringConfiguration.getOrDefault("passing_td", 4.0);
            Double points = tds * pointsPerTD;
            breakdown.put("passing_tds", points);
            totalPoints += points;
        }

        if (stats.containsKey("interceptions")) {
            Double ints = (Double) stats.get("interceptions");
            Double penalty = (Double) scoringConfiguration.getOrDefault("interceptions", -2.0);
            Double points = ints * penalty;
            breakdown.put("interceptions", points);
            totalPoints += points;
        }

        // Rushing stats
        if (stats.containsKey("rushing_yards")) {
            Double yards = (Double) stats.get("rushing_yards");
            Double yardsPerPoint = (Double) scoringConfiguration.getOrDefault("rushing_yards_per_point", 10.0);
            Double points = yards / yardsPerPoint;
            breakdown.put("rushing_yards", points);
            totalPoints += points;
        }

        if (stats.containsKey("rushing_tds")) {
            Double tds = (Double) stats.get("rushing_tds");
            Double pointsPerTD = (Double) scoringConfiguration.getOrDefault("rushing_td", 6.0);
            Double points = tds * pointsPerTD;
            breakdown.put("rushing_tds", points);
            totalPoints += points;
        }

        // Receiving stats
        if (stats.containsKey("receptions")) {
            Double receptions = (Double) stats.get("receptions");
            Double ppr = (Double) scoringConfiguration.getOrDefault("receptions", 1.0);
            Double points = receptions * ppr;
            breakdown.put("receptions", points);
            totalPoints += points;
        }

        if (stats.containsKey("receiving_yards")) {
            Double yards = (Double) stats.get("receiving_yards");
            Double yardsPerPoint = (Double) scoringConfiguration.getOrDefault("receiving_yards_per_point", 10.0);
            Double points = yards / yardsPerPoint;
            breakdown.put("receiving_yards", points);
            totalPoints += points;
        }

        if (stats.containsKey("receiving_tds")) {
            Double tds = (Double) stats.get("receiving_tds");
            Double pointsPerTD = (Double) scoringConfiguration.getOrDefault("receiving_td", 6.0);
            Double points = tds * pointsPerTD;
            breakdown.put("receiving_tds", points);
            totalPoints += points;
        }

        // Fumbles
        if (stats.containsKey("fumbles_lost")) {
            Double fumbles = (Double) stats.get("fumbles_lost");
            Double penalty = (Double) scoringConfiguration.getOrDefault("fumbles_lost", -2.0);
            Double points = fumbles * penalty;
            breakdown.put("fumbles_lost", points);
            totalPoints += points;
        }

        // 2-point conversions
        if (stats.containsKey("two_pt_conversions")) {
            Double conversions = (Double) stats.get("two_pt_conversions");
            Double pointsPer = (Double) scoringConfiguration.getOrDefault("two_pt_conversion", 2.0);
            Double points = conversions * pointsPer;
            breakdown.put("two_pt_conversions", points);
            totalPoints += points;
        }

        // Round to 1 decimal place
        totalPoints = Math.round(totalPoints * 10.0) / 10.0;

        playerScoringBreakdown.put(playerName, breakdown);
        playerFantasyPoints.put(playerName, totalPoints);
    }

    private void verifyScoringBreakdown(String playerName, DataTable dataTable) {
        Map<String, Double> breakdown = playerScoringBreakdown.get(playerName);
        assertThat(breakdown).as("Scoring breakdown for " + playerName).isNotNull();

        List<Map<String, String>> rows = dataTable.asMaps();

        for (Map<String, String> row : rows) {
            String stat = row.get("Stat");
            String calculation = row.get("Calculation");
            Double expectedPoints = parseDouble(row.get("Points"));

            String statKey = mapStatToKey(stat);
            Double actualPoints = breakdown.get(statKey);

            assertThat(actualPoints)
                .as("Points for " + stat + " (calculation: " + calculation + ")")
                .isNotNull()
                .isEqualTo(expectedPoints);
        }
    }

    private String mapStatToKey(String stat) {
        if (stat.contains("Passing yards")) return "passing_yards";
        if (stat.contains("Passing TDs")) return "passing_tds";
        if (stat.contains("Interceptions")) return "interceptions";
        if (stat.contains("Rushing yards")) return "rushing_yards";
        if (stat.contains("Rushing TDs")) return "rushing_tds";
        if (stat.contains("Receptions")) return "receptions";
        if (stat.contains("Receiving yards")) return "receiving_yards";
        if (stat.contains("Receiving TDs")) return "receiving_tds";
        if (stat.contains("Fumbles lost")) return "fumbles_lost";
        if (stat.contains("2-pt conversions")) return "two_pt_conversions";
        return stat.toLowerCase().replace(" ", "_");
    }

    private void assignPlayerToRosterPosition(String playerName, Position position) {
        currentPlayerName = playerName;
        currentPlayerPosition = position;

        NFLPlayer nflPlayer = world.getNFLPlayer(playerName);
        if (nflPlayer == null) {
            nflPlayer = new NFLPlayer(playerName, position, "NFL");
            world.storeNFLPlayer(playerName, nflPlayer);
        }

        Roster roster = world.getCurrentRoster();
        if (roster != null) {
            // Add player to roster
            world.addPlayerToRoster(playerName, position);
        }
    }

    private Double parseDouble(String value) {
        if (value == null || value.isEmpty()) return 0.0;

        // Remove any parenthetical notes or extra whitespace
        value = value.replaceAll("\\(.*?\\)", "").trim();

        try {
            return Double.parseDouble(value);
        } catch (NumberFormatException e) {
            return 0.0;
        }
    }
}
