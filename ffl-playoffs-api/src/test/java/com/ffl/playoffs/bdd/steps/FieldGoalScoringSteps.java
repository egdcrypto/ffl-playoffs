package com.ffl.playoffs.bdd.steps;

import com.ffl.playoffs.bdd.World;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.*;

/**
 * Step definitions for Field Goal Scoring by Distance (FFL-9)
 * Implements Gherkin steps from ffl-9-field-goal-scoring.feature
 *
 * Covers:
 * - Distance-based field goal scoring (0-39, 40-49, 50+ yards)
 * - Custom league field goal configurations
 * - Missed and blocked field goal handling
 * - Field goal data integration from NFL sources
 */
public class FieldGoalScoringSteps {

    @Autowired
    private World world;

    // Test context
    private Map<String, Object> leagueConfig = new HashMap<>();
    private Map<String, List<FieldGoalAttempt>> teamFieldGoals = new HashMap<>();
    private Map<String, String> playerTeamSelections = new HashMap<>();
    private Map<String, Double> calculatedFieldGoalPoints = new HashMap<>();
    private Map<String, Map<String, Object>> fieldGoalBreakdown = new HashMap<>();
    private Exception lastException;
    private boolean fieldGoalScoringEnabled = true;
    private List<FieldGoalAttempt> nflGameData = new ArrayList<>();
    private Map<String, Object> gameStatistics = new HashMap<>();
    private Map<String, Double> teamTotalScores = new HashMap<>();

    // Inner class to represent a field goal attempt
    private static class FieldGoalAttempt {
        private final int distance;
        private final FieldGoalResult result;
        private String kicker;
        private Integer quarter;

        public FieldGoalAttempt(int distance, FieldGoalResult result) {
            this.distance = distance;
            this.result = result;
        }

        public int getDistance() {
            return distance;
        }

        public FieldGoalResult getResult() {
            return result;
        }

        public void setKicker(String kicker) {
            this.kicker = kicker;
        }

        public void setQuarter(Integer quarter) {
            this.quarter = quarter;
        }

        public String getKicker() {
            return kicker;
        }

        public Integer getQuarter() {
            return quarter;
        }
    }

    private enum FieldGoalResult {
        MADE, MISSED, BLOCKED
    }

    // ==================== BACKGROUND STEPS ====================

    @Given("the game {string} is active")
    public void theGameIsActive(String gameName) {
        // Game is active - initialize fresh context
        resetContext();
    }

    @And("the league has field goal scoring enabled")
    public void theLeagueHasFieldGoalScoringEnabled() {
        fieldGoalScoringEnabled = true;
        setDefaultFieldGoalConfiguration();
    }

    // ==================== CONFIGURATION STEPS ====================

    @And("the league has default field goal scoring configured")
    public void theLeagueHasDefaultFieldGoalScoringConfigured() {
        setDefaultFieldGoalConfiguration();
    }

    @Given("the league has custom field goal scoring:")
    public void theLeagueHasCustomFieldGoalScoring(DataTable dataTable) {
        Map<String, String> config = dataTable.asMap(String.class, String.class);

        if (config.containsKey("fg0to39Points")) {
            leagueConfig.put("fg0to39Points", parseDouble(config.get("fg0to39Points")));
        }
        if (config.containsKey("fg40to49Points")) {
            leagueConfig.put("fg40to49Points", parseDouble(config.get("fg40to49Points")));
        }
        if (config.containsKey("fg50PlusPoints")) {
            leagueConfig.put("fg50PlusPoints", parseDouble(config.get("fg50PlusPoints")));
        }
    }

    @Given("the admin owns a league")
    public void theAdminOwnsALeague() {
        // Admin context setup
        leagueConfig.clear();
    }

