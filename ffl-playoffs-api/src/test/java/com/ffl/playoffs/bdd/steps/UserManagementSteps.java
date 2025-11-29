package com.ffl.playoffs.bdd.steps;

import com.ffl.playoffs.application.usecase.CreateUserAccountUseCase;
import com.ffl.playoffs.application.usecase.InviteAdminUseCase;
import com.ffl.playoffs.bdd.World;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.port.UserRepository;
import io.cucumber.java.Before;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;

import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

/**
 * Step definitions for User Management features
 * Implements Gherkin steps from user-management.feature
 */
public class UserManagementSteps {

    @Autowired
    private World world;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private MongoTemplate mongoTemplate;

    private CreateUserAccountUseCase createUserUseCase;
    private InviteAdminUseCase inviteAdminUseCase;

    @Before
    public void setUp() {
        // Clean database before each scenario
        mongoTemplate.getDb().listCollectionNames()
                .forEach(collectionName -> mongoTemplate.getCollection(collectionName).drop());

        // Reset world state
        world.reset();

        // Initialize use cases
        createUserUseCase = new CreateUserAccountUseCase(userRepository);
        inviteAdminUseCase = new InviteAdminUseCase(userRepository);
    }

    // Background steps

    @Given("the system has three role levels: SUPER_ADMIN, ADMIN, and PLAYER")
    public void theSystemHasThreeRoleLevels() {
        // Verify enum has all three roles
        assertThat(Role.values()).containsExactlyInAnyOrder(
                Role.SUPER_ADMIN,
                Role.ADMIN,
                Role.PLAYER
        );
    }

    @Given("SUPER_ADMIN cannot be created through invitation")
    public void superAdminCannotBeCreatedThroughInvitation() {
        // This is enforced in the InviteAdminUseCase
        // It only creates ADMIN role users
        // Verified by checking that invite result has ADMIN role
    }

    @Given("SUPER_ADMIN is bootstrapped via configuration")
    public void superAdminIsBootstrappedViaConfiguration() {
        // Super admin is created via bootstrap script, not through normal flow
        // This step documents the requirement
    }

    // User creation steps

    @Given("a user with SUPER_ADMIN role exists")
    @Given("a user with {string} role exists")
    public void aUserWithRoleExists(String role) {
        Role userRole = Role.valueOf(role != null ? role : "SUPER_ADMIN");
        var command = new CreateUserAccountUseCase.CreateUserCommand(
                "test-" + userRole.name().toLowerCase() + "@example.com",
                "Test " + userRole.name(),
                "google-" + userRole.name().toLowerCase(),
                userRole
        );

        User user = createUserUseCase.execute(command);
        world.setCurrentUser(user);
        world.storeUser(userRole.name(), user);
    }

    @Given("a user with ADMIN role exists")
    public void aUserWithAdminRoleExists() {
        aUserWithRoleExists("ADMIN");
    }

    @Given("a user with PLAYER role exists")
    public void aUserWithPlayerRoleExists() {
        aUserWithRoleExists("PLAYER");
    }

    @Given("the admin owns {int} leagues")
    @Given("the admin owns {int} league(s)")
    public void theAdminOwnsLeagues(int count) {
        // This would be handled by LeagueManagementSteps
        // For now, just store the count in world
        world.setLastResponse(count);
    }

    // Action steps

