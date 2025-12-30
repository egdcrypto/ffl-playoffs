Feature: NFL Data API Rate Limiting with Token Bucket
  As a system
  I want to implement rate limiting for SportsData.io API calls
  So that I stay within API rate limits and avoid throttling

  Background:
    Given the system integrates with SportsData.io API
    And the API has rate limits
    And the system implements token bucket rate limiting
    And distributed rate limiting uses Redis for coordination
    And cost tracking is enabled for API usage

  # =============================================================================
  # TOKEN BUCKET ALGORITHM - BASIC OPERATIONS
  # =============================================================================

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

  # =============================================================================
  # TOKEN BUCKET - ADVANCED SCENARIOS
  # =============================================================================

  Scenario: Token bucket state transitions
    Given a token bucket with capacity 30
    When the bucket state changes:
      | State        | Tokens | Condition                |
      | FULL         | 30     | No recent requests       |
      | AVAILABLE    | 1-29   | Normal operation         |
      | EMPTY        | 0      | All tokens consumed      |
      | REFILLING    | 0->N   | Tokens regenerating      |
    Then state transitions trigger appropriate actions
    And metrics track time in each state

  Scenario: Fractional token accumulation
    Given the refill rate is 0.5 tokens/second
    And the bucket has 10 tokens with 0.3 fractional
    When 1 second passes
    Then 0.5 tokens are added
    And fractional tokens become 0.8
    And available integer tokens remain 10
    When another second passes
    Then fractional tokens become 1.3
    And 1 integer token is added (now 11)
    And fractional becomes 0.3

  Scenario: Token bucket with variable cost requests
    Given different API calls have different costs:
      | API Call                | Token Cost |
      | Simple lookup           | 1          |
      | Batch request (10 items)| 3          |
      | Full week stats         | 5          |
      | Historical data         | 10         |
    When a batch request is made
    Then 3 tokens are consumed
    And 27 tokens remain

  Scenario: Negative token prevention
    Given the token bucket has 2 tokens
    When a request requiring 5 tokens arrives
    Then the request is blocked (not enough tokens)
    And tokens remain at 2 (not negative)
    And the request is queued until 5 tokens available

  Scenario: Token bucket warmup period
    Given the system has just started
    And the token bucket is empty
    When warmup is enabled
    Then initial burst allowance is granted (10 tokens)
    And normal refill rate applies after warmup
    And the system can handle startup requests

  Scenario: Token reservation for scheduled tasks
    Given the token bucket has 30 tokens
    And a scheduled task needs 10 tokens in 5 minutes
    When reservation is requested
    Then 10 tokens are reserved for the scheduled task
    And only 20 tokens are available for other requests
    When the scheduled task runs
    Then reserved tokens are consumed
    And reservation is released

  Scenario: Token bucket with sliding window
    Given the system uses sliding window rate limiting
    And the window is 60 seconds
    When requests are made:
      | Time (sec) | Requests |
      | 0          | 10       |
      | 30         | 10       |
      | 60         | 5        |
    Then at time 60, window includes requests from 0-60
    And total count is 25 (10+10+5)
    At time 61, the first 10 requests expire
    And new capacity becomes available

  # =============================================================================
  # REQUEST QUEUEING
  # =============================================================================

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

  Scenario: Queue timeout for waiting requests
    Given a request is queued waiting for tokens
    And the queue timeout is 30 seconds
    When 30 seconds pass without tokens available
    Then the request is removed from queue
    And error "QUEUE_TIMEOUT" is returned
    And the request can be retried by the client

  Scenario: Queue monitoring and metrics
    Given the request queue is active
    When queue metrics are collected:
      | Metric                | Value   |
      | currentQueueSize      | 15      |
      | maxQueueSize          | 100     |
      | averageWaitTime       | 2.5s    |
      | p99WaitTime           | 8.2s    |
      | droppedRequests       | 3       |
    Then metrics are exported to monitoring
    And alerts trigger when queue exceeds threshold

  Scenario: Priority queue with multiple levels
    Given the queue supports priority levels:
      | Priority | Level | Description              |
      | CRITICAL | 0     | Live game scores         |
      | HIGH     | 1     | Real-time stats          |
      | MEDIUM   | 2     | Player information       |
      | LOW      | 3     | Historical data          |
      | BULK     | 4     | Batch background tasks   |
    When tokens become available
    Then CRITICAL requests are processed first
    And lower priorities wait their turn
    And starvation prevention ensures LOW gets occasional tokens

  # =============================================================================
  # RATE LIMIT CONFIGURATION
  # =============================================================================

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

  Scenario: Dynamic rate limit configuration
    Given the system reads rate limits from configuration
    When configuration is updated at runtime:
      | Parameter        | Old Value | New Value |
      | maxRequestsPerMin| 30        | 45        |
      | bucketCapacity   | 30        | 45        |
      | refillRate       | 0.5/s     | 0.75/s    |
    Then the rate limiter is reconfigured without restart
    And in-flight requests are not affected
    And new limits apply immediately

  Scenario: Environment-specific rate limits
    Given different environments have different limits:
      | Environment | Rate Limit | Burst Capacity |
      | Development | 10/min     | 5              |
      | Staging     | 30/min     | 15             |
      | Production  | 600/min    | 100            |
    When the system starts in each environment
    Then appropriate limits are applied
    And configuration is validated on startup

  # =============================================================================
  # BURST HANDLING
  # =============================================================================

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

  Scenario: Burst detection and alerting
    Given normal traffic is 10 requests/minute
    When 50 requests arrive in 10 seconds
    Then burst is detected (5x normal rate)
    And a burst alert is triggered
    And the burst is logged for analysis
    And rate limiting handles the burst gracefully

  Scenario: Burst capacity reservation
    Given the bucket capacity is 30
    And 10 tokens are reserved for burst handling
    When normal requests consume tokens
    Then only 20 tokens are used for normal flow
    And 10 remain reserved for sudden bursts
    And burst reservation resets when bucket refills

  # =============================================================================
  # DISTRIBUTED RATE LIMITING - BASIC
  # =============================================================================

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

  # =============================================================================
  # DISTRIBUTED RATE LIMITING - ADVANCED
  # =============================================================================

  Scenario: Redis Lua script for atomic token operations
    Given token operations must be atomic
    When a request needs tokens
    Then a Lua script executes atomically:
      | Step | Operation                        |
      | 1    | Get current token count          |
      | 2    | Check if tokens available        |
      | 3    | Decrement if available           |
      | 4    | Return success/failure           |
    And all steps complete in single Redis call
    And no race conditions occur

  Scenario: Token bucket TTL in Redis
    Given tokens are stored in Redis
    When the token key is set
    Then a TTL of 120 seconds is applied
    And if no activity, the key expires
    And on next request, bucket is reinitialized
    And stale rate limit data is cleaned up

  Scenario: Distributed token refill coordination
    Given 3 instances share a token bucket
    When tokens need to be refilled
    Then only one instance performs the refill
    And a distributed lock prevents duplicates
    And the refill is applied atomically
    And all instances see the updated count

  Scenario: Leader election for rate limit management
    Given 3 instances need to coordinate
    When leader election runs
    Then one instance becomes the rate limit leader
    And the leader manages token refills
    And the leader monitors global rate
    And if leader fails, new leader is elected

  Scenario: Handle Redis cluster failover
    Given Redis is running in cluster mode
    When the primary node fails
    Then failover to replica occurs
    And rate limit state is preserved
    And a brief inconsistency window is expected
    And the system continues with minimal disruption

  Scenario: Split-brain handling in distributed rate limiting
    Given network partition causes split-brain
    When instances cannot communicate
    Then each partition uses local limits
    And conservative limits are applied (50% of normal)
    When network heals
    Then state is reconciled
    And normal limits resume

  Scenario: Rate limit synchronization across data centers
    Given the system runs in multiple data centers
    When rate limits need global coordination:
      | Data Center | Local Limit | Global Share |
      | US-East     | 200/min     | 33%          |
      | US-West     | 200/min     | 33%          |
      | EU-Central  | 200/min     | 34%          |
    Then each data center has allocated share
    And global limit of 600/min is respected
    And cross-DC synchronization occurs every 5 seconds

  Scenario: Graceful degradation of distributed limits
    Given distributed rate limiting is active
    When components degrade:
      | Component        | Fallback Strategy          |
      | Redis down       | Local limits (1/N)         |
      | Network partition| Conservative limits (50%)  |
      | High latency     | Cached state (5s stale)    |
    Then the system continues to function
    And API is still protected

  # =============================================================================
  # BACKOFF STRATEGIES - BASIC
  # =============================================================================

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

  # =============================================================================
  # BACKOFF STRATEGIES - COMPREHENSIVE
  # =============================================================================

  Scenario: Exponential backoff with jitter
    Given exponential backoff is configured
    When retry delays are calculated:
      | Retry | Base Delay | Jitter Range | Actual Delay |
      | 1     | 1s         | 0-500ms      | 1.0-1.5s     |
      | 2     | 2s         | 0-1000ms     | 2.0-3.0s     |
      | 3     | 4s         | 0-2000ms     | 4.0-6.0s     |
      | 4     | 8s         | 0-4000ms     | 8.0-12.0s    |
    Then jitter prevents thundering herd
    And retries are spread over time

  Scenario: Decorrelated jitter backoff
    Given decorrelated jitter is enabled
    When retry delays are calculated
    Then each delay is: min(cap, random(base, previous * 3))
    And delays are less predictable
    And better distribution than exponential jitter

  Scenario: Linear backoff for gentle rate limiting
    Given linear backoff is configured
    When retry delays are calculated:
      | Retry | Delay    |
      | 1     | 5s       |
      | 2     | 10s      |
      | 3     | 15s      |
      | 4     | 20s      |
    Then delays increase linearly
    And suitable for APIs with predictable recovery

  Scenario: Backoff with circuit breaker integration
    Given circuit breaker monitors failures
    When 5 failures occur in 1 minute:
      | Failure | Backoff | Circuit State |
      | 1       | 1s      | CLOSED        |
      | 2       | 2s      | CLOSED        |
      | 3       | 4s      | CLOSED        |
      | 4       | 8s      | CLOSED        |
      | 5       | N/A     | OPEN          |
    Then circuit opens after 5 failures
    And all requests fail fast for 30 seconds
    And after cooldown, circuit becomes HALF-OPEN
    And a test request determines full recovery

  Scenario: Backoff respects rate limit headers
    Given API returns Retry-After header: 45 seconds
    When backoff is calculated
    Then the system waits exactly 45 seconds
    And ignores calculated exponential backoff
    And Retry-After takes precedence

  Scenario: Context-aware backoff
    Given different error types require different backoff:
      | Error Type       | Backoff Strategy           |
      | 429 Rate Limit   | Respect Retry-After header |
      | 500 Server Error | Exponential with jitter    |
      | 503 Unavailable  | Linear with long delays    |
      | Timeout          | Immediate retry (once)     |
    When errors occur
    Then appropriate backoff is applied
    And recovery is optimized per error type

  Scenario: Backoff state persistence
    Given a request is in backoff state
    And the application restarts
    When the application recovers
    Then backoff state is restored from Redis
    And the retry schedule continues
    And no duplicate retries occur

  Scenario: Global backoff coordination
    Given all instances hit rate limit simultaneously
    When global backoff is triggered
    Then all instances back off together
    And a leader coordinates the retry schedule
    And requests resume gradually across instances
    And API is not overwhelmed on recovery

  Scenario: Backoff with deadline awareness
    Given a request has a deadline of 30 seconds
    And backoff schedule would take 45 seconds
    When backoff is calculated
    Then only retries within deadline are attempted
    And the request fails after deadline if not successful
    And resources are not wasted on expired requests

  # =============================================================================
  # ADAPTIVE RATE LIMITING
  # =============================================================================

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

  Scenario: Adaptive rate based on API response times
    Given API response times are monitored
    When latency exceeds thresholds:
      | Latency    | Action                      |
      | < 100ms    | Normal rate (100%)          |
      | 100-500ms  | Slightly reduce (90%)       |
      | 500-1000ms | Reduce significantly (70%)  |
      | > 1000ms   | Aggressive reduction (50%)  |
    Then request rate adapts to API health
    And prevents overwhelming stressed API

  Scenario: Seasonal rate adjustment
    Given NFL game days have high traffic
    When the schedule is analyzed:
      | Day       | Time Window      | Rate Adjustment |
      | Sunday    | 1 PM - 11 PM ET  | Reduce to 80%   |
      | Monday    | 8 PM - 11 PM ET  | Reduce to 80%   |
      | Thursday  | 8 PM - 11 PM ET  | Reduce to 80%   |
      | Other     | All day          | Full rate 100%  |
    Then rate limits adjust automatically
    And critical game-day traffic is prioritized

  # =============================================================================
  # RATE LIMIT METRICS AND MONITORING
  # =============================================================================

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

  Scenario: Real-time rate limit dashboard
    Given a monitoring dashboard is configured
    When rate limit data is displayed:
      | Widget               | Data Source          |
      | Token gauge          | Current tokens/max   |
      | Request rate chart   | Requests over time   |
      | Queue depth          | Current queue size   |
      | Error rate           | 429s and timeouts    |
      | Cost accumulator     | Running daily cost   |
    Then operators see real-time status
    And can take action before limits are hit

  Scenario: Historical rate limit analysis
    Given rate limit events are stored
    When analysis is requested for past 30 days
    Then the report includes:
      | Metric                    | Value   |
      | Total rate limit hits     | 12      |
      | Average recovery time     | 45s     |
      | Peak usage day            | Sunday  |
      | Peak usage hour           | 1 PM ET |
      | Recommended limit upgrade | Yes     |
    And patterns inform capacity planning

  # =============================================================================
  # REQUEST SCHEDULING
  # =============================================================================

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

  Scenario: Request coalescing for duplicate calls
    Given 10 users request the same player stats
    Within a 100ms window
    When coalescing is enabled
    Then only 1 API call is made
    And the result is shared with all 10 requesters
    And 9 tokens are saved

  Scenario: Scheduled batch processing
    Given batch jobs are configured:
      | Job                  | Schedule     | Token Budget |
      | Player sync          | 2 AM daily   | 100 tokens   |
      | News refresh         | Every hour   | 20 tokens    |
      | Schedule update      | 6 AM daily   | 10 tokens    |
    When jobs run at scheduled times
    Then token budgets are respected
    And jobs don't interfere with real-time traffic

  # =============================================================================
  # FAIR SHARING
  # =============================================================================

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

  Scenario: Weighted fair queuing
    Given users have different weights:
      | User Type  | Weight | Share of Tokens |
      | Admin      | 3      | 30%             |
      | Premium    | 2      | 40%             |
      | Standard   | 1      | 30%             |
    When tokens are allocated
    Then each tier gets proportional share
    And higher weight means more tokens

  Scenario: Per-user rate limiting
    Given global limit is 600/min
    And there are 100 active users
    When per-user limits are calculated
    Then each user gets max 6/min individual limit
    And prevents single user abuse
    And fair access is guaranteed

  Scenario: Request quota per user session
    Given a user session has quota of 50 requests
    When user makes 50 requests
    Then the 51st request is rejected
    And user sees "Session quota exceeded"
    And quota resets on new session

  # =============================================================================
  # ENDPOINT-SPECIFIC RATE LIMITING
  # =============================================================================

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

  Scenario: Endpoint groups with shared limits
    Given endpoints are grouped:
      | Group         | Endpoints                    | Shared Limit |
      | Stats         | PlayerStats, TeamStats       | 60/min       |
      | Reference     | Players, Teams, Schedule     | 30/min       |
      | Live          | LiveScores, LiveStats        | 120/min      |
    When requests are made to group endpoints
    Then group limits are enforced collectively

  # =============================================================================
  # RATE LIMIT HEADERS
  # =============================================================================

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

  Scenario: Handle missing rate limit headers
    Given the API doesn't return rate limit headers
    When a response is received
    Then the system uses configured defaults
    And local tracking remains authoritative
    And conservative limits are applied

  Scenario: Rate limit header drift detection
    Given local count shows 10 remaining
    And header shows 5 remaining
    When drift is detected
    Then local count is corrected to match header
    And drift is logged for analysis
    And sync frequency is increased temporarily

  # =============================================================================
  # COST OPTIMIZATION - BASIC
  # =============================================================================

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

  # =============================================================================
  # COST OPTIMIZATION - COMPREHENSIVE
  # =============================================================================

  Scenario: Real-time cost tracking
    Given API costs are monitored
    When the cost tracker updates:
      | Time Period | Calls | Cost    |
      | Last hour   | 500   | $5.00   |
      | Today       | 8,000 | $80.00  |
      | This month  | 180K  | $1,800  |
      | Projected   | 250K  | $2,500  |
    Then costs are visible in real-time dashboard
    And trends are analyzed for optimization

  Scenario: Cost budget enforcement
    Given the monthly API budget is $2,000
    When spending approaches budget:
      | Threshold | Action                           |
      | 70%       | Warning alert sent               |
      | 85%       | Non-essential requests throttled |
      | 95%       | Only critical requests allowed   |
      | 100%      | All requests blocked (emergency) |
    Then budget overruns are prevented
    And stakeholders are notified

  Scenario: Cost allocation by feature
    Given the system tracks costs by feature:
      | Feature          | Monthly Cost | % of Total |
      | Live stats       | $1,200       | 48%        |
      | Player search    | $500         | 20%        |
      | News feed        | $300         | 12%        |
      | Schedule sync    | $200         | 8%         |
      | Admin functions  | $300         | 12%        |
    Then cost reports show feature breakdown
    And expensive features are identified

  Scenario: Cost-aware request scheduling
    Given a request costs $0.01
    And the request is non-urgent
    When off-peak pricing is available (50% discount)
    Then the request is scheduled for off-peak hours
    And cost is reduced to $0.005
    And savings are accumulated over time

  Scenario: Tier upgrade cost analysis
    Given current tier costs $500/month for 30K calls
    And usage is 28K calls/month
    When upgrade is analyzed:
      | Tier     | Cost     | Calls    | Cost/Call |
      | Current  | $500     | 30K      | $0.0167   |
      | Standard | $1,000   | 100K     | $0.01     |
      | Premium  | $2,000   | 500K     | $0.004    |
    Then the system recommends optimal tier
    And projected savings are calculated

  Scenario: Cache hit rate impact on cost
    Given cache hit rate is monitored
    When cache effectiveness is analyzed:
      | Cache Hit Rate | API Calls | Monthly Cost |
      | 50%            | 50,000    | $500         |
      | 70%            | 30,000    | $300         |
      | 85%            | 15,000    | $150         |
      | 95%            | 5,000     | $50          |
    Then cache investment ROI is calculated
    And optimal cache TTL is recommended

  Scenario: Request deduplication savings
    Given duplicate requests are tracked
    When deduplication is enabled:
      | Before Dedup | After Dedup | Savings    |
      | 10,000 calls | 7,000 calls | 30%        |
      | $100/day     | $70/day     | $30/day    |
      | $3,000/month | $2,100/month| $900/month |
    Then deduplication effectiveness is measured
    And savings are reported

  Scenario: Cost anomaly detection
    Given normal daily cost is $80
    When daily cost spikes to $200
    Then anomaly is detected (2.5x normal)
    And immediate alert is sent
    And root cause investigation begins
    And automatic throttling may engage

  Scenario: Monthly cost forecast
    Given current month is 15 days complete
    And spend-to-date is $1,200
    When forecast is calculated
    Then projected monthly cost is $2,400
    And if budget is $2,000:
      | Action                              |
      | Alert: 20% over budget projected    |
      | Recommend: Reduce non-essential use |
      | Recommend: Increase cache TTL       |
    And mitigation options are presented

  # =============================================================================
  # GRACE PERIOD HANDLING
  # =============================================================================

  Scenario: Provide grace period before strict enforcement
    Given a new rate limit is configured
    When the rate limiter is deployed
    Then a 1-hour grace period is applied
    And requests exceeding limit are logged but allowed
    And after grace period, strict enforcement begins
    And gives system time to adjust

  Scenario: Soft limits with warning
    Given soft limit is 25/min and hard limit is 30/min
    When requests reach soft limit
    Then warning is logged
    And metric counter increments
    But requests are still allowed
    When requests reach hard limit
    Then requests are blocked
    And rate limiting is enforced

  # =============================================================================
  # RATE LIMIT BY FEATURE
  # =============================================================================

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

  Scenario: Dynamic feature prioritization
    Given game status changes throughout the day:
      | Time Period      | Priority Feature  | Token Allocation |
      | Pre-game         | News, Schedule    | 40% live stats   |
      | During game      | Live stats        | 80% live stats   |
      | Post-game        | Final scores      | 60% final stats  |
      | Off-season       | Player profiles   | Equal allocation |
    When game status changes
    Then token allocation adjusts automatically
    And critical features get priority

  # =============================================================================
  # TESTING AND SIMULATION
  # =============================================================================

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

  Scenario: Chaos testing rate limiting
    Given chaos engineering tests are configured
    When failures are injected:
      | Failure Type         | Expected Behavior         |
      | Redis connection lost| Fallback to local limits  |
      | Clock skew           | Tokens refill correctly   |
      | Network partition    | Conservative limits apply |
      | Token underflow      | Capped at zero            |
    Then the system handles all failures gracefully
    And rate limiting remains functional

  Scenario: Rate limit configuration validation
    Given a new rate limit configuration
    When the configuration is validated:
      | Check                           | Expected        |
      | Capacity > 0                    | Required        |
      | Refill rate > 0                 | Required        |
      | Queue size > 0                  | Required        |
      | Capacity >= refill rate         | Recommended     |
    Then invalid configurations are rejected
    And warnings are shown for suboptimal settings

  # =============================================================================
  # ERROR HANDLING AND EDGE CASES
  # =============================================================================

  Scenario: Handle rate limiter initialization failure
    Given Redis is unavailable on startup
    When the rate limiter initializes
    Then local fallback limits are used
    And initialization failure is logged
    And the system starts in degraded mode
    And reconnection attempts continue

  Scenario: Handle token count corruption
    Given token count in Redis is somehow corrupted
    When a negative token count is detected
    Then the count is reset to capacity
    And the corruption is logged as critical
    And alert is sent for investigation

  Scenario: Rate limit during system time changes
    Given the system clock is adjusted (e.g., DST)
    When time jumps forward 1 hour
    Then token refill is recalculated
    And no sudden burst of tokens is granted
    And rate limiting remains accurate

  Scenario: Handle extremely high request rates
    Given the system receives 10,000 requests/second
    When the rate limiter processes requests
    Then the queue doesn't overflow memory
    And oldest requests are dropped if necessary
    And the system remains responsive
    And critical metrics continue to be collected