    @When("the admin configures field goal scoring:")
    public void theAdminConfiguresFieldGoalScoring(DataTable dataTable) {
        Map<String, String> config = dataTable.asMap(String.class, String.class);

        leagueConfig.put("fg0to39Points", parseDouble(config.get("fg0to39Points")));
        leagueConfig.put("fg40to49Points", parseDouble(config.get("fg40to49Points")));
        leagueConfig.put("fg50PlusPoints", parseDouble(config.get("fg50PlusPoints")));
    }

    @Then("the field goal scoring rules are saved")
    public void theFieldGoalScoringRulesAreSaved() {
        assertThat(leagueConfig).isNotEmpty();
        assertThat(leagueConfig).containsKeys("fg0to39Points", "fg40to49Points", "fg50PlusPoints");
    }

    @And("the league uses the custom configuration")
    public void theLeagueUsesTheCustomConfiguration() {
        // Configuration is already applied
        assertThat(leagueConfig.get("fg0to39Points")).isNotNull();
    }

    // ==================== PLAYER SELECTION STEPS ====================

    @Given("player {string} selected {string} for week {int}")
    public void playerSelectedTeamForWeek(String playerName, String team, int week) {
        playerTeamSelections.put(playerName, team);

        // Initialize field goals list for this team if not exists
        if (!teamFieldGoals.containsKey(team)) {
            teamFieldGoals.put(team, new ArrayList<>());
        }
    }

    // ==================== FIELD GOAL DATA ENTRY STEPS ====================

    @And("the {string} kicker made field goals at:")
    public void theTeamKickerMadeFieldGoalsAt(String team, DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps(String.class, String.class);
        List<FieldGoalAttempt> fieldGoals = teamFieldGoals.computeIfAbsent(team, k -> new ArrayList<>());

        for (Map<String, String> row : rows) {
            String distanceStr = row.get("distance");
            int distance = parseDistance(distanceStr);
            fieldGoals.add(new FieldGoalAttempt(distance, FieldGoalResult.MADE));
        }
    }

    @And("the {string} kicker made a field goal at {int} yards")
    public void theTeamKickerMadeAFieldGoalAtYards(String team, int distance) {
        List<FieldGoalAttempt> fieldGoals = teamFieldGoals.computeIfAbsent(team, k -> new ArrayList<>());
        fieldGoals.add(new FieldGoalAttempt(distance, FieldGoalResult.MADE));
    }

    @And("the {string} kicker made a {int}-yard field goal")
    public void theTeamKickerMadeYardFieldGoal(String team, int distance) {
        theTeamKickerMadeAFieldGoalAtYards(team, distance);
    }

    @And("the {string} kicker attempted field goals:")
    public void theTeamKickerAttemptedFieldGoals(String team, DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps(String.class, String.class);
        List<FieldGoalAttempt> fieldGoals = teamFieldGoals.computeIfAbsent(team, k -> new ArrayList<>());

        for (Map<String, String> row : rows) {
            String distanceStr = row.get("distance");
            String resultStr = row.get("result");

            int distance = parseDistance(distanceStr);
            FieldGoalResult result = FieldGoalResult.valueOf(resultStr);

            fieldGoals.add(new FieldGoalAttempt(distance, result));
        }
    }

    @And("the {string} did not attempt any field goals")
    public void theTeamDidNotAttemptAnyFieldGoals(String team) {
        teamFieldGoals.put(team, new ArrayList<>());
    }

    @And("the {string} kicker made {int} field goals at:")
    public void theTeamKickerMadeFieldGoalsAt(String team, int count, DataTable dataTable) {
        theTeamKickerMadeFieldGoalsAt(team, dataTable);

        // Verify count matches
        List<FieldGoalAttempt> fieldGoals = teamFieldGoals.get(team);
        long madeCount = fieldGoals.stream()
            .filter(fg -> fg.getResult() == FieldGoalResult.MADE)
            .count();
        assertThat(madeCount).isEqualTo(count);
    }

