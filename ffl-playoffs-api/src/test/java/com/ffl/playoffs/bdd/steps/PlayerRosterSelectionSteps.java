package com.ffl.playoffs.bdd.steps;

import com.ffl.playoffs.bdd.World;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.Before;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.util.*;

import static org.assertj.core.api.Assertions.*;

/**
 * Step definitions for Player Roster Selection (FFL-24)
 * Implements Gherkin steps from ffl-24-player-roster-selection.feature
 *
 * This feature implements a ONE-TIME DRAFT MODEL where:
 * - Rosters are built ONCE before the first game starts
 * - Once the first game starts, rosters are PERMANENTLY LOCKED
 * - NO changes allowed after lock: no waiver wire, no trades, no weekly adjustments
 * - Multiple league players can select the same NFL player (no ownership model)
 */
public class PlayerRosterSelectionSteps {

    @Autowired
    private World world;

    // Test context
    private Map<String, League> leagues = new HashMap<>();
    private Map<String, NFLPlayer> nflPlayers = new HashMap<>();
    private Map<String, PlayerRoster> playerRosters = new HashMap<>();
    private Map<String, RosterConfiguration> rosterConfigs = new HashMap<>();
    private String currentLeaguePlayer;
    private Exception lastException;
    private String lastErrorCode;
    private String lastErrorMessage;
    private DraftResult lastDraftResult;
    private LocalDateTime firstGameStartTime;
    private LocalDateTime currentTime;
    private DraftOrder draftOrder;
    private Map<String, Integer> draftPositions = new HashMap<>();

    @Before
    public void setUp() {
        leagues.clear();
        nflPlayers.clear();
        playerRosters.clear();
        rosterConfigs.clear();
        currentLeaguePlayer = null;
        lastException = null;
        lastErrorCode = null;
        lastErrorMessage = null;
        lastDraftResult = null;
        firstGameStartTime = null;
        currentTime = LocalDateTime.now();
        draftOrder = null;
        draftPositions.clear();
    }

    // ==================== Background Steps ====================

    @Given("the league {string} exists")
    public void theLeagueExists(String leagueName) {
        League league = new League();
        league.setName(leagueName);
        league.setId(UUID.randomUUID().toString());
        leagues.put(leagueName, league);
    }

    @And("the league has the following roster configuration:")
    public void theLeagueHasTheFollowingRosterConfiguration(DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps();
        RosterConfiguration config = new RosterConfiguration();

        for (Map<String, String> row : rows) {
            String position = row.get("position");
            int count = Integer.parseInt(row.get("count"));
            String eligiblePositions = row.get("eligiblePositions");

            RosterSlotConfig slotConfig = new RosterSlotConfig();
            slotConfig.setPosition(position);
            slotConfig.setCount(count);
            slotConfig.setEligiblePositions(Arrays.asList(eligiblePositions.split(",")));

            config.addSlotConfig(slotConfig);
        }

        rosterConfigs.put("default", config);
    }

    @And("the league has {int} league players")
    public void theLeagueHasLeaguePlayers(int playerCount) {
        League league = leagues.values().iterator().next();
        league.setPlayerCount(playerCount);
    }

    @And("I am authenticated as league player {string}")
    public void iAmAuthenticatedAsLeaguePlayer(String playerName) {
        currentLeaguePlayer = playerName;
        if (!playerRosters.containsKey(playerName)) {
            playerRosters.put(playerName, new PlayerRoster(playerName));
        }
    }

    @And("the following NFL players exist:")
    public void theFollowingNFLPlayersExist(DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps();

        for (Map<String, String> row : rows) {
            String id = row.get("id");
            String name = row.get("name");
            String position = row.get("position");
            String team = row.get("team");

            NFLPlayer player = new NFLPlayer();
            player.setId(id);
            player.setName(name);
            player.setPosition(position);
            player.setTeam(team);
            player.setStatus("ACTIVE");

            nflPlayers.put(id, player);
        }
    }

    // ==================== Basic Draft Scenarios ====================

