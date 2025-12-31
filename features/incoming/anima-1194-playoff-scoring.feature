@ANIMA-1194 @backend @priority_1 @scoring
Feature: Playoff Scoring System
  As a fantasy football playoffs application
  I want to calculate scores, rank teams, manage playoff brackets, determine matchup results, and handle tiebreakers
  So that the playoff competition is fair, accurate, and engaging

  Background:
    Given a league "2025 NFL Playoffs Pool" exists
    And the league uses PPR scoring configuration
    And the league has playoff bracket format configured
    And the game has 4 weeks (Wild Card, Divisional, Conference, Super Bowl)

  # ============================================
  # SCORING CALCULATIONS
  # ============================================

  @scoring @happy-path
  Scenario: Calculate player roster score for a playoff week
    Given player "john_doe" has a locked roster for Wild Card round:
      | Position | NFL Player           | NFL Team       |
      | QB       | Patrick Mahomes      | Chiefs         |
      | RB       | Derrick Henry        | Ravens         |
      | RB       | Saquon Barkley       | Eagles         |
      | WR       | Tyreek Hill          | Dolphins       |
      | WR       | CeeDee Lamb          | Cowboys        |
      | TE       | Travis Kelce         | Chiefs         |
      | FLEX     | Cooper Kupp          | Rams           |
      | K        | Harrison Butker      | Chiefs         |
      | DEF      | San Francisco 49ers  | 49ers          |
    And the NFL Wild Card games have completed
    And player statistics are available from the data source
    When the system calculates Wild Card scoring for "john_doe"
    Then each roster position score is calculated using league scoring rules
    And the total roster score is the sum of all position scores
    And the score is persisted in the database

  @scoring @happy-path
  Scenario: Calculate aggregate team score across multiple games
    Given player "jane_doe" selected roster includes players from 3 NFL playoff games
    And the scoring configuration includes:
      | Stat                  | Points Per Unit |
      | Passing Yards         | 0.04            |
      | Rushing Yards         | 0.1             |
      | Receiving Yards       | 0.1             |
      | Receptions (PPR)      | 1.0             |
      | Passing TD            | 4               |
      | Rushing/Receiving TD  | 6               |
    When all 3 playoff games complete
    Then each player's stats are aggregated from their respective games
    And the total score reflects performance across all games
    And live scores update as games complete

  @scoring @bonus
  Scenario: Apply bonus points for milestone performances
    Given the league has milestone bonuses configured:
      | Milestone               | Bonus Points |
      | 300+ Passing Yards      | 3            |
      | 100+ Rushing Yards      | 3            |
      | 100+ Receiving Yards    | 3            |
      | 40+ Yard TD             | 2            |
    And player "john_doe" has Patrick Mahomes at QB
    And Patrick Mahomes throws for 350 yards and 3 TDs
    When scoring is calculated
    Then base passing points are: 350 * 0.04 + 3 * 4 = 26 points
    And milestone bonus of 3 points is added for 300+ passing yards
    And total QB score is 29 points

  @scoring @penalties
  Scenario: Calculate negative points for turnovers
    Given the league has turnover penalties configured:
      | Stat               | Points |
      | Interception       | -2     |
      | Fumble Lost        | -2     |
    And player "bob_player" has Josh Allen at QB
    And Josh Allen throws 250 yards, 2 TDs, but 3 interceptions
    When scoring is calculated
    Then base scoring is: (250 * 0.04) + (2 * 4) = 18 points
    And turnover penalty is: 3 * -2 = -6 points
    And total QB score is 12 points

  @scoring @kicker
  Scenario: Score kicker performance with distance-based field goals
    Given the league has kicker scoring:
      | Stat              | Points |
      | Extra Point Made  | 1      |
      | FG 0-39 yards     | 3      |
      | FG 40-49 yards    | 4      |
      | FG 50+ yards      | 5      |
    And Harrison Butker makes: 2 XP, 1 FG (35 yards), 2 FG (48 yards), 1 FG (52 yards)
    When scoring is calculated
    Then kicker score is: 2*1 + 1*3 + 2*4 + 1*5 = 18 points

  @scoring @defense
  Scenario: Score defense/special teams performance
    Given the league has defensive scoring:
      | Stat                | Points |
      | Sack                | 1      |
      | Interception        | 2      |
      | Fumble Recovery     | 2      |
      | Defensive TD        | 6      |
      | Points Allowed 0    | 10     |
      | Points Allowed 1-6  | 7      |
      | Points Allowed 7-13 | 4      |
      | Points Allowed 14-20| 1      |
      | Points Allowed 21-27| 0      |
      | Points Allowed 28+  | -4     |
    And SF 49ers defense has: 4 sacks, 2 INTs, 1 fumble recovery, 1 defensive TD
    And SF 49ers allowed 10 points
    When scoring is calculated
    Then defensive score is: 4*1 + 2*2 + 1*2 + 1*6 + 4 = 20 points

  @scoring @edge-case
  Scenario: Handle bye week scoring for inactive players
    Given player "john_doe" roster includes a player on bye
    And the player's team did not play in the Wild Card round
    When scoring is calculated for Wild Card
    Then the bye week player contributes 0 points
    And the system records "BYE" status for that roster slot

  @scoring @edge-case
  Scenario: Handle injured player with zero stats
    Given player "jane_doe" has Davante Adams at WR
    And Davante Adams was injured and recorded no statistics
    When scoring is calculated
    Then Davante Adams contributes 0 points
    And the system records "DNP" (Did Not Play) status

  @scoring @two-point-conversion
  Scenario: Score two-point conversion attempts
    Given the league has two-point conversion scoring:
      | Stat                    | Points |
      | 2PT Conversion Pass     | 2      |
      | 2PT Conversion Rush     | 2      |
      | 2PT Conversion Receive  | 2      |
    And player "john_doe" has QB who throws a successful 2PT conversion
    And the receiver is also on john_doe's roster
    When scoring is calculated
    Then the QB receives 2 points for the conversion pass
    And the receiver receives 2 points for the conversion reception

  @scoring @fractional
  Scenario: Calculate fractional scoring with precision
    Given the league uses fractional scoring
    And player "jane_doe" has a RB with 87 rushing yards
    When scoring is calculated at 0.1 points per yard
    Then the RB score is 8.7 points (not rounded to 9)
    And total score maintains 2 decimal precision

  # ============================================
  # TEAM RANKINGS
  # ============================================

  @rankings @happy-path
  Scenario: Rank players by weekly score
    Given Wild Card round scoring is complete
    And the following players have scores:
      | Player      | Wild Card Score |
      | john_doe    | 145.5           |
      | jane_doe    | 152.3           |
      | bob_player  | 138.7           |
      | alice_player| 152.3           |
    When the system generates Wild Card rankings
    Then players are ranked by score descending:
      | Rank | Player       | Score |
      | 1    | jane_doe     | 152.3 |
      | 1    | alice_player | 152.3 |
      | 3    | john_doe     | 145.5 |
      | 4    | bob_player   | 138.7 |

  @rankings @cumulative
  Scenario: Rank players by cumulative score across playoff rounds
    Given the following scores exist:
      | Player      | Wild Card | Divisional | Conference | Total  |
      | john_doe    | 145.5     | 128.0      | 165.2      | 438.7  |
      | jane_doe    | 152.3     | 142.5      | 138.8      | 433.6  |
      | bob_player  | 138.7     | 175.0      | 120.5      | 434.2  |
    When the system generates cumulative rankings
    Then rankings reflect total playoff points:
      | Rank | Player     | Total  |
      | 1    | john_doe   | 438.7  |
      | 2    | bob_player | 434.2  |
      | 3    | jane_doe   | 433.6  |

  @rankings @live
  Scenario: Update rankings in real-time during live games
    Given it is Divisional round and games are in progress
    And current scores are:
      | Player      | Current Score |
      | john_doe    | 85.5          |
      | jane_doe    | 92.3          |
    When jane_doe's players score additional points
    And jane_doe's score increases to 98.5
    Then the live rankings update immediately
    And jane_doe remains ranked 1st
    And ranking timestamp is updated

  @rankings @position-based
  Scenario: Calculate position-based rankings
    Given all Wild Card scoring is complete
    When the system calculates position-based statistics
    Then rankings show:
      | Metric              | Leader        | Score  |
      | Top QB Scorer       | john_doe      | 32.5   |
      | Top RB Scorer       | jane_doe      | 28.0   |
      | Top WR Scorer       | bob_player    | 35.2   |
      | Top Overall Roster  | alice_player  | 155.0  |

  @rankings @movement
  Scenario: Display ranking movement between rounds
    Given player "john_doe" was ranked 5th after Wild Card
    And player "john_doe" is ranked 2nd after Divisional
    When john_doe views their standings
    Then the display shows rank improved by 3 positions
    And historical ranking trend is visible

  @rankings @percentile
  Scenario: Calculate percentile rankings for large leagues
    Given a league has 100 players
    And player "john_doe" is ranked 8th overall
    When john_doe views their standings
    Then percentile ranking shows "Top 8%"
    And comparison to median score is displayed

  # ============================================
  # PLAYOFF BRACKET PROGRESSION
  # ============================================

  @bracket @initialization
  Scenario: Initialize 4-round playoff bracket structure
    Given a league with 10 players
    When the playoff bracket is initialized
    Then the bracket has 4 rounds:
      | Round      | Week | Games |
      | Wild Card  | 1    | 6     |
      | Divisional | 2    | 4     |
      | Conference | 3    | 2     |
      | Super Bowl | 4    | 1     |
    And all players start in the bracket
    And initial seeding is based on prior regular season standings or random

  @bracket @advancement
  Scenario: Advance winners to next playoff round
    Given Wild Card round is complete
    And the bracket has 8 matchups
    And winners are determined for each matchup
    When the system processes round advancement
    Then winning players advance to Divisional round
    And losing players are marked as eliminated
    And the Divisional bracket is populated with winners

  @bracket @elimination
  Scenario: Handle elimination after playoff loss
    Given player "bob_player" loses in Wild Card round
    When bracket progression is processed
    Then "bob_player" is marked as "ELIMINATED"
    And "bob_player" cannot make roster selections for future rounds
    And "bob_player" can still view standings and game progress
    And elimination reason is recorded

  @bracket @history
  Scenario: Track bracket advancement through all rounds
    Given player "john_doe" history:
      | Round      | Result   | Score | Opponent     |
      | Wild Card  | WIN      | 145.5 | bob_player   |
      | Divisional | WIN      | 172.3 | alice_player |
      | Conference | PENDING  | -     | jane_doe     |
    When john_doe views their bracket history
    Then each round shows matchup details
    And current round shows active matchup
    And future rounds show potential opponents

  @bracket @visualization
  Scenario: Display complete playoff bracket visualization
    Given the league has progressed through 2 rounds
    When any user views the bracket
    Then the bracket shows:
      | All player matchups for completed rounds |
      | Results and scores for each matchup      |
      | Current round matchups in progress       |
      | Future round matchup slots (TBD)         |
      | Eliminated players grayed out            |

  @bracket @seeding
  Scenario: Generate bracket from seeding
    Given 8 players qualify for playoffs with seeds:
      | Seed | Player       | Regular Season Score |
      | 1    | john_doe     | 1250.5               |
      | 2    | jane_doe     | 1185.3               |
      | 3    | bob_player   | 1142.8               |
      | 4    | alice_player | 1095.2               |
      | 5    | player5      | 1050.0               |
      | 6    | player6      | 1025.5               |
      | 7    | player7      | 998.2                |
      | 8    | player8      | 975.0                |
    When the playoff bracket is generated
    Then Round 1 matchups are:
      | Matchup | Higher Seed | Lower Seed |
      | 1       | john_doe (1)| player8 (8)|
      | 2       | jane_doe (2)| player7 (7)|
      | 3       | bob_player (3)| player6 (6)|
      | 4       | alice_player (4)| player5 (5)|

  @bracket @bye-week
  Scenario: Handle byes for top seeds in bracket
    Given a 12-player league with 4 playoff spots for byes
    And seeds 1-4 receive first-round byes
    When the playoff bracket is generated
    Then seeds 1-4 are placed directly in Divisional round
    And seeds 5-12 compete in Wild Card round
    And bye-week players have "BYE" recorded for Wild Card

  @bracket @reseeding
  Scenario: Reseed bracket after each round
    Given the league uses reseeding after each round
    And Wild Card winners are determined
    When Divisional matchups are set
    Then the highest remaining seed plays the lowest remaining seed
    And matchups preserve competitive balance

  # ============================================
  # MATCHUP RESULTS
  # ============================================

  @matchup @winner
  Scenario: Determine matchup winner by higher score
    Given a Wild Card matchup between "john_doe" and "bob_player"
    And Wild Card games have completed
    And scores are:
      | Player     | Score |
      | john_doe   | 145.5 |
      | bob_player | 138.7 |
    When the matchup result is determined
    Then "john_doe" is declared the matchup winner
    And "bob_player" is declared the matchup loser
    And the margin of victory is 6.8 points

  @matchup @record
  Scenario: Record matchup results with detailed breakdown
    Given matchup between "jane_doe" and "alice_player"
    When jane_doe wins with score 152.3 to 148.5
    Then the matchup record includes:
      | winner          | jane_doe   |
      | loser           | alice_player |
      | winner_score    | 152.3      |
      | loser_score     | 148.5      |
      | margin          | 3.8        |
      | round           | Wild Card  |
      | date_completed  | <timestamp>|

  @matchup @comparison
  Scenario: Display head-to-head matchup comparison
    Given an active matchup between "john_doe" and "jane_doe"
    When either player views the matchup
    Then the display shows:
      | Position | john_doe Player | john_doe Points | jane_doe Player | jane_doe Points |
      | QB       | Mahomes         | 28.5           | Allen            | 32.0           |
      | RB       | Henry           | 15.2           | Barkley          | 22.5           |
      | RB       | McCaffrey       | 24.8           | Cook             | 12.0           |
      | WR       | Hill            | 18.5           | Jefferson        | 25.5           |
      | WR       | Lamb            | 22.0           | Chase            | 28.0           |
      | TE       | Kelce           | 16.5           | Andrews          | 12.5           |
      | FLEX     | Kupp            | 14.0           | Diggs            | 18.2           |
      | K        | Butker          | 12.0           | Tucker           | 9.0            |
      | DEF      | 49ers           | 8.0            | Cowboys          | 6.0            |
      | TOTAL    | -               | 159.5          | -                | 165.7          |

  @matchup @live
  Scenario: Handle matchup in progress with live scores
    Given a Divisional matchup is in progress
    And 2 of 4 playoff games have completed
    When scores are updated
    Then live scores show:
      | john_doe partial score: 85.5 (2 players remaining) |
      | jane_doe partial score: 92.3 (1 player remaining)  |
    And matchup status is "IN_PROGRESS"
    And estimated completion time is shown

  @matchup @parallel
  Scenario: Process multiple matchups simultaneously
    Given 4 Wild Card matchups are configured
    And all Wild Card games have completed
    When matchup processing runs
    Then all 4 matchups are evaluated in parallel
    And all results are recorded atomically
    And bracket is updated with all winners

  @matchup @upset
  Scenario: Record upset matchup (lower seed defeats higher seed)
    Given matchup between seed 1 "john_doe" and seed 8 "player8"
    And scores are:
      | Player   | Score |
      | john_doe | 118.5 |
      | player8  | 142.3 |
    When the matchup result is determined
    Then "player8" wins the matchup
    And the matchup is flagged as an "UPSET"
    And upset statistics are recorded for the league

  @matchup @close-game
  Scenario: Flag close matchup for highlight
    Given matchup between "john_doe" and "jane_doe"
    And final scores differ by less than 5 points
    When the matchup result is determined
    Then the matchup is flagged as a "CLOSE_GAME"
    And the matchup is featured in league highlights

  # ============================================
  # TIEBREAKER HANDLING
  # ============================================

  @tiebreaker @exact-tie
  Scenario: Apply tiebreaker for exact score tie
    Given a matchup between "john_doe" and "jane_doe"
    And both players score exactly 145.5 points
    When the matchup result is determined
    Then the primary tiebreaker is applied: higher single position score
    And if "john_doe" QB scored 32.5 and "jane_doe" QB scored 28.0
    Then "john_doe" wins the tiebreaker
    And tiebreaker method is recorded in matchup result

  @tiebreaker @cascade
  Scenario: Apply cascading tiebreakers
    Given a tied matchup at 145.5 points each
    And the tiebreaker cascade is:
      | Priority | Tiebreaker Method                    |
      | 1        | Highest single position score        |
      | 2        | Second highest position score        |
      | 3        | Most total touchdowns               |
      | 4        | Fewer turnovers                     |
      | 5        | Higher seed (original playoff seed)  |
    When primary tiebreaker results in a tie
    Then the system applies the next tiebreaker
    And continues until a winner is determined

  @tiebreaker @ranking
  Scenario: Apply tiebreaker for rankings with same total score
    Given 3 players have identical cumulative scores of 285.0:
      | Player       | Wild Card | Divisional | Total |
      | john_doe     | 145.0     | 140.0      | 285.0 |
      | jane_doe     | 150.0     | 135.0      | 285.0 |
      | bob_player   | 142.0     | 143.0      | 285.0 |
    When rankings are calculated with tiebreaker: "highest single week score"
    Then rankings are:
      | Rank | Player     | Total | Tiebreaker Score |
      | 1    | jane_doe   | 285.0 | 150.0 (WC)       |
      | 2    | john_doe   | 285.0 | 145.0 (WC)       |
      | 3    | bob_player | 285.0 | 143.0 (Div)      |

  @tiebreaker @custom
  Scenario: Configure league-specific tiebreaker rules
    Given an admin is configuring the league
    When the admin sets tiebreaker rules:
      | Priority | Rule                                  |
      | 1        | Head-to-head record                   |
      | 2        | Best single week playoff score        |
      | 3        | Most playoff touchdowns scored        |
      | 4        | Original draft position               |
    Then the league saves custom tiebreaker configuration
    And tiebreaker rules are displayed in league settings

  @tiebreaker @co-winners
  Scenario: Handle unbreakable tie with co-winners
    Given the championship matchup ends in a tie at 178.5 points
    And all tiebreaker criteria are exhausted with no winner
    When the system processes the championship result
    Then both players are declared co-champions
    And the matchup result records "TIE - CO-CHAMPIONS"
    And notifications are sent to both winners

  @tiebreaker @seeding
  Scenario: Apply tiebreaker to determine playoff seeding
    Given regular season ends with tied records:
      | Player     | W-L  | Points For |
      | john_doe   | 10-3 | 1450.5     |
      | jane_doe   | 10-3 | 1450.5     |
    When playoff seeding is determined
    Then tiebreaker is applied: head-to-head record
    And if head-to-head is split (1-1), apply: points against
    And final seeding order is determined

  @tiebreaker @display
  Scenario: Display tiebreaker explanation to users
    Given matchup ended with tiebreaker applied
    And "john_doe" won via "most touchdowns" tiebreaker
    When users view the matchup result
    Then the display shows:
      | Final Score                   | 145.5 - 145.5 (TIE) |
      | Tiebreaker Applied            | Most Touchdowns     |
      | john_doe Touchdowns           | 8                   |
      | jane_doe Touchdowns           | 6                   |
      | Winner                        | john_doe            |

  # ============================================
  # ELIMINATION AND SURVIVAL
  # ============================================

  @elimination @tracking
  Scenario: Track player elimination through playoff rounds
    Given the playoff started with 16 players
    And Wild Card eliminates 8 players
    And Divisional eliminates 4 players
    And Conference eliminates 2 players
    When viewing elimination summary
    Then the display shows:
      | Round      | Players Remaining | Players Eliminated |
      | Start      | 16                | 0                  |
      | Wild Card  | 8                 | 8                  |
      | Divisional | 4                 | 4                  |
      | Conference | 2                 | 2                  |
      | Super Bowl | 1                 | 1                  |

  @elimination @restriction
  Scenario: Eliminated player cannot make future selections
    Given player "bob_player" was eliminated in Wild Card
    When "bob_player" attempts to submit Divisional roster
    Then the request is rejected with error "PLAYER_ELIMINATED"
    And the error message is "You were eliminated in Wild Card round"

  @elimination @statistics
  Scenario: Calculate survival rate statistics
    Given 32 players started the playoffs
    And player "john_doe" reached the Super Bowl
    When john_doe views their survival statistics
    Then the display shows:
      | Rounds Survived    | 4 of 4             |
      | Survival Rate      | 100%               |
      | Percentile         | Top 3.1%           |
      | Total Players      | 32                 |
      | Players Remaining  | 2                  |

  @elimination @notification
  Scenario: Send elimination notification to player
    Given player "bob_player" loses their Wild Card matchup
    When the matchup result is finalized
    Then "bob_player" receives an elimination notification
    And the notification includes their final ranking
    And the notification thanks them for participating

  # ============================================
  # SCORING EDGE CASES
  # ============================================

  @edge-case @stat-correction
  Scenario: Handle stat correction after scoring is finalized
    Given Wild Card scoring was finalized with scores:
      | Player   | Score |
      | john_doe | 145.5 |
    And NFL issues a stat correction affecting john_doe's QB
    And the correction changes passing yards from 300 to 285
    When stat correction processing runs
    Then john_doe's score is recalculated to 144.9 points
    And matchup results are re-evaluated
    And affected rankings are updated
    And correction audit log is created

  @edge-case @game-cancellation
  Scenario: Handle incomplete game due to cancellation
    Given a playoff game is cancelled mid-game
    And partial stats exist for affected players
    When scoring is calculated
    Then partial stats are counted for the cancelled game
    And the system marks affected roster slots as "PARTIAL"
    And admin can choose to void or count partial scores

  @edge-case @overtime
  Scenario: Score overtime performance
    Given a playoff game goes to overtime
    And additional stats are accumulated in OT
    When scoring is calculated
    Then all overtime statistics are included
    And there is no separate OT scoring multiplier
    And total game stats include regulation + overtime

  @edge-case @trade
  Scenario: Handle player traded mid-playoffs
    Given player "john_doe" has DeAndre Hopkins on roster
    And DeAndre Hopkins is traded between Wild Card and Divisional
    When scoring is calculated for Divisional
    Then Hopkins stats are counted for his new team
    And roster eligibility is maintained through the round

  @edge-case @weather-delay
  Scenario: Handle game delayed due to weather
    Given a playoff game is delayed by 2 hours due to weather
    And some players have games completing before the delay
    When the delayed game eventually completes
    Then all scores are calculated accurately
    And rankings update when all games finish
    And delay status is shown during the interruption

  @edge-case @negative-score
  Scenario: Handle roster with negative total score
    Given player "john_doe" has a poor-performing roster
    And the roster accumulates more penalties than points
    When scoring is calculated
    Then the total score can be negative
    And rankings still order correctly with negative scores
    And matchup comparison handles negative scores

  @edge-case @empty-roster
  Scenario: Handle player with incomplete roster
    Given player "john_doe" failed to fill all roster positions
    And 2 roster slots are empty
    When scoring is calculated
    Then empty slots contribute 0 points
    And the system records "EMPTY" status for unfilled slots
    And a warning is displayed about incomplete roster

  # ============================================
  # SCORING AUDIT AND TRANSPARENCY
  # ============================================

  @audit @trail
  Scenario: Generate detailed scoring audit trail
    Given scoring has been calculated for "john_doe" in Wild Card
    When an audit report is requested
    Then the report includes:
      | Player                | Stats Source | Stats Values      | Points | Formula Applied  |
      | Patrick Mahomes (QB)  | NFL API      | 325 pass yds, 3 TD| 25.0   | PPR-QB-Standard  |
      | Derrick Henry (RB)    | NFL API      | 120 rush yds, 1 TD| 18.0   | PPR-RB-Standard  |
    And the audit includes timestamps for each calculation
    And the audit includes data source version

  @audit @adjustment
  Scenario: Allow admin to manually adjust score with reason
    Given an admin needs to adjust "john_doe" score due to data error
    When the admin applies a +2.5 point adjustment with reason "Stat correction for missed catch"
    Then john_doe's total is updated
    And the adjustment is logged with admin ID, timestamp, and reason
    And the adjustment is visible in scoring history

  @audit @transparency
  Scenario: Display scoring formula transparency
    Given player "jane_doe" wants to understand their score
    When jane_doe views their scoring breakdown
    Then each position shows:
      | Base stats and their point values          |
      | Applied bonuses with qualifying conditions |
      | Applied penalties with causes              |
      | Formula used for calculation               |
      | Total points for position                  |

  @audit @dispute
  Scenario: Handle scoring dispute from player
    Given player "john_doe" believes their score is incorrect
    When john_doe submits a scoring dispute
    Then the dispute is logged with player's explanation
    And an admin is notified to review
    And the player receives confirmation of submission
    And resolution is tracked until closed

  # ============================================
  # PERFORMANCE AND RELIABILITY
  # ============================================

  @performance @concurrent
  Scenario: Handle concurrent score updates during live games
    Given multiple NFL games are in progress simultaneously
    And score updates arrive every 10 seconds
    When the system processes updates concurrently
    Then all player scores are updated without race conditions
    And rankings remain consistent
    And no updates are lost

  @performance @large-league
  Scenario: Scale scoring calculations for large leagues
    Given a league has 500 players
    And each player has a 9-position roster
    When Wild Card scoring is calculated for all players
    Then all 4500 roster positions are scored efficiently
    And processing completes within acceptable time limits
    And results are cached for quick retrieval

  @reliability @retry
  Scenario: Retry failed score calculation
    Given the NFL data API temporarily fails during scoring
    When scoring calculation encounters the failure
    Then the system retries with exponential backoff
    And partial results are preserved
    And the system logs the failure for monitoring
    And scoring resumes when API recovers

  @reliability @data-integrity
  Scenario: Maintain data integrity during system restart
    Given scoring is in progress when the system restarts
    When the system recovers
    Then incomplete calculations are identified
    And scoring resumes from the last checkpoint
    And no duplicate scores are recorded
    And data consistency is verified
