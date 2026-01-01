@backend @priority_1 @commissioners @administration
Feature: Comprehensive Commissioners System
  As a fantasy football playoffs application
  I want to provide commissioners with complete league management powers and tools
  So that they can effectively administer fair and engaging playoff competitions

  Background:
    Given a league "2025 NFL Playoffs Pool" exists
    And user "commissioner_joe" is the league commissioner
    And the league has 12 registered teams

  # ==================== COMMISSIONER POWERS ====================

  Scenario: Display commissioner dashboard
    Given commissioner_joe is logged in
    When commissioner_joe accesses the commissioner dashboard
    Then the dashboard displays:
      | Section               | Content                          |
      | League Status         | Active, 12 teams, Week 2         |
      | Pending Actions       | 3 trades, 1 dispute              |
      | Recent Activity       | Last 10 transactions             |
      | Quick Actions         | Shortcuts to common tasks        |
      | League Health         | Payment status, roster compliance|

  Scenario: View complete commissioner powers
    Given commissioner_joe views their permissions
    When viewing commissioner powers
    Then available powers include:
      | Power Category        | Actions Available                |
      | League Settings       | Modify all settings              |
      | Member Management     | Add, remove, suspend members     |
      | Transaction Control   | Approve, veto, reverse trades    |
      | Scoring               | Adjust scores, apply corrections |
      | Financial             | Manage fees, distribute prizes   |
      | Communication         | League-wide announcements        |
      | Governance            | Create rules, resolve disputes   |

  Scenario: Grant co-commissioner privileges
    Given commissioner_joe needs administrative help
    When commissioner_joe grants co-commissioner to "trusted_member":
      | Permission            | Granted |
      | View admin dashboard  | Yes     |
      | Approve trades        | Yes     |
      | Process waivers       | Yes     |
      | Adjust scores         | No      |
      | Manage members        | No      |
      | Modify settings       | No      |
    Then trusted_member has limited commissioner powers
    And actions are logged under trusted_member's ID

  Scenario: Revoke co-commissioner privileges
    Given "trusted_member" has co-commissioner privileges
    When commissioner_joe revokes privileges
    Then trusted_member loses commissioner access
    And trusted_member becomes regular member
    And notification is sent to trusted_member

  Scenario: Transfer commissioner role
    Given commissioner_joe is stepping down
    When commissioner_joe transfers role to "new_commissioner"
    Then new_commissioner becomes full commissioner
    And commissioner_joe becomes regular member
    And all league members are notified
    And transfer is logged in league history

  Scenario: Emergency commissioner powers
    Given an urgent situation requires immediate action
    When commissioner uses emergency powers:
      | Action                | Scenario                         |
      | Pause all activity    | System issue detected            |
      | Lock all rosters      | Suspected cheating investigation |
      | Reverse transaction   | Obvious error or collusion       |
    Then action is executed immediately
    And emergency log entry is created
    And affected members are notified

  # ==================== LEAGUE MANAGEMENT ====================

  Scenario: Modify league settings
    Given commissioner accesses league settings
    When commissioner modifies settings:
      | Setting               | Old Value    | New Value       |
      | Trade deadline        | Week 3       | Week 2          |
      | Waiver type           | Standard     | FAAB            |
      | Playoff teams         | 6            | 8               |
    Then settings are updated
    And members are notified of changes
    And change history is logged

  Scenario: Lock league settings during playoffs
    Given playoffs have started
    When commissioner attempts to modify scoring settings
    Then modification is blocked
    And message shows "Critical settings locked during playoffs"
    And only non-critical settings can be changed

  Scenario: Override setting lock with justification
    Given playoffs are in progress
    And an emergency setting change is needed
    When commissioner overrides lock:
      | Setting               | Change                    |
      | Roster lock time      | Move 1 hour earlier       |
      | Justification         | NFL schedule change       |
    Then setting is changed despite lock
    And override is logged with justification
    And members are notified

  Scenario: Configure playoff structure
    Given commissioner is setting up playoffs
    When commissioner configures:
      | Setting               | Value                     |
      | Playoff format        | 8-team bracket            |
      | Seeding               | By record, then points    |
      | Bye weeks             | Top 2 seeds               |
      | Consolation           | Enabled                   |
    Then playoff structure is saved
    And bracket preview is generated

  Scenario: Set league schedule
    Given commissioner manages schedule
    When commissioner sets schedule:
      | Event                 | Date                      |
      | Draft                 | January 5, 2025           |
      | Wild Card lock        | January 11, 4:25 PM       |
      | Trade deadline        | January 20, 2025          |
      | Championship          | February 9, 2025          |
    Then schedule is published
    And calendar events are created

  Scenario: Rename league
    Given commissioner wants to rebrand
    When commissioner changes league name to "Elite Playoff Challenge"
    Then league name is updated everywhere
    And historical records maintain reference
    And members are notified

  # ==================== MEMBER MANAGEMENT ====================

  Scenario: Invite new member to league
    Given league has available spots
    When commissioner invites "new_user@email.com":
      | Field                 | Value                     |
      | Message               | Join our playoff pool!   |
      | Expiration            | 7 days                    |
      | Auto-assign team      | Yes                       |
    Then invitation email is sent
    And pending invitation is tracked

  Scenario: Approve join request
    Given user "applicant" has requested to join
    When commissioner reviews and approves request
    Then applicant is added to the league
    And applicant receives welcome notification
    And applicant can create their team

  Scenario: Reject join request
    Given user "unwanted_user" has requested to join
    When commissioner rejects request:
      | Reason                | League is private for friends |
    Then unwanted_user is notified of rejection
    And unwanted_user cannot re-apply for 30 days

  Scenario: Remove member from league
    Given member "problem_member" has violated rules
    When commissioner removes problem_member:
      | Reason                | Repeated violations       |
      | Handle team           | Lock until replaced       |
      | Refund                | No                        |
    Then problem_member loses access
    And their team is locked
    And removal is logged with reason

  Scenario: Suspend member temporarily
    Given member "dispute_member" is under investigation
    When commissioner suspends dispute_member:
      | Duration              | 7 days                    |
      | Restrictions          | No roster moves           |
      | Reason                | Collusion investigation   |
    Then dispute_member has limited access
    And suspension expires automatically
    And suspension is logged

  Scenario: Reinstate suspended member
    Given member "cleared_member" was suspended
    When commissioner lifts suspension
    Then cleared_member regains full access
    And notification is sent
    And reinstatement is logged

  Scenario: Force team ownership transfer
    Given member "inactive_owner" has abandoned team
    When commissioner forces transfer to "replacement_owner":
      | Effective date        | Immediately               |
      | Notification          | Both parties              |
    Then replacement_owner controls team
    And inactive_owner loses access
    And transfer is logged

  Scenario: View member activity report
    Given commissioner wants to check member engagement
    When commissioner generates activity report
    Then report shows:
      | Member          | Last Login | Roster Moves | Trades | Messages |
      | john_doe        | Today      | 5            | 2      | 12       |
      | jane_doe        | 2 days ago | 3            | 1      | 8        |
      | inactive_user   | 2 weeks    | 0            | 0      | 0        |

  # ==================== TRANSACTION APPROVAL ====================

  Scenario: Configure transaction review settings
    Given commissioner sets review policies
    When configuring transaction review:
      | Transaction Type      | Review Required    |
      | Standard trade        | No (auto-approve)  |
      | Trade with picks      | Yes                |
      | Large FAAB bid        | Yes (>$50)         |
      | Add/Drop              | No                 |
    Then policies are enforced
    And flagged transactions await review

  Scenario: Approve pending trade
    Given a trade awaits commissioner approval
    When commissioner reviews trade:
      | Team A Sends          | Team B Sends              |
      | Patrick Mahomes       | Josh Allen + 2nd pick     |
    And commissioner approves trade
    Then trade is executed
    And both teams are notified
    And trade is logged as approved

  Scenario: Veto trade with reason
    Given a trade appears unfair
    When commissioner vetoes trade:
      | Reason                | Trade significantly unbalanced |
      | Detailed explanation  | Mahomes value exceeds offer    |
    Then trade is cancelled
    And both teams receive veto notification with reason
    And veto is logged

  Scenario: Reverse completed trade
    Given a trade was executed but collusion is discovered
    When commissioner reverses trade:
      | Reason                | Collusion confirmed            |
      | Effective date        | Immediately                    |
    Then rosters are restored to pre-trade state
    And both teams are notified
    And reversal is logged with reason

  Scenario: Push through emergency transaction
    Given urgent roster move is needed
    When commissioner pushes transaction:
      | Team                  | Mahomes' Militia              |
      | Action                | Add player from IR            |
      | Reason                | Player cleared to play        |
    Then transaction is executed
    And normal restrictions are bypassed
    And emergency log entry is created

  Scenario: Configure trade veto voting
    Given league uses member voting for trades
    When commissioner configures voting:
      | Setting               | Value                     |
      | Voting enabled        | Yes                       |
      | Veto threshold        | 6 of 12 votes             |
      | Voting period         | 24 hours                  |
      | Commissioner override | Yes                       |
    Then trades are subject to league vote
    And commissioner can override results

  Scenario: View transaction history
    Given commissioner reviews league activity
    When viewing transaction history
    Then history shows:
      | Date       | Type    | Teams           | Details              | Status   |
      | Jan 10     | Trade   | Team A, Team B  | Kelce for Andrews    | Approved |
      | Jan 9      | Veto    | Team C, Team D  | Mahomes for bench    | Vetoed   |
      | Jan 8      | Waiver  | Team A          | Added Rashee Rice    | Complete |

  # ==================== SCORING ADJUSTMENTS ====================

  Scenario: Apply manual score adjustment
    Given a scoring error needs correction
    When commissioner applies adjustment:
      | Team                  | Mahomes' Militia              |
      | Round                 | Wild Card                     |
      | Adjustment            | +3.5 points                   |
      | Reason                | Stat correction for missed TD |
    Then score is updated
    And adjustment is logged with reason
    And affected team is notified

  Scenario: Apply stat correction from NFL
    Given NFL issues official stat correction
    When commissioner applies correction:
      | Player                | Patrick Mahomes               |
      | Original stat         | 325 passing yards             |
      | Corrected stat        | 312 passing yards             |
      | Points impact         | -0.52 points                  |
    Then all affected team scores are updated
    And matchup results are re-evaluated
    And correction log is updated

  Scenario: Reverse score adjustment
    Given a previous adjustment was made in error
    When commissioner reverses adjustment:
      | Original adjustment   | +3.5 points                   |
      | Reason for reversal   | Correction already applied    |
    Then adjustment is removed
    And scores return to previous state
    And reversal is logged

  Scenario: Apply league-wide scoring fix
    Given a scoring rule was applied incorrectly
    When commissioner applies bulk correction:
      | Affected rounds       | All                           |
      | Rule affected         | Passing yards points          |
      | Fix                   | Recalculate with correct rate |
    Then all scores are recalculated
    And all matchups are re-evaluated
    And comprehensive log is created

  Scenario: Lock scores for round
    Given a round has completed
    When commissioner locks scores:
      | Round                 | Wild Card                     |
      | Lock reason           | Round finalized               |
    Then no further changes are allowed
    And scores become official
    And lock timestamp is recorded

  Scenario: View scoring audit trail
    Given commissioner reviews scoring history
    When viewing audit trail for "Mahomes' Militia"
    Then trail shows:
      | Date       | Action          | Original | New    | By           | Reason          |
      | Jan 12     | Adjustment      | 165.5    | 169.0  | commissioner | Stat correction |
      | Jan 11     | Initial score   | -        | 165.5  | System       | Auto-calculated |

  # ==================== COMMUNICATION TOOLS ====================

  Scenario: Post league-wide announcement
    Given commissioner has important news
    When commissioner posts announcement:
      | Title                 | Playoff Rules Reminder         |
      | Message               | Lock times and deadlines...    |
      | Priority              | High                           |
      | Pin to top            | Yes                            |
    Then announcement is visible to all members
    And notifications are sent
    And announcement remains pinned

  Scenario: Send targeted message to specific members
    Given commissioner needs to contact specific teams
    When commissioner sends message:
      | Recipients            | Team A, Team B, Team C         |
      | Subject               | Trade deadline reminder        |
      | Message               | Complete pending trades by...  |
    Then message is sent only to selected members
    And delivery is confirmed

  Scenario: Send email to all members
    Given commissioner needs external communication
    When commissioner sends email:
      | Subject               | League Update                  |
      | Content               | Important information about... |
      | Include roster info   | Yes                            |
    Then email is sent to all member emails
    And unsubscribed members are excluded
    And send log is updated

  Scenario: Create league poll
    Given commissioner wants member input
    When commissioner creates poll:
      | Question              | Extend trade deadline?         |
      | Options               | Yes, No, 24 hours only         |
      | Voting period         | 48 hours                       |
      | Anonymous             | Yes                            |
    Then poll is visible to all members
    And members can vote
    And results update in real-time

  Scenario: Moderate league message board
    Given inappropriate content is posted
    When commissioner moderates:
      | Action                | Delete post                    |
      | Reason                | Violated league conduct rules  |
      | Warn user             | Yes                            |
    Then post is removed
    And poster receives warning
    And moderation is logged

  Scenario: Configure communication settings
    Given commissioner manages communication
    When setting communication rules:
      | Setting               | Value                          |
      | Message board         | Enabled                        |
      | Direct messaging      | Enabled                        |
      | Commissioner-only     | Important updates channel      |
      | Trash talk thread     | Enabled with guidelines        |
    Then communication features are configured

  Scenario: Broadcast emergency message
    Given urgent situation requires immediate attention
    When commissioner broadcasts emergency:
      | Message               | Games postponed - check updates|
      | Delivery              | Push, Email, SMS               |
      | Override quiet hours  | Yes                            |
    Then message is sent immediately
    And all delivery methods are used
    And acknowledgment is tracked

  # ==================== LEAGUE GOVERNANCE ====================

  Scenario: Create league constitution
    Given commissioner establishes formal rules
    When commissioner creates constitution:
      | Section               | Content                        |
      | Purpose               | Competitive playoff competition|
      | Conduct               | Fair play, no collusion        |
      | Disputes              | Commissioner final authority   |
      | Amendments            | 2/3 majority vote              |
      | Penalties             | Warning, suspension, removal   |
    Then constitution is published
    And members must acknowledge

  Scenario: Propose rule amendment
    Given a rule change is needed
    When commissioner proposes amendment:
      | Current rule          | 6-team playoffs                |
      | Proposed change       | 8-team playoffs                |
      | Rationale             | More competitive               |
      | Voting period         | 1 week                         |
    Then proposal is posted
    And voting begins
    And threshold is 2/3 majority

  Scenario: Resolve formal dispute
    Given teams have filed a dispute
    When commissioner reviews dispute:
      | Complainant           | Team A                         |
      | Defendant             | Team B                         |
      | Issue                 | Alleged collusion in trade     |
      | Evidence              | Trade history, chat logs       |
    Then commissioner investigates
    And ruling is issued with reasoning
    And all parties are notified

  Scenario: Issue formal warning
    Given member has minor violation
    When commissioner issues warning:
      | Member                | problem_user                   |
      | Violation             | Unsportsmanlike conduct        |
      | Warning level         | First warning                  |
      | Consequences if repeat| Suspension                     |
    Then warning is recorded
    And member is notified
    And warning appears in member file

  Scenario: Enforce league penalty
    Given member has accumulated violations
    When commissioner enforces penalty:
      | Member                | repeat_offender                |
      | Penalty               | Loss of next waiver priority   |
      | Duration              | 1 round                        |
      | Reason                | Third conduct violation        |
    Then penalty is applied
    And member is notified
    And penalty is logged

  Scenario: Handle collusion case
    Given collusion is suspected between teams
    When commissioner investigates:
      | Teams involved        | Team A, Team B                 |
      | Evidence              | Pattern of one-sided trades    |
      | Investigation steps   | Review history, interview owners|
    Then commissioner rules on case
    And if guilty:
      | Action                | Result                         |
      | Void trades           | Rosters restored               |
      | Penalize teams        | Prize ineligibility            |
      | Remove owners         | If severe                      |

  # ==================== FINANCIAL MANAGEMENT ====================

  Scenario: Set up league financials
    Given commissioner configures payments
    When setting up financials:
      | Setting               | Value                          |
      | Entry fee             | $50                            |
      | Payment deadline      | January 5, 2025                |
      | Payment method        | League Safe                    |
      | Late fee              | $10                            |
    Then financial settings are saved
    And members see payment requirements

  Scenario: Track payment status
    Given fees are due
    When commissioner views payment status
    Then status shows:
      | Member        | Fee Due | Status    | Paid Date  |
      | john_doe      | $50     | Paid      | Jan 2      |
      | jane_doe      | $50     | Paid      | Jan 3      |
      | late_user     | $60     | Overdue   | -          |
    And overdue members are highlighted

  Scenario: Send payment reminder
    Given payments are overdue
    When commissioner sends reminder:
      | Recipients            | All unpaid members             |
      | Message               | Payment due by Jan 5           |
      | Include late fee info | Yes                            |
    Then reminders are sent
    And reminder log is updated

  Scenario: Mark payment as received
    Given member paid outside the system
    When commissioner marks payment:
      | Member                | late_user                      |
      | Amount                | $60                            |
      | Method                | Venmo                          |
      | Transaction ID        | VNM12345                       |
    Then payment is recorded
    And member status updates to Paid

  Scenario: Configure prize structure
    Given commissioner sets prizes
    When configuring prizes:
      | Place                 | Prize    | Percentage |
      | 1st                   | $400     | 66.7%      |
      | 2nd                   | $150     | 25.0%      |
      | 3rd                   | $50      | 8.3%       |
      | Weekly high           | $20/week | From pot   |
    Then prize structure is published
    And total equals collected fees

  Scenario: Distribute prizes
    Given season has concluded
    When commissioner distributes prizes:
      | Winner                | Prize   | Method      |
      | champion_team         | $400    | League Safe |
      | runner_up             | $150    | League Safe |
      | third_place           | $50     | League Safe |
    Then payments are processed
    And winners are notified
    And financial records are closed

  Scenario: Process refund
    Given member requests refund before season
    When commissioner approves refund:
      | Member                | withdrawn_user                 |
      | Amount                | $50                            |
      | Reason                | Personal circumstances         |
    Then refund is processed
    And member is removed from league
    And refund is logged

  Scenario: View financial ledger
    Given financial activity has occurred
    When commissioner views ledger
    Then ledger shows:
      | Date    | Type       | Description         | Amount  | Balance |
      | Jan 2   | Fee        | john_doe entry      | +$50    | $50     |
      | Jan 3   | Fee        | jane_doe entry      | +$50    | $100    |
      | Jan 12  | Prize      | Weekly high payout  | -$20    | $580    |

  # ==================== AUDIT TRAIL ====================

  Scenario: View comprehensive audit log
    Given commissioner needs to review history
    When viewing audit log
    Then log shows all actions:
      | Timestamp   | User           | Action              | Details              |
      | Jan 10 2:30 | commissioner   | Trade approved      | Teams A, B           |
      | Jan 10 1:15 | system         | Score calculated    | Wild Card round      |
      | Jan 9 8:00  | commissioner   | Setting changed     | Trade deadline       |

  Scenario: Filter audit log
    Given extensive audit history exists
    When commissioner filters log:
      | Filter                | Value                          |
      | Date range            | Jan 1-15, 2025                 |
      | Action type           | Commissioner actions           |
      | User                  | commissioner_joe               |
    Then filtered results are displayed
    And export option is available

  Scenario: Export audit log
    Given commissioner needs records
    When exporting audit log:
      | Format                | CSV                            |
      | Date range            | Full season                    |
      | Include               | All actions                    |
    Then log is exported
    And file is downloadable

  Scenario: Track commissioner action history
    Given accountability is required
    When viewing commissioner's own history
    Then history shows:
      | Date       | Action              | Target         | Reason               |
      | Jan 10     | Trade approved      | Trade #123     | Fair trade           |
      | Jan 9      | Score adjusted      | Team A         | Stat correction      |
      | Jan 8      | Member warned       | problem_user   | Conduct violation    |

  Scenario: View transaction approval history
    Given commissioner reviews approvals
    When viewing approval history
    Then history shows:
      | Date       | Transaction   | Decision   | Time to Decide | Notes         |
      | Jan 10     | Trade #123    | Approved   | 2 hours        | Standard trade|
      | Jan 9      | Trade #122    | Vetoed     | 4 hours        | Unbalanced    |
      | Jan 8      | Trade #121    | Approved   | 1 hour         | Quick review  |

  Scenario: Generate compliance report
    Given league oversight is needed
    When commissioner generates report
    Then report includes:
      | Section               | Content                        |
      | Rule enforcement      | Violations and penalties       |
      | Transaction review    | Approval/veto statistics       |
      | Financial compliance  | Payment status and records     |
      | Member activity       | Engagement metrics             |

  # ==================== COMMISSIONER TOOLS ====================

  Scenario: Access commissioner command center
    Given commissioner needs quick actions
    When accessing command center
    Then quick actions are available:
      | Action                | Description                    |
      | Lock all rosters      | Emergency roster freeze        |
      | Pause trades          | Stop all trade activity        |
      | Send alert            | Broadcast to all members       |
      | Run waivers           | Process waivers immediately    |
      | Generate reports      | Create league reports          |

  Scenario: Run manual waiver processing
    Given waivers need immediate processing
    When commissioner runs waivers manually
    Then waiver claims are processed
    And results are distributed
    And processing log is created

  Scenario: Force roster lock
    Given emergency requires roster freeze
    When commissioner forces lock:
      | Scope                 | All teams                      |
      | Reason                | Suspected issue                |
      | Duration              | Until further notice           |
    Then all rosters are locked
    And members are notified
    And lock is logged

  Scenario: Simulate playoff scenarios
    Given commissioner wants to preview
    When running scenario simulation:
      | Scenario              | What if Team A wins?           |
    Then simulation shows:
      | Outcome               | Bracket impact                 |
      | Team A advances       | Faces #1 seed                  |
      | Prize implication     | N/A until final                |

  Scenario: Generate league health report
    Given commissioner monitors league status
    When generating health report
    Then report shows:
      | Metric                | Status    | Details              |
      | Payment compliance    | 92%       | 1 member unpaid      |
      | Roster compliance     | 100%      | All rosters valid    |
      | Activity level        | Good      | 80% active this week |
      | Dispute status        | Clear     | No open disputes     |

  Scenario: Backup league data
    Given commissioner wants data safety
    When initiating backup
    Then backup includes:
      | Data type             | Included                       |
      | Settings              | Yes                            |
      | Rosters               | Yes                            |
      | Transactions          | Yes                            |
      | Scores                | Yes                            |
      | Communications        | Yes                            |
    And backup is downloadable

  Scenario: Import league data
    Given league needs restoration
    When commissioner imports backup
    Then data is restored:
      | Verification          | Status                         |
      | Settings match        | Confirmed                      |
      | Members restored      | 12 of 12                       |
      | Transactions intact   | All present                    |
    And import log is created

  Scenario: Schedule automated tasks
    Given commissioner sets up automation
    When configuring scheduled tasks:
      | Task                  | Schedule        | Enabled |
      | Roster lock reminder  | 24h before lock | Yes     |
      | Payment reminder      | Weekly          | Yes     |
      | Waiver processing     | Daily 3 AM      | Yes     |
      | Score updates         | Real-time       | Yes     |
    Then tasks are scheduled
    And automation runs as configured
