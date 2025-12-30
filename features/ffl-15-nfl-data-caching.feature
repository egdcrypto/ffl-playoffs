Feature: NFL Data Caching Strategy with Redis
  As a system
  I want to cache NFL data with appropriate TTL strategies
  So that I minimize API calls and improve performance

  Background:
    Given the system is configured with Redis cache
    And Redis is running at localhost:6379
    And the system integrates with SportsData.io API

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

  # ============================================
  # ADVANCED TTL POLICIES
  # ============================================

  Scenario: Adaptive TTL based on data volatility
    Given the system monitors data change frequency
    When player data changes rarely (once per week)
    Then the TTL is extended to 48 hours
    When player data changes frequently (during active trade period)
    Then the TTL is reduced to 4 hours
    And TTL adapts automatically to data patterns

  Scenario: Sliding TTL on cache access
    Given player data is cached with 24-hour TTL
    And the initial TTL is set at 12:00 PM
    When a user accesses the cache at 6:00 PM
    Then the TTL is extended by 12 hours (sliding window)
    And frequently accessed data stays cached longer
    And infrequently accessed data expires normally

  Scenario: Staggered TTL to prevent cache stampede
    Given 1000 player profiles are cached simultaneously
    When setting TTLs
    Then TTLs are randomized within a window:
      | Base TTL     | 24 hours        |
      | Jitter Range | +/- 30 minutes  |
    And prevents all keys from expiring at once
    And distributes cache refresh load

  Scenario: Context-aware TTL based on game status
    Given a player is on a team playing today
    When their profile is cached
    Then the TTL is reduced to 1 hour during game day
    And stats may change during the game
    When the player's team has a bye week
    Then the TTL is extended to 48 hours
    And data is more stable

  Scenario: Tiered TTL based on data type freshness needs
    Given the system defines TTL tiers:
      | Tier      | TTL      | Data Types                        |
      | REALTIME  | 30s      | Live scores, in-game stats        |
      | FREQUENT  | 15min    | News, injury updates              |
      | STANDARD  | 1hour    | Schedule, team rosters            |
      | STABLE    | 24hours  | Player profiles, career stats     |
      | PERMANENT | none     | Historical data, final game stats |
    When data is cached
    Then the appropriate tier TTL is applied

  Scenario Outline: TTL policy by data category
    Given data of type <dataType> is cached
    When TTL policy is applied
    Then the TTL is <ttl>

    Examples:
      | dataType            | ttl       |
      | live_game_stats     | 30 seconds|
      | injury_report       | 1 hour    |
      | player_profile      | 24 hours  |
      | weekly_schedule     | 1 hour    |
      | news_feed           | 15 minutes|
      | search_results      | 1 hour    |
      | final_game_stats    | permanent |

  Scenario: TTL override for critical data refresh
    Given player data is cached with 24-hour TTL
    When a critical update is received (e.g., player traded)
    Then the TTL is overridden to 0 (immediate expiration)
    And fresh data is fetched on next request
    And cache reflects current state

  Scenario: Negative TTL for "do not cache" scenarios
    Given the system encounters an API error response
    When caching the error response
    Then a negative/zero TTL is used
    And the error is not cached
    And the next request retries the API

  # ============================================
  # ADVANCED CACHE WARMING STRATEGIES
  # ============================================

  Scenario: Lazy cache warming on first access
    Given player data is not cached
    When the first user requests player "Travis Kelce"
    Then data is fetched from API
    And the cache is populated (lazy loading)
    And subsequent users get cached data

  Scenario: Eager cache warming before peak traffic
    Given peak traffic occurs during Sunday NFL games (1 PM - 8 PM ET)
    When the time is 11:00 AM ET on Sunday
    Then the cache warming job triggers
    And pre-fetches all data likely to be requested:
      | All players on active rosters      |
      | Today's game schedules             |
      | Latest injury reports              |
      | Recent news articles               |
    And cache is fully warm before users arrive

  Scenario: Predictive cache warming based on user patterns
    Given historical data shows users check "Patrick Mahomes" most often
    When the daily cache warming job runs
    Then the top 100 most-requested players are pre-cached
    And cache hit rate for popular players is maximized

  Scenario: Progressive cache warming to avoid API rate limits
    Given 500 players need to be pre-cached
    And API rate limit is 100 requests per minute
    When cache warming runs
    Then players are fetched in batches of 50
    And 1-second delay between batches
    And warming completes in ~10 minutes
    And API rate limits are respected

  Scenario: Cache warming with priority queue
    Given cache warming needs to process multiple data types
    When the warming job runs
    Then data is prioritized:
      | Priority 1 | Live game schedules        |
      | Priority 2 | Starting lineups           |
      | Priority 3 | Popular player profiles    |
      | Priority 4 | Search indexes             |
    And most critical data is warmed first

  Scenario: Warm cache on service startup
    Given the application service restarts
    When the service completes startup
    Then a cache warming job is triggered
    And critical data is pre-fetched
    And service handles requests from warm cache

  Scenario: Warm cache on cache server recovery
    Given Redis was temporarily unavailable
    When Redis connection is restored
    Then a cache warming job is triggered
    And recently-expired keys are refreshed
    And cache hit rate recovers quickly

  Scenario: Delta cache warming after expiration
    Given cache contains 10,000 player profiles
    And 500 profiles expired in the last hour
    When delta warming runs
    Then only the 500 expired profiles are refreshed
    And unchanged profiles remain cached
    And warming is efficient

  Scenario: User-driven cache warming on roster changes
    Given a user adds "Tyreek Hill" to their roster
    When the roster change is saved
    Then the system pre-warms related data:
      | Tyreek Hill's player profile        |
      | Tyreek Hill's season stats          |
      | Miami Dolphins team schedule        |
    And the user's experience is optimized

  # ============================================
  # ADVANCED INVALIDATION PATTERNS
  # ============================================

  Scenario: Write-through caching pattern
    Given a player's status is updated to "Injured"
    When the update is written to the database
    Then the cache is updated simultaneously
    And both database and cache are consistent
    And no stale data is ever served

  Scenario: Write-behind (write-back) caching pattern
    Given high-frequency stats updates during a game
    When live stats are updated
    Then updates are written to cache immediately
    And database writes are batched every 5 seconds
    And write performance is optimized
    And eventual consistency is maintained

  Scenario: Cache-aside pattern for reads
    Given a read request for player data
    When the cache is checked first
    And cache miss occurs
    Then database is queried
    And result is stored in cache
    And application manages cache explicitly

  Scenario: Event-driven cache invalidation
    Given the system subscribes to data change events
    When a "PLAYER_TRADED" event is published
    Then the cache listener receives the event
    And the player's cache entry is invalidated
    And team roster caches are invalidated
    And invalidation is near-real-time

  Scenario: Cascading cache invalidation
    Given player "Patrick Mahomes" is on team "Chiefs"
    When Mahomes' profile is updated
    Then related caches are also invalidated:
      | player:14876              |
      | team:KC:roster            |
      | search:mahomes            |
      | fantasy:scores:week:15    |
    And all affected data is refreshed

  Scenario: Version-based cache invalidation
    Given cached data has version "v1.0"
    When the data schema changes to "v1.1"
    Then cache keys with "v1.0" are invalidated
    And new data uses "v1.1" format
    And backward compatibility is maintained

  Scenario: Tag-based cache invalidation
    Given cache entries are tagged:
      | Key              | Tags                    |
      | player:14876     | [player, chiefs, qb]    |
      | player:17642     | [player, chiefs, rb]    |
      | team:KC:roster   | [team, chiefs]          |
    When tag "chiefs" is invalidated
    Then all entries with tag "chiefs" are deleted
    And unrelated caches are unaffected

  Scenario: Conditional cache invalidation
    Given player data was cached 2 hours ago
    When checking if invalidation is needed
    Then the system compares:
      | Last modified time in API |
      | Last cached time          |
    And if API data is newer, cache is invalidated
    And avoids unnecessary API calls

  Scenario: Soft invalidation with stale-while-revalidate
    Given player data TTL expired 5 minutes ago
    When a user requests the player data
    Then the stale cached data is returned immediately
    And a background refresh is triggered
    And the cache is updated asynchronously
    And user gets fast response with slightly stale data

  Scenario: Purge entire cache namespace
    Given a critical issue requires full cache reset
    When an admin triggers namespace purge for "prod:*"
    Then all production cache keys are deleted
    And cache is completely cleared
    And a full warm-up is triggered

  # ============================================
  # REDIS CLUSTER AND HIGH AVAILABILITY
  # ============================================

  Scenario: Redis Cluster for horizontal scaling
    Given high traffic requires distributed caching
    When Redis Cluster is configured with 6 nodes:
      | Node 1 | Master 0-5460  |
      | Node 2 | Master 5461-10922 |
      | Node 3 | Master 10923-16383 |
      | Node 4 | Replica of Node 1 |
      | Node 5 | Replica of Node 2 |
      | Node 6 | Replica of Node 3 |
    Then cache keys are distributed across slots
    And reads/writes are load balanced
    And cluster handles node failures

  Scenario: Redis Sentinel for automatic failover
    Given Redis is configured with Sentinel monitoring
    When the master Redis node fails
    Then Sentinel detects the failure within 30 seconds
    And a replica is promoted to master
    And application connections are updated
    And cache operations continue with minimal disruption

  Scenario: Read from replica for improved performance
    Given Redis replication is configured
    When a cache read operation occurs
    Then read requests can be served from replicas
    And write requests go to master
    And read throughput is increased
    And master load is reduced

  Scenario: Handle Redis cluster slot migration
    Given a Redis cluster is rebalancing
    When cache operations occur during migration
    Then the client handles MOVED redirections
    And cache operations complete successfully
    And no data is lost during rebalancing

  # ============================================
  # CACHE SERIALIZATION
  # ============================================

  Scenario: JSON serialization for readability
    Given player data is a Java object
    When caching to Redis
    Then the object is serialized to JSON
    And JSON can be inspected via Redis CLI
    And debugging is simplified

  Scenario: Binary serialization for performance
    Given live stats require maximum performance
    When caching to Redis
    Then data is serialized using Protocol Buffers
    And serialization size is 50% smaller than JSON
    And serialization/deserialization is 10x faster

  Scenario: Handle serialization version mismatch
    Given cached data was serialized with version 1
    When the application is updated to version 2
    And schema is incompatible
    Then deserialization failure is caught
    And the old cache entry is invalidated
    And fresh data is fetched and cached with new schema

  Scenario: Serialize complex nested objects
    Given a player profile includes:
      | Basic info (name, team, position)  |
      | Season statistics (nested list)     |
      | Injury history (nested list)        |
      | News articles (nested list)         |
    When serializing to Redis
    Then all nested objects are properly serialized
    And deserialization reconstructs the full object
    And no data is lost

  # ============================================
  # CACHE SECURITY
  # ============================================

  Scenario: Encrypt sensitive cached data
    Given user roster selections contain sensitive information
    When caching user-specific data
    Then the data is encrypted using AES-256
    And the encryption key is stored in a secret manager
    And Redis stores only encrypted values

  Scenario: Redis AUTH for access control
    Given Redis is deployed in production
    When the application connects to Redis
    Then AUTH command is sent with password
    And unauthorized connections are rejected
    And cache data is protected

  Scenario: Redis ACL for fine-grained permissions
    Given multiple services access Redis
    When configuring access control lists:
      | User          | Permissions          |
      | api-service   | read, write all keys |
      | analytics     | read-only access     |
      | cache-warmer  | write-only access    |
    Then each service has appropriate permissions
    And principle of least privilege is enforced

  Scenario: TLS encryption for Redis connections
    Given Redis is accessed over a network
    When the application connects
    Then TLS 1.3 is used for encryption
    And data in transit is protected
    And certificates are validated

  Scenario: Prevent cache poisoning attacks
    Given external input is used in cache keys
    When a malicious user provides crafted input
    Then the input is sanitized before use in keys
    And key injection attacks are prevented
    And cache integrity is maintained

  # ============================================
  # CACHE TESTING AND DEBUGGING
  # ============================================

  Scenario: Unit test cache operations
    Given a cache service is implemented
    When unit tests are executed
    Then cache operations are tested with embedded Redis
    And tests are isolated and repeatable
    And cache logic is verified

  Scenario: Integration test with Redis Testcontainers
    Given integration tests require Redis
    When tests are executed
    Then a Redis container is started automatically
    And tests use a real Redis instance
    And the container is destroyed after tests

  Scenario: Debug cache contents via Redis CLI
    Given an issue requires cache inspection
    When an operator connects via redis-cli
    Then they can execute:
      | KEYS *player*           | List player cache keys    |
      | GET player:14876        | View cached data          |
      | TTL player:14876        | Check remaining TTL       |
      | DEBUG OBJECT player:*   | Inspect key metadata      |
    And troubleshooting is facilitated

  Scenario: Cache introspection API endpoint
    Given debugging cache issues in production
    When calling GET /admin/cache/stats
    Then response includes:
      | totalKeys         | 15,432       |
      | memoryUsed        | 1.2 GB       |
      | hitRate           | 87%          |
      | missRate          | 13%          |
      | avgResponseTime   | 2.5 ms       |
      | hotKeys           | [list]       |
    And operators can diagnose issues

  Scenario: Simulate cache failure for testing
    Given the system needs to test failover
    When cache failure simulation is triggered
    Then Redis connections are artificially blocked
    And the system falls back to database
    And metrics capture the failover behavior
    And resilience is validated

  # ============================================
  # CACHE PARTITIONING AND SHARDING
  # ============================================

  Scenario: Partition cache by data type
    Given different data types have different access patterns
    When organizing cache
    Then data is partitioned:
      | Partition 0 | Player profiles      |
      | Partition 1 | Game stats           |
      | Partition 2 | Search indexes       |
      | Partition 3 | User session data    |
    And partitions can be scaled independently

  Scenario: Shard cache by key hash
    Given consistent hashing is used
    When a cache key is accessed
    Then the key is hashed to determine shard
    And the appropriate Redis node is accessed
    And load is distributed evenly

  Scenario: Handle shard rebalancing
    Given a new Redis node is added to the cluster
    When rebalancing occurs
    Then minimal keys are migrated
    And cache operations continue during migration
    And no downtime occurs

  # ============================================
  # CACHE QUOTA AND LIMITS
  # ============================================

  Scenario: Enforce per-user cache quota
    Given users have cache quotas for personalized data
    When a user exceeds their quota (100 cached rosters)
    Then the oldest cached rosters are evicted
    And the user's quota is enforced
    And fair usage is maintained

  Scenario: Limit cache key size
    Given maximum key size is 512 bytes
    When a key exceeds the limit
    Then the key is truncated or hashed
    And Redis memory is protected
    And operations complete successfully

  Scenario: Limit cache value size
    Given maximum value size is 10 MB
    When a value exceeds the limit
    Then the data is split into chunks
    And chunks are stored with related keys
    And reconstruction is transparent to the application

  # ============================================
  # CACHE METRICS AND OBSERVABILITY
  # ============================================

  Scenario: Export cache metrics to Prometheus
    Given Prometheus monitoring is configured
    When the metrics endpoint is scraped
    Then the following metrics are exported:
      | cache_hits_total          |
      | cache_misses_total        |
      | cache_evictions_total     |
      | cache_size_bytes          |
      | cache_operation_duration  |
    And dashboards visualize cache health

  Scenario: Trace cache operations with distributed tracing
    Given distributed tracing is enabled
    When a cache operation occurs
    Then a span is created:
      | spanName         | redis.get              |
      | key              | player:14876           |
      | hit              | true                   |
      | durationMs       | 1.2                    |
    And cache operations are visible in traces

  Scenario: Log slow cache operations
    Given slow operation threshold is 100ms
    When a cache operation takes 250ms
    Then a warning log is generated:
      | level   | WARN                        |
      | message | Slow cache operation        |
      | key     | player:14876                |
      | latency | 250ms                       |
    And slow operations are investigated

  Scenario: Create cache performance dashboard
    Given Grafana dashboards are configured
    When viewing the cache dashboard
    Then the following panels are displayed:
      | Cache Hit Rate (%)           |
      | Cache Miss Rate (%)          |
      | Memory Usage                 |
      | Keys Count                   |
      | Latency Distribution         |
      | Top 10 Hot Keys              |
      | Eviction Rate                |
    And operators have full visibility

  # ============================================
  # EDGE CASES AND ERROR HANDLING
  # ============================================

  Scenario: Handle cache key collision
    Given two different data items produce the same cache key
    When both items are cached
    Then key collision is detected
    And a unique suffix is added to resolve collision
    And both items are cached correctly

  Scenario: Handle concurrent cache update race condition
    Given two requests update the same cache key simultaneously
    When both updates complete
    Then the last write wins
    And data is consistent
    And no corruption occurs

  Scenario: Handle cache corruption
    Given a cached value becomes corrupted
    When deserialization fails
    Then the corrupted entry is deleted
    And fresh data is fetched from source
    And an error is logged for investigation

  Scenario: Handle extremely large result sets
    Given a search returns 10,000 players
    When attempting to cache
    Then the result is paginated:
      | Page 0: players 1-100     |
      | Page 1: players 101-200   |
      | ...                       |
    And each page is cached separately
    And memory usage is controlled

  Scenario: Handle network partition to Redis
    Given a network partition occurs between app and Redis
    When cache operations timeout
    Then the circuit breaker opens
    And requests bypass cache for 30 seconds
    And database/API is used directly
    When network is restored
    Then circuit breaker closes
    And caching resumes normally

  Scenario Outline: Cache error handling by error type
    Given a cache operation encounters <errorType>
    When handling the error
    Then the response is <response>
    And the action taken is <action>

    Examples:
      | errorType            | response           | action                    |
      | ConnectionTimeout    | fallback to DB     | log warning, retry later  |
      | OutOfMemory          | cache bypass       | alert ops, evict keys     |
      | SerializationError   | delete key         | log error, refetch        |
      | AuthenticationError  | service failure    | alert critical, escalate  |
      | ClusterDown          | cache bypass       | alert critical, failover  |

  # ============================================
  # CACHE CONFIGURATION MANAGEMENT
  # ============================================

  Scenario: Dynamic TTL configuration
    Given TTL values are stored in configuration
    When an operator updates TTL for player profiles
    Then new cache entries use the updated TTL
    And existing entries retain their original TTL
    And no restart is required

  Scenario: Feature flag for caching
    Given caching is controlled by feature flags
    When the "player_cache_enabled" flag is disabled
    Then player data caching is bypassed
    And all requests go to database/API
    When the flag is enabled
    Then caching resumes normally

  Scenario: Environment-specific cache configuration
    Given different environments have different cache needs
    When configuring cache:
      | Environment | Redis URL              | Max Memory |
      | dev         | localhost:6379         | 256 MB     |
      | staging     | redis-staging:6379     | 1 GB       |
      | prod        | redis-cluster:6379     | 4 GB       |
    Then each environment uses appropriate configuration

  Scenario: A/B test cache strategies
    Given two caching strategies are being compared
    When users are split 50/50:
      | Group A | Standard TTL (24 hours)     |
      | Group B | Adaptive TTL (varies)       |
    Then metrics are collected for both groups
    And the better strategy is identified
    And the winner is rolled out globally
