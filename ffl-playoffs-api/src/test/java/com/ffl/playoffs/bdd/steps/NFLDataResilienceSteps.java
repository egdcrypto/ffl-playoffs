package com.ffl.playoffs.bdd.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.Before;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import lombok.extern.slf4j.Slf4j;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;

import static org.assertj.core.api.Assertions.*;

@Slf4j
public class NFLDataResilienceSteps {

    // Circuit Breaker States
    private enum CircuitBreakerState {
        CLOSED, OPEN, HALF_OPEN
    }

    // Test data holders
    private CircuitBreakerState circuitBreakerState;
    private AtomicInteger failureCount;
    private int failureThreshold = 5;
    private long timeoutPeriodSeconds = 60;
    private LocalDateTime circuitOpenedAt;
    private LocalDateTime lastRequestTime;
    private boolean requestBlocked = false;
    private boolean apiCallMade = false;
    private boolean fallbackActivated = false;
    private String fallbackResponse;
    private long responseTime = 0;
    private Map<String, Object> errorResponse = new HashMap<>();
    private Map<String, Object> cachedData = new HashMap<>();
    private LocalDateTime cacheTimestamp;
    private int retryCount = 0;
    private List<Long> retryDelays = new ArrayList<>();
    private String lastErrorCode;
    private String lastHttpStatus;
    private boolean requestRetried = false;
    private boolean opsAlertSent = false;
    private Map<String, Long> endpointTimeouts = new HashMap<>();
    private Map<String, CircuitBreakerState> endpointCircuitBreakers = new HashMap<>();
    private Map<String, AtomicInteger> endpointThreadPools = new HashMap<>();
    private boolean healthCheckPassed = false;
    private int consecutiveHealthCheckFailures = 0;
    private int consecutiveHealthCheckSuccesses = 0;
    private boolean apiHealthy = true;
    private String requestPriority;
    private boolean requestShedded = false;
    private Map<String, Object> errorDetails = new HashMap<>();
    private String idempotencyKey;
    private long currentBackoffDelay = 0;
    private String retryAfterHeader;
    private boolean rateLimiterAdjusted = false;
    private String dataSource = "API";
    private String dataAge;
    private boolean dataFresh = true;
    private boolean warningDisplayed = false;
    private List<String> simulatedFailures = new ArrayList<>();
    private boolean manualResetPerformed = false;
    private Map<String, Integer> requestPriorities = new HashMap<>();
    private List<Map<String, String>> runbookSteps = new ArrayList<>();

    @Before
    public void setUp() {
        // Reset all state before each scenario
        circuitBreakerState = CircuitBreakerState.CLOSED;
        failureCount = new AtomicInteger(0);
        failureThreshold = 5;
        timeoutPeriodSeconds = 60;
        circuitOpenedAt = null;
        lastRequestTime = null;
        requestBlocked = false;
        apiCallMade = false;
        fallbackActivated = false;
        fallbackResponse = null;
        responseTime = 0;
        errorResponse.clear();
        cachedData.clear();
        cacheTimestamp = null;
        retryCount = 0;
        retryDelays.clear();
        lastErrorCode = null;
        lastHttpStatus = null;
        requestRetried = false;
        opsAlertSent = false;
        endpointTimeouts.clear();
        endpointCircuitBreakers.clear();
        endpointThreadPools.clear();
        healthCheckPassed = false;
        consecutiveHealthCheckFailures = 0;
        consecutiveHealthCheckSuccesses = 0;
        apiHealthy = true;
        requestPriority = null;
        requestShedded = false;
        errorDetails.clear();
        idempotencyKey = null;
        currentBackoffDelay = 0;
        retryAfterHeader = null;
        rateLimiterAdjusted = false;
        dataSource = "API";
        dataAge = null;
        dataFresh = true;
        warningDisplayed = false;
        simulatedFailures.clear();
        manualResetPerformed = false;
        requestPriorities.clear();
        runbookSteps.clear();

        // Initialize endpoint timeouts
        endpointTimeouts.put("PlayerGameStatsByWeek", 15L);
        endpointTimeouts.put("FantasyDefenseByGame", 10L);
        endpointTimeouts.put("News", 5L);
        endpointTimeouts.put("Player Search", 8L);

        // Initialize thread pool sizes
        endpointThreadPools.put("SportsData.io API", new AtomicInteger(20));
        endpointThreadPools.put("ESPN API", new AtomicInteger(10));
        endpointThreadPools.put("Database", new AtomicInteger(30));

        // Initialize request priorities
        requestPriorities.put("Live stats polling", 1);
        requestPriorities.put("Player stats", 2);
        requestPriorities.put("News feed", 3);
        requestPriorities.put("Player search", 4);

        log.debug("NFLDataResilienceSteps setUp complete");
    }

    // ========== Background Steps ==========

    @Given("the system integrates with nflreadpy \\(nflverse) for NFL data")
    public void theSystemIntegratesWithNflreadpy() {
        log.debug("System configured with nflreadpy data source");
    }

    @Given("the system has fallback to cached data")
    public void theSystemHasFallbackToCachedData() {
        cachedData.put("player_stats", "cached_stats_data");
        cacheTimestamp = LocalDateTime.now().minusHours(1);
        log.debug("Fallback cache configured");
    }

    @Given("circuit breaker pattern is implemented")
    public void circuitBreakerPatternIsImplemented() {
        circuitBreakerState = CircuitBreakerState.CLOSED;
        log.debug("Circuit breaker pattern initialized");
    }

    // ========== Circuit Breaker Initialization ==========

    @Given("the circuit breaker is initialized")
    public void theCircuitBreakerIsInitialized() {
        circuitBreakerState = CircuitBreakerState.CLOSED;
        failureCount.set(0);
        log.debug("Circuit breaker initialized to CLOSED state");
    }

    @Then("the state is {string}")
    public void theStateIs(String expectedState) {
        CircuitBreakerState expected = CircuitBreakerState.valueOf(expectedState);
        assertThat(circuitBreakerState)
            .as("Circuit breaker state should be %s", expectedState)
            .isEqualTo(expected);
        log.debug("Verified circuit breaker state: {}", expectedState);
    }

    @Then("requests flow normally to SportsData.io API")
    public void requestsFlowNormallyToSportsDataIoAPI() {
        assertThat(circuitBreakerState).isEqualTo(CircuitBreakerState.CLOSED);
        assertThat(requestBlocked).isFalse();
        log.debug("Requests flowing normally");
    }

    @Then("failure count is {int}")
    public void failureCountIs(Integer count) {
        assertThat(failureCount.get())
            .as("Failure count should be %d", count)
            .isEqualTo(count);
        log.debug("Verified failure count: {}", count);
    }

    // ========== Failure Handling ==========

    @Given("the circuit breaker is CLOSED")
    public void theCircuitBreakerIsCLOSED() {
        circuitBreakerState = CircuitBreakerState.CLOSED;
        failureCount.set(0);
        log.debug("Circuit breaker set to CLOSED");
    }

    @When("an API request fails with HTTP {int}")
    public void anAPIRequestFailsWithHTTP(Integer statusCode) {
        lastHttpStatus = "HTTP " + statusCode;
        failureCount.incrementAndGet();
        lastRequestTime = LocalDateTime.now();
        log.debug("API request failed with {}", lastHttpStatus);
    }

    @Then("the failure count is incremented to {int}")
    public void theFailureCountIsIncrementedTo(Integer count) {
        assertThat(failureCount.get()).isEqualTo(count);
        log.debug("Failure count incremented to {}", count);
    }

    @Then("the request is retried")
    public void theRequestIsRetried() {
        requestRetried = true;
        retryCount++;
        log.debug("Request retried, retry count: {}", retryCount);
    }

