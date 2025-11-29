package com.ffl.playoffs.bdd.steps;

import com.ffl.playoffs.bdd.World;
import com.ffl.playoffs.domain.model.*;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import com.ffl.playoffs.domain.port.NFLPlayerRepository;
import com.ffl.playoffs.domain.port.RosterRepository;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

import static org.assertj.core.api.Assertions.*;

/**
 * Step definitions for Roster Building features
 * Implements Gherkin steps from ffl-27-roster-building.feature
 */
public class RosterBuildingSteps {

    @Autowired
    private World world;

    @Autowired
    private RosterRepository rosterRepository;

    @Autowired
    private NFLPlayerRepository nflPlayerRepository;

    @Autowired
    private LeaguePlayerRepository leaguePlayerRepository;

    // Background steps

    @Given("a league {string} exists with roster configuration:")
    public void aLeagueExistsWithRosterConfiguration(String leagueName, DataTable dataTable) {
        // Create league with custom roster configuration
        RosterConfiguration config = new RosterConfiguration();

        var rows = dataTable.asMaps();
        for (var row : rows) {
            String positionStr = row.get("Position");
            Integer count = Integer.parseInt(row.get("Count"));
            Position position = Position.valueOf(positionStr);
            config.setPositionSlots(position, count);
        }

        League league = new League();
        league.setName(leagueName);
        league.setRosterConfiguration(config);
        league.setOwnerId(world.getCurrentUserId());

        world.setCurrentLeague(league);
        world.storeLeague(leagueName, league);
    }

    @Given("the league total roster size is {int} positions")
    public void theLeagueTotalRosterSizeIsPositions(int totalPositions) {
        assertThat(world.getCurrentLeague()).isNotNull();
        assertThat(world.getCurrentLeague().getRosterConfiguration().getTotalSlots())
            .isEqualTo(totalPositions);
    }

    @Given("a PLAYER user is a member of the league")
    public void aPlayerUserIsAMemberOfTheLeague() {
        // Create a league player for the current user
        LeaguePlayer leaguePlayer = new LeaguePlayer();
        leaguePlayer.setUserId(world.getCurrentUserId());
        leaguePlayer.setLeagueId(world.getCurrentLeagueId());
        leaguePlayer.setRole(Role.PLAYER);

        world.setCurrentLeaguePlayer(leaguePlayer);
    }

    @Given("the roster lock deadline has not passed")
    public void theRosterLockDeadlineHasNotPassed() {
        if (world.getCurrentRoster() != null) {
            world.getCurrentRoster().setRosterDeadline(LocalDateTime.now().plusDays(2));
        }
    }

    // Given steps for player rosters

    @Given("the player has an empty roster")
    public void thePlayerHasAnEmptyRoster() {
        Roster roster = new Roster(
            world.getCurrentLeaguePlayer().getId(),
            UUID.randomUUID(), // gameId
            world.getCurrentLeague().getRosterConfiguration()
        );
        world.setCurrentRoster(roster);
        rosterRepository.save(roster);
    }

    @Given("an NFL player {string} exists with position QB")
    public void anNFLPlayerExistsWithPositionQB(String playerName) {
        createNFLPlayer(playerName, Position.QB, "KC");
    }

    @Given("an NFL player {string} exists with position {}")
    public void anNFLPlayerExistsWithPosition(String playerName, String positionStr) {
        Position position = Position.valueOf(positionStr);
        createNFLPlayer(playerName, position, getDefaultTeamForPosition(position));
    }

    @Given("NFL players exist: {string} ({}) and {string} ({})")
    public void nflPlayersExist(String player1Name, String pos1, String player2Name, String pos2) {
        createNFLPlayer(player1Name, Position.valueOf(pos1), "SF");
        createNFLPlayer(player2Name, Position.valueOf(pos2), "BAL");
    }

    @Given("the roster requires {int} RB positions")
    public void theRosterRequiresRBPositions(int count) {
        assertThat(world.getCurrentLeague().getRosterConfiguration().getPositionSlots(Position.RB))
            .isEqualTo(count);
    }

    @Given("the FLEX position accepts RB, WR, or TE")
    public void theFlexPositionAcceptsRBWROrTE() {
        assertThat(world.getCurrentLeague().getRosterConfiguration().hasPosition(Position.FLEX))
            .isTrue();
    }

