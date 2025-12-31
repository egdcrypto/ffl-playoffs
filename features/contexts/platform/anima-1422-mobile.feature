@ANIMA-1422 @mobile @priority_1 @mobile-app
Feature: Mobile Application
  As a fantasy football playoffs platform user
  I want to access the platform via mobile app
  So that I can manage my fantasy teams on the go

  Background:
    Given the mobile app is installed
    And the user is authenticated
    And the device has network connectivity

  # ==================== MOBILE APP ====================

  Scenario: Launch mobile app
    Given the user opens the mobile app
    When the app initializes
    Then the app:
      | Shows splash screen with logo            |
      | Checks authentication status             |
      | Loads cached data for quick display      |
      | Syncs with server for latest data        |
    And the user lands on the dashboard

  Scenario: First-time app launch
    Given the user installs the app for first time
    When the app is opened
    Then onboarding flow shows:
      | Step                | Content                         |
      | Welcome             | App introduction                |
      | Permissions         | Request notifications, etc.     |
      | Login/Register      | Authentication options          |
      | Tutorial            | Quick feature tour              |
    And user can skip to login

  Scenario: App version check
    Given the app checks for updates
    When version is compared to minimum
    Then update handling:
      | Scenario            | Action                          |
      | Up to date          | Continue normally               |
      | Optional update     | Show update banner              |
      | Required update     | Force update before use         |
    And app store link is provided

  Scenario: Handle app crash recovery
    Given the app previously crashed
    When the app is reopened
    Then recovery actions:
      | Restores session if valid               |
      | Clears corrupted cache                  |
      | Reports crash to analytics              |
      | Shows normal state                      |
    And user data is preserved

  Scenario: App background and foreground
    Given the app is in background
    When the user returns to app
    Then the app:
      | Resumes from last screen                |
      | Refreshes stale data                    |
      | Updates notification badge              |
      | Maintains session state                 |
    And transition is smooth

  Scenario: Deep linking into app
    Given the user receives a link
    When the link is opened
    Then deep link handling:
      | Link Type           | Destination                     |
      | Matchup link        | Opens specific matchup          |
      | League invite       | Opens league join flow          |
      | Player link         | Opens player details            |
      | Trade link          | Opens trade proposal            |
    And authentication is required if needed

  # ==================== MOBILE NAVIGATION ====================

  Scenario: Bottom navigation bar
    Given the user is in the app
    When viewing any screen
    Then bottom nav shows:
      | Tab         | Icon      | Destination               |
      | Home        | House     | Dashboard                 |
      | Roster      | Team      | Roster management         |
      | Matchup     | VS        | Current matchup           |
      | League      | Trophy    | League standings          |
      | More        | Menu      | Additional options        |
    And active tab is highlighted

  Scenario: Navigate between tabs
    Given the user is on a tab
    When another tab is tapped
    Then navigation:
      | Switches to new tab instantly           |
      | Preserves previous tab state            |
      | Scrolls to top on same-tab tap          |
      | Animates transition smoothly            |
    And back button returns to previous tab

  Scenario: Access side menu
    Given the user opens side menu
    When menu slides in
    Then menu options include:
      | Option              | Action                          |
      | Profile             | View/edit profile               |
      | My Teams            | List of all teams               |
      | Settings            | App settings                    |
      | Help                | Help and support                |
      | Logout              | Sign out of app                 |
    And menu can be swiped away

  Scenario: Navigate with back gestures
    Given the user is on a detail screen
    When back gesture is performed
    Then navigation:
      | Returns to previous screen              |
      | Animates transition appropriately       |
      | Preserves scroll position               |
      | Works on iOS and Android                |
    And gesture is natural to platform

  Scenario: Tab badge notifications
    Given the user has pending items
    When badge counts are updated
    Then badges show on tabs:
      | Tab         | Badge Condition                 |
      | Home        | Unread notifications            |
      | Matchup     | Score update available          |
      | League      | Pending trade proposal          |
    And badges update in real-time

  # ==================== MOBILE DASHBOARD ====================

  Scenario: View mobile dashboard
    Given the user opens the app
    When dashboard loads
    Then dashboard displays:
      | Widget              | Content                         |
      | Current Matchup     | Score, opponent, status         |
      | My Teams            | Quick team switcher             |
      | Live Scores         | Active games ticker             |
      | Recent Activity     | Latest notifications            |
      | Quick Actions       | Common action buttons           |
    And widgets are scrollable

  Scenario: Dashboard pull-to-refresh
    Given the user is on dashboard
    When pull-to-refresh is triggered
    Then refresh behavior:
      | Shows refresh indicator                 |
      | Fetches latest data from server         |
      | Updates all dashboard widgets           |
      | Hides indicator when complete           |
    And refresh completes within 3 seconds

  Scenario: Dashboard widget customization
    Given the user wants to customize dashboard
    When customization mode is entered
    Then the user can:
      | Reorder widgets by drag and drop        |
      | Hide/show specific widgets              |
      | Resize widgets where applicable         |
      | Reset to default layout                 |
    And preferences are saved

  Scenario: Quick team switcher
    Given the user has multiple teams
    When team switcher is tapped
    Then switcher shows:
      | Team Name           | League          | Status    |
      | Doe's Dominators    | FFL Championship| Active    |
      | John's All-Stars    | Office Pool     | Active    |
    And selecting a team switches context

  Scenario: Live score ticker
    Given NFL games are in progress
    When ticker is displayed
    Then ticker shows:
      | Auto-scrolling game scores              |
      | Games affecting fantasy players         |
      | Tap to expand game details              |
      | Manual scroll override                  |
    And ticker updates in real-time

  # ==================== MOBILE ROSTER ====================

  Scenario: View mobile roster
    Given the user accesses roster
    When roster screen loads
    Then roster displays:
      | Position    | Player          | Status    | Proj Pts |
      | QB          | Patrick Mahomes | Starting  | 24.5     |
      | RB          | Derrick Henry   | Starting  | 16.2     |
      | RB          | Saquon Barkley  | Starting  | 18.5     |
      | BENCH       | Joe Mixon       | Benched   | 12.0     |
    And players are tappable for details

  Scenario: Edit lineup on mobile
    Given the user wants to change lineup
    When edit mode is activated
    Then editing options include:
      | Tap player to see swap options          |
      | Drag and drop to reorder                |
      | Quick swap with bench players           |
      | Lock indicator for locked positions     |
    And changes are saved automatically

  Scenario: Swap players via drag and drop
    Given the user drags a player
    When dropped on another position
    Then swap handling:
      | Validates position eligibility          |
      | Swaps players if valid                  |
      | Shows error if invalid                  |
      | Animates swap transition                |
    And roster updates immediately

  Scenario: View player details from roster
    Given the user taps a player
    When player modal opens
    Then details include:
      | Section             | Content                         |
      | Player Info         | Name, team, position            |
      | Stats               | Season and recent stats         |
      | Matchup             | This week's opponent            |
      | News                | Latest player news              |
      | Actions             | Drop, Trade, View Full Profile  |
    And modal is dismissible

  Scenario: Add player from waiver wire
    Given the user searches for players
    When player is found
    Then add flow:
      | Shows player availability               |
      | Shows who to drop (if roster full)      |
      | Confirms add/drop transaction           |
      | Updates roster immediately              |
    And waiver claim is submitted

  Scenario: Roster deadline countdown
    Given roster lock is approaching
    When deadline countdown is active
    Then countdown shows:
      | Time remaining prominently              |
      | Warning colors as deadline approaches   |
      | Lock notification when locked           |
    And user is alerted before lock

  # ==================== MOBILE MATCHUPS ====================

  Scenario: View current matchup
    Given the user has an active matchup
    When matchup screen loads
    Then matchup displays:
      | Element             | Content                         |
      | My Score            | Current fantasy points          |
      | Opponent Score      | Opponent's fantasy points       |
      | Projection          | Projected final scores          |
      | Players Remaining   | Count of yet-to-play players    |
    And scores update live during games

  Scenario: Compare matchup rosters
    Given the user views matchup
    When roster comparison is shown
    Then comparison displays:
      | Position | My Player       | My Pts | Opp Player      | Opp Pts |
      | QB       | Patrick Mahomes | 24.5   | Josh Allen      | 22.0    |
      | RB       | Derrick Henry   | 16.2   | CMC             | 28.5    |
    And position-by-position comparison

  Scenario: View matchup timeline
    Given the matchup is in progress
    When timeline is accessed
    Then timeline shows:
      | Time        | Event                           |
      | 1:00 PM     | Matchup started                 |
      | 1:45 PM     | Mahomes TD (+4 pts)             |
      | 2:15 PM     | Henry 50-yd run (+5 pts)        |
    And timeline scrolls as events occur

  Scenario: View opponent's roster
    Given the user wants to scout opponent
    When opponent roster is accessed
    Then display shows:
      | Full opponent lineup                    |
      | Projected points per player             |
      | Injury status indicators                |
      | Games remaining                         |
    And opponent's moves are visible

  Scenario: Matchup chat
    Given matchup allows chat
    When chat is opened
    Then chat features:
      | Send messages to opponent               |
      | Receive messages in real-time           |
      | Send reaction emojis                    |
      | Report inappropriate messages           |
    And chat is optional

  # ==================== MOBILE NOTIFICATIONS ====================

  Scenario: Receive push notification
    Given push notifications are enabled
    When a notification is triggered
    Then notification:
      | Shows on device lock screen             |
      | Displays in notification center         |
      | Shows app badge count                   |
      | Plays sound if enabled                  |
    And tapping opens relevant screen

  Scenario: Configure notification preferences
    Given the user manages notifications
    When preferences are accessed
    Then configurable options:
      | Notification Type       | Options             |
      | Score Updates           | All, Important, None|
      | Trade Proposals         | On, Off             |
      | Roster Reminders        | On, Off             |
      | League Activity         | On, Off             |
      | Game Start Alerts       | On, Off             |
    And changes take effect immediately

  Scenario: In-app notification center
    Given the user has notifications
    When notification center is opened
    Then notifications display:
      | Type                | Time      | Read   | Action        |
      | Score Update        | 5 min ago | Unread | View Matchup  |
      | Trade Proposal      | 1 hr ago  | Unread | View Trade    |
      | League Announcement | 2 hr ago  | Read   | View League   |
    And notifications can be marked read

  Scenario: Rich push notifications
    Given a significant event occurs
    When rich notification is sent
    Then notification includes:
      | Image or thumbnail                      |
      | Action buttons                          |
      | Expandable details                      |
      | Quick reply options                     |
    And actions work without opening app

  Scenario: Notification grouping
    Given multiple notifications arrive
    When notifications are grouped
    Then grouping shows:
      | "5 new score updates" (collapsed)       |
      | Individual notifications (expanded)     |
    And groups can be expanded/collapsed

  # ==================== MOBILE OFFLINE ====================

  Scenario: Access app while offline
    Given the device has no network
    When the app is opened
    Then offline behavior:
      | Shows cached data                       |
      | Displays offline indicator              |
      | Disables network-required actions       |
      | Queues actions for later sync           |
    And user can view cached content

  Scenario: View roster offline
    Given the user is offline
    When roster is accessed
    Then offline roster shows:
      | Last synced roster data                 |
      | "Offline" badge on screen               |
      | View-only mode                          |
      | Last sync timestamp                     |
    And changes cannot be made

  Scenario: Queue actions while offline
    Given the user attempts actions offline
    When offline action is taken
    Then queuing behavior:
      | Action is queued locally                |
      | User is informed of queue               |
      | Queue persists across app restarts      |
      | Queue syncs when online                 |
    And queued actions are visible

  Scenario: Sync when connectivity returns
    Given actions were queued offline
    When network connectivity returns
    Then sync process:
      | Detects network availability            |
      | Syncs queued actions                    |
      | Resolves conflicts if any               |
      | Notifies user of sync results           |
    And sync happens automatically

  Scenario: Handle sync conflicts
    Given offline changes conflict with server
    When sync is attempted
    Then conflict resolution:
      | Shows conflicting changes               |
      | Offers resolution options               |
      | Allows user to choose version           |
      | Applies selected resolution             |
    And data integrity is maintained

  Scenario: Offline data caching strategy
    Given the app caches data
    When caching rules apply
    Then cached data includes:
      | Data Type           | Cache Duration      |
      | Roster              | Until next sync     |
      | Matchup             | Until next sync     |
      | Player Stats        | 24 hours            |
      | League Standings    | 1 hour              |
    And cache size is managed

  # ==================== MOBILE PERFORMANCE ====================

  Scenario: App launch performance
    Given the user opens the app
    When launch time is measured
    Then performance targets:
      | Metric              | Target                          |
      | Cold Start          | Under 2 seconds                 |
      | Warm Start          | Under 1 second                  |
      | First Content       | Under 1.5 seconds               |
    And splash screen covers loading

  Scenario: Smooth scrolling
    Given the user scrolls a list
    When scroll performance is measured
    Then scroll behavior:
      | Maintains 60 FPS                        |
      | No jank or stuttering                   |
      | Images load asynchronously              |
      | Placeholder content shown               |
    And scroll is butter-smooth

  Scenario: Image loading optimization
    Given images need to load
    When images are displayed
    Then optimization includes:
      | Progressive image loading               |
      | Appropriate resolution for device       |
      | Lazy loading for off-screen             |
      | Cached images load instantly            |
    And bandwidth is conserved

  Scenario: Battery usage optimization
    Given the app is in use
    When battery impact is measured
    Then optimization includes:
      | Efficient background refresh            |
      | GPS usage only when needed              |
      | Animation reduction in low power        |
      | Network requests batched                |
    And app is battery-friendly

  Scenario: Memory management
    Given the app uses memory
    When memory is managed
    Then management includes:
      | Releases unused resources               |
      | Caches appropriately                    |
      | Handles low memory warnings             |
      | Prevents memory leaks                   |
    And app stays responsive

  Scenario: Network efficiency
    Given network requests are made
    When efficiency is optimized
    Then optimization includes:
      | Request compression                     |
      | Response caching                        |
      | Batch requests where possible           |
      | Delta updates for changes only          |
    And data usage is minimized

  # ==================== MOBILE GESTURES ====================

  Scenario: Swipe to delete
    Given the user views a list with deletable items
    When swipe gesture is performed
    Then swipe behavior:
      | Reveals delete action                   |
      | Confirms deletion before completing     |
      | Animates item removal                   |
      | Provides undo option                    |
    And gesture is consistent across lists

  Scenario: Pull to refresh
    Given the user is on a refreshable screen
    When pull-down gesture is performed
    Then refresh behavior:
      | Shows refresh indicator                 |
      | Triggers data refresh                   |
      | Hides indicator on completion           |
      | Shows error if refresh fails            |
    And gesture is discoverable

  Scenario: Swipe between matchups
    Given the user is viewing a matchup
    When swipe left/right is performed
    Then navigation:
      | Swipe left for next matchup             |
      | Swipe right for previous matchup        |
      | Page indicator shows position           |
      | Edge bounce at ends                     |
    And transition is smooth

  Scenario: Pinch to zoom on charts
    Given the user views a chart
    When pinch gesture is performed
    Then zoom behavior:
      | Zooms in/out on chart                   |
      | Maintains data accuracy                 |
      | Double-tap to reset zoom                |
      | Pan when zoomed in                      |
    And chart remains readable

  Scenario: Long press for quick actions
    Given the user long presses an item
    When context menu appears
    Then menu shows:
      | Quick action options                    |
      | Haptic feedback on trigger              |
      | Dismiss on tap outside                  |
      | Keyboard shortcut hints                 |
    And actions execute immediately

  Scenario: Shake to undo
    Given the user makes a change
    When device is shaken
    Then undo behavior:
      | Shows undo confirmation                 |
      | Reverses last action                    |
      | Works within time window                |
      | Can be disabled in settings             |
    And undo is reversible (redo)

  # ==================== MOBILE SETTINGS ====================

  Scenario: Access app settings
    Given the user opens settings
    When settings screen loads
    Then settings categories show:
      | Category            | Options                         |
      | Account             | Profile, password, linked accounts|
      | Notifications       | Push, email preferences         |
      | Display             | Theme, text size, layout        |
      | Data & Storage      | Cache, offline, data usage      |
      | Privacy             | Privacy controls                |
      | About               | Version, legal, support         |
    And settings are organized logically

  Scenario: Change display theme
    Given the user accesses display settings
    When theme option is changed
    Then theme options include:
      | Theme               | Description                     |
      | Light               | Light background                |
      | Dark                | Dark background                 |
      | System              | Match device setting            |
      | Auto                | Based on time of day            |
    And theme changes immediately

  Scenario: Adjust text size
    Given the user has accessibility needs
    When text size is adjusted
    Then size options include:
      | Size                | Scale                           |
      | Small               | 85%                             |
      | Default             | 100%                            |
      | Large               | 115%                            |
      | Extra Large         | 130%                            |
    And all text scales appropriately

  Scenario: Manage data usage
    Given the user wants to control data
    When data settings are accessed
    Then options include:
      | Setting                 | Options                     |
      | Image Quality           | Auto, Low, High             |
      | Auto-play Videos        | WiFi only, Never, Always    |
      | Background Refresh      | On, Off                     |
      | Download on WiFi Only   | On, Off                     |
    And preferences affect behavior

  Scenario: Clear app cache
    Given the user wants to clear cache
    When cache clear is initiated
    Then clearing shows:
      | Current cache size (e.g., 125 MB)       |
      | Confirmation dialog                     |
      | Progress indicator                      |
      | Success confirmation                    |
    And app continues working after clear

  Scenario: Export/backup settings
    Given the user wants to backup settings
    When export is initiated
    Then export includes:
      | Notification preferences                |
      | Display settings                        |
      | Widget customization                    |
      | Saved filters and views                 |
    And settings can be restored

  # ==================== MOBILE ACCESSIBILITY ====================

  Scenario: VoiceOver/TalkBack support
    Given the user uses screen reader
    When navigating the app
    Then accessibility features:
      | All elements have labels                |
      | Focus order is logical                  |
      | Actions are announced                   |
      | Gestures have alternatives              |
    And app is fully navigable

  Scenario: Dynamic type support
    Given the user has system text scaling
    When app respects system settings
    Then text scaling:
      | Respects system font size               |
      | Layouts adapt to larger text            |
      | No text truncation                      |
      | Buttons remain tappable                 |
    And readability is maintained

  Scenario: Reduce motion preference
    Given the user prefers reduced motion
    When animations play
    Then motion handling:
      | Respects system reduce motion           |
      | Replaces animations with fades          |
      | Removes parallax effects                |
      | Keeps essential transitions             |
    And experience remains smooth

  # ==================== ERROR HANDLING ====================

  Scenario: Handle network errors gracefully
    Given a network error occurs
    When error is detected
    Then error handling:
      | Shows user-friendly error message       |
      | Offers retry option                     |
      | Falls back to cached data               |
      | Logs error for debugging                |
    And app doesn't crash

  Scenario: Handle server errors
    Given the server returns an error
    When error response is received
    Then handling includes:
      | Shows appropriate error message         |
      | Offers to retry                         |
      | Provides support contact                |
      | Doesn't expose technical details        |
    And user can continue using app
