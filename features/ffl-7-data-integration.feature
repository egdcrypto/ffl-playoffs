Feature: Data Integration with External NFL Data Sources
  As the system
  I want to integrate with external NFL data sources
  So that I can provide accurate, real-time game data and scores

  Background:
    Given the system is configured with NFL data API credentials
    And the game "2025 NFL Playoffs Pool" is active
    And the league starts at NFL week 15 with 4 weeks
    And rate limiting is configured for external APIs
    And webhook endpoints are registered for real-time updates

  # =============================================================================
  # NFL SCHEDULE INTEGRATION - BASIC SYNC
  # =============================================================================

  Scenario: Fetch NFL game schedule for league weeks
    Given the league covers NFL weeks 15, 16, 17, 18
    When the system fetches the NFL schedule
    Then the schedule for weeks 15-18 should be retrieved
    And each game should include:
      | homeTeam         |
      | awayTeam         |
      | gameDateTime     |
      | venue            |
      | nflWeekNumber    |
    And schedules for weeks 1-14 should NOT be fetched
    And schedules for weeks beyond 18 should NOT be fetched

  Scenario: Update game schedules when NFL makes changes
    Given the NFL schedule was fetched yesterday
    And an NFL game in week 16 has been rescheduled
    When the system performs a schedule refresh
    Then the updated game date and time are retrieved
    And the GameResult entity is updated with new schedule
    And players are notified of the schedule change

  Scenario: Handle bye weeks in schedule
    Given the league includes NFL week 14
    And "Team A" has a bye week in week 14
    When the schedule is fetched for week 14
    Then "Team A" should be marked as having a bye
    And no game should be scheduled for "Team A"
    And players who selected "Team A" are notified

  # =============================================================================
  # SCHEDULE SYNC - COMPREHENSIVE SCENARIOS
  # =============================================================================

  Scenario: Initial schedule sync for new league
    Given a new league is created for weeks 15-18
    When the league is activated
    Then the system fetches schedules for all 4 weeks
    And all games are stored with status "SCHEDULED"
    And game times are stored in UTC
    And local time zone conversions are available
    And the sync timestamp is recorded

  Scenario: Incremental schedule sync detects changes
    Given the schedule was last synced 1 hour ago
    And the NFL has made schedule changes:
      | Game        | Change Type        | Details                    |
      | KC vs BUF   | Time change        | Moved from 1:00 to 4:25 PM |
      | DEN vs LV   | Venue change       | Moved to neutral site      |
      | NYG vs PHI  | Flex scheduled     | Moved to primetime         |
    When the incremental sync runs
    Then only changed games are updated
    And unchanged games are not modified
    And change audit records are created
    And affected users are notified

  Scenario: Handle schedule conflicts with roster locks
    Given a player has locked their roster for week 15
    And the NFL reschedules a week 15 game
    When the schedule change is detected
    Then the system evaluates if the change affects locked rosters
    And if kickoff is now earlier than lock time:
      | The roster remains locked                |
      | No changes are allowed                   |
    And if kickoff is now later than original:
      | The system logs the change               |
      | But does not unlock rosters              |

  Scenario: Sync schedule across multiple time zones
    Given the system serves users in multiple time zones
    When the NFL schedule is fetched
    Then all game times are stored in UTC
    And game times are converted for display:
      | Time Zone | Example Display           |
      | ET        | Sun, Dec 15 at 1:00 PM ET |
      | CT        | Sun, Dec 15 at 12:00 PM CT|
      | PT        | Sun, Dec 15 at 10:00 AM PT|
    And users see times in their local time zone

  Scenario: Handle international games time zones
    Given a London game is scheduled at 9:30 AM ET
    When the schedule is displayed
    Then UK users see 2:30 PM GMT
    And German users see 3:30 PM CET
    And the venue shows "Tottenham Hotspur Stadium, London"

  Scenario: Detect and handle duplicate game entries
    Given a schedule sync returns duplicate game entries
    When the system processes the data
    Then duplicates are identified by game ID
    And only one instance is stored
    And the duplicate is logged for investigation
    And data integrity is maintained

  Scenario: Schedule sync handles season transitions
    Given the current season is 2024
    And the new season (2025) schedule is released
    When the system detects new season data
    Then new season games are NOT automatically imported
    And admin approval is required for season transition
    And current season data remains unchanged

  Scenario: Schedule sync with postponed games
    Given a game is postponed due to weather
    When the schedule sync runs
    Then the game status changes to "POSTPONED"
    And the original date is preserved in history
    And a tentative new date may be provided
    And affected fantasy scoring is suspended
    And users are notified of the postponement

  Scenario: Validate schedule data completeness
    Given a schedule sync is complete
    When the system validates the data
    Then all weeks should have expected game count:
      | Week 15 | 16 games expected |
      | Week 16 | 16 games expected |
      | Week 17 | 16 games expected |
      | Week 18 | 16 games expected |
    And any missing games are flagged
    And admin alerts are sent for incomplete data

  # =============================================================================
  # LIVE GAME DATA SYNCHRONIZATION - BASIC
  # =============================================================================

  Scenario: Fetch live game scores during games
    Given NFL week 15 games are in progress
    And the data refresh interval is 2 minutes
    When the system fetches live game data
    Then current scores for all week 15 games are retrieved
    And the data includes:
      | homeTeamScore      |
      | awayTeamScore      |
      | quarter            |
      | timeRemaining      |
      | gameStatus         |
    And the data is refreshed every 2 minutes

  Scenario: Update player statistics in real-time
    Given player "john_player" selected "Kansas City Chiefs" for week 15
    And the "Kansas City Chiefs" game is in progress
    When live statistics are fetched
    Then the system retrieves:
      | passingYards     |
      | rushingYards     |
      | receivingYards   |
      | receptions       |
      | touchdowns       |
      | fieldGoals       |
      | defensiveStats   |
    And player scores are recalculated
    And the leaderboard is updated

  Scenario: Data sync respects league-specific NFL weeks
    Given league "Playoffs League" covers NFL weeks 15-18
    And league "Mid-Season League" covers NFL weeks 8-13
    When data synchronization runs
    Then "Playoffs League" fetches data only for weeks 15-18
    And "Mid-Season League" fetches data only for weeks 8-13
    And no overlap or unnecessary data is fetched

  # =============================================================================
  # LIVE STATS - COMPREHENSIVE SCENARIOS
  # =============================================================================

  Scenario: Fetch position-specific live statistics
    Given games are in progress
    When live stats are fetched for each position:
      | Position | Stats Retrieved                                        |
      | QB       | PassYds, PassTD, INT, RushYds, RushTD, Fumbles        |
      | RB       | RushYds, RushTD, Rec, RecYds, RecTD, Fumbles          |
      | WR       | Rec, Targets, RecYds, RecTD, RushYds, Fumbles         |
      | TE       | Rec, Targets, RecYds, RecTD, Fumbles                  |
      | K        | FGM, FGA, FG0-39, FG40-49, FG50+, XPM, XPA            |
      | DEF      | Sacks, INT, FR, Safety, DefTD, PtsAllowed, YdsAllowed |
    Then all stats are correctly attributed to players
    And fantasy points are calculated per position rules

  Scenario: Delta stat updates minimize data transfer
    Given the last stat fetch was 30 seconds ago
    And only 3 plays have occurred since then
    When a delta update is requested
    Then only changed stats are returned:
      | Player         | Changed Stat   | Previous | Current |
      | P. Mahomes     | PassingYards   | 150      | 172     |
      | T. Kelce       | Receptions     | 4        | 5       |
      | T. Kelce       | ReceivingYards | 45       | 58      |
    And unchanged stats are not included
    And bandwidth is optimized

  Scenario: Aggregate team stats from individual players
    Given the "Kansas City Chiefs" offense includes:
      | Player       | PassYds | RushYds | RecYds |
      | P. Mahomes   | 250     | 15      | 0      |
      | I. Pacheco   | 0       | 85      | 20     |
      | T. Kelce     | 0       | 0       | 78     |
    When team stats are calculated
    Then total team stats are:
      | Stat             | Value |
      | Total PassYds    | 250   |
      | Total RushYds    | 100   |
      | Total RecYds     | 98    |
      | Total Offense    | 448   |

  Scenario: Handle player substitutions during game
    Given "Starting QB" is replaced by "Backup QB" in Q3
    When stats are fetched
    Then both players' stats are tracked separately:
      | Player      | PassYds | PassTD |
      | Starting QB | 180     | 2      |
      | Backup QB   | 45      | 0      |
    And fantasy points are calculated for each player

  Scenario: Track special teams statistics
    Given a punt return touchdown occurs
    When live stats are fetched
    Then special teams stats are captured:
      | Stat Type           | Value |
      | Punt Return Yards   | 75    |
      | Punt Return TD      | 1     |
      | Kick Return Yards   | 0     |
    And the correct player receives fantasy credit

  Scenario: Handle stat corrections during live game
    Given "Player X" was credited with a 20-yard reception
    And the play is reviewed and reversed
    When the corrected stats are received
    Then the reception is removed
    And fantasy points are recalculated immediately
    And the leaderboard is updated
    And the correction is logged

  Scenario: Live stats include game context
    Given a game is in progress
    When live stats are fetched
    Then the response includes game context:
      | Field           | Example Value      |
      | quarter         | 3                  |
      | timeRemaining   | 7:45               |
      | possession      | KC                 |
      | downAndDistance | 2nd & 7            |
      | fieldPosition   | OPP 35             |
      | redZone         | false              |
    And context enables accurate UI display

  Scenario: Handle simultaneous games efficiently
    Given 8 games are in progress simultaneously
    When live stats are fetched
    Then a batch request retrieves all game stats
    And stats are distributed to correct games
    And database writes are batched
    And total fetch time is under 3 seconds

  Scenario: Live stats persistence for audit trail
    Given stats are being updated during a game
    When each stat update is processed
    Then a snapshot is saved with timestamp
    And the following audit data is recorded:
      | Field           | Description            |
      | timestamp       | When update received   |
      | source          | API endpoint used      |
      | gameId          | Associated game        |
      | playerStats     | Stats at this moment   |
      | calculatedScore | Fantasy points         |
    And audit data is retained for 90 days

  # =============================================================================
  # GAME RESULT FINALIZATION
  # =============================================================================

  Scenario: Finalize game results when games complete
    Given a game between "Buffalo Bills" and "Miami Dolphins" is in progress
    And the game clock reaches 0:00 in the 4th quarter
    When the game status changes to "FINAL"
    Then the system fetches final statistics
    And the GameResult is marked as FINAL
    And the win/loss status is recorded
    And elimination logic is triggered
    And final scores are calculated

  Scenario: Handle overtime games
    Given a game is tied at the end of regulation
    When the game goes into overtime
    Then the system continues fetching live data
    And the game status is "OVERTIME"
    When overtime completes
    Then final statistics include overtime performance
    And the winner is determined correctly

  Scenario: Capture detailed field goal data for scoring
    Given a game includes field goal attempts
    When game statistics are fetched
    Then each field goal should include:
      | distance        |
      | made/missed     |
      | quarter         |
      | kicker          |
    And field goals are categorized by distance:
      | 0-39 yards      |
      | 40-49 yards     |
      | 50+ yards       |
    And the correct points are awarded based on league configuration

  Scenario: Finalization triggers downstream processing
    Given a game has just been marked FINAL
    When the finalization process runs
    Then the following are triggered in order:
      | Step | Action                           |
      | 1    | Final stats are persisted        |
      | 2    | Fantasy scores are calculated    |
      | 3    | Leaderboard is updated           |
      | 4    | Elimination check is performed   |
      | 5    | Notifications are sent           |
      | 6    | Week summary is updated          |
    And all steps complete within 30 seconds

  Scenario: Handle game result disputes
    Given a game has been marked FINAL
    And a scoring dispute is filed
    When an admin reviews the dispute
    Then the game can be marked "UNDER_REVIEW"
    And fantasy scoring is suspended
    When the review is complete
    Then the game returns to FINAL status
    And any corrections are applied

  # =============================================================================
  # DEFENSIVE STATISTICS INTEGRATION
  # =============================================================================

  Scenario: Fetch comprehensive defensive statistics
    Given a game has completed
    When defensive statistics are fetched
    Then the system retrieves:
      | sacks                    |
      | interceptions            |
      | fumbleRecoveries         |
      | safeties                 |
      | defensiveTouchdowns      |
      | pointsAllowed            |
      | totalYardsAllowed        |
      | passingYardsAllowed      |
      | rushingYardsAllowed      |
    And statistics are broken down by team

  Scenario: Calculate points allowed tiers from game data
    Given the "Pittsburgh Steelers" allowed 10 points in their game
    And the league has standard points allowed tiers configured
    When defensive scoring is calculated
    Then the "Pittsburgh Steelers" defense receives 7 fantasy points for points allowed (1-6 tier)

  Scenario: Calculate yards allowed tiers from game data
    Given the "New England Patriots" allowed 285 total yards
    And the league has standard yards allowed tiers configured
    When defensive scoring is calculated
    Then the "New England Patriots" defense receives 5 fantasy points for yards allowed (200-299 tier)

  Scenario: Track individual defensive player stats
    Given the league scores individual defensive players
    When defensive stats are fetched
    Then individual player stats include:
      | Stat Type       | Players Credited      |
      | Sacks           | Individual defenders  |
      | Interceptions   | Intercepting player   |
      | Fumble Recovery | Recovering player     |
      | Defensive TD    | Scoring player        |
    And team defense aggregates all individual stats

  # =============================================================================
  # RATE LIMITING - BASIC
  # =============================================================================

  Scenario: Handle API rate limiting
    Given the NFL data API has a rate limit of 100 requests per minute
    When the system approaches the rate limit
    Then requests are queued and throttled
    And the system ensures it stays within limits
    And critical data (live scores) is prioritized

  # =============================================================================
  # RATE LIMITING - COMPREHENSIVE SCENARIOS
  # =============================================================================

  Scenario: Token bucket rate limiting
    Given the API allows 100 requests per minute
    And the token bucket starts full
    When requests are made:
      | Time    | Requests | Bucket After |
      | 0:00    | 50       | 50 tokens    |
      | 0:30    | 30       | 70 tokens    |
      | 1:00    | 40       | 80 tokens    |
    Then tokens regenerate at 100/minute
    And excess requests are queued
    And no requests are dropped

  Scenario: Sliding window rate limiting
    Given the API uses sliding window rate limiting
    And the limit is 1000 requests per hour
    When the system tracks requests in 1-minute windows
    Then the total across all windows is monitored
    And old windows expire after 60 minutes
    And the rate limit is evenly distributed

  Scenario: Priority queue for rate-limited requests
    Given rate limiting is active
    And the request queue has mixed priority:
      | Priority | Request Type           |
      | HIGH     | Live score updates     |
      | MEDIUM   | Schedule refreshes     |
      | LOW      | Historical data        |
    When tokens are available
    Then HIGH priority requests are processed first
    And LOW priority waits until capacity exists
    And no request waits more than 5 minutes

  Scenario: Dynamic rate limit adjustment
    Given the system monitors API response headers
    When the API returns rate limit headers:
      | Header                | Value |
      | X-RateLimit-Limit     | 100   |
      | X-RateLimit-Remaining | 25    |
      | X-RateLimit-Reset     | 1705000000 |
    Then the system adjusts its request rate
    And requests are throttled to avoid hitting limit
    And the reset time is respected

  Scenario: Exponential backoff after rate limit hit
    Given the system receives a 429 Too Many Requests response
    When retry attempts are made:
      | Attempt | Wait Time   |
      | 1       | 1 second    |
      | 2       | 2 seconds   |
      | 3       | 4 seconds   |
      | 4       | 8 seconds   |
      | 5       | 16 seconds  |
    Then requests are retried with exponential backoff
    And a maximum of 5 retries is attempted
    And jitter is added to prevent thundering herd

  Scenario: Rate limit per endpoint
    Given different endpoints have different limits:
      | Endpoint           | Limit          |
      | /live-scores       | 60/minute      |
      | /schedules         | 10/minute      |
      | /player-stats      | 30/minute      |
      | /team-info         | 5/minute       |
    When requests are made to each endpoint
    Then each endpoint's limit is tracked separately
    And hitting one limit doesn't affect others

  Scenario: Rate limit circuit breaker
    Given the system has hit rate limits 5 times in 10 minutes
    When the circuit breaker evaluates
    Then the circuit opens (blocks requests)
    And the system waits for a cooldown period
    And a test request is made after 1 minute
    If the test succeeds
    Then the circuit closes (resumes normal)
    Else the circuit remains open

  Scenario: Aggregate rate limits across services
    Given multiple services call the same external API
    When a distributed rate limiter is used
    Then all services share the same token bucket
    And no single service can exhaust the limit
    And fair distribution is maintained

  Scenario: Rate limit monitoring and alerting
    Given rate limiting is active
    When utilization reaches thresholds:
      | Threshold | Alert Type    |
      | 80%       | Warning       |
      | 90%       | High Priority |
      | 100%      | Critical      |
    Then appropriate alerts are sent
    And metrics are recorded for analysis
    And dashboards show real-time utilization

  # =============================================================================
  # ERROR HANDLING AND RELIABILITY - BASIC
  # =============================================================================

  Scenario: Handle API timeout gracefully
    Given the NFL data API is experiencing delays
    When a data fetch request times out after 30 seconds
    Then the system logs the timeout error
    And the system retries the request after 5 minutes
    And the system uses cached data if available
    And admins are notified if timeout persists

  Scenario: Handle missing or incomplete data
    Given the NFL data API returns incomplete statistics
    And passing yards are missing for a game
    When the system processes the data
    Then the system marks the score as "PENDING"
    And the system retries fetching after 15 minutes
    And players are notified of the delay

  Scenario: Fallback to secondary data source
    Given the primary NFL data API is unavailable
    And a secondary data source is configured
    When the system detects primary source failure
    Then the system switches to the secondary source
    And data fetching continues without interruption
    And admins are notified of the switch

  # =============================================================================
  # ERROR HANDLING - COMPREHENSIVE SCENARIOS
  # =============================================================================

  Scenario: Circuit breaker pattern for API failures
    Given the system uses a circuit breaker
    When the failure threshold is reached:
      | State   | Condition                   | Action                    |
      | CLOSED  | Normal operation            | Allow all requests        |
      | OPEN    | 5 failures in 1 minute      | Block all requests        |
      | HALF    | After 30 second timeout     | Allow test request        |
    Then the circuit breaker transitions appropriately
    And requests fail fast when circuit is open
    And recovery is automatic when API recovers

  Scenario: Retry policy with idempotency
    Given a data fetch request fails
    When the system retries
    Then the request includes idempotency key
    And duplicate processing is prevented
    And the retry is safe for non-idempotent operations
    And the original request ID is preserved for tracing

  Scenario: Fallback data strategies
    Given the primary data source is unavailable
    When fallback is activated:
      | Priority | Fallback Source           | Freshness      |
      | 1        | Local cache               | 5 minutes      |
      | 2        | Secondary API             | Real-time      |
      | 3        | Database snapshot         | Last sync      |
      | 4        | Static backup             | Last known     |
    Then the highest priority available source is used
    And users are informed of data freshness

  Scenario: Partial failure handling
    Given a batch request for 10 games
    And 2 games fail to fetch
    When the system processes the response
    Then the 8 successful games are updated
    And the 2 failed games are marked for retry
    And partial success is logged
    And users see available data

  Scenario: Data reconciliation after outage
    Given the data source was unavailable for 30 minutes
    And games were in progress during the outage
    When connectivity is restored
    Then a full reconciliation is triggered
    And all game stats are verified
    And any discrepancies are resolved
    And fantasy scores are recalculated
    And audit logs capture the reconciliation

  Scenario: Handle malformed API responses
    Given the API returns malformed JSON
    When the system attempts to parse the response
    Then a parsing error is caught
    And the raw response is logged for debugging
    And the system retries the request
    And an alert is sent for investigation

  Scenario: Handle unexpected API response structure
    Given the API changes its response format
    When a field is missing or renamed
    Then the system logs the schema mismatch
    And available fields are still processed
    And missing fields use default values
    And admin is alerted to update integration

  Scenario: Graceful degradation during failures
    Given the data integration is experiencing issues
    When the system operates in degraded mode:
      | Component         | Behavior                      |
      | Live scores       | Show cached with timestamp    |
      | Schedule          | Show last known schedule      |
      | Leaderboard       | Display with "updating" badge |
      | Score calculation | Use last known stats          |
    Then users can still access the application
    And degraded status is clearly communicated

  Scenario: Error categorization and handling
    Given different error types occur:
      | Error Type        | HTTP Code | Retry | Alert   |
      | Rate Limit        | 429       | Yes   | Warning |
      | Server Error      | 500       | Yes   | Error   |
      | Not Found         | 404       | No    | Debug   |
      | Unauthorized      | 401       | No    | Critical|
      | Bad Request       | 400       | No    | Error   |
    When each error is encountered
    Then the appropriate handling is applied
    And retries only occur for retriable errors

  Scenario: Error budget tracking
    Given the system has an error budget of 0.1%
    When errors occur
    Then the error rate is calculated
    And if error rate exceeds budget:
      | Action                              |
      | Reduce request rate                 |
      | Enable additional fallbacks         |
      | Send critical alerts                |
    And error budget status is visible in dashboard

  Scenario: Dead letter queue for failed requests
    Given a request fails all retry attempts
    When the request cannot be processed
    Then it is placed in a dead letter queue
    And the request is logged with full context
    And admin can manually retry or dismiss
    And metrics track DLQ size

  # =============================================================================
  # DATA VALIDATION
  # =============================================================================

  Scenario: Validate fetched data for consistency
    Given game data is fetched from the API
    When the system processes the data
    Then the system validates:
      | Scores are non-negative         |
      | Team names match expected values|
      | Game status is valid enum       |
      | Statistics are within reasonable ranges |
    And invalid data is rejected
    And errors are logged for review

  Scenario: Detect and handle stat corrections
    Given final game statistics were imported yesterday
    And the NFL issues a stat correction today
    When the system detects the correction
    Then the GameResult is updated with corrected stats
    And player scores are recalculated
    And the leaderboard is updated
    And affected players are notified

  Scenario: Validate stat values within reasonable ranges
    Given stats are received from the API
    When the system validates each stat:
      | Stat           | Min  | Max  | Action if Invalid    |
      | PassingYards   | -20  | 700  | Log and cap          |
      | RushingYards   | -20  | 350  | Log and cap          |
      | Receptions     | 0    | 25   | Log and cap          |
      | Touchdowns     | 0    | 6    | Log and cap          |
      | FieldGoals     | 0    | 8    | Log and cap          |
    Then values outside ranges are flagged
    And reasonable defaults are applied
    And alerts are sent for review

  Scenario: Cross-validate stats between sources
    Given stats are available from multiple sources
    When the system compares values:
      | Source A   | Source B   | Difference | Action      |
      | 250 yards  | 252 yards  | 2          | Use average |
      | 3 TD       | 3 TD       | 0          | Consistent  |
      | 5 INT      | 2 INT      | 3          | Flag review |
    Then minor differences are reconciled automatically
    And major differences require manual review

  # =============================================================================
  # NEAR REAL-TIME SYNCHRONIZATION
  # =============================================================================

  Scenario: Configure data refresh intervals
    Given the admin configures data refresh settings
    When the admin sets live game refresh to 90 seconds
    And sets completed game refresh to 5 minutes
    Then the system uses 90-second intervals for in-progress games
    And uses 5-minute intervals to check for stat corrections

  Scenario: Adaptive refresh based on game status
    Given a game is scheduled to start at 1:00 PM ET
    And the current time is 11:00 AM ET
    When the system checks game status
    Then the refresh interval is 30 minutes (pre-game)
    When the game starts
    Then the refresh interval changes to 90 seconds (live)
    When the game ends
    Then the refresh interval changes to 5 minutes (post-game)
    After 24 hours
    Then the refresh stops (final)

  Scenario: Coordinate sync across multiple data types
    Given multiple data types need synchronization
    When the sync scheduler runs:
      | Data Type      | Priority | Interval    |
      | Live scores    | 1        | 30 seconds  |
      | Player stats   | 2        | 60 seconds  |
      | Game status    | 3        | 60 seconds  |
      | Schedule       | 4        | 15 minutes  |
      | Team standings | 5        | 1 hour      |
    Then syncs are staggered to avoid rate limits
    And higher priority items are synced first

  # =============================================================================
  # WEBHOOK UPDATES - BASIC
  # =============================================================================

  Scenario: Receive real-time updates via webhook
    Given the NFL data provider supports webhooks
    And the system is configured to receive webhook events
    When a game score changes
    Then the data provider sends a webhook notification
    And the system processes the update immediately
    And player scores are updated without polling delay

  Scenario: Validate webhook authenticity
    Given a webhook is received from an external source
    When the system processes the webhook
    Then the system validates the signature
    And the system verifies the sender is the NFL data provider
    And only authenticated webhooks are processed
    And unauthorized webhooks are rejected and logged

  # =============================================================================
  # WEBHOOK UPDATES - COMPREHENSIVE SCENARIOS
  # =============================================================================

  Scenario: Register webhook endpoints
    Given the system is configured for webhooks
    When the webhook registration is initiated
    Then the following endpoints are registered:
      | Endpoint                    | Event Types                    |
      | /webhooks/scores            | score.updated, score.final     |
      | /webhooks/schedule          | game.scheduled, game.changed   |
      | /webhooks/status            | game.started, game.ended       |
      | /webhooks/stats             | stats.updated, stats.corrected |
    And the provider acknowledges registration
    And endpoint health is monitored

  Scenario: Handle different webhook event types
    Given webhooks are configured
    When the following events are received:
      | Event Type       | Payload Example                | Action                        |
      | score.updated    | {game: "KC-BUF", home: 14}     | Update live scores            |
      | game.started     | {game: "KC-BUF", status: LIVE} | Begin live tracking           |
      | game.ended       | {game: "KC-BUF", status: FINAL}| Finalize game                 |
      | stats.corrected  | {player: "Mahomes", stat: INT} | Recalculate scores            |
      | schedule.changed | {game: "DEN-LV", newTime: ...} | Update schedule               |
    Then each event type is processed by its handler
    And appropriate downstream actions are triggered

  Scenario: Webhook message ordering
    Given multiple webhooks arrive for the same game
    When events arrive out of order:
      | Arrival Order | Sequence Number | Event           |
      | 1             | 3               | Q2 score        |
      | 2             | 1               | Game start      |
      | 3             | 2               | Q1 score        |
    Then events are reordered by sequence number
    And processed in correct chronological order
    And late events wait for missing predecessors
    And timeout occurs after 30 seconds of waiting

  Scenario: Webhook idempotency
    Given the same webhook is delivered twice
    When both deliveries are received:
      | Delivery | Idempotency Key       | Processing       |
      | 1        | evt_12345             | Processed        |
      | 2        | evt_12345             | Skipped          |
    Then duplicate webhooks are identified by key
    And only the first delivery is processed
    And duplicates are logged for monitoring

  Scenario: Webhook acknowledgment and retry
    Given a webhook is received
    When the system processes the webhook:
      | Processing Result | HTTP Response | Provider Action    |
      | Success           | 200 OK        | Mark delivered     |
      | Failure           | 500 Error     | Retry after 60s    |
      | Timeout           | No response   | Retry after 120s   |
    Then successful webhooks are acknowledged immediately
    And failures trigger provider retries
    And the provider stops after 5 failed attempts

  Scenario: Webhook payload validation
    Given a webhook is received
    When the payload is validated:
      | Check               | Valid                  | Invalid Action      |
      | JSON structure      | Well-formed            | Reject with 400     |
      | Required fields     | Present                | Reject with 400     |
      | Field types         | Correct types          | Reject with 400     |
      | Timestamp           | Within 5 minutes       | Log warning         |
      | Signature           | Matches                | Reject with 401     |
    Then invalid webhooks are rejected
    And valid webhooks are processed
    And validation errors are logged

  Scenario: Webhook signature verification
    Given a webhook arrives with signature header
    When the signature is verified:
      | Step | Action                                    |
      | 1    | Extract signature from X-Webhook-Signature|
      | 2    | Compute HMAC-SHA256 of payload           |
      | 3    | Compare computed vs provided signature    |
    Then matching signatures allow processing
    And mismatched signatures are rejected with 401
    And failed verifications are logged as security events

  Scenario: Webhook rate limiting
    Given the system receives many webhooks rapidly
    When the rate exceeds 100 webhooks per second
    Then excess webhooks are queued
    And processing continues at sustainable rate
    And the provider is notified via 429 response
    And high-priority events are processed first

  Scenario: Webhook failure notification
    Given webhook processing fails repeatedly
    When the failure threshold is reached:
      | Consecutive Failures | Action                     |
      | 3                    | Alert sent to ops          |
      | 10                   | Circuit breaker activated  |
      | 25                   | Webhook endpoint disabled  |
    Then administrators are notified
    And the system falls back to polling
    And manual intervention is required to re-enable

  Scenario: Webhook replay for missed events
    Given the system was offline for 15 minutes
    When the system comes back online
    Then the provider is queried for missed events
    And events from the downtime window are retrieved
    And events are processed in sequence order
    And the system catches up to real-time

  Scenario: Webhook event persistence
    Given a webhook is received
    When the event is processed
    Then the raw event is persisted:
      | Field           | Description                 |
      | eventId         | Unique event identifier     |
      | receivedAt      | When webhook was received   |
      | payload         | Full webhook payload        |
      | processingState | RECEIVED, PROCESSED, FAILED |
      | processingTime  | How long processing took    |
    And events are retained for 30 days
    And events can be replayed for debugging

  Scenario: Webhook dead letter handling
    Given a webhook cannot be processed after all retries
    When the webhook is moved to dead letter
    Then the event is preserved with full context
    And admin notification is sent
    And the event can be manually processed
    And root cause can be investigated

  # =============================================================================
  # HISTORICAL DATA IMPORT
  # =============================================================================

  Scenario: Import historical game data for completed weeks
    Given a new league is created mid-season
    And the league starts at NFL week 15
    And NFL weeks 1-14 have already completed
    When the league is activated
    Then the system does NOT import weeks 1-14 data
    And only data for weeks 15-18 is monitored

  Scenario: Backfill data for postponed games
    Given a game was postponed from week 15 to week 16
    And week 15 scoring was calculated without the postponed game
    When the postponed game is played in week 16
    Then the system fetches the game results
    And week 15 scores are recalculated
    And affected players' scores are updated
    And the leaderboard is updated retroactively

  # =============================================================================
  # TEAM AND PLAYER DATA
  # =============================================================================

  Scenario: Fetch NFL team information
    Given the system needs to populate team data
    When the system fetches team information
    Then all 32 NFL teams are retrieved
    And each team includes:
      | teamName         |
      | abbreviation     |
      | city             |
      | conference       |
      | division         |
      | logoUrl          |
    And team data is cached for the season
    And no pagination is needed (only 32 teams)

  Scenario: Update team records and standings
    Given the season is in progress
    When the system fetches team standings
    Then each team's record is updated:
      | wins             |
      | losses           |
      | ties             |
      | winPercentage    |
    And standings are displayed to players for team selection

  Scenario: Sync player roster changes
    Given a player is traded between teams
    When the roster change is detected
    Then the player's team affiliation is updated
    And fantasy rosters are notified of the change
    And the change is effective for future games only

  Scenario: Handle injured reserve updates
    Given a player is placed on IR
    When the roster status is updated
    Then the player is marked as "OUT"
    And fantasy managers are notified
    And the player can be dropped without penalty

  # =============================================================================
  # PAGINATION FOR DATA RETRIEVAL
  # =============================================================================

  Scenario: Paginate NFL team list with default page size
    Given there are 32 NFL teams in the system
    When the client requests the team list without pagination parameters
    Then the response includes 20 teams (default page size)
    And the response includes pagination metadata:
      | page           | 0              |
      | size           | 20             |
      | totalElements  | 32             |
      | totalPages     | 2              |
      | hasNext        | true           |
      | hasPrevious    | false          |

  Scenario: Request specific page of NFL teams
    Given there are 32 NFL teams in the system
    When the client requests page 1 with size 10
    Then the response includes teams 11-20
    And the pagination metadata shows:
      | page           | 1              |
      | size           | 10             |
      | totalElements  | 32             |
      | totalPages     | 4              |
      | hasNext        | true           |
      | hasPrevious    | true           |

  Scenario: Configure custom page size
    Given the client wants to see more items per page
    When the client requests page 0 with size 50
    Then the response includes all 32 teams
    And the pagination metadata shows:
      | page           | 0              |
      | size           | 50             |
      | totalElements  | 32             |
      | totalPages     | 1              |
      | hasNext        | false          |
      | hasPrevious    | false          |

  Scenario: Paginate game results for a league week
    Given NFL week 15 has 16 games scheduled
    When the client requests game results with page size 5
    Then page 0 contains games 1-5
    And page 1 contains games 6-10
    And page 2 contains games 11-15
    And page 3 contains game 16
    And each response includes total count of 16

  Scenario: Paginate leaderboard with many players
    Given a league has 100 players
    When the client requests the leaderboard with page size 25
    Then page 0 shows ranks 1-25
    And page 1 shows ranks 26-50
    And page 2 shows ranks 51-75
    And page 3 shows ranks 76-100
    And pagination links are provided for next/previous pages

  Scenario: Request page beyond available data
    Given there are 32 NFL teams
    When the client requests page 10 with size 20
    Then the response returns an empty list
    And the pagination metadata shows:
      | page           | 10             |
      | size           | 20             |
      | totalElements  | 32             |
      | totalPages     | 2              |
      | hasNext        | false          |
      | hasPrevious    | true           |

  Scenario: Pagination with filtering
    Given there are 32 NFL teams
    And the client filters by conference "AFC"
    When the client requests page 0 with size 10
    Then the response includes 10 AFC teams
    And the pagination metadata reflects filtered total:
      | totalElements  | 16 (AFC teams) |
      | totalPages     | 2              |

  Scenario: Pagination includes navigation links
    Given a paginated API response for teams
    When the client is on page 1 of 4
    Then the response includes navigation links:
      | first    | /api/v1/teams?page=0&size=10       |
      | previous | /api/v1/teams?page=0&size=10       |
      | self     | /api/v1/teams?page=1&size=10       |
      | next     | /api/v1/teams?page=2&size=10       |
      | last     | /api/v1/teams?page=3&size=10       |

  Scenario: Validate page size limits
    Given the system has a maximum page size of 100
    When the client requests a page size of 200
    Then the request is rejected with error "MAX_PAGE_SIZE_EXCEEDED"
    And the error message suggests "Maximum page size is 100"

  Scenario: Paginate with sorting
    Given a list of NFL teams
    When the client requests teams sorted by "winPercentage" descending with page size 10
    Then page 0 shows the top 10 teams by win percentage
    And page 1 shows teams ranked 11-20
    And pagination metadata includes sort information:
      | sort | winPercentage,desc |

  # =============================================================================
  # DATA MONITORING AND HEALTH
  # =============================================================================

  Scenario: Monitor data integration health
    Given the system has data health monitoring enabled
    When data fetches are successful
    Then the health status is "HEALTHY"
    And the last successful sync timestamp is recorded
    When 3 consecutive data fetches fail
    Then the health status changes to "DEGRADED"
    And admins receive an alert
    When 10 consecutive fetches fail
    Then the health status changes to "CRITICAL"
    And critical alerts are sent

  Scenario: View data integration statistics
    Given the admin requests integration statistics
    Then the admin should see:
      | totalAPIRequests         | 1,523           |
      | successfulRequests       | 1,518           |
      | failedRequests           | 5               |
      | averageResponseTime      | 245ms           |
      | lastSyncTimestamp        | 2025-01-05 14:23|
      | dataFreshness            | 2 minutes       |
      | uptime                   | 99.7%           |

  Scenario: Track data source availability
    Given multiple data sources are configured
    When availability is monitored:
      | Source      | Status  | Uptime   | Last Check     |
      | Primary API | HEALTHY | 99.9%    | 30 seconds ago |
      | Secondary   | HEALTHY | 99.5%    | 1 minute ago   |
      | Cache       | HEALTHY | 100%     | 10 seconds ago |
    Then administrators see real-time status
    And historical uptime trends are available

  Scenario: Data freshness alerting
    Given data freshness thresholds are configured:
      | Data Type    | Max Age    | Alert Level |
      | Live scores  | 5 minutes  | Critical    |
      | Player stats | 10 minutes | High        |
      | Schedule     | 1 hour     | Medium      |
    When data exceeds the freshness threshold
    Then the appropriate alert is triggered
    And stale data is flagged in the UI

  Scenario: Integration performance monitoring
    Given performance monitoring is enabled
    When API calls are made
    Then the following metrics are captured:
      | Metric                | Description              |
      | request_duration_ms   | Time to complete request |
      | request_size_bytes    | Payload size             |
      | response_size_bytes   | Response payload size    |
      | connection_time_ms    | Time to establish conn   |
      | dns_lookup_time_ms    | DNS resolution time      |
    And metrics are exported to monitoring system
    And dashboards show latency percentiles

  # =============================================================================
  # DATA CACHING
  # =============================================================================

  Scenario: Cache frequently accessed data
    Given data caching is enabled
    When the same data is requested multiple times:
      | Request | Source          | Latency |
      | 1       | API             | 250ms   |
      | 2       | Cache           | 5ms     |
      | 3       | Cache           | 5ms     |
    Then subsequent requests use cached data
    And cache hit rate is tracked
    And API calls are reduced

  Scenario: Cache invalidation on updates
    Given game data is cached
    When a webhook indicates data has changed
    Then the affected cache entries are invalidated
    And the next request fetches fresh data
    And the cache is repopulated
    And cache coherence is maintained

  Scenario: Cache TTL based on data type
    Given different data types have different TTLs:
      | Data Type      | TTL         |
      | Live scores    | 30 seconds  |
      | Final scores   | 24 hours    |
      | Schedule       | 1 hour      |
      | Team info      | 7 days      |
    When cache entries are created
    Then TTL is set per data type
    And expired entries are refreshed

  Scenario: Cache warming on startup
    Given the system is starting up
    When cache warming is configured
    Then critical data is pre-loaded:
      | Data                   | Priority |
      | Current week schedule  | 1        |
      | Team information       | 2        |
      | Active game statuses   | 3        |
    And the cache is ready before accepting requests

  # =============================================================================
  # MULTI-SOURCE DATA INTEGRATION
  # =============================================================================

  Scenario: Aggregate data from multiple sources
    Given multiple data sources are available:
      | Source      | Data Type        | Priority |
      | Primary API | All data         | 1        |
      | ESPN        | Scores only      | 2        |
      | NFL.com     | Schedule only    | 3        |
    When data is aggregated
    Then primary source is preferred
    And secondary sources fill gaps
    And conflicting data is reconciled

  Scenario: Source failover with data consistency
    Given the primary source fails
    When failover to secondary occurs
    Then data is validated for consistency
    And any discrepancies are logged
    And scores are only updated if consistent
    And admin is notified of failover

  Scenario: Compare data across sources for validation
    Given the same data is available from multiple sources
    When cross-validation runs
    Then discrepancies are identified:
      | Source A | Source B | Difference | Resolution    |
      | 21 pts   | 21 pts   | None       | Confirmed     |
      | 14 pts   | 17 pts   | 3 pts      | Manual review |
    And confirmed data is marked as validated
    And discrepancies require manual review