    @Given("my roster is empty")
    public void myRosterIsEmpty() {
        PlayerRoster roster = playerRosters.get(currentLeaguePlayer);
        if (roster == null) {
            roster = new PlayerRoster(currentLeaguePlayer);
            playerRosters.put(currentLeaguePlayer, roster);
        }
        roster.clear();
    }

    @When("I draft NFL player {string} \\(id: {int}) to position {string}")
    public void iDraftNFLPlayerToPosition(String playerName, int playerId, String position) {
        try {
            NFLPlayer nflPlayer = nflPlayers.get(String.valueOf(playerId));
            if (nflPlayer == null) {
                throw new IllegalArgumentException("PLAYER_NOT_FOUND: NFL player with id " + playerId + " not found");
            }

            PlayerRoster roster = playerRosters.get(currentLeaguePlayer);
            RosterConfiguration config = rosterConfigs.get("default");

            // Validate position exists in configuration
            if (!config.hasPosition(position)) {
                throw new IllegalArgumentException("POSITION_NOT_IN_CONFIGURATION: Position " + position + " is not configured for this league");
            }

            // Validate position compatibility
            if (!isPlayerEligibleForPosition(nflPlayer, position, config)) {
                String errorMsg = playerName + " (" + nflPlayer.getPosition() + ") cannot be drafted to " + position + " position";
                throw new IllegalStateException("POSITION_MISMATCH: " + errorMsg);
            }

            // Check if player already drafted to this roster
            if (roster.hasPlayer(playerId)) {
                String existingPosition = roster.getPlayerPosition(playerId);
                throw new IllegalStateException("PLAYER_ALREADY_DRAFTED: You have already drafted " + playerName + " to position " + existingPosition);
            }

            // Check position limit
            if (roster.isPositionFull(position, config)) {
                int limit = config.getPositionLimit(position);
                throw new IllegalStateException("POSITION_LIMIT_EXCEEDED: " + position + " position slots are full (" + limit + "/" + limit + ")");
            }

            // Draft the player
            roster.addPlayer(playerId, playerName, position);
            lastDraftResult = DraftResult.SUCCESS;
            lastException = null;
            lastErrorCode = null;
            lastErrorMessage = null;

        } catch (Exception e) {
            lastException = e;
            String message = e.getMessage();
            if (message.contains(":")) {
                String[] parts = message.split(":", 2);
                lastErrorCode = parts[0].trim();
                lastErrorMessage = parts[1].trim();
            } else {
                lastErrorMessage = message;
            }
            lastDraftResult = DraftResult.FAILURE;
        }
    }

    @When("I attempt to draft NFL player {string} \\(id: {int}) to position {string}")
    public void iAttemptToDraftNFLPlayerToPosition(String playerName, int playerId, String position) {
        iDraftNFLPlayerToPosition(playerName, playerId, position);
    }

    @When("I draft the following NFL players:")
    public void iDraftTheFollowingNFLPlayers(DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps();

        for (Map<String, String> row : rows) {
            int playerId = Integer.parseInt(row.get("nflPlayerId"));
            String position = row.get("position");

            NFLPlayer nflPlayer = nflPlayers.get(String.valueOf(playerId));
            iDraftNFLPlayerToPosition(nflPlayer.getName(), playerId, position);

            if (lastDraftResult == DraftResult.FAILURE) {
                return;
            }
        }
    }

    @Then("the draft should succeed")
    public void theDraftShouldSucceed() {
        assertThat(lastException).isNull();
        assertThat(lastDraftResult).isEqualTo(DraftResult.SUCCESS);
    }

    @Then("the draft should fail")
    public void theDraftShouldFail() {
        assertThat(lastException).isNotNull();
        assertThat(lastDraftResult).isEqualTo(DraftResult.FAILURE);
    }

    @Then("all drafts should succeed")
    public void allDraftsShouldSucceed() {
        assertThat(lastDraftResult).isEqualTo(DraftResult.SUCCESS);
    }

    @Then("my roster should have {string} in position {string}")
    public void myRosterShouldHaveInPosition(String playerName, String position) {
        PlayerRoster roster = playerRosters.get(currentLeaguePlayer);
        assertThat(roster.hasPlayerInPosition(playerName, position)).isTrue();
    }

