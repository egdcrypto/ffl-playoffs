@stats @anima-1406
Feature: Stats
  As a fantasy football user
  I want comprehensive statistics capabilities
  So that I can analyze performance and make informed decisions

  Background:
    Given I am a logged-in user
    And the stats system is available

  # ============================================================================
  # STATS OVERVIEW
  # ============================================================================

  @happy-path @stats-overview
  Scenario: View stats dashboard
    Given stats exist
    When I view stats dashboard
    Then I should see dashboard
    And key metrics should be displayed

  @happy-path @stats-overview
  Scenario: View key statistics
    Given key stats are tracked
    When I view key stats
    Then I should see important statistics
    And they should be highlighted

  @happy-path @stats-overview
  Scenario: View performance summary
    Given performance data exists
    When I view summary
    Then I should see performance summary
    And trends should be visible

  @happy-path @stats-overview
  Scenario: View stats snapshot
    Given current stats exist
    When I view snapshot
    Then I should see current state
    And it should be quick to read

  @happy-path @stats-overview
  Scenario: View quick stats
    Given I want fast info
    When I view quick stats
    Then I should see essential stats
    And they should be concise

  @happy-path @stats-overview
  Scenario: Customize stats dashboard
    Given customization is available
    When I customize dashboard
    Then preferences should be saved
    And dashboard should reflect them

  @happy-path @stats-overview
  Scenario: Refresh stats
    Given stats may have changed
    When I refresh stats
    Then stats should update
    And latest data should show

  @happy-path @stats-overview
  Scenario: View stats on mobile
    Given I am on mobile
    When I view stats
    Then display should be mobile-friendly
    And all stats should be accessible

  @happy-path @stats-overview
  Scenario: Filter stats by category
    Given categories exist
    When I filter by category
    Then I should see category stats
    And others should be hidden

  @happy-path @stats-overview
  Scenario: View stats help
    Given help is available
    When I view help
    Then I should see stat explanations
    And formulas should be shown

  # ============================================================================
  # PLAYER STATS
  # ============================================================================

  @happy-path @player-stats
  Scenario: View player statistics
    Given player has stats
    When I view player stats
    Then I should see all player stats
    And they should be comprehensive

  @happy-path @player-stats
  Scenario: View individual stats
    Given player exists
    When I view individual stats
    Then I should see their stats
    And breakdown should be shown

  @happy-path @player-stats
  Scenario: View player performance
    Given player has performed
    When I view performance
    Then I should see performance metrics
    And trends should be visible

  @happy-path @player-stats
  Scenario: View stat leaders
    Given leaders are tracked
    When I view leaders
    Then I should see top performers
    And rankings should be shown

  @happy-path @player-stats
  Scenario: View player rankings
    Given rankings exist
    When I view rankings
    Then I should see player rankings
    And position should be shown

  @happy-path @player-stats
  Scenario: View position stats
    Given positions are tracked
    When I filter by position
    Then I should see position stats
    And comparisons should be available

  @happy-path @player-stats
  Scenario: View player game log
    Given player has games
    When I view game log
    Then I should see game-by-game stats
    And dates should be shown

  @happy-path @player-stats
  Scenario: View player averages
    Given player has history
    When I view averages
    Then I should see average stats
    And calculations should be accurate

  @happy-path @player-stats
  Scenario: View player highs/lows
    Given player has range
    When I view highs and lows
    Then I should see extremes
    And context should be provided

  @happy-path @player-stats
  Scenario: Search player stats
    Given many players exist
    When I search player
    Then I should find their stats
    And results should be quick

  # ============================================================================
  # TEAM STATS
  # ============================================================================

  @happy-path @team-stats
  Scenario: View team statistics
    Given team has stats
    When I view team stats
    Then I should see all team stats
    And they should be comprehensive

  @happy-path @team-stats
  Scenario: View team performance
    Given team has performed
    When I view performance
    Then I should see team performance
    And trends should be visible

  @happy-path @team-stats
  Scenario: View team rankings
    Given rankings exist
    When I view team rankings
    Then I should see team rankings
    And league position should be shown

  @happy-path @team-stats
  Scenario: View team comparisons
    Given multiple teams exist
    When I compare teams
    Then I should see comparison
    And differences should be highlighted

  @happy-path @team-stats
  Scenario: View roster stats
    Given roster has players
    When I view roster stats
    Then I should see all player stats
    And totals should be shown

  @happy-path @team-stats
  Scenario: View team scoring breakdown
    Given team has scored
    When I view breakdown
    Then I should see scoring sources
    And contributions should be clear

  @happy-path @team-stats
  Scenario: View team weekly stats
    Given weeks have passed
    When I view weekly stats
    Then I should see week-by-week
    And progression should be visible

  @happy-path @team-stats
  Scenario: View team strength
    Given strength is calculated
    When I view strength
    Then I should see team strength
    And factors should be shown

  @happy-path @team-stats
  Scenario: View bench stats
    Given bench has players
    When I view bench stats
    Then I should see bench production
    And potential should be shown

  @happy-path @team-stats
  Scenario: View team efficiency
    Given efficiency is tracked
    When I view efficiency
    Then I should see efficiency metrics
    And optimization should be suggested

  # ============================================================================
  # LEAGUE STATS
  # ============================================================================

  @happy-path @league-stats
  Scenario: View league statistics
    Given league has stats
    When I view league stats
    Then I should see league-wide stats
    And they should be comprehensive

  @happy-path @league-stats
  Scenario: View league leaders
    Given leaders are tracked
    When I view league leaders
    Then I should see top performers
    And categories should be shown

  @happy-path @league-stats
  Scenario: View league averages
    Given averages are calculated
    When I view averages
    Then I should see league averages
    And I can compare to them

  @happy-path @league-stats
  Scenario: View league records
    Given records are tracked
    When I view records
    Then I should see league records
    And record holders should be shown

  @happy-path @league-stats
  Scenario: View league trends
    Given trends are tracked
    When I view trends
    Then I should see league trends
    And patterns should be visible

  @happy-path @league-stats
  Scenario: View scoring distribution
    Given scoring varies
    When I view distribution
    Then I should see score distribution
    And ranges should be shown

  @happy-path @league-stats
  Scenario: View league activity
    Given activity is tracked
    When I view activity
    Then I should see league activity
    And engagement should be shown

  @happy-path @league-stats
  Scenario: View most owned players
    Given ownership is tracked
    When I view most owned
    Then I should see popular players
    And percentages should be shown

  @happy-path @league-stats
  Scenario: View transaction leaders
    Given transactions are tracked
    When I view transaction leaders
    Then I should see most active teams
    And counts should be shown

  @happy-path @league-stats
  Scenario: View league power rankings
    Given power rankings exist
    When I view power rankings
    Then I should see rankings
    And methodology should be explained

  # ============================================================================
  # WEEKLY STATS
  # ============================================================================

  @happy-path @weekly-stats
  Scenario: View weekly performance
    Given week has completed
    When I view weekly performance
    Then I should see weekly stats
    And all players should be included

  @happy-path @weekly-stats
  Scenario: View week-over-week
    Given multiple weeks exist
    When I view week-over-week
    Then I should see comparison
    And changes should be highlighted

  @happy-path @weekly-stats
  Scenario: View weekly leaders
    Given week has leaders
    When I view weekly leaders
    Then I should see top performers
    And scores should be shown

  @happy-path @weekly-stats
  Scenario: View weekly recap
    Given week completed
    When I view recap
    Then I should see week summary
    And highlights should be shown

  @happy-path @weekly-stats
  Scenario: View game stats
    Given games were played
    When I view game stats
    Then I should see individual game stats
    And details should be comprehensive

  @happy-path @weekly-stats
  Scenario: View weekly matchup stats
    Given matchup completed
    When I view matchup stats
    Then I should see both teams' stats
    And winner should be clear

  @happy-path @weekly-stats
  Scenario: View weekly position breakdown
    Given positions scored
    When I view position breakdown
    Then I should see by-position stats
    And comparisons should be available

  @happy-path @weekly-stats
  Scenario: View weekly highs
    Given week has extremes
    When I view weekly highs
    Then I should see best performances
    And they should be celebrated

  @happy-path @weekly-stats
  Scenario: View weekly lows
    Given week has extremes
    When I view weekly lows
    Then I should see worst performances
    And context should be provided

  @happy-path @weekly-stats
  Scenario: Compare to weekly average
    Given averages exist
    When I compare to average
    Then I should see comparison
    And deviation should be shown

  # ============================================================================
  # SEASON STATS
  # ============================================================================

  @happy-path @season-stats
  Scenario: View season totals
    Given season is ongoing
    When I view season totals
    Then I should see cumulative stats
    And all categories should be shown

  @happy-path @season-stats
  Scenario: View season averages
    Given season has games
    When I view season averages
    Then I should see averages per game
    And calculations should be accurate

  @happy-path @season-stats
  Scenario: View season leaders
    Given season has leaders
    When I view season leaders
    Then I should see top performers
    And rankings should be shown

  @happy-path @season-stats
  Scenario: View season records
    Given records are tracked
    When I view season records
    Then I should see season records
    And record holders should be shown

  @happy-path @season-stats
  Scenario: View cumulative stats
    Given stats accumulate
    When I view cumulative
    Then I should see running totals
    And growth should be visible

  @happy-path @season-stats
  Scenario: View season progression
    Given season has progressed
    When I view progression
    Then I should see week-by-week progression
    And trends should be visible

  @happy-path @season-stats
  Scenario: View playoff stats
    Given playoffs have started
    When I view playoff stats
    Then I should see playoff-only stats
    And they should be separate

  @happy-path @season-stats
  Scenario: View regular season stats
    Given regular season exists
    When I view regular season
    Then I should see regular season stats
    And playoffs should be excluded

  @happy-path @season-stats
  Scenario: Compare seasons
    Given multiple seasons exist
    When I compare seasons
    Then I should see comparison
    And differences should be highlighted

  @happy-path @season-stats
  Scenario: View season summary
    Given season data exists
    When I view summary
    Then I should see season overview
    And key moments should be highlighted

  # ============================================================================
  # STATS COMPARISON
  # ============================================================================

  @happy-path @stats-comparison
  Scenario: Compare players
    Given players exist
    When I compare players
    Then I should see comparison
    And stats should be side-by-side

  @happy-path @stats-comparison
  Scenario: Compare teams
    Given teams exist
    When I compare teams
    Then I should see comparison
    And differences should be shown

  @happy-path @stats-comparison
  Scenario: View side-by-side stats
    Given comparison is ready
    When I view side-by-side
    Then stats should be aligned
    And differences should be clear

  @happy-path @stats-comparison
  Scenario: View head-to-head
    Given history exists
    When I view head-to-head
    Then I should see H2H record
    And historical matchups should be shown

  @happy-path @stats-comparison
  Scenario: View stat differentials
    Given comparison exists
    When I view differentials
    Then I should see differences
    And advantages should be highlighted

  @happy-path @stats-comparison
  Scenario: Compare multiple players
    Given I want multi-compare
    When I add players
    Then I should see all compared
    And I can add more

  @happy-path @stats-comparison
  Scenario: Compare by position
    Given position exists
    When I compare by position
    Then I should see position comparison
    And rankings should be shown

  @happy-path @stats-comparison
  Scenario: Compare to league average
    Given averages exist
    When I compare to average
    Then I should see comparison
    And deviation should be shown

  @happy-path @stats-comparison
  Scenario: Save comparison
    Given comparison is useful
    When I save comparison
    Then comparison should be saved
    And I can access later

  @happy-path @stats-comparison
  Scenario: Share comparison
    Given comparison exists
    When I share comparison
    Then shareable link should be created
    And others can view

  # ============================================================================
  # STATS HISTORY
  # ============================================================================

  @happy-path @stats-history
  Scenario: View historical stats
    Given history exists
    When I view historical
    Then I should see past stats
    And they should be comprehensive

  @happy-path @stats-history
  Scenario: View past performance
    Given past data exists
    When I view past performance
    Then I should see historical performance
    And trends should be visible

  @happy-path @stats-history
  Scenario: View career stats
    Given career data exists
    When I view career stats
    Then I should see career totals
    And milestones should be shown

  @happy-path @stats-history
  Scenario: View stat trends
    Given trends exist
    When I view trends
    Then I should see stat trends
    And direction should be clear

  @happy-path @stats-history
  Scenario: View year-over-year
    Given multiple years exist
    When I view year-over-year
    Then I should see yearly comparison
    And growth should be visible

  @happy-path @stats-history
  Scenario: Search stat history
    Given history is extensive
    When I search history
    Then I should find matches
    And results should be relevant

  @happy-path @stats-history
  Scenario: Filter history by date
    Given dates vary
    When I filter by date
    Then I should see date range
    And only matching should show

  @happy-path @stats-history
  Scenario: View record progression
    Given records have changed
    When I view progression
    Then I should see record evolution
    And holders should be shown

  @happy-path @stats-history
  Scenario: View all-time leaders
    Given all-time data exists
    When I view all-time
    Then I should see all-time leaders
    And records should be shown

  @happy-path @stats-history
  Scenario: Archive stats
    Given stats should be preserved
    When I archive stats
    Then stats should be archived
    And they should be accessible

  # ============================================================================
  # STATS EXPORT
  # ============================================================================

  @happy-path @stats-export
  Scenario: Export stats
    Given stats exist
    When I export stats
    Then export file should be created
    And data should be complete

  @happy-path @stats-export
  Scenario: Download reports
    Given reports exist
    When I download report
    Then file should be downloaded
    And format should be correct

  @happy-path @stats-export
  Scenario: Share stats
    Given stats exist
    When I share stats
    Then shareable link should be created
    And others can view

  @happy-path @stats-export
  Scenario: Print stats
    Given stats are displayed
    When I print stats
    Then printable version should open
    And formatting should be clean

  @happy-path @stats-export
  Scenario: Export to spreadsheet
    Given stats exist
    When I export to spreadsheet
    Then spreadsheet should be created
    And data should be formatted

  @happy-path @stats-export
  Scenario: Export to PDF
    Given stats exist
    When I export to PDF
    Then PDF should be created
    And layout should be proper

  @happy-path @stats-export
  Scenario: Schedule stat exports
    Given scheduling is available
    When I schedule export
    Then schedule should be saved
    And exports should be sent

  @happy-path @stats-export
  Scenario: Email stats
    Given stats exist
    When I email stats
    Then email should be sent
    And stats should be included

  @happy-path @stats-export
  Scenario: Export filtered stats
    Given filters are applied
    When I export filtered
    Then export should match filters
    And only filtered should be included

  @happy-path @stats-export
  Scenario: Export comparison
    Given comparison exists
    When I export comparison
    Then comparison should be exported
    And format should be readable

  # ============================================================================
  # STATS PROJECTIONS
  # ============================================================================

  @happy-path @stats-projections
  Scenario: View projected stats
    Given projections exist
    When I view projections
    Then I should see projected stats
    And they should be reasonable

  @happy-path @stats-projections
  Scenario: View stat forecasts
    Given forecasts are available
    When I view forecasts
    Then I should see forecasts
    And confidence should be shown

  @happy-path @stats-projections
  Scenario: View rest-of-season projections
    Given season is ongoing
    When I view ROS projections
    Then I should see remaining projections
    And factors should be considered

  @happy-path @stats-projections
  Scenario: View weekly projections
    Given week is upcoming
    When I view weekly projections
    Then I should see week projections
    And matchups should be factored

  @happy-path @stats-projections
  Scenario: View stat predictions
    Given predictions are available
    When I view predictions
    Then I should see predicted stats
    And basis should be explained

  @happy-path @stats-projections
  Scenario: Compare projections to actual
    Given actuals exist
    When I compare to projections
    Then I should see comparison
    And accuracy should be shown

  @happy-path @stats-projections
  Scenario: View projection sources
    Given multiple sources exist
    When I view sources
    Then I should see all sources
    And I can choose preference

  @happy-path @stats-projections
  Scenario: Customize projection settings
    Given settings exist
    When I customize projections
    Then settings should be saved
    And projections should adjust

  @happy-path @stats-projections
  Scenario: View projection history
    Given past projections exist
    When I view projection history
    Then I should see past projections
    And accuracy should be tracked

  @happy-path @stats-projections
  Scenario: Export projections
    Given projections exist
    When I export projections
    Then export file should be created
    And data should be complete

