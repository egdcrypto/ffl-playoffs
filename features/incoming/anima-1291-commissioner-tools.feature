@ANIMA-1291 @backend @frontend @priority_1 @commissioner @admin
Feature: Commissioner Tools
  As a league commissioner
  I want comprehensive tools to manage my fantasy football playoff league
  So that I can configure settings, manage members, resolve disputes, and ensure fair play

  Background:
    Given a league "2025 NFL Playoffs Pool" exists
    And the league has a commissioner "commissioner_john"
    And the league has 12 members
    And the current user is authenticated as the commissioner

  # ============================================
  # LEAGUE SETTINGS CONFIGURATION
  # ============================================

  @settings @happy-path
  Scenario: Access league settings dashboard
    Given the commissioner is logged in
    When the commissioner navigates to "League Settings"
    Then the settings dashboard is displayed
    And sections include:
      | General Settings       |
      | Scoring Configuration  |
      | Roster Settings        |
      | Draft Settings         |
      | Playoff Settings       |
      | Privacy Settings       |
    And current values are shown for all settings

  @settings @general
  Scenario: Update general league settings
    Given the commissioner is on the settings page
    When the commissioner updates:
      | Setting       | Value                    |
      | League Name   | Elite NFL Playoff League |
      | Description   | Competitive playoff pool |
      | Max Teams     | 16                       |
      | Entry Fee     | $50                      |
    And clicks "Save Settings"
    Then the settings are updated
    And all members are notified of the changes
    And the change is logged in audit history

  @settings @lock
  Scenario: Lock settings after season starts
    Given the playoff season has started
    When the commissioner views settings
    Then certain settings are locked:
      | Setting        | Status |
      | Max Teams      | Locked |
      | Entry Fee      | Locked |
      | Scoring Rules  | Locked |
    And a warning explains why settings are locked
    And commissioner can request unlock for emergencies

  @settings @preview
  Scenario: Preview settings changes before applying
    Given the commissioner is modifying scoring rules
    When clicking "Preview Changes"
    Then a comparison view shows:
      | Setting    | Current Value | New Value |
      | Passing TD | 4 points      | 6 points  |
    And impact analysis shows affected historical scores
    And "Apply" and "Cancel" options are available

  # ============================================
  # MEMBER MANAGEMENT
  # ============================================

  @members @invite
  Scenario: Invite new member to league
    Given the league has 12 of 16 spots filled
    When the commissioner clicks "Invite Member"
    And enters email "newplayer@email.com"
    And clicks "Send Invitation"
    Then an invitation email is sent
    And the invitation appears in "Pending Invitations"
    And the invitation expires in 7 days
    And the audit log records the invitation

  @members @invite-link
  Scenario: Generate shareable invite link
    Given the commissioner wants to invite multiple members
    When clicking "Generate Invite Link"
    Then a unique invite link is created
    And the link can be copied to clipboard
    And link settings allow:
      | Max uses            | 5         |
      | Expiration          | 48 hours  |
      | Requires approval   | Yes/No    |
    And link usage is tracked

  @members @remove
  Scenario: Remove member from league
    Given member "problematic_user" is in the league
    When the commissioner selects "Remove Member"
    And selects "problematic_user"
    And provides reason "Violation of league rules"
    And confirms the removal
    Then "problematic_user" is removed from the league
    And their roster is handled per league rules (released/reassigned)
    And the member receives notification
    And audit log records removal with reason

  @members @remove-restrictions
  Scenario: Restrict removal during active season
    Given the playoff draft has completed
    And games are in progress
    When the commissioner attempts to remove a member
    Then a warning is displayed about mid-season removal
    And options are presented:
      | Option                    | Description                     |
      | Remove & Auto-manage      | System manages orphan team      |
      | Remove & Assign Manager   | Appoint replacement manager     |
      | Suspend Instead           | Disable member without removal  |
    And confirmation requires acknowledgment of impact

  @members @promote
  Scenario: Promote member to co-commissioner
    Given member "trusted_member" is in the league
    When the commissioner selects "Manage Roles"
    And promotes "trusted_member" to Co-Commissioner
    Then "trusted_member" gains commissioner privileges:
      | Privilege                | Granted |
      | Manage members           | Yes     |
      | Modify settings          | Yes     |
      | Resolve disputes         | Yes     |
      | Delete league            | No      |
    And the promotion is logged
    And both are notified

  @members @demote
  Scenario: Demote co-commissioner to regular member
    Given "co_commish" is a co-commissioner
    When the commissioner demotes "co_commish"
    Then "co_commish" becomes a regular member
    And commissioner privileges are revoked
    And both are notified
    And the demotion is logged

  @members @suspend
  Scenario: Suspend member temporarily
    Given member "away_user" needs temporary suspension
    When the commissioner suspends "away_user" for "2 weeks"
    Then "away_user" cannot make roster changes
    And "away_user" auto-pick is enabled
    And a suspension indicator shows on their profile
    And automatic unsuspension is scheduled

  @members @view-activity
  Scenario: View member activity log
    Given the commissioner wants to review a member's activity
    When selecting "View Activity" for "john_doe"
    Then the activity log shows:
      | Timestamp           | Action                    |
      | 2025-01-10 14:30   | Logged in                 |
      | 2025-01-10 14:35   | Updated roster            |
      | 2025-01-10 15:00   | Sent chat message         |
    And filters allow date range and action type
    And export option is available

  # ============================================
  # SCORING RULE ADJUSTMENTS
  # ============================================

  @scoring @view
  Scenario: View current scoring configuration
    Given the commissioner accesses scoring settings
    When viewing the scoring configuration
    Then all scoring categories are displayed:
      | Category           | Points |
      | Passing Yards      | 0.04   |
      | Passing TD         | 4      |
      | Interception       | -2     |
      | Rushing Yards      | 0.1    |
      | Rushing TD         | 6      |
      | Reception (PPR)    | 1      |
    And scoring format (Standard/PPR/Half-PPR) is shown

  @scoring @modify
  Scenario: Modify scoring rules before season
    Given the season has not started
    When the commissioner modifies:
      | Category    | Old Value | New Value |
      | Passing TD  | 4         | 6         |
      | Reception   | 1         | 0.5       |
    And saves the changes
    Then scoring rules are updated
    And members are notified of changes
    And change is logged with timestamp

  @scoring @locked
  Scenario: Prevent scoring changes during active season
    Given the playoff season is in progress
    When the commissioner attempts to change scoring
    Then a warning states "Scoring changes not allowed during active season"
    And an override request option is available
    And override requires supermajority member approval (75%)

  @scoring @custom
  Scenario: Add custom scoring category
    Given the league wants bonus scoring
    When the commissioner adds:
      | Category              | Points |
      | 300+ Passing Yards    | 3      |
      | 100+ Rushing Yards    | 3      |
      | 40+ Yard TD           | 2      |
    Then custom categories are added
    And they appear in scoring breakdown
    And historical scores are not affected

  @scoring @template
  Scenario: Apply scoring template
    Given pre-defined scoring templates exist
    When the commissioner selects "PPR Standard" template
    Then all scoring values are populated from template
    And the commissioner can customize from template
    And "Save as Custom Template" option is available

  # ============================================
  # SCHEDULE MANAGEMENT
  # ============================================

  @schedule @view
  Scenario: View playoff schedule
    Given the playoff schedule is set
    When the commissioner views the schedule
    Then all rounds are displayed:
      | Round        | Start Date    | End Date      |
      | Wild Card    | Jan 11, 2025  | Jan 13, 2025  |
      | Divisional   | Jan 18, 2025  | Jan 19, 2025  |
      | Conference   | Jan 26, 2025  | Jan 26, 2025  |
      | Super Bowl   | Feb 9, 2025   | Feb 9, 2025   |
    And roster lock deadlines are shown

  @schedule @modify
  Scenario: Modify roster lock deadline
    Given rosters lock 5 minutes before kickoff by default
    When the commissioner changes to "1 hour before kickoff"
    Then the new deadline applies to all future games
    And members are notified of the change
    And warning appears if games are within the new deadline

  @schedule @draft
  Scenario: Schedule draft date and time
    Given the draft is not yet scheduled
    When the commissioner sets:
      | Setting      | Value               |
      | Draft Date   | Jan 5, 2025         |
      | Draft Time   | 7:00 PM EST         |
      | Draft Type   | Snake               |
      | Time per Pick| 90 seconds          |
    Then the draft is scheduled
    And all members receive calendar invite
    And countdown shows on league homepage

  @schedule @reschedule
  Scenario: Reschedule draft
    Given the draft is scheduled for Jan 5
    When the commissioner reschedules to Jan 6
    Then all members are notified immediately
    And calendar invites are updated
    And reason for change is recorded
    And original date is kept in audit log

  # ============================================
  # DISPUTE RESOLUTION
  # ============================================

  @dispute @file
  Scenario: Member files a dispute
    Given member "jane_doe" has a scoring complaint
    When jane_doe files a dispute:
      | Type        | Scoring Error                         |
      | Description | TD credited to wrong player           |
      | Evidence    | Screenshot of NFL.com box score       |
    Then the dispute is created with status "PENDING"
    And the commissioner is notified
    And the dispute appears in commissioner dashboard

  @dispute @review
  Scenario: Commissioner reviews dispute
    Given a pending dispute exists
    When the commissioner opens the dispute
    Then dispute details are displayed:
      | Filed By    | jane_doe          |
      | Type        | Scoring Error     |
      | Description | TD credited wrong |
      | Evidence    | Attached images   |
      | Status      | PENDING           |
    And options are: Approve, Deny, Request Info

  @dispute @approve
  Scenario: Approve dispute and apply correction
    Given the commissioner reviews a valid scoring dispute
    When the commissioner approves the dispute
    And enters correction: "+6 points for jane_doe, Week 1"
    Then jane_doe's score is corrected
    And affected standings are recalculated
    And all impacted members are notified
    And the resolution is logged

  @dispute @deny
  Scenario: Deny dispute with explanation
    Given the commissioner reviews an invalid dispute
    When the commissioner denies with reason "Stats verified correct per NFL.com"
    Then the dispute status becomes "DENIED"
    And the filer is notified with explanation
    And appeal option is provided (if configured)

  @dispute @escalate
  Scenario: Escalate dispute to league vote
    Given a controversial dispute requires broader input
    When the commissioner escalates to league vote
    Then all members can vote on the resolution
    And voting deadline is set (48 hours)
    And majority decision is binding
    And results are announced to all

  @dispute @history
  Scenario: View dispute history
    Given multiple disputes have been resolved
    When the commissioner views dispute history
    Then all disputes are listed with:
      | Date Filed | Type    | Filer    | Status   | Resolution |
    And filters by status, type, member are available
    And export option is available

  # ============================================
  # LEAGUE ANNOUNCEMENTS
  # ============================================

  @announcements @create
  Scenario: Create league announcement
    Given the commissioner has news to share
    When creating an announcement:
      | Title       | Welcome to the 2025 Playoffs!        |
      | Content     | Draft scheduled for Jan 5 at 7 PM... |
      | Priority    | Normal                               |
      | Notify      | Email + Push                         |
    Then the announcement is published
    And it appears on the league homepage
    And members receive notifications per settings

  @announcements @urgent
  Scenario: Create urgent announcement
    Given an urgent matter requires immediate attention
    When the commissioner creates an urgent announcement
    Then all members receive immediate push notification
    And the announcement is pinned at top of feed
    And "URGENT" badge is displayed
    And read receipts are tracked

  @announcements @schedule
  Scenario: Schedule future announcement
    Given the commissioner wants to announce something later
    When scheduling announcement for Jan 1, 2025 at 12:00 PM
    Then the announcement is saved as "Scheduled"
    And it auto-publishes at the specified time
    And the commissioner can edit before publication

  @announcements @edit
  Scenario: Edit existing announcement
    Given an announcement has been published
    When the commissioner edits the content
    Then the announcement is updated
    And "Edited" indicator is shown with timestamp
    And edit history is available

  @announcements @delete
  Scenario: Delete announcement
    Given an obsolete announcement exists
    When the commissioner deletes it
    Then the announcement is removed from view
    And a record is kept in audit log
    And deletion is reversible for 30 days

  # ============================================
  # DRAFT SETTINGS
  # ============================================

  @draft @order
  Scenario: Set draft order manually
    Given the draft order needs to be set
    When the commissioner sets order:
      | Pick | Team           |
      | 1    | john_doe       |
      | 2    | jane_doe       |
      | 3    | bob_player     |
      | ...  | ...            |
    Then the draft order is saved
    And all members can view their position
    And order is locked until commissioner changes it

  @draft @randomize
  Scenario: Randomize draft order
    Given the commissioner wants random draft order
    When clicking "Randomize Order"
    Then a random order is generated
    And the randomization can be witnessed live
    And seed/algorithm details are logged for transparency
    And members are notified of their position

  @draft @lottery
  Scenario: Conduct draft lottery
    Given the league uses lottery for draft order
    When the commissioner initiates lottery
    Then lottery balls are assigned based on settings
    And animated lottery drawing is shown
    And results are revealed dramatically
    And complete lottery results are logged

  @draft @pause-resume
  Scenario: Pause and resume draft
    Given the draft is in progress
    When the commissioner pauses the draft
    Then all pick timers stop
    And "PAUSED" status is shown to all
    And reason for pause can be entered
    When the commissioner resumes
    Then timers continue from where they stopped

  @draft @undo-pick
  Scenario: Undo erroneous draft pick
    Given a pick was made in error
    When the commissioner undoes the last pick
    Then the pick is reversed
    And the player becomes available again
    And the drafter can make a new selection
    And undo is logged with reason

  @draft @force-pick
  Scenario: Force pick for absent owner
    Given an owner is unresponsive and timer expired
    When auto-pick has failed or is disabled
    And the commissioner forces a pick
    Then the commissioner selects for that owner
    And "Commissioner Pick" indicator is shown
    And the affected owner is notified

  # ============================================
  # ADMINISTRATIVE OVERRIDES
  # ============================================

  @override @score
  Scenario: Override player score
    Given a scoring error needs correction
    When the commissioner overrides a score:
      | Player      | Patrick Mahomes |
      | Week        | Wild Card       |
      | Original    | 24.5 points     |
      | Override    | 28.5 points     |
      | Reason      | Stat correction |
    Then the score is updated
    And affected team totals are recalculated
    And standings are updated
    And override is logged and visible

  @override @roster
  Scenario: Override roster move
    Given a roster move needs reversal
    When the commissioner overrides:
      | Action      | Reverse waiver claim |
      | Player      | Travis Kelce         |
      | From Team   | john_doe             |
      | To Status   | Free Agent           |
      | Reason      | Waiver processing error |
    Then the roster change is reversed
    And affected teams are notified
    And override is logged

  @override @matchup
  Scenario: Override matchup result
    Given a matchup result is contested
    When the commissioner overrides the result:
      | Original Winner | john_doe      |
      | New Winner      | jane_doe      |
      | Reason          | Scoring error correction |
    Then the matchup result is changed
    And bracket/standings are updated
    And all affected parties are notified
    And override is prominently logged

  @override @deadline
  Scenario: Override roster deadline for member
    Given a member missed deadline due to emergency
    When the commissioner grants deadline extension:
      | Member      | bob_player           |
      | Extension   | 2 hours              |
      | Reason      | Medical emergency    |
    Then bob_player can make roster changes
    And the extension is logged
    And other members are not affected

  @override @warning
  Scenario: Display override warnings
    Given the commissioner initiates an override
    When the override has significant impact
    Then warnings are displayed:
      | Warning                                    |
      | This will affect standings                 |
      | 3 matchup results may change               |
      | All affected members will be notified      |
    And confirmation requires acknowledgment

  # ============================================
  # AUDIT LOGGING
  # ============================================

  @audit @view
  Scenario: View audit log
    Given various administrative actions have occurred
    When the commissioner views the audit log
    Then all actions are listed:
      | Timestamp           | User           | Action              | Details           |
      | 2025-01-10 14:30   | commissioner   | Updated settings    | Changed entry fee |
      | 2025-01-10 14:45   | commissioner   | Removed member      | problematic_user  |
      | 2025-01-10 15:00   | co_commish     | Approved dispute    | jane_doe dispute  |
    And entries are sortable and filterable

  @audit @filter
  Scenario: Filter audit log by criteria
    Given the audit log has many entries
    When the commissioner filters by:
      | Filter      | Value              |
      | Date Range  | Last 7 days        |
      | Action Type | Member Management  |
      | User        | commissioner       |
    Then only matching entries are shown
    And filter can be saved as preset

  @audit @export
  Scenario: Export audit log
    Given the commissioner needs audit records
    When clicking "Export Audit Log"
    Then format options are presented (CSV, PDF)
    And date range can be specified
    And the file downloads with complete records

  @audit @immutable
  Scenario: Audit log entries are immutable
    Given an audit entry exists
    When any attempt is made to modify it
    Then the modification is rejected
    And audit entries cannot be deleted
    And original data is preserved

  @audit @retention
  Scenario: Audit log retention policy
    Given audit logs accumulate over time
    When the retention period passes (e.g., 2 years)
    Then old entries are archived (not deleted)
    And archived entries are accessible on request
    And retention policy is displayed in settings

  # ============================================
  # PERMISSION CONTROLS
  # ============================================

  @permissions @view
  Scenario: View permission settings
    Given the commissioner manages permissions
    When viewing permission settings
    Then role permissions are displayed:
      | Role            | Invite | Remove | Settings | Override |
      | Commissioner    | Yes    | Yes    | Yes      | Yes      |
      | Co-Commissioner | Yes    | Yes    | Limited  | No       |
      | Member          | No     | No     | No       | No       |

  @permissions @customize
  Scenario: Customize role permissions
    Given the commissioner wants custom permissions
    When modifying Co-Commissioner permissions:
      | Permission        | Setting |
      | Manage Members    | Yes     |
      | Modify Settings   | No      |
      | Resolve Disputes  | Yes     |
      | Post Announcements| Yes     |
    Then the permissions are updated
    And existing co-commissioners are affected

  @permissions @create-role
  Scenario: Create custom role
    Given standard roles don't meet needs
    When the commissioner creates "Dispute Moderator" role:
      | Permission        | Setting |
      | View Disputes     | Yes     |
      | Resolve Disputes  | Yes     |
      | Other Actions     | No      |
    Then the new role is available
    And members can be assigned to it

  @permissions @deny-action
  Scenario: Deny action due to insufficient permissions
    Given a co-commissioner tries to delete the league
    When they attempt the action
    Then the action is denied
    And message: "You don't have permission to delete league"
    And the attempt is logged

  # ============================================
  # LEAGUE LIFECYCLE
  # ============================================

  @lifecycle @archive
  Scenario: Archive completed league
    Given the season has ended
    When the commissioner archives the league
    Then the league becomes read-only
    And historical data is preserved
    And the league is moved to "Archived" section
    And members can still view history

  @lifecycle @renew
  Scenario: Renew league for next season
    Given the commissioner wants to run another season
    When clicking "Renew for 2026"
    Then a new season is created
    And member roster is preserved (with opt-in)
    And settings are copied from previous season
    And a fresh draft is scheduled

  @lifecycle @delete
  Scenario: Delete league (with safeguards)
    Given the commissioner wants to delete the league
    When initiating deletion
    Then multiple confirmations are required
    And all members must be notified
    And a 7-day grace period applies
    And only the original commissioner can delete

  @lifecycle @transfer
  Scenario: Transfer commissioner role
    Given the commissioner is stepping down
    When transferring to "new_commish"
    Then "new_commish" becomes the commissioner
    And all commissioner permissions transfer
    And the change is announced to all members
    And original commissioner becomes regular member

  # ============================================
  # ERROR HANDLING
  # ============================================

  @error @save-failure
  Scenario: Handle save failure gracefully
    Given the commissioner is saving settings
    When the save operation fails
    Then an error message is displayed
    And changes are preserved locally
    And retry option is provided
    And support contact is shown

  @error @concurrent-edit
  Scenario: Handle concurrent edit conflict
    Given two co-commissioners edit settings simultaneously
    When both attempt to save
    Then the second save shows conflict warning
    And options to merge or overwrite are provided
    And the first save is not lost

  # ============================================
  # MOBILE SUPPORT
  # ============================================

  @mobile @dashboard
  Scenario: Access commissioner tools on mobile
    Given the commissioner is on a mobile device
    When accessing commissioner tools
    Then a mobile-optimized interface is shown
    And all functions are accessible
    And touch-friendly controls are used

  @mobile @quick-actions
  Scenario: Quick actions on mobile
    Given the commissioner receives a dispute notification
    When viewing on mobile
    Then quick action buttons are available:
      | Approve | Deny | View Details |
    And common actions don't require navigation

  # ============================================
  # NOTIFICATIONS
  # ============================================

  @notifications @settings
  Scenario: Configure commissioner notifications
    Given the commissioner manages notification preferences
    When configuring notifications:
      | Event               | Email | Push | SMS |
      | New dispute         | Yes   | Yes  | No  |
      | Member joined       | Yes   | No   | No  |
      | Settings changed    | Yes   | Yes  | No  |
    Then notification preferences are saved
    And apply to future events

  @notifications @digest
  Scenario: Receive daily commissioner digest
    Given multiple events occurred today
    When the daily digest is sent
    Then a summary email includes:
      | New members: 2              |
      | Pending disputes: 1         |
      | Roster moves: 15            |
      | Upcoming: Draft in 2 days   |
    And links to relevant sections are included