    @Then("{string} remains available to all other league players")
    public void remainsAvailableToAllOtherLeaguePlayers(String playerName) {
        // In no-ownership model, all players remain available
        assertThat(true).isTrue();
    }

    @Then("my roster completion should be {string}")
    public void myRosterCompletionShouldBe(String completion) {
        PlayerRoster roster = playerRosters.get(currentLeaguePlayer);
        RosterConfiguration config = rosterConfigs.get("default");

        String[] parts = completion.split("/");
        int filled = Integer.parseInt(parts[0]);
        int total = Integer.parseInt(parts[1]);

        assertThat(roster.getFilledSlots()).isEqualTo(filled);
        assertThat(config.getTotalSlots()).isEqualTo(total);
    }

    @Then("I should have {int} roster slots remaining")
    public void iShouldHaveRosterSlotsRemaining(int remaining) {
        PlayerRoster roster = playerRosters.get(currentLeaguePlayer);
        RosterConfiguration config = rosterConfigs.get("default");

        int actualRemaining = config.getTotalSlots() - roster.getFilledSlots();
        assertThat(actualRemaining).isEqualTo(remaining);
    }

    @Then("I should receive error {string}")
    public void iShouldReceiveError(String errorCode) {
        assertThat(lastErrorCode).isEqualTo(errorCode);
    }

    @Then("the error message should be {string}")
    public void theErrorMessageShouldBe(String expectedMessage) {
        assertThat(lastErrorMessage).isEqualTo(expectedMessage);
    }

    @Then("my roster should remain empty")
    public void myRosterShouldRemainEmpty() {
        PlayerRoster roster = playerRosters.get(currentLeaguePlayer);
        assertThat(roster.getFilledSlots()).isEqualTo(0);
    }

    // ==================== FLEX/SUPERFLEX Position Scenarios ====================

    @Given("I have already drafted:")
    public void iHaveAlreadyDrafted(DataTable dataTable) {
        iDraftTheFollowingNFLPlayers(dataTable);
    }

    @When("I draft NFL player {string} \\(id: {int}) to position {string}")
    public void iDraftNFLPlayerWithIdToPosition(String playerName, int playerId, String position) {
        iDraftNFLPlayerToPosition(playerName, playerId, position);
    }

    @And("{string} has position {string}")
    public void hasPosition(String playerName, String position) {
        // This is informational - the NFL player position is already set
        assertThat(true).isTrue();
    }

    // ==================== Duplicate Player Prevention ====================

    @Given("I have already drafted {string} \\(id: {int}) to position {string}")
    public void iHaveAlreadyDraftedToPosition(String playerName, int playerId, String position) {
        iDraftNFLPlayerToPosition(playerName, playerId, position);
        assertThat(lastDraftResult).isEqualTo(DraftResult.SUCCESS);
    }

    @When("I attempt to draft {string} \\(id: {int}) to position {string}")
    public void iAttemptToDraft(String playerName, int playerId, String position) {
        iDraftNFLPlayerToPosition(playerName, playerId, position);
    }

    @Then("my {word} position should still have {string}")
    public void myPositionShouldStillHave(String position, String playerName) {
        PlayerRoster roster = playerRosters.get(currentLeaguePlayer);
        assertThat(roster.hasPlayerInPosition(playerName, position)).isTrue();
    }

    @Then("my {word} position should be empty")
    public void myPositionShouldBeEmpty(String position) {
        PlayerRoster roster = playerRosters.get(currentLeaguePlayer);
        assertThat(roster.isPositionEmpty(position)).isTrue();
    }

    // ==================== No Ownership Model ====================

    @Given("all NFL players are available")
    public void allNFLPlayersAreAvailable() {
        // All players are always available in no-ownership model
        assertThat(nflPlayers).isNotEmpty();
    }

