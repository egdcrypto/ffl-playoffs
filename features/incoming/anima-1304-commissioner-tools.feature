@commissioner-tools @admin
Feature: Commissioner Tools
  As a league commissioner
  I want comprehensive administrative tools
  So that I can manage my fantasy football league effectively

  Background:
    Given I am logged in as the league commissioner
    And the league "Playoff Champions" exists

  # ============================================================================
  # LEAGUE CREATION/CONFIGURATION
  # ============================================================================

  @happy-path @league-creation
  Scenario: Create a new league
    When I create a new league with:
      | Setting        | Value              |
      | Name           | Super Bowl League  |
      | Type           | Redraft            |
      | Teams          | 12                 |
      | Scoring        | PPR                |
    Then the league should be created
    And I should be the commissioner
    And I should see the setup wizard

  @happy-path @league-creation
  Scenario: Configure league settings
    When I access league configuration
    Then I should be able to modify:
      | Setting Category    |
      | Scoring Rules       |
      | Roster Positions    |
      | Playoff Format      |
      | Trade Settings      |
      | Waiver Settings     |
      | Draft Settings      |

  @happy-path @league-creation
  Scenario: Clone existing league for new season
    Given a previous season exists
    When I clone the league for a new season
    Then settings should be copied
    And members should be invited
    And history should be linked

  @happy-path @league-creation
  Scenario: Use league template
    When I create a league from template
    Then I should see template options:
      | Template       | Description            |
      | Standard       | Default settings       |
      | Dynasty        | Keeper/dynasty setup   |
      | Best Ball      | No lineup management   |
      | Guillotine     | Weekly eliminations    |

  @validation @league-creation
  Scenario: Validate league name uniqueness
    Given a league named "Super Bowl League" exists
    When I try to create another with the same name
    Then I should see "League name already exists"

  # ============================================================================
  # MEMBER INVITATION/MANAGEMENT
  # ============================================================================

  @happy-path @members
  Scenario: Invite members via email
    When I invite members:
      | Email                 |
      | member1@example.com   |
      | member2@example.com   |
    Then invitations should be sent
    And pending invites should be tracked

  @happy-path @members
  Scenario: Generate invitation link
    When I generate an invitation link
    Then I should receive a shareable link
    And the link should have configurable expiration
    And I should be able to set usage limits

  @happy-path @members
  Scenario: Approve join request
    Given a user has requested to join
    When I approve the request
    Then the user should become a member
    And they should be assigned a team

  @happy-path @members
  Scenario: Remove member from league
    When I remove "JohnSmith" from the league
    Then they should lose access
    And their team should become orphaned
    And I should be prompted to reassign

  @happy-path @members
  Scenario: Assign co-commissioner
    When I assign "JaneDoe" as co-commissioner
    Then they should have commissioner privileges
    And they should be able to manage the league
    And an audit log entry should be created

  @happy-path @members
  Scenario: View member activity
    When I view member activity report
    Then I should see:
      | Member     | Last Active | Lineup Set | Trades |
      | JohnSmith  | 2 hours ago | Yes        | 3      |
      | JaneDoe    | 1 day ago   | No         | 1      |

  # ============================================================================
  # SCORING RULE ADJUSTMENTS
  # ============================================================================

  @happy-path @scoring
  Scenario: Modify scoring rules
    When I modify scoring rules:
      | Category        | Old Value | New Value |
      | Passing TD      | 4         | 6         |
      | Reception       | 1         | 0.5       |
    Then scoring rules should update
    And members should be notified
    And I should choose retroactive or future-only

  @happy-path @scoring
  Scenario: Add custom scoring category
    When I add a custom scoring category:
      | Name           | Points | Description       |
      | 40+ Yard TD    | 2      | Bonus for long TD |
    Then the category should be added
    And it should apply to relevant plays

  @happy-path @scoring
  Scenario: Preview scoring change impact
    When I preview a scoring change
    Then I should see how past scores would change
    And I should see affected matchups
    And I should see any result changes

  @validation @scoring
  Scenario: Lock scoring rules after deadline
    Given the regular season has started
    When I try to change scoring rules
    Then I should see a warning
    And I should confirm the mid-season change
    And members should vote if required

  # ============================================================================
  # MANUAL SCORE CORRECTIONS
  # ============================================================================

  @happy-path @score-corrections
  Scenario: Apply manual score adjustment
    When I adjust "TeamA" Week 5 score:
      | Original Score | Adjustment | New Score | Reason            |
      | 105.4          | +2.5       | 107.9     | Stat correction   |
    Then the score should be updated
    And an audit log should be created
    And affected members should be notified

  @happy-path @score-corrections
  Scenario: Correct individual player score
    When I correct "Patrick Mahomes" Week 5 score:
      | Original | Corrected | Reason                    |
      | 25.4     | 27.8      | NFL stat correction       |
    Then the player score should update
    And team totals should recalculate

  @happy-path @score-corrections
  Scenario: View pending stat corrections
    When I view pending stat corrections
    Then I should see corrections from the NFL
    And I should be able to apply them
    And I should see which matchups are affected

  @happy-path @score-corrections
  Scenario: Reverse a score correction
    Given I made a score correction
    When I reverse the correction
    Then the original score should be restored
    And the reversal should be logged

  # ============================================================================
  # TRADE APPROVAL/VETO
  # ============================================================================

  @happy-path @trades
  Scenario: Approve pending trade
    Given a trade is pending commissioner approval
    When I approve the trade
    Then the trade should process
    And both teams should be notified
    And rosters should update

  @happy-path @trades
  Scenario: Veto a trade
    Given a trade is pending
    When I veto the trade with reason "Competitive imbalance"
    Then the trade should be cancelled
    And both parties should be notified
    And the veto reason should be visible

  @happy-path @trades
  Scenario: Push trade through immediately
    Given a trade requires review period
    When I push the trade through
    Then the trade should process immediately
    And the review period should be bypassed
    And an audit log should be created

  @happy-path @trades
  Scenario: Set trade review settings
    When I configure trade settings:
      | Setting           | Value                |
      | Review Period     | 24 hours             |
      | Approval Method   | Commissioner Only    |
      | Veto Threshold    | N/A                  |
    Then trade settings should update

  @happy-path @trades
  Scenario: Review trade history
    When I view trade history
    Then I should see all trades
    And I should see approval/veto status
    And I should see commissioner actions

  # ============================================================================
  # ROSTER LOCK/UNLOCK
  # ============================================================================

  @happy-path @roster-lock
  Scenario: Lock all rosters
    When I lock all rosters
    Then no roster changes should be allowed
    And members should be notified
    And I should set unlock time

  @happy-path @roster-lock
  Scenario: Lock specific team's roster
    When I lock "TeamA" roster
    Then only that team should be locked
    And the reason should be recorded
    And an unlock time should be set

  @happy-path @roster-lock
  Scenario: Unlock roster early
    Given a roster is locked
    When I unlock it early
    Then roster changes should be allowed
    And the early unlock should be logged

  @happy-path @roster-lock
  Scenario: Lock rosters for playoffs
    When I enable playoff roster locks
    Then rosters should lock for playoff teams
    And non-playoff teams should remain editable
    And playoff settings should apply

  @happy-path @roster-lock
  Scenario: Set roster lock deadline
    When I set roster lock for "Sunday 1:00 PM"
    Then all rosters should lock at that time
    And countdown should be visible
    And members should receive reminders

  # ============================================================================
  # WAIVER WIRE MANAGEMENT
  # ============================================================================

  @happy-path @waivers
  Scenario: Process waivers manually
    Given waivers are pending
    When I process waivers manually
    Then claims should be processed in priority order
    And results should be applied
    And members should be notified

  @happy-path @waivers
  Scenario: Modify waiver priority
    When I change waiver priority:
      | Team   | Old Priority | New Priority |
      | TeamA  | 5            | 1            |
      | TeamB  | 1            | 5            |
    Then priorities should update
    And the change should be logged

  @happy-path @waivers
  Scenario: Add player to waivers
    When I place "Free Agent Player" on waivers
    Then the player should be on waivers
    And claims should be allowed

  @happy-path @waivers
  Scenario: Modify FAAB budget
    When I adjust "TeamA" FAAB budget by +$20
    Then their budget should increase
    And the adjustment should be logged
    And a reason should be required

  @happy-path @waivers
  Scenario: Cancel waiver claim
    When I cancel "TeamA" waiver claim
    Then the claim should be removed
    And the team should be notified

  # ============================================================================
  # DRAFT ORDER CONFIGURATION
  # ============================================================================

  @happy-path @draft
  Scenario: Set draft order manually
    When I set draft order:
      | Pick | Team   |
      | 1    | TeamA  |
      | 2    | TeamB  |
      | 3    | TeamC  |
    Then the draft order should be set
    And all members should be notified

  @happy-path @draft
  Scenario: Randomize draft order
    When I randomize draft order
    Then a random order should be generated
    And I should see the randomization animation
    And results should be locked

  @happy-path @draft
  Scenario: Schedule draft
    When I schedule draft for "September 1, 7:00 PM ET"
    Then the draft should be scheduled
    And calendar invites should be sent
    And reminders should be configured

  @happy-path @draft
  Scenario: Pause active draft
    Given a draft is in progress
    When I pause the draft
    Then the draft should pause
    And all members should see pause notification
    And I should set a resume time

  @happy-path @draft
  Scenario: Make pick for absent manager
    Given a manager is absent during draft
    When I make a pick for them
    Then the pick should be recorded
    And the pick should be marked as commissioner pick

  # ============================================================================
  # PLAYOFF SEEDING OVERRIDES
  # ============================================================================

  @happy-path @playoffs
  Scenario: Override playoff seeding
    When I override playoff seeding:
      | Seed | Original Team | New Team |
      | 1    | TeamA         | TeamB    |
      | 2    | TeamB         | TeamA    |
    Then seeding should update
    And a reason should be required
    And the override should be logged

  @happy-path @playoffs
  Scenario: Manually set playoff bracket
    When I configure the playoff bracket
    Then I should set matchups manually
    And I should assign seeds
    And the bracket should be published

  @happy-path @playoffs
  Scenario: Add wildcard team
    When I add a wildcard team to playoffs
    Then the team should be added
    And the bracket should adjust
    And members should be notified

  @happy-path @playoffs
  Scenario: Reseed after each round
    When I enable automatic reseeding
    Then brackets should reseed after each round
    And highest seeds should face lowest

  # ============================================================================
  # LEAGUE ANNOUNCEMENTS
  # ============================================================================

  @happy-path @announcements
  Scenario: Post league announcement
    When I post an announcement:
      """
      Trade deadline is this Friday at 5 PM!
      Make your moves before then.
      """
    Then the announcement should be visible
    And all members should be notified
    And it should pin to the top

  @happy-path @announcements
  Scenario: Schedule announcement
    When I schedule an announcement for "October 15, 9:00 AM"
    Then the announcement should post at that time
    And I should see scheduled announcements

  @happy-path @announcements
  Scenario: Send targeted announcement
    When I send an announcement to playoff teams only
    Then only playoff teams should see it
    And the targeting should be logged

  @happy-path @announcements
  Scenario: Edit existing announcement
    Given I posted an announcement
    When I edit the announcement
    Then the update should be visible
    And an edit indicator should appear

  @happy-path @announcements
  Scenario: Delete announcement
    When I delete an announcement
    Then it should be removed
    And members should no longer see it

  # ============================================================================
  # SEASON SCHEDULING
  # ============================================================================

  @happy-path @scheduling
  Scenario: Generate season schedule
    When I generate the season schedule
    Then matchups should be created for all weeks
    And the schedule should be balanced
    And I should be able to preview

  @happy-path @scheduling
  Scenario: Modify weekly matchup
    When I change Week 5 matchup from "TeamA vs TeamB" to "TeamA vs TeamC"
    Then the schedule should update
    And affected teams should be notified

  @happy-path @scheduling
  Scenario: Set rivalry week
    When I designate Week 10 as rivalry week
    And I set specific rivalry matchups
    Then rivalry matchups should be scheduled
    And they should be highlighted

  @happy-path @scheduling
  Scenario: Configure playoff schedule
    When I configure playoff schedule:
      | Round       | Week    |
      | Wild Card   | Week 15 |
      | Semifinals  | Week 16 |
      | Championship| Week 17 |
    Then the playoff schedule should be set

  # ============================================================================
  # DISPUTE RESOLUTION
  # ============================================================================

  @happy-path @disputes
  Scenario: Open dispute case
    When a member files a dispute
    Then I should see the dispute details
    And I should see relevant evidence
    And I should have resolution options

  @happy-path @disputes
  Scenario: Resolve dispute
    When I resolve a dispute:
      | Resolution   | Ruling                        |
      | Decision     | In favor of TeamA             |
      | Action       | Score adjustment of +5 points |
      | Reason       | Verified stat correction      |
    Then the resolution should be applied
    And both parties should be notified

  @happy-path @disputes
  Scenario: Request league vote on dispute
    When I escalate dispute to league vote
    Then all members should vote
    And the majority should determine outcome
    And voting should have a deadline

  @happy-path @disputes
  Scenario: View dispute history
    When I view dispute history
    Then I should see all past disputes
    And I should see resolutions
    And I should see precedents set

  # ============================================================================
  # COMMISSIONER SUCCESSION
  # ============================================================================

  @happy-path @succession
  Scenario: Transfer commissioner role
    When I transfer commissioner to "JaneDoe"
    Then JaneDoe should become commissioner
    And I should become a regular member
    And the transfer should be logged

  @happy-path @succession
  Scenario: Set succession plan
    When I designate "JaneDoe" as successor
    Then they should be listed as backup commissioner
    And they should take over if I'm inactive

  @happy-path @succession
  Scenario: Commissioner vote
    Given the commissioner has been inactive
    When members vote for a new commissioner
    Then the winner should become commissioner
    And the transition should be automatic

  @happy-path @succession
  Scenario: Resign as commissioner
    When I resign as commissioner
    Then I should nominate a replacement
    Or a vote should be triggered
    And the resignation should be logged

  # ============================================================================
  # LEAGUE ARCHIVE/EXPORT
  # ============================================================================

  @happy-path @archive
  Scenario: Archive league season
    When I archive the current season
    Then all data should be preserved
    And the league should be ready for new season
    And historical data should be accessible

  @happy-path @archive
  Scenario: Export league data
    When I export league data
    Then I should receive a comprehensive file
    And it should include:
      | Data Type         |
      | Rosters           |
      | Transactions      |
      | Scores            |
      | Settings          |
      | Member info       |

  @happy-path @archive
  Scenario: Export for platform migration
    When I export for migration to another platform
    Then I should receive a compatible format
    And import instructions should be provided

  @happy-path @archive
  Scenario: Delete league permanently
    When I delete the league permanently
    Then I should confirm multiple times
    And all data should be removed
    And members should be notified

  # ============================================================================
  # PENALTY/BONUS ADJUSTMENTS
  # ============================================================================

  @happy-path @adjustments
  Scenario: Apply point penalty
    When I apply a penalty to "TeamA":
      | Week | Points | Reason                |
      | 5    | -5     | Missed lineup deadline|
    Then the penalty should be applied
    And the team should be notified
    And it should affect standings

  @happy-path @adjustments
  Scenario: Apply bonus points
    When I apply a bonus to "TeamB":
      | Week | Points | Reason             |
      | 3    | +3     | Survivor challenge |
    Then the bonus should be applied
    And it should be visible in scoring

  @happy-path @adjustments
  Scenario: Schedule recurring adjustment
    When I schedule weekly bonus for "League High Score"
    Then the bonus should apply automatically
    And the winner each week should receive it

  @happy-path @adjustments
  Scenario: Remove adjustment
    Given an adjustment was applied
    When I remove the adjustment
    Then scores should revert
    And the removal should be logged

  # ============================================================================
  # TEAM OWNERSHIP TRANSFERS
  # ============================================================================

  @happy-path @ownership
  Scenario: Transfer team ownership
    When I transfer "TeamA" from "JohnSmith" to "NewOwner"
    Then NewOwner should control TeamA
    And JohnSmith should lose access
    And history should be preserved

  @happy-path @ownership
  Scenario: Take over orphaned team
    Given "TeamB" has no active owner
    When I assign "NewOwner" to TeamB
    Then they should gain control
    And the team should no longer be orphaned

  @happy-path @ownership
  Scenario: Co-owner management
    When I add "CoOwner" as co-owner of "TeamA"
    Then both should have control
    And permissions should be shared

  @happy-path @ownership
  Scenario: Temporary team management
    When I temporarily manage "TeamA" for absent owner
    Then I should have roster control
    And my actions should be logged
    And ownership should return when they're back

  # ============================================================================
  # EMERGENCY ROSTER MOVES
  # ============================================================================

  @happy-path @emergency
  Scenario: Emergency roster swap
    Given rosters are locked
    And a player is injured before game time
    When I make an emergency roster swap
    Then the swap should be allowed
    And it should be logged as emergency
    And the team should be notified

  @happy-path @emergency
  Scenario: Force add player to roster
    When I force add "Free Agent" to "TeamA" roster
    Then the player should be added
    And normal waiver rules should be bypassed
    And the action should be logged

  @happy-path @emergency
  Scenario: Emergency IR placement
    When I place "Injured Player" on IR for "TeamA"
    Then the player should move to IR
    And a roster spot should open
    And it should bypass normal rules

  @happy-path @emergency
  Scenario: Unlock roster for emergency
    Given rosters are locked
    When I temporarily unlock "TeamA" roster for 30 minutes
    Then they should be able to make changes
    And it should re-lock automatically

  # ============================================================================
  # COMMISSIONER NOTIFICATIONS
  # ============================================================================

  @happy-path @notifications
  Scenario: Send league-wide notification
    When I send notification to all members
    Then everyone should receive it
    And I should choose delivery method (push, email)

  @happy-path @notifications
  Scenario: Send targeted notification
    When I send notification to inactive members only
    Then only inactive members should receive it

  @happy-path @notifications
  Scenario: Configure automated notifications
    When I configure automated notifications:
      | Event              | Notification        |
      | Trade Pending      | Email to commish    |
      | Dispute Filed      | Push to commish     |
      | Roster Deadline    | Email to all        |
    Then notifications should be automated

  @happy-path @notifications
  Scenario: View notification history
    When I view notification history
    Then I should see all sent notifications
    And I should see delivery status
    And I should see read receipts

  # ============================================================================
  # AUDIT LOGS
  # ============================================================================

  @happy-path @audit
  Scenario: View commissioner action log
    When I view the audit log
    Then I should see all commissioner actions:
      | Action             | Date       | Details              |
      | Score Correction   | 2024-10-15 | TeamA +2.5 points    |
      | Trade Veto         | 2024-10-14 | Blocked trade #123   |
      | Member Removed     | 2024-10-10 | JohnSmith removed    |

  @happy-path @audit
  Scenario: Filter audit log
    When I filter audit log by "Trade Actions"
    Then I should see only trade-related entries

  @happy-path @audit
  Scenario: Export audit log
    When I export the audit log
    Then I should receive a downloadable file
    And it should include all actions with timestamps

  @happy-path @audit
  Scenario: Audit log retention
    When I view audit log settings
    Then I should see retention period
    And I should be able to configure archival

  @happy-path @audit
  Scenario: View who made each change
    When I view a specific audit entry
    Then I should see:
      | Field        | Value              |
      | Action       | Score Correction   |
      | Commissioner | MyUsername         |
      | Timestamp    | 2024-10-15 3:45 PM |
      | IP Address   | 192.168.1.1        |
      | Reason       | NFL stat update    |

  # ============================================================================
  # COMMISSIONER DASHBOARD
  # ============================================================================

  @happy-path @dashboard
  Scenario: View commissioner dashboard
    When I view the commissioner dashboard
    Then I should see league health metrics:
      | Metric              | Status    |
      | Active Members      | 12/12     |
      | Lineups Set         | 10/12     |
      | Pending Actions     | 3         |
      | Disputes Open       | 0         |

  @happy-path @dashboard
  Scenario: View pending actions
    When I view pending actions
    Then I should see:
      | Action Type     | Count | Priority |
      | Trade Approvals | 2     | High     |
      | Join Requests   | 1     | Medium   |
      | Disputes        | 0     | Low      |

  @happy-path @dashboard
  Scenario: Quick actions from dashboard
    When I use quick actions
    Then I should be able to:
      | Quick Action              |
      | Send Announcement         |
      | Process Waivers           |
      | Lock All Rosters          |
      | Generate Schedule         |

  @happy-path @dashboard
  Scenario: View league activity summary
    When I view activity summary
    Then I should see recent league activity
    And I should see trends over time
    And I should see engagement metrics

  @happy-path @dashboard
  Scenario: Configure dashboard widgets
    When I customize my dashboard
    Then I should be able to add/remove widgets
    And I should arrange them as preferred
    And my layout should be saved

  # ============================================================================
  # MOBILE / RESPONSIVE
  # ============================================================================

  @mobile @responsive
  Scenario: Commissioner tools on mobile
    Given I am using a mobile device
    When I access commissioner tools
    Then I should see a mobile-optimized interface
    And all functions should be accessible
    And critical actions should require confirmation

  @mobile @responsive
  Scenario: Quick approvals on mobile
    Given I am on mobile
    When I receive a trade approval notification
    Then I should be able to approve/deny quickly
    And I should see essential trade details

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility @a11y
  Scenario: Screen reader support
    Given I am using a screen reader
    When I navigate commissioner tools
    Then all actions should be accessible
    And confirmations should be announced
    And form fields should be labeled

  @accessibility @a11y
  Scenario: Keyboard navigation
    Given I am using keyboard only
    When I perform commissioner actions
    Then all functions should be keyboard accessible
    And focus should be clearly visible

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error @resilience
  Scenario: Handle failed action gracefully
    Given I am performing a commissioner action
    When the action fails
    Then I should see a clear error message
    And the action should not partially apply
    And I should be able to retry

  @error @resilience
  Scenario: Confirm destructive actions
    When I attempt a destructive action
    Then I should see a confirmation dialog
    And I should type confirmation text
    And I should understand the consequences

  @error @resilience
  Scenario: Undo recent action
    Given I made a commissioner action
    When I click undo within 5 minutes
    Then the action should be reversed
    And the undo should be logged