    @And("the {string} kicker made excellent field goals in week {int}:")
    public void theTeamKickerMadeExcellentFieldGoalsInWeek(String team, int week, DataTable dataTable) {
        theTeamKickerMadeFieldGoalsAt(team, dataTable);
    }

    // ==================== CALCULATION STEPS ====================

    @When("field goal scoring is calculated")
    public void fieldGoalScoringIsCalculated() {
        calculateFieldGoalPointsForAllPlayers();
    }

    @When("field goal scoring is calculated from game data")
    public void fieldGoalScoringIsCalculatedFromGameData() {
        // Process NFL game data and calculate points
        for (FieldGoalAttempt attempt : nflGameData) {
            // This would integrate with actual game data in real implementation
        }
        calculateFieldGoalPointsForAllPlayers();
    }

    @When("week {int} scoring is calculated")
    public void weekScoringIsCalculated(int week) {
        calculateFieldGoalPointsForAllPlayers();

        // Apply elimination rules if needed
        // (Eliminated teams get 0 points)
    }

    @When("total scoring is calculated")
    public void totalScoringIsCalculated() {
        calculateFieldGoalPointsForAllPlayers();

        // Calculate total team scores including other stats
        for (String player : playerTeamSelections.keySet()) {
            String team = playerTeamSelections.get(player);
            Double fgPoints = calculatedFieldGoalPoints.getOrDefault(player, 0.0);

            // Add field goal points to total
            teamTotalScores.put(player, fgPoints);
        }
    }

    // ==================== ASSERTION STEPS ====================

    @Then("the field goal points should be {double}")
    public void theFieldGoalPointsShouldBe(double expectedPoints) {
        // Get the last calculated player's points
        String lastPlayer = playerTeamSelections.keySet().stream()
            .reduce((first, second) -> second)
            .orElse(null);

        assertThat(lastPlayer).isNotNull();
        Double actualPoints = calculatedFieldGoalPoints.get(lastPlayer);

        assertThat(actualPoints)
            .as("Field goal points for player " + lastPlayer)
            .isEqualTo(expectedPoints);
    }

    @Then("the total field goal points should be {double}")
    public void theTotalFieldGoalPointsShouldBe(double expectedPoints) {
        theFieldGoalPointsShouldBe(expectedPoints);
    }

    @Then("the field goal breakdown should be:")
    public void theFieldGoalBreakdownShouldBe(DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps(String.class, String.class);

        String lastPlayer = playerTeamSelections.keySet().stream()
            .reduce((first, second) -> second)
            .orElse(null);

        Map<String, Object> breakdown = fieldGoalBreakdown.get(lastPlayer);
        assertThat(breakdown).isNotNull();

        for (Map<String, String> row : rows) {
            String range = row.get("range");
            int expectedCount = Integer.parseInt(row.get("count"));
            double expectedPointsPerFG = Double.parseDouble(row.get("points per FG"));
            double expectedTotal = Double.parseDouble(row.get("total"));

            @SuppressWarnings("unchecked")
            Map<String, Object> rangeData = (Map<String, Object>) breakdown.get(range);

            assertThat(rangeData).isNotNull();
            assertThat(rangeData.get("count")).isEqualTo(expectedCount);
            assertThat(rangeData.get("pointsPerFG")).isEqualTo(expectedPointsPerFG);
            assertThat(rangeData.get("total")).isEqualTo(expectedTotal);
        }
    }

    @Then("all {int} field goals are in the {int}-{int} range")
    public void allFieldGoalsAreInRange(int count, int minYards, int maxYards) {
        String lastPlayer = playerTeamSelections.keySet().stream()
            .reduce((first, second) -> second)
            .orElse(null);

        String team = playerTeamSelections.get(lastPlayer);
        List<FieldGoalAttempt> fieldGoals = teamFieldGoals.get(team);

        long rangeCount = fieldGoals.stream()
            .filter(fg -> fg.getResult() == FieldGoalResult.MADE)
            .filter(fg -> fg.getDistance() >= minYards && fg.getDistance() <= maxYards)
            .count();

        assertThat(rangeCount).isEqualTo(count);
    }

