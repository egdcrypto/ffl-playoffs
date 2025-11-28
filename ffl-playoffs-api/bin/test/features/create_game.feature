Feature: Create Game
  As a game creator
  I want to create a new FFL Playoffs game
  So that I can invite players to participate

  Scenario: Successfully create a game
    Given I am authenticated as a user
    When I create a game with name "NFL Playoffs 2025"
    And I set the start date to "2025-01-15"
    And I set the end date to "2025-02-15"
    Then the game should be created successfully
    And the game status should be "DRAFT"
    And I should be set as the creator

  Scenario: Create a game with invalid dates
    Given I am authenticated as a user
    When I create a game with name "NFL Playoffs 2025"
    And I set the start date to "2025-02-15"
    And I set the end date to "2025-01-15"
    Then the game creation should fail
    And I should receive an error message "End date must be after start date"
