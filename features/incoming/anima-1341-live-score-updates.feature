@live-score-updates @ANIMA-1341
Feature: Live Score Updates
  As a fantasy football playoffs application user
  I want real-time score updates during NFL games
  So that I can track my team's performance as it happens

  Background:
    Given the fantasy football playoffs application is running
    And I am logged in as a registered user
    And NFL games are scheduled or in progress

  # ============================================================================
  # REAL-TIME SCORE STREAMING - HAPPY PATH
  # ============================================================================

  @happy-path @real-time-streaming
  Scenario: Establish WebSocket connection for live updates
    Given I am viewing a live matchup
    When the page loads
    Then a WebSocket connection should establish
    And I should receive real-time updates
    And connection status should show connected

  @happy-path @real-time-streaming
  Scenario: Fallback to SSE when WebSocket unavailable
    Given WebSocket is not available
    When I view live scores
    Then SSE connection should establish
    And I should still receive updates
    And fallback should be seamless

  @happy-path @real-time-streaming
  Scenario: Fallback to polling for legacy support
    Given WebSocket and SSE are unavailable
    When I view live scores
    Then polling should activate
    And I should receive periodic updates
    And polling interval should be reasonable

  @happy-path @real-time-streaming
  Scenario: Handle connection state changes
    Given I have an active connection
    When connection state changes
    Then I should see connection indicator
    And state should be clearly displayed
    And I should know if connected

  @happy-path @real-time-streaming
  Scenario: Automatic reconnection after disconnect
    Given my connection drops
    When reconnection is attempted
    Then connection should restore automatically
    And I should receive missed updates
    And experience should be seamless

  @happy-path @real-time-streaming
  Scenario: Receive bandwidth-efficient delta updates
    Given I am receiving updates
    When score changes occur
    Then only changed data should be sent
    And bandwidth should be conserved
    And updates should be complete

  @happy-path @real-time-streaming
  Scenario: Configure update frequency
    Given I want to control updates
    When I configure update frequency
    Then I should set update interval
    And updates should respect setting
    And I should balance freshness and performance

  # ============================================================================
  # PLAYER PERFORMANCE TRACKING
  # ============================================================================

  @happy-path @player-tracking
  Scenario: View live stat accumulation
    Given my player is in an active game
    When stats are recorded
    Then I should see live stat updates
    And stats should accumulate in real-time
    And fantasy points should update

  @happy-path @player-tracking
  Scenario: View play-by-play scoring updates
    Given games are in progress
    When scoring plays occur
    Then I should see play-by-play updates
    And each play should show points
    And plays should appear immediately

  @happy-path @player-tracking
  Scenario: Receive touchdown notifications
    Given my player scores a touchdown
    When the TD is confirmed
    Then I should receive TD notification
    And notification should show points
    And celebration should be appropriate

  @happy-path @player-tracking
  Scenario: Receive big play alerts
    Given my player makes a 50+ yard play
    When the big play occurs
    Then I should receive big play alert
    And I should see yardage and points
    And alert should be exciting

  @happy-path @player-tracking
  Scenario: Receive injury status updates
    Given my player's status changes
    When injury is reported
    Then I should receive injury alert
    And I should see injury type
    And I should see return status

  @happy-path @player-tracking
  Scenario: Track player substitutions
    Given player rotations occur
    When my player is substituted
    Then I should see playing status
    And I should know if they're on field
    And snap count should update

  @happy-path @player-tracking
  Scenario: View target and touch tracking
    Given my player is in the game
    When targets and touches occur
    Then I should see target count
    And I should see touch count
    And opportunity tracking should work

  # ============================================================================
  # GAME STATE MANAGEMENT
  # ============================================================================

  @happy-path @game-state
  Scenario: View pre-game countdown
    Given game has not started
    When I view the matchup
    Then I should see countdown timer
    And countdown should be accurate
    And I should know when game starts

  @happy-path @game-state
  Scenario: Track quarter and half progress
    Given a game is in progress
    When I view game status
    Then I should see current quarter
    And I should see time remaining
    And quarter changes should update

  @happy-path @game-state
  Scenario: Synchronize game clock
    Given I am tracking live game
    When game clock runs
    Then my clock should be synchronized
    And time should match broadcast
    And sync should be accurate

  @happy-path @game-state
  Scenario: View halftime score snapshot
    Given halftime occurs
    When I view halftime status
    Then I should see halftime scores
    And I should see halftime stats
    And I should assess first half

  @happy-path @game-state
  Scenario: Confirm final scores
    Given a game ends
    When final score is confirmed
    Then I should see final confirmation
    And scores should be locked
    And game should be marked complete

  @happy-path @game-state
  Scenario: Handle overtime games
    Given a game goes to overtime
    When OT period begins
    Then I should see OT indicator
    And scoring should continue tracking
    And OT rules should be noted

  @happy-path @game-state
  Scenario: Track game delays
    Given a game is delayed
    When delay is announced
    Then I should see delay notice
    And estimated restart should show
    And I should stay informed

  # ============================================================================
  # PUSH NOTIFICATIONS
  # ============================================================================

  @happy-path @push-notifications
  Scenario: Receive score change alerts
    Given I enabled score notifications
    When my team's score changes
    Then I should receive push notification
    And notification should show new score
    And I should see point change

  @happy-path @push-notifications
  Scenario: Receive lead change notifications
    Given I am in a close matchup
    When lead changes
    Then I should receive lead change alert
    And I should see new leader
    And I should see margin

  @happy-path @push-notifications
  Scenario: Receive close game alerts
    Given my matchup is close
    When game enters final minutes
    Then I should receive close game alert
    And I should see matchup status
    And urgency should be conveyed

  @happy-path @push-notifications
  Scenario: Receive touchdown notifications
    Given I enabled TD alerts
    When any of my players scores
    Then I should receive TD notification
    And I should see player and points
    And I should celebrate

  @happy-path @push-notifications
  Scenario: Receive final score notifications
    Given games are ending
    When final scores are confirmed
    Then I should receive final notification
    And I should see matchup result
    And I should know outcome

  @happy-path @push-notifications
  Scenario: Customize notification preferences
    Given I want specific notifications
    When I configure preferences
    Then I should select notification types
    And I should set quiet hours
    And preferences should be saved

  @happy-path @push-notifications
  Scenario: Manage notification frequency
    Given I receive many notifications
    When I adjust frequency
    Then I should bundle or limit alerts
    And I should not be overwhelmed
    And important alerts should still arrive

  # ============================================================================
  # LIVE LEADERBOARD
  # ============================================================================

  @happy-path @live-leaderboard
  Scenario: View real-time standings refresh
    Given standings are displayed
    When scores change
    Then standings should update in real-time
    And rankings should adjust
    And I should see my position

  @happy-path @live-leaderboard
  Scenario: View matchup score comparisons
    Given matchups are in progress
    When I view leaderboard
    Then I should see all matchup scores
    And I should see comparisons
    And I should see who's winning

  @happy-path @live-leaderboard
  Scenario: View projected final scores
    Given games are in progress
    When I view projections
    Then I should see projected finals
    And projections should update live
    And I should see likely outcome

  @happy-path @live-leaderboard
  Scenario: View win probability updates
    Given matchup is in progress
    When I check win probability
    Then I should see current probability
    And probability should update live
    And I should understand my chances

  @happy-path @live-leaderboard
  Scenario: Calculate points needed to win
    Given I am trailing
    When I view points needed
    Then I should see points to overcome
    And calculation should be accurate
    And I should know what's required

  @happy-path @live-leaderboard
  Scenario: Track live ranking changes
    Given leaderboard is active
    When rankings change
    Then I should see position movements
    And up/down arrows should show
    And I should see rank history

  # ============================================================================
  # MULTI-GAME DASHBOARD
  # ============================================================================

  @happy-path @multi-game-dashboard
  Scenario: Track simultaneous games
    Given multiple games are in progress
    When I view the dashboard
    Then I should see all active games
    And scores should update for all
    And I should track everything

  @happy-path @multi-game-dashboard
  Scenario: Receive red zone alerts across games
    Given teams are in red zone
    When red zone opportunities occur
    Then I should see red zone alerts
    And alerts should show which game
    And I should see scoring potential

  @happy-path @multi-game-dashboard
  Scenario: View fantasy-relevant play highlights
    Given plays affect my players
    When relevant plays occur
    Then I should see highlights
    And highlights should show impact
    And I should see key moments

  @happy-path @multi-game-dashboard
  Scenario: View condensed scoring summary
    Given I want quick overview
    When I view summary
    Then I should see condensed scores
    And summary should be scannable
    And key info should stand out

  @happy-path @multi-game-dashboard
  Scenario: Sort games by priority
    Given multiple games are shown
    When I sort by priority
    Then games with my players should rank higher
    And important games should be prominent
    And I should customize sorting

  @happy-path @multi-game-dashboard
  Scenario: Use picture-in-picture game views
    Given I want focused tracking
    When I enable PiP mode
    Then I should see mini game views
    And I should track multiple games
    And PiP should not obstruct

  @happy-path @multi-game-dashboard
  Scenario: Filter dashboard by league
    Given I have multiple leagues
    When I filter by league
    Then I should see only that league's games
    And filtering should be easy
    And I should switch leagues quickly

  # ============================================================================
  # DATA SYNCHRONIZATION
  # ============================================================================

  @happy-path @data-sync
  Scenario: Reconcile scores with official stats
    Given live scores may have errors
    When official stats are available
    Then scores should reconcile
    And any differences should be corrected
    And final should match official

  @happy-path @data-sync
  Scenario: Handle update latency
    Given network latency exists
    When updates are delayed
    Then latency should be compensated
    And I should see approximate times
    And experience should be smooth

  @happy-path @data-sync
  Scenario: Resolve update conflicts
    Given conflicting updates arrive
    When conflict is detected
    Then most recent should be used
    And conflicts should resolve cleanly
    And data integrity should be maintained

  @happy-path @data-sync
  Scenario: Invalidate stale cache
    Given cached data becomes stale
    When fresh data arrives
    Then cache should be invalidated
    And fresh data should display
    And cache strategy should work

  @happy-path @data-sync
  Scenario: Queue updates when offline
    Given I go offline temporarily
    When I come back online
    Then queued updates should sync
    And I should see current state
    And no updates should be lost

  @happy-path @data-sync
  Scenario: View sync status indicators
    Given synchronization occurs
    When I check sync status
    Then I should see sync indicator
    And I should know if data is current
    And I should see last sync time

  # ============================================================================
  # PERFORMANCE OPTIMIZATION
  # ============================================================================

  @happy-path @performance
  Scenario: Batch and throttle updates
    Given many updates arrive rapidly
    When batching is applied
    Then updates should be grouped
    And UI should not overwhelm
    And performance should be smooth

  @happy-path @performance
  Scenario: Manage selective subscriptions
    Given I have many players
    When I manage subscriptions
    Then I should subscribe to relevant updates
    And unnecessary updates should be filtered
    And bandwidth should be conserved

  @happy-path @performance
  Scenario: Handle background updates
    Given app is in background
    When updates arrive
    Then updates should queue efficiently
    And battery should be conserved
    And I should see updates when foregrounded

  @happy-path @performance
  Scenario: Optimize battery on mobile
    Given I am on mobile device
    When tracking live scores
    Then battery usage should be reasonable
    And I should track for extended periods
    And battery optimization should work

  @happy-path @performance
  Scenario: Compress update data
    Given updates are transmitted
    When compression is applied
    Then data should be compressed
    And bandwidth should reduce
    And decompression should be fast

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Handle connection failure
    Given connection cannot establish
    When I try to view live scores
    Then I should see connection error
    And I should be able to retry
    And cached data should show

  @error
  Scenario: Handle update stream interruption
    Given I am receiving updates
    When stream is interrupted
    Then I should see interruption notice
    And reconnection should attempt
    And I should be informed

  @error
  Scenario: Handle malformed update data
    Given update data is corrupted
    When invalid data is received
    Then error should be handled gracefully
    And app should not crash
    And issue should be logged

  @error
  Scenario: Handle notification delivery failure
    Given notification fails to deliver
    When delivery fails
    Then failure should be noted
    And retry should be attempted
    And I should see in-app notification

  @error
  Scenario: Handle sync failure
    Given synchronization fails
    When sync error occurs
    Then I should see sync error
    And I should retry sync
    And data should remain consistent

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: View live scores on mobile
    Given I am using the mobile app
    When I view live scores
    Then display should be mobile-optimized
    And updates should work on mobile
    And experience should be smooth

  @mobile
  Scenario: Receive mobile push notifications
    Given I have mobile notifications enabled
    When scoring events occur
    Then I should receive mobile push
    And notifications should be actionable
    And I should tap to view details

  @mobile
  Scenario: Track scores in background
    Given app is backgrounded
    When scores update
    Then I should receive notifications
    And state should be current when reopened
    And background tracking should work

  @mobile
  Scenario: Handle mobile network transitions
    Given I switch networks on mobile
    When network changes (WiFi to cellular)
    Then connection should maintain or reconnect
    And updates should continue
    And transition should be seamless

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate live updates with keyboard
    Given I am using keyboard navigation
    When I browse live updates
    Then I should navigate with keyboard
    And updates should be accessible
    And focus should be visible

  @accessibility
  Scenario: Screen reader live score access
    Given I am using a screen reader
    When live updates occur
    Then updates should be announced
    And scores should be read correctly
    And structure should be clear

  @accessibility
  Scenario: High contrast live display
    Given I have high contrast enabled
    When I view live scores
    Then numbers should be readable
    And updates should be visible
    And information should be clear

  @accessibility
  Scenario: Live updates with reduced motion
    Given I have reduced motion enabled
    When updates occur
    Then animations should be minimal
    And updates should still be visible
    And functionality should work
