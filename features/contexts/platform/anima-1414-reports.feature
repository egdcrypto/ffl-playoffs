@ANIMA-1414 @backend @priority_2 @reports
Feature: Reports System
  As a fantasy football playoffs platform user
  I want to access comprehensive reports for leagues, teams, players, matchups, and seasons
  So that I can analyze performance, track progress, and make informed decisions

  Background:
    Given a user is authenticated
    And the user has access to a league "2025 NFL Playoffs Pool"
    And the league has active players and historical data
    And the reporting system is enabled for the league

  # ==================== REPORTS OVERVIEW ====================

  Scenario: Access reports dashboard
    Given the user navigates to the reports section
    When the reports dashboard loads
    Then the user sees:
      | Section            | Description                           |
      | Available Reports  | List of all accessible report types   |
      | Recent Reports     | Recently generated or viewed reports  |
      | Report Categories  | Organized categories for navigation   |
      | Quick Stats        | Summary metrics at a glance           |
      | Favorites          | User's bookmarked reports             |
    And the dashboard displays last updated timestamp

  Scenario: View available reports
    Given the user is on the reports dashboard
    When the user views available reports
    Then the system displays all report types:
      | Category       | Report Types                                      |
      | League         | Summary, Activity, Standings, Stats, Health       |
      | Team           | Summary, Performance, Roster, Transactions, Projections |
      | Player         | Summary, Performance, Comparison, Trends, Value   |
      | Matchup        | Summary, Weekly Recap, Analysis, Head-to-Head, Game Recap |
      | Season         | Summary, Recap, End-of-Season, Awards, Statistics |
    And each report shows a brief description and estimated generation time

  Scenario: Browse report categories
    Given the user is on the reports dashboard
    When the user selects a report category "League Reports"
    Then the system displays all reports in that category:
      | Report Name       | Description                                |
      | League Summary    | Overall league health and status           |
      | League Activity   | Recent actions and events in the league    |
      | Standings Report  | Current rankings and playoff positions     |
      | League Stats      | Aggregate statistics across all players    |
      | League Health     | Engagement and participation metrics       |
    And the user can navigate between categories

  Scenario: View recent reports
    Given the user has previously generated reports
    When the user views recent reports
    Then the system displays up to 10 most recent reports:
      | Report Name         | Type     | Generated Date   | Status    |
      | Week 3 Team Summary | Team     | 2025-01-20       | Available |
      | League Standings    | League   | 2025-01-19       | Available |
      | Player Comparison   | Player   | 2025-01-18       | Expired   |
    And the user can regenerate or download available reports
    And expired reports show a refresh option

  Scenario: View report summary widget
    Given the user is on the reports dashboard
    When the dashboard loads summary widgets
    Then the user sees quick summary metrics:
      | Metric                    | Value     |
      | Total Reports Generated   | 47        |
      | Reports This Week         | 8         |
      | Most Viewed Report        | Standings |
      | Scheduled Reports         | 3         |
    And widgets are clickable for detailed views

  # ==================== LEAGUE REPORTS ====================

  Scenario: Generate league summary report
    Given the user selects "League Summary" report
    When the report is generated
    Then the report includes:
      | Section                | Content                                    |
      | League Overview        | Name, format, player count, current round  |
      | Scoring Configuration  | PPR/Standard settings, bonus rules         |
      | Bracket Status         | Current playoff round and remaining teams  |
      | Top Performers         | Leading players by score                   |
      | Recent Activity        | Last 5 significant events                  |
    And the report shows a health score indicator

  Scenario: Generate league activity report
    Given the user selects "League Activity" report for the past week
    When the report is generated
    Then the report includes all league events:
      | Event Type          | Count | Details                            |
      | Roster Changes      | 15    | Players added, dropped, swapped    |
      | Score Updates       | 48    | Live and final score changes       |
      | Bracket Advancement | 4     | Players advancing to next round    |
      | Eliminations        | 4     | Players eliminated from playoffs   |
      | Admin Actions       | 2     | Settings changes, announcements    |
    And events are displayed in chronological order
    And each event shows timestamp and actor

  Scenario: Generate league standings report
    Given the league has completed Wild Card and Divisional rounds
    When the user generates the standings report
    Then the report shows current standings:
      | Rank | Player       | Status     | Total Score | W-L | Next Matchup     |
      | 1    | john_doe     | Active     | 312.5       | 2-0 | vs jane_doe      |
      | 2    | jane_doe     | Active     | 298.7       | 2-0 | vs john_doe      |
      | 3    | bob_player   | Active     | 285.3       | 2-0 | vs alice_player  |
      | 4    | alice_player | Active     | 270.1       | 2-0 | vs bob_player    |
      | 5    | player5      | Eliminated | 195.2       | 1-1 | -                |
    And standings show movement indicators from previous round
    And eliminated players are marked distinctly

  Scenario: Generate league stats report
    Given the league has scoring data across multiple rounds
    When the user generates the league stats report
    Then the report includes aggregate statistics:
      | Statistic                | Value     |
      | Total Points Scored      | 4,578.5   |
      | Average Score Per Player | 152.6     |
      | Highest Single Score     | 185.3     |
      | Lowest Single Score      | 98.2      |
      | Total Touchdowns         | 127       |
      | Average TDs Per Player   | 4.2       |
      | Most Common Roster Pick  | P. Mahomes|
    And the report includes position-based breakdowns
    And comparative charts are available

  Scenario: Generate league health report
    Given the league administrator requests a health report
    When the report is generated
    Then the report assesses league engagement:
      | Metric                    | Value  | Status  |
      | Active Participation Rate | 95%    | Healthy |
      | Roster Lock Compliance    | 100%   | Healthy |
      | Average Login Frequency   | 3.2/wk | Good    |
      | Message Board Activity    | 45/wk  | Active  |
      | Report Generation Usage   | 28/wk  | Normal  |
    And health indicators use color coding (green, yellow, red)
    And recommendations are provided for improvement areas

  # ==================== TEAM REPORTS ====================

  Scenario: Generate team summary report
    Given the user selects their team for reporting
    When the team summary report is generated
    Then the report includes:
      | Section           | Content                                  |
      | Team Overview     | Owner name, team standing, playoff status|
      | Current Roster    | All positions with player names          |
      | Score History     | Scores for each completed round          |
      | Win/Loss Record   | Matchup history with opponents           |
      | Upcoming Matchup  | Next opponent details if still active    |
    And the report shows team avatar and customization

  Scenario: Generate team performance report
    Given the user has completed 3 playoff rounds
    When the team performance report is generated
    Then the report analyzes scoring trends:
      | Round      | Score  | Rank | Trend  |
      | Wild Card  | 145.5  | 3    | -      |
      | Divisional | 167.2  | 1    | +2     |
      | Conference | 155.8  | 2    | -1     |
    And the report identifies:
      | Best Performing Position  | QB (avg 28.5 pts)    |
      | Worst Performing Position | K (avg 7.2 pts)      |
      | Most Consistent Player    | Patrick Mahomes      |
      | Highest Variance Player   | Cooper Kupp          |
    And performance percentile against league average is shown

  Scenario: Generate team roster report
    Given the user wants detailed roster information
    When the team roster report is generated
    Then the report shows current roster details:
      | Position | Player         | Team    | Bye Status | Playoff Status | Avg Pts |
      | QB       | Patrick Mahomes| Chiefs  | Active     | Playing        | 28.5    |
      | RB       | Derrick Henry  | Ravens  | Active     | Playing        | 18.2    |
      | RB       | Saquon Barkley | Eagles  | Active     | Playing        | 22.1    |
      | WR       | Tyreek Hill    | Dolphins| Eliminated | Done           | 15.3    |
      | WR       | CeeDee Lamb    | Cowboys | Eliminated | Done           | 17.8    |
    And the report flags players on eliminated NFL teams
    And roster strength score is calculated

  Scenario: Generate team transaction report
    Given the user has made roster changes during playoffs
    When the team transaction report is generated
    Then the report shows all transactions:
      | Date       | Action  | Player Out     | Player In      | Reason            |
      | 2025-01-15 | Swap    | Davante Adams  | Cooper Kupp    | Injury            |
      | 2025-01-18 | Add     | -              | Tyler Bass     | Kicker upgrade    |
      | 2025-01-20 | Drop    | Russell Wilson | -              | Poor performance  |
    And the report calculates transaction impact:
      | Total Transactions | 3     |
      | Net Point Impact   | +12.5 |
      | Success Rate       | 67%   |

  Scenario: Generate team projections report
    Given the user is preparing for the next round
    When the team projections report is generated
    Then the report shows projected performance:
      | Position | Player         | Projected Pts | Confidence | Opponent      |
      | QB       | Patrick Mahomes| 27.5          | High       | Bills DEF     |
      | RB       | Derrick Henry  | 16.8          | Medium     | Chiefs DEF    |
      | RB       | Saquon Barkley | 21.0          | High       | Commanders DEF|
    And the report shows:
      | Projected Team Total    | 155.3          |
      | Projected League Rank   | 2nd            |
      | Win Probability         | 58%            |
      | Key Matchup Advantages  | QB, RB depth   |
    And confidence levels are explained

  # ==================== PLAYER REPORTS ====================

  Scenario: Generate player summary report
    Given the user selects a specific NFL player "Patrick Mahomes"
    When the player summary report is generated
    Then the report includes:
      | Section            | Content                              |
      | Player Info        | Name, team, position, jersey number  |
      | Season Stats       | Passing yards, TDs, INTs, rating     |
      | Playoff Stats      | Playoff-specific performance         |
      | Fantasy Points     | Total and average fantasy points     |
      | Ownership          | Percentage of teams rostering player |
    And the report includes recent news and injury status

  Scenario: Generate player performance report
    Given the user wants to analyze "Patrick Mahomes" playoff performance
    When the player performance report is generated
    Then the report shows game-by-game breakdown:
      | Round      | Opponent | Pass Yds | Pass TD | INT | Rush Yds | Fantasy Pts |
      | Wild Card  | Dolphins | 310      | 3       | 0   | 25       | 29.4        |
      | Divisional | Bills    | 275      | 2       | 1   | 32       | 22.5        |
      | Conference | Ravens   | 340      | 4       | 0   | 18       | 33.2        |
    And performance trends are visualized
    And comparison to regular season average is included

  Scenario: Generate player comparison report
    Given the user wants to compare "Patrick Mahomes" and "Josh Allen"
    When the player comparison report is generated
    Then the report shows side-by-side comparison:
      | Metric              | Patrick Mahomes | Josh Allen |
      | Playoff Games       | 3               | 2          |
      | Pass Yards/Game     | 308.3           | 295.0      |
      | Pass TD/Game        | 3.0             | 2.5        |
      | Interceptions       | 1               | 2          |
      | Rush Yards/Game     | 25.0            | 42.5       |
      | Fantasy Pts/Game    | 28.4            | 26.8       |
      | Consistency Score   | 8.5             | 7.2        |
    And a recommendation is provided based on matchup
    And historical head-to-head is included if available

  Scenario: Generate player trends report
    Given the user wants to see trending players
    When the player trends report is generated
    Then the report shows rising and falling players:
      | Trend    | Player          | Position | Change  | Reason                    |
      | Rising   | Jaylen Waddle   | WR       | +15%    | Increased targets         |
      | Rising   | Isiah Pacheco   | RB       | +12%    | Higher snap count         |
      | Falling  | Travis Kelce    | TE       | -8%     | Reduced red zone looks    |
      | Falling  | Amari Cooper    | WR       | -20%    | Team eliminated           |
    And trends are calculated over the last 2 weeks
    And actionable insights are provided

  Scenario: Generate player value report
    Given the user wants to assess player values
    When the player value report is generated
    Then the report ranks players by value metrics:
      | Rank | Player          | Position | Ownership | Avg Pts | Value Score |
      | 1    | Jaylen Waddle   | WR       | 45%       | 18.5    | 9.2         |
      | 2    | Isiah Pacheco   | RB       | 38%       | 14.2    | 8.8         |
      | 3    | Jake Ferguson   | TE       | 22%       | 12.5    | 8.5         |
    And value score considers points vs ownership percentage
    And "must roster" and "avoid" recommendations are included

  # ==================== MATCHUP REPORTS ====================

  Scenario: Generate matchup summary report
    Given the user has an active matchup against "jane_doe"
    When the matchup summary report is generated
    Then the report includes:
      | Section              | Content                              |
      | Matchup Overview     | Both team names, round, status       |
      | Current Scores       | Live or final scores for both teams  |
      | Head-to-Head History | Previous matchup results if any      |
      | Key Matchups         | Position battles to watch            |
      | Advantage Analysis   | Which team has edge at each position |
    And win probability is displayed for each team

  Scenario: Generate weekly recap report
    Given the Wild Card round has completed
    When the weekly recap report is generated
    Then the report summarizes the round:
      | Metric               | Value                          |
      | Matchups Completed   | 8                              |
      | Highest Team Score   | 172.5 (john_doe)               |
      | Lowest Team Score    | 105.2 (player12)               |
      | Biggest Upset        | #8 seed beat #1 seed           |
      | Closest Matchup      | 145.5 vs 145.2 (0.3 pt margin) |
      | Top Performer        | Patrick Mahomes (35.2 pts)     |
      | Biggest Bust         | Davante Adams (2.1 pts)        |
    And all matchup results are listed
    And advancing and eliminated players are identified

  Scenario: Generate matchup analysis report
    Given the user wants deep analysis of their matchup
    When the matchup analysis report is generated
    Then the report provides strategic insights:
      | Position | Your Player    | Proj Pts | Opp Player     | Proj Pts | Edge      |
      | QB       | Patrick Mahomes| 27.5     | Josh Allen     | 26.8     | +0.7      |
      | RB       | Derrick Henry  | 16.8     | Saquon Barkley | 21.0     | -4.2      |
      | RB       | CMC            | 22.5     | Joe Mixon      | 14.2     | +8.3      |
    And the report calculates:
      | Your Projected Total  | 155.3                    |
      | Opponent Projected    | 148.7                    |
      | Projected Margin      | +6.6                     |
      | Win Probability       | 62%                      |
      | Key Swing Positions   | RB1, WR2                 |
    And scenario analysis shows best/worst case outcomes

  Scenario: Generate head-to-head report
    Given the user has faced "jane_doe" in multiple rounds
    When the head-to-head report is generated
    Then the report shows historical matchups:
      | Round       | Your Score | Opp Score | Result | Margin |
      | Regular Wk3 | 138.5      | 145.2     | Loss   | -6.7   |
      | Regular Wk9 | 162.3      | 148.5     | Win    | +13.8  |
      | Playoff WC  | 155.0      | 152.3     | Win    | +2.7   |
    And aggregated head-to-head stats:
      | Overall Record        | 2-1        |
      | Total Points For      | 455.8      |
      | Total Points Against  | 446.0      |
      | Average Margin        | +3.3       |
    And trends in the rivalry are highlighted

  Scenario: Generate game recap report
    Given a matchup has completed
    When the game recap report is generated
    Then the report provides complete recap:
      | Section           | Content                                |
      | Final Score       | 165.7 - 159.5 (jane_doe wins)          |
      | Scoring Timeline  | Quarter-by-quarter/Game-by-game points |
      | MVP Performance   | Justin Jefferson (28.5 pts)            |
      | Key Moments       | Lead changes, big plays                |
      | Position Breakdown| Points scored at each position         |
      | Turning Point     | When the matchup was effectively won   |
    And shareable highlight summary is generated

  # ==================== SEASON REPORTS ====================

  Scenario: Generate season summary report
    Given the playoff season is in progress
    When the season summary report is generated
    Then the report includes season-to-date metrics:
      | Metric                   | Value        |
      | Rounds Completed         | 2 of 4       |
      | Players Remaining        | 8 of 32      |
      | Total Points Scored      | 12,456.7     |
      | Average Score Per Round  | 148.3        |
      | Upsets So Far            | 5            |
      | Closest Matchup          | 0.3 pts      |
    And key storylines are highlighted

  Scenario: Generate season recap report
    Given the Wild Card round has completed
    When the season recap for Wild Card is generated
    Then the report provides comprehensive recap:
      | Section              | Content                           |
      | Round Overview       | Format, dates, number of matchups |
      | Results Summary      | All matchup outcomes              |
      | Scoring Leaders      | Top 5 scores of the round         |
      | Position Leaders     | Best at each position             |
      | Surprises            | Unexpected performances           |
      | Disappointments      | Underperforming players           |
      | Bracket Impact       | How results affect championship odds |
    And a narrative summary is generated

  Scenario: Generate end-of-season report
    Given the Super Bowl round has completed
    And a champion has been crowned
    When the end-of-season report is generated
    Then the report includes final standings:
      | Finish | Player       | Total Score | Record |
      | 1st    | john_doe     | 612.5       | 4-0    |
      | 2nd    | jane_doe     | 598.3       | 3-1    |
      | 3rd    | bob_player   | 485.2       | 2-1    |
      | 4th    | alice_player | 470.8       | 2-1    |
    And comprehensive season statistics:
      | Category                  | Winner       | Value    |
      | Most Points Scored        | john_doe     | 612.5    |
      | Highest Single Week       | jane_doe     | 185.3    |
      | Most Consistent           | bob_player   | 8.2 std  |
      | Best Roster Decisions     | john_doe     | +45.2    |
      | Biggest Comeback          | alice_player | 22.5 pts |
    And champion's path to victory is chronicled

  Scenario: Generate season awards report
    Given the season has completed
    When the season awards report is generated
    Then the report announces all awards:
      | Award                    | Winner       | Stat/Reason              |
      | League Champion          | john_doe     | 612.5 total points       |
      | Runner-Up                | jane_doe     | 598.3 total points       |
      | MVP                      | john_doe     | Highest scorer           |
      | Best Draft               | bob_player   | Most value over expectation |
      | Comeback Player          | alice_player | From 12th to 4th finish  |
      | Clutch Performer         | jane_doe     | Best 4th quarter scores  |
      | Best Waiver Pickup       | john_doe     | Cooper Kupp (+42.5 pts)  |
      | Wooden Spoon             | player16     | Last place               |
    And each award includes explanation and statistics

  Scenario: Generate season statistics report
    Given the season has completed
    When the season statistics report is generated
    Then the report includes comprehensive stats:
      | Category                   | Value       | Leader      |
      | Total League Points        | 18,945.3    | -           |
      | Average Score Per Player   | 147.2       | -           |
      | Total Touchdowns           | 423         | -           |
      | Most TDs (Single Team)     | 28          | john_doe    |
      | Highest Win Rate           | 100%        | john_doe    |
      | Total Roster Moves         | 156         | -           |
      | Most Active Trader         | bob_player  | 24 moves    |
    And position-based statistical leaders:
      | Position | Leader          | Total Pts |
      | QB       | Patrick Mahomes | 112.5     |
      | RB       | Saquon Barkley  | 95.2      |
      | WR       | Justin Jefferson| 98.7      |
      | TE       | Travis Kelce    | 65.3      |
    And historical comparisons to past seasons if available

  # ==================== CUSTOM REPORTS ====================

  Scenario: Create a custom report
    Given the user wants to create a custom report
    When the user accesses the custom report builder
    Then the user can configure:
      | Configuration       | Options                              |
      | Report Name         | Free text field                      |
      | Data Sources        | League, Team, Player, Matchup data   |
      | Time Range          | Specific rounds, date range, all-time|
      | Metrics to Include  | Selectable list of available metrics |
      | Grouping            | By player, position, round, week     |
      | Sorting             | Ascending/descending by any metric   |
      | Filters             | Status, position, score range        |
    And preview functionality is available

  Scenario: Define custom metrics
    Given the user is building a custom report
    When the user defines a custom metric
    Then the user can create calculated fields:
      | Metric Name         | Formula                           | Example    |
      | Points Per Game     | Total Points / Games Played       | 28.5       |
      | Consistency Score   | 1 / Standard Deviation            | 8.2        |
      | Value Over Average  | Points - League Average           | +15.3      |
      | Win Contribution    | Points in Wins / Total Wins       | 165.2      |
    And custom metrics can be saved for reuse
    And formula validation is performed

  Scenario: Use report builder interface
    Given the user is in the report builder
    When the user builds a report with drag-and-drop
    Then the interface allows:
      | Action              | Description                          |
      | Add Columns         | Drag metrics to report grid          |
      | Remove Columns      | Remove unwanted fields               |
      | Reorder Columns     | Drag to rearrange column order       |
      | Apply Formatting    | Number format, colors, highlights    |
      | Add Calculations    | Sum, average, min, max, count        |
      | Insert Charts       | Bar, line, pie charts from data      |
    And changes are reflected in real-time preview

  Scenario: Access saved reports
    Given the user has previously saved custom reports
    When the user views saved reports
    Then the system displays:
      | Report Name           | Created     | Last Run    | Schedule    |
      | Weekly Team Analysis  | 2025-01-01  | 2025-01-20  | Weekly      |
      | Player Value Tracker  | 2025-01-05  | 2025-01-19  | On-demand   |
      | Matchup Deep Dive     | 2025-01-10  | 2025-01-18  | Per-round   |
    And the user can:
      | Action   | Description                |
      | Run      | Generate report now        |
      | Edit     | Modify report definition   |
      | Clone    | Create copy to modify      |
      | Delete   | Remove saved report        |
      | Share    | Share with other users     |

  Scenario: Use report templates
    Given the user wants to create a report quickly
    When the user browses report templates
    Then the system offers pre-built templates:
      | Template Name           | Category | Description                      |
      | Weekly Performance      | Team     | Standard weekly team summary     |
      | Player Comparison       | Player   | Side-by-side player analysis     |
      | Matchup Preview         | Matchup  | Pre-game matchup analysis        |
      | Season Standings        | League   | Current standings with trends    |
      | Draft Recap             | Season   | Draft results and value analysis |
    And templates can be customized before saving
    And users can create templates from their reports

  # ==================== REPORT SCHEDULING ====================

  Scenario: Create a scheduled report
    Given the user wants to automate report generation
    When the user configures a scheduled report
    Then the user can set:
      | Setting          | Options                              |
      | Report Type      | Any saved or standard report         |
      | Frequency        | Daily, Weekly, Per-round, Monthly    |
      | Day/Time         | Specific day and time to run         |
      | Recipients       | Email addresses for delivery         |
      | Format           | PDF, CSV, or both                    |
      | Active Period    | Start date, end date, or ongoing     |
    And schedule confirmation is displayed

  Scenario: Manage recurring reports
    Given the user has multiple scheduled reports
    When the user views recurring reports
    Then the system displays all schedules:
      | Report Name          | Frequency | Next Run     | Last Run     | Status  |
      | Weekly Standings     | Weekly    | Mon 8:00 AM  | 2025-01-20   | Active  |
      | Daily Scores         | Daily     | Tomorrow 6AM | Today 6:00AM | Active  |
      | Round Recap          | Per-round | After Conf   | 2025-01-19   | Active  |
    And the user can pause, resume, or cancel schedules
    And run history is accessible

  Scenario: Configure automated delivery
    Given the user sets up automated report delivery
    When the user configures delivery options
    Then the user can specify:
      | Option              | Configuration                        |
      | Email Delivery      | Multiple recipients, subject line    |
      | In-App Notification | Push notification when ready         |
      | Cloud Storage       | Save to Google Drive, Dropbox        |
      | Webhook             | POST to external URL                 |
    And delivery confirmation settings are available
    And failure notifications are configurable

  Scenario: View report calendar
    Given the user has multiple scheduled reports
    When the user views the report calendar
    Then a calendar view displays:
      | Date       | Reports Scheduled                    |
      | 2025-01-21 | Weekly Standings (8:00 AM)           |
      | 2025-01-22 | Daily Scores (6:00 AM)               |
      | 2025-01-26 | Round Recap (After games), Weekly    |
    And the user can click dates to see details
    And add new schedules from the calendar

  Scenario: Create batch reports
    Given the user needs multiple reports at once
    When the user configures a batch report job
    Then the user can select multiple reports to run:
      | Report                | Include |
      | League Standings      | Yes     |
      | All Team Summaries    | Yes     |
      | Player Trends         | Yes     |
      | Matchup Previews      | Yes     |
    And batch jobs can be scheduled or run immediately
    And all reports are delivered as a package

  # ==================== REPORT EXPORT ====================

  Scenario: Export report to multiple formats
    Given the user has generated a report
    When the user chooses to export
    Then export options are available:
      | Format | Description                          |
      | PDF    | Formatted document with charts       |
      | CSV    | Raw data for spreadsheet import      |
      | Excel  | Formatted spreadsheet with formulas  |
      | JSON   | Structured data for API consumption  |
      | Image  | PNG/JPG of charts and tables         |
    And format-specific options are configurable

  Scenario: Download report as PDF
    Given the user has generated a standings report
    When the user clicks "Download PDF"
    Then a PDF file is generated with:
      | Element           | Included                        |
      | Header            | Report title, date, league name |
      | Data Tables       | Formatted with borders          |
      | Charts            | Embedded visualizations         |
      | Footer            | Page numbers, generation time   |
      | Branding          | League logo if configured       |
    And the PDF downloads to user's device
    And file is named with report type and date

  Scenario: Download report as CSV
    Given the user has generated a statistics report
    When the user clicks "Download CSV"
    Then a CSV file is generated with:
      | Row 1     | Column headers                     |
      | Row 2+    | Data rows with proper formatting   |
    And the user can select which columns to include
    And numeric formatting is preserved
    And special characters are properly escaped

  Scenario: Print report
    Given the user has generated a matchup report
    When the user clicks "Print Report"
    Then a print-optimized version is generated:
      | Optimization        | Description                     |
      | Page Breaks         | Logical breaks for readability  |
      | Margins             | Standard print margins          |
      | Color Scheme        | Optional grayscale mode         |
      | Font Size           | Configurable for readability    |
      | Chart Size          | Scaled for print dimensions     |
    And print preview is displayed
    And system print dialog is opened

  Scenario: Share report with others
    Given the user has generated a valuable report
    When the user clicks "Share Report"
    Then sharing options are available:
      | Method              | Description                        |
      | Email               | Send as attachment or link         |
      | Shareable Link      | Generate public or private link    |
      | Social Media        | Share to Twitter, Facebook         |
      | In-League Message   | Send to league message board       |
      | Direct Message      | Send to specific league members    |
    And access permissions can be set
    And link expiration is configurable

  # ==================== REPORT ANALYTICS ====================

  Scenario: View report insights
    Given the user has generated multiple reports over time
    When the user views report insights
    Then the system provides meta-analysis:
      | Insight                | Description                       |
      | Most Viewed Reports    | Top 5 reports by view count       |
      | Trending Topics        | What users are researching        |
      | Data Patterns          | Common queries and interests      |
      | Report Effectiveness   | Which reports lead to actions     |
    And personalized recommendations are provided

  Scenario: Access data visualizations
    Given the user is viewing a statistical report
    When the user accesses visualization options
    Then available chart types include:
      | Chart Type       | Best For                          |
      | Bar Chart        | Comparing values across categories|
      | Line Chart       | Showing trends over time          |
      | Pie Chart        | Showing composition/percentages   |
      | Scatter Plot     | Showing correlation between metrics|
      | Heat Map         | Showing intensity across dimensions|
      | Radar Chart      | Comparing multiple metrics at once|
    And charts are interactive with hover details
    And charts can be customized and exported

  Scenario: Perform trend analysis
    Given the user wants to analyze performance trends
    When the user runs trend analysis
    Then the system calculates:
      | Trend Metric            | Description                      |
      | Score Trajectory        | Direction of scoring over rounds |
      | Position Trends         | Which positions are improving    |
      | Player Trends           | Individual player performance    |
      | League-Wide Trends      | Overall league patterns          |
    And trend visualizations show:
      | Moving averages and trendlines           |
      | Comparison to league average             |
      | Prediction of next round performance     |
      | Statistical confidence intervals         |

  Scenario: Access predictive analytics
    Given the user wants future performance predictions
    When the user runs predictive analytics
    Then the system provides:
      | Prediction              | Description                      |
      | Win Probability         | Likelihood of winning next matchup|
      | Projected Final Standing| Expected final position          |
      | Championship Odds       | Probability of winning it all   |
      | Optimal Lineup          | Suggested roster for max points  |
    And predictions include:
      | Confidence Level  | How certain the prediction is    |
      | Key Factors       | What drives the prediction       |
      | Scenario Analysis | Best case, worst case, likely    |
    And historical accuracy of predictions is shown

  Scenario: View performance metrics dashboard
    Given the user wants comprehensive performance metrics
    When the user accesses the metrics dashboard
    Then real-time metrics are displayed:
      | Metric Category     | Metrics Included                    |
      | Scoring Metrics     | Total, average, max, min, std dev   |
      | Efficiency Metrics  | Points per player, roster efficiency|
      | Consistency Metrics | Week-to-week variance, reliability  |
      | Comparative Metrics | Rank, percentile, vs league average |
    And metrics can be:
      | Filtered by time period                  |
      | Compared across multiple entities        |
      | Exported for further analysis            |
      | Set up with alerts for thresholds        |

  # ==================== REPORT ACCESS AND PERMISSIONS ====================

  Scenario: Control report access by role
    Given a league has multiple user roles
    When report access is configured
    Then permissions are role-based:
      | Role           | Access Level                        |
      | League Admin   | All reports, create, share, schedule|
      | Team Owner     | Own team reports, league public     |
      | League Member  | View public reports only            |
      | Guest          | Limited public report access        |
    And custom permissions can be set per report

  Scenario: Audit report access
    Given the admin wants to track report usage
    When the admin views the report audit log
    Then the log shows:
      | Date       | User       | Report           | Action    | IP Address   |
      | 2025-01-20 | john_doe   | League Standings | Viewed    | 192.168.1.1  |
      | 2025-01-20 | jane_doe   | Team Summary     | Exported  | 192.168.1.2  |
      | 2025-01-19 | admin      | All Reports      | Scheduled | 192.168.1.3  |
    And audit data can be filtered and exported
    And suspicious activity is flagged

  # ==================== ERROR HANDLING ====================

  Scenario: Handle report generation failure
    Given a report fails to generate due to data issues
    When the error occurs
    Then the user is notified with:
      | Error Element   | Content                             |
      | Error Message   | "Unable to generate report"         |
      | Error Code      | RPT-001                             |
      | Reason          | "Missing data for specified period" |
      | Suggestion      | "Select a different date range"     |
    And retry option is available
    And support contact is provided

  Scenario: Handle empty report results
    Given a report query returns no data
    When the report is generated
    Then the user sees:
      | Message         | "No data found matching your criteria" |
      | Suggestions     | Alternative date ranges or filters     |
      | Similar Reports | Other reports that may be relevant     |
    And the report structure is still displayed
    And user can modify filters and regenerate

  Scenario: Handle report timeout
    Given a complex report takes too long to generate
    When the timeout threshold is reached
    Then the system:
      | Notifies user of delay                    |
      | Offers to run report in background        |
      | Provides email notification option        |
      | Suggests simplifying report parameters    |
    And partial results are available if generated
    And the background job is trackable
