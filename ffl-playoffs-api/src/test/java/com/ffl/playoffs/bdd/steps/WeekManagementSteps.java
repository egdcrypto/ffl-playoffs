package com.ffl.playoffs.bdd.steps;

import com.ffl.playoffs.application.service.WeekService;
import com.ffl.playoffs.bdd.World;
import com.ffl.playoffs.domain.model.League;
import com.ffl.playoffs.domain.model.Week;
import com.ffl.playoffs.domain.model.WeekStatus;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.WeekRepository;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

/**
 * Step definitions for Week Management features
 * Implements Gherkin steps from ffl-32-week-management.feature
 */
public class WeekManagementSteps {

    @Autowired
    private World world;

    @Autowired
    private WeekService weekService;

    @Autowired
    private WeekRepository weekRepository;

    @Autowired
    private LeagueRepository leagueRepository;

    private List<Week> createdWeeks;
    private Week currentWeek;
    private Exception lastException;
    private Integer currentNflWeek;

    // Background steps

    @Given("I am authenticated as an admin")
    public void iAmAuthenticatedAsAnAdmin() {
        // This is typically handled by AuthenticationSteps
        // For now, we'll assume the world has a current user set
        assertThat(world.getCurrentUser()).isNotNull();
    }

    @Given("I own a league {string}")
    public void iOwnALeague(String leagueName) {
        // Create a league owned by the current user
        League league = new League();
        league.setName(leagueName);
        league.setCode("TEST" + System.currentTimeMillis());
        league.setOwnerId(world.getCurrentUserId());
        league.setStatus(League.LeagueStatus.CREATED);
        league.setStartingWeek(15);
        league.setNumberOfWeeks(4);

        League savedLeague = leagueRepository.save(league);
        world.setCurrentLeague(savedLeague);
        world.setCurrentLeagueId(savedLeague.getId());
    }

    // Week Entity Creation steps

    @Given("the league has startingWeek={int} and numberOfWeeks={int}")
    public void theLeagueHasStartingWeekAndNumberOfWeeks(Integer startingWeek, Integer numberOfWeeks) {
        League league = world.getCurrentLeague();
        league.setStartingWeekAndDuration(startingWeek, numberOfWeeks);
        leagueRepository.save(league);
    }

    @Given("the league status is {string}")
    public void theLeagueStatusIs(String status) {
        League league = world.getCurrentLeague();
        league.setStatus(League.LeagueStatus.valueOf(status));
        leagueRepository.save(league);
    }

    @When("the admin activates the league")
    public void theAdminActivatesTheLeague() {
        try {
            League league = world.getCurrentLeague();
            // Create weeks when league is activated
            createdWeeks = weekService.createWeeksForLeague(
                league.getId(),
                league.getStartingWeek(),
                league.getNumberOfWeeks(),
                2025 // Current season
            );
            league.setStatus(League.LeagueStatus.ACTIVE);
            leagueRepository.save(league);
        } catch (Exception e) {
            lastException = e;
        }
    }

    @When("the league is activated")
    public void theLeagueIsActivated() {
        theAdminActivatesTheLeague();
    }

    @Then("{int} week entities should be created")
    public void weekEntitiesShouldBeCreated(Integer expectedCount) {
        assertThat(createdWeeks).hasSize(expectedCount);
    }

    @Then("week entities should have the following mapping:")
    public void weekEntitiesShouldHaveTheFollowingMapping(DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps();

        for (Map<String, String> row : rows) {
            int weekId = Integer.parseInt(row.get("weekId"));
            int gameWeekNumber = Integer.parseInt(row.get("gameWeekNumber"));
            int nflWeekNumber = Integer.parseInt(row.get("nflWeekNumber"));
            String status = row.get("status");

            Week week = createdWeeks.get(weekId - 1);
            assertThat(week.getGameWeekNumber()).isEqualTo(gameWeekNumber);
            assertThat(week.getNflWeekNumber()).isEqualTo(nflWeekNumber);
            assertThat(week.getStatus().name()).isEqualTo(status);
        }
    }

    @Then("the week mapping should be:")
    public void theWeekMappingShouldBe(DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps();

        for (int i = 0; i < rows.size(); i++) {
            Map<String, String> row = rows.get(i);
            int gameWeekNumber = Integer.parseInt(row.get("gameWeekNumber"));
            int nflWeekNumber = Integer.parseInt(row.get("nflWeekNumber"));

            Week week = createdWeeks.get(i);
            assertThat(week.getGameWeekNumber()).isEqualTo(gameWeekNumber);
            assertThat(week.getNflWeekNumber()).isEqualTo(nflWeekNumber);
        }
    }

