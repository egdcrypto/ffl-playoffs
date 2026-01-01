@commissioner-tools
Feature: Commissioner Tools
  As a league commissioner
  I want comprehensive commissioner tools
  So that I can effectively manage and administer my fantasy football league

  Background:
    Given I am logged in as a league commissioner
    And I have an active fantasy football league
    And I am on the commissioner tools page

  # --------------------------------------------------------------------------
  # Roster Management Scenarios
  # --------------------------------------------------------------------------
  @roster-management
  Scenario: Force add player to team roster
    Given I am viewing a team's roster as commissioner
    And a player is available in the player pool
    When I select "Force Add Player" from commissioner actions
    And I search for and select the player to add
    And I confirm the roster addition
    Then the player should be added to the team's roster
    And the transaction should be logged in commissioner history
    And the team owner should be notified of the change

  @roster-management
  Scenario: Force drop player from team roster
    Given I am viewing a team's roster as commissioner
    And the team has a rostered player
    When I select "Force Drop Player" from commissioner actions
    And I select the player to drop
    And I provide a reason for the forced drop
    And I confirm the roster removal
    Then the player should be removed from the team's roster
    And the player should be returned to the player pool
    And the action should be recorded with the provided reason

  @roster-management
  Scenario: Move player between teams
    Given I have two teams in my league
    And Team A has Player X on their roster
    When I select "Transfer Player" from commissioner actions
    And I select Player X from Team A
    And I select Team B as the destination
    And I confirm the player transfer
    Then Player X should be moved to Team B's roster
    And Player X should no longer be on Team A's roster
    And both team owners should be notified

  @roster-management
  Scenario: Edit team roster positions
    Given I am viewing a team's roster as commissioner
    And the team has players in various positions
    When I select "Edit Lineup" from commissioner actions
    And I move a player from bench to starting lineup
    And I save the roster changes
    Then the player's position should be updated
    And the change should be logged in commissioner history

  @roster-management
  Scenario: Add player to injured reserve
    Given I am viewing a team's roster as commissioner
    And a player has an injury designation
    When I select "Move to IR" from commissioner actions
    And I select the injured player
    And I confirm the IR placement
    Then the player should be moved to the IR slot
    And the team should have an open roster spot

  @roster-management
  Scenario: Restore deleted roster moves
    Given a team owner accidentally dropped a player
    And the drop occurred within the restoration window
    When I access the transaction history
    And I select "Restore" on the dropped player transaction
    And I confirm the restoration
    Then the player should be restored to the team's roster
    And the original transaction should be marked as reversed

  @roster-management
  Scenario: Lock team roster
    Given I am viewing a team's roster as commissioner
    And the team has not been locked
    When I select "Lock Roster" from commissioner actions
    And I provide a reason for the lock
    And I confirm the roster lock
    Then the team's roster should be locked from changes
    And the owner should be notified of the lock
    And the lock reason should be visible

  @roster-management
  Scenario: Unlock team roster
    Given a team's roster has been locked by commissioner
    When I select "Unlock Roster" from commissioner actions
    And I confirm the roster unlock
    Then the team's roster should be unlocked
    And the owner should be able to make roster changes again

  # --------------------------------------------------------------------------
  # Transaction Management Scenarios
  # --------------------------------------------------------------------------
  @transaction-management
  Scenario: Approve pending trade
    Given there is a pending trade between two teams
    And the trade requires commissioner approval
    When I review the trade details
    And I select "Approve Trade" from commissioner actions
    And I confirm the approval
    Then the trade should be processed immediately
    And both team owners should be notified of approval
    And the trade should appear in league transactions

  @transaction-management
  Scenario: Reject pending trade
    Given there is a pending trade between two teams
    And the trade requires commissioner approval
    When I review the trade details
    And I select "Reject Trade" from commissioner actions
    And I provide a rejection reason
    And I confirm the rejection
    Then the trade should be cancelled
    And both team owners should be notified with the reason
    And the rejection should be logged

  @transaction-management
  Scenario: Reverse completed trade
    Given a trade was completed between two teams
    And the trade occurred within the reversal window
    When I access the completed trade in transaction history
    And I select "Reverse Trade" from commissioner actions
    And I provide a reason for the reversal
    And I confirm the trade reversal
    Then all players should be returned to original teams
    And all draft picks should be returned if applicable
    And both team owners should be notified

  @transaction-management
  Scenario: Process manual waiver claim
    Given a player is on waivers
    And a team owner has requested a manual waiver claim
    When I select "Process Manual Waiver" from commissioner actions
    And I select the player and destination team
    And I set the appropriate waiver priority impact
    And I confirm the waiver claim
    Then the player should be added to the team's roster
    And the waiver priority should be adjusted accordingly

  @transaction-management
  Scenario: Cancel pending waiver claim
    Given a team has a pending waiver claim
    When I access the pending waiver claims
    And I select "Cancel Claim" on the waiver request
    And I provide a cancellation reason
    And I confirm the cancellation
    Then the waiver claim should be cancelled
    And the team owner should be notified

  @transaction-management
  Scenario: Process FAAB adjustment
    Given the league uses FAAB for acquisitions
    And a team needs a FAAB budget adjustment
    When I select "Adjust FAAB Budget" from commissioner actions
    And I select the team to adjust
    And I enter the new FAAB amount
    And I provide a reason for the adjustment
    Then the team's FAAB budget should be updated
    And the adjustment should be logged in commissioner history

  @transaction-management
  Scenario: Bulk process pending transactions
    Given there are multiple pending transactions
    When I access the pending transactions queue
    And I select multiple transactions for bulk action
    And I choose "Approve All Selected"
    And I confirm the bulk approval
    Then all selected transactions should be processed
    And appropriate notifications should be sent

  @transaction-management
  Scenario: Set transaction freeze period
    Given I want to freeze all transactions
    When I select "Transaction Freeze" from commissioner actions
    And I set the freeze start and end dates
    And I provide a freeze reason
    And I activate the freeze
    Then no transactions should be allowed during the freeze period
    And all league members should be notified

  # --------------------------------------------------------------------------
  # Scoring Adjustments Scenarios
  # --------------------------------------------------------------------------
  @scoring-adjustments
  Scenario: Edit individual player score
    Given a matchup has been scored
    And a player's score needs correction
    When I access the matchup scoring details
    And I select "Edit Player Score" on the player
    And I enter the corrected point value
    And I provide a reason for the adjustment
    And I save the score change
    Then the player's score should be updated
    And the matchup total should be recalculated
    And the score change should be logged

  @scoring-adjustments
  Scenario: Apply NFL stat correction
    Given the NFL has issued a stat correction
    And the correction affects players in my league
    When I select "Apply Stat Corrections" from commissioner actions
    And I review the available stat corrections
    And I apply the relevant corrections
    Then all affected player scores should be updated
    And all affected matchup results should be recalculated
    And owners of affected teams should be notified

  @scoring-adjustments
  Scenario: Adjust matchup final result
    Given a matchup has been completed
    And the result needs to be adjusted
    When I access the matchup details
    And I select "Adjust Result" from commissioner actions
    And I enter the adjusted scores for each team
    And I provide a reason for the adjustment
    And I confirm the changes
    Then the matchup result should be updated
    And standings should be recalculated if necessary
    And both team owners should be notified

  @scoring-adjustments
  Scenario: Add bonus points to player
    Given a matchup is in progress or completed
    And a player earned bonus points not automatically calculated
    When I access the player's scoring details
    And I select "Add Bonus Points"
    And I enter the bonus point value
    And I select the bonus category
    And I confirm the bonus addition
    Then the bonus points should be added to the player's total
    And the matchup score should be updated

  @scoring-adjustments
  Scenario: Remove erroneous points
    Given a player has incorrectly awarded points
    When I access the player's scoring breakdown
    And I select "Remove Points" on the erroneous category
    And I enter the points to remove
    And I provide an explanation
    And I confirm the removal
    Then the points should be deducted from the player's total
    And the scoring breakdown should reflect the change

  @scoring-adjustments
  Scenario: Recalculate all scores for week
    Given scoring settings were changed mid-week
    And historical scores need recalculation
    When I select "Recalculate Week Scores" from commissioner actions
    And I select the week to recalculate
    And I confirm the recalculation
    Then all player scores for that week should be recalculated
    And all matchup results should be updated
    And affected owners should be notified

  @scoring-adjustments
  Scenario: View scoring adjustment history
    Given scoring adjustments have been made during the season
    When I access the scoring adjustment history
    Then I should see all scoring changes made
    And each entry should show the original and adjusted values
    And each entry should show the reason and timestamp

  @scoring-adjustments
  Scenario: Bulk score adjustment for stat category
    Given a stat category needs league-wide adjustment
    When I select "Bulk Score Adjustment" from commissioner actions
    And I select the stat category to adjust
    And I enter the adjustment value
    And I select the affected week or weeks
    And I confirm the bulk adjustment
    Then all player scores with that stat should be adjusted
    And all affected matchups should be recalculated

  # --------------------------------------------------------------------------
  # Schedule Management Scenarios
  # --------------------------------------------------------------------------
  @schedule-management
  Scenario: Edit regular season matchup
    Given the regular season schedule has been generated
    And I need to change a specific matchup
    When I access the schedule management page
    And I select the matchup to edit
    And I swap one team with another team from that week
    And I confirm the schedule change
    Then the matchup should be updated
    And the other affected matchups should be adjusted
    And affected team owners should be notified

  @schedule-management
  Scenario: Reschedule matchup to different week
    Given a matchup needs to be moved to a different week
    When I select the matchup to reschedule
    And I choose the destination week
    And I handle any conflicts in the destination week
    And I confirm the reschedule
    Then the matchup should appear in the new week
    And the original week should be updated
    And both teams should be notified

  @schedule-management
  Scenario: Adjust playoff seeding manually
    Given the regular season has ended
    And playoff seeding needs manual adjustment
    When I access playoff seeding management
    And I select the team to reseed
    And I assign the new seed position
    And I provide a reason for the seeding change
    And I confirm the seeding adjustment
    Then the team should be assigned the new seed
    And playoff bracket should be updated
    And all playoff teams should be notified

  @schedule-management
  Scenario: Create bye week for team
    Given a team needs a bye week
    And the schedule needs modification
    When I select "Add Bye Week" from schedule management
    And I select the team and week for the bye
    And I handle the displaced matchup
    And I confirm the bye week addition
    Then the team should have a bye that week
    And the schedule should be adjusted accordingly

  @schedule-management
  Scenario: Generate new schedule
    Given the current schedule needs to be regenerated
    When I select "Regenerate Schedule" from commissioner actions
    And I configure the schedule parameters
    And I preview the new schedule
    And I confirm the schedule regeneration
    Then the new schedule should replace the current one
    And all league members should be notified of the change

  @schedule-management
  Scenario: Set matchup as double-header
    Given I want a team to play two matchups in one week
    When I select "Add Double-Header" from schedule management
    And I select the team and opponents
    And I configure the double-header week
    And I confirm the double-header
    Then the team should have two matchups that week
    And scoring should be tracked for both matchups

  @schedule-management
  Scenario: Cancel scheduled matchup
    Given a matchup needs to be cancelled
    When I select the matchup to cancel
    And I select "Cancel Matchup" from commissioner actions
    And I choose how to handle the result (tie, forfeit, etc.)
    And I confirm the cancellation
    Then the matchup should be cancelled
    And the chosen result handling should be applied
    And both teams should be notified

  @schedule-management
  Scenario: Import custom schedule
    Given I have a custom schedule to import
    When I select "Import Schedule" from commissioner actions
    And I upload the schedule file
    And I map the team names to league teams
    And I validate and confirm the import
    Then the imported schedule should replace the current one
    And any conflicts should be highlighted for resolution

  # --------------------------------------------------------------------------
  # Team Management Scenarios
  # --------------------------------------------------------------------------
  @team-management
  Scenario: Add new team to league
    Given the league has not reached maximum teams
    And a new owner wants to join
    When I select "Add Team" from commissioner actions
    And I enter the new team name
    And I invite or assign an owner
    And I configure initial settings
    And I confirm the team addition
    Then the new team should be added to the league
    And the schedule should be adjusted if necessary
    And the new owner should receive an invitation

  @team-management
  Scenario: Remove team from league
    Given a team needs to be removed from the league
    When I select the team to remove
    And I select "Remove Team" from commissioner actions
    And I choose how to handle the team's players
    And I provide a removal reason
    And I confirm the team removal
    Then the team should be removed from the league
    And the players should be handled as specified
    And the schedule should be adjusted

  @team-management
  Scenario: Rename team
    Given a team name needs to be changed
    When I access the team's settings as commissioner
    And I select "Rename Team" from commissioner actions
    And I enter the new team name
    And I confirm the name change
    Then the team name should be updated
    And the new name should appear throughout the league

  @team-management
  Scenario: Reassign team owner
    Given a team needs a new owner
    And a new owner is available
    When I select "Reassign Owner" from commissioner actions
    And I select the team to reassign
    And I invite or select the new owner
    And I configure ownership transfer options
    And I confirm the ownership change
    Then the team should be assigned to the new owner
    And the previous owner should lose access
    And the new owner should be notified

  @team-management
  Scenario: Set team as inactive
    Given a team owner has become unresponsive
    When I select "Set Inactive" on the team
    And I enable auto-management for the team
    And I configure inactive team settings
    And I confirm the inactive status
    Then the team should be marked as inactive
    And auto-management should handle roster decisions
    And the inactive status should be visible to the league

  @team-management
  Scenario: Merge two teams
    Given two teams need to be merged
    And the league allows team merging
    When I select "Merge Teams" from commissioner actions
    And I select the two teams to merge
    And I configure how to handle combined rosters
    And I assign the merged team owner
    And I confirm the team merge
    Then the teams should be merged into one
    And the roster should be handled as configured
    And the schedule should be adjusted

  @team-management
  Scenario: Edit team logo and branding
    Given a team's logo is inappropriate or needs changing
    When I access the team's profile as commissioner
    And I select "Edit Team Branding"
    And I upload a new logo or select from defaults
    And I save the branding changes
    Then the team's logo should be updated
    And the new branding should appear throughout the league

  @team-management
  Scenario: View team ownership history
    Given a team has had multiple owners
    When I access the team's management page
    And I select "Ownership History"
    Then I should see all previous owners
    And I should see transfer dates and reasons
    And I should see the current owner details

  # --------------------------------------------------------------------------
  # League Communication Scenarios
  # --------------------------------------------------------------------------
  @league-communication
  Scenario: Send commissioner announcement
    Given I have an important announcement for the league
    When I select "Send Announcement" from commissioner actions
    And I compose the announcement message
    And I set the announcement priority level
    And I choose notification delivery methods
    And I send the announcement
    Then all league members should receive the announcement
    And the announcement should be pinned in the league feed
    And read receipts should be tracked

  @league-communication
  Scenario: Create pinned notice
    Given I want to pin important information for the league
    When I select "Create Pinned Notice" from commissioner actions
    And I compose the notice content
    And I set the notice expiration date
    And I configure notice visibility
    And I publish the pinned notice
    Then the notice should appear at the top of the league page
    And the notice should remain until expiration or removal

  @league-communication
  Scenario: Send message to specific team owner
    Given I need to contact a specific team owner
    When I select "Send Direct Message" from commissioner actions
    And I select the recipient owner
    And I compose the private message
    And I choose the delivery method
    And I send the message
    Then the owner should receive the private message
    And the message should be logged in commissioner communications

  @league-communication
  Scenario: Broadcast trade deadline reminder
    Given the trade deadline is approaching
    When I select "Send Deadline Reminder" from commissioner actions
    And I customize the reminder message
    And I include the deadline date and time
    And I send the broadcast
    Then all league members should receive the reminder
    And the deadline should be highlighted in the league

  @league-communication
  Scenario: Create league newsletter
    Given I want to send a weekly league recap
    When I select "Create Newsletter" from commissioner actions
    And I add matchup recaps and standings updates
    And I include commissioner commentary
    And I preview and send the newsletter
    Then all league members should receive the newsletter
    And the newsletter should be archived for reference

  @league-communication
  Scenario: Set up automated notifications
    Given I want to automate certain league notifications
    When I access notification settings
    And I enable automated notifications for key events
    And I customize notification templates
    And I save the automation settings
    Then automated notifications should be sent for configured events
    And the notification log should track all sent messages

  @league-communication
  Scenario: Archive league message
    Given there are old messages in the league feed
    When I access message management
    And I select messages to archive
    And I confirm the archival
    Then the messages should be moved to archive
    And the messages should remain accessible in archive history

  @league-communication
  Scenario: Delete inappropriate message
    Given an inappropriate message was posted in the league
    When I access the message in the league feed
    And I select "Delete Message" from commissioner actions
    And I provide a deletion reason
    And I confirm the deletion
    Then the message should be removed from the feed
    And the poster should be notified
    And the deletion should be logged

  # --------------------------------------------------------------------------
  # Dues and Payments Scenarios
  # --------------------------------------------------------------------------
  @dues-payments
  Scenario: Set up league dues
    Given I want to establish league dues
    When I access the league dues settings
    And I set the dues amount per team
    And I configure the payment deadline
    And I set up payment methods or instructions
    And I save the dues configuration
    Then league dues should be established
    And all team owners should be notified of dues

  @dues-payments
  Scenario: Track dues payment status
    Given league dues have been established
    When I access the payment tracking dashboard
    Then I should see the payment status for each team
    And I should see total collected and outstanding amounts
    And I should see payment due dates

  @dues-payments
  Scenario: Mark dues as paid
    Given a team owner has paid their dues
    When I access the payment tracking dashboard
    And I select the team to update
    And I mark their dues as paid
    And I enter the payment amount and date
    And I save the payment record
    Then the team should be marked as paid
    And the payment should be logged
    And the dashboard should update totals

  @dues-payments
  Scenario: Send payment reminder
    Given some teams have not paid their dues
    When I access the payment tracking dashboard
    And I select unpaid teams
    And I click "Send Payment Reminder"
    And I customize the reminder message
    And I send the reminder
    Then the selected owners should receive payment reminders
    And reminder history should be logged

  @dues-payments
  Scenario: Configure prize distribution
    Given I want to set up prize payouts
    When I access the prize distribution settings
    And I set prizes for each finishing position
    And I configure any weekly prizes
    And I set the payout schedule
    And I save the prize configuration
    Then prize distribution should be configured
    And the prize structure should be visible to all members

  @dues-payments
  Scenario: Record prize payout
    Given the season has ended
    And prizes need to be distributed
    When I access the prize distribution page
    And I select a winner to pay
    And I enter the payout amount and method
    And I mark the prize as distributed
    Then the payout should be recorded
    And the recipient should be notified
    And the distribution log should be updated

  @dues-payments
  Scenario: Generate financial report
    Given the league has financial transactions
    When I select "Generate Financial Report" from commissioner actions
    And I select the reporting period
    And I choose report format
    And I generate the report
    Then a comprehensive financial report should be created
    And the report should include all dues and payouts
    And I should be able to export the report

  @dues-payments
  Scenario: Handle disputed payment
    Given a team owner disputes their payment status
    When I access the payment dispute resolution
    And I review the dispute details
    And I check payment records and evidence
    And I make a ruling on the dispute
    Then the dispute should be resolved
    And payment records should be updated if needed
    And the owner should be notified of the resolution

  # --------------------------------------------------------------------------
  # Draft Management Scenarios
  # --------------------------------------------------------------------------
  @draft-management
  Scenario: Pause active draft
    Given a draft is currently in progress
    And a pause is needed
    When I select "Pause Draft" from commissioner actions
    And I provide a reason for the pause
    And I confirm the draft pause
    Then the draft should be paused immediately
    And all participants should be notified
    And the pause reason should be displayed

  @draft-management
  Scenario: Resume paused draft
    Given the draft has been paused
    And the pause issue has been resolved
    When I select "Resume Draft" from commissioner actions
    And I set the resume countdown timer
    And I confirm the draft resume
    Then participants should be notified of resumption
    And the draft should resume after the countdown

  @draft-management
  Scenario: Assign draft pick for team
    Given a team's pick timer has expired
    And no auto-pick was configured
    When I select "Assign Pick" from commissioner actions
    And I select the team needing a pick assignment
    And I search for and select a player
    And I confirm the pick assignment
    Then the player should be assigned to the team
    And the draft should proceed to the next pick
    And the pick should be logged as commissioner-assigned

  @draft-management
  Scenario: Undo last draft pick
    Given a draft pick was made in error
    And the pick is eligible for reversal
    When I select "Undo Pick" from commissioner actions
    And I confirm the pick reversal
    Then the pick should be reversed
    And the player should return to available pool
    And the team should be on the clock again

  @draft-management
  Scenario: Edit draft order
    Given the draft has not started
    And the draft order needs modification
    When I access draft order settings
    And I drag and drop teams to reorder
    And I save the new draft order
    Then the draft order should be updated
    And all teams should see the new order

  @draft-management
  Scenario: Process keeper selections
    Given the league uses keepers
    And keeper selections need to be finalized
    When I access keeper management
    And I review each team's keeper selections
    And I approve or modify keeper picks
    And I finalize keeper selections
    Then approved keepers should be locked to teams
    And draft picks should be adjusted for keeper costs
    And the draft pool should be updated

  @draft-management
  Scenario: Change draft type mid-setup
    Given the draft has not started
    And the league wants to change draft format
    When I access draft settings
    And I select a different draft type
    And I configure the new draft type settings
    And I save the draft type change
    Then the draft format should be updated
    And league members should be notified

  @draft-management
  Scenario: Manage draft pick trading
    Given teams want to trade draft picks
    When I access draft pick trading management
    And I review pending pick trades
    And I approve or reject pick trades
    And I confirm the trade decisions
    Then approved trades should update pick assignments
    And the draft board should reflect new pick ownership

  # --------------------------------------------------------------------------
  # League Moderation Scenarios
  # --------------------------------------------------------------------------
  @league-moderation
  Scenario: Handle inactive owner
    Given a team owner has been inactive
    And the team is not being managed
    When I access inactive owner management
    And I select the inactive owner's team
    And I choose the resolution action
    And I execute the moderation action
    Then the team should be handled according to the action
    And the league should be notified if appropriate
    And the action should be logged

  @league-moderation
  Scenario: Resolve trade dispute
    Given there is a dispute about a trade
    When I access the dispute resolution center
    And I review the trade in question
    And I gather input from involved parties
    And I make a ruling on the dispute
    And I document the decision
    Then the dispute should be resolved
    And involved parties should be notified
    And the ruling should be recorded

  @league-moderation
  Scenario: Issue warning to team owner
    Given a team owner has violated league rules
    When I select "Issue Warning" from moderation actions
    And I select the team owner
    And I specify the rule violation
    And I compose the warning message
    And I issue the warning
    Then the owner should receive the warning
    And the warning should be logged in their record
    And strike count should be updated if applicable

  @league-moderation
  Scenario: Suspend team owner
    Given a team owner has serious violations
    When I select "Suspend Owner" from moderation actions
    And I select the owner to suspend
    And I set the suspension duration
    And I specify the suspension reason
    And I execute the suspension
    Then the owner should lose league access
    And their team should be set to auto-manage
    And the league should be notified

  @league-moderation
  Scenario: Remove team owner permanently
    Given a team owner has severe or repeated violations
    When I select "Remove Owner" from moderation actions
    And I select the owner to remove
    And I document the removal reason
    And I handle their team assignment
    And I confirm the permanent removal
    Then the owner should be permanently removed
    And their team should be reassigned or removed
    And the removal should be logged

  @league-moderation
  Scenario: Enforce league rule
    Given a league rule was violated
    When I access rule enforcement
    And I select the violated rule
    And I identify the violating party
    And I apply the appropriate penalty
    And I document the enforcement
    Then the penalty should be applied
    And the violator should be notified
    And the enforcement should be recorded

  @league-moderation
  Scenario: Create league rule
    Given the league needs a new rule
    When I access league rules management
    And I select "Add New Rule"
    And I compose the rule text
    And I set the rule category and severity
    And I publish the new rule
    Then the rule should be added to league rules
    And all members should be notified of the new rule

  @league-moderation
  Scenario: Put league rule to vote
    Given a rule change requires member approval
    When I create a rule change proposal
    And I set the voting period
    And I configure the approval threshold
    And I open the proposal for voting
    Then all members should be able to vote
    And voting status should be tracked
    And the outcome should be automatically determined

  # --------------------------------------------------------------------------
  # Commissioner Audit Log Scenarios
  # --------------------------------------------------------------------------
  @audit-log
  Scenario: View all commissioner actions
    Given commissioner actions have been taken
    When I access the commissioner audit log
    Then I should see a chronological list of all actions
    And each action should show timestamp and details
    And each action should show affected parties

  @audit-log
  Scenario: Filter audit log by action type
    Given the audit log has various action types
    When I access the audit log filter options
    And I select specific action types to view
    And I apply the filter
    Then only the selected action types should be displayed
    And the filter should persist during the session

  @audit-log
  Scenario: Search audit log by team
    Given I want to find actions related to a specific team
    When I access the audit log search
    And I search for the team name
    And I execute the search
    Then all actions involving that team should be displayed
    And related context should be included

  @audit-log
  Scenario: Export audit log report
    Given I need to provide an accountability report
    When I access the audit log export options
    And I select the date range for the report
    And I choose the export format
    And I generate the export
    Then the audit log should be exported
    And the report should include all relevant details

  @audit-log
  Scenario: View detailed action breakdown
    Given I want to review a specific commissioner action
    When I select an action from the audit log
    Then I should see the full action details
    And I should see before and after states
    And I should see any related actions or impacts

  @audit-log
  Scenario: Track changes to league settings
    Given league settings have been modified
    When I filter the audit log for settings changes
    Then I should see all settings modifications
    And each change should show previous and new values
    And the reason for change should be included

  @audit-log
  Scenario: Generate commissioner activity summary
    Given I want a summary of commissioner activity
    When I select "Generate Activity Summary" from audit options
    And I set the summary period
    And I generate the summary
    Then I should receive a summary report
    And the report should include action statistics
    And the report should highlight significant actions

  @audit-log
  Scenario: View co-commissioner actions
    Given the league has multiple commissioners
    When I access the audit log
    And I filter by commissioner identity
    Then I should see actions by the selected commissioner
    And I should be able to compare activity across commissioners

  # --------------------------------------------------------------------------
  # Error Handling Scenarios
  # --------------------------------------------------------------------------
  @error-handling
  Scenario: Handle roster move conflict
    Given I am attempting to force add a player
    And the team's roster is at maximum capacity
    When I execute the roster addition
    Then I should see a roster capacity error
    And I should be prompted to drop a player first
    And the original action should not be completed

  @error-handling
  Scenario: Handle trade reversal timeout
    Given I am attempting to reverse a completed trade
    And the trade is outside the reversal window
    When I execute the trade reversal
    Then I should see a timeout error message
    And I should be offered alternative resolution options
    And the trade should remain unchanged

  @error-handling
  Scenario: Handle invalid scoring adjustment
    Given I am adjusting a player's score
    And I enter an invalid point value
    When I attempt to save the adjustment
    Then I should see a validation error
    And the error should explain the valid range
    And the original score should be preserved

  @error-handling
  Scenario: Handle schedule conflict
    Given I am editing the league schedule
    And my changes create a team playing twice in one week
    When I attempt to save the schedule
    Then I should see a conflict error
    And the conflicting matchups should be highlighted
    And I should be able to resolve the conflict

  @error-handling
  Scenario: Handle permission denied for co-commissioner
    Given I am logged in as a co-commissioner
    And I attempt an action reserved for head commissioner
    When I execute the restricted action
    Then I should see a permission denied error
    And I should see which role is required
    And the action should not be executed

  @error-handling
  Scenario: Handle failed notification delivery
    Given I am sending a commissioner announcement
    And some recipients have invalid contact information
    When the announcement is sent
    Then I should see a partial delivery warning
    And I should see which recipients failed
    And I should be able to retry failed deliveries

  @error-handling
  Scenario: Handle draft pause during pick
    Given a team is currently on the clock
    And I attempt to pause the draft
    When I execute the draft pause
    Then the pause should wait for current pick to complete
    Or the pick should be given extra time after resume
    And the team on clock should not be penalized

  @error-handling
  Scenario: Handle concurrent commissioner actions
    Given two commissioners are acting simultaneously
    And both attempt to modify the same entity
    When the second action is processed
    Then the second action should be blocked or merged
    And a conflict notification should be shown
    And data integrity should be maintained

  @error-handling
  Scenario: Handle payment tracking sync error
    Given I am marking a payment as received
    And the payment system is temporarily unavailable
    When I submit the payment record
    Then I should see a sync error message
    And the local record should be saved
    And the system should retry synchronization

  @error-handling
  Scenario: Handle audit log storage failure
    Given I am performing a commissioner action
    And the audit logging system fails
    When the action is executed
    Then the action should still complete
    And I should see a logging warning
    And the action should be queued for later logging

  @error-handling
  Scenario: Handle invalid file import
    Given I am importing a custom schedule
    And the file format is invalid
    When I attempt the import
    Then I should see a format error message
    And the error should specify the expected format
    And sample template should be provided

  @error-handling
  Scenario: Handle league capacity exceeded
    Given I am adding a new team
    And the league is at maximum capacity
    When I attempt to add the team
    Then I should see a capacity error
    And I should see the current team limit
    And I should be offered options to expand or wait

  @error-handling
  Scenario: Handle circular trade reversal
    Given a player was involved in multiple trades
    And I attempt to reverse an intermediate trade
    When I execute the reversal
    Then I should see a dependency warning
    And the chain of trades should be shown
    And I should be guided through proper reversal order

  # --------------------------------------------------------------------------
  # Accessibility Scenarios
  # --------------------------------------------------------------------------
  @accessibility
  Scenario: Navigate commissioner tools with keyboard
    Given I am on the commissioner tools page
    When I navigate using only keyboard controls
    Then all actions should be accessible via keyboard
    And focus indicators should be clearly visible
    And logical tab order should be maintained

  @accessibility
  Scenario: Use commissioner tools with screen reader
    Given I am using a screen reader
    When I access commissioner tools
    Then all elements should have proper ARIA labels
    And action results should be announced
    And complex tables should be navigable

  @accessibility
  Scenario: View commissioner dashboard in high contrast
    Given I have high contrast mode enabled
    When I view the commissioner dashboard
    Then all elements should be clearly visible
    And status indicators should use multiple cues
    And text should meet contrast requirements

  @accessibility
  Scenario: Access commissioner tools on mobile device
    Given I am using a mobile device
    When I access commissioner tools
    Then all features should be accessible
    And touch targets should be appropriately sized
    And the interface should be responsive

  @accessibility
  Scenario: Use commissioner tools with reduced motion
    Given I have reduced motion preferences set
    When I perform commissioner actions
    Then animations should be minimized
    And confirmations should not rely on motion
    And the experience should remain fully functional

  @accessibility
  Scenario: View audit log with text scaling
    Given I have text scaled to 200%
    When I view the commissioner audit log
    Then all text should be readable
    And layouts should adapt without breaking
    And no content should be cut off

  @accessibility
  Scenario: Receive accessible error messages
    Given I trigger an error in commissioner tools
    When the error is displayed
    Then the error should be announced to assistive technology
    And the error should be visually prominent
    And recovery instructions should be clear

  @accessibility
  Scenario: Access commissioner help documentation
    Given I need help with commissioner features
    When I access the help documentation
    Then documentation should be screen reader compatible
    And headings should provide clear navigation
    And examples should include alternative text

  # --------------------------------------------------------------------------
  # Performance Scenarios
  # --------------------------------------------------------------------------
  @performance
  Scenario: Load commissioner dashboard quickly
    Given I have a league with full season data
    When I load the commissioner dashboard
    Then the dashboard should load within 3 seconds
    And key metrics should be immediately visible
    And detailed data should load progressively

  @performance
  Scenario: Process bulk roster changes efficiently
    Given I am making roster changes to multiple teams
    When I execute bulk changes for 10 teams
    Then all changes should complete within 10 seconds
    And progress should be shown during processing
    And partial success should be handled gracefully

  @performance
  Scenario: Search large audit log quickly
    Given the audit log contains 10,000+ entries
    When I search for a specific action
    Then search results should appear within 2 seconds
    And pagination should be smooth
    And filtering should be responsive

  @performance
  Scenario: Generate comprehensive financial report
    Given the league has extensive financial history
    When I generate a full season financial report
    Then the report should generate within 15 seconds
    And I should see generation progress
    And the report should be optimized for viewing

  @performance
  Scenario: Handle concurrent commissioner access
    Given multiple commissioners are active simultaneously
    When all commissioners perform actions concurrently
    Then all actions should complete successfully
    And no race conditions should occur
    And the audit log should accurately capture all actions

  @performance
  Scenario: Recalculate league-wide scores efficiently
    Given I am recalculating scores for the entire season
    When I execute the full recalculation
    Then the process should complete within reasonable time
    And progress updates should be provided
    And the system should remain responsive

  @performance
  Scenario: Load team management for large league
    Given I have a league with 20 teams
    When I access team management
    Then all teams should load within 2 seconds
    And team details should be accessible quickly
    And bulk operations should be available

  @performance
  Scenario: Export large data sets
    Given I am exporting comprehensive league data
    When I export all commissioner records
    Then the export should complete efficiently
    And the file should be properly formatted
    And download should start within 5 seconds
