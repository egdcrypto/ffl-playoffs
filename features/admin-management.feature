Feature: Admin Management
  As an Admin
  I want to create and manage leagues and invite players
  So that I can run fantasy football playoff games

  Background:
    Given I am authenticated as an admin with email "admin@example.com"

  # League Creation

  Scenario: Admin creates a new league with default settings
    When the admin creates a league with the following details:
      | name        | 2024 Playoffs Challenge |
      | description | 4-week playoff game      |
    Then a new league is created
    And the league owner is "admin@example.com"
    And the league starting week is 1 (default)
    And the league number of weeks is 4 (default)
    And the league status is "DRAFT"
    And the league has default PPR scoring rules
    And the league has default field goal scoring rules
    And the league has default defensive scoring rules

  Scenario: Admin creates a playoff-focused league starting at week 15
    When the admin creates a league with the following details:
      | name          | NFL Playoffs 2024        |
      | description   | Final 4 weeks of season  |
      | startingWeek  | 15                       |
      | numberOfWeeks | 4                        |
    Then a new league is created
    And the league starting week is 15
    And the league number of weeks is 4
    And the league covers NFL weeks 15, 16, 17, 18

  Scenario: Admin creates a mid-season challenge
    When the admin creates a league with the following details:
      | name          | Mid-Season Showdown |
      | description   | 6-week challenge    |
      | startingWeek  | 8                   |
      | numberOfWeeks | 6                   |
    Then a new league is created
    And the league starting week is 8
    And the league number of weeks is 6
    And the league covers NFL weeks 8, 9, 10, 11, 12, 13

  Scenario: Admin creates a full-season league
    When the admin creates a league with the following details:
      | name          | Full Season 2024 |
      | startingWeek  | 1                |
      | numberOfWeeks | 17               |
    Then a new league is created
    And the league covers NFL weeks 1 through 17

  Scenario: Prevent league creation that exceeds NFL season
    When the admin creates a league with the following details:
      | startingWeek  | 15 |
      | numberOfWeeks | 5  |
    Then the request is rejected with error "LEAGUE_EXCEEDS_NFL_SEASON"
    And the error message is "startingWeek (15) + numberOfWeeks (5) - 1 exceeds NFL week 18"

  Scenario: Prevent league creation with invalid starting week
    When the admin creates a league with startingWeek 0
    Then the request is rejected with error "INVALID_STARTING_WEEK"
    When the admin creates a league with startingWeek 19
    Then the request is rejected with error "INVALID_STARTING_WEEK"

  Scenario: Prevent league creation with invalid number of weeks
    When the admin creates a league with numberOfWeeks 0
    Then the request is rejected with error "INVALID_NUMBER_OF_WEEKS"
    When the admin creates a league with numberOfWeeks 18
    Then the request is rejected with error "INVALID_NUMBER_OF_WEEKS"

  # League Configuration

  Scenario: Admin configures custom scoring rules
    Given the admin has created a league
    When the admin configures the league with custom scoring:
      | passingYardsPerPoint  | 25  |
      | rushingYardsPerPoint  | 10  |
      | receivingYardsPerPoint| 10  |
      | receptionPoints       | 1   |
      | touchdownPoints       | 6   |
    Then the league scoring rules are updated
    And the custom scoring rules are persisted

  Scenario: Admin configures custom field goal scoring
    Given the admin has created a league
    When the admin configures field goal scoring:
      | fg0to39Points   | 3 |
      | fg40to49Points  | 4 |
      | fg50PlusPoints  | 5 |
    Then the league field goal scoring rules are updated

  Scenario: Admin configures custom defensive scoring
    Given the admin has created a league
    When the admin configures defensive scoring:
      | sackPoints             | 1 |
      | interceptionPoints     | 2 |
      | fumbleRecoveryPoints   | 2 |
      | safetyPoints           | 2 |
      | defensiveTDPoints      | 6 |
    Then the league defensive scoring rules are updated

  Scenario: Admin configures points allowed tiers
    Given the admin has created a league
    When the admin configures points allowed scoring tiers:
      | pointsAllowed | fantasyPoints |
      | 0             | 10            |
      | 1-6           | 7             |
      | 7-13          | 4             |
      | 14-20         | 1             |
      | 21-27         | 0             |
      | 28-34         | -1            |
      | 35+           | -4            |
    Then the points allowed tiers are persisted for the league

  Scenario: Admin modifies league settings before activation
    Given the admin has created a league
    And the league status is "DRAFT"
    When the admin updates the league name to "Updated League Name"
    Then the league name is updated successfully
    And the league status remains "DRAFT"

  Scenario: Prevent modification of critical settings after league activation
    Given the admin has created a league
    And the league status is "ACTIVE"
    When the admin attempts to change the startingWeek
    Then the request is rejected with error "LEAGUE_ALREADY_ACTIVE"
    When the admin attempts to change the numberOfWeeks
    Then the request is rejected with error "LEAGUE_ALREADY_ACTIVE"

  Scenario: Admin can modify non-critical settings after activation
    Given the admin has created a league
    And the league status is "ACTIVE"
    When the admin updates the league description
    Then the description is updated successfully

  # Player Invitation (League-Scoped)

  Scenario: Admin invites a player to their league
    Given the admin owns a league "Playoffs 2024"
    And there is no player with email "player@example.com"
    When the admin invites "player@example.com" to league "Playoffs 2024"
    Then a player invitation is created
    And the invitation is associated with league "Playoffs 2024"
    And an invitation email is sent to "player@example.com"
    And the invitation email includes the league name "Playoffs 2024"
    And the invitation status is "PENDING"

  Scenario: Player accepts invitation and joins league via Google OAuth
    Given a pending player invitation exists for "player@example.com" to league "Playoffs 2024"
    When the player clicks the invitation link
    And authenticates with Google OAuth using email "player@example.com"
    Then a new player account is created with role "PLAYER"
    And the account is linked to Google ID from OAuth
    And the player is added to league "Playoffs 2024" via LeaguePlayer junction table
    And the invitation status changes to "ACCEPTED"
    And the player can now access league "Playoffs 2024"

  Scenario: Existing player accepts invitation to a second league
    Given a player account exists for "player@example.com"
    And the player is a member of league "League A"
    And a pending invitation exists for "player@example.com" to league "League B"
    When the player accepts the invitation to "League B"
    Then the player is added to league "League B"
    And the player remains a member of league "League A"
    And the player can access both leagues

  Scenario: Admin can only invite players to their own leagues
    Given the admin owns league "My League"
    And another admin owns league "Other League"
    When the admin attempts to invite a player to "Other League"
    Then the request is rejected with error "UNAUTHORIZED_LEAGUE_ACCESS"

  Scenario: Admin views all players in their league
    Given the admin owns league "Playoffs 2024"
    And the league has 10 players
    When the admin requests the list of players for "Playoffs 2024"
    Then the response contains 10 player records
    And each record includes email, name, join date, and Google ID

  Scenario: Admin removes a player from their league
    Given the admin owns league "Playoffs 2024"
    And player "player@example.com" is a member of the league
    When the admin removes "player@example.com" from the league
    Then the player is no longer a member of "Playoffs 2024"
    And the player's team selections for that league are archived
    And the player can no longer access "Playoffs 2024"

  Scenario: Prevent duplicate player invitations to same league
    Given the admin owns league "Playoffs 2024"
    And a pending invitation exists for "player@example.com" to league "Playoffs 2024"
    When the admin sends another invitation to "player@example.com" for the same league
    Then the request is rejected with error "INVITATION_ALREADY_EXISTS"

  Scenario: Allow player invitation to different league
    Given the admin owns leagues "League A" and "League B"
    And player "player@example.com" is a member of "League A"
    When the admin invites "player@example.com" to "League B"
    Then a new invitation is created for "League B"
    And the invitation is sent successfully

  # League Management

  Scenario: Admin activates a league
    Given the admin owns league "Playoffs 2024"
    And the league status is "DRAFT"
    And the league has at least 2 players
    When the admin activates the league
    Then the league status changes to "ACTIVE"
    And the league configuration becomes locked
    And players can now make team selections

  Scenario: Admin cannot activate league without minimum players
    Given the admin owns league "Playoffs 2024"
    And the league has 0 players
    When the admin attempts to activate the league
    Then the request is rejected with error "INSUFFICIENT_PLAYERS"

  Scenario: Admin deactivates a league
    Given the admin owns league "Playoffs 2024"
    And the league status is "ACTIVE"
    When the admin deactivates the league
    Then the league status changes to "INACTIVE"
    And players can no longer make new team selections

  Scenario: Admin archives a completed league
    Given the admin owns league "Playoffs 2024"
    And the league has completed all weeks
    When the admin archives the league
    Then the league status changes to "ARCHIVED"
    And the league data is preserved for historical viewing
    And no modifications are allowed to the league

  Scenario: Admin clones settings from previous league
    Given the admin owns league "2023 Playoffs"
    And the league has custom scoring rules
    When the admin creates a new league and clones settings from "2023 Playoffs"
    Then a new league is created
    And the new league has the same scoring rules as "2023 Playoffs"
    And the new league has the same field goal rules as "2023 Playoffs"
    And the new league has the same defensive rules as "2023 Playoffs"
    And the new league has a unique ID and name

  Scenario: Admin views all their leagues
    Given the admin owns 5 leagues
    When the admin requests their list of leagues
    Then the response contains 5 league records
    And each record includes name, status, number of players, and start date

  # Error Cases

  Scenario: Non-admin cannot create leagues
    Given I am authenticated as a player
    When I attempt to create a league
    Then the request is rejected with 403 Forbidden

  Scenario: Admin cannot modify another admin's league
    Given another admin owns league "Other League"
    When I attempt to modify "Other League"
    Then the request is rejected with error "UNAUTHORIZED_LEAGUE_ACCESS"

  Scenario: Player invitation expires after 7 days
    Given an invitation was created 8 days ago for "expired@example.com"
    When the player attempts to accept the expired invitation
    Then the request is rejected with error "INVITATION_EXPIRED"