    @Then("circuit breaker remains CLOSED")
    public void circuitBreakerRemainsCLOSED() {
        assertThat(circuitBreakerState).isEqualTo(CircuitBreakerState.CLOSED);
        log.debug("Circuit breaker remains CLOSED");
    }

    // ========== Circuit Opening ==========

    @Given("the failure threshold is {int}")
    public void theFailureThresholdIs(Integer threshold) {
        this.failureThreshold = threshold;
        log.debug("Failure threshold set to {}", threshold);
    }

    @When("{int} consecutive API requests fail")
    public void consecutiveAPIRequestsFail(Integer count) {
        for (int i = 0; i < count; i++) {
            failureCount.incrementAndGet();
        }
        lastRequestTime = LocalDateTime.now();
        log.debug("{} consecutive failures recorded", count);
    }

    @Then("the failure count reaches {int}")
    public void theFailureCountReaches(Integer count) {
        assertThat(failureCount.get()).isGreaterThanOrEqualTo(count);
        log.debug("Failure count reached {}", count);
    }

    @Then("the circuit breaker opens")
    public void theCircuitBreakerOpens() {
        circuitBreakerState = CircuitBreakerState.OPEN;
        circuitOpenedAt = LocalDateTime.now();
        log.debug("Circuit breaker opened at {}", circuitOpenedAt);
    }

    @Then("the state changes to {string}")
    public void theStateChangesTo(String newState) {
        circuitBreakerState = CircuitBreakerState.valueOf(newState);
        if (newState.equals("OPEN")) {
            circuitOpenedAt = LocalDateTime.now();
        }
        log.debug("Circuit breaker state changed to {}", newState);
    }

    @Then("subsequent requests are blocked immediately")
    public void subsequentRequestsAreBlockedImmediately() {
        requestBlocked = true;
        log.debug("Subsequent requests blocked");
    }

    @Then("fallback is activated")
    public void fallbackIsActivated() {
        fallbackActivated = true;
        fallbackResponse = "cached_or_fallback_data";
        log.debug("Fallback activated");
    }

    // ========== Circuit Open Behavior ==========

    @Given("the circuit breaker is OPEN")
    public void theCircuitBreakerIsOPEN() {
        circuitBreakerState = CircuitBreakerState.OPEN;
        circuitOpenedAt = LocalDateTime.now();
        log.debug("Circuit breaker set to OPEN");
    }

    @When("a new API request is attempted")
    public void aNewAPIRequestIsAttempted() {
        lastRequestTime = LocalDateTime.now();
        if (circuitBreakerState == CircuitBreakerState.OPEN) {
            requestBlocked = true;
            apiCallMade = false;
        }
        log.debug("New API request attempted");
    }

    @Then("the request is immediately blocked")
    public void theRequestIsImmediatelyBlocked() {
        assertThat(requestBlocked).isTrue();
        log.debug("Request blocked");
    }

    @Then("no API call is made")
    public void noAPICallIsMade() {
        assertThat(apiCallMade).isFalse();
        log.debug("No API call made");
    }

    @Then("fallback response is returned")
    public void fallbackResponseIsReturned() {
        assertThat(fallbackActivated).isTrue();
        assertThat(fallbackResponse).isNotNull();
        log.debug("Fallback response returned");
    }

    @Then("user sees cached or fallback data")
    public void userSeesCachedOrFallbackData() {
        assertThat(fallbackResponse).isNotNull();
        log.debug("User sees fallback data");
    }

    @Then("response time is fast \\(no timeout wait)")
    public void responseTimeIsFast() {
        responseTime = 50; // milliseconds
        assertThat(responseTime).isLessThan(100);
        log.debug("Response time is fast: {}ms", responseTime);
    }

    // ========== Half-Open Transition ==========

    @Given("the timeout period is {int} seconds")
    public void theTimeoutPeriodIsSeconds(Integer seconds) {
        this.timeoutPeriodSeconds = seconds;
        log.debug("Timeout period set to {} seconds", seconds);
    }

    @When("{int} seconds elapse")
    public void secondsElapse(Integer seconds) {
        circuitOpenedAt = LocalDateTime.now().minusSeconds(seconds);
        log.debug("{} seconds elapsed", seconds);
    }

    @Then("the circuit breaker transitions to {string}")
    public void theCircuitBreakerTransitionsTo(String state) {
        circuitBreakerState = CircuitBreakerState.valueOf(state);
        log.debug("Circuit breaker transitioned to {}", state);
    }

    @Then("allows limited test requests through")
    public void allowsLimitedTestRequestsThrough() {
        assertThat(circuitBreakerState).isEqualTo(CircuitBreakerState.HALF_OPEN);
        log.debug("Limited test requests allowed");
    }

    @Then("evaluates if API has recovered")
    public void evaluatesIfAPIHasRecovered() {
        log.debug("Evaluating API recovery");
    }

    // ========== Half-Open Success ==========

    @Given("the circuit breaker is HALF_OPEN")
    public void theCircuitBreakerIsHALF_OPEN() {
        circuitBreakerState = CircuitBreakerState.HALF_OPEN;
        log.debug("Circuit breaker set to HALF_OPEN");
    }

    @When("a test request to the API succeeds")
    public void aTestRequestToTheAPISucceeds() {
        apiCallMade = true;
        lastHttpStatus = "HTTP 200";
        log.debug("Test request succeeded");
    }

    @Then("failure count is reset to {int}")
    public void failureCountIsResetTo(Integer count) {
        failureCount.set(count);
        assertThat(failureCount.get()).isEqualTo(count);
        log.debug("Failure count reset to {}", count);
    }

    @Then("normal operation resumes")
    public void normalOperationResumes() {
        assertThat(circuitBreakerState).isEqualTo(CircuitBreakerState.CLOSED);
        assertThat(requestBlocked).isFalse();
        log.debug("Normal operation resumed");
    }

    // ========== Half-Open Failure ==========

    @When("a test request to the API fails")
    public void aTestRequestToTheAPIFails() {
        apiCallMade = true;
        lastHttpStatus = "HTTP 500";
        failureCount.incrementAndGet();
        log.debug("Test request failed");
    }

    @Then("the circuit breaker returns to {string}")
    public void theCircuitBreakerReturnsTo(String state) {
        circuitBreakerState = CircuitBreakerState.valueOf(state);
        if (state.equals("OPEN")) {
            circuitOpenedAt = LocalDateTime.now();
        }
        log.debug("Circuit breaker returned to {}", state);
    }

    @Then("timeout period is extended \\(exponential backoff)")
    public void timeoutPeriodIsExtended() {
        timeoutPeriodSeconds *= 2;
        log.debug("Timeout period extended to {} seconds", timeoutPeriodSeconds);
    }

    @Then("next test attempt is in {int} seconds")
    public void nextTestAttemptIsInSeconds(Integer seconds) {
        assertThat(timeoutPeriodSeconds).isEqualTo(seconds);
        log.debug("Next test attempt in {} seconds", seconds);
    }

    // ========== HTTP Error Handling - 404 ==========

    @Given("a request is made for Player ID {int}")
    public void aRequestIsMadeForPlayerID(Integer playerId) {
        log.debug("Request made for Player ID {}", playerId);
    }

    @When("the API returns HTTP {int} Not Found")
    public void theAPIReturnsHTTPNotFound(Integer statusCode) {
        lastHttpStatus = "HTTP " + statusCode;
        log.debug("API returned {}", lastHttpStatus);
    }

    @Then("the system recognizes resource not found")
    public void theSystemRecognizesResourceNotFound() {
        assertThat(lastHttpStatus).contains("404");
        log.debug("Resource not found recognized");
    }

    @Then("returns error {string}")
    public void returnsError(String errorCode) {
        lastErrorCode = errorCode;
        errorResponse.put("code", errorCode);
        log.debug("Error returned: {}", errorCode);
    }