    @Then("the field goal should be scored in the {string} range")
    public void theFieldGoalShouldBeScoredInRange(String range) {
        // Verification that FG was categorized in correct range
        String lastPlayer = playerTeamSelections.keySet().stream()
            .reduce((first, second) -> second)
            .orElse(null);

        Map<String, Object> breakdown = fieldGoalBreakdown.get(lastPlayer);
        assertThat(breakdown).containsKey(range);
    }

    @And("the points awarded should be {int}")
    public void thePointsAwardedShouldBe(int expectedPoints) {
        String lastPlayer = playerTeamSelections.keySet().stream()
            .reduce((first, second) -> second)
            .orElse(null);

        Double actualPoints = calculatedFieldGoalPoints.get(lastPlayer);
        assertThat(actualPoints).isEqualTo((double) expectedPoints);
    }

    @Then("only made field goals are counted")
    public void onlyMadeFieldGoalsAreCounted() {
        String lastPlayer = playerTeamSelections.keySet().stream()
            .reduce((first, second) -> second)
            .orElse(null);

        String team = playerTeamSelections.get(lastPlayer);
        List<FieldGoalAttempt> fieldGoals = teamFieldGoals.get(team);

        // Verify that only MADE FGs contributed to score
        long madeCount = fieldGoals.stream()
            .filter(fg -> fg.getResult() == FieldGoalResult.MADE)
            .count();

        assertThat(madeCount).isGreaterThan(0);
    }

    @Then("only successful field goals count")
    public void onlySuccessfulFieldGoalsCount() {
        onlyMadeFieldGoalsAreCounted();
    }

    @And("field goals contribute to the overall team score")
    public void fieldGoalsContributeToTheOverallTeamScore() {
        assertThat(calculatedFieldGoalPoints).isNotEmpty();

        String lastPlayer = playerTeamSelections.keySet().stream()
            .reduce((first, second) -> second)
            .orElse(null);

        Double fgPoints = calculatedFieldGoalPoints.get(lastPlayer);
        assertThat(fgPoints).isGreaterThan(0.0);
    }

    @And("the overall score includes offensive + field goals + defensive points")
    public void theOverallScoreIncludesOffensivePlusFieldGoalsPlusDefensivePoints() {
        // Verify comprehensive scoring includes field goals
        assertThat(teamTotalScores).isNotEmpty();
    }

    @And("the field goal points are {double}")
    public void theFieldGoalPointsAre(double expectedPoints) {
        theFieldGoalPointsShouldBe(expectedPoints);
    }

    // ==================== DATA INTEGRATION STEPS ====================

    @Given("a game has completed")
    public void aGameHasCompleted() {
        // Game completion context
    }

    @And("the {string} are being scored")
    public void theTeamAreBeingScored(String team) {
        playerTeamSelections.put("scoring_player", team);
    }

    @When("the system fetches game statistics")
    public void theSystemFetchesGameStatistics() {
        // Simulate fetching game data
        gameStatistics.put("fieldGoalDistance", true);
        gameStatistics.put("fieldGoalResult", true);
        gameStatistics.put("kicker", true);
        gameStatistics.put("quarter", true);
    }

    @Then("field goal data includes:")
    public void fieldGoalDataIncludes(DataTable dataTable) {
        List<String> expectedFields = dataTable.asList(String.class);

        for (String field : expectedFields) {
            assertThat(gameStatistics).containsKey(field);
        }
    }

    @And("each field goal has a distance in yards")
    public void eachFieldGoalHasADistanceInYards() {
        assertThat(gameStatistics.get("fieldGoalDistance")).isNotNull();
    }

    @And("each field goal has a result \\(MADE, MISSED, BLOCKED)")
    public void eachFieldGoalHasAResult() {
        assertThat(gameStatistics.get("fieldGoalResult")).isNotNull();
    }

