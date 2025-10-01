Feature: Game Management
  As a game administrator
  I want to create and manage games
  So that players can participate in the FFL playoffs

  Scenario: Create a new game
    Given I am an administrator with id "admin-123"
    When I create a game named "FFL Playoffs 2025"
    Then the game should be created successfully
    And the game should have status "CREATED"

  Scenario: Invite a player to the game
    Given a game exists with id "game-123"
    When I invite a player with email "player@example.com"
    Then the player should receive an invitation
    And the player status should be "INVITED"
