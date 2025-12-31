@transactions @anima-1401
Feature: Transactions
  As a fantasy football user
  I want comprehensive transaction management
  So that I can track and manage all roster moves

  Background:
    Given I am a logged-in user
    And the transaction system is available

  # ============================================================================
  # TRANSACTION HISTORY
  # ============================================================================

  @happy-path @transaction-history
  Scenario: View transactions
    Given transactions exist
    When I view transactions
    Then I should see all transactions
    And they should be listed chronologically

  @happy-path @transaction-history
  Scenario: View transaction log
    Given log is available
    When I view log
    Then I should see complete log
    And all activity should be recorded

  @happy-path @transaction-history
  Scenario: View recent transactions
    Given recent transactions exist
    When I view recent
    Then I should see latest transactions
    And they should be most recent first

  @happy-path @transaction-history
  Scenario: View transaction timeline
    Given timeline is available
    When I view timeline
    Then I should see transactions over time
    And dates should be clear

  @happy-path @transaction-history
  Scenario: View transaction archive
    Given archive exists
    When I view archive
    Then I should see past transactions
    And I can browse history

  @happy-path @transaction-history
  Scenario: View my transactions only
    Given I have made transactions
    When I filter to my transactions
    Then I should see only my moves
    And others should be hidden

  @happy-path @transaction-history
  Scenario: Paginate transaction history
    Given many transactions exist
    When I paginate
    Then I should see pages
    And I can navigate between them

  @happy-path @transaction-history
  Scenario: Refresh transaction history
    Given history may have changed
    When I refresh
    Then history should update
    And latest should be shown

  @happy-path @transaction-history
  Scenario: View transactions by week
    Given weeks have transactions
    When I view by week
    Then I should see week-grouped transactions
    And I can select any week

  @happy-path @transaction-history
  Scenario: View transactions on mobile
    Given I am on mobile device
    When I view transactions
    Then display should be mobile-friendly
    And all info should be accessible

  # ============================================================================
  # TRANSACTION DETAILS
  # ============================================================================

  @happy-path @transaction-details
  Scenario: View transaction info
    Given transaction exists
    When I view details
    Then I should see full info
    And all details should be shown

  @happy-path @transaction-details
  Scenario: View transaction type
    Given transaction exists
    When I view type
    Then I should see transaction type
    And it should be clearly indicated

  @happy-path @transaction-details
  Scenario: View transaction date
    Given transaction exists
    When I view date
    Then I should see when it occurred
    And timestamp should be shown

  @happy-path @transaction-details
  Scenario: View teams involved
    Given transaction involves teams
    When I view teams
    Then I should see all teams involved
    And roles should be clear

  @happy-path @transaction-details
  Scenario: View players involved
    Given transaction involves players
    When I view players
    Then I should see all players
    And movement should be clear

  @happy-path @transaction-details
  Scenario: View transaction status
    Given transaction has status
    When I view status
    Then I should see current status
    And state should be clear

  @happy-path @transaction-details
  Scenario: View transaction notes
    Given notes exist
    When I view notes
    Then I should see any notes
    And context should be provided

  @happy-path @transaction-details
  Scenario: View transaction impact
    Given impact is calculated
    When I view impact
    Then I should see roster impact
    And changes should be explained

  @happy-path @transaction-details
  Scenario: View related transactions
    Given related transactions exist
    When I view related
    Then I should see connected moves
    And relationship should be clear

  @happy-path @transaction-details
  Scenario: Share transaction details
    Given transaction exists
    When I share details
    Then shareable link should be created
    And others can view

  # ============================================================================
  # TRANSACTION TYPES
  # ============================================================================

  @happy-path @transaction-types
  Scenario: View trade transactions
    Given trades have occurred
    When I view trades
    Then I should see all trades
    And details should be shown

  @happy-path @transaction-types
  Scenario: View add/drop transactions
    Given add/drops have occurred
    When I view add/drops
    Then I should see all add/drops
    And players should be listed

  @happy-path @transaction-types
  Scenario: View waiver claims
    Given waiver claims exist
    When I view waivers
    Then I should see all claims
    And results should be shown

  @happy-path @transaction-types
  Scenario: View free agent pickups
    Given FA pickups exist
    When I view FA pickups
    Then I should see all pickups
    And they should be distinguished from waivers

  @commissioner @transaction-types
  Scenario: View commissioner changes
    Given commissioner made changes
    When I view commissioner moves
    Then I should see all changes
    And reasons should be shown

  @happy-path @transaction-types
  Scenario: View IR moves
    Given IR moves exist
    When I view IR transactions
    Then I should see IR moves
    And status should be shown

  @happy-path @transaction-types
  Scenario: View lineup changes
    Given lineup changes are tracked
    When I view lineup moves
    Then I should see lineup changes
    And positions should be shown

  @happy-path @transaction-types
  Scenario: Filter by transaction type
    Given multiple types exist
    When I filter by type
    Then I should see only that type
    And count should update

  @happy-path @transaction-types
  Scenario: View draft picks traded
    Given draft picks were traded
    When I view draft trades
    Then I should see pick trades
    And years should be shown

  @happy-path @transaction-types
  Scenario: View transaction type breakdown
    Given types are tracked
    When I view breakdown
    Then I should see type distribution
    And counts should be shown

  # ============================================================================
  # TRANSACTION SEARCH
  # ============================================================================

  @happy-path @transaction-search
  Scenario: Search transactions
    Given transactions exist
    When I search transactions
    Then I should find matching results
    And search should be fast

  @happy-path @transaction-search
  Scenario: Filter by type
    Given types exist
    When I filter by type
    Then I should see that type only
    And others should be hidden

  @happy-path @transaction-search
  Scenario: Filter by date
    Given dates vary
    When I filter by date
    Then I should see date range
    And only matching should show

  @happy-path @transaction-search
  Scenario: Filter by team
    Given teams have transactions
    When I filter by team
    Then I should see that team's moves
    And others should be hidden

  @happy-path @transaction-search
  Scenario: Filter by player
    Given players were moved
    When I filter by player
    Then I should see player's transactions
    And history should be shown

  @happy-path @transaction-search
  Scenario: Use advanced search
    Given advanced options exist
    When I use advanced search
    Then I should see detailed options
    And results should match criteria

  @happy-path @transaction-search
  Scenario: Save search filters
    Given I have useful filters
    When I save filters
    Then filters should be saved
    And I can reuse later

  @happy-path @transaction-search
  Scenario: Clear search filters
    Given filters are applied
    When I clear filters
    Then all filters should reset
    And full list should show

  @happy-path @transaction-search
  Scenario: Sort search results
    Given results exist
    When I sort results
    Then results should be sorted
    And order should match selection

  @happy-path @transaction-search
  Scenario: Export search results
    Given results exist
    When I export results
    Then I should receive export file
    And data should match search

  # ============================================================================
  # TRANSACTION NOTIFICATIONS
  # ============================================================================

  @happy-path @transaction-notifications
  Scenario: Receive transaction alert
    Given alerts are enabled
    When transaction occurs
    Then I should receive alert
    And details should be shown

  @happy-path @transaction-notifications
  Scenario: Receive trade notification
    Given trade involves me
    When trade is proposed
    Then I should be notified
    And I can respond

  @happy-path @transaction-notifications
  Scenario: Receive waiver results
    Given I made waiver claim
    When waivers process
    Then I should receive results
    And outcome should be clear

  @happy-path @transaction-notifications
  Scenario: Receive pickup confirmation
    Given I picked up player
    When pickup completes
    Then I should receive confirmation
    And roster should update

  @happy-path @transaction-notifications
  Scenario: Receive transaction update
    Given transaction is pending
    When status changes
    Then I should receive update
    And new status should be shown

  @happy-path @transaction-notifications
  Scenario: Configure transaction alerts
    Given preferences exist
    When I configure alerts
    Then preferences should be saved
    And alerts should follow them

  @happy-path @transaction-notifications
  Scenario: Receive league transaction digest
    Given digest is enabled
    When period completes
    Then I should receive digest
    And summary should be shown

  @happy-path @transaction-notifications
  Scenario: Receive deadline reminder
    Given deadline approaches
    When threshold is reached
    Then I should be reminded
    And time remaining should be shown

  @happy-path @transaction-notifications
  Scenario: Disable transaction notifications
    Given I receive too many
    When I disable notifications
    Then notifications should stop
    And I can re-enable later

  @happy-path @transaction-notifications
  Scenario: View notification history
    Given notifications have occurred
    When I view history
    Then I should see past notifications
    And I can review them

  # ============================================================================
  # TRANSACTION APPROVAL
  # ============================================================================

  @happy-path @transaction-approval
  Scenario: View pending transactions
    Given pending transactions exist
    When I view pending
    Then I should see awaiting approval
    And status should be shown

  @commissioner @transaction-approval
  Scenario: Approve trade
    Given trade needs approval
    When I approve trade
    Then trade should be approved
    And parties should be notified

  @commissioner @transaction-approval
  Scenario: Reject trade
    Given trade needs approval
    When I reject trade
    Then trade should be rejected
    And parties should be notified with reason

  @commissioner @transaction-approval
  Scenario: Review pending transaction
    Given transaction needs review
    When I review transaction
    Then I should see all details
    And I can make decision

  @happy-path @transaction-approval
  Scenario: Vote to veto trade
    Given trade is in review
    When I vote to veto
    Then my vote should be recorded
    And count should update

  @happy-path @transaction-approval
  Scenario: View veto status
    Given veto voting is active
    When I view status
    Then I should see vote count
    And threshold should be shown

  @happy-path @transaction-approval
  Scenario: View approval timeline
    Given approval is in progress
    When I view timeline
    Then I should see remaining time
    And deadline should be clear

  @commissioner @transaction-approval
  Scenario: Expedite transaction approval
    Given transaction is pending
    When I expedite
    Then approval should be faster
    And parties should be notified

  @happy-path @transaction-approval
  Scenario: View approval history
    Given approvals have occurred
    When I view history
    Then I should see past decisions
    And outcomes should be shown

  @happy-path @transaction-approval
  Scenario: Appeal rejected transaction
    Given transaction was rejected
    When I appeal
    Then appeal should be submitted
    And it should be reviewed

  # ============================================================================
  # TRANSACTION RULES
  # ============================================================================

  @happy-path @transaction-rules
  Scenario: View transaction limits
    Given limits are set
    When I view limits
    Then I should see my limits
    And remaining should be shown

  @happy-path @transaction-rules
  Scenario: View trade deadline
    Given deadline is set
    When I view deadline
    Then I should see deadline date
    And time remaining should be shown

  @happy-path @transaction-rules
  Scenario: View waiver priority
    Given priority is set
    When I view priority
    Then I should see my priority
    And order should be clear

  @happy-path @transaction-rules
  Scenario: View acquisition budget
    Given FAAB is enabled
    When I view budget
    Then I should see remaining budget
    And spent should be shown

  @happy-path @transaction-rules
  Scenario: View roster limits
    Given limits exist
    When I view limits
    Then I should see roster limits
    And current count should be shown

  @commissioner @transaction-rules
  Scenario: Configure transaction rules
    Given I am commissioner
    When I configure rules
    Then rules should be saved
    And members should be notified

  @happy-path @transaction-rules
  Scenario: View rule explanations
    Given rules exist
    When I view explanations
    Then I should see detailed rules
    And they should be clear

  @error @transaction-rules
  Scenario: Handle rule violation
    Given I violate a rule
    When I try to proceed
    Then I should see error
    And violation should be explained

  @happy-path @transaction-rules
  Scenario: View rule history
    Given rules have changed
    When I view history
    Then I should see past rules
    And changes should be shown

  @happy-path @transaction-rules
  Scenario: Compare to league rules
    Given league has rules
    When I compare
    Then I should see my status vs rules
    And compliance should be clear

  # ============================================================================
  # TRANSACTION REPORTS
  # ============================================================================

  @happy-path @transaction-reports
  Scenario: View transaction summary
    Given transactions exist
    When I view summary
    Then I should see summary stats
    And key metrics should be shown

  @happy-path @transaction-reports
  Scenario: View team activity
    Given teams have activity
    When I view team activity
    Then I should see team's moves
    And counts should be shown

  @happy-path @transaction-reports
  Scenario: View league activity
    Given league has activity
    When I view league activity
    Then I should see all moves
    And it should be organized

  @happy-path @transaction-reports
  Scenario: View transaction trends
    Given trends exist
    When I view trends
    Then I should see activity trends
    And patterns should be visible

  @happy-path @transaction-reports
  Scenario: View acquisition leaders
    Given acquisitions are tracked
    When I view leaders
    Then I should see most active teams
    And counts should be ranked

  @happy-path @transaction-reports
  Scenario: Generate transaction report
    Given data exists
    When I generate report
    Then report should be created
    And it should be comprehensive

  @happy-path @transaction-reports
  Scenario: View FAAB spending report
    Given FAAB is tracked
    When I view spending
    Then I should see spending breakdown
    And budget should be shown

  @happy-path @transaction-reports
  Scenario: View trade value report
    Given trades occurred
    When I view trade values
    Then I should see value analysis
    And winners should be indicated

  @happy-path @transaction-reports
  Scenario: Schedule automatic reports
    Given scheduling is available
    When I schedule reports
    Then schedule should be saved
    And reports should be sent

  @happy-path @transaction-reports
  Scenario: Compare my activity to league
    Given activity is tracked
    When I compare to league
    Then I should see comparison
    And my ranking should be shown

  # ============================================================================
  # TRANSACTION UNDO
  # ============================================================================

  @commissioner @transaction-undo
  Scenario: Reverse transaction
    Given transaction occurred
    When I reverse transaction
    Then transaction should be undone
    And rosters should be restored

  @happy-path @transaction-undo
  Scenario: Undo recent pickup
    Given I just picked up player
    When I undo pickup
    Then pickup should be reversed
    And player should be available again

  @happy-path @transaction-undo
  Scenario: Cancel pending trade
    Given trade is pending
    When I cancel trade
    Then trade should be cancelled
    And parties should be notified

  @commissioner @transaction-undo
  Scenario: Restore roster
    Given roster was changed
    When I restore roster
    Then roster should be restored
    And I should confirm first

  @commissioner @transaction-undo
  Scenario: Rollback transactions
    Given transactions occurred
    When I rollback to point
    Then transactions should be undone
    And state should be restored

  @happy-path @transaction-undo
  Scenario: View undo options
    Given transaction exists
    When I view undo options
    Then I should see what's reversible
    And limitations should be clear

  @commissioner @transaction-undo
  Scenario: Undo commissioner change
    Given commissioner made change
    When I undo change
    Then change should be reversed
    And log should be updated

  @happy-path @transaction-undo
  Scenario: View undo history
    Given undos have occurred
    When I view history
    Then I should see past undos
    And reasons should be shown

  @error @transaction-undo
  Scenario: Handle undo not available
    Given undo window expired
    When I try to undo
    Then I should see error
    And limitation should be explained

  @commissioner @transaction-undo
  Scenario: Confirm undo action
    Given I am undoing
    When I confirm action
    Then undo should proceed
    And confirmation should be shown

  # ============================================================================
  # TRANSACTION EXPORT
  # ============================================================================

  @happy-path @transaction-export
  Scenario: Export history
    Given history exists
    When I export history
    Then I should receive export file
    And format should be selectable

  @happy-path @transaction-export
  Scenario: Generate transaction report
    Given transactions exist
    When I generate report
    Then report should be created
    And it should be comprehensive

  @happy-path @transaction-export
  Scenario: Export activity log
    Given activity is logged
    When I export log
    Then I should receive log file
    And all activity should be included

  @happy-path @transaction-export
  Scenario: Share transactions
    Given transactions exist
    When I share transactions
    Then shareable link should be created
    And others can view

  @happy-path @transaction-export
  Scenario: Print transactions
    Given transactions are displayed
    When I print transactions
    Then printable version should open
    And formatting should be clean

  @happy-path @transaction-export
  Scenario: Export to spreadsheet
    Given transactions exist
    When I export to spreadsheet
    Then spreadsheet should be created
    And data should be formatted

  @happy-path @transaction-export
  Scenario: Email transaction report
    Given report exists
    When I email report
    Then email should be sent
    And report should be attached

  @happy-path @transaction-export
  Scenario: Export filtered results
    Given filters are applied
    When I export results
    Then export should match filters
    And only filtered should be included

  @happy-path @transaction-export
  Scenario: Schedule transaction exports
    Given scheduling is available
    When I schedule export
    Then schedule should be saved
    And exports should be sent

  @happy-path @transaction-export
  Scenario: Export transaction images
    Given transactions are displayed
    When I create image
    Then image should be generated
    And I can save or share

