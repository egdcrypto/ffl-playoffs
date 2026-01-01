@player-stats
Feature: Player Stats
  As a fantasy football manager
  I want to access comprehensive player statistics
  So that I can evaluate player performance and make informed roster decisions

  Background:
    Given I am a registered user
    And I am logged into the platform
    And I have access to player stats functionality

  # --------------------------------------------------------------------------
  # Game Stats Scenarios
  # --------------------------------------------------------------------------
  @game-stats
  Scenario: View weekly stat lines
    Given games have been played
    When I access a player's weekly stats
    Then I should see their stat line for each game
    And all relevant categories should display
    And the corresponding fantasy points should show

  @game-stats
  Scenario: Access real-time scoring updates
    Given a game is currently in progress
    When I view live player stats
    Then I should see real-time stat updates
    And fantasy points should update as plays occur
    And the refresh should be automatic

  @game-stats
  Scenario: View play-by-play stats
    Given I want detailed game information
    When I access play-by-play stats
    Then I should see each play involving the player
    And yards gained per play should display
    And situation context should be provided

  @game-stats
  Scenario: Access game logs for the season
    Given I want to review all games
    When I view the game log
    Then I should see every game's stat line
    And games should be ordered chronologically
    And I can sort by any stat category

  @game-stats
  Scenario: View opponent-specific game stats
    Given matchups matter for analysis
    When I view stats by opponent
    Then I should see performance against each team
    And matchup difficulty should be indicated
    And I can identify favorable opponents

  @game-stats
  Scenario: Access home vs away game splits
    Given venue affects performance
    When I view home/away splits
    Then I should see separate stat totals
    And averages should calculate for each
    And I can compare the difference

  @game-stats
  Scenario: View game stats with weather context
    Given weather impacts performance
    When I view game stats with weather
    Then weather conditions should display
    And I can filter by weather type
    And weather impact should be analyzable

  @game-stats
  Scenario: Access primetime game stats
    Given some players perform differently in primetime
    When I view primetime splits
    Then I should see stats from primetime games
    And comparison to day games should show
    And primetime rating should calculate

  # --------------------------------------------------------------------------
  # Season Stats Scenarios
  # --------------------------------------------------------------------------
  @season-stats
  Scenario: View cumulative season totals
    Given the season is in progress
    When I access season totals
    Then I should see cumulative stats
    And all counting stats should sum
    And totals should be current

  @season-stats
  Scenario: Access per-game averages
    Given averages provide context
    When I view per-game averages
    Then I should see average stats per game
    And games played should factor correctly
    And I can compare to league averages

  @season-stats
  Scenario: View pace projections
    Given I want to project full season stats
    When I view pace projections
    Then I should see projected season totals
    And current pace should calculate correctly
    And games remaining should factor

  @season-stats
  Scenario: Access season stats by time period
    Given performance varies through season
    When I view stats by time period
    Then I should see stats for selected weeks
    And custom date ranges should work
    And I can compare periods

  @season-stats
  Scenario: View fantasy points per game
    Given fantasy scoring is the goal
    When I view fantasy PPG
    Then I should see average fantasy points
    And scoring format should be selectable
    And ranking should be included

  @season-stats
  Scenario: Access stats with bye week context
    Given bye weeks reduce games played
    When I view stats considering byes
    Then bye weeks should be clearly marked
    And averages should account for byes
    And season total projections should adjust

  @season-stats
  Scenario: View season highs and lows
    Given extremes show range of outcomes
    When I view highs and lows
    Then I should see best and worst games
    And the games should be identified
    And context should be provided

  @season-stats
  Scenario: Compare current season to projections
    Given preseason projections exist
    When I compare to projections
    Then I should see actual vs projected
    And variance should calculate
    And over/under performance should highlight

  # --------------------------------------------------------------------------
  # Career Stats Scenarios
  # --------------------------------------------------------------------------
  @career-stats
  Scenario: View historical performance data
    Given players have career history
    When I access career stats
    Then I should see all career statistics
    And stats should be broken down by season
    And career totals should sum correctly

  @career-stats
  Scenario: Track career milestones
    Given milestones mark achievements
    When I view career milestones
    Then I should see significant achievements
    And milestone dates should display
    And upcoming milestones should project

  @career-stats
  Scenario: Compare year-over-year performance
    Given trends matter for evaluation
    When I compare seasons
    Then I should see side-by-side comparison
    And improvement or decline should highlight
    And percentage changes should calculate

  @career-stats
  Scenario: View career trajectory analysis
    Given career arcs matter for dynasty
    When I view trajectory analysis
    Then I should see performance over time
    And peak performance should identify
    And future trajectory should project

  @career-stats
  Scenario: Access career stats by team
    Given players change teams
    When I view stats by team
    Then I should see performance with each team
    And I can compare across teams
    And transition periods should note

  @career-stats
  Scenario: View career fantasy point totals
    Given historical fantasy production matters
    When I view career fantasy totals
    Then I should see total fantasy points
    And I can view by scoring format
    And yearly breakdowns should show

  @career-stats
  Scenario: Track career rankings history
    Given positional rankings change yearly
    When I view ranking history
    Then I should see positional rank each year
    And overall rank should also show
    And ranking trends should visualize

  @career-stats
  Scenario: Access career playoff performance
    Given playoff performance is valued
    When I view playoff career stats
    Then I should see playoff-specific stats
    And comparison to regular season should show
    And clutch performance should analyze

  # --------------------------------------------------------------------------
  # Advanced Stats Scenarios
  # --------------------------------------------------------------------------
  @advanced-stats
  Scenario: View efficiency metrics
    Given efficiency indicates quality
    When I access efficiency stats
    Then I should see yards per attempt
    And yards per touch should display
    And efficiency rankings should show

  @advanced-stats
  Scenario: Access target share data
    Given targets drive receiving production
    When I view target share
    Then I should see target percentage
    And air yards share should display
    And target trends should visualize

  @advanced-stats
  Scenario: View snap count data
    Given snap counts indicate usage
    When I access snap counts
    Then I should see snap percentages
    And route participation should show for WRs
    And snap trends should display

  @advanced-stats
  Scenario: Access air yards metrics
    Given air yards measure opportunity
    When I view air yards data
    Then I should see total air yards
    And average depth of target should display
    And air yards conversion should calculate

  @advanced-stats
  Scenario: View red zone usage stats
    Given red zone means scoring chances
    When I access red zone stats
    Then I should see red zone targets and carries
    And red zone efficiency should calculate
    And goal line usage should display

  @advanced-stats
  Scenario: Access yards after catch data
    Given YAC shows receiver skill
    When I view YAC stats
    Then I should see yards after catch totals
    And YAC per reception should calculate
    And broken tackle data should include

  @advanced-stats
  Scenario: View pressure and sack rate for QBs
    Given QB protection affects performance
    When I access pressure stats
    Then I should see pressure rate
    And sack rate should display
    And performance under pressure should show

  @advanced-stats
  Scenario: Access route running data
    Given route types matter for analysis
    When I view route data
    Then I should see route distribution
    And success rate by route should display
    And route tree should visualize

  # --------------------------------------------------------------------------
  # Positional Stats Scenarios
  # --------------------------------------------------------------------------
  @positional-stats
  Scenario: View quarterback-specific metrics
    Given QBs have unique stats
    When I access QB stats
    Then I should see passing stats
    And completion percentage should display
    And QBR and passer rating should show

  @positional-stats
  Scenario: Access running back metrics
    Given RBs have specialized stats
    When I access RB stats
    Then I should see rushing and receiving
    And yards per carry should display
    And workload share should show

  @positional-stats
  Scenario: View wide receiver metrics
    Given WRs need receiving focus
    When I access WR stats
    Then I should see receiving stats
    And yards per reception should display
    And separation metrics should show

  @positional-stats
  Scenario: Access tight end metrics
    Given TEs have dual roles
    When I access TE stats
    Then I should see receiving stats
    And blocking grades should be available
    And route participation should display

  @positional-stats
  Scenario: View kicker statistics
    Given kickers have unique metrics
    When I access kicker stats
    Then I should see field goal stats
    And accuracy by distance should display
    And extra point stats should show

  @positional-stats
  Scenario: Access position-specific rankings
    Given rankings contextualize stats
    When I view positional rankings
    Then I should see rank at position
    And ranking by each stat should be available
    And percentile rankings should display

  @positional-stats
  Scenario: Compare players within position
    Given position comparison is valuable
    When I compare players at same position
    Then I should see side-by-side stats
    And advantages should highlight
    And overall comparison should summarize

  @positional-stats
  Scenario: View position benchmark comparisons
    Given benchmarks provide context
    When I compare to position averages
    Then I should see league averages
    And above/below average should indicate
    And elite thresholds should mark

  # --------------------------------------------------------------------------
  # Defensive Stats Scenarios
  # --------------------------------------------------------------------------
  @defensive-stats
  Scenario: View IDP scoring statistics
    Given IDP leagues need defensive stats
    When I access IDP stats
    Then I should see tackles and assists
    And sacks and pressures should display
    And turnovers should show

  @defensive-stats
  Scenario: Access team defense stats
    Given team defenses are fantasy assets
    When I view team defense stats
    Then I should see points allowed
    And yards allowed should display
    And turnover stats should show

  @defensive-stats
  Scenario: View points allowed breakdowns
    Given scoring defense matters
    When I view points allowed
    Then I should see points per game
    And opponent breakdown should show
    And situational scoring should display

  @defensive-stats
  Scenario: Access turnovers forced data
    Given turnovers drive DST scoring
    When I view turnovers forced
    Then I should see interceptions
    And fumble recoveries should display
    And defensive touchdowns should show

  @defensive-stats
  Scenario: View sack and pressure stats
    Given pass rush affects fantasy scoring
    When I access sack stats
    Then I should see total sacks
    And QB hits should display
    And pressure rate should calculate

  @defensive-stats
  Scenario: Access special teams defensive stats
    Given special teams contributes
    When I view special teams defense
    Then I should see blocked kicks
    And return touchdowns should display
    And special teams points should show

  @defensive-stats
  Scenario: View defensive matchup stats
    Given matchups matter for DST
    When I view defensive matchup data
    Then I should see opponent offensive stats
    And favorable matchups should highlight
    And streaming value should indicate

  @defensive-stats
  Scenario: Compare team defenses
    Given comparing DSTs helps decisions
    When I compare defenses
    Then I should see side-by-side stats
    And schedule comparison should include
    And overall ranking should display

  # --------------------------------------------------------------------------
  # Stat Comparisons Scenarios
  # --------------------------------------------------------------------------
  @stat-comparisons
  Scenario: Compare player vs player stats
    Given comparing players aids decisions
    When I compare two players
    Then I should see stats side by side
    And each category should compare
    And winner by category should indicate

  @stat-comparisons
  Scenario: View league average comparisons
    Given league context is important
    When I compare to league averages
    Then I should see player vs league average
    And variance should calculate
    And above/below average should indicate

  @stat-comparisons
  Scenario: Access percentile rankings
    Given percentiles show relative standing
    When I view percentile rankings
    Then I should see percentile for each stat
    And overall percentile should calculate
    And elite thresholds should mark

  @stat-comparisons
  Scenario: Compare stats across scoring formats
    Given formats value stats differently
    When I compare across formats
    Then I should see value in each format
    And format-specific ranks should display
    And optimal format should identify

  @stat-comparisons
  Scenario: View historical comparisons
    Given past comparisons provide context
    When I compare to historical players
    Then I should see current vs historical stats
    And similar player comps should suggest
    And trajectory comparisons should show

  @stat-comparisons
  Scenario: Access team comparison stats
    Given team context matters
    When I compare players on same team
    Then I should see teammate comparisons
    And usage share should display
    And complementary roles should identify

  @stat-comparisons
  Scenario: View age-adjusted comparisons
    Given age affects expectations
    When I view age-adjusted stats
    Then I should see comparison to age peers
    And age curve context should provide
    And developmental trajectory should assess

  @stat-comparisons
  Scenario: Generate comparison reports
    Given comprehensive comparison is valuable
    When I generate a comparison report
    Then I should receive detailed analysis
    And all relevant stats should include
    And I can export the report

  # --------------------------------------------------------------------------
  # Fantasy Point Calculations Scenarios
  # --------------------------------------------------------------------------
  @fantasy-calculations
  Scenario: View scoring system breakdowns
    Given fantasy scoring needs transparency
    When I view point breakdown
    Then I should see points per category
    And scoring rules should display
    And total should sum correctly

  @fantasy-calculations
  Scenario: Calculate points per stat category
    Given understanding scoring helps
    When I view category contributions
    Then I should see points from each stat
    And percentage of total should display
    And primary value drivers should highlight

  @fantasy-calculations
  Scenario: Track bonus scoring achievements
    Given bonuses add extra points
    When I view bonus tracking
    Then I should see bonuses earned
    And bonus thresholds should display
    And near-misses should note

  @fantasy-calculations
  Scenario: Calculate custom scoring values
    Given leagues have custom scoring
    When I apply custom scoring
    Then fantasy points should recalculate
    And custom rules should apply
    And comparison to standard should show

  @fantasy-calculations
  Scenario: View scoring by game situation
    Given situational scoring varies
    When I view situational breakdown
    Then I should see points by quarter
    And garbage time should identify
    And critical situation scoring should show

  @fantasy-calculations
  Scenario: Access penalty deduction tracking
    Given some leagues penalize mistakes
    When penalties are configured
    Then deductions should calculate
    And fumbles and interceptions should track
    And net points should display

  @fantasy-calculations
  Scenario: Compare fantasy scoring across formats
    Given multiple formats exist
    When I compare scoring formats
    Then I should see PPR, standard, half-PPR
    And format-specific values should display
    And optimal format should identify

  @fantasy-calculations
  Scenario: View projected vs actual scoring
    Given projections should be evaluated
    When I compare projected to actual
    Then I should see the variance
    And over/under performance should note
    And projection accuracy should track

  # --------------------------------------------------------------------------
  # Stat Trends Scenarios
  # --------------------------------------------------------------------------
  @stat-trends
  Scenario: View rolling average stats
    Given trends show direction
    When I view rolling averages
    Then I should see recent averages
    And configurable windows should be available
    And trend direction should indicate

  @stat-trends
  Scenario: Identify hot and cold streaks
    Given streaks affect decisions
    When I view streak analysis
    Then I should see current streak status
    And streak length should display
    And historical streaks should show

  @stat-trends
  Scenario: Access consistency scores
    Given consistency matters for reliability
    When I view consistency metrics
    Then I should see variance in performance
    And floor and ceiling should calculate
    And boom/bust tendency should indicate

  @stat-trends
  Scenario: View week-over-week trends
    Given weekly trends matter
    When I view weekly trends
    Then I should see performance changes
    And improvement or decline should highlight
    And trend sustainability should assess

  @stat-trends
  Scenario: Track usage trends
    Given usage indicates future opportunity
    When I view usage trends
    Then I should see target and carry trends
    And snap count trends should display
    And role changes should identify

  @stat-trends
  Scenario: View efficiency trends
    Given efficiency can change
    When I view efficiency trends
    Then I should see efficiency over time
    And sustainable vs unsustainable should analyze
    And regression candidates should identify

  @stat-trends
  Scenario: Access schedule-adjusted trends
    Given schedule difficulty varies
    When I view schedule-adjusted trends
    Then opponent strength should factor
    And true performance should estimate
    And upcoming schedule should project

  @stat-trends
  Scenario: Generate trend analysis reports
    Given comprehensive trend analysis helps
    When I generate trend reports
    Then I should receive detailed analysis
    And visualizations should include
    And I can export the report

  # --------------------------------------------------------------------------
  # Stat Exports Scenarios
  # --------------------------------------------------------------------------
  @stat-exports
  Scenario: Download stat reports as spreadsheet
    Given I want stats in spreadsheet form
    When I export to CSV or Excel
    Then I should receive a downloadable file
    And all stat data should include
    And format should be usable

  @stat-exports
  Scenario: Access stats via API
    Given I want programmatic access
    When I use the stats API
    Then I should receive structured data
    And API documentation should be available
    And rate limits should be reasonable

  @stat-exports
  Scenario: Integrate with external spreadsheets
    Given I use external tools
    When I set up spreadsheet integration
    Then stats should sync to my sheets
    And updates should be automatic
    And data freshness should maintain

  @stat-exports
  Scenario: Export stats for specific time periods
    Given I need stats for certain weeks
    When I select a time period
    Then export should include only that period
    And weekly breakdowns should be available
    And aggregates should be correct

  @stat-exports
  Scenario: Generate printable stat reports
    Given I want physical copies
    When I generate a printable report
    Then I should get a print-optimized format
    And layout should be readable
    And key stats should highlight

  @stat-exports
  Scenario: Schedule automated stat exports
    Given I want regular exports
    When I schedule automated exports
    Then exports should generate on schedule
    And delivery method should be configurable
    And export history should maintain

  @stat-exports
  Scenario: Export stats with custom fields
    Given I need specific data points
    When I customize export fields
    Then I can select which fields to include
    And custom calculations can be added
    And field order should be configurable

  @stat-exports
  Scenario: Share stat exports with league
    Given I want to share with league mates
    When I share an export
    Then league members should receive access
    And sharing permissions should be controllable
    And shared exports should be trackable

  # --------------------------------------------------------------------------
  # Error Handling Scenarios
  # --------------------------------------------------------------------------
  @error-handling
  Scenario: Handle stats data unavailable
    Given stat service may experience issues
    When stats are unavailable
    Then I should see an appropriate error message
    And cached stats should display if available
    And I should know when to retry

  @error-handling
  Scenario: Handle missing player stats
    Given some players may lack stats
    When a player has no stats
    Then I should see an indication
    And the reason should be noted
    And the UI should not break

  @error-handling
  Scenario: Handle stat calculation errors
    Given calculations may fail
    When a stat calculation errors
    Then I should see an appropriate error
    And partial data should still display
    And the error should be logged

  @error-handling
  Scenario: Handle network timeout during fetch
    Given network issues may occur
    When stat fetch times out
    Then I should see timeout message
    And retry option should be available
    And cached data should serve

  @error-handling
  Scenario: Handle invalid custom scoring input
    Given users may enter invalid values
    When invalid scoring is entered
    Then validation error should display
    And valid ranges should be shown
    And I can correct the input

  @error-handling
  Scenario: Handle API rate limiting
    Given API has usage limits
    When rate limit is exceeded
    Then I should see rate limit message
    And retry timing should be indicated
    And cached data should be offered

  @error-handling
  Scenario: Handle stat source discrepancies
    Given sources may disagree
    When stat discrepancy is detected
    Then I should be informed
    And source comparison should show
    And preferred source should be selectable

  @error-handling
  Scenario: Handle export generation failures
    Given exports may fail
    When an export fails
    Then I should see the failure reason
    And retry options should be available
    And partial exports should be recoverable

  @error-handling
  Scenario: Handle concurrent stat updates
    Given stats update frequently
    When updates conflict
    Then conflicts should resolve gracefully
    And most recent data should prevail
    And no data should be lost

  @error-handling
  Scenario: Handle corrupted stat cache
    Given cache data may corrupt
    When corruption is detected
    Then cache should be invalidated
    And fresh data should be fetched
    And I should be minimally impacted

  @error-handling
  Scenario: Handle historical data gaps
    Given historical data may be incomplete
    When data gaps exist
    Then I should see data availability notice
    And available data should still show
    And gaps should be clearly indicated

  @error-handling
  Scenario: Handle unsupported stat categories
    Given some leagues have unusual stats
    When unsupported stats are requested
    Then I should see a helpful message
    And supported alternatives should suggest
    And the request should not break

  @error-handling
  Scenario: Handle timezone issues with game times
    Given users are in different timezones
    When timezone issues occur
    Then reasonable defaults should apply
    And the user should be notified
    And manual correction should be possible

  # --------------------------------------------------------------------------
  # Accessibility Scenarios
  # --------------------------------------------------------------------------
  @accessibility
  Scenario: Navigate stats with keyboard only
    Given I rely on keyboard navigation
    When I use stats without a mouse
    Then I should be able to access all features
    And focus indicators should be clear
    And shortcuts should be available

  @accessibility
  Scenario: Use stats with screen reader
    Given I use a screen reader
    When I access stat content
    Then all content should be properly announced
    And data tables should be semantic
    And updates should be announced

  @accessibility
  Scenario: View stats in high contrast mode
    Given I need high contrast visuals
    When I enable high contrast mode
    Then all stat elements should be visible
    And charts should remain readable
    And no information should be lost

  @accessibility
  Scenario: Access stats on mobile devices
    Given I access stats on a phone
    When I view stats on mobile
    Then the interface should be responsive
    And touch targets should be adequate
    And all features should be accessible

  @accessibility
  Scenario: Customize stat display font size
    Given I need larger text
    When I increase font size
    Then all stat text should scale
    And tables should remain usable
    And no content should be cut off

  @accessibility
  Scenario: Use stats with reduced motion
    Given I am sensitive to motion
    When I have reduced motion enabled
    Then animations should be minimized
    And chart animations should simplify
    And functionality should be preserved

  @accessibility
  Scenario: Access stat charts accessibly
    Given charts convey information visually
    When I access chart data
    Then alternative text should be available
    And data tables should supplement charts
    And color should not be sole indicator

  @accessibility
  Scenario: Print stats with accessible formatting
    Given I need to print stats
    When I print stat data
    Then print layout should be optimized
    And tables should be readable
    And all data should be included

  # --------------------------------------------------------------------------
  # Performance Scenarios
  # --------------------------------------------------------------------------
  @performance
  Scenario: Load player stats quickly
    Given I open a player stat page
    When stat data loads
    Then initial load should complete within 2 seconds
    And progressive loading should show content early
    And perceived performance should be optimized

  @performance
  Scenario: Update real-time stats efficiently
    Given games are in progress
    When live stats stream in
    Then updates should appear within 1 second
    And bandwidth should be optimized
    And UI should remain responsive

  @performance
  Scenario: Handle large stat datasets efficiently
    Given career stats contain years of data
    When I view extensive stat history
    Then scrolling should remain smooth
    And data should paginate or virtualize
    And memory usage should be managed

  @performance
  Scenario: Filter stats without delay
    Given I frequently filter stats
    When I apply filters
    Then results should update within 200ms
    And filter interactions should feel instant
    And no loading spinner should be needed

  @performance
  Scenario: Calculate custom scoring quickly
    Given custom scoring requires recalculation
    When I apply custom scoring
    Then recalculation should complete within 500ms
    And UI should remain responsive
    And results should be accurate

  @performance
  Scenario: Cache stats for offline access
    Given I may lose connectivity
    When I access cached stats offline
    Then previously viewed stats should load
    And cache freshness should be indicated
    And sync should occur when online

  @performance
  Scenario: Export stats efficiently
    Given I export extensive stat data
    When the export generates
    Then export should complete promptly
    And progress should be indicated
    And browser should remain responsive

  @performance
  Scenario: Load stat comparison views quickly
    Given comparisons require multiple players
    When I compare players
    Then comparison should load within 1 second
    And all player data should fetch in parallel
    And rendering should be optimized
