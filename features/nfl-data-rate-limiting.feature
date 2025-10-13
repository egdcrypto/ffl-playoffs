Feature: NFL Data API Rate Limiting with Token Bucket
  As a system
  I want to implement rate limiting for SportsData.io API calls
  So that I stay within API rate limits and avoid throttling

  Background:
    Given the system integrates with SportsData.io API
    And the API has rate limits
    And the system implements token bucket rate limiting

  # Token Bucket Algorithm

  Scenario: Initialize token bucket rate limiter
    Given SportsData.io allows 30 requests per minute
    When the rate limiter is initialized
    Then the bucket capacity is set to 30 tokens
    And tokens refill at 0.5 tokens/second (30/60)
    And the bucket starts full with 30 tokens

  Scenario: Consume token for each API request
    Given the token bucket has 30 tokens
    When the system makes an API request
    Then 1 token is consumed from the bucket
    And 29 tokens remain
    And the API request proceeds

  Scenario: Block request when bucket is empty
    Given the token bucket has 0 tokens
    When the system attempts an API request
    Then the request is blocked
    And the system waits for token refill
    And after 2 seconds, 1 token is available
    And the request is retried

  Scenario: Refill tokens over time
    Given the token bucket has 10 tokens
    And no requests are made
    When 10 seconds pass
    Then 5 tokens are refilled (0.5 tokens/second)
    And the bucket now has 15 tokens

  Scenario: Cap tokens at bucket capacity
    Given the token bucket has 28 tokens
    And no requests are made for 10 seconds
    When 5 tokens would be refilled
    Then the bucket caps at 30 tokens (max capacity)
    And excess tokens are discarded
    And the bucket remains at 30 tokens

  # Request Queueing

  Scenario: Queue requests when rate limit reached
    Given the token bucket has 0 tokens
    And 10 API requests arrive simultaneously
    When all requests attempt to execute
    Then requests are queued in FIFO order
    And requests wait for tokens to become available
    As tokens refill, requests are processed in order
    And all 10 requests eventually complete

  Scenario: Set maximum queue size
    Given the request queue has max size 100
    And the token bucket is empty
    When 150 requests arrive simultaneously
    Then the first 100 requests are queued
    And the remaining 50 requests are rejected
    And rejected requests receive error "RATE_LIMIT_QUEUE_FULL"
    And users are notified to retry later

  Scenario: Prioritize critical requests
    Given the token bucket has limited tokens
    And the queue has both live stats and player search requests
    When requests are prioritized
    Then live stats requests (high priority) are processed first
    And player search requests (low priority) wait
    And critical data is fetched faster

  # Rate Limit Configuration

  Scenario: Configure rate limits per API tier
    Given the system has a Free tier SportsData.io account
    Then the rate limit is 30 requests per minute
    When the system upgrades to Paid tier
    Then the rate limit is increased to 600 requests per minute
    And the token bucket is reconfigured accordingly
    And burst capacity is increased

  Scenario: Configure different rate limits per endpoint
    Given the system calls multiple SportsData.io endpoints
    Then endpoint-specific rate limits are:
      | Endpoint               | Rate Limit (req/min) |
      | PlayerGameStatsByWeek  | 30                   |
      | FantasyDefenseByGame   | 30                   |
      | News                   | 60                   |
      | Player profiles        | 30                   |
      | Schedule               | 60                   |
    And each endpoint has separate token bucket

  # Burst Handling

  Scenario: Allow burst requests with bucket capacity
    Given the token bucket has been idle
    And has accumulated 30 tokens (full capacity)
    When 20 requests arrive simultaneously (burst)
    Then all 20 requests are processed immediately
    And 10 tokens remain
    And burst traffic is handled smoothly

  Scenario: Limit burst size to bucket capacity
    Given the token bucket has 30 tokens
    When 50 requests arrive simultaneously
    Then the first 30 requests proceed immediately
    And the remaining 20 requests are queued
    And processed as tokens refill
    And prevents overwhelming the API

  # Distributed Rate Limiting

  Scenario: Share rate limit across multiple application instances
    Given the system runs 3 application instances
    And all share the same SportsData.io API key
    When Instance A uses 10 tokens
    And Instance B uses 15 tokens
    Then the shared token bucket has 5 tokens remaining
    And all instances respect the global limit
    And Redis is used for distributed token bucket

  Scenario: Synchronize token bucket state in Redis
    Given the token bucket state is stored in Redis
    When Instance A consumes 5 tokens
    Then Redis DECRBY operation updates the count
    And Instance B immediately sees updated count
    And race conditions are prevented with atomic operations
    And token state is consistent across instances

  Scenario: Handle Redis unavailability for rate limiting
    Given the distributed rate limiter uses Redis
    When Redis becomes unavailable
    Then each instance falls back to local rate limiting
    And each instance gets 1/N of the global limit
    And for 3 instances, each gets 10 requests/minute
    And API is still protected from overuse

  # Adaptive Rate Limiting

  Scenario: Detect API rate limit response
    Given the system is making API requests
    When SportsData.io returns HTTP 429 Too Many Requests
    Then the system detects rate limit hit
    And immediately stops all requests
    And backs off for 60 seconds
    And logs the rate limit event
    And reduces request rate by 50%

  Scenario: Gradually increase rate after backoff
    Given the system backed off to 15 requests/minute
    And the backoff period has ended
    When API calls resume
    Then the rate starts at 15 requests/minute
    And gradually increases by 10% every minute
    Until returning to 30 requests/minute
    And avoids triggering rate limit again

  Scenario: Permanent rate limit reduction on repeated violations
    Given the system has triggered rate limit 5 times in 1 hour
    When the rate limit is hit again
    Then the system permanently reduces to 80% of original rate
    And new rate is 24 requests/minute
    And admin is notified to upgrade API tier

  # Rate Limit Metrics

  Scenario: Track API call rate metrics
    Given the system monitors API usage
    When 100 API calls are made in 5 minutes
    Then the average rate is 20 requests/minute
    And metrics are logged:
      | Total Calls          | 100    |
      | Time Period          | 5 min  |
      | Average Rate         | 20/min |
      | Peak Rate            | 35/min |
      | Rate Limit Hits      | 0      |
    And metrics are exported to monitoring system

  Scenario: Alert when approaching rate limit
    Given the rate limit is 30 requests/minute
    And the alert threshold is 80% (24 requests/minute)
    When the current rate reaches 25 requests/minute
    Then an alert is triggered
    And ops team is notified
    And request rate is throttled preemptively
    And rate limit violations are prevented

  Scenario: Track token bucket state
    Given the token bucket is being monitored
    Then the following metrics are tracked:
      | Available Tokens     | 18     |
      | Bucket Capacity      | 30     |
      | Tokens Consumed/min  | 22     |
      | Queue Size           | 3      |
      | Rejected Requests    | 0      |
    And metrics are visible in dashboard

  # Request Scheduling

  Scenario: Schedule non-urgent requests during low-traffic periods
    Given player profile updates are non-urgent
    And live stats polling is high-priority
    When live games are in progress (high traffic)
    Then player profile requests are deferred
    And scheduled for execution during off-peak hours
    And rate limit tokens are reserved for live stats

  Scenario: Batch requests to minimize API calls
    Given the system needs stats for 50 players
    When requests are batched
    Then a single API call fetches all 50 players
    And only 1 token is consumed instead of 50
    And rate limit efficiency is maximized

  # Retry Strategy with Rate Limiting

  Scenario: Retry failed request with exponential backoff
    Given an API request fails due to rate limit
    When the system retries the request
    Then the first retry waits 2 seconds
    And the second retry waits 4 seconds
    And the third retry waits 8 seconds
    And maximum backoff is 60 seconds
    And retries respect rate limit tokens

  Scenario: Abort retry after max attempts
    Given an API request has failed 5 times
    And all retries have been exhausted
    When the final retry fails
    Then the request is abandoned
    And error "MAX_RETRIES_EXCEEDED" is returned
    And the failure is logged
    And user is notified of temporary unavailability

  # Fair Sharing

  Scenario: Implement fair queuing across users
    Given 100 users are making API requests
    And User A makes 50 requests
    And User B makes 10 requests
    When requests are queued
    Then each user gets fair share of rate limit
    And no single user monopolizes the API
    And round-robin scheduling is used

  Scenario: Allocate rate limit by user priority
    Given the system has different user tiers
    Then rate limit allocation is:
      | Premium Users  | 60% of rate limit |
      | Free Users     | 40% of rate limit |
    And premium users get faster response times
    And free users still have reasonable access

  # Endpoint-Specific Rate Limiting

  Scenario: Apply different rate limits per endpoint
    Given /PlayerGameStatsByWeek has limit 30/minute
    And /News has limit 60/minute
    When the system makes requests to both endpoints
    Then each endpoint has independent token bucket
    And requests to News don't impact PlayerGameStats limit
    And endpoints are rate-limited independently

  Scenario: Share tokens across related endpoints
    Given /PlayerGameStatsByWeek and /FantasyDefenseByGame are related
    When the system groups related endpoints
    Then they share a single token bucket of 30/minute
    And combined requests are rate-limited together
    And prevents exceeding API global limit

  # Rate Limit Headers

  Scenario: Parse rate limit headers from API response
    Given SportsData.io returns rate limit headers
    When the API response is received
    Then the system parses headers:
      | X-RateLimit-Limit     | 30     |
      | X-RateLimit-Remaining | 18     |
      | X-RateLimit-Reset     | 1640000000 |
    And adjusts local rate limiter to match
    And stays in sync with API limits

  Scenario: Preemptively throttle based on remaining limit
    Given X-RateLimit-Remaining header shows 3
    And the reset time is in 50 seconds
    When the system checks remaining limit
    Then requests are throttled to 3/50s = 0.06/sec
    And tokens are preserved until reset
    And prevents hitting rate limit

  # Testing and Simulation

  Scenario: Simulate rate limit in test environment
    Given the test environment has fast execution
    When rate limit tests are run
    Then time is simulated (not actual wait)
    And token refill is instant
    And tests complete in seconds, not minutes
    And rate limiting logic is verified

  Scenario: Load test with rate limiter
    Given the system undergoes load testing
    When 1000 concurrent requests are simulated
    Then the rate limiter queues requests
    And processes them at 30/minute
    And no API rate limit is triggered
    And the system remains stable under load

  # Cost Optimization

  Scenario: Track API cost per endpoint
    Given SportsData.io charges per API call
    When the system monitors usage
    Then cost is calculated per endpoint:
      | Endpoint               | Calls/day | Cost/call | Daily Cost |
      | PlayerGameStatsByWeek  | 2,000     | $0.01     | $20        |
      | News                   | 500       | $0.005    | $2.50      |
      | Schedule               | 100       | $0.01     | $1         |
      | Total                  |           |           | $23.50     |
    And cost optimization opportunities are identified

  Scenario: Reduce API calls to minimize cost
    Given current API cost is $700/month
    And caching increases cache hit rate from 70% to 90%
    When caching is optimized
    Then API calls are reduced by 67%
    And cost is reduced to $231/month
    And savings are $469/month ($5,628/year)

  # Grace Period Handling

  Scenario: Provide grace period before strict enforcement
    Given a new rate limit is configured
    When the rate limiter is deployed
    Then a 1-hour grace period is applied
    And requests exceeding limit are logged but allowed
    And after grace period, strict enforcement begins
    And gives system time to adjust

  # Rate Limit by Feature

  Scenario: Apply rate limits per feature
    Given the system has multiple features
    Then rate limits are applied:
      | Feature            | Rate Limit (req/min) |
      | Live Stats Polling | 20                   |
      | Player Search      | 5                    |
      | News Feed          | 3                    |
      | Schedule           | 2                    |
    And each feature has dedicated quota
    And features don't interfere with each other

  Scenario: Reserve tokens for critical features
    Given live stats polling is critical during games
    When rate limit budget is allocated
    Then 70% of tokens are reserved for live stats
    And 30% are available for other features
    And ensures critical features always have capacity