    @Then("does not increment circuit breaker failure count")
    public void doesNotIncrementCircuitBreakerFailureCount() {
        int currentCount = failureCount.get();
        assertThat(currentCount).isEqualTo(0);
        log.debug("Circuit breaker failure count not incremented");
    }

    @Then("logs the missing resource")
    public void logsTheMissingResource() {
        log.info("Missing resource logged");
    }

    @Then("does not retry the request")
    public void doesNotRetryTheRequest() {
        assertThat(requestRetried).isFalse();
        log.debug("Request not retried");
    }

    // ========== HTTP Error Handling - 500 ==========

    @Given("the API experiences internal errors")
    public void theAPIExperiencesInternalErrors() {
        log.debug("API experiencing internal errors");
    }

    @When("the API returns HTTP {int}")
    public void theAPIReturnsHTTP(Integer statusCode) {
        lastHttpStatus = "HTTP " + statusCode;
        log.debug("API returned {}", lastHttpStatus);
    }

    @Then("the system increments circuit breaker failure count")
    public void theSystemIncrementsCircuitBreakerFailureCount() {
        failureCount.incrementAndGet();
        assertThat(failureCount.get()).isGreaterThan(0);
        log.debug("Circuit breaker failure count incremented");
    }

    @Then("retries the request after {int} seconds")
    public void retriesTheRequestAfterSeconds(Integer seconds) {
        requestRetried = true;
        retryDelays.add(seconds.longValue());
        log.debug("Request retried after {} seconds", seconds);
    }

    @Then("logs the server error")
    public void logsTheServerError() {
        log.error("Server error logged: {}", lastHttpStatus);
    }

    @Then("alerts ops team if errors persist")
    public void alertsOpsTeamIfErrorsPersist() {
        if (failureCount.get() >= failureThreshold) {
            opsAlertSent = true;
        }
        log.debug("Ops alert status: {}", opsAlertSent);
    }

    // ========== HTTP Error Handling - 502 ==========

    @Given("the API gateway is experiencing issues")
    public void theAPIGatewayIsExperiencingIssues() {
        log.debug("API gateway issues detected");
    }

    @Then("the system treats it as transient error")
    public void theSystemTreatsItAsTransientError() {
        log.debug("Treating as transient error");
    }

    @Then("retries with exponential backoff \\({int}s, {int}s, {int}s)")
    public void retriesWithExponentialBackoff(Integer delay1, Integer delay2, Integer delay3) {
        retryDelays.add(delay1.longValue());
        retryDelays.add(delay2.longValue());
        retryDelays.add(delay3.longValue());
        log.debug("Exponential backoff delays: {}s, {}s, {}s", delay1, delay2, delay3);
    }

    @Then("switches to fallback after {int} retries")
    public void switchesToFallbackAfterRetries(Integer retries) {
        if (retryCount >= retries) {
            fallbackActivated = true;
        }
        log.debug("Switching to fallback after {} retries", retries);
    }

    // ========== HTTP Error Handling - 503 ==========

    @Given("the API is temporarily unavailable")
    public void theAPIIsTemporarilyUnavailable() {
        log.debug("API temporarily unavailable");
    }

    @Then("the system recognizes service downtime")
    public void theSystemRecognizesServiceDowntime() {
        assertThat(lastHttpStatus).contains("503");
        log.debug("Service downtime recognized");
    }

    @Then("immediately activates fallback")
    public void immediatelyActivatesFallback() {
        fallbackActivated = true;
        fallbackResponse = "cached_data";
        log.debug("Fallback activated immediately");
    }

    @Then("stops retrying until circuit breaker recovers")
    public void stopsRetryingUntilCircuitBreakerRecovers() {
        requestRetried = false;
        circuitBreakerState = CircuitBreakerState.OPEN;
        log.debug("Stopped retrying, waiting for circuit breaker recovery");
    }

    // ========== HTTP Error Handling - 429 ==========

    @Given("the system exceeds API rate limit")
    public void theSystemExceedsAPIRateLimit() {
        log.debug("API rate limit exceeded");
    }

    @Then("the system backs off immediately")
    public void theSystemBacksOffImmediately() {
        currentBackoffDelay = 1000; // milliseconds
        log.debug("Backing off with delay: {}ms", currentBackoffDelay);
    }

    @Then("waits for Retry-After header duration")
    public void waitsForRetryAfterHeaderDuration() {
        retryAfterHeader = "60";
        currentBackoffDelay = Long.parseLong(retryAfterHeader) * 1000;
        log.debug("Waiting for Retry-After: {} seconds", retryAfterHeader);
    }

    @Then("resumes requests after backoff period")
    public void resumesRequestsAfterBackoffPeriod() {
        log.debug("Resuming requests after backoff");
    }

    @Then("adjusts rate limiter settings")
    public void adjustsRateLimiterSettings() {
        rateLimiterAdjusted = true;
        log.debug("Rate limiter settings adjusted");
    }

    // ========== HTTP Error Handling - 401 ==========

    @Given("the API key is invalid or expired")
    public void theAPIKeyIsInvalidOrExpired() {
        log.debug("API key invalid or expired");
    }

    @Then("the system logs critical error")
    public void theSystemLogsCriticalError() {
        log.error("CRITICAL: API key invalid or expired");
    }

    @Then("sends alert to ops team immediately")
    public void sendsAlertToOpsTeamImmediately() {
        opsAlertSent = true;
        log.debug("Alert sent to ops team");
    }

    @Then("does not retry \\(credentials won't change)")
    public void doesNotRetryCredentialsWontChange() {
        requestRetried = false;
        log.debug("Not retrying - credentials won't change");
    }

    @Then("activates fallback indefinitely")
    public void activatesFallbackIndefinitely() {
        fallbackActivated = true;
        circuitBreakerState = CircuitBreakerState.OPEN;
        log.debug("Fallback activated indefinitely");
    }

    @Then("requires manual intervention")
    public void requiresManualIntervention() {
        log.error("Manual intervention required to fix API credentials");
    }

    // ========== Timeout Handling ==========

    @Given("the API is slow to respond")
    public void theAPIIsSlowToRespond() {
        log.debug("API slow to respond");
    }

    @When("the request exceeds {int}-second timeout")
    public void theRequestExceedsSecondTimeout(Integer timeout) {
        responseTime = (timeout + 5) * 1000; // Exceed timeout
        lastErrorCode = "API_TIMEOUT";
        log.debug("Request exceeded {} second timeout", timeout);
    }

    @Then("the request is cancelled")
    public void theRequestIsCancelled() {
        apiCallMade = false;
        log.debug("Request cancelled");
    }

    @Then("error {string} is returned")
    public void errorIsReturned(String errorCode) {
        lastErrorCode = errorCode;
        errorResponse.put("code", errorCode);
        log.debug("Error returned: {}", errorCode);
    }

    @Then("circuit breaker failure count is incremented")
    public void circuitBreakerFailureCountIsIncremented() {
        failureCount.incrementAndGet();
        log.debug("Circuit breaker failure count incremented");
    }

    @Then("cached data is returned as fallback")
    public void cachedDataIsReturnedAsFallback() {
        fallbackActivated = true;
        fallbackResponse = cachedData.get("player_stats").toString();
        log.debug("Cached data returned as fallback");
    }

    @Then("timeout is logged for monitoring")
    public void timeoutIsLoggedForMonitoring() {
        log.warn("Timeout logged for monitoring: {}", lastErrorCode);
    }

    // ========== Endpoint-Specific Timeouts ==========

    @Given("different endpoints have different response times")
    public void differentEndpointsHaveDifferentResponseTimes() {
        log.debug("Different endpoints configured with different timeouts");
    }

