@performance @optimization @load-testing @caching @database
Feature: Performance Optimization and Load Testing
  As a platform operator
  I want to optimize application performance and validate under load
  So that the platform can handle high traffic during peak playoff times

  Background:
    Given the application is deployed
    And monitoring tools are configured
    And baseline performance metrics are established

  # ==========================================
  # Database Query Optimization
  # ==========================================

  @database @query-optimization
  Scenario: Optimize slow database queries
    Given query performance is being monitored
    When I identify slow queries exceeding 100ms
    Then I should optimize by:
      | optimization         | technique                      |
      | add_indexes          | Create appropriate indexes     |
      | query_rewrite        | Restructure inefficient queries|
      | projection           | Select only needed fields      |
      | pagination           | Limit result set size          |
    And query execution time should be under 50ms

  @database @indexes
  Scenario: Create appropriate MongoDB indexes
    Given I am optimizing MongoDB queries
    When I create indexes for common queries:
      | collection | index_fields           | type       |
      | leagues    | {ownerId: 1}           | single     |
      | teams      | {leagueId: 1, name: 1} | compound   |
      | players    | {name: "text"}         | text       |
      | matchups   | {weekNumber: 1, leagueId: 1} | compound |
    Then query performance should improve
    And index usage should be verified with explain()

  @database @aggregation
  Scenario: Optimize aggregation pipelines
    Given complex aggregations are used for standings
    When I optimize aggregation pipeline:
      | stage         | optimization                   |
      | $match        | Place early to filter first    |
      | $project      | Limit fields before processing |
      | $lookup       | Use indexed foreign keys       |
      | $sort         | Ensure index-backed sorts      |
    Then aggregation should complete in under 200ms
    And memory usage should be minimized

  @database @n-plus-one
  Scenario: Eliminate N+1 query problems
    Given N+1 queries are detected
    When I refactor data access:
      | problem               | solution                     |
      | Lazy loading loops    | Eager fetch with projection  |
      | Individual lookups    | Batch queries                |
      | Nested iterations     | Single aggregation pipeline  |
    Then query count should be reduced by 90%
    And response time should improve significantly

  @database @query-hints
  Scenario: Use query hints for optimization
    Given MongoDB query planner needs guidance
    When I apply query hints:
      """
      db.collection.find(query).hint({field: 1})
      """
    Then specific index should be used
    And query plan should be optimal

  @database @read-preference
  Scenario: Configure read preference for scalability
    Given MongoDB replica set is configured
    When I set read preferences:
      | query_type        | read_preference     |
      | real-time scores  | primary             |
      | historical data   | secondaryPreferred  |
      | analytics         | secondary           |
    Then read load should be distributed
    And primary should not be overloaded

  # ==========================================
  # Caching Strategies
  # ==========================================

  @caching @redis
  Scenario: Implement Redis caching layer
    Given Redis is configured as cache
    When I implement caching:
      | data_type         | ttl       | strategy        |
      | player_stats      | 5 min     | cache-aside     |
      | league_standings  | 1 min     | cache-aside     |
      | user_session      | 30 min    | write-through   |
      | static_config     | 1 hour    | cache-aside     |
    Then cache should reduce database load
    And cache hit ratio should exceed 80%

  @caching @cache-aside
  Scenario: Implement cache-aside pattern
    Given I am implementing cache-aside:
      """
      public League getLeague(String id) {
          League cached = cache.get("league:" + id);
          if (cached != null) return cached;

          League league = repository.findById(id);
          cache.put("league:" + id, league, TTL);
          return league;
      }
      """
    Then cache should be checked first
    And database should only be queried on cache miss

  @caching @write-through
  Scenario: Implement write-through caching
    Given I need consistent cache on writes
    When I implement write-through:
      """
      public void updateTeam(Team team) {
          repository.save(team);
          cache.put("team:" + team.getId(), team);
      }
      """
    Then cache should be updated with writes
    And reads should always get fresh data

  @caching @invalidation
  Scenario: Implement cache invalidation strategies
    Given cached data may become stale
    When I implement invalidation:
      | strategy              | use_case                    |
      | TTL expiration        | Time-based staleness        |
      | Event-driven          | On entity update events     |
      | Version-based         | Check version before use    |
      | Pattern invalidation  | Clear related cache keys    |
    Then stale data should be prevented
    And invalidation should be efficient

  @caching @distributed
  Scenario: Configure distributed cache cluster
    Given multiple application instances exist
    When I configure Redis cluster:
      | setting               | value                     |
      | cluster_mode          | enabled                   |
      | replica_count         | 2                         |
      | max_connections       | 100                       |
      | connection_timeout    | 2000ms                    |
    Then cache should be shared across instances
    And failover should be automatic

  @caching @local
  Scenario: Implement local cache for hot data
    Given some data is accessed very frequently
    When I implement Caffeine local cache:
      """
      Cache<String, Player> playerCache = Caffeine.newBuilder()
          .maximumSize(10000)
          .expireAfterWrite(Duration.ofMinutes(5))
          .recordStats()
          .build();
      """
    Then local cache should reduce Redis calls
    And memory usage should be bounded

  @caching @http
  Scenario: Implement HTTP response caching
    Given API responses can be cached
    When I configure HTTP caching headers:
      | endpoint              | cache-control           |
      | GET /players          | max-age=300, public     |
      | GET /leagues/{id}     | max-age=60, private     |
      | GET /health           | no-cache                |
    Then clients should cache responses
    And CDN should cache public responses

  @caching @compression
  Scenario: Compress cached data
    Given large objects are cached
    When I enable cache compression:
      | setting               | value                   |
      | compression_enabled   | true                    |
      | min_compression_size  | 1024 bytes              |
      | compression_algorithm | LZ4                     |
    Then cache memory usage should reduce
    And compression overhead should be minimal

  # ==========================================
  # Connection Pooling
  # ==========================================

  @connection-pool @mongodb
  Scenario: Configure MongoDB connection pool
    Given MongoDB driver is used
    When I configure connection pool:
      | setting               | value                   |
      | maxPoolSize           | 100                     |
      | minPoolSize           | 10                      |
      | maxIdleTimeMS         | 60000                   |
      | waitQueueTimeoutMS    | 5000                    |
      | maxConnecting         | 5                       |
    Then connections should be reused
    And connection overhead should be minimized

  @connection-pool @redis
  Scenario: Configure Redis connection pool
    Given Redis client is used
    When I configure Lettuce pool:
      | setting               | value                   |
      | max_active            | 50                      |
      | max_idle              | 20                      |
      | min_idle              | 5                       |
      | max_wait              | 2000ms                  |
    Then Redis connections should be pooled
    And connection exhaustion should be prevented

  @connection-pool @http
  Scenario: Configure HTTP client connection pool
    Given external API calls are made
    When I configure HTTP client pool:
      | setting               | value                   |
      | max_connections       | 200                     |
      | max_per_route         | 50                      |
      | connection_timeout    | 5000ms                  |
      | socket_timeout        | 30000ms                 |
      | keep_alive            | true                    |
    Then HTTP connections should be reused
    And external API latency should be reduced

  @connection-pool @monitoring
  Scenario: Monitor connection pool metrics
    Given connection pools are configured
    When I enable pool monitoring:
      | metric                    | alert_threshold       |
      | active_connections        | 80% of max            |
      | wait_queue_size           | > 10                  |
      | connection_timeout_rate   | > 1%                  |
      | average_acquire_time      | > 100ms               |
    Then pool health should be visible
    And issues should trigger alerts

  @connection-pool @circuit-breaker
  Scenario: Implement circuit breaker for connections
    Given connections may fail under load
    When I configure circuit breaker:
      | setting               | value                   |
      | failure_threshold     | 5                       |
      | wait_duration         | 30s                     |
      | half_open_requests    | 3                       |
    Then failures should trip circuit
    And system should recover gracefully

  # ==========================================
  # Load Testing with k6
  # ==========================================

  @load-test @k6 @setup
  Scenario: Set up k6 load testing framework
    Given k6 is installed
    When I create load test scripts:
      | script              | purpose                     |
      | smoke.js            | Basic functionality check   |
      | load.js             | Normal load simulation      |
      | stress.js           | Find breaking point         |
      | spike.js            | Sudden traffic increase     |
      | soak.js             | Extended duration test      |
    Then load tests should be executable
    And scripts should be maintainable

  @load-test @k6 @smoke
  Scenario: Run smoke test
    Given smoke test script is ready
    When I execute smoke test:
      """
      export let options = {
          vus: 1,
          duration: '1m',
          thresholds: {
              http_req_duration: ['p(95)<500'],
              http_req_failed: ['rate<0.01']
          }
      };
      """
    Then all endpoints should respond
    And no errors should occur

  @load-test @k6 @load
  Scenario: Run load test with expected traffic
    Given load test script is ready
    When I execute load test:
      """
      export let options = {
          stages: [
              { duration: '5m', target: 100 },
              { duration: '10m', target: 100 },
              { duration: '5m', target: 0 }
          ],
          thresholds: {
              http_req_duration: ['p(95)<1000', 'p(99)<2000'],
              http_req_failed: ['rate<0.05']
          }
      };
      """
    Then system should handle 100 concurrent users
    And response times should meet SLO

  @load-test @k6 @stress
  Scenario: Run stress test to find limits
    Given stress test script is ready
    When I execute stress test:
      """
      export let options = {
          stages: [
              { duration: '2m', target: 100 },
              { duration: '2m', target: 200 },
              { duration: '2m', target: 300 },
              { duration: '2m', target: 400 },
              { duration: '5m', target: 0 }
          ]
      };
      """
    Then breaking point should be identified
    And degradation pattern should be documented

  @load-test @k6 @spike
  Scenario: Run spike test for sudden traffic
    Given spike test script is ready
    When I execute spike test:
      """
      export let options = {
          stages: [
              { duration: '1m', target: 10 },
              { duration: '10s', target: 500 },
              { duration: '3m', target: 500 },
              { duration: '10s', target: 10 },
              { duration: '2m', target: 10 }
          ]
      };
      """
    Then system should survive sudden spike
    And recovery time should be measured

  @load-test @k6 @scenarios
  Scenario: Define realistic user scenarios
    Given I need realistic load patterns
    When I create user scenarios:
      """
      export let options = {
          scenarios: {
              browse_leagues: {
                  executor: 'constant-vus',
                  vus: 50,
                  duration: '10m'
              },
              manage_roster: {
                  executor: 'ramping-vus',
                  startVUs: 0,
                  stages: [{ duration: '5m', target: 20 }]
              },
              view_scores: {
                  executor: 'constant-arrival-rate',
                  rate: 100,
                  timeUnit: '1s',
                  duration: '10m',
                  preAllocatedVUs: 50
              }
          }
      };
      """
    Then scenarios should simulate real usage
    And different user flows should be tested

  @load-test @k6 @api-calls
  Scenario: Implement API call sequences
    Given I need to test API workflows
    When I implement k6 test functions:
      """
      export default function() {
          // Login
          let loginRes = http.post(`${BASE_URL}/auth/login`, payload);
          check(loginRes, { 'login success': (r) => r.status === 200 });

          let token = loginRes.json('token');

          // Get leagues
          let leaguesRes = http.get(`${BASE_URL}/leagues`, {
              headers: { Authorization: `Bearer ${token}` }
          });
          check(leaguesRes, { 'get leagues': (r) => r.status === 200 });

          sleep(1);
      }
      """
    Then complete workflows should be tested
    And authentication should be handled

  # ==========================================
  # Load Testing with Gatling
  # ==========================================

  @load-test @gatling @setup
  Scenario: Set up Gatling load testing framework
    Given Gatling is installed
    When I create simulation:
      """
      class LeagueSimulation extends Simulation {
          val httpProtocol = http
              .baseUrl("https://api.fflplayoffs.com")
              .acceptHeader("application/json")

          val scn = scenario("Browse Leagues")
              .exec(http("Get Leagues").get("/api/v1/leagues"))

          setUp(scn.inject(atOnceUsers(10))).protocols(httpProtocol)
      }
      """
    Then Gatling simulation should run
    And HTML report should be generated

  @load-test @gatling @injection
  Scenario: Configure Gatling injection profiles
    Given I need various load patterns
    When I configure injection:
      """
      setUp(
          scn.inject(
              nothingFor(5.seconds),
              atOnceUsers(10),
              rampUsers(100).during(60.seconds),
              constantUsersPerSec(20).during(120.seconds),
              heavisideUsers(200).during(60.seconds)
          )
      ).protocols(httpProtocol)
      """
    Then different injection patterns should work
    And load should ramp appropriately

  @load-test @gatling @feeders
  Scenario: Use Gatling feeders for test data
    Given I need varied test data
    When I configure feeders:
      """
      val userFeeder = csv("users.csv").circular
      val leagueFeeder = jsonFile("leagues.json").random

      val scn = scenario("User Actions")
          .feed(userFeeder)
          .exec(http("Login").post("/login").body(StringBody("...")))
      """
    Then test data should vary per virtual user
    And data should be loaded from files

  # ==========================================
  # Performance Metrics and Thresholds
  # ==========================================

  @metrics @slo
  Scenario: Define Service Level Objectives
    Given performance SLOs are needed
    When I define SLOs:
      | metric                    | target          |
      | p50_latency               | < 100ms         |
      | p95_latency               | < 500ms         |
      | p99_latency               | < 1000ms        |
      | error_rate                | < 0.1%          |
      | availability              | > 99.9%         |
      | throughput                | > 1000 rps      |
    Then SLOs should be measurable
    And violations should trigger alerts

  @metrics @collection
  Scenario: Collect performance metrics
    Given metrics collection is needed
    When I configure metrics:
      | metric_type           | tool              |
      | application_metrics   | Micrometer        |
      | infrastructure        | Prometheus        |
      | traces                | Jaeger            |
      | logs                  | ELK Stack         |
    Then all metrics should be collected
    And dashboards should visualize data

  @metrics @custom
  Scenario: Create custom performance metrics
    Given I need business-specific metrics
    When I implement custom metrics:
      """
      @Timed(value = "league.creation.time", percentiles = {0.5, 0.95, 0.99})
      public League createLeague(CreateLeagueRequest request) { ... }

      @Counted(value = "matchup.calculations")
      public MatchupResult calculateMatchup(String matchupId) { ... }
      """
    Then custom metrics should be recorded
    And they should be available in dashboards

  @metrics @alerting
  Scenario: Configure performance alerts
    Given I need to be notified of issues
    When I configure alerts:
      | condition                      | severity | action          |
      | p95_latency > 1000ms for 5m    | warning  | notify_slack    |
      | error_rate > 1% for 2m         | critical | page_oncall     |
      | cpu_usage > 80% for 10m        | warning  | notify_slack    |
      | memory_usage > 90%             | critical | page_oncall     |
    Then alerts should trigger appropriately
    And team should be notified

  # ==========================================
  # Performance Profiling
  # ==========================================

  @profiling @cpu
  Scenario: Profile CPU usage
    Given I need to identify CPU hotspots
    When I run CPU profiler:
      | tool              | output                    |
      | async-profiler    | flame graph               |
      | JFR               | detailed recording        |
      | VisualVM          | live profiling            |
    Then hotspots should be identified
    And optimization opportunities should be clear

  @profiling @memory
  Scenario: Profile memory usage
    Given I need to identify memory issues
    When I analyze memory:
      | analysis              | purpose                   |
      | heap_dump             | Object allocation         |
      | GC_logs               | Garbage collection        |
      | memory_leak_detection | Leak identification       |
    Then memory usage patterns should be understood
    And leaks should be identified

  @profiling @database
  Scenario: Profile database operations
    Given I need to analyze database performance
    When I use profiling tools:
      | tool                  | analysis                  |
      | MongoDB profiler      | Slow query log            |
      | explain()             | Query execution plan      |
      | mongostat             | Real-time statistics      |
    Then slow queries should be identified
    And optimization should be data-driven

  # ==========================================
  # Performance Testing in CI/CD
  # ==========================================

  @cicd @performance-tests
  Scenario: Integrate load tests in CI/CD
    Given CI/CD pipeline exists
    When I add performance stage:
      """
      performance-test:
        stage: test
        script:
          - k6 run --out influxdb=http://influxdb:8086/k6 load.js
        rules:
          - if: $CI_COMMIT_BRANCH == "main"
      """
    Then load tests should run on merge to main
    And failures should block deployment

  @cicd @regression
  Scenario: Detect performance regressions
    Given baseline performance exists
    When I compare new results:
      | metric              | baseline | current | threshold |
      | p95_latency         | 450ms    | 480ms   | +10%      |
      | throughput          | 1200rps  | 1150rps | -5%       |
    Then regressions should be detected
    And alerts should be raised for violations

  @cicd @reporting
  Scenario: Generate performance test reports
    Given load tests have completed
    When I generate reports:
      | report_type         | content                   |
      | summary             | Key metrics and pass/fail |
      | detailed            | All measurements          |
      | comparison          | vs previous run           |
      | trends              | Historical data           |
    Then reports should be archived
    And stakeholders should be informed

  # ==========================================
  # Optimization Techniques
  # ==========================================

  @optimization @async
  Scenario: Implement async processing
    Given some operations can be async
    When I implement async patterns:
      | operation           | technique                 |
      | email_sending       | Message queue             |
      | report_generation   | Background job            |
      | data_export         | Async request-response    |
    Then response times should improve
    And user experience should not block

  @optimization @batch
  Scenario: Implement batch processing
    Given many small operations occur
    When I batch operations:
      | operation           | batch_size | interval      |
      | score_updates       | 100        | 5 seconds     |
      | notification_sends  | 50         | 10 seconds    |
      | audit_log_writes    | 200        | 30 seconds    |
    Then database writes should reduce
    And throughput should improve

  @optimization @lazy-loading
  Scenario: Implement lazy loading
    Given not all data is always needed
    When I implement lazy loading:
      | entity            | lazy_fields              |
      | League            | teams, matchups          |
      | Team              | roster, transactions     |
      | Player            | historical_stats         |
    Then initial load should be faster
    And related data should load on demand

  @optimization @compression
  Scenario: Enable response compression
    Given responses can be large
    When I enable compression:
      | setting               | value                   |
      | compression_enabled   | true                    |
      | min_response_size     | 1024 bytes              |
      | compression_level     | 6                       |
      | mime_types            | application/json, text/*|
    Then response sizes should reduce
    And bandwidth should be saved

  @optimization @pagination
  Scenario: Enforce efficient pagination
    Given list endpoints return many items
    When I implement cursor-based pagination:
      | setting               | value                   |
      | default_page_size     | 20                      |
      | max_page_size         | 100                     |
      | cursor_based          | true                    |
    Then large result sets should be paginated
    And database should not scan all rows

  # ==========================================
  # Error Handling and Edge Cases
  # ==========================================

  @error-handling @graceful-degradation
  Scenario: Implement graceful degradation
    Given services may fail under load
    When I implement fallbacks:
      | service           | fallback                  |
      | live_scores       | cached scores             |
      | player_stats      | stale data with indicator |
      | recommendations   | generic suggestions       |
    Then system should remain usable
    And users should be informed of degradation

  @error-handling @timeout
  Scenario: Configure appropriate timeouts
    Given operations need time limits
    When I configure timeouts:
      | operation           | timeout     | action          |
      | database_query      | 5s          | circuit_break   |
      | external_api        | 10s         | fallback        |
      | overall_request     | 30s         | return_error    |
    Then long operations should not block
    And resources should be released

  @edge-case @thundering-herd
  Scenario: Handle thundering herd problem
    Given cache entries may expire simultaneously
    When I implement cache stampede protection:
      | technique           | description               |
      | mutex_lock          | Single thread refresh     |
      | probabilistic       | Random early expiration   |
      | external_recompute  | Background refresh        |
    Then only one thread should refresh cache
    And database should not be overwhelmed
