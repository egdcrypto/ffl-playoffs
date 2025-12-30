@cucumber @e2e @testing @testcontainers @infrastructure
Feature: Cucumber E2E Test Infrastructure
  As a developer
  I want a robust Cucumber test infrastructure
  So that I can write and run reliable end-to-end tests

  Background:
    Given the test project is properly configured
    And Cucumber dependencies are installed
    And Docker is available for Testcontainers

  # ==========================================
  # Cucumber Configuration
  # ==========================================

  @configuration @setup
  Scenario: Configure Cucumber test runner
    Given I am setting up the test infrastructure
    When I configure Cucumber with:
      | setting              | value                          |
      | plugin               | pretty, json, html              |
      | glue                 | com.ffl.playoffs.steps         |
      | features             | src/test/resources/features    |
      | tags                 | configurable via command line  |
    Then Cucumber should be properly configured
    And tests should be discoverable

  @configuration @junit5
  Scenario: Integrate Cucumber with JUnit 5
    Given Cucumber platform engine is configured
    When I create the test suite class:
      """
      @Suite
      @IncludeEngines("cucumber")
      @SelectClasspathResource("features")
      @ConfigurationParameter(key = GLUE_PROPERTY_NAME, value = "com.ffl.playoffs.steps")
      public class CucumberTestSuite {}
      """
    Then tests should run via JUnit 5 platform
    And IDE integration should work

  @configuration @spring
  Scenario: Integrate Cucumber with Spring Boot
    Given Spring Boot test context is needed
    When I configure Spring integration:
      | component            | configuration               |
      | CucumberSpringConfig | @SpringBootTest annotation  |
      | context_caching      | Shared between scenarios    |
      | scope               | cucumber-glue               |
    Then Spring context should be available in steps
    And beans should be injectable

  @configuration @profiles
  Scenario: Configure test profiles
    Given different test environments exist
    When I configure test profiles:
      | profile     | purpose                      |
      | test        | Local test execution         |
      | ci          | CI/CD pipeline               |
      | e2e         | Full end-to-end tests        |
    Then appropriate profile should activate
    And profile-specific config should apply

  @configuration @parallel
  Scenario: Configure parallel test execution
    Given tests can run in parallel
    When I configure parallel execution:
      | setting                    | value    |
      | cucumber.execution.parallel.enabled | true     |
      | cucumber.execution.parallel.config.strategy | dynamic  |
      | junit.jupiter.execution.parallel.mode.default | concurrent |
    Then scenarios should run in parallel
    And thread safety should be maintained

  # ==========================================
  # Testcontainers MongoDB Setup
  # ==========================================

  @testcontainers @mongodb
  Scenario: Configure MongoDB Testcontainer
    Given I need MongoDB for integration tests
    When I configure MongoDB container:
      """
      @Container
      static MongoDBContainer mongoContainer =
          new MongoDBContainer("mongo:6.0")
              .withExposedPorts(27017);
      """
    Then MongoDB container should start before tests
    And container should be accessible via dynamic port

  @testcontainers @lifecycle
  Scenario: Manage container lifecycle
    Given Testcontainers are configured
    When test suite lifecycle events occur:
      | event              | container_action           |
      | before_all         | Start containers           |
      | before_each        | Reset database state       |
      | after_each         | Clean up test data         |
      | after_all          | Stop containers            |
    Then containers should follow lifecycle
    And resources should be properly cleaned

  @testcontainers @reuse
  Scenario: Reuse containers across test runs
    Given I want faster test execution
    When I enable container reuse:
      | setting                    | value    |
      | testcontainers.reuse.enable| true     |
      | container.withReuse        | true     |
    Then containers should persist between runs
    And startup time should be reduced
    And data should be reset appropriately

  @testcontainers @dynamic-properties
  Scenario: Configure dynamic Spring properties from containers
    Given containers provide dynamic connection info
    When I register dynamic properties:
      """
      @DynamicPropertySource
      static void configureProperties(DynamicPropertyRegistry registry) {
          registry.add("spring.data.mongodb.uri",
              mongoContainer::getReplicaSetUrl);
      }
      """
    Then Spring should connect to test container
    And no hardcoded ports should be needed

  @testcontainers @network
  Scenario: Configure container network
    Given multiple containers need to communicate
    When I create shared network:
      """
      static Network network = Network.newNetwork();

      @Container
      static MongoDBContainer mongo = new MongoDBContainer("mongo:6.0")
          .withNetwork(network)
          .withNetworkAliases("mongodb");
      """
    Then containers should communicate via network
    And service discovery should work

  @testcontainers @initialization
  Scenario: Initialize MongoDB with test data
    Given MongoDB container is running
    When I initialize with test data:
      | method              | description                |
      | init scripts        | Run JS initialization      |
      | mongoimport         | Import JSON fixtures       |
      | programmatic        | Insert via MongoTemplate   |
    Then test data should be available
    And data should be consistent for each test

  # ==========================================
  # Test Fixtures
  # ==========================================

  @fixtures @creation
  Scenario: Create test fixture framework
    Given I need reusable test data
    When I create fixture framework:
      | component           | purpose                      |
      | FixtureFactory      | Create test entities         |
      | FixtureLoader       | Load fixtures from files     |
      | FixtureRegistry     | Track created fixtures       |
    Then fixtures should be easily created
    And fixtures should be cleaned up after tests

  @fixtures @builders
  Scenario: Implement fixture builders
    Given I need flexible test data creation
    When I implement builders:
      """
      LeagueFixture.builder()
          .withName("Test League")
          .withMaxTeams(12)
          .withScoringType(ScoringType.PPR)
          .withTeams(TeamFixture.builder().count(6))
          .build();
      """
    Then builders should create valid entities
    And defaults should be sensible
    And customization should be easy

  @fixtures @factory
  Scenario: Use factory pattern for common fixtures
    Given common test scenarios exist
    When I create fixture factories:
      | factory                | creates                      |
      | LeagueFactory         | Standard league configurations|
      | TeamFactory           | Team with roster             |
      | PlayerFactory         | Player with stats            |
      | MatchupFactory        | Weekly matchups              |
    Then factories should provide ready fixtures
    And variations should be supported

  @fixtures @json
  Scenario: Load fixtures from JSON files
    Given fixtures are defined in JSON:
      """
      // fixtures/leagues/standard-league.json
      {
        "name": "Standard Test League",
        "maxTeams": 12,
        "scoringType": "STANDARD",
        "teams": [...]
      }
      """
    When FixtureLoader loads the file
    Then entities should be created from JSON
    And relationships should be maintained

  @fixtures @scenarios
  Scenario: Create scenario-specific fixture sets
    Given different scenarios need different data
    When I create fixture sets:
      | set_name              | description                  |
      | empty_league          | League with no teams         |
      | full_league           | League at capacity           |
      | playoff_league        | League in playoff round      |
      | draft_in_progress     | League mid-draft             |
    Then appropriate set should load per scenario
    And sets should be isolated

  @fixtures @cleanup
  Scenario: Clean up fixtures after tests
    Given fixtures were created during test
    When test completes
    Then all created data should be removed
    And database should return to clean state
    And no orphaned data should remain

  @fixtures @references
  Scenario: Handle fixture references and relationships
    Given entities have relationships
    When fixtures are created:
      | entity    | references               |
      | League    | has many Teams           |
      | Team      | has many Players         |
      | Matchup   | references two Teams     |
    Then references should be properly linked
    And cascade operations should work

  # ==========================================
  # Step Definition Patterns
  # ==========================================

  @steps @organization
  Scenario: Organize step definitions by domain
    Given step definitions are needed
    When I organize by domain:
      | package                        | domain               |
      | steps.authentication          | Login, logout, auth  |
      | steps.league                  | League operations    |
      | steps.team                    | Team management      |
      | steps.roster                  | Roster operations    |
      | steps.matchup                 | Matchup and scoring  |
    Then steps should be easily discoverable
    And related steps should be grouped

  @steps @given
  Scenario: Implement Given step patterns
    Given I am defining precondition steps
    When I implement Given patterns:
      """
      @Given("I am authenticated as {string}")
      public void authenticateAs(String role) {
          testContext.setCurrentUser(userFactory.create(role));
      }

      @Given("a league exists with {int} teams")
      public void leagueExistsWithTeams(int teamCount) {
          League league = leagueFactory.createWithTeams(teamCount);
          testContext.setCurrentLeague(league);
      }
      """
    Then Given steps should set up preconditions
    And state should be stored in context

  @steps @when
  Scenario: Implement When step patterns
    Given I am defining action steps
    When I implement When patterns:
      """
      @When("I create a new league with name {string}")
      public void createLeague(String name) {
          CreateLeagueRequest request = new CreateLeagueRequest(name);
          testContext.setResponse(leagueApi.create(request));
      }

      @When("I add player {string} to my roster")
      public void addPlayerToRoster(String playerName) {
          Player player = playerRepository.findByName(playerName);
          testContext.setResponse(rosterApi.addPlayer(player.getId()));
      }
      """
    Then When steps should perform actions
    And responses should be captured

  @steps @then
  Scenario: Implement Then step patterns
    Given I am defining verification steps
    When I implement Then patterns:
      """
      @Then("the response status should be {int}")
      public void verifyStatus(int expectedStatus) {
          assertThat(testContext.getResponse().getStatusCode())
              .isEqualTo(expectedStatus);
      }

      @Then("the league should have {int} teams")
      public void verifyTeamCount(int expectedCount) {
          League league = testContext.getCurrentLeague();
          assertThat(league.getTeams()).hasSize(expectedCount);
      }
      """
    Then Then steps should verify outcomes
    And assertions should be clear

  @steps @parameters
  Scenario: Use Cucumber parameter types
    Given I need custom parameter parsing
    When I define parameter types:
      """
      @ParameterType(".*")
      public League league(String leagueName) {
          return leagueRepository.findByName(leagueName)
              .orElseThrow(() -> new FixtureNotFoundException(leagueName));
      }

      @ParameterType("\\d+ points?")
      public Integer points(String pointsStr) {
          return Integer.parseInt(pointsStr.replaceAll("\\D", ""));
      }
      """
    Then custom types should parse in steps
    And complex values should be supported

  @steps @datatables
  Scenario: Handle DataTable parameters
    Given I need to pass tabular data
    When I implement DataTable handling:
      """
      @Given("the following teams exist:")
      public void teamsExist(DataTable dataTable) {
          List<Map<String, String>> rows = dataTable.asMaps();
          rows.forEach(row -> {
              Team team = teamFactory.create(
                  row.get("name"),
                  row.get("owner")
              );
              testContext.addTeam(team);
          });
      }
      """
    Then tables should be parsed correctly
    And entities should be created from rows

  @steps @docstrings
  Scenario: Handle DocString parameters
    Given I need to pass multiline content
    When I implement DocString handling:
      """
      @When("I submit the following JSON:")
      public void submitJson(String docString) {
          testContext.setResponse(
              api.post("/leagues", docString)
          );
      }
      """
    Then multiline content should be captured
    And formatting should be preserved

  @steps @shared-context
  Scenario: Implement shared test context
    Given steps need to share state
    When I implement TestContext:
      """
      @ScenarioScoped
      public class TestContext {
          private User currentUser;
          private League currentLeague;
          private ResponseEntity<?> lastResponse;
          // getters, setters, helper methods
      }
      """
    Then context should be injected into steps
    And state should be isolated per scenario

  # ==========================================
  # API Testing Utilities
  # ==========================================

  @api @client
  Scenario: Create API test client
    Given I need to test REST endpoints
    When I create API test client:
      """
      @Component
      public class ApiTestClient {
          private final TestRestTemplate restTemplate;

          public <T> ResponseEntity<T> get(String path, Class<T> type) {
              return restTemplate.getForEntity(path, type);
          }

          public <T> ResponseEntity<T> post(String path, Object body, Class<T> type) {
              return restTemplate.postForEntity(path, body, type);
          }
      }
      """
    Then API client should be injectable
    And common operations should be simplified

  @api @authentication
  Scenario: Handle authentication in API tests
    Given API endpoints require authentication
    When I configure auth for tests:
      | method              | implementation               |
      | JWT token           | Generate test JWT            |
      | Headers             | Add Authorization header     |
      | Test user           | Use predefined test accounts |
    Then authenticated requests should work
    And different roles should be testable

  @api @assertions
  Scenario: Create API response assertions
    Given I need to verify API responses
    When I create assertion utilities:
      """
      public class ApiAssertions {
          public static void assertSuccessResponse(ResponseEntity<?> response) {
              assertThat(response.getStatusCode().is2xxSuccessful()).isTrue();
          }

          public static void assertValidationError(ResponseEntity<?> response, String field) {
              assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
              assertThat(getErrorField(response)).isEqualTo(field);
          }
      }
      """
    Then assertions should be reusable
    And error messages should be clear

  # ==========================================
  # Database Utilities
  # ==========================================

  @database @reset
  Scenario: Reset database between tests
    Given tests should start with clean state
    When I implement database reset:
      | approach            | implementation               |
      | truncate_tables     | Delete all data              |
      | drop_recreate       | Drop and recreate schema     |
      | transaction_rollback| Rollback after each test     |
    Then database should be clean for each test
    And reset should be fast

  @database @seeding
  Scenario: Seed database with baseline data
    Given some baseline data is always needed
    When I implement seeding:
      """
      @BeforeAll
      static void seedDatabase() {
          // Insert reference data
          playerDatabase.insertAllPlayers();
          // Insert NFL schedule
          scheduleDatabase.insertCurrentSeasonSchedule();
      }
      """
    Then baseline data should always exist
    And seeding should only run once

  @database @queries
  Scenario: Create test query utilities
    Given I need to verify database state
    When I create query utilities:
      """
      @Component
      public class TestQueryService {
          public Optional<League> findLeagueByName(String name);
          public List<Team> findTeamsByLeague(String leagueId);
          public int countEntitiesOfType(Class<?> entityClass);
      }
      """
    Then verification queries should be available
    And assertions on data should be easy

  # ==========================================
  # Reporting and Output
  # ==========================================

  @reporting @html
  Scenario: Generate HTML test reports
    Given tests have executed
    When HTML report is generated
    Then report should include:
      | section             | content                    |
      | summary             | Pass/fail counts           |
      | scenarios           | Each scenario result       |
      | steps               | Step-by-step details       |
      | duration            | Execution times            |
      | failures            | Error messages and traces  |

  @reporting @json
  Scenario: Generate JSON test reports
    Given CI/CD needs machine-readable output
    When JSON report is generated
    Then report should include:
      | field               | purpose                    |
      | feature             | Feature information        |
      | scenarios           | Scenario results           |
      | steps               | Step details               |
      | status              | Pass/fail/skip             |
      | duration            | Timing in nanoseconds      |

  @reporting @screenshots
  Scenario: Capture screenshots on failure
    Given UI tests may fail
    When a scenario fails
    Then screenshot should be captured
    And screenshot should be attached to report
    And screenshot path should be logged

  @reporting @logs
  Scenario: Include logs in test reports
    Given logs are helpful for debugging
    When scenario executes
    Then relevant logs should be captured
    And logs should be associated with scenario
    And log level should be configurable

  # ==========================================
  # CI/CD Integration
  # ==========================================

  @cicd @pipeline
  Scenario: Configure tests for CI pipeline
    Given tests run in CI/CD
    When pipeline executes:
      | stage               | action                     |
      | build               | Compile test code          |
      | start_containers    | Launch Testcontainers      |
      | run_tests           | Execute Cucumber tests     |
      | collect_reports     | Gather test artifacts      |
    Then pipeline should complete successfully
    And artifacts should be available

  @cicd @tags
  Scenario: Filter tests by tags in CI
    Given different test suites exist
    When I run with tag filter:
      | command                           | runs                    |
      | mvn test -Dcucumber.filter.tags="@smoke" | Only smoke tests        |
      | mvn test -Dcucumber.filter.tags="@e2e"   | Only E2E tests          |
      | mvn test -Dcucumber.filter.tags="not @slow" | Exclude slow tests   |
    Then only matching tests should run
    And CI can run appropriate suites

  @cicd @parallel-ci
  Scenario: Parallelize tests in CI
    Given CI has multiple executors
    When I configure parallel execution:
      | setting             | value                      |
      | shard_count         | 4                          |
      | shard_index         | 0-3 (per executor)         |
    Then tests should be distributed
    And total execution time should reduce

  @cicd @artifacts
  Scenario: Collect test artifacts
    Given tests have completed
    When artifacts are collected:
      | artifact            | location                   |
      | HTML report         | target/cucumber-reports    |
      | JSON report         | target/cucumber.json       |
      | Screenshots         | target/screenshots         |
      | Logs                | target/test-logs           |
    Then all artifacts should be preserved
    And artifacts should be downloadable

  # ==========================================
  # Error Handling and Debugging
  # ==========================================

  @debugging @hooks
  Scenario: Implement debugging hooks
    Given I need to debug failing tests
    When I implement hooks:
      """
      @Before
      public void beforeScenario(Scenario scenario) {
          log.info("Starting: {}", scenario.getName());
      }

      @After
      public void afterScenario(Scenario scenario) {
          if (scenario.isFailed()) {
              captureDebugInfo(scenario);
          }
      }
      """
    Then debugging info should be available
    And failures should be diagnosable

  @debugging @retry
  Scenario: Configure test retry for flaky tests
    Given some tests may be flaky
    When I configure retry:
      | setting             | value                      |
      | retry_count         | 2                          |
      | retry_on            | failure only               |
      | backoff             | 1 second                   |
    Then flaky tests should retry
    And consistent failures should still fail

  @debugging @isolation
  Scenario: Ensure test isolation
    Given tests must be independent
    When I verify isolation:
      | check               | verification               |
      | no_shared_state     | Context is scenario-scoped |
      | database_reset      | Data cleared between tests |
      | container_reset     | Containers are clean       |
    Then tests should not affect each other
    And order should not matter

  # ==========================================
  # Performance Considerations
  # ==========================================

  @performance @startup
  Scenario: Optimize test startup time
    Given fast feedback is important
    When I optimize startup:
      | optimization        | impact                     |
      | container_reuse     | Skip container start       |
      | context_caching     | Reuse Spring context       |
      | lazy_initialization | Load only what's needed    |
    Then first test should start quickly
    And subsequent tests should be faster

  @performance @execution
  Scenario: Optimize test execution time
    Given test suite should be fast
    When I optimize execution:
      | optimization        | implementation             |
      | parallel_scenarios  | Run scenarios concurrently |
      | minimal_fixtures    | Create only needed data    |
      | efficient_cleanup   | Batch delete operations    |
    Then total suite time should be minimized
    And individual tests should be fast

  @performance @resource-management
  Scenario: Manage test resources efficiently
    Given resources should not be wasted
    When I manage resources:
      | resource            | management                 |
      | containers          | Share when possible        |
      | connections         | Pool and reuse             |
      | memory              | Clean up large objects     |
    Then resource usage should be efficient
    And no memory leaks should occur
