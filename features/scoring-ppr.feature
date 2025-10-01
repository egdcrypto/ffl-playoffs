Feature: PPR Scoring Rules and Calculations
  As the system
  I want to calculate scores using standard PPR (Points Per Reception) rules
  So that players receive accurate points based on their selected team's performance

  Background:
    Given the game uses standard PPR scoring rules
    And the game "2025 NFL Playoffs Pool" is active

  Scenario: Calculate points for passing yards
    Given player "john_player" selected "Kansas City Chiefs" for week 1
    And the "Kansas City Chiefs" quarterbacks threw for 350 passing yards
    When week 1 scoring is calculated
    Then the passing yards points should be 14.0
    # 350 yards / 25 yards per point = 14 points

  Scenario: Calculate points for rushing yards
    Given player "jane_player" selected "Baltimore Ravens" for week 1
    And the "Baltimore Ravens" had 175 rushing yards
    When week 1 scoring is calculated
    Then the rushing yards points should be 17.5
    # 175 yards / 10 yards per point = 17.5 points

  Scenario: Calculate points for receiving yards
    Given player "bob_player" selected "Miami Dolphins" for week 2
    And the "Miami Dolphins" had 280 receiving yards
    When week 2 scoring is calculated
    Then the receiving yards points should be 28.0
    # 280 yards / 10 yards per point = 28 points

  Scenario: Calculate points for receptions (PPR)
    Given player "sarah_player" selected "San Francisco 49ers" for week 1
    And the "San Francisco 49ers" had 25 receptions
    When week 1 scoring is calculated
    Then the reception points should be 25.0
    # 1 point per reception, 25 receptions = 25 points

  Scenario: Calculate points for touchdowns
    Given player "mike_player" selected "Buffalo Bills" for week 3
    And the "Buffalo Bills" scored the following touchdowns:
      | type      | count |
      | passing   | 3     |
      | rushing   | 2     |
      | receiving | 1     |
    When week 3 scoring is calculated
    Then the touchdown points should be 36.0
    # 6 touchdowns * 6 points each = 36 points

  Scenario: Calculate points for field goals
    Given player "lisa_player" selected "Dallas Cowboys" for week 1
    And the "Dallas Cowboys" kicker made the following field goals:
      | distance | count |
      | 45 yards | 2     |
      | 35 yards | 1     |
    When week 1 scoring is calculated
    Then the field goal points should be 9.0
    # 3 field goals * 3 points each = 9 points

  Scenario: Calculate points for extra points
    Given player "tom_player" selected "Green Bay Packers" for week 2
    And the "Green Bay Packers" scored 4 touchdowns
    And the kicker made 4 extra points
    When week 2 scoring is calculated
    Then the extra point points should be 4.0
    # 4 extra points * 1 point each = 4 points

  Scenario: Calculate points for two-point conversions
    Given player "chris_player" selected "Philadelphia Eagles" for week 3
    And the "Philadelphia Eagles" made 2 two-point conversions
    When week 3 scoring is calculated
    Then the two-point conversion points should be 4.0
    # 2 conversions * 2 points each = 4 points

  Scenario: Calculate comprehensive team score
    Given player "alex_player" selected "Cincinnati Bengals" for week 1
    And the "Cincinnati Bengals" had the following performance:
      | stat_type          | value |
      | passing_yards      | 300   |
      | rushing_yards      | 120   |
      | receiving_yards    | 300   |
      | receptions         | 20    |
      | passing_tds        | 3     |
      | rushing_tds        | 1     |
      | field_goals        | 2     |
      | extra_points       | 4     |
      | two_point_conv     | 0     |
    When week 1 scoring is calculated
    Then the total points should be 102.0
    # Passing: 300/25 = 12
    # Rushing: 120/10 = 12
    # Receiving: 300/10 = 30
    # Receptions: 20 * 1 = 20
    # TDs: 4 * 6 = 24
    # FG: 2 * 3 = 6
    # XP: 4 * 1 = 4
    # Total: 108 points

  Scenario: Calculate defensive/special teams scoring
    Given player "nina_player" selected "Pittsburgh Steelers" for week 2
    And the "Pittsburgh Steelers" defense had the following:
      | stat_type              | value |
      | defensive_td           | 1     |
      | interception_td        | 1     |
      | fumble_return_td       | 0     |
      | kick_return_td         | 1     |
      | punt_return_td         | 0     |
      | sacks                  | 5     |
      | interceptions          | 2     |
      | fumbles_recovered      | 1     |
      | safeties               | 0     |
    When week 2 scoring is calculated
    Then defensive touchdown points should be 18.0
    # 3 TDs * 6 points each = 18 points

  Scenario: Eliminated team receives zero points regardless of performance
    Given player "omar_player" selected "Denver Broncos" for week 1
    And the "Denver Broncos" lost their week 1 game
    And the "Denver Broncos" are eliminated for player "omar_player"
    And the "Denver Broncos" had excellent performance in week 2:
      | stat_type       | value |
      | passing_yards   | 400   |
      | rushing_yards   | 150   |
      | receiving_yards | 350   |
      | touchdowns      | 5     |
    When week 2 scoring is calculated for player "omar_player"
    Then the total points should be 0.0
    And the elimination override should be applied

  Scenario: Fractional points are calculated correctly
    Given player "penny_player" selected "Los Angeles Rams" for week 1
    And the "Los Angeles Rams" had the following performance:
      | stat_type       | value |
      | passing_yards   | 283   |
      | rushing_yards   | 97    |
      | receiving_yards | 215   |
    When week 1 scoring is calculated
    Then the passing yards points should be 11.32
    # 283 / 25 = 11.32
    And the rushing yards points should be 9.7
    # 97 / 10 = 9.7
    And the receiving yards points should be 21.5
    # 215 / 10 = 21.5

  Scenario: Zero performance results in zero points
    Given player "quinn_player" selected "New York Giants" for week 3
    And the "New York Giants" had poor performance:
      | stat_type       | value |
      | passing_yards   | 0     |
      | rushing_yards   | 0     |
      | receiving_yards | 0     |
      | touchdowns      | 0     |
      | field_goals     | 0     |
    When week 3 scoring is calculated
    Then the total points should be 0.0

  Scenario: Negative plays do not result in negative points
    Given player "rachel_player" selected "Cleveland Browns" for week 2
    And the "Cleveland Browns" had -5 rushing yards total
    When week 2 scoring is calculated
    Then the rushing yards points should be -0.5
    # System should handle negative yardage appropriately

  Scenario: Score is recalculated when stats are updated
    Given player "steve_player" selected "Tampa Bay Buccaneers" for week 1
    And initial scoring calculated 85.5 points
    And the official stats are corrected:
      | stat_type     | old_value | new_value |
      | receptions    | 22        | 24        |
      | rushing_yards | 130       | 135       |
    When scoring is recalculated
    Then the total points should be updated
    And the point difference should be 2.5
    # 2 more receptions = 2 points, 5 more yards = 0.5 points

  Scenario: Player views detailed scoring breakdown
    Given player "tina_player" selected "Seattle Seahawks" for week 1
    And the "Seattle Seahawks" final score is 92.3 points
    When player "tina_player" requests scoring breakdown
    Then they should see the following categories:
      | category            | points |
      | Passing Yards       | 15.2   |
      | Rushing Yards       | 11.5   |
      | Receiving Yards     | 25.0   |
      | Receptions          | 18.0   |
      | Touchdowns          | 18.0   |
      | Field Goals         | 6.0    |
      | Extra Points        | 3.0    |
      | Two-Point Conv      | 0.0    |
      | Defensive/ST        | 0.0    |
    And the total should be 96.7 points

  Scenario Outline: PPR scoring calculation examples
    Given player "test_player" selected "<team>" for week 1
    And the "<team>" had <passing_yards> passing yards
    And the "<team>" had <rushing_yards> rushing yards
    And the "<team>" had <receiving_yards> receiving yards
    And the "<team>" had <receptions> receptions
    And the "<team>" scored <touchdowns> touchdowns
    When week 1 scoring is calculated
    Then the total points should be <expected_points>

    Examples:
      | team    | passing_yards | rushing_yards | receiving_yards | receptions | touchdowns | expected_points |
      | Chiefs  | 300           | 100           | 250             | 20         | 4          | 87.0            |
      | Bills   | 250           | 150           | 200             | 15         | 3          | 73.0            |
      | 49ers   | 200           | 180           | 180             | 12         | 2          | 58.0            |
      | Cowboys | 350           | 80            | 300             | 25         | 5          | 97.0            |

  Scenario: Weekly scoring deadline triggers calculation
    Given it is week 1 of the game
    And all week 1 games have completed
    And the scoring calculation deadline is "2025-10-08 23:59:59"
    When the scoring deadline passes
    Then scoring should be calculated for all players
    And final scores should be locked for week 1
    And players should receive score notifications

  Scenario: Incomplete game data delays scoring calculation
    Given player "victor_player" selected "Indianapolis Colts" for week 2
    And the "Indianapolis Colts" game has ended
    But official statistics are not yet available
    When scoring calculation is attempted
    Then the score should be marked as "PENDING"
    And player "victor_player" should be notified of the delay
    And scoring should be retried when data becomes available