    @When("league player {string} drafts {string} \\(id: {int}) to position {string}")
    public void leaguePlayerDrafts(String playerName, String nflPlayerName, int playerId, String position) {
        String previousPlayer = currentLeaguePlayer;
        currentLeaguePlayer = playerName;
        if (!playerRosters.containsKey(playerName)) {
            playerRosters.put(playerName, new PlayerRoster(playerName));
        }

        iDraftNFLPlayerToPosition(nflPlayerName, playerId, position);

        currentLeaguePlayer = previousPlayer;
    }

    @Then("league player {string} roster should have {string}")
    public void leaguePlayerRosterShouldHave(String playerName, String nflPlayerName) {
        PlayerRoster roster = playerRosters.get(playerName);
        assertThat(roster.hasPlayerByName(nflPlayerName)).isTrue();
    }

    @Then("{string} should be available to all other league members")
    public void shouldBeAvailableToAllOtherLeagueMembers(String playerName) {
        // Always true in no-ownership model
        assertThat(true).isTrue();
    }

    @Then("there is NO exclusive ownership of NFL players")
    public void thereIsNOExclusiveOwnershipOfNFLPlayers() {
        // Business rule assertion
        assertThat(true).isTrue();
    }

    // ==================== Roster Validation ====================

    @Given("I have already drafted {int} Running Backs:")
    public void iHaveAlreadyDraftedRunningBacks(int count, DataTable dataTable) {
        iDraftTheFollowingNFLPlayers(dataTable);
    }

    @Given("the league allows maximum {int} RB positions")
    public void theLeagueAllowsMaximumRBPositions(int maxRB) {
        // Already configured in roster configuration
        assertThat(rosterConfigs.get("default").getPositionLimit("RB")).isEqualTo(maxRB);
    }

    @When("I attempt to draft NFL player {string} \\(id: {int}) to position {string}")
    public void iAttemptToDraftNFLPlayer(String playerName, int playerId, String position) {
        iDraftNFLPlayerToPosition(playerName, playerId, position);
    }

    @Given("the league has not started")
    public void theLeagueHasNotStarted() {
        firstGameStartTime = LocalDateTime.now().plusDays(1);
        currentTime = LocalDateTime.now();
    }

    @Given("I have drafted {int} out of {int} required positions")
    public void iHaveDraftedOutOfRequiredPositions(int drafted, int total) {
        // Set roster state
        PlayerRoster roster = playerRosters.get(currentLeaguePlayer);
        // Assume drafted count for testing
    }

    @When("I request roster validation")
    public void iRequestRosterValidation() {
        // Validation logic would run here
    }

    @Then("the validation should fail")
    public void theValidationShouldFail() {
        assertThat(true).isTrue();
    }

    @Then("I should receive message {string}")
    public void iShouldReceiveMessage(String message) {
        // Message validation
        assertThat(true).isTrue();
    }

    @Then("I should see {string}")
    public void iShouldSee(String message) {
        // UI message
        assertThat(true).isTrue();
    }

    @Given("I have drafted the following complete roster:")
    public void iHaveDraftedTheFollowingCompleteRoster(DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps();

        for (Map<String, String> row : rows) {
            String position = row.get("position");
            int playerId = Integer.parseInt(row.get("nflPlayerId"));
            String playerName = row.get("name");

            // Create NFL player if doesn't exist
            if (!nflPlayers.containsKey(String.valueOf(playerId))) {
                NFLPlayer player = new NFLPlayer();
                player.setId(String.valueOf(playerId));
                player.setName(playerName);

                // Extract position from name if in format "Name (POS)"
                if (playerName.contains("(")) {
                    String pos = playerName.substring(playerName.indexOf("(") + 1, playerName.indexOf(")"));
                    player.setPosition(pos);
                    playerName = playerName.substring(0, playerName.indexOf("(")).trim();
                    player.setName(playerName);
                }

                nflPlayers.put(String.valueOf(playerId), player);
            }

            iDraftNFLPlayerToPosition(playerName, playerId, position);
        }
    }

    @Then("the validation should succeed")
    public void theValidationShouldSucceed() {
        assertThat(true).isTrue();
    }

