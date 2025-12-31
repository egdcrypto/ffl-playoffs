@lineup-optimizer @anima-1383
Feature: Lineup Optimizer
  As a fantasy football user
  I want intelligent lineup optimization tools
  So that I can maximize my team's projected points

  Background:
    Given I am a logged-in user
    And the lineup optimizer is available

  # ============================================================================
  # OPTIMAL LINEUP
  # ============================================================================

  @happy-path @optimal-lineup
  Scenario: Auto-optimize lineup
    Given I have players on my roster
    When I auto-optimize my lineup
    Then the best lineup should be generated
    And projected points should be maximized

  @happy-path @optimal-lineup
  Scenario: Generate best lineup
    Given projections are available
    When I generate best lineup
    Then I should see optimal configuration
    And each position should be filled optimally

  @happy-path @optimal-lineup
  Scenario: Maximize projected points
    Given I want maximum points
    When I run optimization
    Then lineup should maximize projections
    And total projected points should be shown

  @happy-path @optimal-lineup
  Scenario: Use one-click optimization
    Given I need quick optimization
    When I click optimize
    Then lineup should be set instantly
    And I should see confirmation

  @happy-path @optimal-lineup
  Scenario: Optimize with current projections
    Given projections update
    When I re-optimize
    Then lineup should use latest projections
    And changes should be highlighted

  @happy-path @optimal-lineup
  Scenario: Optimize for specific week
    Given I select a week
    When I optimize for that week
    Then lineup should be week-specific
    And bye weeks should be considered

  @happy-path @optimal-lineup
  Scenario: View optimization explanation
    Given lineup was optimized
    When I view explanation
    Then I should see why players were chosen
    And alternatives should be shown

  @happy-path @optimal-lineup
  Scenario: Undo optimization
    Given I optimized my lineup
    When I undo optimization
    Then previous lineup should be restored
    And I should see confirmation

  @happy-path @optimal-lineup
  Scenario: Preview optimization before applying
    Given I want to preview
    When I preview optimization
    Then I should see proposed changes
    And I can apply or cancel

  @mobile @optimal-lineup
  Scenario: Optimize lineup on mobile
    Given I am on a mobile device
    When I optimize lineup
    Then optimization should work on mobile
    And interface should be touch-friendly

  # ============================================================================
  # LINEUP CONSTRAINTS
  # ============================================================================

  @happy-path @lineup-constraints
  Scenario: Respect roster limits
    Given roster limits exist
    When I optimize
    Then lineup should respect limits
    And position counts should be correct

  @happy-path @lineup-constraints
  Scenario: Maintain salary cap compliance
    Given a salary cap exists
    When I optimize
    Then lineup should be under cap
    And remaining salary should be shown

  @happy-path @lineup-constraints
  Scenario: Meet position requirements
    Given positions are required
    When I optimize
    Then all positions should be filled
    And requirements should be met

  @happy-path @lineup-constraints
  Scenario: Exclude specific players
    Given I want to exclude players
    When I set exclusions
    Then excluded players should not appear
    And optimization should work around them

  @happy-path @lineup-constraints
  Scenario: Lock specific players
    Given I want certain players locked
    When I lock players in lineup
    Then locked players should remain
    And optimization should fill remaining spots

  @happy-path @lineup-constraints
  Scenario: Set minimum salary usage
    Given I want to use more salary
    When I set minimum salary
    Then lineup should meet minimum
    And value should be optimized

  @happy-path @lineup-constraints
  Scenario: Limit exposure to players
    Given I want exposure limits
    When I set exposure caps
    Then player usage should be limited
    And diversification should increase

  @happy-path @lineup-constraints
  Scenario: Set stack constraints
    Given I want QB-WR stacks
    When I set stack rules
    Then stacks should be included
    And correlation should improve

  @happy-path @lineup-constraints
  Scenario: Avoid player combinations
    Given I want to avoid certain combos
    When I set avoidance rules
    Then those combinations should not occur
    And rules should be enforced

  @happy-path @lineup-constraints
  Scenario: Set team exposure limits
    Given I want team diversity
    When I limit team exposure
    Then no team should exceed limit
    And diversification should be maintained

  # ============================================================================
  # LINEUP PROJECTIONS
  # ============================================================================

  @happy-path @lineup-projections
  Scenario: View projected points integration
    Given projections are available
    When I view lineup
    Then I should see projected points
    And total should be calculated

  @happy-path @lineup-projections
  Scenario: View expected value calculations
    Given expected values exist
    When I view lineup values
    Then I should see expected values
    And value over replacement should be shown

  @happy-path @lineup-projections
  Scenario: View upside potential
    Given upside is calculated
    When I view upside
    Then I should see ceiling projection
    And boom potential should be shown

  @happy-path @lineup-projections
  Scenario: View floor projections
    Given floors are calculated
    When I view floor
    Then I should see minimum expected
    And safety should be indicated

  @happy-path @lineup-projections
  Scenario: View ceiling projections
    Given ceilings are calculated
    When I view ceiling
    Then I should see maximum potential
    And upside should be shown

  @happy-path @lineup-projections
  Scenario: Compare projection sources
    Given multiple sources exist
    When I compare sources
    Then I should see different projections
    And I can select preferred source

  @happy-path @lineup-projections
  Scenario: View projection confidence
    Given confidence varies
    When I view confidence
    Then I should see projection certainty
    And high-confidence should be marked

  @happy-path @lineup-projections
  Scenario: Optimize for floor
    Given I want safety
    When I optimize for floor
    Then lineup should maximize floor
    And consistency should be prioritized

  @happy-path @lineup-projections
  Scenario: Optimize for ceiling
    Given I want upside
    When I optimize for ceiling
    Then lineup should maximize ceiling
    And boom players should be selected

  @happy-path @lineup-projections
  Scenario: View ownership projections
    Given ownership data exists
    When I view ownership
    Then I should see projected ownership
    And leverage opportunities should be shown

  # ============================================================================
  # LINEUP SCENARIOS
  # ============================================================================

  @happy-path @lineup-scenarios
  Scenario: Generate multiple lineups
    Given I need multiple lineups
    When I generate multiple
    Then I should receive several lineups
    And lineups should be unique

  @happy-path @lineup-scenarios
  Scenario: Optimize best ball lineup
    Given best ball rules apply
    When I optimize for best ball
    Then lineup should consider best ball
    And auto-selection should be factored

  @happy-path @lineup-scenarios
  Scenario: Optimize showdown mode
    Given showdown format applies
    When I optimize showdown
    Then captain should be selected
    And multipliers should be considered

  @happy-path @lineup-scenarios
  Scenario: Optimize captain mode
    Given captain format applies
    When I select captain
    Then captain multiplier should apply
    And optimization should account for it

  @happy-path @lineup-scenarios
  Scenario: Optimize for GPP contests
    Given I am entering GPP
    When I optimize for GPP
    Then lineup should be contrarian
    And upside should be maximized

  @happy-path @lineup-scenarios
  Scenario: Optimize for cash games
    Given I am entering cash games
    When I optimize for cash
    Then lineup should be safe
    And floor should be maximized

  @happy-path @lineup-scenarios
  Scenario: Generate tournament lineups
    Given I need many lineups
    When I generate tournament set
    Then I should receive diverse lineups
    And correlation should vary

  @happy-path @lineup-scenarios
  Scenario: Run Monte Carlo simulations
    Given simulations are available
    When I run simulations
    Then I should see outcome distribution
    And win probability should be shown

  @happy-path @lineup-scenarios
  Scenario: Compare scenarios side by side
    Given I have multiple scenarios
    When I compare them
    Then I should see differences
    And trade-offs should be clear

  @happy-path @lineup-scenarios
  Scenario: Save lineup scenarios
    Given I created scenarios
    When I save scenarios
    Then scenarios should be saved
    And I can access them later

  # ============================================================================
  # LINEUP ADVICE
  # ============================================================================

  @happy-path @lineup-advice
  Scenario: Get start/sit recommendations
    Given I need lineup advice
    When I view recommendations
    Then I should see start/sit advice
    And reasoning should be provided

  @happy-path @lineup-advice
  Scenario: View expert picks integration
    Given experts provide picks
    When I view expert picks
    Then I should see expert recommendations
    And expert credentials should be shown

  @happy-path @lineup-advice
  Scenario: View matchup analysis
    Given matchups affect decisions
    When I view matchup analysis
    Then I should see favorable matchups
    And exploitation should be suggested

  @happy-path @lineup-advice
  Scenario: View weekly rankings
    Given rankings are available
    When I view weekly rankings
    Then I should see position rankings
    And my players should be highlighted

  @happy-path @lineup-advice
  Scenario: Get personalized advice
    Given my roster is known
    When I get personalized advice
    Then advice should be roster-specific
    And my situation should be considered

  @happy-path @lineup-advice
  Scenario: View consensus recommendations
    Given multiple sources exist
    When I view consensus
    Then I should see aggregated advice
    And agreement level should be shown

  @happy-path @lineup-advice
  Scenario: Get flex position advice
    Given flex decisions are hard
    When I get flex advice
    Then I should see flex recommendations
    And alternatives should be compared

  @happy-path @lineup-advice
  Scenario: View advice confidence
    Given advice has confidence levels
    When I view confidence
    Then I should see how confident advice is
    And close calls should be noted

  @happy-path @lineup-advice
  Scenario: Explain advice reasoning
    Given advice is provided
    When I ask for explanation
    Then I should see supporting reasoning
    And factors should be listed

  @happy-path @lineup-advice
  Scenario: Disagree with advice
    Given I disagree with advice
    When I override advice
    Then my decision should be saved
    And I can track outcome

  # ============================================================================
  # LINEUP LOCK
  # ============================================================================

  @happy-path @lineup-lock
  Scenario: View lineup lock times
    Given lineups lock at game time
    When I view lock times
    Then I should see when lineups lock
    And countdown should be shown

  @happy-path @lineup-lock
  Scenario: Auto-set before lock
    Given lock time approaches
    When auto-set is enabled
    Then lineup should be set automatically
    And I should be notified

  @happy-path @lineup-lock
  Scenario: Make pre-game adjustments
    Given game hasn't started
    When I make adjustments
    Then changes should be saved
    And new lineup should be confirmed

  @happy-path @lineup-lock
  Scenario: Use late swap support
    Given late swap is enabled
    When I swap players after lock
    Then I should swap unlocked players
    And swap should be saved

  @happy-path @lineup-lock
  Scenario: View which players are locked
    Given some games started
    When I view lineup
    Then locked players should be indicated
    And I cannot change them

  @happy-path @lineup-lock
  Scenario: Receive lock warning
    Given lock time approaches
    When warning threshold is reached
    Then I should receive warning
    And I should set my lineup

  @happy-path @lineup-lock
  Scenario: Set lineup before deadline
    Given deadline approaches
    When I set lineup in time
    Then lineup should be saved
    And I should see confirmation

  @happy-path @lineup-lock
  Scenario: View time until lock
    Given lock time is set
    When I view countdown
    Then I should see time remaining
    And countdown should be accurate

  @error @lineup-lock
  Scenario: Handle missed lineup lock
    Given I missed the lock
    Then I should see error message
    And I cannot make changes

  @happy-path @lineup-lock
  Scenario: Configure lock notifications
    Given I want lock reminders
    When I configure notifications
    Then I should set reminder times
    And preferences should be saved

  # ============================================================================
  # LINEUP COMPARISON
  # ============================================================================

  @happy-path @lineup-comparison
  Scenario: Compare lineup options
    Given I have multiple options
    When I compare lineups
    Then I should see side-by-side comparison
    And differences should be highlighted

  @happy-path @lineup-comparison
  Scenario: Run what-if analysis
    Given I want to test changes
    When I run what-if
    Then I should see projected impact
    And comparison should be clear

  @happy-path @lineup-comparison
  Scenario: Preview trade impact
    Given I am considering a trade
    When I preview trade impact
    Then I should see lineup changes
    And improvement should be quantified

  @happy-path @lineup-comparison
  Scenario: Preview roster changes
    Given I want to change roster
    When I preview changes
    Then I should see lineup impact
    And optimal lineup should update

  @happy-path @lineup-comparison
  Scenario: Compare current vs optimal
    Given my lineup is set
    When I compare to optimal
    Then I should see the difference
    And points left on bench should be shown

  @happy-path @lineup-comparison
  Scenario: Compare to opponent
    Given I have a matchup
    When I compare to opponent
    Then I should see head-to-head comparison
    And advantages should be shown

  @happy-path @lineup-comparison
  Scenario: View improvement opportunities
    Given improvements exist
    When I view opportunities
    Then I should see potential gains
    And actions should be suggested

  @happy-path @lineup-comparison
  Scenario: Compare across weeks
    Given multiple weeks exist
    When I compare weeks
    Then I should see weekly comparisons
    And trends should be visible

  @happy-path @lineup-comparison
  Scenario: Save comparison
    Given I created a comparison
    When I save it
    Then comparison should be saved
    And I can access it later

  @happy-path @lineup-comparison
  Scenario: Share comparison
    Given I want to share
    When I share comparison
    Then shareable link should be created
    And others can view it

  # ============================================================================
  # LINEUP ALERTS
  # ============================================================================

  @happy-path @lineup-alerts
  Scenario: Receive lineup reminders
    Given I have alerts enabled
    When deadline approaches
    Then I should receive reminder
    And I should set my lineup

  @happy-path @lineup-alerts
  Scenario: Receive inactive player alerts
    Given a player is ruled inactive
    When they're in my lineup
    Then I should receive alert
    And I should make changes

  @happy-path @lineup-alerts
  Scenario: Receive injury updates
    Given injuries are reported
    When my player is injured
    Then I should be notified
    And impact should be explained

  @happy-path @lineup-alerts
  Scenario: Receive weather impact alerts
    Given weather affects games
    When weather impacts my players
    Then I should be notified
    And adjustments should be suggested

  @happy-path @lineup-alerts
  Scenario: Configure alert preferences
    Given I want custom alerts
    When I configure preferences
    Then I should set my preferences
    And preferences should be saved

  @happy-path @lineup-alerts
  Scenario: Receive suboptimal lineup alerts
    Given my lineup isn't optimal
    When I have a suboptimal lineup
    Then I should be notified
    And improvements should be suggested

  @happy-path @lineup-alerts
  Scenario: Receive late scratch alerts
    Given a player is scratched
    When scratch is announced
    Then I should be alerted immediately
    And time to react should be noted

  @happy-path @lineup-alerts
  Scenario: View alert history
    Given I have received alerts
    When I view history
    Then I should see past alerts
    And alerts should be searchable

  @happy-path @lineup-alerts
  Scenario: Disable specific alerts
    Given I receive too many alerts
    When I disable specific types
    Then those alerts should stop
    And I can re-enable later

  @happy-path @lineup-alerts
  Scenario: Receive projection change alerts
    Given projections change
    When significant change occurs
    Then I should be notified
    And lineup impact should be shown

  # ============================================================================
  # LINEUP HISTORY
  # ============================================================================

  @happy-path @lineup-history
  Scenario: View past lineups
    Given I have lineup history
    When I view past lineups
    Then I should see historical lineups
    And I can select any week

  @happy-path @lineup-history
  Scenario: Analyze lineup performance
    Given lineups have results
    When I analyze performance
    Then I should see how lineups performed
    And actual vs projected should be shown

  @happy-path @lineup-history
  Scenario: Review past decisions
    Given I made lineup decisions
    When I review decisions
    Then I should see decision outcomes
    And learnings should be identified

  @happy-path @lineup-history
  Scenario: Track lineup ROI
    Given I track results
    When I view ROI
    Then I should see return on decisions
    And performance should be quantified

  @happy-path @lineup-history
  Scenario: View optimal vs actual
    Given historical optimal exists
    When I compare to actual
    Then I should see what was optimal
    And points missed should be shown

  @happy-path @lineup-history
  Scenario: View lineup trends
    Given I have history
    When I view trends
    Then I should see patterns
    And tendencies should be identified

  @happy-path @lineup-history
  Scenario: Export lineup history
    Given I want to export
    When I export history
    Then I should receive export file
    And data should be complete

  @happy-path @lineup-history
  Scenario: View season-long analysis
    Given season has progressed
    When I view season analysis
    Then I should see full season view
    And overall performance should be shown

  # ============================================================================
  # LINEUP EXPORT
  # ============================================================================

  @happy-path @lineup-export
  Scenario: Export lineups
    Given I have lineups
    When I export lineups
    Then I should receive export file
    And format should be selectable

  @happy-path @lineup-export
  Scenario: Share with friends
    Given I want to share
    When I share lineup
    Then shareable link should be created
    And friends can view it

  @happy-path @lineup-export
  Scenario: Sync across platforms
    Given I use multiple platforms
    When I sync lineups
    Then lineups should sync
    And platforms should be connected

  @happy-path @lineup-export
  Scenario: Bulk upload lineups
    Given I have many lineups
    When I bulk upload
    Then lineups should be uploaded
    And validation should occur

  @happy-path @lineup-export
  Scenario: Export to CSV
    Given I want CSV format
    When I export to CSV
    Then I should receive CSV file
    And format should be correct

  @happy-path @lineup-export
  Scenario: Export to DFS site format
    Given I use DFS sites
    When I export for DFS
    Then format should match site
    And upload should be easy

  @happy-path @lineup-export
  Scenario: Print lineup
    Given I want printed lineup
    When I print lineup
    Then printable version should open
    And formatting should be clean

  @happy-path @lineup-export
  Scenario: Copy lineup to clipboard
    Given I want to copy
    When I copy lineup
    Then lineup should be copied
    And I can paste elsewhere

  @happy-path @lineup-export
  Scenario: Import lineup from file
    Given I have a lineup file
    When I import lineup
    Then lineup should be imported
    And validation should occur

  @happy-path @lineup-export
  Scenario: Schedule automatic exports
    Given I want regular exports
    When I schedule exports
    Then exports should run on schedule
    And I should receive them automatically
