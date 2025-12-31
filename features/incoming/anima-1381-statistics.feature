@statistics @anima-1381
Feature: Statistics
  As a fantasy football user
  I want comprehensive statistical data and analysis
  So that I can evaluate players, teams, and make informed decisions

  Background:
    Given I am a logged-in user
    And the statistics system is available

  # ============================================================================
  # PLAYER STATISTICS
  # ============================================================================

  @happy-path @player-statistics
  Scenario: View individual stats
    Given I am viewing a player
    When I access their statistics
    Then I should see individual stats
    And stats should be current

  @happy-path @player-statistics
  Scenario: View season stats
    Given I am viewing a player
    When I view season stats
    Then I should see full season statistics
    And stats should be cumulative

  @happy-path @player-statistics
  Scenario: View career stats
    Given a player has career history
    When I view career stats
    Then I should see career totals
    And year-by-year breakdown should be available

  @happy-path @player-statistics
  Scenario: View game logs
    Given a player has played games
    When I view game logs
    Then I should see game-by-game stats
    And logs should be chronological

  @happy-path @player-statistics
  Scenario: View weekly breakdowns
    Given a player has weekly data
    When I view weekly breakdown
    Then I should see stats by week
    And I can compare weeks

  @happy-path @player-statistics
  Scenario: View player stats by opponent
    Given a player has faced multiple opponents
    When I view opponent splits
    Then I should see stats by opponent
    And matchup tendencies should be visible

  @happy-path @player-statistics
  Scenario: View home vs away stats
    Given a player has home and away games
    When I view home/away splits
    Then I should see split statistics
    And differences should be highlighted

  @happy-path @player-statistics
  Scenario: View red zone stats
    Given red zone stats exist
    When I view red zone statistics
    Then I should see red zone performance
    And TD efficiency should be shown

  @happy-path @player-statistics
  Scenario: View fantasy points breakdown
    Given fantasy scoring applies
    When I view fantasy breakdown
    Then I should see points by category
    And scoring should be itemized

  @mobile @player-statistics
  Scenario: View player stats on mobile
    Given I am on a mobile device
    When I view player statistics
    Then stats should be mobile-friendly
    And I should be able to scroll easily

  # ============================================================================
  # TEAM STATISTICS
  # ============================================================================

  @happy-path @team-statistics
  Scenario: View team stats
    Given I select an NFL team
    When I view team statistics
    Then I should see team-level stats
    And stats should be comprehensive

  @happy-path @team-statistics
  Scenario: View offensive stats
    Given a team has offense
    When I view offensive stats
    Then I should see offensive statistics
    And passing/rushing should be shown

  @happy-path @team-statistics
  Scenario: View defensive stats
    Given a team has defense
    When I view defensive stats
    Then I should see defensive statistics
    And points allowed should be shown

  @happy-path @team-statistics
  Scenario: View league stats
    Given league statistics exist
    When I view league stats
    Then I should see league-wide statistics
    And averages should be shown

  @happy-path @team-statistics
  Scenario: View unit performance
    Given team units are tracked
    When I view unit performance
    Then I should see unit-specific stats
    And rankings should be shown

  @happy-path @team-statistics
  Scenario: View team rankings
    Given teams are ranked by stats
    When I view team rankings
    Then I should see where team ranks
    And category rankings should be shown

  @happy-path @team-statistics
  Scenario: View opponent stats allowed
    Given opponent data exists
    When I view stats allowed
    Then I should see what teams allow
    And fantasy points allowed should be shown

  @happy-path @team-statistics
  Scenario: View team situational stats
    Given situational data exists
    When I view situational stats
    Then I should see third down, red zone stats
    And efficiency should be shown

  @happy-path @team-statistics
  Scenario: Compare team stats
    Given multiple teams exist
    When I compare team stats
    Then I should see side-by-side comparison
    And differences should be highlighted

  @happy-path @team-statistics
  Scenario: View team stats by quarter
    Given quarter splits exist
    When I view by quarter
    Then I should see quarter-by-quarter stats
    And patterns should be visible

  # ============================================================================
  # LEAGUE STATISTICS
  # ============================================================================

  @happy-path @league-statistics
  Scenario: View league-wide stats
    Given I am in a fantasy league
    When I view league statistics
    Then I should see league-wide data
    And all teams should be included

  @happy-path @league-statistics
  Scenario: View scoring leaders
    Given teams have scored
    When I view scoring leaders
    Then I should see top scorers
    And points should be ranked

  @happy-path @league-statistics
  Scenario: View category leaders
    Given categories are tracked
    When I view category leaders
    Then I should see leaders by category
    And each category should be shown

  @happy-path @league-statistics
  Scenario: View league averages
    Given averages are calculated
    When I view league averages
    Then I should see average statistics
    And I can compare to averages

  @happy-path @league-statistics
  Scenario: View league records
    Given records exist
    When I view league records
    Then I should see record holders
    And records should be categorized

  @happy-path @league-statistics
  Scenario: View transaction statistics
    Given transactions occur
    When I view transaction stats
    Then I should see transaction activity
    And most active teams should be shown

  @happy-path @league-statistics
  Scenario: View head-to-head stats
    Given matchups have occurred
    When I view H2H stats
    Then I should see all-time records
    And rivalries should be visible

  @happy-path @league-statistics
  Scenario: View playoff statistics
    Given playoffs have occurred
    When I view playoff stats
    Then I should see playoff performance
    And championship data should be shown

  @happy-path @league-statistics
  Scenario: View weekly league stats
    Given weeks have completed
    When I view weekly stats
    Then I should see week-by-week league data
    And trends should be visible

  @happy-path @league-statistics
  Scenario: View historical league stats
    Given league has history
    When I view historical stats
    Then I should see past season data
    And I can select any season

  # ============================================================================
  # STAT CATEGORIES
  # ============================================================================

  @happy-path @stat-categories
  Scenario: View passing stats
    Given passing stats exist
    When I view passing statistics
    Then I should see completions, yards, TDs
    And QB rating should be shown

  @happy-path @stat-categories
  Scenario: View rushing stats
    Given rushing stats exist
    When I view rushing statistics
    Then I should see carries, yards, TDs
    And yards per carry should be shown

  @happy-path @stat-categories
  Scenario: View receiving stats
    Given receiving stats exist
    When I view receiving statistics
    Then I should see targets, receptions, yards
    And catch rate should be shown

  @happy-path @stat-categories
  Scenario: View special teams stats
    Given special teams stats exist
    When I view special teams statistics
    Then I should see return yards, FGs
    And kick/punt data should be shown

  @happy-path @stat-categories
  Scenario: View defensive stats
    Given defensive stats exist
    When I view defensive statistics
    Then I should see sacks, interceptions
    And team defense stats should be shown

  @happy-path @stat-categories
  Scenario: View IDP stats
    Given IDP stats exist
    When I view IDP statistics
    Then I should see individual defensive stats
    And tackles, sacks should be detailed

  @happy-path @stat-categories
  Scenario: Filter stats by category
    Given I want specific categories
    When I filter by category
    Then I should see only that category
    And filter should be clearable

  @happy-path @stat-categories
  Scenario: View combined statistics
    Given multiple categories exist
    When I view combined stats
    Then I should see all categories together
    And total production should be shown

  @happy-path @stat-categories
  Scenario: View kicker statistics
    Given kicker stats exist
    When I view kicker stats
    Then I should see FG attempts, makes
    And accuracy should be shown

  @happy-path @stat-categories
  Scenario: View fumble statistics
    Given fumble data exists
    When I view fumble stats
    Then I should see fumbles, lost fumbles
    And recovery data should be shown

  # ============================================================================
  # STATISTICAL TRENDS
  # ============================================================================

  @happy-path @statistical-trends
  Scenario: View trending stats
    Given stats are trending
    When I view trending statistics
    Then I should see what's trending
    And direction should be indicated

  @happy-path @statistical-trends
  Scenario: View week-over-week changes
    Given multiple weeks exist
    When I view WoW changes
    Then I should see changes by week
    And trends should be visualized

  @happy-path @statistical-trends
  Scenario: View historical trends
    Given historical data exists
    When I view historical trends
    Then I should see long-term trends
    And patterns should be identified

  @happy-path @statistical-trends
  Scenario: View momentum indicators
    Given momentum is tracked
    When I view momentum
    Then I should see player momentum
    And hot/cold streaks should be shown

  @happy-path @statistical-trends
  Scenario: View rolling averages
    Given rolling data exists
    When I view rolling averages
    Then I should see recent averages
    And window should be configurable

  @happy-path @statistical-trends
  Scenario: View usage trends
    Given usage is tracked
    When I view usage trends
    Then I should see target share, snap count trends
    And opportunity changes should be shown

  @happy-path @statistical-trends
  Scenario: View performance trajectory
    Given trajectory data exists
    When I view trajectory
    Then I should see performance direction
    And projections should be shown

  @happy-path @statistical-trends
  Scenario: Identify breakout trends
    Given breakouts occur
    When I identify breakouts
    Then I should see emerging players
    And supporting stats should be shown

  @happy-path @statistical-trends
  Scenario: View trend visualizations
    Given visualizations are available
    When I view trend charts
    Then I should see graphical trends
    And charts should be interactive

  @happy-path @statistical-trends
  Scenario: Set trend alerts
    Given I want trend notifications
    When I set trend alerts
    Then I should be notified of trends
    And thresholds should be configurable

  # ============================================================================
  # ADVANCED STATISTICS
  # ============================================================================

  @happy-path @advanced-statistics
  Scenario: View advanced metrics
    Given advanced metrics exist
    When I view advanced stats
    Then I should see advanced metrics
    And methodology should be explained

  @happy-path @advanced-statistics
  Scenario: View efficiency stats
    Given efficiency is calculated
    When I view efficiency stats
    Then I should see efficiency metrics
    And rankings should be shown

  @happy-path @advanced-statistics
  Scenario: View analytics dashboard
    Given analytics are available
    When I view analytics
    Then I should see comprehensive analytics
    And insights should be provided

  @happy-path @advanced-statistics
  Scenario: View expected points added
    Given EPA is calculated
    When I view EPA
    Then I should see EPA values
    And context should be provided

  @happy-path @advanced-statistics
  Scenario: View air yards stats
    Given air yards are tracked
    When I view air yards
    Then I should see air yards data
    And target depth should be shown

  @happy-path @advanced-statistics
  Scenario: View yards after catch
    Given YAC is tracked
    When I view YAC stats
    Then I should see YAC data
    And ability should be rated

  @happy-path @advanced-statistics
  Scenario: View success rate
    Given success rate is calculated
    When I view success rate
    Then I should see play success data
    And consistency should be shown

  @happy-path @advanced-statistics
  Scenario: View pressure stats
    Given pressure is tracked
    When I view pressure stats
    Then I should see pressure rate
    And QB performance under pressure should be shown

  @happy-path @advanced-statistics
  Scenario: View separation stats
    Given separation is tracked
    When I view separation
    Then I should see receiver separation
    And coverage data should be shown

  @happy-path @advanced-statistics
  Scenario: View explosive play stats
    Given explosive plays are tracked
    When I view explosive plays
    Then I should see big play data
    And rate should be calculated

  # ============================================================================
  # STAT COMPARISON
  # ============================================================================

  @happy-path @stat-comparison
  Scenario: Compare two players
    Given I select two players
    When I compare their stats
    Then I should see side-by-side comparison
    And differences should be highlighted

  @happy-path @stat-comparison
  Scenario: Compare multiple players
    Given I select multiple players
    When I compare stats
    Then I should see multi-player comparison
    And table should be sortable

  @happy-path @stat-comparison
  Scenario: Compare teams
    Given I select teams
    When I compare team stats
    Then I should see team comparison
    And matchup insights should be shown

  @happy-path @stat-comparison
  Scenario: View side-by-side stats
    Given I am comparing
    When I view side-by-side
    Then stats should be parallel
    And differences should be clear

  @happy-path @stat-comparison
  Scenario: Analyze matchup stats
    Given a matchup exists
    When I analyze matchup
    Then I should see relevant comparisons
    And advantages should be highlighted

  @happy-path @stat-comparison
  Scenario: Compare to league average
    Given averages exist
    When I compare to average
    Then I should see vs average comparison
    And above/below should be indicated

  @happy-path @stat-comparison
  Scenario: Compare across seasons
    Given multiple seasons exist
    When I compare seasons
    Then I should see cross-season comparison
    And changes should be highlighted

  @happy-path @stat-comparison
  Scenario: Save stat comparison
    Given I created a comparison
    When I save it
    Then comparison should be saved
    And I can access it later

  @happy-path @stat-comparison
  Scenario: Share stat comparison
    Given I created a comparison
    When I share it
    Then a shareable link should be generated
    And others can view the comparison

  @happy-path @stat-comparison
  Scenario: View comparison visualizations
    Given comparison exists
    When I view visualizations
    Then I should see graphical comparison
    And charts should be clear

  # ============================================================================
  # STAT LEADERS
  # ============================================================================

  @happy-path @stat-leaders
  Scenario: View leaderboards
    Given leaderboards exist
    When I view leaderboards
    Then I should see ranked leaders
    And categories should be available

  @happy-path @stat-leaders
  Scenario: View top performers
    Given games have been played
    When I view top performers
    Then I should see best performers
    And time period should be selectable

  @happy-path @stat-leaders
  Scenario: View category leaders
    Given categories are tracked
    When I view category leaders
    Then I should see leader by category
    And I can select any category

  @happy-path @stat-leaders
  Scenario: View rising stars
    Given players are emerging
    When I view rising stars
    Then I should see trending players
    And growth should be shown

  @happy-path @stat-leaders
  Scenario: Filter leaders by position
    Given I want position leaders
    When I filter by position
    Then I should see position leaders
    And filter should be clearable

  @happy-path @stat-leaders
  Scenario: View weekly leaders
    Given a week has completed
    When I view weekly leaders
    Then I should see that week's top performers
    And weekly rankings should be shown

  @happy-path @stat-leaders
  Scenario: View season leaders
    Given season is ongoing
    When I view season leaders
    Then I should see season-long leaders
    And cumulative stats should be shown

  @happy-path @stat-leaders
  Scenario: View fantasy points leaders
    Given fantasy points are scored
    When I view fantasy leaders
    Then I should see top fantasy scorers
    And format should be considered

  @happy-path @stat-leaders
  Scenario: View rookie leaders
    Given rookies are playing
    When I view rookie leaders
    Then I should see top rookies
    And rookie-only rankings should be shown

  @happy-path @stat-leaders
  Scenario: Track leader changes
    Given leaders change
    When I track leader changes
    Then I should see movement
    And new leaders should be highlighted

  # ============================================================================
  # STAT SEARCH
  # ============================================================================

  @happy-path @stat-search
  Scenario: Search statistics
    Given I want specific stats
    When I search stats
    Then I should find matching results
    And search should be fast

  @happy-path @stat-search
  Scenario: Filter by category
    Given categories exist
    When I filter by category
    Then I should see category-specific stats
    And filter should be clearable

  @happy-path @stat-search
  Scenario: Filter by player
    Given I want player stats
    When I filter by player
    Then I should see that player's stats
    And all categories should be shown

  @happy-path @stat-search
  Scenario: Filter by team
    Given I want team stats
    When I filter by team
    Then I should see that team's stats
    And roster should be included

  @happy-path @stat-search
  Scenario: Run custom queries
    Given I need specific data
    When I run custom query
    Then I should get custom results
    And query should be flexible

  @happy-path @stat-search
  Scenario: Filter by date range
    Given I want specific dates
    When I filter by date range
    Then I should see stats from that range
    And dates should be selectable

  @happy-path @stat-search
  Scenario: Use advanced filters
    Given I need precise results
    When I use advanced filters
    Then I should combine multiple criteria
    And results should be accurate

  @happy-path @stat-search
  Scenario: Save stat search
    Given I want to repeat a search
    When I save the search
    Then search should be saved
    And I can run it again

  @happy-path @stat-search
  Scenario: View search history
    Given I have searched before
    When I view search history
    Then I should see past searches
    And I can repeat any search

  @happy-path @stat-search
  Scenario: Clear search filters
    Given I have filters applied
    When I clear filters
    Then all filters should be removed
    And default view should return

  # ============================================================================
  # STAT EXPORT
  # ============================================================================

  @happy-path @stat-export
  Scenario: Export data to CSV
    Given I have stats to export
    When I export to CSV
    Then I should receive CSV file
    And data should be complete

  @happy-path @stat-export
  Scenario: Download statistics
    Given I want to download stats
    When I download statistics
    Then I should receive download
    And format should be selectable

  @happy-path @stat-export
  Scenario: Share statistics
    Given I want to share stats
    When I share statistics
    Then shareable link should be created
    And others can view stats

  @happy-path @stat-export
  Scenario: Access stats via API
    Given API access is available
    When I query stats API
    Then I should receive stat data
    And response should be formatted

  @happy-path @stat-export
  Scenario: Export to spreadsheet
    Given I want spreadsheet format
    When I export to Excel
    Then I should receive Excel file
    And formatting should be preserved

  @happy-path @stat-export
  Scenario: Export custom report
    Given I configured a report
    When I export the report
    Then I should receive report file
    And customizations should be included

  @happy-path @stat-export
  Scenario: Schedule automatic exports
    Given I need regular exports
    When I schedule exports
    Then exports should run on schedule
    And I should receive them automatically

  @happy-path @stat-export
  Scenario: Bulk download statistics
    Given I need lots of data
    When I bulk download
    Then I should receive large dataset
    And download should be efficient

  @happy-path @stat-export
  Scenario: Print statistics
    Given I want printed stats
    When I print statistics
    Then printable version should open
    And formatting should be clean

  @happy-path @stat-export
  Scenario: Copy stats to clipboard
    Given I want to copy stats
    When I copy to clipboard
    Then stats should be copied
    And I can paste elsewhere
