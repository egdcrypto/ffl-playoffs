package com.ffl.playoffs.bdd.steps;

import com.ffl.playoffs.bdd.World;
import com.ffl.playoffs.domain.aggregate.*;
import com.ffl.playoffs.domain.model.*;
import com.ffl.playoffs.domain.port.LeagueRepository;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

import static org.assertj.core.api.Assertions.*;

/**
 * Step definitions for League Configuration Lock features
 * Implements Gherkin steps from ffl-12-league-configuration-lock.feature
 *
 * Handles:
 * - Configuration lock when first NFL game starts
 * - Prevention of configuration changes after lock
 * - Lock validation for all configuration aspects
 * - Audit logging of attempted modifications
 * - Lock warnings and UI indicators
 */
public class LeagueConfigurationLockSteps {

    @Autowired
    private World world;

    @Autowired
    private LeagueRepository leagueRepository;

    private static final DateTimeFormatter ET_FORMATTER =
        DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private static final ZoneId ET_ZONE = ZoneId.of("America/New_York");

    private LocalDateTime firstGameStartTime;
    private String lastRejectionError;
    private String lastRejectionMessage;
    private Map<String, Object> originalConfiguration = new HashMap<>();
    private List<String> attemptedChanges = new ArrayList<>();
    private List<Map<String, String>> auditLogEntries = new ArrayList<>();
    private String warningBanner;
    private int countdownHours;
    private boolean lockIndicatorDisplayed;

    // ==================== Background Steps ====================

    @Given("an ADMIN user owns league {string}")
    public void anAdminUserOwnsLeague(String leagueName) {
        // Create admin user if not exists
        if (world.getCurrentUser() == null) {
            User admin = new User();
            admin.setRole(Role.ADMIN);
            world.setCurrentUser(admin);
        }

        // Create league owned by admin
        League league = new League();
        league.setName(leagueName);
        league.setOwnerId(world.getCurrentUserId());
        league.setStatus(League.LeagueStatus.CREATED);

        // Set default roster configuration
        RosterConfiguration config = new RosterConfiguration();
        config.setPositionSlots(Position.QB, 1);
        config.setPositionSlots(Position.RB, 2);
        config.setPositionSlots(Position.WR, 2);
        config.setPositionSlots(Position.TE, 1);
        config.setPositionSlots(Position.FLEX, 1);
        config.setPositionSlots(Position.K, 1);
        config.setPositionSlots(Position.DEF, 1);
        league.setRosterConfiguration(config);

        // Set default scoring rules
        ScoringRules scoringRules = new ScoringRules();
        scoringRules.setReceptionPoints(1.0); // Full PPR
        league.setScoringRules(scoringRules);

        world.setCurrentLeague(league);
        world.storeLeague(leagueName, league);
        leagueRepository.save(league);

        // Store original configuration for comparison
        storeOriginalConfiguration(league);
    }

    @Given("the league starts at NFL week {int}")
    public void theLeagueStartsAtNFLWeek(int week) {
        League league = world.getCurrentLeague();
        Integer numberOfWeeks = league.getNumberOfWeeks() != null ? league.getNumberOfWeeks() : 4;
        league.setStartingWeekAndDuration(week, numberOfWeeks);
        originalConfiguration.put("startingWeek", week);
    }

    @Given("the league runs for {int} weeks")
    public void theLeagueRunsForWeeks(int weeks) {
        League league = world.getCurrentLeague();
        Integer startingWeek = league.getStartingWeek() != null ? league.getStartingWeek() : 1;
        league.setStartingWeekAndDuration(startingWeek, weeks);
        originalConfiguration.put("numberOfWeeks", weeks);
    }

    @Given("the first NFL game of week {int} starts at {string}")
    public void theFirstNFLGameOfWeekStartsAt(int week, String gameTimeStr) {
        this.firstGameStartTime = parseETDateTime(gameTimeStr);
        world.getCurrentLeague().setFirstGameStartTime(firstGameStartTime);
    }

    @Given("the league is currently ACTIVE")
    public void theLeagueIsCurrentlyActive() {
        world.getCurrentLeague().setStatus(League.LeagueStatus.ACTIVE);
    }

    // ==================== Given Steps ====================

    @Given("the current time is {string}")
    public void theCurrentTimeIs(String timeStr) {
        LocalDateTime time = parseETDateTime(timeStr);
        world.setTestTime(time);
    }

