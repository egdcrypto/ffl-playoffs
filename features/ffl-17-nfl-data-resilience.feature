Feature: NFL Data Integration Resilience (Circuit Breaker, Error Handling, Fallback)
  As a system
  I want robust error handling and circuit breaker patterns
  So that the application remains available even when external APIs fail

  Background:
    Given the system integrates with SportsData.io API
    And the system has fallback to ESPN API
    And circuit breaker pattern is implemented
    And resilience metrics are being collected

  # ============================================================================
  # CIRCUIT BREAKER STATE MACHINE
  # ============================================================================

  @circuit-breaker @state-machine
  Scenario: Initialize circuit breaker in CLOSED state
    Given the circuit breaker is initialized
    Then the state is "CLOSED"
    And requests flow normally to SportsData.io API
    And failure count is 0
    And the circuit breaker is ready to protect the system

  @circuit-breaker @state-machine
  Scenario: Maintain CLOSED state on successful requests
    Given the circuit breaker is CLOSED
    And the failure count is 2
    When an API request succeeds
    Then the circuit breaker remains CLOSED
    And the failure count is reset to 0
    And the success count is incremented

  @circuit-breaker @state-machine
  Scenario: Increment failure count on API errors
    Given the circuit breaker is CLOSED
    And the failure count is 0
    When an API request fails with HTTP 500
    Then the failure count is incremented to 1
    And the request is retried
    And circuit breaker remains CLOSED

  @circuit-breaker @state-machine
  Scenario: Open circuit after failure threshold reached
    Given the circuit breaker is CLOSED
    And the failure threshold is 5
    And the failure count is 4
    When an API request fails with HTTP 500
    Then the failure count reaches 5
    And the circuit breaker opens
    And the state changes to "OPEN"
    And the open timestamp is recorded
    And subsequent requests are blocked immediately
    And fallback is activated

  @circuit-breaker @state-machine
  Scenario: Block requests when circuit is OPEN
    Given the circuit breaker is OPEN
    When a new API request is attempted
    Then the request is immediately blocked
    And no API call is made
    And fallback response is returned
    And user sees cached or fallback data
    And response time is under 5ms (no timeout wait)
    And the "circuit_open_rejections" metric is incremented

  @circuit-breaker @state-machine
  Scenario: Transition to HALF_OPEN after timeout period
    Given the circuit breaker is OPEN
    And the timeout period is 60 seconds
    And the circuit opened 60 seconds ago
    When a new request arrives
    Then the circuit breaker transitions to "HALF_OPEN"
    And allows exactly 1 test request through
    And evaluates if API has recovered
    And logs the state transition

  @circuit-breaker @state-machine
  Scenario: Close circuit on successful test request in HALF_OPEN
    Given the circuit breaker is HALF_OPEN
    When a test request to the API succeeds
    Then the circuit breaker transitions to "CLOSED"
    And failure count is reset to 0
    And normal operation resumes
    And "circuit_closed" event is emitted
    And ops team is notified of recovery

  @circuit-breaker @state-machine
  Scenario: Reopen circuit on failed test request in HALF_OPEN
    Given the circuit breaker is HALF_OPEN
    When a test request to the API fails
    Then the circuit breaker returns to "OPEN"
    And timeout period is extended using exponential backoff
    And next test attempt is in 120 seconds
    And consecutive failure count is incremented

  @circuit-breaker @state-machine
  Scenario: Queue requests during HALF_OPEN evaluation
    Given the circuit breaker is HALF_OPEN
    And a test request is in flight
    When 10 additional requests arrive simultaneously
    Then those requests are queued (not rejected)
    And they wait for test request result
    And if test succeeds, queued requests are processed
    And if test fails, queued requests use fallback

  # ============================================================================
  # SLIDING WINDOW ALGORITHMS
  # ============================================================================

  @circuit-breaker @sliding-window
  Scenario: Use count-based sliding window for failure tracking
    Given the circuit breaker uses count-based sliding window
    And the window size is 10 requests
    And the failure threshold is 50%
    When the last 10 requests show 6 failures
    Then the failure rate is calculated as 60%
    And the circuit breaker opens
    And older requests beyond window are not considered

  @circuit-breaker @sliding-window
  Scenario: Use time-based sliding window for failure tracking
    Given the circuit breaker uses time-based sliding window
    And the window duration is 60 seconds
    And the failure threshold is 50%
    When 20 requests in last 60 seconds show 12 failures
    Then the failure rate is calculated as 60%
    And the circuit breaker opens
    And requests older than 60 seconds are excluded

  @circuit-breaker @sliding-window
  Scenario: Require minimum request volume before opening
    Given the circuit breaker is CLOSED
    And minimum requests threshold is 10
    And only 5 requests have been made in the window
    And all 5 requests failed (100% failure rate)
    When evaluating circuit breaker state
    Then the circuit breaker remains CLOSED
    And waits for sufficient sample size
    And logs "Insufficient requests for circuit evaluation"

  @circuit-breaker @sliding-window
  Scenario: Handle window boundary transitions smoothly
    Given the circuit breaker uses time-based sliding window
    And the window is 60 seconds
    When a request from 59 seconds ago ages out of the window
    Then the failure count is decremented smoothly
    And no sudden state changes occur
    And metrics remain accurate

  # ============================================================================
  # ERROR HANDLING BY HTTP STATUS CODE
  # ============================================================================

  @error-handling @http-status
  Scenario: Handle 400 Bad Request errors
    Given a request is malformed or has invalid parameters
    When the API returns HTTP 400 Bad Request
    Then the system classifies error as "CLIENT_ERROR"
    And does not increment circuit breaker failure count
    And does not retry the request
    And logs the error with request details
    And returns user-friendly validation message

  @error-handling @http-status
  Scenario: Handle 401 Unauthorized (Invalid API Key)
    Given the API key is invalid or expired
    When the API returns HTTP 401
    Then the system logs critical error
    And sends PagerDuty alert to ops team immediately
    And does not retry (credentials won't change)
    And activates fallback indefinitely
    And requires manual intervention
    And prevents further API calls until resolved

  @error-handling @http-status
  Scenario: Handle 403 Forbidden errors
    Given the API key lacks permission for the endpoint
    When the API returns HTTP 403 Forbidden
    Then the system classifies error as "AUTHORIZATION_ERROR"
    And logs the forbidden resource
    And does not retry the request
    And alerts ops team for permission review
    And suggests checking API subscription tier

  @error-handling @http-status
  Scenario: Handle 404 Not Found errors
    Given a request is made for Player ID 99999999
    When the API returns HTTP 404 Not Found
    Then the system recognizes resource not found
    And returns error "PLAYER_NOT_FOUND"
    And does not increment circuit breaker failure count
    And logs the missing resource
    And does not retry the request
    And caches the "not found" result for 5 minutes

  @error-handling @http-status
  Scenario: Handle 408 Request Timeout from server
    Given the server takes too long to process the request
    When the API returns HTTP 408 Request Timeout
    Then the system treats it as transient error
    And increments circuit breaker failure count
    And retries with exponential backoff
    And logs timeout details

  @error-handling @http-status
  Scenario: Handle 429 Too Many Requests (Rate Limit)
    Given the system exceeds API rate limit
    When the API returns HTTP 429
    Then the system backs off immediately
    And does not increment circuit breaker failure count
    And parses Retry-After header value
    And waits for specified duration before retrying
    And adjusts rate limiter settings
    And logs rate limit event for monitoring

  @error-handling @http-status
  Scenario: Handle 500 Internal Server Error
    Given the API experiences internal errors
    When the API returns HTTP 500
    Then the system increments circuit breaker failure count
    And retries the request with exponential backoff
    And logs the server error with correlation ID
    And alerts ops team if errors persist beyond threshold

  @error-handling @http-status
  Scenario: Handle 502 Bad Gateway errors
    Given the API gateway is experiencing issues
    When the API returns HTTP 502
    Then the system treats it as transient error
    And retries with exponential backoff (2s, 4s, 8s)
    And increments circuit breaker failure count
    And switches to fallback after 3 retries

  @error-handling @http-status
  Scenario: Handle 503 Service Unavailable
    Given the API is temporarily unavailable
    When the API returns HTTP 503
    Then the system recognizes service downtime
    And immediately activates fallback
    And increments circuit breaker failure count
    And respects Retry-After header if present
    And reduces request frequency

  @error-handling @http-status
  Scenario: Handle 504 Gateway Timeout
    Given the upstream server is slow to respond
    When the API returns HTTP 504
    Then the system treats it as transient error
    And increments circuit breaker failure count
    And retries with increased timeout
    And logs gateway timeout for monitoring

  # ============================================================================
  # NETWORK ERROR HANDLING
  # ============================================================================

  @error-handling @network
  Scenario: Handle DNS resolution failure
    Given the DNS server is unreachable
    When a request is made to api.sportsdata.io
    And DNS lookup fails with NXDOMAIN
    Then the system logs DNS failure
    And increments circuit breaker failure count
    And retries after DNS cache TTL expires
    And activates fallback mechanism
    And alerts ops team for DNS investigation

  @error-handling @network
  Scenario: Handle connection refused errors
    Given the API server is not accepting connections
    When TCP connection to port 443 is refused
    Then the system logs connection refused error
    And increments circuit breaker failure count
    And retries with exponential backoff
    And switches to fallback after 3 attempts

  @error-handling @network
  Scenario: Handle connection reset errors
    Given the API server terminates connection unexpectedly
    When the connection is reset during request
    Then the system logs connection reset
    And classifies as transient network error
    And increments circuit breaker failure count
    And retries the request safely (idempotent)

  @error-handling @network
  Scenario: Handle SSL/TLS handshake failures
    Given the API server has certificate issues
    When SSL handshake fails with certificate error
    Then the system logs SSL failure with details
    And does NOT retry (security issue)
    And alerts security team immediately
    And activates fallback mechanism
    And prevents further requests until resolved

  @error-handling @network
  Scenario: Handle network partition (split brain)
    Given network connectivity to API is intermittent
    When requests alternate between success and failure
    Then the system detects unstable connection
    And increases failure threshold temporarily
    And logs network instability pattern
    And considers proactive fallback activation

  # ============================================================================
  # TIMEOUT HANDLING
  # ============================================================================

  @timeout @configuration
  Scenario: Handle API request timeout
    Given the API is slow to respond
    And request timeout is 10 seconds
    When the request exceeds 10-second timeout
    Then the request is cancelled
    And error "API_TIMEOUT" is returned
    And circuit breaker failure count is incremented
    And cached data is returned as fallback
    And timeout is logged with request details

  @timeout @configuration
  Scenario: Configure different timeouts per endpoint
    Given different endpoints have different response times
    Then timeouts are configured:
      | Endpoint               | Timeout | Connect Timeout |
      | PlayerGameStatsByWeek  | 15s     | 5s              |
      | FantasyDefenseByGame   | 10s     | 5s              |
      | News                   | 5s      | 2s              |
      | Player Search          | 8s      | 3s              |
      | Bulk Stats Export      | 60s     | 5s              |
    And each endpoint has appropriate timeout
    And connect timeout is separate from read timeout

  @timeout @configuration
  Scenario: Increase timeout on retries
    Given the first request times out after 10 seconds
    When the system retries the request
    Then the retry timeout is increased to 15 seconds
    And gives API more time to respond
    And prevents immediate retry timeout
    And maximum timeout is capped at 30 seconds

  @timeout @configuration
  Scenario: Apply adaptive timeout based on response time history
    Given the system tracks P99 response times
    And P99 for PlayerStats endpoint is 3 seconds
    When timeout is evaluated for PlayerStats
    Then timeout is set to P99 * 3 = 9 seconds
    And provides buffer above normal response times
    And adapts to changing API performance

  @timeout @configuration
  Scenario: Handle slow-start after idle connection
    Given a connection has been idle for 5 minutes
    When a new request is made on the idle connection
    Then the system allows extra time for connection warmup
    And timeout is increased by 2 seconds
    And accounts for TCP slow-start

  # ============================================================================
  # FALLBACK STRATEGIES
  # ============================================================================

  @fallback @cache
  Scenario: Fall back to cached data on API failure
    Given Player stats were cached 1 hour ago
    When the SportsData.io API is unavailable
    Then the circuit breaker opens
    And the system returns cached data
    And response includes header "X-Data-Source: CACHE"
    And response includes header "X-Cache-Age: 3600"
    And displays "Last updated: 1 hour ago"
    And user experience is not interrupted

  @fallback @multi-tier
  Scenario: Fall back to ESPN API on SportsData.io failure
    Given SportsData.io circuit breaker is OPEN
    When live stats are needed
    Then the system switches to ESPN API
    And fetches player stats from ESPN
    And maps ESPN response to domain model
    And logs fallback activation
    And tracks ESPN API usage
    And response includes "X-Data-Source: ESPN_FALLBACK"

  @fallback @multi-tier
  Scenario: Implement multi-tier fallback chain
    Given the fallback chain is configured as:
      | Priority | Source           | Max Latency |
      | 1        | SportsData.io    | 5s          |
      | 2        | ESPN API         | 8s          |
      | 3        | Yahoo Sports API | 10s         |
      | 4        | Local Cache      | 10ms        |
    When SportsData.io fails
    Then the system tries ESPN API
    When ESPN API also fails
    Then the system tries Yahoo Sports API
    When Yahoo Sports API also fails
    Then the system returns cached data
    And logs entire fallback chain execution

  @fallback @graceful-degradation
  Scenario: Degrade gracefully when all APIs fail
    Given both SportsData.io and ESPN APIs are unavailable
    And cache is empty or expired beyond acceptable age
    When the system attempts to fetch live stats
    Then the system returns stale cached data with warning
    And displays prominent banner "Live stats temporarily unavailable"
    And shows last updated timestamp
    And suggests refreshing page in 5 minutes
    And logs critical alert
    And triggers PagerDuty incident

  @fallback @partial
  Scenario: Serve partial data when possible
    Given Player stats API is unavailable
    But Schedule API is working
    When a user views their dashboard
    Then the schedule is displayed normally
    And player stats show cached values with stale indicator
    And partial degradation is communicated to user
    And user sees mostly functional page
    And missing sections are clearly marked

  @fallback @validation
  Scenario: Validate fallback data before serving
    Given fallback cache contains player stats
    When the system retrieves fallback data
    Then the data is validated for completeness
    And required fields (playerId, stats, gameId) are present
    And data types are correct
    And if validation fails, deeper fallback is tried
    And invalid cached data is purged

  @fallback @circuit-breaker
  Scenario: Apply circuit breaker to fallback APIs
    Given ESPN API is the fallback for SportsData.io
    And ESPN API starts experiencing failures
    When ESPN API circuit breaker opens
    Then the system proceeds to next fallback tier
    And does not flood failing ESPN API
    And each fallback has independent circuit breaker

  # ============================================================================
  # RETRY STRATEGIES
  # ============================================================================

  @retry @exponential-backoff
  Scenario: Implement exponential backoff on retries
    Given an API request fails with HTTP 500
    When the system retries
    Then retry delays follow exponential backoff:
      | Retry | Base Delay | Actual Delay |
      | 1     | 2s         | 2s           |
      | 2     | 4s         | 4s           |
      | 3     | 8s         | 8s           |
      | 4     | 16s        | 16s          |
      | 5     | 32s        | 32s (capped) |
    And maximum retry delay is capped at 32 seconds

  @retry @jitter
  Scenario: Add jitter to prevent thundering herd
    Given 100 requests fail simultaneously
    And base retry delay is 2 seconds
    When all attempt to retry
    Then jitter (random 0-1000ms) is added to each retry
    And requests are spread over 2.0-3.0 seconds window
    And prevents overwhelming API with synchronized retries
    And uses decorrelated jitter algorithm

  @retry @decorrelated-jitter
  Scenario: Apply decorrelated jitter for better distribution
    Given the system uses decorrelated jitter algorithm
    And minimum delay is 1 second
    And maximum delay is 32 seconds
    When calculating retry delay
    Then delay = min(maxDelay, random(minDelay, previousDelay * 3))
    And delays are unpredictable but bounded
    And provides better distribution than simple jitter

  @retry @budget
  Scenario: Enforce retry budget to limit total retries
    Given the system has a retry budget of 10% of requests
    And 1000 requests are made per minute
    And retry budget allows 100 retries per minute
    When 80 retries have been used in the current minute
    And 30 more requests need retrying
    Then only 20 of the 30 requests are retried
    And remaining 10 are rejected immediately
    And prevents retry storms

  @retry @limits
  Scenario: Limit maximum retry attempts per request
    Given an API request is retrying
    And maximum retries is 5
    When 5 retries have been attempted
    And all have failed
    Then the system stops retrying
    And returns error "MAX_RETRIES_EXCEEDED"
    And activates fallback mechanism
    And logs failure with all retry attempts

  @retry @non-retryable
  Scenario: Skip retries for non-retryable errors
    Given a request returns HTTP 400 Bad Request
    When the system processes the error
    Then the error is classified as non-retryable:
      | HTTP Status | Retryable |
      | 400         | No        |
      | 401         | No        |
      | 403         | No        |
      | 404         | No        |
      | 422         | No        |
      | 429         | Special   |
      | 500         | Yes       |
      | 502         | Yes       |
      | 503         | Yes       |
      | 504         | Yes       |
    And no retries are attempted for non-retryable errors

  @retry @idempotency
  Scenario: Ensure safe retries with idempotency
    Given a GET request to fetch player stats
    When the request is retried after timeout
    Then the retry is safe (idempotent)
    And multiple requests produce same result
    And no side effects occur
    And server handles duplicate requests gracefully

  @retry @idempotency-key
  Scenario: Add idempotency key to non-idempotent requests
    Given a POST request to submit a player selection
    When the request may need retry
    Then an idempotency key is included in header
    And key format is "X-Idempotency-Key: {userId}:{timestamp}:{hash}"
    And server detects duplicate requests
    And returns cached response for duplicates
    And prevents double-processing

  # ============================================================================
  # BULKHEAD PATTERN
  # ============================================================================

  @bulkhead @endpoint-isolation
  Scenario: Isolate failures per endpoint with bulkhead pattern
    Given the system calls multiple SportsData.io endpoints
    And each endpoint has its own circuit breaker
    When /PlayerGameStatsByWeek fails repeatedly
    Then only that endpoint's circuit breaker opens
    And other endpoints (/News, /Schedule) remain functional
    And failures are isolated per endpoint
    And prevents cascading failures

  @bulkhead @thread-pool
  Scenario: Allocate separate thread pools per API
    Given the system uses thread pools for API calls
    Then thread pools are allocated:
      | Pool Name         | Core Threads | Max Threads | Queue Size |
      | SportsData.io API | 10           | 20          | 100        |
      | ESPN API          | 5            | 10          | 50         |
      | Database          | 15           | 30          | 200        |
      | Cache             | 5            | 10          | 50         |
    And thread pool exhaustion in one doesn't affect others
    And prevents resource starvation

  @bulkhead @semaphore
  Scenario: Use semaphore-based bulkhead for lightweight isolation
    Given the system uses semaphore bulkhead
    And maximum concurrent requests to SportsData.io is 50
    When 50 requests are in flight
    And request #51 arrives
    Then request #51 is rejected immediately
    And returns error "BULKHEAD_FULL"
    And does not wait in queue
    And protects downstream service

  @bulkhead @queue
  Scenario: Use queue-based bulkhead with bounded queue
    Given the system uses queue-based bulkhead
    And queue size is 100
    And worker pool size is 20
    When queue is full (100 pending requests)
    And new request arrives
    Then new request is rejected
    And returns error "QUEUE_FULL"
    And queued requests are processed in order

  @bulkhead @priority-queue
  Scenario: Implement priority-based bulkhead queue
    Given the bulkhead has priority queue
    And queue slots are allocated:
      | Priority | Percentage | Description      |
      | High     | 50%        | Live stats       |
      | Medium   | 30%        | User requests    |
      | Low      | 20%        | Background tasks |
    When low-priority queue is full
    Then high-priority requests still accepted
    And critical functionality preserved

  @bulkhead @dynamic-sizing
  Scenario: Dynamically resize bulkhead based on load
    Given the bulkhead supports dynamic sizing
    And current API response time is 500ms
    When API response time degrades to 2000ms
    Then bulkhead size is reduced by 50%
    And reduces concurrent requests
    And prevents overwhelming slow service
    And logs sizing adjustment

  # ============================================================================
  # HEALTH CHECKS
  # ============================================================================

  @health-check @periodic
  Scenario: Perform periodic API health checks
    Given the system monitors SportsData.io health
    And health check interval is 30 seconds
    When the health check runs
    Then a lightweight request is made (GET /health or HEAD /)
    And response time is measured
    And success/failure is recorded
    And health status is updated in registry

  @health-check @unhealthy
  Scenario: Declare API unhealthy after consecutive failures
    Given health checks are running
    And consecutive failure threshold is 3
    When 3 consecutive health checks fail
    Then the API is declared unhealthy
    And proactive fallback is activated
    And circuit breaker preemptively opens
    And ops team is alerted via PagerDuty
    And dashboard shows unhealthy status

  @health-check @recovery
  Scenario: Declare API healthy after recovery
    Given the API was declared unhealthy
    And consecutive success threshold is 3
    When 3 consecutive health checks succeed
    Then the API is declared healthy
    And fallback is deactivated gradually
    And circuit breaker is reset to CLOSED
    And normal operation resumes
    And recovery event is logged

  @health-check @deep
  Scenario: Perform deep health check with dependency verification
    Given the system performs deep health checks
    When deep health check runs
    Then it verifies:
      | Component          | Check                     |
      | SportsData.io API  | GET /v3/nfl/scores/json   |
      | ESPN API           | GET /v3/sports/football   |
      | MongoDB            | ping command              |
      | Redis Cache        | PING command              |
    And all components must pass for healthy status
    And partial failures trigger degraded status

  @health-check @circuit-integration
  Scenario: Integrate health check with circuit breaker
    Given health check is integrated with circuit breaker
    When health check detects API unhealthy
    Then circuit breaker is proactively opened
    And prevents user requests from hitting unhealthy API
    When health check detects recovery
    Then circuit breaker transitions to HALF_OPEN
    And allows gradual traffic restoration

  # ============================================================================
  # GRACEFUL DEGRADATION
  # ============================================================================

  @graceful-degradation @feature-flags
  Scenario: Disable non-critical features on partial failure
    Given the News API is unavailable
    But Player Stats API is working
    When the system detects News API failure
    Then the news feed section is hidden via feature flag
    And core fantasy scoring continues to work
    And users see "News temporarily unavailable" message
    And essential features remain operational

  @graceful-degradation @reduced-freshness
  Scenario: Reduce data freshness requirements under load
    Given real-time stats API is struggling
    And response times exceed SLO of 500ms
    When P99 response time reaches 3 seconds
    Then polling frequency is reduced from 30s to 120s
    And reduces load on struggling API
    And cache TTL is extended
    And users see "Updates delayed" indicator
    And still provides reasonably fresh data

  @graceful-degradation @read-only
  Scenario: Switch to read-only mode during write failures
    Given the database is experiencing write issues
    But reads are still working
    When write operations fail consistently
    Then the system switches to read-only mode
    And users can view data but not modify
    And clear message shows "Temporary read-only mode"
    And critical writes are queued for later

  @graceful-degradation @simplified-response
  Scenario: Return simplified responses under load
    Given the system is under extreme load
    And response time SLO is being breached
    When load exceeds 150% of capacity
    Then responses are simplified:
      | Normal Response      | Degraded Response     |
      | Full player details  | Basic stats only      |
      | All weeks history    | Current week only     |
      | All scoring details  | Total score only      |
    And reduces compute and bandwidth
    And maintains core functionality

  # ============================================================================
  # ERROR RESPONSE STANDARDS
  # ============================================================================

  @error-response @format
  Scenario: Return consistent error response format
    Given any error occurs in the system
    When the error response is generated
    Then the response follows RFC 7807 Problem Details format:
      | Field          | Example Value                    |
      | type           | /errors/api-timeout              |
      | title          | API Request Timeout              |
      | status         | 504                              |
      | detail         | SportsData.io request timed out  |
      | instance       | /api/v1/players/12345/stats      |
      | timestamp      | 2024-12-15T15:32:10.123Z         |
      | requestId      | req-abc123-def456                |
      | retryable      | true                             |
      | retryAfter     | 30                               |
    And errors are machine-readable
    And clients can parse consistently

  @error-response @debugging
  Scenario: Include helpful error details for debugging
    Given an API error occurs
    When the error is logged internally
    Then details include:
      | Field                 | Description                    |
      | API endpoint          | /v3/nfl/stats/PlayerGameStats  |
      | HTTP status code      | 503                            |
      | Response body         | {"error": "overloaded"}        |
      | Request headers       | Authorization, User-Agent      |
      | Request duration      | 5432ms                         |
      | Circuit breaker state | HALF_OPEN                      |
      | Retry attempt         | 2 of 5                         |
      | Correlation ID        | corr-xyz789                    |
    And enables rapid debugging
    And sensitive data is redacted

  # ============================================================================
  # MONITORING AND ALERTING
  # ============================================================================

  @monitoring @circuit-breaker-alerts
  Scenario: Alert on circuit breaker state change to OPEN
    Given the circuit breaker opens
    When the state changes from CLOSED to OPEN
    Then a PagerDuty alert is triggered
    And Slack notification is sent to #nfl-api-alerts
    And alert includes:
      | Field              | Value                    |
      | API affected       | SportsData.io            |
      | Endpoint           | /PlayerGameStatsByWeek   |
      | Failure count      | 5                        |
      | Failure rate       | 75%                      |
      | Last error         | HTTP 500                 |
      | Time opened        | 2024-12-15T15:32:10Z     |
      | Fallback active    | ESPN API                 |
    And runbook link is included

  @monitoring @error-rate
  Scenario: Alert on sustained high error rate
    Given the system tracks error rates per endpoint
    And alert threshold is 10% error rate over 5 minutes
    When error rate exceeds 10% for 5 consecutive minutes
    Then a high error rate alert is triggered
    And ops team is notified
    And system may preemptively activate fallback
    And prevents widespread user impact

  @monitoring @latency
  Scenario: Alert on latency SLO breach
    Given P99 latency SLO is 2 seconds
    When P99 latency exceeds 2 seconds for 3 minutes
    Then a latency alert is triggered
    And alert severity is based on breach magnitude:
      | P99 Latency | Severity |
      | 2-3 seconds | Warning  |
      | 3-5 seconds | High     |
      | 5+ seconds  | Critical |
    And suggests potential remediation actions

  @monitoring @dashboard
  Scenario: Display resilience metrics on dashboard
    Given ops team views monitoring dashboard
    Then resilience metrics are displayed:
      | Metric                  | Current Value  | Trend      |
      | Circuit Breaker State   | CLOSED         | Stable     |
      | Failure Rate (5m)       | 2.3%           | Decreasing |
      | Success Rate (5m)       | 97.7%          | Increasing |
      | Average Response Time   | 245ms          | Stable     |
      | P50 Response Time       | 180ms          | Stable     |
      | P95 Response Time       | 450ms          | Stable     |
      | P99 Response Time       | 1.2s           | Stable     |
      | Fallback Activations    | 3 (last 24h)   | Decreasing |
      | API Health              | Healthy        | Stable     |
      | Retry Rate              | 1.5%           | Stable     |
      | Bulkhead Utilization    | 45%            | Stable     |
    And provides visibility into system health
    And trends show 24-hour history

  @monitoring @distributed-tracing
  Scenario: Include resilience events in distributed traces
    Given distributed tracing is enabled (OpenTelemetry)
    When a request experiences resilience events
    Then the trace includes spans for:
      | Span Name                | Attributes                    |
      | circuit_breaker.check    | state=CLOSED                  |
      | retry.attempt            | attempt=2, delay=4s           |
      | fallback.activation      | source=ESPN_API               |
      | bulkhead.acquire         | permits_available=15          |
    And enables end-to-end debugging
    And correlates with other service spans

  # ============================================================================
  # FALLBACK DATA QUALITY
  # ============================================================================

  @fallback-quality @metadata
  Scenario: Tag fallback data with source metadata
    Given data is served from fallback
    When the response is returned
    Then the data includes metadata headers:
      | Header            | Value               |
      | X-Data-Source     | CACHE               |
      | X-Cache-Age       | 3600                |
      | X-Data-Fresh      | false               |
      | X-Fallback-Reason | PRIMARY_UNAVAILABLE |
    And user/client knows data may be stale

  @fallback-quality @staleness-warning
  Scenario: Warn user when serving stale data
    Given cached data is 6 hours old
    And staleness threshold is 4 hours
    When the data is returned as fallback
    Then a prominent warning is included:
      "This data may be outdated. Last updated: 6 hours ago"
    And warning severity is based on age:
      | Age          | Severity | Message                           |
      | 1-4 hours    | Info     | Data may be slightly outdated     |
      | 4-12 hours   | Warning  | Data may be significantly outdated|
      | 12+ hours    | Error    | Data is stale, use with caution   |
    And user can make informed decisions

  @fallback-quality @data-reconciliation
  Scenario: Reconcile data after fallback recovery
    Given fallback was serving cached data
    And primary API recovers
    When circuit breaker closes
    Then the system fetches fresh data
    And compares with fallback data served
    And logs any significant discrepancies
    And updates all cached entries
    And ensures data consistency

  # ============================================================================
  # CHAOS ENGINEERING
  # ============================================================================

  @chaos-engineering @failure-injection
  Scenario: Simulate API failure in test environment
    Given the test environment has chaos engineering enabled
    And failure injection is configured for SportsData.io
    When a test triggers API failure simulation
    Then the API returns HTTP 500 for configured duration
    And circuit breaker behavior is verified
    And fallback mechanisms are tested
    And resilience is validated

  @chaos-engineering @latency-injection
  Scenario: Simulate slow API responses
    Given chaos engineering is enabled
    When latency injection is activated
    Then API responses are delayed by configured amount:
      | Scenario      | Delay    | Affected Requests |
      | Slow          | 2s       | 100%              |
      | Intermittent  | 5s       | 20%               |
      | Timeout       | 30s      | 10%               |
    And timeout handling is verified
    And retry logic is exercised

  @chaos-engineering @state-transitions
  Scenario: Test circuit breaker state machine
    Given the circuit breaker is CLOSED
    When chaos engineering injects 5 consecutive failures
    Then the circuit opens
    And state is verified as OPEN
    After 60 seconds, it transitions to HALF_OPEN
    When chaos injects a single success
    Then it transitions to CLOSED
    And full state machine is validated

  @chaos-engineering @partition
  Scenario: Simulate network partition
    Given chaos engineering simulates network partition
    When connectivity to SportsData.io is blocked
    Then all requests fail with connection timeout
    And circuit breaker opens
    And fallback activates
    When partition heals
    Then circuit transitions through HALF_OPEN to CLOSED
    And normal operation resumes

  # ============================================================================
  # RECOVERY PROCEDURES
  # ============================================================================

  @recovery @automatic
  Scenario: Automatically recover from transient failures
    Given SportsData.io experiences 5-minute outage
    When the circuit breaker opens
    And enters timeout period of 60 seconds
    After 60 seconds, circuit transitions to HALF_OPEN
    When test request succeeds
    Then circuit closes
    And normal operation resumes automatically
    And no manual intervention required
    And recovery is logged and metrics updated

  @recovery @gradual-restoration
  Scenario: Gradually restore traffic after recovery
    Given the circuit breaker was OPEN for 10 minutes
    And transitions to HALF_OPEN
    When test request succeeds
    Then traffic is restored gradually:
      | Time After Close | Traffic Percentage |
      | 0-30 seconds     | 25%                |
      | 30-60 seconds    | 50%                |
      | 60-90 seconds    | 75%                |
      | 90+ seconds      | 100%               |
    And prevents overwhelming recovered service
    And monitors for regressions during ramp-up

  @recovery @warmup
  Scenario: Warm up connections after recovery
    Given the circuit was OPEN and connections were idle
    When circuit closes and traffic resumes
    Then connection pool is warmed up gradually
    And first few requests have increased timeout
    And accounts for TCP slow-start
    And prevents timeout storms on cold connections

  @recovery @manual-reset
  Scenario: Manual circuit breaker reset by administrator
    Given the circuit breaker is stuck OPEN
    And the API is known to be healthy
    When an administrator manually resets the circuit breaker
    Then the state is forced to CLOSED
    And failure count is reset to 0
    And requests resume immediately
    And admin action is logged with user ID
    And audit trail is maintained

  @recovery @manual-force-open
  Scenario: Manually force circuit breaker OPEN
    Given an administrator detects impending API failure
    When the administrator manually opens the circuit
    Then the state is forced to OPEN
    And fallback is immediately activated
    And no requests are sent to API
    And action is logged with reason
    And stays open until manually closed

  # ============================================================================
  # LOAD SHEDDING
  # ============================================================================

  @load-shedding @priority
  Scenario: Shed low-priority requests under high load
    Given the API is under heavy load
    And response times exceed SLO (>2 seconds)
    When low-priority requests (player search) arrive
    Then those requests are rejected immediately
    And error "SERVICE_OVERLOADED" is returned with 503
    And high-priority requests (live stats) are processed
    And protects API from overload

  @load-shedding @adaptive
  Scenario: Implement adaptive load shedding
    Given the system monitors load indicators
    Then load shedding activates based on:
      | Indicator              | Threshold | Action              |
      | CPU utilization        | 80%       | Shed Priority 4     |
      | Memory utilization     | 85%       | Shed Priority 3-4   |
      | Response time P99      | 3 seconds | Shed Priority 2-4   |
      | Error rate             | 10%       | Shed Priority 2-4   |
      | Queue depth            | 90%       | Shed all priorities |
    And shedding is proportional to load

  @load-shedding @priority-queue
  Scenario: Implement request priority queue
    Given requests are classified by priority:
      | Priority | Request Type           | SLA         |
      | 1        | Live stats polling     | 500ms P99   |
      | 2        | Player stats fetch     | 1s P99      |
      | 3        | News feed              | 3s P99      |
      | 4        | Player search          | 5s P99      |
    When system is under load
    Then high-priority requests are processed first
    And low-priority requests may be delayed or dropped
    And ensures critical features work

  @load-shedding @client-backpressure
  Scenario: Apply backpressure to clients
    Given the system is overloaded
    When rejecting requests due to load
    Then response includes Retry-After header
    And clients are instructed to back off
    And well-behaved clients reduce request rate
    And prevents thundering herd on recovery

  # ============================================================================
  # DEPENDENCY ISOLATION
  # ============================================================================

  @dependency-isolation @containment
  Scenario: Isolate third-party API failures
    Given the system depends on SportsData.io
    When SportsData.io fails completely
    Then the failure is contained within adapter layer
    And does not crash the application
    And user-facing features degrade gracefully
    And core application remains running
    And database and authentication continue to work
    And unrelated features are unaffected

  @dependency-isolation @cascading-prevention
  Scenario: Prevent cascading failures across services
    Given Service A depends on Service B
    And Service B depends on SportsData.io
    When SportsData.io fails
    Then Service B handles the failure with fallback
    And does not propagate failure to Service A
    And each layer has independent circuit breaker
    And failures are contained at each level
    And timeout at each layer prevents blocking

  @dependency-isolation @async-boundaries
  Scenario: Use async boundaries for dependency isolation
    Given external API calls are made asynchronously
    When an API call hangs indefinitely
    Then the calling thread is not blocked
    And timeout is enforced at async boundary
    And other requests continue processing
    And thread pool is not exhausted

  # ============================================================================
  # RESOURCE LIMITS
  # ============================================================================

  @resource-limits @connection-pool
  Scenario: Handle connection pool exhaustion gracefully
    Given connection pool max size is 50
    And all 50 connections are in use
    When a new request arrives
    Then request waits in queue for connection (max 5 seconds)
    And if timeout, returns error "CONNECTION_POOL_EXHAUSTED"
    And does not create unbounded connections
    And logs connection pool pressure

  @resource-limits @memory-pressure
  Scenario: Handle high memory pressure gracefully
    Given the system monitors heap memory usage
    When heap usage exceeds 85%
    Then non-essential caching is reduced
    And request queue size is reduced
    And large response buffering is limited
    And garbage collection is triggered proactively
    And alert is sent for memory pressure

  @resource-limits @file-descriptors
  Scenario: Handle file descriptor exhaustion
    Given the system monitors file descriptor usage
    When file descriptors exceed 80% of limit
    Then alert is triggered
    And idle connections are aggressively closed
    And new connection rate is throttled
    And prevents "too many open files" errors

  # ============================================================================
  # DOCUMENTATION AND RUNBOOKS
  # ============================================================================

  @documentation @runbook
  Scenario: Provide runbook for circuit breaker open
    Given the circuit breaker opens
    When ops team is alerted
    Then runbook is referenced with steps:
      | Step | Action                                    |
      | 1    | Check SportsData.io status page           |
      | 2    | Verify API credentials in secrets manager |
      | 3    | Review error logs for root cause          |
      | 4    | Check rate limiting dashboard             |
      | 5    | Verify network connectivity               |
      | 6    | Check DNS resolution                      |
      | 7    | Manually reset circuit if API healthy     |
      | 8    | Escalate if issue persists >15 minutes    |
    And enables rapid incident resolution
    And includes rollback procedures

  @documentation @postmortem
  Scenario: Generate incident data for postmortem
    Given a resilience incident occurred
    When generating postmortem data
    Then the system provides:
      | Data                        | Source                    |
      | Timeline of state changes   | Circuit breaker logs      |
      | Error distribution          | Monitoring metrics        |
      | Affected requests count     | Request logs              |
      | Fallback effectiveness      | Fallback metrics          |
      | User impact estimate        | Error rate during incident|
      | Time to recovery            | State change timestamps   |
    And facilitates thorough incident review