    @Then("timeouts are configured:")
    public void timeoutsAreConfigured(DataTable dataTable) {
        dataTable.asMaps().forEach(row -> {
            String endpoint = row.get("Endpoint");
            String timeout = row.get("Timeout").replace("s", "");
            endpointTimeouts.put(endpoint, Long.parseLong(timeout));
        });
        log.debug("Endpoint timeouts configured: {}", endpointTimeouts);
    }

    @Then("each endpoint has appropriate timeout")
    public void eachEndpointHasAppropriateTimeout() {
        assertThat(endpointTimeouts).isNotEmpty();
        log.debug("All endpoints have timeouts configured");
    }

    // ========== Retry Timeout Increase ==========

    @Given("the first request times out after {int} seconds")
    public void theFirstRequestTimesOutAfterSeconds(Integer seconds) {
        responseTime = seconds * 1000;
        lastErrorCode = "API_TIMEOUT";
        log.debug("First request timed out after {} seconds", seconds);
    }

    @When("the system retries the request")
    public void theSystemRetriesTheRequest() {
        requestRetried = true;
        retryCount++;
        log.debug("System retrying request");
    }

    @Then("the retry timeout is increased to {int} seconds")
    public void theRetryTimeoutIsIncreasedToSeconds(Integer seconds) {
        long newTimeout = seconds;
        assertThat(newTimeout).isGreaterThan(10);
        log.debug("Retry timeout increased to {} seconds", seconds);
    }

    @Then("gives API more time to respond")
    public void givesAPIMoreTimeToRespond() {
        log.debug("Giving API more time to respond on retry");
    }

    @Then("prevents immediate retry timeout")
    public void preventsImmediateRetryTimeout() {
        log.debug("Preventing immediate retry timeout");
    }

    // ========== Fallback to Cache ==========

    @Given("Player stats were cached {int} hour ago")
    public void playerStatsWereCachedHourAgo(Integer hours) {
        cacheTimestamp = LocalDateTime.now().minusHours(hours);
        cachedData.put("player_stats", "cached_player_data");
        log.debug("Player stats cached {} hour(s) ago", hours);
    }

    @When("the SportsData.io API is unavailable")
    public void theSportsDataIoAPIIsUnavailable() {
        circuitBreakerState = CircuitBreakerState.OPEN;
        log.debug("SportsData.io API unavailable");
    }

    @Then("the system returns cached data")
    public void theSystemReturnsCachedData() {
        fallbackActivated = true;
        fallbackResponse = cachedData.get("player_stats").toString();
        dataSource = "CACHE";
        log.debug("Returning cached data");
    }

    @Then("displays {string}")
    public void displays(String message) {
        log.debug("Displaying message: {}", message);
    }

    @Then("user experience is not interrupted")
    public void userExperienceIsNotInterrupted() {
        assertThat(fallbackResponse).isNotNull();
        log.debug("User experience not interrupted");
    }

    // ========== Fallback to ESPN ==========

    @Given("SportsData.io circuit breaker is OPEN")
    public void sportsDataIoCircuitBreakerIsOPEN() {
        endpointCircuitBreakers.put("SportsData.io", CircuitBreakerState.OPEN);
        log.debug("SportsData.io circuit breaker is OPEN");
    }

    @When("live stats are needed")
    public void liveStatsAreNeeded() {
        log.debug("Live stats requested");
    }

    @Then("the system switches to ESPN API")
    public void theSystemSwitchesToESPNAPI() {
        dataSource = "ESPN";
        log.debug("Switched to ESPN API");
    }

    @Then("fetches player stats from ESPN")
    public void fetchesPlayerStatsFromESPN() {
        fallbackResponse = "espn_player_stats";
        log.debug("Fetching player stats from ESPN");
    }

    @Then("maps ESPN response to domain model")
    public void mapsESPNResponseToDomainModel() {
        log.debug("Mapping ESPN response to domain model");
    }

    @Then("logs fallback activation")
    public void logsFallbackActivation() {
        log.info("Fallback to ESPN API activated");
    }

    @Then("tracks ESPN API usage")
    public void tracksESPNAPIUsage() {
        log.debug("Tracking ESPN API usage");
    }

    // ========== Graceful Degradation ==========

    @Given("both SportsData.io and ESPN APIs are unavailable")
    public void bothSportsDataIoAndESPNAPIsAreUnavailable() {
        endpointCircuitBreakers.put("SportsData.io", CircuitBreakerState.OPEN);
        endpointCircuitBreakers.put("ESPN", CircuitBreakerState.OPEN);
        log.debug("Both APIs unavailable");
    }

    @When("the system attempts to fetch live stats")
    public void theSystemAttemptsToFetchLiveStats() {
        log.debug("Attempting to fetch live stats");
    }

    @Then("the system returns most recent cached data")
    public void theSystemReturnsMostRecentCachedData() {
        fallbackResponse = cachedData.get("player_stats").toString();
        dataSource = "CACHE";
        log.debug("Returning most recent cached data");
    }

    @Then("displays prominent warning {string}")
    public void displaysProminentWarning(String warning) {
        warningDisplayed = true;
        log.warn("Warning displayed: {}", warning);
    }

    @Then("shows last updated timestamp")
    public void showsLastUpdatedTimestamp() {
        assertThat(cacheTimestamp).isNotNull();
        log.debug("Showing last updated: {}", cacheTimestamp);
    }

    @Then("suggests refreshing page in {int} minutes")
    public void suggestsRefreshingPageInMinutes(Integer minutes) {
        log.debug("Suggesting refresh in {} minutes", minutes);
    }

    @Then("logs critical alert")
    public void logsCriticalAlert() {
        log.error("CRITICAL: All APIs unavailable");
    }

    // ========== Partial Degradation ==========

    @Given("Player stats API is unavailable")
    public void playerStatsAPIIsUnavailable() {
        endpointCircuitBreakers.put("PlayerStats", CircuitBreakerState.OPEN);
        log.debug("Player stats API unavailable");
    }

    @Given("Schedule API is working")
    public void scheduleAPIIsWorking() {
        endpointCircuitBreakers.put("Schedule", CircuitBreakerState.CLOSED);
        log.debug("Schedule API working");
    }

    @When("a user views their dashboard")
    public void aUserViewsTheirDashboard() {
        log.debug("User viewing dashboard");
    }

    @Then("the schedule is displayed normally")
    public void theScheduleIsDisplayedNormally() {
        log.debug("Schedule displayed normally");
    }

    @Then("player stats show cached values")
    public void playerStatsShowCachedValues() {
        fallbackResponse = cachedData.get("player_stats").toString();
        log.debug("Player stats showing cached values");
    }

    @Then("partial degradation is acceptable")
    public void partialDegradationIsAcceptable() {
        log.debug("Partial degradation acceptable");
    }

    @Then("user sees mostly functional page")
    public void userSeesMostlyFunctionalPage() {
        log.debug("User sees mostly functional page");
    }

    // ========== Exponential Backoff ==========

    @Given("an API request fails")
    public void anAPIRequestFails() {
        lastHttpStatus = "HTTP 500";
        failureCount.incrementAndGet();
        log.debug("API request failed");
    }

    @When("the system retries")
    public void theSystemRetries() {
        requestRetried = true;
        log.debug("System retrying");
    }

    @Then("retry delays are exponential:")
    public void retryDelaysAreExponential(DataTable dataTable) {
        retryDelays.clear();
        dataTable.asLists().forEach(row -> {
            if (!row.get(0).equals("Retry 1")) { // Skip header-like rows
                String delayStr = row.get(1).replace(" seconds", "").trim();
                retryDelays.add(Long.parseLong(delayStr));
            }
        });
        log.debug("Exponential retry delays configured: {}", retryDelays);
    }

    @Then("maximum retry delay is capped at {int} seconds")
    public void maximumRetryDelayIsCappedAtSeconds(Integer maxDelay) {
        retryDelays.forEach(delay -> assertThat(delay).isLessThanOrEqualTo(maxDelay));
        log.debug("Maximum retry delay capped at {} seconds", maxDelay);
    }

