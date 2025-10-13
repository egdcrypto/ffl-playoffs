package com.ffl.playoffs.bdd.steps;

import com.ffl.playoffs.application.usecase.CreateLeagueUseCase;
import com.ffl.playoffs.bdd.World;
import com.ffl.playoffs.domain.model.League;
import com.ffl.playoffs.domain.model.RosterConfiguration;
import com.ffl.playoffs.domain.model.ScoringRules;
import com.ffl.playoffs.domain.port.LeagueRepository;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;

import static org.assertj.core.api.Assertions.*;

/**
 * Step definitions for League Management features
 * Implements Gherkin steps from league-creation.feature
 */
public class LeagueManagementSteps {

    @Autowired
    private World world;

    @Autowired
    private LeagueRepository leagueRepository;

    private CreateLeagueUseCase createLeagueUseCase;

    @Autowired
    public void initialize() {
        createLeagueUseCase = new CreateLeagueUseCase(leagueRepository);
    }

    // Given steps

    @Given("an admin user wants to create a new league")
    public void anAdminUserWantsToCreateANewLeague() {
        // Admin user should already be set in world from UserManagementSteps
        assertThat(world.getCurrentUser()).isNotNull();
        assertThat(world.getCurrentUser().isAdmin() || world.getCurrentUser().isSuperAdmin()).isTrue();
    }

    @Given("the admin provides league details:")
    public void theAdminProvidesLeagueDetails(io.cucumber.datatable.DataTable dataTable) {
        // Parse data table and store in world
        var data = dataTable.asMaps();
        if (!data.isEmpty()) {
            world.setLastResponse(data.get(0));
        }
    }

    @Given("the league uses default roster configuration")
    public void theLeagueUsesDefaultRosterConfiguration() {
        // Default configuration will be used in creation
    }

    @Given("the league uses custom roster configuration with:")
    public void theLeagueUsesCustomRosterConfigurationWith(io.cucumber.datatable.DataTable dataTable) {
        var data = dataTable.asMaps().get(0);
        RosterConfiguration config = new RosterConfiguration();

        data.forEach((position, count) -> {
            if (!position.equalsIgnoreCase("position")) {
                // Parse position and count
                // This would need Position enum mapping
            }
        });

        world.setLastResponse(config);
    }

    @Given("the league code {string} already exists")
    public void theLeagueCodeAlreadyExists(String code) {
        // Create a league with this code
        var command = new CreateLeagueUseCase.CreateLeagueCommand(
                "Existing League",
                code,
                world.getCurrentUserId(),
                1,
                17
        );
        League existingLeague = createLeagueUseCase.execute(command);
        world.storeLeague("existing", existingLeague);
    }

    // When steps

    @When("the admin creates the league")
    public void theAdminCreatesTheLeague() {
        try {
            // Get league details from world (set by previous step)
            @SuppressWarnings("unchecked")
            var details = (java.util.Map<String, String>) world.getLastResponse();

            var command = new CreateLeagueUseCase.CreateLeagueCommand(
                    details.getOrDefault("name", "Test League"),
                    details.getOrDefault("code", "TEST2025"),
                    world.getCurrentUserId(),
                    Integer.parseInt(details.getOrDefault("starting_week", "1")),
                    Integer.parseInt(details.getOrDefault("number_of_weeks", "17"))
            );

            if (details.containsKey("description")) {
                command.setDescription(details.get("description"));
            }

            League league = createLeagueUseCase.execute(command);
            world.setCurrentLeague(league);
            world.setLastResponse(league);
            world.setLastException(null);
        } catch (Exception e) {
            world.setLastException(e);
        }
    }

    @When("the admin tries to create a league with code {string}")
    public void theAdminTriesToCreateALeagueWithCode(String code) {
        try {
            var command = new CreateLeagueUseCase.CreateLeagueCommand(
                    "Duplicate League",
                    code,
                    world.getCurrentUserId(),
                    1,
                    17
            );

            League league = createLeagueUseCase.execute(command);
            world.setCurrentLeague(league);
            world.setLastException(null);
        } catch (Exception e) {
            world.setLastException(e);
        }
    }

