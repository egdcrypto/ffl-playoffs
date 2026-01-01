@mobile-app
Feature: Mobile App
  As a fantasy football manager on the go
  I want to manage my team from my mobile device
  So that I can stay connected to my league anywhere

  # --------------------------------------------------------------------------
  # Mobile Navigation
  # --------------------------------------------------------------------------

  @mobile-navigation
  Scenario: Navigate using bottom navigation bar
    Given I am logged in on the mobile app
    When I view the bottom navigation bar
    Then I should see the Home tab
    And I should see the My Team tab
    And I should see the League tab
    And I should see the Players tab
    And I should see the More tab

  @mobile-navigation
  Scenario: Switch between tabs
    Given I am logged in on the mobile app
    When I tap on a different navigation tab
    Then the app should switch to that section
    And the tab should be highlighted as active
    And the transition should be smooth

  @mobile-navigation
  Scenario: Use swipe gestures for navigation
    Given I am logged in on the mobile app
    And I am on the My Team screen
    When I swipe left
    Then I should navigate to the next section
    And when I swipe right I should go back

  @mobile-navigation
  Scenario: Use pull-to-refresh gesture
    Given I am logged in on the mobile app
    And I am viewing any list screen
    When I pull down on the screen
    Then the content should refresh
    And I should see a refresh indicator
    And new data should load

  @mobile-navigation
  Scenario: Navigate back with swipe gesture
    Given I am logged in on the mobile app
    And I am on a detail screen
    When I swipe from the left edge
    Then I should navigate back to the previous screen

  @mobile-navigation
  Scenario: Use long press for quick actions
    Given I am logged in on the mobile app
    And I am viewing a player list
    When I long press on a player
    Then I should see a quick action menu
    And I should see options like Add, Trade, View Stats

  @mobile-navigation
  Scenario: Access search with swipe down
    Given I am logged in on the mobile app
    And I am on the home screen
    When I swipe down from the top
    Then the search bar should appear
    And I should be able to search for players or teams

  # --------------------------------------------------------------------------
  # Mobile Dashboard
  # --------------------------------------------------------------------------

  @mobile-dashboard
  Scenario: View mobile home screen
    Given I am logged in on the mobile app
    When I am on the home screen
    Then I should see my current matchup summary
    And I should see quick access to my team
    And I should see recent league activity
    And I should see upcoming game alerts

  @mobile-dashboard
  Scenario: Use quick actions on home screen
    Given I am logged in on the mobile app
    And I am on the home screen
    When I tap on quick actions
    Then I should see Set Lineup option
    And I should see Add Player option
    And I should see View Waivers option
    And I should see Trade option

  @mobile-dashboard
  Scenario: Access app shortcuts from home screen
    Given I have the app installed on my device
    When I long press the app icon on my device home screen
    Then I should see app shortcuts
    And I should see Set Lineup shortcut
    And I should see View Matchup shortcut
    And I should see Quick Add shortcut

  @mobile-dashboard
  Scenario: View personalized dashboard cards
    Given I am logged in on the mobile app
    When I view my dashboard
    Then I should see cards based on my activity
    And I should see injured player alerts if applicable
    And I should see trade offer notifications
    And I should see lineup optimization suggestions

  @mobile-dashboard
  Scenario: Customize dashboard card order
    Given I am logged in on the mobile app
    When I customize my dashboard
    Then I should be able to reorder cards
    And I should be able to hide cards
    And I should be able to add new cards
    And my preferences should be saved

  @mobile-dashboard
  Scenario: View live game day dashboard
    Given I am logged in on the mobile app
    And games are currently in progress
    When I view the dashboard
    Then I should see live scores prominently
    And I should see my players' real-time points
    And I should see opponent's points
    And I should see projected final score

  # --------------------------------------------------------------------------
  # Push Notifications
  # --------------------------------------------------------------------------

  @push-notifications
  Scenario: Receive real-time game alerts
    Given I am logged in on the mobile app
    And I have push notifications enabled
    When one of my players scores a touchdown
    Then I should receive a push notification
    And the notification should show player name and points
    And I should be able to tap to view details

  @push-notifications
  Scenario: Receive trade offer notification
    Given I am logged in on the mobile app
    And I have push notifications enabled
    When I receive a trade offer
    Then I should get a push notification
    And I should see the trade summary in the notification
    And I should have action buttons to Accept or Decline

  @push-notifications
  Scenario: Use notification quick actions
    Given I receive a push notification
    When I view the notification
    Then I should see relevant quick actions
    And I should be able to act without opening the app
    And actions should complete in the background

  @push-notifications
  Scenario: Deep link from notification
    Given I receive a push notification about a trade
    When I tap on the notification
    Then I should be taken directly to the trade details
    And the app should open to the correct screen
    And I should see the full trade information

  @push-notifications
  Scenario: View notification badge counts
    Given I am logged in on the mobile app
    And I have unread notifications
    When I view the app icon
    Then I should see a badge with the notification count
    And the count should update when I read notifications

  @push-notifications
  Scenario: Receive lineup reminder notification
    Given I am logged in on the mobile app
    And I have lineup reminders enabled
    When it is close to game time and my lineup is not set
    Then I should receive a reminder notification
    And I should be able to set lineup from notification

  @push-notifications
  Scenario: Configure notification preferences
    Given I am logged in on the mobile app
    When I configure notification settings
    Then I should be able to toggle different notification types
    And I should be able to set quiet hours
    And I should be able to choose notification sounds

  # --------------------------------------------------------------------------
  # Offline Mode
  # --------------------------------------------------------------------------

  @offline-mode
  Scenario: Access cached data when offline
    Given I am logged in on the mobile app
    And I have previously viewed my team
    When I lose internet connection
    Then I should still be able to view my team roster
    And I should see cached player information
    And I should see an offline indicator

  @offline-mode
  Scenario: View offline indicator
    Given I am logged in on the mobile app
    When I lose internet connection
    Then I should see a clear offline indicator
    And the indicator should show when last synced
    And I should know which features are unavailable

  @offline-mode
  Scenario: Queue actions for sync when reconnected
    Given I am logged in on the mobile app
    And I am offline
    When I make lineup changes
    Then the changes should be queued locally
    And I should see pending sync indicator
    And changes should sync when connection is restored

  @offline-mode
  Scenario: Sync data when connection is restored
    Given I am logged in on the mobile app
    And I have queued actions while offline
    When my internet connection is restored
    Then queued actions should sync automatically
    And I should see sync progress
    And I should receive confirmation of synced changes

  @offline-mode
  Scenario: Handle sync conflicts
    Given I am logged in on the mobile app
    And I made changes while offline
    When syncing reveals a conflict
    Then I should be notified of the conflict
    And I should see options to resolve it
    And I should be able to choose which version to keep

  @offline-mode
  Scenario: Pre-cache important data
    Given I am logged in on the mobile app
    And I am connected to WiFi
    When I access settings
    Then I should be able to enable pre-caching
    And important data should download for offline use
    And I should see cache size and manage it

  # --------------------------------------------------------------------------
  # Mobile Lineup
  # --------------------------------------------------------------------------

  @mobile-lineup
  Scenario: Set lineup with swipe gestures
    Given I am logged in on the mobile app
    And I am viewing my lineup
    When I swipe a player from bench to starting lineup
    Then the player should move to the starting position
    And the UI should update smoothly
    And the change should be saved

  @mobile-lineup
  Scenario: Use drag-and-drop to rearrange players
    Given I am logged in on the mobile app
    And I am viewing my lineup
    When I long press and drag a player
    Then I should be able to move them to a new position
    And valid drop zones should be highlighted
    And the move should complete on release

  @mobile-lineup
  Scenario: Make quick substitution
    Given I am logged in on the mobile app
    And I am viewing my lineup
    When I tap on a starting player
    Then I should see available substitutes
    And I should be able to tap to swap players
    And the substitution should be immediate

  @mobile-lineup
  Scenario: View player comparison before substitution
    Given I am logged in on the mobile app
    And I am considering a substitution
    When I tap compare before swapping
    Then I should see side-by-side stats
    And I should see projected points
    And I should see matchup information

  @mobile-lineup
  Scenario: Optimize lineup with one tap
    Given I am logged in on the mobile app
    And I am viewing my lineup
    When I tap the Optimize Lineup button
    Then the app should suggest optimal lineup
    And I should see projected point improvement
    And I should be able to accept or reject suggestions

  @mobile-lineup
  Scenario: Set lineup for future weeks
    Given I am logged in on the mobile app
    When I navigate to future week lineup
    Then I should be able to set lineup in advance
    And I should see bye week indicators
    And I should see projected availability

  # --------------------------------------------------------------------------
  # Mobile Draft
  # --------------------------------------------------------------------------

  @mobile-draft
  Scenario: Join draft room on mobile
    Given I am logged in on the mobile app
    And my league draft is starting
    When I join the draft room
    Then I should see the draft board
    And I should see the pick timer
    And I should see available players

  @mobile-draft
  Scenario: View pick timer on mobile
    Given I am in the mobile draft room
    And it is my turn to pick
    When I view the screen
    Then I should see a prominent countdown timer
    And I should receive a notification when time is running low
    And I should be able to auto-draft if needed

  @mobile-draft
  Scenario: Manage player queue on mobile
    Given I am in the mobile draft room
    When I access my player queue
    Then I should be able to add players to queue
    And I should be able to reorder my queue
    And I should see when queued players are drafted

  @mobile-draft
  Scenario: Make a draft pick on mobile
    Given I am in the mobile draft room
    And it is my turn to pick
    When I select a player to draft
    Then I should confirm my selection
    And the player should be added to my team
    And the draft should move to the next pick

  @mobile-draft
  Scenario: Receive draft alerts
    Given I am logged in on the mobile app
    And a draft is in progress
    When it is almost my turn to pick
    Then I should receive an alert notification
    And I should be able to jump to draft from notification
    And I should see who just picked

  @mobile-draft
  Scenario: Search players during draft
    Given I am in the mobile draft room
    When I search for a player
    Then results should appear quickly
    And I should be able to filter by position
    And I should see player availability status

  @mobile-draft
  Scenario: View draft results on mobile
    Given the draft has completed
    When I view draft results on mobile
    Then I should see all picks in order
    And I should be able to view any team's draft
    And I should see draft grades if available

  # --------------------------------------------------------------------------
  # Mobile Transactions
  # --------------------------------------------------------------------------

  @mobile-transactions
  Scenario: Submit waiver claim on mobile
    Given I am logged in on the mobile app
    When I find a player I want to claim
    And I submit a waiver claim
    Then I should be able to select who to drop
    And I should confirm the claim
    And I should see the claim in my pending transactions

  @mobile-transactions
  Scenario: Propose trade on mobile
    Given I am logged in on the mobile app
    When I want to propose a trade
    And I select players to offer and receive
    Then I should see the trade summary
    And I should be able to add a message
    And I should be able to send the trade offer

  @mobile-transactions
  Scenario: Review trade offer on mobile
    Given I am logged in on the mobile app
    And I have a pending trade offer
    When I view the trade offer
    Then I should see full trade details
    And I should see player comparisons
    And I should be able to Accept, Decline, or Counter

  @mobile-transactions
  Scenario: Add free agent on mobile
    Given I am logged in on the mobile app
    When I find an available free agent
    And I tap Add Player
    Then I should select who to drop if roster is full
    And I should confirm the transaction
    And the player should be added immediately

  @mobile-transactions
  Scenario: View transaction history on mobile
    Given I am logged in on the mobile app
    When I view my transaction history
    Then I should see all my recent transactions
    And I should be able to filter by type
    And I should see transaction dates and details

  @mobile-transactions
  Scenario: Cancel pending transaction
    Given I am logged in on the mobile app
    And I have a pending waiver claim
    When I view my pending transactions
    Then I should be able to cancel the claim
    And I should confirm the cancellation
    And the claim should be removed

  # --------------------------------------------------------------------------
  # Biometric Authentication
  # --------------------------------------------------------------------------

  @biometric-auth
  Scenario: Enable Face ID login
    Given I am logged in on the mobile app
    And my device supports Face ID
    When I enable Face ID in settings
    Then Face ID should be configured for the app
    And I should be able to login with Face ID

  @biometric-auth
  Scenario: Login with Touch ID
    Given I have Touch ID enabled for the app
    When I open the app
    Then I should be prompted for Touch ID
    And I should be able to authenticate with fingerprint
    And I should be logged in upon successful authentication

  @biometric-auth
  Scenario: Fallback to password when biometric fails
    Given I have biometric login enabled
    When biometric authentication fails
    Then I should be offered password login option
    And I should be able to enter my password
    And I should successfully log in

  @biometric-auth
  Scenario: Require biometric for sensitive actions
    Given I am logged in on the mobile app
    And I have biometric security enabled
    When I try to make a trade
    Then I should be prompted for biometric verification
    And the action should only complete after verification

  @biometric-auth
  Scenario: Secure storage with biometric protection
    Given I am logged in on the mobile app
    When I enable secure storage
    Then my credentials should be stored securely
    And sensitive data should require biometric to access
    And data should be encrypted on device

  @biometric-auth
  Scenario: Disable biometric authentication
    Given I have biometric login enabled
    When I disable biometric authentication
    Then I should confirm with my password
    And biometric login should be disabled
    And I should login with password going forward

  # --------------------------------------------------------------------------
  # Mobile Widgets
  # --------------------------------------------------------------------------

  @mobile-widgets
  Scenario: Add live scores widget to home screen
    Given I have the app installed
    When I add the live scores widget to my home screen
    Then I should see real-time game scores
    And the widget should update automatically
    And I should be able to tap to open the app

  @mobile-widgets
  Scenario: View matchup widget
    Given I have added the matchup widget
    When I view my device home screen
    Then I should see my current matchup summary
    And I should see my score vs opponent score
    And I should see projected final outcome

  @mobile-widgets
  Scenario: View standings widget
    Given I have added the standings widget
    When I view my device home screen
    Then I should see current league standings
    And I should see my team's position highlighted
    And I should see win-loss records

  @mobile-widgets
  Scenario: Configure widget size
    Given I am adding a widget
    When I choose the widget size
    Then I should have small, medium, and large options
    And each size should show appropriate detail
    And I should be able to resize after adding

  @mobile-widgets
  Scenario: Update widget data
    Given I have widgets on my home screen
    When new data is available
    Then widgets should update automatically
    And updates should be battery efficient
    And I should see fresh data when viewing

  @mobile-widgets
  Scenario: Interact with widget
    Given I have an interactive widget
    When I tap on different widget sections
    Then I should be deep linked to relevant app sections
    And the app should open to the correct content

  @mobile-widgets
  Scenario: View my players widget
    Given I have added the my players widget
    When I view my device home screen
    Then I should see my starting players
    And I should see their game status
    And I should see live points during games

  # --------------------------------------------------------------------------
  # App Performance
  # --------------------------------------------------------------------------

  @app-performance
  Scenario: Experience fast app loading
    Given I tap on the app icon
    When the app launches
    Then the app should load within 2 seconds
    And I should see content immediately
    And the app should be fully interactive quickly

  @app-performance
  Scenario: Load images efficiently
    Given I am browsing player profiles
    When I scroll through player images
    Then images should load progressively
    And placeholder images should show while loading
    And images should be cached for future viewing

  @app-performance
  Scenario: Experience smooth scrolling
    Given I am viewing a long list of players
    When I scroll through the list
    Then scrolling should be smooth at 60fps
    And there should be no jank or stuttering
    And items should load seamlessly

  @app-performance
  Scenario: Background refresh data
    Given I have background refresh enabled
    When the app is in the background
    Then data should refresh periodically
    And I should see fresh data when returning
    And background refresh should be battery efficient

  @app-performance
  Scenario: Maintain battery efficiency
    Given I am using the app regularly
    When I check battery usage
    Then the app should use reasonable battery
    And there should be no excessive background activity
    And I should be able to configure battery optimization

  @app-performance
  Scenario: Handle poor network conditions
    Given I am on a slow network connection
    When I use the app
    Then the app should remain responsive
    And I should see loading indicators
    And critical features should still work

  @app-performance
  Scenario: Minimize data usage
    Given I have data saver mode enabled
    When I use the app
    Then the app should minimize data consumption
    And images should load at lower quality
    And non-essential data should be deferred

  # --------------------------------------------------------------------------
  # Mobile-Specific Features
  # --------------------------------------------------------------------------

  @mobile-features
  Scenario: Use haptic feedback
    Given I am using the app
    When I perform significant actions
    Then I should feel haptic feedback
    And feedback should be appropriate to the action
    And I should be able to disable haptic feedback

  @mobile-features
  Scenario: Support landscape and portrait modes
    Given I am using the app
    When I rotate my device
    Then the app should adapt to the new orientation
    And content should reflow appropriately
    And functionality should remain accessible

  @mobile-features
  Scenario: Use voice commands
    Given I have voice control enabled
    When I speak a command
    Then the app should recognize my intent
    And I should be able to set lineup by voice
    And I should receive voice confirmation

  @mobile-features
  Scenario: Share content from mobile
    Given I am viewing content in the app
    When I tap the share button
    Then I should see native sharing options
    And I should be able to share to other apps
    And shared content should be properly formatted

  @mobile-features
  Scenario: Use picture-in-picture for live scores
    Given I am viewing live scores
    When I navigate away from the app
    Then I should be able to enable picture-in-picture
    And I should see a floating score window
    And I should be able to tap to return to app

  # --------------------------------------------------------------------------
  # Error Handling and Edge Cases
  # --------------------------------------------------------------------------

  @mobile-app @error-handling
  Scenario: Handle app crash gracefully
    Given the app encounters an unexpected error
    When the app crashes
    Then crash data should be logged
    And I should be able to restart the app
    And my unsaved data should be recovered if possible

  @mobile-app @error-handling
  Scenario: Handle session expiration
    Given my session has expired
    When I try to perform an action
    Then I should be prompted to re-authenticate
    And I should be able to use biometric or password
    And my action should complete after authentication

  @mobile-app @error-handling
  Scenario: Handle low storage conditions
    Given my device is low on storage
    When I use the app
    Then I should be notified of low storage
    And I should be able to clear app cache
    And critical functions should still work

  @mobile-app @error-handling
  Scenario: Handle app update required
    Given a new app version is required
    When I open the app
    Then I should see an update required message
    And I should be directed to the app store
    And I should not be able to use outdated version

  @mobile-app @accessibility
  Scenario: Support screen readers on mobile
    Given I use a screen reader
    When I navigate the app
    Then all elements should be properly labeled
    And navigation should be logical
    And I should be able to use all features

  @mobile-app @accessibility
  Scenario: Support dynamic text sizing
    Given I have increased system text size
    When I use the app
    Then app text should respect my size preference
    And layouts should adapt to larger text
    And no text should be cut off
