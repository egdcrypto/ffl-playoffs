@injuries @ANIMA-1346
Feature: Injuries
  As a fantasy football playoffs application user
  I want comprehensive injury tracking and management
  So that I can manage my roster effectively and avoid starting injured players

  Background:
    Given the fantasy football playoffs application is running
    And I am logged in as a registered user
    And injury data is being tracked

  # ============================================================================
  # INJURY STATUS TRACKING - HAPPY PATH
  # ============================================================================

  @happy-path @injury-status
  Scenario: View real-time injury status updates
    Given injury reports are updated
    When I view my players
    Then I should see current injury status
    And status should be real-time
    And I should see latest information

  @happy-path @injury-status
  Scenario: View official NFL injury designations
    Given NFL designations are assigned
    When I check player status
    Then I should see Out designation
    And I should see Doubtful designation
    And I should see Questionable and Probable

  @happy-path @injury-status
  Scenario: Track game-time decisions
    Given player is a game-time decision
    When I view their status
    Then I should see GTD indicator
    And I should see decision timeline
    And I should plan accordingly

  @happy-path @injury-status
  Scenario: View practice participation reports
    Given practice reports are available
    When I check player practice status
    Then I should see practice participation level
    And I should see DNP, Limited, or Full
    And I should see progression through week

  @happy-path @injury-status
  Scenario: View injury type and body part
    Given player has an injury
    When I view injury details
    Then I should see injury type
    And I should see affected body part
    And I should understand the nature

  @happy-path @injury-status
  Scenario: View expected return timelines
    Given player has extended injury
    When I view return timeline
    Then I should see expected return date
    And I should see recovery progress
    And I should plan my roster

  @happy-path @injury-status
  Scenario: View injury severity indicator
    Given injuries have different severities
    When I view injury information
    Then I should see severity level
    And severity should be color-coded
    And I should understand impact

  # ============================================================================
  # INJURY ALERTS
  # ============================================================================

  @happy-path @injury-alerts
  Scenario: Receive push notifications for injury updates
    Given I enabled injury notifications
    When a player's injury status changes
    Then I should receive push notification
    And notification should show new status
    And I should act quickly

  @happy-path @injury-alerts
  Scenario: Receive email alerts for key player injuries
    Given email alerts are enabled
    When key player is injured
    Then I should receive email alert
    And email should include details
    And I should see impact analysis

  @happy-path @injury-alerts
  Scenario: View in-app injury banners
    Given injuries affect my roster
    When I open the app
    Then I should see injury banner
    And banner should highlight affected players
    And I should see action needed

  @happy-path @injury-alerts
  Scenario: Receive lineup alert for injured starters
    Given my starter is injured
    When lineup deadline approaches
    Then I should receive lineup alert
    And alert should warn of injured starter
    And I should be prompted to adjust

  @happy-path @injury-alerts
  Scenario: Customize alert preferences
    Given I want specific alerts
    When I configure alert preferences
    Then I should set which injuries to alert
    And I should set alert methods
    And preferences should save

  @happy-path @injury-alerts
  Scenario: Receive breaking injury news
    Given breaking injury news occurs
    When news is reported
    Then I should receive immediate alert
    And I should see news details
    And I should react quickly

  # ============================================================================
  # INJURY REPORT INTEGRATION
  # ============================================================================

  @happy-path @injury-reports
  Scenario: Import official NFL injury reports
    Given NFL releases injury report
    When report is imported
    Then I should see official designations
    And report should be complete
    And data should be accurate

  @happy-path @injury-reports
  Scenario: View Wednesday practice report
    Given it is Wednesday
    When practice report is released
    Then I should see Wednesday participation
    And initial injury info should show
    And I should monitor through week

  @happy-path @injury-reports
  Scenario: View Thursday practice report
    Given it is Thursday
    When practice report is released
    Then I should see Thursday participation
    And I should see progression
    And I should compare to Wednesday

  @happy-path @injury-reports
  Scenario: View Friday injury report
    Given it is Friday
    When final report is released
    Then I should see official designations
    And game status should be clearer
    And I should finalize plans

  @happy-path @injury-reports
  Scenario: View final injury report before game
    Given game is approaching
    When final report is released
    Then I should see final status
    And Out players should be confirmed
    And I should make final lineup moves

  @happy-path @injury-reports
  Scenario: View injury report history
    Given past reports exist
    When I view report history
    Then I should see past injury reports
    And I should see status progression
    And I should identify patterns

  @happy-path @injury-reports
  Scenario: View team-by-team injury summaries
    Given injuries are reported
    When I view team summary
    Then I should see all team injuries
    And I should see position impacts
    And I should assess team health

  @happy-path @injury-reports
  Scenario: View beat reporter injury intel
    Given reporters provide updates
    When intel is available
    Then I should see reporter insights
    And insider information should show
    And I should get edge on injury news

  # ============================================================================
  # ROSTER IMPACT ANALYSIS
  # ============================================================================

  @happy-path @roster-impact
  Scenario: View injured player replacement suggestions
    Given my player is injured
    When I view suggestions
    Then I should see replacement options
    And options should be from my roster
    And I should see projection comparison

  @happy-path @roster-impact
  Scenario: View waiver wire recommendations for injuries
    Given I need replacement from waivers
    When I view waiver suggestions
    Then I should see available replacements
    And I should see pickup recommendations
    And I should see priority targets

  @happy-path @roster-impact
  Scenario: Identify backup players
    Given starter is injured
    When I view depth chart
    Then I should see backup player
    And I should see their projections
    And I should consider adding them

  @happy-path @roster-impact
  Scenario: Assess depth chart impact
    Given injury affects team depth
    When I view team impact
    Then I should see how injury affects team
    And I should see opportunity for backups
    And I should identify beneficiaries

  @happy-path @roster-impact
  Scenario: Analyze positional scarcity
    Given injuries create scarcity
    When I view position analysis
    Then I should see position availability
    And scarcity should be highlighted
    And I should prioritize accordingly

  @happy-path @roster-impact
  Scenario: Assess trade value impact for injured players
    Given injured player has trade value
    When I view trade impact
    Then I should see diminished value
    And I should see buy-low opportunities
    And I should assess trade timing

  # ============================================================================
  # IR MANAGEMENT
  # ============================================================================

  @happy-path @ir-management
  Scenario: Manage Injured Reserve slots
    Given I have IR slots
    When I view IR management
    Then I should see available IR slots
    And I should see IR-eligible players
    And I should manage IR roster

  @happy-path @ir-management
  Scenario: Check IR eligibility
    Given player has injury designation
    When I check IR eligibility
    Then I should see if player is IR-eligible
    And eligibility rules should be clear
    And I should know if I can IR them

  @happy-path @ir-management
  Scenario: Place player on IR
    Given player is IR-eligible
    When I place them on IR
    Then player should move to IR slot
    And roster spot should open
    And I should add replacement

  @happy-path @ir-management
  Scenario: Activate player from IR
    Given player is returning from injury
    When I activate from IR
    Then player should return to roster
    And I should make room if needed
    And activation should complete

  @happy-path @ir-management @commissioner
  Scenario: Configure IR slot settings
    Given I am commissioner
    When I configure IR settings
    Then I should set number of IR slots
    And I should set eligibility rules
    And configuration should save

  @happy-path @ir-management
  Scenario: Manage multiple IR slots
    Given league has multiple IR slots
    When I manage IR
    Then I should use multiple slots
    And I should see all IR players
    And I should manage each slot

  # ============================================================================
  # INJURY HISTORY
  # ============================================================================

  @happy-path @injury-history
  Scenario: View player injury history
    Given player has past injuries
    When I view injury history
    Then I should see all past injuries
    And I should see recovery times
    And I should see games missed

  @happy-path @injury-history
  Scenario: Identify injury-prone players
    Given some players are injury-prone
    When I view injury risk
    Then injury-prone players should be flagged
    And risk level should be shown
    And I should factor into decisions

  @happy-path @injury-history
  Scenario: View recovery time patterns
    Given past recoveries are tracked
    When I view patterns
    Then I should see typical recovery times
    And I should see injury-specific patterns
    And I should project current recovery

  @happy-path @injury-history
  Scenario: View historical injury data
    Given historical data exists
    When I view history
    Then I should see multi-year injury data
    And trends should be visible
    And I should understand player durability

  @happy-path @injury-history
  Scenario: Track season-ending injuries
    Given season-ending injuries occur
    When I view season-enders
    Then I should see players out for season
    And I should see when they went down
    And I should remove from consideration

  @happy-path @injury-history
  Scenario: View career injury timeline
    Given player has career history
    When I view timeline
    Then I should see career injury timeline
    And I should see all injuries chronologically
    And I should assess long-term health

  # ============================================================================
  # GAME-DAY UPDATES
  # ============================================================================

  @happy-path @gameday-updates
  Scenario: View pre-game inactive list
    Given teams release inactive lists
    When I view inactives
    Then I should see inactive players
    And I should know who won't play
    And I should adjust lineup

  @happy-path @gameday-updates
  Scenario: Track warm-up participation
    Given players are warming up
    When I view warm-up status
    Then I should see who is warming up
    And I should see who isn't
    And I should monitor GTD players

  @happy-path @gameday-updates
  Scenario: Receive in-game injury alerts
    Given game is in progress
    When player is injured
    Then I should receive immediate alert
    And I should see injury type
    And I should monitor status

  @happy-path @gameday-updates
  Scenario: View sideline and tent injury reports
    Given player goes to sideline/tent
    When status is reported
    Then I should see sideline/tent report
    And I should see evaluation status
    And I should wait for updates

  @happy-path @gameday-updates
  Scenario: Track return to game updates
    Given injured player may return
    When they return to game
    Then I should receive return update
    And I should know they're playing
    And I should track their performance

  @happy-path @gameday-updates
  Scenario: View post-game injury reports
    Given game has ended
    When post-game report is released
    Then I should see post-game injuries
    And I should see new injuries
    And I should plan for next week

  # ============================================================================
  # LINEUP OPTIMIZATION
  # ============================================================================

  @happy-path @lineup-optimization
  Scenario: Auto-adjust lineup for injuries
    Given auto-adjust is enabled
    When starter is ruled out
    Then lineup should auto-adjust
    And best replacement should start
    And I should be notified

  @happy-path @lineup-optimization
  Scenario: View suggested lineup swaps
    Given injuries affect my lineup
    When I view suggestions
    Then I should see swap recommendations
    And I should see projection impact
    And I should apply swaps easily

  @happy-path @lineup-optimization
  Scenario: Receive injured player benching reminders
    Given injured player is in lineup
    When deadline approaches
    Then I should receive reminder
    And reminder should urge action
    And I should avoid zero points

  @happy-path @lineup-optimization
  Scenario: View optimal replacement recommendations
    Given I need replacements
    When I view recommendations
    Then I should see optimal replacements
    And projections should compare
    And I should optimize my lineup

  @happy-path @lineup-optimization
  Scenario: Explore what-if injury scenarios
    Given I want to plan ahead
    When I run what-if scenarios
    Then I should see if player X is out
    And I should see my options
    And I should prepare contingencies

  @happy-path @lineup-optimization
  Scenario: Create contingency lineup plans
    Given GTD players exist
    When I create contingency plan
    Then I should have backup lineup ready
    And plan should activate if needed
    And I should be covered

  # ============================================================================
  # INJURY ANALYTICS
  # ============================================================================

  @happy-path @injury-analytics
  Scenario: View team injury trends
    Given team injury data exists
    When I view team trends
    Then I should see injury frequency
    And I should see position patterns
    And I should identify risky teams

  @happy-path @injury-analytics
  Scenario: View position group injury rates
    Given position data exists
    When I view position rates
    Then I should see injury rates by position
    And I should see high-risk positions
    And I should factor into strategy

  @happy-path @injury-analytics
  Scenario: View weather-related injury correlation
    Given weather data is tracked
    When I view weather impact
    Then I should see weather correlations
    And cold/wet weather should show impact
    And I should adjust expectations

  @happy-path @injury-analytics
  Scenario: Assess bye week rest impact
    Given bye weeks affect health
    When I view bye impact
    Then I should see rest benefit
    And I should see post-bye health
    And I should factor bye timing

  @happy-path @injury-analytics
  Scenario: View playoff injury predictions
    Given playoff games approach
    When I view predictions
    Then I should see injury likelihood
    And workload fatigue should factor
    And I should plan for playoffs

  @happy-path @injury-analytics
  Scenario: Assess injury impact on fantasy scoring
    Given injuries affect scoring
    When I view scoring impact
    Then I should see how injuries reduce points
    And I should see replacement value
    And I should understand loss

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Handle injury data unavailable
    Given injury data is expected
    When data is unavailable
    Then I should see appropriate message
    And last known data should show
    And I should retry later

  @error
  Scenario: Handle conflicting injury reports
    Given reports conflict
    When I view injury status
    Then I should see conflicting info
    And sources should be shown
    And I should monitor closely

  @error
  Scenario: Handle IR placement failure
    Given I try to place on IR
    When placement fails
    Then I should see error message
    And I should see why it failed
    And I should resolve the issue

  @error
  Scenario: Handle delayed injury updates
    Given updates are delayed
    When delay occurs
    Then I should see last update time
    And I should know data may be stale
    And I should check other sources

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: View injuries on mobile
    Given I am using the mobile app
    When I view injury information
    Then display should be mobile-optimized
    And injuries should be clearly shown
    And I should act quickly

  @mobile
  Scenario: Receive injury alerts on mobile
    Given injury alerts are enabled
    When injury occurs
    Then I should receive mobile push
    And I should tap to view details
    And I should manage lineup

  @mobile
  Scenario: Manage IR on mobile
    Given I need to use IR
    When I manage IR on mobile
    Then IR actions should work
    And interface should be usable
    And roster should update

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate injuries with keyboard
    Given I am using keyboard navigation
    When I browse injury information
    Then I should navigate with keyboard
    And all actions should be accessible
    And focus should be visible

  @accessibility
  Scenario: Screen reader injury access
    Given I am using a screen reader
    When I view injury information
    Then injuries should be announced
    And status should be read clearly
    And I should understand severity

  @accessibility
  Scenario: High contrast injury display
    Given I have high contrast enabled
    When I view injuries
    Then injury indicators should be visible
    And status colors should be accessible
    And text should be readable

  @accessibility
  Scenario: Injuries with reduced motion
    Given I have reduced motion enabled
    When injury alerts occur
    Then animations should be minimal
    And alerts should still be visible
    And functionality should work
