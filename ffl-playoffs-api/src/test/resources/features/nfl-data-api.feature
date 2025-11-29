Feature: NFL Data API
  As an API consumer
  I want to access NFL player and game data
  So that I can build fantasy football features

  Background:
    Given the NFL data has been synced

  Scenario: Get players by team
    When I request players for team "KC"
    Then I should receive a list of Kansas City Chiefs players

  Scenario: Get game schedule for week
    When I request games for season 2024 week 15
    Then I should receive 16 games

  Scenario: Get player stats for week
    When I request stats for season 2024 week 15
    Then I should receive player statistics

  Scenario: Get player by ID
    Given a player with ID "12345" exists
    When I request player with ID "12345"
    Then I should receive the player details
    And the player should have a name
    And the player should have a position
    And the player should have a team

  Scenario: Get game by ID
    Given a game with ID "2024-15-KC-BUF" exists
    When I request game with ID "2024-15-KC-BUF"
    Then I should receive the game details
    And the game should have home and away teams
    And the game should have a status

  Scenario: Get player stats for a specific player
    Given a player with ID "12345" has stats for season 2024 week 15
    When I request stats for player "12345" in season 2024 week 15
    Then I should receive the player's weekly statistics
    And the stats should include fantasy points

  Scenario: Search players by name
    Given multiple players exist in the database
    When I search for players with name "Mahomes"
    Then I should receive players matching the search criteria

  Scenario: Get active games
    Given there are games currently in progress
    When I request active games
    Then I should receive only games with IN_PROGRESS or HALFTIME status
