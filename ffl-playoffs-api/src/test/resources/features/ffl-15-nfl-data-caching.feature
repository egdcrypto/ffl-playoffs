# @ref: https://github.com/nflverse/nflreadpy
# @ref: docs/NFL_DATA_INTEGRATION_PROPOSAL.md
Feature: NFL Data Caching Strategy with Redis
  As a system
  I want to cache NFL data with appropriate TTL strategies
  So that I minimize data fetches and improve performance

  Background:
    Given the system is configured with Redis cache
    And Redis is running at localhost:6379
    And the system integrates with nflreadpy (nflverse) for NFL data

  # Cache Layer Architecture

  Scenario: Multi-layer caching strategy
    Given the system implements multi-layer caching
    Then the cache layers are:
      | Layer 1 | Application (Caffeine) | In-memory, fastest     |
      | Layer 2 | Redis                  | Distributed, shared    |
      | Layer 3 | Database               | Persistent, slowest    |
    And data flows: API → Database → Redis → Application → User

  # Player Data Caching

  Scenario: Cache player profile data with 24-hour TTL
    Given "Patrick Mahomes" player data is fetched from API
    When the data is successfully retrieved
    Then the data is stored in Redis with key "player:14876"
    And the TTL is set to 24 hours (86400 seconds)
    And subsequent requests return cached data
    And no API call is made within 24 hours

  Scenario: Return cached player data when available
    Given "Patrick Mahomes" data is cached in Redis
    And the cache was updated 2 hours ago
    When a user requests player data for PlayerID 14876
    Then Redis is queried first
    And the cached data is returned immediately
    And response time is < 10ms
    And no API call is made
    And cache hit metric is incremented

  Scenario: Fetch from API when cache expired
    Given "Patrick Mahomes" data was cached 25 hours ago
    And the TTL has expired
    When a user requests player data
    Then Redis returns null (cache miss)
    And the system fetches fresh data from SportsData.io API
    And the cache is updated with TTL 24 hours
    And cache miss metric is incremented

  # Live Game Stats Caching

  Scenario: Cache live stats with short TTL (30 seconds)
    Given NFL week 15 has games in progress
    When live stats are fetched from API
    Then the stats are cached in Redis with key "live_stats:week:15"
    And the TTL is set to 30 seconds
    And subsequent requests within 30 seconds return cached data
    And API polling respects 30-second intervals

  Scenario: Use cached live stats during polling interval
    Given live stats were fetched 10 seconds ago
    And cached with TTL 30 seconds
    When 5 concurrent users request live stats
    Then all 5 requests hit Redis cache
    And only 1 API call was made 10 seconds ago
    And API rate limits are preserved
    And all users see consistent data

  Scenario: Refresh live stats cache after TTL expires
    Given live stats were cached 35 seconds ago
    And the TTL has expired
    When the next polling cycle occurs
    Then the cache is empty
    And a new API call is made
    And cache is updated with fresh stats
    And TTL is reset to 30 seconds

  # Final Game Stats Caching

  Scenario: Cache final game stats permanently (until stat corrections)
    Given a game between KC and BUF has status "Final"
    When the system fetches final stats
    Then the stats are cached with key "final_stats:game:15401"
    And the TTL is set to 48 hours (stat correction window)
    And after 48 hours, the cache is permanent (no expiration)
    And API calls are eliminated for final games

  Scenario: Handle stat corrections by refreshing cache
    Given final game stats were cached 24 hours ago
    And it is now Tuesday 3:00 AM ET (stat correction time)
    When the scheduled stat correction job runs
    Then all final game caches for the previous week are invalidated
    And fresh stats are fetched from API
    And caches are updated with corrected stats
    And TTL is removed (permanent cache)

  # Schedule Caching

  Scenario: Cache weekly schedule with 1-hour TTL
    Given the schedule for NFL week 15 is fetched
    And no games are in progress
    When the schedule data is retrieved
    Then it is cached with key "schedule:week:15"
    And the TTL is set to 1 hour (3600 seconds)
    And subsequent schedule requests hit cache

  Scenario: Reduce schedule cache TTL during live games
    Given NFL week 15 has games in progress
    When the schedule is fetched
    Then the cache TTL is reduced to 5 minutes (300 seconds)
    And schedule status updates are fresher
    And game status changes are detected faster

  Scenario: Invalidate schedule cache on manual update
    Given the schedule is cached
    When the NFL announces a game time change
    And an admin triggers a schedule refresh
    Then the cache is immediately deleted from Redis
    And fresh schedule data is fetched
    And cache is repopulated with updated data

  # Player Search Results Caching

  Scenario: Cache player search results with 1-hour TTL
    Given a user searches for "Mahomes"
    When the search results are fetched
    Then the results are cached with key "search:mahomes"
    And the TTL is set to 1 hour
    And subsequent identical searches hit cache
    And API calls are reduced

  Scenario: Cache search results per query + filters
    Given a user searches for "Smith" at position "WR"
    When the search is executed
    Then the cache key is "search:smith:position:WR"
    And results are specific to that query
    And different filters produce different cache keys

  Scenario: Cache pagination separately per page
    Given a search for "Smith" returns 100 players
    When the user requests page 0 (players 1-50)
    Then cache key is "search:smith:page:0:size:50"
    When the user requests page 1 (players 51-100)
    Then cache key is "search:smith:page:1:size:50"
    And each page is cached independently

  # News and Injuries Caching

  Scenario: Cache news feed with 15-minute TTL
    Given the latest NFL news is fetched
    When the news data is retrieved
    Then it is cached with key "news:latest"
    And the TTL is set to 15 minutes (900 seconds)
    And news is refreshed every 15 minutes

  Scenario: Cache player-specific news with 15-minute TTL
    Given news for "Patrick Mahomes" is fetched
    When the news data is retrieved
    Then it is cached with key "news:player:14876"
    And the TTL is set to 15 minutes
    And player news is updated frequently

  Scenario: Cache injury report with 1-hour TTL (updated daily at 4 PM ET)
    Given the official injury report is fetched at 4:00 PM ET
    When the injury data is retrieved
    Then it is cached with key "injuries:week:15"
    And the TTL is set to 1 hour
    And injury report is relatively stable between updates

  Scenario: Invalidate injury cache on breaking news
    Given the injury report is cached
    When a major injury breaking news event occurs
    And the system detects high-impact injury update
    Then the cache is immediately invalidated
    And fresh injury data is fetched
    And affected users are notified

  # Cache Key Strategy

  Scenario: Use structured cache key naming convention
    Given the system stores various data types in Redis
    Then cache keys follow the pattern:
      | Data Type    | Key Pattern                    |
      | Player       | player:{playerID}              |
      | Live Stats   | live_stats:week:{week}         |
      | Final Stats  | final_stats:game:{gameID}      |
      | Schedule     | schedule:week:{week}           |
      | News         | news:latest or news:player:{id}|
      | Search       | search:{query}:filter:{value}  |
      | Injury       | injuries:week:{week}           |
    And keys are easily identifiable and queryable

  Scenario: Use namespacing for environment separation
    Given the system runs in multiple environments (dev, staging, prod)
    Then cache keys are prefixed with environment:
      | dev:player:14876     |
      | staging:player:14876 |
      | prod:player:14876    |
    And data isolation is maintained across environments

  # Cache Invalidation Strategies

  Scenario: Time-based cache invalidation with TTL
    Given data is cached with TTL
    When the TTL expires
    Then Redis automatically evicts the key
    And the next request triggers a cache miss
    And fresh data is fetched from API

  Scenario: Manual cache invalidation by key
    Given cached data needs immediate update
    When an admin triggers cache invalidation
    Then the system executes DEL command for specific key
    And the cache entry is removed
    And next request fetches fresh data

  Scenario: Pattern-based cache invalidation
    Given all week 15 caches need invalidation
    When an admin triggers bulk invalidation
    Then the system executes KEYS *week:15* to find matches
    And all matching keys are deleted
    And all week 15 data is refreshed

  Scenario: Invalidate cache on data update
    Given "Player X" data is cached
    When Player X is traded to a new team
    And the system receives the update
    Then the cache key "player:{playerX_id}" is deleted
    And fresh data with new team is fetched
    And cache is repopulated with updated info

  # Cache Warming

  Scenario: Warm cache before game day
    Given Sunday games start at 1:00 PM ET
    And the current time is Sunday 12:00 PM
    When the pre-game cache warming job runs
    Then the system pre-fetches:
      | Player profiles for all rostered players |
      | Schedule for current week                 |
      | Team rosters for teams playing today      |
    And all data is cached with appropriate TTLs
    And cache hit rates are maximized during games

  Scenario: Warm cache for popular players
    Given "Patrick Mahomes" is rostered by 80% of users
    When the daily cache warming job runs
    Then popular players are pre-cached
    And reduces API calls during peak traffic
    And improves response times for users

  # Cache Performance Monitoring

  Scenario: Track cache hit/miss ratios
    Given the system monitors cache performance
    When 100 requests are made
    And 85 requests hit cache
    And 15 requests miss cache
    Then the cache hit ratio is 85%
    And the cache miss ratio is 15%
    And metrics are logged for analysis

  Scenario: Alert on low cache hit rate
    Given the target cache hit rate is 80%
    When the cache hit rate drops below 60%
    Then an alert is triggered
    And ops team is notified
    And cache strategy is reviewed

  Scenario: Monitor cache memory usage
    Given Redis has 2 GB memory allocated
    When cache memory usage exceeds 1.6 GB (80%)
    Then a warning alert is triggered
    And old/unused keys are evicted
    And memory usage is brought back to safe levels

  # Cache Eviction Policies

  Scenario: Use LRU eviction policy for limited memory
    Given Redis is configured with maxmemory policy "allkeys-lru"
    When memory limit is reached
    Then Redis evicts least recently used keys
    And frequently accessed data remains cached
    And cache efficiency is maintained

  Scenario: Respect TTL-based eviction
    Given Redis is configured with maxmemory policy "volatile-ttl"
    When memory limit is reached
    Then keys with shortest TTL are evicted first
    And live game data (30s TTL) is evicted before player profiles (24h TTL)
    And critical data is preserved longer

  # Cache Consistency

  Scenario: Ensure cache consistency with database
    Given data is updated in the database
    When the update transaction commits
    Then the corresponding cache entry is invalidated
    And ensures cache doesn't serve stale data
    And next request fetches fresh data from database

  Scenario: Handle race condition on cache miss
    Given 2 concurrent requests miss cache simultaneously
    When both attempt to fetch from API
    Then only the first request makes the API call
    And the second request waits for the first to complete
    And both use the same cached result
    And API rate limits are protected

  # Cache Failover

  Scenario: Gracefully handle Redis unavailability
    Given Redis cache is unavailable (connection error)
    When a user requests data
    Then the system catches the Redis error
    And falls back to database query
    And data is returned without caching
    And error is logged for ops team
    And user experience is not impacted

  Scenario: Bypass cache on cache server errors
    Given Redis is responding with errors
    When cache operations fail repeatedly
    Then the system activates bypass mode
    And all requests go directly to database/API
    And caching is temporarily disabled
    When Redis health is restored
    Then caching is re-enabled automatically

  # Cache Compression

  Scenario: Compress large cache values
    Given player stats JSON is 50 KB
    When the data is cached in Redis
    Then the JSON is compressed using gzip
    And compressed size is ~10 KB (80% reduction)
    And memory usage is minimized
    When data is retrieved
    Then it is decompressed automatically
    And decompression overhead is negligible (< 1ms)

  Scenario: Skip compression for small values
    Given a cache value is 500 bytes
    When the data is cached
    Then compression is skipped (overhead not worth it)
    And data is stored as-is
    And minimizes CPU usage

  # Distributed Caching

  Scenario: Share cache across multiple application instances
    Given the system runs 3 application server instances
    And all connect to the same Redis instance
    When Instance A caches player data
    Then Instance B and C can access the same cached data
    And cache is shared across all instances
    And API calls are minimized globally

  Scenario: Handle cache stampede with distributed lock
    Given 100 concurrent requests miss cache simultaneously
    When all attempt to fetch from API
    Then a distributed lock (Redis SETNX) is acquired by the first request
    And only the first request calls the API
    And other requests wait for the lock to release
    When the first request completes and caches data
    Then the lock is released
    And all waiting requests retrieve from cache
    And only 1 API call is made instead of 100

  # Cache Analytics

  Scenario: Log cache access patterns
    Given the system logs all cache operations
    When a cache key is accessed
    Then the access is logged with timestamp
    And access frequency is tracked per key
    And popular keys are identified for optimization

  Scenario: Identify cache hot spots
    Given cache metrics are analyzed
    When certain keys are accessed 1000x/minute
    Then these keys are identified as hot spots
    And TTLs are optimized for these keys
    And cache warming strategies are adjusted

  Scenario: Analyze cache cost savings
    Given SportsData.io API costs $0.01 per call
    And the system makes 10,000 API calls/day without cache
    When caching is enabled with 85% hit rate
    Then API calls are reduced to 1,500/day
    And cost savings are $85/day ($31,025/year)
    And ROI metrics are tracked
