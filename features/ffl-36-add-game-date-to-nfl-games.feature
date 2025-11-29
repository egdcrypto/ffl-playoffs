Feature: FFL-36: Add Game Date to NFL Games Data Model
  @python @backend

  As a fantasy football player
  I want to see the actual date of NFL games
  So that I can plan my roster submissions accordingly

  Background:
    Given the NFL data sync service is running
    And MongoDB is available at mongodb://localhost:30017

  # Reference Documentation:
  # - Python ingestion module: nfl-data-sync/src/ (in feature/ffl-34-scheduled-nfl-data-sync branch)
  # - Python domain models: nfl-data-sync/src/domain/models.py
  # - Python MongoDB adapter: nfl-data-sync/src/infrastructure/adapters/mongodb_repositories.py
  # - MongoDB database: ffl_playoffs
  # - Collection: nfl_games
  # - nflreadpy library provides game_date field in schedules
  # - Current NFLGame model has: game_id, season, week, home_team, away_team, game_time, status
  # - Need to add: game_date (date of the actual game)

  @data-model
  Scenario: NFL Game model includes game_date field
    Given the NFLGame domain model exists in Python
    When I inspect the NFLGame model
    Then it should have a "game_date" field of type datetime
    And it should have a "season" field of type int
    And it should have a "week" field of type int

  @data-sync
  Scenario: NFL schedule sync includes game date
    Given nflreadpy is available for data fetching
    When the sync service fetches the NFL schedule for season 2024
    Then each game record should include the "game_date" field
    And the game_date should be a valid datetime representing the actual game date

  @mongodb
  Scenario: Game date is persisted to MongoDB
    Given the NFL schedule has been synced for season 2024
    When I query the nfl_games collection
    Then each document should have a "game_date" field
    And the game_date should be stored as an ISODate

  @api
  Scenario: Game date is returned in API responses
    Given the NFL schedule has been synced
    When I call GET /api/v1/nfl/games/week/2024/1
    Then each game in the response should include "gameDate"
    And the gameDate should be in ISO 8601 format

  @integration
  Scenario: Existing games are updated with game date
    Given there are existing game records without game_date
    When the sync service runs with force_update=true
    Then all existing games should be updated to include game_date
    And the game_date values should be accurate based on NFL schedule data

  # Technical Requirements:
  # 1. Update NFLGame Python model to include game_date: datetime field
  # 2. Update MongoDB repository to persist game_date
  # 3. Update nflreadpy adapter to extract game_date from schedule data
  # 4. Update Java NFLGameDocument to include gameDate field
  # 5. Update Java NFLGameDTO to include gameDate in API response
  # 6. Create migration script to backfill game_date for existing records
