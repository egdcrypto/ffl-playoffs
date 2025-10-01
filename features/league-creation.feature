Feature: League Creation and Configuration
  As an admin
  I want to create and configure fantasy football leagues
  So that players can participate in customized competitions

  Background:
    Given a user with ADMIN role exists
    And the admin is authenticated

  Scenario: Admin creates basic league with default configuration
    When the admin creates a new league with:
      | Field              | Value                |
      | Name               | Championship 2024    |
      | Description        | Season playoff pool  |
      | Starting Week      | 1                    |
      | Number of Weeks    | 4                    |
      | Max Players        | 20                   |
      | Privacy            | PRIVATE              |
    Then a new league is created with id "league-123"
    And the league owner is set to the admin
    And the league status is "DRAFT"
    And the league uses default roster configuration
    And the league uses default PPR scoring rules

  Scenario: Admin configures custom roster structure
    When the admin creates a league with custom roster configuration:
      | Position   | Count |
      | QB         | 1     |
      | RB         | 3     |
      | WR         | 3     |
      | TE         | 1     |
      | FLEX       | 2     |
      | K          | 1     |
      | DEF        | 1     |
      | Superflex  | 1     |
    Then the league total roster size is 13 positions
    And each position slot is defined with eligible positions
    And the FLEX slot accepts RB, WR, or TE
    And the Superflex slot accepts QB, RB, WR, or TE

  Scenario: Admin sets league to start at NFL week 15 (playoffs)
    When the admin creates a league with:
      | Starting Week   | 15 |
      | Number of Weeks | 4  |
    Then the league starts at NFL week 15
    And the league runs through NFL weeks 15, 16, 17, 18
    And the league covers the NFL playoffs period

  Scenario: Admin creates mid-season league
    When the admin creates a league with:
      | Starting Week   | 8  |
      | Number of Weeks | 6  |
    Then the league starts at NFL week 8
    And the league runs through NFL weeks 8-13
    And the system validates: 8 + 6 - 1 = 13 ≤ 22

  Scenario: Admin attempts to create league exceeding NFL season
    When the admin attempts to create a league with:
      | Starting Week   | 18 |
      | Number of Weeks | 6  |
    Then the request is rejected with error "EXCEEDS_NFL_SEASON"
    And the system shows validation error: "18 + 6 - 1 = 23 > 22"
    And no league is created

  Scenario: Admin configures custom PPR scoring rules
    When the admin creates a league with custom PPR scoring:
      | Passing yards per point   | 20   |
      | Passing TD                | 6    |
      | Interception              | -1   |
      | Rushing yards per point   | 10   |
      | Rushing TD                | 6    |
      | Reception (PPR)           | 0.5  |
      | Receiving TD              | 6    |
    Then the league uses Half-PPR scoring (0.5 per reception)
    And the league uses custom passing points configuration

  Scenario: Admin configures custom field goal scoring
    When the admin creates a league with custom field goal scoring:
      | Distance Range | Points |
      | 0-39 yards     | 3      |
      | 40-49 yards    | 5      |
      | 50+ yards      | 7      |
    Then the league uses custom field goal scoring rules
    And long field goals are worth more points

  Scenario: Admin configures custom defensive scoring
    When the admin creates a league with custom defensive scoring:
      | Sack                   | 2   |
      | Interception           | 3   |
      | Fumble Recovery        | 3   |
      | Safety                 | 4   |
      | Defensive/ST TD        | 8   |
    And custom points allowed tiers
    And custom yards allowed tiers
    Then the league uses custom defensive scoring rules

  Scenario: Admin sets roster lock deadline
    Given the first NFL game of week 1 starts on "2024-09-05 20:20:00 ET"
    When the admin sets roster lock deadline to "2024-09-05 20:00:00 ET"
    Then the roster lock is set to 20 minutes before first game
    And the configuration is validated and accepted

  Scenario: Admin attempts to set roster lock after first game
    Given the first NFL game of week 1 starts on "2024-09-05 20:20:00 ET"
    When the admin attempts to set roster lock to "2024-09-05 21:00:00 ET"
    Then the request is rejected with error "LOCK_AFTER_GAME_START"
    And the system shows "Roster lock must be before first game starts"

  Scenario: Admin creates public league
    When the admin creates a league with privacy "PUBLIC"
    Then the league is discoverable by all users
    And players can request to join the league

  Scenario: Admin creates private league
    When the admin creates a league with privacy "PRIVATE"
    Then the league is not discoverable
    And players can only join via invitation

  Scenario: Admin sets maximum player capacity
    When the admin creates a league with maxPlayers set to 12
    Then the league can have up to 12 players
    And invitations are rejected once 12 players have joined

  Scenario: Admin creates league with minimum configuration
    When the admin creates a league with minimal required fields:
      | Name            | Quick League |
      | Starting Week   | 1            |
      | Number of Weeks | 1            |
    And at least 1 roster position is defined
    Then the league is created successfully
    And default values are applied for optional fields

  Scenario: Admin attempts to create league with no roster positions
    When the admin attempts to create a league with:
      | QB  | 0 |
      | RB  | 0 |
      | WR  | 0 |
      | TE  | 0 |
    Then the request is rejected with error "NO_ROSTER_POSITIONS"
    And the system shows "At least 1 position slot required"

  Scenario: Admin activates league
    Given the admin has created a league with status "DRAFT"
    And the league configuration is complete
    When the admin activates the league
    Then the league status changes to "ACTIVE"
    And players can now join and build rosters
    And the league configuration can still be modified until first game starts

  Scenario: Admin deactivates league before first game
    Given the admin has an active league
    And the first game has not started
    When the admin deactivates the league
    Then the league status changes to "INACTIVE"
    And players cannot join or modify rosters

  Scenario: Admin clones settings from previous league
    Given the admin has a previous league "2023 Championship" with custom configuration
    When the admin creates a new league and clones settings from "2023 Championship"
    Then the new league inherits all configuration from "2023 Championship"
    And the new league has roster configuration, scoring rules, and deadlines copied
    And the admin can modify the cloned settings before activation

  Scenario: Admin views all their leagues
    Given the admin owns 5 leagues
    When the admin requests their league list
    Then the system returns all 5 leagues
    And each league shows: name, status, starting week, player count, lock status

  Scenario: Admin cannot manage leagues they don't own
    Given another admin owns league "league-456"
    When the admin attempts to modify league "league-456"
    Then the request is rejected with 403 Forbidden
    And no changes are applied to the league

  Scenario: Admin views league lock status before first game
    Given the admin has an active league
    And the first NFL game starts in 2 hours
    When the admin views the league configuration
    Then the system shows "Configuration locks in: 2 hours"
    And the system displays countdown timer
    And the admin can make changes before lock

  Scenario: League configuration becomes immutable when first game starts
    Given the admin has an active league
    And the first NFL game of the starting week begins
    When the league lock system runs
    Then the league configuration is automatically locked
    And the league lockReason is set to "FIRST_GAME_STARTED"
    And the league lockTimestamp is set to first game start time
