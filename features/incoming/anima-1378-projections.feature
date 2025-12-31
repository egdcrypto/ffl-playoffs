@projections @anima-1378
Feature: Projections
  As a fantasy football user
  I want comprehensive fantasy point projections and forecasting
  So that I can make informed decisions about my team

  Background:
    Given I am a logged-in user
    And the projection system is available

  # ============================================================================
  # PLAYER PROJECTIONS
  # ============================================================================

  @happy-path @player-projections
  Scenario: View weekly projections
    Given I am viewing a player
    When I check their weekly projection
    Then I should see projected points for the week
    And projection should include confidence range

  @happy-path @player-projections
  Scenario: View season projections
    Given I am viewing a player
    When I check their season projection
    Then I should see projected season total
    And projection should be broken down by category

  @happy-path @player-projections
  Scenario: View rest-of-season projections
    Given we are mid-season
    When I view ROS projections
    Then I should see remaining season totals
    And actual vs projected should be compared

  @happy-path @player-projections
  Scenario: View playoff projections
    Given playoffs are approaching
    When I view playoff projections
    Then I should see playoff week projections
    And matchup schedule should be factored

  @happy-path @player-projections
  Scenario: Compare player projections
    Given I want to compare players
    When I compare their projections
    Then I should see side-by-side comparison
    And key differences should be highlighted

  @happy-path @player-projections
  Scenario: View projection by scoring format
    Given different scoring formats exist
    When I select a scoring format
    Then projections should adjust accordingly
    And format-specific points should be shown

  @happy-path @player-projections
  Scenario: View projection trends
    Given projections change over time
    When I view projection trends
    Then I should see how projections have changed
    And trend direction should be indicated

  @happy-path @player-projections
  Scenario: View projection breakdown
    Given I want detailed projections
    When I view projection breakdown
    Then I should see stats by category
    And each category's contribution should be shown

  @happy-path @player-projections
  Scenario: Filter projections by position
    Given I want position-specific projections
    When I filter by position
    Then I should see projections for that position
    And position rankings should be shown

  @happy-path @player-projections
  Scenario: View projections for bench players
    Given I have bench players
    When I view bench projections
    Then I should see bench player projections
    And comparison to starters should be available

  # ============================================================================
  # TEAM PROJECTIONS
  # ============================================================================

  @happy-path @team-projections
  Scenario: View team point projections
    Given I own a fantasy team
    When I view team projections
    Then I should see total projected points
    And projection should be for current lineup

  @happy-path @team-projections
  Scenario: View weekly team totals
    Given I have set my lineup
    When I view weekly projection
    Then I should see projected team total
    And breakdown by position should be shown

  @happy-path @team-projections
  Scenario: View season outlook
    Given we are in-season
    When I view season outlook
    Then I should see projected season performance
    And playoff probability should be included

  @happy-path @team-projections
  Scenario: View playoff outlook
    Given playoffs are possible
    When I view playoff outlook
    Then I should see playoff projection
    And path to championship should be shown

  @happy-path @team-projections
  Scenario: Compare team projections
    Given I want to compare teams
    When I compare team projections
    Then I should see side-by-side comparison
    And strengths and weaknesses should be shown

  @happy-path @team-projections
  Scenario: View team projection history
    Given I have team projection history
    When I view historical projections
    Then I should see past projections vs actual
    And accuracy should be tracked

  @happy-path @team-projections
  Scenario: View optimal lineup projection
    Given I have multiple lineup options
    When I view optimal projection
    Then I should see best possible lineup
    And projected gain should be shown

  @happy-path @team-projections
  Scenario: View team strength by position
    Given I am analyzing my team
    Then I should see strength by position
    And weak positions should be identified

  @happy-path @team-projections
  Scenario: View team projection variance
    Given projections have ranges
    When I view projection variance
    Then I should see team upside and downside
    And risk profile should be clear

  @happy-path @team-projections
  Scenario: Project team with different lineups
    Given I want to test lineups
    When I project different configurations
    Then I should see how projections change
    And optimal configuration should be suggested

  # ============================================================================
  # MATCHUP PROJECTIONS
  # ============================================================================

  @happy-path @matchup-projections
  Scenario: View head-to-head predictions
    Given I have a matchup
    When I view matchup projection
    Then I should see predicted outcome
    And each team's projection should be shown

  @happy-path @matchup-projections
  Scenario: View win probability
    Given I have a matchup
    When I check win probability
    Then I should see my chances of winning
    And probability should be percentage-based

  @happy-path @matchup-projections
  Scenario: View projected margins
    Given I have a matchup
    When I view projected margin
    Then I should see expected point difference
    And confidence interval should be shown

  @happy-path @matchup-projections
  Scenario: Receive upset alerts
    Given my team is projected to lose
    When upset potential exists
    Then I should see upset alert
    And scenarios for winning should be shown

  @happy-path @matchup-projections
  Scenario: View matchup breakdown
    Given I have a matchup
    When I view matchup breakdown
    Then I should see position-by-position comparison
    And advantages should be highlighted

  @happy-path @matchup-projections
  Scenario: View live matchup projections
    Given my matchup is in progress
    When I view live projections
    Then projections should update in real-time
    And win probability should adjust

  @happy-path @matchup-projections
  Scenario: View historical matchup data
    Given I have played this opponent before
    When I view historical data
    Then I should see past matchup results
    And trends should be visible

  @happy-path @matchup-projections
  Scenario: Compare lineup options for matchup
    Given I am setting my lineup
    When I compare lineup options
    Then I should see win probability for each
    And optimal lineup should be suggested

  @happy-path @matchup-projections
  Scenario: View close matchup indicators
    Given my matchup is projected close
    Then I should see close matchup indicator
    And key players should be highlighted

  @happy-path @matchup-projections
  Scenario: View matchup simulation results
    Given simulations are run
    When I view simulation results
    Then I should see outcome distribution
    And most likely scenarios should be shown

  # ============================================================================
  # SCORING PROJECTIONS
  # ============================================================================

  @happy-path @scoring-projections
  Scenario: View scoring breakdowns
    Given I am viewing projections
    When I view scoring breakdown
    Then I should see points by category
    And each category should be detailed

  @happy-path @scoring-projections
  Scenario: View category projections
    Given scoring has multiple categories
    When I view category projections
    Then I should see each category projected
    And category rankings should be shown

  @happy-path @scoring-projections
  Scenario: View floor/ceiling ranges
    Given projections have ranges
    When I view floor and ceiling
    Then I should see minimum and maximum projections
    And likely range should be indicated

  @happy-path @scoring-projections
  Scenario: View expected points
    Given I am evaluating a player
    When I view expected points
    Then I should see mean expected value
    And standard deviation should be shown

  @happy-path @scoring-projections
  Scenario: View PPR vs standard projections
    Given different formats exist
    When I compare PPR to standard
    Then I should see projection differences
    And format impact should be clear

  @happy-path @scoring-projections
  Scenario: View bonus point projections
    Given my league has bonuses
    When I view bonus projections
    Then I should see expected bonus points
    And bonus likelihood should be shown

  @happy-path @scoring-projections
  Scenario: View red zone projections
    Given red zone opportunities matter
    When I view red zone projections
    Then I should see TD probability
    And red zone usage should be factored

  @happy-path @scoring-projections
  Scenario: View target share projections
    Given targets affect scoring
    When I view target projections
    Then I should see expected targets
    And target share should be shown

  @happy-path @scoring-projections
  Scenario: View rushing attempt projections
    Given rushing attempts matter
    When I view rushing projections
    Then I should see expected carries
    And yards per carry should be shown

  @happy-path @scoring-projections
  Scenario: View defensive scoring projections
    Given I have a defense
    When I view defensive projections
    Then I should see defensive point projection
    And opponent matchup should be factored

  # ============================================================================
  # PROJECTION SOURCES
  # ============================================================================

  @happy-path @projection-sources
  Scenario: View multiple projection sources
    Given multiple sources are available
    When I view projections
    Then I should see different sources
    And source attribution should be clear

  @happy-path @projection-sources
  Scenario: View consensus rankings
    Given multiple sources exist
    When I view consensus
    Then I should see aggregated rankings
    And consensus should weight sources

  @happy-path @projection-sources
  Scenario: View expert projections
    Given experts provide projections
    When I view expert projections
    Then I should see expert picks
    And expert credentials should be shown

  @happy-path @projection-sources
  Scenario: View algorithm-based projections
    Given algorithms generate projections
    When I view algorithm projections
    Then I should see data-driven projections
    And methodology should be explained

  @happy-path @projection-sources
  Scenario: Compare projection sources
    Given multiple sources are available
    When I compare sources
    Then I should see source differences
    And variance should be highlighted

  @happy-path @projection-sources
  Scenario: Filter by projection source
    Given I prefer certain sources
    When I filter by source
    Then I should see only that source
    And filter should be clearable

  @happy-path @projection-sources
  Scenario: View source accuracy history
    Given sources have track records
    When I view source accuracy
    Then I should see historical accuracy
    And most accurate sources should be ranked

  @happy-path @projection-sources
  Scenario: Set preferred projection source
    Given I prefer a source
    When I set my preference
    Then that source should be default
    And preference should be saved

  @happy-path @projection-sources
  Scenario: View proprietary projections
    Given platform has proprietary projections
    When I view our projections
    Then I should see platform projections
    And methodology should be transparent

  @happy-path @projection-sources
  Scenario: Subscribe to premium sources
    Given premium sources are available
    When I subscribe to premium
    Then I should access premium projections
    And additional insights should be provided

  # ============================================================================
  # CUSTOM PROJECTIONS
  # ============================================================================

  @happy-path @custom-projections
  Scenario: Make user adjustments
    Given I disagree with a projection
    When I adjust the projection
    Then my adjustment should be saved
    And custom projection should be used

  @happy-path @custom-projections
  Scenario: Configure custom settings
    Given I want custom projection settings
    When I configure my settings
    Then settings should be applied
    And projections should reflect settings

  @happy-path @custom-projections
  Scenario: Create personal projections
    Given I want my own projections
    When I create personal projections
    Then I can set my own values
    And they should be used in calculations

  @happy-path @custom-projections
  Scenario: Override default projections
    Given default projections exist
    When I override a projection
    Then my override should take precedence
    And original should still be visible

  @happy-path @custom-projections
  Scenario: Import custom projections
    Given I have projections elsewhere
    When I import projections
    Then my projections should be imported
    And format should be validated

  @happy-path @custom-projections
  Scenario: Export custom projections
    Given I created custom projections
    When I export them
    Then I should receive export file
    And data should be complete

  @happy-path @custom-projections
  Scenario: Reset to default projections
    Given I have customized projections
    When I reset to defaults
    Then default projections should be restored
    And customizations should be cleared

  @happy-path @custom-projections
  Scenario: Share custom projections
    Given I want to share projections
    When I share my projections
    Then others can view them
    And attribution should be maintained

  @happy-path @custom-projections
  Scenario: View adjustment impact
    Given I make an adjustment
    Then I should see how it affects rankings
    And lineup recommendations should update

  @happy-path @custom-projections
  Scenario: Track custom projection accuracy
    Given I use custom projections
    When results are in
    Then I should see my accuracy
    And comparison to defaults should be shown

  # ============================================================================
  # PROJECTION HISTORY
  # ============================================================================

  @happy-path @projection-history
  Scenario: View past accuracy
    Given projections have been made
    When I view accuracy history
    Then I should see how accurate projections were
    And accuracy should be by player/source

  @happy-path @projection-history
  Scenario: View historical comparisons
    Given historical data exists
    When I compare to history
    Then I should see past vs present projections
    And trends should be identified

  @happy-path @projection-history
  Scenario: View track record
    Given sources have history
    When I view track record
    Then I should see cumulative accuracy
    And reliability should be scored

  @happy-path @projection-history
  Scenario: View accuracy scores
    Given accuracy is measured
    When I view accuracy scores
    Then I should see scoring metrics
    And ranking by accuracy should be shown

  @happy-path @projection-history
  Scenario: Compare projection to actual
    Given games have been played
    When I compare to actual
    Then I should see projected vs actual
    And variance should be highlighted

  @happy-path @projection-history
  Scenario: View weekly accuracy trends
    Given multiple weeks have passed
    When I view weekly trends
    Then I should see accuracy by week
    And consistency should be measured

  @happy-path @projection-history
  Scenario: Analyze projection errors
    Given projections have errors
    When I analyze errors
    Then I should see common error patterns
    And causes should be identified

  @happy-path @projection-history
  Scenario: View best and worst projections
    Given projections have varied accuracy
    When I view extremes
    Then I should see best and worst predictions
    And learnings should be available

  # ============================================================================
  # PROJECTION ALERTS
  # ============================================================================

  @happy-path @projection-alerts
  Scenario: Receive projection change alerts
    Given I have alerts enabled
    When a projection changes significantly
    Then I should receive an alert
    And change magnitude should be shown

  @happy-path @projection-alerts
  Scenario: Receive significant update alerts
    Given major updates occur
    When projections update significantly
    Then I should be notified
    And reason for change should be explained

  @happy-path @projection-alerts
  Scenario: Configure threshold alerts
    Given I want custom thresholds
    When I set alert thresholds
    Then alerts should trigger at my thresholds
    And preferences should be saved

  @happy-path @projection-alerts
  Scenario: View trending changes
    Given projections are trending
    When I view trending changes
    Then I should see trending players
    And trend direction should be clear

  @happy-path @projection-alerts
  Scenario: Set player-specific alerts
    Given I want alerts for specific players
    When I set player alerts
    Then I should be notified for those players
    And alert type should be configurable

  @happy-path @projection-alerts
  Scenario: Receive lineup impact alerts
    Given my lineup is set
    When a rostered player's projection changes
    Then I should receive lineup alert
    And action should be suggested

  @happy-path @projection-alerts
  Scenario: View alert history
    Given I have received alerts
    When I view alert history
    Then I should see past alerts
    And alerts should be searchable

  @happy-path @projection-alerts
  Scenario: Disable projection alerts
    Given I receive too many alerts
    When I disable projection alerts
    Then alerts should stop
    And I can re-enable later

  # ============================================================================
  # PROJECTION ANALYSIS
  # ============================================================================

  @happy-path @projection-analysis
  Scenario: View projection insights
    Given insights are available
    When I view projection insights
    Then I should see key takeaways
    And insights should be actionable

  @happy-path @projection-analysis
  Scenario: View variance analysis
    Given projections vary
    When I analyze variance
    Then I should see variance metrics
    And high-variance players should be flagged

  @happy-path @projection-analysis
  Scenario: Identify boom/bust potential
    Given players have upside/downside
    When I view boom/bust analysis
    Then I should see boom/bust ratings
    And risk/reward should be clear

  @happy-path @projection-analysis
  Scenario: View risk assessment
    Given risk varies by player
    When I view risk assessment
    Then I should see risk scores
    And risk factors should be explained

  @happy-path @projection-analysis
  Scenario: Analyze matchup impact on projections
    Given matchups affect projections
    When I analyze matchup impact
    Then I should see matchup adjustments
    And favorable matchups should be highlighted

  @happy-path @projection-analysis
  Scenario: View weather impact analysis
    Given weather affects games
    When I view weather impact
    Then I should see weather adjustments
    And affected players should be identified

  @happy-path @projection-analysis
  Scenario: Analyze usage trends
    Given usage affects projections
    When I analyze usage trends
    Then I should see usage patterns
    And projection implications should be shown

  @happy-path @projection-analysis
  Scenario: View projection confidence levels
    Given confidence varies
    When I view confidence levels
    Then I should see confidence scores
    And high-confidence projections should be marked

  # ============================================================================
  # PROJECTION INTEGRATION
  # ============================================================================

  @happy-path @projection-integration
  Scenario: Use projections in lineup optimizer
    Given projections are available
    When I use lineup optimizer
    Then projections should drive optimization
    And optimal lineup should be generated

  @happy-path @projection-integration
  Scenario: Use projections in trade analyzer
    Given I am analyzing a trade
    When I view trade analysis
    Then projections should inform trade value
    And trade impact should be shown

  @happy-path @projection-integration
  Scenario: View waiver rankings by projection
    Given waivers are available
    When I view waiver rankings
    Then rankings should include projections
    And pickup value should be calculated

  @happy-path @projection-integration
  Scenario: Get start/sit recommendations
    Given I need lineup advice
    When I get start/sit recommendations
    Then recommendations should use projections
    And confidence should be shown

  @happy-path @projection-integration
  Scenario: View projections in draft
    Given I am drafting
    When I view player projections
    Then draft projections should be shown
    And value over replacement should be calculated

  @happy-path @projection-integration
  Scenario: Integrate projections with rankings
    Given rankings are available
    When I view rankings
    Then projections should be integrated
    And ranking vs projection should be comparable

  @happy-path @projection-integration
  Scenario: Use projections for roster decisions
    Given I make roster decisions
    Then projections should inform decisions
    And add/drop recommendations should use projections

  @happy-path @projection-integration
  Scenario: View projections on mobile
    Given I am on mobile
    When I view projections
    Then projections should be mobile-friendly
    And key data should be visible

  @happy-path @projection-integration
  Scenario: Export projections to spreadsheet
    Given I want projections externally
    When I export projections
    Then I should receive spreadsheet file
    And all projection data should be included

  @happy-path @projection-integration
  Scenario: Share projection insights
    Given I find valuable insights
    When I share insights
    Then insights should be shareable
    And others can view them