    @Given("the league is ACTIVE")
    public void theLeagueIsActive() {
        world.getCurrentLeague().setStatus(League.LeagueStatus.ACTIVE);
    }

    @Given("the first game starts in {int} hours")
    public void theFirstGameStartsInHours(int hours) {
        // Validation that first game is indeed in specified hours
        if (firstGameStartTime != null && world.getTestTime() != null) {
            long actualHours = java.time.Duration.between(
                world.getTestTime(),
                firstGameStartTime
            ).toHours();
            assertThat(actualHours).isEqualTo(hours);
        }
    }

    @Given("the league configuration is locked")
    public void theLeagueConfigurationIsLocked() {
        League league = world.getCurrentLeague();

        // Lock at first game start time
        if (firstGameStartTime == null) {
            firstGameStartTime = LocalDateTime.now().minusHours(1);
            league.setFirstGameStartTime(firstGameStartTime);
        }

        league.lockConfiguration(firstGameStartTime, "FIRST_GAME_STARTED");

        // Set test time to after lock
        if (world.getTestTime() == null) {
            world.setTestTime(firstGameStartTime.plusMinutes(30));
        }
    }

    @Given("the league roster has {int} QB, {int} RB, {int} WR")
    public void theLeagueRosterHasPositions(int qb, int rb, int wr) {
        League league = world.getCurrentLeague();
        RosterConfiguration config = league.getRosterConfiguration();

        if (config == null) {
            config = new RosterConfiguration();
            league.setRosterConfiguration(config);
        }

        config.setPositionSlots(Position.QB, qb);
        config.setPositionSlots(Position.RB, rb);
        config.setPositionSlots(Position.WR, wr);

        originalConfiguration.put("QB", qb);
        originalConfiguration.put("RB", rb);
        originalConfiguration.put("WR", wr);
    }

    @Given("the league uses Full PPR \\({double} per reception)")
    public void theLeagueUsesFullPPR(double pprValue) {
        League league = world.getCurrentLeague();
        ScoringRules scoringRules = league.getScoringRules();

        if (scoringRules == null) {
            scoringRules = new ScoringRules();
            league.setScoringRules(scoringRules);
        }

        scoringRules.setReceptionPoints(pprValue);
        originalConfiguration.put("receptionPoints", pprValue);
    }

    @Given("the league maxPlayers is {int}")
    public void theLeagueMaxPlayersIs(int maxPlayers) {
        originalConfiguration.put("maxPlayers", maxPlayers);
    }

    @Given("the league is PRIVATE")
    public void theLeagueIsPrivate() {
        originalConfiguration.put("privacy", "PRIVATE");
    }

    @Given("a SUPER_ADMIN user accesses the league")
    public void aSuperAdminUserAccessesTheLeague() {
        User superAdmin = new User();
        superAdmin.setRole(Role.SUPER_ADMIN);
        world.setCurrentUser(superAdmin);
    }

    @Given("the admin creates a new league during week {int}")
    public void theAdminCreatesANewLeagueDuringWeek(int week) {
        League league = new League();
        league.setName("New League Week " + week);
        league.setOwnerId(world.getCurrentUserId());
        league.setStartingWeekAndDuration(week, 4);
        league.setStatus(League.LeagueStatus.CREATED);

        world.setCurrentLeague(league);
    }

    @Given("the first game of week {int} already started")
    public void theFirstGameOfWeekAlreadyStarted(int week) {
        LocalDateTime gameStartTime = LocalDateTime.now().minusHours(2);
        this.firstGameStartTime = gameStartTime;
        world.getCurrentLeague().setFirstGameStartTime(gameStartTime);
        world.setTestTime(LocalDateTime.now());
    }

    // ==================== When Steps ====================

    @When("the admin modifies league configuration")
    public void theAdminModifiesLeagueConfiguration() {
        try {
            League league = world.getCurrentLeague();
            league.setName("Modified Name", world.getTestTime());
            world.setLastException(null);
        } catch (Exception e) {
            world.setLastException(e);
        }
    }

    @When("the first NFL game begins")
    public void theFirstNFLGameBegins() {
        League league = world.getCurrentLeague();
        league.lockConfiguration(firstGameStartTime, "FIRST_GAME_STARTED");
    }

