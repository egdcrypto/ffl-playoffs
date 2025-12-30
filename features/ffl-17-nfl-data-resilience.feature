Feature: NFL Data Integration Resilience (Circuit Breaker, Error Handling, Fallback)
  As a system
  I want robust error handling and circuit breaker patterns
  So that the application remains available even when external APIs fail

  Background:
    Given the system integrates with SportsData.io API
    And the system has fallback to ESPN API
    And circuit breaker pattern is implemented

  # Circuit Breaker States

  Scenario: Initialize circuit breaker in CLOSED state
    Given the circuit breaker is initialized
    Then the state is "CLOSED"
    And requests flow normally to SportsData.io API
    And failure count is 0

  Scenario: Increment failure count on API errors
    Given the circuit breaker is CLOSED
    When an API request fails with HTTP 500
    Then the failure count is incremented to 1
    And the request is retried
    And circuit breaker remains CLOSED

  Scenario: Open circuit after failure threshold
    Given the circuit breaker is CLOSED
    And the failure threshold is 5
    When 5 consecutive API requests fail
    Then the failure count reaches 5
    And the circuit breaker opens
    And the state changes to "OPEN"
    And subsequent requests are blocked immediately
    And fallback is activated

  Scenario: Block requests when circuit is OPEN
    Given the circuit breaker is OPEN
    When a new API request is attempted
    Then the request is immediately blocked
    And no API call is made
    And fallback response is returned
    And user sees cached or fallback data
    And response time is fast (no timeout wait)

  Scenario: Transition to HALF_OPEN after timeout period
    Given the circuit breaker is OPEN
    And the timeout period is 60 seconds
    When 60 seconds elapse
    Then the circuit breaker transitions to "HALF_OPEN"
    And allows limited test requests through
    And evaluates if API has recovered

  Scenario: Close circuit on successful test request
    Given the circuit breaker is HALF_OPEN
    When a test request to the API succeeds
    Then the circuit breaker transitions to "CLOSED"
    And failure count is reset to 0
    And normal operation resumes

  Scenario: Reopen circuit on failed test request
    Given the circuit breaker is HALF_OPEN
    When a test request to the API fails
    Then the circuit breaker returns to "OPEN"
    And timeout period is extended (exponential backoff)
    And next test attempt is in 120 seconds

  # Error Handling by HTTP Status Code

  Scenario: Handle 404 Not Found errors
    Given a request is made for Player ID 99999999
    When the API returns HTTP 404 Not Found
    Then the system recognizes resource not found
    And returns error "PLAYER_NOT_FOUND"
    And does not increment circuit breaker failure count
    And logs the missing resource
    And does not retry the request

  Scenario: Handle 500 Internal Server Error
    Given the API experiences internal errors
    When the API returns HTTP 500
    Then the system increments circuit breaker failure count
    And retries the request after 5 seconds
    And logs the server error
    And alerts ops team if errors persist

  Scenario: Handle 502 Bad Gateway errors
    Given the API gateway is experiencing issues
    When the API returns HTTP 502
    Then the system treats it as transient error
    And retries with exponential backoff (2s, 4s, 8s)
    And increments circuit breaker failure count
    And switches to fallback after 3 retries

  Scenario: Handle 503 Service Unavailable
    Given the API is temporarily unavailable
    When the API returns HTTP 503
    Then the system recognizes service downtime
    And immediately activates fallback
    And increments circuit breaker failure count
    And stops retrying until circuit breaker recovers

  Scenario: Handle 429 Too Many Requests (Rate Limit)
    Given the system exceeds API rate limit
    When the API returns HTTP 429
    Then the system backs off immediately
    And does not increment circuit breaker failure count
    And waits for Retry-After header duration
    And resumes requests after backoff period
    And adjusts rate limiter settings

  Scenario: Handle 401 Unauthorized (Invalid API Key)
    Given the API key is invalid or expired
    When the API returns HTTP 401
    Then the system logs critical error
    And sends alert to ops team immediately
    And does not retry (credentials won't change)
    And activates fallback indefinitely
    And requires manual intervention

  # Timeout Handling

  Scenario: Handle API request timeout
    Given the API is slow to respond
    When the request exceeds 10-second timeout
    Then the request is cancelled
    And error "API_TIMEOUT" is returned
    And circuit breaker failure count is incremented
    And cached data is returned as fallback
    And timeout is logged for monitoring

  Scenario: Configure different timeouts per endpoint
    Given different endpoints have different response times
    Then timeouts are configured:
      | Endpoint               | Timeout |
      | PlayerGameStatsByWeek  | 15s     |
      | FantasyDefenseByGame   | 10s     |
      | News                   | 5s      |
      | Player Search          | 8s      |
    And each endpoint has appropriate timeout

  Scenario: Increase timeout on retries
    Given the first request times out after 10 seconds
    When the system retries the request
    Then the retry timeout is increased to 15 seconds
    And gives API more time to respond
    And prevents immediate retry timeout

  # Fallback Strategies

  Scenario: Fall back to cached data on API failure
    Given Player stats were cached 1 hour ago
    When the SportsData.io API is unavailable
    Then the circuit breaker opens
    And the system returns cached data
    And displays "Last updated: 1 hour ago"
    And user experience is not interrupted

  Scenario: Fall back to ESPN API on SportsData.io failure
    Given SportsData.io circuit breaker is OPEN
    When live stats are needed
    Then the system switches to ESPN API
    And fetches player stats from ESPN
    And maps ESPN response to domain model
    And logs fallback activation
    And tracks ESPN API usage

  Scenario: Degrade gracefully when all APIs fail
    Given both SportsData.io and ESPN APIs are unavailable
    When the system attempts to fetch live stats
    Then the system returns most recent cached data
    And displays prominent warning "Live stats temporarily unavailable"
    And shows last updated timestamp
    And suggests refreshing page in 5 minutes
    And logs critical alert

  Scenario: Serve partial data when possible
    Given Player stats API is unavailable
    But Schedule API is working
    When a user views their dashboard
    Then the schedule is displayed normally
    And player stats show cached values
    And partial degradation is acceptable
    And user sees mostly functional page

  # Retry Strategies

  Scenario: Implement exponential backoff on retries
    Given an API request fails
    When the system retries
    Then retry delays are exponential:
      | Retry 1 | 2 seconds  |
      | Retry 2 | 4 seconds  |
      | Retry 3 | 8 seconds  |
      | Retry 4 | 16 seconds |
      | Retry 5 | 32 seconds |
    And maximum retry delay is capped at 60 seconds

  Scenario: Add jitter to prevent thundering herd
    Given 100 requests fail simultaneously
    When all attempt to retry after 2 seconds
    Then jitter (random 0-500ms) is added to each retry
    And requests are spread over 2.0-2.5 seconds
    And prevents overwhelming API with synchronized retries

  Scenario: Limit maximum retry attempts
    Given an API request is retrying
    When 5 retries have been attempted
    And all have failed
    Then the system stops retrying
    And returns error "MAX_RETRIES_EXCEEDED"
    And activates fallback mechanism
    And logs failure for investigation

  Scenario: Skip retries for non-retryable errors
    Given a request returns HTTP 400 Bad Request
    When the system processes the error
    Then the error is classified as non-retryable
    And no retries are attempted
    And error is returned immediately
    And developer is notified of bad request

  # Idempotency

  Scenario: Ensure safe retries with idempotency
    Given a GET request to fetch player stats
    When the request is retried
    Then the retry is safe (idempotent)
    And multiple requests produce same result
    And no side effects occur

  Scenario: Add idempotency key to non-idempotent requests
    Given a POST request to update player data
    When the request may be retried
    Then an idempotency key is included
    And duplicate requests are detected
    And prevents double-processing
    And ensures data consistency

  # Health Checks

  Scenario: Perform periodic API health checks
    Given the system monitors SportsData.io health
    When the health check runs every 60 seconds
    Then a lightweight request is made (e.g., GET /status)
    And response time is measured
    And success/failure is recorded
    And health status is tracked

  Scenario: Declare API unhealthy after consecutive failures
    Given health checks are running
    When 3 consecutive health checks fail
    Then the API is declared unhealthy
    And proactive fallback is activated
    And circuit breaker preemptively opens
    And ops team is alerted

  Scenario: Declare API healthy after recovery
    Given the API was declared unhealthy
    When 3 consecutive health checks succeed
    Then the API is declared healthy
    And fallback is deactivated
    And circuit breaker is reset to CLOSED
    And normal operation resumes

  # Bulkhead Pattern

  Scenario: Isolate failures with bulkhead pattern
    Given the system calls multiple SportsData.io endpoints
    When /PlayerGameStatsByWeek fails repeatedly
    Then only that endpoint's circuit breaker opens
    And other endpoints (/News, /Schedule) remain functional
    And failures are isolated per endpoint
    And prevents cascading failures

  Scenario: Allocate separate thread pools per API
    Given the system uses thread pools for API calls
    Then thread pools are allocated:
      | SportsData.io API | 20 threads |
      | ESPN API          | 10 threads |
      | Database          | 30 threads |
    And thread pool exhaustion in one doesn't affect others
    And prevents resource starvation

  # Graceful Degradation

  Scenario: Disable non-critical features on partial failure
    Given the News API is unavailable
    But Player Stats API is working
    When the system detects News API failure
    Then the news feed section is hidden
    And core fantasy scoring continues to work
    And users are notified "News temporarily unavailable"
    And essential features remain operational

  Scenario: Reduce data freshness requirements
    Given real-time stats API is struggling
    When response times exceed 5 seconds
    Then polling frequency is reduced from 30s to 60s
    And reduces load on API
    And gracefully degrades real-time experience
    And still provides reasonably fresh data

  # Error Response Standards

  Scenario: Return consistent error response format
    Given any error occurs in the system
    When the error response is generated
    Then the response follows standard format:
      | error.code        | API_TIMEOUT          |
      | error.message     | API request timed out|
      | error.timestamp   | ISO 8601 timestamp   |
      | error.requestId   | Unique request ID    |
      | error.retryable   | true/false           |
    And errors are machine-readable

  Scenario: Include helpful error details for debugging
    Given an API error occurs
    When the error is logged
    Then details include:
      | API endpoint      |
      | HTTP status code  |
      | Response body     |
      | Request headers   |
      | Timestamp         |
      | Circuit breaker state |
    And enables rapid debugging

  # Monitoring and Alerting

  Scenario: Alert on circuit breaker open
    Given the circuit breaker opens
    When the state changes from CLOSED to OPEN
    Then an alert is triggered
    And ops team receives notification
    And alert includes:
      | API affected       | SportsData.io        |
      | Failure count      | 5                    |
      | Last error         | HTTP 500             |
      | Time opened        | 2024-12-15T15:32:10Z |
    And enables rapid response

  Scenario: Alert on high error rate
    Given the system tracks error rates
    When error rate exceeds 10% over 5 minutes
    Then a high error rate alert is triggered
    And ops team is notified
    And system may preemptively activate fallback
    And prevents user impact

  Scenario: Dashboard displays resilience metrics
    Given ops team views monitoring dashboard
    Then resilience metrics are displayed:
      | Circuit Breaker State  | CLOSED         |
      | Failure Rate           | 2.3%           |
      | Success Rate           | 97.7%          |
      | Average Response Time  | 245ms          |
      | P99 Response Time      | 1.2s           |
      | Fallback Activations   | 3 (last 24h)   |
      | API Health             | Healthy        |
    And provides visibility into system health

  # Fallback Data Quality

  Scenario: Tag fallback data with source
    Given data is served from fallback
    When the response is returned
    Then the data includes metadata:
      | source    | CACHE       |
      | age       | 1 hour      |
      | fresh     | false       |
    And user knows data may be stale

  Scenario: Warn user when serving stale data
    Given cached data is 6 hours old
    When the data is returned as fallback
    Then a warning is included:
      "This data may be outdated. Last updated: 6 hours ago"
    And user is informed of data quality
    And can make informed decisions

  # Testing Resilience

  Scenario: Simulate API failure in test environment
    Given the test environment has chaos engineering enabled
    When a test triggers API failure simulation
    Then the API returns errors for X% of requests
    And circuit breaker behavior is verified
    And fallback mechanisms are tested
    And resilience is validated

  Scenario: Test circuit breaker state transitions
    Given the circuit breaker is CLOSED
    When 5 failures are injected
    Then the circuit opens
    After 60 seconds, it transitions to HALF_OPEN
    When a success is injected
    Then it transitions to CLOSED
    And full state machine is validated

  # Recovery Procedures

  Scenario: Automatically recover from transient failures
    Given SportsData.io experiences 5-minute outage
    When the circuit breaker opens
    And enters timeout period
    After 60 seconds, circuit transitions to HALF_OPEN
    When test request succeeds
    Then circuit closes
    And normal operation resumes automatically
    And no manual intervention required

  Scenario: Manual circuit breaker reset
    Given the circuit breaker is stuck OPEN
    And the API is known to be healthy
    When an admin manually resets the circuit breaker
    Then the state is forced to CLOSED
    And failure count is reset to 0
    And requests resume immediately
    And admin action is logged

  # Load Shedding

  Scenario: Shed low-priority requests under high load
    Given the API is under heavy load
    And response times exceed 3 seconds
    When low-priority requests (player search) arrive
    Then those requests are rejected
    And error "SERVICE_OVERLOADED" is returned
    And high-priority requests (live stats) are processed
    And protects API from overload

  Scenario: Implement request priority queue
    Given requests have different priorities:
      | Live stats polling     | Priority 1 (highest) |
      | Player stats           | Priority 2           |
      | News feed              | Priority 3           |
      | Player search          | Priority 4 (lowest)  |
    When system is under load
    Then high-priority requests are processed first
    And low-priority requests may be delayed or dropped
    And ensures critical features work

  # Dependency Isolation

  Scenario: Isolate third-party API failures
    Given the system depends on SportsData.io
    When SportsData.io fails completely
    Then the failure is contained
    And does not crash the application
    And user-facing features degrade gracefully
    And core application remains running
    And database and authentication continue to work

  Scenario: Prevent cascading failures
    Given Service A depends on Service B
    And Service B depends on SportsData.io
    When SportsData.io fails
    Then Service B handles the failure
    And does not propagate failure to Service A
    And each layer has circuit breaker
    And failures are contained at each level

  # Documentation and Runbooks

  Scenario: Provide runbook for circuit breaker open
    Given the circuit breaker opens
    When ops team is alerted
    Then runbook is referenced with steps:
      1. Check SportsData.io status page
      2. Verify API credentials
      3. Review error logs
      4. Check rate limiting
      5. Manually reset circuit breaker if API is healthy
    And enables rapid incident resolution

  # ============================================
  # ADVANCED CIRCUIT BREAKER PATTERNS
  # ============================================

  Scenario: Slow call circuit breaker
    Given the circuit breaker monitors response times
    And slow call threshold is 5 seconds
    When 50% of calls exceed 5 seconds (slow call rate)
    Then the circuit breaker opens based on slowness
    And prevents degraded performance from affecting users
    And metrics track slow call percentage

  Scenario: Half-open state with limited probe requests
    Given the circuit breaker is in HALF_OPEN state
    And permits 3 test requests
    When the first 2 test requests succeed
    Then the circuit remains HALF_OPEN
    When the 3rd test request succeeds
    Then the circuit transitions to CLOSED
    And gradual recovery is validated

  Scenario: Half-open failure immediately reopens circuit
    Given the circuit breaker is in HALF_OPEN state
    When the first test request fails
    Then the circuit immediately returns to OPEN
    And the timeout period is doubled (exponential backoff)
    And no more test requests are allowed this period

  Scenario: Sliding window failure rate calculation
    Given the circuit breaker uses a sliding window of 100 calls
    When 10 failures occur in the last 100 calls
    Then the failure rate is 10%
    And if threshold is 50%, circuit remains CLOSED
    When 60 failures occur in the last 100 calls
    Then the failure rate is 60%
    And circuit opens (exceeds 50% threshold)

  Scenario: Count-based sliding window
    Given the circuit breaker uses count-based window of 10 calls
    When the last 10 calls are: success, success, fail, fail, fail, fail, fail, success, success, fail
    Then failure count is 6 out of 10
    And failure rate is 60%
    And circuit opens if threshold exceeded

  Scenario: Time-based sliding window
    Given the circuit breaker uses time-based window of 60 seconds
    When 5 failures occur in the last 60 seconds
    And 100 total requests in the last 60 seconds
    Then failure rate is 5%
    And circuit remains closed

  Scenario: Configure different thresholds per endpoint criticality
    Given endpoints have different failure thresholds:
      | endpoint           | failureThreshold | slowCallThreshold |
      | /live-stats        | 30%              | 2 seconds         |
      | /player-profile    | 50%              | 5 seconds         |
      | /news              | 70%              | 10 seconds        |
    When evaluating circuit breaker state
    Then each endpoint uses its configured thresholds
    And critical endpoints have stricter thresholds

  Scenario: Circuit breaker with minimum call threshold
    Given the circuit breaker requires minimum 10 calls before evaluation
    When only 5 calls have been made (all failures)
    Then the circuit remains CLOSED (not enough samples)
    When 10 calls have been made (all failures)
    Then the circuit opens (enough samples to evaluate)

  # ============================================
  # ADVANCED FALLBACK STRATEGIES
  # ============================================

  Scenario: Multi-level fallback cascade
    Given fallback levels are configured:
      | Level 1 | Redis cache (hot)        |
      | Level 2 | ESPN API (alternate)     |
      | Level 3 | MongoDB cache (warm)     |
      | Level 4 | Static default values    |
    When SportsData.io fails
    Then Level 1 is attempted first
    If Level 1 misses, Level 2 is attempted
    And cascade continues until success or exhaustion
    And metrics track which level served the request

  Scenario: Fallback with data freshness validation
    Given cached data has a freshness threshold of 4 hours
    When fallback to cache is triggered
    Then the cache is checked for data age
    If data is older than 4 hours
    Then a warning is attached to the response
    And data is still returned (stale better than nothing)

  Scenario: Hybrid fallback combining sources
    Given SportsData.io is partially available
    When player stats endpoint fails but schedule endpoint works
    Then player stats come from cache
    And schedule comes from live API
    And response combines both sources
    And source metadata indicates hybrid response

  Scenario: Fallback with automatic refresh attempt
    Given cached data is served as fallback
    And background refresh is enabled
    When a cache hit occurs during fallback
    Then a background job attempts to refresh from API
    And user gets immediate cache response
    And cache is updated if background refresh succeeds

  Scenario: Fallback data transformation
    Given ESPN API response format differs from SportsData.io
    When fallback to ESPN is activated
    Then the ESPN response is transformed to match domain model
    And field mappings are applied:
      | ESPN Field    | Domain Field      |
      | playerId      | externalPlayerId  |
      | stats.rushing | rushingYards      |
      | stats.passing | passingYards      |
    And response is consistent regardless of source

  Scenario: Conditional fallback based on request type
    Given different request types have different fallback strategies
    When request type is "live-score"
    Then fallback returns cached data with 30-second max age
    When request type is "historical-stats"
    Then fallback returns cached data with 24-hour max age
    And fallback strategy matches data volatility

  Scenario: Circuit breaker per fallback source
    Given each fallback source has its own circuit breaker
    When ESPN API (fallback) also fails repeatedly
    Then ESPN's circuit breaker opens
    And system skips to next fallback level
    And prevents wasting time on broken fallback

  # ============================================
  # RETRY WITH CONTEXT PRESERVATION
  # ============================================

  Scenario: Preserve request context across retries
    Given a request includes context:
      | requestId       | req-123-abc       |
      | correlationId   | corr-456-def      |
      | userId          | user-789          |
    When the request is retried
    Then all context is preserved in retry
    And logs show same requestId across attempts
    And distributed tracing links all attempts

  Scenario: Retry with modified parameters
    Given a request for page size 100 times out
    When the request is retried
    Then page size is reduced to 50
    And smaller payloads are more likely to succeed
    And adaptive retry improves success rate

  Scenario: Retry budget per request
    Given each request has a retry budget of 3 attempts
    When 3 retries are exhausted
    Then no more retries occur for this request
    And final failure is reported
    And retry budget prevents infinite loops

  Scenario: Retry budget per time window
    Given the system has a global retry budget of 100 per minute
    When 100 retries occur in 1 minute
    Then additional retries are rejected with "RETRY_BUDGET_EXHAUSTED"
    And prevents retry storms from overwhelming API

  Scenario: Selective retry based on error analysis
    Given an error response is received
    When error contains "invalid_api_key"
    Then retry is skipped (error is permanent)
    When error contains "rate_limit_exceeded"
    Then retry is scheduled after Retry-After delay
    When error contains "internal_server_error"
    Then immediate retry with backoff is attempted

  # ============================================
  # RATE LIMITING INTEGRATION
  # ============================================

  Scenario: Integrate rate limiter with circuit breaker
    Given the API rate limit is 100 requests per minute
    And current usage is 95 requests
    When 10 new requests arrive
    Then 5 requests are processed
    And 5 requests are queued for next minute
    And rate limiter prevents 429 errors proactively

  Scenario: Adaptive rate limiting based on API response
    Given the API returns X-RateLimit-Remaining: 10
    When the system parses rate limit headers
    Then request rate is reduced to preserve quota
    And rate limiter adapts to API feedback
    And 429 errors are minimized

  Scenario: Rate limit sharing across instances
    Given 3 application instances share API quota
    When rate limit state is stored in Redis
    Then all instances see current usage
    And rate limit is enforced globally
    And no single instance exhausts quota

  Scenario: Priority-based rate limit allocation
    Given 100 requests per minute quota
    When allocating across request types:
      | Type         | Allocation |
      | Live stats   | 50%        |
      | Player data  | 30%        |
      | News         | 15%        |
      | Search       | 5%         |
    Then critical requests get priority allocation
    And low-priority requests are throttled first

  # ============================================
  # OBSERVABILITY AND DISTRIBUTED TRACING
  # ============================================

  Scenario: Distributed tracing for API calls
    Given distributed tracing is enabled
    When an API call is made
    Then a span is created with:
      | spanName      | sportsdata.getPlayerStats |
      | attributes    | playerId, week, endpoint  |
      | status        | OK or ERROR               |
      | duration      | measured in ms            |
    And traces are exported to observability platform

  Scenario: Trace context propagation to external API
    Given a trace context exists
    When calling SportsData.io API
    Then trace headers are included:
      | traceparent   | 00-traceId-spanId-01 |
      | tracestate    | vendor=ffl           |
    And enables end-to-end tracing if API supports it

  Scenario: Correlation ID for request tracking
    Given a user request has correlationId "corr-abc-123"
    When the request triggers multiple API calls
    Then all API calls include X-Correlation-Id: corr-abc-123
    And all logs include the correlation ID
    And debugging across services is simplified

  Scenario: Metrics for circuit breaker state changes
    Given Prometheus metrics are configured
    When circuit breaker state changes
    Then metrics are emitted:
      | circuit_breaker_state        | gauge   | 0=CLOSED, 1=OPEN, 2=HALF_OPEN |
      | circuit_breaker_calls_total  | counter | success/failure labels        |
      | circuit_breaker_failures     | counter | by error type                 |
      | circuit_breaker_opens_total  | counter | number of times opened        |
    And dashboards visualize circuit breaker health

  Scenario: Custom metrics for fallback usage
    Given fallback is activated
    Then the following metrics are recorded:
      | fallback_activations_total   | counter | by source              |
      | fallback_latency_seconds     | histogram | time to fallback     |
      | fallback_data_age_seconds    | gauge   | staleness of data      |
      | fallback_success_rate        | gauge   | fallback effectiveness |

  Scenario: Log aggregation with structured logging
    Given structured logging is enabled
    When an API error occurs
    Then log entry includes structured fields:
      | level         | ERROR                    |
      | message       | API call failed          |
      | endpoint      | /PlayerGameStatsByWeek   |
      | statusCode    | 500                      |
      | latencyMs     | 5234                     |
      | circuitState  | OPEN                     |
      | retryAttempt  | 3                        |
      | correlationId | corr-abc-123             |
    And logs are searchable and aggregatable

  # ============================================
  # CONFIGURATION AND TUNING
  # ============================================

  Scenario: Dynamic circuit breaker configuration
    Given circuit breaker settings are in config store
    When an admin updates failure threshold from 50% to 30%
    Then the change takes effect without restart
    And new thresholds apply to new requests
    And existing circuit states are preserved

  Scenario: Feature flag for fallback strategies
    Given fallback strategies are controlled by feature flags
    When flag "espn_fallback_enabled" is disabled
    Then ESPN fallback is skipped
    And system falls back to cache directly
    And feature flags enable A/B testing of strategies

  Scenario: Environment-specific resilience settings
    Given different environments have different needs
    When configuring resilience:
      | Environment | Failure Threshold | Timeout | Retries |
      | dev         | 80%               | 30s     | 1       |
      | staging     | 60%               | 15s     | 2       |
      | prod        | 40%               | 10s     | 3       |
    Then each environment has appropriate settings
    And production has strictest thresholds

  Scenario: Auto-tuning based on historical data
    Given the system collects performance metrics
    When analyzing the last 7 days of data
    Then optimal thresholds are suggested:
      | metric              | current | suggested | reason                |
      | failureThreshold    | 50%     | 35%       | P95 failure rate: 25% |
      | timeoutMs           | 10000   | 8000      | P99 latency: 6500ms   |
      | retryCount          | 3       | 2         | 3rd retry success: 5% |
    And operators can accept or reject suggestions

  # ============================================
  # MULTI-REGION FAILOVER
  # ============================================

  Scenario: Geographic failover to backup region
    Given primary API endpoint is in us-east-1
    And backup endpoint is in us-west-2
    When primary endpoint circuit breaker opens
    Then traffic is routed to us-west-2
    And latency may increase slightly
    And availability is maintained

  Scenario: DNS-based failover
    Given DNS health checks monitor API endpoint
    When primary endpoint fails health checks
    Then DNS automatically routes to backup
    And clients are directed to healthy endpoint
    And failover is transparent to application

  Scenario: Active-active multi-region
    Given both regions handle traffic simultaneously
    When one region degrades
    Then traffic is shifted to healthy region
    And load balancer detects health issues
    And no complete outage occurs

  # ============================================
  # CHAOS ENGINEERING
  # ============================================

  Scenario: Chaos testing with controlled failure injection
    Given chaos testing is enabled in staging
    When failure injection is configured:
      | type        | rate | duration |
      | latency     | 30%  | 5s       |
      | error       | 10%  | HTTP 500 |
      | timeout     | 5%   | 15s      |
    Then failures are randomly injected
    And resilience mechanisms are exercised
    And system behavior under failure is validated

  Scenario: Chaos monkey kills random services
    Given chaos monkey is enabled
    When a random service instance is terminated
    Then other instances handle the load
    And auto-scaling provisions replacement
    And no user impact occurs

  Scenario: Simulate network partition
    Given network partition simulation is enabled
    When partition between app and API is simulated
    Then circuit breaker detects failures
    And fallback is activated
    And system handles partition gracefully
    When partition is resolved
    Then system recovers automatically

  Scenario: Gradual degradation testing
    Given load testing with increasing failure rate
    When failure rate increases from 0% to 50% over 30 minutes
    Then system gracefully degrades
    And critical features remain available longer
    And degradation thresholds are validated

  # ============================================
  # RECOVERY ORCHESTRATION
  # ============================================

  Scenario: Automated recovery verification
    Given the circuit breaker transitions from OPEN to HALF_OPEN
    When test requests are sent
    Then success rate is measured
    And if > 80% success, circuit closes
    And if < 50% success, circuit reopens
    And partial recovery is handled appropriately

  Scenario: Gradual traffic ramp-up after recovery
    Given the circuit breaker closes after recovery
    When normal traffic resumes
    Then traffic is ramped up gradually:
      | Time     | Traffic % |
      | 0-30s    | 10%       |
      | 30-60s   | 25%       |
      | 60-90s   | 50%       |
      | 90-120s  | 100%      |
    And prevents overwhelming recovering service

  Scenario: Recovery with warm-up period
    Given the circuit breaker transitions to CLOSED
    When warm-up period is enabled
    Then call rate is limited for 60 seconds
    And allows service to warm up (caches, connections)
    And prevents immediate overload after recovery

  Scenario: Automatic rollback on recovery failure
    Given traffic ramp-up is in progress
    When error rate spikes during ramp-up
    Then ramp-up is paused
    And circuit breaker may reopen
    And traffic is reduced to previous stable level
    And failed recovery is detected early

  # ============================================
  # SLA MANAGEMENT
  # ============================================

  Scenario: SLA monitoring for API availability
    Given SLA target is 99.9% availability
    When the system tracks uptime
    Then availability is calculated:
      | Period    | Uptime     | Status    |
      | Last hour | 100%       | Meeting   |
      | Last day  | 99.95%     | Meeting   |
      | Last week | 99.87%     | At risk   |
    And alerts fire when SLA is at risk

  Scenario: Error budget consumption tracking
    Given monthly error budget is 0.1% (43 minutes downtime)
    When 30 minutes of downtime occur
    Then error budget consumed is 70%
    And remaining budget is 13 minutes
    And alerts fire at 50%, 80%, 100% consumption

  Scenario: SLA credit calculation for outages
    Given an outage lasts 2 hours
    When calculating SLA credits
    Then impact is assessed:
      | Affected users | 10,000        |
      | Impact level   | Partial (P1)  |
      | Duration       | 120 minutes   |
    And credit calculation follows policy
    And incident report is generated

  # ============================================
  # EDGE CASES AND SPECIAL HANDLING
  # ============================================

  Scenario: Handle partial response from API
    Given the API returns partial data (some fields missing)
    When processing the response
    Then missing fields are handled gracefully
    And defaults are applied where appropriate
    And partial data is served with warning
    And full refresh is scheduled

  Scenario: Handle corrupted API response
    Given the API returns malformed JSON
    When parsing the response
    Then parse error is caught
    And error is classified as server error (not client)
    And circuit breaker failure count is incremented
    And fallback is activated

  Scenario: Handle unexpected response structure
    Given the API changes response schema without notice
    When new fields are encountered
    Then unknown fields are ignored
    When expected fields are missing
    Then error is logged and fallback activated
    And schema validation protects against changes

  Scenario: Handle extremely slow degradation
    Given response times increase gradually
    When average latency exceeds threshold
    Then slow call circuit breaker activates
    And prevents gradual degradation from going unnoticed
    And early warning enables proactive response

  Scenario: Handle intermittent failures
    Given failures occur randomly (10% failure rate)
    When circuit breaker evaluates
    Then sliding window averages the failure rate
    And single failures don't trigger circuit open
    And sustained failure pattern is detected

  Scenario Outline: Error classification and handling
    Given an error with HTTP status <status> occurs
    When classifying the error
    Then it is classified as <classification>
    And retry behavior is <retryBehavior>
    And circuit breaker impact is <circuitImpact>

    Examples:
      | status | classification   | retryBehavior     | circuitImpact    |
      | 400    | CLIENT_ERROR     | no retry          | no impact        |
      | 401    | AUTH_ERROR       | no retry          | no impact        |
      | 403    | AUTH_ERROR       | no retry          | no impact        |
      | 404    | NOT_FOUND        | no retry          | no impact        |
      | 429    | RATE_LIMITED     | retry after delay | no impact        |
      | 500    | SERVER_ERROR     | retry with backoff| increment failure|
      | 502    | GATEWAY_ERROR    | retry with backoff| increment failure|
      | 503    | UNAVAILABLE      | retry with backoff| increment failure|
      | 504    | TIMEOUT          | retry with backoff| increment failure|

  # ============================================
  # DEPENDENCY HEALTH AGGREGATION
  # ============================================

  Scenario: Aggregate health of all dependencies
    Given the system depends on multiple services
    When health check endpoint is called
    Then aggregated health is returned:
      | dependency     | status   | latency | details           |
      | SportsData.io  | healthy  | 120ms   | circuit: CLOSED   |
      | ESPN API       | healthy  | 250ms   | circuit: CLOSED   |
      | Redis Cache    | healthy  | 5ms     | connected         |
      | MongoDB        | degraded | 500ms   | replica lag       |
      | Overall        | degraded |         | 1 degraded dep    |
    And overall status reflects worst dependency

  Scenario: Kubernetes readiness based on dependencies
    Given readiness probe checks critical dependencies
    When SportsData.io circuit is OPEN
    And ESPN fallback is healthy
    Then readiness probe returns healthy (fallback available)
    When all data sources are unavailable
    Then readiness probe returns unhealthy
    And Kubernetes stops routing traffic to pod

  Scenario: Liveness probe independent of dependencies
    Given liveness probe checks application health
    When SportsData.io is completely down
    Then liveness probe still returns healthy
    And application is not restarted due to external failure
    And external failures don't cause restart loops