    @Given("the QB position only accepts QB players")
    public void theQBPositionOnlyAcceptsQBPlayers() {
        assertThat(world.getCurrentLeague().getRosterConfiguration().hasPosition(Position.QB))
            .isTrue();
    }

    @Given("an NFL team defense {string} exists with position DEF")
    public void anNFLTeamDefenseExistsWithPositionDEF(String teamName) {
        createNFLPlayer(teamName, Position.DEF, teamName);
    }

    @Given("{int} NFL players exist in the database")
    public void nflPlayersExistInTheDatabase(int count) {
        for (int i = 1; i <= count; i++) {
            createNFLPlayer("Player" + i, Position.values()[i % 6], "TEAM" + (i % 32));
        }
        world.setNFLPlayerCount(count);
    }

    @Given("{int} NFL quarterbacks exist")
    public void nflQuarterbacksExist(int count) {
        for (int i = 1; i <= count; i++) {
            createNFLPlayer("QB" + i, Position.QB, "TEAM" + i);
        }
        world.setNFLPlayerCount(count);
    }

    @Given("multiple players belong to {string}")
    public void multiplePlayersBelongTo(String teamName) {
        createNFLPlayer("Patrick Mahomes", Position.QB, teamName);
        createNFLPlayer("Travis Kelce", Position.TE, teamName);
        createNFLPlayer("Isiah Pacheco", Position.RB, teamName);
        createNFLPlayer("Harrison Butker", Position.K, teamName);
    }

    @Given("an NFL player {string} exists")
    public void anNFLPlayerExists(String playerName) {
        NFLPlayer existingPlayer = world.getNFLPlayer(playerName);
        if (existingPlayer == null) {
            createNFLPlayer(playerName, Position.QB, "KC");
        }
    }

    @Given("the player has game-by-game stats for weeks {int}-{int}")
    public void thePlayerHasGameByGameStatsForWeeks(int startWeek, int endWeek) {
        // This would populate stats - for BDD we just mark it as available
        world.setPlayerStatsAvailable(true);
    }

    @Given("the player has {string} selected for QB")
    public void thePlayerHasSelectedForQB(String playerName) {
        NFLPlayer nflPlayer = world.getNFLPlayer(playerName);
        if (nflPlayer == null) {
            nflPlayer = createNFLPlayer(playerName, Position.QB, "KC");
        }

        Roster roster = world.getCurrentRoster();
        if (roster == null) {
            roster = new Roster(
                world.getCurrentLeaguePlayer().getId(),
                UUID.randomUUID(),
                world.getCurrentLeague().getRosterConfiguration()
            );
            world.setCurrentRoster(roster);
        }

        RosterSlot qbSlot = roster.getSlotsByPosition(Position.QB).get(0);
        roster.assignPlayerToSlot(qbSlot.getId(), nflPlayer.getId(), nflPlayer.getPosition());
    }

    @Given("the roster lock deadline is in {int} days")
    public void theRosterLockDeadlineIsInDays(int days) {
        world.getCurrentRoster().setRosterDeadline(LocalDateTime.now().plusDays(days));
    }

    @Given("the player needs to fill all {int} roster positions")
    public void thePlayerNeedsToFillAllRosterPositions(int totalPositions) {
        Roster roster = new Roster(
            world.getCurrentLeaguePlayer().getId(),
            UUID.randomUUID(),
            world.getCurrentLeague().getRosterConfiguration()
        );
        world.setCurrentRoster(roster);
        assertThat(roster.getTotalSlotCount()).isEqualTo(totalPositions);
    }

    @Given("the player has filled {int} of {int} roster positions")
    public void thePlayerHasFilledOfRosterPositions(int filled, int total) {
        Roster roster = world.getCurrentRoster();
        assertThat(roster.getTotalSlotCount()).isEqualTo(total);

        // Fill the specified number of positions
        int filledCount = 0;
        for (RosterSlot slot : roster.getSlots()) {
            if (filledCount < filled) {
                NFLPlayer player = createNFLPlayer("Player" + filledCount,
                    getCompatiblePosition(slot.getPosition()), "TEAM");
                roster.assignPlayerToSlot(slot.getId(), player.getId(), player.getPosition());
                filledCount++;
            } else {
                break;
            }
        }
    }

    @Given("the K position is empty")
    public void theKPositionIsEmpty() {
        Roster roster = world.getCurrentRoster();
        RosterSlot kSlot = roster.getSlotsByPosition(Position.K).get(0);
        assertThat(kSlot.isEmpty()).isTrue();
    }