    @Then("game week {int} maps to NFL week {int}")
    public void gameWeekMapsToNFLWeek(Integer gameWeek, Integer nflWeek) {
        Week week = createdWeeks.stream()
                .filter(w -> w.getGameWeekNumber().equals(gameWeek))
                .findFirst()
                .orElseThrow();
        assertThat(week.getNflWeekNumber()).isEqualTo(nflWeek);
    }

    // Week Status Management steps

    @Given("the league has {int} weeks created")
    public void theLeagueHasWeeksCreated(Integer numberOfWeeks) {
        League league = world.getCurrentLeague();
        createdWeeks = weekService.createWeeksForLeague(
            league.getId(),
            league.getStartingWeek(),
            numberOfWeeks,
            2025
        );
    }

    @Given("all weeks have status {string}")
    public void allWeeksHaveStatus(String status) {
        assertThat(createdWeeks)
                .allMatch(w -> w.getStatus().name().equals(status));
    }

    @Given("the league is activated")
    public void givenTheLeagueIsActivated() {
        League league = world.getCurrentLeague();
        league.setStatus(League.LeagueStatus.ACTIVE);
        leagueRepository.save(league);
    }

    @When("the current date reaches the start of NFL week {int}")
    public void theCurrentDateReachesTheStartOfNFLWeek(Integer nflWeek) {
        // Simulate time passing - activate the week for this NFL week
        Week week = createdWeeks.stream()
                .filter(w -> w.getNflWeekNumber().equals(nflWeek))
                .findFirst()
                .orElseThrow();
        currentWeek = weekService.activateWeek(week.getId());
    }

    @Then("week {int} \\(NFL week {int}) status changes to {string}")
    public void weekNFLWeekStatusChangesTo(Integer gameWeek, Integer nflWeek, String expectedStatus) {
        Week week = weekService.getWeekByGameWeekNumber(world.getCurrentLeagueId(), gameWeek)
                .orElseThrow();
        assertThat(week.getStatus().name()).isEqualTo(expectedStatus);
    }

    @Then("the pick deadline for week {int} is displayed")
    public void thePickDeadlineForWeekIsDisplayed(Integer gameWeek) {
        Week week = weekService.getWeekByGameWeekNumber(world.getCurrentLeagueId(), gameWeek)
                .orElseThrow();
        assertThat(week.getPickDeadline()).isNotNull();
    }

    @Then("players can make selections for week {int}")
    public void playersCanMakeSelectionsForWeek(Integer gameWeek) {
        Week week = weekService.getWeekByGameWeekNumber(world.getCurrentLeagueId(), gameWeek)
                .orElseThrow();
        assertThat(week.canAcceptSelections()).isTrue();
    }

    @Given("week {int} \\(NFL week {int}) has status {string}")
    public void weekNFLWeekHasStatus(Integer gameWeek, Integer nflWeek, String status) {
        Week week = weekService.getWeekByGameWeekNumber(world.getCurrentLeagueId(), gameWeek)
                .orElseThrow();

        // Set status based on the string
        switch (status) {
            case "ACTIVE":
                if (week.isUpcoming()) {
                    week.activate();
                }
                break;
            case "LOCKED":
                if (week.isUpcoming()) {
                    week.activate();
                }
                if (week.isActive()) {
                    week.lock();
                }
                break;
            case "COMPLETED":
                if (week.isUpcoming()) {
                    week.activate();
                }
                if (week.isActive()) {
                    week.lock();
                }
                if (week.isLocked()) {
                    week.complete();
                }
                break;
        }

        weekService.save(week);
        currentWeek = week;
    }

    @Given("the pick deadline is {string}")
    public void thePickDeadlineIs(String deadline) {
        // Parse deadline and set it on current week
        LocalDateTime pickDeadline = LocalDateTime.parse(deadline.replace(" ET", "").replace(" ", "T"));
        currentWeek.setPickDeadline(pickDeadline);
        weekService.save(currentWeek);
    }

    @When("the deadline passes")
    public void theDeadlinePasses() {
        // Simulate deadline passing by locking the week
        currentWeek = weekService.lockWeek(currentWeek.getId());
    }

    @Then("week {int} status changes to {string}")
    public void weekStatusChangesTo(Integer gameWeek, String expectedStatus) {
        Week week = weekService.getWeekByGameWeekNumber(world.getCurrentLeagueId(), gameWeek)
                .orElseThrow();
        assertThat(week.getStatus().name()).isEqualTo(expectedStatus);
    }

    @Then("no further selections can be made for week {int}")
    public void noFurtherSelectionsCanBeMadeForWeek(Integer gameWeek) {
        Week week = weekService.getWeekByGameWeekNumber(world.getCurrentLeagueId(), gameWeek)
                .orElseThrow();
        assertThat(week.canAcceptSelections()).isFalse();
    }

