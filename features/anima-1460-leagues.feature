@backend @priority_1 @leagues @administration
Feature: Comprehensive Leagues System
  As a fantasy football playoffs application
  I want to provide complete league creation, management, and governance capabilities
  So that commissioners can run organized and engaging playoff competitions

  Background:
    Given the fantasy football playoffs platform is available
    And user authentication is configured

  # ==================== LEAGUE CREATION ====================

  Scenario: Create a new league with basic settings
    Given user "commissioner_joe" is logged in
    When commissioner_joe creates a new league:
      | Field           | Value                  |
      | League Name     | 2025 NFL Playoffs Pool |
      | Format          | Playoff Fantasy        |
      | Scoring         | PPR                    |
      | Max Teams       | 12                     |
      | Entry Fee       | $50                    |
    Then the league is created successfully
    And commissioner_joe is assigned as commissioner
    And the league is in "Setup" status

  Scenario: Create a private league with password protection
    Given user "commissioner_joe" is creating a league
    When commissioner_joe sets privacy options:
      | Setting           | Value              |
      | Visibility        | Private            |
      | Join Method       | Password Required  |
      | Password          | SecurePass123      |
    Then the league requires password to join
    And the league is not visible in public listings

  Scenario: Create a public league for open enrollment
    Given user "commissioner_jane" is creating a league
    When commissioner_jane sets privacy options:
      | Setting           | Value              |
      | Visibility        | Public             |
      | Join Method       | Open Enrollment    |
      | Auto-Approve      | Yes                |
    Then the league appears in public listings
    And anyone can join without approval

  Scenario: Create a league from template
    Given predefined league templates exist
    When commissioner creates league from "Standard Playoff Pool" template
    Then all template settings are applied:
      | Setting           | Template Value     |
      | Scoring           | PPR                |
      | Roster Size       | 9 starters         |
      | Playoff Weeks     | 4                  |
      | Tiebreaker        | Highest single position |
    And commissioner can modify template settings

  Scenario: Clone an existing league
    Given commissioner_joe has a league from last year
    When commissioner_joe clones "2024 NFL Playoffs Pool"
    Then a new league is created with copied settings
    And member list is optionally carried over
    And transaction history is not copied
    And the new league is independent

  Scenario: Validate league creation requirements
    Given user attempts to create a league
    When required fields are missing:
      | Missing Field    |
      | League Name      |
      | Scoring Format   |
    Then creation fails with validation errors
    And specific missing fields are identified
    And user is prompted to complete required fields

  Scenario: Set league start date and playoff schedule
    Given a league is being created
    When commissioner sets schedule:
      | Setting           | Value              |
      | Season Start      | January 11, 2025   |
      | Wild Card         | January 11-12      |
      | Divisional        | January 18-19      |
      | Conference        | January 26         |
      | Super Bowl        | February 9         |
    Then the schedule is saved
    And roster lock times are automatically set

  # ==================== LEAGUE SETTINGS ====================

  Scenario: Configure scoring settings
    Given commissioner is editing league settings
    When commissioner configures scoring:
      | Category          | Stat                  | Points |
      | Passing           | Passing Yards         | 0.04   |
      | Passing           | Passing TD            | 4      |
      | Passing           | Interception          | -2     |
      | Rushing           | Rushing Yards         | 0.1    |
      | Rushing           | Rushing TD            | 6      |
      | Receiving         | Reception (PPR)       | 1.0    |
      | Receiving         | Receiving Yards       | 0.1    |
      | Receiving         | Receiving TD          | 6      |
    Then scoring settings are saved
    And all teams see updated scoring rules

  Scenario: Configure roster settings
    Given commissioner is editing roster settings
    When commissioner configures roster positions:
      | Position | Count | Required |
      | QB       | 1     | Yes      |
      | RB       | 2     | Yes      |
      | WR       | 2     | Yes      |
      | TE       | 1     | Yes      |
      | FLEX     | 1     | Yes      |
      | K        | 1     | Yes      |
      | DEF      | 1     | Yes      |
      | BENCH    | 6     | No       |
      | IR       | 1     | No       |
    Then roster configuration is saved
    And teams must follow position requirements

  Scenario: Configure trade settings
    Given commissioner is editing trade rules
    When commissioner configures trades:
      | Setting                | Value           |
      | Trades Allowed         | Yes             |
      | Trade Deadline         | Conference Week |
      | Review Period          | 24 hours        |
      | Commissioner Approval  | No              |
      | Veto System            | League Vote     |
      | Veto Threshold         | 50%             |
    Then trade settings are saved
    And trade rules are enforced

  Scenario: Configure waiver wire settings
    Given commissioner is editing waiver settings
    When commissioner configures waivers:
      | Setting                | Value           |
      | Waiver Type            | FAAB            |
      | FAAB Budget            | $100            |
      | Waiver Period          | 24 hours        |
      | Processing Day         | Daily           |
      | Continuous Waivers     | Yes             |
    Then waiver settings are saved
    And teams receive FAAB budgets

  Scenario: Lock settings after playoffs begin
    Given playoffs have started
    When commissioner attempts to change scoring settings
    Then the change is blocked
    And message shows "Settings locked during playoffs"
    And only non-scoring settings can be modified

  Scenario: Configure tiebreaker rules
    Given commissioner is setting tiebreakers
    When commissioner configures tiebreaker order:
      | Priority | Tiebreaker                    |
      | 1        | Head-to-head record           |
      | 2        | Highest single week score     |
      | 3        | Total season points           |
      | 4        | Original seed                 |
    Then tiebreaker rules are saved
    And rules are applied in specified order

  Scenario: Configure playoff bracket settings
    Given commissioner is configuring playoff format
    When commissioner sets bracket:
      | Setting                | Value           |
      | Bracket Size           | 12 teams        |
      | Rounds                 | 4               |
      | Seeding                | By regular season |
      | Reseeding              | No              |
      | Consolation Bracket    | Yes             |
    Then bracket configuration is saved
    And bracket is generated when playoffs start

  # ==================== LEAGUE MEMBERS ====================

  Scenario: Invite members to join league
    Given commissioner has created a league
    When commissioner sends invitations:
      | Email                  | Message                    |
      | john@email.com         | Join our playoff pool!     |
      | jane@email.com         | Join our playoff pool!     |
      | bob@email.com          | Join our playoff pool!     |
    Then invitations are sent via email
    And invitations contain join link
    And pending invitations are tracked

  Scenario: Accept league invitation
    Given user "new_member" receives invitation
    When new_member clicks join link
    And new_member creates account if needed
    Then new_member joins the league
    And commissioner is notified
    And new_member can create their team

  Scenario: Request to join public league
    Given user "interested_user" finds a public league
    When interested_user requests to join
    Then request is sent to commissioner
    And interested_user sees "Pending Approval" status
    And commissioner can approve or reject

  Scenario: Approve join request
    Given commissioner has pending join requests
    When commissioner approves "new_member" request
    Then new_member gains league access
    And new_member is notified of approval
    And member count is updated

  Scenario: Reject join request
    Given commissioner has pending join requests
    When commissioner rejects "spam_user" request:
      | Reason | League is full for invited members only |
    Then spam_user is notified of rejection
    And request is removed from pending
    And spam_user cannot reapply for 30 days

  Scenario: Remove member from league
    Given commissioner needs to remove a member
    When commissioner removes "problem_member":
      | Reason | Violated league rules repeatedly |
    Then problem_member loses league access
    And problem_member's team is handled:
      | Option | Lock team for season |
    And removal is logged in league history

  Scenario: Transfer team ownership
    Given member "old_owner" cannot continue
    When commissioner transfers team to "new_owner"
    Then new_owner assumes team control
    And roster and history are preserved
    And old_owner loses team access
    And transfer is logged

  Scenario: View league member directory
    Given league has 12 members
    When any member views member directory
    Then directory shows:
      | Member        | Team Name        | Role         | Joined     |
      | commissioner_joe | Mahomes' Militia | Commissioner | Jan 1      |
      | john_doe      | Bills Mafia      | Member       | Jan 2      |
      | jane_doe      | Bird Gang        | Member       | Jan 2      |
    And contact options respect privacy settings

  # ==================== LEAGUE GOVERNANCE ====================

  Scenario: Commissioner makes league announcement
    Given commissioner has important news
    When commissioner posts announcement:
      | Title    | Playoff Rules Reminder          |
      | Message  | Rosters lock 5 minutes before...|
      | Priority | High                            |
    Then all members are notified
    And announcement appears on league home
    And announcement is pinned until removed

  Scenario: Create league rule modification vote
    Given a rule change is proposed
    When commissioner creates vote:
      | Proposal  | Change trade deadline to Super Bowl week |
      | Options   | Yes, No, Abstain                         |
      | Deadline  | January 15, 2025                         |
      | Threshold | 2/3 majority                             |
    Then all members can vote
    And results are tracked in real-time
    And decision is binding when threshold met

  Scenario: Handle rule dispute
    Given members dispute a scoring decision
    When commissioner reviews dispute:
      | Issue      | Stat correction not applied     |
      | Affected   | team_a, team_b                  |
      | Evidence   | NFL.com stat correction notice  |
    Then commissioner makes ruling
    And ruling is documented with reasoning
    And affected parties are notified

  Scenario: Delegate commissioner powers
    Given commissioner needs temporary help
    When commissioner grants co-commissioner role to "trusted_member"
    Then trusted_member gains specified powers:
      | Power                  | Granted |
      | Approve trades         | Yes     |
      | Process waivers        | Yes     |
      | Remove members         | No      |
      | Modify scoring         | No      |
    And actions are logged with co-commissioner ID

  Scenario: Transfer commissioner role
    Given commissioner "original_commish" is leaving
    When original_commish transfers role to "new_commish"
    Then new_commish becomes full commissioner
    And original_commish becomes regular member
    And all members are notified of change

  Scenario: Commissioner resolves collusion allegation
    Given collusion is alleged between teams
    When commissioner investigates:
      | Allegation | Lopsided trade to help team_a    |
      | Trade      | Mahomes for backup QB            |
      | Evidence   | Chat logs, trade history         |
    Then commissioner can:
      | Action              | Result                   |
      | Void the trade      | Rosters restored         |
      | Issue warning       | Documented in history    |
      | Remove members      | If repeat offense        |

  Scenario: Set league constitution
    Given commissioner establishes rules
    When commissioner creates constitution:
      | Section              | Content                         |
      | Purpose              | Competitive playoff pool        |
      | Conduct              | No collusion, respect members   |
      | Disputes             | Commissioner final authority    |
      | Amendments           | 2/3 vote required               |
    Then constitution is saved
    And members must acknowledge rules
    And constitution is reference for disputes

  # ==================== LEAGUE SCHEDULE ====================

  Scenario: Generate playoff matchup schedule
    Given league is ready to start playoffs
    When commissioner generates schedule
    Then matchups are created:
      | Round      | Matchups                              |
      | Wild Card  | 1v12, 2v11, 3v10, 4v9, 5v8, 6v7      |
      | Divisional | Winners advance                       |
      | Conference | Semifinal matchups                    |
      | Super Bowl | Championship matchup                  |
    And bracket is displayed to all members

  Scenario: Set roster lock deadlines
    Given schedule is configured
    When lock times are set:
      | Round      | Lock Time                  |
      | Wild Card  | Sat Jan 11, 4:25 PM ET     |
      | Divisional | Sat Jan 18, 4:25 PM ET     |
      | Conference | Sun Jan 26, 3:00 PM ET     |
      | Super Bowl | Sun Feb 9, 6:30 PM ET      |
    Then locks are enforced at specified times
    And reminders are sent before lock

  Scenario: Display upcoming league events
    Given league has scheduled events
    When member views league calendar
    Then events are displayed:
      | Date       | Event                      | Action Required |
      | Jan 10     | Wild Card roster lock      | Submit lineup   |
      | Jan 11-12  | Wild Card games            | -               |
      | Jan 15     | Trade deadline             | Complete trades |
      | Jan 17     | Divisional roster lock     | Submit lineup   |

  Scenario: Configure scoring periods
    Given commissioner defines scoring periods
    When periods are set:
      | Period     | Start Date  | End Date    | Games   |
      | Wild Card  | Jan 11      | Jan 13      | 6       |
      | Divisional | Jan 18      | Jan 19      | 4       |
      | Conference | Jan 26      | Jan 26      | 2       |
      | Super Bowl | Feb 9       | Feb 9       | 1       |
    Then scoring aggregates within periods
    And standings update after each period

  Scenario: Handle schedule changes
    Given NFL reschedules a game
    When commissioner updates schedule:
      | Original           | New                    |
      | Sun Jan 12, 1 PM   | Mon Jan 13, 8 PM       |
    Then affected roster locks are adjusted
    And members are notified of change
    And projections update for new time

  Scenario: Set waiver processing schedule
    Given waivers need regular processing
    When commissioner sets waiver schedule:
      | Processing Time    | Daily at 3 AM ET       |
      | Claim Period       | 24 hours               |
      | Priority Reset     | After each round       |
    Then waivers process automatically
    And results are posted after processing

  # ==================== LEAGUE FINANCES ====================

  Scenario: Configure league entry fees
    Given commissioner sets up paid league
    When commissioner configures fees:
      | Setting            | Value           |
      | Entry Fee          | $50             |
      | Payment Deadline   | January 5       |
      | Payment Method     | League Safe     |
      | Late Fee           | $10             |
    Then fee structure is saved
    And members see payment requirements

  Scenario: Track payment status
    Given league has entry fees
    When commissioner views payment status
    Then status shows:
      | Member        | Amount Due | Status    | Date Paid  |
      | john_doe      | $50        | Paid      | Jan 2      |
      | jane_doe      | $50        | Paid      | Jan 3      |
      | bob_player    | $50        | Pending   | -          |
    And commissioner can send reminders

  Scenario: Configure prize distribution
    Given league has collected fees
    When commissioner sets prizes:
      | Place          | Prize    | Percentage |
      | 1st Place      | $400     | 66.7%      |
      | 2nd Place      | $150     | 25.0%      |
      | 3rd Place      | $50      | 8.3%       |
      | Weekly High    | Rollover | -          |
    Then prize structure is published
    And total distribution equals total collected

  Scenario: Process weekly high score bonus
    Given league has weekly bonus
    When Wild Card round completes
    Then highest scorer is identified:
      | Winner        | Score  | Prize   |
      | john_doe      | 185.5  | $20     |
    And bonus is recorded in ledger
    And winner is announced

  Scenario: Distribute final prizes
    Given playoffs have concluded
    When commissioner initiates payout:
      | Winner        | Prize   | Method      |
      | champion_team | $400    | League Safe |
      | runner_up     | $150    | League Safe |
      | third_place   | $50     | League Safe |
    Then payouts are processed
    And confirmation is sent to winners
    And league ledger is closed

  Scenario: Handle refund request
    Given member cannot participate
    When member requests refund before playoffs start
    Then commissioner reviews request
    And if approved:
      | Action          | Result              |
      | Issue refund    | Member removed      |
      | Find replacement| Team transferred    |
    And financial records are updated

  Scenario: View league financial ledger
    Given financial transactions exist
    When commissioner views ledger
    Then ledger shows:
      | Date    | Type       | Description        | Amount  | Balance |
      | Jan 2   | Payment    | john_doe entry fee | +$50    | $50     |
      | Jan 3   | Payment    | jane_doe entry fee | +$50    | $100    |
      | Jan 12  | Payout     | Weekly high bonus  | -$20    | $80     |
    And ledger can be exported

  # ==================== LEAGUE COMMUNICATION ====================

  Scenario: Post to league message board
    Given league has message board enabled
    When member "john_doe" posts message:
      | Title   | Bold Prediction: Bills Win It All    |
      | Content | Here's why I think the Bills...      |
    Then message appears on board
    And other members can reply
    And notifications are sent per preferences

  Scenario: Send league-wide email
    Given commissioner needs to contact all members
    When commissioner sends email:
      | Subject | Important: Roster Lock Reminder       |
      | Body    | Don't forget to set lineups by...     |
    Then email is sent to all members
    And send history is logged
    And unsubscribed members are excluded

  Scenario: Enable league chat
    Given real-time chat is available
    When commissioner enables chat:
      | Setting            | Value           |
      | Chat Enabled       | Yes             |
      | Moderation         | Commissioner    |
      | History Retention  | 90 days         |
    Then chat is available to members
    And chat respects league rules

  Scenario: Create private chat channel
    Given league chat is enabled
    When commissioner creates channel:
      | Name        | Trade Talk                |
      | Members     | Selected members only     |
      | Purpose     | Discuss potential trades  |
    Then channel is created
    And only invited members can access

  Scenario: Moderate chat message
    Given inappropriate message is posted
    When commissioner moderates:
      | Action      | Delete message            |
      | Reason      | Violated conduct rules    |
      | Warning     | Yes                       |
    Then message is removed
    And poster receives warning
    And moderation is logged

  Scenario: Set up trash talk thread
    Given league enjoys competitive banter
    When commissioner creates thread:
      | Name        | Smack Talk Central        |
      | Rules       | Keep it fun, no personal attacks |
    Then thread is available
    And posts are clearly labeled as banter

  Scenario: Configure notification preferences
    Given member wants to control notifications
    When member sets preferences:
      | Notification Type    | Email | Push | In-App |
      | Matchup results      | Yes   | Yes  | Yes    |
      | Trade offers         | Yes   | Yes  | Yes    |
      | Chat mentions        | No    | Yes  | Yes    |
      | Commissioner updates | Yes   | Yes  | Yes    |
    Then preferences are saved
    And notifications respect settings

  # ==================== LEAGUE HISTORY ====================

  Scenario: View league champion history
    Given league has multi-year history
    When viewing champion history
    Then history shows:
      | Year | Champion         | Runner-Up        | Score     |
      | 2024 | Mahomes' Militia | Bills Mafia      | 185-172   |
      | 2023 | Bird Gang        | Purple Reign     | 165-158   |
      | 2022 | Bills Mafia      | Mahomes' Militia | 178-175   |
    And records are preserved permanently

  Scenario: View all-time league records
    Given historical performance data exists
    When viewing league records
    Then records show:
      | Record                   | Holder           | Value   | Date       |
      | Highest Weekly Score     | john_doe         | 198.5   | Jan 2024   |
      | Highest Season Total     | jane_doe         | 1,892   | 2023       |
      | Longest Win Streak       | bob_player       | 8       | 2022-2023  |
      | Most Championships       | commissioner_joe | 3       | All-time   |

  Scenario: View member career statistics
    Given members have multi-year participation
    When viewing career stats for "john_doe"
    Then stats show:
      | Statistic              | Value    |
      | Seasons Played         | 5        |
      | Championships          | 2        |
      | Playoff Appearances    | 4        |
      | Career Win-Loss        | 28-17    |
      | Total Points Scored    | 8,542.5  |

  Scenario: View draft history
    Given drafts have been conducted
    When viewing draft history
    Then history shows:
      | Year | Round | Pick | Team             | Player          |
      | 2025 | 1     | 3    | Mahomes' Militia | Patrick Mahomes |
      | 2025 | 1     | 4    | Bills Mafia      | Josh Allen      |
    And pick values can be analyzed

  Scenario: View transaction history
    Given transactions have occurred
    When viewing transaction log
    Then log shows:
      | Date    | Type   | Team             | Details                    |
      | Jan 10  | Trade  | Multiple         | Kelce for Andrews + pick   |
      | Jan 8   | Add    | Mahomes' Militia | Added Rashee Rice          |
      | Jan 7   | Drop   | Bills Mafia      | Dropped Stefon Diggs       |
    And transactions are filterable

  Scenario: Archive completed season
    Given current season has concluded
    When commissioner archives season
    Then season data is preserved:
      | Data Type           | Archived |
      | Final standings     | Yes      |
      | All rosters         | Yes      |
      | Weekly scores       | Yes      |
      | Transactions        | Yes      |
      | Chat history        | Optional |
    And new season can begin

  # ==================== LEAGUE FORMATS ====================

  Scenario: Configure standard playoff pool format
    Given commissioner selects standard format
    When format settings are applied:
      | Setting              | Value             |
      | Pool Type            | Pick'em           |
      | Roster Style         | Fixed positions   |
      | Scoring              | PPR               |
      | Playoff Weeks        | 4                 |
    Then league operates as playoff pool
    And rules match format requirements

  Scenario: Configure salary cap format
    Given commissioner wants salary cap league
    When salary cap settings are configured:
      | Setting              | Value             |
      | Salary Cap           | $200,000,000      |
      | Floor                | $150,000,000      |
      | Rookie Wage Scale    | Yes               |
      | Cap Rollover         | Yes               |
    Then salary cap is enforced
    And roster moves require cap space

  Scenario: Configure dynasty format
    Given commissioner wants dynasty league
    When dynasty settings are configured:
      | Setting              | Value             |
      | Keeper Count         | 5 players         |
      | Contract Years       | 1-4 years         |
      | Rookie Draft         | Yes               |
      | Taxi Squad           | 3 players         |
    Then dynasty rules are applied
    And keeper deadlines are set

  Scenario: Configure auction draft format
    Given commissioner wants auction draft
    When auction settings are configured:
      | Setting              | Value             |
      | Budget               | $200              |
      | Minimum Bid          | $1                |
      | Nomination Order     | Snake             |
      | Time per Nomination  | 30 seconds        |
    Then auction format is ready
    And draft follows auction rules

  Scenario: Configure best ball format
    Given commissioner wants best ball league
    When best ball settings are configured:
      | Setting              | Value             |
      | Auto-Optimal Lineup  | Yes               |
      | Roster Size          | 18                |
      | No Transactions      | Yes               |
    Then best ball scoring is applied
    And optimal lineup is calculated automatically

  Scenario: Configure IDP format
    Given commissioner wants individual defensive players
    When IDP settings are configured:
      | Position | Count | Scoring Enabled |
      | DL       | 2     | Yes             |
      | LB       | 2     | Yes             |
      | DB       | 2     | Yes             |
      | IDP FLEX | 1     | Yes             |
    Then IDP positions are added to roster
    And defensive player scoring is enabled

  Scenario: Configure superflex format
    Given commissioner wants superflex league
    When superflex settings are configured:
      | Setting              | Value             |
      | Superflex Position   | QB/RB/WR/TE       |
      | Max Starting QBs     | 2                 |
    Then superflex roster slot is available
    And QB value increases in format

  # ==================== LEAGUE IMPORT/EXPORT ====================

  Scenario: Export league settings
    Given commissioner wants to backup settings
    When commissioner exports league configuration
    Then export file contains:
      | Data Type            | Included |
      | Scoring settings     | Yes      |
      | Roster settings      | Yes      |
      | Trade rules          | Yes      |
      | Schedule             | Yes      |
      | Prize structure      | Yes      |
    And file is downloadable as JSON

  Scenario: Import league from another platform
    Given commissioner has league on ESPN/Yahoo
    When commissioner initiates import:
      | Source Platform      | ESPN              |
      | League ID            | 12345678          |
      | Import Type          | Full League       |
    Then league data is imported:
      | Data Type            | Imported |
      | Teams and owners     | Yes      |
      | Rosters              | Yes      |
      | Scoring history      | Yes      |
      | Draft results        | Yes      |
    And commissioner reviews imported data

  Scenario: Export league to spreadsheet
    Given commissioner needs data analysis
    When commissioner exports to Excel
    Then spreadsheet contains:
      | Sheet                | Data                    |
      | Standings            | Current rankings        |
      | Rosters              | All team rosters        |
      | Scoring              | Weekly scoring details  |
      | Transactions         | All transactions        |
    And file is downloadable

  Scenario: Export financial records
    Given league has financial history
    When commissioner exports financial data
    Then export contains:
      | Record Type          | Data                    |
      | Entry fees           | Payment status          |
      | Payouts              | Prize distributions     |
      | Transaction log      | All financial activity  |
    And export is suitable for tax records

  Scenario: Migrate league to new season
    Given season has concluded
    When commissioner migrates to new season:
      | Setting              | Option              |
      | Keep members         | Yes                 |
      | Keep settings        | Yes, with updates   |
      | Reset rosters        | Yes                 |
      | Archive history      | Yes                 |
    Then new season is created
    And members are invited to return
    And previous season is archived

  Scenario: Share league template
    Given commissioner created successful league
    When commissioner shares as template:
      | Template Name        | Standard Playoff Pool   |
      | Visibility           | Public                  |
      | Description          | Balanced PPR playoff... |
    Then template is available publicly
    And other commissioners can use it
    And original commissioner is credited

  Scenario: Backup entire league data
    Given commissioner wants complete backup
    When commissioner initiates full backup
    Then backup includes:
      | Data Category        | Included |
      | All settings         | Yes      |
      | Member data          | Yes      |
      | All transactions     | Yes      |
      | Chat history         | Yes      |
      | Financial records    | Yes      |
    And backup can restore league completely

  Scenario: API access for league data
    Given external integration is needed
    When developer accesses league API:
      | Endpoint             | Method | Description         |
      | /api/league/{id}     | GET    | League info         |
      | /api/league/standings| GET    | Current standings   |
      | /api/league/rosters  | GET    | All team rosters    |
      | /api/league/scores   | GET    | Scoring data        |
    Then API returns requested data
    And authentication is required
    And rate limiting is enforced