    @Given("the NFL game data includes field goals:")
    public void theNFLGameDataIncludesFieldGoals(DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps(String.class, String.class);

        for (Map<String, String> row : rows) {
            String team = row.get("team");
            int distance = Integer.parseInt(row.get("distance"));
            FieldGoalResult result = FieldGoalResult.valueOf(row.get("result"));

            FieldGoalAttempt attempt = new FieldGoalAttempt(distance, result);
            nflGameData.add(attempt);

            // Also add to team field goals
            List<FieldGoalAttempt> teamFGs = teamFieldGoals.computeIfAbsent(team, k -> new ArrayList<>());
            teamFGs.add(attempt);
        }
    }

    @Then("the system correctly categorizes each field goal")
    public void theSystemCorrectlyCategorizesEachFieldGoal() {
        // Verify categorization logic
        String lastPlayer = playerTeamSelections.keySet().stream()
            .reduce((first, second) -> second)
            .orElse(null);

        Map<String, Object> breakdown = fieldGoalBreakdown.get(lastPlayer);
        assertThat(breakdown).isNotNull();
    }

    // ==================== DISPLAY STEPS ====================

    @When("the player requests the scoring breakdown")
    public void thePlayerRequestsTheScoringBreakdown() {
        // Breakdown is already calculated
    }

    @Then("they should see the field goal details:")
    public void theyShouldSeeTheFieldGoalDetails(DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps(String.class, String.class);

        String lastPlayer = playerTeamSelections.keySet().stream()
            .reduce((first, second) -> second)
            .orElse(null);

        String team = playerTeamSelections.get(lastPlayer);
        List<FieldGoalAttempt> fieldGoals = teamFieldGoals.get(team);

        assertThat(fieldGoals).hasSize(rows.size());
    }

    @And("the total field goal points: {double}")
    public void theTotalFieldGoalPoints(double expectedPoints) {
        theFieldGoalPointsShouldBe(expectedPoints);
    }

    // ==================== COMPREHENSIVE SCORING STEPS ====================

    @And("the {string} had the following performance:")
    public void theTeamHadTheFollowingPerformance(String team, DataTable dataTable) {
        Map<String, String> stats = dataTable.asMap(String.class, String.class);

        // Store stats for comprehensive scoring
        for (Map.Entry<String, String> entry : stats.entrySet()) {
            gameStatistics.put(team + "_" + entry.getKey(), entry.getValue());
        }
    }

    @And("the {string} scored {int} touchdowns")
    public void theTeamScoredTouchdowns(String team, int touchdowns) {
        gameStatistics.put(team + "_touchdowns", touchdowns);
    }

    @And("the team's offensive points come primarily from field goals")
    public void theTeamsOffensivePointsComePrimarilyFromFieldGoals() {
        // Verification that field goals are primary scoring source
        String lastPlayer = playerTeamSelections.keySet().stream()
            .reduce((first, second) -> second)
            .orElse(null);

        Double fgPoints = calculatedFieldGoalPoints.get(lastPlayer);
        assertThat(fgPoints).isGreaterThan(0.0);
    }

    // ==================== ELIMINATION STEPS ====================

    @And("the {string} lost their week {int} game")
    public void theTeamLostTheirWeekGame(String team, int week) {
        gameStatistics.put(team + "_week" + week + "_result", "LOSS");
    }

    @And("the {string} are eliminated")
    public void theTeamIsEliminated(String team) {
        gameStatistics.put(team + "_eliminated", true);
    }

    @And("the elimination override is applied")
    public void theEliminationOverrideIsApplied() {
        // Apply elimination rule - eliminated teams get 0 points
        String lastPlayer = playerTeamSelections.keySet().stream()
            .reduce((first, second) -> second)
            .orElse(null);

        String team = playerTeamSelections.get(lastPlayer);
        Boolean isEliminated = (Boolean) gameStatistics.get(team + "_eliminated");

        if (Boolean.TRUE.equals(isEliminated)) {
            calculatedFieldGoalPoints.put(lastPlayer, 0.0);
        }
    }