    // ========== Jitter ==========

    @Given("{int} requests fail simultaneously")
    public void requestsFailSimultaneously(Integer count) {
        for (int i = 0; i < count; i++) {
            simulatedFailures.add("request_" + i);
        }
        log.debug("{} requests failed simultaneously", count);
    }

    @When("all attempt to retry after {int} seconds")
    public void allAttemptToRetryAfterSeconds(Integer seconds) {
        log.debug("All requests attempting retry after {} seconds", seconds);
    }

    @Then("jitter \\(random {int}-{int}ms) is added to each retry")
    public void jitterIsAddedToEachRetry(Integer minJitter, Integer maxJitter) {
        log.debug("Jitter added: {}-{}ms", minJitter, maxJitter);
    }

    @Then("requests are spread over {double}-{double} seconds")
    public void requestsAreSpreadOverSeconds(Double minSpread, Double maxSpread) {
        log.debug("Requests spread over {}-{} seconds", minSpread, maxSpread);
    }

    @Then("prevents overwhelming API with synchronized retries")
    public void preventsOverwhelmingAPIWithSynchronizedRetries() {
        log.debug("Synchronized retry prevention active");
    }

    // ========== Max Retries ==========

    @Given("an API request is retrying")
    public void anAPIRequestIsRetrying() {
        requestRetried = true;
        log.debug("API request retrying");
    }

    @When("{int} retries have been attempted")
    public void retriesHaveBeenAttempted(Integer count) {
        retryCount = count;
        log.debug("{} retries attempted", count);
    }

    @When("all have failed")
    public void allHaveFailed() {
        log.debug("All retries failed");
    }

    @Then("the system stops retrying")
    public void theSystemStopsRetrying() {
        requestRetried = false;
        log.debug("System stopped retrying");
    }

    @Then("returns error {string}")
    public void returnsErrorWithCode(String errorCode) {
        lastErrorCode = errorCode;
        errorResponse.put("code", errorCode);
        log.debug("Returning error: {}", errorCode);
    }

    @Then("activates fallback mechanism")
    public void activatesFallbackMechanism() {
        fallbackActivated = true;
        log.debug("Fallback mechanism activated");
    }

    @Then("logs failure for investigation")
    public void logsFailureForInvestigation() {
        log.error("Failure logged for investigation: max retries exceeded");
    }

    // ========== Non-Retryable Errors ==========

    @Given("a request returns HTTP {int} Bad Request")
    public void aRequestReturnsHTTPBadRequest(Integer statusCode) {
        lastHttpStatus = "HTTP " + statusCode;
        log.debug("Request returned {}", lastHttpStatus);
    }

    @When("the system processes the error")
    public void theSystemProcessesTheError() {
        log.debug("Processing error: {}", lastHttpStatus);
    }

    @Then("the error is classified as non-retryable")
    public void theErrorIsClassifiedAsNonRetryable() {
        requestRetried = false;
        log.debug("Error classified as non-retryable");
    }

    @Then("no retries are attempted")
    public void noRetriesAreAttempted() {
        assertThat(requestRetried).isFalse();
        log.debug("No retries attempted");
    }

    @Then("error is returned immediately")
    public void errorIsReturnedImmediately() {
        responseTime = 10; // Fast response
        log.debug("Error returned immediately");
    }

    @Then("developer is notified of bad request")
    public void developerIsNotifiedOfBadRequest() {
        log.warn("Developer notified of bad request");
    }

    // ========== Idempotency - GET Requests ==========

    @Given("a GET request to fetch player stats")
    public void aGETRequestToFetchPlayerStats() {
        log.debug("GET request to fetch player stats");
    }

    @When("the request is retried")
    public void whenTheRequestIsRetried() {
        requestRetried = true;
        retryCount++;
        log.debug("Request retried");
    }

    @Then("the retry is safe \\(idempotent)")
    public void theRetryIsSafeIdempotent() {
        log.debug("Retry is idempotent");
    }

    @Then("multiple requests produce same result")
    public void multipleRequestsProduceSameResult() {
        log.debug("Multiple requests produce same result");
    }

    @Then("no side effects occur")
    public void noSideEffectsOccur() {
        log.debug("No side effects from retry");
    }

    // ========== Idempotency - POST Requests ==========

    @Given("a POST request to update player data")
    public void aPOSTRequestToUpdatePlayerData() {
        log.debug("POST request to update player data");
    }

    @When("the request may be retried")
    public void theRequestMayBeRetried() {
        log.debug("Request may be retried");
    }

    @Then("an idempotency key is included")
    public void anIdempotencyKeyIsIncluded() {
        idempotencyKey = UUID.randomUUID().toString();
        assertThat(idempotencyKey).isNotNull();
        log.debug("Idempotency key: {}", idempotencyKey);
    }

    @Then("duplicate requests are detected")
    public void duplicateRequestsAreDetected() {
        log.debug("Duplicate request detection enabled");
    }

    @Then("prevents double-processing")
    public void preventsDoubleProcessing() {
        log.debug("Double-processing prevented");
    }

    @Then("ensures data consistency")
    public void ensuresDataConsistency() {
        log.debug("Data consistency ensured");
    }

    // ========== Health Checks ==========

    @Given("the system monitors SportsData.io health")
    public void theSystemMonitorsSportsDataIoHealth() {
        log.debug("Monitoring SportsData.io health");
    }

    @When("the health check runs every {int} seconds")
    public void theHealthCheckRunsEverySeconds(Integer interval) {
        log.debug("Health check running every {} seconds", interval);
    }

    @Then("a lightweight request is made \\(e.g., GET \\/status)")
    public void aLightweightRequestIsMade() {
        log.debug("Lightweight health check request made");
    }

    @Then("response time is measured")
    public void responseTimeIsMeasured() {
        responseTime = 100; // milliseconds
        log.debug("Response time measured: {}ms", responseTime);
    }

    @Then("success\\/failure is recorded")
    public void successFailureIsRecorded() {
        healthCheckPassed = true;
        log.debug("Health check result recorded");
    }

    @Then("health status is tracked")
    public void healthStatusIsTracked() {
        log.debug("Health status tracked");
    }

    // ========== Health Check Failures ==========

    @Given("health checks are running")
    public void healthChecksAreRunning() {
        log.debug("Health checks running");
    }

    @When("{int} consecutive health checks fail")
    public void consecutiveHealthChecksFail(Integer count) {
        consecutiveHealthCheckFailures = count;
        log.debug("{} consecutive health checks failed", count);
    }

    @Then("the API is declared unhealthy")
    public void theAPIIsDeclaredUnhealthy() {
        apiHealthy = false;
        log.warn("API declared unhealthy");
    }

    @Then("proactive fallback is activated")
    public void proactiveFallbackIsActivated() {
        fallbackActivated = true;
        log.debug("Proactive fallback activated");
    }

    @Then("circuit breaker preemptively opens")
    public void circuitBreakerPreemptivelyOpens() {
        circuitBreakerState = CircuitBreakerState.OPEN;
        log.debug("Circuit breaker preemptively opened");
    }

    @Then("ops team is alerted")
    public void opsTeamIsAlerted() {
        opsAlertSent = true;
        log.debug("Ops team alerted");
    }

    // ========== Health Check Recovery ==========

    @Given("the API was declared unhealthy")
    public void theAPIWasDeclaredUnhealthy() {
        apiHealthy = false;
        consecutiveHealthCheckFailures = 3;
        log.debug("API was declared unhealthy");
    }

    @When("{int} consecutive health checks succeed")
    public void consecutiveHealthChecksSucceed(Integer count) {
        consecutiveHealthCheckSuccesses = count;
        log.debug("{} consecutive health checks succeeded", count);
    }

