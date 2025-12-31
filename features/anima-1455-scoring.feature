@backend @priority_1 @scoring @configuration
Feature: Comprehensive Scoring System
  As a fantasy football playoffs application
  I want to provide flexible scoring configuration, accurate calculations, and detailed breakdowns
  So that league commissioners can customize scoring rules and players can understand their scores

  Background:
    Given a league "2025 NFL Playoffs Pool" exists
    And the league has a commissioner "league_admin"
    And the game has 4 weeks (Wild Card, Divisional, Conference, Super Bowl)

  # ==================== SCORING SETTINGS ====================

  Scenario: Configure default PPR scoring settings for a league
    Given the commissioner is setting up the league
    When the commissioner selects "PPR" as the scoring format
    Then the default scoring configuration is applied:
      | Category          | Stat                  | Points Per Unit |
      | Passing           | Passing Yards         | 0.04            |
      | Passing           | Passing TD            | 4               |
      | Passing           | Interception          | -2              |
      | Passing           | 2-Point Conversion    | 2               |
      | Rushing           | Rushing Yards         | 0.1             |
      | Rushing           | Rushing TD            | 6               |
      | Rushing           | 2-Point Conversion    | 2               |
      | Receiving         | Receptions            | 1.0             |
      | Receiving         | Receiving Yards       | 0.1             |
      | Receiving         | Receiving TD          | 6               |
      | Receiving         | 2-Point Conversion    | 2               |
      | Fumbles           | Fumble Lost           | -2              |
    And the configuration is saved to the league settings

  Scenario: Configure Half-PPR scoring settings
    Given the commissioner is setting up the league
    When the commissioner selects "Half-PPR" as the scoring format
    Then the reception points are set to 0.5 per reception
    And all other settings match standard PPR configuration

  Scenario: Configure Standard (non-PPR) scoring settings
    Given the commissioner is setting up the league
    When the commissioner selects "Standard" as the scoring format
    Then the reception points are set to 0 per reception
    And all other settings match standard configuration

  Scenario: View current league scoring settings
    Given a league with PPR scoring configuration
    When a player views the league scoring settings
    Then all scoring categories are displayed with their point values
    And the scoring format name is displayed as "PPR"
    And the last modified date is shown

  Scenario: Prevent scoring settings changes after playoffs start
    Given a league with playoffs in progress
    When the commissioner attempts to modify scoring settings
    Then the modification is rejected with error "PLAYOFFS_IN_PROGRESS"
    And the error message explains that settings are locked during playoffs

  Scenario: Export scoring settings configuration
    Given a league with custom scoring configuration
    When the commissioner exports the scoring settings
    Then a JSON file is generated with all scoring rules
    And the file can be imported to another league

  Scenario: Import scoring settings from another league
    Given a commissioner is setting up a new league
    And a scoring configuration file exists from a previous league
    When the commissioner imports the configuration file
    Then all scoring settings are applied from the imported file
    And a confirmation shows the imported settings summary

  # ==================== LIVE SCORING ====================

  Scenario: Calculate live score during an active game
    Given player "john_doe" has a locked roster for Wild Card round
    And the Chiefs vs Dolphins game is in progress
    And john_doe has Patrick Mahomes at QB from the Chiefs
    And current game stats for Patrick Mahomes are:
      | Stat              | Value |
      | Passing Yards     | 185   |
      | Passing TDs       | 2     |
      | Interceptions     | 0     |
      | Rushing Yards     | 12    |
    When the live scoring service calculates the current score
    Then Patrick Mahomes live score is: (185 * 0.04) + (2 * 4) + (12 * 0.1) = 16.6 points
    And john_doe's total roster score includes this live calculation

  Scenario: Update live score as game progresses
    Given player "jane_doe" has Josh Allen at QB
    And the Bills vs Ravens game is in progress at halftime
    And Josh Allen's current stats are 180 passing yards, 1 TD
    When Josh Allen throws a 35-yard touchdown pass in the third quarter
    And the live scoring service polls updated stats
    Then Jane_doe's QB score increases by approximately 5.4 points
    And the score update timestamp is recorded

  Scenario: Display live vs final score indicators
    Given player "bob_player" has players from multiple games:
      | Position | Player          | Game Status  |
      | QB       | Lamar Jackson   | Final        |
      | RB       | Derrick Henry   | In Progress  |
      | WR       | Stefon Diggs    | Scheduled    |
    When bob_player views their roster scores
    Then Lamar Jackson's score shows "FINAL" indicator
    And Derrick Henry's score shows "LIVE" indicator with pulsing animation
    And Stefon Diggs's score shows "SCHEDULED" with game start time

  Scenario: Handle live scoring during simultaneous games
    Given 4 NFL playoff games are in progress
    And player "alice_player" has players in all 4 games
    When the scoring service polls all games
    Then stats from all 4 games are aggregated
    And alice_player's total score reflects all live games
    And each player's contribution is attributed to their respective game

  Scenario: Freeze live score when game ends
    Given the Chiefs vs Dolphins game status is "In Progress"
    And player "john_doe" has Chiefs players scoring 45.5 points
    When the game status changes to "Final"
    Then those player scores are marked as "FINAL"
    And no further updates are made for those roster slots
    And the final score is persisted to the database

  # ==================== SCORING CATEGORIES ====================

  Scenario: Configure passing scoring category
    Given the commissioner is configuring scoring settings
    When the commissioner sets passing scoring:
      | Stat                      | Points |
      | Passing Yards             | 0.04   |
      | Passing Touchdown         | 4      |
      | Interception Thrown       | -2     |
      | 2-Point Passing Conversion| 2      |
      | Passing Yards per Bonus   | 25     |
    Then the passing category is saved
    And QBs are scored using these rules

  Scenario: Configure rushing scoring category
    Given the commissioner is configuring scoring settings
    When the commissioner sets rushing scoring:
      | Stat                      | Points |
      | Rushing Yards             | 0.1    |
      | Rushing Touchdown         | 6      |
      | 2-Point Rushing Conversion| 2      |
      | Rushing Yards per Bonus   | 10     |
    Then the rushing category is saved
    And RBs are scored using these rules

  Scenario: Configure receiving scoring category
    Given the commissioner is configuring scoring settings
    When the commissioner sets receiving scoring:
      | Stat                      | Points |
      | Reception                 | 1.0    |
      | Receiving Yards           | 0.1    |
      | Receiving Touchdown       | 6      |
      | 2-Point Receiving Conversion | 2   |
    Then the receiving category is saved
    And WRs and TEs are scored using these rules

  Scenario: Configure kicker scoring category
    Given the commissioner is configuring scoring settings
    When the commissioner sets kicker scoring:
      | Stat                | Points |
      | Extra Point Made    | 1      |
      | Extra Point Missed  | -1     |
      | FG Made 0-19 yards  | 3      |
      | FG Made 20-29 yards | 3      |
      | FG Made 30-39 yards | 3      |
      | FG Made 40-49 yards | 4      |
      | FG Made 50+ yards   | 5      |
      | FG Missed 0-39      | -1     |
      | FG Missed 40-49     | 0      |
      | FG Missed 50+       | 0      |
    Then the kicker category is saved
    And kickers are scored using distance-based rules

  Scenario: Configure defense/special teams scoring category
    Given the commissioner is configuring scoring settings
    When the commissioner sets defense scoring:
      | Stat                    | Points |
      | Sack                    | 1      |
      | Interception            | 2      |
      | Fumble Recovery         | 2      |
      | Defensive Touchdown     | 6      |
      | Safety                  | 2      |
      | Blocked Kick            | 2      |
      | Kick Return TD          | 6      |
      | Punt Return TD          | 6      |
      | Points Allowed 0        | 10     |
      | Points Allowed 1-6      | 7      |
      | Points Allowed 7-13     | 4      |
      | Points Allowed 14-20    | 1      |
      | Points Allowed 21-27    | 0      |
      | Points Allowed 28-34    | -1     |
      | Points Allowed 35+      | -4     |
    Then the defense category is saved
    And team defenses are scored using these rules

  Scenario: Calculate combined position scoring
    Given the league uses PPR scoring
    And player "john_doe" has Saquon Barkley at RB
    And Saquon Barkley's game stats are:
      | Stat              | Value |
      | Rushing Yards     | 125   |
      | Rushing TDs       | 2     |
      | Receptions        | 5     |
      | Receiving Yards   | 45    |
      | Receiving TDs     | 0     |
    When scoring is calculated
    Then Barkley's score is: (125 * 0.1) + (2 * 6) + (5 * 1.0) + (45 * 0.1) = 34.0 points

  # ==================== PPR SCORING ====================

  Scenario: Apply full PPR scoring to receptions
    Given the league uses full PPR scoring (1.0 points per reception)
    And player "jane_doe" has Travis Kelce at TE
    And Travis Kelce's game stats are:
      | Stat              | Value |
      | Receptions        | 8     |
      | Receiving Yards   | 95    |
      | Receiving TDs     | 1     |
    When scoring is calculated
    Then Kelce's PPR score is: (8 * 1.0) + (95 * 0.1) + (1 * 6) = 23.5 points
    And the 8 receptions contribute 8.0 points to the total

  Scenario: Apply half-PPR scoring to receptions
    Given the league uses half-PPR scoring (0.5 points per reception)
    And player "bob_player" has Tyreek Hill at WR
    And Tyreek Hill's game stats are:
      | Stat              | Value |
      | Receptions        | 10    |
      | Receiving Yards   | 140   |
      | Receiving TDs     | 1     |
    When scoring is calculated
    Then Hill's half-PPR score is: (10 * 0.5) + (140 * 0.1) + (1 * 6) = 25.0 points
    And the 10 receptions contribute 5.0 points to the total

  Scenario: Apply standard (zero-PPR) scoring
    Given the league uses standard scoring (0 points per reception)
    And player "alice_player" has CeeDee Lamb at WR
    And CeeDee Lamb's game stats are:
      | Stat              | Value |
      | Receptions        | 7     |
      | Receiving Yards   | 110   |
      | Receiving TDs     | 1     |
    When scoring is calculated
    Then Lamb's standard score is: (0 * 7) + (110 * 0.1) + (1 * 6) = 17.0 points
    And the 7 receptions contribute 0 points to the total

  Scenario: Compare PPR impact on player rankings
    Given the league allows switching between PPR modes for analysis
    And a player has these stats:
      | Stat              | Value |
      | Receptions        | 12    |
      | Receiving Yards   | 80    |
      | Receiving TDs     | 0     |
    When scoring is compared across formats
    Then the scores are:
      | Format      | Score |
      | Full PPR    | 20.0  |
      | Half PPR    | 14.0  |
      | Standard    | 8.0   |
    And PPR impact is +12.0 points vs Standard

  Scenario: Apply PPR to running backs in receiving role
    Given the league uses full PPR scoring
    And player "john_doe" has Christian McCaffrey at RB
    And CMC's game stats are:
      | Stat              | Value |
      | Rushing Yards     | 85    |
      | Rushing TDs       | 1     |
      | Receptions        | 9     |
      | Receiving Yards   | 72    |
      | Receiving TDs     | 1     |
    When scoring is calculated
    Then CMC's total PPR score is: (85 * 0.1) + (1 * 6) + (9 * 1.0) + (72 * 0.1) + (1 * 6) = 38.7 points
    And the receiving component (9 rec + 72 yds + 1 TD) = 16.2 PPR points

  # ==================== BONUS SCORING ====================

  Scenario: Configure milestone bonus scoring
    Given the commissioner is configuring bonus scoring
    When the commissioner sets milestone bonuses:
      | Milestone               | Bonus Points |
      | 100+ Rushing Yards      | 3            |
      | 100+ Receiving Yards    | 3            |
      | 300+ Passing Yards      | 3            |
      | 400+ Passing Yards      | 5            |
    Then milestone bonuses are saved to league settings
    And bonuses are applied when thresholds are reached

  Scenario: Apply rushing yardage milestone bonus
    Given the league has 100+ rushing yards bonus of 3 points
    And player "jane_doe" has Derrick Henry at RB
    And Derrick Henry rushes for 142 yards and 2 TDs
    When scoring is calculated
    Then base rushing score is: (142 * 0.1) + (2 * 6) = 26.2 points
    And 100+ rushing yard bonus of 3 points is applied
    And total RB score is 29.2 points

  Scenario: Apply passing yardage milestone bonus
    Given the league has passing milestones: 300+ yards = 3 pts, 400+ yards = 5 pts
    And player "bob_player" has Patrick Mahomes at QB
    And Patrick Mahomes throws for 425 yards and 4 TDs
    When scoring is calculated
    Then base passing score is: (425 * 0.04) + (4 * 4) = 33.0 points
    And 300+ passing yard bonus of 3 points is applied
    And 400+ passing yard bonus of 5 points is applied
    And total QB score is 41.0 points

  Scenario: Configure big play bonuses
    Given the commissioner is configuring bonus scoring
    When the commissioner sets big play bonuses:
      | Play Type               | Bonus Points |
      | 40+ Yard TD             | 2            |
      | 50+ Yard TD             | 3            |
      | 40+ Yard Reception      | 1            |
      | 40+ Yard Run            | 1            |
    Then big play bonuses are saved to league settings

  Scenario: Apply big play touchdown bonus
    Given the league has 40+ yard TD bonus of 2 points
    And player "alice_player" has Tyreek Hill at WR
    And Tyreek Hill catches a 65-yard touchdown pass
    When scoring is calculated
    Then base receiving score for the play is: 1 rec + 6.5 yds + 6 TD = 13.5 points
    And 40+ yard TD bonus of 2 points is applied
    And 50+ yard TD bonus of 3 points is also applied
    And total bonus for this play is 5 points

  Scenario: No bonus when threshold not reached
    Given the league has 100+ rushing yards bonus of 3 points
    And player "john_doe" has a RB who rushes for 98 yards
    When scoring is calculated
    Then the 100+ rushing yard bonus is NOT applied
    And the RB score is 9.8 points (base only)

  Scenario: Configure TD-based bonuses
    Given the commissioner is configuring bonus scoring
    When the commissioner sets TD bonuses:
      | Milestone               | Bonus Points |
      | 3+ Passing TDs          | 3            |
      | 4+ Passing TDs          | 5            |
      | 2+ Rushing TDs          | 2            |
      | 2+ Receiving TDs        | 2            |
    Then TD bonuses are saved to league settings

  Scenario: Apply multiple TD bonus
    Given the league has 3+ passing TD bonus of 3 points
    And player "jane_doe" has Josh Allen at QB
    And Josh Allen throws 4 touchdowns
    When scoring is calculated
    Then 3+ passing TD bonus of 3 points is applied
    And 4+ passing TD bonus of 5 points is also applied
    And total TD bonuses add 8 points to base score

  # ==================== IDP SCORING ====================

  Scenario: Configure IDP (Individual Defensive Player) scoring
    Given the commissioner is enabling IDP scoring
    When the commissioner sets IDP scoring rules:
      | Stat                    | Points |
      | Solo Tackle             | 1      |
      | Assisted Tackle         | 0.5    |
      | Sack                    | 2      |
      | Interception            | 3      |
      | Forced Fumble           | 2      |
      | Fumble Recovery         | 2      |
      | Defensive TD            | 6      |
      | Pass Defended           | 1      |
      | Safety                  | 2      |
      | Tackle for Loss         | 1      |
    Then IDP scoring is enabled for the league
    And IDP roster positions become available

  Scenario: Calculate IDP linebacker score
    Given the league has IDP scoring enabled
    And player "bob_player" has T.J. Watt at LB position
    And T.J. Watt's defensive stats are:
      | Stat                | Value |
      | Solo Tackles        | 6     |
      | Assisted Tackles    | 2     |
      | Sacks               | 2.0   |
      | Forced Fumbles      | 1     |
      | Tackles for Loss    | 2     |
    When scoring is calculated
    Then Watt's IDP score is: (6 * 1) + (2 * 0.5) + (2 * 2) + (1 * 2) + (2 * 1) = 17.0 points

  Scenario: Calculate IDP defensive back score
    Given the league has IDP scoring enabled
    And player "alice_player" has Sauce Gardner at CB position
    And Sauce Gardner's defensive stats are:
      | Stat                | Value |
      | Solo Tackles        | 4     |
      | Assisted Tackles    | 1     |
      | Interceptions       | 1     |
      | Pass Defended       | 3     |
      | Defensive TD        | 1     |
    When scoring is calculated
    Then Gardner's IDP score is: (4 * 1) + (1 * 0.5) + (1 * 3) + (3 * 1) + (1 * 6) = 16.5 points

  Scenario: Calculate IDP defensive lineman score
    Given the league has IDP scoring enabled
    And player "john_doe" has Micah Parsons at DL position
    And Micah Parsons' defensive stats are:
      | Stat                | Value |
      | Solo Tackles        | 3     |
      | Sacks               | 3.0   |
      | Forced Fumbles      | 1     |
      | Tackles for Loss    | 3     |
      | QB Hits             | 4     |
    When scoring is calculated
    Then Parsons' IDP score is: (3 * 1) + (3 * 2) + (1 * 2) + (3 * 1) = 14.0 points

  Scenario: Configure IDP roster positions
    Given the commissioner is setting up IDP roster
    When the commissioner adds IDP positions:
      | Position | Count |
      | DL       | 2     |
      | LB       | 2     |
      | DB       | 2     |
      | IDP FLEX | 1     |
    Then the roster supports 7 IDP positions
    And IDP FLEX accepts any defensive player

  Scenario: IDP scoring with half sacks
    Given the league has IDP scoring with 2 points per sack
    And player "jane_doe" has a LB with 1.5 sacks
    When scoring is calculated
    Then the LB receives 3.0 points for sacks (1.5 * 2)
    And partial sacks are counted proportionally

  Scenario: League without IDP scoring
    Given the league does not have IDP scoring enabled
    When a player views roster configuration
    Then no IDP positions are available
    And team defense is the only defensive scoring option

  # ==================== SCORING CORRECTIONS ====================

  Scenario: Apply official NFL stat correction
    Given Wild Card round scoring was finalized
    And player "john_doe" had a QB score of 28.5 points
    And the NFL issues a stat correction:
      | Player          | Stat Change                      |
      | Patrick Mahomes | Passing yards: 325 -> 312        |
    When the scoring correction process runs
    Then john_doe's QB score is recalculated to 28.0 points
    And the correction is logged with timestamp and reason
    And john_doe is notified of the score change

  Scenario: Evaluate matchup impact from stat correction
    Given matchup between "jane_doe" and "bob_player" ended 145.5 to 144.2
    And jane_doe was declared the winner
    And a stat correction reduces jane_doe's score by 2.0 points
    When the correction is applied
    Then jane_doe's new score is 143.5 points
    And matchup result is re-evaluated
    And bob_player becomes the new winner with 144.2 points
    And both players are notified of the result change
    And bracket advancement is updated

  Scenario: Stat correction does not change matchup result
    Given matchup between "john_doe" and "alice_player" ended 160.5 to 142.0
    And john_doe was declared the winner by 18.5 points
    And a stat correction reduces john_doe's score by 1.5 points
    When the correction is applied
    Then john_doe's new score is 159.0 points
    And john_doe remains the matchup winner
    And the margin of victory is updated to 17.0 points
    And rankings are updated but no elimination changes occur

  Scenario: Display stat correction history
    Given multiple stat corrections have occurred in the league
    When a user views the stat correction log
    Then corrections are displayed chronologically:
      | Date       | Player          | Original | Corrected | Reason              |
      | 2025-01-12 | Patrick Mahomes | 28.5     | 28.0      | NFL stat correction |
      | 2025-01-13 | Derrick Henry   | 22.0     | 23.5      | Missed reception    |
    And each correction shows affected fantasy players

  Scenario: Commissioner manually applies scoring adjustment
    Given a data entry error affected player scores
    And the commissioner needs to apply a manual adjustment
    When the commissioner adjusts "bob_player" score by +3.0 points
    And enters reason "Data provider error for missed TD"
    Then bob_player's score is updated
    And the adjustment is logged with commissioner ID
    And the adjustment is visible in scoring history
    And audit trail is maintained

  Scenario: Stat correction window expires
    Given the stat correction window is 72 hours after round completion
    And Wild Card round completed 80 hours ago
    When an NFL stat correction is received
    Then the correction is logged but not applied
    And a notification is sent to the commissioner
    And the commissioner can manually decide to apply it

  Scenario: Bulk stat corrections for multiple players
    Given the NFL issues corrections affecting 5 players
    When the batch correction process runs
    Then all 5 player scores are recalculated
    And all affected matchups are re-evaluated
    And a single notification summarizes all changes
    And database updates are performed atomically

  # ==================== SCORING BREAKDOWN ====================

  Scenario: Display detailed scoring breakdown by position
    Given player "john_doe" has a completed roster for Wild Card
    When john_doe views their scoring breakdown
    Then the breakdown shows each position:
      | Position | Player           | Score | Stats Summary                    |
      | QB       | Patrick Mahomes  | 28.5  | 312 pass yds, 3 TD, 0 INT        |
      | RB1      | Derrick Henry    | 22.0  | 145 rush yds, 1 TD, 2 rec        |
      | RB2      | Saquon Barkley   | 18.5  | 95 rush yds, 1 TD, 3 rec         |
      | WR1      | Tyreek Hill      | 24.0  | 8 rec, 125 yds, 1 TD             |
      | WR2      | CeeDee Lamb      | 15.5  | 6 rec, 85 yds, 0 TD              |
      | TE       | Travis Kelce     | 16.0  | 7 rec, 70 yds, 1 TD              |
      | FLEX     | A.J. Brown       | 12.0  | 5 rec, 60 yds, 0 TD              |
      | K        | Harrison Butker  | 11.0  | 2 XP, 2 FG (35, 48 yds)          |
      | DEF      | SF 49ers         | 8.0   | 3 sacks, 1 INT, 14 pts allowed   |
      | TOTAL    | -                | 155.5 | -                                |

  Scenario: Display stat-by-stat scoring formula
    Given player "jane_doe" wants to understand their QB score
    And jane_doe's QB is Josh Allen with 24.8 points
    When jane_doe views the detailed QB breakdown
    Then the breakdown shows each stat contribution:
      | Stat              | Value | Points/Unit | Contribution |
      | Passing Yards     | 280   | 0.04        | 11.2         |
      | Passing TDs       | 2     | 4           | 8.0          |
      | Interceptions     | 1     | -2          | -2.0         |
      | Rushing Yards     | 42    | 0.1         | 4.2          |
      | Rushing TDs       | 0     | 6           | 0.0          |
      | 300+ Yard Bonus   | No    | 3           | 0.0          |
      | Fumbles Lost      | 0     | -2          | 0.0          |
      | 2-PT Conversions  | 1     | 2           | 2.0          |
      | SUBTOTAL          | -     | -           | 23.4         |
      | 40+ Yard TD Bonus | 1     | 2           | 2.0          |
      | TOTAL             | -     | -           | 25.4         |

  Scenario: Display scoring breakdown with bonuses highlighted
    Given the league has milestone bonuses enabled
    And player "bob_player" has a RB with 132 rushing yards and 2 TDs
    When bob_player views the RB breakdown
    Then base stats show: (132 * 0.1) + (2 * 6) = 25.2 points
    And bonuses section shows:
      | Bonus Type           | Qualified | Points |
      | 100+ Rushing Yards   | Yes       | +3.0   |
    And total shows 28.2 points
    And bonus is visually highlighted

  Scenario: Display team defense scoring breakdown
    Given player "alice_player" has the Cowboys defense
    And the Cowboys defense stats are:
      | Stat                | Value |
      | Sacks               | 4     |
      | Interceptions       | 2     |
      | Fumble Recoveries   | 1     |
      | Defensive TDs       | 0     |
      | Points Allowed      | 17    |
    When alice_player views the DEF breakdown
    Then the breakdown shows:
      | Stat              | Value | Points/Unit | Contribution |
      | Sacks             | 4     | 1           | 4.0          |
      | Interceptions     | 2     | 2           | 4.0          |
      | Fumble Recoveries | 1     | 2           | 2.0          |
      | Defensive TDs     | 0     | 6           | 0.0          |
      | Points Allowed    | 17    | (14-20 = 1) | 1.0          |
      | TOTAL             | -     | -           | 11.0         |

  Scenario: Compare weekly scoring breakdowns
    Given player "john_doe" has scores for multiple playoff rounds
    When john_doe views the weekly comparison
    Then the breakdown shows side-by-side:
      | Position | Wild Card | Divisional | Conference |
      | QB       | 28.5      | 32.0       | 26.5       |
      | RB1      | 22.0      | 18.5       | 24.0       |
      | RB2      | 18.5      | 15.0       | 19.5       |
      | WR1      | 24.0      | 28.0       | 22.0       |
      | WR2      | 15.5      | 20.0       | 18.5       |
      | TE       | 16.0      | 12.5       | 14.0       |
      | FLEX     | 12.0      | 15.5       | 16.5       |
      | K        | 11.0      | 8.0        | 9.0        |
      | DEF      | 8.0       | 12.0       | 6.0        |
      | TOTAL    | 155.5     | 161.5      | 156.0      |
    And trends are shown for each position

  Scenario: Export scoring breakdown to printable format
    Given player "jane_doe" wants to save their scoring breakdown
    When jane_doe exports the breakdown
    Then a PDF or CSV file is generated
    And the export includes all positions, stats, and calculations
    And league branding is included in the export

  # ==================== SCORING COMPARISON ====================

  Scenario: Compare scores between two players head-to-head
    Given a matchup between "john_doe" and "jane_doe"
    When either player views the comparison
    Then the head-to-head breakdown shows:
      | Position | john_doe Player | john_doe Pts | jane_doe Player | jane_doe Pts | Advantage |
      | QB       | Mahomes         | 28.5         | Allen           | 32.0         | jane_doe  |
      | RB1      | Henry           | 22.0         | Barkley         | 18.5         | john_doe  |
      | RB2      | McCaffrey       | 18.5         | Cook            | 12.0         | john_doe  |
      | WR1      | Hill            | 24.0         | Jefferson       | 28.0         | jane_doe  |
      | WR2      | Lamb            | 15.5         | Chase           | 22.5         | jane_doe  |
      | TE       | Kelce           | 16.0         | Andrews         | 10.0         | john_doe  |
      | FLEX     | Brown           | 12.0         | Diggs           | 18.0         | jane_doe  |
      | K        | Butker          | 11.0         | Tucker          | 8.0          | john_doe  |
      | DEF      | 49ers           | 8.0          | Cowboys         | 6.0          | john_doe  |
      | TOTAL    | -               | 155.5        | -               | 155.0        | john_doe  |

  Scenario: Display position-by-position advantage summary
    Given a comparison between "john_doe" and "jane_doe"
    When the advantage summary is displayed
    Then john_doe wins 5 positions
    And jane_doe wins 4 positions
    And the net point differential is shown (+0.5 for john_doe)

  Scenario: Compare player against league average
    Given player "bob_player" wants to see how they compare
    When bob_player views their league comparison
    Then each position shows:
      | Position | bob_player Score | League Avg | Difference | Percentile |
      | QB       | 32.0             | 24.5       | +7.5       | 85th       |
      | RB1      | 18.0             | 19.2       | -1.2       | 45th       |
      | RB2      | 15.5             | 16.8       | -1.3       | 42nd       |
      | TOTAL    | 148.5            | 142.0      | +6.5       | 72nd       |

  Scenario: Compare best and worst performers at each position
    Given Wild Card scoring is complete
    When a user views position leaders
    Then the comparison shows:
      | Position | Best Player    | Best Score | Worst Player   | Worst Score |
      | QB       | jane_doe       | 35.5       | player_8       | 12.0        |
      | RB       | bob_player     | 28.0       | player_12      | 4.5         |
      | WR       | alice_player   | 32.0       | player_5       | 6.0         |
    And clicking each shows their roster selection

  Scenario: Compare scoring across different rounds
    Given player "john_doe" has played 3 playoff rounds
    When john_doe views their round-by-round comparison
    Then trends are displayed:
      | Metric              | Wild Card | Divisional | Conference | Trend    |
      | Total Score         | 155.5     | 161.5      | 156.0      | Stable   |
      | QB Performance      | 28.5      | 32.0       | 26.5       | Variable |
      | Top Scorer          | WR1       | QB         | RB1        | -        |
      | Worst Position      | DEF       | K          | DEF        | -        |
    And a chart visualizes score progression

  Scenario: Compare what-if roster scenarios
    Given player "alice_player" is analyzing their roster
    And alice_player started Cooper Kupp but could have started Michael Pittman
    When alice_player runs a what-if comparison
    Then the comparison shows:
      | Scenario                | Score  | Difference |
      | Actual (Kupp)           | 148.5  | -          |
      | What-if (Pittman)       | 152.0  | +3.5       |
    And the breakdown shows where the difference occurred

  # ==================== CUSTOM SCORING RULES ====================

  Scenario: Create custom scoring stat
    Given the commissioner wants to add a unique scoring stat
    When the commissioner creates a custom stat:
      | Name                    | Points | Category  |
      | Passing First Down      | 0.5    | Passing   |
    Then the custom stat is added to the league configuration
    And the stat is available for scoring calculations
    And it appears in scoring breakdowns

  Scenario: Configure position-specific scoring multipliers
    Given the commissioner wants to emphasize certain positions
    When the commissioner sets position multipliers:
      | Position | Multiplier |
      | QB       | 1.5        |
      | TE       | 1.25       |
    Then QB scores are multiplied by 1.5
    And TE scores are multiplied by 1.25
    And other positions use default 1.0 multiplier

  Scenario: Configure negative point thresholds
    Given the commissioner wants penalties for poor performance
    When the commissioner sets negative thresholds:
      | Threshold               | Penalty |
      | Under 50 Rushing Yards  | -1      |
      | Under 50 Receiving Yards| -1      |
      | 3+ Interceptions        | -3      |
    Then poor performances incur additional penalties

  Scenario: Configure game context bonuses
    Given the commissioner wants to reward clutch performances
    When the commissioner sets game context bonuses:
      | Context                     | Bonus |
      | 4th Quarter TD              | 1     |
      | Overtime TD                 | 2     |
      | Game-Winning Score          | 3     |
    Then clutch performances receive bonus points
    And the data source must provide play-by-play context

  Scenario: Enable return yardage scoring
    Given the commissioner wants to score return yards
    When the commissioner enables return scoring:
      | Stat                | Points |
      | Kick Return Yards   | 0.05   |
      | Punt Return Yards   | 0.05   |
      | Kick Return TD      | 6      |
      | Punt Return TD      | 6      |
    Then return specialists can accumulate points
    And WRs and RBs with return duties benefit

  Scenario: Configure two-QB league scoring
    Given the league uses a superflex format
    When the commissioner configures superflex scoring:
      | Setting                     | Value         |
      | SUPERFLEX Position          | QB/RB/WR/TE   |
      | Starting QBs Allowed        | 2             |
    Then players can start 2 QBs
    And SUPERFLEX position accepts any offensive player

  Scenario: Configure tight end premium scoring
    Given the commissioner wants to boost TE value
    When the commissioner sets TE premium:
      | Setting              | Value |
      | TE Reception Bonus   | 0.5   |
    Then TEs receive 1.5 points per reception in PPR
    And TEs become more valuable relative to WRs

  Scenario: Disable specific scoring categories
    Given the commissioner wants simplified scoring
    When the commissioner disables categories:
      | Category to Disable    |
      | Kicker Scoring         |
      | Defense/ST Scoring     |
    Then kicker position is removed from rosters
    And defense position is removed from rosters
    And scoring only includes offensive players

  Scenario: Clone and modify scoring template
    Given a standard PPR scoring template exists
    When the commissioner clones the template
    And modifies:
      | Change                         |
      | Increase passing TD to 6 pts   |
      | Add 100+ yard bonus for RBs    |
    Then a new custom scoring configuration is created
    And the original template remains unchanged
    And the custom configuration is saved

  Scenario: Validate custom scoring configuration
    Given the commissioner creates a custom scoring rule
    When the configuration includes invalid values:
      | Invalid Setting                    |
      | Passing Yards: -0.5 (negative)     |
      | Rushing TD: "six" (non-numeric)    |
    Then validation errors are displayed
    And the invalid configuration is not saved
    And specific field errors are highlighted

  Scenario: Preview scoring impact before applying rules
    Given the commissioner is considering scoring changes
    When the commissioner previews the new configuration
    Then sample calculations are shown:
      | Sample Player      | Old Score | New Score | Difference |
      | Patrick Mahomes    | 28.5      | 34.5      | +6.0       |
      | Derrick Henry      | 22.0      | 25.0      | +3.0       |
    And the commissioner can accept or cancel changes