    @Then("NFL games for week {int} are in progress")
    public void nflGamesForWeekAreInProgress(Integer nflWeek) {
        // This would typically check with the NFL data service
        // For now, we'll just verify the week is locked
        Week week = createdWeeks.stream()
                .filter(w -> w.getNflWeekNumber().equals(nflWeek))
                .findFirst()
                .orElseThrow();
        assertThat(week.isLocked()).isTrue();
    }

    @Given("all NFL week {int} games have finished")
    public void allNFLWeekGamesHaveFinished(Integer nflWeek) {
        Week week = createdWeeks.stream()
                .filter(w -> w.getNflWeekNumber().equals(nflWeek))
                .findFirst()
                .orElseThrow();

        // Update game stats to show all games completed
        weekService.updateGameStats(week.getId(), 16, 16, 0);
    }

    @When("the final game completes")
    public void theFinalGameCompletes() {
        // Game completion is already set in previous step
    }

    @When("all scores are calculated")
    public void allScoresAreCalculated() {
        // Scores calculation would be handled by scoring service
    }

    @Then("week {int} scores are finalized")
    public void weekScoresAreFinalized(Integer gameWeek) {
        Week week = weekService.getWeekByGameWeekNumber(world.getCurrentLeagueId(), gameWeek)
                .orElseThrow();
        assertThat(week.isCompleted()).isTrue();
    }

    @Given("a week entity exists")
    public void aWeekEntityExists() {
        if (createdWeeks == null || createdWeeks.isEmpty()) {
            theLeagueHasWeeksCreated(1);
        }
        currentWeek = createdWeeks.get(0);
    }

    @Then("the week progresses through statuses:")
    public void theWeekProgressesThroughStatuses(DataTable dataTable) {
        // Verify the status progression is valid
        Week week = new Week(UUID.randomUUID(), 1, 15);

        assertThat(week.getStatus()).isEqualTo(WeekStatus.UPCOMING);

        week.activate();
        assertThat(week.getStatus()).isEqualTo(WeekStatus.ACTIVE);

        week.lock();
        assertThat(week.getStatus()).isEqualTo(WeekStatus.LOCKED);

        week.complete();
        assertThat(week.getStatus()).isEqualTo(WeekStatus.COMPLETED);
    }

    // Additional helper methods for other scenarios can be added here

    @Given("the league covers NFL weeks {int}-{int}")
    public void theLeagueCoversNFLWeeks(Integer startWeek, Integer endWeek) {
        int numberOfWeeks = endWeek - startWeek + 1;
        League league = world.getCurrentLeague();
        league.setStartingWeekAndDuration(startWeek, numberOfWeeks);
        leagueRepository.save(league);
    }

    @When("week entities are created")
    public void weekEntitiesAreCreated() {
        theAdminActivatesTheLeague();
    }

    @When("the system attempts to create weeks again")
    public void theSystemAttemptsToCreateWeeksAgain() {
        try {
            League league = world.getCurrentLeague();
            weekService.createWeeksForLeague(
                league.getId(),
                league.getStartingWeek(),
                league.getNumberOfWeeks(),
                2025
            );
        } catch (Exception e) {
            lastException = e;
        }
    }

    @Then("the operation is rejected with error {string}")
    public void theOperationIsRejectedWithError(String expectedError) {
        assertThat(lastException).isNotNull();
        assertThat(lastException.getMessage()).contains(expectedError);
    }

    @When("I request week by gameWeekNumber={int}")
    public void iRequestWeekByGameWeekNumber(Integer gameWeekNumber) {
        currentWeek = weekService.getWeekByGameWeekNumber(world.getCurrentLeagueId(), gameWeekNumber)
                .orElse(null);
    }

    @Then("I should receive the week entity")
    public void iShouldReceiveTheWeekEntity() {
        assertThat(currentWeek).isNotNull();
    }

    @Then("the week should have nflWeekNumber={int}")
    public void theWeekShouldHaveNflWeekNumber(Integer expectedNflWeek) {
        assertThat(currentWeek.getNflWeekNumber()).isEqualTo(expectedNflWeek);
    }

    @When("I request week by nflWeekNumber={int}")
    public void iRequestWeekByNflWeekNumber(Integer nflWeekNumber) {
        currentWeek = weekService.getWeekByNflWeekNumber(world.getCurrentLeagueId(), nflWeekNumber)
                .orElse(null);
    }

    @Then("I should receive the week entity for game week {int}")
    public void iShouldReceiveTheWeekEntityForGameWeek(Integer expectedGameWeek) {
        assertThat(currentWeek).isNotNull();
        assertThat(currentWeek.getGameWeekNumber()).isEqualTo(expectedGameWeek);
    }

    @Then("the gameWeekNumber should be {int}")
    public void theGameWeekNumberShouldBe(Integer expectedGameWeek) {
        assertThat(currentWeek.getGameWeekNumber()).isEqualTo(expectedGameWeek);
    }
}
