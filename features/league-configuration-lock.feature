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
    Then the UI displays "🔒 LOCKED" indicator
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