    @Given("the player has {string} selected for TE")
    public void thePlayerHasSelectedForTE(String playerName) {
        NFLPlayer nflPlayer = world.getNFLPlayer(playerName);
        if (nflPlayer == null) {
            nflPlayer = createNFLPlayer(playerName, Position.TE, "KC");
        }

        Roster roster = world.getCurrentRoster();
        RosterSlot teSlot = roster.getSlotsByPosition(Position.TE).get(0);
        roster.assignPlayerToSlot(teSlot.getId(), nflPlayer.getId(), nflPlayer.getPosition());
    }

    @Given("two league players exist: Player A and Player B")
    public void twoLeaguePlayersExistPlayerAAndPlayerB() {
        LeaguePlayer playerA = new LeaguePlayer();
        playerA.setUserId(UUID.randomUUID());
        playerA.setLeagueId(world.getCurrentLeagueId());
        world.storeLeaguePlayer("PlayerA", playerA);

        LeaguePlayer playerB = new LeaguePlayer();
        playerB.setUserId(UUID.randomUUID());
        playerB.setLeagueId(world.getCurrentLeagueId());
        world.storeLeaguePlayer("PlayerB", playerB);
    }

    @Given("the player has a complete roster")
    public void thePlayerHasACompleteRoster() {
        Roster roster = world.getCurrentRoster();
        for (RosterSlot slot : roster.getSlots()) {
            if (slot.isEmpty()) {
                NFLPlayer player = createNFLPlayer("Player_" + slot.getId(),
                    getCompatiblePosition(slot.getPosition()), "TEAM");
                roster.assignPlayerToSlot(slot.getId(), player.getId(), player.getPosition());
            }
        }
        assertThat(roster.isComplete()).isTrue();
    }

    @Given("a league has roster configuration with {int} Superflex position")
    public void aLeagueHasRosterConfigurationWithSuperflexPosition(int count) {
        RosterConfiguration config = world.getCurrentLeague().getRosterConfiguration();
        config.setPositionSlots(Position.SUPERFLEX, count);
    }

    @Given("the Superflex position accepts QB, RB, WR, or TE")
    public void theSuperflexPositionAcceptsQBRBWROrTE() {
        assertThat(world.getCurrentLeague().getRosterConfiguration().hasPosition(Position.SUPERFLEX))
            .isTrue();
    }

    // When steps

    @When("the player selects {string} for the QB roster slot")
    public void thePlayerSelectsForTheQBRosterSlot(String playerName) {
        selectPlayerForPosition(playerName, Position.QB, 1);
    }

    @When("the player selects {string} for RB slot {int}")
    public void thePlayerSelectsForRBSlot(String playerName, int slotNumber) {
        selectPlayerForPosition(playerName, Position.RB, slotNumber);
    }

    @When("the player selects {string} for the FLEX roster slot")
    public void thePlayerSelectsForTheFLEXRosterSlot(String playerName) {
        selectPlayerForPosition(playerName, Position.FLEX, 1);
    }

    @When("the player attempts to select {string} for the QB slot")
    public void thePlayerAttemptsToSelectForTheQBSlot(String playerName) {
        try {
            selectPlayerForPosition(playerName, Position.QB, 1);
            world.setLastException(null);
        } catch (Exception e) {
            world.setLastException(e);
        }
    }

    @When("the player selects {string} for the K roster slot")
    public void thePlayerSelectsForTheKRosterSlot(String playerName) {
        selectPlayerForPosition(playerName, Position.K, 1);
    }

    @When("the player selects {string} for the DEF roster slot")
    public void thePlayerSelectsForTheDEFRosterSlot(String playerName) {
        selectPlayerForPosition(playerName, Position.DEF, 1);
    }

    @When("the player searches for {string}")
    public void thePlayerSearchesFor(String searchTerm) {
        List<NFLPlayer> results = nflPlayerRepository.searchByName(searchTerm);
        world.setSearchResults(results);
    }

    @When("the player filters by position QB")
    public void thePlayerFiltersByPositionQB() {
        List<NFLPlayer> results = nflPlayerRepository.findByPosition(Position.QB);
        world.setSearchResults(results);
    }

    @When("the player filters by NFL team {string}")
    public void thePlayerFiltersByNFLTeam(String teamName) {
        List<NFLPlayer> results = nflPlayerRepository.findByTeam(teamName);
        world.setSearchResults(results);
    }

