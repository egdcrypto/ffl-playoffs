Feature: Defensive Scoring with Configurable Tiers
  As the system
  I want to calculate defensive fantasy points using configurable scoring rules and tiers
  So that teams receive accurate defensive scores based on league configuration

  Background:
    Given the game "2025 NFL Playoffs Pool" is active
    And the league has defensive scoring enabled

  # Individual Defensive Play Scoring

  Scenario: Calculate points for sacks
    Given player "john_player" selected "Pittsburgh Steelers" for week 1
    And the league has sack points configured as 1 point
    And the "Pittsburgh Steelers" defense recorded 5 sacks
    When defensive scoring is calculated
    Then the sack points should be 5.0
    # 5 sacks * 1 point = 5 points

  Scenario: Calculate points for interceptions
    Given player "jane_player" selected "Baltimore Ravens" for week 2
    And the league has interception points configured as 2 points
    And the "Baltimore Ravens" defense had 3 interceptions
    When defensive scoring is calculated
    Then the interception points should be 6.0
    # 3 interceptions * 2 points = 6 points

  Scenario: Calculate points for fumble recoveries
    Given player "bob_player" selected "San Francisco 49ers" for week 1
    And the league has fumble recovery points configured as 2 points
    And the "San Francisco 49ers" defense recovered 2 fumbles
    When defensive scoring is calculated
    Then the fumble recovery points should be 4.0
    # 2 fumbles * 2 points = 4 points

  Scenario: Calculate points for safeties
    Given player "sarah_player" selected "Denver Broncos" for week 3
    And the league has safety points configured as 2 points
    And the "Denver Broncos" defense recorded 1 safety
    When defensive scoring is calculated
    Then the safety points should be 2.0

  Scenario: Calculate points for defensive touchdowns
    Given player "mike_player" selected "Dallas Cowboys" for week 1
    And the league has defensive TD points configured as 6 points
    And the "Dallas Cowboys" defense scored 2 touchdowns
    When defensive scoring is calculated
    Then the defensive touchdown points should be 12.0
    # 2 TDs * 6 points = 12 points

  # Points Allowed Tier Scoring

  Scenario: Defense allows 0 points - maximum tier
    Given player "alex_player" selected "Buffalo Bills" for week 2
    And the league has standard points allowed tiers configured
    And the "Buffalo Bills" defense allowed 0 points
    When defensive scoring is calculated
    Then the points allowed tier score should be 10.0
    # 0 points allowed = 10 fantasy points

  Scenario: Defense allows 1-6 points - high tier
    Given player "chris_player" selected "New England Patriots" for week 1
    And the "New England Patriots" defense allowed 6 points
    When defensive scoring is calculated
    Then the points allowed tier score should be 7.0
    # 1-6 points allowed = 7 fantasy points

  Scenario: Defense allows 7-13 points - mid tier
    Given player "lisa_player" selected "Green Bay Packers" for week 3
    And the "Green Bay Packers" defense allowed 10 points
    When defensive scoring is calculated
    Then the points allowed tier score should be 4.0
    # 7-13 points allowed = 4 fantasy points

  Scenario: Defense allows 14-20 points - low tier
    Given player "tom_player" selected "Seattle Seahawks" for week 1
    And the "Seattle Seahawks" defense allowed 17 points
    When defensive scoring is calculated
    Then the points allowed tier score should be 1.0
    # 14-20 points allowed = 1 fantasy point

  Scenario: Defense allows 21-27 points - zero tier
    Given player "nina_player" selected "Tampa Bay Buccaneers" for week 2
    And the "Tampa Bay Buccaneers" defense allowed 24 points
    When defensive scoring is calculated
    Then the points allowed tier score should be 0.0
    # 21-27 points allowed = 0 fantasy points

  Scenario: Defense allows 28-34 points - negative tier
    Given player "omar_player" selected "Cleveland Browns" for week 1
    And the "Cleveland Browns" defense allowed 31 points
    When defensive scoring is calculated
    Then the points allowed tier score should be -1.0
    # 28-34 points allowed = -1 fantasy point

  Scenario: Defense allows 35+ points - maximum negative tier
    Given player "penny_player" selected "Arizona Cardinals" for week 3
    And the "Arizona Cardinals" defense allowed 42 points
    When defensive scoring is calculated
    Then the points allowed tier score should be -4.0
    # 35+ points allowed = -4 fantasy points

  # Yards Allowed Tier Scoring

  Scenario: Defense allows 0-99 total yards - maximum tier
    Given player "quinn_player" selected "Chicago Bears" for week 1
    And the league has standard yards allowed tiers configured
    And the "Chicago Bears" defense allowed 95 total yards
    When defensive scoring is calculated
    Then the yards allowed tier score should be 10.0
    # 0-99 yards = 10 fantasy points

  Scenario: Defense allows 100-199 yards - high tier
    Given player "rachel_player" selected "Miami Dolphins" for week 2
    And the "Miami Dolphins" defense allowed 175 total yards
    When defensive scoring is calculated
    Then the yards allowed tier score should be 7.0
    # 100-199 yards = 7 fantasy points

  Scenario: Defense allows 200-299 yards - mid-high tier
    Given player "steve_player" selected "Kansas City Chiefs" for week 1
    And the "Kansas City Chiefs" defense allowed 250 total yards
    When defensive scoring is calculated
    Then the yards allowed tier score should be 5.0
    # 200-299 yards = 5 fantasy points

  Scenario: Defense allows 300-349 yards - mid tier
    Given player "tina_player" selected "Indianapolis Colts" for week 3
    And the "Indianapolis Colts" defense allowed 325 total yards
    When defensive scoring is calculated
    Then the yards allowed tier score should be 3.0
    # 300-349 yards = 3 fantasy points

  Scenario: Defense allows 350-399 yards - zero tier
    Given player "victor_player" selected "Los Angeles Rams" for week 1
    And the "Los Angeles Rams" defense allowed 375 total yards
    When defensive scoring is calculated
    Then the yards allowed tier score should be 0.0
    # 350-399 yards = 0 fantasy points

  Scenario: Defense allows 400-449 yards - negative tier
    Given player "wendy_player" selected "Atlanta Falcons" for week 2
    And the "Atlanta Falcons" defense allowed 425 total yards
    When defensive scoring is calculated
    Then the yards allowed tier score should be -3.0
    # 400-449 yards = -3 fantasy points

  Scenario: Defense allows 450+ yards - maximum negative tier
    Given player "xander_player" selected "Detroit Lions" for week 1
    And the "Detroit Lions" defense allowed 485 total yards
    When defensive scoring is calculated
    Then the yards allowed tier score should be -5.0
    # 450+ yards = -5 fantasy points

  # Comprehensive Defensive Scoring

  Scenario: Calculate total defensive points with all components
    Given player "yara_player" selected "Philadelphia Eagles" for week 1
    And the "Philadelphia Eagles" defense had the following performance:
      | stat_type              | value |
      | sacks                  | 3     |
      | interceptions          | 1     |
      | fumbleRecoveries       | 1     |
      | safeties               | 0     |
      | defensiveTouchdowns    | 1     |
      | pointsAllowed          | 10    |
      | totalYardsAllowed      | 250   |
    And the league has standard defensive scoring configured:
      | sackPoints           | 1 |
      | interceptionPoints   | 2 |
      | fumbleRecoveryPoints | 2 |
      | safetyPoints         | 2 |
      | defensiveTDPoints    | 6 |
    When defensive scoring is calculated
    Then the defensive score breakdown should be:
      | category                | points |
      | Sacks (3)               | 3      |
      | Interceptions (1)       | 2      |
      | Fumble Recoveries (1)   | 2      |
      | Safeties (0)            | 0      |
      | Defensive TDs (1)       | 6      |
      | Points Allowed (10)     | 4      |
      | Yards Allowed (250)     | 5      |
    And the total defensive points should be 22.0
    # 3 + 2 + 2 + 0 + 6 + 4 + 5 = 22

  Scenario: Calculate defensive score with negative components
    Given player "zane_player" selected "New York Giants" for week 2
    And the "New York Giants" defense had the following performance:
      | stat_type              | value |
      | sacks                  | 1     |
      | interceptions          | 0     |
      | fumbleRecoveries       | 0     |
      | safeties               | 0     |
      | defensiveTouchdowns    | 0     |
      | pointsAllowed          | 35    |
      | totalYardsAllowed      | 450   |
    When defensive scoring is calculated
    Then the defensive score breakdown should be:
      | category                | points |
      | Sacks (1)               | 1      |
      | Points Allowed (35)     | -4     |
      | Yards Allowed (450)     | -5     |
    And the total defensive points should be -8.0
    # 1 + (-4) + (-5) = -8

  # Custom Defensive Scoring Configuration

  Scenario: Admin configures custom defensive play points
    Given the admin owns a league
    When the admin configures custom defensive scoring:
      | sackPoints           | 2   |
      | interceptionPoints   | 3   |
      | fumbleRecoveryPoints | 3   |
      | safetyPoints         | 4   |
      | defensiveTDPoints    | 8   |
    Then the defensive scoring rules are saved
    And future defensive calculations use the custom values

  Scenario: Admin configures custom points allowed tiers
    Given the admin owns a league
    When the admin configures custom points allowed tiers:
      | pointsAllowedRange | fantasyPoints |
      | 0                  | 15            |
      | 1-10               | 10            |
      | 11-20              | 5             |
      | 21-30              | 0             |
      | 31-40              | -5            |
      | 41+                | -10           |
    Then the points allowed tiers are saved
    And defensive scoring uses the custom tiers

  Scenario: Admin configures custom yards allowed tiers
    Given the admin owns a league
    When the admin configures custom yards allowed tiers:
      | yardsAllowedRange | fantasyPoints |
      | 0-150             | 15            |
      | 151-250           | 10            |
      | 251-350           | 5             |
      | 351-450           | 0             |
      | 451+              | -10           |
    Then the yards allowed tiers are saved
    And defensive scoring uses the custom tiers

  # Tier Boundary Conditions

  Scenario Outline: Points allowed tier boundaries
    Given player "test_player" selected "<team>" for week 1
    And the "<team>" defense allowed <pointsAllowed> points
    When defensive scoring is calculated
    Then the points allowed tier score should be <expectedPoints>

    Examples:
      | team    | pointsAllowed | expectedPoints |
      | Team A  | 0             | 10             |
      | Team B  | 1             | 7              |
      | Team C  | 6             | 7              |
      | Team D  | 7             | 4              |
      | Team E  | 13            | 4              |
      | Team F  | 14            | 1              |
      | Team G  | 20            | 1              |
      | Team H  | 21            | 0              |
      | Team I  | 27            | 0              |
      | Team J  | 28            | -1             |
      | Team K  | 34            | -1             |
      | Team L  | 35            | -4             |
      | Team M  | 100           | -4             |

  Scenario Outline: Yards allowed tier boundaries
    Given player "test_player" selected "<team>" for week 1
    And the "<team>" defense allowed <yardsAllowed> total yards
    When defensive scoring is calculated
    Then the yards allowed tier score should be <expectedPoints>

    Examples:
      | team    | yardsAllowed | expectedPoints |
      | Team A  | 0            | 10             |
      | Team B  | 99           | 10             |
      | Team C  | 100          | 7              |
      | Team D  | 199          | 7              |
      | Team E  | 200          | 5              |
      | Team F  | 299          | 5              |
      | Team G  | 300          | 3              |
      | Team H  | 349          | 3              |
      | Team I  | 350          | 0              |
      | Team J  | 399          | 0              |
      | Team K  | 400          | -3             |
      | Team L  | 449          | -3             |
      | Team M  | 450          | -5             |
      | Team N  | 600          | -5             |

  # Integration with Team Elimination

  Scenario: Eliminated team receives zero defensive points
    Given player "eliminated_player" selected "Jacksonville Jaguars" for week 1
    And the "Jacksonville Jaguars" lost their week 1 game
    And the "Jacksonville Jaguars" are eliminated
    And the "Jacksonville Jaguars" had excellent defensive performance in week 2:
      | sacks                | 6   |
      | interceptions        | 3   |
      | defensiveTouchdowns  | 1   |
      | pointsAllowed        | 3   |
      | totalYardsAllowed    | 150 |
    When week 2 defensive scoring is calculated
    Then the total defensive points should be 0.0
    And the elimination override is applied

  # Defensive Scoring Display

  Scenario: Player views detailed defensive scoring breakdown
    Given player "detail_player" selected "Los Angeles Chargers" for week 1
    And the final defensive score is 18.5 points
    When the player requests the defensive scoring breakdown
    Then they should see:
      | category                     | value | points |
      | Sacks                        | 4     | 4.0    |
      | Interceptions                | 2     | 4.0    |
      | Fumble Recoveries            | 1     | 2.0    |
      | Safeties                     | 0     | 0.0    |
      | Defensive TDs                | 1     | 6.0    |
      | Points Allowed (10)          | 10    | 4.0    |
      | Yards Allowed (225)          | 225   | 5.0    |
      | Total Defensive Points       |       | 25.0   |

  # Data Integration for Defensive Stats

  Scenario: Fetch defensive statistics from NFL data source
    Given a game has completed
    And the "Minnesota Vikings" defense is being scored
    When the system fetches defensive statistics
    Then the following data is retrieved:
      | sacks                  |
      | interceptions          |
      | fumbleRecoveries       |
      | safeties               |
      | defensiveTouchdowns    |
      | pointsAllowed          |
      | passingYardsAllowed    |
      | rushingYardsAllowed    |
      | totalYardsAllowed      |
    And totalYardsAllowed = passingYardsAllowed + rushingYardsAllowed

  Scenario: Calculate total yards from passing and rushing yards allowed
    Given the "Carolina Panthers" defense allowed:
      | passingYardsAllowed | 180 |
      | rushingYardsAllowed | 95  |
    When defensive scoring is calculated
    Then the totalYardsAllowed should be 275
    And the yards allowed tier score should be 5.0 (200-299 tier)
