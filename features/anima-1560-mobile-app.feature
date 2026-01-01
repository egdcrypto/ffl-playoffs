@mobile-app
Feature: Mobile App
  As a fantasy football user
  I want to use a native mobile application
  So that I can manage my fantasy teams on the go with an optimized experience

  # Native Experience Scenarios
  @native-experience
  Scenario: Install iOS app from App Store
    Given I am an iOS device user
    When I search for the app in the App Store
    And I tap install
    Then the app should download and install
    And the app icon should appear on my home screen
    And the app should be optimized for my device

  @native-experience
  Scenario: Install Android app from Play Store
    Given I am an Android device user
    When I search for the app in Google Play Store
    And I tap install
    Then the app should download and install
    And the app should appear in my app drawer
    And the app should support my Android version

  @native-experience
  Scenario: Experience native iOS navigation
    Given I am using the iOS app
    When I navigate through the app
    Then navigation should use iOS native patterns
    And gestures should feel native to iOS
    And transitions should be smooth and native

  @native-experience
  Scenario: Experience native Android navigation
    Given I am using the Android app
    When I navigate through the app
    Then navigation should use Material Design patterns
    And the back button should work correctly
    And transitions should follow Android guidelines

  @native-experience
  Scenario: App performs with native speed
    Given I am using the mobile app
    When I interact with app features
    Then responses should feel instant
    And animations should run at 60fps
    And there should be no perceivable lag

  @native-experience
  Scenario: Use platform-specific sharing
    Given I am viewing shareable content
    When I tap the share button
    Then the native share sheet should appear
    And I should see platform-specific share options
    And sharing should complete successfully

  @native-experience
  Scenario: Access platform-specific features
    Given I am using the mobile app
    When I access device-specific features
    Then iOS features like Handoff should work
    And Android features like split-screen should work
    And platform integrations should function correctly

  @native-experience
  Scenario: App respects system preferences
    Given I have system preferences configured
    When I use the mobile app
    Then app should respect system font size
    And app should follow system dark/light mode
    And app should honor accessibility settings

  # Offline Mode Scenarios
  @offline-mode
  Scenario: Access cached data when offline
    Given I have previously loaded league data
    And I am currently offline
    When I open the mobile app
    Then I should see my cached league data
    And I should see a clear offline indicator
    And last sync time should be displayed

  @offline-mode
  Scenario: Set lineup while offline
    Given I am offline
    And I have cached roster data
    When I make lineup changes
    Then changes should be saved locally
    And I should see pending sync indicator
    And changes should sync when online

  @offline-mode
  Scenario: Sync data when reconnecting
    Given I made changes while offline
    And I have reconnected to the internet
    When sync is triggered
    Then local changes should upload
    And server changes should download
    And conflicts should be resolved appropriately

  @offline-mode
  Scenario: Manage offline draft queue
    Given I am preparing for a draft
    When I set up my draft queue offline
    Then queue changes should save locally
    And queue should sync before draft starts
    And I should see queue sync status

  @offline-mode
  Scenario: View player information offline
    Given I have cached player data
    And I am offline
    When I view a player profile
    Then basic player info should display
    And I should see cached statistics
    And unavailable data should be indicated

  @offline-mode
  Scenario: Handle offline conflict resolution
    Given I made offline changes
    And conflicting changes were made online
    When I reconnect and sync
    Then I should see conflict notification
    And I should be able to choose which changes to keep
    And resolution should be logged

  @offline-mode
  Scenario: Cache league data for offline use
    Given I am online
    When I navigate through league data
    Then data should be cached automatically
    And cache should prioritize recent data
    And cache size should be manageable

  @offline-mode
  Scenario: Clear offline cache
    Given I have cached data stored
    When I clear the offline cache
    Then cached data should be removed
    And storage space should be freed
    And I should need to resync when online

  # Push Notifications Scenarios
  @push-notifications
  Scenario: Receive real-time score alerts
    Given I have enabled score notifications
    And my players are in active games
    When a player scores
    Then I should receive a push notification
    And notification should show scoring details
    And notification should arrive within seconds

  @push-notifications
  Scenario: Customize notification preferences
    Given I am in notification settings
    When I configure notification preferences
    Then I should be able to toggle notification types
    And I should be able to set priority levels
    And preferences should save immediately

  @push-notifications
  Scenario: Configure quiet hours
    Given I am in notification settings
    When I set quiet hours
    Then notifications should be silenced during those hours
    And urgent notifications should still come through if enabled
    And notifications should resume after quiet hours

  @push-notifications
  Scenario: Receive grouped notifications
    Given multiple events occur rapidly
    When notifications are generated
    Then related notifications should be grouped
    And group summary should be informative
    And expanding should show individual notifications

  @push-notifications
  Scenario: Receive trade proposal notification
    Given I have trade notifications enabled
    When someone proposes a trade to me
    Then I should receive a push notification
    And notification should show trade summary
    And tapping should open trade details

  @push-notifications
  Scenario: Receive injury alert notification
    Given I have injury alerts enabled
    And a player on my roster is injured
    When the injury is reported
    Then I should receive immediate notification
    And notification should show injury details
    And I should see lineup impact warning

  @push-notifications
  Scenario: Handle notification permissions
    Given I am setting up the app
    When the app requests notification permission
    Then I should see clear explanation of notification use
    And I should be able to grant or deny permission
    And app should function without notifications if denied

  @push-notifications
  Scenario: Clear notification badges
    Given I have unread notification badges
    When I view the notifications
    Then badges should clear appropriately
    And app icon badge should update
    And notification center should reflect read status

  # Touch Gestures Scenarios
  @touch-gestures
  Scenario: Swipe to bench player
    Given I am viewing my roster
    When I swipe left on a starting player
    Then bench action should be revealed
    And tapping should move player to bench
    And animation should confirm the action

  @touch-gestures
  Scenario: Drag and drop roster management
    Given I am viewing my lineup
    When I long-press and drag a player
    Then the player should lift from the list
    And valid drop zones should be highlighted
    And dropping should update the lineup

  @touch-gestures
  Scenario: Pull to refresh data
    Given I am viewing league data
    When I pull down on the screen
    Then refresh indicator should appear
    And data should refresh from server
    And indicator should dismiss when complete

  @touch-gestures
  Scenario: Use gesture shortcuts
    Given I am using the mobile app
    When I use configured gesture shortcuts
    Then shortcuts should execute assigned actions
    And feedback should confirm the gesture
    And actions should complete successfully

  @touch-gestures
  Scenario: Swipe between matchups
    Given I am viewing a matchup
    When I swipe left or right
    Then I should navigate to adjacent matchups
    And transitions should be smooth
    And current matchup should be indicated

  @touch-gestures
  Scenario: Pinch to zoom on charts
    Given I am viewing statistical charts
    When I pinch to zoom
    Then chart should zoom in or out
    And I should be able to pan when zoomed
    And double-tap should reset zoom

  @touch-gestures
  Scenario: Long press for quick actions
    Given I am viewing a player
    When I long press on the player
    Then quick action menu should appear
    And menu should show relevant actions
    And selecting action should execute it

  @touch-gestures
  Scenario: Swipe to delete notification
    Given I am viewing notifications
    When I swipe left on a notification
    Then delete action should be revealed
    And tapping delete should remove notification
    And undo option should briefly appear

  # Mobile Lineup Scenarios
  @mobile-lineup
  Scenario: Make quick lineup changes
    Given I am viewing my lineup
    When I tap on a player slot
    Then available players should display
    And I should be able to select replacement
    And lineup should update immediately

  @mobile-lineup
  Scenario: One-tap start or sit player
    Given I am viewing my roster
    When I tap the start/sit toggle on a player
    Then player status should switch immediately
    And visual feedback should confirm change
    And lineup should be valid after change

  @mobile-lineup
  Scenario: Swap player positions
    Given I have players at multiple positions
    When I initiate a position swap
    Then valid swap options should be shown
    And I should be able to complete the swap
    And both positions should update

  @mobile-lineup
  Scenario: Replace injured player quickly
    Given a player in my lineup is injured
    When I view my lineup
    Then injured player should be flagged
    And replacement suggestions should appear
    And one-tap replacement should be available

  @mobile-lineup
  Scenario: View optimal lineup suggestion
    Given I am viewing my lineup
    When I tap "Optimize Lineup"
    Then optimal lineup should be suggested
    And I should see projected point improvements
    And I should be able to apply suggestions

  @mobile-lineup
  Scenario: Set lineup for future weeks
    Given I am viewing lineup settings
    When I select a future week
    Then I should be able to set that lineup
    And I should see projected availability
    And lineup should lock at appropriate time

  @mobile-lineup
  Scenario: View lineup lock status
    Given game times are approaching
    When I view my lineup
    Then I should see countdown to lock
    And locked players should be indicated
    And I should see which players can still be changed

  @mobile-lineup
  Scenario: Batch lineup changes
    Given I have multiple lineup changes to make
    When I make changes and tap save
    Then all changes should apply together
    And confirmation should show all changes
    And I should be able to undo if needed

  # Live Scoring Scenarios
  @live-scoring
  Scenario: View real-time scoring updates
    Given games are in progress
    When I view my matchup
    Then scores should update in real-time
    And I should see live point totals
    And updates should appear within seconds

  @live-scoring
  Scenario: See score animations
    Given I am viewing live scoring
    When a player scores
    Then score change should animate
    And animation should draw attention appropriately
    And previous score should be visible briefly

  @live-scoring
  Scenario: View play-by-play updates
    Given I am viewing a player's scoring
    When I expand scoring details
    Then I should see individual plays
    And plays should show point values
    And plays should update in real-time

  @live-scoring
  Scenario: Use home screen scoring widget
    Given I have added the scoring widget
    When games are in progress
    Then widget should show live scores
    And widget should update automatically
    And tapping widget should open app

  @live-scoring
  Scenario: View matchup probability
    Given I am viewing my live matchup
    When scores update
    Then win probability should recalculate
    And probability animation should update
    And historical trend should be visible

  @live-scoring
  Scenario: See player game status
    Given games are in progress
    When I view my players
    Then I should see if they are playing
    And I should see current game score
    And I should see game time remaining

  @live-scoring
  Scenario: Receive scoring notifications during games
    Given I have live scoring alerts enabled
    When my players score big plays
    Then I should receive notifications
    And notifications should show point impact
    And notifications should respect preferences

  @live-scoring
  Scenario: View red zone alerts
    Given I have red zone alerts enabled
    When my player's team is in red zone
    Then I should receive an alert
    And alert should identify the player
    And outcome should be reported afterward

  # Mobile Draft Scenarios
  @mobile-draft
  Scenario: Join draft room on mobile
    Given a draft is starting
    When I open the draft on mobile
    Then draft room should load optimized for mobile
    And all draft controls should be accessible
    And I should see other participants

  @mobile-draft
  Scenario: View pick timer on mobile
    Given the draft is in progress
    When it is my turn to pick
    Then pick timer should be prominently displayed
    And timer should be accurate
    And warning should show when time is low

  @mobile-draft
  Scenario: Toggle auto-draft mode
    Given I am in the draft room
    When I toggle auto-draft
    Then auto-draft status should update
    And my queue should be used for picks
    And I should be able to resume manual picking

  @mobile-draft
  Scenario: Search players during draft
    Given I am drafting
    When I search for a player
    Then search should be fast and responsive
    And results should filter in real-time
    And I should be able to quickly select a player

  @mobile-draft
  Scenario: View draft board on mobile
    Given the draft is in progress
    When I view the draft board
    Then board should be scrollable
    And picks should be color-coded by team
    And I should be able to zoom and pan

  @mobile-draft
  Scenario: Manage draft queue on mobile
    Given I am in the draft room
    When I access my queue
    Then I should be able to reorder players
    And I should be able to add or remove players
    And queue should sync in real-time

  @mobile-draft
  Scenario: Make auction bid on mobile
    Given I am in an auction draft
    When a player is nominated
    Then I should see current bid
    And I should be able to place bids quickly
    And bid buttons should be easy to tap

  @mobile-draft
  Scenario: Handle draft connection issues
    Given I am drafting on mobile
    And I lose connection temporarily
    When connection is restored
    Then draft state should sync
    And I should see what I missed
    And I should be able to continue drafting

  # Biometric Security Scenarios
  @biometric-security
  Scenario: Enable Face ID login
    Given I am using an iPhone with Face ID
    When I enable Face ID in settings
    And I authenticate with Face ID
    Then Face ID should be enabled for login
    And future logins should offer Face ID
    And I should have password fallback

  @biometric-security
  Scenario: Enable Touch ID login
    Given I am using a device with Touch ID
    When I enable Touch ID in settings
    And I authenticate with fingerprint
    Then Touch ID should be enabled
    And future logins should offer Touch ID
    And I should have password fallback

  @biometric-security
  Scenario: Login with fingerprint on Android
    Given I am using Android with fingerprint sensor
    When I enable fingerprint login
    And I register my fingerprint
    Then fingerprint login should be available
    And login should be quick and secure
    And fallback options should exist

  @biometric-security
  Scenario: Secure sensitive data storage
    Given I am logged in with biometrics
    When sensitive data is stored
    Then data should be encrypted
    And data should only be accessible after biometric auth
    And data should be cleared on logout

  @biometric-security
  Scenario: Re-authenticate for sensitive actions
    Given I am logged in
    When I attempt a sensitive action like changing payment
    Then I should be prompted for biometric authentication
    And action should only proceed after verification
    And failed attempts should be logged

  @biometric-security
  Scenario: Handle biometric authentication failure
    Given I am attempting biometric login
    When biometric authentication fails
    Then I should be able to retry
    And after multiple failures I should use password
    And account should not be locked

  @biometric-security
  Scenario: Disable biometric authentication
    Given I have biometric login enabled
    When I disable biometric authentication
    Then I should need to enter password
    And biometric login should be removed
    And stored biometric data should be cleared

  @biometric-security
  Scenario: Biometric timeout settings
    Given I have biometric login enabled
    When I configure timeout settings
    Then I should be able to set re-auth frequency
    And app should require re-auth after timeout
    And sensitive areas should always require auth

  # Mobile Widgets Scenarios
  @mobile-widgets
  Scenario: Add home screen widget on iOS
    Given I am on iOS home screen
    When I add the fantasy football widget
    Then widget should appear on home screen
    And widget should show relevant data
    And widget should update periodically

  @mobile-widgets
  Scenario: Add home screen widget on Android
    Given I am on Android home screen
    When I add the fantasy football widget
    Then widget should appear on home screen
    And widget should be resizable
    And widget should update automatically

  @mobile-widgets
  Scenario: View lock screen widget
    Given I have enabled lock screen widgets
    When I view my lock screen
    Then I should see fantasy scores widget
    And widget should show current matchup
    And tapping should unlock and open app

  @mobile-widgets
  Scenario: Use iOS Live Activities
    Given games are in progress
    And I have Live Activities enabled
    When I access Dynamic Island or lock screen
    Then I should see live scoring updates
    And updates should be real-time
    And I should be able to expand for details

  @mobile-widgets
  Scenario: Configure Apple Watch complications
    Given I have an Apple Watch
    When I add fantasy complications
    Then complications should show on watch face
    And scores should update regularly
    And tapping should open watch app

  @mobile-widgets
  Scenario: Configure widget data display
    Given I have widgets added
    When I configure widget settings
    Then I should be able to choose displayed league
    And I should be able to select data to show
    And widget should update with new configuration

  @mobile-widgets
  Scenario: Widget updates during games
    Given I have scoring widget displayed
    And games are in progress
    When scores change
    Then widget should update promptly
    And update should not drain excessive battery
    And widget should show freshness indicator

  @mobile-widgets
  Scenario: Interactive widget actions
    Given I have an interactive widget
    When I tap widget actions
    Then quick actions should execute
    And feedback should confirm action
    And app should open if needed for completion

  # App Settings Scenarios
  @app-settings
  Scenario: Enable dark mode
    Given I am in app settings
    When I enable dark mode
    Then app should switch to dark theme
    And all screens should use dark colors
    And images should adjust appropriately

  @app-settings
  Scenario: Configure data usage controls
    Given I am in app settings
    When I access data usage settings
    Then I should be able to limit background data
    And I should be able to reduce image quality on cellular
    And I should see current data usage

  @app-settings
  Scenario: Manage cache storage
    Given I am in app settings
    When I access storage settings
    Then I should see cache size
    And I should be able to clear cache
    And I should be able to limit cache size

  @app-settings
  Scenario: Configure accessibility options
    Given I am in app settings
    When I access accessibility settings
    Then I should be able to increase text size
    And I should be able to enable high contrast
    And I should be able to reduce motion

  @app-settings
  Scenario: Set default league
    Given I am in multiple leagues
    When I set a default league
    Then app should open to that league
    And widgets should default to that league
    And notifications should prioritize that league

  @app-settings
  Scenario: Configure app language
    Given I am in app settings
    When I change app language
    Then app should switch to selected language
    And all content should be translated
    And language should persist across sessions

  @app-settings
  Scenario: Manage app permissions
    Given I am in app settings
    When I review app permissions
    Then I should see all requested permissions
    And I should be able to revoke permissions
    And app should explain why each is needed

  @app-settings
  Scenario: Reset app to defaults
    Given I am in app settings
    When I reset to default settings
    Then all settings should revert to defaults
    And I should be warned about data loss
    And account should remain logged in

  # Error Handling Scenarios
  @error-handling
  Scenario: Handle network connectivity loss
    Given I am using the mobile app
    When I lose network connectivity
    Then I should see offline indicator
    And cached data should remain accessible
    And app should reconnect automatically

  @error-handling
  Scenario: Handle app crash recovery
    Given the app crashed previously
    When I reopen the app
    Then app should recover gracefully
    And unsaved data should be restored if possible
    And crash report should be sent if permitted

  @error-handling
  Scenario: Handle authentication token expiration
    Given my session token has expired
    When I attempt an action
    Then I should be prompted to re-authenticate
    And biometric login should be available
    And my work should not be lost

  @error-handling
  Scenario: Handle low storage situations
    Given device storage is low
    When the app needs to cache data
    Then I should see storage warning
    And app should clear unnecessary cache
    And core functionality should remain available

  @error-handling
  Scenario: Handle push notification delivery failure
    Given push notifications are configured
    When notification delivery fails
    Then in-app notification should still appear
    And I should see notification on next app open
    And notification status should be logged

  @error-handling
  Scenario: Handle widget update failures
    Given widgets are configured
    When widget update fails
    Then widget should show last known data
    And widget should indicate stale data
    And next update should be attempted

  @error-handling
  Scenario: Handle biometric hardware unavailability
    Given biometric login is enabled
    When biometric hardware is unavailable
    Then password login should be offered
    And clear explanation should be shown
    And user should be able to proceed

  @error-handling
  Scenario: Handle background sync failures
    Given background sync is enabled
    When sync fails in background
    Then failure should be logged
    And sync should retry with backoff
    And user should be notified if persistent

  # Accessibility Scenarios
  @accessibility
  Scenario: Navigate app with VoiceOver
    Given I am using VoiceOver on iOS
    When I navigate through the app
    Then all elements should be accessible
    And labels should be descriptive
    And gestures should work correctly

  @accessibility
  Scenario: Navigate app with TalkBack
    Given I am using TalkBack on Android
    When I navigate through the app
    Then all elements should be accessible
    And focus order should be logical
    And announcements should be helpful

  @accessibility
  Scenario: Use app with increased text size
    Given I have increased system text size
    When I use the app
    Then text should scale appropriately
    And layout should adjust to fit
    And no content should be cut off

  @accessibility
  Scenario: Use app with reduced motion
    Given I have enabled reduce motion
    When I use the app
    Then animations should be minimized
    And transitions should be simple
    And functionality should be preserved

  @accessibility
  Scenario: Use app with switch control
    Given I am using switch control
    When I navigate the app
    Then all interactive elements should be reachable
    And actions should be executable
    And feedback should be clear

  @accessibility
  Scenario: Draft room accessibility
    Given I am using assistive technology
    When I participate in a draft
    Then draft controls should be accessible
    And timer should be announced
    And picks should be described clearly

  @accessibility
  Scenario: Widget accessibility
    Given I am using VoiceOver or TalkBack
    When I interact with widgets
    Then widget content should be readable
    And actions should be accessible
    And updates should be announced

  @accessibility
  Scenario: Color blind friendly interface
    Given I have color vision deficiency
    When I use the app
    Then I should not rely on color alone
    And status should use icons and text
    And charts should use patterns

  # Performance Scenarios
  @performance
  Scenario: App launches within performance budget
    Given the app is installed
    When I launch the app
    Then app should reach usable state within 2 seconds
    And splash screen should be minimal
    And content should load progressively

  @performance
  Scenario: Smooth scrolling performance
    Given I am viewing long lists
    When I scroll quickly
    Then scrolling should be smooth at 60fps
    And content should load as I scroll
    And no jank should be perceptible

  @performance
  Scenario: Efficient battery usage
    Given I am using the app regularly
    When I check battery usage
    Then app should not be top battery consumer
    And background activity should be minimal
    And location usage should be optimized

  @performance
  Scenario: Minimal memory footprint
    Given I am using the app
    When memory usage is monitored
    Then app should stay within reasonable limits
    And memory should be released when backgrounded
    And large images should be managed efficiently

  @performance
  Scenario: Fast draft room performance
    Given I am in the draft room
    When the draft is active
    Then interface should remain responsive
    And picks should register instantly
    And timer should be accurate

  @performance
  Scenario: Widget update efficiency
    Given widgets are active
    When widgets update
    Then updates should complete quickly
    And battery impact should be minimal
    And updates should batch efficiently

  @performance
  Scenario: Offline mode performance
    Given I am using offline mode
    When I access cached data
    Then data should load instantly
    And local operations should be fast
    And no network timeouts should occur

  @performance
  Scenario: App size optimization
    Given I am downloading the app
    When installation completes
    Then app size should be reasonable
    And assets should download on demand
    And unused features should not inflate size