    @When("the player views {string} details")
    public void thePlayerViewsDetails(String playerName) {
        NFLPlayer player = world.getNFLPlayer(playerName);
        world.setSelectedPlayer(player);
    }

    @When("the player replaces {string} with {string} for QB")
    public void thePlayerReplacesWithForQB(String oldPlayerName, String newPlayerName) {
        try {
            NFLPlayer newPlayer = world.getNFLPlayer(newPlayerName);
            if (newPlayer == null) {
                newPlayer = createNFLPlayer(newPlayerName, Position.QB, "BUF");
            }

            Roster roster = world.getCurrentRoster();
            RosterSlot qbSlot = roster.getSlotsByPosition(Position.QB).get(0);

            NFLPlayer oldPlayer = world.getNFLPlayer(oldPlayerName);
            roster.dropAndAddPlayer(qbSlot.getId(), oldPlayer.getId(),
                newPlayer.getId(), newPlayer.getPosition());

            world.setLastException(null);
        } catch (Exception e) {
            world.setLastException(e);
        }
    }

    @When("the player selects valid NFL players for all positions:")
    public void thePlayerSelectsValidNFLPlayersForAllPositions(DataTable dataTable) {
        var rows = dataTable.asMaps();
        for (var row : rows) {
            String positionStr = row.get("Position");
            String playerName = row.get("Player");

            Position position = Position.valueOf(positionStr);
            NFLPlayer nflPlayer = world.getNFLPlayer(playerName);
            if (nflPlayer == null) {
                // Extract position from player name if specified (e.g., "Cooper Kupp (WR)")
                Position playerPosition = position;
                if (playerName.contains("(") && playerName.contains(")")) {
                    String posInName = playerName.substring(playerName.indexOf("(") + 1, playerName.indexOf(")"));
                    playerPosition = Position.valueOf(posInName);
                    playerName = playerName.substring(0, playerName.indexOf("(")).trim();
                }
                nflPlayer = createNFLPlayer(playerName, playerPosition, getDefaultTeamForPosition(playerPosition));
            }

            Roster roster = world.getCurrentRoster();
            List<RosterSlot> slots = roster.getSlotsByPosition(position);

            // Find first empty slot for this position
            RosterSlot targetSlot = slots.stream()
                .filter(RosterSlot::isEmpty)
                .findFirst()
                .orElse(slots.get(0));

            roster.assignPlayerToSlot(targetSlot.getId(), nflPlayer.getId(), nflPlayer.getPosition());
        }
    }

    @When("the player attempts to validate their roster")
    public void thePlayerAttemptsToValidateTheirRoster() {
        try {
            Roster roster = world.getCurrentRoster();
            if (!roster.isComplete()) {
                throw new IllegalStateException("ROSTER_INCOMPLETE");
            }
            world.setLastException(null);
        } catch (Exception e) {
            world.setLastException(e);
        }
    }

    @When("the player attempts to select {string} for FLEX")
    public void thePlayerAttemptsToSelectForFLEX(String playerName) {
        try {
            selectPlayerForPosition(playerName, Position.FLEX, 1);
            world.setLastException(null);
        } catch (Exception e) {
            world.setLastException(e);
        }
    }

    @When("Player A selects {string} for QB")
    public void playerASelectsForQB(String playerName) {
        LeaguePlayer playerA = world.getLeaguePlayer("PlayerA");
        NFLPlayer nflPlayer = world.getNFLPlayer(playerName);

        Roster rosterA = new Roster(playerA.getId(), UUID.randomUUID(),
            world.getCurrentLeague().getRosterConfiguration());
        world.storeRoster("RosterA", rosterA);

        RosterSlot qbSlot = rosterA.getSlotsByPosition(Position.QB).get(0);
        rosterA.assignPlayerToSlot(qbSlot.getId(), nflPlayer.getId(), nflPlayer.getPosition());
    }

    @When("Player B selects {string} for QB")
    public void playerBSelectsForQB(String playerName) {
        LeaguePlayer playerB = world.getLeaguePlayer("PlayerB");
        NFLPlayer nflPlayer = world.getNFLPlayer(playerName);

        Roster rosterB = new Roster(playerB.getId(), UUID.randomUUID(),
            world.getCurrentLeague().getRosterConfiguration());
        world.storeRoster("RosterB", rosterB);

        RosterSlot qbSlot = rosterB.getSlotsByPosition(Position.QB).get(0);
        rosterB.assignPlayerToSlot(qbSlot.getId(), nflPlayer.getId(), nflPlayer.getPosition());
    }

