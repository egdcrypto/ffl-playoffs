@mobile-app @mobile @native
Feature: Mobile App
  As a fantasy football manager
  I want to use a full-featured mobile app
  So that I can manage my team and stay connected on the go

  Background:
    Given a fantasy football platform exists
    And mobile apps are available
    And I am a registered user

  # ==========================================
  # NATIVE iOS AND ANDROID APPS
  # ==========================================

  @native @ios @happy-path
  Scenario: Launch iOS app
    Given I have the iOS app installed
    When I launch the app
    Then the app opens to my dashboard
    And native iOS experience is provided

  @native @android @happy-path
  Scenario: Launch Android app
    Given I have the Android app installed
    When I launch the app
    Then the app opens to my dashboard
    And native Android experience is provided

  @native @install
  Scenario: Install app from app store
    Given I am on the app store
    When I download and install the app
    Then the app is installed successfully
    And I can open it

  @native @update
  Scenario: Update app to latest version
    Given an app update is available
    When I update the app
    Then the latest version is installed
    And new features are available

  @native @permissions
  Scenario: Grant app permissions
    Given the app needs permissions
    When I grant requested permissions
    Then features requiring permissions work
    And I can manage permissions later

  # ==========================================
  # RESPONSIVE MOBILE WEB
  # ==========================================

  @web @responsive @happy-path
  Scenario: Access site on mobile browser
    Given I am using a mobile browser
    When I navigate to the website
    Then the site is mobile-optimized
    And all features are accessible

  @web @pwa
  Scenario: Add to home screen as PWA
    Given I am on the mobile website
    When I add to home screen
    Then a PWA icon is added
    And I can launch like a native app

  @web @fallback
  Scenario: Use mobile web when app unavailable
    Given native app is not installed
    When I access the platform
    Then mobile web provides full functionality
    And experience is still optimized

  @web @feature-parity
  Scenario: Mobile web feature parity
    Given I am using mobile web
    When I access features
    Then all major features are available
    And experience matches native where possible

  # ==========================================
  # PUSH NOTIFICATION SYSTEM
  # ==========================================

  @push @happy-path
  Scenario: Receive push notification
    Given I have notifications enabled
    When a notification is sent
    Then I receive a push notification
    And I can tap to view details

  @push @configure
  Scenario: Configure push notification preferences
    Given I want to customize notifications
    When I access notification settings
    Then I can enable/disable notification types
    And preferences are saved

  @push @categories
  Scenario: Configure notifications by category
    Given different notification categories exist
    When I configure by category
    Then I control each type separately
    And granular control is available

  @push @rich
  Scenario: Receive rich push notifications
    Given rich notifications are supported
    When I receive a notification
    Then it includes images or actions
    And I can interact without opening app

  @push @quiet
  Scenario: Set quiet hours for notifications
    Given I don't want late-night alerts
    When I set quiet hours
    Then notifications are silenced during those hours
    And they resume automatically

  @push @badge
  Scenario: Display notification badge
    Given I have unread notifications
    When I view app icon
    Then badge count is displayed
    And count updates as I read

  # ==========================================
  # OFFLINE MODE WITH DATA SYNC
  # ==========================================

  @offline @happy-path
  Scenario: Use app in offline mode
    Given I lose internet connection
    When I use the app offline
    Then cached data is available
    And I can view my roster and scores

  @offline @queue
  Scenario: Queue actions while offline
    Given I am offline
    When I make changes
    Then changes are queued locally
    And they sync when online

  @offline @sync
  Scenario: Sync data when connection restored
    Given I was offline and made changes
    When connection is restored
    Then queued changes are synced
    And I am notified of sync status

  @offline @conflict
  Scenario: Handle sync conflicts
    Given data changed both locally and remotely
    When sync occurs
    Then conflicts are detected
    And I can choose resolution

  @offline @indicator
  Scenario: Display offline indicator
    Given I am offline
    When I view the app
    Then offline status is clearly shown
    And I know what features are limited

  # ==========================================
  # TOUCH-OPTIMIZED UI
  # ==========================================

  @touch @ui @happy-path
  Scenario: Interact with touch-optimized interface
    Given I am using the mobile app
    When I interact with UI elements
    Then touch targets are appropriately sized
    And interactions are smooth

  @touch @buttons
  Scenario: Use appropriately sized touch targets
    Given buttons and links are displayed
    When I tap them
    Then they are easy to tap accurately
    And minimum 44pt touch targets exist

  @touch @spacing
  Scenario: Navigate with proper spacing
    Given UI elements are displayed
    When I scroll and tap
    Then elements have adequate spacing
    And accidental taps are minimized

  @touch @feedback
  Scenario: Receive visual touch feedback
    Given I tap an element
    When the tap is registered
    Then visual feedback is provided
    And I know my tap was received

  # ==========================================
  # SWIPE GESTURES
  # ==========================================

  @swipe @navigation @happy-path
  Scenario: Navigate using swipe gestures
    Given I am viewing content
    When I swipe left or right
    Then I navigate between screens
    And navigation is intuitive

  @swipe @actions
  Scenario: Reveal swipe actions on list items
    Given I am viewing a list
    When I swipe on an item
    Then action buttons are revealed
    And I can quickly take action

  @swipe @back
  Scenario: Swipe to go back
    Given I am on a detail screen
    When I swipe from left edge
    Then I navigate back
    And gesture is natural

  @swipe @dismiss
  Scenario: Swipe to dismiss
    Given a modal or card is displayed
    When I swipe down
    Then the modal dismisses
    And underlying content is shown

  @swipe @refresh
  Scenario: Swipe to delete
    Given I can delete an item
    When I swipe to reveal delete
    Then I can confirm deletion
    And item is removed

  # ==========================================
  # PULL-TO-REFRESH
  # ==========================================

  @pull-refresh @happy-path
  Scenario: Pull to refresh content
    Given I am viewing refreshable content
    When I pull down on the screen
    Then content refreshes
    And latest data is loaded

  @pull-refresh @indicator
  Scenario: Display refresh indicator
    Given I am pulling to refresh
    When I pull past threshold
    Then refresh indicator animates
    And I know refresh is occurring

  @pull-refresh @complete
  Scenario: Complete refresh and update
    Given refresh is in progress
    When refresh completes
    Then indicator dismisses
    And content is updated

  @pull-refresh @error
  Scenario: Handle refresh error
    Given refresh fails
    When error occurs
    Then error message is shown
    And I can retry

  # ==========================================
  # BIOMETRIC AUTHENTICATION
  # ==========================================

  @biometric @faceid @happy-path
  Scenario: Authenticate with Face ID
    Given Face ID is enabled on my device
    When I open the app
    Then Face ID prompt appears
    And I am authenticated on success

  @biometric @touchid
  Scenario: Authenticate with Touch ID
    Given Touch ID is enabled on my device
    When I open the app
    Then Touch ID prompt appears
    And I am authenticated on success

  @biometric @fingerprint
  Scenario: Authenticate with fingerprint on Android
    Given fingerprint is enabled on my device
    When I open the app
    Then fingerprint prompt appears
    And I am authenticated on success

  @biometric @fallback
  Scenario: Fall back to password when biometric fails
    Given biometric authentication fails
    When fallback is offered
    Then I can enter password
    And I am authenticated

  @biometric @enable
  Scenario: Enable biometric authentication
    Given I want to use biometrics
    When I enable in settings
    Then biometric login is activated
    And I confirm with current password

  @biometric @disable
  Scenario: Disable biometric authentication
    Given I want to stop using biometrics
    When I disable in settings
    Then biometric login is deactivated
    And password login is required

  # ==========================================
  # MOBILE LINEUP MANAGEMENT
  # ==========================================

  @lineup @mobile @happy-path
  Scenario: Manage lineup on mobile
    Given I have a fantasy roster
    When I access lineup on mobile
    Then I can set my lineup easily
    And mobile-optimized interface is used

  @lineup @drag-drop
  Scenario: Drag and drop players in lineup
    Given I am setting my lineup
    When I drag a player
    Then I can drop them in a position
    And lineup updates visually

  @lineup @quick-swap
  Scenario: Quick swap players
    Given I want to swap starter and bench
    When I tap swap action
    Then players are swapped
    And it is quick and easy

  @lineup @lock-indicator
  Scenario: Show lineup lock indicator
    Given games are about to start
    When I view my lineup
    Then lock status is clearly shown
    And I know which players are locked

  @lineup @submit
  Scenario: Submit lineup changes
    Given I have made lineup changes
    When I submit
    Then changes are saved
    And I receive confirmation

  # ==========================================
  # QUICK-ACTION WIDGETS
  # ==========================================

  @widgets @happy-path
  Scenario: View home screen widget
    Given I have added a widget
    When I view my home screen
    Then widget displays key info
    And info updates regularly

  @widgets @scores
  Scenario: View live scores widget
    Given games are in progress
    When I view scores widget
    Then live scores are displayed
    And I can see my matchup status

  @widgets @lineup
  Scenario: View lineup widget
    Given I have a lineup widget
    When I view it
    Then my starters are shown
    And I can tap to manage

  @widgets @configure
  Scenario: Configure widget content
    Given I want to customize widget
    When I configure the widget
    Then I select what information to show
    And widget updates accordingly

  @widgets @multiple
  Scenario: Add multiple widgets
    Given I want multiple widgets
    When I add different widgets
    Then each displays unique content
    And all update properly

  # ==========================================
  # LIVE SCORE TICKER
  # ==========================================

  @ticker @happy-path
  Scenario: View live score ticker
    Given games are in progress
    When I view the ticker
    Then live scores scroll across
    And my players are highlighted

  @ticker @real-time
  Scenario: Ticker updates in real-time
    Given I am watching the ticker
    When a score changes
    Then ticker updates immediately
    And scoring plays are noted

  @ticker @expand
  Scenario: Expand ticker for details
    Given I see an interesting score
    When I tap the ticker
    Then detailed view expands
    And I see full game info

  @ticker @minimize
  Scenario: Minimize ticker
    Given ticker is expanded
    When I minimize it
    Then it returns to compact mode
    And more screen space is available

  # ==========================================
  # DARK MODE SUPPORT
  # ==========================================

  @dark-mode @happy-path
  Scenario: Enable dark mode
    Given I want to use dark mode
    When I enable dark mode
    Then the app displays in dark theme
    And all screens are dark

  @dark-mode @system
  Scenario: Follow system dark mode setting
    Given I use system appearance
    When my system changes mode
    Then the app follows system setting
    And transitions smoothly

  @dark-mode @manual
  Scenario: Manually toggle dark mode
    Given I want manual control
    When I toggle dark mode
    Then mode changes immediately
    And my preference is saved

  @dark-mode @schedule
  Scenario: Schedule dark mode
    Given I want scheduled dark mode
    When I set a schedule
    Then dark mode activates on schedule
    And transitions at set times

  @dark-mode @charts
  Scenario: Charts adapt to dark mode
    Given dark mode is enabled
    When I view charts and graphs
    Then they are readable in dark mode
    And colors are appropriate

  # ==========================================
  # HAPTIC FEEDBACK
  # ==========================================

  @haptic @happy-path
  Scenario: Feel haptic feedback on actions
    Given haptics are enabled
    When I perform an action
    Then I feel haptic feedback
    And feedback matches the action

  @haptic @success
  Scenario: Haptic feedback on success
    Given an action succeeds
    When success is confirmed
    Then I feel success haptic
    And it is satisfying

  @haptic @error
  Scenario: Haptic feedback on error
    Given an error occurs
    When error is displayed
    Then I feel error haptic
    And it is distinct from success

  @haptic @disable
  Scenario: Disable haptic feedback
    Given I prefer no haptics
    When I disable in settings
    Then haptics are turned off
    And app remains functional

  # ==========================================
  # VOICE COMMAND INTEGRATION
  # ==========================================

  @voice @happy-path
  Scenario: Use voice commands
    Given voice commands are enabled
    When I speak a command
    Then the app responds to my voice
    And action is performed

  @voice @siri
  Scenario: Use Siri shortcuts
    Given I am on iOS
    When I create a Siri shortcut
    Then I can use voice to trigger it
    And app actions are executed

  @voice @google
  Scenario: Use Google Assistant
    Given I am on Android
    When I use Google Assistant
    Then app integrates with Assistant
    And voice commands work

  @voice @lineup
  Scenario: Check lineup by voice
    Given I want to check my lineup
    When I ask about my lineup
    Then lineup status is spoken
    And I hear my starters

  @voice @scores
  Scenario: Check scores by voice
    Given I want live scores
    When I ask for scores
    Then current scores are spoken
    And I stay informed hands-free

  # ==========================================
  # MOBILE DRAFT ROOM
  # ==========================================

  @draft @mobile @happy-path
  Scenario: Participate in draft on mobile
    Given a draft is scheduled
    When I join on mobile
    Then draft room is mobile-optimized
    And I can draft effectively

  @draft @interface
  Scenario: Use mobile draft interface
    Given draft is in progress
    When I view draft board
    Then interface is touch-friendly
    And I can see essential info

  @draft @pick
  Scenario: Make draft pick on mobile
    Given it is my turn
    When I select a player
    Then my pick is submitted
    And draft continues

  @draft @queue
  Scenario: Manage draft queue on mobile
    Given I have a player queue
    When I manage queue on mobile
    Then I can reorder and add players
    And queue is usable

  @draft @notifications
  Scenario: Receive draft notifications
    Given draft is active
    When it becomes my turn
    Then I receive notification
    And I can pick from notification

  # ==========================================
  # CAMERA INTEGRATION
  # ==========================================

  @camera @profile @happy-path
  Scenario: Take profile photo with camera
    Given I want to update my photo
    When I use the camera
    Then I can take a new photo
    And it is set as my profile

  @camera @gallery
  Scenario: Select photo from gallery
    Given I have photos in gallery
    When I select from gallery
    Then I can choose an existing photo
    And it is set as my profile

  @camera @crop
  Scenario: Crop profile photo
    Given I have selected a photo
    When I crop the photo
    Then I can adjust framing
    And cropped version is saved

  @camera @team-logo
  Scenario: Upload team logo via camera
    Given I want a custom team logo
    When I capture or select image
    Then it becomes my team logo
    And logo is displayed

  # ==========================================
  # SHARE SHEETS
  # ==========================================

  @share @sheet @happy-path
  Scenario: Share content via share sheet
    Given I want to share content
    When I tap share
    Then native share sheet opens
    And I see sharing options

  @share @social
  Scenario: Share to social media
    Given share sheet is open
    When I select a social app
    Then content is shared to that app
    And formatting is appropriate

  @share @message
  Scenario: Share via message
    Given I want to share with a friend
    When I select messaging app
    Then content is shared via message
    And link is included

  @share @copy
  Scenario: Copy link to clipboard
    Given I want to copy a link
    When I select copy
    Then link is copied to clipboard
    And I can paste elsewhere

  # ==========================================
  # DEEP LINKING
  # ==========================================

  @deep-link @happy-path
  Scenario: Open app via deep link
    Given I tap a link to app content
    When the link is opened
    Then app opens to specific content
    And navigation is direct

  @deep-link @player
  Scenario: Deep link to player profile
    Given I have a player link
    When I tap the link
    Then app opens to that player
    And profile is displayed

  @deep-link @matchup
  Scenario: Deep link to matchup
    Given I have a matchup link
    When I tap the link
    Then app opens to that matchup
    And I see matchup details

  @deep-link @league
  Scenario: Deep link to league
    Given I have a league link
    When I tap the link
    Then app opens to that league
    And I join or view

  @deep-link @fallback
  Scenario: Handle deep link without app
    Given app is not installed
    When I tap a deep link
    Then I am taken to app store or web
    And I can still access content

  # ==========================================
  # APP SHORTCUTS AND QUICK ACTIONS
  # ==========================================

  @shortcuts @happy-path
  Scenario: Use app shortcuts from home screen
    Given app supports shortcuts
    When I long-press app icon
    Then quick action menu appears
    And I can take common actions

  @shortcuts @lineup
  Scenario: Quick action to set lineup
    Given lineup shortcut exists
    When I select it
    Then app opens to lineup screen
    And I can set lineup immediately

  @shortcuts @scores
  Scenario: Quick action to check scores
    Given scores shortcut exists
    When I select it
    Then app opens to live scores
    And I see current matchup

  @shortcuts @draft
  Scenario: Quick action to join draft
    Given draft is about to start
    When I select draft shortcut
    Then app opens to draft room
    And I am ready to draft

  # ==========================================
  # BACKGROUND APP REFRESH
  # ==========================================

  @background @refresh @happy-path
  Scenario: Background refresh updates data
    Given background refresh is enabled
    When app is in background
    Then data refreshes periodically
    And app has latest data when opened

  @background @scores
  Scenario: Background refresh for live scores
    Given games are in progress
    When app is backgrounded
    Then scores update in background
    And notifications are sent

  @background @enable
  Scenario: Enable background refresh
    Given I want background updates
    When I enable in settings
    Then background refresh activates
    And data stays current

  @background @disable
  Scenario: Disable background refresh
    Given I want to save battery
    When I disable background refresh
    Then only foreground updates occur
    And battery is conserved

  # ==========================================
  # BATTERY OPTIMIZATION
  # ==========================================

  @battery @optimization @happy-path
  Scenario: Optimize battery usage
    Given battery optimization is important
    When I use the app
    Then battery usage is minimized
    And performance is maintained

  @battery @low-power
  Scenario: Reduce features in low power mode
    Given low power mode is active
    When I use the app
    Then background activities are reduced
    And essential features remain

  @battery @settings
  Scenario: Configure battery settings
    Given I want to control battery use
    When I access battery settings
    Then I can adjust refresh frequency
    And balance power and updates

  # ==========================================
  # MOBILE PAYMENT
  # ==========================================

  @payment @mobile @happy-path
  Scenario: Make payment on mobile
    Given I owe a payment
    When I pay on mobile
    Then payment flow is mobile-optimized
    And transaction completes

  @payment @apple-pay
  Scenario: Pay with Apple Pay
    Given Apple Pay is available
    When I select Apple Pay
    Then payment uses Apple Pay
    And biometric confirms

  @payment @google-pay
  Scenario: Pay with Google Pay
    Given Google Pay is available
    When I select Google Pay
    Then payment uses Google Pay
    And is fast and secure

  @payment @in-app
  Scenario: In-app purchase flow
    Given in-app purchase is needed
    When I complete purchase
    Then native purchase flow is used
    And transaction is recorded

  # ==========================================
  # TABLET-OPTIMIZED LAYOUTS
  # ==========================================

  @tablet @layout @happy-path
  Scenario: View app on tablet
    Given I am using a tablet
    When I open the app
    Then layout is tablet-optimized
    And screen space is used well

  @tablet @split-view
  Scenario: Use split view on tablet
    Given I am on iPad
    When I use split view
    Then app displays properly
    And multitasking works

  @tablet @landscape
  Scenario: Use tablet in landscape
    Given I rotate to landscape
    When I view the app
    Then layout adapts to landscape
    And more content is visible

  @tablet @sidebar
  Scenario: Use sidebar navigation on tablet
    Given tablet layout is active
    When I view navigation
    Then sidebar is always visible
    And navigation is quick

  # ==========================================
  # ACCESSIBILITY
  # ==========================================

  @accessibility @voiceover @happy-path
  Scenario: Use app with VoiceOver
    Given VoiceOver is enabled on iOS
    When I use the app
    Then all elements are properly labeled
    And navigation is accessible

  @accessibility @talkback
  Scenario: Use app with TalkBack
    Given TalkBack is enabled on Android
    When I use the app
    Then all elements are announced
    And app is fully accessible

  @accessibility @text-size
  Scenario: Support dynamic text size
    Given I use larger text
    When I view the app
    Then text respects my size preference
    And layout accommodates

  @accessibility @reduce-motion
  Scenario: Respect reduce motion setting
    Given I have reduce motion enabled
    When I use the app
    Then animations are minimized
    And transitions are simple

  @accessibility @color-blind
  Scenario: Support color blind users
    Given I am color blind
    When I view the app
    Then information is not color-only
    And icons/shapes provide context

  @accessibility @switch
  Scenario: Support switch control
    Given I use switch control
    When I navigate the app
    Then all actions are reachable
    And timing is appropriate

  # ==========================================
  # APP STORE OPTIMIZATION
  # ==========================================

  @aso @listing @happy-path
  Scenario: View optimized app store listing
    Given I am viewing app store listing
    When I see the listing
    Then description is compelling
    And screenshots showcase features

  @aso @reviews
  Scenario: View app reviews
    Given the app has reviews
    When I view reviews
    Then I see user feedback
    And ratings are visible

  @aso @rating-prompt
  Scenario: Prompt for app rating
    Given I am an engaged user
    When appropriate time arrives
    Then I am asked to rate the app
    And prompt is not annoying

  @aso @update-notes
  Scenario: View update release notes
    Given app has been updated
    When I view update notes
    Then I see what's new
    And changes are clear

  # ==========================================
  # ERROR HANDLING
  # ==========================================

  @error-handling
  Scenario: Handle network error gracefully
    Given network error occurs
    When I perform an action
    Then error is handled gracefully
    And I can retry

  @error-handling
  Scenario: Handle app crash recovery
    Given app crashed previously
    When I reopen the app
    Then state is recovered if possible
    And I can continue

  @error-handling
  Scenario: Handle outdated app version
    Given my app is outdated
    When I try to use features
    Then I am prompted to update
    And update path is clear