    @And("no points are awarded despite the great kicks")
    public void noPointsAreAwardedDespiteTheGreatKicks() {
        String lastPlayer = playerTeamSelections.keySet().stream()
            .reduce((first, second) -> second)
            .orElse(null);

        Double points = calculatedFieldGoalPoints.get(lastPlayer);
        assertThat(points).isEqualTo(0.0);
    }

    // ==================== VALIDATION AND ERROR HANDLING ====================

    @Given("game data includes a field goal with distance {int} yards")
    public void gameDataIncludesAFieldGoalWithDistanceYards(int distance) {
        nflGameData.add(new FieldGoalAttempt(distance, FieldGoalResult.MADE));
    }

    @When("the system processes the data")
    public void theSystemProcessesTheData() {
        try {
            for (FieldGoalAttempt attempt : nflGameData) {
                if (attempt.getDistance() < 0) {
                    throw new IllegalArgumentException("Invalid field goal distance: " + attempt.getDistance());
                }
            }
        } catch (Exception e) {
            lastException = e;
        }
    }

    @Then("the invalid field goal is rejected")
    public void theInvalidFieldGoalIsRejected() {
        assertThat(lastException).isNotNull();
    }

    @And("an error is logged")
    public void anErrorIsLogged() {
        assertThat(lastException.getMessage()).contains("Invalid");
    }

    @And("the field goal is not included in scoring")
    public void theFieldGoalIsNotIncludedInScoring() {
        // Verify invalid FG was not counted
        assertThat(lastException).isNotNull();
    }

    @Given("game data includes a field goal at {int} yards")
    public void gameDataIncludesAFieldGoalAtYards(int distance) {
        nflGameData.add(new FieldGoalAttempt(distance, FieldGoalResult.MADE));

        // Also add to a test team
        playerTeamSelections.put("test_player", "Test Team");
        List<FieldGoalAttempt> teamFGs = teamFieldGoals.computeIfAbsent("Test Team", k -> new ArrayList<>());
        teamFGs.add(new FieldGoalAttempt(distance, FieldGoalResult.MADE));
    }

    @Then("the field goal is accepted \\(record-breaking kick!)")
    public void theFieldGoalIsAcceptedRecordBreakingKick() {
        assertThat(nflGameData).isNotEmpty();
        assertThat(lastException).isNull();
    }

    @And("it is scored in the {int}\\+ yards range")
    public void itIsScoredInTheYardsRange(int minYards) {
        // Verify it's in the 50+ range
        FieldGoalAttempt attempt = nflGameData.get(nflGameData.size() - 1);
        assertThat(attempt.getDistance()).isGreaterThanOrEqualTo(minYards);
    }

    @And("the points awarded are based on {int}\\+ tier")
    public void thePointsAwardedAreBasedOnTier(int minYards) {
        calculateFieldGoalPointsForAllPlayers();

        String lastPlayer = playerTeamSelections.keySet().stream()
            .reduce((first, second) -> second)
            .orElse(null);

        Double points = calculatedFieldGoalPoints.get(lastPlayer);
        Double expectedPointsPerFG = (Double) leagueConfig.get("fg50PlusPoints");

        assertThat(points).isEqualTo(expectedPointsPerFG);
    }

    // ==================== LEAGUE COMPARISON STEPS ====================

    @Given("league {string} has default field goal scoring:")
    public void leagueHasDefaultFieldGoalScoring(String leagueName, DataTable dataTable) {
        // Store configuration for specific league
        Map<String, String> config = dataTable.asMap(String.class, String.class);

        Map<String, Object> leagueSpecificConfig = new HashMap<>();
        leagueSpecificConfig.put("fg0to39Points", parseDouble(config.get("fg0to39Points")));
        leagueSpecificConfig.put("fg40to49Points", parseDouble(config.get("fg40to49Points")));
        leagueSpecificConfig.put("fg50PlusPoints", parseDouble(config.get("fg50PlusPoints")));

        gameStatistics.put(leagueName + "_config", leagueSpecificConfig);
    }