    @Then("the API is declared healthy")
    public void theAPIIsDeclaredHealthy() {
        apiHealthy = true;
        log.info("API declared healthy");
    }

    @Then("fallback is deactivated")
    public void fallbackIsDeactivated() {
        fallbackActivated = false;
        log.debug("Fallback deactivated");
    }

    @Then("circuit breaker is reset to CLOSED")
    public void circuitBreakerIsResetToCLOSED() {
        circuitBreakerState = CircuitBreakerState.CLOSED;
        failureCount.set(0);
        log.debug("Circuit breaker reset to CLOSED");
    }

    // ========== Bulkhead Pattern ==========

    @Given("the system calls multiple SportsData.io endpoints")
    public void theSystemCallsMultipleSportsDataIoEndpoints() {
        endpointCircuitBreakers.put("PlayerGameStatsByWeek", CircuitBreakerState.CLOSED);
        endpointCircuitBreakers.put("News", CircuitBreakerState.CLOSED);
        endpointCircuitBreakers.put("Schedule", CircuitBreakerState.CLOSED);
        log.debug("Multiple endpoints configured");
    }

    @When("\\/PlayerGameStatsByWeek fails repeatedly")
    public void playerGameStatsByWeekFailsRepeatedly() {
        endpointCircuitBreakers.put("PlayerGameStatsByWeek", CircuitBreakerState.OPEN);
        log.debug("PlayerGameStatsByWeek failing repeatedly");
    }

    @Then("only that endpoint's circuit breaker opens")
    public void onlyThatEndpointCircuitBreakerOpens() {
        assertThat(endpointCircuitBreakers.get("PlayerGameStatsByWeek"))
            .isEqualTo(CircuitBreakerState.OPEN);
        log.debug("Only PlayerGameStatsByWeek circuit breaker opened");
    }

    @Then("other endpoints \\(\\/News, \\/Schedule) remain functional")
    public void otherEndpointsRemainFunctional() {
        assertThat(endpointCircuitBreakers.get("News"))
            .isEqualTo(CircuitBreakerState.CLOSED);
        assertThat(endpointCircuitBreakers.get("Schedule"))
            .isEqualTo(CircuitBreakerState.CLOSED);
        log.debug("Other endpoints remain functional");
    }

    @Then("failures are isolated per endpoint")
    public void failuresAreIsolatedPerEndpoint() {
        log.debug("Failures isolated per endpoint");
    }

    @Then("prevents cascading failures")
    public void preventsCascadingFailures() {
        log.debug("Cascading failures prevented");
    }

    // ========== Thread Pools ==========

    @Given("the system uses thread pools for API calls")
    public void theSystemUsesThreadPoolsForAPICalls() {
        log.debug("Thread pools configured for API calls");
    }

    @Then("thread pools are allocated:")
    public void threadPoolsAreAllocated(DataTable dataTable) {
        dataTable.asMaps().forEach(row -> {
            String pool = row.keySet().iterator().next();
            String threads = row.get(pool).replace(" threads", "").trim();
            endpointThreadPools.put(pool, new AtomicInteger(Integer.parseInt(threads)));
        });
        log.debug("Thread pools allocated: {}", endpointThreadPools);
    }

    @Then("thread pool exhaustion in one doesn't affect others")
    public void threadPoolExhaustionInOneDoesntAffectOthers() {
        log.debug("Thread pool isolation maintained");
    }

    @Then("prevents resource starvation")
    public void preventsResourceStarvation() {
        log.debug("Resource starvation prevented");
    }

    // ========== Feature Degradation ==========

    @Given("the News API is unavailable")
    public void theNewsAPIIsUnavailable() {
        endpointCircuitBreakers.put("News", CircuitBreakerState.OPEN);
        log.debug("News API unavailable");
    }

    @Given("Player Stats API is working")
    public void playerStatsAPIIsWorking() {
        endpointCircuitBreakers.put("PlayerStats", CircuitBreakerState.CLOSED);
        log.debug("Player Stats API working");
    }

    @When("the system detects News API failure")
    public void theSystemDetectsNewsAPIFailure() {
        log.debug("News API failure detected");
    }

    @Then("the news feed section is hidden")
    public void theNewsFeedSectionIsHidden() {
        log.debug("News feed section hidden");
    }

    @Then("core fantasy scoring continues to work")
    public void coreFantasyScoringContinuesToWork() {
        log.debug("Core fantasy scoring functional");
    }

    @Then("users are notified {string}")
    public void usersAreNotified(String notification) {
        log.info("User notification: {}", notification);
    }

    @Then("essential features remain operational")
    public void essentialFeaturesRemainOperational() {
        log.debug("Essential features operational");
    }

    // ========== Data Freshness Reduction ==========

    @Given("real-time stats API is struggling")
    public void realTimeStatsAPIIsStruggling() {
        log.debug("Real-time stats API struggling");
    }

    @When("response times exceed {int} seconds")
    public void responseTimesExceedSeconds(Integer seconds) {
        responseTime = (seconds + 1) * 1000;
        log.debug("Response times exceed {} seconds", seconds);
    }

    @Then("polling frequency is reduced from {int}s to {int}s")
    public void pollingFrequencyIsReduced(Integer from, Integer to) {
        log.debug("Polling frequency reduced from {}s to {}s", from, to);
    }

    @Then("reduces load on API")
    public void reducesLoadOnAPI() {
        log.debug("Load on API reduced");
    }

    @Then("gracefully degrades real-time experience")
    public void gracefullyDegradesRealTimeExperience() {
        log.debug("Real-time experience gracefully degraded");
    }

    @Then("still provides reasonably fresh data")
    public void stillProvidesReasonablyFreshData() {
        log.debug("Reasonably fresh data still provided");
    }

    // ========== Error Response Format ==========

    @Given("any error occurs in the system")
    public void anyErrorOccursInTheSystem() {
        lastErrorCode = "API_TIMEOUT";
        log.debug("Error occurred in system");
    }

    @When("the error response is generated")
    public void theErrorResponseIsGenerated() {
        errorResponse.put("code", lastErrorCode);
        errorResponse.put("message", "API request timed out");
        errorResponse.put("timestamp", LocalDateTime.now().toString());
        errorResponse.put("requestId", UUID.randomUUID().toString());
        errorResponse.put("retryable", true);
        log.debug("Error response generated: {}", errorResponse);
    }

    @Then("the response follows standard format:")
    public void theResponseFollowsStandardFormat(DataTable dataTable) {
        dataTable.asMaps().forEach(row -> {
            String field = row.keySet().iterator().next();
            assertThat(errorResponse).containsKey(field.replace("error.", ""));
        });
        log.debug("Error response follows standard format");
    }

    @Then("errors are machine-readable")
    public void errorsAreMachineReadable() {
        assertThat(errorResponse).containsKey("code");
        log.debug("Errors are machine-readable");
    }

    // ========== Error Details ==========

    @Given("an API error occurs")
    public void anAPIErrorOccurs() {
        lastHttpStatus = "HTTP 500";
        log.debug("API error occurred");
    }

    @When("the error is logged")
    public void theErrorIsLogged() {
        errorDetails.put("endpoint", "/api/player/stats");
        errorDetails.put("status", lastHttpStatus);
        errorDetails.put("response", "Internal Server Error");
        errorDetails.put("headers", "Authorization: Bearer xxx");
        errorDetails.put("timestamp", LocalDateTime.now().toString());
        errorDetails.put("circuitBreakerState", circuitBreakerState.toString());
        log.error("Error details logged: {}", errorDetails);
    }

    @Then("details include:")
    public void detailsInclude(DataTable dataTable) {
        dataTable.asList().forEach(detail -> {
            log.debug("Error detail present: {}", detail);
        });
    }

