@waivers
Feature: Waivers
  As a fantasy football team owner
  I want to manage waiver wire claims and free agent pickups
  So that I can improve my roster throughout the season

  # Waiver Claims Scenarios
  @waiver-claims
  Scenario: Submit a waiver claim
    Given I am a team owner
    And a player is on waivers
    When I submit a waiver claim for that player
    And I select a player to drop
    Then my claim should be submitted
    And I should see confirmation of the claim
    And the claim should be pending until processing

  @waiver-claims
  Scenario: Claim a recently dropped player
    Given a player was recently dropped
    And the player is in waiver period
    When I submit a claim for the dropped player
    Then my claim should be queued
    And I should see the waiver clear time
    And I should be notified when processed

  @waiver-claims
  Scenario: Submit claim with priority position
    Given I have waiver priority
    When I submit a waiver claim
    Then my priority position should be recorded
    And my claim should be processed at my priority
    And I should see my current priority

  @waiver-claims
  Scenario: Submit multiple claims on same player
    Given multiple owners want the same player
    When each owner submits a claim
    Then all claims should be recorded
    And priority order should determine winner
    And losing claims should be cancelled

  @waiver-claims
  Scenario: Cancel pending waiver claim
    Given I have a pending waiver claim
    When I cancel the claim before processing
    Then the claim should be cancelled
    And my roster should remain unchanged
    And I should see cancellation confirmation

  @waiver-claims
  Scenario: Modify waiver claim before processing
    Given I have a pending waiver claim
    When I modify the player to drop
    Then the claim should be updated
    And new drop selection should be saved
    And modification should be logged

  @waiver-claims
  Scenario: Submit conditional waiver claim
    Given I want to claim a player only if another claim fails
    When I set up conditional claims
    Then claims should be prioritized
    And backup claims should process if primary fails
    And all conditions should be evaluated

  @waiver-claims
  Scenario: View all pending waiver claims
    Given I have submitted waiver claims
    When I view my pending claims
    Then I should see all active claims
    And I should see processing time for each
    And I should be able to manage claims

  # Waiver Order Scenarios
  @waiver-order
  Scenario: View waiver priority order
    Given the league uses waiver priority
    When I view the waiver order
    Then I should see all teams ranked
    And I should see my current position
    And order should reflect current standings

  @waiver-order
  Scenario: Waiver order by inverse standings
    Given the league uses inverse standings order
    When standings update
    Then waiver order should update inversely
    And last place should have first priority
    And first place should have last priority

  @waiver-order
  Scenario: Rolling waiver priority after claim
    Given the league uses rolling waivers
    When I successfully claim a player
    Then my priority should move to last
    And other teams should move up
    And new order should be visible

  @waiver-order
  Scenario: Reset waiver order
    Given I am a commissioner
    When I reset the waiver order
    Then order should reset to default
    And all teams should be notified
    And reset should be logged

  @waiver-order
  Scenario: Maintain waiver order after failed claim
    Given I submitted a waiver claim
    When the claim fails due to being outbid
    Then my waiver priority should not change
    And my position should remain the same
    And I should be notified of the outcome

  @waiver-order
  Scenario: View waiver order history
    Given waiver order has changed over time
    When I view waiver order history
    Then I should see historical order changes
    And I should see reasons for changes
    And timeline should be clear

  @waiver-order
  Scenario: Configure waiver order type
    Given I am a commissioner
    When I configure waiver order settings
    Then I should select order type
    And I should set reset frequency
    And settings should apply immediately

  @waiver-order
  Scenario: Handle tied waiver priority
    Given two teams have same priority
    When tie-breaking is needed
    Then configured tie-breaker should apply
    And resolution should be fair
    And tie-break method should be documented

  # Waiver Processing Scenarios
  @waiver-processing
  Scenario: Process waiver claims successfully
    Given waiver processing time has arrived
    And claims are pending
    When processing runs
    Then highest priority claims should succeed
    And rosters should be updated
    And all owners should be notified

  @waiver-processing
  Scenario: Handle successful waiver pickup
    Given my waiver claim is highest priority
    When processing completes
    Then claimed player should join my roster
    And dropped player should leave roster
    And transaction should be logged

  @waiver-processing
  Scenario: Handle failed waiver claim
    Given my waiver claim has lower priority
    When a higher priority claim exists
    Then my claim should fail
    And I should be notified of failure
    And I should see who claimed the player

  @waiver-processing
  Scenario: Apply tie-breaking rules
    Given multiple claims have same priority
    When tie-breaking is needed
    Then configured rules should apply
    And one claim should win
    And tie-break reason should be shown

  @waiver-processing
  Scenario: Process multiple claims in sequence
    Given I have prioritized multiple claims
    When processing runs
    Then claims should process in my order
    And successful claims should affect later ones
    And roster limits should be respected

  @waiver-processing
  Scenario: Handle processing errors gracefully
    Given waiver processing encounters an error
    When error occurs
    Then no partial processing should complete
    And claims should remain pending
    And commissioner should be notified

  @waiver-processing
  Scenario: View waiver processing results
    Given waiver processing has completed
    When I view results
    Then I should see all processed claims
    And I should see success and failure
    And details should be comprehensive

  @waiver-processing
  Scenario: Commissioner manually processes waivers
    Given I am a commissioner
    When I manually trigger processing
    Then waivers should process immediately
    And normal rules should apply
    And manual trigger should be logged

  # Waiver Periods Scenarios
  @waiver-periods
  Scenario: View waiver wire windows
    Given the league has waiver windows
    When I view waiver schedule
    Then I should see when waivers open
    And I should see when waivers close
    And current status should be clear

  @waiver-periods
  Scenario: Handle game-day waivers
    Given it is game day
    When I try to claim a playing player
    Then claim should be restricted appropriately
    And game-time rules should apply
    And clear message should explain restrictions

  @waiver-periods
  Scenario: Weekly waiver periods
    Given the league uses weekly waivers
    When the weekly period is active
    Then claims can be submitted
    And processing happens once per week
    And next processing time should display

  @waiver-periods
  Scenario: Continuous waivers
    Given the league uses continuous waivers
    When a player clears waivers
    Then player becomes free agent immediately
    And no waiting period exists
    And pickups are first-come first-served

  @waiver-periods
  Scenario: View time until waiver clears
    Given a player is on waivers
    When I view the player
    Then I should see countdown to clear
    And timezone should be correct
    And I should be able to set reminders

  @waiver-periods
  Scenario: Configure waiver period settings
    Given I am a commissioner
    When I configure waiver periods
    Then I should set period length
    And I should set processing times
    And settings should be validated

  @waiver-periods
  Scenario: Handle waiver period transitions
    Given waiver period is ending
    When period transitions
    Then pending claims should process
    And new period should begin
    And transition should be seamless

  @waiver-periods
  Scenario: Emergency waiver period changes
    Given unusual circumstances require changes
    When commissioner modifies periods
    Then changes should apply
    And league should be notified
    And reason should be documented

  # FAAB Bidding Scenarios
  @faab-bidding
  Scenario: Submit FAAB bid for player
    Given the league uses FAAB
    And I have available budget
    When I submit a bid for a player
    Then my bid amount should be recorded
    And my budget should be reserved
    And bid should be blind to others

  @faab-bidding
  Scenario: Manage FAAB budget
    Given I have a FAAB budget
    When I view my budget
    Then I should see remaining balance
    And I should see pending bids
    And I should see season spending

  @faab-bidding
  Scenario: Win FAAB bid
    Given I submitted the highest bid
    When bidding closes
    Then I should win the player
    And bid amount should be deducted
    And remaining budget should update

  @faab-bidding
  Scenario: Handle tied FAAB bids
    Given multiple teams bid same amount
    When tie-breaking is needed
    Then waiver priority should break tie
    And losing bidder keeps their budget
    And tie resolution should be logged

  @faab-bidding
  Scenario: Submit zero dollar bid
    Given I want to make a $0 bid
    When I submit the bid
    Then bid should be accepted if allowed
    And I should be at lowest priority
    And settings should govern $0 bids

  @faab-bidding
  Scenario: View FAAB bid history
    Given bids have been processed
    When I view bid history
    Then I should see all my bids
    And I should see winning bid amounts
    And I should see league spending trends

  @faab-bidding
  Scenario: Modify FAAB bid before processing
    Given I have a pending bid
    When I modify my bid amount
    Then new amount should be saved
    And original bid should be replaced
    And modification should be logged

  @faab-bidding
  Scenario: Transfer FAAB in trade
    Given FAAB can be traded
    When a trade includes FAAB
    Then budget should transfer
    And both teams should see updated balance
    And transfer should be logged

  # Waiver Settings Scenarios
  @waiver-settings
  Scenario: Configure league waiver system
    Given I am a commissioner
    When I access waiver settings
    Then I should configure waiver type
    And I should set processing schedule
    And settings should save correctly

  @waiver-settings
  Scenario: Select waiver type
    Given I am configuring waivers
    When I select waiver type
    Then options should include standard and FAAB
    And I should see type descriptions
    And selection should apply to league

  @waiver-settings
  Scenario: Set processing day and time
    Given I am configuring waivers
    When I set processing schedule
    Then I should select day of week
    And I should select time
    And timezone should be configurable

  @waiver-settings
  Scenario: Configure waiver period length
    Given I am configuring waivers
    When I set period length
    Then I should specify hours or days
    And minimum period should be enforced
    And changes should notify league

  @waiver-settings
  Scenario: Set FAAB budget amount
    Given league uses FAAB
    When I configure FAAB settings
    Then I should set season budget
    And I should set minimum bid
    And I should enable or disable $0 bids

  @waiver-settings
  Scenario: Configure playoff waiver rules
    Given playoffs are approaching
    When I set playoff waiver rules
    Then I should enable or disable playoff waivers
    And I should set special restrictions
    And rules should apply during playoffs

  @waiver-settings
  Scenario: View current waiver settings
    Given waiver settings are configured
    When I view settings
    Then all settings should be displayed
    And current values should be clear
    And I should understand the rules

  @waiver-settings
  Scenario: Reset waiver settings to default
    Given waiver settings have been customized
    When I reset to defaults
    Then settings should revert
    And I should confirm the reset
    And league should be notified

  # Waiver Restrictions Scenarios
  @waiver-restrictions
  Scenario: Enforce roster limits during claims
    Given my roster is at maximum
    When I submit a waiver claim
    Then I must drop a player
    And claim without drop should be blocked
    And limit should be clearly shown

  @waiver-restrictions
  Scenario: Enforce position requirements
    Given I need minimum players at a position
    When I try to drop my only player there
    Then drop should be restricted
    And position requirement should be shown
    And alternative options should be suggested

  @waiver-restrictions
  Scenario: Handle injured reserve rules
    Given I have IR slots available
    When I claim a player while IR-eligible
    Then IR move options should be shown
    And IR rules should be enforced
    And claim should proceed if valid

  @waiver-restrictions
  Scenario: Check claim eligibility
    Given a player might be ineligible
    When I try to claim them
    Then eligibility should be verified
    And ineligible claims should be blocked
    And reason should be explained

  @waiver-restrictions
  Scenario: Restrict claims during roster lock
    Given roster lock is active
    When I try to submit claim
    Then claim should be queued or blocked
    And lock status should be shown
    And unlock time should be displayed

  @waiver-restrictions
  Scenario: Enforce maximum acquisitions
    Given league limits acquisitions
    And I have reached the limit
    When I try to claim a player
    Then claim should be blocked
    And acquisition count should be shown
    And limit reset time should display

  @waiver-restrictions
  Scenario: Restrict claiming own dropped player
    Given I recently dropped a player
    When I try to claim them back
    Then restriction period should apply
    And I should see when I can claim
    And restriction should be fair

  @waiver-restrictions
  Scenario: Handle taxi squad restrictions
    Given league has taxi squads
    When waiver claims interact with taxi
    Then taxi rules should apply
    And eligible players should be identified
    And restrictions should be enforced

  # Waiver Notifications Scenarios
  @waiver-notifications
  Scenario: Receive claim confirmation
    Given I submit a waiver claim
    When claim is submitted
    Then I should receive confirmation
    And confirmation should show details
    And processing time should be included

  @waiver-notifications
  Scenario: Receive processing results notification
    Given waivers have processed
    When processing completes
    Then I should receive results notification
    And success or failure should be clear
    And next steps should be suggested

  @waiver-notifications
  Scenario: Receive outbid alert
    Given I was outbid on a FAAB claim
    When processing completes
    Then I should be notified of losing bid
    And winning bid amount should be shown
    And player should be identified

  @waiver-notifications
  Scenario: Receive waiver period reminders
    Given waiver period is ending soon
    When reminder is triggered
    Then I should receive reminder
    And time remaining should be clear
    And link to waivers should be included

  @waiver-notifications
  Scenario: Configure waiver notification preferences
    Given I am in notification settings
    When I configure waiver notifications
    Then I should toggle notification types
    And I should set notification methods
    And preferences should save immediately

  @waiver-notifications
  Scenario: Receive player available notification
    Given I set an alert for a player
    When that player becomes available
    Then I should be notified
    And player details should be included
    And quick claim link should be provided

  @waiver-notifications
  Scenario: Receive FAAB budget alerts
    Given my FAAB budget is low
    When budget falls below threshold
    Then I should receive alert
    And remaining budget should be shown
    And spending advice should be offered

  @waiver-notifications
  Scenario: Receive claim processed for watched player
    Given I am watching a player
    When someone claims that player
    Then I should be notified
    And claiming team should be shown
    And I should be able to stop watching

  # Waiver History Scenarios
  @waiver-history
  Scenario: View waiver transaction log
    Given waiver transactions have occurred
    When I view transaction log
    Then I should see all transactions
    And transactions should be sortable
    And details should be comprehensive

  @waiver-history
  Scenario: View personal bid history
    Given I have placed FAAB bids
    When I view my bid history
    Then I should see all my bids
    And I should see outcomes
    And spending total should display

  @waiver-history
  Scenario: Generate waiver activity report
    Given the season has waiver activity
    When I request activity report
    Then report should be generated
    And report should include all claims
    And report should be exportable

  @waiver-history
  Scenario: View season waiver statistics
    Given the season has progressed
    When I view waiver statistics
    Then I should see league-wide stats
    And I should see most active teams
    And I should see popular pickups

  @waiver-history
  Scenario: Search waiver history
    Given extensive waiver history exists
    When I search history
    Then I should find by player name
    And I should find by team
    And I should find by date range

  @waiver-history
  Scenario: Compare waiver spending
    Given teams have spent FAAB
    When I compare spending
    Then I should see all team spending
    And I should see spending efficiency
    And rankings should be visible

  @waiver-history
  Scenario: View waiver success rate
    Given I have made waiver claims
    When I view my success rate
    Then I should see claims won vs lost
    And I should see success percentage
    And trend over time should display

  @waiver-history
  Scenario: Export waiver history
    Given I want to export data
    When I request export
    Then export file should be generated
    And all history should be included
    And format should be selectable

  # Free Agent Pickups Scenarios
  @free-agent-pickups
  Scenario: Add free agent directly
    Given a player is a free agent
    And waivers have cleared
    When I add the free agent
    Then player should join my roster
    And transaction should be immediate
    And drop should be required if at limit

  @free-agent-pickups
  Scenario: Post-waiver free agent pickup
    Given waivers have processed
    And unclaimed players are available
    When I pick up a free agent
    Then pickup should process immediately
    And no waiver claim needed
    And roster should update instantly

  @free-agent-pickups
  Scenario: Instant acquisition
    Given league allows instant pickups
    When I acquire a free agent
    Then acquisition should be immediate
    And player should be on roster
    And I should be able to use player

  @free-agent-pickups
  Scenario: Respect pickup limits
    Given league has pickup limits
    And I have reached the limit
    When I try to pick up free agent
    Then pickup should be blocked
    And limit should be displayed
    And reset time should be shown

  @free-agent-pickups
  Scenario: View available free agents
    Given free agents are available
    When I browse free agents
    Then I should see all available players
    And I should see player stats
    And I should see ownership percentage

  @free-agent-pickups
  Scenario: Filter free agents by position
    Given I need a specific position
    When I filter by position
    Then only that position should show
    And filtering should be fast
    And I should see player count

  @free-agent-pickups
  Scenario: Sort free agents by various criteria
    Given I am viewing free agents
    When I sort by different criteria
    Then sorting should apply
    And I should sort by points, rank, or ownership
    And sort order should be toggleable

  @free-agent-pickups
  Scenario: Quick add from player card
    Given I am viewing a free agent
    When I use quick add button
    Then add flow should start
    And drop selection should appear if needed
    And transaction should complete quickly

  # Error Handling Scenarios
  @error-handling
  Scenario: Handle concurrent waiver claims
    Given multiple users claim same player simultaneously
    When claims are submitted
    Then all claims should be recorded
    And no duplicates should occur
    And priority should determine outcome

  @error-handling
  Scenario: Handle claim submission failure
    Given I am submitting a waiver claim
    When submission fails
    Then error should display
    And claim should not be partially saved
    And retry should be available

  @error-handling
  Scenario: Handle processing interruption
    Given waiver processing is running
    When processing is interrupted
    Then partial results should not commit
    And processing should be recoverable
    And commissioner should be notified

  @error-handling
  Scenario: Handle invalid drop selection
    Given I selected a player to drop
    When that player becomes ineligible
    Then claim should be flagged
    And I should be notified to update
    And original claim should be preserved

  @error-handling
  Scenario: Handle FAAB overdraft attempt
    Given my bid exceeds my budget
    When I try to submit
    Then bid should be blocked
    And budget limit should be shown
    And I should be able to adjust bid

  @error-handling
  Scenario: Handle waiver period confusion
    Given waiver periods have changed
    When user has outdated information
    Then current status should be clear
    And refresh should update information
    And confusion should be minimized

  @error-handling
  Scenario: Handle notification delivery failure
    Given waiver notification fails
    When delivery failure occurs
    Then retry should be attempted
    And in-app notification should be created
    And failure should be logged

  @error-handling
  Scenario: Recover from roster sync issues
    Given roster data is out of sync
    When waiver operations occur
    Then sync should be forced
    And operations should use current data
    And sync issues should be resolved

  # Accessibility Scenarios
  @accessibility
  Scenario: Navigate waivers with keyboard
    Given I am on the waivers page
    When I navigate using only keyboard
    Then all waiver functions should be accessible
    And claim submission should work
    And focus should be clearly visible

  @accessibility
  Scenario: Screen reader announces waiver status
    Given I am using a screen reader
    When I view waiver information
    Then waiver periods should be announced
    And claim status should be stated
    And processing times should be clear

  @accessibility
  Scenario: High contrast waiver interface
    Given I have high contrast mode enabled
    When I view waivers
    Then all elements should be visible
    And status indicators should be distinguishable
    And bid inputs should be clear

  @accessibility
  Scenario: Accessible waiver claim form
    Given I am submitting a waiver claim
    When I fill out the claim form
    Then form labels should be accessible
    And errors should be announced
    And submission should be confirmable

  @accessibility
  Scenario: Free agent list is accessible
    Given I am browsing free agents
    When I navigate the list
    Then players should be navigable
    And stats should be announced
    And quick actions should be accessible

  @accessibility
  Scenario: FAAB bid input is accessible
    Given I am entering a FAAB bid
    When I input bid amount
    Then input should be properly labeled
    And budget remaining should be announced
    And validation should be accessible

  @accessibility
  Scenario: Waiver notifications are accessible
    Given I receive waiver notifications
    When notification arrives
    Then content should be announced
    And actions should be accessible
    And dismissal should be keyboard accessible

  @accessibility
  Scenario: Mobile waiver accessibility
    Given I am using mobile with accessibility features
    When I manage waivers
    Then all features should work
    And touch targets should be adequate
    And VoiceOver or TalkBack should work

  # Performance Scenarios
  @performance
  Scenario: Waiver page loads quickly
    Given I am accessing waivers
    When the page loads
    Then page should load within 2 seconds
    And available players should display
    And pending claims should show

  @performance
  Scenario: Free agent list performs well
    Given many free agents are available
    When I browse the list
    Then scrolling should be smooth
    And filtering should be fast
    And sorting should be responsive

  @performance
  Scenario: Waiver processing completes efficiently
    Given many waiver claims are pending
    When processing runs
    Then processing should complete timely
    And all claims should be handled
    And no timeouts should occur

  @performance
  Scenario: FAAB calculations are fast
    Given I am calculating bids
    When bid analysis runs
    Then calculations should be instant
    And budget impact should show immediately
    And no lag should be perceptible

  @performance
  Scenario: Claim submission is responsive
    Given I am submitting a claim
    When I submit
    Then submission should confirm within 1 second
    And UI should provide immediate feedback
    And claim should be saved reliably

  @performance
  Scenario: Waiver history loads efficiently
    Given extensive history exists
    When I load history
    Then initial page should load quickly
    And pagination should be smooth
    And searching should be responsive

  @performance
  Scenario: Real-time updates perform well
    Given waivers are being updated
    When updates occur
    Then updates should appear promptly
    And no duplicate updates should show
    And UI should remain responsive

  @performance
  Scenario: Mobile waiver performance
    Given I am using mobile device
    When I use waiver features
    Then performance should be acceptable
    And data usage should be efficient
    And battery impact should be minimal
