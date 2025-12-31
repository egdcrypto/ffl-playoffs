@snap-counts @ANIMA-1354
Feature: Snap Counts
  As a fantasy football playoffs application user
  I want comprehensive NFL snap count data, trends, and analysis
  So that I can evaluate player usage and opportunity shares during the fantasy football playoffs

  Background:
    Given the fantasy football playoffs application is running
    And I am logged in as a registered user
    And snap count data is available

  # ============================================================================
  # SNAP COUNT DATA - HAPPY PATH
  # ============================================================================

  @happy-path @snap-count-data
  Scenario: View weekly snap count totals
    Given weekly data is recorded
    When I view weekly snap counts
    Then I should see total snaps per player
    And weekly totals should be accurate
    And I should see playing time

  @happy-path @snap-count-data
  Scenario: View offensive snap counts
    Given offensive snaps are tracked
    When I view offensive snaps
    Then I should see offensive player snaps
    And skill position snaps should show
    And offensive line snaps should show

  @happy-path @snap-count-data
  Scenario: View defensive snap counts
    Given defensive snaps are tracked
    When I view defensive snaps
    Then I should see defensive player snaps
    And IDP snaps should show
    And defensive positions should be covered

  @happy-path @snap-count-data
  Scenario: View special teams snaps
    Given special teams snaps are tracked
    When I view special teams snaps
    Then I should see ST player snaps
    And coverage snaps should show
    And return snaps should show

  @happy-path @snap-count-data
  Scenario: View snap percentage calculations
    Given team snaps are available
    When I view snap percentages
    Then I should see percentage of team snaps
    And percentages should be calculated
    And I should understand share

  @happy-path @snap-count-data
  Scenario: Track real-time snap counts
    Given game is in progress
    When I view live snaps
    Then I should see real-time snap counts
    And counts should update during game
    And I should track live usage

  @happy-path @snap-count-data
  Scenario: View snap counts by game
    Given multiple games have occurred
    When I view game-by-game snaps
    Then I should see snaps per game
    And game log should show
    And I should see consistency

  @happy-path @snap-count-data
  Scenario: View league-wide snap leaders
    Given all players have snap data
    When I view snap leaders
    Then I should see highest snap players
    And leaders should be ranked
    And I should identify workhorses

  # ============================================================================
  # SNAP COUNT BREAKDOWN
  # ============================================================================

  @happy-path @snap-breakdown
  Scenario: View total snaps per game
    Given game snap data exists
    When I view game totals
    Then I should see total snaps in game
    And team totals should show
    And I should see pace

  @happy-path @snap-breakdown
  Scenario: View snaps by quarter
    Given quarter data is tracked
    When I view quarterly snaps
    Then I should see snaps per quarter
    And usage patterns should emerge
    And I should see when players play

  @happy-path @snap-breakdown
  Scenario: View red zone snap counts
    Given red zone snaps are tracked
    When I view red zone snaps
    Then I should see RZ snap counts
    And RZ percentage should show
    And I should assess TD opportunity

  @happy-path @snap-breakdown
  Scenario: View two-minute drill snaps
    Given two-minute data is tracked
    When I view two-minute snaps
    Then I should see two-minute snaps
    And hurry-up usage should show
    And I should see situational roles

  @happy-path @snap-breakdown
  Scenario: View goal line snaps
    Given goal line data is tracked
    When I view goal line snaps
    Then I should see goal line snaps
    And short yardage usage should show
    And I should assess vulture risk

  @happy-path @snap-breakdown
  Scenario: View hurry-up offense snaps
    Given hurry-up data is tracked
    When I view hurry-up snaps
    Then I should see no-huddle snaps
    And tempo usage should show
    And I should understand situational value

  @happy-path @snap-breakdown
  Scenario: View passing down snaps
    Given passing down data exists
    When I view passing snaps
    Then I should see pass situation snaps
    And third down usage should show
    And I should assess PPR value

  @happy-path @snap-breakdown
  Scenario: View running down snaps
    Given running down data exists
    When I view running snaps
    Then I should see run situation snaps
    And early down usage should show
    And I should assess standard value

  # ============================================================================
  # SNAP COUNT TRENDS
  # ============================================================================

  @happy-path @snap-trends
  Scenario: View week-over-week changes
    Given multiple weeks of data exist
    When I view weekly changes
    Then I should see week-over-week comparison
    And changes should be highlighted
    And trends should emerge

  @happy-path @snap-trends
  Scenario: View season-long trends
    Given season data is accumulated
    When I view season trends
    Then I should see full season progression
    And trend line should show
    And I should understand trajectory

  @happy-path @snap-trends
  Scenario: View rolling averages
    Given enough games have occurred
    When I view rolling average
    Then I should see 3-game or 5-game average
    And average should smooth variance
    And I should see baseline

  @happy-path @snap-trends
  Scenario: View snap share evolution
    Given share has changed over time
    When I view share evolution
    Then I should see share progression
    And evolution should be graphed
    And I should track role development

  @happy-path @snap-trends
  Scenario: Analyze usage patterns
    Given pattern data exists
    When I analyze patterns
    Then I should see usage patterns
    And consistent patterns should be identified
    And I should predict future usage

  @happy-path @snap-trends
  Scenario: View workload trajectory
    Given workload has changed
    When I view trajectory
    Then I should see workload direction
    And increasing or decreasing should be clear
    And I should anticipate changes

  @happy-path @snap-trends
  Scenario: Identify snap count inflection points
    Given role changes have occurred
    When I view inflection points
    Then I should see key moments
    And role changes should be marked
    And I should understand turning points

  @happy-path @snap-trends
  Scenario: Compare current to historical trends
    Given historical data exists
    When I compare trends
    Then I should see current vs past
    And context should be provided
    And I should understand norms

  # ============================================================================
  # POSITION-SPECIFIC ANALYSIS
  # ============================================================================

  @happy-path @position-analysis
  Scenario: View running back snap shares
    Given RB snap data exists
    When I view RB snaps
    Then I should see RB snap shares
    And backfield split should show
    And I should identify lead back

  @happy-path @position-analysis
  Scenario: View wide receiver route participation
    Given WR route data exists
    When I view WR routes
    Then I should see routes run
    And route participation should show
    And I should assess target opportunity

  @happy-path @position-analysis
  Scenario: View tight end blocking vs receiving
    Given TE data is broken down
    When I view TE usage
    Then I should see blocking snaps
    And receiving snaps should show
    And I should assess fantasy value

  @happy-path @position-analysis
  Scenario: View quarterback snap counts
    Given QB snap data exists
    When I view QB snaps
    Then I should see QB snap totals
    And dropbacks should show
    And I should see opportunity

  @happy-path @position-analysis
  Scenario: View defensive position snaps
    Given defensive data exists
    When I view defensive snaps
    Then I should see position breakdowns
    And IDP snap counts should show
    And I should evaluate IDP value

  @happy-path @position-analysis
  Scenario: View specialist snap tracking
    Given specialist data exists
    When I view specialist snaps
    Then I should see K/P snaps
    And return specialist snaps should show
    And special teams should be covered

  @happy-path @position-analysis
  Scenario: View flex position snap comparison
    Given flex players exist
    When I compare flex snaps
    Then I should see RB/WR/TE snaps together
    And I should compare opportunity
    And flex decisions should be informed

  @happy-path @position-analysis
  Scenario: View position group snap totals
    Given position groups exist
    When I view group totals
    Then I should see total by position
    And group distribution should show
    And I should understand scheme

  # ============================================================================
  # SNAP COUNT ALERTS
  # ============================================================================

  @happy-path @snap-alerts
  Scenario: Receive snap share increase alerts
    Given snap share is increasing
    When increase is detected
    Then I should receive alert
    And I should see new share
    And I should consider adding

  @happy-path @snap-alerts
  Scenario: Receive decreased usage warnings
    Given snap share is decreasing
    When decrease is detected
    Then I should receive warning
    And I should see reduction
    And I should consider benching

  @happy-path @snap-alerts
  Scenario: Receive breakout snap notifications
    Given player is breaking out
    When breakout is detected
    Then I should receive notification
    And spike should be noted
    And I should act quickly

  @happy-path @snap-alerts
  Scenario: Track injury replacement snaps
    Given starter is injured
    When backup gets snaps
    Then I should see replacement snaps
    And opportunity increase should be tracked
    And I should target backup

  @happy-path @snap-alerts
  Scenario: View role change indicators
    Given role is changing
    When change is detected
    Then I should see indicator
    And role shift should be described
    And I should adjust expectations

  @happy-path @snap-alerts
  Scenario: Configure custom threshold alerts
    Given I want specific thresholds
    When I configure thresholds
    Then I should set snap thresholds
    And alerts should respect thresholds
    And preferences should save

  @happy-path @snap-alerts
  Scenario: Configure alert delivery method
    Given I prefer certain delivery
    When I configure delivery
    Then I should choose push, email, or both
    And preferred method should be used
    And settings should persist

  @happy-path @snap-alerts
  Scenario: Manage alert frequency
    Given I want specific frequency
    When I set frequency
    Then alerts should match frequency
    And I should not be overwhelmed
    And frequency should be respected

  # ============================================================================
  # OPPORTUNITY METRICS
  # ============================================================================

  @happy-path @opportunity-metrics
  Scenario: View snap count to target ratio
    Given target data exists
    When I view target ratio
    Then I should see targets per snap
    And efficiency should be calculated
    And I should assess target rate

  @happy-path @opportunity-metrics
  Scenario: View snap count to carry ratio
    Given carry data exists
    When I view carry ratio
    Then I should see carries per snap
    And rushing efficiency should show
    And I should assess touch rate

  @happy-path @opportunity-metrics
  Scenario: Calculate efficiency per snap
    Given performance data exists
    When I view efficiency
    Then I should see production per snap
    And efficiency should be measured
    And I should identify efficient players

  @happy-path @opportunity-metrics
  Scenario: View fantasy points per snap
    Given scoring data exists
    When I view points per snap
    Then I should see fantasy points per snap
    And efficiency should be calculated
    And I should assess value

  @happy-path @opportunity-metrics
  Scenario: Calculate opportunity score
    Given opportunity data exists
    When I view opportunity score
    Then I should see composite score
    And score should combine factors
    And I should understand opportunity

  @happy-path @opportunity-metrics
  Scenario: View usage efficiency rating
    Given efficiency data exists
    When I view efficiency rating
    Then I should see usage efficiency
    And rating should be calculated
    And I should compare players

  @happy-path @opportunity-metrics
  Scenario: Compare opportunity metrics across players
    Given multiple players have data
    When I compare metrics
    Then I should see side-by-side comparison
    And efficiency should compare
    And I should rank players

  @happy-path @opportunity-metrics
  Scenario: Project future opportunities
    Given trend data exists
    When I view projections
    Then I should see projected opportunities
    And trends should inform projection
    And I should anticipate usage

  # ============================================================================
  # TEAM SNAP ANALYSIS
  # ============================================================================

  @happy-path @team-analysis
  Scenario: View team pace of play
    Given pace data exists
    When I view team pace
    Then I should see plays per game
    And pace should be ranked
    And I should understand volume

  @happy-path @team-analysis
  Scenario: View total offensive snaps
    Given team snap totals exist
    When I view team totals
    Then I should see total offensive snaps
    And team totals should rank
    And I should identify high-volume offenses

  @happy-path @team-analysis
  Scenario: View snap distribution by position
    Given distribution data exists
    When I view distribution
    Then I should see position snap breakdown
    And distribution should be visualized
    And I should understand scheme

  @happy-path @team-analysis
  Scenario: View formation snap counts
    Given formation data exists
    When I view formation snaps
    Then I should see 11/12/21/22 personnel snaps
    And formation preferences should show
    And I should understand tendencies

  @happy-path @team-analysis
  Scenario: View personnel grouping snaps
    Given personnel data exists
    When I view personnel snaps
    Then I should see grouping breakdowns
    And usage should be clear
    And I should identify key personnel

  @happy-path @team-analysis
  Scenario: Analyze tempo patterns
    Given tempo data exists
    When I analyze tempo
    Then I should see tempo tendencies
    And game script should factor
    And I should understand pace changes

  @happy-path @team-analysis
  Scenario: Compare team snap philosophies
    Given multiple teams exist
    When I compare philosophies
    Then I should see style differences
    And run/pass tendencies should show
    And I should understand approaches

  @happy-path @team-analysis
  Scenario: View team snap totals by week
    Given weekly team data exists
    When I view weekly totals
    Then I should see team snaps per week
    And variance should be visible
    And I should see consistency

  # ============================================================================
  # COMPARATIVE ANALYSIS
  # ============================================================================

  @happy-path @comparative-analysis
  Scenario: Compare player vs player snaps
    Given multiple players exist
    When I compare players
    Then I should see side-by-side snaps
    And comparison should be clear
    And I should make decisions

  @happy-path @comparative-analysis
  Scenario: Compare team vs league average
    Given league average exists
    When I compare to league
    Then I should see team vs average
    And deviation should be shown
    And I should understand context

  @happy-path @comparative-analysis
  Scenario: Compare position group snaps
    Given position groups exist
    When I compare groups
    Then I should see group comparisons
    And I should see heavy/light usage
    And I should understand scheme

  @happy-path @comparative-analysis
  Scenario: Compare week vs season average
    Given season data exists
    When I compare week to season
    Then I should see variance from average
    And outliers should be flagged
    And I should understand normal

  @happy-path @comparative-analysis
  Scenario: Identify role players
    Given role data exists
    When I identify roles
    Then I should see player roles
    And starter/backup should be clear
    And situational players should be identified

  @happy-path @comparative-analysis
  Scenario: View snap share rankings
    Given rankings can be calculated
    When I view rankings
    Then I should see snap share rankings
    And players should be ranked
    And I should identify leaders

  @happy-path @comparative-analysis
  Scenario: Compare across positions
    Given flex players exist
    When I compare positions
    Then I should see cross-position comparison
    And value should be comparable
    And I should make flex decisions

  @happy-path @comparative-analysis
  Scenario: Benchmark against elite players
    Given elite players are defined
    When I benchmark
    Then I should see comparison to elites
    And gap should be measured
    And I should understand tier

  # ============================================================================
  # HISTORICAL DATA
  # ============================================================================

  @happy-path @historical-data
  Scenario: View career snap history
    Given career data exists
    When I view career snaps
    Then I should see career snap totals
    And year-by-year should show
    And I should see progression

  @happy-path @historical-data
  Scenario: Compare season-over-season
    Given multiple seasons exist
    When I compare seasons
    Then I should see season comparisons
    And changes should be visible
    And I should understand trajectory

  @happy-path @historical-data
  Scenario: View game log snap data
    Given game logs exist
    When I view game log
    Then I should see snaps per game
    And game log should be complete
    And I should see consistency

  @happy-path @historical-data
  Scenario: Access snap count archives
    Given archives exist
    When I access archives
    Then I should see historical data
    And past seasons should be available
    And I should research history

  @happy-path @historical-data
  Scenario: View trend visualization
    Given trend data exists
    When I view visualization
    Then I should see trend graphs
    And direction should be clear
    And I should understand trajectory

  @happy-path @historical-data
  Scenario: Recognize usage patterns
    Given patterns exist
    When I analyze patterns
    Then I should see recurring patterns
    And patterns should be identified
    And I should predict future usage

  @happy-path @historical-data
  Scenario: Export historical data
    Given I want to analyze elsewhere
    When I export data
    Then I should receive data export
    And format should be usable
    And I should analyze offline

  @happy-path @historical-data
  Scenario: Compare to player's own history
    Given player has history
    When I compare current to history
    Then I should see deviation from norm
    And changes should be flagged
    And I should understand context

  # ============================================================================
  # VISUALIZATION
  # ============================================================================

  @happy-path @visualization
  Scenario: View snap count charts
    Given snap data exists
    When I view charts
    Then I should see snap count visualized
    And charts should be clear
    And data should be understandable

  @happy-path @visualization
  Scenario: View trend line graphs
    Given trend data exists
    When I view trend lines
    Then I should see trend visualization
    And direction should be clear
    And I should see trajectory

  @happy-path @visualization
  Scenario: View heat maps by position
    Given position data exists
    When I view heat maps
    Then I should see position heat maps
    And intensity should be color-coded
    And I should identify heavy usage

  @happy-path @visualization
  Scenario: View pie charts for share
    Given share data exists
    When I view pie charts
    Then I should see share distribution
    And pie should show percentages
    And I should understand splits

  @happy-path @visualization
  Scenario: View week-by-week bar charts
    Given weekly data exists
    When I view bar charts
    Then I should see weekly bars
    And variance should be visible
    And I should see consistency

  @happy-path @visualization
  Scenario: View mobile-optimized display
    Given I am on mobile
    When I view visualizations
    Then display should be mobile-friendly
    And charts should be readable
    And interaction should work

  @happy-path @visualization
  Scenario: Export visualization images
    Given I want to share
    When I export images
    Then I should receive image files
    And images should be high quality
    And I should share easily

  @happy-path @visualization
  Scenario: Customize visualization preferences
    Given display options exist
    When I customize display
    Then preferences should apply
    And visualization should match preferences
    And settings should save

  # ============================================================================
  # COMMISSIONER TOOLS
  # ============================================================================

  @happy-path @commissioner-tools @commissioner
  Scenario: Configure snap count settings for league
    Given I am commissioner
    When I configure settings
    Then I should set league preferences
    And settings should apply to league
    And configuration should save

  @happy-path @commissioner-tools @commissioner
  Scenario: Share snap count reports with league
    Given snap reports exist
    When I share with league
    Then league should see reports
    And sharing should work
    And commissioner should control

  @happy-path @commissioner-tools @commissioner
  Scenario: Generate snap count analysis reports
    Given snap data exists
    When I generate report
    Then I should receive report
    And report should be comprehensive
    And I should share with league

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Handle snap count data unavailable
    Given snap data is expected
    When data is unavailable
    Then I should see error message
    And last known data should show
    And I should retry later

  @error
  Scenario: Handle incomplete snap data
    Given complete data is expected
    When data is incomplete
    Then I should see partial data
    And missing data should be noted
    And I should understand limitations

  @error
  Scenario: Handle real-time tracking failure
    Given real-time is expected
    When tracking fails
    Then I should see error message
    And I should retry
    And fallback should be available

  @error
  Scenario: Handle calculation error
    Given calculation is attempted
    When calculation fails
    Then I should see error message
    And raw data should remain
    And I should retry

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: View snap counts on mobile
    Given I am using mobile app
    When I view snap counts
    Then display should be mobile-optimized
    And data should be readable
    And I should scroll and interact

  @mobile
  Scenario: Receive snap alerts on mobile
    Given snap alerts are enabled
    When alert is triggered
    Then I should receive mobile push
    And I should tap to view
    And I should act quickly

  @mobile
  Scenario: View visualizations on mobile
    Given I am on mobile
    When I view charts
    Then charts should be mobile-friendly
    And interaction should work
    And I should understand data

  @mobile
  Scenario: Compare players on mobile
    Given I am on mobile
    When I compare players
    Then comparison should work on mobile
    And I should swipe between players
    And data should be clear

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate snap counts with keyboard
    Given I am using keyboard navigation
    When I browse snap counts
    Then I should navigate with keyboard
    And all content should be accessible
    And focus should be visible

  @accessibility
  Scenario: Screen reader snap count access
    Given I am using a screen reader
    When I view snap counts
    Then data should be announced
    And numbers should be read clearly
    And I should understand information

  @accessibility
  Scenario: High contrast snap count display
    Given I have high contrast enabled
    When I view snap counts
    Then text should be readable
    And charts should be accessible
    And data should be clear

  @accessibility
  Scenario: Snap counts with reduced motion
    Given I have reduced motion enabled
    When snap data updates
    Then animations should be minimal
    And updates should still be visible
    And functionality should work
