@projections @ANIMA-1345
Feature: Projections
  As a fantasy football playoffs application user
  I want comprehensive projection functionality
  So that I can make informed decisions and optimize my lineup

  Background:
    Given the fantasy football playoffs application is running
    And I am logged in as a registered user
    And projection data is available

  # ============================================================================
  # PLAYER PROJECTIONS - HAPPY PATH
  # ============================================================================

  @happy-path @player-projections
  Scenario: View weekly point projections
    Given I want to set my lineup
    When I view player projections
    Then I should see weekly point projections
    And projections should be per player
    And I should use projections for decisions

  @happy-path @player-projections
  Scenario: View rest-of-season projections
    Given I want long-term planning
    When I view ROS projections
    Then I should see remaining season totals
    And projections should factor schedule
    And I should plan accordingly

  @happy-path @player-projections
  Scenario: View playoff-specific projections
    Given playoffs are approaching
    When I view playoff projections
    Then I should see playoff week projections
    And projections should factor playoff matchups
    And I should optimize for playoffs

  @happy-path @player-projections
  Scenario: View position-based projection rankings
    Given I want to compare players
    When I view position rankings
    Then I should see projections ranked by position
    And I should compare within position
    And rankings should be clear

  @happy-path @player-projections
  Scenario: View projection confidence intervals
    Given I want projection reliability
    When I view confidence intervals
    Then I should see projection range
    And I should see high and low estimates
    And confidence should be indicated

  @happy-path @player-projections
  Scenario: View boom/bust probability ratings
    Given I want upside information
    When I view boom/bust ratings
    Then I should see boom probability
    And I should see bust probability
    And I should assess risk/reward

  @happy-path @player-projections
  Scenario: View matchup-adjusted projections
    Given matchups affect performance
    When I view adjusted projections
    Then projections should factor opponent
    And difficult matchups should lower projection
    And favorable matchups should increase

  @happy-path @player-projections
  Scenario: Compare player projections
    Given I am deciding between players
    When I compare projections
    Then I should see side-by-side projections
    And differences should be highlighted
    And I should make informed choice

  # ============================================================================
  # TEAM PROJECTIONS
  # ============================================================================

  @happy-path @team-projections
  Scenario: View weekly team total projections
    Given I have a lineup set
    When I view team projections
    Then I should see projected team total
    And total should sum player projections
    And I should see weekly expectation

  @happy-path @team-projections
  Scenario: View optimal lineup projections
    Given I have roster options
    When I view optimal lineup
    Then I should see best projected lineup
    And optimal total should be shown
    And I should see improvement opportunity

  @happy-path @team-projections
  Scenario: View bench strength projections
    Given I have bench players
    When I view bench projections
    Then I should see bench player projections
    And bench strength should be calculated
    And I should see depth assessment

  @happy-path @team-projections
  Scenario: View injury-adjusted team totals
    Given injuries affect my team
    When I view adjusted projections
    Then projections should factor injuries
    And questionable players should adjust
    And I should see impact

  @happy-path @team-projections
  Scenario: Calculate bye week impact
    Given bye weeks affect my roster
    When I view bye impact
    Then I should see bye week reduction
    And replacement projections should show
    And I should plan for byes

  @happy-path @team-projections
  Scenario: View strength of schedule projections
    Given schedule affects performance
    When I view SOS projections
    Then I should see schedule difficulty
    And future projections should factor SOS
    And I should understand outlook

  # ============================================================================
  # MATCHUP PROJECTIONS
  # ============================================================================

  @happy-path @matchup-projections
  Scenario: View head-to-head win probability
    Given I have a matchup
    When I view win probability
    Then I should see my win percentage
    And I should see opponent's percentage
    And probability should be calculated

  @happy-path @matchup-projections
  Scenario: View projected score differentials
    Given matchup projections exist
    When I view differential
    Then I should see expected margin
    And I should see who is favored
    And differential should be clear

  @happy-path @matchup-projections
  Scenario: View close game likelihood
    Given matchup is projected close
    When I view close game probability
    Then I should see likelihood of close game
    And threshold should be defined
    And I should prepare accordingly

  @happy-path @matchup-projections
  Scenario: View upset probability
    Given I am the underdog
    When I view upset probability
    Then I should see upset chance
    And factors should be shown
    And hope should be provided

  @happy-path @matchup-projections
  Scenario: View key player impact analysis
    Given certain players matter more
    When I view impact analysis
    Then I should see key player projections
    And impact on outcome should be shown
    And I should focus on key players

  @happy-path @matchup-projections
  Scenario: Explore what-if lineup scenarios
    Given I want to test lineups
    When I run what-if scenarios
    Then I should see projection with different players
    And I should compare scenarios
    And I should optimize my lineup

  # ============================================================================
  # PROJECTION SOURCES
  # ============================================================================

  @happy-path @projection-sources
  Scenario: View multiple projection providers
    Given multiple sources exist
    When I view projections
    Then I should see various provider projections
    And I should compare sources
    And I should see differences

  @happy-path @projection-sources
  Scenario: View consensus projection aggregation
    Given multiple sources are available
    When I view consensus projections
    Then I should see aggregated projection
    And consensus should combine sources
    And I should see unified view

  @happy-path @projection-sources
  Scenario: Import expert projections
    Given expert projections exist
    When I import expert data
    Then expert projections should load
    And I should see expert opinions
    And I should factor expertise

  @happy-path @projection-sources
  Scenario: Input custom projections
    Given I have my own projections
    When I enter custom projections
    Then custom values should be saved
    And my projections should be used
    And I should customize my view

  @happy-path @projection-sources
  Scenario: Track historical accuracy
    Given past projections exist
    When I view accuracy tracking
    Then I should see historical accuracy
    And I should see source performance
    And I should trust reliable sources

  @happy-path @projection-sources
  Scenario: View source reliability ratings
    Given sources have track records
    When I view reliability
    Then I should see source ratings
    And ratings should reflect accuracy
    And I should weight sources accordingly

  # ============================================================================
  # PROJECTION MODELS
  # ============================================================================

  @happy-path @projection-models
  Scenario: View standard projection algorithms
    Given standard models exist
    When I view standard projections
    Then I should see algorithm-based projections
    And methodology should be transparent
    And projections should be reasonable

  @happy-path @projection-models
  Scenario: View machine learning predictions
    Given ML models are available
    When I view ML projections
    Then I should see ML-based projections
    And model should factor many variables
    And predictions should be sophisticated

  @happy-path @projection-models
  Scenario: View Vegas-based projections
    Given Vegas lines are available
    When I view Vegas projections
    Then I should see Vegas-derived projections
    And game totals should factor in
    And sharp money should influence

  @happy-path @projection-models
  Scenario: View weather-adjusted projections
    Given weather affects games
    When I view weather adjustments
    Then projections should factor weather
    And outdoor games should adjust
    And I should see weather impact

  @happy-path @projection-models
  Scenario: View home/away adjustments
    Given home field matters
    When I view location adjustments
    Then home games should boost projections
    And away games should reduce
    And adjustment should be shown

  @happy-path @projection-models
  Scenario: View primetime game adjustments
    Given primetime affects performance
    When I view primetime adjustments
    Then primetime games should adjust
    And player tendencies should factor
    And spotlight effect should show

  # ============================================================================
  # LIVE PROJECTION UPDATES
  # ============================================================================

  @happy-path @live-projections
  Scenario: View in-game projection adjustments
    Given games are in progress
    When projections adjust
    Then I should see live projection updates
    And projections should change with game flow
    And I should see real-time adjustments

  @happy-path @live-projections
  Scenario: View real-time win probability
    Given my matchup is live
    When I view win probability
    Then probability should update in real-time
    And swings should be visible
    And I should see my chances

  @happy-path @live-projections
  Scenario: View projected final scores
    Given games are in progress
    When I view projected finals
    Then I should see projected final score
    And projection should update as games progress
    And I should see likely outcome

  @happy-path @live-projections
  Scenario: Calculate points needed to win
    Given I am tracking my matchup
    When I view points needed
    Then I should see how many points I need
    And calculation should be accurate
    And I should know what's required

  @happy-path @live-projections
  Scenario: View comeback probability
    Given I am trailing
    When I view comeback probability
    Then I should see chance of comeback
    And remaining players should factor
    And hope should be quantified

  @happy-path @live-projections
  Scenario: View garbage time projections
    Given game is in garbage time
    When I view projections
    Then garbage time should factor in
    And stat accumulation should adjust
    And projections should be realistic

  # ============================================================================
  # PROJECTION ANALYTICS
  # ============================================================================

  @happy-path @projection-analytics
  Scenario: Compare projection vs actual
    Given games are complete
    When I compare projections
    Then I should see projection vs actual
    And differences should be highlighted
    And I should assess accuracy

  @happy-path @projection-analytics
  Scenario: Track accuracy over time
    Given projection history exists
    When I view accuracy trends
    Then I should see accuracy over time
    And trends should be visible
    And I should see improvement or decline

  @happy-path @projection-analytics
  Scenario: View player projection trends
    Given player data exists
    When I view player trends
    Then I should see projection trends
    And I should see rising/falling players
    And I should identify hot players

  @happy-path @projection-analytics
  Scenario: Analyze projection variance
    Given projections vary
    When I analyze variance
    Then I should see projection variance
    And I should see consensus agreement
    And I should assess confidence

  @happy-path @projection-analytics
  Scenario: View model performance metrics
    Given models have track records
    When I view model performance
    Then I should see model accuracy stats
    And I should see MAE, RMSE, etc.
    And I should trust better models

  @happy-path @projection-analytics
  Scenario: View projection leaderboards
    Given projectors compete
    When I view leaderboards
    Then I should see top projection sources
    And rankings should reflect accuracy
    And I should follow top sources

  # ============================================================================
  # PROJECTION CUSTOMIZATION
  # ============================================================================

  @happy-path @projection-customization
  Scenario: Set custom projection weights
    Given multiple sources exist
    When I set custom weights
    Then my weights should apply
    And weighted projections should calculate
    And I should see personalized projections

  @happy-path @projection-customization
  Scenario: Select favorite sources
    Given many sources are available
    When I select favorites
    Then favorite sources should be prioritized
    And I should see my preferred projections
    And selection should persist

  @happy-path @projection-customization
  Scenario: Configure projection display preferences
    Given display options exist
    When I configure preferences
    Then display should match my preferences
    And I should see what I want
    And preferences should save

  @happy-path @projection-customization
  Scenario: Set alert thresholds for changes
    Given projections change
    When I set alert thresholds
    Then I should receive alerts for big changes
    And threshold should be customizable
    And I should stay informed

  @happy-path @projection-customization
  Scenario: Export projections
    Given I want to analyze elsewhere
    When I export projections
    Then I should receive projection data
    And format should be usable
    And export should be complete

  # ============================================================================
  # PLAYOFF-SPECIFIC PROJECTIONS
  # ============================================================================

  @happy-path @playoff-projections
  Scenario: View playoff advancement probability
    Given playoffs are coming
    When I view advancement odds
    Then I should see probability of advancing
    And each round should have odds
    And I should see my path

  @happy-path @playoff-projections
  Scenario: View championship odds
    Given I want to win it all
    When I view championship odds
    Then I should see my title probability
    And odds should factor all scenarios
    And I should see my chances

  @happy-path @playoff-projections
  Scenario: Assess elimination risk
    Given I could be eliminated
    When I view elimination risk
    Then I should see elimination probability
    And risk factors should be shown
    And I should understand my situation

  @happy-path @playoff-projections
  Scenario: View optimal playoff strategy
    Given strategy matters in playoffs
    When I view strategic recommendations
    Then I should see optimal moves
    And trade targets should be suggested
    And I should execute strategy

  @happy-path @playoff-projections
  Scenario: Analyze must-win scenarios
    Given I must win to advance
    When I view must-win analysis
    Then I should see what's required
    And scenarios should be clear
    And I should prepare accordingly

  @happy-path @playoff-projections
  Scenario: View clinching scenarios
    Given I could clinch playoff spot
    When I view clinching scenarios
    Then I should see what's needed to clinch
    And scenarios should be clear
    And I should know my path

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Handle projection data unavailable
    Given projection data is expected
    When data is unavailable
    Then I should see appropriate message
    And fallback projections should show
    And I should retry later

  @error
  Scenario: Handle projection calculation error
    Given projection calculation occurs
    When calculation fails
    Then I should see error message
    And last known projections should show
    And issue should be logged

  @error
  Scenario: Handle missing player projection
    Given I need a player's projection
    When projection is missing
    Then I should see missing indicator
    And I should see why it's missing
    And I should proceed without it

  @error
  Scenario: Handle source connection failure
    Given projection source is needed
    When connection fails
    Then I should see connection error
    And other sources should work
    And I should retry later

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: View projections on mobile
    Given I am using the mobile app
    When I view projections
    Then display should be mobile-optimized
    And projections should be readable
    And I should scroll and interact

  @mobile
  Scenario: Compare players on mobile
    Given I am on mobile
    When I compare player projections
    Then comparison should work on mobile
    And I should swipe between players
    And data should be clear

  @mobile
  Scenario: View live projections on mobile
    Given games are in progress on mobile
    When I view live updates
    Then projections should update on mobile
    And experience should be smooth
    And I should track in real-time

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate projections with keyboard
    Given I am using keyboard navigation
    When I browse projections
    Then I should navigate with keyboard
    And all data should be accessible
    And focus should be visible

  @accessibility
  Scenario: Screen reader projection access
    Given I am using a screen reader
    When I view projections
    Then projections should be announced
    And numbers should be read correctly
    And structure should be clear

  @accessibility
  Scenario: High contrast projection display
    Given I have high contrast enabled
    When I view projections
    Then numbers should be readable
    And charts should be accessible
    And data should be clear

  @accessibility
  Scenario: Projections with reduced motion
    Given I have reduced motion enabled
    When live updates occur
    Then animations should be minimal
    And updates should still be visible
    And functionality should work
