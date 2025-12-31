@ANIMA-1290 @frontend @priority_1 @draft @real-time
Feature: Draft Room Interface
  As a fantasy football playoffs participant
  I want an interactive real-time draft room experience
  So that I can select NFL players for my playoff roster in a live draft setting

  Background:
    Given a league "2025 NFL Playoffs Pool" exists
    And the league has 12 participants
    And the draft is configured for snake draft order
    And each team drafts 9 roster positions:
      | Position | Count |
      | QB       | 1     |
      | RB       | 2     |
      | WR       | 2     |
      | TE       | 1     |
      | FLEX     | 1     |
      | K        | 1     |
      | DEF      | 1     |
    And the draft is scheduled to start at a specific time
    And the current user is authenticated and registered for the draft

  # ============================================
  # DRAFT ROOM ENTRY AND INITIALIZATION
  # ============================================

  @entry @happy-path
  Scenario: Enter draft room before draft starts
    Given the draft is scheduled to start in 10 minutes
    When the user enters the draft room
    Then the draft lobby is displayed
    And a countdown timer shows time until draft starts
    And the draft order is displayed
    And participant list shows who has joined
    And chat functionality is available
    And "Draft starts in 10:00" message is shown

  @entry @happy-path
  Scenario: Enter draft room when draft is in progress
    Given the draft started 30 minutes ago
    And it is currently Round 3, Pick 5
    When the user enters the draft room
    Then the current draft state is loaded
    And the user sees their already-drafted players
    And the current pick is highlighted
    And pick history is visible
    And if it's the user's turn, they are prompted to pick

  @entry @late
  Scenario: Handle late entry to draft
    Given the draft started 15 minutes ago
    And the user "john_doe" missed their first two picks
    When john_doe enters the draft room
    Then auto-picked players are shown for missed picks
    And john_doe's roster shows the auto-picked players
    And a notification explains the auto-picks
    And john_doe can continue drafting from current position

  # ============================================
  # DRAFT TIMER COUNTDOWN
  # ============================================

  @timer @display
  Scenario: Display draft timer for current pick
    Given it is the current user's turn to pick
    And the pick timer is set to 90 seconds
    When the user's turn begins
    Then a countdown timer displays "1:30"
    And the timer counts down in real-time
    And the timer is prominently displayed
    And audio/visual cues indicate time remaining

  @timer @warning
  Scenario: Display timer warning when time is running low
    Given it is the current user's turn to pick
    And 20 seconds remain on the clock
    When the timer reaches 20 seconds
    Then the timer turns yellow/orange (warning color)
    And an audible warning sound plays
    And the timer display may pulse or animate
    And "Hurry up!" message may be shown

  @timer @critical
  Scenario: Display critical timer warning
    Given it is the current user's turn to pick
    And 10 seconds remain on the clock
    When the timer reaches 10 seconds
    Then the timer turns red (critical color)
    And countdown becomes more urgent visually
    And audio warning intensifies
    And auto-pick warning is displayed

  @timer @expired
  Scenario: Handle timer expiration with auto-pick
    Given it is "john_doe's" turn to pick
    And the timer expires (reaches 0)
    When auto-pick is triggered
    Then the best available player based on rankings is selected
    And the pick is announced to all participants
    And "Auto-picked" indicator is shown on the selection
    And the draft advances to the next pick
    And john_doe receives notification of auto-pick

  @timer @pause
  Scenario: Commissioner pauses the draft timer
    Given the draft is in progress
    And the commissioner needs to pause
    When the commissioner clicks "Pause Draft"
    Then all timers stop
    And "DRAFT PAUSED" message is displayed to all
    And no picks can be made during pause
    And commissioner can resume with "Resume Draft"

  @timer @settings
  Scenario: Display different timer settings per round
    Given the league has configured timers:
      | Round | Time Limit |
      | 1-3   | 120 seconds |
      | 4-6   | 90 seconds  |
      | 7-9   | 60 seconds  |
    When viewing the draft room
    Then the current round's timer setting is used
    And timer settings are visible in draft info

  # ============================================
  # PICK QUEUE MANAGEMENT
  # ============================================

  @queue @add
  Scenario: Add player to pick queue
    Given the draft is in progress
    And it is not currently the user's turn
    When the user clicks "Add to Queue" on "Patrick Mahomes"
    Then Patrick Mahomes is added to the user's queue
    And a queue indicator shows the player is queued
    And the queue panel displays Patrick Mahomes
    And queue position number is shown

  @queue @multiple
  Scenario: Manage multiple players in queue
    Given the user has 3 players in their queue:
      | Position | Player         |
      | 1        | Patrick Mahomes |
      | 2        | Josh Allen      |
      | 3        | Lamar Jackson   |
    When viewing the queue panel
    Then all 3 players are displayed in order
    And drag-and-drop reordering is available
    And remove buttons are available for each player
    And "Clear Queue" option is available

  @queue @reorder
  Scenario: Reorder players in queue
    Given the user has Patrick Mahomes at position 1
    And Josh Allen at position 2
    When the user drags Josh Allen above Patrick Mahomes
    Then Josh Allen moves to position 1
    And Patrick Mahomes moves to position 2
    And queue order is saved

  @queue @auto-select
  Scenario: Auto-select from queue when turn arrives
    Given the user has "Patrick Mahomes" at the top of their queue
    And Patrick Mahomes is still available
    When it becomes the user's turn
    Then Patrick Mahomes is highlighted as suggested pick
    And "Pick from Queue" button is prominently displayed
    And one-click selection is available

  @queue @unavailable
  Scenario: Handle queued player becoming unavailable
    Given the user has "Patrick Mahomes" in their queue
    And another participant drafts Patrick Mahomes
    When Patrick Mahomes is drafted
    Then Patrick Mahomes is marked as unavailable in the queue
    And strikethrough or grayed-out styling is applied
    And notification alerts the user
    And next available queued player is suggested

  @queue @persist
  Scenario: Persist queue across page refresh
    Given the user has 5 players in their queue
    When the user refreshes the page
    Then the queue is restored with all 5 players
    And queue order is maintained
    And unavailable players are updated

  # ============================================
  # PLAYER SEARCH AND FILTERING
  # ============================================

  @search @text
  Scenario: Search players by name
    Given the player list is displayed
    When the user types "Mahom" in the search box
    Then results filter to show "Patrick Mahomes"
    And other players with "Mahom" in name are shown
    And search is case-insensitive
    And results update as user types (debounced)

  @search @instant
  Scenario: Instant search results
    Given the user is searching for a player
    When each character is typed
    Then results filter within 200ms
    And no full page reload occurs
    And result count is displayed

  @filter @position
  Scenario: Filter players by position
    Given the player list is displayed
    When the user selects "QB" position filter
    Then only quarterbacks are displayed
    And position filter is highlighted
    And "Clear Filter" option is available
    And multiple positions can be selected

  @filter @team
  Scenario: Filter players by NFL team
    Given the player list is displayed
    When the user selects "Kansas City Chiefs" team filter
    Then only Chiefs players are displayed
    And team logo/colors may be shown
    And filter can be combined with position filter

  @filter @availability
  Scenario: Filter to show only available players
    Given some players have been drafted
    When the user enables "Available Only" filter
    Then drafted players are hidden
    And only undrafted players are shown
    And the toggle is clearly visible

  @filter @bye-week
  Scenario: Filter players by playoff bye week
    Given some players have first-round byes
    When the user filters by "No Bye Week 1"
    Then only players active in Wild Card are shown
    And bye week info is displayed for each player

  @filter @combined
  Scenario: Apply multiple filters simultaneously
    Given the user applies filters:
      | Filter Type | Value          |
      | Position    | RB             |
      | Team        | Baltimore      |
      | Available   | Yes            |
    When filters are applied
    Then only available Baltimore Ravens running backs are shown
    And active filters are displayed as chips/tags
    And each filter can be removed individually

  @filter @clear
  Scenario: Clear all filters
    Given multiple filters are applied
    When the user clicks "Clear All Filters"
    Then all filters are removed
    And full player list is displayed
    And search box is cleared

  @sort @ranking
  Scenario: Sort players by ranking
    Given the player list is displayed
    When the user sorts by "Expert Ranking"
    Then players are ordered by ranking (best first)
    And ranking numbers are displayed
    And sort direction can be toggled (asc/desc)

  @sort @stats
  Scenario: Sort players by projected points
    Given the player list is displayed
    When the user sorts by "Projected Points"
    Then players are ordered by projection
    And projected point values are visible
    And source of projections is indicated

  # ============================================
  # DRAFT BOARD DISPLAY
  # ============================================

  @board @structure
  Scenario: Display draft board grid
    Given the draft is in progress
    When viewing the draft board
    Then a grid shows all picks:
      | Rows represent rounds (1-9)    |
      | Columns represent teams (1-12) |
    And each cell shows the picked player or is empty
    And current pick cell is highlighted
    And the board scrolls if necessary

  @board @team-columns
  Scenario: Display team columns with headers
    Given the draft board is displayed
    When viewing team columns
    Then each column header shows team owner name
    And owner avatars may be displayed
    And column for current user is highlighted
    And column widths accommodate player names

  @board @round-rows
  Scenario: Display round rows with snake order
    Given the draft uses snake order
    When viewing round rows
    Then odd rounds go left-to-right (1→12)
    And even rounds go right-to-left (12→1)
    And arrows indicate draft direction
    And current round row is highlighted

  @board @cell-content
  Scenario: Display pick details in board cells
    Given "john_doe" picked "Patrick Mahomes" in Round 1, Pick 3
    When viewing the draft board cell
    Then the cell shows:
      | Player name    | Patrick Mahomes |
      | Position       | QB              |
      | NFL Team       | KC              |
      | Pick number    | 1.03            |
    And clicking the cell shows more details

  @board @empty-cell
  Scenario: Display empty cells for future picks
    Given some picks have not been made yet
    When viewing future pick cells
    Then cells show "---" or team logo placeholder
    And cells are styled differently than made picks
    And upcoming picks may show pick number

  @board @scroll
  Scenario: Scroll draft board to current pick
    Given the draft is in Round 7
    When entering the draft room or when a new round starts
    Then the board auto-scrolls to show current pick
    And manual scrolling is available
    And "Jump to Current" button is available

  @board @highlight-user
  Scenario: Highlight current user's picks
    Given the current user has made 5 picks
    When viewing the draft board
    Then the user's column is visually distinguished
    And user's picks have special styling (border/background)
    And "My Team" label may be shown

  # ============================================
  # AUTO-PICK FUNCTIONALITY
  # ============================================

  @autopick @enable
  Scenario: Enable auto-pick mode
    Given the user needs to step away
    When the user enables "Auto-Pick" mode
    Then auto-pick status indicator shows "ON"
    And all participants see user is on auto-pick
    And picks will be made automatically when user's turn
    And confirmation message is shown

  @autopick @disable
  Scenario: Disable auto-pick mode
    Given auto-pick is currently enabled
    When the user disables auto-pick
    Then auto-pick status shows "OFF"
    And manual picking resumes
    And timer applies to user's picks again

  @autopick @rankings
  Scenario: Auto-pick uses configured rankings
    Given the user has customized their player rankings
    And auto-pick is enabled
    When it becomes the user's turn
    Then the highest-ranked available player is selected
    And position needs are considered
    And the pick follows the user's pre-draft rankings

  @autopick @default
  Scenario: Auto-pick uses default rankings if none set
    Given the user has not set custom rankings
    And auto-pick is enabled
    When it becomes the user's turn
    Then expert consensus rankings are used
    And best available player is selected
    And a notification indicates default rankings used

  @autopick @position-need
  Scenario: Auto-pick considers roster needs
    Given the user has already drafted 2 QBs
    And roster limit is 1 QB
    When auto-pick runs
    Then QBs are skipped
    And next highest-ranked player at needed position is picked
    And roster composition is respected

  @autopick @queue-priority
  Scenario: Auto-pick prioritizes queue over rankings
    Given the user has players in their queue
    And auto-pick is enabled
    When it becomes the user's turn
    Then the top queued available player is picked first
    And if queue is empty, rankings are used

  # ============================================
  # DRAFT ORDER VISUALIZATION
  # ============================================

  @order @display
  Scenario: Display draft order list
    Given the draft order has been set
    When viewing the draft order panel
    Then all 12 teams are listed in order
    And position numbers (1-12) are shown
    And team names and owner names are displayed
    And current picker is highlighted

  @order @snake
  Scenario: Display snake draft order progression
    Given the draft uses snake order
    When viewing order for multiple rounds
    Then Round 1 shows order 1→12
    And Round 2 shows order 12→1
    And Round 3 shows order 1→12
    And arrows or visual cues show direction changes

  @order @upcoming
  Scenario: Show upcoming picks for current user
    Given the current user picks 5th in odd rounds
    And picks 8th in even rounds
    When viewing "My Upcoming Picks" section
    Then next 3-5 upcoming picks are shown
    And picks until next turn are counted
    And estimated time until next pick is shown

  @order @on-the-clock
  Scenario: Display "On the Clock" indicator
    Given it is "jane_doe's" turn to pick
    When viewing the draft room
    Then "jane_doe" has "ON THE CLOCK" badge
    And their position in order is highlighted
    And timer is associated with their name
    And all participants see who is picking

  @order @completed
  Scenario: Display completed picks in order
    Given 15 picks have been made
    When viewing pick order history
    Then picks are listed chronologically
    And each shows: pick #, team, player, position
    And most recent picks are at top
    And scrolling reveals earlier picks

  # ============================================
  # PICK HISTORY
  # ============================================

  @history @display
  Scenario: Display pick history log
    Given multiple picks have been made
    When viewing the pick history panel
    Then picks are shown in reverse chronological order
    And each entry shows:
      | Pick number (e.g., 1.05)        |
      | Team/owner who picked           |
      | Player name and position        |
      | NFL team                        |
      | Timestamp                       |

  @history @live-feed
  Scenario: Update pick history in real-time
    Given the user is viewing pick history
    When another participant makes a pick
    Then the new pick appears at the top of history
    And animation highlights the new entry
    And "New Pick" indicator may flash
    And history scrolls to show new pick

  @history @filter
  Scenario: Filter pick history by team
    Given 50 picks have been made
    When the user filters history to "john_doe's picks"
    Then only john_doe's picks are shown
    And pick numbers maintain original sequence
    And "Show All" option is available

  @history @export
  Scenario: Export pick history
    Given the draft is complete
    When the user clicks "Export History"
    Then options for CSV, PDF are presented
    And exported file includes all picks with details
    And file downloads to user's device

  # ============================================
  # REAL-TIME UPDATES WHEN OTHERS PICK
  # ============================================

  @realtime @pick-notification
  Scenario: Receive notification when another player picks
    Given the user is in the draft room
    And it is another participant's turn
    When that participant makes a pick
    Then a notification appears: "[Owner] picked [Player]"
    And the draft board updates
    And the player is marked as unavailable
    And pick history adds the new entry

  @realtime @visual-update
  Scenario: Visual update when pick is made
    Given the user is viewing the draft board
    When a pick is made by any participant
    Then the board cell fills with player info
    And animation highlights the new pick
    And available player list updates
    And current pick indicator advances

  @realtime @turn-notification
  Scenario: Receive notification when it's user's turn
    Given it was the previous picker's turn
    When that pick is made and it becomes user's turn
    Then prominent "YOUR TURN!" notification appears
    And browser notification is sent (if permitted)
    And audio alert plays
    And timer starts for user's pick

  @realtime @queue-update
  Scenario: Update queue when queued player is taken
    Given the user has "Josh Allen" in their queue
    When another participant drafts Josh Allen
    Then Josh Allen is marked unavailable in queue
    And notification: "Josh Allen was drafted by [Owner]"
    And queue automatically highlights next available

  @realtime @sync
  Scenario: Maintain sync across all participants
    Given 12 participants are in the draft room
    When any pick is made
    Then all 12 clients update within 1 second
    And all see the same draft state
    And no conflicts or duplicates occur

  # ============================================
  # CONNECTION HANDLING
  # ============================================

  @connection @websocket
  Scenario: Establish WebSocket connection for real-time updates
    Given the user enters the draft room
    When the page loads
    Then a WebSocket connection is established
    And connection status indicator shows "Connected"
    And real-time updates begin flowing

  @connection @disconnect
  Scenario: Handle connection disconnect
    Given the user has an active connection
    When the connection is lost
    Then "Disconnected" warning is displayed
    And auto-reconnection attempts begin
    And draft actions are disabled until reconnected
    And countdown shows reconnection attempts

  @connection @reconnect
  Scenario: Reconnect and sync after disconnect
    Given the user was disconnected for 30 seconds
    And 2 picks were made during disconnect
    When the connection is restored
    Then the draft state is fully synchronized
    And missed picks appear in history
    And draft board shows current state
    And "Reconnected" confirmation is shown

  @connection @offline-queue
  Scenario: Queue actions while disconnected
    Given the user loses connection
    When the user adds a player to queue while offline
    Then the action is queued locally
    And "Will sync when connected" message appears
    When connection is restored
    Then queued actions are synchronized

  @connection @latency
  Scenario: Handle high latency gracefully
    Given network latency is high (> 2 seconds)
    When the user makes a pick
    Then "Submitting pick..." indicator shows
    And pick is confirmed when server responds
    And timeout occurs if no response in 10 seconds
    And retry option is provided

  @connection @heartbeat
  Scenario: Maintain connection with heartbeat
    Given the user is in the draft room
    When the connection is idle
    Then heartbeat pings are sent every 30 seconds
    And server responds to confirm connection
    And connection is maintained during long waits

  # ============================================
  # MOBILE RESPONSIVE VIEWS
  # ============================================

  @mobile @layout
  Scenario: Display draft room on mobile device
    Given the user is on a mobile device (< 768px)
    When entering the draft room
    Then a mobile-optimized layout is shown
    And key panels are accessible via tabs or accordion
    And draft board is scrollable/zoomable
    And timer is always visible

  @mobile @tabs
  Scenario: Navigate draft room via tabs on mobile
    Given the mobile layout is displayed
    When viewing available tabs
    Then tabs include: "Board", "Players", "My Team", "Queue", "History"
    And swiping changes tabs
    And current tab is highlighted
    And tab badges show counts/alerts

  @mobile @player-list
  Scenario: View player list on mobile
    Given the user is on mobile
    When viewing the "Players" tab
    Then players are listed in scrollable cards
    And search is prominently placed
    And filters are accessible via filter button
    And "Add to Queue" and "Draft" buttons are touch-friendly

  @mobile @make-pick
  Scenario: Make a pick on mobile
    Given it is the user's turn on mobile
    When the user selects a player to draft
    Then a confirmation modal appears
    And "Confirm Pick" button is large and tappable
    And accidental picks are prevented
    And success feedback is clear

  @mobile @notifications
  Scenario: Receive mobile notifications
    Given the user has the app in background
    When it becomes their turn
    Then a push notification is sent
    And tapping notification opens draft room
    And the user is prompted to make their pick

  @mobile @landscape
  Scenario: Use landscape mode on mobile
    Given the user rotates to landscape
    When the draft room adjusts
    Then more draft board is visible
    And split view may show board + player list
    And timer remains visible

  # ============================================
  # DESKTOP VIEWS
  # ============================================

  @desktop @layout
  Scenario: Display full draft room on desktop
    Given the user is on a desktop device (> 1024px)
    When entering the draft room
    Then multi-panel layout is displayed:
      | Panel          | Position      |
      | Draft Board    | Center/Main   |
      | Player List    | Right Side    |
      | My Team        | Left Side     |
      | Pick History   | Bottom/Side   |
      | Timer/Status   | Top           |

  @desktop @resize
  Scenario: Resize panels on desktop
    Given the desktop layout is displayed
    When the user drags panel dividers
    Then panels resize accordingly
    And minimum sizes are enforced
    And layout preferences are saved

  @desktop @keyboard
  Scenario: Use keyboard shortcuts on desktop
    Given the user is in the draft room
    When using keyboard shortcuts:
      | Shortcut | Action            |
      | Enter    | Confirm pick      |
      | Q        | Add to queue      |
      | /        | Focus search      |
      | Esc      | Cancel/close      |
    Then actions are performed
    And shortcut help is available (?)

  @desktop @multi-monitor
  Scenario: Pop out panels to second monitor
    Given the user has multiple monitors
    When clicking "Pop Out" on a panel
    Then the panel opens in a new window
    And the window can be moved to another monitor
    And real-time sync continues across windows

  # ============================================
  # ERROR RECOVERY
  # ============================================

  @error @pick-failure
  Scenario: Handle pick submission failure
    Given the user attempts to draft a player
    When the server returns an error
    Then an error message is displayed
    And the pick is not committed
    And the user can retry
    And the player remains available (if still undrafted)

  @error @player-taken
  Scenario: Handle race condition - player already taken
    Given the user clicks to draft "Patrick Mahomes"
    And another user drafted Mahomes milliseconds before
    When the server processes the request
    Then error: "Patrick Mahomes was just drafted"
    And the user must select another player
    And timer does not reset (time continues)
    And Mahomes is now shown as unavailable

  @error @session-expired
  Scenario: Handle session expiration
    Given the user's session expires during draft
    When an action is attempted
    Then "Session expired" message is shown
    And re-authentication is required
    And after login, user returns to draft room
    And draft state is restored

  @error @server-error
  Scenario: Handle server error gracefully
    Given a server error occurs (500)
    When the error is detected
    Then "Server error" message is displayed
    And automatic retry is attempted
    And manual refresh option is provided
    And draft state is preserved locally

  @error @data-conflict
  Scenario: Handle data synchronization conflict
    Given local and server states differ
    When conflict is detected
    Then server state is accepted as authoritative
    And local state is updated
    And user is notified of any changes
    And no data is lost

  # ============================================
  # CHAT AND COMMUNICATION
  # ============================================

  @chat @send
  Scenario: Send chat message during draft
    Given the user is in the draft room
    When the user types a message and sends
    Then the message appears in chat for all participants
    And sender name and timestamp are shown
    And chat scrolls to show new message

  @chat @receive
  Scenario: Receive chat messages from others
    Given chat is open
    When another participant sends a message
    Then the message appears in real-time
    And unread indicator shows if chat is minimized
    And notification sound may play

  @chat @reactions
  Scenario: React to picks with emojis
    Given a pick was just made
    When the user clicks a reaction emoji
    Then the reaction appears on the pick
    And all participants see the reaction
    And reaction counts are shown

  # ============================================
  # DRAFT COMPLETION
  # ============================================

  @completion @final-pick
  Scenario: Handle final pick of draft
    Given only one pick remains
    When the final pick is made
    Then "DRAFT COMPLETE!" announcement appears
    And celebration animation plays
    And final rosters are displayed
    And "View Results" button is available

  @completion @results
  Scenario: Display draft results
    Given the draft is complete
    When viewing results
    Then all teams and their rosters are shown
    And draft grades may be displayed
    And "Best Pick" and "Reach" picks highlighted
    And export/share options are available

  @completion @roster-confirmation
  Scenario: Confirm roster after draft
    Given the draft is complete
    When the user views their team
    Then full roster is displayed
    And all positions are filled
    And total projected points shown
    And link to playoff preparation is provided

  # ============================================
  # ACCESSIBILITY
  # ============================================

  @accessibility @screen-reader
  Scenario: Support screen reader navigation
    Given the user uses a screen reader
    When navigating the draft room
    Then all elements have proper aria labels
    And pick announcements are read aloud
    And timer status is announced
    And focus management is logical

  @accessibility @keyboard
  Scenario: Full keyboard accessibility
    Given the user cannot use a mouse
    When navigating with keyboard
    Then all functions are accessible via keyboard
    And focus indicators are visible
    And tab order is logical
    And no keyboard traps exist

  @accessibility @contrast
  Scenario: Maintain color contrast
    Given the draft room uses various colors
    When viewed by users with vision impairments
    Then all text meets WCAG AA contrast (4.5:1)
    And status is not conveyed by color alone
    And high contrast mode is available

  # ============================================
  # PERFORMANCE
  # ============================================

  @performance @load
  Scenario: Load draft room efficiently
    Given the draft room has full player database
    When entering the draft room
    Then initial load completes within 3 seconds
    And player list loads progressively
    And critical UI (timer, current pick) loads first

  @performance @updates
  Scenario: Handle rapid updates efficiently
    Given multiple picks are made quickly
    When updates stream to all clients
    Then UI remains responsive
    And no updates are dropped
    And rendering does not block user interaction