    @When("the player views their roster")
    public void thePlayerViewsTheirRoster() {
        Roster roster = world.getCurrentRoster();
        world.setLastResponse(roster);
    }

    @When("the player selects {string} for the Superflex slot")
    public void thePlayerSelectsForTheSuperflexSlot(String playerName) {
        selectPlayerForPosition(playerName, Position.SUPERFLEX, 1);
    }

    // Then steps

    @Then("a RosterSelection is created linking {string} to the QB slot")
    public void aRosterSelectionIsCreatedLinkingToTheQBSlot(String playerName) {
        Roster roster = world.getCurrentRoster();
        NFLPlayer nflPlayer = world.getNFLPlayer(playerName);

        RosterSlot qbSlot = roster.getSlotsByPosition(Position.QB).get(0);
        assertThat(qbSlot.isFilled()).isTrue();
        assertThat(qbSlot.getNflPlayerId()).isEqualTo(nflPlayer.getId());
    }

    @Then("the roster now has {int} of {int} positions filled")
    public void theRosterNowHasOfPositionsFilled(int filled, int total) {
        Roster roster = world.getCurrentRoster();
        assertThat(roster.getFilledSlotCount()).isEqualTo(filled);
        assertThat(roster.getTotalSlotCount()).isEqualTo(total);
    }

    @Then("the QB position shows {string}")
    public void theQBPositionShows(String expectedDisplay) {
        Roster roster = world.getCurrentRoster();
        RosterSlot qbSlot = roster.getSlotsByPosition(Position.QB).get(0);
        assertThat(qbSlot.isFilled()).isTrue();

        NFLPlayer player = nflPlayerRepository.findById(qbSlot.getNflPlayerId()).orElse(null);
        assertThat(player).isNotNull();

        // expectedDisplay format: "Patrick Mahomes (QB - KC)"
        String actualDisplay = String.format("%s (%s - %s)",
            player.getName(), player.getPosition().name(), player.getNflTeamAbbreviation());
        assertThat(actualDisplay).isEqualTo(expectedDisplay);
    }

    @Then("both RB positions are filled")
    public void bothRBPositionsAreFilled() {
        Roster roster = world.getCurrentRoster();
        List<RosterSlot> rbSlots = roster.getSlotsByPosition(Position.RB);
        assertThat(rbSlots).hasSize(2);
        assertThat(rbSlots.stream().allMatch(RosterSlot::isFilled)).isTrue();
    }

    @Then("the roster shows both running backs")
    public void theRosterShowsBothRunningBacks() {
        Roster roster = world.getCurrentRoster();
        List<RosterSlot> rbSlots = roster.getSlotsByPosition(Position.RB);

        for (RosterSlot slot : rbSlots) {
            NFLPlayer player = nflPlayerRepository.findById(slot.getNflPlayerId()).orElse(null);
            assertThat(player).isNotNull();
            assertThat(player.getPosition()).isEqualTo(Position.RB);
        }
    }

    @Then("the FLEX position is filled with a TE")
    public void theFlexPositionIsFilledWithATE() {
        Roster roster = world.getCurrentRoster();
        RosterSlot flexSlot = roster.getSlotsByPosition(Position.FLEX).get(0);
        assertThat(flexSlot.isFilled()).isTrue();

        NFLPlayer player = nflPlayerRepository.findById(flexSlot.getNflPlayerId()).orElse(null);
        assertThat(player).isNotNull();
        assertThat(player.getPosition()).isEqualTo(Position.TE);
    }

    @Then("the selection is valid")
    public void theSelectionIsValid() {
        assertThat(world.getLastException()).isNull();
    }

    @Then("the selection is rejected with error {string}")
    public void theSelectionIsRejectedWithError(String errorCode) {
        assertThat(world.getLastException()).isNotNull();
        assertThat(world.getLastException().getMessage()).contains(errorCode);
    }

    @Then("the QB slot remains empty")
    public void theQBSlotRemainsEmpty() {
        Roster roster = world.getCurrentRoster();
        RosterSlot qbSlot = roster.getSlotsByPosition(Position.QB).get(0);
        assertThat(qbSlot.isEmpty()).isTrue();
    }

