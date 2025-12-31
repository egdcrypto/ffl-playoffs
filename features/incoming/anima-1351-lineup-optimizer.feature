@lineup-optimizer @ANIMA-1351
Feature: Lineup Optimizer
  As a fantasy football playoffs application user
  I want intelligent lineup optimization tools
  So that I can set optimal starting lineups for fantasy football playoffs

  Background:
    Given the fantasy football playoffs application is running
    And I am logged in as a registered user
    And projection data is available for optimization

  # ============================================================================
  # AUTOMATIC LINEUP OPTIMIZATION - HAPPY PATH
  # ============================================================================

  @happy-path @auto-optimization
  Scenario: Generate one-click optimal lineup
    Given I have players on my roster
    When I click optimize lineup
    Then optimal lineup should be generated
    And best players should be in starting slots
    And I should see projected total

  @happy-path @auto-optimization
  Scenario: Optimize using projection-based analysis
    Given projections are available
    When I run optimization
    Then projections should drive selections
    And highest projected players should start
    And I should see projection breakdown

  @happy-path @auto-optimization
  Scenario: Support PPR scoring format optimization
    Given my league uses PPR scoring
    When I optimize lineup
    Then PPR values should be used
    And pass-catching players should be valued
    And lineup should be PPR-optimized

  @happy-path @auto-optimization
  Scenario: Support Standard scoring format optimization
    Given my league uses Standard scoring
    When I optimize lineup
    Then Standard values should be used
    And rushing should be valued appropriately
    And lineup should be Standard-optimized

  @happy-path @auto-optimization
  Scenario: Support Half-PPR scoring format optimization
    Given my league uses Half-PPR scoring
    When I optimize lineup
    Then Half-PPR values should be used
    And balance should be reflected
    And lineup should be Half-PPR-optimized

  @happy-path @auto-optimization
  Scenario: Optimize flex position selection
    Given I have flex-eligible players
    When I optimize lineup
    Then best flex option should be selected
    And flex should maximize total points
    And position eligibility should be respected

  @happy-path @auto-optimization
  Scenario: Optimize superflex/2QB lineup
    Given my league has superflex slot
    When I optimize lineup
    Then QB value should be considered for superflex
    And optimal superflex choice should be made
    And lineup should maximize points

  @happy-path @auto-optimization
  Scenario: Optimize IDP lineup positions
    Given my league uses IDP
    When I optimize lineup
    Then defensive players should be optimized
    And IDP positions should be filled optimally
    And total lineup should be maximized

  @happy-path @auto-optimization
  Scenario: Apply optimization instantly
    Given I want quick optimization
    When I trigger optimize
    Then optimization should complete quickly
    And lineup should update immediately
    And I should see results fast

  # ============================================================================
  # OPTIMIZATION FACTORS
  # ============================================================================

  @happy-path @optimization-factors
  Scenario: Integrate player projections
    Given projections are updated
    When optimization runs
    Then latest projections should be used
    And projections should drive decisions
    And I should see projection source

  @happy-path @optimization-factors
  Scenario: Weight matchup difficulty
    Given matchups vary in difficulty
    When optimization considers matchups
    Then favorable matchups should boost value
    And tough matchups should reduce value
    And matchup impact should show

  @happy-path @optimization-factors
  Scenario: Consider weather impact
    Given weather affects games
    When optimization factors weather
    Then bad weather should impact projections
    And indoor games should be unaffected
    And weather adjustment should show

  @happy-path @optimization-factors
  Scenario: Factor injury status
    Given players have injury designations
    When optimization considers injuries
    Then injured players should be flagged
    And questionable players should be assessed
    And healthy players should be preferred

  @happy-path @optimization-factors
  Scenario: Exclude bye week players
    Given some players are on bye
    When optimization runs
    Then bye week players should be excluded
    And only active players should be considered
    And bye players should go to bench

  @happy-path @optimization-factors
  Scenario: Verify game times
    Given games have different start times
    When optimization considers timing
    Then locked games should be handled
    And late game flexibility should factor
    And timing should be verified

  @happy-path @optimization-factors
  Scenario: Consider home/away factors
    Given players play home or away
    When optimization factors location
    Then home advantage should be considered
    And away performance should factor
    And location impact should show

  @happy-path @optimization-factors
  Scenario: Factor recent performance trends
    Given players have recent game data
    When optimization considers trends
    Then hot players should get boost
    And cold players should be flagged
    And trends should influence decisions

  # ============================================================================
  # CONSTRAINT HANDLING
  # ============================================================================

  @happy-path @constraint-handling
  Scenario: Enforce position eligibility rules
    Given positions have requirements
    When optimization assigns players
    Then position eligibility should be enforced
    And only eligible players should fill slots
    And rules should be respected

  @happy-path @constraint-handling
  Scenario: Fill all roster slot requirements
    Given roster has required slots
    When optimization completes
    Then all slots should be filled
    And no empty slots should exist
    And roster should be complete

  @happy-path @constraint-handling
  Scenario: Handle Thursday player locking
    Given Thursday games lock early
    When Thursday game starts
    Then Thursday players should lock
    And optimization should respect locks
    And locked players should not move

  @happy-path @constraint-handling
  Scenario: Handle game-time decisions
    Given player is GTD
    When optimization runs before game
    Then GTD status should be flagged
    And backup plan should be suggested
    And I should monitor status

  @happy-path @constraint-handling
  Scenario: Manage IR slot exclusions
    Given players are on IR
    When optimization runs
    Then IR players should be excluded
    And only active players should start
    And IR should be managed separately

  @happy-path @constraint-handling
  Scenario: Handle taxi squad exclusions
    Given dynasty league has taxi squad
    When optimization runs
    Then taxi players should be excluded
    And only active roster should optimize
    And taxi should be separate

  @happy-path @constraint-handling
  Scenario: Respect maximum position limits
    Given positions have max limits
    When optimization runs
    Then max limits should be respected
    And no position should exceed limit
    And constraints should be enforced

  @happy-path @constraint-handling
  Scenario: Handle multi-position eligible players
    Given player is eligible for multiple positions
    When optimization assigns player
    Then best position should be selected
    And overall lineup should be optimized
    And flexibility should be utilized

  # ============================================================================
  # OPTIMIZATION MODES
  # ============================================================================

  @happy-path @optimization-modes
  Scenario: Optimize for maximum projected points
    Given I want highest projection
    When I select max points mode
    Then lineup should maximize projections
    And highest upside should be selected
    And total should be maximized

  @happy-path @optimization-modes
  Scenario: Optimize for floor (safe picks)
    Given I want safe floor
    When I select floor optimization
    Then consistent players should be selected
    And low-variance options should be preferred
    And floor should be maximized

  @happy-path @optimization-modes
  Scenario: Optimize for ceiling (boom potential)
    Given I want highest ceiling
    When I select ceiling optimization
    Then high-upside players should be selected
    And boom potential should be prioritized
    And ceiling should be maximized

  @happy-path @optimization-modes
  Scenario: Optimize for balanced risk/reward
    Given I want balance
    When I select balanced mode
    Then mix of safe and boom should be selected
    And risk should be balanced
    And lineup should be diversified

  @happy-path @optimization-modes
  Scenario: Optimize for contrarian plays
    Given I want low ownership
    When I select contrarian mode
    Then less popular players should be favored
    And ownership should be considered
    And differentiation should be prioritized

  @happy-path @optimization-modes
  Scenario: Optimize with stack strategy
    Given I want player stacks
    When I select stack optimization
    Then same-team players should be grouped
    And QB-WR stacks should be considered
    And stack correlation should be used

  @happy-path @optimization-modes
  Scenario: Switch between optimization modes
    Given multiple modes are available
    When I switch modes
    Then lineup should recalculate
    And mode should apply
    And I should see mode differences

  @happy-path @optimization-modes
  Scenario: Compare optimization mode results
    Given I want to compare modes
    When I compare results
    Then I should see side-by-side comparison
    And differences should be highlighted
    And I should choose best approach

  # ============================================================================
  # WHAT-IF ANALYSIS
  # ============================================================================

  @happy-path @what-if-analysis
  Scenario: Analyze swap player scenarios
    Given I want to swap players
    When I run swap analysis
    Then I should see impact of swap
    And point difference should show
    And I should make informed decision

  @happy-path @what-if-analysis
  Scenario: Compare bench vs starter
    Given I have bench options
    When I compare to starter
    Then I should see comparison
    And projections should be shown
    And better option should be clear

  @happy-path @what-if-analysis
  Scenario: Analyze trade impact on lineup
    Given I'm considering a trade
    When I analyze trade impact
    Then I should see lineup change
    And new optimal lineup should show
    And I should understand trade effect

  @happy-path @what-if-analysis
  Scenario: Analyze waiver pickup impact
    Given waiver target is available
    When I analyze pickup impact
    Then I should see lineup improvement
    And new player should be placed
    And impact should be quantified

  @happy-path @what-if-analysis
  Scenario: Simulate injury replacement
    Given starter may be injured
    When I simulate replacement
    Then I should see backup in lineup
    And point impact should show
    And contingency should be clear

  @happy-path @what-if-analysis
  Scenario: Compare multiple lineup scenarios
    Given I have different options
    When I compare scenarios
    Then I should see multiple lineups
    And I should compare projections
    And best scenario should be identified

  @happy-path @what-if-analysis
  Scenario: Save what-if scenarios
    Given I ran scenarios
    When I save scenarios
    Then scenarios should be saved
    And I should access them later
    And history should persist

  @happy-path @what-if-analysis
  Scenario: Share what-if analysis
    Given I want advice
    When I share analysis
    Then I should generate shareable view
    And others should see scenarios
    And sharing should work

  # ============================================================================
  # START/SIT RECOMMENDATIONS
  # ============================================================================

  @happy-path @start-sit
  Scenario: View position-by-position analysis
    Given I need start/sit help
    When I view position analysis
    Then I should see recommendations by position
    And each position should have advice
    And I should make decisions

  @happy-path @start-sit
  Scenario: Compare players head-to-head
    Given I'm deciding between players
    When I compare head-to-head
    Then I should see direct comparison
    And stats should be side-by-side
    And winner should be suggested

  @happy-path @start-sit
  Scenario: View expert consensus integration
    Given experts have opinions
    When I view expert consensus
    Then I should see aggregated advice
    And consensus should guide decision
    And I should see expert agreement

  @happy-path @start-sit
  Scenario: View historical performance data
    Given player has history
    When I view historical data
    Then I should see past performance
    And trends should be visible
    And history should inform decision

  @happy-path @start-sit
  Scenario: Analyze matchup history
    Given player has faced opponent before
    When I view matchup history
    Then I should see past results vs opponent
    And patterns should be visible
    And history should factor in

  @happy-path @start-sit
  Scenario: View confidence ratings
    Given recommendations have confidence
    When I view confidence
    Then I should see confidence level
    And certainty should be indicated
    And I should weigh accordingly

  @happy-path @start-sit
  Scenario: Filter start/sit by position
    Given I want specific position
    When I filter by position
    Then I should see only that position
    And recommendations should filter
    And I should see position-specific advice

  @happy-path @start-sit
  Scenario: View start/sit explanations
    Given I want to understand reasoning
    When I view explanations
    Then I should see why to start/sit
    And factors should be explained
    And I should understand rationale

  # ============================================================================
  # DFS INTEGRATION
  # ============================================================================

  @happy-path @dfs-integration
  Scenario: Optimize daily fantasy lineup
    Given I play DFS
    When I optimize DFS lineup
    Then DFS rules should apply
    And salary cap should be respected
    And lineup should be legal

  @happy-path @dfs-integration
  Scenario: Respect salary cap constraints
    Given DFS has salary cap
    When optimization runs
    Then total salary should be under cap
    And value should be maximized
    And cap should not be exceeded

  @happy-path @dfs-integration
  Scenario: Consider ownership percentages
    Given ownership data is available
    When I factor ownership
    Then high ownership should be noted
    And differentiation should be possible
    And ownership should inform decisions

  @happy-path @dfs-integration
  Scenario: Generate contrarian play suggestions
    Given I want to be different
    When I view contrarian plays
    Then low-owned players should show
    And upside should be highlighted
    And I should differentiate

  @happy-path @dfs-integration
  Scenario: Generate multiple DFS lineups
    Given I want lineup diversity
    When I generate multiple lineups
    Then I should receive multiple lineups
    And lineups should be diverse
    And I should have options

  @happy-path @dfs-integration
  Scenario: Optimize for contest type
    Given contest types differ
    When I select contest type
    Then optimization should adjust
    And GPP vs cash should differ
    And strategy should match contest

  @happy-path @dfs-integration
  Scenario: Stack players for correlation
    Given stacks provide correlation
    When I build stacks
    Then correlated players should group
    And game stacks should be available
    And correlation should boost upside

  @happy-path @dfs-integration
  Scenario: Export DFS lineups
    Given I have optimized lineups
    When I export lineups
    Then lineups should export
    And format should match platform
    And import should work

  # ============================================================================
  # LINEUP ALERTS
  # ============================================================================

  @happy-path @lineup-alerts
  Scenario: Receive suboptimal lineup warnings
    Given my lineup is not optimal
    When suboptimality is detected
    Then I should receive warning
    And I should see what's wrong
    And I should be prompted to fix

  @happy-path @lineup-alerts
  Scenario: Receive better option notifications
    Given better option exists on bench
    When better option is found
    Then I should receive notification
    And I should see the better player
    And I should consider swap

  @happy-path @lineup-alerts
  Scenario: Receive injured starter alerts
    Given my starter is injured
    When injury is reported
    Then I should receive alert
    And I should see replacement options
    And I should act quickly

  @happy-path @lineup-alerts
  Scenario: Receive bye week player alerts
    Given bye player is in lineup
    When bye is detected
    Then I should receive alert
    And I should see the issue
    And I should remove bye player

  @happy-path @lineup-alerts
  Scenario: Receive game-time decision updates
    Given player is GTD
    When status updates
    Then I should receive update
    And I should see new status
    And I should adjust if needed

  @happy-path @lineup-alerts
  Scenario: Receive lock time reminders
    Given lineup lock is approaching
    When lock time nears
    Then I should receive reminder
    And I should finalize lineup
    And I should not miss deadline

  @happy-path @lineup-alerts
  Scenario: Configure alert preferences
    Given I want specific alerts
    When I configure preferences
    Then I should set alert types
    And I should set timing
    And preferences should save

  @happy-path @lineup-alerts
  Scenario: Receive projection change alerts
    Given projections update
    When significant change occurs
    Then I should receive alert
    And I should see new projection
    And I should consider impact

  # ============================================================================
  # OPTIMIZATION HISTORY
  # ============================================================================

  @happy-path @optimization-history
  Scenario: View past lineup decisions
    Given I have made decisions
    When I view history
    Then I should see past lineups
    And decisions should be recorded
    And I should review choices

  @happy-path @optimization-history
  Scenario: Compare optimal vs actual lineup
    Given week has completed
    When I compare optimal vs actual
    Then I should see what was optimal
    And I should see what I started
    And difference should be shown

  @happy-path @optimization-history
  Scenario: Track points left on bench
    Given bench players scored
    When I view bench points
    Then I should see points left on bench
    And missed opportunities should show
    And I should learn from mistakes

  @happy-path @optimization-history
  Scenario: View decision accuracy metrics
    Given I have decision history
    When I view accuracy
    Then I should see hit rate
    And accuracy should be measured
    And I should improve over time

  @happy-path @optimization-history
  Scenario: Learn from past mistakes
    Given I have made mistakes
    When I analyze mistakes
    Then I should see patterns
    And I should see improvements
    And I should avoid repeating errors

  @happy-path @optimization-history
  Scenario: View season-long optimization score
    Given season has progressed
    When I view optimization score
    Then I should see overall score
    And score should reflect decisions
    And I should track improvement

  @happy-path @optimization-history
  Scenario: Export optimization history
    Given I want to analyze elsewhere
    When I export history
    Then I should receive data
    And format should be usable
    And export should be complete

  @happy-path @optimization-history
  Scenario: Compare to league average
    Given league data exists
    When I compare to league
    Then I should see my rank
    And I should compare to average
    And I should understand my performance

  # ============================================================================
  # PLAYOFF OPTIMIZATION
  # ============================================================================

  @happy-path @playoff-optimization
  Scenario: Optimize for playoff matchups
    Given playoffs are underway
    When I optimize for playoffs
    Then playoff matchups should be prioritized
    And schedule should factor heavily
    And championship should be considered

  @happy-path @playoff-optimization
  Scenario: Factor playoff schedule strength
    Given playoff schedules vary
    When optimization considers schedule
    Then favorable schedules should boost
    And tough schedules should impact
    And I should see schedule effect

  @happy-path @playoff-optimization
  Scenario: Prioritize championship week
    Given championship is paramount
    When optimizing for championship
    Then Week 17 matchups should matter most
    And championship players should be valued
    And title should be the focus

  @happy-path @playoff-optimization
  Scenario: Account for multi-week playoff matchups
    Given playoffs span multiple weeks
    When I view multi-week optimization
    Then all playoff weeks should be considered
    And consistency should be valued
    And total playoff output should matter

  # ============================================================================
  # COMMISSIONER TOOLS
  # ============================================================================

  @happy-path @commissioner-tools @commissioner
  Scenario: Configure optimization settings
    Given I am commissioner
    When I configure optimization settings
    Then I should set allowed features
    And settings should apply to league
    And configuration should save

  @happy-path @commissioner-tools @commissioner
  Scenario: Enable or disable optimizer for league
    Given optimizer can be toggled
    When I toggle optimizer
    Then optimizer should enable or disable
    And league should see change
    And setting should persist

  @happy-path @commissioner-tools @commissioner
  Scenario: View league optimization usage
    Given league members use optimizer
    When I view usage stats
    Then I should see usage metrics
    And adoption should be visible
    And I should understand usage

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Handle projection data unavailable
    Given projection data is expected
    When data is unavailable
    Then I should see error message
    And fallback should be offered
    And I should retry later

  @error
  Scenario: Handle optimization calculation error
    Given optimization is running
    When calculation fails
    Then I should see error message
    And I should see what went wrong
    And I should retry

  @error
  Scenario: Handle impossible lineup constraint
    Given constraints cannot be satisfied
    When optimization fails
    Then I should see constraint error
    And I should see which constraint failed
    And I should adjust roster

  @error
  Scenario: Handle locked player optimization
    Given player is already locked
    When optimization runs
    Then locked player should remain
    And optimization should work around lock
    And I should be notified

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: Use quick optimize button on mobile
    Given I am using mobile app
    When I tap quick optimize
    Then lineup should optimize quickly
    And mobile UI should be responsive
    And result should show immediately

  @mobile
  Scenario: Swipe to swap players on mobile
    Given I want to swap players
    When I swipe on player
    Then swap interface should appear
    And I should swap easily
    And lineup should update

  @mobile
  Scenario: Receive push notifications for changes
    Given changes affect my lineup
    When change occurs
    Then I should receive push notification
    And notification should be actionable
    And I should respond quickly

  @mobile
  Scenario: Access offline lineup caching
    Given I am offline
    When I view lineup
    Then cached lineup should show
    And I should see last known state
    And updates should sync when online

  @mobile
  Scenario: Benefit from battery-efficient updates
    Given I want battery efficiency
    When app runs in background
    Then updates should be efficient
    And battery should be preserved
    And important alerts should still come

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate optimizer with keyboard
    Given I am using keyboard navigation
    When I use lineup optimizer
    Then I should navigate with keyboard
    And all features should be accessible
    And focus should be visible

  @accessibility
  Scenario: Screen reader optimizer access
    Given I am using a screen reader
    When I use lineup optimizer
    Then recommendations should be announced
    And players should be read clearly
    And I should understand suggestions

  @accessibility
  Scenario: High contrast optimizer display
    Given I have high contrast enabled
    When I view optimizer
    Then interface should be readable
    And recommendations should be clear
    And data should be visible

  @accessibility
  Scenario: Optimizer with reduced motion
    Given I have reduced motion enabled
    When optimization runs
    Then animations should be minimal
    And results should still show
    And functionality should work
