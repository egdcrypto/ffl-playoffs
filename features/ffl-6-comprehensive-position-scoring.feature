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