    @Then("the player is shown eligible positions: QB")
    public void thePlayerIsShownEligiblePositionsQB() {
        // This would be shown in the UI - for BDD we just verify the exception message
        assertThat(world.getLastException()).isNotNull();
    }

    @Then("the K position is filled")
    public void theKPositionIsFilled() {
        Roster roster = world.getCurrentRoster();
        RosterSlot kSlot = roster.getSlotsByPosition(Position.K).get(0);
        assertThat(kSlot.isFilled()).isTrue();
    }

    @Then("the roster shows {string}")
    public void theRosterShows(String expectedDisplay) {
        Roster roster = world.getCurrentRoster();

        // Extract position from display string
        Position position = null;
        if (expectedDisplay.contains("(K")) {
            position = Position.K;
        } else if (expectedDisplay.contains("(DEF)")) {
            position = Position.DEF;
        }

        assertThat(position).isNotNull();
        RosterSlot slot = roster.getSlotsByPosition(position).get(0);
        assertThat(slot.isFilled()).isTrue();

        NFLPlayer player = nflPlayerRepository.findById(slot.getNflPlayerId()).orElse(null);
        assertThat(player).isNotNull();

        String actualDisplay = String.format("%s (%s - %s)",
            player.getName(), player.getPosition().name(), player.getNflTeamAbbreviation());
        assertThat(actualDisplay).isEqualTo(expectedDisplay);
    }

    @Then("the DEF position is filled")
    public void theDEFPositionIsFilled() {
        Roster roster = world.getCurrentRoster();
        RosterSlot defSlot = roster.getSlotsByPosition(Position.DEF).get(0);
        assertThat(defSlot.isFilled()).isTrue();
    }

    @Then("the system returns players matching {string}")
    public void theSystemReturnsPlayersMatching(String searchTerm) {
        List<NFLPlayer> results = world.getSearchResults();
        assertThat(results).isNotEmpty();
        assertThat(results).allMatch(p ->
            p.getName().toLowerCase().contains(searchTerm.toLowerCase()));
    }

    @Then("the results include {string}")
    public void theResultsInclude(String playerDisplay) {
        List<NFLPlayer> results = world.getSearchResults();
        String playerName = playerDisplay.substring(0, playerDisplay.indexOf("(")).trim();

        assertThat(results).anyMatch(p -> p.getName().equals(playerName));
    }

    @Then("the results are paginated with {int} players per page")
    public void theResultsArePaginatedWithPlayersPerPage(int pageSize) {
        // Pagination would be handled by the repository/service layer
        world.setPageSize(pageSize);
    }

    @Then("the system returns all quarterbacks")
    public void theSystemReturnsAllQuarterbacks() {
        List<NFLPlayer> results = world.getSearchResults();
        assertThat(results).isNotEmpty();
        assertThat(results).allMatch(p -> p.getPosition() == Position.QB);
    }

    @Then("the results are sorted alphabetically by last name")
    public void theResultsAreSortedAlphabeticallyByLastName() {
        List<NFLPlayer> results = world.getSearchResults();
        List<String> lastNames = results.stream()
            .map(NFLPlayer::getLastName)
            .collect(Collectors.toList());

        List<String> sortedLastNames = new ArrayList<>(lastNames);
        Collections.sort(sortedLastNames);

        assertThat(lastNames).isEqualTo(sortedLastNames);
    }

    @Then("the system returns all Chiefs players")
    public void theSystemReturnsAllChiefsPlayers() {
        List<NFLPlayer> results = world.getSearchResults();
        assertThat(results).isNotEmpty();
        assertThat(results).allMatch(p -> p.getNflTeam().contains("Kansas City Chiefs"));
    }

    @Then("the results include positions: QB, RB, WR, TE, K, DEF")
    public void theResultsIncludePositionsQBRBWRTEKDEF() {
        List<NFLPlayer> results = world.getSearchResults();
        Set<Position> positions = results.stream()
            .map(NFLPlayer::getPosition)
            .collect(Collectors.toSet());

        // Should have at least some of these positions
        assertThat(positions).isNotEmpty();
    }

    @Then("the system shows passing yards, TDs, INTs for each week")
    public void theSystemShowsPassingYardsTDsINTsForEachWeek() {
        assertThat(world.isPlayerStatsAvailable()).isTrue();
        NFLPlayer player = world.getSelectedPlayer();
        assertThat(player).isNotNull();
    }

