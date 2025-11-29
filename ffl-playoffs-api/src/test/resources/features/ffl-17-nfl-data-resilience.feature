# @ref: https://github.com/nflverse/nflreadpy
# @ref: docs/NFL_DATA_INTEGRATION_PROPOSAL.md
Feature: NFL Data Integration Resilience (Circuit Breaker, Error Handling, Fallback)
  As a system
  I want robust error handling and circuit breaker patterns
  So that the application remains available even when nflverse data is unavailable

  Background:
    Given the system integrates with nflreadpy (nflverse) for NFL data
    And the system has fallback to cached data
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
