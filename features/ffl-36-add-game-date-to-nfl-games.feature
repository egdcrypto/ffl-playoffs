Feature: FFL-36: Add Game Date to NFL Games Data Model
  @python @backend @java

  As a fantasy football player
  I want to see the actual date of NFL games
  So that I can plan my roster submissions accordingly

  Background:
    Given the NFL data sync service is running
    And MongoDB is available at mongodb://localhost:30017
    And the nfl_games collection exists

  # Reference Documentation:
  # - Python ingestion module: nfl-data-sync/src/ (in feature/ffl-34-scheduled-nfl-data-sync branch)
  # - Python domain models: nfl-data-sync/src/domain/models.py
  # - Python MongoDB adapter: nfl-data-sync/src/infrastructure/adapters/mongodb_repositories.py
  # - MongoDB database: ffl_playoffs
  # - Collection: nfl_games
  # - nflreadpy library provides game_date field in schedules
  # - Current NFLGame model has: game_id, season, week, home_team, away_team, game_time, status
  # - Need to add: game_date (date of the actual game)

  # ============================================================================
  # DATA MODEL UPDATES - PYTHON
  # ============================================================================

  @data-model @python
  Scenario: NFL Game Python model includes game_date field
    Given the NFLGame domain model exists in Python
    When I inspect the NFLGame model
    Then it should have a "game_date" field of type datetime
    And it should have a "season" field of type int
    And it should have a "week" field of type int
    And the game_date field should be required (not Optional)

  @data-model @python
  Scenario: NFLGame model validates game_date field
    Given the NFLGame model is being constructed
    When I create an NFLGame with:
      | Field      | Value                    |
      | game_id    | 2024091500               |
      | season     | 2024                     |
      | week       | 1                        |
      | home_team  | KC                       |
      | away_team  | BAL                      |
      | game_date  | 2024-09-15               |
      | game_time  | 2024-09-15T20:20:00Z     |
      | status     | SCHEDULED                |
    Then the NFLGame instance should be created successfully
    And the game_date should be stored as a date object

  @data-model @python @validation
  Scenario: NFLGame model rejects invalid game_date
    Given the NFLGame model is being constructed
    When I attempt to create an NFLGame with game_date "not-a-date"
    Then a validation error should be raised
    And the error message should indicate invalid date format

  @data-model @python @validation
  Scenario: NFLGame model rejects null game_date
    Given the NFLGame model is being constructed
    When I attempt to create an NFLGame with game_date as null
    Then a validation error should be raised
    And the error message should indicate game_date is required

  @data-model @python @validation
  Scenario: NFLGame model validates game_date is within season
    Given the NFLGame model is being constructed
    When I create an NFLGame with:
      | Field      | Value       |
      | season     | 2024        |
      | game_date  | 2024-09-15  |
    Then the validation should pass
    When I create an NFLGame with:
      | Field      | Value       |
      | season     | 2024        |
      | game_date  | 2023-09-15  |
    Then a validation warning should be logged about date/season mismatch

  # ============================================================================
  # DATA MODEL UPDATES - JAVA
  # ============================================================================

  @data-model @java
  Scenario: NFLGameDocument includes gameDate field
    Given the NFLGameDocument MongoDB document class exists
    When I inspect the NFLGameDocument class
    Then it should have a "gameDate" field of type LocalDate
    And it should have @Field("game_date") annotation
    And it should have appropriate getter and setter methods

  @data-model @java
  Scenario: NFLGameDTO includes gameDate field
    Given the NFLGameDTO response class exists
    When I inspect the NFLGameDTO class
    Then it should have a "gameDate" field of type LocalDate
    And it should have @JsonFormat annotation for ISO 8601 date
    And the field should be serialized as "gameDate" in JSON

  @data-model @java
  Scenario: Domain NFLGame entity includes gameDate
    Given the NFLGame domain entity exists
    When I inspect the NFLGame entity
    Then it should have a "gameDate" field of type LocalDate
    And it should be immutable (final field with builder)
    And it should be included in equals/hashCode

  # ============================================================================
  # SYNC SERVICE INTEGRATION
  # ============================================================================

  @data-sync @nflreadpy
  Scenario: NFL schedule sync includes game date
    Given nflreadpy is available for data fetching
    When the sync service fetches the NFL schedule for season 2024
    Then each game record should include the "game_date" field
    And the game_date should be a valid date representing the actual game date
    And the game_date should match the date portion of game_time

  @data-sync @nflreadpy
  Scenario: Parse game_date from nflreadpy schedule data
    Given nflreadpy returns schedule data with:
      | Field       | Value                    |
      | game_id     | 2024091500               |
      | gameday     | 2024-09-15               |
      | gametime    | 20:20                    |
    When the sync adapter processes the schedule data
    Then the game_date should be extracted as "2024-09-15"
    And the game_time should be constructed as "2024-09-15T20:20:00-04:00"

  @data-sync @timezone
  Scenario: Handle game_date timezone conversion
    Given a game is scheduled for "2024-09-15" in Eastern Time
    When the sync service processes the game
    Then the game_date should be stored as "2024-09-15" (date only, no timezone)
    And the game_time should include full timezone info
    And late-night games should maintain correct date

  @data-sync @timezone
  Scenario: Handle late-night game date correctly
    Given a game starts at 11:30 PM ET on Saturday 2024-09-14
    When the sync service processes the game
    Then the game_date should be "2024-09-14" (the date it started)
    And games that run past midnight should keep original date
    And the date should not change based on viewer timezone

  @data-sync @international
  Scenario: Handle international game dates correctly
    Given a game is scheduled in London for "2024-10-13" local time
    And the game starts at 09:30 local time (14:30 ET)
    When the sync service processes the game
    Then the game_date should be "2024-10-13"
    And the venue timezone should be considered
    And US-based date should be used for fantasy purposes

  @data-sync @error-handling
  Scenario: Handle missing game_date in source data
    Given nflreadpy returns a game record without gameday field
    When the sync service processes the game
    Then the sync should log a warning
    And attempt to derive game_date from game_time
    And if derivation fails, skip the record with error

  @data-sync @error-handling
  Scenario: Handle malformed game_date in source data
    Given nflreadpy returns game_date as "September 15, 2024"
    When the sync service attempts to parse the date
    Then the sync should try multiple date formats:
      | Format             | Example            |
      | YYYY-MM-DD         | 2024-09-15         |
      | MM/DD/YYYY         | 09/15/2024         |
      | Month DD, YYYY     | September 15, 2024 |
    And successfully parse the valid format
    And log the format used for debugging

  @data-sync @incremental
  Scenario: Incremental sync updates game_date if changed
    Given a game exists with game_date "2024-09-15"
    And the NFL reschedules the game to "2024-09-16"
    When the sync service runs
    Then the game_date should be updated to "2024-09-16"
    And a game_date change event should be logged
    And dependent systems should be notified

  @data-sync @batch
  Scenario: Batch sync handles game_date for all games
    Given the sync service is processing 272 regular season games
    When the batch sync completes
    Then all 272 games should have game_date populated
    And no games should have null game_date
    And sync metrics should include game_date coverage: 100%

  # ============================================================================
  # MONGODB PERSISTENCE
  # ============================================================================

  @mongodb @persistence
  Scenario: Game date is persisted to MongoDB
    Given the NFL schedule has been synced for season 2024
    When I query the nfl_games collection
    Then each document should have a "game_date" field
    And the game_date should be stored as an ISODate
    And the field name in MongoDB should be "game_date"

  @mongodb @schema
  Scenario: MongoDB document schema includes game_date
    Given a game is synced with game_date "2024-09-15"
    When I query the document in MongoDB
    Then the document structure should be:
      """json
      {
        "_id": "2024091500",
        "game_id": "2024091500",
        "season": 2024,
        "week": 1,
        "home_team": "KC",
        "away_team": "BAL",
        "game_date": ISODate("2024-09-15T00:00:00.000Z"),
        "game_time": ISODate("2024-09-16T00:20:00.000Z"),
        "status": "SCHEDULED"
      }
      """
    And game_date should be midnight UTC of the game day

  @mongodb @index
  Scenario: Create index on game_date field
    Given the nfl_games collection exists
    When I check the collection indexes
    Then there should be an index on "game_date"
    And the index should be ascending
    And the index should support date range queries efficiently

  @mongodb @compound-index
  Scenario: Create compound index for common queries
    Given the nfl_games collection exists
    When I check the collection indexes
    Then there should be a compound index on:
      | Field      | Order |
      | season     | 1     |
      | game_date  | 1     |
    And the index should optimize queries for games by season and date

  @mongodb @query
  Scenario: Query games by date range
    Given games exist for September 2024
    When I query games where game_date is between "2024-09-08" and "2024-09-14"
    Then only Week 1 games should be returned
    And the query should use the game_date index
    And query performance should be under 100ms

  @mongodb @query
  Scenario: Query today's games
    Given today is "2024-09-15"
    And there are 14 games scheduled for today
    When I query games where game_date equals today
    Then exactly 14 games should be returned
    And each game should have game_date "2024-09-15"

  @mongodb @aggregation
  Scenario: Aggregate games by date
    Given games exist for the 2024 season
    When I run aggregation to count games per date
    Then the result should show:
      | game_date   | count |
      | 2024-09-05  | 1     |
      | 2024-09-08  | 13    |
      | 2024-09-09  | 1     |
      | 2024-09-12  | 1     |
    And aggregation should complete efficiently

  @mongodb @update
  Scenario: Update game_date for existing game
    Given a game exists with game_date "2024-09-15"
    When the game is rescheduled to "2024-09-16"
    And the update is persisted
    Then the document should show game_date "2024-09-16"
    And the updated_at timestamp should be updated
    And version number should be incremented

  # ============================================================================
  # API RESPONSES
  # ============================================================================

  @api @response
  Scenario: Game date is returned in API responses
    Given the NFL schedule has been synced
    When I call GET /api/v1/nfl/games/week/2024/1
    Then each game in the response should include "gameDate"
    And the gameDate should be in ISO 8601 date format (YYYY-MM-DD)
    And the response should be:
      """json
      {
        "games": [
          {
            "gameId": "2024091500",
            "season": 2024,
            "week": 1,
            "homeTeam": "KC",
            "awayTeam": "BAL",
            "gameDate": "2024-09-15",
            "gameTime": "2024-09-15T20:20:00-04:00",
            "status": "SCHEDULED"
          }
        ]
      }
      """

  @api @filter
  Scenario: Filter games by date via API
    Given games exist for September 2024
    When I call GET /api/v1/nfl/games?date=2024-09-15
    Then only games on 2024-09-15 should be returned
    And the response should include the correct count
    And each game should have gameDate "2024-09-15"

  @api @filter
  Scenario: Filter games by date range via API
    Given games exist for September 2024
    When I call GET /api/v1/nfl/games?fromDate=2024-09-08&toDate=2024-09-14
    Then only games within the date range should be returned
    And games on both boundary dates should be included
    And response should be sorted by gameDate ascending

  @api @filter
  Scenario: Filter games by today's date
    Given today is "2024-09-15"
    When I call GET /api/v1/nfl/games?date=today
    Then games scheduled for today should be returned
    And the system should resolve "today" to the current date
    And timezone should be based on ET for NFL schedule

  @api @sorting
  Scenario: Sort games by date via API
    Given games exist for multiple weeks
    When I call GET /api/v1/nfl/games?sort=gameDate:asc
    Then games should be sorted by gameDate ascending
    And earliest games should appear first
    And secondary sort should be by gameTime

  @api @sorting
  Scenario: Default sort includes game date
    Given games exist for Week 1
    When I call GET /api/v1/nfl/games/week/2024/1
    Then games should be sorted by:
      | Priority | Field     | Order |
      | 1        | gameDate  | asc   |
      | 2        | gameTime  | asc   |
    And Thursday game appears before Sunday games

  @api @graphql
  Scenario: Game date is available in GraphQL schema
    Given the GraphQL schema is defined
    When I inspect the NFLGame type
    Then it should have a "gameDate" field of type Date
    And the field should be non-nullable
    And it should be queryable and filterable

  @api @graphql
  Scenario: Query games by date via GraphQL
    Given games exist for September 2024
    When I execute GraphQL query:
      """graphql
      query {
        games(filter: { gameDate: "2024-09-15" }) {
          gameId
          gameDate
          homeTeam
          awayTeam
        }
      }
      """
    Then games on 2024-09-15 should be returned
    And each game should include the gameDate field

  @api @validation
  Scenario: API rejects invalid date format
    When I call GET /api/v1/nfl/games?date=15-09-2024
    Then the response should be HTTP 400 Bad Request
    And the error message should indicate invalid date format
    And the expected format should be provided: YYYY-MM-DD

  @api @validation
  Scenario: API handles future dates gracefully
    When I call GET /api/v1/nfl/games?date=2025-09-15
    Then the response should be HTTP 200 OK
    And an empty games list should be returned
    And no error should occur

  # ============================================================================
  # MIGRATION SCENARIOS
  # ============================================================================

  @migration @backfill
  Scenario: Existing games are updated with game date
    Given there are existing game records without game_date
    When the sync service runs with force_update=true
    Then all existing games should be updated to include game_date
    And the game_date values should be accurate based on NFL schedule data
    And migration progress should be logged

  @migration @backfill
  Scenario: Backfill game_date from game_time
    Given existing games have game_time but no game_date
    When the migration script runs
    Then game_date should be derived from game_time
    And the date portion should be extracted correctly
    And timezone should be considered for derivation

  @migration @script
  Scenario: Run migration script for game_date backfill
    Given the migration script is available
    When I run the migration with:
      | Parameter    | Value           |
      | season       | 2024            |
      | dry_run      | false           |
      | batch_size   | 100             |
    Then all 2024 season games should be updated
    And progress should be reported every 100 records
    And total records updated should be logged

  @migration @dry-run
  Scenario: Migration dry run shows proposed changes
    Given existing games are missing game_date
    When I run the migration with dry_run=true
    Then no database changes should be made
    And the output should show:
      | Field              | Value |
      | Records to update  | 272   |
      | Sample updates     | 5     |
    And sample updates should show before/after values

  @migration @validation
  Scenario: Migration validates data integrity
    Given the migration has completed
    When I run the validation check
    Then all games should have game_date populated
    And no games should have null game_date
    And game_date should match date portion of game_time for all games
    And validation report should be generated

  @migration @rollback
  Scenario: Migration can be rolled back
    Given the migration has updated game_date for 272 games
    When I run the rollback script
    Then game_date field should be unset for all games
    And the original document state should be restored
    And rollback should be logged for audit

  @migration @idempotent
  Scenario: Migration is idempotent
    Given the migration has already run once
    When I run the migration again
    Then no duplicate updates should occur
    And games with game_date should be skipped
    And only games without game_date should be processed
    And the final state should be identical

  @migration @historical
  Scenario: Backfill historical seasons
    Given games exist for seasons 2020-2024
    When I run the migration for all historical seasons
    Then game_date should be populated for all seasons:
      | Season | Games Updated |
      | 2020   | 269           |
      | 2021   | 285           |
      | 2022   | 285           |
      | 2023   | 285           |
      | 2024   | 272           |
    And total records should be 1396

  @migration @error-handling
  Scenario: Migration handles errors gracefully
    Given some games have corrupted game_time data
    When the migration runs
    Then valid games should be updated successfully
    And invalid games should be logged to error file
    And migration should continue after errors
    And error summary should be provided at end

  # ============================================================================
  # INTEGRATION SCENARIOS
  # ============================================================================

  @integration @end-to-end
  Scenario: Full sync populates game_date correctly
    Given the NFL data sync service is running
    And nflreadpy has schedule data for 2024 season
    When I trigger a full schedule sync
    Then all 272 regular season games should be synced
    And each game should have game_date populated
    And game_date should match the scheduled date for each game

  @integration @roster-lock
  Scenario: Game date affects roster lock calculation
    Given a game has game_date "2024-09-15"
    And roster lock is configured for 1 hour before game time
    When calculating roster lock deadline
    Then the date component should come from game_date
    And the time component should come from game_time
    And lock deadline should be "2024-09-15T19:20:00-04:00"

  @integration @fantasy-scoring
  Scenario: Game date used for fantasy week determination
    Given a game has game_date "2024-09-12" (Thursday)
    And the game is in NFL Week 2
    When calculating fantasy scoring week
    Then the game should be assigned to fantasy Week 2
    And game_date should be used for determining deadlines
    And Thursday games should not affect Week 1 scoring

  @integration @ui-display
  Scenario: Game date displayed correctly in UI
    Given a game has game_date "2024-09-15"
    When the UI renders the game card
    Then the date should display as "Sunday, Sep 15"
    And the date should be formatted for user's locale
    And date should be clearly distinguishable from time

  @integration @notification
  Scenario: Game date used in notifications
    Given a user has players in the game on "2024-09-15"
    When sending game day notifications
    Then the notification should include the date
    And format should be "Your players compete on Sunday, Sep 15"
    And timezone should be based on user preference

  @integration @cache
  Scenario: Game date changes invalidate cache
    Given game data is cached
    And a game's date changes from "2024-09-15" to "2024-09-16"
    When the sync detects the change
    Then the cache for that game should be invalidated
    And the cache for the affected weeks should be invalidated
    And fresh data should be fetched on next request

  # ============================================================================
  # EDGE CASES
  # ============================================================================

  @edge-case @bye-week
  Scenario: Handle bye week games (none)
    Given a team has a bye week 6
    When querying games for that team in week 6
    Then no games should be returned
    And the API should not error
    And response should indicate bye week

  @edge-case @postponed
  Scenario: Handle postponed game date change
    Given a game was originally scheduled for "2024-09-15"
    And the game is postponed to "2024-09-16"
    When the sync updates the game
    Then game_date should be updated to "2024-09-16"
    And game_time should be updated accordingly
    And a postponement event should be recorded

  @edge-case @cancelled
  Scenario: Handle cancelled game
    Given a game was scheduled for "2024-09-15"
    And the game is cancelled
    When the sync updates the game
    Then game_date should remain "2024-09-15"
    And status should be "CANCELLED"
    And the game should be queryable by date

  @edge-case @doubleheader
  Scenario: Handle multiple games on same date for team
    Given the 2020 season had COVID-related schedule changes
    And a team played two games in the same week
    When querying by team and date
    Then both games should be returned
    And each game should have distinct game_id
    And sorting by game_time should order them correctly

  @edge-case @playoff
  Scenario: Handle playoff game dates
    Given playoff games are scheduled
    When syncing Wild Card weekend games
    Then game_date should be populated for each playoff game
    And playoff games should be queryable by date
    And Wild Card games should span Saturday and Sunday

  @edge-case @super-bowl
  Scenario: Handle Super Bowl date
    Given the Super Bowl is scheduled for "2025-02-09"
    When syncing the Super Bowl game
    Then game_date should be "2025-02-09"
    And the game should be queryable as the latest game of season
    And week should be set appropriately (e.g., 22 or "SB")

  @edge-case @leap-year
  Scenario: Handle leap year dates correctly
    Given a game is scheduled for "2024-02-29" (leap year)
    When the sync processes the game
    Then game_date should be stored as "2024-02-29"
    And date arithmetic should work correctly
    And queries for February games should include it

  # ============================================================================
  # PERFORMANCE
  # ============================================================================

  @performance @query
  Scenario: Game date queries are performant
    Given 5 seasons of NFL games exist (1400+ records)
    When I query games by date range spanning 1 week
    Then the query should complete in under 100ms
    And the game_date index should be used
    And explain plan should show index scan

  @performance @sync
  Scenario: Game date parsing is efficient
    Given a full season sync processes 272 games
    When measuring game_date parsing time
    Then total parsing time should be under 1 second
    And memory usage should remain stable
    And no date parsing bottlenecks should exist

  @performance @api
  Scenario: API response time with game_date filter
    Given games exist for the 2024 season
    When I call GET /api/v1/nfl/games?date=2024-09-15
    Then response time should be under 200ms
    And the game_date filter should use database index
    And response size should be proportional to result count
