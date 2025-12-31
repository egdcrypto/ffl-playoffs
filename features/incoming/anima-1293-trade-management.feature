@ANIMA-1293 @backend @frontend @priority_1 @trades
Feature: Trade Management
  As a fantasy football playoffs participant
  I want to trade players with other teams
  So that I can improve my roster and compete for the championship

  Background:
    Given a league "2025 NFL Playoffs Pool" exists
    And the league has 12 teams
    And trading is enabled for the league
    And the current user is authenticated

  # ============================================
  # TRADE PROPOSALS
  # ============================================

  @proposal @happy-path
  Scenario: Create a simple one-for-one trade proposal
    Given "john_doe" owns "Patrick Mahomes"
    And "jane_doe" owns "Josh Allen"
    When "john_doe" proposes a trade:
      | Offering       | Requesting    |
      | Patrick Mahomes| Josh Allen    |
    Then the trade proposal is created with status "PENDING"
    And "jane_doe" receives a trade notification
    And the proposal expires in 48 hours
    And both players are marked "In Trade" on rosters

  @proposal @multi-player
  Scenario: Create multi-player trade proposal
    Given "john_doe" owns "Travis Kelce" and "Derrick Henry"
    And "bob_player" owns "Tyreek Hill" and "Cooper Kupp"
    When "john_doe" proposes:
      | Offering       | Requesting    |
      | Travis Kelce   | Tyreek Hill   |
      | Derrick Henry  | Cooper Kupp   |
    Then the trade proposal includes 4 players
    And both parties see all players involved
    And trade value analysis is shown for each side

  @proposal @draft-picks
  Scenario: Create trade proposal including draft picks
    Given "john_doe" has a 1st round pick for next season
    And "alice_player" owns "CeeDee Lamb"
    When "john_doe" proposes:
      | Offering               | Requesting   |
      | 2026 1st Round Pick    | CeeDee Lamb  |
    Then the trade includes the draft pick
    And pick details show original owner and conditional status
    And pick is marked as tradeable asset

  @proposal @add-message
  Scenario: Include message with trade proposal
    Given "john_doe" creates a trade proposal
    When adding a message: "I think this is fair value. Let me know!"
    Then the message is attached to the proposal
    And "jane_doe" sees the message when reviewing

  @proposal @cancel
  Scenario: Cancel pending trade proposal
    Given "john_doe" has a pending proposal to "jane_doe"
    When "john_doe" cancels the proposal
    Then the proposal status becomes "CANCELLED"
    And "jane_doe" is notified of cancellation
    And players are no longer marked "In Trade"

  @proposal @counter
  Scenario: Counter a trade proposal
    Given "jane_doe" received a trade proposal from "john_doe"
    When "jane_doe" counters with different players:
      | Offering       | Requesting        |
      | Josh Allen     | Patrick Mahomes   |
      | James Cook     | -                 |
    Then a counter-proposal is created
    And the original proposal is linked
    And "john_doe" is notified of the counter

  @proposal @multiple-pending
  Scenario: Handle multiple pending proposals for same player
    Given "john_doe" owns "Patrick Mahomes"
    And "john_doe" has proposals to "jane_doe" and "bob_player" for Mahomes
    When "jane_doe" accepts her proposal first
    Then "bob_player's" proposal is automatically cancelled
    And "bob_player" is notified the player is no longer available

  # ============================================
  # TRADE REVIEWS
  # ============================================

  @review @display
  Scenario: Display trade proposal for review
    Given "jane_doe" has a pending trade proposal
    When viewing the proposal
    Then the following is displayed:
      | Section           | Content                      |
      | Incoming Players  | Patrick Mahomes (QB - KC)    |
      | Outgoing Players  | Josh Allen (QB - BUF)        |
      | Trade Value       | You Receive: 95 / Give: 92   |
      | Roster Impact     | Before/After visualization   |
      | Expiration        | 47 hours remaining           |
    And Accept/Reject/Counter buttons are available

  @review @compare-players
  Scenario: Compare traded players side-by-side
    Given a trade proposal is being reviewed
    When viewing player comparison
    Then stats are compared:
      | Stat          | Incoming (Mahomes) | Outgoing (Allen) |
      | Fantasy Pts   | 389.5              | 412.5            |
      | Avg/Game      | 22.9               | 24.3             |
      | Playoff Proj  | 98.5               | 102.3            |
    And position rank is shown for each

  @review @history
  Scenario: View trade history with proposal partner
    Given "john_doe" and "jane_doe" have traded before
    When viewing the trade proposal
    Then previous trades between them are shown:
      | Date       | john_doe Sent   | jane_doe Sent   |
      | Dec 2024   | Lamar Jackson   | Jalen Hurts     |
    And helps assess trading partner reliability

  # ============================================
  # TRADE APPROVALS AND REJECTIONS
  # ============================================

  @approval @accept
  Scenario: Accept a trade proposal
    Given "jane_doe" reviews a fair trade proposal
    When "jane_doe" clicks "Accept Trade"
    Then the trade status becomes "ACCEPTED"
    And the trade enters the review period (if configured)
    And both parties are notified
    And players transfer after review period

  @approval @instant
  Scenario: Process instant trade (no review period)
    Given the league has no trade review period
    When "jane_doe" accepts the trade
    Then players transfer immediately
    And rosters update in real-time
    And transaction log is updated
    And league feed shows the trade

  @approval @review-period
  Scenario: Process trade with league review period
    Given the league has a 24-hour review period
    When "jane_doe" accepts the trade
    Then trade status becomes "PENDING_REVIEW"
    And all league members can view the trade
    And the trade processes after 24 hours
    And commissioner can expedite or veto

  @rejection @decline
  Scenario: Reject a trade proposal
    Given "jane_doe" reviews an unfavorable trade
    When "jane_doe" clicks "Reject Trade"
    Then the trade status becomes "REJECTED"
    And "john_doe" is notified of rejection
    And players are unmarked from "In Trade"
    And rejection reason can optionally be provided

  @rejection @auto-expire
  Scenario: Trade proposal auto-expires
    Given a trade proposal was created 48 hours ago
    When the expiration time passes
    Then the trade status becomes "EXPIRED"
    And both parties are notified
    And no action is required

  # ============================================
  # TRADE DEADLINES
  # ============================================

  @deadline @display
  Scenario: Display trade deadline countdown
    Given the trade deadline is January 20, 2025, 4:00 PM EST
    When viewing the trade center
    Then countdown shows: "Trade deadline: 5 days, 3 hours"
    And deadline is prominent on the page
    And timezone is shown in user's local time

  @deadline @enforce
  Scenario: Enforce trade deadline
    Given the trade deadline has passed
    When "john_doe" attempts to create a trade proposal
    Then the request is denied
    And message: "Trading is closed. Deadline passed on Jan 20."
    And existing pending trades are auto-cancelled

  @deadline @warning
  Scenario: Send trade deadline warning notification
    Given the trade deadline is in 24 hours
    When the warning period is reached
    Then all league members receive notification:
      | Subject | Trade Deadline Approaching!       |
      | Body    | Only 24 hours left to make trades |
    And pending trades are highlighted for action

  @deadline @extension
  Scenario: Commissioner extends trade deadline
    Given the commissioner needs to extend the deadline
    When the commissioner sets new deadline to January 22
    Then the deadline is updated
    And all members are notified of extension
    And the change is logged

  # ============================================
  # TRADE HISTORY
  # ============================================

  @history @view
  Scenario: View league trade history
    Given multiple trades have occurred this season
    When viewing "Trade History"
    Then all completed trades are listed:
      | Date       | Teams                    | Players Exchanged        |
      | Jan 15     | john_doe ↔ jane_doe     | Mahomes ↔ Allen          |
      | Jan 10     | bob_player ↔ alice      | Kelce ↔ Andrews + Pick   |
    And trades are sortable by date, team, or player

  @history @filter
  Scenario: Filter trade history by team
    Given many trades exist in history
    When filtering to "john_doe's trades"
    Then only trades involving john_doe are shown
    And both sent and received trades appear

  @history @details
  Scenario: View trade details from history
    Given a trade exists in history
    When clicking on the trade
    Then details show:
      | Trade Date         | January 15, 2025          |
      | Team A Sent        | Patrick Mahomes           |
      | Team B Sent        | Josh Allen                |
      | Trade Value at Time| A: 95 points, B: 92 points|
      | Current Value      | A: 98 points, B: 90 points|
    And retrospective analysis is available

  @history @export
  Scenario: Export trade history
    Given trade history exists
    When clicking "Export Trade History"
    Then CSV/PDF options are available
    And download includes all trade details

  # ============================================
  # FAIR VALUE ANALYSIS
  # ============================================

  @value @display
  Scenario: Display trade value analysis
    Given a trade proposal is created
    When viewing value analysis
    Then trade values are shown:
      | Side       | Players              | Total Value |
      | Offering   | Travis Kelce         | 85.5        |
      | Requesting | Mark Andrews + Pick  | 88.2        |
      | Difference | -2.7 (Slight loss)   |             |
    And value source is indicated (ESPN, Yahoo, etc.)

  @value @fair-range
  Scenario: Indicate fair trade range
    Given trade values are calculated
    When the difference is within 10%
    Then the trade is marked "FAIR"
    And green indicator shows balanced trade
    When the difference exceeds 20%
    Then "LOPSIDED" warning appears
    And commissioner review may be triggered

  @value @projections
  Scenario: Include rest-of-season projections in value
    Given players have different remaining schedules
    When calculating trade value
    Then ROS projections are factored:
      | Player   | Current Value | ROS Projection | Combined |
      | Mahomes  | 85            | 98             | 92       |
      | Allen    | 88            | 95             | 91       |
    And schedule difficulty is shown

  @value @positional-scarcity
  Scenario: Factor positional scarcity into value
    Given TE is a scarce position
    When trading a top-5 TE
    Then scarcity adjustment is applied:
      | Base Value | Scarcity Bonus | Adjusted Value |
      | 80         | +15            | 95             |
    And scarcity explanation is provided

  # ============================================
  # ROSTER IMPACT PREVIEW
  # ============================================

  @impact @before-after
  Scenario: Show roster before and after trade
    Given "john_doe" is trading away Patrick Mahomes
    When viewing roster impact
    Then before/after comparison shows:
      | Position | Before          | After           |
      | QB       | Patrick Mahomes | Josh Allen      |
      | RB1      | Derrick Henry   | Derrick Henry   |
      | WR1      | CeeDee Lamb     | CeeDee Lamb     |
    And projected team total is shown for both

  @impact @depth-chart
  Scenario: Show depth chart impact
    Given the trade affects backup positions
    When viewing depth chart impact
    Then depth changes are highlighted:
      | Position | Starter Impact | Backup Impact |
      | QB       | Changed        | None          |
      | RB       | None           | New backup    |

  @impact @bye-weeks
  Scenario: Analyze bye week impact
    Given traded players have different byes
    When viewing bye week analysis
    Then bye week conflicts are shown:
      | Week | Before Trade   | After Trade    |
      | 6    | 2 players out  | 1 player out   |
      | 10   | 1 player out   | 3 players out  |
    And improvement/degradation is indicated

  @impact @strength
  Scenario: Calculate team strength change
    Given the trade affects projected points
    When viewing strength analysis
    Then projected impact is shown:
      | Metric             | Before | After  | Change |
      | Weekly Projection  | 145.5  | 142.3  | -3.2   |
      | Playoff Projection | 580.0  | 568.0  | -12.0  |
    And recommendation is provided

  # ============================================
  # COMMISSIONER VETO POWERS
  # ============================================

  @veto @review
  Scenario: Commissioner reviews trade for veto
    Given a trade was accepted and is in review period
    When the commissioner opens trade review
    Then trade details and value analysis are shown
    And options are: "Approve", "Veto", "Request Explanation"

  @veto @execute
  Scenario: Commissioner vetoes a trade
    Given the commissioner identifies collusion
    When vetoing the trade with reason: "Suspected collusion"
    Then the trade status becomes "VETOED"
    And both parties are notified with reason
    And players remain on original rosters
    And the veto is logged

  @veto @appeal
  Scenario: Trade participants appeal a veto
    Given a trade was vetoed
    When the affected parties submit an appeal
    Then the appeal is logged
    And commissioner must respond within 24 hours
    And appeal details are visible to commissioner

  @veto @league-vote
  Scenario: Enable league vote for veto decisions
    Given league settings require vote for vetoes
    When a trade is submitted for league vote
    Then all non-involved members can vote
    And majority (>50%) required to veto
    And voting period is 24 hours
    And results are binding

  @veto @override
  Scenario: Commissioner pushes through a trade
    Given a trade is stuck in review
    When the commissioner approves immediately
    Then the trade processes without waiting
    And all parties are notified
    And the override is logged

  # ============================================
  # TRADE NOTIFICATIONS
  # ============================================

  @notifications @proposal
  Scenario: Receive notification for new trade proposal
    Given "jane_doe" has notifications enabled
    When "john_doe" sends a trade proposal
    Then "jane_doe" receives:
      | Channel    | Notification                         |
      | Email      | "john_doe wants to trade with you"   |
      | Push       | "New trade proposal from john_doe"   |
      | In-App     | Trade badge appears on menu          |
    And notification links to trade review

  @notifications @accepted
  Scenario: Receive notification when trade is accepted
    Given "john_doe" proposed a trade
    When "jane_doe" accepts the trade
    Then "john_doe" receives:
      | Channel | Notification                     |
      | Email   | "Your trade was accepted!"       |
      | Push    | "Trade with jane_doe accepted"   |
    And roster changes are summarized

  @notifications @rejected
  Scenario: Receive notification when trade is rejected
    Given "john_doe" proposed a trade
    When "jane_doe" rejects the trade
    Then "john_doe" receives notification of rejection
    And rejection reason is included (if provided)

  @notifications @league-wide
  Scenario: League receives notification of completed trade
    Given trade notifications are enabled league-wide
    When a trade completes
    Then all league members receive:
      | Notification | "Trade Alert: john_doe traded Mahomes to jane_doe for Allen" |
    And trade details link is included

  @notifications @preferences
  Scenario: Configure trade notification preferences
    Given the user manages notification settings
    When configuring trade notifications:
      | Event              | Email | Push | In-App |
      | Incoming Proposal  | Yes   | Yes  | Yes    |
      | Trade Accepted     | Yes   | Yes  | Yes    |
      | Trade Rejected     | No    | Yes  | Yes    |
      | League Trades      | No    | No   | Yes    |
    Then preferences are saved and applied

  # ============================================
  # MULTI-PLAYER TRADES
  # ============================================

  @multi @create
  Scenario: Create complex multi-player trade
    Given multiple players can be traded
    When "john_doe" proposes:
      | john_doe Offers        | jane_doe Offers           |
      | Patrick Mahomes        | Josh Allen                |
      | Travis Kelce           | George Kittle             |
      | 2026 2nd Round Pick    | James Cook                |
    Then all 6 assets are included in the proposal
    And value analysis covers all items

  @multi @balance
  Scenario: Validate trade balance for multi-player
    Given a multi-player trade is proposed
    When validating roster compliance
    Then both teams must have valid rosters after trade
    And minimum/maximum position requirements are checked
    And warnings shown if roster becomes invalid

  @multi @partial-reject
  Scenario: Cannot partially reject multi-player trade
    Given a 3-for-2 trade is proposed
    When "jane_doe" reviews the trade
    Then only full Accept or full Reject is available
    And counter-offer option allows modifications
    And individual players cannot be removed

  # ============================================
  # DRAFT PICK TRADES
  # ============================================

  @picks @include
  Scenario: Include future draft picks in trade
    Given teams have tradeable draft picks
    When creating a trade with picks
    Then available picks are shown:
      | Pick                   | Original Owner |
      | 2026 1st Round         | john_doe       |
      | 2026 2nd Round         | john_doe       |
      | 2027 1st Round         | john_doe       |
    And picks can be added to trade

  @picks @conditional
  Scenario: Create conditional draft pick trade
    Given advanced pick trading is enabled
    When trading a conditional pick:
      | Condition                          | Pick Becomes |
      | If john_doe finishes top 6         | 2nd Round    |
      | If john_doe finishes bottom 6      | 1st Round    |
    Then conditions are recorded
    And pick updates when condition resolves

  @picks @validate
  Scenario: Validate future pick availability
    Given "john_doe" already traded their 2026 1st
    When attempting to trade 2026 1st again
    Then the trade is blocked
    And message: "2026 1st Round Pick already traded to jane_doe"

  @picks @tracker
  Scenario: Display draft pick ownership tracker
    Given picks have been traded in the league
    When viewing pick tracker
    Then current ownership is shown:
      | Pick           | Original | Current Owner |
      | 2026 1st (1)   | john_doe | jane_doe      |
      | 2026 1st (2)   | jane_doe | jane_doe      |
      | 2026 2nd (1)   | john_doe | bob_player    |

  # ============================================
  # TRADE VALIDATION RULES
  # ============================================

  @validation @roster-limits
  Scenario: Validate roster limits after trade
    Given "john_doe" has 3 QBs (max allowed)
    When proposing to receive another QB
    Then warning: "Trade would exceed QB limit (3)"
    And john_doe must include a QB in the trade or drop one

  @validation @minimum-roster
  Scenario: Validate minimum roster requirements
    Given "jane_doe" has only 1 QB
    When proposing to trade away that QB
    Then trade is blocked
    And message: "Cannot trade - would leave no QBs on roster"

  @validation @player-eligibility
  Scenario: Validate player trade eligibility
    Given a player was just acquired via waivers
    And 24-hour trade restriction applies
    When attempting to trade that player
    Then trade is blocked
    And message: "Player tradeable in 18 hours"

  @validation @injured-reserve
  Scenario: Handle IR-designated players in trades
    Given "Patrick Mahomes" is on IR
    When included in a trade proposal
    Then IR status is clearly indicated
    And receiving team must have IR slot
    And trade is blocked if no IR slot available

  @validation @same-team
  Scenario: Prevent trading with yourself
    Given "john_doe" is logged in
    When attempting to create trade with self
    Then trade creation is blocked
    And message: "Cannot trade with yourself"

  # ============================================
  # TRADE WINDOWS
  # ============================================

  @window @open
  Scenario: Display open trade window
    Given the trade window is currently open
    When viewing the trade center
    Then status shows: "Trading is OPEN"
    And all trade functions are available
    And no restrictions are displayed

  @window @closed
  Scenario: Display closed trade window
    Given trading is closed between rounds
    When viewing the trade center
    Then status shows: "Trading is CLOSED"
    And create trade button is disabled
    And message: "Trading opens again on [date]"

  @window @scheduled
  Scenario: Display scheduled trade windows
    Given the league has scheduled trade windows
    When viewing trade schedule
    Then windows are displayed:
      | Period       | Open         | Close        |
      | Pre-Season   | Dec 1        | Dec 15       |
      | In-Season    | Jan 1        | Jan 20       |
      | Post-Draft   | After draft  | Kickoff      |
    And current window is highlighted

  @window @emergency
  Scenario: Commissioner opens emergency trade window
    Given trading is normally closed
    When the commissioner opens emergency window
    Then trading is enabled for specified duration
    And all members are notified
    And reason is logged

  # ============================================
  # TRADE ANALYTICS
  # ============================================

  @analytics @dashboard
  Scenario: View trade analytics dashboard
    Given the user accesses trade analytics
    When the dashboard loads
    Then metrics are displayed:
      | Metric                    | Value  |
      | Trades Made This Season   | 5      |
      | Trade Win Rate            | 60%    |
      | Value Acquired            | +45.5  |
      | Best Trade                | Kelce for Andrews |

  @analytics @league-activity
  Scenario: View league-wide trade activity
    Given trading has occurred in the league
    When viewing league trade analytics
    Then summary shows:
      | Most Active Trader | john_doe (8 trades) |
      | Most Traded Player | Josh Allen (3 times)|
      | Average Trade Size | 2.3 players         |
      | Total Trades       | 24                  |

  @analytics @value-tracking
  Scenario: Track trade value over time
    Given a trade occurred 4 weeks ago
    When viewing trade value tracking
    Then value comparison shows:
      | At Trade Time | Current Value | Change  |
      | Team A: 95    | Team A: 110   | +15     |
      | Team B: 92    | Team B: 85    | -7      |
    And "winner" of trade is indicated

  @analytics @trends
  Scenario: View trading trends
    Given sufficient trade data exists
    When viewing trends
    Then charts show:
      | Trade volume by week           |
      | Average trade value by month   |
      | Most traded positions          |
      | Trade deadline surge           |

  # ============================================
  # MOBILE AND RESPONSIVE
  # ============================================

  @mobile @create
  Scenario: Create trade on mobile device
    Given the user is on mobile
    When creating a trade proposal
    Then mobile-optimized interface is shown
    And player selection uses touch-friendly lists
    And swipe gestures work for player selection
    And trade preview is scrollable

  @mobile @review
  Scenario: Review trade on mobile
    Given the user receives trade on mobile
    When reviewing the proposal
    Then all details are visible on mobile
    And Accept/Reject buttons are prominent
    And comparison table scrolls horizontally

  # ============================================
  # ERROR HANDLING
  # ============================================

  @error @network
  Scenario: Handle network error during trade submission
    Given the user submits a trade proposal
    When the network fails
    Then error message is displayed
    And trade is saved as draft locally
    And retry option is available
    And no duplicate proposals are created

  @error @concurrent
  Scenario: Handle concurrent trade conflict
    Given two trades for same player are submitted simultaneously
    When both attempt to process
    Then first submission succeeds
    And second shows: "Player no longer available"
    And no invalid roster states occur

  @error @validation
  Scenario: Display validation errors clearly
    Given a trade has multiple validation issues
    When attempting to submit
    Then all errors are displayed:
      | Error                           |
      | Exceeds QB roster limit         |
      | Player on trade restriction     |
    And user can fix issues before resubmitting
