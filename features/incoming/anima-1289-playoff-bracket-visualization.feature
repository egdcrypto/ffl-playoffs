@ANIMA-1289 @frontend @priority_1 @bracket @visualization
Feature: Playoff Bracket Visualization
  As a fantasy football playoffs participant
  I want to view an interactive playoff bracket
  So that I can track tournament progression, see matchups, and follow my path to the championship

  Background:
    Given a league "2025 NFL Playoffs Pool" exists
    And the league has 16 players in the playoffs
    And the playoff format is 4 rounds:
      | Round        | Week | Matchups |
      | Wild Card    | 1    | 8        |
      | Divisional   | 2    | 4        |
      | Conference   | 3    | 2        |
      | Championship | 4    | 1        |
    And the current user is authenticated

  # ============================================
  # BRACKET STRUCTURE AND LAYOUT
  # ============================================

  @structure @happy-path
  Scenario: Display complete playoff bracket structure
    Given the playoff bracket has been initialized
    When the user navigates to the bracket view
    Then the bracket displays all 4 rounds in a tournament tree format
    And each round is clearly labeled (Wild Card, Divisional, Conference, Championship)
    And matchup slots are arranged from left to right showing progression
    And the Championship winner slot is prominently displayed at the center/right
    And connecting lines show advancement paths between rounds

  @structure @seeding
  Scenario: Display bracket with seeding positions
    Given 16 players are seeded based on regular season standings
    When the bracket is displayed
    Then seed numbers are shown next to each player name
    And higher seeds are positioned at the top of each matchup bracket
    And seed 1 plays seed 16 in the first matchup
    And seed 2 plays seed 15 in the second matchup
    And traditional tournament seeding order is maintained

  @structure @rounds
  Scenario: Display round headers with dates
    Given the playoff schedule is configured
    When viewing the bracket
    Then each round shows:
      | Round        | Date Range           |
      | Wild Card    | Jan 11-13, 2025      |
      | Divisional   | Jan 18-19, 2025      |
      | Conference   | Jan 26, 2025         |
      | Championship | Feb 9, 2025          |
    And current round is highlighted
    And past rounds are visually distinguished from future rounds

  @structure @layout
  Scenario: Display bracket with proper spacing and alignment
    Given the bracket has multiple rounds
    When rendered on screen
    Then matchups within each round are evenly spaced
    And advancement lines connect logically to next round matchups
    And there is sufficient space to display player names and scores
    And the layout scales appropriately for the number of participants

  # ============================================
  # MATCHUP VISUALIZATION
  # ============================================

  @matchup @display
  Scenario: Display individual matchup details
    Given a Wild Card matchup exists between "john_doe" (seed 1) and "player16" (seed 16)
    When viewing the matchup in the bracket
    Then the matchup card shows:
      | Element              | Display                    |
      | Player 1 name        | john_doe                   |
      | Player 1 seed        | #1                         |
      | Player 1 avatar      | Profile image              |
      | Player 2 name        | player16                   |
      | Player 2 seed        | #16                        |
      | Player 2 avatar      | Profile image              |
      | Matchup status       | UPCOMING / LIVE / COMPLETE |
      | Game time/date       | Sat Jan 11, 4:30 PM        |

  @matchup @live
  Scenario: Display live matchup with real-time scores
    Given a matchup is in progress between "john_doe" and "jane_doe"
    And john_doe has a current score of 85.5
    And jane_doe has a current score of 92.3
    When viewing the matchup in the bracket
    Then the matchup shows "LIVE" indicator with pulsing animation
    And john_doe's score of 85.5 is displayed
    And jane_doe's score of 92.3 is displayed
    And the leading player is visually highlighted
    And the score difference is shown (+6.8)
    And a "View Details" link is available

  @matchup @completed
  Scenario: Display completed matchup with final results
    Given the matchup between "john_doe" and "bob_player" is complete
    And john_doe won with 145.5 points
    And bob_player lost with 138.7 points
    When viewing the matchup in the bracket
    Then the winner (john_doe) shows a checkmark or trophy icon
    And the loser (bob_player) is grayed out or crossed out
    And final scores are displayed for both players
    And "FINAL" status is shown
    And the margin of victory (6.8 pts) is visible

  @matchup @upcoming
  Scenario: Display upcoming matchup awaiting start
    Given a Divisional matchup is scheduled
    And the Wild Card round is not yet complete
    When viewing the upcoming matchup
    Then player slots show "TBD" or "Winner of Matchup X"
    And the scheduled date/time is displayed
    And countdown to game start may be shown
    And "UPCOMING" status is displayed

  @matchup @bye
  Scenario: Display bye week for top seeds
    Given top 4 seeds receive first-round byes
    And seed 1 "john_doe" has a Wild Card bye
    When viewing the bracket
    Then john_doe appears in the Divisional round
    And the Wild Card slot shows "BYE" for john_doe
    And john_doe's advancement is shown with a different indicator
    And bye status is clearly communicated

  @matchup @hover
  Scenario: Show matchup details on hover/tap
    Given a completed matchup exists in the bracket
    When the user hovers over the matchup (desktop) or taps (mobile)
    Then a tooltip or modal displays:
      | Detailed score breakdown by position |
      | Key player performances              |
      | Margin of victory                    |
      | Link to full matchup page            |
    And the tooltip dismisses on mouse leave or tap elsewhere

  # ============================================
  # ROUND PROGRESSION VISUALIZATION
  # ============================================

  @progression @wild-card
  Scenario: Display Wild Card round with 8 matchups
    Given it is Wild Card weekend
    And 16 players are competing
    When viewing the bracket
    Then 8 matchups are displayed in the Wild Card column
    And matchups show seeds: 1v16, 2v15, 3v14, 4v13, 5v12, 6v11, 7v10, 8v9
    And all matchups are active or scheduled
    And no advancement lines are filled yet

  @progression @divisional
  Scenario: Display Divisional round after Wild Card completion
    Given Wild Card round is complete
    And 8 winners have advanced
    When viewing the bracket
    Then Wild Card matchups show completed results with winners highlighted
    And Divisional round shows 4 matchups with advancing players
    And advancement lines connect Wild Card winners to their Divisional matchups
    And eliminated players are visually marked

  @progression @conference
  Scenario: Display Conference round with 2 matchups
    Given Divisional round is complete
    And 4 players remain
    When viewing the bracket
    Then Conference round shows 2 matchups
    And matchups are labeled (NFC Championship, AFC Championship equivalent)
    And advancement lines connect from Divisional winners
    And Championship round shows "Winner of NFC" vs "Winner of AFC" placeholders

  @progression @championship
  Scenario: Display Championship matchup
    Given Conference round is complete
    And 2 finalists are determined
    When viewing the bracket
    Then the Championship matchup is prominently displayed
    And both finalists are shown with their tournament path
    And "Super Bowl" or "Championship" label is displayed
    And winner crown/trophy placeholder is visible

  @progression @champion
  Scenario: Display tournament champion after completion
    Given the Championship game is complete
    And "john_doe" has won the tournament
    When viewing the bracket
    Then john_doe is displayed as champion with special styling
    And a trophy or crown icon is shown
    And "2025 Champion" label is displayed
    And confetti animation plays (optional)
    And champion's complete tournament path is highlighted

  # ============================================
  # WINNER AND LOSER INDICATORS
  # ============================================

  @indicators @winner
  Scenario: Display winner indicator after matchup completion
    Given a matchup is complete with "john_doe" as winner
    When viewing the bracket
    Then john_doe's name is bolded or highlighted
    And a green checkmark or trophy icon appears
    And john_doe's slot has a winning color (green/gold)
    And an advancement line connects to the next round

  @indicators @loser
  Scenario: Display loser/eliminated indicator
    Given "bob_player" lost in Wild Card round
    When viewing the bracket
    Then bob_player's name is grayed out or strikethrough
    And a red X or "ELIMINATED" badge appears
    And bob_player's slot has a losing color (gray/red)
    And elimination round is indicated

  @indicators @current-user
  Scenario: Highlight current user's position in bracket
    Given the current user "john_doe" is in the tournament
    And john_doe is in the Conference round
    When viewing the bracket
    Then john_doe's matchup is highlighted with a special border
    And "YOU" label or distinct avatar ring is shown
    And john_doe's path through the bracket is traced/highlighted
    And current matchup is emphasized

  @indicators @active-matchup
  Scenario: Display active matchup indicator
    Given a matchup is currently in progress
    When viewing the bracket
    Then the active matchup has a pulsing border or glow
    And "LIVE" badge is displayed
    And scores update in real-time
    And the matchup draws visual attention

  @indicators @clinched
  Scenario: Display clinched advancement indicator
    Given "john_doe" has an insurmountable lead in a matchup
    And "bob_player" has no remaining active NFL players
    When viewing the bracket
    Then john_doe's slot shows "CLINCHED" indicator
    And the advancement line to next round is partially filled
    And bob_player shows "ELIMINATED" indicator pre-emptively

  # ============================================
  # UPCOMING GAME DISPLAY
  # ============================================

  @upcoming @schedule
  Scenario: Display upcoming matchup schedule
    Given the current round has not started
    And Divisional round is next
    When viewing the bracket
    Then upcoming matchups show scheduled start times
    And times are displayed in user's local timezone
    And a countdown shows time until first game
    And calendar integration option is available

  @upcoming @preview
  Scenario: Show matchup preview for upcoming games
    Given john_doe vs jane_doe is scheduled for Divisional round
    When clicking on the upcoming matchup
    Then a preview panel shows:
      | Player comparison stats    |
      | Head-to-head history       |
      | Key player matchups        |
      | Projected scores           |
      | Betting odds (if enabled)  |

  @upcoming @reminder
  Scenario: Set reminder for upcoming matchup
    Given an upcoming matchup is displayed
    When the user clicks "Set Reminder"
    Then notification options are presented (15 min, 1 hour, 1 day before)
    And the selected reminder is saved
    And a confirmation is shown
    And the matchup shows a reminder icon

  @upcoming @notifications
  Scenario: Display notification for upcoming matchup start
    Given the user has set a reminder
    When the reminder time is reached
    Then a push notification is sent
    And clicking the notification opens the bracket view
    And the matchup is highlighted

  # ============================================
  # BRACKET UPDATES AFTER GAME COMPLETION
  # ============================================

  @updates @real-time
  Scenario: Update bracket in real-time when game completes
    Given the user is viewing the bracket
    And a Wild Card matchup completes
    When the final score is determined
    Then the matchup updates to show final result
    And winner animation plays
    And loser is grayed out
    And advancement line animates to next round
    And next round matchup shows the advancing player

  @updates @animation
  Scenario: Animate bracket advancement
    Given a round has just completed
    And winners are advancing
    When the bracket updates
    Then winner cards animate sliding toward next round
    And advancement lines fill with color progressively
    And next round matchups populate with animation
    And audio cue plays (optional)

  @updates @notification
  Scenario: Notify user of bracket changes
    Given the user is not viewing the bracket
    And a matchup affecting the user completes
    When the game finishes
    Then a notification is sent about bracket update
    And clicking opens the bracket with changes highlighted
    And a "What's New" indicator shows recent changes

  @updates @round-completion
  Scenario: Display round completion summary
    Given all Wild Card matchups are complete
    When viewing the bracket
    Then a round summary is available:
      | Total matchups completed  | 8      |
      | Biggest upset             | #16 over #1 |
      | Closest matchup           | 0.5 points  |
      | Highest score             | 175.5 points |
    And all advancement lines to Divisional are filled

  @updates @history
  Scenario: View bracket progression history
    Given the tournament has progressed through 3 rounds
    When the user clicks "View History"
    Then a timeline shows bracket state at each round completion
    And user can navigate through historical snapshots
    And comparisons between rounds are available

  # ============================================
  # MOBILE RESPONSIVE VIEWS
  # ============================================

  @mobile @layout
  Scenario: Display bracket on mobile devices
    Given the user is on a mobile device (< 768px width)
    When viewing the bracket
    Then the bracket switches to a mobile-optimized layout
    And rounds are displayed in a horizontal scrollable view
    And matchups are stacked vertically within each round
    And touch gestures enable navigation (swipe between rounds)
    And pinch-to-zoom is available for detail

  @mobile @swipe
  Scenario: Navigate bracket via swipe on mobile
    Given the mobile bracket view is displayed
    When the user swipes left
    Then the view scrolls to the next round
    When the user swipes right
    Then the view scrolls to the previous round
    And a round indicator shows current position

  @mobile @matchup-detail
  Scenario: View matchup details on mobile
    Given a matchup is displayed on mobile
    When the user taps on the matchup
    Then a bottom sheet or modal displays full matchup details
    And the sheet can be dismissed by swiping down
    And actions (set reminder, view stats) are accessible

  @mobile @portrait-landscape
  Scenario: Adapt bracket for portrait and landscape modes
    Given the user is on a mobile device
    When the device is in portrait mode
    Then the bracket displays in compact vertical format
    When the device rotates to landscape
    Then the bracket expands to show more rounds horizontally
    And the transition is smooth without data loss

  @mobile @offline
  Scenario: Display cached bracket when offline
    Given the user has previously viewed the bracket
    And the device goes offline
    When the user opens the bracket view
    Then the last cached bracket state is displayed
    And an "Offline" indicator is shown
    And a message indicates data may be stale
    And refresh is attempted when connectivity returns

  # ============================================
  # DESKTOP RESPONSIVE VIEWS
  # ============================================

  @desktop @layout
  Scenario: Display full bracket on desktop
    Given the user is on a desktop device (> 1024px width)
    When viewing the bracket
    Then the complete bracket is visible without scrolling
    And all 4 rounds are displayed left-to-right
    And matchup details are visible without hover/click
    And the layout maximizes screen real estate

  @desktop @widescreen
  Scenario: Optimize bracket for widescreen displays
    Given the user has a widescreen monitor (> 1920px)
    When viewing the bracket
    Then additional space is used for enhanced details
    And player stats may be shown inline
    And larger avatars and fonts are used
    And the bracket remains centered with appropriate margins

  @desktop @split-view
  Scenario: Display bracket alongside live scores
    Given a game is in progress
    When viewing the bracket on desktop
    Then a split view option shows bracket + live scoreboard
    And the bracket updates sync with the live feed
    And the user can toggle to full bracket view

  @desktop @keyboard
  Scenario: Navigate bracket with keyboard on desktop
    Given the user is viewing the bracket
    When the user presses arrow keys
    Then focus moves between matchups
    And Enter/Space opens matchup details
    And Tab moves focus in logical order
    And Escape closes modals/tooltips

  @desktop @print
  Scenario: Print bracket from desktop
    Given the user wants a printable bracket
    When the user clicks "Print Bracket"
    Then a print-optimized layout is generated
    And the bracket fits on standard paper size
    And colors are printer-friendly
    And optional blank bracket for predictions is available

  # ============================================
  # TABLET RESPONSIVE VIEWS
  # ============================================

  @tablet @layout
  Scenario: Display bracket on tablet devices
    Given the user is on a tablet device (768px - 1024px width)
    When viewing the bracket
    Then a hybrid layout is used (partially scrollable)
    And 2-3 rounds are visible at once
    And touch and click interactions work
    And the layout balances detail and overview

  # ============================================
  # ACCESSIBILITY REQUIREMENTS
  # ============================================

  @accessibility @screen-reader
  Scenario: Support screen reader navigation
    Given the user is using a screen reader
    When navigating the bracket
    Then each matchup has descriptive aria-label
    And round headings are announced
    And matchup status is read (live, complete, upcoming)
    And winner/loser status is announced
    And advancement paths are described

  @accessibility @keyboard-only
  Scenario: Enable full keyboard navigation
    Given the user cannot use a mouse
    When navigating with keyboard only
    Then all matchups are focusable with Tab
    And focus indicator is clearly visible
    And Enter opens matchup details
    And Escape closes dialogs
    And skip links are available

  @accessibility @color-contrast
  Scenario: Maintain sufficient color contrast
    Given the bracket uses color-coded indicators
    When viewed by users with color vision deficiency
    Then winner/loser status uses icons in addition to color
    And text contrast meets WCAG AA standards (4.5:1)
    And important information is not conveyed by color alone
    And a high-contrast mode is available

  @accessibility @text-scaling
  Scenario: Support text scaling for low vision users
    Given the user has increased system font size (up to 200%)
    When viewing the bracket
    Then all text scales appropriately
    And layout adjusts to accommodate larger text
    And no text is cut off or overlapping
    And the bracket remains usable

  @accessibility @reduced-motion
  Scenario: Respect reduced motion preferences
    Given the user has "prefers-reduced-motion" enabled
    When viewing the bracket
    Then animations are disabled or minimized
    And live indicators use non-animated alternatives
    And transitions are instant instead of animated
    And the experience remains engaging without motion

  @accessibility @alt-text
  Scenario: Provide alt text for visual elements
    Given avatars and icons are displayed
    When screen reader reads the bracket
    Then player avatars have descriptive alt text
    And status icons have text equivalents
    And decorative images are marked as presentational
    And chart/bracket structure is described

  # ============================================
  # INTERACTIVE FEATURES
  # ============================================

  @interactive @filter
  Scenario: Filter bracket to show specific player's path
    Given the tournament is in progress
    When the user searches for "john_doe"
    Then john_doe's matchups are highlighted throughout the bracket
    And other matchups are dimmed but visible
    And john_doe's path to current round is traced
    And a "Show All" button resets the view

  @interactive @compare
  Scenario: Compare two players' bracket paths
    Given both "john_doe" and "jane_doe" are in the tournament
    When the user selects both for comparison
    Then both paths are highlighted in different colors
    And potential meeting point (if any) is indicated
    And comparison stats are shown in a sidebar

  @interactive @prediction
  Scenario: Make bracket predictions before tournament
    Given the tournament has not started
    When the user enables "Prediction Mode"
    Then each matchup becomes clickable to select winner
    And selected winners advance in the prediction bracket
    And a predicted champion is selected
    And predictions are saved and shareable

  @interactive @share
  Scenario: Share bracket on social media
    Given the user views their bracket position
    When clicking "Share"
    Then options for Twitter, Facebook, copy link are shown
    And a bracket image is generated with user's position
    And the shared link opens the bracket view
    And privacy settings are respected

  @interactive @zoom
  Scenario: Zoom in/out on bracket
    Given the bracket has many participants
    When the user uses zoom controls or gestures
    Then the bracket scales larger or smaller
    And detail level adjusts (more/less info shown)
    And pan/drag allows navigation when zoomed
    And a "Reset Zoom" option is available

  # ============================================
  # EDGE CASES AND ERROR HANDLING
  # ============================================

  @edge-case @empty-bracket
  Scenario: Display message when bracket not initialized
    Given the playoff bracket has not been set up yet
    When the user navigates to bracket view
    Then a message displays "Bracket Not Yet Available"
    And estimated availability date is shown
    And a "Notify Me" option is available
    And seeding information may be shown

  @edge-case @single-round
  Scenario: Display minimal bracket for small leagues
    Given only 4 players are in the playoffs
    When viewing the bracket
    Then only 2 rounds are displayed (Semi-final, Final)
    And the layout adapts to fewer matchups
    And all functionality remains available

  @edge-case @large-bracket
  Scenario: Display bracket for large tournament
    Given 64 players are in the playoffs
    When viewing the bracket
    Then the bracket shows 6 rounds
    And navigation aids help manage complexity
    And search/filter becomes essential
    And performance remains acceptable

  @error @load-failure
  Scenario: Handle bracket data load failure
    Given the bracket API is unavailable
    When the user navigates to bracket view
    Then an error message is displayed
    And a "Retry" button is available
    And cached data is shown if available
    And the user is not blocked from navigation

  @error @update-failure
  Scenario: Handle real-time update failure
    Given the user is viewing a live bracket
    When WebSocket connection is lost
    Then a "Reconnecting..." indicator is shown
    And the bracket continues showing last known state
    And automatic reconnection is attempted
    And manual refresh option is available

  # ============================================
  # PERFORMANCE
  # ============================================

  @performance @loading
  Scenario: Load bracket efficiently
    Given the bracket data is fetched
    When the bracket view loads
    Then initial render completes within 2 seconds
    And visible matchups load first (above the fold)
    And off-screen matchups lazy load
    And loading skeleton is shown during fetch

  @performance @updates
  Scenario: Handle frequent real-time updates efficiently
    Given multiple games are in progress
    And scores update every 30 seconds
    When updates are received
    Then only changed matchups re-render
    And the UI remains responsive
    And memory usage stays stable
    And battery impact is minimized on mobile
