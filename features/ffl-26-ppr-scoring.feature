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

  # Edge Cases and Special Scenarios

  Scenario: NFL player on bye week scores zero points
    Given the player has "Josh Allen" at QB position
    And in NFL week 7, the Buffalo Bills have a bye week
    When the system calculates fantasy points for week 7
    Then "Josh Allen" scores 0 fantasy points for week 7
    And the player's weekly total excludes "Josh Allen" contribution
    And the bye week is clearly indicated in the scoring breakdown

  Scenario: Injured player who does not play scores zero points
    Given the player has "Cooper Kupp" at WR position
    And "Cooper Kupp" is listed as OUT for NFL week 3
    And "Cooper Kupp" has no game stats for week 3
    When the system calculates fantasy points for week 3
    Then "Cooper Kupp" scores 0 fantasy points
    And the injury status is displayed in the scoring view

  Scenario: Player with negative fantasy points
    Given the player has "Trevor Lawrence" at QB position
    And in NFL week 5, "Trevor Lawrence" has game stats:
      | Stat              | Value |
      | Passing yards     | 120   |
      | Passing TDs       | 0     |
      | Interceptions     | 4     |
      | Rushing yards     | 8     |
      | Fumbles lost      | 2     |
    When the system calculates fantasy points for week 5
    Then "Trevor Lawrence" scores:
      | Stat              | Calculation   | Points |
      | Passing yards     | 120/25        | 4.8    |
      | Passing TDs       | 0 × 4         | 0      |
      | Interceptions     | 4 × -2        | -8     |
      | Rushing yards     | 8/10          | 0.8    |
      | Fumbles lost      | 2 × -2        | -4     |
    And the total fantasy points for "Trevor Lawrence" is -6.4 points

  Scenario: Yards below scoring threshold contribute fractional points
    Given the player has "Najee Harris" at RB position
    And in NFL week 1, "Najee Harris" has game stats:
      | Stat              | Value |
      | Rushing yards     | 57    |
      | Rushing TDs       | 0     |
      | Receptions        | 3     |
      | Receiving yards   | 23    |
    When the system calculates fantasy points for week 1
    Then "Najee Harris" scores:
      | Stat              | Calculation   | Points |
      | Rushing yards     | 57/10         | 5.7    |
      | Receptions        | 3 × 1         | 3      |
      | Receiving yards   | 23/10         | 2.3    |
    And the total fantasy points for "Najee Harris" is 11.0 points

  # Kicker Scoring Scenarios

  Scenario: Calculate kicker fantasy points with field goal distance tiers
    Given the league has field goal scoring:
      | Distance    | Points |
      | 0-39 yards  | 3      |
      | 40-49 yards | 4      |
      | 50+ yards   | 5      |
      | Extra Point | 1      |
    And the player has "Justin Tucker" at K position
    And in NFL week 1, "Justin Tucker" has game stats:
      | Stat              | Value |
      | FG made 0-39      | 1     |
      | FG made 40-49     | 2     |
      | FG made 50+       | 1     |
      | Extra points made | 3     |
    When the system calculates fantasy points for week 1
    Then "Justin Tucker" scores:
      | Stat              | Calculation   | Points |
      | FG 0-39           | 1 × 3         | 3      |
      | FG 40-49          | 2 × 4         | 8      |
      | FG 50+            | 1 × 5         | 5      |
      | Extra points      | 3 × 1         | 3      |
    And the total fantasy points for "Justin Tucker" is 19 points

  Scenario: Kicker with missed field goals and extra points
    Given the league has field goal scoring with missed kick penalties:
      | Stat                  | Points |
      | Missed FG 0-39        | -2     |
      | Missed FG 40-49       | -1     |
      | Missed Extra Point    | -1     |
    And the player has "Tyler Bass" at K position
    And in NFL week 2, "Tyler Bass" has game stats:
      | Stat                  | Value |
      | FG made 30-39         | 2     |
      | FG missed 35 yards    | 1     |
      | Extra points made     | 2     |
      | Extra points missed   | 1     |
    When the system calculates fantasy points for week 2
    Then "Tyler Bass" scores:
      | Stat                  | Calculation   | Points |
      | FG made               | 2 × 3         | 6      |
      | FG missed 0-39        | 1 × -2        | -2     |
      | Extra points made     | 2 × 1         | 2      |
      | Extra points missed   | 1 × -1        | -1     |
    And the total fantasy points for "Tyler Bass" is 5 points

  # FLEX Position Scoring

  Scenario: FLEX position with eligible RB player
    Given the player has "Aaron Jones" at FLEX position
    And "Aaron Jones" is a RB
    And in NFL week 1, "Aaron Jones" has game stats:
      | Stat              | Value |
      | Rushing yards     | 85    |
      | Rushing TDs       | 1     |
      | Receptions        | 4     |
      | Receiving yards   | 35    |
    When the system calculates fantasy points for week 1
    Then "Aaron Jones" at FLEX scores using RB scoring rules
    And the total fantasy points for "Aaron Jones" is 22.5 points

  Scenario: FLEX position with eligible WR player
    Given the player has "DeAndre Hopkins" at FLEX position
    And "DeAndre Hopkins" is a WR
    And in NFL week 1, "DeAndre Hopkins" has game stats:
      | Stat              | Value |
      | Receptions        | 6     |
      | Receiving yards   | 95    |
      | Receiving TDs     | 1     |
    When the system calculates fantasy points for week 1
    Then "DeAndre Hopkins" at FLEX scores using WR scoring rules
    And the total fantasy points for "DeAndre Hopkins" is 21.5 points

  Scenario: FLEX position with eligible TE player
    Given the player has "George Kittle" at FLEX position
    And "George Kittle" is a TE
    And in NFL week 1, "George Kittle" has game stats:
      | Stat              | Value |
      | Receptions        | 5     |
      | Receiving yards   | 78    |
      | Receiving TDs     | 1     |
    When the system calculates fantasy points for week 1
    Then "George Kittle" at FLEX scores using TE scoring rules
    And the total fantasy points for "George Kittle" is 18.8 points

  # SUPERFLEX Position Scoring

  Scenario: SUPERFLEX position with QB player
    Given the league has SUPERFLEX roster configuration
    And the player has "Jalen Hurts" at SUPERFLEX position
    And "Jalen Hurts" is a QB
    And in NFL week 1, "Jalen Hurts" has game stats:
      | Stat              | Value |
      | Passing yards     | 275   |
      | Passing TDs       | 2     |
      | Interceptions     | 0     |
      | Rushing yards     | 45    |
      | Rushing TDs       | 1     |
    When the system calculates fantasy points for week 1
    Then "Jalen Hurts" at SUPERFLEX scores using QB scoring rules
    And the total fantasy points for "Jalen Hurts" is 29.5 points

  Scenario: SUPERFLEX position accepts QB, RB, WR, or TE
    Given the league has SUPERFLEX roster configuration
    When a player attempts to place a QB in SUPERFLEX
    Then the assignment is allowed
    When a player attempts to place a RB in SUPERFLEX
    Then the assignment is allowed
    When a player attempts to place a WR in SUPERFLEX
    Then the assignment is allowed
    When a player attempts to place a TE in SUPERFLEX
    Then the assignment is allowed
    When a player attempts to place a K in SUPERFLEX
    Then the assignment is rejected with error "K not eligible for SUPERFLEX"
    When a player attempts to place a DEF in SUPERFLEX
    Then the assignment is rejected with error "DEF not eligible for SUPERFLEX"

  # TE Premium Scoring

  Scenario: TE Premium scoring gives bonus points per reception
    Given the admin configures TE Premium scoring:
      | Position | Reception Points |
      | RB       | 1.0              |
      | WR       | 1.0              |
      | TE       | 1.5              |
    And the player has "Travis Kelce" at TE position
    And in NFL week 1, "Travis Kelce" has game stats:
      | Stat              | Value |
      | Receptions        | 8     |
      | Receiving yards   | 100   |
      | Receiving TDs     | 1     |
    When the system calculates fantasy points for week 1
    Then "Travis Kelce" scores:
      | Stat              | Calculation   | Points |
      | Receptions        | 8 × 1.5       | 12     |
      | Receiving yards   | 100/10        | 10     |
      | Receiving TDs     | 1 × 6         | 6      |
    And the total fantasy points for "Travis Kelce" is 28 points
    And the TE receives 4 more points than standard PPR due to premium

  # Bonus Scoring Scenarios

  Scenario: Yardage bonuses for exceptional performances
    Given the league has yardage bonus rules:
      | Stat              | Threshold | Bonus |
      | Passing yards     | 300       | 3     |
      | Passing yards     | 400       | 5     |
      | Rushing yards     | 100       | 3     |
      | Receiving yards   | 100       | 3     |
    And the player has "Josh Allen" at QB position
    And in NFL week 1, "Josh Allen" has game stats:
      | Stat              | Value |
      | Passing yards     | 350   |
      | Passing TDs       | 3     |
      | Rushing yards     | 55    |
    When the system calculates fantasy points for week 1
    Then "Josh Allen" earns the 300-yard passing bonus of 3 points
    And the total fantasy points includes the yardage bonus

  Scenario: TD bonuses for long scores
    Given the league has long TD bonus rules:
      | Stat              | Distance  | Bonus |
      | Rushing TD        | 50+ yards | 2     |
      | Receiving TD      | 50+ yards | 2     |
      | Passing TD        | 50+ yards | 1     |
    And the player has "Tyreek Hill" at WR position
    And in NFL week 1, "Tyreek Hill" has:
      | Stat              | Value                    |
      | Receptions        | 5                        |
      | Receiving yards   | 120                      |
      | Receiving TDs     | 2 (one was 75 yards)     |
    When the system calculates fantasy points for week 1
    Then "Tyreek Hill" earns the 50+ yard TD bonus of 2 points
    And the base fantasy points are 29 points
    And the total with bonus is 31 points

  # Dual-Threat QB Scenarios

  Scenario: Mobile QB with rushing and passing stats
    Given the player has "Lamar Jackson" at QB position
    And in NFL week 1, "Lamar Jackson" has game stats:
      | Stat              | Value |
      | Passing yards     | 225   |
      | Passing TDs       | 2     |
      | Interceptions     | 0     |
      | Rushing yards     | 95    |
      | Rushing TDs       | 2     |
      | Fumbles lost      | 0     |
    When the system calculates fantasy points for week 1
    Then "Lamar Jackson" scores:
      | Stat              | Calculation   | Points |
      | Passing yards     | 225/25        | 9      |
      | Passing TDs       | 2 × 4         | 8      |
      | Rushing yards     | 95/10         | 9.5    |
      | Rushing TDs       | 2 × 6         | 12     |
    And the total fantasy points for "Lamar Jackson" is 38.5 points

  # Scoring Precision and Rounding

  Scenario: Fantasy points are calculated with proper decimal precision
    Given the player has "Davante Adams" at WR position
    And in NFL week 1, "Davante Adams" has game stats:
      | Stat              | Value |
      | Receptions        | 7     |
      | Receiving yards   | 113   |
      | Receiving TDs     | 1     |
    When the system calculates fantasy points for week 1
    Then "Davante Adams" scores:
      | Stat              | Calculation   | Points |
      | Receptions        | 7 × 1         | 7.0    |
      | Receiving yards   | 113/10        | 11.3   |
      | Receiving TDs     | 1 × 6         | 6.0    |
    And the total fantasy points for "Davante Adams" is 24.3 points
    And the points are displayed with one decimal precision

  Scenario: Points are not rounded until final total
    Given the player has "Saquon Barkley" at RB position
    And in NFL week 1, "Saquon Barkley" has game stats:
      | Stat              | Value |
      | Rushing yards     | 87    |
      | Rushing TDs       | 1     |
      | Receptions        | 5     |
      | Receiving yards   | 43    |
    When the system calculates fantasy points for week 1
    Then the calculation maintains full precision:
      | Stat              | Calculation   | Exact Points  |
      | Rushing yards     | 87/10         | 8.7           |
      | Rushing TDs       | 1 × 6         | 6.0           |
      | Receptions        | 5 × 1         | 5.0           |
      | Receiving yards   | 43/10         | 4.3           |
    And the total fantasy points for "Saquon Barkley" is 24.0 points

  # Multi-Week Scoring Consistency

  Scenario: Scoring rules remain consistent across all weeks
    Given the league is configured with full PPR scoring
    And the league starts at NFL week 15 and runs for 4 weeks
    When the player's WR catches 5 receptions each week
    Then the WR earns exactly 5 PPR points in week 15
    And the WR earns exactly 5 PPR points in week 16
    And the WR earns exactly 5 PPR points in week 17
    And the WR earns exactly 5 PPR points in week 18
    And the scoring rules are never modified mid-season

  # Error Handling Scenarios

  Scenario: Handle missing player stats gracefully
    Given the player has "Ja'Marr Chase" at WR position
    And the NFL data feed fails to provide stats for week 2
    When the system attempts to calculate fantasy points for week 2
    Then the system marks "Ja'Marr Chase" as "Stats Pending"
    And the player's weekly total shows "Incomplete"
    And the system retries fetching stats on next refresh

  Scenario: Validate scoring configuration before league starts
    Given the admin is creating a new league
    When the admin sets passing TD points to -10
    Then the system warns "Unusual scoring value: Passing TD -10 points"
    When the admin confirms the unusual value
    Then the scoring configuration is saved
    And the system logs the admin acknowledgment

  Scenario: Prevent invalid scoring rule modifications after lock
    Given the league has started and configuration is locked
    When the admin attempts to change PPR points from 1.0 to 0.5
    Then the modification is rejected with error "SCORING_LOCKED"
    And the PPR scoring remains at 1.0 points per reception

  # Leaderboard Impact

  Scenario: Weekly scoring affects league standings
    Given the league has 10 players with completed rosters
    And week 1 scoring is calculated for all players
    When the system updates the leaderboard
    Then players are ranked by total fantasy points (descending)
    And ties are broken by highest single-player score
    And the leaderboard shows each player's weekly and cumulative totals

  Scenario Outline: Position-specific scoring applies correctly
    Given the player has "<Player>" at <Position> position
    And in NFL week 1, "<Player>" has <Stat> of <Value>
    When the system calculates fantasy points for week 1
    Then the <Stat> contributes <Points> fantasy points

    Examples:
      | Player              | Position | Stat              | Value | Points |
      | Patrick Mahomes     | QB       | Passing yards     | 250   | 10.0   |
      | Patrick Mahomes     | QB       | Passing TDs       | 2     | 8.0    |
      | Patrick Mahomes     | QB       | Interceptions     | 1     | -2.0   |
      | Derrick Henry       | RB       | Rushing yards     | 150   | 15.0   |
      | Derrick Henry       | RB       | Rushing TDs       | 2     | 12.0   |
      | Davante Adams       | WR       | Receptions        | 10    | 10.0   |
      | Davante Adams       | WR       | Receiving yards   | 120   | 12.0   |
      | Davante Adams       | WR       | Receiving TDs     | 1     | 6.0    |
      | Mark Andrews        | TE       | Receptions        | 6     | 6.0    |
      | Mark Andrews        | TE       | Receiving yards   | 75    | 7.5    |

  Scenario Outline: PPR scoring type comparison
    Given a league with <PPR Type> scoring
    And a WR has 8 receptions and 80 receiving yards
    When the system calculates fantasy points
    Then the WR's total fantasy points is <Total Points>

    Examples:
      | PPR Type    | Total Points |
      | Standard    | 8.0          |
      | Half-PPR    | 12.0         |
      | Full-PPR    | 16.0         |
