Feature: PPR Scoring for Individual NFL Players
  As a league player
  I want my roster to be scored based on individual NFL player performance using PPR rules
  So that my fantasy points reflect real-world player statistics

  Background:
    Given a league "Championship 2024" exists with PPR scoring configuration:
      | Scoring Rule              | Points  |
      | Passing yards per point   | 25      |
      | Passing TD                | 4       |
      | Interception              | -2      |
      | Rushing yards per point   | 10      |
      | Rushing TD                | 6       |
      | Receiving yards per point | 10      |
      | Reception (PPR)           | 1       |
      | Receiving TD              | 6       |
      | Fumble lost               | -2      |
      | 2-point conversion        | 2       |
    And a player has a complete locked roster

  Scenario: Calculate quarterback fantasy points
    Given the player has "Patrick Mahomes" at QB position
    And in NFL week 1, "Patrick Mahomes" has game stats:
      | Stat              | Value |
      | Passing yards     | 300   |
      | Passing TDs       | 3     |
      | Interceptions     | 1     |
      | Rushing yards     | 15    |
      | Fumbles lost      | 0     |
    When the system calculates fantasy points for week 1
    Then "Patrick Mahomes" scores:
      | Stat              | Calculation   | Points |
      | Passing yards     | 300/25        | 12     |
      | Passing TDs       | 3 × 4         | 12     |
      | Interceptions     | 1 × -2        | -2     |
      | Rushing yards     | 15/10         | 1.5    |
    And the total fantasy points for "Patrick Mahomes" is 23.5 points

  Scenario: Calculate running back fantasy points with PPR
    Given the player has "Christian McCaffrey" at RB position
    And in NFL week 1, "Christian McCaffrey" has game stats:
      | Stat              | Value |
      | Rushing yards     | 120   |
      | Rushing TDs       | 2     |
      | Receptions        | 6     |
      | Receiving yards   | 50    |
      | Receiving TDs     | 0     |
      | Fumbles lost      | 1     |
    When the system calculates fantasy points for week 1
    Then "Christian McCaffrey" scores:
      | Stat              | Calculation   | Points |
      | Rushing yards     | 120/10        | 12     |
      | Rushing TDs       | 2 × 6         | 12     |
      | Receptions        | 6 × 1         | 6      |
      | Receiving yards   | 50/10         | 5      |
      | Fumbles lost      | 1 × -2        | -2     |
    And the total fantasy points for "Christian McCaffrey" is 33 points

  Scenario: Calculate wide receiver fantasy points with PPR
    Given the player has "Tyreek Hill" at WR position
    And in NFL week 1, "Tyreek Hill" has game stats:
      | Stat              | Value |
      | Receptions        | 8     |
      | Receiving yards   | 150   |
      | Receiving TDs     | 2     |
      | Fumbles lost      | 0     |
    When the system calculates fantasy points for week 1
    Then "Tyreek Hill" scores:
      | Stat              | Calculation   | Points |
      | Receptions        | 8 × 1         | 8      |
      | Receiving yards   | 150/10        | 15     |
      | Receiving TDs     | 2 × 6         | 12     |
    And the total fantasy points for "Tyreek Hill" is 35 points

  Scenario: Calculate tight end fantasy points with 2-point conversion
    Given the player has "Travis Kelce" at TE position
    And in NFL week 1, "Travis Kelce" has game stats:
      | Stat              | Value |
      | Receptions        | 7     |
      | Receiving yards   | 85    |
      | Receiving TDs     | 1     |
      | 2-pt conversions  | 1     |
    When the system calculates fantasy points for week 1
    Then "Travis Kelce" scores:
      | Stat              | Calculation   | Points |
      | Receptions        | 7 × 1         | 7      |
      | Receiving yards   | 85/10         | 8.5    |
      | Receiving TDs     | 1 × 6         | 6      |
      | 2-pt conversions  | 1 × 2         | 2      |
    And the total fantasy points for "Travis Kelce" is 23.5 points

  Scenario: Calculate weekly roster total
    Given the player has a complete roster with 9 NFL players
    And week 1 fantasy points are calculated for each player:
      | Position | Player                  | Points |
      | QB       | Patrick Mahomes         | 23.5   |
      | RB       | Christian McCaffrey     | 33.0   |
      | RB       | Derrick Henry           | 18.0   |
      | WR       | Tyreek Hill             | 35.0   |
      | WR       | CeeDee Lamb             | 22.5   |
      | TE       | Travis Kelce            | 23.5   |
      | FLEX     | Cooper Kupp (WR)        | 19.0   |
      | K        | Justin Tucker           | 9.0    |
      | DEF      | San Francisco 49ers     | 12.0   |
    When the system calculates the player's total score for week 1
    Then the player's weekly total is 195.5 fantasy points

  Scenario: Admin configures Half-PPR scoring
    Given the admin is configuring a new league
    When the admin sets reception points to 0.5
    And sets all other PPR rules to standard values
    Then the league uses Half-PPR scoring
    And receptions are worth 0.5 points each
    And a WR with 10 receptions and 100 yards scores: 10 + 5 = 15 points

  Scenario: Admin configures Standard (non-PPR) scoring
    Given the admin is configuring a new league
    When the admin sets reception points to 0
    And sets all other PPR rules to standard values
    Then the league uses Standard scoring
    And receptions are worth 0 points
    And a WR with 10 receptions and 100 yards scores: 0 + 10 = 10 points

  Scenario: Custom PPR scoring rules
    Given the admin configures custom scoring:
      | Scoring Rule              | Points  |
      | Passing yards per point   | 20      |
      | Passing TD                | 6       |
      | Rushing TD                | 7       |
    And a QB throws 400 yards and 2 TDs
    When the system calculates fantasy points
    Then the QB scores: (400/20) + (2 × 6) = 20 + 12 = 32 points

  Scenario: Player scores zero for unfilled roster position
    Given the player's roster has an empty K position
    And the player has 8 of 9 positions filled
    When the system calculates week 1 scores
    Then the K position contributes 0 fantasy points
    And the player's total only includes points from 8 filled positions

  Scenario: Track cumulative scoring across multiple weeks
    Given the league runs for 4 weeks
    And the player's roster scores:
      | Week | Points |
      | 1    | 195.5  |
      | 2    | 178.0  |
      | 3    | 201.5  |
      | 4    | 185.0  |
    When the system calculates cumulative score
    Then the player's total season score is 760.0 fantasy points

  Scenario: Real-time score updates during live games
    Given the player has "Patrick Mahomes" at QB
    And NFL week 1 games are in progress
    And the data refresh interval is 5 minutes
    When "Patrick Mahomes" completes a 75-yard TD pass
    Then the system updates player stats within 5 minutes
    And "Patrick Mahomes" fantasy points increase by: (75/25) + 4 = 7 points
    And the player's weekly total is recalculated

  Scenario: View game-by-game scoring breakdown
    Given the player has "Christian McCaffrey" at RB
    And the league has completed 3 weeks
    When the player views "Christian McCaffrey" scoring details
    Then the system shows fantasy points for each week:
      | Week | Rushing Yards | Rushing TDs | Receptions | Receiving Yards | Total Points |
      | 1    | 120           | 2           | 6          | 50              | 33.0         |
      | 2    | 95            | 1           | 4          | 35              | 22.5         |
      | 3    | 140           | 3           | 5          | 40              | 37.0         |
    And the system shows season totals and averages
