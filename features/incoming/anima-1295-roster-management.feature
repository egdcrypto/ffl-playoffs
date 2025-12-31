@roster-management @lineup
Feature: Roster Management
  As a fantasy football manager
  I want to manage my team roster and lineup
  So that I can optimize my team's performance each week

  Background:
    Given I am logged in as a league member
    And the league "Playoff Champions" exists
    And I own the team "My Fantasy Team"

  # ============================================================================
  # LINEUP SETTING
  # ============================================================================

  @happy-path @lineup
  Scenario: Set starting lineup for the week
    Given my roster contains players at all positions
    And the lineup deadline has not passed
    When I set my starting lineup:
      | Position | Player          |
      | QB       | Patrick Mahomes |
      | RB1      | Derrick Henry   |
      | RB2      | Saquon Barkley  |
      | WR1      | Tyreek Hill     |
      | WR2      | Justin Jefferson|
      | TE       | Travis Kelce    |
      | FLEX     | A.J. Brown      |
      | K        | Justin Tucker   |
      | DEF      | San Francisco   |
    Then my lineup should be saved
    And I should see a confirmation message

  @happy-path @lineup
  Scenario: View current starting lineup
    Given I have a saved lineup for this week
    When I view my team roster
    Then I should see my starting players clearly marked
    And I should see projected points for each starter
    And I should see the total projected team points

  @happy-path @lineup
  Scenario: Quick-set optimal lineup
    Given I have players on my roster
    When I click "Set Optimal Lineup"
    Then the system should automatically set the highest projected players
    And I should see the recommended lineup for review
    And I should be able to confirm or modify the lineup

  @happy-path @lineup
  Scenario: Copy lineup from previous week
    Given I had a lineup set for the previous week
    And all those players are still on my roster
    When I click "Copy Last Week's Lineup"
    Then my lineup should match last week's starters
    And players with bye weeks should be flagged

  @validation @lineup
  Scenario: Cannot start player on bye week
    Given "Patrick Mahomes" is on bye this week
    When I attempt to start "Patrick Mahomes"
    Then I should see a warning "Player is on bye week"
    And the system should suggest alternatives from my bench

  @validation @lineup
  Scenario: Cannot start injured player marked as Out
    Given "Derrick Henry" is marked as "Out" for this week
    When I attempt to start "Derrick Henry"
    Then I should see a warning "Player is ruled Out"
    And I should be prompted to select a replacement

  # ============================================================================
  # BENCH MANAGEMENT
  # ============================================================================

  @happy-path @bench
  Scenario: View bench players
    Given I have players on my bench
    When I view my team roster
    Then I should see all bench players listed
    And I should see their projected points
    And I should see their injury status

  @happy-path @bench
  Scenario: Move player from bench to starting lineup
    Given "Josh Allen" is on my bench
    And "Patrick Mahomes" is in my starting QB slot
    When I swap "Josh Allen" into the QB starting position
    Then "Josh Allen" should be my starting QB
    And "Patrick Mahomes" should move to my bench

  @happy-path @bench
  Scenario: Bench depth chart view
    When I view my bench by position
    Then I should see bench players grouped by position:
      | Position | Players                    |
      | QB       | Josh Allen                 |
      | RB       | Najee Harris, Javonte Williams |
      | WR       | Chris Olave, Garrett Wilson |
      | TE       | Dallas Goedert             |

  @happy-path @bench
  Scenario: Sort bench players by various criteria
    Given I have multiple bench players
    When I sort my bench by "Projected Points"
    Then bench players should be ordered by projected points descending
    And I should be able to sort by name, position, or opponent

  # ============================================================================
  # POSITION ELIGIBILITY
  # ============================================================================

  @happy-path @eligibility
  Scenario: Player with single position eligibility
    Given "Patrick Mahomes" is eligible only at QB
    When I view position eligibility for "Patrick Mahomes"
    Then I should see "QB" as the only eligible position
    And I should only be able to start him at QB

  @happy-path @eligibility
  Scenario: Player with multiple position eligibility
    Given "Cordarrelle Patterson" is eligible at RB and WR
    When I view position eligibility for "Cordarrelle Patterson"
    Then I should see "RB, WR" as eligible positions
    And I should be able to start him at RB, WR, or FLEX

  @happy-path @eligibility
  Scenario: Start multi-position player at flex
    Given "Taysom Hill" is eligible at QB, TE, and RB
    And my FLEX slot accepts RB, WR, and TE
    When I start "Taysom Hill" at FLEX
    Then "Taysom Hill" should be in my FLEX position
    And his TE eligibility should satisfy the FLEX requirement

  @validation @eligibility
  Scenario: Cannot start player at ineligible position
    Given "Patrick Mahomes" is eligible only at QB
    When I attempt to start "Patrick Mahomes" at RB
    Then I should see an error "Player is not eligible at this position"
    And the lineup change should not be saved

  @happy-path @eligibility
  Scenario: View all position-eligible players for a slot
    Given I need to fill my FLEX position
    When I click on the FLEX slot
    Then I should see all RB, WR, and TE players from my roster
    And I should not see QB, K, or DEF players

  # ============================================================================
  # ROSTER LOCKS
  # ============================================================================

  @happy-path @locks
  Scenario: Player locks at game time
    Given "Patrick Mahomes" game starts at 1:00 PM
    And the current time is 1:05 PM
    When I view "Patrick Mahomes" status
    Then I should see "Locked" indicator
    And I should not be able to move him to or from the starting lineup

  @happy-path @locks
  Scenario: Make lineup changes before player locks
    Given "Patrick Mahomes" game starts at 1:00 PM
    And the current time is 12:30 PM
    When I move "Patrick Mahomes" to my bench
    Then the change should be saved
    And "Patrick Mahomes" should be on my bench

  @happy-path @locks
  Scenario: View lock countdown for players
    Given multiple games are scheduled today
    When I view my roster
    Then I should see countdown timers for each unlocked player
    And locked players should show "Locked" status

  @happy-path @locks
  Scenario: Swap unlocked players after some games start
    Given "Patrick Mahomes" (1:00 PM game) is locked
    And "Josh Allen" (4:25 PM game) is unlocked
    When I attempt to swap "Josh Allen" for "Patrick Mahomes"
    Then I should see an error "Cannot swap with locked player"

  @happy-path @locks
  Scenario: Start unlocked bench player for locked injured starter
    Given "Derrick Henry" is locked and injured during game
    And "Najee Harris" (4:25 PM game) is unlocked on my bench
    When the commissioner enables emergency swap
    Then I should be able to start "Najee Harris"
    And an audit log should record the emergency change

  @edge-case @locks
  Scenario: Postponed game affects lock status
    Given "Patrick Mahomes" was locked for a 1:00 PM game
    And the game is postponed to Monday
    When the postponement is announced
    Then "Patrick Mahomes" should become unlocked
    And I should be able to adjust my lineup

  # ============================================================================
  # IR SLOTS
  # ============================================================================

  @happy-path @ir
  Scenario: Move injured player to IR slot
    Given "Christian McCaffrey" is designated as IR-eligible
    And I have an open IR slot
    When I move "Christian McCaffrey" to my IR slot
    Then "Christian McCaffrey" should be in my IR slot
    And I should have an open roster spot

  @happy-path @ir
  Scenario: View IR slot capacity
    Given my league allows 2 IR slots
    And I have 1 player on IR
    When I view my IR slots
    Then I should see "1/2 IR Slots Used"
    And I should see the player on IR

  @validation @ir
  Scenario: Cannot move healthy player to IR
    Given "Patrick Mahomes" has no injury designation
    When I attempt to move "Patrick Mahomes" to IR
    Then I should see an error "Player is not IR-eligible"
    And "Patrick Mahomes" should remain in his current position

  @validation @ir
  Scenario: Must clear IR before adding players when IR player is healthy
    Given "Christian McCaffrey" is on my IR slot
    And "Christian McCaffrey" is now designated as healthy
    And my roster is at maximum capacity
    When I attempt to add a player from waivers
    Then I should see "Must activate or drop IR player first"
    And the transaction should be blocked

  @happy-path @ir
  Scenario: Activate player from IR to roster
    Given "Christian McCaffrey" is on my IR slot
    And "Christian McCaffrey" is now healthy
    And I have an open roster spot
    When I activate "Christian McCaffrey" from IR
    Then "Christian McCaffrey" should be on my active roster
    And my IR slot should be empty

  @happy-path @ir
  Scenario: IR-to-roster swap with drop
    Given "Christian McCaffrey" is on my IR
    And my roster is full
    When I activate "Christian McCaffrey" and drop "Backup RB"
    Then "Christian McCaffrey" should be on my roster
    And "Backup RB" should be dropped to waivers

  # ============================================================================
  # TAXI SQUAD
  # ============================================================================

  @happy-path @taxi
  Scenario: View taxi squad players
    Given my league has taxi squad enabled
    And I have players on my taxi squad
    When I view my taxi squad
    Then I should see all taxi squad players
    And I should see their eligibility for promotion

  @happy-path @taxi
  Scenario: Add rookie to taxi squad
    Given my league allows rookies on taxi squad
    And I draft rookie "Bijan Robinson"
    When I place "Bijan Robinson" on my taxi squad
    Then "Bijan Robinson" should be on my taxi squad
    And he should not count against my active roster limit

  @happy-path @taxi
  Scenario: Promote player from taxi squad
    Given "Bijan Robinson" is on my taxi squad
    And I have an open roster spot
    When I promote "Bijan Robinson" to my active roster
    Then "Bijan Robinson" should be on my active roster
    And my taxi squad should have an open slot

  @validation @taxi
  Scenario: Cannot add veteran to taxi squad
    Given "Patrick Mahomes" is a veteran player
    And the league restricts taxi squad to rookies only
    When I attempt to place "Patrick Mahomes" on taxi squad
    Then I should see an error "Only rookies allowed on taxi squad"

  @validation @taxi
  Scenario: Taxi squad player claimed by another team
    Given "Bijan Robinson" is on my taxi squad
    And another team submits a claim for "Bijan Robinson"
    When I am notified of the claim
    Then I should have 24 hours to promote or release
    And the claiming team's move should be pending

  @happy-path @taxi
  Scenario: Taxi squad deadline
    Given the taxi squad deadline is Week 8
    And we are in Week 9
    When I attempt to add a player to taxi squad
    Then I should see "Taxi squad deadline has passed"
    And no taxi squad changes should be allowed

  # ============================================================================
  # ROSTER LIMITS
  # ============================================================================

  @happy-path @limits
  Scenario: View roster limits
    Given my league has roster limits configured
    When I view my roster settings
    Then I should see:
      | Setting              | Value |
      | Max Roster Size      | 16    |
      | Max QBs              | 3     |
      | Max RBs              | 6     |
      | Max WRs              | 6     |
      | Max TEs              | 3     |
      | Max Ks               | 2     |
      | Max DEFs             | 2     |

  @validation @limits
  Scenario: Cannot exceed position limit
    Given I have 3 QBs on my roster (the maximum)
    When I attempt to add another QB from waivers
    Then I should see "Maximum QBs (3) reached"
    And I should be prompted to drop a QB first

  @validation @limits
  Scenario: Cannot exceed total roster limit
    Given my roster has 16 players (the maximum)
    When I attempt to add a player without dropping
    Then I should see "Roster is full - must drop a player"
    And the add should be blocked

  @happy-path @limits
  Scenario: Position limit warning when trading
    Given I have 2 QBs on my roster
    And the maximum is 3 QBs
    When I receive a trade offer including 2 QBs
    Then I should see a warning about position limits
    And the trade should be blocked if it violates limits

  # ============================================================================
  # LINEUP VALIDATION
  # ============================================================================

  @validation @lineup-validation
  Scenario: Validate complete starting lineup
    Given I have empty starting positions
    When I attempt to save my lineup with empty slots
    Then I should see a warning "Incomplete lineup - empty slots detected"
    And I should see which positions need players

  @validation @lineup-validation
  Scenario: Validate no duplicate players in lineup
    Given "Tyreek Hill" is in my WR1 slot
    When I attempt to also place "Tyreek Hill" in my FLEX slot
    Then I should see an error "Player already in lineup"
    And the duplicate should be prevented

  @happy-path @lineup-validation
  Scenario: Lineup validation before game time
    Given my lineup has issues
    When the 1-hour pregame warning is triggered
    Then I should receive a notification about lineup problems
    And the notification should list specific issues

  @happy-path @lineup-validation
  Scenario: Auto-fill empty lineup slots
    Given I have empty starting positions
    And I have eligible bench players
    When I click "Auto-fill Empty Slots"
    Then empty positions should be filled with highest projected bench players
    And I should review and confirm the changes

  @validation @lineup-validation
  Scenario: Validate bye week coverage
    Given multiple starters have the same bye week
    When I view Week 7 lineup
    Then I should see bye week warnings
    And I should see suggestions for bye week coverage

  # ============================================================================
  # FLEX POSITIONS
  # ============================================================================

  @happy-path @flex
  Scenario: View flex position eligibility rules
    When I view flex position settings
    Then I should see which positions are flex-eligible:
      | Flex Slot  | Eligible Positions |
      | FLEX       | RB, WR, TE         |
      | SUPERFLEX  | QB, RB, WR, TE     |

  @happy-path @flex
  Scenario: Start RB in flex position
    Given my RB slots are filled
    And I have RB "Javonte Williams" on my bench
    When I start "Javonte Williams" in my FLEX slot
    Then "Javonte Williams" should be in my FLEX position
    And my lineup should be valid

  @happy-path @flex
  Scenario: Start QB in superflex position
    Given my league has a SUPERFLEX slot
    And my QB slot is filled with "Patrick Mahomes"
    And I have "Josh Allen" on my bench
    When I start "Josh Allen" in my SUPERFLEX slot
    Then "Josh Allen" should be in my SUPERFLEX position

  @happy-path @flex
  Scenario: Optimal flex selection recommendation
    Given I have multiple flex-eligible players
    When I view flex recommendations
    Then I should see players ranked by projected points
    And I should see matchup difficulty indicators

  @validation @flex
  Scenario: Cannot start kicker in flex
    Given my FLEX slot accepts RB, WR, TE
    When I attempt to start kicker "Justin Tucker" in FLEX
    Then I should see an error "Kicker not eligible for FLEX"

  # ============================================================================
  # DEADLINE ENFORCEMENT
  # ============================================================================

  @happy-path @deadline
  Scenario: View lineup deadline
    Given the lineup deadline is Thursday 8:20 PM EST
    When I view my lineup
    Then I should see "Lineup locks: Thursday 8:20 PM EST"
    And I should see a countdown to the deadline

  @happy-path @deadline
  Scenario: Weekly lineup deadline for all games
    Given the league uses weekly lineup locks
    And the first game is Thursday night
    When the Thursday game kicks off
    Then my entire lineup should lock for the week
    And I should not be able to make any changes

  @happy-path @deadline
  Scenario: Individual game time deadline
    Given the league uses individual game locks
    And "Patrick Mahomes" plays at 1:00 PM
    And "Josh Allen" plays at 4:25 PM
    When it's 1:05 PM
    Then "Patrick Mahomes" should be locked
    And "Josh Allen" should still be editable until 4:25 PM

  @validation @deadline
  Scenario: Cannot change lineup after deadline
    Given the lineup deadline has passed
    When I attempt to change my lineup
    Then I should see "Lineup is locked"
    And no changes should be allowed

  @edge-case @deadline
  Scenario: Commissioner extends deadline
    Given the lineup deadline has passed
    And the commissioner extends the deadline by 30 minutes
    When I view my lineup
    Then I should be able to make changes
    And I should see the new deadline

  # ============================================================================
  # PLAYER SWAPS
  # ============================================================================

  @happy-path @swaps
  Scenario: Swap two players between positions
    Given "Derrick Henry" is my starting RB1
    And "Saquon Barkley" is my starting RB2
    When I swap their positions
    Then "Saquon Barkley" should be RB1
    And "Derrick Henry" should be RB2

  @happy-path @swaps
  Scenario: Swap starter and bench player
    Given "Derrick Henry" is my starting RB1
    And "Najee Harris" is on my bench
    When I swap "Derrick Henry" and "Najee Harris"
    Then "Najee Harris" should be my starting RB1
    And "Derrick Henry" should be on my bench

  @happy-path @swaps
  Scenario: Drag and drop player swap
    Given I am viewing my roster
    When I drag "Tyreek Hill" from WR1 to FLEX
    And I drag "A.J. Brown" from FLEX to WR1
    Then the positions should swap
    And both players should be in their new positions

  @validation @swaps
  Scenario: Cannot swap locked player
    Given "Patrick Mahomes" is locked (game in progress)
    And "Josh Allen" is unlocked
    When I attempt to swap them
    Then I should see "Cannot swap - Patrick Mahomes is locked"

  @happy-path @swaps
  Scenario: Quick swap suggestion
    Given "Derrick Henry" is injured and in my lineup
    And "Najee Harris" is healthy on my bench
    When I view the injury alert for "Derrick Henry"
    Then I should see "Swap with Najee Harris?" option
    And clicking it should perform the swap

  # ============================================================================
  # EMPTY ROSTER SLOTS
  # ============================================================================

  @validation @empty-slots
  Scenario: Alert for empty starting lineup slots
    Given I have an empty RB2 starting slot
    When I view my lineup
    Then I should see a warning indicator on the empty slot
    And I should see "No player selected" in the RB2 position

  @happy-path @empty-slots
  Scenario: Fill empty slot from bench
    Given I have an empty WR2 starting slot
    And I have WRs on my bench
    When I click on the empty WR2 slot
    Then I should see a list of eligible bench WRs
    And I should be able to select one to start

  @validation @empty-slots
  Scenario: Warning before game with empty slots
    Given I have empty starting slots
    And games start in 1 hour
    When the pregame notification is sent
    Then I should receive an alert about empty lineup slots
    And I should see which positions are empty

  @validation @empty-slots
  Scenario: Cannot have empty required positions at deadline
    Given the league requires all positions filled
    And I have an empty FLEX slot
    When the lineup deadline approaches
    Then I should receive repeated warnings
    And the system should auto-fill if I don't respond

  @happy-path @empty-slots
  Scenario: View waiver recommendations for empty slots
    Given I have an empty TE slot on my roster
    When I view the empty slot
    Then I should see top available TEs on waivers
    And I should be able to initiate a waiver claim

  # ============================================================================
  # ROSTER NOTIFICATIONS
  # ============================================================================

  @happy-path @notifications
  Scenario: Receive injury update notification
    Given "Derrick Henry" is on my roster
    And "Derrick Henry" injury status changes to "Doubtful"
    When the status update is published
    Then I should receive a notification about the injury
    And the notification should suggest bench alternatives

  @happy-path @notifications
  Scenario: Receive lineup lock reminder
    Given my lineup has empty slots
    And the deadline is in 1 hour
    When the reminder is triggered
    Then I should receive a push notification
    And the notification should link to my lineup

  @happy-path @notifications
  Scenario: Receive bye week reminder
    Given Week 7 is approaching
    And I have 3 players on bye in Week 7
    When the week begins
    Then I should receive a bye week notification
    And it should list affected players

  @happy-path @notifications
  Scenario: Configure roster notification preferences
    When I view notification settings
    Then I should be able to toggle:
      | Notification Type        | Enabled |
      | Injury Updates           | Yes     |
      | Lineup Lock Reminders    | Yes     |
      | Bye Week Alerts          | Yes     |
      | Player News              | Yes     |
      | Roster Move Confirmations| Yes     |

  @happy-path @notifications
  Scenario: Receive notification when player is dropped
    Given "Backup QB" was dropped by another team
    And "Backup QB" was on my watch list
    When the drop is processed
    Then I should receive a notification
    And I should be able to submit a waiver claim

  @happy-path @notifications
  Scenario: Game-day lineup confirmation notification
    Given it's game day
    And my lineup is set
    When I enable game-day confirmations
    Then I should receive a notification 2 hours before first game
    And I should confirm or modify my lineup

  # ============================================================================
  # MOBILE / RESPONSIVE
  # ============================================================================

  @mobile @responsive
  Scenario: Manage lineup on mobile device
    Given I am using a mobile device
    When I view my roster
    Then I should see a mobile-optimized layout
    And I should be able to swipe to swap players
    And I should see clear position indicators

  @mobile @responsive
  Scenario: Quick lineup edit on mobile
    Given I am using a mobile device
    And I receive a push notification about an injury
    When I tap the notification
    Then I should go directly to my lineup
    And I should be able to quickly swap the injured player

  @mobile @responsive
  Scenario: Roster view adapts to screen size
    Given I am viewing my roster on a tablet
    When I rotate to landscape mode
    Then the roster layout should adapt
    And I should see starters and bench side by side

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility @a11y
  Scenario: Screen reader support for roster management
    Given I am using a screen reader
    When I navigate my roster
    Then all players should be announced with name and position
    And lineup status should be clearly communicated
    And locked/unlocked status should be announced

  @accessibility @a11y
  Scenario: Keyboard navigation for lineup setting
    Given I am using keyboard navigation
    When I set my lineup using only keyboard
    Then I should be able to tab through all positions
    And I should be able to select players with Enter key
    And focus should be clearly visible

  @accessibility @a11y
  Scenario: High contrast mode for roster view
    Given I have high contrast mode enabled
    When I view my roster
    Then all players should be clearly visible
    And locked/unlocked status should use distinct patterns
    And injury indicators should be clearly distinguishable

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error @resilience
  Scenario: Handle network error during lineup save
    Given I am saving my lineup
    And network connectivity is lost
    When the save fails
    Then I should see "Unable to save lineup - retrying..."
    And my changes should be preserved locally
    And the system should retry when connection is restored

  @error @resilience
  Scenario: Handle concurrent lineup edits
    Given I have my lineup open in two browser tabs
    When I make changes in both tabs simultaneously
    Then the first save should succeed
    And the second should show "Lineup was modified - please refresh"

  @error @resilience
  Scenario: Handle player data sync issues
    Given player data is temporarily unavailable
    When I view my roster
    Then I should see cached player data
    And I should see "Data may be outdated" warning
    And the system should sync when data becomes available

  @error @validation
  Scenario: Invalid lineup state recovery
    Given my lineup enters an invalid state
    When the system detects the issue
    Then I should be notified of the problem
    And I should be offered options to fix the lineup
    And the commissioner should be alerted if needed