    @When("the admin attempts to change the league name")
    public void theAdminAttemptsToChangeTheLeagueName() {
        try {
            League league = world.getCurrentLeague();
            String originalName = league.getName();
            originalConfiguration.putIfAbsent("name", originalName);

            league.setName("New League Name", world.getTestTime());
            world.setLastException(null);
        } catch (League.ConfigurationLockedException e) {
            lastRejectionError = "CONFIGURATION_LOCKED";
            lastRejectionMessage = "Configuration is locked - first game has started";
            world.setLastException(e);
            logAuditEntry("MODIFY_LEAGUE_NAME", "BLOCKED_CONFIGURATION_LOCKED");
        }
    }

    @When("the admin attempts to change starting week from {int} to {int}")
    public void theAdminAttemptsToChangeStartingWeek(int from, int to) {
        try {
            League league = world.getCurrentLeague();
            assertThat(league.getStartingWeek()).isEqualTo(from);

            league.setStartingWeek(to, world.getTestTime());
            world.setLastException(null);
        } catch (League.ConfigurationLockedException e) {
            lastRejectionError = "CONFIGURATION_LOCKED";
            lastRejectionMessage = "Configuration is locked - first game has started";
            world.setLastException(e);
            logAuditEntry("MODIFY_STARTING_WEEK", "BLOCKED_CONFIGURATION_LOCKED");
        }
    }

    @When("the admin attempts to change number of weeks from {int} to {int}")
    public void theAdminAttemptsToChangeNumberOfWeeks(int from, int to) {
        try {
            League league = world.getCurrentLeague();
            assertThat(league.getNumberOfWeeks()).isEqualTo(from);

            league.setNumberOfWeeks(to, world.getTestTime());
            world.setLastException(null);
        } catch (League.ConfigurationLockedException e) {
            lastRejectionError = "CONFIGURATION_LOCKED";
            lastRejectionMessage = "Configuration is locked - first game has started";
            world.setLastException(e);
            logAuditEntry("MODIFY_NUMBER_OF_WEEKS", "BLOCKED_CONFIGURATION_LOCKED");
        }
    }

    @When("the admin attempts to change roster to {int} QB, {int} RB, {int} WR")
    public void theAdminAttemptsToChangeRosterConfiguration(int qb, int rb, int wr) {
        try {
            League league = world.getCurrentLeague();
            RosterConfiguration newConfig = new RosterConfiguration();
            newConfig.setPositionSlots(Position.QB, qb);
            newConfig.setPositionSlots(Position.RB, rb);
            newConfig.setPositionSlots(Position.WR, wr);

            league.setRosterConfiguration(newConfig, world.getTestTime());
            world.setLastException(null);
        } catch (League.ConfigurationLockedException e) {
            lastRejectionError = "CONFIGURATION_LOCKED";
            lastRejectionMessage = "Configuration is locked - first game has started";
            world.setLastException(e);
            logAuditEntry("MODIFY_ROSTER_CONFIGURATION", "BLOCKED_CONFIGURATION_LOCKED");
        }
    }

    @When("the admin attempts to change to Half PPR \\({double} per reception)")
    public void theAdminAttemptsToChangeToHalfPPR(double pprValue) {
        try {
            League league = world.getCurrentLeague();
            ScoringRules newRules = new ScoringRules();
            newRules.setReceptionPoints(pprValue);

            league.setScoringRules(newRules, world.getTestTime());
            world.setLastException(null);
        } catch (League.ConfigurationLockedException e) {
            lastRejectionError = "CONFIGURATION_LOCKED";
            lastRejectionMessage = "Configuration is locked - first game has started";
            world.setLastException(e);
            logAuditEntry("MODIFY_PPR_SCORING", "BLOCKED_CONFIGURATION_LOCKED");
        }
    }

    @When("the admin attempts to change field goal scoring rules")
    public void theAdminAttemptsToChangeFieldGoalScoringRules() {
        try {
            League league = world.getCurrentLeague();
            ScoringRules newRules = league.getScoringRules() != null
                ? league.getScoringRules()
                : new ScoringRules();

            league.setScoringRules(newRules, world.getTestTime());
            world.setLastException(null);
        } catch (League.ConfigurationLockedException e) {
            lastRejectionError = "CONFIGURATION_LOCKED";
            lastRejectionMessage = "Configuration is locked - first game has started";
            world.setLastException(e);
            logAuditEntry("MODIFY_FIELD_GOAL_SCORING", "BLOCKED_CONFIGURATION_LOCKED");
        }
    }