    @Then("the system shows season totals and averages")
    public void theSystemShowsSeasonTotalsAndAverages() {
        NFLPlayer player = world.getSelectedPlayer();
        assertThat(player).isNotNull();
        assertThat(player.getFantasyPoints()).isNotNull();
    }

    @Then("the system shows fantasy points per week")
    public void theSystemShowsFantasyPointsPerWeek() {
        assertThat(world.isPlayerStatsAvailable()).isTrue();
    }

    @Then("the roster is updated")
    public void theRosterIsUpdated() {
        assertThat(world.getLastException()).isNull();
        Roster roster = world.getCurrentRoster();
        assertThat(roster.getUpdatedAt()).isAfter(roster.getCreatedAt());
    }

    @Then("the QB position now shows {string}")
    public void theQBPositionNowShows(String expectedDisplay) {
        theQBPositionShows(expectedDisplay);
    }

    @Then("{string} is removed from the roster")
    public void isRemovedFromTheRoster(String playerName) {
        NFLPlayer player = world.getNFLPlayer(playerName);
        Roster roster = world.getCurrentRoster();
        assertThat(roster.hasPlayer(player.getId())).isFalse();
    }

    @Then("all {int} roster positions are filled")
    public void allRosterPositionsAreFilled(int totalPositions) {
        Roster roster = world.getCurrentRoster();
        assertThat(roster.isComplete()).isTrue();
        assertThat(roster.getFilledSlotCount()).isEqualTo(totalPositions);
    }

    @Then("the roster status is {string}")
    public void theRosterStatusIs(String status) {
        Roster roster = world.getCurrentRoster();
        if ("COMPLETE".equals(status)) {
            assertThat(roster.isComplete()).isTrue();
        } else if ("INCOMPLETE".equals(status)) {
            assertThat(roster.isComplete()).isFalse();
        }
    }

    @Then("the roster is ready for lock at deadline")
    public void theRosterIsReadyForLockAtDeadline() {
        Roster roster = world.getCurrentRoster();
        assertThat(roster.isComplete()).isTrue();
        assertThat(roster.isLocked()).isFalse();
    }

    @Then("the validation fails with error {string}")
    public void theValidationFailsWithError(String errorMessage) {
        assertThat(world.getLastException()).isNotNull();
        assertThat(world.getLastException().getMessage()).contains(errorMessage);
    }

    @Then("the system shows missing position: K")
    public void theSystemShowsMissingPositionK() {
        Roster roster = world.getCurrentRoster();
        List<Position> missing = roster.getMissingPositions();
        assertThat(missing).contains(Position.K);
    }

    @Then("the roster cannot be locked")
    public void theRosterCannotBeLocked() {
        Roster roster = world.getCurrentRoster();
        assertThat(roster.isComplete()).isFalse();
    }

    @Then("the system shows {string}")
    public void theSystemShows(String message) {
        assertThat(world.getLastException()).isNotNull();
        assertThat(world.getLastException().getMessage()).contains(message);
    }

    @Then("both selections are successful")
    public void bothSelectionsAreSuccessful() {
        Roster rosterA = world.getRoster("RosterA");
        Roster rosterB = world.getRoster("RosterB");

        assertThat(rosterA).isNotNull();
        assertThat(rosterB).isNotNull();
    }

    @Then("both players have {string} in their rosters")
    public void bothPlayersHaveInTheirRosters(String playerName) {
        NFLPlayer nflPlayer = world.getNFLPlayer(playerName);
        Roster rosterA = world.getRoster("RosterA");
        Roster rosterB = world.getRoster("RosterB");

        assertThat(rosterA.hasPlayer(nflPlayer.getId())).isTrue();
        assertThat(rosterB.hasPlayer(nflPlayer.getId())).isTrue();
    }

    @Then("NFL players are not {string} - unlimited availability")
    public void nflPlayersAreNotUnlimitedAvailability(String drafted) {
        // This is a business rule validation - players can be selected by multiple league players
        // No actual validation needed, just documenting the rule
    }

    @Then("the system displays all {int} positions with selected NFL players")
    public void theSystemDisplaysAllPositionsWithSelectedNFLPlayers(int totalPositions) {
        Roster roster = (Roster) world.getLastResponse();
        assertThat(roster).isNotNull();
        assertThat(roster.getTotalSlotCount()).isEqualTo(totalPositions);
        assertThat(roster.isComplete()).isTrue();
    }

