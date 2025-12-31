@projections @anima-1409
Feature: Projections
  As a fantasy football user
  I want comprehensive projection capabilities
  So that I can make informed lineup and roster decisions

  Background:
    Given I am a logged-in user
    And the projection system is available

  # ============================================================================
  # PROJECTION OVERVIEW
  # ============================================================================

  @happy-path @projection-overview
  Scenario: View projection dashboard
    Given projections exist
    When I view projection dashboard
    Then I should see dashboard
    And key projections should be displayed

  @happy-path @projection-overview
  Scenario: View weekly projections
    Given week is upcoming
    When I view weekly projections
    Then I should see this week's projections
    And all players should be included

  @happy-path @projection-overview
  Scenario: View season projections
    Given season is ongoing
    When I view season projections
    Then I should see remaining season projections
    And trends should be visible

  @happy-path @projection-overview
  Scenario: View projection summary
    Given projections are calculated
    When I view summary
    Then I should see projection summary
    And key insights should be highlighted

  @happy-path @projection-overview
  Scenario: View key projections
    Given key players exist
    When I view key projections
    Then I should see important projections
    And they should be prioritized

  @happy-path @projection-overview
  Scenario: View projection trends
    Given trends exist
    When I view trends
    Then I should see projection trends
    And direction should be clear

  @happy-path @projection-overview
  Scenario: View projection on mobile
    Given I am on mobile
    When I view projections
    Then display should be mobile-friendly
    And all data should be accessible

  @happy-path @projection-overview
  Scenario: Customize projection dashboard
    Given customization is available
    When I customize dashboard
    Then preferences should be saved
    And dashboard should reflect them

  @happy-path @projection-overview
  Scenario: Refresh projections
    Given projections may have changed
    When I refresh projections
    Then projections should update
    And latest data should show

  @happy-path @projection-overview
  Scenario: View projection timestamp
    Given projections have timestamp
    When I view timestamp
    Then I should see when updated
    And freshness should be clear

  # ============================================================================
  # PLAYER PROJECTIONS
  # ============================================================================

  @happy-path @player-projections
  Scenario: View player forecasts
    Given player has forecasts
    When I view player forecasts
    Then I should see player projections
    And they should be detailed

  @happy-path @player-projections
  Scenario: View individual projections
    Given player exists
    When I view individual projection
    Then I should see their projection
    And breakdown should be shown

  @happy-path @player-projections
  Scenario: View position projections
    Given position exists
    When I view position projections
    Then I should see position rankings
    And all players should be ranked

  @happy-path @player-projections
  Scenario: View projection accuracy
    Given past projections exist
    When I view accuracy
    Then I should see accuracy metrics
    And reliability should be indicated

  @happy-path @player-projections
  Scenario: View projection range
    Given range is calculated
    When I view range
    Then I should see floor and ceiling
    And variance should be shown

  @happy-path @player-projections
  Scenario: View projection breakdown
    Given breakdown exists
    When I view breakdown
    Then I should see scoring breakdown
    And each category should be projected

  @happy-path @player-projections
  Scenario: Compare player projections
    Given players exist
    When I compare projections
    Then I should see comparison
    And differences should be clear

  @happy-path @player-projections
  Scenario: View projection history
    Given history exists
    When I view history
    Then I should see past projections
    And accuracy should be tracked

  @happy-path @player-projections
  Scenario: Search player projections
    Given many players exist
    When I search player
    Then I should find projection
    And results should be quick

  @happy-path @player-projections
  Scenario: Filter by position
    Given positions exist
    When I filter by position
    Then I should see position only
    And rankings should update

  # ============================================================================
  # TEAM PROJECTIONS
  # ============================================================================

  @happy-path @team-projections
  Scenario: View team forecasts
    Given team exists
    When I view team forecasts
    Then I should see team projections
    And they should be comprehensive

  @happy-path @team-projections
  Scenario: View roster projections
    Given roster is set
    When I view roster projections
    Then I should see roster totals
    And each player should be included

  @happy-path @team-projections
  Scenario: View lineup projections
    Given lineup is set
    When I view lineup projections
    Then I should see starting lineup projection
    And total should be calculated

  @happy-path @team-projections
  Scenario: View bench projections
    Given bench has players
    When I view bench projections
    Then I should see bench projections
    And potential should be shown

  @happy-path @team-projections
  Scenario: View total team projection
    Given team is complete
    When I view total
    Then I should see team total
    And it should be accurate

  @happy-path @team-projections
  Scenario: View projection by position
    Given positions are filled
    When I view by position
    Then I should see position breakdown
    And contributions should be clear

  @happy-path @team-projections
  Scenario: Compare to league average
    Given averages exist
    When I compare to average
    Then I should see comparison
    And ranking should be shown

  @happy-path @team-projections
  Scenario: View optimal lineup projection
    Given optimal is calculated
    When I view optimal
    Then I should see best possible lineup
    And I can apply it

  @happy-path @team-projections
  Scenario: View projection changes
    Given lineup changed
    When I view changes
    Then I should see projection impact
    And difference should be shown

  @happy-path @team-projections
  Scenario: Project future weeks
    Given future exists
    When I project future
    Then I should see future projections
    And schedule should be considered

  # ============================================================================
  # MATCHUP PROJECTIONS
  # ============================================================================

  @happy-path @matchup-projections
  Scenario: View matchup forecast
    Given matchup exists
    When I view matchup forecast
    Then I should see both teams
    And projections should be compared

  @happy-path @matchup-projections
  Scenario: View win probability
    Given probability is calculated
    When I view win probability
    Then I should see win chance
    And confidence should be shown

  @happy-path @matchup-projections
  Scenario: View projected score
    Given scores are projected
    When I view projected score
    Then I should see expected scores
    And margin should be calculated

  @happy-path @matchup-projections
  Scenario: View margin of victory
    Given margin is calculated
    When I view margin
    Then I should see expected margin
    And closeness should be indicated

  @happy-path @matchup-projections
  Scenario: View upset probability
    Given underdog exists
    When I view upset probability
    Then I should see upset chance
    And factors should be explained

  @happy-path @matchup-projections
  Scenario: View head-to-head comparison
    Given both teams set
    When I view comparison
    Then I should see position comparisons
    And advantages should be shown

  @happy-path @matchup-projections
  Scenario: View key matchups
    Given matchups within matchup
    When I view key matchups
    Then I should see important player matchups
    And impact should be clear

  @happy-path @matchup-projections
  Scenario: Simulate matchup
    Given simulation is available
    When I simulate matchup
    Then simulation should run
    And outcomes should be shown

  @happy-path @matchup-projections
  Scenario: View projection confidence
    Given confidence is calculated
    When I view confidence
    Then I should see confidence level
    And uncertainty should be shown

  @happy-path @matchup-projections
  Scenario: Compare to actual results
    Given matchup completed
    When I compare to actual
    Then I should see comparison
    And accuracy should be shown

  # ============================================================================
  # PROJECTION SOURCES
  # ============================================================================

  @happy-path @projection-sources
  Scenario: View expert projections
    Given experts provide projections
    When I view expert projections
    Then I should see expert picks
    And sources should be credited

  @happy-path @projection-sources
  Scenario: View consensus projections
    Given consensus is calculated
    When I view consensus
    Then I should see averaged projections
    And methodology should be clear

  @happy-path @projection-sources
  Scenario: View algorithm projections
    Given algorithm runs
    When I view algorithm projections
    Then I should see calculated projections
    And model should be explained

  @happy-path @projection-sources
  Scenario: Create custom projections
    Given I want custom
    When I create custom projections
    Then I should be able to adjust
    And my projections should save

  @happy-path @projection-sources
  Scenario: View projection providers
    Given providers exist
    When I view providers
    Then I should see all sources
    And I can choose preferred

  @happy-path @projection-sources
  Scenario: Compare source accuracy
    Given accuracy is tracked
    When I compare accuracy
    Then I should see source rankings
    And reliability should be clear

  @happy-path @projection-sources
  Scenario: Switch projection source
    Given sources are available
    When I switch source
    Then projections should update
    And new source should apply

  @happy-path @projection-sources
  Scenario: Blend projection sources
    Given blending is available
    When I blend sources
    Then projections should combine
    And weights should be applied

  @happy-path @projection-sources
  Scenario: View source methodology
    Given methodology exists
    When I view methodology
    Then I should see how calculated
    And factors should be explained

  @happy-path @projection-sources
  Scenario: Rate projection source
    Given source is used
    When I rate source
    Then rating should be saved
    And it should help others

  # ============================================================================
  # PROJECTION COMPARISON
  # ============================================================================

  @happy-path @projection-comparison
  Scenario: Compare projections
    Given multiple projections exist
    When I compare projections
    Then I should see comparison
    And differences should be shown

  @happy-path @projection-comparison
  Scenario: Compare source projections
    Given sources differ
    When I compare sources
    Then I should see source comparison
    And variations should be clear

  @happy-path @projection-comparison
  Scenario: Compare projection vs actual
    Given actuals exist
    When I compare to actual
    Then I should see comparison
    And accuracy should be calculated

  @happy-path @projection-comparison
  Scenario: View historical accuracy
    Given history exists
    When I view accuracy
    Then I should see historical accuracy
    And trends should be visible

  @happy-path @projection-comparison
  Scenario: View projection trends
    Given trends exist
    When I view trends
    Then I should see projection changes
    And direction should be clear

  @happy-path @projection-comparison
  Scenario: Compare week-over-week
    Given weeks exist
    When I compare weeks
    Then I should see changes
    And reasons should be shown

  @happy-path @projection-comparison
  Scenario: Compare to ADP
    Given ADP exists
    When I compare to ADP
    Then I should see ADP comparison
    And value should be indicated

  @happy-path @projection-comparison
  Scenario: Compare floor vs ceiling
    Given range exists
    When I compare floor to ceiling
    Then I should see range comparison
    And risk should be clear

  @happy-path @projection-comparison
  Scenario: Export comparison
    Given comparison exists
    When I export comparison
    Then export should be created
    And data should be complete

  @happy-path @projection-comparison
  Scenario: Share comparison
    Given comparison exists
    When I share comparison
    Then shareable link should be created
    And others can view

  # ============================================================================
  # PROJECTION SETTINGS
  # ============================================================================

  @happy-path @projection-settings
  Scenario: Configure projection preferences
    Given preferences exist
    When I configure preferences
    Then preferences should be saved
    And projections should follow them

  @happy-path @projection-settings
  Scenario: Set default source
    Given sources exist
    When I set default source
    Then default should be saved
    And it should be used

  @happy-path @projection-settings
  Scenario: Configure projection weights
    Given weights are adjustable
    When I configure weights
    Then weights should be saved
    And projections should adjust

  @happy-path @projection-settings
  Scenario: Make custom adjustments
    Given adjustments are available
    When I make adjustments
    Then adjustments should apply
    And projections should update

  @happy-path @projection-settings
  Scenario: Configure display settings
    Given display options exist
    When I configure display
    Then settings should be saved
    And display should update

  @happy-path @projection-settings
  Scenario: Set projection format
    Given formats exist
    When I set format
    Then format should be saved
    And projections should display accordingly

  @happy-path @projection-settings
  Scenario: Configure decimal places
    Given precision options exist
    When I set decimal places
    Then precision should be saved
    And numbers should display accordingly

  @happy-path @projection-settings
  Scenario: Reset projection settings
    Given I have custom settings
    When I reset settings
    Then defaults should be restored
    And I should confirm first

  @happy-path @projection-settings
  Scenario: Export settings
    Given settings are configured
    When I export settings
    Then settings should be exported
    And I can import elsewhere

  @happy-path @projection-settings
  Scenario: Import settings
    Given settings file exists
    When I import settings
    Then settings should be applied
    And projections should update

  # ============================================================================
  # PROJECTION UPDATES
  # ============================================================================

  @happy-path @projection-updates
  Scenario: View real-time updates
    Given updates are available
    When I view updates
    Then I should see real-time changes
    And they should be immediate

  @happy-path @projection-updates
  Scenario: View projection changes
    Given projections changed
    When I view changes
    Then I should see what changed
    And reasons should be shown

  @happy-path @projection-updates
  Scenario: View pre-game updates
    Given game is approaching
    When I view pre-game
    Then I should see latest projections
    And factors should be current

  @happy-path @projection-updates
  Scenario: View in-game adjustments
    Given game is in progress
    When I view in-game
    Then I should see adjusted projections
    And live data should be used

  @happy-path @projection-updates
  Scenario: View post-game analysis
    Given game completed
    When I view post-game
    Then I should see analysis
    And accuracy should be reviewed

  @happy-path @projection-updates
  Scenario: Track update history
    Given updates occurred
    When I view update history
    Then I should see all updates
    And timeline should be clear

  @happy-path @projection-updates
  Scenario: Enable auto-refresh
    Given auto-refresh exists
    When I enable auto-refresh
    Then projections should update automatically
    And frequency should be configurable

  @happy-path @projection-updates
  Scenario: View update reasons
    Given update has reasons
    When I view reasons
    Then I should see why updated
    And factors should be listed

  @happy-path @projection-updates
  Scenario: Subscribe to updates
    Given subscription is available
    When I subscribe
    Then I should receive updates
    And they should be timely

  @happy-path @projection-updates
  Scenario: View injury impact updates
    Given injury occurred
    When I view impact
    Then I should see projection changes
    And affected players should be shown

  # ============================================================================
  # PROJECTION ALERTS
  # ============================================================================

  @happy-path @projection-alerts
  Scenario: Receive projection notifications
    Given alerts are enabled
    When projection changes significantly
    Then I should receive notification
    And change should be shown

  @happy-path @projection-alerts
  Scenario: Receive significant change alerts
    Given threshold is set
    When change exceeds threshold
    Then I should be alerted
    And magnitude should be shown

  @happy-path @projection-alerts
  Scenario: Configure threshold alerts
    Given thresholds exist
    When I configure thresholds
    Then thresholds should be saved
    And alerts should follow them

  @happy-path @projection-alerts
  Scenario: Receive breakout projections
    Given breakout is projected
    When breakout is identified
    Then I should be alerted
    And opportunity should be explained

  @happy-path @projection-alerts
  Scenario: Receive bust alerts
    Given bust is projected
    When bust is identified
    Then I should be alerted
    And risk should be explained

  @happy-path @projection-alerts
  Scenario: Receive lineup alerts
    Given lineup is suboptimal
    When better option exists
    Then I should be alerted
    And suggestion should be made

  @happy-path @projection-alerts
  Scenario: Configure alert preferences
    Given preferences exist
    When I configure preferences
    Then preferences should be saved
    And alerts should follow them

  @happy-path @projection-alerts
  Scenario: Disable projection alerts
    Given I receive too many
    When I disable alerts
    Then alerts should stop
    And I can re-enable later

  @happy-path @projection-alerts
  Scenario: View alert history
    Given alerts have been sent
    When I view history
    Then I should see past alerts
    And I can review them

  @happy-path @projection-alerts
  Scenario: Set quiet hours
    Given I need quiet time
    When I set quiet hours
    Then alerts should pause
    And they should resume after

  # ============================================================================
  # PROJECTION ANALYSIS
  # ============================================================================

  @happy-path @projection-analysis
  Scenario: View projection breakdown
    Given breakdown exists
    When I view breakdown
    Then I should see detailed breakdown
    And each component should be shown

  @happy-path @projection-analysis
  Scenario: View scoring breakdown
    Given scoring is projected
    When I view scoring breakdown
    Then I should see by-category projections
    And totals should match

  @happy-path @projection-analysis
  Scenario: View opportunity analysis
    Given opportunities are tracked
    When I view opportunity analysis
    Then I should see volume projections
    And usage should be shown

  @happy-path @projection-analysis
  Scenario: View matchup analysis
    Given matchup affects projection
    When I view matchup analysis
    Then I should see matchup impact
    And adjustments should be explained

  @happy-path @projection-analysis
  Scenario: View situational projections
    Given situations vary
    When I view situational
    Then I should see context-based projections
    And factors should be shown

  @happy-path @projection-analysis
  Scenario: View weather impact
    Given weather is factor
    When I view weather impact
    Then I should see weather adjustment
    And effect should be explained

  @happy-path @projection-analysis
  Scenario: View rest/fatigue analysis
    Given rest is tracked
    When I view rest analysis
    Then I should see fatigue impact
    And schedule should be considered

  @happy-path @projection-analysis
  Scenario: View red zone analysis
    Given red zone is tracked
    When I view red zone
    Then I should see red zone projections
    And TD probability should be shown

  @happy-path @projection-analysis
  Scenario: Export analysis
    Given analysis exists
    When I export analysis
    Then export should be created
    And data should be complete

  @happy-path @projection-analysis
  Scenario: View variance analysis
    Given variance exists
    When I view variance
    Then I should see projection uncertainty
    And confidence should be shown

