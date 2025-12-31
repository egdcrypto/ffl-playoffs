@ANIMA-1292 @frontend @priority_1 @statistics @player-data
Feature: Player Statistics Dashboard
  As a fantasy football playoffs participant
  I want to view comprehensive NFL player statistics
  So that I can make informed decisions about roster selections and matchups

  Background:
    Given the NFL playoff data source is available
    And the current user is authenticated
    And the user is viewing the player statistics dashboard

  # ============================================
  # SEASON STATS DISPLAY
  # ============================================

  @season-stats @happy-path
  Scenario: Display player season statistics summary
    Given the user selects player "Patrick Mahomes"
    When viewing the season stats section
    Then the following season totals are displayed:
      | Stat Category    | Value  |
      | Games Played     | 17     |
      | Passing Yards    | 4,839  |
      | Passing TDs      | 41     |
      | Interceptions    | 12     |
      | Passer Rating    | 106.3  |
      | Fantasy Points   | 389.5  |
    And the stats are for the current NFL season
    And last updated timestamp is shown

  @season-stats @position-specific
  Scenario: Display position-specific season stats for RB
    Given the user selects running back "Derrick Henry"
    When viewing the season stats section
    Then RB-specific stats are displayed:
      | Stat Category     | Value  |
      | Rushing Attempts  | 325    |
      | Rushing Yards     | 1,921  |
      | Rushing TDs       | 16     |
      | Yards Per Carry   | 5.9    |
      | Receptions        | 32     |
      | Receiving Yards   | 245    |
      | Receiving TDs     | 1      |
      | Total TDs         | 17     |
      | Fantasy Points    | 312.6  |

  @season-stats @position-specific
  Scenario: Display position-specific season stats for WR
    Given the user selects wide receiver "CeeDee Lamb"
    When viewing the season stats section
    Then WR-specific stats are displayed:
      | Stat Category     | Value  |
      | Targets           | 181    |
      | Receptions        | 135    |
      | Receiving Yards   | 1,749  |
      | Receiving TDs     | 12     |
      | Yards Per Reception| 13.0   |
      | Catch Rate        | 74.6%  |
      | Fantasy Points    | 298.9  |

  @season-stats @defense
  Scenario: Display team defense season stats
    Given the user selects defense "San Francisco 49ers"
    When viewing the season stats section
    Then defensive stats are displayed:
      | Stat Category       | Value |
      | Points Allowed/Game | 17.5  |
      | Sacks               | 48    |
      | Interceptions       | 18    |
      | Fumble Recoveries   | 12    |
      | Defensive TDs       | 4     |
      | Fantasy Points      | 168.0 |

  @season-stats @comparison
  Scenario: Compare season stats to league average
    Given the user is viewing "Josh Allen" stats
    When enabling "Compare to League Average"
    Then each stat shows comparison:
      | Stat          | Player Value | League Avg | Difference |
      | Passing Yards | 4,306        | 3,850      | +456       |
      | Passing TDs   | 37           | 28         | +9         |
    And above-average stats are highlighted green
    And below-average stats are highlighted red

  # ============================================
  # WEEKLY BREAKDOWNS
  # ============================================

  @weekly @display
  Scenario: Display weekly performance breakdown
    Given the user selects player "Travis Kelce"
    When viewing the weekly breakdown section
    Then a table shows each week's performance:
      | Week | Opponent | Targets | Rec | Yards | TDs | Fantasy Pts |
      | 1    | @DET     | 9       | 6   | 71    | 1   | 17.1        |
      | 2    | JAX      | 11      | 8   | 89    | 0   | 16.9        |
      | 3    | @CHI     | 7       | 5   | 62    | 1   | 14.2        |
    And weeks are sortable by any column
    And clicking a week shows detailed game log

  @weekly @chart
  Scenario: Display weekly fantasy points chart
    Given the user is viewing weekly breakdown
    When the chart view is selected
    Then a line/bar chart displays fantasy points by week
    And average line is shown across weeks
    And boom/bust weeks are visually highlighted
    And chart is interactive (hover for details)

  @weekly @bye-week
  Scenario: Display bye week indicator
    Given the player had a bye in Week 10
    When viewing weekly breakdown
    Then Week 10 shows "BYE" instead of stats
    And the row is styled differently
    And bye week doesn't affect averages calculation

  @weekly @missed-games
  Scenario: Display missed games due to injury
    Given the player missed Weeks 8-10 due to injury
    When viewing weekly breakdown
    Then Weeks 8-10 show "DNP - Injury" status
    And injury type is indicated (if known)
    And stats show 0 or N/A appropriately

  @weekly @filter
  Scenario: Filter weekly stats by date range
    Given the user wants playoff weeks only
    When filtering to "Wild Card - Super Bowl"
    Then only playoff week stats are displayed
    And summary recalculates for filtered period
    And "Clear Filter" option is available

  # ============================================
  # PERFORMANCE TRENDS
  # ============================================

  @trends @visualization
  Scenario: Display performance trend chart
    Given the user is viewing "Ja'Marr Chase" stats
    When viewing the trends section
    Then a trend line chart shows:
      | Metric displayed over time      |
      | Fantasy points per game         |
      | Targets per game                |
      | Yards per game                  |
    And trend direction is indicated (up/down/stable)
    And rolling average line is optional

  @trends @last-weeks
  Scenario: Show last N weeks trend
    Given the user wants recent performance
    When selecting "Last 4 Weeks" trend view
    Then only the last 4 weeks are charted
    And comparison to season average is shown
    And hot/cold streak indicator is displayed

  @trends @splits
  Scenario: Display home vs away performance splits
    Given the user is analyzing "Tyreek Hill"
    When viewing performance splits
    Then home and away stats are compared:
      | Split   | Games | Yards/Game | TDs | Fantasy Avg |
      | Home    | 8     | 95.5       | 5   | 19.2        |
      | Away    | 9     | 82.3       | 4   | 16.8        |
    And significant differences are highlighted

  @trends @weather
  Scenario: Display weather-related performance
    Given weather affects outdoor games
    When viewing weather splits
    Then performance in different conditions is shown:
      | Condition      | Games | Fantasy Avg |
      | Dome/Indoor    | 6     | 22.5        |
      | Clear Outdoor  | 8     | 18.2        |
      | Rain/Snow      | 3     | 14.1        |

  @trends @vs-division
  Scenario: Display performance vs divisional opponents
    Given divisional games may differ
    When viewing divisional splits
    Then stats against division are separated:
      | Opponent Type    | Games | Fantasy Avg |
      | Divisional       | 6     | 21.3        |
      | Non-Divisional   | 11    | 18.5        |

  # ============================================
  # FANTASY PROJECTIONS
  # ============================================

  @projections @weekly
  Scenario: Display weekly fantasy projection
    Given the user is viewing "Patrick Mahomes"
    And the upcoming game is vs Buffalo
    When viewing projections section
    Then the weekly projection shows:
      | Projected Points | 24.5        |
      | Projected Range  | 18.5 - 30.5 |
      | Confidence Level | Medium      |
      | vs Vegas O/U     | 52.5        |
    And projection source is indicated

  @projections @sources
  Scenario: Compare projections from multiple sources
    Given multiple projection sources are available
    When viewing projections comparison
    Then projections from each source are shown:
      | Source          | Projection |
      | ESPN            | 24.5       |
      | Yahoo           | 23.8       |
      | FantasyPros     | 25.2       |
      | Consensus       | 24.5       |
    And consensus projection is highlighted

  @projections @ros
  Scenario: Display rest-of-season projection
    Given it is mid-season
    When viewing ROS projections
    Then remaining weeks projections are shown:
      | Remaining Games | 4          |
      | Total Projected | 98.5       |
      | Avg Per Game    | 24.6       |
    And schedule difficulty is factored in

  @projections @playoff
  Scenario: Display playoff-specific projections
    Given it is NFL playoff time
    When viewing playoff projections
    Then projections for each playoff round are shown:
      | Round        | Opponent  | Projection |
      | Wild Card    | MIA       | 26.5       |
      | Divisional   | TBD       | 24.0       |
      | Conference   | TBD       | 23.5       |
    And matchup quality is indicated

  # ============================================
  # POSITIONAL RANKINGS
  # ============================================

  @rankings @position
  Scenario: Display positional rankings
    Given the user views QB rankings
    When the ranking table is displayed
    Then QBs are ranked by fantasy points:
      | Rank | Player          | Team | Fantasy Pts | Avg/Game |
      | 1    | Josh Allen      | BUF  | 412.5       | 24.3     |
      | 2    | Lamar Jackson   | BAL  | 398.2       | 23.4     |
      | 3    | Patrick Mahomes | KC   | 389.5       | 22.9     |
    And current player's rank is highlighted
    And ranking movement arrows show trends

  @rankings @scoring-format
  Scenario: Adjust rankings by scoring format
    Given the user's league uses Half-PPR
    When viewing WR rankings
    Then rankings adjust for Half-PPR scoring
    And toggle between Standard/Half-PPR/Full-PPR is available
    And rankings recalculate dynamically

  @rankings @weekly
  Scenario: Display weekly positional rankings
    Given the user wants this week's rankings
    When selecting "Week 18 Rankings"
    Then rankings show this week's performance:
      | Rank | Player     | Opponent | Projected | Floor | Ceiling |
      | 1    | Josh Allen | MIA      | 28.5      | 20.0  | 38.0    |
    And rankings can toggle between projected and actual

  @rankings @tiers
  Scenario: Display player tiers within position
    Given positional tiers are defined
    When viewing tiered rankings
    Then players are grouped into tiers:
      | Tier   | Players                           |
      | Elite  | Allen, Jackson, Mahomes           |
      | Good   | Hurts, Stroud, Love               |
      | Average| Goff, Stafford, Cousins           |
    And tier boundaries are clearly marked

  # ============================================
  # MATCHUP ANALYSIS
  # ============================================

  @matchup @opponent
  Scenario: Display matchup analysis vs upcoming opponent
    Given "Derrick Henry" plays @CIN this week
    When viewing matchup analysis
    Then analysis shows:
      | Metric                      | Value     |
      | CIN Rush Defense Rank       | 28th      |
      | CIN Fantasy Pts Allowed (RB)| 24.5/game |
      | Henry's Projection vs CIN   | 22.5      |
      | Historical vs CIN           | 2 games, 145 avg |
    And matchup is rated (Favorable/Neutral/Difficult)

  @matchup @defense-stats
  Scenario: Display opponent defensive statistics
    Given the matchup analysis is displayed
    When viewing opponent defense details
    Then detailed defensive stats are shown:
      | Stat                     | Value | Rank |
      | Points Allowed/Game      | 24.5  | 22nd |
      | Rushing Yards Allowed    | 125.5 | 28th |
      | Passing Yards Allowed    | 235.0 | 15th |
      | Fantasy Pts to RBs       | 24.5  | 28th |
      | Fantasy Pts to WRs       | 28.2  | 18th |

  @matchup @historical
  Scenario: Display historical performance vs opponent
    Given "Patrick Mahomes" has played @BUF multiple times
    When viewing historical matchup data
    Then past performances are shown:
      | Date       | Result | Yards | TDs | Fantasy Pts |
      | Jan 2024   | L      | 245   | 1   | 18.2        |
      | Dec 2023   | W      | 320   | 3   | 29.5        |
      | Jan 2022   | W      | 378   | 3   | 32.1        |
    And career average vs this opponent is shown

  @matchup @coverage
  Scenario: Display expected coverage matchup for WR
    Given "CeeDee Lamb" faces specific cornerbacks
    When viewing coverage matchup
    Then expected coverage is analyzed:
      | Expected Coverage       | Rating    |
      | Primary: Sauce Gardner  | Difficult |
      | Slot: Michael Carter II | Favorable |
    And target share projection is adjusted

  # ============================================
  # INJURY TRACKING
  # ============================================

  @injury @status
  Scenario: Display current injury status
    Given "Davante Adams" has an injury designation
    When viewing the player card
    Then injury status is prominently displayed:
      | Status       | Questionable        |
      | Injury Type  | Hamstring           |
      | Game Status  | Game-Time Decision  |
      | Last Updated | Jan 10, 2025 4:30 PM|
    And injury icon appears on all player views

  @injury @history
  Scenario: Display injury history
    Given the user wants to assess injury risk
    When viewing injury history
    Then past injuries are listed:
      | Date        | Injury        | Games Missed |
      | Nov 2024    | Hamstring     | 2            |
      | Oct 2023    | Ankle         | 0            |
      | Sep 2022    | Shoulder      | 3            |
    And recurring injury patterns are noted

  @injury @impact
  Scenario: Display injury impact on projections
    Given a player is listed as Questionable
    When viewing projections
    Then projection accounts for injury:
      | If Active   | 18.5 points |
      | If Limited  | 14.2 points |
      | If Out      | 0 points    |
    And probability of playing is estimated

  @injury @report
  Scenario: Display team injury report
    Given multiple players on a team have injuries
    When viewing team injury report
    Then all injured players are listed:
      | Player        | Position | Status      | Injury    |
      | Davante Adams | WR       | Questionable| Hamstring |
      | Josh Jacobs   | RB       | Probable    | Shoulder  |
    And report is updated from official sources

  # ============================================
  # SNAP COUNTS
  # ============================================

  @snaps @percentage
  Scenario: Display snap count percentage
    Given the user views "Amon-Ra St. Brown"
    When viewing snap count data
    Then snap percentages are shown:
      | Metric            | Value |
      | Offensive Snaps % | 92%   |
      | Route Participation| 88%   |
      | Red Zone Snaps %  | 85%   |
    And trend over recent weeks is displayed

  @snaps @weekly
  Scenario: Display weekly snap count trends
    Given snap data is available weekly
    When viewing snap count trend
    Then a chart shows snap % by week:
      | Week | Total Snaps | Snap % | Routes Run |
      | 17   | 65          | 95%    | 42         |
      | 16   | 58          | 88%    | 38         |
      | 15   | 62          | 92%    | 40         |
    And significant changes are highlighted

  @snaps @comparison
  Scenario: Compare snap counts to backfield/position group
    Given RB snap shares matter for fantasy
    When viewing "James Cook" snap data
    Then comparison to teammates is shown:
      | Player      | Snap Share | Opportunity Share |
      | James Cook  | 62%        | 58%               |
      | Ray Davis   | 35%        | 38%               |
      | Other       | 3%         | 4%                |
    And trends in share are indicated

  # ============================================
  # TARGET SHARE METRICS
  # ============================================

  @targets @share
  Scenario: Display target share percentage
    Given the user views "Tyreek Hill"
    When viewing target share data
    Then target metrics are displayed:
      | Metric            | Value | Team Rank |
      | Target Share      | 28.5% | 1st       |
      | Air Yards Share   | 32.1% | 1st       |
      | Red Zone Targets  | 22%   | 2nd       |
      | Deep Targets (20+)| 18    | 1st       |

  @targets @trend
  Scenario: Display target share trend
    Given target share can fluctuate
    When viewing target trend chart
    Then weekly target share is displayed:
      | Week | Targets | Team Total | Share  |
      | 17   | 12      | 38         | 31.6%  |
      | 16   | 8       | 35         | 22.9%  |
      | 15   | 11      | 42         | 26.2%  |
    And average and trend line are shown

  @targets @air-yards
  Scenario: Display air yards and aDOT
    Given advanced receiving metrics are available
    When viewing air yards data
    Then metrics include:
      | Metric              | Value |
      | Total Air Yards     | 1,245 |
      | Average Depth (aDOT)| 10.8  |
      | Air Yards Share     | 32%   |
      | RACR (YAC/Air)      | 1.15  |
    And comparison to position average is shown

  @targets @quality
  Scenario: Display target quality metrics
    Given target quality affects production
    When viewing target quality
    Then quality indicators are shown:
      | Metric              | Value | Rating    |
      | Catchable Target %  | 78%   | Above Avg |
      | Contested Catch %   | 12%   | Average   |
      | Wide Open Target %  | 35%   | Elite     |

  # ============================================
  # HISTORICAL COMPARISONS
  # ============================================

  @historical @career
  Scenario: Display career statistics
    Given the user views a veteran player
    When viewing career stats
    Then career totals are displayed:
      | Season | Games | Yards | TDs | Fantasy Pts |
      | 2024   | 17    | 4,839 | 41  | 389.5       |
      | 2023   | 16    | 4,183 | 27  | 312.2       |
      | 2022   | 17    | 5,250 | 41  | 405.8       |
    And career totals and averages are shown

  @historical @compare-players
  Scenario: Compare two players head-to-head
    Given the user wants to compare players
    When comparing "Josh Allen" vs "Patrick Mahomes"
    Then side-by-side comparison shows:
      | Stat          | Allen  | Mahomes |
      | Fantasy Pts   | 412.5  | 389.5   |
      | Passing Yards | 4,306  | 4,839   |
      | Passing TDs   | 37     | 41      |
      | Rushing Yards | 531    | 389     |
    And differences are highlighted
    And "Add to Comparison" for more players is available

  @historical @era-adjusted
  Scenario: Display era-adjusted statistics
    Given comparing across seasons has context
    When viewing era-adjusted stats
    Then stats are normalized to league averages:
      | Season | Raw Fantasy Pts | Era-Adjusted | vs Avg |
      | 2024   | 389.5           | 385.2        | +22%   |
      | 2020   | 376.2           | 398.5        | +18%   |
    And methodology is explained

  @historical @pace
  Scenario: Display on-pace projections
    Given the season is partially complete
    When viewing pace statistics
    Then full-season pace is calculated:
      | Current (12 games) | Pace (17 games) |
      | 2,850 passing yds  | 4,038 yards     |
      | 24 TDs             | 34 TDs          |
      | 285 fantasy pts    | 404 points      |

  # ============================================
  # FILTERING AND SORTING
  # ============================================

  @filter @position
  Scenario: Filter players by position
    Given the player list is displayed
    When selecting "WR" position filter
    Then only wide receivers are shown
    And filter chip indicates active filter
    And count shows "142 WRs"

  @filter @team
  Scenario: Filter players by NFL team
    Given the user wants players from one team
    When selecting "Kansas City Chiefs"
    Then only Chiefs players are displayed
    And team logo is shown in filter
    And all positions on team are included

  @filter @availability
  Scenario: Filter by fantasy availability
    Given the user is in a league
    When filtering to "Available Players"
    Then rostered players are hidden
    And waiver wire players are shown
    And "On Waivers" vs "Free Agent" is indicated

  @filter @stats-threshold
  Scenario: Filter by statistical threshold
    Given the user wants productive players
    When filtering "Fantasy Points > 150"
    Then only players above threshold appear
    And threshold can be adjusted with slider
    And multiple stat filters can combine

  @sort @column
  Scenario: Sort players by any column
    Given a player table is displayed
    When clicking "Fantasy Pts" column header
    Then players are sorted by fantasy points descending
    And clicking again reverses to ascending
    And sort indicator shows current sort

  @sort @multiple
  Scenario: Apply secondary sort
    Given players are sorted by position
    When adding secondary sort by fantasy points
    Then players are grouped by position
    And within each position, sorted by points
    And sort order is displayed

  # ============================================
  # SEARCH FUNCTIONALITY
  # ============================================

  @search @name
  Scenario: Search players by name
    Given the search box is focused
    When typing "Maham"
    Then autocomplete suggests "Patrick Mahomes"
    And results filter as user types
    And search is case-insensitive

  @search @team
  Scenario: Search players by team name
    Given the user searches by team
    When typing "Chiefs"
    Then all Chiefs players appear
    And team name matches are indicated
    And city names also work ("Kansas City")

  @search @position
  Scenario: Search with position qualifier
    Given the user wants specific position
    When typing "QB Allen"
    Then Josh Allen (QB) appears first
    And other Allens appear below
    And position prefix filters results

  @search @fuzzy
  Scenario: Handle fuzzy/typo search
    Given the user misspells a name
    When typing "Mahommes" (extra m)
    Then "Patrick Mahomes" is still found
    And "Did you mean..." suggestion may appear
    And common misspellings are handled

  @search @recent
  Scenario: Display recent searches
    Given the user has searched before
    When clicking on search box
    Then recent searches are displayed
    And clicking a recent search executes it
    And clear history option is available

  # ============================================
  # RESPONSIVE DESIGN
  # ============================================

  @responsive @mobile
  Scenario: Display dashboard on mobile device
    Given the user is on a mobile device (<768px)
    When viewing the player statistics dashboard
    Then a mobile-optimized layout is shown
    And tables become scrollable cards
    And charts resize appropriately
    And key stats are prioritized

  @responsive @tablet
  Scenario: Display dashboard on tablet
    Given the user is on a tablet (768-1024px)
    When viewing the dashboard
    Then a hybrid layout is used
    And side panels may collapse
    And touch interactions work well

  @responsive @desktop
  Scenario: Display full dashboard on desktop
    Given the user is on desktop (>1024px)
    When viewing the dashboard
    Then full multi-panel layout is shown
    And all sections visible simultaneously
    And hover interactions enhance experience

  @responsive @chart-sizing
  Scenario: Charts resize responsively
    Given the viewport size changes
    When charts are displayed
    Then charts resize to fit container
    And data points remain readable
    And legends adjust positioning

  @responsive @table-scroll
  Scenario: Tables scroll horizontally on mobile
    Given a stats table has many columns
    When viewing on mobile
    Then table scrolls horizontally
    And player name column is sticky/fixed
    And scroll indicator shows more data

  # ============================================
  # DATA REFRESH AND LOADING
  # ============================================

  @loading @initial
  Scenario: Display loading state for data
    Given player data is being fetched
    When the dashboard is loading
    Then skeleton loaders show content shape
    And loading spinner is visible
    And "Loading player data..." message shows

  @loading @refresh
  Scenario: Refresh data on demand
    Given data may be stale
    When clicking "Refresh Data"
    Then new data is fetched
    And last updated timestamp updates
    And changes are highlighted briefly

  @loading @live
  Scenario: Display live game updates
    Given a game is in progress
    When viewing a player in an active game
    Then stats update in real-time
    And "LIVE" indicator is shown
    And update frequency is every 30 seconds

  @loading @cache
  Scenario: Use cached data when offline
    Given the user loses connection
    When viewing the dashboard
    Then cached data is displayed
    And "Offline - showing cached data" message appears
    And refresh attempts when connection returns

  # ============================================
  # EXPORT AND SHARE
  # ============================================

  @export @csv
  Scenario: Export stats to CSV
    Given the user wants to analyze externally
    When clicking "Export to CSV"
    Then a CSV file downloads
    And all displayed columns are included
    And current filters are applied to export

  @export @image
  Scenario: Export chart as image
    Given a chart is displayed
    When clicking "Save as Image"
    Then PNG/JPG of the chart downloads
    And image includes title and legend
    And resolution is suitable for sharing

  @share @player-card
  Scenario: Share player stats card
    Given the user wants to share stats
    When clicking "Share"
    Then options include: Copy Link, Twitter, Facebook
    And a shareable card image is generated
    And link opens the player's stats page

  # ============================================
  # ACCESSIBILITY
  # ============================================

  @accessibility @screen-reader
  Scenario: Support screen reader navigation
    Given the user uses a screen reader
    When navigating the dashboard
    Then all stats have proper labels
    And charts have text alternatives
    And data tables are properly structured

  @accessibility @keyboard
  Scenario: Full keyboard navigation
    Given the user navigates with keyboard
    When using tab and arrow keys
    Then all elements are focusable
    And focus indicators are visible
    And interactive elements respond to Enter/Space

  @accessibility @contrast
  Scenario: Maintain color contrast
    Given stats use various colors
    When viewing the dashboard
    Then all text meets WCAG AA standards
    And color is not sole indicator
    And high contrast mode is available