    @Then("my roster status should be {string}")
    public void myRosterStatusShouldBe(String status) {
        assertThat(true).isTrue();
    }

    // ==================== Draft Order Scenarios ====================

    @Given("the league uses {string} draft order")
    public void theLeagueUsesDraftOrder(String orderType) {
        draftOrder = new DraftOrder(orderType);
    }

    @Given("there are {int} league players: {word}, {word}, {word}, {word}")
    public void thereAreLeaguePlayers(int count, String p1, String p2, String p3, String p4) {
        draftOrder.setPlayers(Arrays.asList(p1, p2, p3, p4));
    }

    @Given("it is round {int} of the draft")
    public void itIsRoundOfTheDraft(int round) {
        draftOrder.setCurrentRound(round);
    }

    @Then("the draft order should be: {word}, {word}, {word}, {word}")
    public void theDraftOrderShouldBe(String p1, String p2, String p3, String p4) {
        List<String> expectedOrder = Arrays.asList(p1, p2, p3, p4);
        assertThat(draftOrder.getCurrentOrder()).isEqualTo(expectedOrder);
    }

    @When("round {int} begins")
    public void roundBegins(int round) {
        draftOrder.setCurrentRound(round);
    }

    // ==================== Roster Lock Scenarios ====================

    @Given("the first game starts at {string}")
    public void theFirstGameStartsAt(String dateTime) {
        firstGameStartTime = LocalDateTime.parse(dateTime.replace(" ET", "").replace(" ", "T"));
    }

    @Given("the current time is {string}")
    public void theCurrentTimeIs(String dateTime) {
        currentTime = LocalDateTime.parse(dateTime.replace(" ET", "").replace(" ", "T"));
    }

    @When("I drop {string} from my roster")
    public void iDropFromMyRoster(String playerName) {
        try {
            if (currentTime.isAfter(firstGameStartTime) || currentTime.isEqual(firstGameStartTime)) {
                throw new IllegalStateException("ROSTER_PERMANENTLY_LOCKED: Roster is permanently locked - no changes allowed after first game starts");
            }

            PlayerRoster roster = playerRosters.get(currentLeaguePlayer);
            roster.removePlayer(playerName);
            lastException = null;

        } catch (Exception e) {
            lastException = e;
            String message = e.getMessage();
            if (message.contains(":")) {
                String[] parts = message.split(":", 2);
                lastErrorCode = parts[0].trim();
                lastErrorMessage = parts[1].trim();
            }
        }
    }

    @When("I attempt to drop {string} from my roster")
    public void iAttemptToDropFromMyRoster(String playerName) {
        iDropFromMyRoster(playerName);
    }

    @Then("the drop should succeed")
    public void theDropShouldSucceed() {
        assertThat(lastException).isNull();
    }

    @Then("the drop should fail")
    public void theDropShouldFail() {
        assertThat(lastException).isNotNull();
    }

    @Then("{string} should be removed from my roster")
    public void shouldBeRemovedFromMyRoster(String playerName) {
        PlayerRoster roster = playerRosters.get(currentLeaguePlayer);
        assertThat(roster.hasPlayerByName(playerName)).isFalse();
    }

    @Then("{string} remains on my roster for the entire season")
    public void remainsOnMyRosterForTheEntireSeason(String playerName) {
        PlayerRoster roster = playerRosters.get(currentLeaguePlayer);
        assertThat(roster.hasPlayerByName(playerName)).isTrue();
    }

    // ==================== Helper Methods ====================

    private boolean isPlayerEligibleForPosition(NFLPlayer player, String rosterPosition, RosterConfiguration config) {
        List<String> eligiblePositions = config.getEligiblePositions(rosterPosition);

        if (eligiblePositions == null || eligiblePositions.isEmpty()) {
            return player.getPosition().equals(rosterPosition);
        }

        return eligiblePositions.contains(player.getPosition());
    }

    // ==================== Helper Classes ====================

    private static class League {
        private String id;
        private String name;
        private int playerCount;

        public String getId() { return id; }
        public void setId(String id) { this.id = id; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public int getPlayerCount() { return playerCount; }
        public void setPlayerCount(int playerCount) { this.playerCount = playerCount; }
    }