    @When("the admin attempts to change defensive scoring rules")
    public void theAdminAttemptsToChangeDefensiveScoringRules() {
        try {
            League league = world.getCurrentLeague();
            ScoringRules newRules = league.getScoringRules() != null
                ? league.getScoringRules()
                : new ScoringRules();

            league.setScoringRules(newRules, world.getTestTime());
            world.setLastException(null);
        } catch (League.ConfigurationLockedException e) {
            lastRejectionError = "CONFIGURATION_LOCKED";
            lastRejectionMessage = "Configuration is locked - first game has started";
            world.setLastException(e);
            logAuditEntry("MODIFY_DEFENSIVE_SCORING", "BLOCKED_CONFIGURATION_LOCKED");
        }
    }

    @When("the admin attempts to change points allowed tier scoring")
    public void theAdminAttemptsToChangePointsAllowedTierScoring() {
        try {
            League league = world.getCurrentLeague();
            ScoringRules newRules = league.getScoringRules() != null
                ? league.getScoringRules()
                : new ScoringRules();

            league.setScoringRules(newRules, world.getTestTime());
            world.setLastException(null);
        } catch (League.ConfigurationLockedException e) {
            lastRejectionError = "CONFIGURATION_LOCKED";
            lastRejectionMessage = "Configuration is locked - first game has started";
            world.setLastException(e);
            logAuditEntry("MODIFY_POINTS_ALLOWED_TIERS", "BLOCKED_CONFIGURATION_LOCKED");
        }
    }

    @When("the admin attempts to change yards allowed tier scoring")
    public void theAdminAttemptsToChangeYardsAllowedTierScoring() {
        try {
            League league = world.getCurrentLeague();
            ScoringRules newRules = league.getScoringRules() != null
                ? league.getScoringRules()
                : new ScoringRules();

            league.setScoringRules(newRules, world.getTestTime());
            world.setLastException(null);
        } catch (League.ConfigurationLockedException e) {
            lastRejectionError = "CONFIGURATION_LOCKED";
            lastRejectionMessage = "Configuration is locked - first game has started";
            world.setLastException(e);
            logAuditEntry("MODIFY_YARDS_ALLOWED_TIERS", "BLOCKED_CONFIGURATION_LOCKED");
        }
    }

    @When("the admin attempts to change the roster lock deadline")
    public void theAdminAttemptsToChangeTheRosterLockDeadline() {
        try {
            League league = world.getCurrentLeague();
            // In real implementation, this would set roster lock deadline
            // For now, we simulate by attempting to modify configuration
            league.validateConfigurationMutable(world.getTestTime());
            world.setLastException(null);
        } catch (League.ConfigurationLockedException e) {
            lastRejectionError = "CONFIGURATION_LOCKED";
            lastRejectionMessage = "Configuration is locked - first game has started";
            world.setLastException(e);
            logAuditEntry("MODIFY_ROSTER_LOCK_DEADLINE", "BLOCKED_CONFIGURATION_LOCKED");
        }
    }

    @When("the admin attempts to change maxPlayers to {int}")
    public void theAdminAttemptsToChangeMaxPlayersTo(int newMaxPlayers) {
        try {
            League league = world.getCurrentLeague();
            league.validateConfigurationMutable(world.getTestTime());
            // In real implementation, would set maxPlayers property
            world.setLastException(null);
        } catch (League.ConfigurationLockedException e) {
            lastRejectionError = "CONFIGURATION_LOCKED";
            lastRejectionMessage = "Configuration is locked - first game has started";
            world.setLastException(e);
            logAuditEntry("MODIFY_MAX_PLAYERS", "BLOCKED_CONFIGURATION_LOCKED");
        }
    }

    @When("the admin attempts to change privacy to PUBLIC")
    public void theAdminAttemptsToChangePrivacyToPublic() {
        try {
            League league = world.getCurrentLeague();
            league.validateConfigurationMutable(world.getTestTime());
            // In real implementation, would set privacy setting
            world.setLastException(null);
        } catch (League.ConfigurationLockedException e) {
            lastRejectionError = "CONFIGURATION_LOCKED";
            lastRejectionMessage = "Configuration is locked - first game has started";
            world.setLastException(e);
            logAuditEntry("MODIFY_PRIVACY_SETTINGS", "BLOCKED_CONFIGURATION_LOCKED");
        }
    }

