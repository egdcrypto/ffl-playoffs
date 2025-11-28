# BDD Test Implementation Guide

This guide explains the Cucumber BDD testing framework and provides patterns for implementing step definitions for all feature files.

## Overview

**Scope**: 24 feature files with 6,218 lines of Gherkin
**Framework**: Cucumber with Spring Boot integration
**Status**: Infrastructure complete, 2 features implemented as examples

## Architecture

### Directory Structure

```
src/test/java/com/ffl/playoffs/bdd/
├── CucumberSpringConfiguration.java    # Spring Boot integration
├── CucumberRunnerIT.java              # JUnit 5 test runner
├── World.java                         # Shared state across steps
├── README.md                          # This file
└── steps/
    ├── UserManagementSteps.java       # ✅ Implemented
    ├── LeagueManagementSteps.java     # ✅ Implemented
    ├── PATManagementSteps.java        # ⏸️ TODO
    ├── AuthenticationSteps.java       # ⏸️ TODO
    ├── RosterManagementSteps.java     # ⏸️ TODO
    └── [22 more step definition classes needed]

src/test/resources/features/
├── user-management.feature            # ✅ Copied
├── league-creation.feature            # ✅ Copied
└── [22 more feature files to copy]
```

## Implemented Features

### 1. UserManagementSteps.java
**Feature**: `user-management.feature`
**Scenarios**: Role-based access control, user creation, authorization

**Example Steps Implemented**:
- `Given a user with SUPER_ADMIN role exists`
- `When the super admin invites a new admin`
- `Then the new admin is created with ADMIN role`

### 2. LeagueManagementSteps.java
**Feature**: `league-creation.feature`
**Scenarios**: League creation, validation, configuration

**Example Steps Implemented**:
- `Given an admin user wants to create a new league`
- `When the admin creates the league`
- `Then the league is created successfully`

## How to Implement Additional Features

### Step 1: Choose a Feature File

Pick a feature file from `/features/` directory:
```bash
ls -lh features/
```

Recommended order:
1. ✅ user-management.feature (DONE)
2. ✅ league-creation.feature (DONE)
3. ⏸️ pat-management.feature (high priority)
4. ⏸️ authentication.feature (high priority)
5. ⏸️ roster-building.feature
6. ⏸️ player-selection.feature
7. ... (remaining 18 features)

### Step 2: Copy Feature File

```bash
cp features/[feature-name].feature ffl-playoffs-api/src/test/resources/features/
```

### Step 3: Create Step Definition Class

Template for new step definition class:

```java
package com.ffl.playoffs.bdd.steps;

import com.ffl.playoffs.bdd.World;
import io.cucumber.java.Before;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;

import static org.assertj.core.api.Assertions.*;

public class [Feature]Steps {

    @Autowired
    private World world;

    @Autowired
    private MongoTemplate mongoTemplate;

    // Autowire repositories and use cases as needed
    // @Autowired
    // private [Repository] repository;

    // Initialize use cases in @Before or @Autowired method

    @Before
    public void setUp() {
        // Clean database if needed (already done in World)
        // Initialize use cases
    }

    // Implement Given steps
    @Given("step text from feature file")
    public void stepMethod() {
        // Implementation
    }

    // Implement When steps
    @When("step text from feature file")
    public void stepMethod() {
        // Implementation
    }

    // Implement Then steps
    @Then("step text from feature file")
    public void stepMethod() {
        // Implementation
    }
}
```

### Step 4: Map Gherkin to Use Cases

For each feature, identify the relevant use cases:

**Example: PAT Management Feature**
```gherkin
Scenario: Create new PAT
  Given a SUPER_ADMIN user is logged in
  When they create a PAT with name "CI/CD Token" and scope "WRITE"
  Then a PAT is created with unique identifier
```

**Maps to**:
- Use Case: `CreatePATUseCase`
- Repository: `PersonalAccessTokenRepository`
- Domain Model: `PersonalAccessToken`

**Implementation**:
```java
@Autowired
private PersonalAccessTokenRepository patRepository;
private CreatePATUseCase createPATUseCase;

@Autowired
public void initialize() {
    createPATUseCase = new CreatePATUseCase(patRepository, userRepository);
}

@When("they create a PAT with name {string} and scope {string}")
public void theyCreateAPATWithNameAndScope(String name, String scope) {
    var command = new CreatePATUseCase.CreatePATCommand(
        name,
        PATScope.valueOf(scope),
        LocalDateTime.now().plusDays(90),
        world.getCurrentUserId()
    );

    CreatePATUseCase.CreatePATResult result = createPATUseCase.execute(command);
    world.setCurrentPAT(result.getPlaintextToken());
    world.setLastResponse(result);
}
```

## Running BDD Tests

### Run All Cucumber Tests
```bash
cd ffl-playoffs-api
./gradlew test --tests CucumberRunnerIT
```

### Run Specific Feature
```bash
./gradlew test --tests CucumberRunnerIT \
  -Dcucumber.filter.tags="@user-management"
```

### Generate HTML Report
Reports are generated at:
```
target/cucumber-reports/cucumber.html
```

## World Class Usage

The `World` class maintains state across steps in a scenario.

### Storing Data
```java
// Store current user
world.setCurrentUser(user);

// Store named entities
world.storeUser("admin", adminUser);
world.storeLeague("test_league", league);
world.storePAT("api_token", pat);

// Store responses
world.setLastResponse(result);
world.setLastException(exception);
```

### Retrieving Data
```java
// Get current context
User user = world.getCurrentUser();
League league = world.getCurrentLeague();
String token = world.getCurrentPATToken();

// Get named entities
User admin = world.getUser("admin");
League testLeague = world.getLeague("test_league");

// Get responses
Object result = world.getLastResponse();
Exception error = world.getLastException();
```

