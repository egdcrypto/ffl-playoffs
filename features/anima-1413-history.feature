@backend @priority_2 @history
Feature: History Management System
  As a fantasy football playoffs application
  I want to track, display, search, and export historical data across all aspects of the game
  So that users can review past performance, analyze trends, and maintain comprehensive records

  Background:
    Given a league "2025 NFL Playoffs Pool" exists
    And the league has completed multiple seasons
    And historical data is available from previous seasons

  # ==================== HISTORY OVERVIEW ====================

  Scenario: Display history dashboard with summary statistics
    Given player "john_doe" is authenticated
    And john_doe has participated in 3 seasons
    When john_doe navigates to the history dashboard
    Then the dashboard displays:
      | Metric                    | Value          |
      | Total Seasons Played      | 3              |
      | Overall Win-Loss Record   | 28-14          |
      | Championships Won         | 1              |
      | Playoff Appearances       | 3              |
      | All-Time Points Scored    | 4,250.5        |
      | Best Single Week Score    | 185.3          |
      | Career High Finish        | 1st (2024)     |
    And recent activity timeline is displayed

  Scenario: View league history summary
    Given the league has been active for 5 seasons
    When any user views league history
    Then the league history displays:
      | Season | Champion       | Runner-Up     | Total Players | Avg Score |
      | 2024   | john_doe       | jane_doe      | 12            | 145.2     |
      | 2023   | bob_player     | john_doe      | 10            | 138.5     |
      | 2022   | jane_doe       | alice_player  | 10            | 142.8     |
      | 2021   | alice_player   | bob_player    | 8             | 135.0     |
      | 2020   | john_doe       | bob_player    | 8             | 128.5     |
    And league growth metrics are shown

  Scenario: View team history for a specific player
    Given player "john_doe" has history spanning 4 seasons
    When viewing john_doe's team history
    Then the history shows:
      | Season | Final Standing | W-L Record | Total Points | Playoff Result    |
      | 2024   | 1st            | 12-2       | 1,520.5      | Champion          |
      | 2023   | 2nd            | 10-4       | 1,385.0      | Runner-Up         |
      | 2022   | 5th            | 7-7        | 1,180.3      | First Round Exit  |
      | 2021   | 3rd            | 9-5        | 1,165.2      | Semifinals        |
    And career statistics summary is displayed

  Scenario: View player history for NFL players
    Given NFL player "Patrick Mahomes" has been rostered in the league
    When viewing Patrick Mahomes' history in this league
    Then the history shows:
      | Season | Times Rostered | Avg Points/Week | Total Points | Best Week Owner |
      | 2024   | 15             | 24.5            | 98.0         | john_doe        |
      | 2023   | 12             | 22.8            | 91.2         | jane_doe        |
      | 2022   | 10             | 26.2            | 104.8        | bob_player      |
    And ownership trends are displayed

  Scenario: View history timeline with major events
    Given the league has recorded significant events
    When viewing the history timeline
    Then events are displayed chronologically:
      | Date       | Event Type      | Description                                    |
      | 2024-01-28 | Championship    | john_doe defeats jane_doe 178.5-165.2         |
      | 2024-01-21 | Record Broken   | john_doe sets new single-week record: 185.3   |
      | 2024-01-14 | Upset           | Seed 8 defeats Seed 1 in Wild Card            |
      | 2024-01-07 | Season Start    | 2024 Playoffs begin with 12 players           |
    And events can be filtered by type

  # ==================== SEASON HISTORY ====================

  Scenario: View detailed past season records
    Given season 2024 is complete
    When viewing the 2024 season history
    Then detailed records show:
      | Category          | Leader         | Value    |
      | Most Points       | john_doe       | 1,520.5  |
      | Highest Avg       | john_doe       | 108.6    |
      | Best Week         | jane_doe       | 182.5    |
      | Most Wins         | john_doe       | 12       |
      | Longest Streak    | bob_player     | 6 wins   |
    And weekly breakdowns are available

  Scenario: View season champions history
    Given the league has crowned champions in past seasons
    When viewing the championship history
    Then the champions list shows:
      | Season | Champion       | Championship Score | Opponent     | Margin |
      | 2024   | john_doe       | 178.5              | jane_doe     | 13.3   |
      | 2023   | bob_player     | 165.2              | john_doe     | 8.5    |
      | 2022   | jane_doe       | 172.0              | alice_player | 22.8   |
    And repeat champions are highlighted
    And closest championship games are noted

  Scenario: View historical season standings
    Given multiple seasons are complete
    When viewing season 2023 standings
    Then final standings show:
      | Rank | Player       | W-L  | Points For | Points Against | Streak |
      | 1    | bob_player   | 11-3 | 1,425.0    | 1,185.5        | W4     |
      | 2    | john_doe     | 10-4 | 1,385.0    | 1,220.0        | W2     |
      | 3    | jane_doe     | 9-5  | 1,350.5    | 1,280.3        | L1     |
      | 4    | alice_player | 8-6  | 1,295.0    | 1,310.5        | W1     |
    And tiebreaker information is included

  Scenario: View historical season statistics
    Given season 2023 statistics are available
    When viewing detailed 2023 stats
    Then position statistics show:
      | Position | Top Scorer     | Avg Points | Total Points Scored |
      | QB       | john_doe       | 28.5       | 3,420.0             |
      | RB       | jane_doe       | 22.0       | 5,280.0             |
      | WR       | bob_player     | 18.5       | 4,440.0             |
      | TE       | alice_player   | 12.8       | 1,536.0             |
      | K        | john_doe       | 9.5        | 1,140.0             |
      | DEF      | jane_doe       | 8.2        | 984.0               |
    And week-by-week trends are available

  Scenario: Compare seasons side by side
    Given seasons 2023 and 2024 are complete
    When comparing seasons 2023 and 2024
    Then comparison shows:
      | Metric              | 2023    | 2024    | Change    |
      | League Average      | 138.5   | 145.2   | +4.8%     |
      | Total Players       | 10      | 12      | +2        |
      | Highest Score       | 175.0   | 185.3   | +5.9%     |
      | Closest Matchup     | 0.5 pts | 0.3 pts | -0.2      |
      | Total Touchdowns    | 245     | 278     | +13.5%    |

  # ==================== MATCHUP HISTORY ====================

  Scenario: View all past matchups
    Given player "john_doe" has played multiple matchups
    When viewing john_doe's matchup history
    Then all matchups are displayed:
      | Date       | Round      | Opponent     | Score   | Result | Margin |
      | 2024-01-28 | Super Bowl | jane_doe     | 178.5   | WIN    | +13.3  |
      | 2024-01-21 | Conference | bob_player   | 165.2   | WIN    | +22.0  |
      | 2024-01-14 | Divisional | alice_player | 152.8   | WIN    | +8.5   |
      | 2024-01-07 | Wild Card  | player5      | 145.0   | WIN    | +18.2  |
    And matchups can be filtered by season, round, or result

  Scenario: View head-to-head history between two players
    Given "john_doe" and "jane_doe" have faced each other multiple times
    When viewing head-to-head history between john_doe and jane_doe
    Then the rivalry record shows:
      | Overall Record | john_doe leads 4-2               |
      | Avg Score Diff | john_doe +5.8 points             |
      | Last Meeting   | 2024 Super Bowl - john_doe WIN   |
      | Playoff Record | john_doe 2-1                     |
    And individual matchup details are listed:
      | Season | Round      | Winner   | Score            |
      | 2024   | Super Bowl | john_doe | 178.5 - 165.2    |
      | 2023   | Conference | jane_doe | 158.5 - 152.0    |
      | 2023   | Wild Card  | john_doe | 145.2 - 138.5    |

  Scenario: View matchup records and statistics
    Given the league has recorded all historical matchups
    When viewing league matchup records
    Then records show:
      | Record                    | Holder(s)           | Value      | Date       |
      | Highest Combined Score    | john_doe vs jane_doe| 343.7      | 2024-01-28 |
      | Largest Victory Margin    | bob_player          | 58.2       | 2023-01-14 |
      | Closest Matchup           | jane_doe vs alice   | 0.3 pts    | 2024-01-14 |
      | Most Overtime Tiebreakers | john_doe            | 3          | Various    |
      | Most Consecutive Wins     | john_doe            | 8          | 2024       |

  Scenario: View historical scores for a specific matchup
    Given matchup history exists for 2024 Super Bowl
    When viewing detailed matchup history
    Then detailed breakdown shows:
      | Category              | john_doe    | jane_doe    |
      | Final Score           | 178.5       | 165.2       |
      | QB Points             | 32.5        | 28.0        |
      | RB Points             | 48.2        | 42.5        |
      | WR Points             | 55.8        | 52.0        |
      | TE Points             | 18.5        | 22.2        |
      | K Points              | 12.0        | 10.5        |
      | DEF Points            | 11.5        | 10.0        |
      | Bench Points (Unused) | 45.2        | 52.8        |

  Scenario: View rivalry history and trends
    Given "john_doe" and "bob_player" have a long rivalry
    When viewing their rivalry history
    Then rivalry analysis shows:
      | Metric                  | Value                              |
      | Total Meetings          | 8                                  |
      | Series Leader           | john_doe (5-3)                     |
      | Win Streak              | john_doe - 3 current               |
      | Average Margin          | 8.5 points                         |
      | Playoff Meetings        | 2 (split 1-1)                      |
      | Most Common Outcome     | john_doe wins by 5-10 pts (3 times)|
    And trend chart shows historical performance

  # ==================== TRANSACTION HISTORY ====================

  Scenario: View trade history
    Given trades have been executed in the league
    When viewing trade history
    Then all trades are displayed:
      | Date       | Team A     | Gave              | Team B       | Received          |
      | 2024-01-05 | john_doe   | Pick 1.03         | jane_doe     | Patrick Mahomes   |
      | 2023-12-15 | bob_player | Derrick Henry     | alice_player | Travis Kelce      |
    And trade values and analysis are shown
    And trades can be filtered by player, team, or date

  Scenario: View waiver wire history
    Given waiver transactions have occurred
    When viewing waiver history
    Then waiver activity shows:
      | Date       | Player          | Action    | Team         | FAAB Spent |
      | 2024-01-10 | Jahmyr Gibbs    | Claimed   | john_doe     | $25        |
      | 2024-01-10 | Tank Dell       | Claimed   | jane_doe     | $15        |
      | 2024-01-09 | Romeo Doubs     | Dropped   | bob_player   | -          |
    And waiver priority changes are logged

  Scenario: View add/drop history
    Given roster changes have been made
    When viewing add/drop history
    Then roster moves show:
      | Date       | Team       | Added           | Dropped         | Reason          |
      | 2024-01-12 | john_doe   | Isaiah Pacheco  | Khalil Herbert  | Injury Swap     |
      | 2024-01-11 | jane_doe   | Tank Dell       | -               | Free Agent Add  |
      | 2024-01-10 | bob_player | -               | Romeo Doubs     | Roster Cut      |
    And moves can be filtered by team, date, or transaction type

  Scenario: View complete transaction log
    Given all transactions are recorded
    When viewing the transaction log for season 2024
    Then all transactions are displayed chronologically:
      | Timestamp           | Type        | Team(s)      | Details                          |
      | 2024-01-12 14:35:22 | Add/Drop    | john_doe     | Add Pacheco, Drop Herbert        |
      | 2024-01-10 10:00:00 | Waiver      | john_doe     | Claimed Gibbs ($25)              |
      | 2024-01-05 09:15:30 | Trade       | john_doe     | Traded pick for Mahomes          |
    And transactions can be searched and filtered

  Scenario: View roster moves summary
    Given player "john_doe" has made multiple roster moves
    When viewing john_doe's roster move summary
    Then summary statistics show:
      | Metric                    | Value  |
      | Total Transactions        | 24     |
      | Trades Made               | 3      |
      | Waiver Claims             | 8      |
      | Free Agent Adds           | 10     |
      | Players Dropped           | 12     |
      | FAAB Spent                | $85    |
      | FAAB Remaining            | $15    |
      | Most Added Position       | WR (6) |
    And activity trends by week are shown

  # ==================== DRAFT HISTORY ====================

  Scenario: View past draft results
    Given the 2024 draft is complete
    When viewing 2024 draft history
    Then draft results show:
      | Round | Pick | Team         | Player Selected    | Position |
      | 1     | 1    | john_doe     | Christian McCaffrey| RB       |
      | 1     | 2    | jane_doe     | Tyreek Hill        | WR       |
      | 1     | 3    | bob_player   | CeeDee Lamb        | WR       |
      | 1     | 4    | alice_player | Travis Kelce       | TE       |
    And complete draft board is viewable

  Scenario: View individual draft picks history
    Given player "john_doe" has drafted in multiple seasons
    When viewing john_doe's draft history
    Then all draft picks show:
      | Season | Round | Pick | Player Selected     | Position | End of Season Value |
      | 2024   | 1     | 1    | Christian McCaffrey | RB       | Top 5 RB            |
      | 2024   | 2     | 12   | Mark Andrews        | TE       | Top 3 TE            |
      | 2023   | 1     | 3    | Justin Jefferson    | WR       | Top 3 WR            |
    And draft grade over time is displayed

  Scenario: View draft grades history
    Given draft analysis has been performed
    When viewing draft grades for season 2024
    Then grades show:
      | Team         | Grade | Best Pick                    | Worst Pick              |
      | john_doe     | A-    | CMC at 1.01 (Value +15)      | K at Round 8 (Reach)    |
      | jane_doe     | B+    | Tyreek at 1.02 (Value +10)   | DEF at Round 7 (Early)  |
      | bob_player   | B     | Lamb at 1.03 (Value +8)      | Backup QB Round 6       |
      | alice_player | A     | Kelce at 1.04 (Value +12)    | None significant        |
    And methodology for grading is explained

  Scenario: View keeper history
    Given the league uses keeper rules
    When viewing keeper history
    Then keeper selections show:
      | Season | Team         | Keeper              | Round Cost | Years Kept |
      | 2024   | john_doe     | Patrick Mahomes     | 4          | 2          |
      | 2024   | jane_doe     | Josh Allen          | 5          | 1          |
      | 2023   | john_doe     | Patrick Mahomes     | 6          | 1          |
      | 2023   | bob_player   | Travis Kelce        | 3          | 3          |
    And keeper value analysis is shown

  Scenario: Compare draft strategies across seasons
    Given multiple drafts are complete
    When comparing draft strategies
    Then analysis shows:
      | Team         | Avg RB Pick | Avg WR Pick | Early TE% | Value Over Avg |
      | john_doe     | Round 1.5   | Round 2.2   | 35%       | +8.5           |
      | jane_doe     | Round 2.0   | Round 1.3   | 20%       | +5.2           |
      | bob_player   | Round 1.2   | Round 2.5   | 15%       | +3.8           |
    And successful strategies are highlighted

  # ==================== PLAYOFF HISTORY ====================

  Scenario: View all playoff results
    Given playoff brackets are recorded for all seasons
    When viewing playoff results history
    Then playoff summaries show:
      | Season | Playoff Teams | Champion   | Runner-Up  | Third Place  |
      | 2024   | 8             | john_doe   | jane_doe   | bob_player   |
      | 2023   | 6             | bob_player | john_doe   | alice_player |
      | 2022   | 6             | jane_doe   | alice_player | john_doe   |
    And bracket visualization is available for each season

  Scenario: View championship history
    Given multiple championships have been played
    When viewing championship game history
    Then championship details show:
      | Season | Champion   | Score  | Runner-Up    | Score  | MVP Performance       |
      | 2024   | john_doe   | 178.5  | jane_doe     | 165.2  | Mahomes 35.5 pts      |
      | 2023   | bob_player | 165.2  | john_doe     | 156.7  | Kelce 28.0 pts        |
      | 2022   | jane_doe   | 172.0  | alice_player | 149.2  | Jefferson 32.5 pts    |
    And championship game highlights are noted

  Scenario: View historical playoff brackets
    Given the 2024 playoff bracket is complete
    When viewing the 2024 playoff bracket history
    Then the bracket shows all rounds:
      | Round      | Matchup                      | Result                    |
      | Wild Card  | (1) john_doe vs (8) player8  | john_doe 145.0 - 126.8    |
      | Wild Card  | (2) jane_doe vs (7) player7  | jane_doe 152.3 - 138.5    |
      | Divisional | (1) john_doe vs (4) alice    | john_doe 152.8 - 144.3    |
      | Conference | (1) john_doe vs (3) bob      | john_doe 165.2 - 143.2    |
      | Super Bowl | (1) john_doe vs (2) jane     | john_doe 178.5 - 165.2    |
    And bracket can be viewed in graphical format

  Scenario: View playoff performances history
    Given player "john_doe" has playoff history
    When viewing john_doe's playoff performance history
    Then playoff stats show:
      | Season | Seed | Result      | Playoff Avg | Best Round   | Best Score |
      | 2024   | 1    | Champion    | 160.4       | Super Bowl   | 178.5      |
      | 2023   | 2    | Runner-Up   | 152.3       | Divisional   | 168.0      |
      | 2022   | 4    | Semifinals  | 138.5       | Wild Card    | 145.2      |
    And career playoff statistics are summarized

  Scenario: View postseason records
    Given playoff records are tracked
    When viewing postseason records
    Then records show:
      | Record                      | Holder       | Value    | Season |
      | Most Playoff Wins           | john_doe     | 12       | Career |
      | Most Championships          | john_doe     | 2        | Career |
      | Highest Playoff Score       | john_doe     | 185.3    | 2024   |
      | Best Playoff Avg (Min 4 G)  | jane_doe     | 162.5    | 2024   |
      | Most Consecutive Appearances| bob_player   | 5        | Career |
      | Most Upsets                 | player8      | 3        | Career |

  # ==================== RECORD HISTORY ====================

  Scenario: View all-time league records
    Given the league has tracked records since inception
    When viewing all-time records
    Then records are displayed:
      | Category                    | Record Holder  | Value    | Date Set   |
      | Highest Single Week Score   | john_doe       | 185.3    | 2024-01-21 |
      | Lowest Winning Score        | alice_player   | 98.5     | 2022-01-14 |
      | Most Points in a Season     | john_doe       | 1,520.5  | 2024       |
      | Longest Win Streak          | bob_player     | 9        | 2023       |
      | Most Transactions           | jane_doe       | 45       | 2023       |
      | Highest Draft Pick Value    | john_doe       | +25.0    | 2024       |

  Scenario: View league records with context
    Given records have historical context
    When viewing detailed league records
    Then each record shows:
      | Record               | Current Holder | Value  | Previous Holder | Previous Value | Improvement |
      | Single Week High     | john_doe       | 185.3  | jane_doe        | 175.0          | +10.3       |
      | Season Points        | john_doe       | 1,520.5| bob_player      | 1,425.0        | +95.5       |
    And record progression history is available

  Scenario: View team-specific records
    Given player "john_doe" wants to see their records
    When viewing john_doe's team records
    Then personal records show:
      | Record                  | Value    | When Set   | League Rank |
      | Best Single Week        | 185.3    | 2024-01-21 | 1st         |
      | Best Season Total       | 1,520.5  | 2024       | 1st         |
      | Best Playoff Score      | 178.5    | 2024-01-28 | 1st         |
      | Longest Win Streak      | 8        | 2024       | 2nd         |
      | Best Draft Grade        | A-       | 2024       | 3rd         |
    And comparison to league averages is shown

  Scenario: View player-specific records for NFL players
    Given NFL player records are tracked
    When viewing Patrick Mahomes' records in the league
    Then records show:
      | Record                  | Value  | Owner      | Date       |
      | Best Single Game        | 42.5   | john_doe   | 2024-01-21 |
      | Best Playoff Game       | 38.0   | jane_doe   | 2023-01-28 |
      | Most Times Rostered     | 45     | -          | All-time   |
      | Highest Season Avg      | 28.5   | john_doe   | 2024       |

  Scenario: View record breakers and near-misses
    Given records are closely tracked
    When viewing record breaker history
    Then record events show:
      | Date       | Record                | New Holder | New Value | Previous | By      |
      | 2024-01-21 | Single Week High      | john_doe   | 185.3     | 175.0    | +10.3   |
      | 2024-01-28 | Championship Score    | john_doe   | 178.5     | 172.0    | +6.5    |
    And near-miss attempts are shown:
      | Date       | Record            | Attempt By | Attempt | Record | Diff   |
      | 2024-01-14 | Single Week High  | jane_doe   | 182.5   | 185.3  | -2.8   |

  # ==================== STATS HISTORY ====================

  Scenario: View historical statistics overview
    Given comprehensive stats are tracked
    When viewing historical stats
    Then stats summary shows:
      | Metric                    | All-Time | 2024    | 2023    | Trend    |
      | League Avg Score          | 140.5    | 145.2   | 138.5   | +4.8%    |
      | Total Points Scored       | 52,450   | 18,200  | 16,550  | Growing  |
      | Avg Margin of Victory     | 12.5     | 11.8    | 13.2    | Tighter  |
      | Upsets (Lower Seed Wins)  | 35%      | 38%     | 32%     | Increasing|

  Scenario: View career stats for a player
    Given player "john_doe" has multi-season history
    When viewing john_doe's career stats
    Then career statistics show:
      | Category                | Value      | Rank     |
      | Total Games Played      | 42         | 1st      |
      | Total Wins              | 28         | 1st      |
      | Total Points            | 4,250.5    | 1st      |
      | Career Avg Score        | 145.2      | 1st      |
      | Championships           | 2          | 1st      |
      | Playoff Games Played    | 12         | 1st      |
      | Playoff Wins            | 10         | 1st      |

  Scenario: View season-by-season stats comparison
    Given player has multiple seasons of data
    When viewing season-by-season comparison for john_doe
    Then season breakdown shows:
      | Season | Games | Wins | Losses | Points  | Avg    | Best Week | Playoff |
      | 2024   | 14    | 12   | 2      | 1,520.5 | 108.6  | 185.3     | Champ   |
      | 2023   | 14    | 10   | 4      | 1,385.0 | 98.9   | 168.0     | 2nd     |
      | 2022   | 14    | 7    | 7      | 1,180.3 | 84.3   | 145.2     | Semis   |
    And growth trends are visualized

  Scenario: View stat trends over time
    Given historical data spans multiple seasons
    When viewing scoring trends
    Then trend analysis shows:
      | Metric              | 2022    | 2023    | 2024    | Trend Direction |
      | QB Scoring Avg      | 22.5    | 24.0    | 26.5    | Increasing      |
      | RB Scoring Avg      | 18.0    | 17.5    | 16.8    | Decreasing      |
      | WR Scoring Avg      | 14.5    | 15.2    | 16.0    | Increasing      |
      | TE Scoring Avg      | 10.0    | 11.5    | 12.5    | Increasing      |
    And visualizations show trend lines

  Scenario: Track milestone achievements
    Given milestones are defined and tracked
    When viewing milestone history
    Then milestones achieved show:
      | Player       | Milestone                      | Date       | Value    |
      | john_doe     | 1000 Career Points             | 2022-01-15 | 1,005.2  |
      | john_doe     | 20 Career Wins                 | 2023-01-21 | 20       |
      | jane_doe     | First Championship             | 2022-01-29 | 172.0    |
      | bob_player   | 5 Playoff Appearances          | 2024-01-07 | 5        |
    And upcoming milestone projections are shown

  Scenario: View positional scoring history
    Given position stats are tracked over time
    When viewing positional history
    Then position trends show:
      | Position | 2022 Avg | 2023 Avg | 2024 Avg | Top Scorer (2024)   |
      | QB       | 22.5     | 24.0     | 26.5     | john_doe (28.5)     |
      | RB1      | 18.0     | 17.5     | 16.8     | jane_doe (19.2)     |
      | RB2      | 12.5     | 12.0     | 11.5     | bob_player (13.0)   |
      | WR1      | 16.5     | 17.0     | 18.5     | alice_player (20.0) |
      | WR2      | 12.0     | 12.5     | 13.2     | john_doe (14.5)     |
      | TE       | 10.0     | 11.5     | 12.5     | bob_player (15.0)   |
      | FLEX     | 11.0     | 11.5     | 12.0     | jane_doe (13.5)     |
      | K        | 8.5      | 8.8      | 9.0      | john_doe (9.5)      |
      | DEF      | 7.0      | 7.5      | 8.0      | jane_doe (8.5)      |

  # ==================== HISTORY SEARCH ====================

  Scenario: Search history by keyword
    Given comprehensive history is available
    When searching history for "Patrick Mahomes"
    Then search results show:
      | Type        | Date       | Description                              |
      | Draft       | 2024-01-01 | john_doe drafted Patrick Mahomes Rd 4    |
      | Trade       | 2024-01-05 | jane_doe traded for Patrick Mahomes      |
      | Score       | 2024-01-21 | Mahomes scores 35.5 pts for john_doe     |
      | Record      | 2024-01-21 | Mahomes best single game: 42.5 pts       |
    And results can be further filtered

  Scenario: Filter history by year
    Given history spans multiple years
    When filtering history to 2023
    Then only 2023 results are displayed
    And the filter shows:
      | Available Years | Count    |
      | 2024            | 1,250    |
      | 2023            | 1,100    |
      | 2022            | 950      |
      | All Time        | 3,300    |

  Scenario: Filter history by team
    Given all team histories are available
    When filtering history to "john_doe"
    Then only john_doe's history is displayed
    And results include:
      | Type          | Count |
      | Matchups      | 42    |
      | Transactions  | 24    |
      | Draft Picks   | 36    |
      | Records       | 8     |
      | Milestones    | 5     |

  Scenario: Filter history by type
    Given various history types exist
    When filtering by type "trades"
    Then only trade history is shown:
      | Date       | Parties            | Summary                      |
      | 2024-01-05 | john_doe, jane_doe | Pick for Patrick Mahomes     |
      | 2023-12-15 | bob_player, alice  | Derrick Henry for Travis Kelce|
    And count shows "Showing 15 trades"

  Scenario: Perform advanced history search
    Given the search supports advanced queries
    When performing advanced search with:
      | Field       | Operator       | Value           |
      | Year        | equals         | 2024            |
      | Type        | in             | matchup, trade  |
      | Player      | contains       | john_doe        |
      | Score       | greater_than   | 150             |
    Then results are filtered to match all criteria
    And result count and pagination are shown
    And search can be saved for future use

  Scenario: Search with autocomplete suggestions
    Given the search supports autocomplete
    When typing "Pat" in the search box
    Then suggestions show:
      | Suggestion          | Category     |
      | Patrick Mahomes     | NFL Player   |
      | Pat Freiermuth      | NFL Player   |
      | PAT (Point After)   | Scoring Type |
    And selecting a suggestion executes the search

  # ==================== HISTORY EXPORT ====================

  Scenario: Export history to CSV format
    Given player "john_doe" wants to export their history
    When exporting john_doe's matchup history as CSV
    Then a CSV file is generated with:
      | Column Headers: Date, Round, Opponent, Score, Result, Margin |
      | Data rows for each matchup                                    |
      | Proper formatting and escaping                                |
    And the file is available for download

  Scenario: Export history to PDF format
    Given league history needs to be exported
    When exporting 2024 season history as PDF
    Then a PDF document is generated with:
      | Cover page with league name and season                        |
      | Table of contents                                             |
      | Final standings with formatting                               |
      | Playoff bracket visualization                                 |
      | Records and achievements                                      |
      | Statistical summaries with charts                             |
    And the document is printer-friendly

  Scenario: Download complete records
    Given all records are available
    When downloading complete record book
    Then the export includes:
      | All-time records with context                                 |
      | Season-by-season record holders                               |
      | Record progression history                                    |
      | Near-miss attempts                                            |
    And format options include CSV, PDF, and JSON

  Scenario: Print history report
    Given a printable report is needed
    When generating print-friendly history
    Then the print layout includes:
      | Optimized for standard paper sizes                            |
      | Black and white friendly design                               |
      | Page numbers and headers                                      |
      | Proper page breaks between sections                           |
    And print preview is available

  Scenario: Share history via link
    Given player wants to share their history
    When john_doe creates a shareable history link
    Then a unique URL is generated
    And the link provides read-only access to:
      | john_doe's career statistics                                  |
      | Matchup history                                               |
      | Records and achievements                                      |
    And link can be set to expire after a specified time
    And link can be revoked by the owner

  Scenario: Generate comprehensive history report
    Given detailed reporting is available
    When generating a comprehensive history report for 2024
    Then the report includes:
      | Section            | Contents                                   |
      | Executive Summary  | Season highlights and key statistics       |
      | Standings          | Final standings with tiebreaker details    |
      | Playoffs           | Complete bracket and round-by-round results|
      | Records            | New records set during the season          |
      | Awards             | MVP, most improved, biggest upset, etc.    |
      | Statistics         | Detailed stats with charts and analysis    |
      | Transaction Log    | Complete transaction history               |
    And the report can be customized before export

  Scenario: Export history in machine-readable format
    Given API access is available
    When exporting history as JSON
    Then the JSON output includes:
      | Properly structured data hierarchy                            |
      | All requested data fields                                     |
      | Timestamps in ISO 8601 format                                 |
      | Pagination metadata if applicable                             |
    And the data can be imported into external tools

  Scenario: Schedule recurring history exports
    Given automated exports are needed
    When setting up scheduled export:
      | Frequency  | weekly                           |
      | Format     | CSV                              |
      | Content    | matchup results, standings       |
      | Delivery   | email to john_doe@example.com    |
    Then exports are automatically generated on schedule
    And delivery confirmations are logged
    And schedule can be modified or cancelled

  # ==================== HISTORY PERMISSIONS AND PRIVACY ====================

  Scenario: Respect privacy settings in history display
    Given player "bob_player" has set history to private
    When "john_doe" tries to view bob_player's detailed history
    Then only public information is shown:
      | bob_player's public profile                                   |
      | Head-to-head record with john_doe                             |
      | League standings participation                                |
    And private information is hidden:
      | Detailed transaction history                                  |
      | Draft strategy analysis                                       |
      | Personal statistics breakdown                                 |

  Scenario: Admin can view all history
    Given user is a league admin
    When admin views any player's history
    Then full history is accessible
    And admin actions are logged for audit purposes
    And sensitive information is marked appropriately

  # ==================== HISTORY DATA INTEGRITY ====================

  Scenario: Handle missing historical data gracefully
    Given some historical data is incomplete
    When viewing history with gaps
    Then available data is displayed
    And missing data shows "Data unavailable" placeholders
    And data completeness indicator shows percentage available

  Scenario: Verify historical data accuracy
    Given history has been recorded
    When viewing historical matchup results
    Then all scores match recorded game results
    And calculated statistics match source data
    And any discrepancies are flagged for review

  Scenario: Archive and preserve long-term history
    Given the league has 10+ seasons of history
    When accessing archived history
    Then all historical data remains accessible
    And performance is optimized for large datasets
    And data integrity is maintained through archival
