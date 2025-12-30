Feature: League Configuration
  As an Admin
  I want to configure league settings including start week, duration, and scoring rules
  So that I can customize the game experience for my players

  Background:
    Given I am authenticated as an admin
    And I have created a league

  # =============================================================================
  # STARTING WEEK AND DURATION CONFIGURATION
  # =============================================================================

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

  Scenario: Configure single-week league for special events
    When the admin sets startingWeek to 17
    And the admin sets numberOfWeeks to 1
    Then the league is configured for exactly NFL week 17
    And this is valid for single-week playoff pools

  Scenario: Configure full regular season league
    When the admin sets startingWeek to 1
    And the admin sets numberOfWeeks to 18
    Then the league covers the entire NFL regular season
    And week entities 1-18 are created

  # =============================================================================
  # SEASON SELECTION
  # =============================================================================

  Scenario: Configure league for current NFL season
    When the admin creates a new league
    Then the league defaults to the current NFL season
    And the season year is automatically set

  Scenario: Configure league for upcoming season
    Given it is currently July 2024
    When the admin creates a league for the 2024 season
    Then the league is configured for the 2024-2025 NFL season
    And the league can be set up before the season starts

  Scenario: Cannot create league for past completed seasons
    Given it is currently March 2025
    When the admin attempts to create a league for the 2023 season
    Then the request is rejected with error "SEASON_COMPLETED"
    And the message is "Cannot create leagues for completed seasons"

  Scenario: Season affects NFL schedule data
    When the admin configures a league for the 2024 season
    Then the league uses 2024 NFL schedule data
    And game times are based on the 2024 schedule
    And bye weeks are based on 2024 team schedules

  # =============================================================================
  # WEEK MAPPING
  # =============================================================================

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

  Scenario: Week mapping is displayed to players
    Given the league starts at NFL week 10
    When a player views the schedule
    Then the display shows:
      | League Week | NFL Week | Status    |
      | 1           | 10       | Upcoming  |
      | 2           | 11       | Upcoming  |
      | 3           | 12       | Upcoming  |
      | 4           | 13       | Upcoming  |

  Scenario: Current week is calculated based on NFL schedule
    Given the league starts at NFL week 15
    And the current NFL week is 16
    When a player views the league
    Then league week 2 is shown as the current week
    And league week 1 is shown as completed

  # =============================================================================
  # SCORING FORMAT SELECTION
  # =============================================================================

  Scenario: Select standard scoring format
    When the admin selects scoring format "STANDARD"
    Then receptions do not score points
    And the base scoring rules are:
      | passingYardsPerPoint   | 25  |
      | rushingYardsPerPoint   | 10  |
      | receivingYardsPerPoint | 10  |
      | receptionPoints        | 0   |
      | touchdownPoints        | 6   |

  Scenario: Select half-PPR scoring format
    When the admin selects scoring format "HALF_PPR"
    Then receptions score 0.5 points each
    And the base scoring rules are:
      | passingYardsPerPoint   | 25  |
      | rushingYardsPerPoint   | 10  |
      | receivingYardsPerPoint | 10  |
      | receptionPoints        | 0.5 |
      | touchdownPoints        | 6   |

  Scenario: Select full PPR scoring format
    When the admin selects scoring format "FULL_PPR"
    Then receptions score 1 point each
    And the base scoring rules are:
      | passingYardsPerPoint   | 25  |
      | rushingYardsPerPoint   | 10  |
      | receivingYardsPerPoint | 10  |
      | receptionPoints        | 1   |
      | touchdownPoints        | 6   |

  Scenario: Select custom scoring format
    When the admin selects scoring format "CUSTOM"
    Then all scoring values are editable
    And the admin can configure each scoring category individually

  # =============================================================================
  # PPR SCORING CONFIGURATION
  # =============================================================================

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

  Scenario: Configure passing touchdown points separately
    When the admin configures:
      | passingTouchdownPoints   | 4 |
      | rushingTouchdownPoints   | 6 |
      | receivingTouchdownPoints | 6 |
    Then passing TDs score 4 points
    And rushing/receiving TDs score 6 points

  Scenario: Configure interception penalties
    When the admin configures:
      | interceptionThrownPoints | -2 |
    Then each interception thrown deducts 2 points from the QB

  Scenario: Configure fumble penalties
    When the admin configures:
      | fumbleLostPoints | -2 |
    Then each fumble lost deducts 2 points from the player

  Scenario: Configure decimal scoring precision
    When the admin enables decimal scoring
    Then yardage is calculated with decimal precision
    And a player with 47 rushing yards scores 4.7 points (at 10 yards per point)

  # =============================================================================
  # BONUS SCORING CONFIGURATION
  # =============================================================================

  Scenario: Configure yardage milestone bonuses
    When the admin configures bonus scoring:
      | 100_yard_rushing_bonus   | 3 |
      | 100_yard_receiving_bonus | 3 |
      | 300_yard_passing_bonus   | 3 |
      | 400_yard_passing_bonus   | 5 |
      | 200_yard_rushing_bonus   | 5 |
      | 200_yard_receiving_bonus | 5 |
    Then these bonuses are applied in addition to yardage points

  Scenario: Bonuses stack with base scoring
    Given a player rushes for 150 yards
    And 100-yard rushing bonus is 3 points
    When the score is calculated
    Then the player receives:
      | yardage points | 15  |
      | bonus points   | 3   |
      | total          | 18  |

  Scenario: Multiple bonuses can apply
    Given a player rushes for 210 yards
    And 100-yard rushing bonus is 3 points
    And 200-yard rushing bonus is 5 points
    When the score is calculated
    Then both bonuses apply
    And the player receives 21 + 3 + 5 = 29 points

  Scenario: Configure long touchdown bonuses
    When the admin configures:
      | longTouchdownBonus       | 2  |
      | longTouchdownThreshold   | 40 |
    Then touchdowns of 40+ yards receive an extra 2 points

  Scenario: Configure big play bonuses
    When the admin configures:
      | longRushBonus            | 1  |
      | longRushThreshold        | 25 |
      | longReceptionBonus       | 1  |
      | longReceptionThreshold   | 25 |
    Then runs of 25+ yards receive 1 bonus point
    And receptions of 25+ yards receive 1 bonus point

  Scenario: Disable all bonuses
    When the admin disables bonus scoring
    Then no milestone bonuses are applied
    And only base yardage and touchdown points count

  # =============================================================================
  # FIELD GOAL SCORING CONFIGURATION
  # =============================================================================

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

  Scenario: Configure missed field goal penalties
    When the admin configures:
      | missedFg0to39Points  | -1 |
      | missedFg40to49Points | 0  |
      | missedFg50PlusPoints | 0  |
    Then missed short field goals are penalized
    And missed long field goals have no penalty

  Scenario: Configure extra point scoring
    When the admin configures:
      | extraPointMadePoints   | 1  |
      | extraPointMissedPoints | -1 |
    Then made PATs score 1 point
    And missed PATs deduct 1 point

  Scenario: Configure granular field goal distance tiers
    When the admin configures field goal scoring:
      | fg0to29Points   | 2 |
      | fg30to39Points  | 3 |
      | fg40to49Points  | 4 |
      | fg50to59Points  | 5 |
      | fg60PlusPoints  | 6 |
    Then 5 distance tiers are configured
    And each tier has separate point values

  # =============================================================================
  # DEFENSIVE SCORING CONFIGURATION
  # =============================================================================

  Scenario: Configure custom defensive play scoring
    When the admin configures defensive scoring:
      | sackPoints           | 1 |
      | interceptionPoints   | 2 |
      | fumbleRecoveryPoints | 2 |
      | safetyPoints         | 2 |
      | defensiveTDPoints    | 6 |
    Then the defensive scoring rules are saved

  Scenario: Configure points allowed tiers
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

  Scenario: Configure additional defensive stats
    When the admin configures:
      | blockedKickPoints    | 2 |
      | blockedPuntPoints    | 2 |
      | forcedFumblePoints   | 1 |
      | tackleForLossPoints  | 0.5 |
      | passDefensedPoints   | 0.5 |
    Then extended defensive stats are scored

  Scenario: Configure special teams scoring
    When the admin configures:
      | kickReturnTDPoints  | 6 |
      | puntReturnTDPoints  | 6 |
      | returnYardsPerPoint | 25 |
    Then special teams returns are scored
    And return TDs are worth 6 points

  # =============================================================================
  # PICK DEADLINE CONFIGURATION
  # =============================================================================

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

  Scenario: Configure deadline based on first game of week
    When the admin selects "FIRST_GAME" deadline type
    Then pick deadlines are automatically set to the first game kickoff for each week
    And Thursday Night Football starts lock the picks

  Scenario: Configure deadline with buffer time
    When the admin sets deadline buffer to 15 minutes
    Then pick deadlines are 15 minutes before the first game
    And players have time before lockout

  Scenario: Configure Saturday deadline for all weeks
    When the admin selects "SATURDAY_MIDNIGHT" deadline type
    Then all pick deadlines are Saturday 11:59 PM ET
    And this provides a consistent deadline

  Scenario: Configure per-game deadlines
    When the admin enables per-game deadlines
    Then each player selection locks at that game's kickoff
    And players can modify selections until each game starts

  Scenario: Deadline time zone display
    When a player in Pacific time views deadlines
    Then deadlines are displayed in PT
    And a player in Eastern time sees deadlines in ET
    And the underlying UTC time is consistent

  # =============================================================================
  # ELIMINATION RULES CONFIGURATION
  # =============================================================================

  Scenario: Configure elimination mode
    When the admin enables elimination mode
    Then players with lowest scores are eliminated each week
    And eliminated players cannot make picks in future weeks

  Scenario: Configure players eliminated per week
    When the admin configures elimination:
      | playersPerWeek | 1 |
    Then 1 player is eliminated each week
    And the player with the lowest score is eliminated

  Scenario: Configure elimination with tiebreaker
    When the admin configures elimination:
      | eliminateOnTies       | false |
      | tiebreakerMethod      | PREVIOUS_WEEK_SCORE |
    Then ties at the elimination line are broken by previous week score
    And if still tied, both players survive

  Scenario: Configure variable elimination per week
    When the admin configures elimination:
      | week1Eliminations | 2 |
      | week2Eliminations | 2 |
      | week3Eliminations | 1 |
      | week4Eliminations | 0 |
    Then elimination counts vary by week
    And week 4 (championship) has no eliminations

  Scenario: Configure minimum players remaining
    When the admin configures elimination:
      | minimumPlayers | 2 |
    Then at least 2 players remain for the final week
    And elimination stops when 2 players remain

  Scenario: Disable elimination mode
    When the admin disables elimination mode
    Then all players compete every week
    And the winner is determined by cumulative score

  Scenario: Configure elimination protection
    When the admin enables immunity protection
    Then the highest scorer each week cannot be eliminated the following week
    And immunity is displayed on leaderboards

  # =============================================================================
  # LEAGUE PRIVACY SETTINGS
  # =============================================================================

  Scenario: Create a private league
    When the admin sets the league to "PRIVATE"
    Then only invited players can join
    And the league does not appear in public league listings

  Scenario: Create a public league
    When the admin sets the league to "PUBLIC"
    Then the league appears in public league listings
    And players can request to join

  Scenario: Configure join approval for public leagues
    Given the league is set to "PUBLIC"
    When the admin enables join approval
    Then players must be approved by admin to join
    And pending requests are shown in admin dashboard

  Scenario: Configure password protection
    When the admin sets league password to "secret123"
    Then players must enter the password to join
    And the password is not visible after setting

  Scenario: Configure invite link expiration
    When the admin configures invite links to expire in 7 days
    Then invite links become invalid after 7 days
    And expired links show "Invitation expired" message

  # =============================================================================
  # MAXIMUM PLAYERS CONFIGURATION
  # =============================================================================

  Scenario: Configure maximum number of players
    When the admin sets maxPlayers to 20
    Then the league can have up to 20 players
    When 20 players have joined
    Then new player invitations are blocked with error "LEAGUE_FULL"

  Scenario: Unlimited players in a league
    When the admin sets maxPlayers to null
    Then the league has no player limit
    And unlimited players can join

  Scenario: Configure minimum players to start
    When the admin sets minPlayers to 4
    Then the league requires at least 4 players to activate
    And activation fails with fewer than 4 players

  Scenario: Waitlist when league is full
    Given the league has maxPlayers = 20
    And 20 players have joined
    When the admin enables waitlist
    Then additional players can join the waitlist
    And waitlisted players are added if spots open

  # =============================================================================
  # CONFIGURATION LOCKING
  # =============================================================================

  Scenario: All settings can be modified before first game starts
    Given the league status is "ACTIVE"
    And the league starts at NFL week 15
    And the first game of NFL week 15 starts on "2024-12-15 13:00:00 ET"
    And the current time is "2024-12-15 10:00:00 ET"
    When the admin modifies any league setting
    Then the modification is allowed
    And the league configuration is still mutable

  Scenario: ALL configuration becomes immutable once first game starts
    Given the league starts at NFL week 15
    And the first game of NFL week 15 started at "2024-12-15 13:00:00 ET"
    And the current time is "2024-12-15 13:01:00 ET"
    When the admin attempts to change any configuration setting
    Then the request is rejected with error "LEAGUE_STARTED_CONFIGURATION_LOCKED"
    And the error message is "Configuration cannot be changed after first game starts"

  Scenario: Cannot change scoring rules after first game starts
    Given the league started 2 hours ago (first NFL game began)
    When the admin attempts to modify PPR scoring rules
    Then the request is rejected with error "LEAGUE_STARTED_CONFIGURATION_LOCKED"
    When the admin attempts to modify field goal scoring rules
    Then the request is rejected with error "LEAGUE_STARTED_CONFIGURATION_LOCKED"
    When the admin attempts to modify defensive scoring rules
    Then the request is rejected with error "LEAGUE_STARTED_CONFIGURATION_LOCKED"

  Scenario: Cannot change league duration after first game starts
    Given the league started 1 day ago
    When the admin attempts to change startingWeek
    Then the request is rejected with error "LEAGUE_STARTED_CONFIGURATION_LOCKED"
    When the admin attempts to change numberOfWeeks
    Then the request is rejected with error "LEAGUE_STARTED_CONFIGURATION_LOCKED"

  Scenario: Cannot change league name or description after first game starts
    Given the league started 3 hours ago
    When the admin attempts to update the league name
    Then the request is rejected with error "LEAGUE_STARTED_CONFIGURATION_LOCKED"
    When the admin attempts to update the league description
    Then the request is rejected with error "LEAGUE_STARTED_CONFIGURATION_LOCKED"

  Scenario: Cannot change privacy settings after first game starts
    Given the league started yesterday
    When the admin attempts to change the league from PRIVATE to PUBLIC
    Then the request is rejected with error "LEAGUE_STARTED_CONFIGURATION_LOCKED"

  Scenario: Cannot change max players after first game starts
    Given the league started 5 days ago
    When the admin attempts to increase maxPlayers from 20 to 30
    Then the request is rejected with error "LEAGUE_STARTED_CONFIGURATION_LOCKED"

  Scenario: Cannot change pick deadlines after first game starts
    Given the league started at NFL week 15
    And the league is now in week 2 (NFL week 16)
    When the admin attempts to modify the pick deadline for week 3
    Then the request is rejected with error "LEAGUE_STARTED_CONFIGURATION_LOCKED"

  Scenario: League lock is based on NFL game start time, not activation
    Given the league is activated at "2024-12-14 09:00:00 ET"
    And the first game of NFL week 15 starts at "2024-12-15 13:00:00 ET"
    And the current time is "2024-12-14 15:00:00 ET"
    Then the league is activated but not locked
    And configuration can still be modified
    When the current time advances to "2024-12-15 13:00:01 ET"
    Then the league configuration becomes permanently locked
    And no further modifications are allowed

  Scenario: View league lock status
    Given the league starts at NFL week 15
    When the admin requests league details
    Then the response includes:
      | configurationLocked    | true/false          |
      | lockTimestamp          | <first-game-start>  |
      | lockReason             | FIRST_GAME_STARTED  |

  Scenario: Warning displayed before configuration locks
    Given the league is activated
    And the first game starts in 2 hours
    When the admin views the league configuration page
    Then a warning is displayed:
      """
      Configuration will become permanently locked when the first game starts at 2024-12-15 13:00:00 ET (in 2 hours).
      Make any final changes now.
      """

  Scenario: Audit log captures attempted modifications after lock
    Given the league configuration is locked
    When the admin attempts to modify any setting
    Then the attempt is rejected
    And an audit log entry is created:
      | action       | CONFIG_MODIFICATION_REJECTED  |
      | adminId      | <admin-id>                    |
      | reason       | LEAGUE_STARTED                |
      | attemptedAt  | <timestamp>                   |

  Scenario Outline: All settings become immutable after first game
    Given the league started <time> ago
    When the admin attempts to change <setting>
    Then the request is rejected with error "LEAGUE_STARTED_CONFIGURATION_LOCKED"

    Examples:
      | time      | setting                           |
      | 1 minute  | startingWeek                      |
      | 1 hour    | numberOfWeeks                     |
      | 1 day     | PPR scoring rules                 |
      | 2 days    | field goal scoring rules          |
      | 1 week    | defensive scoring rules           |
      | 1 minute  | points allowed tiers              |
      | 1 hour    | yards allowed tiers               |
      | 1 day     | league name                       |
      | 2 days    | league description                |
      | 1 week    | privacy settings (public/private) |
      | 1 minute  | max players                       |
      | 1 hour    | pick deadlines                    |
      | 1 day     | elimination mode                  |

  # =============================================================================
  # TIEBREAKER RULES CONFIGURATION
  # =============================================================================

  Scenario: Configure tiebreaker rules
    When the admin configures tiebreakers:
      | priority | method              |
      | 1        | HEAD_TO_HEAD        |
      | 2        | TOTAL_POINTS        |
      | 3        | HIGHEST_SINGLE_WEEK |
    Then tiebreakers are applied in priority order

  Scenario: Configure bench scoring as tiebreaker
    When the admin enables bench points as tiebreaker
    Then if starters tie, bench points break the tie
    And this encourages deep roster management

  Scenario: Configure random tiebreaker as last resort
    When the admin sets final tiebreaker to "RANDOM"
    Then after all other methods, a random selection is made
    And the random result is logged for transparency

  Scenario: Configure no tiebreaker (ties allowed)
    When the admin disables tiebreakers
    Then tied players share the same rank
    And tied players both receive the same prize (if applicable)

  # =============================================================================
  # NOTIFICATION PREFERENCES
  # =============================================================================

  Scenario: Configure league notification settings
    When the admin configures notifications:
      | pickDeadlineReminder     | 24_HOURS_BEFORE |
      | scoreUpdates             | REAL_TIME       |
      | eliminationNotifications | ENABLED         |
      | leagueAnnouncements      | ENABLED         |
    Then notification settings are saved for the league

  Scenario: Configure deadline reminder timing
    When the admin sets deadline reminders:
      | 24 hours before |
      | 1 hour before   |
      | 15 minutes before |
    Then players receive 3 reminder notifications

  Scenario: Configure score update frequency
    When the admin sets score updates to "AFTER_EACH_GAME"
    Then players receive score notifications after each game
    And not during live gameplay

  Scenario: Configure digest notifications
    When the admin enables weekly digest
    Then players receive a summary email each week
    And the digest includes standings and upcoming matchups

  # =============================================================================
  # CONFIGURATION CLONING
  # =============================================================================

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

  Scenario: Clone configuration from league template
    Given a league template "Standard PPR" exists
    When the admin creates a new league using template "Standard PPR"
    Then all scoring rules from the template are applied
    And the admin can modify individual settings

  Scenario: Save current configuration as template
    Given the admin has configured a league
    When the admin saves the configuration as template "My Custom Rules"
    Then the template is saved for future use
    And other admins in the organization can use this template

  # =============================================================================
  # CONFIGURATION VALIDATION
  # =============================================================================

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

  Scenario: Validate scoring rule consistency
    When the admin configures inconsistent scoring:
      | touchdownPoints        | 6 |
      | passingTouchdownPoints | 4 |
    Then the system applies the more specific rule
    And passing TDs are 4 points, other TDs are 6 points

  Scenario: Validate defensive tier ranges
    When the admin configures overlapping points allowed tiers
    Then the request is rejected with error "OVERLAPPING_TIER_RANGES"
    And the error message specifies which ranges overlap

  Scenario: Validate all required fields before activation
    When the admin attempts to activate an incomplete league
    Then the response includes a list of missing fields:
      | scoring format          |
      | roster configuration    |
      | pick deadline type      |
    And each missing field links to its configuration section

  # =============================================================================
  # MULTI-LEAGUE DIFFERENT CONFIGURATIONS
  # =============================================================================

  Scenario: Admin manages multiple leagues with different configurations
    Given the admin owns league "Playoffs League"
    And "Playoffs League" starts at week 15 with 4 weeks
    And the admin owns league "Full Season League"
    And "Full Season League" starts at week 1 with 17 weeks
    When players make selections in each league
    Then each league uses its own configuration independently
    And team selections are scoped to each league

  Scenario: Player in multiple leagues sees different rules
    Given player is in "PPR League" with full PPR scoring
    And player is in "Standard League" with no reception points
    When the player views scoring rules
    Then each league displays its own rules
    And scores are calculated per league configuration

  # =============================================================================
  # ROSTER CONFIGURATION
  # =============================================================================

  Scenario: Configure standard roster with all positions
    Given the admin is configuring a new league
    When the admin sets roster configuration:
      | position   | slots |
      | QB         | 1     |
      | RB         | 2     |
      | WR         | 2     |
      | TE         | 1     |
      | FLEX       | 1     |
      | K          | 1     |
      | DEF        | 1     |
    Then the roster configuration is saved
    And the total roster size is 9
    And all league players must fill 9 position slots

  Scenario: Configure superflex roster
    Given the admin is configuring a new league
    When the admin sets roster configuration:
      | position   | slots |
      | QB         | 1     |
      | RB         | 2     |
      | WR         | 3     |
      | TE         | 1     |
      | FLEX       | 1     |
      | SUPERFLEX  | 1     |
      | K          | 1     |
      | DEF        | 1     |
    Then the roster configuration is saved
    And the total roster size is 11
    And the SUPERFLEX slot accepts QB, RB, WR, or TE

  Scenario: Roster configuration with multiple RBs and WRs
    Given the admin is configuring a new league
    When the admin sets roster configuration:
      | position   | slots |
      | QB         | 1     |
      | RB         | 3     |
      | WR         | 3     |
      | TE         | 1     |
      | FLEX       | 2     |
      | K          | 1     |
      | DEF        | 1     |
    Then the roster configuration is saved
    And the total roster size is 12

  Scenario: Minimum roster configuration validation
    Given the admin is configuring a new league
    When the admin attempts to save roster configuration:
      | position   | slots |
      | RB         | 2     |
      | WR         | 2     |
    Then the configuration is rejected
    And the error message is "Roster must have at least 1 QB or 1 SUPERFLEX slot"

  Scenario: Maximum roster size validation
    Given the admin is configuring a new league
    When the admin attempts to save roster configuration with 25 total slots
    Then the configuration is rejected
    And the error message is "Roster configuration cannot exceed 20 total slots"

  Scenario: Roster configuration cannot be changed after league starts
    Given the league is configured with standard roster (9 players)
    And the league has started
    When the admin attempts to change roster configuration
    Then the modification is rejected
    And the error message is "Configuration cannot be modified after the first game has started"

  Scenario: Each league can have different roster configuration
    Given admin1 creates "League A" with 9-player roster (1 QB, 2 RB, 2 WR, 1 TE, 1 FLEX, 1 K, 1 DEF)
    And admin2 creates "League B" with 11-player superflex roster
    When players join each league
    Then "League A" players must fill 9 position slots
    And "League B" players must fill 11 position slots
    And roster requirements are independent per league

  Scenario: Configure TE premium scoring
    When the admin enables TE premium:
      | teReceptionPoints | 1.5 |
    Then tight end receptions score 1.5 points
    And other positions still score 1 point per reception

  # =============================================================================
  # API ENDPOINTS
  # =============================================================================

  Scenario: Get league configuration endpoint
    When a GET request is sent to "/api/v1/leagues/{id}/configuration"
    Then the response status is 200
    And the response includes all configuration settings

  Scenario: Update league configuration endpoint
    When a PUT request is sent to "/api/v1/leagues/{id}/configuration" with:
      | startingWeek  | 15  |
      | numberOfWeeks | 4   |
    Then the response status is 200
    And the configuration is updated

  Scenario: Get scoring rules endpoint
    When a GET request is sent to "/api/v1/leagues/{id}/scoring-rules"
    Then the response status is 200
    And the response includes all scoring categories

  Scenario: Update scoring rules endpoint
    When a PUT request is sent to "/api/v1/leagues/{id}/scoring-rules" with scoring data
    Then the response status is 200
    And the scoring rules are updated

  Scenario: Get roster configuration endpoint
    When a GET request is sent to "/api/v1/leagues/{id}/roster-configuration"
    Then the response status is 200
    And the response includes position slots

  Scenario: Validate configuration endpoint
    When a POST request is sent to "/api/v1/leagues/{id}/configuration/validate"
    Then the response status is 200
    And the response includes validation results for each setting

  Scenario: Clone configuration endpoint
    When a POST request is sent to "/api/v1/leagues/{id}/configuration/clone" with:
      | sourceLeagueId | <source-id> |
    Then the response status is 200
    And the configuration is cloned

  Scenario: Get configuration lock status endpoint
    When a GET request is sent to "/api/v1/leagues/{id}/configuration/lock-status"
    Then the response status is 200
    And the response includes:
      | locked       | true/false          |
      | lockTime     | <timestamp>         |
      | lockReason   | FIRST_GAME_STARTED  |

  # =============================================================================
  # CONFIGURATION HISTORY AND VERSIONING
  # =============================================================================

  Scenario: Configuration changes are tracked
    When the admin modifies scoring rules
    Then a configuration history entry is created
    And the entry includes before and after values
    And the entry includes the admin who made the change

  Scenario: View configuration history
    When the admin requests configuration history
    Then all past changes are returned
    And changes are sorted by timestamp descending
    And each entry shows what was changed

  Scenario: Compare configuration versions
    Given the configuration has been modified 3 times
    When the admin compares version 1 with version 3
    Then differences are highlighted
    And added/removed/changed values are shown

  Scenario: Revert to previous configuration
    Given the league has not started
    When the admin reverts to a previous configuration version
    Then all settings are restored to that version
    And a new history entry records the revert

  # =============================================================================
  # IMPORT AND EXPORT CONFIGURATION
  # =============================================================================

  Scenario: Export configuration to JSON
    When the admin exports league configuration
    Then a JSON file is downloaded
    And the file contains all configuration settings
    And the file can be used to create new leagues

  Scenario: Import configuration from JSON
    Given the admin has a configuration JSON file
    When the admin imports the configuration
    Then all settings are applied to the league
    And the admin can review changes before saving

  Scenario: Export configuration to spreadsheet
    When the admin exports scoring rules as CSV
    Then a CSV file is generated
    And the file can be opened in Excel or Google Sheets
    And the admin can share rules with players

  # =============================================================================
  # COMMISSIONER CONTROLS
  # =============================================================================

  Scenario: Transfer commissioner rights
    When the admin transfers commissioner to another admin
    Then the new admin can modify configuration
    And the original admin retains admin access but cannot configure

  Scenario: Add co-commissioner
    When the admin adds a co-commissioner
    Then both admins can modify configuration
    And changes by either are tracked

  Scenario: Commissioner override for special circumstances
    Given a league rule dispute occurs
    When the commissioner applies a score adjustment
    Then the adjustment is recorded with reason
    And an audit trail is maintained

  # =============================================================================
  # MOBILE AND ACCESSIBILITY
  # =============================================================================

  Scenario: Configuration page is mobile-friendly
    When the admin accesses configuration on mobile
    Then all settings are accessible
    And forms are touch-friendly
    And dropdowns and inputs work correctly

  Scenario: Configuration is accessible to screen readers
    When a screen reader accesses the configuration page
    Then all form fields have proper labels
    And error messages are announced
    And navigation is logical

  Scenario: Configuration uses high-contrast colors
    When the admin views configuration
    Then all text meets WCAG AA contrast requirements
    And error states are visually distinguishable
    And form validation is clear

  # =============================================================================
  # EDGE CASES AND ERROR HANDLING
  # =============================================================================

  Scenario: Handle concurrent configuration updates
    Given two admins edit configuration simultaneously
    When both attempt to save
    Then the first save succeeds
    And the second receives a conflict error
    And the second admin is prompted to refresh

  Scenario: Handle partial configuration save failure
    Given a network error occurs during save
    When the configuration save fails partway through
    Then the entire save is rolled back
    And no partial configuration is applied
    And the admin is notified to retry

  Scenario: Handle invalid data in imported configuration
    Given an imported JSON has invalid scoring values
    When the admin imports the configuration
    Then invalid values are flagged
    And the import is rejected with specific errors
    And the admin can fix and retry

  Scenario: Handle timezone edge cases for deadlines
    Given a deadline falls during daylight saving time change
    When the deadline is configured
    Then the UTC time is stored correctly
    And display adjusts for DST
    And no games are missed

  Scenario: Handle NFL schedule changes
    Given the NFL reschedules a game
    When the league has a deadline based on game time
    Then the admin is notified of the change
    And deadline can be updated accordingly