### State Reset
The `World` is automatically reset before each scenario by the `@Before` hook.

## Common Step Patterns

### Background Steps
```java
@Given("the system is initialized")
public void theSystemIsInitialized() {
    // Common setup for all scenarios
}
```

### Parameterized Steps
```java
@Given("a user with {string} role exists")
public void aUserWithRoleExists(String role) {
    Role userRole = Role.valueOf(role);
    // Create user with role
}

@When("the user creates {int} leagues")
public void theUserCreatesLeagues(int count) {
    for (int i = 0; i < count; i++) {
        // Create league
    }
}
```

### Data Tables
```java
@Given("the league has the following configuration:")
public void theLeagueHasConfiguration(DataTable dataTable) {
    var config = dataTable.asMaps();
    // Parse and apply configuration
}
```

### Scenario Outlines
```java
@When("starting week is {int} and duration is {int}")
public void startingWeekAndDuration(int week, int duration) {
    // Test different week configurations
}
```

## Testing Strategies

### 1. Happy Path Testing
Focus on successful scenarios first:
- User creation succeeds
- League creation succeeds
- Roster building succeeds

### 2. Validation Testing
Test business rule validation:
- Invalid week ranges
- Duplicate codes
- Authorization failures

### 3. Edge Case Testing
Test boundary conditions:
- Maximum week (22)
- Minimum duration (1)
- Empty rosters

### 4. Error Testing
Test error handling:
- Not found errors
- Authorization errors
- Validation errors

## Integration with Existing Tests

BDD tests complement integration tests:

**Integration Tests** (JUnit):
- Unit-level testing
- Repository integration
- Use case validation
- Located in: `src/test/java/.../application/usecase/`

**BDD Tests** (Cucumber):
- Behavior-driven scenarios
- End-to-end workflows
- Business requirement validation
- Located in: `src/test/java/.../bdd/`

Both test suites use:
- Same MongoDB Testcontainers
- Same Spring Boot test configuration
- Same use cases and repositories

## Feature Implementation Checklist

For each feature file:

- [ ] Copy feature file to `src/test/resources/features/`
- [ ] Create step definition class in `src/test/java/.../bdd/steps/`
- [ ] Implement Given steps (setup)
- [ ] Implement When steps (actions)
- [ ] Implement Then steps (assertions)
- [ ] Autowire required repositories
- [ ] Initialize use cases
- [ ] Use World for state management
- [ ] Run tests: `./gradlew test --tests CucumberRunnerIT`
- [ ] Verify HTML report
- [ ] Commit with message: `test: add BDD steps for [feature]`

## Remaining Features to Implement

| Priority | Feature File | Lines | Estimated Effort | Use Cases |
|----------|-------------|-------|------------------|-----------|
| HIGH | pat-management.feature | 413 | 4-6 hours | CreatePATUseCase, ValidatePATUseCase, RevokePATUseCase |
| HIGH | authentication.feature | 206 | 3-4 hours | ValidateGoogleJWTUseCase, ValidatePATUseCase |
| HIGH | roster-building.feature | 151 | 3-4 hours | BuildRosterUseCase, AddNFLPlayerToSlotUseCase |
| MED | player-selection.feature | 180 | 3-4 hours | SelectTeamUseCase, ValidateSelectionUseCase |
| MED | roster-lock.feature | 125 | 2-3 hours | LockRosterUseCase, ValidateConfigurationLockUseCase |
| MED | league-configuration.feature | 470 | 6-8 hours | ConfigureLeagueUseCase |
| MED | admin-invitation.feature | 142 | 2-3 hours | InviteAdminUseCase, AcceptAdminInvitationUseCase |
| MED | player-invitation.feature | 109 | 2-3 hours | InvitePlayerUseCase, AcceptPlayerInvitationUseCase |
| LOW | data-integration.feature | 407 | 5-7 hours | FetchNFLScheduleUseCase, SyncNFLDataUseCase |
| LOW | defensive-scoring.feature | 349 | 4-5 hours | CalculateScoresUseCase |
| LOW | field-goal-scoring.feature | 317 | 3-4 hours | CalculateScoresUseCase |
| LOW | ppr-scoring.feature | 253 | 3-4 hours | CalculateScoresUseCase |
| LOW | leaderboard.feature | 344 | 4-5 hours | CalculateLeaderboardUseCase |
| ... | (12 more features) | ~2500 | 30-40 hours | Various |

**Total Estimated Effort**: 80-100 hours for complete implementation

## Quick Start

To continue BDD implementation:

1. **Choose next feature**: `pat-management.feature` (high priority)
2. **Copy feature file**:
   ```bash
   cp features/pat-management.feature ffl-playoffs-api/src/test/resources/features/
   ```
3. **Create step definitions**: `PATManagementSteps.java`
4. **Follow UserManagementSteps.java as template**
5. **Implement steps incrementally**
6. **Run tests frequently**

## Tips for Success

1. **Start Small**: Implement one scenario at a time
2. **Reuse Steps**: Many steps can be shared across features
3. **Use World**: Store all state in World class for easy access
4. **Test Often**: Run Cucumber after each step implementation
5. **Follow Patterns**: Use existing step definitions as templates
6. **Document**: Add comments for complex step logic
7. **Commit Frequently**: Commit after each feature completion

## Support

For questions or issues:
1. Review existing step definitions
2. Check Cucumber documentation: https://cucumber.io/docs/cucumber/
3. Review Spring Boot Cucumber integration
4. See integration tests for use case examples

---

**Status**: Infrastructure complete ✅
**Next Steps**: Implement remaining 22 features following this guide
**Estimated Completion**: 80-100 hours of focused development
