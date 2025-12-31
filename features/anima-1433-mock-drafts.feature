@backend @priority_2 @mock-drafts @drafting
Feature: Mock Drafts
  As a fantasy football player
  I want to practice drafting with mock drafts
  So that I can refine my strategy, test different approaches, and prepare for real drafts

  Background:
    Given the mock draft system is available
    And player rankings are loaded from the current season projections
    And ADP (Average Draft Position) data is available

  # ==================== MOCK DRAFT LOBBY ====================

  Scenario: View list of available public mock draft lobbies
    Given player "john_doe" navigates to the mock draft lobby
    When the lobby page loads
    Then john_doe sees a list of available mock drafts:
      | Draft Name          | Type    | Teams | Spots Open | Start Time        |
      | Quick Snake Draft   | Snake   | 10    | 3          | When full         |
      | Premium PPR Mock    | Snake   | 12    | 7          | 5 min countdown   |
      | Auction Practice    | Auction | 12    | 5          | When full         |
      | Half PPR League     | Snake   | 10    | 1          | Starting soon     |
    And each draft shows the scoring format (Standard, PPR, Half-PPR)
    And each draft shows the roster configuration

  Scenario: Filter mock draft lobbies by preferences
    Given player "jane_doe" is in the mock draft lobby
    When jane_doe applies filters:
      | Filter       | Value    |
      | Draft Type   | Snake    |
      | Team Size    | 12       |
      | Scoring      | PPR      |
      | Start Time   | 5 min    |
    Then only matching mock drafts are displayed
    And the filter preferences are saved for future sessions

  Scenario: Join a public mock draft lobby
    Given player "john_doe" finds a mock draft with 1 spot remaining
    When john_doe clicks "Join Draft"
    Then john_doe is added to the draft room
    And john_doe is assigned an available draft position
    And john_doe sees the draft countdown timer
    And other participants are notified of the new joiner

  Scenario: Create a private mock draft lobby
    Given player "jane_doe" wants to practice with friends
    When jane_doe creates a private mock draft:
      | Setting        | Value       |
      | Draft Name     | Friends Mock|
      | Type           | Snake       |
      | Teams          | 10          |
      | Visibility     | Private     |
      | Password       | secret123   |
    Then a private lobby is created
    And jane_doe receives a shareable invite link
    And the draft appears in jane_doe's "My Drafts" list
    And the draft requires password to join

  Scenario: Host configures mock draft start time
    Given player "bob_player" is hosting a private mock draft
    When bob_player sets the draft to start:
      | Start Option   | Value              |
      | When Full      | Start immediately when all spots filled |
      | Countdown      | Start after 10 minute countdown         |
      | Scheduled      | Start at specific date/time             |
    Then the selected start option is applied
    And participants see the configured start behavior

  Scenario: Leave a mock draft lobby before it starts
    Given player "john_doe" has joined a mock draft lobby
    And the draft has not started yet
    When john_doe clicks "Leave Draft"
    Then john_doe is removed from the lobby
    And john_doe's spot becomes available for others
    And other participants are notified of the departure

  Scenario: Handle lobby timeout for inactive drafts
    Given a private mock draft has been waiting for 30 minutes
    And the minimum player count has not been reached
    When the lobby timeout is reached
    Then the host is notified the lobby will expire
    And participants are given 5 minutes to add more players
    And if still not full, the lobby is automatically cancelled

  Scenario: Quick-join instant mock draft
    Given player "alice_player" wants to draft immediately
    When alice_player clicks "Quick Join"
    Then the system finds the next available mock draft
    And alice_player is automatically placed in a lobby
    And the draft starts within 2 minutes of joining
    And alice_player can set quick-join preferences

  # ==================== DRAFT CONFIGURATION ====================

  Scenario: Configure snake draft settings
    Given host "john_doe" is setting up a mock draft
    When john_doe configures snake draft settings:
      | Setting               | Value                    |
      | Number of Teams       | 12                       |
      | Number of Rounds      | 15                       |
      | Pick Timer            | 60 seconds               |
      | Draft Order           | Randomized               |
      | Third Round Reversal  | Disabled                 |
    Then the draft is configured for 180 total picks
    And draft order will be randomized when draft starts

  Scenario: Configure auction draft settings
    Given host "jane_doe" is setting up an auction mock draft
    When jane_doe configures auction settings:
      | Setting               | Value                    |
      | Number of Teams       | 12                       |
      | Salary Cap            | $200                     |
      | Minimum Bid           | $1                       |
      | Bid Increment         | $1                       |
      | Nomination Timer      | 30 seconds               |
      | Bidding Timer         | 10 seconds               |
      | Nomination Order      | Snake                    |
    Then the auction draft is configured
    And each team starts with $200 budget

  Scenario: Configure roster positions
    Given host "bob_player" is configuring draft roster slots
    When bob_player sets roster positions:
      | Position | Count |
      | QB       | 1     |
      | RB       | 2     |
      | WR       | 2     |
      | TE       | 1     |
      | FLEX     | 1     |
      | K        | 1     |
      | DEF      | 1     |
      | BENCH    | 6     |
    Then the draft requires 15 total picks per team
    And position eligibility is enforced during draft

  Scenario: Configure scoring format
    Given host "alice_player" is setting up scoring rules
    When alice_player selects "PPR" scoring format
    Then standard PPR scoring rules are applied:
      | Stat                 | Points |
      | Passing Yard         | 0.04   |
      | Passing TD           | 4      |
      | Interception         | -2     |
      | Rushing Yard         | 0.1    |
      | Rushing TD           | 6      |
      | Reception            | 1.0    |
      | Receiving Yard       | 0.1    |
      | Receiving TD         | 6      |
    And player projections reflect PPR scoring

  Scenario: Configure custom scoring format
    Given host "john_doe" wants custom scoring rules
    When john_doe creates custom scoring:
      | Stat                 | Points |
      | Reception            | 0.5    |
      | 40+ Yard TD Bonus    | 2      |
      | 100+ Rush Yards      | 3      |
      | 100+ Rec Yards       | 3      |
    Then custom scoring is applied to projections
    And player rankings are recalculated
    And the custom format is saved for future use

  Scenario: Configure draft pick trading rules
    Given host "jane_doe" is setting draft trade rules
    When jane_doe configures:
      | Setting                 | Value   |
      | Allow Pick Trading      | Yes     |
      | Trading Window          | Entire Draft |
      | Future Pick Trading     | No      |
    Then participants can trade picks during the draft
    And trade proposals require mutual acceptance

  Scenario: Configure keeper settings for mock draft
    Given host "bob_player" wants to simulate keeper league
    When bob_player enables keeper mode:
      | Setting              | Value                    |
      | Keepers Per Team     | 3                        |
      | Keeper Round Cost    | Previous round - 1       |
      | Cannot Keep          | First round picks        |
    Then each team can designate 3 keepers
    And keepers are locked before draft starts

  Scenario: Apply dynasty draft configuration
    Given host "alice_player" is setting up dynasty mock
    When alice_player enables dynasty settings:
      | Setting               | Value                    |
      | Rookie Draft Only     | Yes                      |
      | Rounds                | 5                        |
      | Include IDP           | Yes                      |
    Then only rookie-eligible players are draftable
    And IDP positions are added to roster

  # ==================== SNAKE DRAFT ====================

  Scenario: Start snake draft with randomized order
    Given a mock draft lobby is full with 10 teams
    And draft order is set to "Randomized"
    When the draft starts
    Then draft positions 1-10 are randomly assigned
    And each participant is notified of their draft position
    And the draft board displays the order
    And the first pick timer starts

  Scenario: Make a snake draft pick
    Given player "john_doe" has the 1st overall pick
    And the pick timer shows 60 seconds remaining
    When john_doe selects "Christian McCaffrey" from the player list
    And john_doe confirms the selection
    Then Christian McCaffrey is added to john_doe's roster
    And Christian McCaffrey is removed from the available player pool
    And the pick is announced to all participants
    And the turn advances to pick #2

  Scenario: Snake draft order reverses each round
    Given a 10-team snake draft is in round 1
    And the draft order is: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    When round 1 completes
    Then round 2 order reverses to: 10, 9, 8, 7, 6, 5, 4, 3, 2, 1
    And round 3 reverts to: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    And this pattern continues throughout the draft

  Scenario: Third round reversal snake draft
    Given a 10-team draft with third round reversal enabled
    And the draft order is: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    When the draft reaches round 3
    Then round 3 order remains reversed: 10, 9, 8, 7, 6, 5, 4, 3, 2, 1
    And round 4 starts with: 10, 9, 8, 7, 6, 5, 4, 3, 2, 1
    And the pattern resumes normal snake from round 5

  Scenario: Draft pick timer expires without selection
    Given player "jane_doe" has the current pick
    And the pick timer reaches 0 seconds
    When the timer expires
    Then autopick is triggered for jane_doe
    And the best available player per jane_doe's rankings is selected
    And a "Timer Expired - Autopicked" notice is displayed
    And the draft advances to the next pick

  Scenario: View snake draft board during draft
    Given the mock draft is in progress at pick #45
    When player "bob_player" views the draft board
    Then bob_player sees all completed picks in a grid:
      | Round | Pick 1      | Pick 2      | Pick 3      | ... |
      | 1     | McCaffrey   | Kupp        | Jefferson   | ... |
      | 2     | Kelce       | Hill        | Henry       | ... |
      | 3     | Lamb        | Chase       | Adams       | ... |
    And the current pick is highlighted
    And bob_player's picks are color-coded
    And upcoming picks show timer and drafter

  Scenario: Search and filter available players during draft
    Given player "alice_player" is on the clock
    When alice_player searches for "running back"
    And filters by:
      | Filter     | Value    |
      | Position   | RB       |
      | Team       | Any      |
      | Status     | Available|
    Then only available running backs are displayed
    And results are sorted by projected points
    And ADP and ranking are shown for each player

  Scenario: Queue picks for upcoming rounds
    Given player "john_doe" is not currently on the clock
    When john_doe adds players to their pick queue:
      | Priority | Player          |
      | 1        | Travis Kelce    |
      | 2        | Davante Adams   |
      | 3        | CeeDee Lamb     |
    Then the queue is saved for john_doe
    And if john_doe's pick comes and Kelce is available, he's auto-selected
    And if Kelce is taken, the next available queued player is selected

  Scenario: Trade picks during snake draft
    Given pick trading is enabled
    And player "jane_doe" has picks #15 and #26
    And player "bob_player" has pick #22
    When jane_doe proposes trading pick #26 for pick #22
    And bob_player accepts the trade
    Then pick #22 now belongs to jane_doe
    And pick #26 now belongs to bob_player
    And the draft board updates to reflect the trade
    And a trade notification is broadcast

  Scenario: Complete snake draft
    Given all 150 picks in a 10-team, 15-round draft have been made
    When the final pick is completed
    Then the draft is marked as "Complete"
    And all participants receive their final rosters
    And draft results are saved for analysis
    And the lobby is closed

  # ==================== AUCTION DRAFT ====================

  Scenario: Start auction draft with nomination order
    Given a 12-team auction mock draft is ready
    And nomination order is set to "Snake"
    When the draft starts
    Then team 1 is prompted to nominate a player
    And the nomination timer starts at 30 seconds
    And all teams see their $200 salary cap

  Scenario: Nominate a player for auction
    Given player "john_doe" has the nomination turn
    When john_doe nominates "Justin Jefferson" at $50
    Then an auction begins for Justin Jefferson
    And the starting bid is $50
    And all teams can now place bids
    And the bidding timer starts at 10 seconds

  Scenario: Place a bid in auction draft
    Given an auction is in progress for "Justin Jefferson"
    And the current high bid is $55 by "jane_doe"
    When "bob_player" bids $58
    Then bob_player becomes the high bidder
    And the bidding timer resets to 10 seconds
    And all participants see the new high bid

  Scenario: Win an auction
    Given the bidding timer reaches 0
    And "alice_player" has the high bid of $62 for "Justin Jefferson"
    When the auction closes
    Then Justin Jefferson is added to alice_player's roster
    And $62 is deducted from alice_player's budget
    And alice_player now has $138 remaining
    And the next nomination turn begins

  Scenario: Enforce salary cap constraints
    Given player "john_doe" has $45 remaining budget
    And john_doe must fill 3 more roster spots
    When john_doe attempts to bid $44 on a player
    Then the bid is rejected
    And the error message is "You must reserve $1 minimum per remaining roster spot"
    And maximum allowed bid is $43

  Scenario: Handle auction with no bids
    Given "jane_doe" nominates "Backup Kicker" at $1
    And no other team places a bid
    When the bidding timer expires
    Then "Backup Kicker" is awarded to jane_doe for $1
    And $1 is deducted from jane_doe's budget
    And the next nomination begins

  Scenario: Display auction draft status
    Given the auction draft is in progress
    When any participant views the draft room
    Then they see:
      | Team         | Budget | Roster Spots | Max Bid |
      | john_doe     | $145   | 8            | $138    |
      | jane_doe     | $112   | 6            | $107    |
      | bob_player   | $178   | 10           | $169    |
    And the current auction item and high bid
    And nomination order queue

  Scenario: Bid war extends auction timer
    Given the bidding timer is at 3 seconds
    When "john_doe" places a bid
    Then the timer resets to 10 seconds
    And this prevents last-second sniping
    And allows time for counter-bids

  Scenario: Skip nomination turn
    Given player "jane_doe" has the nomination
    And jane_doe doesn't want to nominate
    When the nomination timer expires
    Then the system auto-nominates the highest-ranked available player
    And the starting bid is $1
    And the auction proceeds normally

  Scenario: Display auction value analysis
    Given player "bob_player" is considering a bid
    When bob_player views "Ja'Marr Chase" player card
    Then the card shows:
      | Metric           | Value         |
      | Projected Points | 285.5         |
      | ADP Price        | $48           |
      | Current Bid      | $52           |
      | Value Rating     | Slight Overpay|
    And bob_player can make informed bidding decisions

  Scenario: Complete auction draft
    Given all roster spots are filled for all teams
    When the final auction completes
    Then the draft is marked as "Complete"
    And final budgets are displayed (all should be $0)
    And rosters are finalized
    And draft results are saved for analysis

  # ==================== AUTOPICK SYSTEM ====================

  Scenario: Enable autopick for entire draft
    Given player "john_doe" needs to leave during the draft
    When john_doe enables autopick mode
    Then john_doe's picks are made automatically
    And picks follow john_doe's custom rankings if set
    And picks follow default ADP if no custom rankings
    And john_doe can disable autopick by returning

  Scenario: Configure autopick preferences
    Given player "jane_doe" wants to customize autopick
    When jane_doe sets autopick preferences:
      | Setting              | Value              |
      | Ranking Source       | Custom Rankings    |
      | Position Limits      | Max 3 RB, Max 3 WR |
      | Avoid Teams          | Cowboys, Giants    |
      | Priority Positions   | RB, WR, RB         |
    Then autopick respects these preferences
    And jane_doe's roster builds according to strategy

  Scenario: Autopick makes optimal selection
    Given player "bob_player" is on autopick
    And bob_player's custom rankings have "Derrick Henry" as #1 available
    When it's bob_player's turn
    Then autopick selects "Derrick Henry"
    And the pick is made within 5 seconds
    And a "Auto" badge is shown on the pick

  Scenario: Autopick respects roster constraints
    Given player "alice_player" has autopick enabled
    And alice_player already has 2 QBs rostered
    And roster limit is 2 QBs maximum
    When autopick runs for alice_player
    Then autopick skips all QB selections
    And picks the highest-ranked non-QB player

  Scenario: Autopick handles position scarcity
    Given autopick is running for "john_doe"
    And john_doe has 0 TEs rostered
    And only 3 rounds remain
    And TE is a required position
    When autopick calculates the pick
    Then autopick selects the best available TE
    And ensures roster requirements are met before draft ends

  Scenario: Autopick in auction draft
    Given player "jane_doe" is on autopick in an auction
    When it's jane_doe's nomination turn
    Then autopick nominates the top-ranked available player
    And sets starting bid at projected value
    When other auctions occur
    Then autopick bids on players within value range
    And respects budget constraints

  Scenario: Pause autopick temporarily
    Given player "bob_player" has autopick enabled
    And bob_player's next pick is in 2 turns
    When bob_player clicks "Pause Autopick"
    Then bob_player takes manual control for their next pick
    And autopick resumes after the manual pick
    And this allows strategic intervention

  Scenario: Autopick notification
    Given player "alice_player" was away during their pick
    And autopick selected "Cooper Kupp"
    When alice_player returns to the draft
    Then alice_player sees notification "Autopick selected Cooper Kupp (Round 3, Pick 8)"
    And the autopick log shows all auto-selections

  Scenario: Override autopick queue
    Given player "john_doe" has a pick queue set
    And autopick is enabled
    When john_doe's pick comes
    Then autopick uses the queue first
    And if queue is empty or all taken, falls back to rankings
    And this combines queue with autopick protection

  # ==================== DRAFT BOARD ====================

  Scenario: Display live draft board during draft
    Given a 12-team mock draft is in progress
    When any participant views the draft board
    Then they see a grid with teams as columns and rounds as rows
    And completed picks show player name and position
    And the current pick is highlighted with timer
    And upcoming picks show the drafting team

  Scenario: Filter draft board by position
    Given the draft board is displayed
    When player "jane_doe" filters to show only "RB"
    Then only running back picks are highlighted
    And other positions are dimmed
    And RB runs on each team are easily visible
    And jane_doe can assess RB scarcity

  Scenario: View team roster from draft board
    Given player "bob_player" clicks on "john_doe" column header
    When the roster panel opens
    Then bob_player sees john_doe's complete roster:
      | Position | Player          | Pick # |
      | QB       | Josh Allen      | 36     |
      | RB       | Derrick Henry   | 12     |
      | RB       | (Empty)         | -      |
      | WR       | Tyreek Hill     | 13     |
    And roster needs are visible

  Scenario: Track positional runs on draft board
    Given the draft is in round 5
    And 4 consecutive RBs have been picked
    When the draft board updates
    Then a "RB Run" indicator appears
    And participants can see the position trend
    And this informs drafting strategy

  Scenario: Show ADP comparison on draft board
    Given pick #45 is "Travis Kelce"
    When viewing the draft board
    Then Kelce's pick shows:
      | Metric       | Value |
      | Pick #       | 45    |
      | ADP          | 38    |
      | Difference   | -7    |
    And this helps identify reaches and values

  Scenario: Export draft board to image
    Given the mock draft has completed
    When player "alice_player" clicks "Export Draft Board"
    Then a PNG image of the full draft board is generated
    And alice_player can save or share the image
    And the image includes all picks and teams

  Scenario: Draft board auto-scrolls to current pick
    Given the draft is at pick #87
    And player "john_doe" is viewing the board
    When the current pick changes
    Then the board auto-scrolls to show the active pick
    And john_doe can disable auto-scroll if preferred
    And manual scroll position is preserved when disabled

  Scenario: Display draft board summary statistics
    Given the draft is in progress
    When player "jane_doe" views the summary panel
    Then statistics are displayed:
      | Metric                    | Value |
      | Picks Made                | 78    |
      | Picks Remaining           | 72    |
      | Most Popular Position     | RB    |
      | Average Pick Time         | 28s   |
      | Fastest Pick              | 3s    |
    And the summary updates in real-time

  # ==================== DRAFT ANALYSIS ====================

  Scenario: Generate post-draft grade for each team
    Given a mock draft has completed
    When draft analysis is generated
    Then each team receives a grade:
      | Team         | Grade | Analysis                          |
      | john_doe     | A-    | Strong RB depth, weak at TE       |
      | jane_doe     | B+    | Balanced roster, reached on QB    |
      | bob_player   | B     | Good value picks, needs WR help   |
    And grades are based on value vs ADP and roster balance

  Scenario: Analyze draft value metrics
    Given player "john_doe" views their draft analysis
    When the analysis panel loads
    Then john_doe sees value breakdown:
      | Pick # | Player          | ADP   | Value | Rating    |
      | 5      | Saquon Barkley  | 8     | +3    | Great     |
      | 16     | Davante Adams   | 14    | -2    | Slight Reach |
      | 17     | Travis Kelce    | 22    | +5    | Steal     |
    And total value score is calculated

  Scenario: Compare draft to expert rankings
    Given mock draft for "jane_doe" is complete
    When jane_doe views expert comparison
    Then the comparison shows:
      | Expert Source  | Roster Grade | Best Pick      | Worst Pick   |
      | ESPN           | B+           | Lamb at 24     | Defense R8   |
      | Yahoo          | B            | Jefferson R2   | Kelce reach  |
      | FantasyPros    | A-           | RB stack       | Weak QB      |
    And jane_doe can understand different perspectives

  Scenario: Identify roster strengths and weaknesses
    Given draft analysis runs for "bob_player"
    When strength/weakness analysis completes
    Then the report shows:
      | Category     | Assessment                          |
      | Strengths    | Elite RB1/RB2, Strong WR corps     |
      | Weaknesses   | TE streaming needed, Weak bench    |
      | Risks        | Injury concern with RB1            |
      | Upside       | WR3 breakout candidate             |
    And actionable recommendations are provided

  Scenario: Display projected weekly points
    Given draft is complete for "alice_player"
    When projected lineup is calculated
    Then alice_player sees:
      | Metric                  | Value   |
      | Projected Weekly Avg    | 142.5   |
      | Floor (10th percentile) | 118.2   |
      | Ceiling (90th percentile)| 168.8  |
      | League Rank Projection  | 3rd     |
    And projections are based on current season data

  Scenario: Analyze positional investment strategy
    Given draft analysis for "john_doe" is complete
    When position investment is calculated
    Then the breakdown shows:
      | Position | Draft Capital | League Avg | Analysis      |
      | QB       | 8%            | 10%        | Under-invested|
      | RB       | 35%           | 30%        | Heavy invest  |
      | WR       | 28%           | 28%        | Average       |
      | TE       | 15%           | 12%        | Premium TE    |
    And strategy implications are explained

  Scenario: Compare mock draft to previous attempts
    Given player "jane_doe" has completed 5 mock drafts
    When jane_doe views trend analysis
    Then comparisons are shown:
      | Mock # | Date       | Grade | Avg Value | Strategy       |
      | 5      | Today      | A-    | +2.1      | Zero RB        |
      | 4      | Yesterday  | B     | -0.5      | Hero RB        |
      | 3      | 2 days ago | B+    | +1.2      | Best Available |
    And jane_doe can identify successful strategies

  Scenario: Share draft analysis on social media
    Given draft analysis is complete for "bob_player"
    When bob_player clicks "Share Analysis"
    Then a shareable summary card is generated:
      | Content              | Included |
      | Team Grade           | Yes      |
      | Top 3 Picks          | Yes      |
      | Projected Points     | Yes      |
      | Full Roster          | Optional |
    And bob_player can share to Twitter, Facebook, or copy link

  # ==================== DRAFT HISTORY ====================

  Scenario: View list of completed mock drafts
    Given player "john_doe" navigates to "My Mock Drafts"
    When the history page loads
    Then john_doe sees all past mock drafts:
      | Draft Name       | Date       | Type    | Teams | Grade | Result     |
      | Quick Snake      | Jan 5      | Snake   | 10    | A-    | Complete   |
      | PPR Practice     | Jan 4      | Snake   | 12    | B+    | Complete   |
      | Auction Test     | Jan 3      | Auction | 12    | B     | Complete   |
      | Friends League   | Jan 2      | Snake   | 10    | -     | Incomplete |
    And drafts are sorted by date descending

  Scenario: Replay a completed mock draft
    Given player "jane_doe" selects a completed mock draft
    When jane_doe clicks "View Replay"
    Then the draft board is reconstructed
    And jane_doe can step through each pick:
      | Controls        | Action                    |
      | Next Pick       | Advance one pick          |
      | Previous Pick   | Go back one pick          |
      | Jump to Round   | Skip to specific round    |
      | Play/Pause      | Animate picks over time   |
    And jane_doe can analyze decision points

  Scenario: View detailed pick-by-pick history
    Given player "bob_player" views draft history details
    When the detail view loads
    Then each pick shows:
      | Pick # | Round | Player          | Time Taken | Autopick | Value |
      | 1      | 1     | C. McCaffrey    | 45s        | No       | +2    |
      | 20     | 2     | S. Barkley      | 12s        | No       | +1    |
      | 21     | 3     | D. Adams        | 58s        | No       | -1    |
    And bob_player can filter by round or position

  Scenario: Download draft results as CSV
    Given player "alice_player" wants to export draft data
    When alice_player clicks "Export to CSV"
    Then a CSV file is generated with columns:
      | Pick | Round | Team | Player | Position | ADP | Value |
    And alice_player can analyze in spreadsheet software

  Scenario: Delete old mock draft from history
    Given player "john_doe" has 50 mock drafts in history
    When john_doe selects drafts older than 30 days
    And clicks "Delete Selected"
    Then selected drafts are removed from history
    And storage space is freed
    And action cannot be undone

  Scenario: Filter draft history by criteria
    Given player "jane_doe" has extensive draft history
    When jane_doe filters by:
      | Filter       | Value        |
      | Draft Type   | Auction      |
      | Grade        | A or higher  |
      | Date Range   | Last 7 days  |
    Then only matching drafts are displayed
    And jane_doe can study successful auction drafts

  Scenario: Star favorite mock drafts
    Given player "bob_player" has a particularly good mock draft
    When bob_player stars the draft
    Then the draft is marked as favorite
    And appears in "Starred Drafts" filter
    And will not be auto-deleted for storage

  Scenario: View aggregate statistics across all mock drafts
    Given player "alice_player" has completed 25 mock drafts
    When alice_player views "My Draft Stats"
    Then aggregate metrics are shown:
      | Metric                 | Value |
      | Total Mock Drafts      | 25    |
      | Average Grade          | B+    |
      | Most Drafted Player    | Kelce |
      | Average Draft Position | 5.2   |
      | Win Rate (if scored)   | 62%   |
    And trends over time are graphed

  # ==================== PRACTICE MODES ====================

  Scenario: Practice draft against AI opponents
    Given player "john_doe" wants solo practice
    When john_doe starts a practice draft:
      | Setting          | Value       |
      | Opponents        | AI Bots     |
      | Bot Difficulty   | Medium      |
      | Draft Speed      | Fast        |
      | Team Size        | 12          |
    Then 11 AI drafters fill the lobby
    And the draft starts immediately
    And AI makes realistic draft selections

  Scenario: Configure AI drafter difficulty
    Given player "jane_doe" is setting up practice mode
    When jane_doe selects AI difficulty:
      | Difficulty | Behavior                                    |
      | Easy       | Random picks, no strategy                   |
      | Medium     | Follows ADP with some variation             |
      | Hard       | Optimal picks, targets value                |
      | Expert     | Adaptive strategy, position runs, reaches   |
    Then AI opponents draft according to difficulty
    And jane_doe gets appropriate challenge level

  Scenario: Practice specific draft positions
    Given player "bob_player" wants to practice from 12th pick
    When bob_player sets:
      | Setting           | Value |
      | My Draft Position | 12    |
    Then bob_player is assigned pick #12
    And can practice late-round strategies
    And experience the "turn" at picks 12-13

  Scenario: Practice specific scenarios
    Given player "alice_player" wants to practice "Zero RB"
    When alice_player selects scenario mode:
      | Scenario       | Constraints                        |
      | Zero RB        | No RB in first 3 rounds           |
      | Hero RB        | Take RB #1 overall, none until R5 |
      | TE Premium     | Take TE in first 2 rounds         |
      | Robust RB      | Take RB in R1 and R2              |
    Then the practice enforces selected strategy
    And provides feedback on execution

  Scenario: Timed pressure practice mode
    Given player "john_doe" wants to practice under pressure
    When john_doe enables "Speed Draft" mode:
      | Setting        | Value    |
      | Pick Timer     | 15 seconds |
      | No Extensions  | Yes      |
    Then picks must be made within 15 seconds
    And no timer pauses are allowed
    And john_doe practices quick decision-making

  Scenario: Practice with custom player pool
    Given player "jane_doe" wants to practice dynasty rookie draft
    When jane_doe configures custom pool:
      | Setting             | Value        |
      | Player Pool         | Rookies Only |
      | Include             | 2025 Class   |
      | ADP Source          | Dynasty      |
    Then only rookie players are available
    And jane_doe practices rookie evaluation

  Scenario: Practice auction budget management
    Given player "bob_player" wants auction budget practice
    When bob_player starts auction practice mode:
      | Setting              | Value       |
      | Focus Area           | Budget Mgmt |
      | Scenario             | Star-heavy  |
      | AI Bidding           | Aggressive  |
    Then AI opponents bid aggressively on top players
    And bob_player learns budget discipline
    And post-practice analysis shows spending patterns

  Scenario: Pause and resume practice draft
    Given player "alice_player" is in a solo practice draft
    And needs to take a break
    When alice_player clicks "Pause Draft"
    Then the draft state is saved
    And alice_player can resume later from "My Drafts"
    And AI opponents wait for alice_player's return

  # ==================== DRAFT SHARING ====================

  Scenario: Share mock draft results link
    Given player "john_doe" has completed a mock draft
    When john_doe clicks "Share Results"
    Then a unique shareable URL is generated
    And the link shows john_doe's roster and analysis
    And viewers can see without logging in
    And the link expires after 30 days

  Scenario: Share draft to league chat
    Given player "jane_doe" completed a mock draft
    And jane_doe is a member of "Dynasty Dawgs" league
    When jane_doe shares to league chat
    Then a summary card is posted:
      | Content        | Details                    |
      | Header         | jane_doe's Mock Draft      |
      | Grade          | A-                         |
      | Notable Picks  | Jefferson R1, Henry R2     |
      | Link           | View Full Draft            |
    And league members can view and comment

  Scenario: Invite friends to join mock draft
    Given player "bob_player" created a private mock draft
    When bob_player clicks "Invite Friends"
    Then bob_player can:
      | Method          | Action                      |
      | Copy Link       | Share invite URL            |
      | Email           | Send email invitations      |
      | In-App          | Invite platform friends     |
      | QR Code         | Generate scannable code     |
    And invited users can join with one click

  Scenario: Create embeddable draft board widget
    Given player "alice_player" wants to embed draft results
    When alice_player generates embed code
    Then HTML/iframe code is provided
    And alice_player can embed on blog or website
    And the widget shows interactive draft board

  Scenario: Share draft analysis to Discord
    Given player "john_doe" uses Discord integration
    When john_doe shares draft to Discord server
    Then a rich embed is posted:
      | Field          | Content                    |
      | Title          | Mock Draft Complete        |
      | Roster         | Top 5 picks                |
      | Grade          | B+                         |
      | Thumbnail      | Team logo                  |
    And server members can react and discuss

  Scenario: Compare drafts with friends
    Given player "jane_doe" and player "bob_player" both completed mocks
    When jane_doe initiates draft comparison
    Then side-by-side comparison shows:
      | Round | jane_doe Pick  | bob_player Pick |
      | 1     | McCaffrey      | Jefferson       |
      | 2     | Lamb           | Henry           |
      | 3     | Kelce          | Kelce           |
    And overlapping picks are highlighted
    And unique picks show value differences

  Scenario: Publish mock draft to community
    Given player "alice_player" has an exceptional mock draft
    When alice_player publishes to "Community Drafts"
    Then the draft is visible to all users
    And can be upvoted and commented on
    And alice_player earns reputation points
    And top drafts are featured on homepage

  Scenario: Generate shareable draft recap video
    Given player "john_doe" wants video content
    When john_doe clicks "Generate Recap"
    Then an animated video is created showing:
      | Content              | Duration |
      | Pick highlights      | 30 sec   |
      | Draft board filling  | 15 sec   |
      | Final roster reveal  | 10 sec   |
      | Analysis summary     | 15 sec   |
    And john_doe can download or share directly

  Scenario: Privacy settings for shared drafts
    Given player "jane_doe" is sharing a draft
    When jane_doe configures privacy:
      | Setting              | Value    |
      | Visibility           | Private  |
      | Require Login        | Yes      |
      | Allowed Viewers      | Friends  |
      | Analytics Tracking   | Off      |
    Then only approved friends can view
    And draft is not indexed by search engines

  # ==================== ERROR HANDLING AND EDGE CASES ====================

  Scenario: Handle network disconnection during draft
    Given player "john_doe" is actively drafting
    When john_doe loses internet connection
    Then the system detects disconnection within 5 seconds
    And john_doe is shown "Reconnecting..." status
    And autopick is enabled as backup
    When connection is restored
    Then john_doe resumes control
    And any autopicked players are shown

  Scenario: Handle draft room crash recovery
    Given a mock draft is in progress with 8 participants
    When the server experiences an error
    Then draft state is recovered from persistent storage
    And all participants are reconnected
    And the draft resumes from last confirmed pick
    And no picks are lost or duplicated

  Scenario: Handle simultaneous bid submissions in auction
    Given two players submit bids within 100ms of each other
    When the server processes the bids
    Then the earlier timestamp wins
    And the losing bid receives "Outbid" notification
    And race conditions are prevented
    And bid ordering is deterministic

  Scenario: Handle player data refresh during draft
    Given player projections are updated mid-draft
    When the system receives new projection data
    Then rankings update without disrupting picks
    And in-progress autopick uses updated data
    And users are notified of projection changes
    And historical picks retain original values

  Scenario: Handle maximum lobby capacity
    Given a popular mock draft has 100 participants waiting
    When the system reaches capacity
    Then new users are added to a waitlist
    And waitlist position is displayed
    And users are notified when spots open
    And alternative lobbies are suggested

  Scenario: Handle draft timer synchronization
    Given 12 participants are in different time zones
    When the pick timer is running
    Then all participants see synchronized countdown
    And timer accounts for network latency
    And server time is authoritative
    And no participant gains unfair advantage

  Scenario: Handle invalid player selection
    Given player "jane_doe" attempts to draft a player
    When the player was already drafted by another team
    Then the selection is rejected
    And jane_doe sees "Player unavailable" error
    And jane_doe's timer is not penalized
    And jane_doe can make another selection

  Scenario: Handle incomplete draft due to abandonment
    Given a mock draft has 3 participants remaining
    And 9 participants have left or gone AFK
    When 30 minutes pass with minimal activity
    Then remaining participants are notified
    And option to complete with AI or cancel is offered
    And draft can be salvaged or gracefully ended