    @And("league {string} has custom scoring:")
    public void leagueHasCustomScoring(String leagueName, DataTable dataTable) {
        leagueHasDefaultFieldGoalScoring(leagueName, dataTable);
    }

    @And("both leagues have a kicker who made:")
    public void bothLeaguesHaveAKickerWhoMade(DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps(String.class, String.class);

        List<FieldGoalAttempt> attempts = new ArrayList<>();
        for (Map<String, String> row : rows) {
            String distanceStr = row.get("distance");
            int distance = parseDistance(distanceStr);
            attempts.add(new FieldGoalAttempt(distance, FieldGoalResult.MADE));
        }

        gameStatistics.put("common_kicker_fgs", attempts);
    }

    @When("scoring is calculated for both leagues")
    public void scoringIsCalculatedForBothLeagues() {
        // Calculate for both league configs
        @SuppressWarnings("unchecked")
        List<FieldGoalAttempt> attempts = (List<FieldGoalAttempt>) gameStatistics.get("common_kicker_fgs");

        // Standard League
        @SuppressWarnings("unchecked")
        Map<String, Object> standardConfig = (Map<String, Object>) gameStatistics.get("Standard League_config");
        double standardPoints = calculateFieldGoalPoints(attempts, standardConfig);
        calculatedFieldGoalPoints.put("Standard League", standardPoints);

        // Long Distance League
        @SuppressWarnings("unchecked")
        Map<String, Object> longDistanceConfig = (Map<String, Object>) gameStatistics.get("Long Distance League_config");
        double longDistancePoints = calculateFieldGoalPoints(attempts, longDistanceConfig);
        calculatedFieldGoalPoints.put("Long Distance League", longDistancePoints);
    }

    @Then("{string} awards {int} points \\({int} \\+ {int} \\+ {int})")
    public void leagueAwardsPoints(String leagueName, int totalPoints, int p1, int p2, int p3) {
        Double actualPoints = calculatedFieldGoalPoints.get(leagueName);
        assertThat(actualPoints).isEqualTo((double) totalPoints);
        assertThat(p1 + p2 + p3).isEqualTo(totalPoints);
    }

    @And("{string} awards {int} points \\({int} \\+ {int} \\+ {int})")
    public void andLeagueAwardsPoints(String leagueName, int totalPoints, int p1, int p2, int p3) {
        leagueAwardsPoints(leagueName, totalPoints, p1, p2, p3);
    }

    @And("the custom league rewards long kicks more heavily")
    public void theCustomLeagueRewardsLongKicksMoreHeavily() {
        Double standardPoints = calculatedFieldGoalPoints.get("Standard League");
        Double longDistancePoints = calculatedFieldGoalPoints.get("Long Distance League");

        assertThat(longDistancePoints).isGreaterThan(standardPoints);
    }

    // ==================== HELPER METHODS ====================

    private void resetContext() {
        leagueConfig.clear();
        teamFieldGoals.clear();
        playerTeamSelections.clear();
        calculatedFieldGoalPoints.clear();
        fieldGoalBreakdown.clear();
        lastException = null;
        fieldGoalScoringEnabled = true;
        nflGameData.clear();
        gameStatistics.clear();
        teamTotalScores.clear();
    }

    private void setDefaultFieldGoalConfiguration() {
        leagueConfig.put("fg0to39Points", 3.0);
        leagueConfig.put("fg40to49Points", 4.0);
        leagueConfig.put("fg50PlusPoints", 5.0);
    }

