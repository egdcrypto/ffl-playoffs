Feature: League Configuration Lock on First Game Start
  As a system administrator
  I want league configuration to become immutable when the first NFL game starts
  So that the competition remains fair and rules cannot be changed mid-season

  Background:
    Given an ADMIN user owns league "Championship 2024"
    And the league starts at NFL week 1
    And the league runs for 4 weeks
    And the first NFL game of week 1 starts at "2024-09-05 20:20:00 ET"
    And the league is currently ACTIVE

  # ============================================================================
  # BASIC CONFIGURATION LOCK SCENARIOS
  # ============================================================================

  Scenario: Configuration remains mutable between activation and first game
    Given the current time is "2024-09-05 15:00:00 ET"
    And the league is ACTIVE
    And the first game starts in 5 hours
    When the admin modifies league configuration
    Then the changes are applied successfully
    And the league configuration is not locked yet

  Scenario: Configuration locks exactly when first game starts
    Given the current time is "2024-09-05 20:20:00 ET"
    When the first NFL game begins
    Then the league configuration is automatically locked
    And the league lockReason is set to "FIRST_GAME_STARTED"
    And the league lockTimestamp is "2024-09-05 20:20:00 ET"
    And the league isLocked flag is true

  Scenario: Admin cannot modify league name after lock
    Given the league configuration is locked
    When the admin attempts to change the league name
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And the system shows "Configuration is locked - first game has started"
    And the league name remains unchanged

  Scenario: Admin cannot modify starting week after lock
    Given the league configuration is locked
    When the admin attempts to change starting week from 1 to 2
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And the starting week remains 1

  Scenario: Admin cannot modify number of weeks after lock
    Given the league configuration is locked
    When the admin attempts to change number of weeks from 4 to 5
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And the number of weeks remains 4

  Scenario: Admin cannot modify roster configuration after lock
    Given the league configuration is locked
    And the league roster has 1 QB, 2 RB, 2 WR
    When the admin attempts to change roster to 2 QB, 3 RB, 3 WR
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And the roster configuration remains unchanged

  Scenario: Admin cannot modify PPR scoring rules after lock
    Given the league configuration is locked
    And the league uses Full PPR (1.0 per reception)
    When the admin attempts to change to Half PPR (0.5 per reception)
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And the PPR scoring remains Full PPR

  Scenario: Admin cannot modify field goal scoring after lock
    Given the league configuration is locked
    When the admin attempts to change field goal scoring rules
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And the field goal scoring rules remain unchanged

  Scenario: Admin cannot modify defensive scoring after lock
    Given the league configuration is locked
    When the admin attempts to change defensive scoring rules
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And the defensive scoring rules remain unchanged

  Scenario: Admin cannot modify points allowed tiers after lock
    Given the league configuration is locked
    When the admin attempts to change points allowed tier scoring
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And the points allowed tiers remain unchanged

  Scenario: Admin cannot modify yards allowed tiers after lock
    Given the league configuration is locked
    When the admin attempts to change yards allowed tier scoring
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And the yards allowed tiers remain unchanged

  Scenario: Admin cannot modify roster lock deadline after lock
    Given the league configuration is locked
    When the admin attempts to change the roster lock deadline
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And the roster lock deadline remains unchanged

  Scenario: Admin cannot modify max players after lock
    Given the league configuration is locked
    And the league maxPlayers is 20
    When the admin attempts to change maxPlayers to 30
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And the maxPlayers remains 20

  Scenario: Admin cannot modify privacy settings after lock
    Given the league configuration is locked
    And the league is PRIVATE
    When the admin attempts to change privacy to PUBLIC
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And the league remains PRIVATE

  Scenario: Admin cannot deactivate league after lock
    Given the league configuration is locked
    And the league is ACTIVE
    When the admin attempts to deactivate the league
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And the league remains ACTIVE

  Scenario: Admin views locked configuration with lock indicator
    Given the league configuration is locked
    When the admin views the league settings
    Then the UI displays "LOCKED" indicator
    And all configuration fields are read-only
    And the system shows "Configuration locked since: 2024-09-05 20:20:00 ET"
    And the system shows lock reason: "FIRST_GAME_STARTED"

  Scenario: Admin receives warning before configuration locks
    Given the current time is "2024-09-05 19:20:00 ET"
    And the first game starts in 1 hour
    When the admin views league configuration
    Then the system displays warning banner
    And the warning shows "Configuration locks in: 1 hour"
    And the warning shows countdown timer
    And the admin can still make changes

  Scenario: Audit log captures attempted modifications after lock
    Given the league configuration is locked
    When the admin attempts to modify PPR scoring rules
    Then the attempt is blocked with CONFIGURATION_LOCKED error
    And an audit log entry is created with:
      | Field       | Value                         |
      | AdminId     | admin-id                      |
      | LeagueId    | league-123                    |
      | Action      | MODIFY_PPR_SCORING            |
      | Result      | BLOCKED_CONFIGURATION_LOCKED  |
      | Timestamp   | current timestamp             |
    And the audit log includes attempted changes

  Scenario: Multiple configuration changes attempted after lock
    Given the league configuration is locked
    When the admin attempts to modify:
      | Setting            | New Value  |
      | League name        | New Name   |
      | PPR scoring        | Half PPR   |
      | Starting week      | 2          |
      | Number of weeks    | 5          |
    Then all 4 attempts are blocked with CONFIGURATION_LOCKED
    And 4 audit log entries are created
    And no configuration changes are applied

  Scenario: Lock applies to all configuration aspects
    Given the league configuration is locked
    Then the following are ALL immutable:
      | Configuration Aspect          |
      | League name                   |
      | League description            |
      | Starting week                 |
      | Number of weeks               |
      | Roster configuration          |
      | Position counts               |
      | PPR scoring rules             |
      | Field goal scoring rules      |
      | Defensive scoring rules       |
      | Points allowed tiers          |
      | Yards allowed tiers           |
      | Pick deadlines                |
      | Maximum league players        |
      | Privacy settings              |
      | League status (active/inactive)|
    And attempted changes to any aspect are rejected

  Scenario: Lock timestamp is based on first game start time
    Given the first NFL game of week 1 starts at "2024-09-05 20:20:00 ET"
    When the league configuration lock is applied
    Then the lockTimestamp is "2024-09-05 20:20:00 ET"
    And the lockTimestamp matches the first game start time exactly
    And the lockTimestamp is not based on league activation time

  Scenario: New league inherits lock status from NFL schedule
    Given the admin creates a new league during week 1
    And the first game of week 1 already started
    When the admin activates the league
    Then the league is immediately locked
    And the lockReason is "FIRST_GAME_STARTED"
    And the admin cannot modify configuration

  Scenario: Super admin cannot override configuration lock
    Given the league configuration is locked
    And a SUPER_ADMIN user accesses the league
    When the super admin attempts to modify league configuration
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And even SUPER_ADMIN cannot bypass configuration lock
    And the lock is strictly enforced for fairness

  # ============================================================================
  # CONFIGURATION LOCK TIMING PRECISION
  # ============================================================================

  Scenario: Lock triggers at exact kickoff time with millisecond precision
    Given the first NFL game kickoff is "2024-09-05 20:20:00.000 ET"
    When the current time is "2024-09-05 20:19:59.999 ET"
    Then the configuration is still mutable
    When the current time advances to "2024-09-05 20:20:00.000 ET"
    Then the configuration becomes locked
    And the lock boundary is precise to the millisecond

  Scenario: Lock uses actual kickoff time not scheduled time
    Given the first NFL game is scheduled for "2024-09-05 20:20:00 ET"
    And the actual kickoff is delayed to "2024-09-05 20:35:00 ET"
    When the system receives the actual kickoff event
    Then the configuration locks at "2024-09-05 20:35:00 ET"
    And the scheduled time is not used for lock

  Scenario: Thursday night game triggers lock for week 1 leagues
    Given the first NFL game of week 1 is Thursday Night Football
    And the game starts at "2024-09-05 20:20:00 ET"
    When Thursday night kickoff occurs
    Then all week 1 leagues are locked
    And Sunday leagues are also locked (week 1 already started)
    And week 2+ starting leagues are not affected

  Scenario: Multiple games kicking off simultaneously
    Given two NFL games are scheduled to start at "2024-09-08 13:00:00 ET"
    And both games are in week 1
    When both games kick off at the same time
    Then the lock triggers once at "2024-09-08 13:00:00 ET"
    And the lock is not duplicated
    And the first received kickoff event triggers the lock

  Scenario: Early kickoff in London game
    Given an NFL London game is scheduled for "2024-09-15 09:30:00 ET"
    And this is the first game of week 2
    And a league starts at week 2
    When the London game kicks off at "2024-09-15 09:30:00 ET"
    Then the week 2 league is locked at "2024-09-15 09:30:00 ET"
    And week 1 leagues were already locked

  Scenario: Lock based on league's starting week
    Given League A starts at NFL week 1
    And League B starts at NFL week 2
    And the first game of week 1 starts at "2024-09-05 20:20:00 ET"
    When the week 1 first game kicks off
    Then League A is locked at "2024-09-05 20:20:00 ET"
    And League B remains unlocked
    When the first game of week 2 kicks off
    Then League B is locked

  # ============================================================================
  # GAME SCHEDULE CHANGES AND EDGE CASES
  # ============================================================================

  Scenario: Game postponed before kickoff
    Given the first NFL game is scheduled for "2024-09-05 20:20:00 ET"
    And the game is postponed to "2024-09-06 19:00:00 ET" before kickoff
    When the current time is "2024-09-05 21:00:00 ET"
    Then the configuration is still mutable
    And the lock deadline updates to "2024-09-06 19:00:00 ET"
    And admins are notified of the deadline change

  Scenario: Game cancelled and rescheduled
    Given the first NFL game is cancelled due to weather
    And the next scheduled game is "2024-09-08 13:00:00 ET"
    When the first NFL game is determined
    Then the lock deadline is "2024-09-08 13:00:00 ET"
    And the configuration remains mutable until then

  Scenario: Game delayed mid-play does not affect lock
    Given the first NFL game kicked off at "2024-09-05 20:20:00 ET"
    And the configuration locked at "2024-09-05 20:20:00 ET"
    When the game is suspended due to weather at "2024-09-05 21:00:00 ET"
    Then the configuration remains locked
    And the lock cannot be reversed
    And game resumption has no effect on lock

  Scenario: Bye week does not affect lock timing
    Given League A starts at NFL week 1
    And the league's players have various bye weeks
    When the first game of week 1 kicks off
    Then the configuration locks regardless of bye weeks
    And bye weeks do not delay the lock

  Scenario: All games of starting week cancelled (extreme scenario)
    Given all NFL games for week 1 are cancelled
    And week 1 is effectively skipped
    When the NFL announces week 1 cancellation
    Then the league starting week shifts to week 2
    And the lock deadline moves to week 2 first game
    And admins are notified of the change

  # ============================================================================
  # CONFIGURATION SNAPSHOT AND INTEGRITY
  # ============================================================================

  Scenario: Configuration snapshot captured at lock time
    Given the league has the following configuration:
      | Setting              | Value          |
      | League name          | Championship   |
      | PPR                  | Full (1.0)     |
      | Starting week        | 1              |
      | Number of weeks      | 4              |
      | Max players          | 20             |
      | Roster lock deadline | 20:00 ET       |
    When the configuration locks
    Then a complete configuration snapshot is stored
    And the snapshot includes all settings
    And the snapshot is immutable and timestamped

  Scenario: Configuration hash generated for integrity verification
    Given the league configuration is locked
    When the lock is applied
    Then a cryptographic hash of the configuration is generated
    And the hash is stored with the lock record
    And configuration tampering can be detected via hash mismatch

  Scenario: Configuration cannot be modified via direct database access
    Given the league configuration is locked
    And an unauthorized actor attempts database modification
    When the modification is attempted
    Then the application layer enforces lock on read
    And any detected tampering triggers an alert
    And the original configuration can be restored from snapshot

  Scenario: Lock verification on every configuration access
    Given the league configuration is locked
    When any configuration modification request is received
    Then the system checks lock status before processing
    And the check is performed at the database level
    And no race conditions allow bypass

  # ============================================================================
  # LOCK STATE PERSISTENCE AND RECOVERY
  # ============================================================================

  Scenario: Lock state persists across application restarts
    Given the league configuration is locked
    And the lock was applied at "2024-09-05 20:20:00 ET"
    When the application is restarted
    Then the configuration remains locked
    And the lockTimestamp is preserved
    And the lockReason is preserved

  Scenario: Lock state recovery after database failover
    Given the league configuration is locked
    And a database failover occurs
    When the system reconnects to the database
    Then the lock state is correctly read from the new primary
    And no inconsistency occurs
    And the configuration remains protected

  Scenario: Lock state synchronized across distributed instances
    Given a multi-instance deployment
    And the league configuration locks on instance A
    When instance B receives a modification request
    Then instance B reads the current lock state
    And instance B correctly rejects the modification
    And eventual consistency ensures lock propagation

  Scenario: Lock applied during system outage
    Given the first game kicks off at "2024-09-05 20:20:00 ET"
    And the system is down from "2024-09-05 20:00:00 ET" to "2024-09-05 21:00:00 ET"
    When the system comes back online
    Then all leagues starting week 1 are automatically locked
    And the lockTimestamp is set to "2024-09-05 20:20:00 ET"
    And the lock is retroactively applied

  Scenario: Lock job is idempotent
    Given the league configuration is locked
    When the lock job runs again (duplicate trigger)
    Then no changes are made
    And no duplicate lock records are created
    And the original lockTimestamp is unchanged

  # ============================================================================
  # IMMUTABILITY ENFORCEMENT - DETAILED SETTINGS
  # ============================================================================

  Scenario: Cannot modify passing yards scoring after lock
    Given the league configuration is locked
    And passing yards score 0.04 points per yard
    When the admin attempts to change to 0.05 points per yard
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And passing yards scoring remains 0.04

  Scenario: Cannot modify rushing yards scoring after lock
    Given the league configuration is locked
    And rushing yards score 0.1 points per yard
    When the admin attempts to change to 0.15 points per yard
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And rushing yards scoring remains 0.1

  Scenario: Cannot modify receiving yards scoring after lock
    Given the league configuration is locked
    And receiving yards score 0.1 points per yard
    When the admin attempts to change to 0.15 points per yard
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And receiving yards scoring remains 0.1

  Scenario: Cannot modify touchdown scoring after lock
    Given the league configuration is locked
    And passing TDs score 4 points
    And rushing/receiving TDs score 6 points
    When the admin attempts to change passing TDs to 6 points
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And touchdown scoring remains unchanged

  Scenario: Cannot modify interception scoring after lock
    Given the league configuration is locked
    And interceptions thrown score -2 points
    When the admin attempts to change to -1 point
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And interception scoring remains -2

  Scenario: Cannot modify fumble scoring after lock
    Given the league configuration is locked
    And fumbles lost score -2 points
    When the admin attempts to change to -1 point
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And fumble scoring remains -2

  Scenario: Cannot modify bonus thresholds after lock
    Given the league configuration is locked
    And 100-yard rushing bonus is 3 points
    When the admin attempts to change threshold to 75 yards
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And bonus thresholds remain unchanged

  Scenario: Cannot add new scoring categories after lock
    Given the league configuration is locked
    And "40-yard TD bonus" is not configured
    When the admin attempts to add "40-yard TD bonus" of 2 points
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And new scoring categories cannot be added

  Scenario: Cannot remove scoring categories after lock
    Given the league configuration is locked
    And "100-yard rushing bonus" is configured at 3 points
    When the admin attempts to remove "100-yard rushing bonus"
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And existing scoring categories cannot be removed

  # ============================================================================
  # ROSTER CONFIGURATION IMMUTABILITY
  # ============================================================================

  Scenario: Cannot add roster positions after lock
    Given the league configuration is locked
    And the roster has 1 QB, 2 RB, 2 WR, 1 TE, 1 FLEX, 1 K, 1 DEF
    When the admin attempts to add a second FLEX position
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And roster positions remain unchanged

  Scenario: Cannot remove roster positions after lock
    Given the league configuration is locked
    And the roster has 1 K position
    When the admin attempts to remove the K position
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And roster positions remain unchanged

  Scenario: Cannot modify FLEX eligibility after lock
    Given the league configuration is locked
    And FLEX can be RB, WR, or TE
    When the admin attempts to add QB to FLEX eligibility
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And FLEX eligibility remains RB, WR, TE

  Scenario: Cannot modify bench size after lock
    Given the league configuration is locked
    And the bench size is 6 players
    When the admin attempts to change bench to 8 players
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And bench size remains 6

  Scenario: Cannot modify IR slot configuration after lock
    Given the league configuration is locked
    And IR slots are set to 2
    When the admin attempts to change IR slots to 3
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And IR configuration remains unchanged

  # ============================================================================
  # LEAGUE SETTINGS IMMUTABILITY
  # ============================================================================

  Scenario: Cannot modify league description after lock
    Given the league configuration is locked
    And the league description is "Original description"
    When the admin attempts to change description to "New description"
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And the description remains "Original description"

  Scenario: Cannot modify league logo after lock
    Given the league configuration is locked
    And the league has a logo set
    When the admin attempts to change the league logo
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And the logo remains unchanged

  Scenario: Cannot modify league timezone after lock
    Given the league configuration is locked
    And the league timezone is "America/New_York"
    When the admin attempts to change to "America/Los_Angeles"
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And the timezone remains "America/New_York"

  Scenario: Cannot modify elimination rules after lock
    Given the league configuration is locked
    And elimination is 1 player per week
    When the admin attempts to change to 2 players per week
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And elimination rules remain unchanged

  Scenario: Cannot modify tiebreaker rules after lock
    Given the league configuration is locked
    And tiebreaker is "Total season points"
    When the admin attempts to change to "Head-to-head"
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And tiebreaker rules remain unchanged

  Scenario: Cannot modify draft type after lock
    Given the league configuration is locked
    And the draft type is "Open selection"
    When the admin attempts to change to "Snake draft"
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And draft type remains unchanged

  # ============================================================================
  # DEADLINE AND TIMING IMMUTABILITY
  # ============================================================================

  Scenario: Cannot modify roster lock time after lock
    Given the league configuration is locked
    And roster lock is "20 minutes before first game"
    When the admin attempts to change to "1 hour before first game"
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And roster lock timing remains unchanged

  Scenario: Cannot modify weekly deadline settings after lock
    Given the league configuration is locked
    And weekly deadline is tied to game start times
    When the admin attempts to change deadline rules
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And deadline settings remain unchanged

  Scenario: Cannot extend league duration after lock
    Given the league configuration is locked
    And the league runs weeks 1-4 (4 weeks)
    When the admin attempts to extend to weeks 1-5 (5 weeks)
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And league duration remains 4 weeks

  Scenario: Cannot shorten league duration after lock
    Given the league configuration is locked
    And the league runs weeks 1-4 (4 weeks)
    When the admin attempts to shorten to weeks 1-3 (3 weeks)
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And league duration remains 4 weeks

  # ============================================================================
  # NOTIFICATIONS AND ALERTS
  # ============================================================================

  Scenario: Admin receives 24-hour warning notification
    Given the first game starts in 24 hours
    When the notification scheduler runs
    Then the admin receives an email notification
    And the notification says "Configuration locks in 24 hours"
    And the notification lists current configuration summary
    And the notification includes a link to review settings

  Scenario: Admin receives 1-hour warning notification
    Given the first game starts in 1 hour
    When the notification scheduler runs
    Then the admin receives a push notification
    And the notification says "URGENT: Configuration locks in 1 hour"
    And the notification has high priority

  Scenario: Admin receives lock confirmation notification
    Given the first game just started
    When the configuration lock is applied
    Then the admin receives a confirmation notification
    And the notification says "Configuration is now locked"
    And the notification includes the lock timestamp
    And the notification includes a configuration summary

  Scenario: All league members notified of lock
    Given the league has 15 members
    When the configuration locks
    Then all 15 members receive a notification
    And the notification says "League rules are now locked for the season"
    And members can view the locked configuration

  Scenario: Notification includes locked configuration summary
    Given the configuration just locked
    When the lock notification is sent
    Then it includes key settings:
      | Setting              | Value       |
      | PPR                  | Full (1.0)  |
      | Scoring system       | Standard    |
      | Starting week        | 1           |
      | Duration             | 4 weeks     |
      | Roster lock          | 20 min pre  |

  Scenario: Failed notification does not affect lock
    Given the notification service is temporarily unavailable
    When the configuration locks
    Then the lock is still applied
    And notifications are queued for retry
    And the lock is not dependent on notification delivery

  # ============================================================================
  # MULTI-LEAGUE AND MULTI-ADMIN SCENARIOS
  # ============================================================================

  Scenario: Admin manages multiple leagues with different lock times
    Given admin "John" owns two leagues:
      | League        | Starting Week | Lock Status |
      | League Alpha  | 1             | Locked      |
      | League Beta   | 3             | Unlocked    |
    When John views his leagues dashboard
    Then League Alpha shows "LOCKED" status
    And League Beta shows "Configuration editable until Week 3 kickoff"
    And John can modify League Beta configuration

  Scenario: Co-admin cannot modify locked configuration
    Given the league configuration is locked
    And "Sarah" is a co-admin of the league
    When Sarah attempts to modify the configuration
    Then the request is rejected with error "CONFIGURATION_LOCKED"
    And co-admins are also bound by the lock

  Scenario: Ownership transfer does not unlock configuration
    Given the league configuration is locked
    When ownership is transferred from "John" to "Mike"
    Then the configuration remains locked
    And Mike cannot modify the configuration
    And the lock persists across ownership changes

  Scenario: League merge does not unlock configuration
    Given both leagues A and B are locked
    When an admin merges League B into League A
    Then the merged league remains locked
    And the lock is not circumvented by merging

  # ============================================================================
  # API ENFORCEMENT
  # ============================================================================

  Scenario: REST API rejects configuration changes after lock
    Given the league configuration is locked
    When a PUT request is made to "/api/leagues/{id}/configuration"
    Then the response status is 403 Forbidden
    And the response body contains "CONFIGURATION_LOCKED"
    And the response includes lock timestamp

  Scenario: PATCH API rejects partial configuration changes after lock
    Given the league configuration is locked
    When a PATCH request is made to update PPR scoring
    Then the response status is 403 Forbidden
    And the response body contains "CONFIGURATION_LOCKED"

  Scenario: API returns lock status in configuration response
    Given the league configuration is locked
    When a GET request is made to "/api/leagues/{id}/configuration"
    Then the response includes:
      | Field           | Value                    |
      | isLocked        | true                     |
      | lockTimestamp   | 2024-09-05T20:20:00Z     |
      | lockReason      | FIRST_GAME_STARTED       |
      | canModify       | false                    |

  Scenario: Lock status endpoint provides detailed information
    Given the league configuration is locked
    When a GET request is made to "/api/leagues/{id}/lock-status"
    Then the response includes:
      | Field              | Value                    |
      | locked             | true                     |
      | lockTimestamp      | 2024-09-05T20:20:00Z     |
      | lockReason         | FIRST_GAME_STARTED       |
      | lockDurationWeeks  | 4                        |
      | remainingWeeks     | 3                        |
      | configurationHash  | sha256-hash-value        |

  Scenario: Bulk configuration update rejected after lock
    Given the league configuration is locked
    When a PUT request with multiple configuration changes is made
    Then all changes are rejected atomically
    And the response indicates all settings are locked
    And no partial updates occur

  Scenario: Configuration import rejected after lock
    Given the league configuration is locked
    When an admin attempts to import configuration from another league
    Then the import is rejected with error "CONFIGURATION_LOCKED"
    And the configuration remains unchanged

  # ============================================================================
  # UI ENFORCEMENT
  # ============================================================================

  Scenario: Configuration form is read-only after lock
    Given the league configuration is locked
    When the admin opens the configuration page
    Then all input fields are disabled
    And save/update buttons are hidden
    And a "Configuration Locked" banner is displayed

  Scenario: Lock countdown timer on configuration page
    Given the first game starts in 30 minutes
    When the admin views the configuration page
    Then a countdown timer shows "Locks in: 30:00"
    And the timer updates in real-time
    And the timer turns red at 5 minutes remaining

  Scenario: Lock tooltip explains the restriction
    Given the league configuration is locked
    When the admin hovers over a disabled field
    Then a tooltip appears
    And the tooltip says "This setting is locked because the season has started"
    And the tooltip shows the lock timestamp

  Scenario: Mobile app respects configuration lock
    Given the league configuration is locked
    When the admin views configuration on mobile
    Then all settings are displayed as read-only
    And the lock status is clearly indicated
    And no edit actions are available

  Scenario: Configuration history shows lock event
    Given the league configuration was locked
    When the admin views configuration history
    Then the history shows a "CONFIGURATION_LOCKED" event
    And the event timestamp is the lock time
    And the event reason is "FIRST_GAME_STARTED"

  # ============================================================================
  # AUDIT TRAIL AND COMPLIANCE
  # ============================================================================

  Scenario: Complete audit trail of configuration changes before lock
    Given the admin made 5 configuration changes before lock
    When the configuration locks
    Then all 5 changes are in the audit log
    And each change has timestamp and admin ID
    And the final state at lock time is recorded

  Scenario: Attempted modifications after lock are logged
    Given the league configuration is locked
    When 3 modification attempts are made
    Then 3 audit log entries are created with:
      | Field          | Value                        |
      | action         | CONFIGURATION_MODIFY_ATTEMPT |
      | result         | BLOCKED                      |
      | reason         | CONFIGURATION_LOCKED         |
      | attemptedBy    | admin-id                     |
      | attemptedValue | new-value                    |

  Scenario: Audit log is tamper-proof
    Given the configuration audit log exists
    When an unauthorized modification is attempted on the audit log
    Then the attempt is detected
    And an alert is generated
    And the original audit log is preserved

  Scenario: Audit log can be exported for compliance
    Given the league configuration is locked
    When the admin requests audit log export
    Then a complete audit trail is exported
    And the export includes all changes and lock events
    And the export is digitally signed

  Scenario: Audit log retention for 7 years
    Given the league season has ended
    When the audit log retention policy is applied
    Then the configuration audit log is retained for 7 years
    And the log can be retrieved for compliance audits
    And the log is archived after 1 year

  # ============================================================================
  # PRE-LOCK VALIDATION
  # ============================================================================

  Scenario: Configuration completeness check before lock
    Given the first game starts in 1 hour
    When the system validates configuration completeness
    Then any missing required settings are flagged
    And the admin receives a warning about incomplete settings
    And the lock will still proceed with defaults

  Scenario: Invalid configuration detected before lock
    Given the configuration has an invalid scoring rule
    And the first game starts in 1 hour
    When the validation runs
    Then the admin is warned about the invalid configuration
    And the admin has time to correct before lock

  Scenario: Configuration conflict detected before lock
    Given FLEX allows QB but no QB scoring is configured
    When the validation runs before lock
    Then a conflict warning is displayed
    And the admin is advised to resolve the conflict

  Scenario: Lock proceeds despite warnings
    Given configuration has non-blocking warnings
    When the first game starts
    Then the configuration locks with warnings
    And the warnings are logged
    And the admin was notified of warnings beforehand

  # ============================================================================
  # ERROR HANDLING AND EDGE CASES
  # ============================================================================

  Scenario: Database unavailable during lock trigger
    Given the first game starts at "2024-09-05 20:20:00 ET"
    And the database is temporarily unavailable
    When the lock trigger fires
    Then the lock operation is queued
    And the system retries when database is available
    And the lock is eventually applied

  Scenario: Concurrent lock attempts are handled correctly
    Given multiple instances receive the kickoff event
    When both instances attempt to lock the configuration
    Then exactly one lock record is created
    And the lock is idempotent
    And no race conditions occur

  Scenario: Lock during high traffic period
    Given 1000 leagues need to be locked at the same time
    When the first game kicks off
    Then all leagues are locked within acceptable time
    And the system handles the load gracefully
    And no leagues are missed

  Scenario: Network partition during lock synchronization
    Given a multi-region deployment
    And a network partition occurs during lock
    When regions reconnect
    Then lock states are reconciled
    And the most restrictive state wins (locked)
    And eventual consistency is achieved

  Scenario: Partial lock failure recovery
    Given the lock process fails midway
    When the system recovers
    Then incomplete locks are detected
    And the lock process is retried
    And all configurations are properly locked

  Scenario: Timezone edge case during DST transition
    Given the first game is during DST transition
    When the lock trigger fires
    Then the correct time is used (unambiguous UTC)
    And the lock is applied at the right moment
    And no confusion from timezone ambiguity

  # ============================================================================
  # TESTING AND SIMULATION
  # ============================================================================

  Scenario: Admin can simulate lock in test mode
    Given the league is in test mode
    When the admin triggers a lock simulation
    Then the UI shows locked state
    And no actual database changes are made
    And the admin can verify UI behavior
    And test mode is clearly indicated

  Scenario: Time manipulation for lock testing
    Given the system is in test environment
    When a tester advances time past first game
    Then the lock triggers as expected
    And all lock behaviors can be verified
    And test time does not affect production

  Scenario: Lock dry-run shows what would be locked
    Given the first game starts in 2 hours
    When the admin requests a lock dry-run
    Then the system shows:
      | Setting              | Current Value | Would Lock |
      | League name          | Championship  | Yes        |
      | PPR                  | Full (1.0)    | Yes        |
      | Starting week        | 1             | Yes        |
      | All settings         | ...           | Yes        |
    And no actual lock is applied

  Scenario: Integration test verifies lock enforcement
    Given an automated integration test
    When the test locks configuration and attempts modification
    Then the modification is correctly rejected
    And the test passes
    And lock enforcement is verified

  # ============================================================================
  # ROLLBACK AND RECOVERY (EXPLICITLY NOT SUPPORTED)
  # ============================================================================

  Scenario: Configuration unlock is not supported
    Given the league configuration is locked
    When an admin requests to unlock the configuration
    Then the system shows "Configuration cannot be unlocked"
    And no unlock functionality is provided
    And the lock is permanent for the season

  Scenario: Super admin cannot unlock configuration
    Given the league configuration is locked
    And a SUPER_ADMIN attempts to unlock
    Then the request is rejected
    And the system shows "Lock cannot be overridden"
    And fairness is maintained

  Scenario: Support ticket for unlock is rejected
    Given a support ticket requests configuration unlock
    When support reviews the ticket
    Then the request is denied
    And the response explains the immutability policy
    And the configuration remains locked

  Scenario: Emergency unlock requires board approval (not automated)
    Given an extreme emergency requires unlock consideration
    When the situation is escalated
    Then the system does not provide automatic unlock
    And any unlock would require manual database intervention
    And such intervention is logged and audited

  # ============================================================================
  # SEASON END AND ARCHIVAL
  # ============================================================================

  Scenario: Configuration remains locked after season ends
    Given the league configuration is locked
    And the 4-week season has ended
    When the admin views the configuration
    Then it still shows as locked
    And the lock is permanent for historical integrity
    And the configuration becomes archival

  Scenario: New season requires new league
    Given the locked league's season has ended
    When the admin wants to run a new season
    Then they must create a new league
    And the old league configuration remains locked
    And the new league starts fresh

  Scenario: Locked configuration available for historical review
    Given the league is archived after season end
    When a user views the archived league
    Then the locked configuration is readable
    And the configuration shows the locked state
    And historical scoring rules are preserved

  Scenario: Configuration export includes lock metadata
    Given the league is exported for archival
    When the export is generated
    Then it includes:
      | Field              | Value                    |
      | configuration      | full settings snapshot   |
      | lockTimestamp      | 2024-09-05T20:20:00Z     |
      | lockReason         | FIRST_GAME_STARTED       |
      | configurationHash  | sha256-hash-value        |
    And the export is complete for record-keeping
