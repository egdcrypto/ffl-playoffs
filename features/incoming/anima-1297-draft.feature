@draft @player-selection
Feature: Draft
  As a fantasy football manager
  I want to participate in the player draft
  So that I can select players for my team

  Background:
    Given I am logged in as a league member
    And the league "Playoff Champions" exists
    And the draft is scheduled

  # ============================================================================
  # DRAFT ROOM INTERFACE
  # ============================================================================

  @happy-path @draft-room
  Scenario: Enter draft room before draft starts
    Given the draft starts in 30 minutes
    When I enter the draft room
    Then I should see the draft lobby
    And I should see all league members' connection status
    And I should see the countdown to draft start

  @happy-path @draft-room
  Scenario: View draft board layout
    Given the draft has started
    When I view the draft board
    Then I should see a grid with teams as columns
    And I should see rounds as rows
    And I should see picks fill in as they are made

  @happy-path @draft-room
  Scenario: View available players list
    Given the draft has started
    When I view available players
    Then I should see all undrafted players
    And I should be able to filter by position
    And I should see player projections and rankings

  @happy-path @draft-room
  Scenario: Search for players during draft
    Given the draft has started
    When I search for "Patrick Mahomes"
    Then I should see matching players
    And I should see if each player is available or drafted

  @happy-path @draft-room
  Scenario: View player details during draft
    Given the draft has started
    When I click on "Patrick Mahomes"
    Then I should see player details:
      | Field          | Value              |
      | Position       | QB                 |
      | Team           | Kansas City Chiefs |
      | Bye Week       | 10                 |
      | ADP            | 15.3               |
      | Projected Pts  | 385                |

  @happy-path @draft-room
  Scenario: View draft room chat
    Given the draft has started
    When I view the draft chat
    Then I should see messages from league members
    And I should be able to send messages
    And I should see pick announcements in chat

  @happy-path @draft-room
  Scenario: View my roster during draft
    Given the draft has started
    And I have made several picks
    When I view my roster
    Then I should see my drafted players by position
    And I should see which positions still need to be filled
    And I should see my roster depth

  # ============================================================================
  # DRAFT ORDER
  # ============================================================================

  @happy-path @draft-order
  Scenario: View draft order before draft
    When I view the draft order
    Then I should see all teams in pick order
    And I should see my pick position
    And I should see the full order for round 1

  @happy-path @draft-order
  Scenario: Randomize draft order
    Given I am the commissioner
    And the draft order has not been set
    When I randomize the draft order
    Then teams should be assigned random positions
    And all members should be notified of their position

  @happy-path @draft-order
  Scenario: Manually set draft order
    Given I am the commissioner
    When I manually set the draft order:
      | Pick | Team     |
      | 1    | Team A   |
      | 2    | Team B   |
      | 3    | Team C   |
    Then the draft order should be saved
    And all members should see the order

  @happy-path @draft-order
  Scenario: Draft order based on previous season
    Given this is a returning league
    When I set draft order to "Reverse of Last Season Standings"
    Then last place should pick first
    And the champion should pick last

  @happy-path @draft-order
  Scenario: Lottery for draft order
    Given I am the commissioner
    When I run a lottery for draft order
    Then random lottery results should determine order
    And the lottery animation should display
    And results should be recorded

  @happy-path @draft-order
  Scenario: View pick throughout draft
    Given the draft is in round 5
    When I view my upcoming picks
    Then I should see my next pick number
    And I should see how many picks until my turn

  # ============================================================================
  # SNAKE/LINEAR FORMATS
  # ============================================================================

  @happy-path @snake
  Scenario: Snake draft order reversal
    Given the league uses snake draft format
    And Team A has pick 1 in round 1
    When round 2 begins
    Then Team A should have the last pick in round 2
    And the order should continue to alternate

  @happy-path @snake
  Scenario: View snake draft visualization
    Given the league uses snake draft format
    When I view the draft order visualization
    Then I should see the snake pattern illustrated
    And I should see my picks highlighted across rounds

  @happy-path @linear
  Scenario: Linear draft maintains order
    Given the league uses linear draft format
    And Team A has pick 1 in round 1
    When round 2 begins
    Then Team A should have pick 1 in round 2
    And the order should remain consistent

  @happy-path @third-round-reversal
  Scenario: Third round reversal snake
    Given the league uses third round reversal format
    When round 3 begins
    Then the order should reverse from round 2
    And rounds 3 and 4 should use the same order
    And round 5 should reverse again

  # ============================================================================
  # AUCTION BIDDING
  # ============================================================================

  @happy-path @auction
  Scenario: View auction budget
    Given the league uses auction draft
    And my budget is $200
    When I view my auction status
    Then I should see "$200 remaining"
    And I should see minimum bid requirements

  @happy-path @auction
  Scenario: Nominate player for auction
    Given it is my turn to nominate
    When I nominate "Patrick Mahomes" with opening bid $25
    Then "Patrick Mahomes" should be up for auction
    And the bidding timer should start
    And other teams should see the nomination

  @happy-path @auction
  Scenario: Place bid on nominated player
    Given "Patrick Mahomes" is up for auction
    And the current bid is $30
    When I bid $35
    Then I should be the high bidder
    And the timer should reset
    And other teams should see my bid

  @happy-path @auction
  Scenario: Win auction for player
    Given I am the high bidder at $45
    And the bidding timer expires
    When the auction closes
    Then "Patrick Mahomes" should be added to my team
    And my budget should decrease by $45
    And the next nomination should begin

  @happy-path @auction
  Scenario: Quick bid buttons
    Given "Josh Allen" is up for auction at $20
    When I use the quick bid buttons
    Then I should see options for "+$1", "+$5", "+$10"
    And clicking should place the corresponding bid

  @validation @auction
  Scenario: Cannot bid more than remaining budget
    Given I have $30 remaining budget
    And I need to fill 3 roster spots at $1 each minimum
    When I attempt to bid $29
    Then I should see "Maximum bid is $27"
    And the bid should be blocked

  @validation @auction
  Scenario: Cannot bid on player when roster is full
    Given my roster is complete
    When I attempt to bid on a player
    Then I should see "Roster is full"
    And bidding should be disabled

  @happy-path @auction
  Scenario: Auction draft with FAAB-style bidding
    Given the league uses blind auction format
    When all teams submit bids for "Patrick Mahomes"
    Then bids should be revealed simultaneously
    And the highest bidder should win

  # ============================================================================
  # DRAFT TIMER
  # ============================================================================

  @happy-path @timer
  Scenario: View pick timer countdown
    Given it is my turn to pick
    And the pick timer is 90 seconds
    When I view the draft room
    Then I should see a countdown timer
    And the timer should count down in real-time

  @happy-path @timer
  Scenario: Timer warning at low time
    Given it is my turn to pick
    And 15 seconds remain on the timer
    When the timer reaches 15 seconds
    Then I should see a visual warning
    And I should hear an audio alert

  @happy-path @timer
  Scenario: Timer expires triggers auto-pick
    Given it is my turn to pick
    And I have not made a selection
    When the timer expires
    Then the auto-pick should select a player
    And the next team should be on the clock

  @happy-path @timer
  Scenario: Pause timer as commissioner
    Given I am the commissioner
    And a team needs extra time
    When I pause the draft timer
    Then the timer should stop
    And all members should see "Draft Paused"
    And I should be able to resume

  @happy-path @timer
  Scenario: Configure pick timer duration
    Given I am the commissioner
    And the draft has not started
    When I set pick timer to 60 seconds
    Then each pick should have a 60-second timer

  @happy-path @timer
  Scenario: Different timer for first pick
    Given I am the commissioner
    When I configure a 3-minute timer for pick 1.01
    Then the first pick should have 3 minutes
    And subsequent picks should use the default timer

  # ============================================================================
  # AUTO-PICK
  # ============================================================================

  @happy-path @auto-pick
  Scenario: Enable auto-pick
    Given the draft has started
    When I enable auto-pick mode
    Then my picks should be made automatically
    And I should see "Auto-Pick Enabled" indicator
    And I should be able to disable at any time

  @happy-path @auto-pick
  Scenario: Auto-pick uses my rankings
    Given I have custom player rankings set
    And auto-pick is enabled
    When it is my turn to pick
    Then auto-pick should select the highest-ranked available player
    And the selection should respect my rankings

  @happy-path @auto-pick
  Scenario: Auto-pick uses default rankings
    Given I have not set custom rankings
    And auto-pick is enabled
    When it is my turn to pick
    Then auto-pick should use platform default rankings
    And position needs should be considered

  @happy-path @auto-pick
  Scenario: Auto-pick respects position limits
    Given I have 3 QBs (the maximum)
    And auto-pick is enabled
    When it is my turn and the best available is a QB
    Then auto-pick should skip the QB
    And select the best available at another position

  @happy-path @auto-pick
  Scenario: Disable auto-pick and make manual selection
    Given auto-pick is enabled
    When I disable auto-pick
    And I manually select "Tyreek Hill"
    Then "Tyreek Hill" should be added to my team
    And auto-pick should remain disabled

  @happy-path @auto-pick
  Scenario: Auto-pick timeout fallback
    Given I am making picks manually
    And the timer expires without a selection
    When auto-pick activates as fallback
    Then the best available player should be selected
    And I should receive a notification

  # ============================================================================
  # QUEUE MANAGEMENT
  # ============================================================================

  @happy-path @queue
  Scenario: Add player to draft queue
    Given the draft has started
    When I add "Patrick Mahomes" to my queue
    Then "Patrick Mahomes" should appear in my queue
    And I should see queue position for the player

  @happy-path @queue
  Scenario: Reorder draft queue
    Given my queue contains:
      | Priority | Player          |
      | 1        | Patrick Mahomes |
      | 2        | Josh Allen      |
      | 3        | Lamar Jackson   |
    When I move "Josh Allen" to priority 1
    Then my queue should be reordered
    And "Josh Allen" should be first

  @happy-path @queue
  Scenario: Remove player from queue
    Given "Patrick Mahomes" is in my queue
    When I remove "Patrick Mahomes" from my queue
    Then "Patrick Mahomes" should no longer be in my queue
    And remaining players should reorder

  @happy-path @queue
  Scenario: Queue player drafted by another team
    Given "Patrick Mahomes" is in my queue
    And another team drafts "Patrick Mahomes"
    When my queue updates
    Then "Patrick Mahomes" should be marked as drafted
    And I should receive a notification
    And the player should be removed from my queue

  @happy-path @queue
  Scenario: Auto-pick from queue
    Given my queue is set up
    And auto-pick is enabled
    When it is my turn to pick
    Then auto-pick should select the first available player from my queue
    And that player should be removed from my queue

  @happy-path @queue
  Scenario: View queue status during draft
    Given I have players in my queue
    When I view my queue
    Then I should see which players are still available
    And I should see which have been drafted
    And I should see projected pick numbers

  # ============================================================================
  # PLAYER RANKINGS
  # ============================================================================

  @happy-path @rankings
  Scenario: View default player rankings
    When I view player rankings
    Then I should see players ranked by overall value
    And I should see position-specific rankings
    And I should see ADP data

  @happy-path @rankings
  Scenario: Create custom player rankings
    When I create custom rankings
    And I move "Derrick Henry" above "Saquon Barkley"
    Then my custom rankings should be saved
    And auto-pick should use my rankings

  @happy-path @rankings
  Scenario: Import rankings from external source
    Given I have a rankings file from FantasyPros
    When I import the rankings file
    Then my rankings should update to match the import
    And I should see import confirmation

  @happy-path @rankings
  Scenario: View rankings by position
    When I filter rankings by "RB"
    Then I should see only running backs
    And they should be ranked by RB value
    And I should see RB-specific projections

  @happy-path @rankings
  Scenario: Compare my rankings to consensus
    When I compare my rankings to consensus
    Then I should see where I differ from ADP
    And I should see players I have ranked higher
    And I should see players I have ranked lower

  @happy-path @rankings
  Scenario: Do not draft list
    When I add "Injury Prone Player" to my do-not-draft list
    Then "Injury Prone Player" should be flagged
    And auto-pick should never select this player
    And I should see a warning if I try to draft manually

  # ============================================================================
  # PICK TRADING
  # ============================================================================

  @happy-path @pick-trading
  Scenario: Trade draft picks before draft
    Given draft pick trading is enabled
    And I own pick 1.05
    When I trade pick 1.05 to "Team B" for pick 2.03 and 3.03
    Then the trade should be recorded
    And "Team B" should have pick 1.05
    And I should have picks 2.03 and 3.03

  @happy-path @pick-trading
  Scenario: View updated draft order after trade
    Given picks have been traded
    When I view the draft order
    Then I should see the updated pick ownership
    And traded picks should be highlighted

  @happy-path @pick-trading
  Scenario: Trade picks during draft
    Given the draft is in progress
    And the league allows in-draft pick trading
    When I trade my next pick to "Team B"
    Then the trade should be recorded immediately
    And the draft board should update

  @happy-path @pick-trading
  Scenario: Trade future year picks
    Given this is a dynasty league
    And future pick trading is enabled
    When I trade my 2025 1st round pick
    Then the future pick should be recorded as traded
    And it should appear in next year's draft order

  @validation @pick-trading
  Scenario: Cannot trade pick that has been used
    Given I have already made pick 1.05
    When I attempt to trade pick 1.05
    Then I should see "Cannot trade - pick already used"
    And the trade should be blocked

  @commissioner @pick-trading
  Scenario: Commissioner veto pick trade
    Given I am the commissioner
    And a questionable pick trade is proposed
    When I veto the trade
    Then the trade should be cancelled
    And both teams should be notified

  # ============================================================================
  # KEEPER SELECTIONS
  # ============================================================================

  @happy-path @keepers
  Scenario: Select keepers before draft
    Given this is a keeper league
    And I can keep up to 3 players
    When I select my keepers:
      | Player          | Keeper Round |
      | Patrick Mahomes | 2            |
      | Derrick Henry   | 1            |
    Then my keepers should be locked in
    And those picks should be assigned to me

  @happy-path @keepers
  Scenario: View keeper cost
    Given keeper cost is "previous round minus 1"
    And I drafted "Patrick Mahomes" in round 4 last year
    When I view keeper options
    Then "Patrick Mahomes" should cost a round 3 pick
    And I should see the value assessment

  @happy-path @keepers
  Scenario: Keeper deadline enforcement
    Given the keeper deadline is 24 hours before draft
    And the deadline has not passed
    When I change my keeper selection
    Then the change should be saved
    And I should see the deadline countdown

  @validation @keepers
  Scenario: Cannot keep more than maximum allowed
    Given the maximum keepers is 3
    And I have already selected 3 keepers
    When I attempt to add a 4th keeper
    Then I should see "Maximum keepers (3) already selected"
    And I should remove one before adding another

  @happy-path @keepers
  Scenario: View all league keeper selections
    Given the keeper deadline has passed
    When I view league keepers
    Then I should see all teams' keeper selections
    And I should see which players are no longer available

  @happy-path @keepers
  Scenario: Waive keeper rights
    Given I have keeper rights to "Patrick Mahomes"
    When I waive my keeper rights
    Then "Patrick Mahomes" should be available in the draft
    And I should have my draft pick restored

  # ============================================================================
  # DRAFT HISTORY
  # ============================================================================

  @happy-path @history
  Scenario: View live draft history
    Given the draft is in progress
    When I view draft history
    Then I should see all picks made in order
    And I should see team, player, round, and pick number
    And the list should update in real-time

  @happy-path @history
  Scenario: View past draft results
    Given a draft was completed last season
    When I view historical drafts
    Then I should see the full draft results
    And I should be able to analyze pick values

  @happy-path @history
  Scenario: Export draft results
    Given the draft is complete
    When I export draft results
    Then I should receive a CSV file with all picks
    And it should include player, team, round, and pick

  @happy-path @history
  Scenario: View draft results by team
    Given the draft is complete
    When I view "Team A" draft results
    Then I should see all players drafted by "Team A"
    And I should see their draft positions

  @happy-path @history
  Scenario: Undo last pick as commissioner
    Given I am the commissioner
    And the last pick was made in error
    When I undo the last pick
    Then the pick should be reversed
    And the timer should restart
    And an audit log should record the undo

  # ============================================================================
  # MOCK DRAFTS
  # ============================================================================

  @happy-path @mock
  Scenario: Create a mock draft
    When I create a mock draft
    Then I should be able to practice drafting
    And the mock should use current player data
    And my real draft queue should not be affected

  @happy-path @mock
  Scenario: Mock draft with computer opponents
    When I start a mock draft against CPU
    Then computer teams should make realistic picks
    And I should experience the draft flow
    And I should be able to adjust CPU difficulty

  @happy-path @mock
  Scenario: Mock draft with league members
    Given I invite league members to mock draft
    When we all join the mock draft room
    Then we should be able to practice together
    And results should not affect the real draft

  @happy-path @mock
  Scenario: Simulate picks in mock draft
    Given I am in a mock draft
    When I enable "simulate to my pick"
    Then the mock should fast-forward
    And I should see simulated picks
    And the draft should pause at my pick

  @happy-path @mock
  Scenario: Review mock draft results
    Given I completed a mock draft
    When I review my mock draft
    Then I should see my simulated team
    And I should see grade and analysis
    And I should be able to share results

  @happy-path @mock
  Scenario: Multiple mock draft scenarios
    When I run 10 mock drafts
    Then I should see player frequency data
    And I should see which players I typically get
    And I should see optimal strategies

  # ============================================================================
  # DRAFT RECAP
  # ============================================================================

  @happy-path @recap
  Scenario: Generate draft recap
    Given the draft is complete
    When the draft recap is generated
    Then I should see overall draft analysis
    And I should see team grades
    And I should see best picks and reaches

  @happy-path @recap
  Scenario: View my team's draft grade
    Given the draft is complete
    When I view my draft recap
    Then I should see my team grade
    And I should see strengths and weaknesses
    And I should see projected finish

  @happy-path @recap
  Scenario: View steal and reach picks
    Given the draft is complete
    When I view steal and reach analysis
    Then I should see players drafted below ADP (steals)
    And I should see players drafted above ADP (reaches)
    And I should see value ratings

  @happy-path @recap
  Scenario: Compare draft to expert rankings
    Given the draft is complete
    When I compare to expert consensus
    Then I should see how my picks compare
    And I should see expert opinions on selections

  @happy-path @recap
  Scenario: Share draft recap
    Given I have my draft recap
    When I share my draft recap
    Then I should be able to share on social media
    And I should get a shareable link
    And the image should show my team and grade

  # ============================================================================
  # PAUSE/RESUME
  # ============================================================================

  @commissioner @pause
  Scenario: Pause draft in progress
    Given I am the commissioner
    And the draft is in progress
    When I pause the draft
    Then the timer should stop
    And all members should see "Draft Paused"
    And no picks should be allowed

  @commissioner @pause
  Scenario: Resume paused draft
    Given I am the commissioner
    And the draft is paused
    When I resume the draft
    Then the timer should restart
    And all members should see "Draft Resumed"
    And picking should continue

  @happy-path @pause
  Scenario: View pause reason
    Given the draft is paused
    When I view the pause status
    Then I should see the reason for the pause
    And I should see estimated resume time if provided

  @commissioner @pause
  Scenario: End draft early
    Given I am the commissioner
    And there are circumstances requiring early end
    When I end the draft early
    Then remaining picks should auto-complete
    And the draft should be marked complete
    And results should be finalized

  @commissioner @pause
  Scenario: Reschedule draft
    Given I am the commissioner
    And the draft needs to be postponed
    When I reschedule the draft
    Then all members should be notified
    And the new date should be displayed
    And calendar invites should update

  # ============================================================================
  # DRAFT NOTIFICATIONS
  # ============================================================================

  @happy-path @notifications
  Scenario: Receive notification when on the clock
    Given I have notifications enabled
    When it becomes my turn to pick
    Then I should receive a push notification
    And the notification should say "You're on the clock!"

  @happy-path @notifications
  Scenario: Receive notification when pick is upcoming
    Given I have notifications enabled
    When my pick is 2 picks away
    Then I should receive a heads-up notification
    And I should have time to prepare

  @happy-path @notifications
  Scenario: Receive notification when player is drafted
    Given "Patrick Mahomes" is in my queue
    When another team drafts "Patrick Mahomes"
    Then I should receive a notification
    And the notification should say "Patrick Mahomes was drafted"

  @happy-path @notifications
  Scenario: Receive draft start reminder
    Given the draft starts in 1 hour
    When the reminder time is reached
    Then I should receive a reminder notification
    And the notification should link to the draft room

  @happy-path @notifications
  Scenario: Receive draft completion notification
    Given I am a league member
    When the draft is complete
    Then I should receive a notification
    And I should see a link to the draft recap

  @happy-path @notifications
  Scenario: Configure draft notification preferences
    When I configure draft notifications
    Then I should be able to toggle:
      | Notification Type    | Enabled |
      | On the Clock         | Yes     |
      | Upcoming Pick        | Yes     |
      | Player Drafted       | Yes     |
      | Draft Start Reminder | Yes     |
      | Draft Complete       | Yes     |

  # ============================================================================
  # MOBILE / RESPONSIVE
  # ============================================================================

  @mobile @responsive
  Scenario: Draft on mobile device
    Given I am using a mobile device
    When I enter the draft room
    Then I should see a mobile-optimized interface
    And I should be able to make picks with touch
    And I should see essential information on screen

  @mobile @responsive
  Scenario: Quick pick on mobile
    Given I am using a mobile device
    And it is my turn to pick
    When I tap on "Patrick Mahomes"
    Then I should see a quick draft confirmation
    And I should be able to confirm with one tap

  @mobile @responsive
  Scenario: Manage queue on mobile
    Given I am using a mobile device
    When I view my draft queue
    Then I should be able to reorder with swipe gestures
    And I should be able to remove players easily

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility @a11y
  Scenario: Screen reader support for draft
    Given I am using a screen reader
    When I participate in the draft
    Then picks should be announced
    And timer status should be accessible
    And all controls should be labeled

  @accessibility @a11y
  Scenario: Keyboard navigation for draft
    Given I am using keyboard only
    When I navigate the draft room
    Then I should be able to browse players with arrow keys
    And I should be able to make picks with Enter
    And focus should be managed appropriately

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error @resilience
  Scenario: Handle connection loss during draft
    Given the draft is in progress
    And my connection is lost
    When connectivity issues occur
    Then my picks should be preserved
    And I should see reconnection status
    And auto-pick should activate if needed

  @error @resilience
  Scenario: Handle server issues during draft
    Given the draft server experiences issues
    When a pick fails to process
    Then the system should retry automatically
    And the timer should pause if necessary
    And commissioners should be alerted

  @error @resilience
  Scenario: Recover from draft room crash
    Given the draft was in progress
    And the app crashed
    When I reopen the draft room
    Then I should rejoin at the current pick
    And my queue should be preserved
    And no picks should be lost
