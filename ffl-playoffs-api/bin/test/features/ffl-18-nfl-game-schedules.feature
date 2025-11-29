# Integration tests for FFL-18: NFL Game Schedules
Feature: NFL Game Schedules Integration Tests
  As a system
  I want to retrieve and manage NFL game schedules
  So that I can track when games occur and enable near real-time stat polling

  Background:
    Given the NFL game schedule data is available
    And the current NFL season is 2024

  # Retrieve Full Season Schedule
  Scenario: Fetch complete NFL season schedule
    When I fetch all games for season 2024
    Then the response includes games for the 2024 season
    And each game includes basic game information

  Scenario: Filter schedule by specific week
    Given games exist for week 15
    When I request the schedule for week 15
    Then the response includes only week 15 games
    And games are sorted by date and time

  # Game Status Tracking
  Scenario: Retrieve scheduled game details
    Given a game is scheduled between "KC" and "BUF"
    When I fetch the game details
    Then the game status is "SCHEDULED"
    And the game includes home and away teams
    And scores are null for scheduled games

  Scenario: Detect when game starts
    Given a game with status "SCHEDULED"
    When the game status is updated to "IN_PROGRESS"
    Then the game status changes to "IN_PROGRESS"
    And scores start updating

  Scenario: Detect when game completes
    Given a game with status "IN_PROGRESS"
    When the game is marked as "FINAL"
    Then the final scores are recorded
    And the game status is "FINAL"

  Scenario: Handle overtime games
    Given a game is in overtime
    When I fetch the game details
    Then the quarter field shows "OT"
    And the game status is "IN_PROGRESS"

  # Game Status Enumeration
  Scenario: Recognize all possible game statuses
    Given games with various statuses exist
    When I query games by status "SCHEDULED"
    Then I receive only scheduled games
    When I query games by status "IN_PROGRESS"
    Then I receive only in-progress games
    When I query games by status "FINAL"
    Then I receive only completed games

  # Week Schedule Retrieval
  Scenario: Get schedule for specific NFL week
    Given week 15 has 16 games
    When I request games for season 2024 week 15
    Then I receive 16 games
    And all games are for week 15

  # Game Time Tracking
  Scenario: Track game time remaining
    Given a game is in progress in quarter 2
    When I fetch the game details
    Then the quarter field shows the current quarter
    And time remaining information is available

  Scenario: Handle halftime
    Given a game is at halftime
    When I fetch the game details
    Then the status shows "HALFTIME"

  # Schedule Changes and Updates
  Scenario: Handle game postponement
    Given a scheduled game exists
    When the game is postponed to a new time
    Then the game status is "POSTPONED"
    And the game time is updated

  Scenario: Handle game cancellation
    Given a scheduled game exists
    When the game is cancelled
    Then the game status is "CANCELLED"

  # Stadium and Venue Information
  Scenario: Retrieve stadium details for game
    Given a game with venue information exists
    When I fetch the game details
    Then stadium information is included

  # Schedule Integration with Live Stats
  Scenario: Get active games for polling
    Given there are games in progress
    When I request active games
    Then I receive only games with IN_PROGRESS or HALFTIME status
    And these games require live stats polling

  # Historical Schedule Data
  Scenario: Retrieve past week's schedule
    Given week 14 games are all completed
    When I request the schedule for week 14
    Then all games have status "FINAL"

  # Multi-week Schedule View
  Scenario: Retrieve schedule for multiple weeks
    Given weeks 15 through 18 have game data
    When I request games for season 2024
    Then the response includes games from all weeks
    And games are grouped by week

  # Error Handling
  Scenario: Handle invalid week number
    When I request schedule for week 99
    Then no games are returned

  # Primetime Games
  Scenario: Identify games by broadcast network
    Given week 15 includes primetime games
    When I request games for week 15
    Then some games have broadcast network information
    And networks include CBS, FOX, NBC, ESPN, or Amazon
