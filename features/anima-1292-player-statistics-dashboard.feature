@frontend @backend @priority_1 @analytics @dashboard
Feature: Player Statistics Dashboard
  As a fantasy football playoffs participant
  I want to view comprehensive NFL player statistics and analytics
  So that I can make informed roster decisions and track player performance throughout the playoffs

  Background:
    Given the NFL playoffs are in progress
    And player statistics data is available from the data source
    And the user is authenticated in the fantasy football playoffs application

  # ==================== SEASON STATS DISPLAY ====================

  Scenario: Display comprehensive season statistics for a player
    Given the user navigates to the player statistics dashboard
    When the user selects player "Patrick Mahomes"
    Then the dashboard displays season totals:
      | Category           | Value  |
      | Passing Yards      | 4,183  |
      | Passing TDs        | 26     |
      | Interceptions      | 14     |
      | Completion %       | 67.2%  |
      | QBR                | 84.5   |
      | Games Played       | 17     |
      | Fantasy Points     | 302.5  |
      | Fantasy PPG        | 17.8   |

  Scenario: Display running back season statistics
    Given the user is viewing the player statistics dashboard
    When the user selects player "Derrick Henry"
    Then the dashboard displays RB-specific statistics:
      | Category           | Value  |
      | Rushing Yards      | 1,921  |
      | Rushing TDs        | 16     |
      | Yards Per Carry    | 5.4    |
      | Receptions         | 31     |
      | Receiving Yards    | 280    |
      | Receiving TDs      | 1      |
      | Touches            | 395    |
      | Fumbles            | 2      |

  Scenario: Display wide receiver season statistics
    Given the user is viewing the player statistics dashboard
    When the user selects player "Ja'Marr Chase"
    Then the dashboard displays WR-specific statistics:
      | Category           | Value  |
      | Receptions         | 117    |
      | Targets            | 156    |
      | Receiving Yards    | 1,708  |
      | Receiving TDs      | 17     |
      | Yards Per Catch    | 14.6   |
      | Catch Rate         | 75.0%  |
      | 100+ Yard Games    | 8      |
      | Longest Reception  | 72     |

  Scenario: Display tight end season statistics
    Given the user is viewing the player statistics dashboard
    When the user selects player "Travis Kelce"
    Then the dashboard displays TE-specific statistics:
      | Category           | Value |
      | Receptions         | 97    |
      | Targets            | 136   |
      | Receiving Yards    | 823   |
      | Receiving TDs      | 3     |
      | Yards After Catch  | 285   |
      | Red Zone Targets   | 18    |

  Scenario: Display kicker season statistics
    Given the user is viewing the player statistics dashboard
    When the user selects player "Harrison Butker"
    Then the dashboard displays K-specific statistics:
      | Category           | Value |
      | Field Goals Made   | 25    |
      | Field Goals Att    | 28    |
      | FG Percentage      | 89.3% |
      | Extra Points Made  | 45    |
      | Extra Points Att   | 46    |
      | Long FG            | 57    |
      | FG 50+ Made        | 6     |

  Scenario: Display defense/special teams statistics
    Given the user is viewing the player statistics dashboard
    When the user selects "San Francisco 49ers" defense
    Then the dashboard displays DST-specific statistics:
      | Category           | Value |
      | Sacks              | 48    |
      | Interceptions      | 18    |
      | Fumbles Recovered  | 12    |
      | Defensive TDs      | 4     |
      | Points Allowed/Gm  | 17.5  |
      | Yards Allowed/Gm   | 285   |
      | Pass TDs Allowed   | 18    |
      | Rush TDs Allowed   | 8     |

  # ==================== WEEKLY BREAKDOWNS ====================

  Scenario: Display weekly performance breakdown
    Given the user is viewing player "Patrick Mahomes" statistics
    When the user selects "Weekly Breakdown" view
    Then a week-by-week table is displayed:
      | Week | Opponent | Pass Yds | Pass TD | INT | Pts  | Result |
      | 1    | @DET     | 282      | 2       | 0   | 21.3 | W      |
      | 2    | CIN      | 315      | 3       | 1   | 23.5 | W      |
      | 3    | @ATL     | 248      | 1       | 2   | 12.8 | L      |
      | 4    | BYE      | -        | -       | -   | -    | -      |
      | 5    | LV       | 306      | 2       | 0   | 20.2 | W      |

  Scenario: View weekly snap count breakdown
    Given the user is viewing player "Saquon Barkley" statistics
    When the user views the weekly breakdown
    Then snap count data is included:
      | Week | Snaps | Snap % | Touches | Opp Share |
      | 1    | 58    | 85%    | 24      | 78%       |
      | 2    | 62    | 92%    | 28      | 82%       |
      | 3    | 55    | 80%    | 22      | 75%       |

  Scenario: Filter weekly breakdown by date range
    Given the user is viewing weekly breakdown for "Tyreek Hill"
    When the user filters by "Last 4 Weeks"
    Then only the last 4 weeks of data are displayed
    And summary averages are recalculated for the filtered period

  Scenario: Compare home vs away performance
    Given the user is viewing player "Josh Allen" statistics
    When the user selects "Home/Away Split" view
    Then performance is broken down:
      | Location | Games | Pass Yds/G | TDs/G | Fantasy PPG |
      | Home     | 9     | 285.5      | 2.3   | 22.5        |
      | Away     | 8     | 258.2      | 1.8   | 18.2        |

  Scenario: View red zone weekly breakdown
    Given the user is viewing player "Travis Kelce" statistics
    When the user selects "Red Zone Performance" filter
    Then red zone-specific weekly stats are shown:
      | Week | RZ Targets | RZ Catches | RZ TDs | RZ Opp % |
      | 1    | 3          | 2          | 1      | 25%      |
      | 2    | 4          | 3          | 2      | 33%      |
      | 3    | 2          | 1          | 0      | 17%      |

  # ==================== PERFORMANCE TRENDS ====================

  Scenario: Display rolling average performance trend
    Given the user is viewing player "Ja'Marr Chase" statistics
    When the user selects "Performance Trends" view
    Then a 4-week rolling average chart is displayed
    And trend direction indicators are shown:
      | Metric          | Current | 4-Week Avg | Trend |
      | Targets/Game    | 11.5    | 10.2       | UP    |
      | Yards/Game      | 108.5   | 95.3       | UP    |
      | Fantasy PPG     | 22.5    | 19.8       | UP    |

  Scenario: Visualize performance trend over season
    Given the user is viewing player performance trends
    When viewing "Derrick Henry" rushing yards trend
    Then a line chart displays weekly rushing yards
    And the chart highlights:
      | Season high week and yardage    |
      | Season low week and yardage     |
      | Average line across all weeks   |
      | Recent trend arrow              |

  Scenario: Identify hot and cold streaks
    Given the user is viewing trend analysis
    When analyzing player "CeeDee Lamb"
    Then streak information is displayed:
      | Streak Type | Weeks    | Avg Fantasy Pts |
      | Hot Streak  | 8-11     | 26.5            |
      | Cold Streak | 3-5      | 12.2            |
      | Current     | Week 17+ | 18.5 (neutral)  |

  Scenario: Display consistency metrics
    Given the user is viewing player "Amon-Ra St. Brown" trends
    When viewing consistency analysis
    Then floor and ceiling metrics are shown:
      | Metric          | Value |
      | Floor (lowest)  | 8.5   |
      | Ceiling (high)  | 32.5  |
      | Median          | 16.2  |
      | Std Deviation   | 6.8   |
      | Consistency Rk  | 12    |

  Scenario: Compare pre and post bye week performance
    Given player "Patrick Mahomes" had a bye in week 6
    When the user views bye week split analysis
    Then performance comparison is displayed:
      | Period         | Games | Fantasy PPG | QBR  |
      | Pre-Bye        | 5     | 18.5        | 82.3 |
      | Post-Bye       | 11    | 22.8        | 88.5 |
      | Difference     | -     | +4.3        | +6.2 |

  # ==================== FANTASY PROJECTIONS ====================

  Scenario: Display projected fantasy points for upcoming matchup
    Given the user is viewing player "Saquon Barkley" statistics
    And the Divisional playoff round is upcoming
    When viewing the projections tab
    Then projected fantasy points are displayed:
      | Metric              | Projection |
      | Projected Points    | 22.5       |
      | Projection Range    | 15.0-30.5  |
      | Confidence Level    | 75%        |
      | Expert Consensus    | 21.8       |

  Scenario: View projection factors and methodology
    Given the user is viewing projections for "Josh Allen"
    When the user expands "Projection Details"
    Then projection factors are explained:
      | Factor              | Impact     | Description                    |
      | Matchup Grade       | A-         | vs weak secondary              |
      | Recent Form         | Strong     | 25+ pts in 3 of last 4 weeks   |
      | Weather             | Neutral    | Dome stadium                   |
      | Injury Status       | Healthy    | Full participant in practice   |
      | Home/Away           | +2.5       | Home field advantage           |

  Scenario: Compare player projection to season average
    Given the user is viewing projections
    When comparing "Travis Kelce" projection to season average
    Then comparison is displayed:
      | Metric          | Season Avg | Projection | Diff    |
      | Fantasy Points  | 12.5       | 15.8       | +3.3    |
      | Targets         | 8.0        | 10.0       | +2.0    |
      | Receptions      | 5.7        | 7.5        | +1.8    |

  Scenario: Display projection accuracy history
    Given the system tracks projection accuracy
    When the user views projection reliability for "Derrick Henry"
    Then historical accuracy is shown:
      | Metric                    | Value |
      | Season Accuracy (RMSE)    | 4.2   |
      | Within 5 pts (%)          | 72%   |
      | Overproject Tendency      | -1.5  |
      | Most Accurate Week        | 8     |

  Scenario: View rest-of-season projections
    Given the user is planning playoff roster
    When viewing ROS projections for RBs
    Then ranking projections are displayed:
      | Rank | Player          | Proj Total | Proj PPG | Uncertainty |
      | 1    | Saquon Barkley  | 85.0       | 21.3     | Low         |
      | 2    | Derrick Henry   | 78.5       | 19.6     | Low         |
      | 3    | Josh Jacobs     | 72.0       | 18.0     | Medium      |

  # ==================== POSITIONAL RANKINGS ====================

  Scenario: Display positional fantasy rankings
    Given the user is on the player statistics dashboard
    When the user selects "Positional Rankings" for QBs
    Then quarterbacks are ranked by fantasy performance:
      | Rank | Player          | Team   | Fantasy Pts | PPG   |
      | 1    | Lamar Jackson   | BAL    | 385.5       | 22.7  |
      | 2    | Josh Allen      | BUF    | 365.2       | 21.5  |
      | 3    | Jalen Hurts     | PHI    | 342.8       | 20.2  |
      | 4    | Patrick Mahomes | KC     | 302.5       | 17.8  |

  Scenario: View positional rankings with multiple scoring formats
    Given the user is viewing RB rankings
    When the user toggles between scoring formats
    Then rankings update per format:
      | Format    | Rank 1          | Rank 2          | Rank 3       |
      | PPR       | Saquon Barkley  | Derrick Henry   | Bijan Robinson |
      | Half-PPR  | Saquon Barkley  | Derrick Henry   | Jahmyr Gibbs  |
      | Standard  | Derrick Henry   | Saquon Barkley  | Josh Jacobs   |

  Scenario: Filter positional rankings by playoff teams only
    Given the user is viewing WR rankings
    When the user enables "Playoff Teams Only" filter
    Then only players from playoff teams are displayed
    And non-playoff team players are hidden

  Scenario: View positional rankings by specific stat category
    Given the user is viewing TE rankings
    When the user sorts by "Red Zone Targets"
    Then rankings reorder by red zone targets:
      | Rank | Player        | Team | RZ Targets | RZ TDs |
      | 1    | Travis Kelce  | KC   | 25         | 8      |
      | 2    | T.J. Hockenson| MIN  | 22         | 6      |
      | 3    | Mark Andrews  | BAL  | 20         | 9      |

  Scenario: Display ranking trends over time
    Given the user is viewing positional rankings
    When viewing ranking movement for "Ja'Marr Chase"
    Then ranking history is displayed:
      | Week | Rank | Change |
      | 17   | 1    | -      |
      | 16   | 2    | +1     |
      | 15   | 1    | -      |
      | 14   | 3    | -2     |

  # ==================== MATCHUP ANALYSIS ====================

  Scenario: Display upcoming matchup grade
    Given the user is viewing player "Josh Allen"
    And the Bills are playing the Ravens in the Divisional round
    When viewing matchup analysis
    Then matchup information is displayed:
      | Category               | Value     |
      | Opponent               | Ravens    |
      | Matchup Grade          | B+        |
      | Opp Fantasy Pts Allow  | 18.5/game |
      | Opp Position Rank      | 14th      |
      | Vegas Implied Points   | 27.5      |

  Scenario: View opponent defensive statistics
    Given the user is analyzing matchup for "Derrick Henry"
    When viewing "Opponent Defense Breakdown"
    Then defensive stats are displayed:
      | Metric                 | Value  | League Rank |
      | Rush Yards Allowed/Gm  | 125.5  | 24th        |
      | Rush TDs Allowed       | 15     | 28th        |
      | Yards Per Carry Allow  | 4.8    | 22nd        |
      | Stacked Boxes %        | 22%    | 30th        |

  Scenario: Display historical performance vs opponent
    Given the user is viewing matchup for "Patrick Mahomes"
    When viewing historical data vs the opponent
    Then past performance is shown:
      | Date       | Opponent | Result | Pass Yds | TDs | Fantasy |
      | Nov 2024   | Ravens   | W      | 312      | 3   | 25.8    |
      | Sep 2023   | Ravens   | L      | 285      | 1   | 16.5    |
      | Jan 2023   | Ravens   | W      | 295      | 2   | 22.0    |
      | Career Avg | Ravens   | 2-1    | 297.3    | 2.0 | 21.4    |

  Scenario: View matchup comparison with similar players
    Given the user is analyzing "Tyreek Hill" matchup
    When viewing how similar WRs performed vs the opponent
    Then comparison data is shown:
      | Similar WR       | Fantasy Pts | Targets | Yards |
      | Davante Adams    | 22.5        | 12      | 105   |
      | Justin Jefferson | 18.2        | 10      | 85    |
      | CeeDee Lamb      | 25.8        | 14      | 125   |
      | Average          | 22.2        | 12      | 105   |

  Scenario: Display weather impact on matchup
    Given the user is viewing outdoor stadium matchup
    When weather conditions are available
    Then weather impact is displayed:
      | Factor         | Forecast  | Impact      |
      | Temperature    | 28F       | -2.5 pts    |
      | Wind Speed     | 15 mph    | -1.5 pts    |
      | Precipitation  | Snow      | -3.0 pts    |
      | Overall Impact | Negative  | -7.0 pts    |

  # ==================== INJURY TRACKING ====================

  Scenario: Display current injury status
    Given the user is viewing player "Cooper Kupp"
    When viewing injury information
    Then current status is displayed:
      | Field          | Value                  |
      | Status         | Questionable           |
      | Injury         | Ankle                  |
      | Practice Wed   | Limited                |
      | Practice Thu   | Limited                |
      | Practice Fri   | Full                   |
      | Game Status    | Expected to Play       |
      | Last Updated   | 2025-01-10 4:30 PM EST |

  Scenario: View injury history for a player
    Given the user is viewing injury-prone player analysis
    When viewing "Christian McCaffrey" injury history
    Then historical injuries are displayed:
      | Season | Injury    | Games Missed | Recovery Time |
      | 2024   | Calf      | 8            | 9 weeks       |
      | 2023   | Achilles  | 0            | Game-time     |
      | 2022   | Knee      | 2            | 2 weeks       |
      | Career | -         | 24           | -             |

  Scenario: Display injury impact on projections
    Given player "Davante Adams" has a hamstring injury
    When viewing projections with injury context
    Then injury-adjusted projection is shown:
      | Metric                    | Value |
      | Healthy Projection        | 18.5  |
      | Injury-Adjusted Proj      | 14.2  |
      | Injury Impact             | -4.3  |
      | Snap Count Estimate       | 75%   |
      | Projection Confidence     | Low   |

  Scenario: Track practice participation trends
    Given the user is monitoring "Travis Kelce" status
    When viewing practice participation
    Then weekly practice trends are shown:
      | Week | Wednesday | Thursday | Friday | Game Status |
      | 17   | DNP       | Limited  | Full   | Played      |
      | 18   | Veteran   | Veteran  | Full   | Played      |
      | WC   | DNP       | Limited  | LP     | Questionable|

  Scenario: Display injury reserve and return timeline
    Given player "Nick Chubb" is on injured reserve
    When viewing IR player status
    Then return information is displayed:
      | Field               | Value            |
      | Status              | IR               |
      | Injury              | Knee (ACL)       |
      | Date Placed on IR   | Oct 15, 2024     |
      | Eligible to Return  | Dec 15, 2024     |
      | Expected Return     | Week 1 Playoffs  |
      | Practice Window     | Opened           |

  # ==================== SNAP COUNTS ====================

  Scenario: Display weekly snap count data
    Given the user is viewing player "Jahmyr Gibbs" statistics
    When selecting the "Snap Counts" tab
    Then weekly snap data is displayed:
      | Week | Total Snaps | Snap % | Rush Snaps | Pass Snaps | Red Zone |
      | 17   | 42          | 65%    | 18         | 24         | 8        |
      | 16   | 48          | 72%    | 22         | 26         | 10       |
      | 15   | 35          | 54%    | 15         | 20         | 5        |

  Scenario: Compare snap share with backfield teammates
    Given the user is viewing "Jahmyr Gibbs" snap counts
    When viewing backfield comparison
    Then teammate snap share is shown:
      | Player        | Snap % | Rush Att % | Target % | RZ Opp % |
      | Jahmyr Gibbs  | 52%    | 45%        | 65%      | 55%      |
      | David Montgomery| 48%  | 55%        | 35%      | 45%      |

  Scenario: Track snap count trends over time
    Given the user is analyzing snap trends
    When viewing "Nico Collins" snap percentage trend
    Then a chart displays weekly snap percentages
    And trend analysis shows:
      | Metric             | Value  |
      | 4-Week Average     | 88%    |
      | Season Average     | 85%    |
      | Trend Direction    | Stable |
      | Injury Impact Weeks| 2-3    |

  Scenario: Display route participation for receivers
    Given the user is viewing WR "Ja'Marr Chase" snaps
    When viewing route participation
    Then route data is shown:
      | Route Type | Run % | Target Rate | Completion % |
      | Go/Fade    | 15%   | 25%         | 55%          |
      | Out        | 20%   | 18%         | 72%          |
      | Slant      | 18%   | 22%         | 85%          |
      | Corner     | 12%   | 28%         | 62%          |
      | Dig/In     | 22%   | 20%         | 78%          |

  Scenario: View red zone snap percentage
    Given the user is evaluating goal-line backs
    When viewing red zone snaps for RBs
    Then red zone usage is displayed:
      | Player          | RZ Snaps | RZ Snap % | Goal Line % | RZ TDs |
      | Derrick Henry   | 85       | 92%       | 95%         | 12     |
      | Saquon Barkley  | 78       | 88%       | 75%         | 10     |
      | Josh Jacobs     | 65       | 85%       | 90%         | 8      |

  # ==================== TARGET SHARE METRICS ====================

  Scenario: Display target share for receivers
    Given the user is viewing "Tyreek Hill" statistics
    When viewing target share metrics
    Then target data is displayed:
      | Metric              | Value  | Team Rank |
      | Target Share        | 28.5%  | 1         |
      | Air Yards Share     | 35.2%  | 1         |
      | Targets/Game        | 11.2   | -         |
      | Target Quality      | 8.5    | -         |
      | Contested Targets % | 18%    | -         |

  Scenario: Compare target share across team receivers
    Given the user is analyzing the Chiefs receiving corps
    When viewing team target distribution
    Then target breakdown is displayed:
      | Player          | Target Share | Air Yards % | RZ Targets % |
      | Travis Kelce    | 25.5%        | 18.2%       | 32%          |
      | Rashee Rice     | 22.8%        | 28.5%       | 22%          |
      | Hollywood Brown | 15.2%        | 25.0%       | 12%          |
      | Other           | 36.5%        | 28.3%       | 34%          |

  Scenario: Track target share trends
    Given the user is viewing "DeVonta Smith" target trends
    When analyzing target share over time
    Then trend analysis shows:
      | Period        | Target Share | Targets/Gm | Trend     |
      | Weeks 1-6     | 22.5%        | 8.2        | -         |
      | Weeks 7-12    | 25.8%        | 9.5        | UP        |
      | Weeks 13-17   | 28.2%        | 10.8       | UP        |
      | Season        | 25.5%        | 9.5        | Increasing|

  Scenario: Display air yards and ADOT metrics
    Given the user is comparing deep threats
    When viewing air yards for WRs
    Then air yard data is displayed:
      | Player           | Total Air Yds | ADOT  | Deep Tgt % | Yds/Target |
      | Ja'Marr Chase    | 1,850         | 11.8  | 28%        | 10.9       |
      | Tyreek Hill      | 1,680         | 10.5  | 25%        | 9.2        |
      | Nico Collins     | 1,520         | 12.2  | 32%        | 10.5       |

  Scenario: View target quality metrics
    Given the user is evaluating target value
    When viewing "Mark Andrews" target quality
    Then quality metrics are shown:
      | Metric                    | Value |
      | Target Premium Score      | 8.5   |
      | Expected Fantasy/Target   | 1.85  |
      | Actual Fantasy/Target     | 2.12  |
      | Target Efficiency         | +14%  |
      | Contested Catch Rate      | 62%   |

  # ==================== HISTORICAL COMPARISONS ====================

  Scenario: Compare current season to previous years
    Given the user is viewing "Patrick Mahomes" statistics
    When selecting "Historical Comparison" view
    Then year-over-year comparison is displayed:
      | Season | Games | Pass Yds | TDs | INT | Fantasy Pts | Rank |
      | 2024   | 17    | 4,183    | 26  | 14  | 302.5       | 4    |
      | 2023   | 16    | 4,580    | 28  | 14  | 328.2       | 2    |
      | 2022   | 17    | 5,250    | 41  | 12  | 385.5       | 1    |
      | 2021   | 17    | 4,839    | 37  | 13  | 352.8       | 2    |

  Scenario: Compare player to historical playoff performances
    Given the user is viewing playoff projections
    When viewing "Derrick Henry" historical playoff data
    Then playoff history is displayed:
      | Year | Round      | Opponent  | Rush Yds | TDs | Fantasy |
      | 2024 | Wild Card  | -         | -        | -   | -       |
      | 2023 | Did Not    | -         | -        | -   | -       |
      | 2021 | Divisional | Bengals   | 62       | 0   | 6.2     |
      | 2020 | Wild Card  | Ravens    | 195      | 1   | 25.5    |
      | 2020 | Divisional | Ravens    | 195      | 1   | 25.5    |
      | 2020 | Conference | Chiefs    | 69       | 0   | 6.9     |

  Scenario: Compare player to position peers
    Given the user is viewing "Lamar Jackson" statistics
    When comparing to other elite QBs
    Then peer comparison is shown:
      | Player          | Pass Yds | Rush Yds | Total TDs | Fantasy |
      | Lamar Jackson   | 4,172    | 915      | 45        | 385.5   |
      | Josh Allen      | 4,100    | 568      | 40        | 365.2   |
      | Jalen Hurts     | 3,850    | 685      | 38        | 342.8   |

  Scenario: View career milestone tracking
    Given the user is viewing "Travis Kelce" profile
    When viewing career milestones
    Then milestone progress is displayed:
      | Milestone             | Current | Target | Progress |
      | Career Receptions     | 950     | 1,000  | 95%      |
      | Career Receiving Yds  | 11,500  | 12,000 | 96%      |
      | Career Receiving TDs  | 75      | 80     | 94%      |
      | Pro Bowl Selections   | 9       | 10     | 90%      |

  Scenario: Compare player to rookie season
    Given the user is analyzing "Ja'Marr Chase" development
    When viewing rookie vs current comparison
    Then development chart is displayed:
      | Metric          | Rookie (2021) | Current (2024) | Growth  |
      | Receptions      | 81            | 117            | +44%    |
      | Receiving Yds   | 1,455         | 1,708          | +17%    |
      | Receiving TDs   | 13            | 17             | +31%    |
      | Fantasy PPG     | 16.5          | 22.8           | +38%    |

  # ==================== FILTERING AND SORTING ====================

  Scenario: Filter players by position
    Given the user is on the player statistics dashboard
    When the user selects position filter "RB"
    Then only running backs are displayed in the results
    And the position filter indicator shows "RB" selected

  Scenario: Filter players by NFL team
    Given the user is viewing player statistics
    When the user filters by team "Kansas City Chiefs"
    Then only Chiefs players are displayed
    And players are sorted by fantasy points by default

  Scenario: Filter by fantasy point threshold
    Given the user is viewing all players
    When the user sets minimum fantasy points to 200
    Then only players with 200+ fantasy points are shown
    And count indicator shows number of matching players

  Scenario: Apply multiple filters simultaneously
    Given the user is on the player dashboard
    When the user applies the following filters:
      | Filter Type    | Value           |
      | Position       | WR              |
      | Team           | Playoff Teams   |
      | Min Points     | 150             |
      | Injury Status  | Healthy         |
    Then only healthy WRs from playoff teams with 150+ points are shown
    And active filter chips are displayed

  Scenario: Sort players by different metrics
    Given a list of players is displayed
    When the user clicks on the "Targets" column header
    Then players are sorted by targets descending
    And the column header shows sort direction indicator

  Scenario: Save and load custom filter presets
    Given the user has created a custom filter configuration
    When the user saves it as "Playoff WR Targets"
    Then the preset is available for future sessions
    And the user can quickly load the preset with one click

  Scenario: Clear all filters
    Given multiple filters are active
    When the user clicks "Clear All Filters"
    Then all filters are removed
    And the default player list is restored

  Scenario: Filter by availability status
    Given the user is viewing player list
    When filtering by "Available Players Only"
    Then only non-rostered players are displayed
    And rostered players are hidden from view

  # ==================== SEARCH FUNCTIONALITY ====================

  Scenario: Search for player by name
    Given the user is on the player statistics dashboard
    When the user types "Mahomes" in the search bar
    Then "Patrick Mahomes" appears in the search results
    And search is case-insensitive

  Scenario: Search with partial name match
    Given the user is searching for players
    When the user types "Ja'M"
    Then matching players are suggested:
      | Player           | Team   | Position |
      | Ja'Marr Chase    | CIN    | WR       |
      | Jamal Williams   | NO     | RB       |
    And the user can select from autocomplete suggestions

  Scenario: Search by team name
    Given the user is using the search feature
    When the user types "Chiefs"
    Then all Chiefs players are listed
    And team name search is indicated

  Scenario: Search with no results
    Given the user is searching
    When the user types "XYZNOTAPLAYER"
    Then "No players found" message is displayed
    And suggestions for similar searches may be offered

  Scenario: Search filters persist with navigation
    Given the user has searched for "Running Backs"
    When the user navigates to a player detail and returns
    Then the search results are preserved
    And the search term remains in the search bar

  Scenario: Clear search and return to default view
    Given the user has an active search
    When the user clicks the clear search button (X)
    Then the search bar is cleared
    And the default player list is displayed

  Scenario: Search with voice input
    Given the device supports voice input
    When the user activates voice search
    And speaks "Josh Allen"
    Then voice input is transcribed
    And matching players are displayed

  Scenario: Recent searches are saved
    Given the user has performed previous searches
    When the user focuses on the search bar
    Then recent searches are displayed as suggestions:
      | Recent Searches |
      | Patrick Mahomes |
      | Chiefs WR       |
      | Top RBs         |

  # ==================== RESPONSIVE DESIGN ====================

  Scenario: Display dashboard on desktop browser
    Given the user is on a desktop with 1920x1080 resolution
    When viewing the player statistics dashboard
    Then full sidebar navigation is visible
    And player table displays all columns
    And charts are displayed at full size

  Scenario: Display dashboard on tablet device
    Given the user is on a tablet with 768x1024 resolution
    When viewing the player statistics dashboard
    Then navigation collapses to hamburger menu
    And player table shows priority columns only
    And secondary stats are accessible via expand

  Scenario: Display dashboard on mobile device
    Given the user is on a mobile device with 375x667 resolution
    When viewing the player statistics dashboard
    Then navigation is hidden behind hamburger menu
    And player list is displayed as cards
    And horizontal scroll is available for tables
    And touch-friendly buttons are used

  Scenario: Maintain functionality across breakpoints
    Given the user is resizing the browser window
    When the window width changes from 1920px to 375px
    Then all features remain accessible
    And layout smoothly transitions between breakpoints
    And no content is cut off or overlapping

  Scenario: Charts resize responsively
    Given the user is viewing performance charts
    When the viewport width decreases
    Then charts resize proportionally
    And legends reposition or collapse as needed
    And data points remain interactive

  Scenario: Tables adapt to screen size
    Given the user is viewing player statistics table on mobile
    When viewing the table
    Then columns are prioritized:
      | Priority 1 | Player Name, Fantasy Points |
      | Priority 2 | Position, Team             |
      | Priority 3 | Key Stats (expandable)     |
    And user can swipe horizontally for more columns

  Scenario: Navigation works on touch devices
    Given the user is on a touch device
    When interacting with the dashboard
    Then touch gestures are supported:
      | Gesture        | Action               |
      | Tap            | Select/Navigate      |
      | Swipe Left     | Next page/section    |
      | Swipe Right    | Previous page        |
      | Pull Down      | Refresh data         |
      | Pinch          | Zoom charts          |

  Scenario: Dark mode support
    Given the user has dark mode enabled on their device
    When viewing the player statistics dashboard
    Then dashboard displays in dark color scheme
    And contrast ratios meet accessibility standards
    And charts use dark-mode optimized colors

  Scenario: Offline capability for recently viewed data
    Given the user has viewed player statistics while online
    When the device goes offline
    Then recently viewed player data is accessible
    And an "Offline Mode" indicator is displayed
    And last sync timestamp is shown

  # ==================== DATA REFRESH AND LIVE UPDATES ====================

  Scenario: Manual data refresh
    Given the user is viewing player statistics
    When the user clicks the refresh button
    Then all statistics are fetched from the data source
    And a loading indicator is displayed during refresh
    And "Last Updated" timestamp is updated

  Scenario: Auto-refresh during live games
    Given NFL games are currently in progress
    When the user is viewing the dashboard
    Then statistics automatically refresh every 60 seconds
    And live indicators show which games are active
    And scores update without page reload

  Scenario: Real-time score notifications
    Given the user is viewing a player during a live game
    When that player scores a touchdown
    Then a notification briefly appears
    And the player's stats animate to show the update
    And fantasy points are recalculated

  Scenario: Stale data warning
    Given the user's data is more than 30 minutes old
    When viewing the dashboard
    Then a "Data may be stale" warning is displayed
    And the user is prompted to refresh
    And auto-refresh option is offered

  # ==================== ERROR HANDLING ====================

  Scenario: Handle player data unavailable
    Given the data source is temporarily unavailable
    When the user attempts to view player statistics
    Then a user-friendly error message is displayed
    And cached data is shown if available
    And retry option is provided

  Scenario: Handle partial data load
    Given some player statistics failed to load
    When viewing the dashboard
    Then available data is displayed
    And missing sections show "Data unavailable"
    And specific error details are logged

  Scenario: Handle invalid player search
    Given the user searches for a retired player
    When no active player matches
    Then message "Player not found in active roster" is shown
    And suggestion to check historical data is offered

  Scenario: Handle network timeout
    Given the network request times out
    When fetching player statistics
    Then timeout error message is displayed
    And automatic retry is attempted
    And user can manually retry after 3 failed attempts

  # ==================== ACCESSIBILITY ====================

  Scenario: Screen reader compatibility
    Given the user is using a screen reader
    When navigating the player statistics dashboard
    Then all elements have appropriate ARIA labels
    And data tables have proper headers
    And navigation is logical and sequential

  Scenario: Keyboard navigation
    Given the user is navigating with keyboard only
    When using the dashboard
    Then all interactive elements are focusable
    And focus order is logical
    And focus indicators are clearly visible

  Scenario: Color contrast compliance
    Given accessibility standards require 4.5:1 contrast ratio
    When viewing the dashboard
    Then all text meets contrast requirements
    And charts use patterns in addition to colors
    And color is not the only indicator of information
