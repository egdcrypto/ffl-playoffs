Feature: Roster Lock - One-Time Draft Model
  As a league administrator
  I want rosters to be permanently locked once the first game starts
  So that the league operates as a one-time draft with no weekly changes

  Background:
    Given a league "Championship 2024" exists
    And the league starts at NFL week 1
    And the league runs for 4 weeks
    And the roster lock deadline is set to "2024-09-05 20:00:00 ET"
    And the first NFL game of week 1 starts at "2024-09-05 20:20:00 ET"
    And multiple players are members of the league

  Scenario: Player completes roster before lock deadline
    Given the current time is "2024-09-05 19:00:00 ET"
    And a player has filled all 9 roster positions
    When the roster lock deadline passes at "2024-09-05 20:00:00 ET"
    Then the roster is automatically locked
    And the roster status changes to "LOCKED"
    And the roster lockTimestamp is set to "2024-09-05 20:00:00 ET"

  Scenario: Player attempts to edit roster after lock deadline
    Given the current time is "2024-09-05 21:00:00 ET"
    And the roster lock deadline has passed
    And a player's roster is locked
    When the player attempts to change their QB selection
    Then the request is rejected with error "ROSTER_LOCKED"
    And the system shows "Rosters are locked for the season - no changes allowed"
    And no roster changes are applied

  Scenario: Player has incomplete roster at lock deadline
    Given the current time is "2024-09-05 19:00:00 ET"
    And a player has only filled 7 of 9 roster positions
    And the QB and K positions are empty
    When the roster lock deadline passes at "2024-09-05 20:00:00 ET"
    Then the roster is locked in incomplete state
    And the roster status changes to "LOCKED_INCOMPLETE"
    And the player will score 0 points for QB and K positions all season
    And a notification is sent to the player about incomplete roster

  Scenario: Admin configures roster lock deadline before first game
    Given the admin is creating a new league
    And the first NFL game starts at "2024-09-05 20:20:00 ET"
    When the admin sets roster lock deadline to "2024-09-05 20:00:00 ET"
    Then the configuration is accepted
    And players have until 20:00 ET to finalize rosters

  Scenario: Admin attempts to set roster lock after first game start
    Given the first NFL game starts at "2024-09-05 20:20:00 ET"
    When the admin attempts to set roster lock deadline to "2024-09-05 21:00:00 ET"
    Then the configuration is rejected with error "LOCK_AFTER_GAME_START"
    And the system shows "Roster lock must be before first game starts"

  Scenario: Player views locked roster during the season
    Given the roster lock deadline has passed
    And a player's roster is locked with 9 NFL players
    And the current week is week 3 of 4
    When the player views their roster
    Then the system displays all 9 locked roster positions
    And the system shows "Roster locked for the season"
    And the system shows cumulative scores for weeks 1-3
    And all edit buttons are disabled

  Scenario: No waiver wire or free agent pickups allowed
    Given the roster lock deadline has passed
    And NFL player "Christian McCaffrey" is injured in week 2
    When the player attempts to add a replacement player
    Then the request is rejected with error "ROSTER_LOCKED"
    And the system shows "No roster changes allowed - one-time draft model"
    And the injured player remains in the roster

  Scenario: No trades allowed after roster lock
    Given two players have locked rosters
    And the current week is week 2
    When Player A attempts to propose a trade with Player B
    Then the request is rejected with error "TRADES_NOT_ALLOWED"
    And the system shows "This league uses one-time draft - no trades"

  Scenario: Roster lock countdown displayed to players
    Given the current time is "2024-09-05 18:00:00 ET"
    And the roster lock deadline is "2024-09-05 20:00:00 ET"
    When a player views their roster page
    Then the system displays "Roster locks in: 2 hours"
    And the countdown updates in real-time
    And the system highlights incomplete positions

  Scenario: Player receives reminder before roster lock
    Given a player has an incomplete roster
    And the roster lock deadline is in 24 hours
    When the reminder system runs
    Then an email reminder is sent to the player
    And the email shows which positions are unfilled
    And the email shows the exact lock deadline time

  Scenario: Admin views all roster lock statuses
    Given the league has 10 players
    And 8 players have complete rosters
    And 2 players have incomplete rosters
    When the admin views roster lock status report
    Then the system shows 8 players with status "LOCKED_COMPLETE"
    And the system shows 2 players with status "LOCKED_INCOMPLETE"
    And the system shows which positions are missing for incomplete rosters

  Scenario: Locked roster scores throughout the season
    Given a player's roster was locked with all 9 positions filled
    And the league runs for 4 weeks
    When the season progresses through weeks 1-4
    Then the same 9 NFL players score points each week
    And the player's total score accumulates across all 4 weeks
    And no roster changes occur at any point

  Scenario: Roster validation before lock deadline
    Given the current time is 1 hour before lock deadline
    And a player has filled 8 of 9 positions
    When the validation system runs
    Then the player receives a warning notification
    And the system shows "Your roster is incomplete - fill all positions before lock"
    And the system lists missing positions

  Scenario: Emergency roster unlock by admin is not allowed
    Given the roster lock deadline has passed
    And all rosters are locked
    And a player requests to change their roster due to injury
    When the admin considers unlocking the roster
    Then the system does not provide unlock functionality
    And the admin cannot override roster lock
    And the one-time draft model is strictly enforced