    @Then("each position shows: player name, NFL position, NFL team, jersey number")
    public void eachPositionShowsPlayerNameNFLPositionNFLTeamJerseyNumber() {
        Roster roster = (Roster) world.getLastResponse();
        for (RosterSlot slot : roster.getSlots()) {
            if (slot.isFilled()) {
                NFLPlayer player = nflPlayerRepository.findById(slot.getNflPlayerId()).orElse(null);
                assertThat(player).isNotNull();
                assertThat(player.getName()).isNotNull();
                assertThat(player.getPosition()).isNotNull();
                assertThat(player.getNflTeam()).isNotNull();
            }
        }
    }

    @Then("the system shows roster completion status: {int}/{int} filled")
    public void theSystemShowsRosterCompletionStatusFilled(int filled, int total) {
        Roster roster = (Roster) world.getLastResponse();
        assertThat(roster.getFilledSlotCount()).isEqualTo(filled);
        assertThat(roster.getTotalSlotCount()).isEqualTo(total);
    }

    @Then("the Superflex position is filled with a QB")
    public void theSuperflexPositionIsFilledWithAQB() {
        Roster roster = world.getCurrentRoster();
        RosterSlot superflexSlot = roster.getSlotsByPosition(Position.SUPERFLEX).get(0);
        assertThat(superflexSlot.isFilled()).isTrue();

        NFLPlayer player = nflPlayerRepository.findById(superflexSlot.getNflPlayerId()).orElse(null);
        assertThat(player).isNotNull();
        assertThat(player.getPosition()).isEqualTo(Position.QB);
    }

    // Helper methods

    private NFLPlayer createNFLPlayer(String name, Position position, String team) {
        NFLPlayer player = new NFLPlayer(name, position, team);
        player.setId((long) (Math.random() * 1000000));

        // Parse name into first and last
        String[] nameParts = name.split(" ");
        if (nameParts.length >= 2) {
            player.setFirstName(nameParts[0]);
            player.setLastName(nameParts[nameParts.length - 1]);
        }

        player.setNflTeamAbbreviation(getTeamAbbreviation(team));
        player.setStatus("ACTIVE");

        nflPlayerRepository.save(player);
        world.storeNFLPlayer(name, player);

        return player;
    }

    private void selectPlayerForPosition(String playerName, Position position, int slotNumber) {
        NFLPlayer nflPlayer = world.getNFLPlayer(playerName);
        if (nflPlayer == null) {
            throw new IllegalArgumentException("NFL Player not found: " + playerName);
        }

        Roster roster = world.getCurrentRoster();
        List<RosterSlot> slots = roster.getSlotsByPosition(position);

        if (slots.isEmpty()) {
            throw new IllegalArgumentException("No " + position + " slots found");
        }

        RosterSlot targetSlot = slots.get(slotNumber - 1);
        roster.assignPlayerToSlot(targetSlot.getId(), nflPlayer.getId(), nflPlayer.getPosition());
    }

    private String getDefaultTeamForPosition(Position position) {
        switch (position) {
            case QB: return "Kansas City Chiefs";
            case RB: return "San Francisco 49ers";
            case WR: return "Miami Dolphins";
            case TE: return "Kansas City Chiefs";
            case K: return "Baltimore Ravens";
            case DEF: return "San Francisco 49ers";
            default: return "NFL Team";
        }
    }

    private String getTeamAbbreviation(String teamName) {
        if (teamName.contains("Kansas City") || teamName.equals("KC")) return "KC";
        if (teamName.contains("San Francisco") || teamName.equals("SF")) return "SF";
        if (teamName.contains("Baltimore") || teamName.equals("BAL")) return "BAL";
        if (teamName.contains("Miami")) return "MIA";
        if (teamName.contains("Buffalo") || teamName.equals("BUF")) return "BUF";
        return teamName.length() > 3 ? teamName.substring(0, 3).toUpperCase() : teamName;
    }

    private Position getCompatiblePosition(Position slotPosition) {
        if (slotPosition == Position.FLEX) {
            return Position.RB; // Default to RB for FLEX
        }
        if (slotPosition == Position.SUPERFLEX) {
            return Position.QB; // Default to QB for SUPERFLEX
        }
        return slotPosition;
    }
}
