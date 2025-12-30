Feature: Comprehensive Position-Specific Scoring with Configurable Rules
  As a fantasy football system
  I want to calculate fantasy points for all position types using configurable scoring rules
  So that each player type (QB, RB, WR, TE, K, DEF) is scored correctly based on league configuration

  Background:
    Given the system calculates fantasy points based on league configuration
    And each position type has different scoring rules
    And all scoring rules are configurable by league admins
    And scoring formulas are evaluated using Spring Expression Language (SpEL)

  # ==================== QUARTERBACK (QB) SCORING ====================

  Scenario: Calculate QB points with standard configuration
    Given a league has QB scoring configured as:
      | Stat                   | Points Per Unit |
      | Passing yards          | 0.04 (1 per 25) |
      | Passing TD             | 4               |
      | Interception           | -2              |
      | Rushing yards          | 0.1 (1 per 10)  |
      | Rushing TD             | 6               |
      | Fumble lost            | -2              |
      | 2-pt conversion pass   | 2               |
      | 2-pt conversion rush   | 2               |
    And "Patrick Mahomes" has stats:
      | Stat               | Value |
      | Passing yards      | 325   |
      | Passing TDs        | 3     |
      | Interceptions      | 1     |
      | Rushing yards      | 18    |
      | Rushing TDs        | 0     |
      | Fumbles lost       | 0     |
    When fantasy points are calculated
    Then the scoring breakdown is:
      | Component          | Calculation | Points |
      | Passing yards      | 325/25      | 13.0   |
      | Passing TDs        | 3 × 4       | 12.0   |
      | Interceptions      | 1 × -2      | -2.0   |
      | Rushing yards      | 18/10       | 1.8    |
    And total fantasy points = 24.8

  Scenario: QB with custom configuration (6-point passing TDs)
    Given a league has QB scoring configured as:
      | Passing TD             | 6    |
      | Passing yards per point| 20   |
      | Interception           | -3   |
    And "Josh Allen" has stats:
      | Passing yards      | 400   |
      | Passing TDs        | 4     |
      | Interceptions      | 2     |
      | Rushing yards      | 50    |
      | Rushing TDs        | 1     |
    When fantasy points are calculated
    Then the scoring breakdown is:
      | Passing yards  | 400/20  | 20.0  |
      | Passing TDs    | 4 × 6   | 24.0  |
      | Interceptions  | 2 × -3  | -6.0  |
      | Rushing yards  | 50/10   | 5.0   |
      | Rushing TDs    | 1 × 6   | 6.0   |
    And total fantasy points = 49.0

  Scenario: QB with multiple turnovers (negative points)
    Given "Quarterback X" has stats:
      | Passing yards      | 200   |
      | Passing TDs        | 1     |
      | Interceptions      | 4     |
      | Fumbles lost       | 2     |
    When fantasy points are calculated with standard rules
    Then the scoring is:
      | Passing yards  | 200/25  | 8.0   |
      | Passing TDs    | 1 × 4   | 4.0   |
      | Interceptions  | 4 × -2  | -8.0  |
      | Fumbles lost   | 2 × -2  | -4.0  |
    And total fantasy points = 0.0 (positive and negative cancel out)

  # ==================== RUNNING BACK (RB) SCORING ====================

  Scenario: Calculate RB points with PPR configuration
    Given a league has RB scoring configured as:
      | Rushing yards      | 0.1 (1 per 10)  |
      | Rushing TD         | 6               |
      | Receptions         | 1 (Full PPR)    |
      | Receiving yards    | 0.1 (1 per 10)  |
      | Receiving TD       | 6               |
      | Fumble lost        | -2              |
    And "Christian McCaffrey" has stats:
      | Rushing yards      | 120   |
      | Rushing TDs        | 2     |
      | Receptions         | 8     |
      | Receiving yards    | 65    |
      | Receiving TDs      | 1     |
      | Fumbles lost       | 0     |
    When fantasy points are calculated
    Then the scoring breakdown is:
      | Rushing yards    | 120/10  | 12.0  |
      | Rushing TDs      | 2 × 6   | 12.0  |
      | Receptions       | 8 × 1   | 8.0   |
      | Receiving yards  | 65/10   | 6.5   |
      | Receiving TDs    | 1 × 6   | 6.0   |
    And total fantasy points = 44.5

  Scenario: RB with Half-PPR configuration
    Given a league uses Half-PPR (0.5 points per reception)
    And "Derrick Henry" has stats:
      | Rushing yards      | 150   |
      | Rushing TDs        | 2     |
      | Receptions         | 3     |
      | Receiving yards    | 25    |
    When fantasy points are calculated
    Then the scoring is:
      | Rushing yards    | 150/10  | 15.0  |
      | Rushing TDs      | 2 × 6   | 12.0  |
      | Receptions       | 3 × 0.5 | 1.5   |
      | Receiving yards  | 25/10   | 2.5   |
    And total fantasy points = 31.0

  Scenario: RB with fumble penalty
    Given "Running Back X" has stats:
      | Rushing yards      | 80    |
      | Rushing TDs        | 1     |
      | Fumbles lost       | 2     |
    When fantasy points are calculated with standard rules
    Then the scoring is:
      | Rushing yards  | 80/10   | 8.0   |
      | Rushing TDs    | 1 × 6   | 6.0   |
      | Fumbles lost   | 2 × -2  | -4.0  |
    And total fantasy points = 10.0

  # ==================== WIDE RECEIVER (WR) SCORING ====================

  Scenario: Calculate WR points with Full PPR
    Given a league uses Full PPR (1 point per reception)
    And "Tyreek Hill" has stats:
      | Receptions         | 10    |
      | Receiving yards    | 150   |
      | Receiving TDs      | 2     |
      | Rushing yards      | 15    |
      | Rushing TDs        | 0     |
    When fantasy points are calculated
    Then the scoring breakdown is:
      | Receptions       | 10 × 1  | 10.0  |
      | Receiving yards  | 150/10  | 15.0  |
      | Receiving TDs    | 2 × 6   | 12.0  |
      | Rushing yards    | 15/10   | 1.5   |
    And total fantasy points = 38.5

  Scenario: WR with Standard (non-PPR) scoring
    Given a league uses Standard (0 points per reception)
    And "Wide Receiver X" has stats:
      | Receptions         | 10    |
      | Receiving yards    | 100   |
      | Receiving TDs      | 1     |
    When fantasy points are calculated
    Then the scoring is:
      | Receptions       | 10 × 0  | 0.0   |
      | Receiving yards  | 100/10  | 10.0  |
      | Receiving TDs    | 1 × 6   | 6.0   |
    And total fantasy points = 16.0
    And receptions provide no points in Standard scoring

  # ==================== TIGHT END (TE) SCORING ====================

  Scenario: Calculate TE points with Tight End Premium
    Given a league has TE premium scoring (1.5 PPR for TEs)
    And "Travis Kelce" has stats:
      | Receptions         | 8     |
      | Receiving yards    | 95    |
      | Receiving TDs      | 1     |
      | 2-pt conversions   | 1     |
    When fantasy points are calculated
    Then the scoring breakdown is:
      | Receptions       | 8 × 1.5 | 12.0  |
      | Receiving yards  | 95/10   | 9.5   |
      | Receiving TDs    | 1 × 6   | 6.0   |
      | 2-pt conversions | 1 × 2   | 2.0   |
    And total fantasy points = 29.5
    And TE premium rewards pass-catching TEs

  # ==================== KICKER (K) SCORING ====================

  Scenario: Calculate kicker points with standard distance-based scoring
    Given a league has kicker scoring configured as:
      | FG 0-39 yards      | 3     |
      | FG 40-49 yards     | 4     |
      | FG 50+ yards       | 5     |
      | Extra point        | 1     |
      | Missed FG 0-39     | 0     |
      | Missed FG 40-49    | 0     |
      | Missed FG 50+      | 0     |
      | Missed XP          | 0     |
    And "Harrison Butker" has stats:
      | FG made 0-39       | 2     |
      | FG made 40-49      | 1     |
      | FG made 50+        | 1     |
      | Extra points made  | 4     |
    When fantasy points are calculated
    Then the scoring breakdown is:
      | FG 0-39       | 2 × 3  | 6.0   |
      | FG 40-49      | 1 × 4  | 4.0   |
      | FG 50+        | 1 × 5  | 5.0   |
      | Extra points  | 4 × 1  | 4.0   |
    And total fantasy points = 19.0

  Scenario: Kicker with missed field goal penalties (custom configuration)
    Given a league has aggressive kicker penalty scoring:
      | FG made 0-39       | 3     |
      | FG made 40-49      | 4     |
      | FG made 50+        | 5     |
      | Missed FG 0-39     | -1    |
      | Missed FG 40-49    | -0.5  |
      | Missed FG 50+      | 0     |
      | Extra point        | 1     |
      | Missed XP          | -1    |
    And "Kicker X" has stats:
      | FG made 0-39       | 1     |
      | FG missed 0-39     | 2     |
      | FG made 40-49      | 1     |
      | FG missed 40-49    | 1     |
      | Extra points made  | 2     |
      | Extra points missed| 1     |
    When fantasy points are calculated
    Then the scoring breakdown is:
      | FG made 0-39     | 1 × 3    | 3.0   |
      | FG missed 0-39   | 2 × -1   | -2.0  |
      | FG made 40-49    | 1 × 4    | 4.0   |
      | FG missed 40-49  | 1 × -0.5 | -0.5  |
      | XP made          | 2 × 1    | 2.0   |
      | XP missed        | 1 × -1   | -1.0  |
    And total fantasy points = 5.5
    And missed kicks penalize the kicker

  Scenario: Kicker with extreme penalties (harsh league configuration)
    Given a league has harsh kicker penalty scoring:
      | FG made 0-39       | 3     |
      | Missed FG 0-39     | -3    |
      | Missed XP          | -2    |
    And "Unreliable Kicker" has stats:
      | FG made 0-39       | 1     |
      | FG missed 0-39     | 3     |
      | Extra points made  | 1     |
      | Extra points missed| 2     |
    When fantasy points are calculated
    Then the scoring is:
      | FG made 0-39    | 1 × 3   | 3.0   |
      | FG missed 0-39  | 3 × -3  | -9.0  |
      | XP made         | 1 × 1   | 1.0   |
      | XP missed       | 2 × -2  | -4.0  |
    And total fantasy points = -9.0 (negative total!)
    And harsh penalties can result in negative kicker scores

  Scenario: Perfect kicker with bonus points
    Given a league rewards perfect kickers:
      | FG made 40-49      | 4     |
      | FG made 50+        | 5     |
      | Extra point        | 1     |
      | Perfect day bonus  | 3     |
    And "Perfect Kicker" has stats:
      | FG made 40-49      | 2     |
      | FG made 50+        | 1     |
      | Extra points made  | 5     |
      | FG missed          | 0     |
      | XP missed          | 0     |
    When fantasy points are calculated
    Then the scoring is:
      | FG 40-49        | 2 × 4  | 8.0   |
      | FG 50+          | 1 × 5  | 5.0   |
      | Extra points    | 5 × 1  | 5.0   |
      | Perfect bonus   | 1 × 3  | 3.0   |
    And total fantasy points = 21.0

  # ==================== DEFENSE/SPECIAL TEAMS (DEF) SCORING ====================

  Scenario: Calculate defensive points with standard configuration
    Given a league has defensive scoring configured as:
      | Sacks                   | 1     |
      | Interceptions           | 2     |
      | Fumble recoveries       | 2     |
      | Safeties                | 2     |
      | Defensive TDs           | 6     |
      | Special teams TDs       | 6     |
      | Points allowed 0        | 10    |
      | Points allowed 1-6      | 7     |
      | Points allowed 7-13     | 4     |
      | Points allowed 14-20    | 1     |
      | Points allowed 21-27    | 0     |
      | Points allowed 28-34    | -1    |
      | Points allowed 35+      | -4    |
      | Yards allowed 0-99      | 10    |
      | Yards allowed 100-199   | 7     |
      | Yards allowed 200-299   | 5     |
      | Yards allowed 300-349   | 3     |
      | Yards allowed 350-399   | 0     |
      | Yards allowed 400-449   | -3    |
      | Yards allowed 450+      | -5    |
    And "San Francisco 49ers" defense has stats:
      | Sacks              | 4     |
      | Interceptions      | 2     |
      | Fumble recoveries  | 1     |
      | Defensive TDs      | 1     |
      | Points allowed     | 10    |
      | Yards allowed      | 250   |
    When fantasy points are calculated
    Then the scoring breakdown is:
      | Sacks            | 4 × 1  | 4.0   |
      | Interceptions    | 2 × 2  | 4.0   |
      | Fumble recoveries| 1 × 2  | 2.0   |
      | Defensive TDs    | 1 × 6  | 6.0   |
      | Points allowed   | 7-13   | 4.0   |
      | Yards allowed    | 200-299| 5.0   |
    And total fantasy points = 25.0

  Scenario: Defense allows many points (negative scoring)
    Given "Defense X" has stats:
      | Sacks              | 2     |
      | Interceptions      | 0     |
      | Points allowed     | 42    |
      | Yards allowed      | 475   |
    When fantasy points are calculated with standard rules
    Then the scoring is:
      | Sacks            | 2 × 1  | 2.0   |
      | Points allowed   | 35+    | -4.0  |
      | Yards allowed    | 450+   | -5.0  |
    And total fantasy points = -7.0 (negative defensive score!)

  Scenario: Elite defensive shutout performance
    Given "Elite Defense" has stats:
      | Sacks              | 6     |
      | Interceptions      | 3     |
      | Fumble recoveries  | 2     |
      | Safeties           | 1     |
      | Defensive TDs      | 2     |
      | Points allowed     | 0     |
      | Yards allowed      | 150   |
    When fantasy points are calculated with standard rules
    Then the scoring is:
      | Sacks            | 6 × 1  | 6.0   |
      | Interceptions    | 3 × 2  | 6.0   |
      | Fumble recoveries| 2 × 2  | 4.0   |
      | Safeties         | 1 × 2  | 2.0   |
      | Defensive TDs    | 2 × 6  | 12.0  |
      | Points allowed   | 0      | 10.0  |
      | Yards allowed    | 100-199| 7.0   |
    And total fantasy points = 47.0 (elite defensive performance!)

  # ==================== FLEX POSITION SCORING ====================

  Scenario: FLEX position uses same scoring as base position
    Given a league has FLEX position (RB/WR/TE eligible)
    And a player slots "Cooper Kupp" (WR) in FLEX
    And "Cooper Kupp" has stats:
      | Receptions         | 9     |
      | Receiving yards    | 115   |
      | Receiving TDs      | 1     |
    When fantasy points are calculated
    Then WR scoring rules are applied:
      | Receptions       | 9 × 1   | 9.0   |
      | Receiving yards  | 115/10  | 11.5  |
      | Receiving TDs    | 1 × 6   | 6.0   |
    And total fantasy points = 26.5
    And FLEX doesn't have separate scoring rules

  # ==================== SUPERFLEX POSITION SCORING ====================

  Scenario: Superflex uses QB scoring when QB is slotted
    Given a league has Superflex position (QB/RB/WR/TE eligible)
    And a player slots "Geno Smith" (QB) in Superflex
    And "Geno Smith" has stats:
      | Passing yards      | 250   |
      | Passing TDs        | 2     |
      | Interceptions      | 1     |
    When fantasy points are calculated
    Then QB scoring rules are applied:
      | Passing yards  | 250/25  | 10.0  |
      | Passing TDs    | 2 × 4   | 8.0   |
      | Interceptions  | 1 × -2  | -2.0  |
    And total fantasy points = 16.0

  # ==================== CONFIGURATION VALIDATION ====================

  Scenario: Prevent invalid scoring configuration
    Given an admin attempts to configure scoring:
      | Passing yards per point | -5    |
      | Rushing TD              | 0     |
    When the configuration is validated
    Then the system rejects negative yards per point
    And the system warns about 0-point touchdowns
    And the configuration is not saved

  Scenario: Admin can configure zero penalty for negative plays
    Given an admin wants forgiving scoring with no penalties
    When the admin configures:
      | Interception    | 0     |
      | Fumble lost     | 0     |
      | Missed FG 0-39  | 0     |
    Then the configuration is valid
    And negative plays don't reduce fantasy points

  # ==================== COMPLEX MULTI-STAT SCENARIOS ====================

  Scenario: QB who also catches a TD (trick play)
    Given "Player X" is listed as QB
    And has stats:
      | Passing yards      | 200   |
      | Passing TDs        | 2     |
      | Receptions         | 1     |
      | Receiving yards    | 3     |
      | Receiving TDs      | 1     |
    When fantasy points are calculated
    Then all stats are counted:
      | Passing yards    | 200/25  | 8.0   |
      | Passing TDs      | 2 × 4   | 8.0   |
      | Receptions       | 1 × 1   | 1.0   |
      | Receiving yards  | 3/10    | 0.3   |
      | Receiving TDs    | 1 × 6   | 6.0   |
    And total fantasy points = 23.3

  Scenario: Zero stat performance (DNP - Did Not Play)
    Given "Injured Player" has all stats at 0
    When fantasy points are calculated
    Then total fantasy points = 0.0
    And the player contributed nothing to roster

  Scenario: Stat correction changes calculated points
    Given "Player Y" was originally credited with stats:
      | Rushing yards      | 105   |
      | Rushing TDs        | 2     |
    And original fantasy points = 22.5
    When NFL issues stat correction:
      | Rushing yards      | 98    |
      | Rushing TDs        | 1     |
    Then new fantasy points are calculated:
      | Rushing yards    | 98/10  | 9.8   |
      | Rushing TDs      | 1 × 6  | 6.0   |
    And new total = 15.8
    And the difference of -6.7 points is applied

  # ==================== EDGE CASES ====================

  Scenario: Fractional stat values are rounded correctly
    Given "Player Z" has stats:
      | Rushing yards      | 107   |
      | Receiving yards    | 83    |
    When fantasy points are calculated
    Then the scoring is:
      | Rushing yards    | 107/10  | 10.7  |
      | Receiving yards  | 83/10   | 8.3   |
    And total fantasy points = 19.0 (to 1 decimal place)

  Scenario: Extremely high stat totals
    Given "Record-Breaking Player" has stats:
      | Passing yards      | 554   |
      | Passing TDs        | 7     |
    When fantasy points are calculated
    Then the scoring is:
      | Passing yards  | 554/25  | 22.16 |
      | Passing TDs    | 7 × 4   | 28.0  |
    And total fantasy points = 50.16
    And the system handles record-breaking performances

  Scenario: All negative stats (worst possible performance)
    Given "Worst Performance" has stats:
      | Passing yards      | 50    |
      | Interceptions      | 5     |
      | Fumbles lost       | 3     |
      | Sacks taken        | 8     |
    When fantasy points are calculated
    Then the scoring is:
      | Passing yards  | 50/25   | 2.0   |
      | Interceptions  | 5 × -2  | -10.0 |
      | Fumbles lost   | 3 × -2  | -6.0  |
    And total fantasy points = -14.0
    And the system correctly handles net negative scores

  # ==================== SPEL IMPLEMENTATION ====================

  @spel @implementation
  Scenario: Scoring formulas stored as SpEL expressions with configurable multipliers
    Given a league has configurable scoring formulas stored as:
      | position | spel_formula                                                                |
      | QB       | #passingYards * #ptsPerPassYard + #passingTDs * #ptsPerPassTD - #interceptions * #ptsPerInt + #rushingYards * #ptsPerRushYard + #rushingTDs * #ptsPerRushTD - #fumblesLost * #ptsPerFumble |
      | RB       | #rushingYards * #ptsPerRushYard + #rushingTDs * #ptsPerRushTD + #receptions * #pprValue + #receivingYards * #ptsPerRecYard + #receivingTDs * #ptsPerRecTD - #fumblesLost * #ptsPerFumble |
      | WR       | #receivingYards * #ptsPerRecYard + #receivingTDs * #ptsPerRecTD + #receptions * #pprValue + #rushingYards * #ptsPerRushYard + #rushingTDs * #ptsPerRushTD |
      | TE       | #receivingYards * #ptsPerRecYard + #receivingTDs * #ptsPerRecTD + #receptions * #tePremium |
      | K        | #xpMade * #ptsPerXP - #xpMissed * #ptsPerXPMiss + #fg0to39Made * #ptsPerFG0to39 + #fg40to49Made * #ptsPerFG40to49 + #fg50PlusMade * #ptsPerFG50Plus |
    When scoring is calculated using the SpEL engine
    Then formulas are parsed and cached for performance
    And player stats and scoring multipliers are injected as SpEL variables

  @spel @configuration
  Scenario: Configurable scoring multipliers per league
    Given a league has scoring multipliers configured as:
      | multiplier        | default | description                    |
      | #ptsPerPassYard   | 0.04    | Points per passing yard        |
      | #ptsPerPassTD     | 4       | Points per passing touchdown   |
      | #ptsPerInt        | 2       | Points lost per interception   |
      | #ptsPerRushYard   | 0.1     | Points per rushing yard        |
      | #ptsPerRushTD     | 6       | Points per rushing touchdown   |
      | #ptsPerRecYard    | 0.1     | Points per receiving yard      |
      | #ptsPerRecTD      | 6       | Points per receiving touchdown |
      | #ptsPerFumble     | 2       | Points lost per fumble         |
      | #pprValue         | 0-1     | Points per reception (PPR)     |
      | #tePremium        | 1.5     | TE premium reception multiplier|
      | #ptsPerXP         | 1       | Points per extra point made    |
      | #ptsPerXPMiss     | 1       | Points lost per XP missed      |
      | #ptsPerFG0to39    | 3       | Points per FG 0-39 yards       |
      | #ptsPerFG40to49   | 4       | Points per FG 40-49 yards      |
      | #ptsPerFG50Plus   | 5       | Points per FG 50+ yards        |
    When a league admin modifies a multiplier
    Then the new value is used in all future scoring calculations
    And historical scores are not affected

  @spel @variables
  Scenario: Available SpEL variables for scoring
    Given the SpEL evaluation context includes:
      | variable           | description                           |
      | #passingYards      | Passing yards                         |
      | #passingTDs        | Passing touchdowns                    |
      | #interceptions     | Interceptions thrown                  |
      | #rushingYards      | Rushing yards                         |
      | #rushingTDs        | Rushing touchdowns                    |
      | #receptions        | Receptions                            |
      | #receivingYards    | Receiving yards                       |
      | #receivingTDs      | Receiving touchdowns                  |
      | #fumblesLost       | Fumbles lost                          |
      | #pprValue          | PPR multiplier (0, 0.5, or 1.0)       |
      | #tePremium         | TE premium multiplier (default 1.5)   |
      | #xpMade            | Extra points made                     |
      | #xpMissed          | Extra points missed                   |
      | #fg0to39Made       | Field goals 0-39 yards made           |
      | #fg40to49Made      | Field goals 40-49 yards made          |
      | #fg50PlusMade      | Field goals 50+ yards made            |
      | #sacks             | Defensive sacks                       |
      | #defensiveTDs      | Defensive touchdowns                  |
      | #pointsAllowed     | Points allowed by defense             |
    When a formula references these variables
    Then values are injected from player statistics

  @spel @bonuses
  Scenario: Configurable milestone bonuses using SpEL conditionals
    Given a league has configurable bonus rules:
      | bonus                  | spel_expression                                                                          |
      | 300-yard passing       | (#passingYards >= #bonus300PassThreshold ? #bonus300PassPts : 0)                        |
      | 400-yard passing       | (#passingYards >= #bonus400PassThreshold ? #bonus400PassPts : 0)                        |
      | 100-yard rushing       | (#rushingYards >= #bonus100RushThreshold ? #bonus100RushPts : 0)                        |
      | 200-yard rushing       | (#rushingYards >= #bonus200RushThreshold ? #bonus200RushPts : 0)                        |
      | 100-yard receiving     | (#receivingYards >= #bonus100RecThreshold ? #bonus100RecPts : 0)                        |
      | 200-yard receiving     | (#receivingYards >= #bonus200RecThreshold ? #bonus200RecPts : 0)                        |
      | 40+ yard TD pass       | (#longTDPass >= #bonus40YdTDThreshold ? #bonus40YdTDPts : 0)                            |
      | 40+ yard TD rush       | (#longTDRush >= #bonus40YdTDThreshold ? #bonus40YdTDPts : 0)                            |
      | 40+ yard TD reception  | (#longTDRec >= #bonus40YdTDThreshold ? #bonus40YdTDPts : 0)                             |
      | Perfect kicker game    | (#fgMissed == 0 && #xpMissed == 0 && (#fgMade + #xpMade) >= #bonusPerfectKickerMin ? #bonusPerfectKickerPts : 0) |
    And the bonus thresholds and points are configurable:
      | multiplier                | default | description                      |
      | #bonus300PassThreshold    | 300     | Threshold for 300-yard bonus     |
      | #bonus300PassPts          | 3       | Points for 300-yard passing      |
      | #bonus400PassThreshold    | 400     | Threshold for 400-yard bonus     |
      | #bonus400PassPts          | 5       | Points for 400-yard passing      |
      | #bonus100RushThreshold    | 100     | Threshold for 100-yard rushing   |
      | #bonus100RushPts          | 3       | Points for 100-yard rushing      |
      | #bonus200RushThreshold    | 200     | Threshold for 200-yard rushing   |
      | #bonus200RushPts          | 5       | Points for 200-yard rushing      |
      | #bonus100RecThreshold     | 100     | Threshold for 100-yard receiving |
      | #bonus100RecPts           | 3       | Points for 100-yard receiving    |
      | #bonus200RecThreshold     | 200     | Threshold for 200-yard receiving |
      | #bonus200RecPts           | 5       | Points for 200-yard receiving    |
      | #bonus40YdTDThreshold     | 40      | Min yards for long TD bonus      |
      | #bonus40YdTDPts           | 2       | Points for 40+ yard TD           |
      | #bonusPerfectKickerMin    | 5       | Min kicks for perfect game bonus |
      | #bonusPerfectKickerPts    | 3       | Points for perfect kicker game   |
    When bonuses are evaluated using SpEL
    Then all applicable bonuses are added to base score
    And league admins can enable/disable individual bonuses

  # ============================================================================
  # SPEL ENGINE ERROR HANDLING
  # ============================================================================

  @spel @error-handling
  Scenario: Handle invalid SpEL formula syntax
    Given an admin configures a custom SpEL formula with syntax error
      | formula | #passingYards * #ptsPerPassYard + (unclosed parenthesis |
    When the formula is validated
    Then the system rejects the formula with error "Invalid SpEL syntax"
    And the error message includes the position of the syntax error
    And the previous valid formula remains in effect

  @spel @error-handling
  Scenario: Handle missing variable in SpEL formula
    Given a scoring formula references an undefined variable
      | formula | #passingYards * #ptsPerPassYard + #nonExistentVar |
    When the formula is evaluated
    Then the system logs a warning about undefined variable "#nonExistentVar"
    And the undefined variable is treated as 0
    And the remaining formula is evaluated correctly

  @spel @error-handling
  Scenario: Handle null stat values in SpEL evaluation
    Given a player has null values for some stats
      | stat           | value |
      | passingYards   | 250   |
      | passingTDs     | 2     |
      | interceptions  | null  |
      | rushingYards   | null  |
    When the scoring formula is evaluated
    Then null values are treated as 0
    And the formula evaluates without errors
    And only non-null stats contribute to the score

  @spel @error-handling
  Scenario: Handle division by zero in custom formula
    Given an admin configures a formula with potential division
      | formula | #passingYards / #gamesPlayed |
    And #gamesPlayed is 0
    When the formula is evaluated
    Then the system returns 0.0 for the division result
    And the error is logged for investigation
    And the player's score defaults to 0

  @spel @error-handling
  Scenario: Handle numeric overflow in scoring calculation
    Given a player has extremely high stat values
      | passingYards   | 2147483647 |
      | passingTDs     | 100        |
    When the scoring formula is evaluated
    Then the system detects potential overflow
    And the score is capped at a maximum value
    And an alert is raised for manual review

  @spel @validation
  Scenario: Validate SpEL formula before saving
    Given an admin creates a new scoring formula
    When the formula is submitted for saving
    Then the system validates SpEL syntax
    And the system verifies all referenced variables exist
    And the system performs a test evaluation with sample data
    And only valid formulas are saved to configuration

  # ============================================================================
  # SCORING AUDIT AND HISTORY
  # ============================================================================

  @audit
  Scenario: Record scoring calculation audit trail
    Given "Patrick Mahomes" scores fantasy points in Week 10
    When the scoring calculation completes
    Then an audit record is created with
      | field              | value                                    |
      | playerId           | mahomes-id                               |
      | weekId             | 10                                       |
      | position           | QB                                       |
      | formulaUsed        | [SpEL formula]                           |
      | inputStats         | [JSON of all stat values]                |
      | scoringMultipliers | [JSON of all multiplier values]          |
      | baseScore          | 24.8                                     |
      | bonuses            | [JSON of applied bonuses]                |
      | totalScore         | 27.8                                     |
      | calculatedAt       | [timestamp]                              |
      | configVersion      | [scoring config version]                 |

  @audit
  Scenario: Query historical scoring calculations
    Given scoring audits exist for "Patrick Mahomes" for weeks 1-10
    When an admin queries scoring history for player "mahomes-id"
    Then the system returns all audit records chronologically
    And each record includes the formula and multipliers used at that time
    And the admin can compare how scoring rules changed over time

  @audit
  Scenario: Track scoring configuration changes
    Given a league modifies scoring rules
      | change                    | old_value | new_value |
      | Points per passing TD     | 4         | 6         |
      | Points per interception   | -2        | -1        |
    When the configuration is saved
    Then an audit record captures the change
      | field           | value                          |
      | changedBy       | admin-user-id                  |
      | changedAt       | [timestamp]                    |
      | configVersion   | [incremented version]          |
      | changes         | [JSON diff of old vs new]      |
    And future scores use the new configuration
    And historical scores remain unchanged

  @audit
  Scenario: Explain scoring breakdown to users
    Given a user views their fantasy score for Week 5
    When they request a scoring breakdown
    Then the system displays
      | Category         | Stats Used         | Points Earned |
      | Passing          | 350 yds, 3 TDs     | 26.0          |
      | Rushing          | 25 yds, 0 TDs      | 2.5           |
      | Turnovers        | 1 INT              | -2.0          |
      | Bonuses          | 300-yard passing   | 3.0           |
      | Total            |                    | 29.5          |
    And each line item shows the formula applied

  # ============================================================================
  # LEAGUE SCORING TEMPLATES
  # ============================================================================

  @templates
  Scenario: Create league from Standard scoring template
    Given the system has a "Standard" scoring template
      | stat                | value |
      | Passing yards       | 0.04  |
      | Passing TD          | 4     |
      | Rushing yards       | 0.1   |
      | Rushing TD          | 6     |
      | Reception           | 0     |
      | Receiving yards     | 0.1   |
      | Receiving TD        | 6     |
    When a new league selects the Standard template
    Then all scoring rules are copied from the template
    And the league admin can customize any rule
    And the template remains unchanged

  @templates
  Scenario: Create league from PPR scoring template
    Given the system has a "PPR" scoring template
      | stat                | value |
      | Reception           | 1.0   |
    When a new league selects the PPR template
    Then receptions earn 1 point each
    And all other rules follow the template defaults

  @templates
  Scenario: Create league from Half-PPR scoring template
    Given the system has a "Half-PPR" scoring template
      | stat                | value |
      | Reception           | 0.5   |
    When a new league selects the Half-PPR template
    Then receptions earn 0.5 points each

  @templates
  Scenario: Create league from TE Premium template
    Given the system has a "TE Premium" scoring template
      | stat                     | value |
      | TE Reception             | 1.5   |
      | WR/RB Reception          | 1.0   |
    When a new league selects the TE Premium template
    Then tight ends earn 1.5 points per reception
    And wide receivers and running backs earn 1.0 points per reception

  @templates
  Scenario: Create league from custom template
    Given a league admin has created a custom template "High Scoring"
      | stat                | value |
      | Passing TD          | 6     |
      | Rushing TD          | 8     |
      | Receiving TD        | 8     |
      | Reception           | 1.5   |
    When another league copies this template
    Then all custom rules are applied
    And the source template is attributed

  # ============================================================================
  # INDIVIDUAL DEFENSIVE PLAYER (IDP) SCORING
  # ============================================================================

  @idp
  Scenario: Calculate IDP scoring for linebacker
    Given a league has IDP scoring enabled
    And IDP scoring is configured as:
      | Stat               | Points |
      | Solo tackle        | 1      |
      | Assisted tackle    | 0.5    |
      | Sack               | 2      |
      | Tackle for loss    | 1      |
      | Pass defended      | 1      |
      | Interception       | 3      |
      | Forced fumble      | 2      |
      | Fumble recovery    | 2      |
      | Defensive TD       | 6      |
      | Safety             | 4      |
    And "Fred Warner" (LB) has stats:
      | Solo tackles       | 8      |
      | Assisted tackles   | 4      |
      | Sacks              | 1.5    |
      | Tackles for loss   | 2      |
      | Pass defended      | 1      |
    When fantasy points are calculated
    Then the scoring breakdown is:
      | Solo tackles     | 8 × 1    | 8.0   |
      | Assisted tackles | 4 × 0.5  | 2.0   |
      | Sacks            | 1.5 × 2  | 3.0   |
      | TFL              | 2 × 1    | 2.0   |
      | Pass defended    | 1 × 1    | 1.0   |
    And total fantasy points = 16.0

  @idp
  Scenario: Calculate IDP scoring for defensive back
    Given a league has IDP scoring enabled
    And "Jalen Ramsey" (CB) has stats:
      | Solo tackles       | 4      |
      | Interceptions      | 2      |
      | Pass defended      | 5      |
      | Fumble recovery    | 1      |
    When fantasy points are calculated
    Then the scoring breakdown is:
      | Solo tackles     | 4 × 1   | 4.0   |
      | Interceptions    | 2 × 3   | 6.0   |
      | Pass defended    | 5 × 1   | 5.0   |
      | Fumble recovery  | 1 × 2   | 2.0   |
    And total fantasy points = 17.0

  @idp
  Scenario: Calculate IDP scoring for defensive lineman
    Given a league has IDP scoring enabled
    And "Nick Bosa" (DE) has stats:
      | Solo tackles       | 3      |
      | Sacks              | 2.5    |
      | Tackles for loss   | 3      |
      | Forced fumble      | 1      |
    When fantasy points are calculated
    Then the scoring breakdown is:
      | Solo tackles     | 3 × 1   | 3.0   |
      | Sacks            | 2.5 × 2 | 5.0   |
      | TFL              | 3 × 1   | 3.0   |
      | Forced fumble    | 1 × 2   | 2.0   |
    And total fantasy points = 13.0

  @idp
  Scenario: IDP big play bonus
    Given a league has IDP big play bonuses:
      | Stat                    | Points |
      | Interception return TD  | 6      |
      | Fumble return TD        | 6      |
      | 50+ yard interception   | 2      |
    And "Defensive Player X" has stats:
      | Interceptions          | 1      |
      | Interception return TD | 1      |
      | Interception yards     | 65     |
    When fantasy points are calculated
    Then the scoring includes:
      | Interception         | 1 × 3   | 3.0   |
      | Interception TD      | 1 × 6   | 6.0   |
      | 50+ yard INT bonus   | 1 × 2   | 2.0   |
    And total fantasy points = 11.0

  # ============================================================================
  # SCORE RECALCULATION
  # ============================================================================

  @recalculation
  Scenario: Recalculate scores after stat correction
    Given Week 5 scores have been calculated and finalized
    And the NFL issues a stat correction for "Player X"
      | stat           | original | corrected |
      | Rushing yards  | 102      | 98        |
      | Rushing TDs    | 2        | 1         |
    When the stat correction is applied
    Then the scoring service recalculates affected player's score
    And the original score of 22.2 becomes 15.8
    And the score difference (-6.4) is applied to all matchups
    And affected matchup outcomes are updated if necessary

  @recalculation
  Scenario: Recalculate scores after configuration change (future only)
    Given a league admin changes scoring rules
      | change              | old_value | new_value |
      | Points per rush TD  | 6         | 8         |
    When the configuration is saved
    Then future week scores use the new configuration
    And historical week scores are NOT recalculated
    And users see a notice about the configuration change

  @recalculation
  Scenario: Bulk recalculation for entire week
    Given a data provider error caused incorrect stats for Week 8
    When corrected stats are received for all players
    Then the system queues bulk recalculation for Week 8
    And each player's score is recalculated with corrected stats
    And all matchup outcomes are re-evaluated
    And users are notified of any changes

  @recalculation
  Scenario: Recalculation preserves audit history
    Given a player's score is recalculated due to stat correction
    When the new score is saved
    Then the original audit record is preserved with status "superseded"
    And a new audit record is created with status "corrected"
    And the new record references the original record
    And both records are available for historical analysis

  # ============================================================================
  # MULTI-WEEK AGGREGATION
  # ============================================================================

  @aggregation
  Scenario: Calculate season total points
    Given "Player X" has weekly scores:
      | Week | Points |
      | 1    | 18.5   |
      | 2    | 22.3   |
      | 3    | 15.0   |
      | 4    | 28.7   |
      | 5    | 12.2   |
    When season totals are calculated
    Then total fantasy points = 96.7
    And average points per game = 19.34

  @aggregation
  Scenario: Calculate playoff period points
    Given playoffs run from Week 15 to Week 17
    And "Player Y" has playoff scores:
      | Week | Points |
      | 15   | 25.0   |
      | 16   | 32.5   |
      | 17   | 18.3   |
    When playoff totals are calculated
    Then total playoff fantasy points = 75.8
    And playoff average = 25.27

  @aggregation
  Scenario: Compare scoring across positions
    Given the following season totals by position:
      | Position | Top Score | Average | Median |
      | QB       | 425.3     | 285.2   | 280.0  |
      | RB       | 320.5     | 180.4   | 165.2  |
      | WR       | 310.8     | 175.6   | 160.5  |
      | TE       | 250.2     | 120.3   | 105.8  |
      | K        | 185.0     | 145.2   | 142.0  |
      | DEF      | 220.0     | 125.5   | 118.0  |
    When position rankings are generated
    Then each position has a VBD (Value Based Draft) score
    And replacement level is calculated per position

  # ============================================================================
  # PERFORMANCE CONSIDERATIONS
  # ============================================================================

  @performance
  Scenario: Cache compiled SpEL expressions
    Given scoring formulas are frequently evaluated
    When the SpEL engine is initialized
    Then all position formulas are pre-compiled
    And compiled expressions are cached in memory
    And subsequent evaluations reuse cached expressions
    And cache is invalidated only when formulas change

  @performance
  Scenario: Batch scoring calculation for entire week
    Given Week 10 has 500 player stat records to score
    When batch scoring is triggered
    Then the system processes players in parallel batches
    And each batch size is optimized for memory usage
    And total calculation time is under 5 seconds
    And all scores are atomically saved on success

  @performance
  Scenario: Handle concurrent scoring requests
    Given multiple users request score recalculation simultaneously
    When requests arrive within the same second
    Then the system uses optimistic locking for score updates
    And duplicate calculations are detected and deduplicated
    And each player's score is calculated exactly once

  @performance
  Scenario: Scoring engine response time under load
    Given 1000 concurrent score calculation requests
    When load testing is performed
    Then 95th percentile response time is under 100ms
    And no requests fail due to timeout
    And memory usage remains stable

  # ============================================================================
  # ADVANCED EDGE CASES
  # ============================================================================

  @edge-case
  Scenario: Player changes position mid-season
    Given "Taysom Hill" is listed as QB in weeks 1-8
    And "Taysom Hill" is listed as TE in weeks 9-17
    When scoring is calculated
    Then QB rules are applied for weeks 1-8
    And TE rules are applied for weeks 9-17
    And season totals combine both position scores correctly

  @edge-case
  Scenario: Player traded mid-game
    Given "Player X" is traded during a game
    And stats are split between teams:
      | Team | Rushing yards | Rushing TDs |
      | A    | 45            | 1           |
      | B    | 30            | 0           |
    When fantasy points are calculated
    Then all stats are combined regardless of team
    And total rushing yards = 75
    And total rushing TDs = 1
    And total fantasy points = 13.5

  @edge-case
  Scenario: Two-point conversion scoring
    Given a league scores 2-point conversions:
      | Type              | Points |
      | 2PC pass          | 2      |
      | 2PC rush          | 2      |
      | 2PC reception     | 2      |
    And "Player X" has 2-point conversion stats:
      | 2PC passes thrown    | 1 |
      | 2PC receptions made  | 2 |
    When fantasy points are calculated
    Then the scoring includes:
      | 2PC passes      | 1 × 2  | 2.0  |
      | 2PC receptions  | 2 × 2  | 4.0  |
    And total 2PC fantasy points = 6.0

  @edge-case
  Scenario: Defensive scoring against negative offensive yards
    Given "Defense X" holds opponents to negative rushing yards
      | Rushing yards allowed  | -5   |
      | Passing yards allowed  | 180  |
      | Total yards allowed    | 175  |
    When fantasy points are calculated
    Then yards allowed bracket = 100-199
    And yards allowed points = 7
    And negative rushing yards don't cause calculation errors

  @edge-case
  Scenario: Handle bye week with no stats
    Given "Player X" is on bye in Week 7
    When scoring is attempted for Week 7
    Then the system returns 0 fantasy points
    And no audit record is created for bye week
    And the player is marked as "BYE" in the interface

  @edge-case
  Scenario: Handle COVID/injury designation with zero snaps
    Given "Player X" is active but plays 0 snaps
    And the player has all stats at 0
    When fantasy points are calculated
    Then total fantasy points = 0.0
    And the player is marked as "ACTIVE - 0 snaps"
    And this differs from inactive/out status

  @edge-case
  Scenario: Defensive player scores offensive touchdown
    Given "Defensive Player X" (LB) catches a TD on fake punt
      | Receptions        | 1    |
      | Receiving yards   | 45   |
      | Receiving TDs     | 1    |
    When fantasy points are calculated for IDP scoring
    Then offensive stats are counted with IDP scoring rules:
      | Receiving yards  | 45/10  | 4.5   |
      | Receiving TDs    | 1 × 6  | 6.0   |
    And IDP stats for the same game are also counted
    And total combines both offensive and defensive contributions

  @edge-case
  Scenario: Kicker attempts and makes 60+ yard field goal
    Given a league has extended distance kicker scoring:
      | FG made 50-59 yards | 5     |
      | FG made 60+ yards   | 6     |
    And "Justin Tucker" makes a 66-yard field goal
    When fantasy points are calculated
    Then the 60+ yard FG earns 6 points
    And this is displayed as a record-breaking achievement

  @edge-case
  Scenario: Defensive touchdown on two-point conversion return
    Given a league scores defensive 2PC returns:
      | Defensive 2PC return TD | 2 |
    And "Defense X" returns a 2PC attempt for a score
    When fantasy points are calculated
    Then the defensive 2PC return earns 2 points
    And this is rare but valid scoring category

  # ============================================================================
  # SCORING VALIDATION AND CONSTRAINTS
  # ============================================================================

  @validation
  Scenario: Enforce minimum scoring values
    Given an admin attempts to configure scoring:
      | Stat                | Value |
      | Passing TD          | -5    |
      | Rushing yards/point | 0     |
    When the configuration is validated
    Then the system rejects negative touchdown values
    And the system rejects zero yards per point (division by zero)
    And validation errors are clearly displayed

  @validation
  Scenario: Enforce maximum scoring values
    Given an admin attempts to configure scoring:
      | Stat        | Value |
      | Passing TD  | 100   |
    When the configuration is validated
    Then the system warns about unusually high values
    And the admin must confirm the unusual configuration
    And a warning is logged for review

  @validation
  Scenario: Validate consistency of PPR settings
    Given an admin configures PPR settings:
      | Position | PPR Value |
      | RB       | 1.0       |
      | WR       | 0.5       |
      | TE       | 1.5       |
    When the configuration is validated
    Then the system notes inconsistent PPR values across positions
    And the admin is warned this is non-standard
    And the configuration is allowed if admin confirms

  @validation
  Scenario: Prevent duplicate scoring categories
    Given an admin configures:
      | Stat           | Value |
      | Passing TD     | 4     |
      | Passing TD     | 6     |
    When the configuration is validated
    Then the system rejects duplicate category definitions
    And only one value per scoring category is allowed

  # ============================================================================
  # REAL-TIME SCORING DURING GAMES
  # ============================================================================

  @realtime
  Scenario: Calculate live scoring during game
    Given a live NFL game is in progress
    And "Patrick Mahomes" current game stats are:
      | Passing yards   | 175   |
      | Passing TDs     | 2     |
      | Interceptions   | 0     |
    When live fantasy points are calculated
    Then current fantasy points = 15.0
    And projected final score is estimated
    And score updates every stat change

  @realtime
  Scenario: Handle stat revisions during game
    Given live scoring shows "Player X" with 1 rushing TD
    When the play is reviewed and overturned
    Then the rushing TD is removed from stats
    And fantasy points are immediately recalculated
    And users see the score decrease in real-time
    And a notification explains the revision

  @realtime
  Scenario: Display projected fantasy points
    Given a game is at halftime
    And "Player X" has first-half stats:
      | Rushing yards  | 65   |
      | Rushing TDs    | 1    |
      | Current points | 12.5 |
    When projections are calculated
    Then projected final points = 25.0 (based on pace)
    And confidence interval is displayed (20-30 range)
    And projection updates as game progresses

  # ============================================================================
  # CROSS-LEAGUE SCORING COMPARISON
  # ============================================================================

  @comparison
  Scenario: Compare player value across league formats
    Given "Travis Kelce" has Week 10 stats:
      | Receptions        | 8    |
      | Receiving yards   | 85   |
      | Receiving TDs     | 1    |
    When scoring is compared across formats:
      | Format      | PPR Value | Points |
      | Standard    | 0         | 14.5   |
      | Half-PPR    | 0.5       | 18.5   |
      | Full PPR    | 1.0       | 22.5   |
      | TE Premium  | 1.5       | 26.5   |
    Then the value difference between formats is displayed
    And TE Premium shows 12-point advantage over Standard

  @comparison
  Scenario: Generate position scarcity analysis
    Given season scoring data for all players
    When scarcity analysis is generated
    Then each position shows:
      | Position | Replacement Level | Top 5 vs Replacement |
      | QB       | QB12              | +5.2 pts/week        |
      | RB       | RB24              | +8.1 pts/week        |
      | WR       | WR30              | +6.5 pts/week        |
      | TE       | TE12              | +4.8 pts/week        |
    And this informs draft and trade strategy
