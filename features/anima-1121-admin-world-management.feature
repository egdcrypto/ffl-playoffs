@admin @world-management @platform @ANIMA-1121
Feature: Admin World Management
  As a platform administrator
  I want to manage all worlds on the platform
  So that I can ensure quality, resolve world-related issues, and maintain platform integrity

  Background:
    Given an authenticated administrator with "world_management" permissions
    And the world management system is operational
    And the following worlds exist on the platform:
      | world_id   | name              | status    | owner        | players | server     |
      | WLD-001    | Fantasy Realm     | active    | user_alice   | 250     | us-east-1  |
      | WLD-002    | Epic Adventures   | active    | user_bob     | 180     | us-west-2  |
      | WLD-003    | Dragon's Domain   | suspended | user_charlie | 0       | eu-west-1  |
      | WLD-004    | Mystic Lands      | active    | org_gaming   | 450     | us-east-1  |

  # =============================================================================
  # WORLD OVERVIEW AND LISTING
  # =============================================================================

  @dashboard @happy-path
  Scenario: View all worlds overview with summary statistics
    Given there are 150 worlds on the platform
    When I navigate to the world management dashboard
    Then I should see the total world count of 150
    And I should see a breakdown by status:
      | status      | count |
      | active      | 120   |
      | suspended   | 15    |
      | maintenance | 10    |
      | pending     | 5     |
    And I should see total player count across all worlds
    And I should see worlds requiring attention highlighted

  @dashboard @metrics
  Scenario: View world health summary
    Given worlds have varying health statuses
    When I view the dashboard health summary
    Then I should see:
      | health_status | count | percentage |
      | healthy       | 130   | 87%        |
      | warning       | 15    | 10%        |
      | critical      | 5     | 3%         |
    And critical worlds should be prominently displayed
    And I should be able to click through to details

  @filter @status
  Scenario Outline: Filter worlds by status
    Given worlds exist in various statuses
    When I filter worlds by status "<status>"
    Then I should see only worlds with status "<status>"
    And the result count should be displayed

    Examples:
      | status      |
      | active      |
      | suspended   |
      | maintenance |
      | pending     |
      | archived    |

  @filter @owner
  Scenario Outline: Filter worlds by owner type
    Given worlds are owned by different entity types
    When I filter worlds by owner_type "<owner_type>"
    Then I should see only worlds matching the owner type
    And owner details should be visible

    Examples:
      | owner_type   |
      | individual   |
      | organization |
      | enterprise   |

  @filter @health
  Scenario Outline: Filter worlds by health status
    Given worlds have varying health metrics
    When I filter worlds by health_status "<health_status>"
    Then I should see only worlds with that health status
    And health indicators should be visible

    Examples:
      | health_status |
      | healthy       |
      | warning       |
      | critical      |

  @search @happy-path
  Scenario: Search for worlds by name
    Given a world named "Fantasy Realm" exists
    When I search for worlds with query "Fantasy"
    Then I should see "Fantasy Realm" in the results
    And the search should be case-insensitive
    And matching text should be highlighted

  @search @owner
  Scenario: Search for worlds by owner
    Given worlds are owned by user "alice_gamer"
    When I search for worlds with query "alice"
    Then I should see all worlds owned by alice_gamer
    And owner information should be displayed

  @details @happy-path
  Scenario: View detailed world information
    Given a world "Epic Adventures" exists with ID "WLD-002"
    When I view the details for world "WLD-002"
    Then I should see the world name "Epic Adventures"
    And I should see the world description
    And I should see owner information:
      | field         | value              |
      | owner_name    | user_bob           |
      | email         | bob@example.com    |
      | account_type  | premium            |
    And I should see player statistics:
      | metric           | value |
      | current_players  | 180   |
      | peak_players     | 320   |
      | total_sessions   | 15000 |
    And I should see resource allocation:
      | resource | allocated | used   |
      | cpu      | 4 cores   | 2.5    |
      | memory   | 8 GB      | 5.2 GB |
      | storage  | 100 GB    | 45 GB  |

  # =============================================================================
  # WORLD OWNERSHIP TRANSFER
  # =============================================================================

  @ownership @transfer @happy-path
  Scenario: Transfer world ownership to another user
    Given a world "Fantasy Kingdom" with ID "WLD-005" is owned by user "original_owner"
    And user "new_owner" has a verified account
    When I initiate ownership transfer to "new_owner"
    And I provide transfer reason "Owner request - account consolidation"
    And I confirm the transfer
    Then the world ownership should be transferred to "new_owner"
    And "original_owner" should receive a notification:
      | type    | ownership_transferred_out |
      | world   | Fantasy Kingdom           |
      | new_owner | new_owner               |
    And "new_owner" should receive a notification:
      | type    | ownership_transferred_in |
      | world   | Fantasy Kingdom          |
    And a domain event "WorldOwnershipTransferred" should be published

  @ownership @validation
  Scenario: Cannot transfer world to unverified user
    Given a world exists
    And user "unverified_user" has an unverified account
    When I attempt to transfer ownership to "unverified_user"
    Then the transfer should be rejected
    And I should see error "Cannot transfer to unverified account"

  @ownership @validation
  Scenario: Cannot transfer world to banned user
    Given a world exists
    And user "banned_user" has a banned account
    When I attempt to transfer ownership to "banned_user"
    Then the transfer should be rejected
    And I should see error "Cannot transfer to banned account"

  @ownership @validation
  Scenario: Cannot transfer world to user at ownership limit
    Given a world exists
    And user "max_owner" has reached their world ownership limit
    When I attempt to transfer ownership to "max_owner"
    Then the transfer should be rejected
    And I should see error "User has reached maximum world ownership limit"

  # =============================================================================
  # WORLD SUSPENSION
  # =============================================================================

  @suspension @happy-path
  Scenario: Suspend world temporarily
    Given an active world "Problematic World" with ID "WLD-010" exists
    And the world has 50 active players
    When I suspend the world with:
      | reason   | Terms of Service violation   |
      | duration | 7 days                       |
      | notify   | true                         |
    Then the world should be marked as "suspended"
    And all 50 active players should be disconnected gracefully
    And the world owner should receive suspension notification:
      | reason        | Terms of Service violation |
      | duration      | 7 days                     |
      | appeal_link   | included                   |
    And a domain event "WorldSuspended" should be published

  @suspension @immediate
  Scenario: Suspend world with immediate effect
    Given an active world with security concerns
    When I suspend the world with immediate effect
    Then all players should be disconnected within 30 seconds
    And new connections should be rejected
    And the suspension should be logged with urgency flag

  @suspension @lift
  Scenario: Lift world suspension early
    Given a world "WLD-010" is currently suspended
    And the suspension was scheduled for 7 days
    When I lift the suspension early with reason "Issue resolved after owner compliance"
    Then the world should become active immediately
    And the owner should be notified of early reinstatement
    And a domain event "WorldSuspensionLifted" should be published

  @suspension @history
  Scenario: View world suspension history
    Given a world has been suspended 3 times previously
    When I view the suspension history
    Then I should see all past suspensions:
      | date       | duration | reason                    | lifted_early |
      | 2024-01-15 | 7 days   | TOS violation             | no           |
      | 2023-11-20 | 3 days   | Spam complaints           | yes          |
      | 2023-08-05 | 14 days  | Repeated TOS violations   | no           |
    And I should see the cumulative suspension time

  @suspension @escalation
  Scenario: Apply escalated suspension for repeat offenders
    Given a world has 3 previous suspensions
    When I apply a new suspension
    Then the system should suggest escalated duration
    And display the violation history
    And require additional justification for lighter sentences

  # =============================================================================
  # WORLD DELETION
  # =============================================================================

  @deletion @grace-period
  Scenario: Delete world permanently with grace period
    Given a world "Abandoned World" with ID "WLD-020" exists
    And the world has no active players for 90 days
    When I initiate permanent deletion with reason "Abandoned - owner unresponsive"
    And I confirm by typing "DELETE WLD-020"
    Then a 30-day grace period should begin
    And the world should be marked as "pending_deletion"
    And the owner should receive deletion notice:
      | deletion_date | in 30 days        |
      | recovery_link | included          |
      | data_export   | available         |
    And a domain event "WorldDeletionScheduled" should be published

  @deletion @immediate @critical
  Scenario: Immediate deletion for severe violations
    Given a world has been flagged for illegal content
    And the content has been verified by legal team
    When I initiate immediate deletion with:
      | reason          | Illegal content - verified     |
      | legal_reference | CASE-2024-001                  |
      | evidence_id     | EVD-2024-001                   |
    And I confirm with super admin authorization
    Then the world should be deleted immediately
    And evidence should be preserved for legal purposes
    And a domain event "WorldDeletedImmediate" should be published

  @deletion @cancel
  Scenario: Cancel scheduled deletion
    Given a world is scheduled for deletion in 15 days
    When I cancel the deletion with reason "Owner appealed successfully"
    Then the world should return to active status
    And the owner should be notified of cancellation
    And a domain event "WorldDeletionCancelled" should be published

  @deletion @recover
  Scenario: Recover deleted world within recovery window
    Given a world was deleted 5 days ago
    And the world is within the 30-day recovery window
    When I initiate recovery with:
      | reason       | Owner paid outstanding balance |
      | restore_to   | original_owner                 |
    Then the world should be restored
    And all data should be recovered
    And a domain event "WorldRecovered" should be published

  # =============================================================================
  # WORLD HEALTH MONITORING
  # =============================================================================

  @health @metrics
  Scenario: Monitor world health metrics
    Given a world "WLD-001" is active with monitoring enabled
    When I view health metrics
    Then I should see current metrics:
      | metric          | value  | status  |
      | cpu_percent     | 45%    | healthy |
      | memory_percent  | 62%    | healthy |
      | network_latency | 25ms   | healthy |
      | connections     | 180    | healthy |
      | error_rate      | 0.1%   | healthy |
    And metrics should refresh every 30 seconds

  @health @alerts @critical
  Scenario: Receive critical health alert
    Given a world has health monitoring configured
    When the cpu_percent exceeds 90%
    Then a critical alert should be triggered
    And the on-call team should be notified
    And the alert should appear on the dashboard
    And a domain event "WorldHealthCritical" should be published

  @health @alerts @warning
  Scenario: Receive warning health alert
    Given a world has health monitoring configured
    When the memory_percent exceeds 85%
    Then a warning alert should be triggered
    And the alert should be logged
    And recommendations should be displayed

  @health @thresholds
  Scenario: Configure custom health thresholds
    Given I am managing health monitoring for world "WLD-001"
    When I configure custom thresholds:
      | metric          | warning | critical |
      | cpu_percent     | 75      | 90       |
      | memory_percent  | 80      | 95       |
      | error_rate      | 3       | 5        |
    Then the custom thresholds should be saved
    And alerts should use the new thresholds

  @health @history
  Scenario: View health metric history
    Given a world has been monitored for 30 days
    When I view health history
    Then I should see trend charts for all metrics
    And I should be able to filter by time range
    And I should see incident markers on the timeline

  # =============================================================================
  # PERFORMANCE RESOLUTION
  # =============================================================================

  @performance @scaling
  Scenario: Scale resources to resolve performance issues
    Given a world "WLD-001" is experiencing high load
    And current resource allocation is:
      | cpu    | 4 cores |
      | memory | 8 GB    |
    When I initiate resource scaling to:
      | cpu    | 8 cores |
      | memory | 16 GB   |
    Then additional resources should be provisioned
    And the scaling action should be logged:
      | action         | scale_up        |
      | previous_cpu   | 4 cores         |
      | new_cpu        | 8 cores         |
      | cost_impact    | +$50/month      |
    And a domain event "WorldResourcesScaled" should be published

  @performance @restart
  Scenario: Restart world to resolve issues
    Given a world "WLD-002" is experiencing degraded performance
    And the world has 100 active players
    When I initiate a graceful world restart
    Then players should receive a 5-minute warning
    And players should be disconnected gracefully at restart time
    And the world should restart within 2 minutes
    And a domain event "WorldRestarted" should be published

  @performance @maintenance
  Scenario: Put world into maintenance mode
    Given a world needs extended maintenance
    When I enable maintenance mode with:
      | reason            | Database optimization     |
      | estimated_duration| 2 hours                   |
      | notification      | true                      |
    Then the world should enter maintenance mode
    And players should see maintenance message
    And new connections should be rejected

  # =============================================================================
  # BULK OPERATIONS
  # =============================================================================

  @bulk @update
  Scenario: Perform bulk world status update
    Given I have selected 10 worlds for bulk operation
    When I apply bulk action "enable_maintenance" with:
      | reason   | Platform-wide update |
      | duration | 30 minutes           |
    Then all 10 worlds should be updated
    And I should see a summary:
      | successful | 10 |
      | failed     | 0  |

  @bulk @confirmation
  Scenario: Bulk operation requires confirmation for large sets
    Given I have selected 75 worlds for bulk operation
    When I initiate the bulk action "suspend"
    Then I should be required to type "CONFIRM BULK SUSPEND 75"
    And I should see impact summary before confirmation

  @bulk @partial-failure
  Scenario: Handle partial failure in bulk operations
    Given I have selected 20 worlds for bulk operation
    And 3 worlds have conflicting states
    When I apply the bulk action
    Then 17 worlds should be updated successfully
    And 3 worlds should show failure reasons
    And I should have option to retry failed operations

  # =============================================================================
  # WORLD TEMPLATES
  # =============================================================================

  @templates @create
  Scenario: Create world template from existing world
    Given a world "WLD-001" has exemplary configuration
    When I create a template from the world:
      | name        | Fantasy World Template    |
      | description | Optimized for RPG games   |
      | category    | gaming                    |
    Then the template should be created
    And the template should be available for new world creation
    And a domain event "WorldTemplateCreated" should be published

  @templates @apply
  Scenario: Apply template to new world
    Given a template "Fantasy World Template" exists
    When I create a new world using the template
    Then the new world should have template configurations:
      | setting           | value           |
      | resource_profile  | medium          |
      | features_enabled  | chat, inventory |
      | default_settings  | applied         |

  @templates @versioning
  Scenario: Manage template versions
    Given a template has been updated multiple times
    When I view the template version history
    Then I should see all versions:
      | version | date       | changes             |
      | 3.0     | 2024-01-15 | Added new features  |
      | 2.0     | 2023-12-01 | Performance tuning  |
      | 1.0     | 2023-10-01 | Initial version     |
    And I should be able to revert to previous versions

  @templates @deprecate
  Scenario: Deprecate a template
    Given a template is outdated
    When I deprecate the template with:
      | reason      | Replaced by v2 template |
      | successor   | Fantasy World v2        |
    Then the template should be marked as deprecated
    And existing worlds should not be affected
    And new world creation should suggest the successor

  # =============================================================================
  # SERVER MIGRATION
  # =============================================================================

  @migration @happy-path
  Scenario: Migrate world between servers
    Given a world "WLD-001" is on server "us-east-1"
    And server "eu-west-1" has available capacity
    When I initiate migration to "eu-west-1":
      | scheduled_time | 2024-02-01 02:00 UTC |
      | notify_owner   | true                  |
    Then the migration should be scheduled
    And the world owner should be notified:
      | migration_date     | 2024-02-01 02:00 UTC |
      | estimated_downtime | 15 minutes           |
      | new_region         | eu-west-1            |

  @migration @execute
  Scenario: Execute scheduled migration
    Given a migration is scheduled for world "WLD-001"
    When the migration executes
    Then the world should be taken offline
    And data should be transferred to new server
    And the world should be verified on new server
    And a domain event "WorldMigrated" should be published

  @migration @rollback
  Scenario: Rollback failed migration
    Given a migration is in progress for world "WLD-001"
    And the migration fails verification
    When the rollback is initiated
    Then the world should be restored on original server
    And there should be no data loss
    And the owner should be notified of the failure
    And a domain event "WorldMigrationRolledBack" should be published

  @migration @progress
  Scenario: Monitor migration progress
    Given a migration is in progress
    When I view migration status
    Then I should see progress:
      | phase              | status     | progress |
      | data_export        | completed  | 100%     |
      | data_transfer      | in_progress| 65%      |
      | verification       | pending    | 0%       |
      | dns_update         | pending    | 0%       |
    And I should see estimated time remaining

  # =============================================================================
  # LEGAL AND COMPLIANCE
  # =============================================================================

  @legal @data-request
  Scenario: Handle legal data request
    Given a legal data request is received
    And the request is from a verified authority
    When I process the request with:
      | request_id     | LEGAL-2024-001          |
      | authority      | FBI                     |
      | world_id       | WLD-010                 |
      | data_scope     | user_activity, messages |
    Then the requested data should be extracted
    And the data should be encrypted
    And the data should be securely transmitted
    And the request should be logged in compliance system

  @legal @geo-restriction
  Scenario: Apply geo-restriction to world
    Given a world needs geographic restrictions
    When I apply geo-restrictions:
      | blocked_regions | CN, RU, IR |
      | reason          | Legal compliance |
    Then players from blocked regions should be denied access
    And existing players should be notified and disconnected
    And a domain event "WorldGeoRestricted" should be published

  @legal @gdpr
  Scenario: Process GDPR data deletion request
    Given a GDPR deletion request is received for a world
    When I process the GDPR request:
      | request_id | GDPR-2024-001 |
      | scope      | all_personal_data |
    Then personal data should be deleted within 30 days
    And confirmation should be sent to the requester
    And audit trail should be maintained

  @legal @content-takedown
  Scenario: Execute content takedown order
    Given a legal takedown order is received
    When I execute the takedown:
      | order_id      | TAKEDOWN-2024-001 |
      | content_type  | world             |
      | action        | immediate_removal |
    Then the world should be taken offline immediately
    And content should be preserved for legal review
    And a domain event "WorldTakenDown" should be published

  # =============================================================================
  # WORLD ANALYTICS
  # =============================================================================

  @analytics @engagement
  Scenario: View world engagement analytics
    Given a world has been active for 6 months
    When I view engagement analytics
    Then I should see:
      | metric                | value    |
      | daily_active_users    | 150      |
      | weekly_active_users   | 450      |
      | monthly_active_users  | 1200     |
      | avg_session_duration  | 45 min   |
      | sessions_per_user     | 3.2      |
    And I should see trend charts

  @analytics @retention
  Scenario: View retention analytics
    Given a world has user cohort data
    When I view retention analytics
    Then I should see retention rates:
      | cohort      | day_1 | day_7 | day_30 |
      | January     | 80%   | 55%   | 35%    |
      | February    | 82%   | 58%   | 38%    |
      | March       | 85%   | 60%   | 40%    |
    And I should be able to filter by cohort

  @analytics @compare
  Scenario: Compare analytics across worlds
    Given multiple worlds have analytics data
    When I compare worlds "WLD-001" and "WLD-002"
    Then I should see side-by-side metrics:
      | metric              | WLD-001 | WLD-002 | difference |
      | daily_active_users  | 150     | 180     | +20%       |
      | avg_session_duration| 45 min  | 38 min  | -16%       |
      | retention_30_day    | 35%     | 42%     | +20%       |

  @analytics @export
  Scenario: Export analytics reports
    Given I need to share analytics data
    When I export analytics for world "WLD-001":
      | format      | csv              |
      | date_range  | last_90_days     |
      | metrics     | all              |
    Then the report should be generated
    And the download should be available

  # =============================================================================
  # WORLD BACKUPS
  # =============================================================================

  @backup @list
  Scenario: View world backup list
    Given a world has automated backups configured
    When I view backup management for world "WLD-001"
    Then I should see available backups:
      | backup_id  | date       | size   | type      | status   |
      | BKP-001    | 2024-01-15 | 2.5 GB | automatic | verified |
      | BKP-002    | 2024-01-14 | 2.4 GB | automatic | verified |
      | BKP-003    | 2024-01-10 | 2.3 GB | manual    | verified |
    And I should see the backup schedule

  @backup @create
  Scenario: Create manual backup
    Given I need to backup a world before maintenance
    When I trigger a manual backup for world "WLD-001":
      | name   | Pre-maintenance backup |
      | retain | 90 days                |
    Then the backup should be created
    And the backup should be verified for integrity
    And a domain event "WorldBackupCreated" should be published

  @backup @restore
  Scenario: Restore world from backup
    Given a valid backup "BKP-001" exists for world "WLD-001"
    When I initiate restoration from "BKP-001"
    And I confirm the data loss warning
    Then the world should be taken offline
    And the world should be restored from backup
    And the restoration should be verified
    And a domain event "WorldRestored" should be published

  @backup @retention
  Scenario: Configure backup retention policy
    Given I am managing backups for world "WLD-001"
    When I configure retention policy:
      | daily_backups   | keep 7     |
      | weekly_backups  | keep 4     |
      | monthly_backups | keep 12    |
    Then the retention policy should be saved
    And old backups should be pruned accordingly

  # =============================================================================
  # FEATURE MANAGEMENT
  # =============================================================================

  @features @list
  Scenario: View world feature flags
    Given a world has configurable features
    When I view feature flags for world "WLD-001"
    Then I should see available features:
      | feature         | status  | dependencies    |
      | chat_system     | enabled | none            |
      | trading         | enabled | inventory       |
      | pvp_combat      | disabled| none            |
      | voice_chat      | enabled | chat_system     |

  @features @toggle
  Scenario: Toggle feature flag
    Given a feature "pvp_combat" is disabled for world "WLD-001"
    When I enable the feature "pvp_combat"
    Then the feature should be enabled
    And the change should be logged
    And billing should be updated if applicable
    And a domain event "WorldFeatureToggled" should be published

  @features @warning
  Scenario: Handle feature disable with active users
    Given 50 players are actively using "trading" feature
    When I attempt to disable "trading"
    Then I should see warning:
      | message        | 50 users currently using this feature |
      | impact         | Users will lose unsaved progress      |
    And I should have options:
      | option              | description                    |
      | immediate_disable   | Disable now with warning       |
      | scheduled_disable   | Disable after grace period     |
      | cancel              | Keep feature enabled           |

  # =============================================================================
  # SUPPORT HISTORY
  # =============================================================================

  @support @history
  Scenario: Access world support history
    Given a world has had support interactions
    When I view support history for world "WLD-001"
    Then I should see all related tickets:
      | ticket_id  | date       | issue               | status   |
      | TKT-001    | 2024-01-15 | Performance issue   | resolved |
      | TKT-002    | 2024-01-10 | Player complaint    | resolved |
      | TKT-003    | 2024-01-05 | Billing question    | resolved |
    And I should see admin actions taken

  @support @notes
  Scenario: Add support notes to world
    Given I am reviewing world "WLD-001"
    When I add internal support notes:
      | note | Owner contacted about TOS compliance. Agreed to review. |
    Then the notes should be saved with:
      | timestamp | current time |
      | admin_id  | my_admin_id  |
    And the notes should be visible to other admins

  @support @escalation
  Scenario: View and track escalated issues
    Given a world has escalated support issues
    When I view escalation status
    Then I should see:
      | issue            | escalated_to  | status     |
      | Legal concern    | Legal team    | in_review  |
      | Security breach  | Security team | resolved   |

  # =============================================================================
  # EMERGENCY OPERATIONS
  # =============================================================================

  @emergency @shutdown
  Scenario: Execute emergency world shutdown
    Given a world "WLD-050" poses risk to platform stability
    When I execute emergency shutdown with:
      | justification | Active exploit detected, spreading to other worlds |
      | severity      | critical                                            |
    Then the world should be immediately taken offline
    And all connections should be terminated within 5 seconds
    And the incident should be escalated to on-call team
    And a domain event "WorldEmergencyShutdown" should be published

  @emergency @resource-limit
  Scenario: Apply emergency resource limits
    Given a world is consuming excessive resources
    When I execute emergency resource limits:
      | cpu_limit    | 2 cores |
      | memory_limit | 4 GB    |
      | reason       | Preventing platform degradation |
    Then the limits should be applied immediately
    And the owner should be notified
    And a domain event "WorldResourceLimited" should be published

  @emergency @evacuation
  Scenario: Execute emergency player evacuation
    Given a server hosting multiple worlds is failing
    When I execute player evacuation:
      | source_server | us-east-1     |
      | target_server | us-west-2     |
      | priority      | critical      |
    Then all players should be migrated to backup server
    And player sessions should be preserved
    And a domain event "WorldEvacuated" should be published

  # =============================================================================
  # AUTHORIZATION AND SECURITY
  # =============================================================================

  @security @rbac
  Scenario: Enforce role-based access control
    Given an admin has "world_viewer" permission only
    When they attempt to suspend a world
    Then the operation should be denied with 403 Forbidden
    And the attempt should be logged
    And they should see "Insufficient permissions for world suspension"

  @security @elevation
  Scenario: Require elevated authorization for critical operations
    Given I have standard admin permissions
    When I attempt to delete a world
    Then I should be required to provide:
      | requirement          | type                    |
      | super_admin_approval | Another admin must approve |
      | mfa_verification     | Re-authenticate with MFA   |
      | confirmation_text    | Type DELETE WORLD-ID       |

  @security @audit
  Scenario: Audit all management actions
    Given I perform world management actions
    When any action is performed
    Then it should be recorded in the audit log:
      | field       | captured                    |
      | timestamp   | ISO 8601 format             |
      | admin_id    | Performing admin            |
      | action      | Action type                 |
      | target      | Affected world              |
      | details     | Action parameters           |
      | ip_address  | Request origin              |
    And logs should be immutable

  # =============================================================================
  # DOMAIN EVENTS
  # =============================================================================

  @domain-events @lifecycle
  Scenario: WorldCreated event triggers monitoring setup
    Given a new world is created
    When a "WorldCreated" event is published
    Then monitoring should be automatically configured
    And alerting rules should be applied
    And default backup schedule should be set

  @domain-events @suspension
  Scenario: WorldSuspended event triggers notifications
    Given a world is suspended
    When a "WorldSuspended" event is published
    Then all active players should be notified
    And player sessions should be gracefully closed
    And the owner should receive detailed notification

  @domain-events @deletion
  Scenario: WorldDeleted event triggers cleanup
    Given a world is deleted
    When a "WorldDeleted" event is published
    Then server resources should be released
    And billing should be finalized
    And data should be archived per retention policy

  # =============================================================================
  # ERROR HANDLING
  # =============================================================================

  @error @not-found
  Scenario: Handle world not found
    Given I search for a non-existent world "WLD-99999"
    When the request is processed
    Then I should see error "World not found"
    And I should see suggestions for similar world IDs

  @error @concurrent-modification
  Scenario: Handle concurrent modification conflict
    Given two admins are modifying the same world
    When the second admin saves their changes
    Then they should see "Conflict: World was modified by another admin"
    And they should see options to:
      | option    | description               |
      | refresh   | Load latest version       |
      | force     | Overwrite with my changes |
      | merge     | Merge changes manually    |

  @error @timeout
  Scenario: Handle operation timeout
    Given a world operation takes too long
    When the timeout threshold is exceeded
    Then I should see "Operation timed out"
    And the operation should be queued for retry
    And I should receive notification when completed

  @error @validation
  Scenario: Handle validation errors
    Given I am updating world settings
    When I submit invalid configuration
    Then I should see specific validation errors:
      | field       | error                      |
      | max_players | Must be between 1 and 1000 |
      | name        | Cannot be empty            |
    And the form should preserve my input