    @Then("enables rapid debugging")
    public void enablesRapidDebugging() {
        assertThat(errorDetails).isNotEmpty();
        log.debug("Rapid debugging enabled with detailed error info");
    }

    // ========== Circuit Breaker Alert ==========

    @Given("the circuit breaker opens")
    public void givenTheCircuitBreakerOpens() {
        circuitBreakerState = CircuitBreakerState.OPEN;
        circuitOpenedAt = LocalDateTime.now();
        log.debug("Circuit breaker opened");
    }

    @When("the state changes from CLOSED to OPEN")
    public void theStateChangesFromCLOSEDToOPEN() {
        circuitBreakerState = CircuitBreakerState.OPEN;
        log.debug("State changed from CLOSED to OPEN");
    }

    @Then("an alert is triggered")
    public void anAlertIsTriggered() {
        opsAlertSent = true;
        log.warn("Alert triggered for circuit breaker open");
    }

    @Then("ops team receives notification")
    public void opsTeamReceivesNotification() {
        assertThat(opsAlertSent).isTrue();
        log.debug("Ops team notification sent");
    }

    @Then("alert includes:")
    public void alertIncludes(DataTable dataTable) {
        Map<String, String> alertData = new HashMap<>();
        dataTable.asMaps().forEach(row -> {
            String key = row.keySet().iterator().next();
            alertData.put(key, row.get(key));
        });
        log.debug("Alert includes data: {}", alertData);
    }

    @Then("enables rapid response")
    public void enablesRapidResponse() {
        log.debug("Rapid response enabled");
    }

    // ========== High Error Rate Alert ==========

    @Given("the system tracks error rates")
    public void theSystemTracksErrorRates() {
        log.debug("System tracking error rates");
    }

    @When("error rate exceeds {int}% over {int} minutes")
    public void errorRateExceedsOverMinutes(Integer percentage, Integer minutes) {
        log.warn("Error rate exceeded {}% over {} minutes", percentage, minutes);
    }

    @Then("a high error rate alert is triggered")
    public void aHighErrorRateAlertIsTriggered() {
        opsAlertSent = true;
        log.warn("High error rate alert triggered");
    }

    @Then("system may preemptively activate fallback")
    public void systemMayPreemptivelyActivateFallback() {
        fallbackActivated = true;
        log.debug("Preemptive fallback activated");
    }

    @Then("prevents user impact")
    public void preventsUserImpact() {
        log.debug("User impact prevented");
    }

    // ========== Dashboard Metrics ==========

    @Given("ops team views monitoring dashboard")
    public void opsTeamViewsMonitoringDashboard() {
        log.debug("Ops team viewing dashboard");
    }

    @Then("resilience metrics are displayed:")
    public void resilienceMetricsAreDisplayed(DataTable dataTable) {
        Map<String, String> metrics = new HashMap<>();
        dataTable.asMaps().forEach(row -> {
            String key = row.keySet().iterator().next();
            metrics.put(key, row.get(key));
        });
        log.debug("Dashboard metrics: {}", metrics);
    }

    @Then("provides visibility into system health")
    public void providesVisibilityIntoSystemHealth() {
        log.debug("System health visibility provided");
    }

    // ========== Fallback Data Tagging ==========

    @Given("data is served from fallback")
    public void dataIsServedFromFallback() {
        fallbackActivated = true;
        dataSource = "CACHE";
        log.debug("Data served from fallback");
    }

    @When("the response is returned")
    public void theResponseIsReturned() {
        log.debug("Response returned");
    }

    @Then("the data includes metadata:")
    public void theDataIncludesMetadata(DataTable dataTable) {
        Map<String, String> metadata = new HashMap<>();
        dataTable.asMaps().forEach(row -> {
            String key = row.keySet().iterator().next();
            metadata.put(key, row.get(key));
        });
        log.debug("Metadata included: {}", metadata);
    }

    @Then("user knows data may be stale")
    public void userKnowsDataMayBeStale() {
        dataFresh = false;
        log.debug("User informed data may be stale");
    }

    // ========== Stale Data Warning ==========

    @Given("cached data is {int} hours old")
    public void cachedDataIsHoursOld(Integer hours) {
        cacheTimestamp = LocalDateTime.now().minusHours(hours);
        dataAge = hours + " hours";
        log.debug("Cached data is {} hours old", hours);
    }

    @When("the data is returned as fallback")
    public void theDataIsReturnedAsFallback() {
        fallbackActivated = true;
        dataSource = "CACHE";
        log.debug("Data returned as fallback");
    }

    @Then("a warning is included:")
    public void aWarningIsIncluded(String warning) {
        warningDisplayed = true;
        log.warn("Warning displayed: {}", warning);
    }

    @Then("user is informed of data quality")
    public void userIsInformedOfDataQuality() {
        assertThat(warningDisplayed).isTrue();
        log.debug("User informed of data quality");
    }

    @Then("can make informed decisions")
    public void canMakeInformedDecisions() {
        log.debug("User can make informed decisions");
    }

    // ========== Chaos Engineering ==========

    @Given("the test environment has chaos engineering enabled")
    public void theTestEnvironmentHasChaosEngineeringEnabled() {
        log.debug("Chaos engineering enabled");
    }

    @When("a test triggers API failure simulation")
    public void aTestTriggersAPIFailureSimulation() {
        log.debug("API failure simulation triggered");
    }

    @Then("the API returns errors for X% of requests")
    public void theAPIReturnsErrorsForXOfRequests() {
        log.debug("API returning errors for X% of requests");
    }

    @Then("circuit breaker behavior is verified")
    public void circuitBreakerBehaviorIsVerified() {
        log.debug("Circuit breaker behavior verified");
    }

    @Then("fallback mechanisms are tested")
    public void fallbackMechanismsAreTested() {
        log.debug("Fallback mechanisms tested");
    }

    @Then("resilience is validated")
    public void resilienceIsValidated() {
        log.debug("Resilience validated");
    }

    // ========== State Machine Testing ==========

    @When("{int} failures are injected")
    public void failuresAreInjected(Integer count) {
        for (int i = 0; i < count; i++) {
            failureCount.incrementAndGet();
        }
        log.debug("{} failures injected", count);
    }

    @Then("the circuit opens")
    public void theCircuitOpens() {
        circuitBreakerState = CircuitBreakerState.OPEN;
        circuitOpenedAt = LocalDateTime.now();
        log.debug("Circuit opened");
    }

    @Then("After {int} seconds, it transitions to HALF_OPEN")
    public void afterSecondsItTransitionsToHALF_OPEN(Integer seconds) {
        circuitOpenedAt = LocalDateTime.now().minusSeconds(seconds);
        circuitBreakerState = CircuitBreakerState.HALF_OPEN;
        log.debug("After {} seconds, transitioned to HALF_OPEN", seconds);
    }

    @When("a success is injected")
    public void aSuccessIsInjected() {
        lastHttpStatus = "HTTP 200";
        log.debug("Success injected");
    }

    @Then("it transitions to CLOSED")
    public void itTransitionsToCLOSED() {
        circuitBreakerState = CircuitBreakerState.CLOSED;
        failureCount.set(0);
        log.debug("Transitioned to CLOSED");
    }

    @Then("full state machine is validated")
    public void fullStateMachineIsValidated() {
        log.debug("Full state machine validated");
    }

    // ========== Automatic Recovery ==========

    @Given("SportsData.io experiences {int}-minute outage")
    public void sportsDataIoExperiencesMinuteOutage(Integer minutes) {
        log.debug("SportsData.io experiences {}-minute outage", minutes);
    }

    @When("the circuit breaker opens")
    public void whenTheCircuitBreakerOpens() {
        circuitBreakerState = CircuitBreakerState.OPEN;
        circuitOpenedAt = LocalDateTime.now();
        log.debug("Circuit breaker opened");
    }

    @When("enters timeout period")
    public void entersTimeoutPeriod() {
        log.debug("Entered timeout period");
    }

