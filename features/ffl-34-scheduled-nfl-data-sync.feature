@backend @nfl-data @scheduled
Feature: Scheduled NFL Data Sync
  As the FFL Playoffs application
  I need to periodically sync NFL data from external sources
  So that users have up-to-date player stats, schedules, and scores

  Background:
    Given the NFL data sync service is configured
    And the external NFL data provider is available

  # Player Data Sync
  @sync @players
  Scenario: Sync NFL player roster data daily
    Given the player sync is scheduled to run daily at 6:00 AM
    When the scheduled sync job executes
    Then the system should fetch all NFL player profiles
    And store them in the local NFLPlayer collection
    And update existing players with new information
    And add any new players to the database
    And log the sync completion with player count

  @sync @players
  Scenario: Handle new players added during season
    Given the local database has 1800 NFL players
    And the external source has 1805 NFL players
    When the player sync job executes
    Then 5 new players should be added to the database
    And existing player data should be updated
    And the sync log should show "5 players added, 1800 players updated"

  # Schedule Sync
  @sync @schedules
  Scenario: Sync NFL game schedules weekly
    Given the schedule sync is configured to run every Monday
    When the scheduled sync job executes
    Then the system should fetch the current week's game schedule
    And store game matchups in the NFLGame collection
    And include game start times in ET timezone
    And include home and away teams for each game

  @sync @schedules
  Scenario: Update schedule when NFL changes game times
    Given game "KC vs BUF" is scheduled for "Sunday 4:25 PM ET"
    And the NFL updates the game time to "Sunday 8:20 PM ET"
    When the schedule sync job executes
    Then the local game record should reflect the new time
    And affected league lock deadlines should be recalculated
    And a schedule change event should be logged

  # Live Score Sync
  @sync @live-scores
  Scenario: Sync live scores during active games
    Given it is Sunday at 1:30 PM ET during NFL season
    And there are 8 games currently in progress
    When the live score sync job executes
    Then the system should fetch current scores for all active games
    And update the NFLGame collection with current scores
    And the sync should complete within 30 seconds
    And the next sync should be scheduled in 5 minutes

  @sync @live-scores
  Scenario: Skip live score sync when no games are active
    Given it is Tuesday at 10:00 AM ET
    And there are no NFL games in progress
    When the live score sync job is triggered
    Then the system should detect no active games
    And skip the score fetching to conserve API calls
    And log "No active games, skipping live score sync"

  @sync @live-scores
  Scenario: Increase sync frequency during game final minutes
    Given a game is in the 4th quarter with 2 minutes remaining
    When the live score sync evaluates the game status
    Then the sync interval should decrease to 1 minute
    And player stats should be fetched more frequently
    And the system should prepare for final score processing

  # Player Stats Sync
  @sync @stats
  Scenario: Sync player stats after games complete
    Given the "LAR vs SEA" game has ended with final score
    When the post-game stats sync job executes
    Then the system should fetch final player statistics
    And update PlayerStats for all players in the game
    And calculate fantasy points based on scoring rules
    And trigger leaderboard recalculation for affected leagues

  @sync @stats
  Scenario: Calculate fantasy points for multiple scoring formats
    Given player "Patrick Mahomes" has the following stats
      | Stat              | Value |
      | Passing Yards     | 325   |
      | Passing TDs       | 3     |
      | Interceptions     | 1     |
      | Rushing Yards     | 28    |
    When fantasy points are calculated
    Then the points should be calculated for each league's scoring rules
      | Scoring Format | Expected Points |
      | Standard       | 23.3            |
      | Half PPR       | 23.3            |
      | Full PPR       | 23.3            |

  # Error Handling
  @error-handling
  Scenario: Handle external API unavailability
    Given the external NFL data provider is unavailable
    When a scheduled sync job attempts to execute
    Then the system should retry 3 times with exponential backoff
    And log each retry attempt
    And if all retries fail, alert the admin
    And schedule the next retry in 15 minutes

  @error-handling
  Scenario: Handle rate limit exceeded
    Given the external API rate limit is 100 requests per minute
    And the sync job has made 100 requests
    When another request is attempted
    Then the system should pause until the rate limit resets
    And log "Rate limit reached, waiting for reset"
    And resume sync after the cooldown period

  @error-handling
  Scenario: Handle partial sync failure
    Given a sync job is processing 32 NFL teams
    And the sync fails after processing 20 teams
    When the error is detected
    Then the system should log the partial completion
    And mark the sync as "PARTIAL_FAILURE"
    And store which teams were successfully synced
    And retry only the failed teams on next execution

  # Configuration
  @configuration
  Scenario: Configure sync intervals via application.yml
    Given the application configuration contains
      """yaml
      nfl-data:
        sync:
          players:
            enabled: true
            cron: "0 0 6 * * *"
          schedules:
            enabled: true
            cron: "0 0 0 * * MON"
          live-scores:
            enabled: true
            interval-seconds: 300
      """
    When the application starts
    Then the player sync should be scheduled for 6:00 AM daily
    And the schedule sync should be scheduled for Monday at midnight
    And the live score sync should run every 300 seconds during games

  @configuration
  Scenario: Disable specific sync jobs via configuration
    Given the schedule sync is configured with "enabled: false"
    When the application starts
    Then the schedule sync job should not be registered
    And the other sync jobs should run normally
    And a warning should be logged about disabled sync

  # Manual Trigger
  @admin @manual-sync
  Scenario: Admin triggers manual data sync
    Given an admin user is authenticated
    When the admin calls POST /api/v1/admin/sync/players
    Then a player sync job should be triggered immediately
    And the response should include a sync job ID
    And the admin can check sync status via GET /api/v1/admin/sync/{jobId}

  @admin @manual-sync
  Scenario: Admin views sync status and history
    Given sync jobs have been running for the past week
    When the admin calls GET /api/v1/admin/sync/history
    Then the response should include recent sync jobs
      | Job Type    | Status    | Records | Duration |
      | PLAYERS     | COMPLETED | 1805    | 45s      |
      | SCHEDULES   | COMPLETED | 16      | 12s      |
      | LIVE_SCORES | COMPLETED | 8       | 8s       |
    And the response should include last sync timestamps
    And the response should include any error messages

  # Metrics and Monitoring
  @monitoring
  Scenario: Track sync metrics for observability
    Given the sync service has metrics enabled
    When sync jobs execute
    Then the following metrics should be recorded
      | Metric                        | Type    |
      | nfl_sync_jobs_total           | Counter |
      | nfl_sync_duration_seconds     | Gauge   |
      | nfl_sync_records_processed    | Counter |
      | nfl_sync_errors_total         | Counter |
      | nfl_api_requests_total        | Counter |
      | nfl_api_rate_limit_hits       | Counter |
