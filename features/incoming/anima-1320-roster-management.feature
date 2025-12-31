@roster-management @ANIMA-1320
Feature: Roster Management
  As a fantasy football team manager
  I want to manage my roster effectively
  So that I can optimize my team for each week's matchups

  Background:
    Given the fantasy football playoffs application is running
    And I am logged in as a team manager
    And I have an active team in a league

  # ============================================================================
  # LINEUP SETTING - HAPPY PATH
  # ============================================================================

  @happy-path @lineup
  Scenario: Set starting lineup for upcoming week
    Given I am viewing my roster page
    And the roster lock deadline has not passed
    When I drag a player from my bench to a starting position
    Then the player should be moved to the starting lineup
    And my bench should show the vacancy
    And my projected points should update

  @happy-path @lineup
  Scenario: Swap players between starting positions
    Given I have two players at the same position
    And one is in my starting lineup and one is on my bench
    When I swap the two players
    Then the bench player should move to the starting position
    And the starting player should move to the bench
    And both changes should be saved automatically

  @happy-path @lineup
  Scenario: Set optimal lineup automatically
    Given I am viewing my roster page
    And I have multiple lineup options
    When I click "Set Optimal Lineup"
    Then the system should calculate the best lineup based on projections
    And my starting lineup should be updated accordingly
    And I should see a confirmation message

  @happy-path @lineup
  Scenario: View lineup for future weeks
    Given I am on my roster page
    When I select a future week from the week selector
    Then I should see my projected lineup for that week
    And I should be able to make changes for that week
    And bye week indicators should show correctly

  @happy-path @lineup
  Scenario: Quick-set lineup from mobile
    Given I am using the mobile app
    And I need to set my lineup quickly
    When I tap "Quick Set Lineup"
    Then the system should auto-fill optimal starters
    And I should see a summary of changes made
    And I can confirm or modify the selections

  # ============================================================================
  # POSITION ELIGIBILITY
  # ============================================================================

  @happy-path @position-eligibility
  Scenario: View player position eligibility
    Given I am viewing a player's details
    When I check their position eligibility
    Then I should see all positions they can fill
    And I should see their primary position highlighted
    And dual-eligible players should show multiple positions

  @happy-path @position-eligibility
  Scenario: Start player in eligible flex position
    Given I have a running back with RB/FLEX eligibility
    And my RB slots are full
    When I start the player in my FLEX position
    Then the player should be placed in FLEX successfully
    And my lineup should be valid

  @happy-path @position-eligibility
  Scenario: View position eligibility changes
    Given a player has had their position eligibility updated
    When I view my roster
    Then I should see a notification of the eligibility change
    And the player should show their new eligible positions
    And I should be able to use them in new positions

  @happy-path @position-eligibility
  Scenario: Handle tight end premium in TE/WR flex
    Given the league has a TE Premium flex position
    And I have a tight end on my bench
    When I start the tight end in the TE/WR flex
    Then the player should receive TE premium scoring
    And the position should show as filled correctly

  # ============================================================================
  # FLEX POSITIONS
  # ============================================================================

  @happy-path @flex
  Scenario: Start RB in standard flex position
    Given the league has a standard RB/WR/TE flex position
    And I have an extra running back
    When I place the RB in the flex position
    Then the flex position should be filled
    And my lineup should be valid

  @happy-path @flex
  Scenario: Start WR in standard flex position
    Given the league has a standard RB/WR/TE flex position
    And I have an extra wide receiver with high projections
    When I place the WR in the flex position
    Then the flex position should be filled
    And my projected points should update

  @happy-path @flex
  Scenario: Configure multiple flex positions
    Given the league has 2 flex positions
    And I have available players for both
    When I fill both flex positions
    Then both positions should show as filled
    And my starting lineup should be complete

  # ============================================================================
  # SUPERFLEX CONFIGURATIONS
  # ============================================================================

  @happy-path @superflex
  Scenario: Start QB in superflex position
    Given the league has a superflex position
    And I have a backup quarterback
    When I place the QB in the superflex position
    Then the superflex should be filled with the QB
    And my lineup should be valid

  @happy-path @superflex
  Scenario: Start non-QB in superflex position
    Given the league has a superflex position
    And I do not have a backup QB
    When I place a running back in the superflex
    Then the superflex should be filled with the RB
    And my lineup should show reduced projected points compared to using a QB

  @happy-path @superflex
  Scenario: View superflex recommendations
    Given the league has a superflex position
    When I view superflex recommendations
    Then I should see ranked options for the superflex spot
    And QBs should typically rank higher due to point differential
    And I should see matchup analysis for each option

  @happy-path @superflex
  Scenario: Two-QB league roster management
    Given the league requires 2 starting QBs
    And I have 3 QBs on my roster
    When I set my lineup
    Then I must fill both QB positions
    And my third QB can go in superflex if available
    And the system should warn if I have QB bye week conflicts

  # ============================================================================
  # BYE WEEK MANAGEMENT
  # ============================================================================

  @happy-path @bye-week
  Scenario: View upcoming bye weeks for roster
    Given I am on my roster page
    When I click "View Bye Weeks"
    Then I should see a calendar view of all player bye weeks
    And weeks with multiple byes should be highlighted
    And I should see position coverage for each week

  @happy-path @bye-week
  Scenario: Receive bye week warning when setting lineup
    Given I have a player on bye this week
    And I try to start that player
    When I attempt to save my lineup
    Then I should receive a warning about the bye week player
    And I should be prompted to select an alternative
    And the bye week player should be highlighted

  @happy-path @bye-week
  Scenario: Auto-adjust lineup for bye weeks
    Given I have players on bye this week
    When I click "Auto-fill Bye Week Replacements"
    Then the system should suggest bench players to fill in
    And I should see the projected point difference
    And I can accept or modify the suggestions

  @happy-path @bye-week
  Scenario: Plan ahead for stacked bye week
    Given multiple starters have the same bye week
    And that week is approaching
    When I view my bye week planner
    Then I should see warnings about the stacked bye
    And I should see waiver wire suggestions
    And I should see trade recommendations

  # ============================================================================
  # ROSTER LOCKS
  # ============================================================================

  @happy-path @roster-lock
  Scenario: View roster lock deadline
    Given I am on my roster page
    When I check the roster lock information
    Then I should see the lock deadline date and time
    And I should see a countdown timer
    And I should see which positions lock and when

  @happy-path @roster-lock
  Scenario: Set lineup before roster lock
    Given the roster lock deadline is in 1 hour
    When I make changes to my starting lineup
    Then my changes should be saved successfully
    And I should see a confirmation of the save time
    And I should see remaining time until lock

  @happy-path @roster-lock
  Scenario: Receive roster lock reminder
    Given roster lock is approaching
    And I have an incomplete lineup
    When the 1-hour warning time is reached
    Then I should receive a notification
    And the notification should indicate empty positions
    And I should be able to set lineup from the notification

  @happy-path @roster-lock
  Scenario: Individual game roster locks
    Given the league uses individual game locks
    And I have a player in Thursday Night Football
    When Thursday's game kicks off
    Then only that player should be locked
    And I should still be able to adjust Sunday players
    And locked players should show a lock icon

  @happy-path @roster-lock
  Scenario: View locked players status
    Given some games have already started
    When I view my roster
    Then locked players should be clearly marked
    And I should see their live game stats
    And I should not be able to move locked players

  # ============================================================================
  # IR SLOTS
  # ============================================================================

  @happy-path @ir-slot
  Scenario: Move injured player to IR slot
    Given I have a player with IR designation
    And I have an available IR slot
    When I move the player to the IR slot
    Then the player should be placed on IR
    And my active roster slot should be freed
    And I should be able to add another player

  @happy-path @ir-slot
  Scenario: View IR-eligible players
    Given I have players with various injury statuses
    When I check IR eligibility
    Then I should see which players qualify for IR
    And I should see their injury designation
    And I should see expected return timeline if available

  @happy-path @ir-slot
  Scenario: Activate player from IR
    Given I have a player on IR who is now healthy
    When I activate the player from IR
    Then the player should move to my active roster
    And if my roster is full I should be prompted to drop someone
    And the IR slot should become available

  @happy-path @ir-slot
  Scenario: IR-plus slot for designated to return
    Given the league has IR+ slots
    And I have a player designated to return from IR
    When I place them in IR+ slot
    Then they should remain on IR+ while practicing
    And I should see their practice participation
    And I should receive alerts when they're activated

  @happy-path @ir-slot
  Scenario: Multiple IR slots management
    Given the league has 2 IR slots
    And I have 2 injured players
    When I move both to IR
    Then both IR slots should be filled
    And my active roster should have 2 free spots
    And I should see both players in the IR section

  # ============================================================================
  # BENCH MANAGEMENT
  # ============================================================================

  @happy-path @bench
  Scenario: View bench depth by position
    Given I am on my roster page
    When I view my bench
    Then I should see players organized by position
    And I should see each player's bye week
    And I should see their upcoming matchup

  @happy-path @bench
  Scenario: Sort bench players by various criteria
    Given I have multiple players on my bench
    When I sort by projected points
    Then players should be ordered by projections
    And I should be able to sort by other criteria
    And the sort preference should be saved

  @happy-path @bench
  Scenario: Identify droppable bench players
    Given I need to free up a roster spot
    When I view drop recommendations
    Then I should see players ranked by droppability
    And I should see their recent performance
    And I should see their remaining schedule strength

  @happy-path @bench
  Scenario: Bench player comparison
    Given I have multiple players at the same position on bench
    When I compare them
    Then I should see side-by-side statistics
    And I should see upcoming schedule comparison
    And I should see expert rankings for each

  # ============================================================================
  # ROSTER LIMITS
  # ============================================================================

  @happy-path @roster-limits
  Scenario: View current roster against limits
    Given the league has roster size limits
    When I view my roster
    Then I should see my current count vs maximum
    And I should see position-specific limits if applicable
    And I should see available roster spots

  @happy-path @roster-limits
  Scenario: Enforce maximum roster size
    Given my roster is at maximum capacity
    When I try to add a new player
    Then I should be required to drop a player first
    And I should see which players are droppable
    And the add should only complete after a drop

  @happy-path @roster-limits
  Scenario: Position limits enforcement
    Given the league limits QBs to 3 per roster
    And I already have 3 QBs
    When I try to add a 4th QB
    Then I should be blocked from adding
    And I should see the position limit message
    And I should be offered to drop a QB first

  @happy-path @roster-limits
  Scenario: Minimum roster requirements
    Given the league requires minimum players per position
    When I try to drop my only kicker
    Then I should be warned about minimum requirements
    And the drop should be blocked
    And I should see options to add a replacement first

  # ============================================================================
  # STARTING LINEUP REQUIREMENTS
  # ============================================================================

  @happy-path @lineup-requirements
  Scenario: View starting lineup requirements
    Given I am setting my lineup
    When I check lineup requirements
    Then I should see all required positions
    And I should see which are filled vs empty
    And I should see optional positions like flex

  @happy-path @lineup-requirements
  Scenario: Validate complete lineup
    Given I have filled all required positions
    When I validate my lineup
    Then the system should confirm lineup is valid
    And I should see total projected points
    And I should receive confirmation of submission

  @happy-path @lineup-requirements
  Scenario: Incomplete lineup warning
    Given I have empty required positions
    When I try to finalize my lineup
    Then I should receive a warning about empty positions
    And the empty positions should be highlighted
    And I should be prompted to fill them

  @happy-path @lineup-requirements
  Scenario: League-specific position requirements
    Given the league has custom position requirements
    And it requires 2 RBs, 3 WRs, and 2 FLEX
    When I view my lineup slots
    Then I should see the correct number of each position
    And I should be able to fill each appropriately
    And the requirements should be enforced

  # ============================================================================
  # TAXI SQUADS
  # ============================================================================

  @happy-path @taxi-squad
  Scenario: View taxi squad roster
    Given the league has taxi squad slots
    When I view my taxi squad
    Then I should see all players on taxi squad
    And I should see their rookie status
    And I should see eligibility to be promoted

  @happy-path @taxi-squad
  Scenario: Add rookie to taxi squad
    Given I have a rookie player
    And I have an available taxi squad slot
    When I move the rookie to taxi squad
    Then the player should be placed on taxi squad
    And they should not count against active roster
    And I should see their development stats

  @happy-path @taxi-squad
  Scenario: Promote player from taxi squad
    Given I have a player on taxi squad
    And they have exceeded taxi squad eligibility
    When I promote them to active roster
    Then they should move to my active roster
    And the taxi squad slot should open
    And they should be eligible to start

  @happy-path @taxi-squad
  Scenario: Taxi squad protection rules
    Given a player is on my taxi squad
    When another manager tries to claim them
    Then I should receive a notification
    And I should have 24 hours to promote or release
    And the claiming manager should wait for my decision

  @happy-path @taxi-squad
  Scenario: Taxi squad eligibility expiration
    Given a taxi squad player is in their second year
    And the league allows only rookies on taxi squad
    When the eligibility period ends
    Then I should receive a notification to promote or cut
    And the player should be flagged for action
    And I should have a deadline to decide

  # ============================================================================
  # PRACTICE SQUADS
  # ============================================================================

  @happy-path @practice-squad
  Scenario: View practice squad
    Given the league has practice squad functionality
    When I view my practice squad
    Then I should see all practice squad players
    And I should see their development status
    And I should see promotion eligibility

  @happy-path @practice-squad
  Scenario: Sign player to practice squad
    Given I have an available practice squad slot
    And there are available free agents
    When I sign a player to my practice squad
    Then the player should be added to practice squad
    And they should not count against roster limit
    And other teams should not be able to claim them

  @happy-path @practice-squad
  Scenario: Promote from practice squad to active roster
    Given I have a player on practice squad
    And I have roster space available
    When I promote the player
    Then they should move to active roster
    And they should be eligible to play
    And the practice squad spot should open

  @happy-path @practice-squad
  Scenario: Practice squad poaching rules
    Given another team has a player on practice squad
    And the league allows practice squad poaching
    When I attempt to sign that player to my active roster
    Then I should be able to add them directly to my roster
    And the original team should be notified
    And the player should be removed from their practice squad

  # ============================================================================
  # ROSTER DEADLINES
  # ============================================================================

  @happy-path @roster-deadline
  Scenario: View all roster deadlines
    Given I am managing my team
    When I view roster deadlines
    Then I should see the weekly lineup deadline
    And I should see trade deadline if applicable
    And I should see waiver processing times

  @happy-path @roster-deadline
  Scenario: Receive deadline reminders
    Given a roster deadline is approaching
    When the reminder threshold is reached
    Then I should receive a notification
    And the notification should specify which deadline
    And I should be able to take action from notification

  @happy-path @roster-deadline
  Scenario: Handle deadline timezone display
    Given I am in a different timezone than the league default
    When I view deadlines
    Then times should be displayed in my local timezone
    And I should see the timezone indicator
    And countdowns should be accurate to my time

  @happy-path @roster-deadline
  Scenario: Emergency roster exception request
    Given the roster deadline has passed
    And I have an emergency situation
    When I request a deadline exception from the commissioner
    Then the commissioner should receive my request
    And they should be able to approve or deny
    And approved changes should be logged

  # ============================================================================
  # LEAGUE ROSTER SETTINGS CONFIGURATION
  # ============================================================================

  @happy-path @roster-settings @commissioner
  Scenario: Configure roster size limits
    Given I am the league commissioner
    When I access roster settings
    Then I should be able to set maximum roster size
    And I should be able to set position-specific limits
    And changes should apply to all teams

  @happy-path @roster-settings @commissioner
  Scenario: Configure starting lineup positions
    Given I am the league commissioner
    When I configure starting lineup requirements
    Then I should be able to add or remove position slots
    And I should be able to configure flex position eligibility
    And I should see how it affects all teams

  @happy-path @roster-settings @commissioner
  Scenario: Configure IR slot settings
    Given I am the league commissioner
    When I configure IR settings
    Then I should be able to set number of IR slots
    And I should be able to set IR eligibility requirements
    And I should be able to enable IR+ for designated to return

  @happy-path @roster-settings @commissioner
  Scenario: Configure taxi squad rules
    Given I am the league commissioner
    When I configure taxi squad settings
    Then I should be able to enable or disable taxi squads
    And I should be able to set squad size
    And I should be able to set eligibility duration

  @happy-path @roster-settings @commissioner
  Scenario: Configure roster lock settings
    Given I am the league commissioner
    When I configure roster lock settings
    Then I should be able to choose between game-time and weekly locks
    And I should be able to set the lock timing
    And I should be able to set exceptions

  # ============================================================================
  # PLAYER ADDS AND DROPS
  # ============================================================================

  @happy-path @add-drop
  Scenario: Add free agent to roster
    Given I have available roster space
    And there is a player available as free agent
    When I add the free agent
    Then the player should be added to my roster
    And my roster count should increase
    And I should see the player on my team

  @happy-path @add-drop
  Scenario: Drop player from roster
    Given I have a player I want to release
    When I drop the player
    Then the player should be removed from my roster
    And they should become a free agent
    And my roster spot should be freed

  @happy-path @add-drop
  Scenario: Add player while dropping another
    Given my roster is full
    And I want to add a free agent
    When I select add and drop together
    Then I should be able to specify who to drop
    And both transactions should process together
    And my roster should remain at maximum

  @happy-path @add-drop
  Scenario: View transaction history
    Given I have made roster moves
    When I view my transaction history
    Then I should see all adds and drops
    And I should see dates and times
    And I should see any associated waiver costs

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Attempt to start ineligible player at position
    Given I have a quarterback
    When I try to start them at running back position
    Then the move should be rejected
    And I should see an eligibility error message
    And the player should remain in their original spot

  @error
  Scenario: Attempt to exceed roster limit
    Given my roster is at maximum capacity
    When I try to add a player without dropping
    Then the add should be blocked
    And I should see a roster limit error
    And I should be prompted to drop a player first

  @error
  Scenario: Attempt to modify locked roster
    Given my roster is locked for the current week
    When I try to make lineup changes
    Then the changes should be blocked
    And I should see a roster lock message
    And I should see when changes are allowed again

  @error
  Scenario: Attempt to move non-IR eligible player to IR
    Given I have a healthy player
    When I try to move them to an IR slot
    Then the move should be rejected
    And I should see IR eligibility requirements
    And the player should remain in active roster

  @error
  Scenario: Attempt to drop player in starting lineup
    Given I have a player in my starting lineup
    And roster lock has not passed
    When I try to drop that player
    Then I should see a warning about dropping a starter
    And I should confirm the action
    And if confirmed the lineup position should become empty

  @error
  Scenario: Network error while saving lineup
    Given I am making lineup changes
    When a network error occurs during save
    Then I should see an error notification
    And my pending changes should be preserved
    And I should be able to retry the save

  @error
  Scenario: Invalid roster configuration
    Given my roster becomes invalid due to position changes
    When I view my roster
    Then I should see an invalid roster warning
    And I should see which positions are affected
    And I should be guided to fix the issues

  @error
  Scenario: Concurrent roster modification conflict
    Given I am editing my roster
    And another session makes changes
    When I try to save my changes
    Then I should be notified of the conflict
    And I should see the competing changes
    And I should choose how to resolve

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: Manage roster on mobile device
    Given I am using the mobile app
    When I access my roster
    Then I should see a mobile-optimized layout
    And I should be able to drag and drop players
    And all roster functions should be accessible

  @mobile
  Scenario: Swipe to move players on mobile
    Given I am viewing my roster on mobile
    When I swipe on a bench player
    Then I should see quick action options
    And I can start, drop, or view details
    And the interface should be touch-friendly

  @mobile
  Scenario: Receive push notification for roster lock
    Given I have push notifications enabled
    And roster lock is approaching
    When the warning time is reached
    Then I should receive a push notification
    And tapping it should open my roster
    And I should be able to set lineup quickly

  @mobile
  Scenario: Mobile lineup optimization
    Given I am on mobile with limited time
    When I tap "Optimize Lineup"
    Then the best lineup should be calculated
    And I should see a quick summary
    And I can confirm with one tap

  @mobile
  Scenario: View roster in landscape mode
    Given I am using a mobile device
    When I rotate to landscape
    Then the roster view should adapt
    And I should see more player information
    And all controls should remain accessible

  # ============================================================================
  # ROSTER ASSISTANT AND RECOMMENDATIONS
  # ============================================================================

  @happy-path @roster-assistant
  Scenario: Get lineup recommendations
    Given I am setting my lineup
    When I request lineup advice
    Then I should see recommended starters
    And I should see the reasoning for each choice
    And I should see confidence levels

  @happy-path @roster-assistant
  Scenario: Receive start/sit notifications
    Given I have push notifications enabled
    And game day is approaching
    When late-breaking news affects my players
    Then I should receive a notification
    And the notification should include recommendations
    And I should be able to act quickly

  @happy-path @roster-assistant
  Scenario: View roster strength analysis
    Given I want to analyze my roster
    When I view roster strength
    Then I should see position-by-position analysis
    And I should see comparison to league average
    And I should see areas for improvement

  @happy-path @roster-assistant
  Scenario: Get trade suggestions for roster improvement
    Given my roster has weaknesses
    When I view trade suggestions
    Then I should see potential trade targets
    And I should see fair value trade packages
    And I should see how trades would improve my team

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate roster with keyboard
    Given I am using keyboard navigation
    When I navigate through the roster page
    Then I should be able to tab through all elements
    And I should be able to move players with keyboard
    And focus indicators should be visible

  @accessibility
  Scenario: Screen reader roster management
    Given I am using a screen reader
    When I manage my roster
    Then all elements should have proper labels
    And player positions should be announced
    And lineup status should be communicated

  @accessibility
  Scenario: High contrast roster view
    Given I have high contrast mode enabled
    When I view my roster
    Then colors should have sufficient contrast
    And position indicators should be distinguishable
    And locked players should be clearly marked

  @accessibility
  Scenario: Roster management with voice control
    Given I am using voice control
    When I issue roster commands
    Then I should be able to start and bench players
    And I should be able to navigate positions
    And confirmations should be voice-accessible
