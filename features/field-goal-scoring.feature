Feature: Field Goal Scoring by Distance
  As the system
  I want to calculate field goal fantasy points based on configurable distance tiers
  So that leagues can reward longer field goals with more points

  Background:
    Given the game "2025 NFL Playoffs Pool" is active
    And the league has field goal scoring enabled

  # Default Field Goal Scoring

  Scenario: Score field goals 0-39 yards with default rules
    Given player "john_player" selected "Kansas City Chiefs" for week 1
    And the league has default field goal scoring configured
    And the "Kansas City Chiefs" kicker made field goals at:
      | distance |
      | 25 yards |
      | 35 yards |
      | 38 yards |
    When field goal scoring is calculated
    Then the field goal points should be 9.0
    # 3 field goals in 0-39 range * 3 points = 9 points

  Scenario: Score field goals 40-49 yards with default rules
    Given player "jane_player" selected "Buffalo Bills" for week 2
    And the league has default field goal scoring configured
    And the "Buffalo Bills" kicker made field goals at:
      | distance |
      | 40 yards |
      | 45 yards |
    When field goal scoring is calculated
    Then the field goal points should be 8.0
    # 2 field goals in 40-49 range * 4 points = 8 points

  Scenario: Score field goals 50+ yards with default rules
    Given player "bob_player" selected "Baltimore Ravens" for week 1
    And the league has default field goal scoring configured
    And the "Baltimore Ravens" kicker made field goals at:
      | distance |
      | 52 yards |
      | 58 yards |
    When field goal scoring is calculated
    Then the field goal points should be 10.0
    # 2 field goals in 50+ range * 5 points = 10 points

  # Mixed Distance Field Goals

  Scenario: Score field goals across multiple distance ranges
    Given player "sarah_player" selected "San Francisco 49ers" for week 1
    And the league has default field goal scoring configured
    And the "San Francisco 49ers" kicker made field goals at:
      | distance |
      | 28 yards |
      | 42 yards |
      | 51 yards |
    When field goal scoring is calculated
    Then the field goal breakdown should be:
      | range      | count | points per FG | total |
      | 0-39 yards | 1     | 3             | 3     |
      | 40-49 yards| 1     | 4             | 4     |
      | 50+ yards  | 1     | 5             | 5     |
    And the total field goal points should be 12.0

  Scenario: Score multiple field goals in same distance range
    Given player "mike_player" selected "Dallas Cowboys" for week 3
    And the "Dallas Cowboys" kicker made field goals at:
      | distance |
      | 22 yards |
      | 30 yards |
      | 35 yards |
      | 39 yards |
    When field goal scoring is calculated
    Then all 4 field goals are in the 0-39 range
    And the total field goal points should be 12.0
    # 4 FGs * 3 points = 12 points

  # Distance Boundary Conditions

  Scenario Outline: Field goal distance boundaries
    Given player "test_player" selected "Test Team" for week 1
    And the league has default field goal scoring configured
    And the "Test Team" kicker made a field goal at <distance> yards
    When field goal scoring is calculated
    Then the field goal should be scored in the <range> range
    And the points awarded should be <points>

    Examples:
      | distance | range       | points |
      | 18       | 0-39 yards  | 3      |
      | 25       | 0-39 yards  | 3      |
      | 39       | 0-39 yards  | 3      |
      | 40       | 40-49 yards | 4      |
      | 45       | 40-49 yards | 4      |
      | 49       | 40-49 yards | 4      |
      | 50       | 50+ yards   | 5      |
      | 55       | 50+ yards   | 5      |
      | 60       | 50+ yards   | 5      |
      | 65       | 50+ yards   | 5      |

  # Custom Field Goal Scoring Configuration

  Scenario: Admin configures custom field goal points
    Given the admin owns a league
    When the admin configures field goal scoring:
      | fg0to39Points  | 2 |
      | fg40to49Points | 5 |
      | fg50PlusPoints | 7 |
    Then the field goal scoring rules are saved
    And the league uses the custom configuration

  Scenario: Score field goals with custom configuration
    Given the league has custom field goal scoring:
      | fg0to39Points  | 2 |
      | fg40to49Points | 5 |
      | fg50PlusPoints | 7 |
    And player "alex_player" selected "Green Bay Packers" for week 1
    And the "Green Bay Packers" kicker made field goals at:
      | distance |
      | 30 yards |
      | 43 yards |
      | 52 yards |
    When field goal scoring is calculated
    Then the field goal breakdown should be:
      | range       | count | points per FG | total |
      | 0-39 yards  | 1     | 2             | 2     |
      | 40-49 yards | 1     | 5             | 5     |
      | 50+ yards   | 1     | 7             | 7     |
    And the total field goal points should be 14.0

  Scenario: League rewards long field goals more heavily
    Given the league has custom field goal scoring:
      | fg0to39Points  | 3  |
      | fg40to49Points | 6  |
      | fg50PlusPoints | 10 |
    And player "chris_player" selected "Miami Dolphins" for week 2
    And the "Miami Dolphins" kicker made a 55-yard field goal
    When field goal scoring is calculated
    Then the field goal points should be 10.0

  # Missed Field Goals

  Scenario: Missed field goals do not award points
    Given player "lisa_player" selected "Philadelphia Eagles" for week 1
    And the "Philadelphia Eagles" kicker attempted field goals:
      | distance | result |
      | 30 yards | MADE   |
      | 45 yards | MISSED |
      | 52 yards | MADE   |
    When field goal scoring is calculated
    Then only made field goals are counted
    And the total field goal points should be 8.0
    # 30 yards (3 pts) + 52 yards (5 pts) = 8 points

  Scenario: All missed field goals result in zero points
    Given player "tom_player" selected "Cleveland Browns" for week 3
    And the "Cleveland Browns" kicker attempted field goals:
      | distance | result |
      | 35 yards | MISSED |
      | 42 yards | MISSED |
      | 50 yards | MISSED |
    When field goal scoring is calculated
    Then the total field goal points should be 0.0

  # Blocked Field Goals

  Scenario: Blocked field goals do not award points
    Given player "nina_player" selected "Denver Broncos" for week 1
    And the "Denver Broncos" kicker attempted field goals:
      | distance | result  |
      | 28 yards | MADE    |
      | 41 yards | BLOCKED |
    When field goal scoring is calculated
    Then only successful field goals count
    And the total field goal points should be 3.0

  # Data Integration

  Scenario: Fetch field goal data with distances from NFL data source
    Given a game has completed
    And the "Pittsburgh Steelers" are being scored
    When the system fetches game statistics
    Then field goal data includes:
      | fieldGoalDistance    |
      | fieldGoalResult      |
      | kicker               |
      | quarter              |
    And each field goal has a distance in yards
    And each field goal has a result (MADE, MISSED, BLOCKED)

  Scenario: Calculate field goal points from NFL game data
    Given the NFL game data includes field goals:
      | team              | distance | result |
      | Kansas City Chiefs| 35       | MADE   |
      | Kansas City Chiefs| 48       | MADE   |
      | Kansas City Chiefs| 55       | MADE   |
    And player "omar_player" selected "Kansas City Chiefs" for week 1
    When field goal scoring is calculated from game data
    Then the system correctly categorizes each field goal
    And the total field goal points should be 12.0
    # 35 yards (3) + 48 yards (4) + 55 yards (5) = 12

  # Comprehensive Scoring with Field Goals

  Scenario: Field goals contribute to total team score
    Given player "penny_player" selected "Seattle Seahawks" for week 1
    And the "Seattle Seahawks" had the following performance:
      | stat_type          | value |
      | passing_yards      | 250   |
      | rushing_yards      | 100   |
      | receiving_yards    | 250   |
      | receptions         | 20    |
      | touchdowns         | 3     |
      | extra_points       | 3     |
    And the "Seattle Seahawks" kicker made field goals at:
      | distance |
      | 25 yards |
      | 45 yards |
    When total scoring is calculated
    Then the field goal points are 7.0
    # 25 yards (3) + 45 yards (4) = 7
    And field goals contribute to the overall team score
    And the overall score includes offensive + field goals + defensive points

  # Field Goal Scoring Display

  Scenario: Player views detailed field goal breakdown
    Given player "quinn_player" selected "Tampa Bay Buccaneers" for week 2
    And the "Tampa Bay Buccaneers" kicker made field goals at:
      | distance |
      | 32 yards |
      | 38 yards |
      | 47 yards |
      | 53 yards |
    When the player requests the scoring breakdown
    Then they should see the field goal details:
      | distance | range       | points |
      | 32 yards | 0-39 yards  | 3      |
      | 38 yards | 0-39 yards  | 3      |
      | 47 yards | 40-49 yards | 4      |
      | 53 yards | 50+ yards   | 5      |
    And the total field goal points: 15.0

  # Edge Cases

  Scenario: No field goals attempted
    Given player "rachel_player" selected "New York Jets" for week 1
    And the "New York Jets" did not attempt any field goals
    When field goal scoring is calculated
    Then the total field goal points should be 0.0

  Scenario: Team scores only via field goals
    Given player "steve_player" selected "Tennessee Titans" for week 3
    And the "Tennessee Titans" scored 0 touchdowns
    And the "Tennessee Titans" kicker made 5 field goals at:
      | distance |
      | 20 yards |
      | 35 yards |
      | 40 yards |
      | 48 yards |
      | 51 yards |
    When total scoring is calculated
    Then the field goal points should be 19.0
    # 20 (3) + 35 (3) + 40 (4) + 48 (4) + 51 (5) = 19
    And the team's offensive points come primarily from field goals

  # Integration with Team Elimination

  Scenario: Eliminated team receives zero field goal points
    Given player "eliminated_player" selected "Atlanta Falcons" for week 1
    And the "Atlanta Falcons" lost their week 1 game
    And the "Atlanta Falcons" are eliminated
    And the "Atlanta Falcons" kicker made excellent field goals in week 2:
      | distance |
      | 55 yards |
      | 58 yards |
      | 60 yards |
    When week 2 scoring is calculated
    Then the total field goal points should be 0.0
    And the elimination override is applied
    And no points are awarded despite the great kicks

  # Validation and Error Handling

  Scenario: Invalid field goal distance is rejected
    Given game data includes a field goal with distance -5 yards
    When the system processes the data
    Then the invalid field goal is rejected
    And an error is logged
    And the field goal is not included in scoring

  Scenario: Field goal distance exceeds realistic maximum
    Given game data includes a field goal at 75 yards
    When the system processes the data
    Then the field goal is accepted (record-breaking kick!)
    And it is scored in the 50+ yards range
    And the points awarded are based on 50+ tier

  # League Comparison

  Scenario: Compare field goal scoring across different league configurations
    Given league "Standard League" has default field goal scoring:
      | fg0to39Points  | 3 |
      | fg40to49Points | 4 |
      | fg50PlusPoints | 5 |
    And league "Long Distance League" has custom scoring:
      | fg0to39Points  | 2 |
      | fg40to49Points | 5 |
      | fg50PlusPoints | 10|
    And both leagues have a kicker who made:
      | distance |
      | 30 yards |
      | 45 yards |
      | 55 yards |
    When scoring is calculated for both leagues
    Then "Standard League" awards 12 points (3 + 4 + 5)
    And "Long Distance League" awards 17 points (2 + 5 + 10)
    And the custom league rewards long kicks more heavily