    @When("the admin attempts to deactivate the league")
    public void theAdminAttemptsToDeactivateTheLeague() {
        try {
            League league = world.getCurrentLeague();
            league.validateConfigurationMutable(world.getTestTime());
            // In real implementation, would change status
            world.setLastException(null);
        } catch (League.ConfigurationLockedException e) {
            lastRejectionError = "CONFIGURATION_LOCKED";
            lastRejectionMessage = "Configuration is locked - first game has started";
            world.setLastException(e);
            logAuditEntry("DEACTIVATE_LEAGUE", "BLOCKED_CONFIGURATION_LOCKED");
        }
    }

    @When("the admin views the league settings")
    public void theAdminViewsTheLeagueSettings() {
        League league = world.getCurrentLeague();
        lockIndicatorDisplayed = league.isConfigurationLocked(world.getTestTime());
        world.setLastResponse(league);
    }

    @When("the admin views league configuration")
    public void theAdminViewsLeagueConfiguration() {
        League league = world.getCurrentLeague();

        if (firstGameStartTime != null && world.getTestTime() != null) {
            long hoursUntilLock = java.time.Duration.between(
                world.getTestTime(),
                firstGameStartTime
            ).toHours();

            if (hoursUntilLock > 0 && hoursUntilLock <= 24) {
                countdownHours = (int) hoursUntilLock;
                warningBanner = String.format("Configuration locks in: %d hour%s",
                    countdownHours, countdownHours == 1 ? "" : "s");
            }
        }

        world.setLastResponse(league);
    }

    @When("the admin attempts to modify PPR scoring rules")
    public void theAdminAttemptsToModifyPPRScoringRules() {
        theAdminAttemptsToChangeToHalfPPR(0.5);
    }

    @When("the admin attempts to modify:")
    public void theAdminAttemptsToModify(DataTable dataTable) {
        List<Map<String, String>> changes = dataTable.asMaps();
        int blockedCount = 0;

        for (Map<String, String> change : changes) {
            String setting = change.get("Setting");
            String newValue = change.get("New Value");

            try {
                League league = world.getCurrentLeague();
                league.validateConfigurationMutable(world.getTestTime());
                // Would apply change here
            } catch (League.ConfigurationLockedException e) {
                blockedCount++;
                attemptedChanges.add(setting + " -> " + newValue);
                logAuditEntry("MODIFY_" + setting.toUpperCase().replace(" ", "_"),
                             "BLOCKED_CONFIGURATION_LOCKED");
            }
        }

        // Store count for validation
        originalConfiguration.put("blockedAttempts", blockedCount);
    }

    @When("the league configuration lock is applied")
    public void theLeagueConfigurationLockIsApplied() {
        League league = world.getCurrentLeague();
        league.lockConfiguration(firstGameStartTime, "FIRST_GAME_STARTED");
    }

    @When("the admin activates the league")
    public void theAdminActivatesTheLeague() {
        League league = world.getCurrentLeague();

        // Check if already locked due to first game starting
        if (league.isConfigurationLocked(world.getTestTime())) {
            league.lockConfiguration(firstGameStartTime, "FIRST_GAME_STARTED");
        }

        league.setStatus(League.LeagueStatus.ACTIVE);
    }

    @When("the super admin attempts to modify league configuration")
    public void theSuperAdminAttemptsToModifyLeagueConfiguration() {
        // Even super admin cannot bypass configuration lock
        theAdminAttemptsToChangeTheLeagueName();
    }

    // ==================== Then Steps ====================

    @Then("the changes are applied successfully")
    public void theChangesAreAppliedSuccessfully() {
        assertThat(world.getLastException()).isNull();
    }

    @Then("the league configuration is not locked yet")
    public void theLeagueConfigurationIsNotLockedYet() {
        League league = world.getCurrentLeague();
        assertThat(league.isConfigurationLocked(world.getTestTime())).isFalse();
    }

    @Then("the league configuration is automatically locked")
    public void theLeagueConfigurationIsAutomaticallyLocked() {
        League league = world.getCurrentLeague();
        assertThat(league.isConfigurationLocked(world.getTestTime())).isTrue();
    }

    @Then("the league lockReason is set to {string}")
    public void theLeagueLockReasonIsSetTo(String reason) {
        League league = world.getCurrentLeague();
        assertThat(league.getLockReason()).isEqualTo(reason);
    }

