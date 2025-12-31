@player-comparison @comparison @analytics
Feature: Player Comparison
  As a fantasy football manager
  I want to compare players side-by-side
  So that I can make informed decisions on trades, starts, and roster moves

  Background:
    Given a fantasy football platform exists
    And player data and statistics are available
    And I am a registered user

  # ==========================================
  # SIDE-BY-SIDE STAT COMPARISON
  # ==========================================

  @side-by-side @happy-path
  Scenario: Compare two players side-by-side
    Given I want to compare two players
    When I select two players for comparison
    Then I see their stats displayed side-by-side
    And key differences are highlighted

  @side-by-side @select
  Scenario: Select players for comparison
    Given I am on the comparison page
    When I search for and select players
    Then they are added to the comparison
    And I can proceed with analysis

  @side-by-side @swap
  Scenario: Swap player positions in comparison
    Given I have two players selected
    When I swap their positions
    Then the left and right columns switch
    And the comparison is reordered

  @side-by-side @remove
  Scenario: Remove a player from comparison
    Given I have players in comparison
    When I remove one player
    Then they are removed from the view
    And I can add a different player

  @side-by-side @highlight
  Scenario: Highlight leader in each category
    Given I am comparing two players
    When I view their stats
    Then the leader in each category is highlighted
    And visual indicators show advantages

  # ==========================================
  # MULTI-PLAYER COMPARISON
  # ==========================================

  @multi-player @happy-path
  Scenario: Compare up to four players
    Given I want to compare multiple players
    When I select up to four players
    Then all players are displayed in columns
    And I can compare across all of them

  @multi-player @add
  Scenario: Add additional player to comparison
    Given I have two players in comparison
    When I add a third player
    Then the comparison expands to three columns
    And all three are compared

  @multi-player @limit
  Scenario: Enforce maximum player limit
    Given I have four players in comparison
    When I try to add a fifth player
    Then I receive a message about the limit
    And I must remove a player to add another

  @multi-player @ranking
  Scenario: Rank players across comparison
    Given I have multiple players compared
    When I view the ranking summary
    Then players are ranked by each metric
    And an overall ranking is provided

  @multi-player @same-position
  Scenario: Compare players at same position
    Given I am comparing players
    When all players are the same position
    Then position-specific stats are shown
    And comparison is more relevant

  # ==========================================
  # SEASON STATS COMPARISON
  # ==========================================

  @season-stats @happy-path
  Scenario: Compare current season stats
    Given players have current season data
    When I compare season stats
    Then I see full season statistics
    And totals and averages are shown

  @season-stats @year
  Scenario: Compare stats from a specific year
    Given historical season data exists
    When I select a specific year
    Then stats from that year are compared
    And I can switch between years

  @season-stats @categories
  Scenario: Compare all statistical categories
    Given I am comparing season stats
    When I view all categories
    Then passing, rushing, receiving stats are shown
    And fantasy points are calculated

  @season-stats @per-game
  Scenario: View per-game averages
    Given season totals are displayed
    When I toggle to per-game averages
    Then all stats are shown per game
    And games played is factored in

  @season-stats @pace
  Scenario: View season pace projections
    Given the season is in progress
    When I view pace projections
    Then I see projected full-season totals
    And current trends are extrapolated

  # ==========================================
  # WEEKLY PERFORMANCE COMPARISON
  # ==========================================

  @weekly @happy-path
  Scenario: Compare weekly performances
    Given players have weekly data
    When I compare weekly performance
    Then I see week-by-week stats
    And I can identify patterns

  @weekly @specific
  Scenario: Compare a specific week
    Given I want to focus on one week
    When I select a specific week
    Then only that week's stats are shown
    And performance is detailed

  @weekly @trend
  Scenario: View weekly performance trends
    Given multiple weeks of data exist
    When I view trend analysis
    Then I see performance trending over time
    And momentum is indicated

  @weekly @best-worst
  Scenario: Compare best and worst weeks
    Given I am viewing weekly data
    When I check best and worst weeks
    Then I see each player's ceiling and floor
    And consistency is assessed

  @weekly @chart
  Scenario: Visualize weekly performance
    Given weekly data is available
    When I view the comparison chart
    Then I see a line chart of weekly points
    And visual comparison is easy

  # ==========================================
  # CAREER STATS COMPARISON
  # ==========================================

  @career @happy-path
  Scenario: Compare career statistics
    Given players have career data
    When I compare career stats
    Then I see lifetime totals
    And career per-game averages are shown

  @career @milestones
  Scenario: Compare career milestones
    Given players have career achievements
    When I view career milestones
    Then I see major accomplishments
    And milestones are compared

  @career @seasons
  Scenario: Compare number of productive seasons
    Given players have multi-year careers
    When I compare career longevity
    Then I see productive years
    And career trajectories are shown

  @career @peak
  Scenario: Compare peak seasons
    Given players have historical data
    When I compare peak seasons
    Then I see each player's best season
    And peak performance is compared

  # ==========================================
  # PROJECTION COMPARISON
  # ==========================================

  @projections @happy-path
  Scenario: Compare player projections
    Given players have projections
    When I compare projections
    Then I see projected fantasy points
    And projection sources are shown

  @projections @weekly
  Scenario: Compare weekly projections
    Given upcoming week projections exist
    When I compare weekly projections
    Then I see this week's expected points
    And matchup context is provided

  @projections @ros
  Scenario: Compare rest-of-season projections
    Given ROS projections are available
    When I compare ROS projections
    Then I see remaining season value
    And bye weeks are factored in

  @projections @sources
  Scenario: Compare projections from different sources
    Given multiple projection sources exist
    When I compare across sources
    Then I see projections from each source
    And consensus is highlighted

  @projections @accuracy
  Scenario: Compare projection accuracy
    Given historical accuracy data exists
    When I view accuracy comparison
    Then I see how accurate projections have been
    And reliability is assessed

  # ==========================================
  # MATCHUP DIFFICULTY COMPARISON
  # ==========================================

  @matchup @difficulty @happy-path
  Scenario: Compare upcoming matchup difficulty
    Given players have upcoming matchups
    When I compare matchup difficulty
    Then I see each player's opponent
    And defensive rankings are shown

  @matchup @grades
  Scenario: Compare matchup grades
    Given matchup grades are calculated
    When I view matchup comparison
    Then I see letter grades for each
    And the better matchup is clear

  @matchup @schedule
  Scenario: Compare remaining schedule difficulty
    Given schedule data is available
    When I compare remaining schedules
    Then I see schedule strength rankings
    And favorable stretches are identified

  @matchup @historical
  Scenario: Compare historical vs opponent
    Given players have played these opponents before
    When I view historical matchup data
    Then I see past performances vs each defense
    And trends are identified

  # ==========================================
  # TARGET SHARE AND USAGE
  # ==========================================

  @usage @targets @happy-path
  Scenario: Compare target share
    Given pass-catching players are compared
    When I view target share comparison
    Then I see target percentage for each
    And volume differences are clear

  @usage @touches
  Scenario: Compare touch volume
    Given players have touch data
    When I compare touches
    Then I see total touches per game
    And workload is compared

  @usage @snap-count
  Scenario: Compare snap counts
    Given snap data is available
    When I compare snap percentages
    Then I see playing time for each
    And opportunity is assessed

  @usage @trend
  Scenario: Compare usage trends
    Given usage changes over time
    When I view usage trends
    Then I see if usage is increasing or decreasing
    And trajectory is compared

  @usage @routes
  Scenario: Compare route participation
    Given route data is available
    When I compare route participation
    Then I see routes run per game
    And passing game involvement is clear

  # ==========================================
  # RED ZONE COMPARISON
  # ==========================================

  @red-zone @happy-path
  Scenario: Compare red zone opportunities
    Given red zone data is available
    When I compare red zone usage
    Then I see red zone touches/targets
    And TD opportunity is compared

  @red-zone @efficiency
  Scenario: Compare red zone efficiency
    Given red zone results are tracked
    When I compare efficiency
    Then I see red zone TD rate
    And conversion ability is assessed

  @red-zone @share
  Scenario: Compare red zone share
    Given team red zone data exists
    When I compare red zone share
    Then I see percentage of team's red zone work
    And relative opportunity is shown

  @red-zone @goal-line
  Scenario: Compare goal-line usage
    Given goal-line data is available
    When I compare goal-line work
    Then I see carries/targets inside the 5
    And TD equity is compared

  # ==========================================
  # CONSISTENCY METRICS
  # ==========================================

  @consistency @happy-path
  Scenario: Compare player consistency
    Given consistency metrics exist
    When I compare consistency
    Then I see standard deviation of scores
    And consistency rating is shown

  @consistency @floor
  Scenario: Compare scoring floors
    Given floor data is calculated
    When I compare floors
    Then I see minimum expected points
    And reliability is assessed

  @consistency @variance
  Scenario: Compare scoring variance
    Given variance data exists
    When I compare variance
    Then I see how much scores fluctuate
    And predictability is compared

  @consistency @streak
  Scenario: Compare scoring streaks
    Given streak data is tracked
    When I compare streaks
    Then I see consecutive good/bad weeks
    And current momentum is shown

  # ==========================================
  # BOOM/BUST COMPARISON
  # ==========================================

  @boom-bust @happy-path
  Scenario: Compare boom/bust rates
    Given boom/bust data is calculated
    When I compare boom/bust rates
    Then I see boom rate for each player
    And bust rate is also shown

  @boom-bust @thresholds
  Scenario: View boom/bust thresholds
    Given thresholds are defined
    When I view threshold information
    Then I see what defines boom and bust
    And I can customize thresholds

  @boom-bust @risk
  Scenario: Compare risk profiles
    Given risk data is available
    When I compare risk profiles
    Then I see overall risk assessment
    And risk tolerance match is indicated

  @boom-bust @upside
  Scenario: Compare upside potential
    Given upside data is calculated
    When I compare upside
    Then I see ceiling potential for each
    And explosion possibility is rated

  # ==========================================
  # FLOOR AND CEILING COMPARISON
  # ==========================================

  @floor-ceiling @happy-path
  Scenario: Compare floor and ceiling projections
    Given floor and ceiling data exists
    When I compare floor and ceiling
    Then I see minimum and maximum expected
    And range is visualized

  @floor-ceiling @range
  Scenario: Compare outcome ranges
    Given outcome distributions are calculated
    When I compare ranges
    Then I see width of outcome range
    And certainty vs uncertainty is shown

  @floor-ceiling @visualization
  Scenario: Visualize floor and ceiling comparison
    Given range data is available
    When I view the visualization
    Then I see a graphical comparison
    And overlap and differences are clear

  @floor-ceiling @strategy
  Scenario: Recommend based on floor vs ceiling
    Given I provide my situation
    When I get recommendations
    Then I see who fits my needs better
    And strategy advice is given

  # ==========================================
  # TRADE VALUE COMPARISON
  # ==========================================

  @trade-value @happy-path
  Scenario: Compare trade values
    Given trade values are calculated
    When I compare trade values
    Then I see relative trade value
    And values are comparable

  @trade-value @chart
  Scenario: Reference trade value chart
    Given a trade value chart exists
    When I view chart values
    Then I see players' chart positions
    And the difference is calculated

  @trade-value @trend
  Scenario: Compare trade value trends
    Given trade values change over time
    When I view value trends
    Then I see rising or falling values
    And trajectory is compared

  @trade-value @fairness
  Scenario: Assess trade fairness
    Given I am considering a trade
    When I compare values
    Then I see if the trade is fair
    And adjustments are suggested

  # ==========================================
  # AUCTION VALUE COMPARISON
  # ==========================================

  @auction-value @happy-path
  Scenario: Compare auction values
    Given auction values are calculated
    When I compare auction values
    Then I see dollar values for each
    And price difference is shown

  @auction-value @format
  Scenario: Adjust for league format
    Given different formats exist
    When I apply my league format
    Then values adjust accordingly
    And comparison reflects my settings

  @auction-value @historical
  Scenario: Compare historical auction prices
    Given past auction data exists
    When I view historical prices
    Then I see what players have cost
    And price trends are shown

  @auction-value @surplus
  Scenario: Compare surplus value
    Given surplus value is calculated
    When I compare surplus
    Then I see value over replacement
    And bargain potential is assessed

  # ==========================================
  # SCHEDULE STRENGTH COMPARISON
  # ==========================================

  @schedule @strength @happy-path
  Scenario: Compare schedule strength
    Given schedule data is available
    When I compare remaining schedules
    Then I see strength of schedule
    And favorable matchups are counted

  @schedule @playoffs
  Scenario: Compare playoff schedule strength
    Given playoff weeks are defined
    When I compare playoff schedules
    Then I see playoff matchup difficulty
    And playoff value is assessed

  @schedule @by-week
  Scenario: Compare week-by-week matchups
    Given I want detailed comparison
    When I view weekly schedule comparison
    Then I see each week's matchup
    And I can compare specific weeks

  @schedule @favorable
  Scenario: Count favorable matchups
    Given matchup grades are assigned
    When I count favorable matchups
    Then I see number of good matchups remaining
    And easy stretches are identified

  # ==========================================
  # HISTORICAL TRENDS
  # ==========================================

  @historical @trends @happy-path
  Scenario: Compare historical performance trends
    Given historical data exists
    When I view trend comparison
    Then I see multi-year performance
    And career trajectories are compared

  @historical @age
  Scenario: Factor age into comparison
    Given player ages are known
    When I consider age curves
    Then I see expected trajectory
    And age-related decline is noted

  @historical @similar
  Scenario: Compare to historical comps
    Given player comps are calculated
    When I view historical comparisons
    Then I see similar past players
    And outcomes are referenced

  @historical @progression
  Scenario: Compare year-over-year progression
    Given multi-year data exists
    When I view YoY comparison
    Then I see how players have improved
    And development is tracked

  # ==========================================
  # POSITION RANK COMPARISON
  # ==========================================

  @position-rank @happy-path
  Scenario: Compare position ranks
    Given players are ranked at position
    When I compare position ranks
    Then I see each player's rank
    And positional value is clear

  @position-rank @scoring
  Scenario: Compare by scoring format rank
    Given ranks vary by scoring format
    When I apply my scoring format
    Then ranks reflect my format
    And comparison is relevant

  @position-rank @trend
  Scenario: Compare rank trends
    Given ranks change over time
    When I view rank trends
    Then I see ranking trajectory
    And momentum is compared

  @position-rank @tiers
  Scenario: Compare position tier placement
    Given position tiers are defined
    When I compare tiers
    Then I see which tier each is in
    And tier gaps are shown

  # ==========================================
  # FANTASY POINTS COMPARISON
  # ==========================================

  @fantasy-points @ppg @happy-path
  Scenario: Compare fantasy points per game
    Given PPG data is calculated
    When I compare PPG
    Then I see average fantasy points
    And scoring format is applied

  @fantasy-points @total
  Scenario: Compare total fantasy points
    Given season totals exist
    When I compare totals
    Then I see total fantasy points
    And games played is noted

  @fantasy-points @format
  Scenario: Compare across scoring formats
    Given multiple formats are supported
    When I compare across formats
    Then I see how values differ by format
    And format-specific ranks are shown

  @fantasy-points @weekly
  Scenario: Compare weekly fantasy point distribution
    Given weekly data exists
    When I compare distributions
    Then I see scoring patterns
    And consistency is visualized

  # ==========================================
  # POINTS VS POSITION AVERAGE
  # ==========================================

  @vs-average @happy-path
  Scenario: Compare points vs position average
    Given position averages are calculated
    When I compare vs average
    Then I see how each exceeds/lags average
    And relative value is clear

  @vs-average @percentile
  Scenario: Compare position percentiles
    Given percentile data exists
    When I compare percentiles
    Then I see where each ranks percentile-wise
    And elite vs average is distinguished

  @vs-average @replacement
  Scenario: Compare value over replacement
    Given replacement level is defined
    When I compare value over replacement
    Then I see points above replacement
    And true value is assessed

  # ==========================================
  # VISUAL CHARTS AND GRAPHS
  # ==========================================

  @visualization @charts @happy-path
  Scenario: View comparison charts
    Given I am comparing players
    When I view charts
    Then I see graphical comparisons
    And visuals aid understanding

  @visualization @bar
  Scenario: View bar chart comparison
    Given stat categories are available
    When I view bar chart
    Then I see bars for each stat
    And differences are visually clear

  @visualization @radar
  Scenario: View radar chart comparison
    Given multiple categories are compared
    When I view radar chart
    Then I see multi-dimensional comparison
    And strengths/weaknesses are visual

  @visualization @line
  Scenario: View line chart for trends
    Given time series data exists
    When I view line chart
    Then I see performance over time
    And trend comparison is visual

  @visualization @customize
  Scenario: Customize chart display
    Given I want to customize charts
    When I adjust chart settings
    Then I can change colors and labels
    And the chart reflects my preferences

  # ==========================================
  # EXPORT COMPARISON
  # ==========================================

  @export @happy-path
  Scenario: Export comparison results
    Given I have a comparison set up
    When I export the comparison
    Then I receive a downloadable file
    And all comparison data is included

  @export @format
  Scenario: Choose export format
    Given export formats are available
    When I select format
    Then I can choose PDF, CSV, or image
    And export is generated accordingly

  @export @charts
  Scenario: Export comparison with charts
    Given charts are displayed
    When I include charts in export
    Then visual charts are in the export
    And the file is comprehensive

  @export @selection
  Scenario: Export selected stats only
    Given I only want certain stats
    When I select stats to export
    Then only selected stats are exported
    And the file is focused

  # ==========================================
  # SAVE COMPARISON TEMPLATES
  # ==========================================

  @templates @save @happy-path
  Scenario: Save comparison as template
    Given I have configured a comparison
    When I save the template
    Then my comparison settings are saved
    And I can reuse the template

  @templates @load
  Scenario: Load saved comparison template
    Given I have saved templates
    When I load a template
    Then the comparison is set up
    And I only need to add players

  @templates @edit
  Scenario: Edit saved template
    Given I want to modify a template
    When I edit the template
    Then I can change settings
    And the template is updated

  @templates @delete
  Scenario: Delete saved template
    Given I no longer need a template
    When I delete it
    Then the template is removed
    And it no longer appears in my list

  @templates @share
  Scenario: Share comparison template
    Given I have a useful template
    When I share it
    Then others can use my template
    And attribution is maintained

  # ==========================================
  # SOCIAL SHARING
  # ==========================================

  @social @share @happy-path
  Scenario: Share comparison on social media
    Given I have a comparison
    When I share to social media
    Then a formatted post is created
    And the comparison is shareable

  @social @image
  Scenario: Generate shareable comparison image
    Given I want to share visually
    When I generate an image
    Then an attractive graphic is created
    And it is formatted for social

  @social @league
  Scenario: Share comparison in league
    Given my league has social features
    When I share to league
    Then league mates can view
    And discussion is enabled

  @social @link
  Scenario: Generate shareable link
    Given I want to share via link
    When I generate a link
    Then others can view the comparison
    And the link is shareable

  # ==========================================
  # MOBILE EXPERIENCE
  # ==========================================

  @mobile @happy-path
  Scenario: Compare players on mobile
    Given I am using the mobile app
    When I access comparison tools
    Then the interface is mobile-optimized
    And all features are accessible

  @mobile @swipe
  Scenario: Swipe between players on mobile
    Given I am comparing on mobile
    When I swipe
    Then I can move between players
    And the experience is fluid

  @mobile @portrait
  Scenario: View comparison in portrait mode
    Given I am in portrait orientation
    When I view comparison
    Then the layout is optimized for portrait
    And I can scroll horizontally

  @mobile @landscape
  Scenario: View comparison in landscape mode
    Given I am in landscape orientation
    When I view comparison
    Then more columns are visible
    And side-by-side is easier

  @mobile @quick-compare
  Scenario: Quick compare from any player card
    Given I see a player card
    When I tap quick compare
    Then I can immediately add another player
    And comparison opens quickly

  # ==========================================
  # QUICK COMPARE FROM ROSTER
  # ==========================================

  @roster @quick-compare @happy-path
  Scenario: Compare players from roster view
    Given I am viewing my roster
    When I select players to compare
    Then comparison opens with selected players
    And I can make lineup decisions

  @roster @bench-vs-starter
  Scenario: Compare bench player to starter
    Given I have starters and bench players
    When I compare bench vs starter
    Then I can assess if I should swap
    And the comparison informs my decision

  @roster @trade-target
  Scenario: Compare roster player to trade target
    Given I am considering a trade
    When I compare my player to target
    Then I see side-by-side value
    And trade decision is informed

  @roster @multi-select
  Scenario: Select multiple roster players to compare
    Given I have multiple options at a position
    When I select several players
    Then they are all compared
    And I can pick the best option

  # ==========================================
  # ERROR HANDLING
  # ==========================================

  @error-handling
  Scenario: Handle missing player data
    Given a player lacks some data
    When I include them in comparison
    Then available data is shown
    And missing data is indicated

  @error-handling
  Scenario: Handle incompatible player comparison
    Given I try to compare very different positions
    When the comparison is created
    Then a warning is shown
    And relevant shared stats are displayed

  @error-handling
  Scenario: Handle comparison load failure
    Given the comparison fails to load
    When I try to access it
    Then an error message is shown
    And I can retry or report the issue

  # ==========================================
  # ACCESSIBILITY
  # ==========================================

  @accessibility
  Scenario: Navigate comparison with screen reader
    Given I am using a screen reader
    When I access comparison
    Then all data is properly labeled
    And comparison is navigable

  @accessibility
  Scenario: View comparison with high contrast
    Given I have high contrast enabled
    When I view comparison
    Then all elements are visible
    And leader highlighting is accessible

  @accessibility
  Scenario: Navigate comparison with keyboard
    Given I use keyboard navigation
    When I use the comparison tool
    Then all features are keyboard accessible
    And focus indicators are clear