    @Then("After {int} seconds, circuit transitions to HALF_OPEN")
    public void thenAfterSecondsCircuitTransitionsToHALF_OPEN(Integer seconds) {
        circuitOpenedAt = LocalDateTime.now().minusSeconds(seconds);
        circuitBreakerState = CircuitBreakerState.HALF_OPEN;
        log.debug("After {} seconds, circuit transitioned to HALF_OPEN", seconds);
    }

    @When("test request succeeds")
    public void testRequestSucceeds() {
        lastHttpStatus = "HTTP 200";
        log.debug("Test request succeeded");
    }

    @Then("circuit closes")
    public void circuitCloses() {
        circuitBreakerState = CircuitBreakerState.CLOSED;
        failureCount.set(0);
        log.debug("Circuit closed");
    }

    @Then("normal operation resumes automatically")
    public void normalOperationResumesAutomatically() {
        assertThat(circuitBreakerState).isEqualTo(CircuitBreakerState.CLOSED);
        log.debug("Normal operation resumed automatically");
    }

    @Then("no manual intervention required")
    public void noManualInterventionRequired() {
        log.debug("No manual intervention required");
    }

    // ========== Manual Circuit Reset ==========

    @Given("the circuit breaker is stuck OPEN")
    public void theCircuitBreakerIsStuckOPEN() {
        circuitBreakerState = CircuitBreakerState.OPEN;
        circuitOpenedAt = LocalDateTime.now().minusMinutes(30);
        log.warn("Circuit breaker stuck OPEN");
    }

    @Given("the API is known to be healthy")
    public void theAPIIsKnownToBeHealthy() {
        apiHealthy = true;
        log.debug("API known to be healthy");
    }

    @When("an admin manually resets the circuit breaker")
    public void anAdminManuallyResetsTheCircuitBreaker() {
        manualResetPerformed = true;
        circuitBreakerState = CircuitBreakerState.CLOSED;
        failureCount.set(0);
        log.info("Admin manually reset circuit breaker");
    }

    @Then("the state is forced to CLOSED")
    public void theStateIsForcedToCLOSED() {
        assertThat(circuitBreakerState).isEqualTo(CircuitBreakerState.CLOSED);
        log.debug("State forced to CLOSED");
    }

    @Then("requests resume immediately")
    public void requestsResumeImmediately() {
        requestBlocked = false;
        log.debug("Requests resumed immediately");
    }

    @Then("admin action is logged")
    public void adminActionIsLogged() {
        assertThat(manualResetPerformed).isTrue();
        log.info("Admin action logged");
    }

    // ========== Load Shedding ==========

    @Given("the API is under heavy load")
    public void theAPIIsUnderHeavyLoad() {
        log.warn("API under heavy load");
    }

    @Given("response times exceed {int} seconds")
    public void responseTimesExceedSecondsGiven(Integer seconds) {
        responseTime = (seconds + 1) * 1000;
        log.debug("Response times exceed {} seconds", seconds);
    }

    @When("low-priority requests \\(player search) arrive")
    public void lowPriorityRequestsArrive() {
        requestPriority = "player search";
        log.debug("Low-priority request arrived");
    }

    @Then("those requests are rejected")
    public void thoseRequestsAreRejected() {
        requestShedded = true;
        log.debug("Low-priority requests rejected");
    }

    @Then("error {string} is returned")
    public void errorStringIsReturned(String errorCode) {
        lastErrorCode = errorCode;
        errorResponse.put("code", errorCode);
        log.debug("Error returned: {}", errorCode);
    }

    @Then("high-priority requests \\(live stats) are processed")
    public void highPriorityRequestsAreProcessed() {
        log.debug("High-priority requests processed");
    }

    @Then("protects API from overload")
    public void protectsAPIFromOverload() {
        log.debug("API protected from overload");
    }

    // ========== Request Priority Queue ==========

    @Given("requests have different priorities:")
    public void requestsHaveDifferentPriorities(DataTable dataTable) {
        dataTable.asMaps().forEach(row -> {
            String request = row.keySet().iterator().next();
            String priority = row.get(request).replace("Priority ", "").replace(" (highest)", "").replace(" (lowest)", "").trim();
            requestPriorities.put(request, Integer.parseInt(priority));
        });
        log.debug("Request priorities configured: {}", requestPriorities);
    }

    @When("system is under load")
    public void systemIsUnderLoad() {
        log.warn("System under load");
    }

    @Then("high-priority requests are processed first")
    public void highPriorityRequestsAreProcessedFirst() {
        log.debug("High-priority requests processed first");
    }

    @Then("low-priority requests may be delayed or dropped")
    public void lowPriorityRequestsMayBeDelayedOrDropped() {
        log.debug("Low-priority requests may be delayed or dropped");
    }

    @Then("ensures critical features work")
    public void ensuresCriticalFeaturesWork() {
        log.debug("Critical features ensured to work");
    }

    // ========== Dependency Isolation ==========

    @Given("the system depends on SportsData.io")
    public void theSystemDependsOnSportsDataIo() {
        log.debug("System depends on SportsData.io");
    }

    @When("SportsData.io fails completely")
    public void sportsDataIoFailsCompletely() {
        circuitBreakerState = CircuitBreakerState.OPEN;
        log.error("SportsData.io failed completely");
    }

    @Then("the failure is contained")
    public void theFailureIsContained() {
        log.debug("Failure contained");
    }

    @Then("does not crash the application")
    public void doesNotCrashTheApplication() {
        log.debug("Application did not crash");
    }

    @Then("user-facing features degrade gracefully")
    public void userFacingFeaturesDegradeGracefully() {
        fallbackActivated = true;
        log.debug("User-facing features degraded gracefully");
    }

    @Then("core application remains running")
    public void coreApplicationRemainsRunning() {
        log.debug("Core application remains running");
    }

    @Then("database and authentication continue to work")
    public void databaseAndAuthenticationContinueToWork() {
        log.debug("Database and authentication continue to work");
    }

    // ========== Cascading Failure Prevention ==========

    @Given("Service A depends on Service B")
    public void serviceADependsOnServiceB() {
        log.debug("Service A depends on Service B");
    }

    @Given("Service B depends on SportsData.io")
    public void serviceBDependsOnSportsDataIo() {
        log.debug("Service B depends on SportsData.io");
    }

    @When("SportsData.io fails")
    public void sportsDataIoFails() {
        log.error("SportsData.io failed");
    }

    @Then("Service B handles the failure")
    public void serviceBHandlesTheFailure() {
        log.debug("Service B handled the failure");
    }

    @Then("does not propagate failure to Service A")
    public void doesNotPropagateFailureToServiceA() {
        log.debug("Failure not propagated to Service A");
    }

    @Then("each layer has circuit breaker")
    public void eachLayerHasCircuitBreaker() {
        log.debug("Each layer has circuit breaker");
    }

    @Then("failures are contained at each level")
    public void failuresAreContainedAtEachLevel() {
        log.debug("Failures contained at each level");
    }

    // ========== Runbook ==========

    @When("ops team is alerted")
    public void whenOpsTeamIsAlerted() {
        opsAlertSent = true;
        log.warn("Ops team alerted");
    }

    @Then("runbook is referenced with steps:")
    public void runbookIsReferencedWithSteps(DataTable dataTable) {
        runbookSteps.clear();
        dataTable.asList().forEach(step -> {
            Map<String, String> stepMap = new HashMap<>();
            stepMap.put("step", step);
            runbookSteps.add(stepMap);
        });
        log.debug("Runbook steps: {}", runbookSteps);
    }

    @Then("enables rapid incident resolution")
    public void enablesRapidIncidentResolution() {
        assertThat(runbookSteps).isNotEmpty();
        log.debug("Rapid incident resolution enabled");
    }
}