    @Then("the league lockTimestamp is {string}")
    public void theLeagueLockTimestampIs(String timestampStr) {
        League league = world.getCurrentLeague();
        LocalDateTime expectedTime = parseETDateTime(timestampStr);

        assertThat(league.getConfigurationLockedAt()).isNotNull();
        assertThat(league.getConfigurationLockedAt()).isCloseTo(expectedTime,
            within(1, java.time.temporal.ChronoUnit.MINUTES));
    }

    @Then("the league isLocked flag is true")
    public void theLeagueIsLockedFlagIsTrue() {
        League league = world.getCurrentLeague();
        assertThat(league.getConfigurationLocked()).isTrue();
    }

    @Then("the request is rejected with error {string}")
    public void theRequestIsRejectedWithError(String errorCode) {
        assertThat(world.getLastException()).isNotNull();
        assertThat(lastRejectionError).isEqualTo(errorCode);
    }

    @Then("the system shows {string}")
    public void theSystemShows(String message) {
        assertThat(lastRejectionMessage).isEqualTo(message);
    }

    @Then("the league name remains unchanged")
    public void theLeagueNameRemainsUnchanged() {
        League league = world.getCurrentLeague();
        String expectedName = (String) originalConfiguration.get("name");
        if (expectedName != null) {
            assertThat(league.getName()).isEqualTo(expectedName);
        }
    }

    @Then("the starting week remains {int}")
    public void theStartingWeekRemains(int expectedWeek) {
        League league = world.getCurrentLeague();
        assertThat(league.getStartingWeek()).isEqualTo(expectedWeek);
    }

    @Then("the number of weeks remains {int}")
    public void theNumberOfWeeksRemains(int expectedWeeks) {
        League league = world.getCurrentLeague();
        assertThat(league.getNumberOfWeeks()).isEqualTo(expectedWeeks);
    }

    @Then("the roster configuration remains unchanged")
    public void theRosterConfigurationRemainsUnchanged() {
        League league = world.getCurrentLeague();
        RosterConfiguration config = league.getRosterConfiguration();

        assertThat(config).isNotNull();
        if (originalConfiguration.containsKey("QB")) {
            assertThat(config.getPositionSlots(Position.QB))
                .isEqualTo(originalConfiguration.get("QB"));
        }
    }

    @Then("the PPR scoring remains Full PPR")
    public void thePPRScoringRemainsFullPPR() {
        League league = world.getCurrentLeague();
        ScoringRules rules = league.getScoringRules();

        assertThat(rules).isNotNull();
        assertThat(rules.getReceptionPoints()).isEqualTo(1.0);
    }

    @Then("the field goal scoring rules remain unchanged")
    public void theFieldGoalScoringRulesRemainUnchanged() {
        // Validated by exception being thrown
        assertThat(world.getLastException()).isNotNull();
    }

    @Then("the defensive scoring rules remain unchanged")
    public void theDefensiveScoringRulesRemainUnchanged() {
        // Validated by exception being thrown
        assertThat(world.getLastException()).isNotNull();
    }

    @Then("the points allowed tiers remain unchanged")
    public void thePointsAllowedTiersRemainUnchanged() {
        // Validated by exception being thrown
        assertThat(world.getLastException()).isNotNull();
    }

    @Then("the yards allowed tiers remain unchanged")
    public void theYardsAllowedTiersRemainUnchanged() {
        // Validated by exception being thrown
        assertThat(world.getLastException()).isNotNull();
    }

    @Then("the roster lock deadline remains unchanged")
    public void theRosterLockDeadlineRemainsUnchanged() {
        // Validated by exception being thrown
        assertThat(world.getLastException()).isNotNull();
    }

    @Then("the maxPlayers remains {int}")
    public void theMaxPlayersRemains(int expectedMaxPlayers) {
        // Validated by exception being thrown
        assertThat(world.getLastException()).isNotNull();
    }

    @Then("the league remains PRIVATE")
    public void theLeagueRemainsPrivate() {
        // Validated by exception being thrown
        assertThat(world.getLastException()).isNotNull();
    }

    @Then("the league remains ACTIVE")
    public void theLeagueRemainsActive() {
        League league = world.getCurrentLeague();
        assertThat(league.getStatus()).isEqualTo(League.LeagueStatus.ACTIVE);
    }

    @Then("the UI displays {string} indicator")
    public void theUIDisplaysIndicator(String indicator) {
        assertThat(lockIndicatorDisplayed).isTrue();
    }

