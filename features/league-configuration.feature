Feature: League Configuration
  As an Admin
  I want to configure league settings including start week, duration, and scoring rules
  So that I can customize the game experience for my players

  Background:
    Given I am authenticated as an admin
    And I have created a league

  # Starting Week and Duration Configuration

  Scenario: Configure league to start at NFL week 1 (default)
    When the admin sets the league startingWeek to 1
    And the admin sets numberOfWeeks to 4
    Then the league configuration is saved
    And the league will cover NFL weeks 1, 2, 3, 4

  Scenario: Configure league for playoff weeks only
    When the admin sets the league startingWeek to 15
    And the admin sets numberOfWeeks to 4
    Then the league configuration is saved
    And the league will cover NFL weeks 15, 16, 17, 18
    And league week 1 maps to NFL week 15
    And league week 2 maps to NFL week 16
    And league week 3 maps to NFL week 17
    And league week 4 maps to NFL week 18

  Scenario: Configure mid-season league
    When the admin sets the league startingWeek to 8
    And the admin sets numberOfWeeks to 6
    Then the league will cover NFL weeks 8, 9, 10, 11, 12, 13

  Scenario Outline: Valid league configurations
    When the admin sets startingWeek to <startWeek> and numberOfWeeks to <numWeeks>
    Then the configuration is valid
    And the final NFL week is <finalWeek>

    Examples:
      | startWeek | numWeeks | finalWeek |
      | 1         | 1        | 1         |
      | 1         | 17       | 17        |
      | 5         | 10       | 14        |
      | 10        | 8        | 17        |
      | 15        | 4        | 18        |
      | 18        | 1        | 18        |

  Scenario Outline: Invalid league configurations
    When the admin sets startingWeek to <startWeek> and numberOfWeeks to <numWeeks>
    Then the configuration is rejected with error "<error>"

    Examples:
      | startWeek | numWeeks | error                      |
      | 0         | 4        | INVALID_STARTING_WEEK      |
      | 19        | 4        | INVALID_STARTING_WEEK      |
      | 5         | 0        | INVALID_NUMBER_OF_WEEKS    |
      | 5         | 18       | INVALID_NUMBER_OF_WEEKS    |
      | 15        | 5        | LEAGUE_EXCEEDS_NFL_SEASON  |
      | 18        | 2        | LEAGUE_EXCEEDS_NFL_SEASON  |

  Scenario: Validation prevents exceeding NFL week 18
    When the admin attempts to set startingWeek=16 and numberOfWeeks=4
    Then the request is rejected
    And the error is "startingWeek (16) + numberOfWeeks (4) - 1 = 19 exceeds NFL week 18"

  # Week Mapping

  Scenario: Week entities are created based on configuration
    Given the admin sets startingWeek=10 and numberOfWeeks=4
    When the league is activated
    Then 4 week entities are created
    And week 1 has nflWeekNumber = 10
    And week 2 has nflWeekNumber = 11
    And week 3 has nflWeekNumber = 12
    And week 4 has nflWeekNumber = 13

  Scenario: Players select teams for NFL weeks, not league weeks
    Given the league starts at NFL week 15
    And the league has 4 weeks
    When a player makes selections
    Then the player selects a team for NFL week 15 in league week 1
    And the player selects a team for NFL week 16 in league week 2
    And the player selects a team for NFL week 17 in league week 3
    And the player selects a team for NFL week 18 in league week 4

  # PPR Scoring Configuration

  Scenario: Configure custom PPR scoring rules
    When the admin configures PPR scoring:
      | passingYardsPerPoint   | 25  |
      | rushingYardsPerPoint   | 10  |
      | receivingYardsPerPoint | 10  |
      | receptionPoints        | 1   |
      | touchdownPoints        | 6   |
      | extraPointPoints       | 1   |
      | twoPointConversionPoints | 2 |
    Then the PPR scoring rules are saved
    And the league uses these custom rules for scoring

  Scenario: Use default PPR scoring rules
    When the admin does not configure custom PPR rules
    Then the league uses default PPR scoring:
      | passingYardsPerPoint   | 25  |
      | rushingYardsPerPoint   | 10  |
      | receivingYardsPerPoint | 10  |
      | receptionPoints        | 1   |
      | touchdownPoints        | 6   |

  Scenario: Prevent invalid PPR scoring values
    When the admin sets receptionPoints to -1
    Then the request is rejected with error "INVALID_SCORING_VALUE"
    And the error message is "Scoring values must be non-negative"

  # Field Goal Scoring Configuration

  Scenario: Configure custom field goal scoring by distance
    When the admin configures field goal scoring:
      | fg0to39Points  | 3 |
      | fg40to49Points | 4 |
      | fg50PlusPoints | 5 |
    Then the field goal scoring rules are saved

  Scenario: Configure higher points for long field goals
    When the admin configures field goal scoring:
      | fg0to39Points  | 2 |
      | fg40to49Points | 5 |
      | fg50PlusPoints | 7 |
    Then the field goal scoring rules are saved
    And 50+ yard field goals score 7 points

  Scenario: Use default field goal scoring
    When the admin does not configure field goal rules
    Then the league uses default field goal scoring:
      | fg0to39Points  | 3 |
      | fg40to49Points | 4 |
      | fg50PlusPoints | 5 |

  # Defensive Scoring Configuration

  Scenario: Configure custom defensive play scoring
    When the admin configures defensive scoring:
      | sackPoints           | 1 |
      | interceptionPoints   | 2 |
      | fumbleRecoveryPoints | 2 |
      | safetyPoints         | 2 |
      | defensiveTDPoints    | 6 |
    Then the defensive scoring rules are saved

  Scenario: Configure defensive points allowed tiers
    When the admin configures points allowed tiers:
      | pointsAllowedRange | fantasyPoints |
      | 0                  | 10            |
      | 1-6                | 7             |
      | 7-13               | 4             |
      | 14-20              | 1             |
      | 21-27              | 0             |
      | 28-34              | -1            |
      | 35+                | -4            |
    Then the points allowed tiers are saved

  Scenario: Configure custom defensive yards allowed tiers
    When the admin configures yards allowed tiers:
      | yardsAllowedRange | fantasyPoints |
      | 0-99              | 10            |
      | 100-199           | 7             |
      | 200-299           | 5             |
      | 300-349           | 3             |
      | 350-399           | 0             |
      | 400-449           | -3            |
      | 450+              | -5            |
    Then the yards allowed tiers are saved

  Scenario: Use default defensive scoring rules
    When the admin does not configure defensive rules
    Then the league uses default defensive scoring
    And default points allowed tiers
    And default yards allowed tiers

  # Pick Deadline Configuration

  Scenario: Configure pick deadline for each week
    Given the league starts at NFL week 15
    And the league has 4 weeks
    When the admin sets the pick deadline for week 15 to "2024-12-15T13:00:00Z"
    And the admin sets the pick deadline for week 16 to "2024-12-22T13:00:00Z"
    And the admin sets the pick deadline for week 17 to "2024-12-29T13:00:00Z"
    And the admin sets the pick deadline for week 18 to "2025-01-05T13:00:00Z"
    Then all pick deadlines are saved

  Scenario: Default pick deadline is Sunday 1PM ET for each NFL week
    Given the league starts at NFL week 10
    When the admin does not configure custom deadlines
    Then the system sets default deadlines:
      | nflWeek | deadline               |
      | 10      | Sunday 1PM ET Week 10  |
      | 11      | Sunday 1PM ET Week 11  |
      | 12      | Sunday 1PM ET Week 12  |
      | 13      | Sunday 1PM ET Week 13  |

  # League Privacy Settings

  Scenario: Create a private league
    When the admin sets the league to "PRIVATE"
    Then only invited players can join
    And the league does not appear in public league listings

  Scenario: Create a public league
    When the admin sets the league to "PUBLIC"
    Then the league appears in public league listings
    And players can request to join

  # Maximum Players Configuration

  Scenario: Configure maximum number of players
    When the admin sets maxPlayers to 20
    Then the league can have up to 20 players
    When 20 players have joined
    Then new player invitations are blocked with error "LEAGUE_FULL"

  Scenario: Unlimited players in a league
    When the admin sets maxPlayers to null
    Then the league has no player limit
    And unlimited players can join

  # Configuration Locking

  Scenario: All settings can be modified before activation
    Given the league status is "DRAFT"
    When the admin modifies any setting
    Then the modification is allowed

  Scenario: Critical settings locked after activation
    Given the league status is "ACTIVE"
    When the admin attempts to change startingWeek
    Then the request is rejected with error "LEAGUE_ALREADY_ACTIVE"
    When the admin attempts to change numberOfWeeks
    Then the request is rejected with error "LEAGUE_ALREADY_ACTIVE"
    When the admin attempts to change scoring rules
    Then the request is rejected with error "LEAGUE_ALREADY_ACTIVE"

  Scenario: Non-critical settings can be modified after activation
    Given the league status is "ACTIVE"
    When the admin updates the league name
    Then the update is allowed
    When the admin updates the league description
    Then the update is allowed

  # Configuration Cloning

  Scenario: Clone configuration from another league
    Given the admin owns league "2023 Playoffs" with custom configuration
    When the admin creates a new league "2024 Playoffs"
    And selects to clone configuration from "2023 Playoffs"
    Then the new league inherits:
      | PPR scoring rules          |
      | Field goal scoring rules   |
      | Defensive scoring rules    |
      | Points allowed tiers       |
      | Yards allowed tiers        |
      | Pick deadline settings     |
      | Max players                |
      | Privacy settings           |
    But the new league has unique:
      | League ID          |
      | League name        |
      | Starting week      |
      | Number of weeks    |

  # Configuration Validation

  Scenario: Comprehensive configuration validation on activation
    Given the league has the following configuration:
      | startingWeek  | 15 |
      | numberOfWeeks | 4  |
      | minPlayers    | 2  |
    And the league has 5 players
    When the admin activates the league
    Then the system validates:
      | Configuration validity     | valid |
      | NFL week range validity    | valid |
      | Minimum players met        | valid |
      | Scoring rules completeness | valid |
    And the league is activated successfully

  Scenario: Activation fails with incomplete configuration
    Given the league has no scoring rules configured
    When the admin attempts to activate the league
    Then the request is rejected with error "INCOMPLETE_CONFIGURATION"
    And the error details specify "Scoring rules must be configured"

  # Multi-League Different Configurations

  Scenario: Admin manages multiple leagues with different configurations
    Given the admin owns league "Playoffs League"
    And "Playoffs League" starts at week 15 with 4 weeks
    And the admin owns league "Full Season League"
    And "Full Season League" starts at week 1 with 17 weeks
    When players make selections in each league
    Then each league uses its own configuration independently
    And team selections are scoped to each league
