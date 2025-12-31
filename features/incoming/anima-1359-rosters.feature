@rosters @anima-1359
Feature: Rosters
  As a fantasy football manager
  I want to manage my team roster
  So that I can optimize my lineup and roster composition for maximum points

  Background:
    Given I am a logged-in user
    And I have at least one fantasy team
    And the current fantasy season is active

  # ============================================================================
  # ROSTER DISPLAY
  # ============================================================================

  @happy-path @roster-display
  Scenario: View current roster
    Given I am on the team management page
    When I navigate to the roster section
    Then I should see all players on my roster
    And each player should display their name, position, and team
    And I should see player status indicators

  @happy-path @roster-display
  Scenario: View roster by position groups
    Given I am viewing my roster
    When I select position group view
    Then I should see players organized by position
    And quarterbacks should be grouped together
    And running backs should be grouped together
    And wide receivers should be grouped together
    And tight ends should be grouped together
    And defensive players should be grouped together
    And kickers should be grouped together

  @happy-path @roster-display
  Scenario: View roster with player photos
    Given I am viewing my roster
    Then each player should display their headshot photo
    And photos should have appropriate fallback images

  @happy-path @roster-display
  Scenario: View roster with injury status
    Given I am viewing my roster
    And some players have injury designations
    Then I should see injury status indicators
    And injured players should show their designation
    And I should see expected return timeframes when available

  @happy-path @roster-display
  Scenario: View roster with bye week indicators
    Given I am viewing my roster
    When players have upcoming bye weeks
    Then I should see bye week warnings
    And players on bye this week should be highlighted

  @happy-path @roster-display
  Scenario: View roster slot information
    Given I am viewing my roster
    Then I should see all available roster slots
    And I should see which slots are filled
    And I should see which slots are empty

  @happy-path @roster-display
  Scenario: View roster with projected points
    Given I am viewing my roster
    Then each player should display projected points
    And projections should update based on matchups

  @mobile @roster-display
  Scenario: View roster on mobile device
    Given I am viewing my roster on a mobile device
    Then the roster should display in mobile-optimized format
    And I should be able to scroll through players
    And player cards should be touch-friendly

  @accessibility @roster-display
  Scenario: Navigate roster with screen reader
    Given I am using a screen reader
    When I navigate to my roster
    Then all player information should be announced
    And position groups should be properly labeled

  @error @roster-display
  Scenario: Handle roster loading failure
    Given I am on the team management page
    When the roster fails to load
    Then I should see an error message
    And I should have option to retry loading

  # ============================================================================
  # LINEUP MANAGEMENT
  # ============================================================================

  @happy-path @lineup
  Scenario: Set starting lineup
    Given I am viewing my roster
    When I move a player to a starting position
    Then the player should appear in the starting lineup
    And the previous player in that slot should move to bench

  @happy-path @lineup
  Scenario: Bench a starting player
    Given I have a player in my starting lineup
    When I move them to the bench
    Then the player should appear on the bench
    And the starting slot should become empty

  @happy-path @lineup
  Scenario: Use drag and drop for lineup changes
    Given I am viewing my roster
    When I drag a bench player to a starting slot
    Then the player should be placed in that slot
    And the UI should update immediately

  @happy-path @lineup
  Scenario: Swap two starting players
    Given I have two players at the same position
    When I swap their lineup positions
    Then the players should exchange positions
    And lineup projections should update

  @happy-path @lineup
  Scenario: Auto-optimize lineup
    Given I am viewing my roster
    When I select auto-optimize lineup
    Then the system should set optimal starters
    And optimizations should be based on projections

  @happy-path @lineup
  Scenario: Lock lineup for the week
    Given I have set my starting lineup
    When I lock my lineup
    Then the lineup should be marked as locked
    And I should see confirmation of the lock

  @happy-path @lineup
  Scenario: Unlock previously locked lineup
    Given my lineup is locked
    When I unlock the lineup before the deadline
    Then I should be able to make changes again

  @happy-path @lineup
  Scenario: View lineup deadline countdown
    Given I am viewing my roster
    Then I should see time remaining until lineup locks
    And the countdown should update in real-time

  @error @lineup
  Scenario: Attempt to change locked lineup
    Given my lineup is locked for the week
    When I try to make a lineup change
    Then I should see a message that lineup is locked
    And no changes should be allowed

  @error @lineup
  Scenario: Attempt to start ineligible player
    Given I have a player who is out or on IR
    When I try to start that player
    Then I should see a warning about player status
    And I should be prompted to confirm or cancel

  @error @lineup
  Scenario: Attempt to overfill position slot
    Given all slots for a position are filled
    When I try to add another player to that position
    Then I should see an error message
    And I should be prompted to bench a current starter

  # ============================================================================
  # ROSTER POSITIONS
  # ============================================================================

  @happy-path @positions
  Scenario: View available roster positions
    Given I am viewing my roster
    Then I should see all position slots available
    And slots should include QB, RB, WR, TE, K, DEF
    And flex positions should be clearly indicated

  @happy-path @positions
  Scenario: Use flex position for RB
    Given I have an open flex position
    When I assign a running back to flex
    Then the RB should appear in the flex slot
    And the player should be eligible for that position

  @happy-path @positions
  Scenario: Use flex position for WR
    Given I have an open flex position
    When I assign a wide receiver to flex
    Then the WR should appear in the flex slot

  @happy-path @positions
  Scenario: Use flex position for TE
    Given I have an open flex position
    When I assign a tight end to flex
    Then the TE should appear in the flex slot

  @happy-path @positions
  Scenario: View superflex position options
    Given my league uses superflex positions
    When I view the superflex slot
    Then I should see all eligible positions
    And quarterbacks should be eligible for superflex

  @happy-path @positions
  Scenario: View IDP position slots
    Given my league uses individual defensive players
    When I view my roster
    Then I should see IDP position slots
    And defensive players should be assignable

  @error @positions
  Scenario: Attempt to assign player to wrong position
    Given I have a quarterback
    When I try to assign them to a running back slot
    Then I should see an error message
    And the assignment should be rejected

  @error @positions
  Scenario: Attempt to use ineligible player in flex
    Given I have a kicker on my roster
    When I try to assign them to flex position
    Then I should see an error message
    And kickers should not be flex-eligible

  # ============================================================================
  # ROSTER MOVES
  # ============================================================================

  @happy-path @roster-moves
  Scenario: Add player from free agency
    Given a player is available as a free agent
    When I add them to my roster
    Then the player should appear on my roster
    And my roster count should increase

  @happy-path @roster-moves
  Scenario: Drop player from roster
    Given I have a player on my roster
    When I drop that player
    Then the player should be removed from my roster
    And my roster count should decrease
    And the player should become a free agent

  @happy-path @roster-moves
  Scenario: Add and drop in single transaction
    Given my roster is at maximum capacity
    When I add a free agent and drop a rostered player
    Then the new player should be on my roster
    And the dropped player should be removed
    And my roster count should remain the same

  @happy-path @roster-moves
  Scenario: View available roster moves
    Given I am viewing my roster
    When I check available transactions
    Then I should see add and drop options
    And I should see trade options

  @happy-path @roster-moves
  Scenario: Submit waiver claim
    Given a player was recently dropped
    When I submit a waiver claim
    Then the claim should be recorded
    And I should see confirmation of my claim

  @happy-path @roster-moves
  Scenario: Cancel pending waiver claim
    Given I have a pending waiver claim
    When I cancel the claim
    Then the claim should be removed
    And I should see confirmation of cancellation

  @happy-path @roster-moves
  Scenario: View roster move history
    Given I have made roster transactions
    When I view my transaction history
    Then I should see all adds, drops, and trades
    And transactions should show dates and details

  @error @roster-moves
  Scenario: Attempt to exceed roster limit
    Given my roster is at maximum capacity
    When I try to add a player without dropping one
    Then I should see an error message
    And I should be prompted to drop a player

  @error @roster-moves
  Scenario: Attempt to drop player during game
    Given a player's game has started
    When I try to drop that player
    Then I should see an error message
    And the drop should be blocked until game ends

  @commissioner @roster-moves
  Scenario: Commissioner force roster move
    Given I am a league commissioner
    When I force a roster move for a team
    Then the move should be executed immediately
    And the team owner should be notified

  # ============================================================================
  # IR MANAGEMENT
  # ============================================================================

  @happy-path @ir-management
  Scenario: Place player on IR
    Given I have a player with IR-eligible status
    When I move them to IR slot
    Then the player should be placed on IR
    And an IR slot should become occupied

  @happy-path @ir-management
  Scenario: View IR-eligible players
    Given I am viewing my roster
    When I check IR eligibility
    Then I should see which players can be placed on IR
    And eligibility should be based on injury status

  @happy-path @ir-management
  Scenario: Activate player from IR
    Given I have a player on IR who is now healthy
    When I activate them from IR
    Then the player should return to active roster
    And the IR slot should become available

  @happy-path @ir-management
  Scenario: View IR slot capacity
    Given I am viewing my roster
    Then I should see how many IR slots are available
    And I should see which IR slots are occupied

  @happy-path @ir-management
  Scenario: Add player while roster is over limit due to IR
    Given I have a player on IR who is now healthy
    And my roster exceeds normal limits
    Then I should be blocked from adding new players
    And I should see a message to resolve IR situation

  @error @ir-management
  Scenario: Attempt to place healthy player on IR
    Given I have a healthy player
    When I try to place them on IR
    Then I should see an error message
    And the move should be rejected

  @error @ir-management
  Scenario: Exceed IR slot limit
    Given all IR slots are filled
    When I try to place another player on IR
    Then I should see an error message
    And I should be prompted to activate an IR player

  @error @ir-management
  Scenario: Make transaction with illegal IR usage
    Given I have an IR-ineligible player on IR
    When I try to make a roster transaction
    Then I should see an error message
    And I must resolve IR before making moves

  # ============================================================================
  # ROSTER ALERTS
  # ============================================================================

  @happy-path @roster-alerts
  Scenario: Receive bye week alert
    Given I have multiple players on bye this week
    When I view my roster
    Then I should see a bye week alert
    And the alert should list affected positions

  @happy-path @roster-alerts
  Scenario: Receive injury alert
    Given a player on my roster becomes injured
    Then I should receive an injury notification
    And the notification should include injury details

  @happy-path @roster-alerts
  Scenario: Receive lineup deadline reminder
    Given lineup lock is approaching
    And my lineup has empty slots or issues
    Then I should receive a deadline reminder
    And the reminder should highlight issues

  @happy-path @roster-alerts
  Scenario: Receive roster limit warning
    Given my roster is approaching maximum capacity
    Then I should see a roster limit warning
    And the warning should show available spots

  @happy-path @roster-alerts
  Scenario: Configure roster alert preferences
    Given I am in settings
    When I configure roster alert preferences
    Then I should be able to enable/disable alert types
    And I should be able to set notification timing

  @happy-path @roster-alerts
  Scenario: Receive player status change alert
    Given a player's status changes
    When the status affects lineup eligibility
    Then I should receive a status change alert

  @happy-path @roster-alerts
  Scenario: View all active roster alerts
    Given I have multiple roster alerts
    When I view the alerts summary
    Then I should see all active alerts
    And alerts should be prioritized by urgency

  @mobile @roster-alerts
  Scenario: Receive push notification for roster alert
    Given I have push notifications enabled
    When a critical roster alert is triggered
    Then I should receive a push notification

  @error @roster-alerts
  Scenario: Handle alert delivery failure
    Given an alert fails to deliver
    Then the system should retry delivery
    And the alert should be logged for later viewing

  # ============================================================================
  # ROSTER ANALYSIS
  # ============================================================================

  @happy-path @roster-analysis
  Scenario: View roster strength analysis
    Given I am viewing my roster
    When I access roster analysis
    Then I should see overall roster strength rating
    And I should see strength by position

  @happy-path @roster-analysis
  Scenario: View roster weaknesses
    Given I am viewing roster analysis
    Then I should see identified weaknesses
    And recommendations should address weak spots

  @happy-path @roster-analysis
  Scenario: Compare roster to league average
    Given I am viewing roster analysis
    When I compare to league average
    Then I should see how my roster stacks up
    And comparisons should be position-by-position

  @happy-path @roster-analysis
  Scenario: View roster depth chart
    Given I am viewing roster analysis
    When I check roster depth
    Then I should see depth at each position
    And depth concerns should be highlighted

  @happy-path @roster-analysis
  Scenario: View schedule-based analysis
    Given I am viewing roster analysis
    When I view schedule analysis
    Then I should see upcoming matchup difficulty
    And bye weeks should be factored in

  @happy-path @roster-analysis
  Scenario: View trade value summary
    Given I am viewing roster analysis
    Then I should see trade values for my players
    And I should see suggested trade targets

  @happy-path @roster-analysis
  Scenario: View roster balance metrics
    Given I am viewing roster analysis
    Then I should see roster balance assessment
    And the analysis should show position allocation

  @happy-path @roster-analysis
  Scenario: Export roster analysis report
    Given I am viewing roster analysis
    When I export the analysis
    Then I should receive a downloadable report
    And the report should include all analysis data

  @accessibility @roster-analysis
  Scenario: View roster analysis with screen reader
    Given I am using a screen reader
    When I access roster analysis
    Then all metrics should be properly announced
    And charts should have text alternatives

  # ============================================================================
  # ROSTER HISTORY
  # ============================================================================

  @happy-path @roster-history
  Scenario: View roster transaction history
    Given I have made roster transactions
    When I view roster history
    Then I should see all transactions
    And transactions should be in chronological order

  @happy-path @roster-history
  Scenario: Filter roster history by transaction type
    Given I am viewing roster history
    When I filter by adds only
    Then I should see only add transactions
    And other transaction types should be hidden

  @happy-path @roster-history
  Scenario: View roster history by date range
    Given I am viewing roster history
    When I select a date range
    Then I should see transactions within that range

  @happy-path @roster-history
  Scenario: View roster snapshot from past week
    Given I am viewing roster history
    When I select a specific past week
    Then I should see my roster as it was that week
    And I should see who was starting

  @happy-path @roster-history
  Scenario: View player acquisition history
    Given I am viewing a specific player
    When I check their acquisition history
    Then I should see when I acquired them
    And I should see the acquisition method

  @happy-path @roster-history
  Scenario: Export roster history
    Given I am viewing roster history
    When I export the history
    Then I should receive a downloadable file
    And the file should contain all transaction data

  @happy-path @roster-history
  Scenario: View league-wide transaction history
    Given I am viewing roster history
    When I select league view
    Then I should see all league transactions
    And transactions should show team names

  # ============================================================================
  # ROSTER COMPARISON
  # ============================================================================

  @happy-path @roster-comparison
  Scenario: Compare roster to opponent
    Given I have an upcoming matchup
    When I compare rosters with my opponent
    Then I should see side-by-side comparison
    And advantages should be highlighted

  @happy-path @roster-comparison
  Scenario: Compare roster position by position
    Given I am comparing rosters
    Then I should see position-by-position breakdown
    And projected points should be compared

  @happy-path @roster-comparison
  Scenario: Compare roster to league leader
    Given I want to compare to top teams
    When I compare to the league leader
    Then I should see roster differences
    And I should see where I can improve

  @happy-path @roster-comparison
  Scenario: View roster comparison trends
    Given I am comparing rosters over time
    Then I should see how comparisons have changed
    And trends should show improvement or decline

  @happy-path @roster-comparison
  Scenario: Compare multiple rosters simultaneously
    Given I want to compare several teams
    When I select multiple teams to compare
    Then I should see multi-team comparison view
    And key metrics should be side by side

  @happy-path @roster-comparison
  Scenario: Share roster comparison
    Given I have completed a roster comparison
    When I share the comparison
    Then a shareable link should be generated
    And others should be able to view the comparison

  @mobile @roster-comparison
  Scenario: View roster comparison on mobile
    Given I am on a mobile device
    When I view roster comparison
    Then the comparison should be mobile-optimized
    And I should be able to swipe between rosters

  # ============================================================================
  # ROSTER SETTINGS
  # ============================================================================

  @happy-path @roster-settings
  Scenario: Configure default lineup order
    Given I am in roster settings
    When I set my preferred lineup order
    Then players should be sorted in that order

  @happy-path @roster-settings
  Scenario: Enable automatic lineup setting
    Given I am in roster settings
    When I enable auto-set lineup
    Then my lineup should be set automatically each week
    And the best projected players should start

  @happy-path @roster-settings
  Scenario: Configure IR management preferences
    Given I am in roster settings
    When I configure IR preferences
    Then I should set automatic IR notifications
    And I should set IR activation reminders

  @happy-path @roster-settings
  Scenario: Set roster alert preferences
    Given I am in roster settings
    When I configure alert preferences
    Then I should enable/disable specific alerts
    And I should set alert timing preferences

  @happy-path @roster-settings
  Scenario: Configure bye week alerts
    Given I am in roster settings
    When I set bye week alert preferences
    Then I should choose when to receive alerts
    And I should set alert threshold for multiple byes

  @happy-path @roster-settings
  Scenario: Export roster settings
    Given I am in roster settings
    When I export my settings
    Then I should receive a settings backup file

  @happy-path @roster-settings
  Scenario: Import roster settings
    Given I have a settings backup file
    When I import the settings
    Then my preferences should be restored
    And I should see confirmation of import

  @commissioner @roster-settings
  Scenario: Configure league roster settings
    Given I am a league commissioner
    When I access league roster settings
    Then I should be able to set roster limits
    And I should configure position requirements

  @commissioner @roster-settings
  Scenario: Configure IR slot rules
    Given I am a league commissioner
    When I configure IR settings
    Then I should set number of IR slots
    And I should set IR eligibility rules

  @commissioner @roster-settings
  Scenario: Set transaction limits
    Given I am a league commissioner
    When I set transaction limits
    Then I should configure weekly add/drop limits
    And limits should apply to all teams

  @error @roster-settings
  Scenario: Handle invalid setting value
    Given I am configuring roster settings
    When I enter an invalid value
    Then I should see a validation error
    And the setting should not be saved

  @error @roster-settings
  Scenario: Handle settings save failure
    Given I am saving roster settings
    When the save operation fails
    Then I should see an error message
    And I should be able to retry saving