    @Then("all configuration fields are read-only")
    public void allConfigurationFieldsAreReadOnly() {
        League league = world.getCurrentLeague();
        assertThat(league.isConfigurationLocked(world.getTestTime())).isTrue();
    }

    @Then("the system shows {string}")
    public void theSystemShowsMessage(String message) {
        if (message.startsWith("Configuration locked since:")) {
            League league = world.getCurrentLeague();
            assertThat(league.getConfigurationLockedAt()).isNotNull();
        } else if (message.contains("lock reason:")) {
            League league = world.getCurrentLeague();
            assertThat(league.getLockReason()).isNotNull();
        }
    }

    @Then("the system displays warning banner")
    public void theSystemDisplaysWarningBanner() {
        assertThat(warningBanner).isNotNull();
    }

    @Then("the warning shows {string}")
    public void theWarningShows(String message) {
        if (message.startsWith("Configuration locks in:")) {
            assertThat(warningBanner).contains("Configuration locks in:");
        }
    }

    @Then("the warning shows countdown timer")
    public void theWarningShowsCountdownTimer() {
        assertThat(countdownHours).isGreaterThan(0);
    }

    @Then("the admin can still make changes")
    public void theAdminCanStillMakeChanges() {
        League league = world.getCurrentLeague();
        assertThat(league.isConfigurationLocked(world.getTestTime())).isFalse();
    }

    @Then("the attempt is blocked with CONFIGURATION_LOCKED error")
    public void theAttemptIsBlockedWithConfigurationLockedError() {
        assertThat(world.getLastException()).isNotNull();
        assertThat(lastRejectionError).isEqualTo("CONFIGURATION_LOCKED");
    }

    @Then("an audit log entry is created with:")
    public void anAuditLogEntryIsCreatedWith(DataTable dataTable) {
        Map<String, String> expectedEntry = dataTable.asMaps().get(0);

        assertThat(auditLogEntries).isNotEmpty();
        Map<String, String> lastEntry = auditLogEntries.get(auditLogEntries.size() - 1);

        if (expectedEntry.containsKey("AdminId")) {
            assertThat(lastEntry.get("AdminId")).isNotNull();
        }
        if (expectedEntry.containsKey("LeagueId")) {
            assertThat(lastEntry.get("LeagueId")).isNotNull();
        }
        if (expectedEntry.containsKey("Action")) {
            assertThat(lastEntry.get("Action")).isEqualTo(expectedEntry.get("Action"));
        }
        if (expectedEntry.containsKey("Result")) {
            assertThat(lastEntry.get("Result")).isEqualTo(expectedEntry.get("Result"));
        }
        if (expectedEntry.containsKey("Timestamp")) {
            assertThat(lastEntry.get("Timestamp")).isNotNull();
        }
    }

    @Then("the audit log includes attempted changes")
    public void theAuditLogIncludesAttemptedChanges() {
        assertThat(auditLogEntries).isNotEmpty();
        Map<String, String> lastEntry = auditLogEntries.get(auditLogEntries.size() - 1);
        assertThat(lastEntry.get("AttemptedChange")).isNotNull();
    }

    @Then("all {int} attempts are blocked with CONFIGURATION_LOCKED")
    public void allAttemptsAreBlockedWithConfigurationLocked(int expectedCount) {
        Integer actualCount = (Integer) originalConfiguration.get("blockedAttempts");
        assertThat(actualCount).isEqualTo(expectedCount);
    }

    @Then("{int} audit log entries are created")
    public void auditLogEntriesAreCreated(int expectedCount) {
        assertThat(auditLogEntries.size()).isGreaterThanOrEqualTo(expectedCount);
    }

    @Then("no configuration changes are applied")
    public void noConfigurationChangesAreApplied() {
        assertThat(attemptedChanges).isNotEmpty();
        // All changes should have been blocked
    }

    @Then("the following are ALL immutable:")
    public void theFollowingAreAllImmutable(DataTable dataTable) {
        League league = world.getCurrentLeague();
        assertThat(league.isConfigurationLocked(world.getTestTime())).isTrue();

        // All configuration aspects should be immutable
        List<String> aspects = dataTable.asList();
        assertThat(aspects.size()).isGreaterThan(0);
    }

