# @ref: https://github.com/nflverse/nflreadpy
# @ref: docs/NFL_DATA_INTEGRATION_PROPOSAL.md
# @ref: docs/solutions/FFL-34-scheduled-nfl-data-sync-proposal.md
@backend @nfl-data @scheduled
Feature: Scheduled NFL Data Sync
  As the FFL Playoffs application
  I need to periodically sync NFL data from external sources
  So that users have up-to-date player stats, schedules, and scores

  Background:
    Given the NFL data sync service is configured
    And the external NFL data provider is available
    And sync metrics collection is enabled

  # ============================================================================
  # DAILY PLAYER DATA SYNC
  # ============================================================================

  @sync @players @daily
  Scenario: Sync NFL player roster data daily
    Given the player sync is scheduled to run daily at 6:00 AM ET
    When the scheduled sync job executes
    Then the system should fetch all NFL player profiles
    And store them in the local NFLPlayer collection
    And update existing players with new information
    And add any new players to the database
    And log the sync completion with player count
    And record sync duration metric

  @sync @players @daily
  Scenario: Handle new players added during season
    Given the local database has 1800 NFL players
    And the external source has 1805 NFL players
    When the player sync job executes
    Then 5 new players should be added to the database
    And existing player data should be updated
    And the sync log should show "5 players added, 1800 players updated"
    And new player events should be emitted

  @sync @players @daily
  Scenario: Handle player removed from roster
    Given player "John Smith" exists in local database
    And player "John Smith" is no longer on any NFL roster
    When the player sync job executes
    Then player "John Smith" status should be updated to "INACTIVE"
    And player should NOT be deleted (historical data preserved)
    And player should be excluded from fantasy availability
    And sync log should note "1 player marked inactive"

  @sync @players @incremental
  Scenario: Perform incremental player sync
    Given the last full player sync was 2 hours ago
    And the external API supports "If-Modified-Since" header
    When the incremental sync job executes
    Then only players modified in the last 2 hours are fetched
    And API data transfer is minimized
    And sync completes faster than full sync
    And last-modified timestamp is updated

  @sync @players @position-change
  Scenario: Handle player position change
    Given player "Taysom Hill" has position "QB" in local database
    And the external source shows position "TE"
    When the player sync job executes
    Then player position should be updated to "TE"
    And fantasy eligibility should be recalculated
    And position change event should be logged
    And affected roster selections should be flagged for review

  @sync @players @team-change
  Scenario: Handle player traded to new team
    Given player "DeAndre Hopkins" is on team "TEN"
    And the external source shows team "KC"
    When the player sync job executes
    Then player team should be updated to "KC"
    And bye week should be updated to KC's bye week
    And trade event should be logged with timestamp
    And fantasy owners should be notified

  @sync @players @injury-status
  Scenario: Sync player injury status updates
    Given player "Christian McCaffrey" has injury status "Healthy"
    And the external source shows injury status "Questionable"
    And injury body part is "Calf"
    When the player sync job executes
    Then injury status should be updated to "Questionable"
    And injury details should be stored
    And injury update event should be emitted
    And projected fantasy points should be adjusted

  @sync @players @rookie
  Scenario: Handle rookie players added mid-season
    Given the 2024 NFL Draft has concluded
    And undrafted free agents are signing with teams
    When the player sync job executes
    Then new rookie players should be added
    And rookie flag should be set for first-year players
    And college information should be populated
    And draft position should be recorded if applicable

  @sync @players @batch
  Scenario: Process players in batches for large datasets
    Given there are 2000+ NFL players to sync
    And batch size is configured as 100 players
    When the player sync job executes
    Then players should be processed in batches of 100
    And each batch should be committed separately
    And partial progress should be checkpointed
    And memory usage should remain stable

  # ============================================================================
  # WEEKLY SCHEDULE SYNC
  # ============================================================================

  @sync @schedules @weekly
  Scenario: Sync NFL game schedules weekly
    Given the schedule sync is configured to run every Monday at 4:00 AM ET
    When the scheduled sync job executes
    Then the system should fetch the current week's game schedule
    And store game matchups in the NFLGame collection
    And include game start times in ET timezone
    And include home and away teams for each game
    And include broadcast network information

  @sync @schedules @weekly
  Scenario: Sync full season schedule at start of season
    Given it is the week before NFL Week 1
    When the full season schedule sync executes
    Then all 18 weeks of regular season games should be fetched
    And all 272 regular season games should be stored
    And bye weeks should be calculated for each team
    And schedule sync status should show "FULL_SEASON_LOADED"

  @sync @schedules @time-change
  Scenario: Update schedule when NFL changes game times
    Given game "KC vs BUF" is scheduled for "Sunday 4:25 PM ET"
    And the NFL updates the game time to "Sunday 8:20 PM ET"
    When the schedule sync job executes
    Then the local game record should reflect the new time
    And affected league lock deadlines should be recalculated
    And a schedule change event should be logged
    And affected users should receive notification

  @sync @schedules @flex
  Scenario: Handle NFL flex scheduling
    Given game "DAL vs NYG" is scheduled for Week 15 Sunday 1:00 PM
    And the NFL flexes the game to Sunday Night Football
    When the schedule sync job executes
    Then game time should be updated to 8:20 PM ET
    And broadcast network should change to NBC
    And flex notification should be sent to users
    And roster lock times should be adjusted

  @sync @schedules @postponed
  Scenario: Handle postponed or rescheduled games
    Given game "BUF vs CLE" is scheduled for Sunday 1:00 PM
    And severe weather causes postponement to Monday 7:00 PM
    When the schedule sync job executes
    Then game time should be updated to Monday 7:00 PM
    And game status should show "RESCHEDULED"
    And reason should be recorded as "WEATHER"
    And fantasy scoring deadlines should be adjusted

  @sync @schedules @cancelled
  Scenario: Handle cancelled game
    Given a game is cancelled due to extraordinary circumstances
    When the schedule sync job executes
    Then game status should be updated to "CANCELLED"
    And players from both teams should receive 0 fantasy points
    And users should be notified of cancellation
    And alternative scoring rules should be applied if configured

  @sync @schedules @playoffs
  Scenario: Sync playoff schedule
    Given the regular season has concluded
    And playoff matchups are determined
    When the schedule sync job executes
    Then Wild Card round games should be added
    And Divisional round placeholders should be created
    And Conference Championship placeholders should be created
    And Super Bowl placeholder should be created
    And playoff schedule should be clearly marked

  @sync @schedules @bye-weeks
  Scenario: Calculate and store bye weeks
    When the full season schedule is synced
    Then bye week should be determined for each team:
      | Team | Bye Week |
      | KC   | 6        |
      | SF   | 9        |
      | PHI  | 5        |
      | DET  | 5        |
    And bye week should be denormalized to player records
    And fantasy projections should show 0 for bye weeks

  @sync @schedules @primetime
  Scenario: Identify primetime games
    When the schedule sync job executes
    Then primetime games should be flagged:
      | Game Type              | Day       | Time      | Network |
      | Thursday Night Football| Thursday  | 8:15 PM   | Prime   |
      | Sunday Night Football  | Sunday    | 8:20 PM   | NBC     |
      | Monday Night Football  | Monday    | 8:15 PM   | ESPN    |
    And primetime designation should affect roster lock timing

  # ============================================================================
  # LIVE SCORE SYNC
  # ============================================================================

  @sync @live-scores @active
  Scenario: Sync live scores during active games
    Given it is Sunday at 1:30 PM ET during NFL season
    And there are 8 games currently in progress
    When the live score sync job executes
    Then the system should fetch current scores for all active games
    And update the NFLGame collection with current scores
    And the sync should complete within 30 seconds
    And the next sync should be scheduled in 5 minutes

  @sync @live-scores @no-games
  Scenario: Skip live score sync when no games are active
    Given it is Tuesday at 10:00 AM ET
    And there are no NFL games in progress
    When the live score sync job is triggered
    Then the system should detect no active games
    And skip the score fetching to conserve API calls
    And log "No active games, skipping live score sync"
    And schedule next check for game start times

  @sync @live-scores @critical-moments
  Scenario: Increase sync frequency during game final minutes
    Given a game is in the 4th quarter with 2 minutes remaining
    When the live score sync evaluates the game status
    Then the sync interval should decrease to 1 minute
    And player stats should be fetched more frequently
    And the system should prepare for final score processing
    And WebSocket connections should receive priority updates

  @sync @live-scores @game-phases
  Scenario: Adjust sync based on game phase
    Then sync frequency should vary by game phase:
      | Phase            | Sync Interval | Priority |
      | Pre-game         | 15 minutes    | Low      |
      | 1st Quarter      | 5 minutes     | Medium   |
      | 2nd Quarter      | 5 minutes     | Medium   |
      | Halftime         | 10 minutes    | Low      |
      | 3rd Quarter      | 5 minutes     | Medium   |
      | 4th Quarter      | 2 minutes     | High     |
      | Overtime         | 1 minute      | Critical |
      | Final            | N/A (done)    | N/A      |
    And transitions between phases should be detected automatically

  @sync @live-scores @overtime
  Scenario: Handle overtime game scoring
    Given game "KC vs BUF" is tied 24-24 at end of regulation
    When overtime begins
    Then sync frequency should increase to 1 minute
    And overtime indicator should be set on game record
    And sudden death rules should be applied to scoring
    And game clock tracking should continue

  @sync @live-scores @scoring-plays
  Scenario: Track individual scoring plays
    Given a game is in progress
    When a touchdown is scored
    Then the scoring play should be recorded:
      | Field          | Value              |
      | Type           | TOUCHDOWN          |
      | Player         | Travis Kelce       |
      | Team           | KC                 |
      | Quarter        | 3                  |
      | Time           | 7:23               |
      | Points         | 6                  |
    And the scoring play should be available for play-by-play

  @sync @live-scores @weather-delay
  Scenario: Handle weather delay during game
    Given game "TB vs MIA" is in progress
    And lightning causes a weather delay
    When the sync detects game status "DELAYED"
    Then game status should be updated to "WEATHER_DELAY"
    And estimated resume time should be tracked if available
    And sync should continue at reduced frequency
    And users should be notified of delay

  @sync @live-scores @parallel
  Scenario: Process multiple concurrent games efficiently
    Given 14 NFL games are scheduled for Sunday 1:00 PM
    When the live score sync runs
    Then all 14 games should be fetched in parallel
    And results should be aggregated efficiently
    And sync should complete within 30 seconds
    And individual game failures should not block others

  @sync @live-scores @websocket
  Scenario: Push live updates via WebSocket
    Given users are connected via WebSocket for live scores
    When the live score sync completes
    Then updated scores should be pushed to connected clients
    And player stat updates should be pushed
    And fantasy point calculations should be pushed
    And latency should be under 2 seconds from sync completion

  # ============================================================================
  # PLAYER STATS SYNC
  # ============================================================================

  @sync @stats @post-game
  Scenario: Sync player stats after games complete
    Given the "LAR vs SEA" game has ended with final score
    When the post-game stats sync job executes
    Then the system should fetch final player statistics
    And update PlayerStats for all players in the game
    And calculate fantasy points based on scoring rules
    And trigger leaderboard recalculation for affected leagues

  @sync @stats @multi-format
  Scenario: Calculate fantasy points for multiple scoring formats
    Given player "Patrick Mahomes" has the following stats:
      | Stat              | Value |
      | Passing Yards     | 325   |
      | Passing TDs       | 3     |
      | Interceptions     | 1     |
      | Rushing Yards     | 28    |
    When fantasy points are calculated
    Then the points should be calculated for each scoring format:
      | Scoring Format | Expected Points |
      | Standard       | 23.3            |
      | Half PPR       | 23.3            |
      | Full PPR       | 23.3            |
    And all league leaderboards using each format should update

  @sync @stats @defensive
  Scenario: Sync team defense stats
    Given the "KC Defense" played against "LAC"
    When the post-game stats sync executes
    Then defensive stats should include:
      | Stat               | Value |
      | Points Allowed     | 17    |
      | Sacks              | 4     |
      | Interceptions      | 2     |
      | Fumbles Recovered  | 1     |
      | Defensive TDs      | 1     |
      | Safeties           | 0     |
    And defensive fantasy points should be calculated

  @sync @stats @kicker
  Scenario: Sync kicker stats
    Given kicker "Harrison Butker" played for KC
    When the post-game stats sync executes
    Then kicker stats should include:
      | Stat              | Value |
      | FG Made (0-39)    | 2     |
      | FG Made (40-49)   | 1     |
      | FG Made (50+)     | 1     |
      | FG Missed         | 0     |
      | XP Made           | 4     |
      | XP Missed         | 0     |
    And kicker fantasy points should be calculated correctly

  @sync @stats @idp
  Scenario: Sync individual defensive player stats
    Given linebacker "T.J. Watt" played for PIT
    When the post-game stats sync executes
    Then IDP stats should include:
      | Stat              | Value |
      | Solo Tackles      | 5     |
      | Assisted Tackles  | 3     |
      | Sacks             | 2.0   |
      | Tackles For Loss  | 3     |
      | QB Hits           | 4     |
      | Passes Defended   | 1     |
      | Forced Fumbles    | 1     |
      | Fumble Recoveries | 0     |
      | Interceptions     | 0     |
    And IDP fantasy points should be calculated

  @sync @stats @weekly-aggregation
  Scenario: Aggregate weekly stats for players
    Given it is the end of NFL Week 10
    And all games for Week 10 have completed
    When the weekly aggregation job runs
    Then season-to-date stats should be updated for all players
    And averages should be recalculated
    And rankings should be updated
    And historical data should be preserved

  # ============================================================================
  # STAT CORRECTIONS
  # ============================================================================

  @sync @corrections
  Scenario: Apply NFL official stat corrections
    Given the NFL releases official stat corrections on Wednesday
    And player "Joe Burrow" passing yards corrected from 287 to 291
    When the stat corrections sync job executes
    Then player stats should be updated with corrected values
    And fantasy points should be recalculated
    And affected league standings should be updated
    And correction audit log should be created

  @sync @corrections @timing
  Scenario: Schedule stat corrections sync
    Given stat corrections are typically released on Wednesdays
    Then the stat corrections sync should be scheduled:
      | Day       | Time      | Purpose                    |
      | Wednesday | 2:00 PM   | First pass corrections     |
      | Thursday  | 6:00 AM   | Final corrections          |
    And corrections should only affect the previous week's games
    And correction window should close after Thursday sync

  @sync @corrections @impact
  Scenario: Handle stat correction that changes game outcome
    Given league standings show Team A winning by 0.5 points
    And a stat correction adds 1 point to Team B
    When the correction is applied
    Then league standings should be recalculated
    And outcome should flip from Team A to Team B
    And notification should be sent to affected teams
    And correction impact should be clearly documented

  @sync @corrections @audit
  Scenario: Maintain audit trail for stat corrections
    Given a stat correction is applied
    Then an audit record should be created with:
      | Field          | Value                      |
      | Player         | Joe Burrow                 |
      | Week           | 10                         |
      | Stat           | PassingYards               |
      | OldValue       | 287                        |
      | NewValue       | 291                        |
      | PointsChange   | +0.16                      |
      | Timestamp      | 2024-11-13T14:30:00Z       |
      | Source         | NFL Official               |
    And audit trail should be queryable by admin

  @sync @corrections @notification
  Scenario: Notify users of stat corrections
    Given a stat correction affects fantasy standings
    When the correction is applied
    Then affected league commissioners should be notified
    And affected team owners should be notified
    And notification should include:
      | Player affected    |
      | Stat corrected     |
      | Points change      |
      | Impact on standings|

  @sync @corrections @freeze
  Scenario: Prevent corrections after deadline
    Given a league has a stat correction deadline of Thursday 11:59 PM
    And a late stat correction is released Friday
    When the correction sync attempts to apply
    Then the correction should be blocked for that league
    And a warning should be logged
    And admin should be notified of blocked correction
    And raw correction data should still be stored

  # ============================================================================
  # SYNC CONFIGURATION
  # ============================================================================

  @configuration @yaml
  Scenario: Configure sync intervals via application.yml
    Given the application configuration contains:
      """yaml
      nfl-data:
        sync:
          players:
            enabled: true
            cron: "0 0 6 * * *"
          schedules:
            enabled: true
            cron: "0 0 4 * * MON"
          live-scores:
            enabled: true
            interval-seconds: 300
          stat-corrections:
            enabled: true
            cron: "0 0 14 * * WED,THU"
      """
    When the application starts
    Then the player sync should be scheduled for 6:00 AM daily
    And the schedule sync should be scheduled for Monday at 4:00 AM
    And the live score sync should run every 300 seconds during games
    And the stat corrections sync should run Wed/Thu at 2:00 PM

  @configuration @disable
  Scenario: Disable specific sync jobs via configuration
    Given the schedule sync is configured with "enabled: false"
    When the application starts
    Then the schedule sync job should not be registered
    And the other sync jobs should run normally
    And a warning should be logged about disabled sync
    And health check should report disabled job status

  @configuration @environment
  Scenario: Use environment-specific sync configuration
    Given the application is running in "production" environment
    Then sync intervals should be:
      | Job Type    | Interval    |
      | Players     | Daily 6 AM  |
      | Schedules   | Weekly Mon  |
      | Live Scores | 5 minutes   |
    Given the application is running in "development" environment
    Then sync intervals should be:
      | Job Type    | Interval    |
      | Players     | Manual only |
      | Schedules   | Manual only |
      | Live Scores | 30 minutes  |

  @configuration @dynamic
  Scenario: Dynamically adjust sync configuration
    Given the system detects high API latency
    When automatic throttling is triggered
    Then sync intervals should be increased temporarily
    And rate limit should be reduced
    And log should show "Sync throttled due to API latency"
    And configuration should restore when latency normalizes

  @configuration @feature-flags
  Scenario: Control sync features via feature flags
    Given feature flag "live-score-websocket" is disabled
    When live scores are synced
    Then scores should be stored in database
    But WebSocket push should be skipped
    And users should poll for updates instead
    And feature flag status should be logged

  @configuration @season-aware
  Scenario: Adjust sync based on NFL season status
    Then sync behavior should vary by season phase:
      | Season Phase    | Player Sync | Schedule Sync | Live Scores |
      | Offseason       | Weekly      | Monthly       | Disabled    |
      | Preseason       | Daily       | Weekly        | Game days   |
      | Regular Season  | Daily       | Weekly        | Game days   |
      | Playoffs        | Daily       | After games   | Game days   |
      | Super Bowl      | Daily       | N/A           | Game day    |
    And transitions between phases should be automatic

  # ============================================================================
  # ADMIN MANUAL TRIGGERS
  # ============================================================================

  @admin @manual-sync
  Scenario: Admin triggers manual player sync
    Given an admin user is authenticated
    When the admin calls POST /api/v1/admin/sync/players
    Then a player sync job should be triggered immediately
    And the response should include:
      | Field    | Value                |
      | jobId    | sync-players-12345   |
      | status   | STARTED              |
      | type     | PLAYERS              |
      | trigger  | MANUAL               |
      | user     | admin@ffl.com        |
    And the admin can check sync status via GET /api/v1/admin/sync/{jobId}

  @admin @manual-sync
  Scenario: Admin triggers manual sync for specific team
    Given an admin user is authenticated
    When the admin calls POST /api/v1/admin/sync/team/KC
    Then a sync job should be triggered for Kansas City Chiefs only
    And only KC players should be fetched
    And response should indicate team-specific sync
    And sync should complete faster than full sync

  @admin @manual-sync
  Scenario: Admin triggers manual sync for specific week
    Given an admin user is authenticated
    And current week is NFL Week 12
    When the admin calls POST /api/v1/admin/sync/week/10
    Then a sync job should fetch Week 10 stats
    And historical stats should be updated
    And response should indicate week-specific sync

  @admin @manual-sync
  Scenario: Admin views sync status and history
    Given sync jobs have been running for the past week
    When the admin calls GET /api/v1/admin/sync/history
    Then the response should include recent sync jobs:
      | Job Type    | Status    | Records | Duration | Trigger  |
      | PLAYERS     | COMPLETED | 1805    | 45s      | SCHEDULED|
      | SCHEDULES   | COMPLETED | 16      | 12s      | SCHEDULED|
      | LIVE_SCORES | COMPLETED | 8       | 8s       | SCHEDULED|
      | PLAYERS     | COMPLETED | 1805    | 42s      | MANUAL   |
    And the response should include last sync timestamps
    And the response should include any error messages
    And pagination should be supported

  @admin @manual-sync
  Scenario: Admin cancels running sync job
    Given a player sync job is currently running
    And the job ID is "sync-players-12345"
    When the admin calls DELETE /api/v1/admin/sync/{jobId}
    Then the sync job should be cancelled
    And partial results should be rolled back
    And status should change to "CANCELLED"
    And cancellation should be logged with reason

  @admin @manual-sync
  Scenario: Admin forces full re-sync
    Given the admin suspects data corruption
    When the admin calls POST /api/v1/admin/sync/players?force=true
    Then the sync should ignore all cached data
    And the sync should fetch all players from scratch
    And existing records should be compared and updated
    And sync should take longer than incremental sync
    And log should indicate "FORCE_FULL_SYNC"

  @admin @manual-sync
  Scenario: Admin schedules future sync
    Given the admin wants to sync during low-traffic period
    When the admin calls POST /api/v1/admin/sync/schedule with:
      | Field       | Value                 |
      | type        | PLAYERS               |
      | scheduledAt | 2024-11-15T03:00:00Z  |
    Then the sync should be queued for the specified time
    And response should include scheduled job ID
    And job should execute at the scheduled time
    And admin should receive notification when complete

  @admin @manual-sync @rate-limit
  Scenario: Rate limit manual sync requests
    Given an admin has triggered 5 manual syncs in the last minute
    When the admin attempts another manual sync
    Then the request should be rejected
    And error should indicate "RATE_LIMIT_EXCEEDED"
    And message should show when next sync is allowed
    And rate limit should reset after cooldown

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error-handling @api-unavailable
  Scenario: Handle external API unavailability
    Given the external NFL data provider is unavailable
    When a scheduled sync job attempts to execute
    Then the system should retry 3 times with exponential backoff:
      | Retry | Delay    |
      | 1     | 5 seconds|
      | 2     | 15 seconds|
      | 3     | 45 seconds|
    And log each retry attempt
    And if all retries fail, alert the admin
    And schedule the next retry in 15 minutes

  @error-handling @rate-limit
  Scenario: Handle rate limit exceeded
    Given the external API rate limit is 100 requests per minute
    And the sync job has made 100 requests
    When another request is attempted
    Then the system should pause until the rate limit resets
    And log "Rate limit reached, waiting for reset"
    And resume sync after the cooldown period
    And adjust request rate to prevent future limits

  @error-handling @partial-failure
  Scenario: Handle partial sync failure
    Given a sync job is processing 32 NFL teams
    And the sync fails after processing 20 teams
    When the error is detected
    Then the system should log the partial completion
    And mark the sync as "PARTIAL_FAILURE"
    And store which teams were successfully synced
    And retry only the failed teams on next execution
    And alert admin about partial failure

  @error-handling @timeout
  Scenario: Handle sync job timeout
    Given a sync job has a timeout of 10 minutes
    When the sync job exceeds 10 minutes
    Then the job should be terminated gracefully
    And partial progress should be saved
    And status should be set to "TIMEOUT"
    And admin should be alerted
    And next run should attempt to complete remaining work

  @error-handling @data-validation
  Scenario: Handle invalid data from external source
    Given the external API returns player with invalid data:
      | Field    | Value      | Issue          |
      | Position | XYZ        | Invalid enum   |
      | Team     | UNKNOWN    | Invalid team   |
      | Height   | -10        | Negative value |
    When the sync job processes this player
    Then the invalid fields should be logged
    And the player should be skipped or stored with defaults
    And sync should continue with remaining players
    And data quality report should be generated

  @error-handling @network
  Scenario: Handle network connectivity issues
    Given network connectivity to the API is intermittent
    When the sync job experiences connection reset
    Then the request should be retried with backoff
    And connection pool should be refreshed
    And if persistent, circuit breaker should open
    And cached data should be used as fallback

  @error-handling @database
  Scenario: Handle database write failures
    Given the sync job has fetched 500 players
    And the database becomes temporarily unavailable
    When the sync attempts to write
    Then write operations should be retried
    And successfully fetched data should be buffered
    And when database recovers, buffered data should be written
    And no data should be lost

  @error-handling @circuit-breaker
  Scenario: Circuit breaker prevents cascade failures
    Given the external API has failed 5 consecutive times
    When the circuit breaker opens
    Then all sync requests should fail fast
    And cached data should be served
    And health check should report circuit open
    And after 60 seconds, a test request should be allowed
    And if successful, circuit should close

  @error-handling @dead-letter
  Scenario: Move failed sync events to dead letter queue
    Given a sync event cannot be processed after all retries
    When the event is marked as permanently failed
    Then the event should be moved to dead letter queue
    And admin should be notified
    And event should be available for manual inspection
    And manual retry should be possible

  @error-handling @recovery
  Scenario: Automatic recovery after extended outage
    Given the external API was unavailable for 2 hours
    When the API becomes available again
    Then the system should detect recovery
    And missed sync jobs should be queued in order
    And catch-up sync should run with priority
    And normal schedule should resume after catch-up

  # ============================================================================
  # DATA CONSISTENCY
  # ============================================================================

  @consistency @idempotent
  Scenario: Ensure sync jobs are idempotent
    Given the player sync job runs successfully
    When the same sync job runs again with same data
    Then no duplicate records should be created
    And existing records should remain unchanged
    And sync should complete without errors
    And metrics should show "0 changes detected"

  @consistency @conflict
  Scenario: Handle concurrent sync conflicts
    Given a manual sync and scheduled sync run simultaneously
    When both attempt to update the same player
    Then one sync should acquire the lock
    And the other should wait or skip the record
    And no data corruption should occur
    And both syncs should complete successfully

  @consistency @versioning
  Scenario: Track data versions for conflict detection
    Given player "Patrick Mahomes" has version 15
    And an update arrives with version 14 (older)
    When the sync attempts to apply the update
    Then the update should be rejected as stale
    And log should show "Stale update rejected"
    And current version 15 should be retained

  @consistency @checksum
  Scenario: Verify data integrity with checksums
    Given the sync fetches 1000 player records
    And the response includes a checksum
    When the sync calculates local checksum
    Then checksums should match
    And if mismatch, sync should be flagged for review
    And data should not be committed until verified

  @consistency @rollback
  Scenario: Rollback failed sync transaction
    Given a sync job updates 500 players
    And an error occurs at player 450
    When the rollback is triggered
    Then all 449 previous updates should be reverted
    And database should return to pre-sync state
    And rollback should be logged
    And next sync should retry all players

  # ============================================================================
  # METRICS AND MONITORING
  # ============================================================================

  @monitoring @metrics
  Scenario: Track sync metrics for observability
    Given the sync service has metrics enabled
    When sync jobs execute
    Then the following metrics should be recorded:
      | Metric                        | Type      | Labels           |
      | nfl_sync_jobs_total           | Counter   | type, status     |
      | nfl_sync_duration_seconds     | Histogram | type             |
      | nfl_sync_records_processed    | Counter   | type, operation  |
      | nfl_sync_errors_total         | Counter   | type, error_type |
      | nfl_api_requests_total        | Counter   | endpoint, status |
      | nfl_api_latency_seconds       | Histogram | endpoint         |
      | nfl_api_rate_limit_hits       | Counter   | endpoint         |
      | nfl_sync_last_success_time    | Gauge     | type             |
    And metrics should be exposed on /actuator/prometheus

  @monitoring @health
  Scenario: Report sync health status
    When the health check endpoint is called
    Then sync health should be reported:
      | Component          | Status  | Details                     |
      | player_sync        | UP      | Last run: 2 hours ago       |
      | schedule_sync      | UP      | Last run: 1 day ago         |
      | live_score_sync    | UP      | Last run: 5 minutes ago     |
      | external_api       | UP      | Latency: 150ms              |
    And overall sync health should be derived from components

  @monitoring @alerts
  Scenario: Trigger alerts for sync failures
    Given alerting is configured with PagerDuty integration
    When the player sync fails for 3 consecutive runs
    Then a critical alert should be sent
    And alert should include:
      | Field         | Value                    |
      | Severity      | CRITICAL                 |
      | Job           | PLAYER_SYNC              |
      | Failures      | 3                        |
      | Last Error    | API_TIMEOUT              |
      | Runbook       | /docs/runbooks/sync.md   |
    And alert should escalate if not acknowledged

  @monitoring @logging
  Scenario: Structured logging for sync events
    When a sync job executes
    Then structured log entries should include:
      | Field          | Example Value            |
      | timestamp      | 2024-11-15T06:00:00Z     |
      | level          | INFO                     |
      | job_id         | sync-players-12345       |
      | job_type       | PLAYERS                  |
      | trigger        | SCHEDULED                |
      | duration_ms    | 45000                    |
      | records        | 1805                     |
      | status         | COMPLETED                |
      | trace_id       | abc123                   |
    And logs should be queryable in centralized logging

  @monitoring @dashboard
  Scenario: Display sync dashboard for operations
    Given the operations team views the sync dashboard
    Then the dashboard should display:
      | Widget                  | Content                     |
      | Last Sync Times         | By job type with status     |
      | Sync Success Rate       | 24-hour rolling percentage  |
      | Average Sync Duration   | By job type trend           |
      | Active Sync Jobs        | Currently running jobs      |
      | Error Rate              | By job type and error type  |
      | API Quota Usage         | Requests used vs limit      |
    And dashboard should refresh every 30 seconds

  @monitoring @tracing
  Scenario: Distributed tracing for sync operations
    Given distributed tracing is enabled
    When a sync job executes
    Then traces should span:
      | Component        | Operation              |
      | Scheduler        | Job triggered          |
      | SyncService      | Sync started           |
      | ExternalAPI      | Data fetched           |
      | Database         | Records written        |
      | EventPublisher   | Events emitted         |
    And traces should be correlated with trace_id
    And traces should be visible in Jaeger/Zipkin