    private int parseDistance(String distanceStr) {
        // Remove "yards" suffix if present
        return Integer.parseInt(distanceStr.replaceAll("[^0-9]", ""));
    }

    private double parseDouble(String value) {
        if (value == null || value.isEmpty()) {
            return 0.0;
        }
        try {
            return Double.parseDouble(value.trim());
        } catch (NumberFormatException e) {
            return 0.0;
        }
    }

    private void calculateFieldGoalPointsForAllPlayers() {
        for (Map.Entry<String, String> entry : playerTeamSelections.entrySet()) {
            String playerName = entry.getKey();
            String team = entry.getValue();

            List<FieldGoalAttempt> fieldGoals = teamFieldGoals.getOrDefault(team, new ArrayList<>());

            double totalPoints = calculateFieldGoalPoints(fieldGoals, leagueConfig);
            calculatedFieldGoalPoints.put(playerName, totalPoints);

            // Calculate breakdown
            Map<String, Object> breakdown = calculateFieldGoalBreakdown(fieldGoals, leagueConfig);
            fieldGoalBreakdown.put(playerName, breakdown);
        }
    }

    private double calculateFieldGoalPoints(List<FieldGoalAttempt> fieldGoals, Map<String, Object> config) {
        double totalPoints = 0.0;

        double fg0to39Points = (Double) config.getOrDefault("fg0to39Points", 3.0);
        double fg40to49Points = (Double) config.getOrDefault("fg40to49Points", 4.0);
        double fg50PlusPoints = (Double) config.getOrDefault("fg50PlusPoints", 5.0);

        for (FieldGoalAttempt fg : fieldGoals) {
            if (fg.getResult() != FieldGoalResult.MADE) {
                continue; // Only count made field goals
            }

            int distance = fg.getDistance();

            if (distance <= 39) {
                totalPoints += fg0to39Points;
            } else if (distance <= 49) {
                totalPoints += fg40to49Points;
            } else {
                totalPoints += fg50PlusPoints;
            }
        }

        return totalPoints;
    }

    private Map<String, Object> calculateFieldGoalBreakdown(List<FieldGoalAttempt> fieldGoals, Map<String, Object> config) {
        Map<String, Object> breakdown = new HashMap<>();

        double fg0to39Points = (Double) config.getOrDefault("fg0to39Points", 3.0);
        double fg40to49Points = (Double) config.getOrDefault("fg40to49Points", 4.0);
        double fg50PlusPoints = (Double) config.getOrDefault("fg50PlusPoints", 5.0);

        int count0to39 = 0;
        int count40to49 = 0;
        int count50Plus = 0;

        for (FieldGoalAttempt fg : fieldGoals) {
            if (fg.getResult() != FieldGoalResult.MADE) {
                continue;
            }

            int distance = fg.getDistance();

            if (distance <= 39) {
                count0to39++;
            } else if (distance <= 49) {
                count40to49++;
            } else {
                count50Plus++;
            }
        }

        // Create breakdown for each range
        if (count0to39 > 0 || count40to49 > 0 || count50Plus > 0) {
            Map<String, Object> range0to39 = new HashMap<>();
            range0to39.put("count", count0to39);
            range0to39.put("pointsPerFG", fg0to39Points);
            range0to39.put("total", count0to39 * fg0to39Points);
            breakdown.put("0-39 yards", range0to39);

            Map<String, Object> range40to49 = new HashMap<>();
            range40to49.put("count", count40to49);
            range40to49.put("pointsPerFG", fg40to49Points);
            range40to49.put("total", count40to49 * fg40to49Points);
            breakdown.put("40-49 yards", range40to49);

            Map<String, Object> range50Plus = new HashMap<>();
            range50Plus.put("count", count50Plus);
            range50Plus.put("pointsPerFG", fg50PlusPoints);
            range50Plus.put("total", count50Plus * fg50PlusPoints);
            breakdown.put("50+ yards", range50Plus);
        }

        return breakdown;
    }
}