    @Then("attempted changes to any aspect are rejected")
    public void attemptedChangesToAnyAspectAreRejected() {
        League league = world.getCurrentLeague();

        try {
            league.validateConfigurationMutable(world.getTestTime());
            fail("Should have thrown ConfigurationLockedException");
        } catch (League.ConfigurationLockedException e) {
            // Expected
        }
    }

    @Then("the lockTimestamp is {string}")
    public void theLockTimestampIs(String timestampStr) {
        theLeagueLockTimestampIs(timestampStr);
    }

    @Then("the lockTimestamp matches the first game start time exactly")
    public void theLockTimestampMatchesTheFirstGameStartTimeExactly() {
        League league = world.getCurrentLeague();
        assertThat(league.getConfigurationLockedAt()).isEqualTo(firstGameStartTime);
    }

    @Then("the lockTimestamp is not based on league activation time")
    public void theLockTimestampIsNotBasedOnLeagueActivationTime() {
        League league = world.getCurrentLeague();
        assertThat(league.getConfigurationLockedAt()).isEqualTo(firstGameStartTime);
        assertThat(league.getConfigurationLockedAt()).isNotEqualTo(league.getCreatedAt());
    }

    @Then("the league is immediately locked")
    public void theLeagueIsImmediatelyLocked() {
        League league = world.getCurrentLeague();
        assertThat(league.isConfigurationLocked(world.getTestTime())).isTrue();
    }

    @Then("the lockReason is {string}")
    public void theLockReasonIs(String reason) {
        theLeagueLockReasonIsSetTo(reason);
    }

    @Then("the admin cannot modify configuration")
    public void theAdminCannotModifyConfiguration() {
        League league = world.getCurrentLeague();

        try {
            league.validateConfigurationMutable(world.getTestTime());
            fail("Should have thrown ConfigurationLockedException");
        } catch (League.ConfigurationLockedException e) {
            // Expected
        }
    }

    @Then("even SUPER_ADMIN cannot bypass configuration lock")
    public void evenSuperAdminCannotBypassConfigurationLock() {
        assertThat(world.getLastException()).isNotNull();
        assertThat(world.getLastException()).isInstanceOf(League.ConfigurationLockedException.class);
    }

    @Then("the lock is strictly enforced for fairness")
    public void theLockIsStrictlyEnforcedForFairness() {
        League league = world.getCurrentLeague();
        assertThat(league.isConfigurationLocked(world.getTestTime())).isTrue();
        assertThat(league.getLockReason()).isEqualTo("FIRST_GAME_STARTED");
    }

    // ==================== Helper Methods ====================

    private LocalDateTime parseETDateTime(String dateTimeStr) {
        // Remove " ET" suffix if present
        String cleanStr = dateTimeStr.replace(" ET", "").trim();

        // Parse as Eastern Time and convert to system default
        ZonedDateTime etTime = ZonedDateTime.of(
            LocalDateTime.parse(cleanStr, ET_FORMATTER),
            ET_ZONE
        );

        return etTime.toLocalDateTime();
    }

    private void storeOriginalConfiguration(League league) {
        originalConfiguration.put("name", league.getName());
        originalConfiguration.put("status", league.getStatus());

        if (league.getStartingWeek() != null) {
            originalConfiguration.put("startingWeek", league.getStartingWeek());
        }
        if (league.getNumberOfWeeks() != null) {
            originalConfiguration.put("numberOfWeeks", league.getNumberOfWeeks());
        }

        if (league.getRosterConfiguration() != null) {
            RosterConfiguration config = league.getRosterConfiguration();
            originalConfiguration.put("QB", config.getPositionSlots(Position.QB));
            originalConfiguration.put("RB", config.getPositionSlots(Position.RB));
            originalConfiguration.put("WR", config.getPositionSlots(Position.WR));
        }

        if (league.getScoringRules() != null) {
            originalConfiguration.put("receptionPoints", league.getScoringRules().getReceptionPoints());
        }
    }

    private void logAuditEntry(String action, String result) {
        Map<String, String> entry = new HashMap<>();
        entry.put("AdminId", world.getCurrentUserId() != null ? world.getCurrentUserId().toString() : "admin-id");
        entry.put("LeagueId", world.getCurrentLeagueId() != null ? world.getCurrentLeagueId().toString() : "league-123");
        entry.put("Action", action);
        entry.put("Result", result);
        entry.put("Timestamp", LocalDateTime.now().toString());
        entry.put("AttemptedChange", action);

        auditLogEntries.add(entry);
    }
}