    @When("the admin creates a league with starting week {int} and {int} weeks duration")
    public void theAdminCreatesALeagueWithStartingWeekAndWeeksDuration(int startingWeek, int numberOfWeeks) {
        try {
            var command = new CreateLeagueUseCase.CreateLeagueCommand(
                    "Week Test League",
                    "WEEK" + startingWeek,
                    world.getCurrentUserId(),
                    startingWeek,
                    numberOfWeeks
            );

            League league = createLeagueUseCase.execute(command);
            world.setCurrentLeague(league);
            world.setLastException(null);
        } catch (Exception e) {
            world.setLastException(e);
        }
    }

    // Then steps

    @Then("the league is created successfully")
    public void theLeagueIsCreatedSuccessfully() {
        assertThat(world.getCurrentLeague()).isNotNull();
        assertThat(world.getCurrentLeague().getId()).isNotNull();
        assertThat(world.getLastException()).isNull();
    }

    @Then("the league has status {string}")
    public void theLeagueHasStatus(String status) {
        assertThat(world.getCurrentLeague()).isNotNull();
        assertThat(world.getCurrentLeague().getStatus().name()).isEqualTo(status);
    }

    @Then("the league owner is the creating admin")
    public void theLeagueOwnerIsTheCreatingAdmin() {
        assertThat(world.getCurrentLeague()).isNotNull();
        assertThat(world.getCurrentLeague().getOwnerId()).isEqualTo(world.getCurrentUserId());
    }

    @Then("the league is persisted to the database")
    public void theLeagueIsPersistedToTheDatabase() {
        League league = leagueRepository.findById(world.getCurrentLeagueId()).orElse(null);
        assertThat(league).isNotNull();
        assertThat(league.getId()).isEqualTo(world.getCurrentLeagueId());
    }

    @Then("the league has a unique code {string}")
    public void theLeagueHasAUniqueCode(String code) {
        assertThat(world.getCurrentLeague()).isNotNull();
        assertThat(world.getCurrentLeague().getCode()).isEqualTo(code);
    }

    @Then("the league creation fails")
    public void theLeagueCreationFails() {
        assertThat(world.getLastException()).isNotNull();
    }

    @Then("an error message {string} is returned")
    public void anErrorMessageIsReturned(String expectedMessage) {
        assertThat(world.getLastException()).isNotNull();
        assertThat(world.getLastException().getMessage()).contains(expectedMessage);
    }

    @Then("the league has standard roster configuration")
    public void theLeagueHasStandardRosterConfiguration() {
        assertThat(world.getCurrentLeague()).isNotNull();
        assertThat(world.getCurrentLeague().getRosterConfiguration()).isNotNull();
        assertThat(world.getCurrentLeague().getRosterConfiguration().getTotalSlots()).isGreaterThan(0);
    }

    @Then("the league has default PPR scoring rules")
    public void theLeagueHasDefaultPPRScoringRules() {
        assertThat(world.getCurrentLeague()).isNotNull();
        assertThat(world.getCurrentLeague().getScoringRules()).isNotNull();
        assertThat(world.getCurrentLeague().getScoringRules().getReceptionPoints()).isEqualTo(1.0);
    }

    @Then("the league starting week is {int}")
    public void theLeagueStartingWeekIs(int week) {
        assertThat(world.getCurrentLeague()).isNotNull();
        assertThat(world.getCurrentLeague().getStartingWeek()).isEqualTo(week);
    }

    @Then("the league duration is {int} weeks")
    public void theLeagueDurationIsWeeks(int weeks) {
        assertThat(world.getCurrentLeague()).isNotNull();
        assertThat(world.getCurrentLeague().getNumberOfWeeks()).isEqualTo(weeks);
    }

    @Then("the league ends at week {int}")
    public void theLeagueEndsAtWeek(int endWeek) {
        assertThat(world.getCurrentLeague()).isNotNull();
        assertThat(world.getCurrentLeague().getEndingWeek()).isEqualTo(endWeek);
    }

    @Then("the league configuration is not locked")
    public void theLeagueConfigurationIsNotLocked() {
        assertThat(world.getCurrentLeague()).isNotNull();
        assertThat(world.getCurrentLeague().getConfigurationLocked()).isFalse();
    }

    @Then("the league can be configured by the admin")
    public void theLeagueCanBeConfiguredByTheAdmin() {
        assertThat(world.getCurrentLeague()).isNotNull();
        assertThat(world.getCurrentLeague().isConfigurationLocked(LocalDateTime.now())).isFalse();
    }
}