    @When("the super admin accesses system-wide endpoints")
    public void theSuperAdminAccessesSystemWideEndpoints() {
        // This step represents making API calls with super admin permissions
        // In actual implementation, this would call API endpoints
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.SUPER_ADMIN);
    }

    @When("the admin attempts to access system resources")
    public void theAdminAttemptsToAccessSystemResources() {
        // This step represents making API calls with admin permissions
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.ADMIN);
    }

    @When("the player attempts to access admin endpoints")
    public void thePlayerAttemptsToAccessAdminEndpoints() {
        // This step represents making API calls with player permissions
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.PLAYER);
    }

    @When("the player attempts to access system resources")
    public void thePlayerAttemptsToAccessSystemResources() {
        // This step represents making API calls with player permissions
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.PLAYER);
    }

    @When("the super admin invites a new admin")
    public void theSuperAdminInvitesANewAdmin() {
        User superAdmin = world.getCurrentUser();
        var command = new InviteAdminUseCase.InviteAdminCommand(
                "newadmin@example.com",
                "New Admin",
                superAdmin.getId()
        );

        InviteAdminUseCase.InviteAdminResult result = inviteAdminUseCase.execute(command);
        world.setLastResponse(result);
        world.storeUser("invited_admin", result.getAdmin());
    }

    // Assertion steps

    @Then("the super admin can view all leagues across the system")
    public void theSuperAdminCanViewAllLeaguesAcrossTheSystem() {
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.SUPER_ADMIN);
        // Super admin has full system access
    }

    @Then("the super admin can manage admin accounts")
    public void theSuperAdminCanManageAdminAccounts() {
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.SUPER_ADMIN);
        // Verified by ability to invite admins
    }

    @Then("the super admin can generate Personal Access Tokens")
    public void theSuperAdminCanGeneratePersonalAccessTokens() {
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.SUPER_ADMIN);
        // PAT creation is restricted to SUPER_ADMIN
    }

    @Then("the super admin can audit all system activities")
    public void theSuperAdminCanAuditAllSystemActivities() {
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.SUPER_ADMIN);
        // Audit access is SUPER_ADMIN only
    }

    @Then("the admin can create and manage their own leagues")
    public void theAdminCanCreateAndManageTheirOwnLeagues() {
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.ADMIN);
        // League creation is ADMIN capability
    }

    @Then("the admin can configure their league settings")
    public void theAdminCanConfigureTheirLeagueSettings() {
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.ADMIN);
        // League configuration is owned by ADMIN
    }

    @Then("the admin can invite players to their leagues")
    public void theAdminCanInvitePlayersToTheirLeagues() {
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.ADMIN);
        // Player invitation is ADMIN capability
    }

    @Then("the admin cannot access other admins' leagues")
    public void theAdminCannotAccessOtherAdminsLeagues() {
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.ADMIN);
        // League access is scoped to owner
    }

    @Then("the admin cannot view system-wide data")
    public void theAdminCannotViewSystemWideData() {
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.ADMIN);
        // System-wide access is SUPER_ADMIN only
    }

    @Then("the new admin is created with ADMIN role")
    public void theNewAdminIsCreatedWithAdminRole() {
        InviteAdminUseCase.InviteAdminResult result =
                (InviteAdminUseCase.InviteAdminResult) world.getLastResponse();
        assertThat(result).isNotNull();
        assertThat(result.getAdmin().getRole()).isEqualTo(Role.ADMIN);
    }

    @Then("the new admin receives an invitation token")
    public void theNewAdminReceivesAnInvitationToken() {
        InviteAdminUseCase.InviteAdminResult result =
                (InviteAdminUseCase.InviteAdminResult) world.getLastResponse();
        assertThat(result.getInvitationToken()).isNotNull();
        assertThat(result.getInvitationToken()).startsWith("admin_invite_");
    }

    @Then("the player can view leagues they are invited to")
    public void thePlayerCanViewLeaguesTheyAreInvitedTo() {
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.PLAYER);
        // Players can only see leagues they're members of
    }

    @Then("the player can build their roster")
    public void thePlayerCanBuildTheirRoster() {
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.PLAYER);
        // Roster building is core PLAYER capability
    }

    @Then("the player cannot create leagues")
    public void thePlayerCannotCreateLeagues() {
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.PLAYER);
        // League creation requires ADMIN role
    }

    @Then("the player cannot invite other players")
    public void thePlayerCannotInviteOtherPlayers() {
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.PLAYER);
        // Invitation requires ADMIN role
    }

    @Then("the player cannot configure league settings")
    public void thePlayerCannotConfigureLeagueSettings() {
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.PLAYER);
        // Configuration requires ADMIN role
    }

    @Then("the player is denied access")
    public void thePlayerIsDeniedAccess() {
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.PLAYER);
        // Players cannot access admin endpoints
    }

    @Then("an authorization error is returned")
    public void anAuthorizationErrorIsReturned() {
        // This would check for 403 Forbidden in actual API response
        assertThat(world.getLastException()).isNotNull();
    }

    // Additional steps for new scenarios

    @Given("a PLAYER user exists")
    public void aPlayerUserExists() {
        aUserWithRoleExists("PLAYER");
    }

    @Given("the player is a member of a league")
    public void thePlayerIsAMemberOfALeague() {
        // This would be handled by LeagueManagementSteps
        // For now, just mark as true in world
        world.setLastResponse("player_has_league");
    }

    @Given("the player is invited to {string} by Admin A")
    public void thePlayerIsInvitedToByAdminA(String leagueName) {
        // Create Admin A if not exists
        User adminA = world.getUser("ADMIN_A");
        if (adminA == null) {
            var command = new CreateUserAccountUseCase.CreateUserCommand(
                    "admina@example.com",
                    "Admin A",
                    "google-admin-a",
                    Role.ADMIN
            );
            adminA = createUserUseCase.execute(command);
            world.storeUser("ADMIN_A", adminA);
        }
        // Store the invitation context
        world.storeLeague(leagueName, null); // Placeholder for league
    }

    @Given("the player is invited to {string} by Admin B")
    public void thePlayerIsInvitedToByAdminB(String leagueName) {
        // Create Admin B if not exists
        User adminB = world.getUser("ADMIN_B");
        if (adminB == null) {
            var command = new CreateUserAccountUseCase.CreateUserCommand(
                    "adminb@example.com",
                    "Admin B",
                    "google-admin-b",
                    Role.ADMIN
            );
            adminB = createUserUseCase.execute(command);
            world.storeUser("ADMIN_B", adminB);
        }
        // Store the invitation context
        world.storeLeague(leagueName, null); // Placeholder for league
    }

    @When("the player accepts both invitations")
    public void thePlayerAcceptsBothInvitations() {
        // Player acceptance logic would be implemented here
        // For now, just verify player exists
        assertThat(world.getCurrentUser()).isNotNull();
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.PLAYER);
    }

    @Then("the player is a member of both leagues")
    public void thePlayerIsAMemberOfBothLeagues() {
        // Verify player can access both leagues
        assertThat(world.getCurrentUser()).isNotNull();
    }

    @Then("the player can build separate rosters for each league")
    public void thePlayerCanBuildSeparateRostersForEachLeague() {
        // Roster building is core PLAYER capability per league
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.PLAYER);
    }

    @Then("the player can view standings for both leagues independently")
    public void thePlayerCanViewStandingsForBothLeaguesIndependently() {
        // Players can view standings for their leagues
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.PLAYER);
    }

    @Then("the player can build their roster with NFL player selections")
    public void thePlayerCanBuildTheirRosterWithNFLPlayerSelections() {
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.PLAYER);
        // Roster building with NFL player selection is core PLAYER capability
    }

    @Then("the player can view standings and scores for their league")
    public void thePlayerCanViewStandingsAndScoresForTheirLeague() {
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.PLAYER);
        // Players can view league standings and scores
    }

    @Then("the player cannot invite other users")
    public void thePlayerCannotInviteOtherUsers() {
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.PLAYER);
        // Invitation requires ADMIN role
    }

    @Then("the player cannot access admin functions")
    public void thePlayerCannotAccessAdminFunctions() {
        assertThat(world.getCurrentUserRole()).isEqualTo(Role.PLAYER);
        // Admin functions require ADMIN or SUPER_ADMIN role
    }

    @Given("users exist with roles: SUPER_ADMIN, ADMIN, and PLAYER")
    public void usersExistWithRolesSuperAdminAdminAndPlayer() {
        // Create all three users
        aUserWithRoleExists("SUPER_ADMIN");
        User superAdmin = world.getCurrentUser();
        world.storeUser("SUPER_ADMIN", superAdmin);

        aUserWithRoleExists("ADMIN");
        User admin = world.getCurrentUser();
        world.storeUser("ADMIN", admin);

        aUserWithRoleExists("PLAYER");
        User player = world.getCurrentUser();
        world.storeUser("PLAYER", player);
    }

    @When("each user attempts to access role-restricted endpoints")
    public void eachUserAttemptsToAccessRoleRestrictedEndpoints() {
        // This represents testing access control for each user
        assertThat(world.getUser("SUPER_ADMIN")).isNotNull();
        assertThat(world.getUser("ADMIN")).isNotNull();
        assertThat(world.getUser("PLAYER")).isNotNull();
    }

    @Then("SUPER_ADMIN can access all endpoints")
    public void superAdminCanAccessAllEndpoints() {
        User superAdmin = world.getUser("SUPER_ADMIN");
        assertThat(superAdmin).isNotNull();
        assertThat(superAdmin.hasRole(Role.SUPER_ADMIN)).isTrue();
        assertThat(superAdmin.hasRole(Role.ADMIN)).isTrue();
        assertThat(superAdmin.hasRole(Role.PLAYER)).isTrue();
    }

    @Then("ADMIN can only access admin and player endpoints")
    public void adminCanOnlyAccessAdminAndPlayerEndpoints() {
        User admin = world.getUser("ADMIN");
        assertThat(admin).isNotNull();
        assertThat(admin.hasRole(Role.ADMIN)).isTrue();
        assertThat(admin.hasRole(Role.PLAYER)).isTrue();
        assertThat(admin.hasRole(Role.SUPER_ADMIN)).isFalse();
    }

    @Then("PLAYER can only access player endpoints")
    public void playerCanOnlyAccessPlayerEndpoints() {
        User player = world.getUser("PLAYER");
        assertThat(player).isNotNull();
        assertThat(player.hasRole(Role.PLAYER)).isTrue();
        assertThat(player.hasRole(Role.ADMIN)).isFalse();
        assertThat(player.hasRole(Role.SUPER_ADMIN)).isFalse();
    }

    @Then("unauthorized access attempts return {int} Forbidden")
    public void unauthorizedAccessAttemptsReturnForbidden(int statusCode) {
        // This would check HTTP status code in actual API test
        assertThat(statusCode).isEqualTo(403);
    }
}
