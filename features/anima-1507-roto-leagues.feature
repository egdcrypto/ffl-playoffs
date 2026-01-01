@roto-leagues
Feature: Roto Leagues
  As a fantasy football manager
  I want to compete in rotisserie-style leagues
  So that I can accumulate statistics across categories and compete based on overall rankings

  Background:
    Given the fantasy football platform is available
    And I am logged in as a registered user
    And I am a member of a rotisserie league

  # ============================================================================
  # CATEGORY STANDINGS
  # ============================================================================

  @category-standings
  Scenario: View overall category standings
    Given my league uses rotisserie format
    And the season is in progress
    When I navigate to the league standings
    Then I should see all teams ranked by total roto points
    And I should see category points breakdown for each team
    And I should see overall standings position

  @category-standings
  Scenario: View individual category rankings
    Given multiple statistical categories are tracked
    When I view category-specific standings
    Then I should see teams ranked within each category
    And I should see the statistical values for each team
    And I should see category points awarded

  @category-standings
  Scenario: Sort standings by specific category
    Given I am viewing the league standings
    When I sort by a specific category
    Then teams should be ordered by that category's stats
    And I should see ranking within that category
    And overall roto points should still be visible

  @category-standings
  Scenario: View standings changes over time
    Given standings have changed during the season
    When I view standings with trend indicators
    Then I should see movement arrows or indicators
    And I should see previous week's position
    And I should see net position change

  @category-standings
  Scenario: Compare category performance between teams
    Given I want to compare my team to another
    When I select a team for comparison
    Then I should see side-by-side category stats
    And I should see who leads each category
    And I should see the point differential

  @category-standings
  Scenario: View category standings after stat corrections
    Given official stats have been corrected
    When the standings are recalculated
    Then I should see updated category rankings
    And I should see notification of changes
    And historical standings should reflect corrections

  @category-standings
  Scenario: Display category standings on mobile
    Given I am viewing on a mobile device
    When I access category standings
    Then the display should be responsive
    And I should be able to scroll horizontally through categories
    And key information should be visible

  @category-standings
  Scenario: View playoff positioning in standings
    Given the roto league has playoff implications
    When I view the standings
    Then I should see playoff cutoff line
    And I should see magic numbers for clinching
    And I should see elimination scenarios

  @category-standings
  Scenario Outline: Award category points based on ranking
    Given there are <teams> teams in the league
    And my team ranks <rank> in a category
    When category points are calculated
    Then I should receive <points> points for that category

    Examples:
      | teams | rank | points |
      | 10    | 1    | 10     |
      | 10    | 5    | 6      |
      | 10    | 10   | 1      |
      | 12    | 1    | 12     |
      | 12    | 6    | 7      |

  # ============================================================================
  # CUMULATIVE STATS
  # ============================================================================

  @cumulative-stats
  Scenario: Track cumulative passing yards
    Given passing yards is a roto category
    When my players accumulate passing yards
    Then I should see my total passing yards for the season
    And I should see weekly breakdowns
    And I should see my ranking in this category

  @cumulative-stats
  Scenario: Track cumulative rushing yards
    Given rushing yards is a roto category
    When my players accumulate rushing yards
    Then I should see my total rushing yards for the season
    And I should see contribution by player
    And I should see my category ranking

  @cumulative-stats
  Scenario: Track cumulative receiving yards
    Given receiving yards is a roto category
    When my players accumulate receiving yards
    Then I should see my total receiving yards for the season
    And I should see top contributors
    And I should see my standing in the category

  @cumulative-stats
  Scenario: Track cumulative touchdowns
    Given touchdowns is a roto category
    When my players score touchdowns
    Then I should see my total touchdown count
    And I should see breakdown by type
    And I should see my category position

  @cumulative-stats
  Scenario: Track cumulative receptions
    Given receptions is a roto category
    When my players make receptions
    Then I should see my total reception count
    And I should see weekly reception totals
    And I should see category ranking

  @cumulative-stats
  Scenario: View stat accumulation by week
    Given I want to see weekly stat progression
    When I view my cumulative stats history
    Then I should see stats added each week
    And I should see running totals
    And I should see pace projections

  @cumulative-stats
  Scenario: Track negative stat categories
    Given interceptions is a negative roto category
    When my players throw interceptions
    Then I should see interception count
    And lower counts should rank higher
    And points should be awarded inversely

  @cumulative-stats
  Scenario: View cumulative stats for all teams
    Given I want to compare league-wide stats
    When I view the cumulative stats leaderboard
    Then I should see all teams' stats by category
    And I should see league totals
    And I should see averages per team

  @cumulative-stats
  Scenario: Track stats from bench players
    Given I want to know bench player contributions
    When I view my roster stats
    Then I should see which stats came from starters
    And I should see bench player stats separately
    And only starter stats should count for roto

  # ============================================================================
  # ROTISSERIE SCORING
  # ============================================================================

  @rotisserie-scoring
  Scenario: Calculate total roto points
    Given all categories have been scored
    When total roto points are calculated
    Then I should see sum of all category points
    And I should see my overall ranking
    And I should see points behind leader

  @rotisserie-scoring
  Scenario: View roto scoring breakdown
    Given my team has accumulated roto points
    When I view my scoring breakdown
    Then I should see points from each category
    And I should see which categories are strongest
    And I should see which categories need improvement

  @rotisserie-scoring
  Scenario: Update roto scores after games
    Given NFL games have concluded
    When stats are finalized for the week
    Then roto category rankings should update
    And roto points should be recalculated
    And standings should reflect changes

  @rotisserie-scoring
  Scenario: Handle ties in roto scoring
    Given two teams have identical total roto points
    When viewing the standings
    Then the tiebreaker should be applied
    And the resolution should be displayed
    And both teams should see their position

  @rotisserie-scoring
  Scenario: Project final roto standings
    Given the season is partially complete
    When I view projected final standings
    Then I should see pace-based projections
    And I should see confidence intervals
    And I should see likely final position

  @rotisserie-scoring
  Scenario: Compare roto scoring systems
    Given different roto scoring methods exist
    When I view my league's scoring method
    Then I should see how points are awarded
    And I should understand the scoring structure
    And I should see examples of calculations

  @rotisserie-scoring
  Scenario: View historical roto scoring
    Given previous seasons have concluded
    When I view historical roto results
    Then I should see past season standings
    And I should see point totals by season
    And I should see category performance history

  @rotisserie-scoring
  Scenario: Understand roto point value changes
    Given category rankings have shifted
    When my roto points change
    Then I should see which categories caused the change
    And I should see the magnitude of the change
    And I should see my new standing

  @rotisserie-scoring
  Scenario: Track roto points over time
    Given the season has progressed
    When I view my roto point trend
    Then I should see a graph of points over time
    And I should see inflection points
    And I should see trend direction

  # ============================================================================
  # CATEGORY RANKINGS
  # ============================================================================

  @category-rankings
  Scenario: View my ranking in each category
    Given multiple roto categories exist
    When I view my category rankings
    Then I should see my position in each category
    And I should see the statistical value
    And I should see points awarded per category

  @category-rankings
  Scenario: Identify category strengths
    Given I have varied category performance
    When I analyze my category rankings
    Then I should see my top categories highlighted
    And I should see where I rank highest
    And I should see competitive advantages

  @category-rankings
  Scenario: Identify category weaknesses
    Given some categories are underperforming
    When I view my category analysis
    Then I should see my weakest categories
    And I should see gap to average
    And I should see improvement suggestions

  @category-rankings
  Scenario: Track category ranking changes
    Given category rankings shift weekly
    When I view ranking changes
    Then I should see movement in each category
    And I should see which categories improved
    And I should see which categories declined

  @category-rankings
  Scenario: Compare category rankings to league average
    Given I want to benchmark my performance
    When I view category comparisons
    Then I should see league average for each category
    And I should see how I compare
    And I should see above/below average indicators

  @category-rankings
  Scenario: View category ranking history
    Given the season has progressed
    When I view my category ranking history
    Then I should see how my rankings changed over time
    And I should see trend lines
    And I should identify patterns

  @category-rankings
  Scenario: Sort teams by specific category rank
    Given I want to see who leads a category
    When I sort by a specific category
    Then I should see teams ordered by that category
    And I should see exact statistical values
    And I should see point differentials

  @category-rankings
  Scenario: View real-time category ranking updates
    Given games are currently in progress
    When I view live category rankings
    Then I should see rankings updating in real-time
    And I should see projected final rankings
    And I should see potential position changes

  @category-rankings
  Scenario: Analyze category distribution
    Given I want to understand category competitiveness
    When I view category distribution
    Then I should see how tightly packed rankings are
    And I should see category variance
    And I should see opportunity areas

  # ============================================================================
  # STAT ACCUMULATION
  # ============================================================================

  @stat-accumulation
  Scenario: Accumulate stats from starting lineup
    Given I have set my starting lineup
    When my starters accumulate statistics
    Then those stats should count toward my roto totals
    And I should see stats credited properly
    And my category standings should update

  @stat-accumulation
  Scenario: Exclude bench player stats
    Given I have players on my bench
    When bench players accumulate statistics
    Then those stats should not count for roto
    And I should see them tracked separately
    And only active roster stats should count

  @stat-accumulation
  Scenario: Handle player on bye week
    Given a starter is on bye week
    When I do not have a replacement
    Then I should accumulate zero stats from that slot
    And my category totals should reflect the gap
    And I should see impact on standings

  @stat-accumulation
  Scenario: Track stat accumulation rate
    Given I want to monitor my stat pace
    When I view stat accumulation rate
    Then I should see stats per week average
    And I should see projected season totals
    And I should see comparison to pace needed

  @stat-accumulation
  Scenario: View stat accumulation by player
    Given I want to see player contributions
    When I view player stat breakdown
    Then I should see each player's contributions by category
    And I should see percentage of team totals
    And I should identify key contributors

  @stat-accumulation
  Scenario: Handle injured player stat accumulation
    Given a player is injured mid-game
    When partial stats are accumulated
    Then I should see stats up to injury point
    And I should see injury notation
    And my totals should include partial stats

  @stat-accumulation
  Scenario: Track opponent stat accumulation
    Given I want to monitor competition
    When I view opponent stat accumulation
    Then I should see their weekly additions
    And I should see how they compare to mine
    And I should see category gaps

  @stat-accumulation
  Scenario: Project stat accumulation to season end
    Given current stat accumulation rates are known
    When I view season projections
    Then I should see projected final totals
    And I should see projected category rankings
    And I should see projected final standing

  @stat-accumulation
  Scenario: Handle stat corrections to accumulation
    Given official stat corrections are issued
    When corrections are applied
    Then my accumulated stats should be adjusted
    And I should be notified of changes
    And historical records should be updated

  # ============================================================================
  # ROTO TIEBREAKERS
  # ============================================================================

  @roto-tiebreakers
  Scenario: Configure roto tiebreaker rules
    Given I am the commissioner
    When I access tiebreaker settings
    Then I should be able to set tiebreaker priority
    And I should see available tiebreaker options
    And I should be able to save the configuration

  @roto-tiebreakers
  Scenario: Apply most category wins tiebreaker
    Given two teams have identical total roto points
    And most category wins is the first tiebreaker
    When the tiebreaker is applied
    Then the team with more first-place categories wins
    And the resolution should be displayed

  @roto-tiebreakers
  Scenario: Apply best single category tiebreaker
    Given teams are tied after initial tiebreakers
    And best single category is configured
    When this tiebreaker is applied
    Then the team with the highest category rank wins
    And the specific category should be noted

  @roto-tiebreakers
  Scenario: Apply total statistics tiebreaker
    Given teams are tied on category points
    And total statistics is a tiebreaker
    When total stats are compared
    Then the team with higher total stats wins
    And the stat comparison should be shown

  @roto-tiebreakers
  Scenario: Handle multi-way roto tie
    Given three or more teams have identical roto points
    When tiebreakers are applied
    Then all tied teams should be evaluated together
    And proper ordering should be determined
    And each resolution step should be documented

  @roto-tiebreakers
  Scenario: Display tiebreaker explanation
    Given a tiebreaker has resolved a tie
    When I view the standings
    Then I should see tiebreaker notation
    And I should be able to view details
    And the explanation should be clear

  @roto-tiebreakers
  Scenario: Apply head-to-head category comparison
    Given teams are tied overall
    And head-to-head comparison is a tiebreaker
    When categories are compared directly
    Then the team winning more categories head-to-head wins
    And category-by-category comparison should be shown

  @roto-tiebreakers
  Scenario: Use coin flip as final tiebreaker
    Given all configured tiebreakers result in ties
    And coin flip is the final tiebreaker
    When the coin flip is executed
    Then the result should be random and fair
    And the outcome should be recorded
    And both teams should be notified

  @roto-tiebreakers
  Scenario: Apply tiebreaker for playoff seeding
    Given roto standings determine playoff seeding
    And teams are tied at playoff cutoff
    When tiebreakers are applied
    Then playoff qualification should be determined
    And affected teams should be notified
    And the decision should be documented

  # ============================================================================
  # CATEGORY LIMITS
  # ============================================================================

  @category-limits
  Scenario: Configure maximum category limits
    Given I am the commissioner
    When I set category limits
    Then I should be able to set maximum values per category
    And I should see limit enforcement rules
    And teams should be notified of limits

  @category-limits
  Scenario: Reach category ceiling
    Given a category has a maximum limit
    When my team reaches that limit
    Then additional stats should not count
    And I should see ceiling reached notification
    And my category should be maxed out

  @category-limits
  Scenario: View progress toward category limit
    Given category limits are in place
    When I view my category progress
    Then I should see current value vs limit
    And I should see percentage of limit used
    And I should see remaining capacity

  @category-limits
  Scenario: Configure minimum category requirements
    Given the league requires minimum category participation
    When I view category requirements
    Then I should see minimum thresholds
    And I should see my progress toward minimums
    And I should see penalties for not meeting minimums

  @category-limits
  Scenario: Handle category limit during game
    Given I am approaching a category limit
    And a game is in progress
    When my players accumulate stats
    Then I should see live progress toward limit
    And I should see projection for hitting limit
    And I should receive warnings if approaching

  @category-limits
  Scenario: Strategy around category limits
    Given category limits affect scoring strategy
    When I plan my roster
    Then I should see limit impact projections
    And I should see optimal player usage
    And I should see when to pivot strategy

  @category-limits
  Scenario: View league-wide category limit status
    Given multiple teams are approaching limits
    When I view league limit status
    Then I should see which teams are near limits
    And I should see competitive implications
    And I should see limit pacing information

  @category-limits
  Scenario: Apply partial stats when hitting limit
    Given I hit a category limit mid-game
    When stats are finalized
    Then only stats up to the limit should count
    And overflow should be tracked but not scored
    And my final category value should equal the limit

  @category-limits
  Scenario: Reset category limits for new period
    Given category limits are periodic
    When a new period begins
    Then limits should reset
    And I should see new limit capacity
    And previous period should be preserved

  # ============================================================================
  # WEEKLY ROTO UPDATES
  # ============================================================================

  @weekly-roto-updates
  Scenario: Receive weekly standings update
    Given the weekly scoring period has ended
    When updates are processed
    Then I should receive a standings update notification
    And I should see my new position
    And I should see key changes in categories

  @weekly-roto-updates
  Scenario: View weekly stat summary
    Given the week has concluded
    When I view my weekly summary
    Then I should see stats accumulated this week
    And I should see category ranking changes
    And I should see points gained or lost

  @weekly-roto-updates
  Scenario: Track weekly category movement
    Given categories have shifted during the week
    When I view weekly movement
    Then I should see which categories changed
    And I should see magnitude of changes
    And I should see resulting point changes

  @weekly-roto-updates
  Scenario: Compare weekly performance to opponents
    Given the week is complete
    When I compare weekly performance
    Then I should see how I performed vs competitors
    And I should see who gained ground
    And I should see who lost ground

  @weekly-roto-updates
  Scenario: View weekly award for best roto performance
    Given weekly awards are enabled
    When the week concludes
    Then I should see who had best roto week
    And I should see category leaders for the week
    And I should see notable performances

  @weekly-roto-updates
  Scenario: Receive live roto updates during games
    Given NFL games are in progress
    When stats are updated live
    Then I should see roto standings update in real-time
    And I should see category ranking fluctuations
    And I should see projected weekly finish

  @weekly-roto-updates
  Scenario: View weekly trendlines
    Given multiple weeks have concluded
    When I view weekly trends
    Then I should see trend lines for each category
    And I should see momentum indicators
    And I should see trajectory toward season goals

  @weekly-roto-updates
  Scenario: Set weekly roto alerts
    Given I want to monitor specific thresholds
    When I configure weekly alerts
    Then I should receive alerts when thresholds are crossed
    And I should see real-time notifications
    And I should be able to customize alert conditions

  @weekly-roto-updates
  Scenario: View weekly recap report
    Given the week has been finalized
    When I access the weekly recap
    Then I should see comprehensive weekly analysis
    And I should see biggest movers
    And I should see key matchup implications

  # ============================================================================
  # SEASON-LONG TRACKING
  # ============================================================================

  @season-long-tracking
  Scenario: Track cumulative season stats
    Given the season is in progress
    When I view season-long statistics
    Then I should see total accumulated stats
    And I should see week-by-week progression
    And I should see season projections

  @season-long-tracking
  Scenario: View season standings progression
    Given multiple weeks have been played
    When I view standings history
    Then I should see my position each week
    And I should see trend of my standing
    And I should see critical turning points

  @season-long-tracking
  Scenario: Track pace toward season goals
    Given I have set season goals
    When I view goal progress
    Then I should see current pace vs goals
    And I should see projected final values
    And I should see if I'm on track

  @season-long-tracking
  Scenario: View season-long category analysis
    Given the season is underway
    When I analyze category performance
    Then I should see category trends over time
    And I should see consistency metrics
    And I should see improvement areas

  @season-long-tracking
  Scenario: Compare season performance to previous years
    Given historical data exists
    When I compare to previous seasons
    Then I should see year-over-year comparisons
    And I should see improvement or decline
    And I should see historical context

  @season-long-tracking
  Scenario: Project final season standings
    Given sufficient season data exists
    When I view final projections
    Then I should see projected final standings
    And I should see confidence levels
    And I should see scenarios for improvement

  @season-long-tracking
  Scenario: Track category consistency
    Given weekly performances vary
    When I analyze consistency
    Then I should see week-to-week variance
    And I should see most consistent categories
    And I should see most volatile categories

  @season-long-tracking
  Scenario: View season milestone achievements
    Given I have reached statistical milestones
    When I view my achievements
    Then I should see milestones reached
    And I should see upcoming milestones
    And I should see league milestone comparisons

  @season-long-tracking
  Scenario: Generate end-of-season report
    Given the season has concluded
    When I access the season report
    Then I should see complete season summary
    And I should see final standings and stats
    And I should see year in review highlights

  # ============================================================================
  # ROTO LEAGUE SETTINGS
  # ============================================================================

  @roto-league-settings
  Scenario: Configure roto categories
    Given I am the commissioner
    When I access roto category settings
    Then I should be able to add or remove categories
    And I should be able to set category weights
    And I should see impact of changes

  @roto-league-settings
  Scenario: Set number of scoring categories
    Given the league is being configured
    When I set the number of categories
    Then I should be able to choose from standard sets
    And I should be able to customize the selection
    And category count should be balanced

  @roto-league-settings
  Scenario: Configure category point values
    Given categories need point value settings
    When I configure point distribution
    Then I should be able to set standard 1-point-per-rank
    And I should be able to use alternative distributions
    And I should see how it affects scoring

  @roto-league-settings
  Scenario: Set roster requirements for roto
    Given roster construction affects roto
    When I configure roster settings
    Then I should set starting lineup positions
    And I should set roster size limits
    And I should see category implications

  @roto-league-settings
  Scenario: Configure stat tracking settings
    Given stat tracking needs configuration
    When I access stat settings
    Then I should be able to set which stats count
    And I should configure stat source
    And I should set update frequency

  @roto-league-settings
  Scenario: Set tiebreaker configuration
    Given tiebreaker rules need to be set
    When I configure tiebreakers
    Then I should be able to order tiebreaker priority
    And I should see available options
    And I should be able to save preferences

  @roto-league-settings
  Scenario: Configure playoff settings for roto
    Given roto league has playoffs
    When I configure playoff settings
    Then I should set how roto translates to playoffs
    And I should configure playoff format
    And I should set seeding rules

  @roto-league-settings
  Scenario: Set category limits and floors
    Given category constraints are needed
    When I configure limits
    Then I should be able to set maximums
    And I should be able to set minimums
    And I should see enforcement rules

  @roto-league-settings
  Scenario: View all roto settings summary
    Given all settings have been configured
    When I view settings summary
    Then I should see complete configuration
    And I should see category list
    And I should see all rules and constraints

  @roto-league-settings
  Scenario: Import roto settings from template
    Given standard roto templates exist
    When I import a template
    Then settings should be populated
    And I should be able to customize further
    And original template should be preserved

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error-handling
  Scenario: Handle missing stat data
    Given stat data is unavailable for a period
    When the system detects missing data
    Then an appropriate message should be displayed
    And affected categories should be noted
    And expected resolution time should be shown

  @error-handling
  Scenario: Handle stat provider outage
    Given the stat data provider is unavailable
    When stats cannot be retrieved
    Then cached data should be used if available
    And users should be notified of delay
    And updates should resume when service returns

  @error-handling
  Scenario: Handle calculation errors in standings
    Given a standings calculation error occurs
    When the error is detected
    Then the system should attempt recalculation
    And if unresolved, commissioner should be notified
    And previous valid standings should be preserved

  @error-handling
  Scenario: Handle category configuration errors
    Given category settings have conflicts
    When the conflict is detected
    Then a clear error message should be displayed
    And the commissioner should be guided to fix
    And invalid settings should not be saved

  @error-handling
  Scenario: Handle stat correction conflicts
    Given multiple stat corrections affect the same game
    When corrections are processed
    Then conflicts should be resolved systematically
    And final values should be authoritative
    And change history should be maintained

  @error-handling
  Scenario: Handle roster-stat mismatch
    Given roster changes occurred mid-week
    When stats don't match expected roster
    Then the system should identify discrepancy
    And proper stat attribution should be made
    And any issues should be flagged

  @error-handling
  Scenario: Handle division by zero in calculations
    Given a calculation could result in division by zero
    When the calculation is attempted
    Then the error should be handled gracefully
    And a sensible default should be used
    And the scenario should be logged

  @error-handling
  Scenario: Handle concurrent stat updates
    Given multiple stat updates arrive simultaneously
    When processing concurrent updates
    Then updates should be processed in order
    And no data should be lost
    And final state should be consistent

  @error-handling
  Scenario: Handle historical data corruption
    Given historical stat data becomes corrupted
    When corruption is detected
    Then backup data should be restored
    And affected users should be notified
    And data integrity should be verified

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate standings with screen reader
    Given I am using a screen reader
    When I access roto standings
    Then all data should be properly labeled
    And table structure should be navigable
    And rankings should be clearly announced

  @accessibility
  Scenario: Use keyboard navigation for stats
    Given I am navigating via keyboard
    When I access stat displays
    Then all interactive elements should be focusable
    And tab order should be logical
    And data should be accessible via keyboard

  @accessibility
  Scenario: View category charts with accessibility
    Given I need accessible data visualization
    When I view category charts
    Then charts should have text alternatives
    And data should be available in table format
    And colors should not be the only indicator

  @accessibility
  Scenario: Configure settings with accessibility tools
    Given I use accessibility tools
    When I configure roto settings
    Then all form fields should be labeled
    And error messages should be announced
    And help text should be accessible

  @accessibility
  Scenario: View standings in high contrast mode
    Given I use high contrast display settings
    When I view roto standings
    Then all text should be readable
    And rankings should be distinguishable
    And interactive elements should be visible

  @accessibility
  Scenario: Access roto features on mobile
    Given I am using a mobile device
    When I access roto features
    Then the interface should be responsive
    And touch targets should be appropriately sized
    And all features should be accessible

  @accessibility
  Scenario: Receive accessible notifications
    Given I have accessibility preferences
    When I receive roto updates
    Then notifications should be screen reader compatible
    And important information should be conveyed
    And notification preferences should work

  @accessibility
  Scenario: View stat tables with reduced motion
    Given I have reduced motion preferences
    When viewing live stat updates
    Then updates should not use animations
    And information should still be clear
    And the experience should remain informative

  @accessibility
  Scenario: Access category details via voice
    Given I use voice control
    When I request category information
    Then voice commands should work
    And data should be spoken clearly
    And navigation should be possible via voice

  # ============================================================================
  # PERFORMANCE
  # ============================================================================

  @performance
  Scenario: Load roto standings quickly
    Given I am accessing roto standings
    When the page loads
    Then standings should appear within 2 seconds
    And all data should load smoothly
    And the experience should feel responsive

  @performance
  Scenario: Handle large league stat calculations
    Given a league has many teams and categories
    When standings are calculated
    Then calculation should complete quickly
    And results should be accurate
    And system should not slow down

  @performance
  Scenario: Process real-time stat updates efficiently
    Given many stat updates are streaming
    When updates are processed
    Then standings should update promptly
    And no updates should be lost
    And system should remain responsive

  @performance
  Scenario: Load historical stat data efficiently
    Given extensive historical data exists
    When historical data is requested
    Then data should load progressively
    And initial results should appear quickly
    And performance should scale with data size

  @performance
  Scenario: Handle high traffic during games
    Given many users access standings during games
    When traffic peaks
    Then system should remain responsive
    And all users should receive updates
    And no degradation should occur

  @performance
  Scenario: Calculate complex tiebreakers efficiently
    Given many teams are tied
    And complex tiebreakers must be applied
    When tiebreakers are resolved
    Then calculation should be fast
    And results should be accurate
    And process should be transparent

  @performance
  Scenario: Cache frequently accessed standings
    Given standings are viewed frequently
    When standings are requested
    Then cached data should be served when valid
    And cache should update when data changes
    And users should see accurate data

  @performance
  Scenario: Generate season reports efficiently
    Given season reports require extensive calculation
    When a report is generated
    Then generation should complete in reasonable time
    And progress should be shown
    And the report should be comprehensive

  @performance
  Scenario: Handle concurrent league calculations
    Given multiple leagues require calculations
    When calculations run concurrently
    Then each league should be processed correctly
    And resources should be managed efficiently
    And no league should be delayed significantly