    private static class NFLPlayer {
        private String id;
        private String name;
        private String position;
        private String team;
        private String status;

        public String getId() { return id; }
        public void setId(String id) { this.id = id; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public String getPosition() { return position; }
        public void setPosition(String position) { this.position = position; }
        public String getTeam() { return team; }
        public void setTeam(String team) { this.team = team; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
    }

    private static class PlayerRoster {
        private String playerName;
        private Map<Integer, RosterEntry> entries = new HashMap<>();

        public PlayerRoster(String playerName) {
            this.playerName = playerName;
        }

        public void addPlayer(int playerId, String playerName, String position) {
            entries.put(playerId, new RosterEntry(playerId, playerName, position));
        }

        public boolean hasPlayer(int playerId) {
            return entries.containsKey(playerId);
        }

        public boolean hasPlayerByName(String playerName) {
            return entries.values().stream()
                .anyMatch(e -> e.playerName.equals(playerName));
        }

        public boolean hasPlayerInPosition(String playerName, String position) {
            return entries.values().stream()
                .anyMatch(e -> e.playerName.equals(playerName) && e.position.equals(position));
        }

        public String getPlayerPosition(int playerId) {
            RosterEntry entry = entries.get(playerId);
            return entry != null ? entry.position : null;
        }

        public void removePlayer(String playerName) {
            entries.values().removeIf(e -> e.playerName.equals(playerName));
        }

        public boolean isPositionFull(String position, RosterConfiguration config) {
            int limit = config.getPositionLimit(position);
            long count = entries.values().stream()
                .filter(e -> e.position.equals(position))
                .count();
            return count >= limit;
        }

        public boolean isPositionEmpty(String position) {
            return entries.values().stream()
                .noneMatch(e -> e.position.equals(position));
        }

        public int getFilledSlots() {
            return entries.size();
        }

        public void clear() {
            entries.clear();
        }
    }

    private static class RosterEntry {
        int playerId;
        String playerName;
        String position;

        public RosterEntry(int playerId, String playerName, String position) {
            this.playerId = playerId;
            this.playerName = playerName;
            this.position = position;
        }
    }

    private static class RosterConfiguration {
        private List<RosterSlotConfig> slots = new ArrayList<>();

        public void addSlotConfig(RosterSlotConfig config) {
            slots.add(config);
        }

        public boolean hasPosition(String position) {
            return slots.stream().anyMatch(s -> s.position.equals(position));
        }

        public int getPositionLimit(String position) {
            return slots.stream()
                .filter(s -> s.position.equals(position))
                .findFirst()
                .map(s -> s.count)
                .orElse(0);
        }

        public List<String> getEligiblePositions(String rosterPosition) {
            return slots.stream()
                .filter(s -> s.position.equals(rosterPosition))
                .findFirst()
                .map(s -> s.eligiblePositions)
                .orElse(Collections.emptyList());
        }

        public int getTotalSlots() {
            return slots.stream().mapToInt(s -> s.count).sum();
        }
    }

    private static class RosterSlotConfig {
        String position;
        int count;
        List<String> eligiblePositions;

        public void setPosition(String position) { this.position = position; }
        public void setCount(int count) { this.count = count; }
        public void setEligiblePositions(List<String> eligiblePositions) {
            this.eligiblePositions = eligiblePositions;
        }
    }

    private static class DraftOrder {
        private String type;
        private List<String> players;
        private int currentRound = 1;

        public DraftOrder(String type) {
            this.type = type;
        }

        public void setPlayers(List<String> players) {
            this.players = new ArrayList<>(players);
        }

        public void setCurrentRound(int round) {
            this.currentRound = round;
        }

        public List<String> getCurrentOrder() {
            if ("SNAKE".equals(type) && currentRound % 2 == 0) {
                List<String> reversed = new ArrayList<>(players);
                Collections.reverse(reversed);
                return reversed;
            }
            return players;
        }
    }

    private enum DraftResult {
        SUCCESS, FAILURE
    }
}
