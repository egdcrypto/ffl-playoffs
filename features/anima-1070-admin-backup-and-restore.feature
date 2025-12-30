@admin @backup @disaster-recovery @ANIMA-1070
Feature: Admin Backup and Restore
  As a platform administrator
  I want to manage system backups and restoration
  So that I can ensure data safety and disaster recovery

  Background:
    Given an authenticated administrator with "backup_management" permissions
    And the backup system is operational
    And the following storage backends are configured:
      | backend     | type    | region    | status |
      | primary     | S3      | us-east-1 | active |
      | secondary   | S3      | us-west-2 | active |
      | archive     | Glacier | us-east-1 | active |

  # =============================================================================
  # BACKUP DASHBOARD AND OVERVIEW
  # =============================================================================

  @dashboard @happy-path
  Scenario: View backup system dashboard
    Given there are 150 stored backups across all storage backends
    And the last successful backup completed 2 hours ago
    When I access the backup management dashboard
    Then I should see the backup system health status as "Healthy"
    And I should see summary metrics:
      | metric                  | value              |
      | total_backups           | 150                |
      | last_backup_time        | 2 hours ago        |
      | next_scheduled_backup   | in 22 hours        |
      | storage_used            | 2.4 TB             |
      | backup_success_rate     | 99.2%              |
      | oldest_restore_point    | 365 days ago       |
    And I should see the recent backup activity log

  @dashboard @metrics
  Scenario: View detailed backup metrics
    Given backup data for the past 30 days
    When I view the metrics section
    Then I should see the following performance indicators:
      | metric                | current | trend   |
      | avg_backup_duration   | 45m     | -10%    |
      | compression_ratio     | 3.2x    | stable  |
      | dedup_savings         | 45%     | +5%     |
      | transfer_speed        | 850MB/s | +15%    |
    And I should see trend charts for each metric

  @dashboard @alerts
  Scenario: View backup alerts and warnings
    Given there are active backup-related alerts
    When I view the backup dashboard
    Then I should see active alerts categorized by severity:
      | severity | alert_type           | message                          |
      | critical | backup_failed        | Backup job BKP-1234 failed       |
      | warning  | storage_threshold    | Storage 85% full                 |
      | warning  | replication_lag      | Secondary region 2 hours behind  |
      | info     | maintenance_scheduled| Maintenance window in 24 hours   |
    And I should be able to acknowledge or dismiss alerts
    And dismissed alerts should be logged for audit

  @dashboard @storage-overview
  Scenario: View storage utilization breakdown
    Given backups distributed across storage tiers
    When I view the storage overview
    Then I should see utilization by tier:
      | tier     | used    | available | cost_per_gb |
      | hot      | 500 GB  | 500 GB    | $0.023      |
      | warm     | 1.2 TB  | 800 GB    | $0.0125     |
      | cold     | 700 GB  | 1.3 TB    | $0.004      |
    And I should see storage growth projections

  # =============================================================================
  # BACKUP SCHEDULE CONFIGURATION
  # =============================================================================

  @schedule @happy-path
  Scenario: Configure daily backup schedule
    Given I want to set up automated backups
    When I configure a backup schedule with:
      | parameter        | value                |
      | name             | daily_full_backup    |
      | frequency        | Daily                |
      | time             | 02:00 UTC            |
      | backup_type      | Full                 |
      | components       | All                  |
      | retention_policy | standard_30_day      |
    Then the schedule should be created
    And the next run should be calculated
    And a domain event "BackupScheduleConfigured" should be published

  @schedule @cron
  Scenario: Configure custom CRON schedule
    Given I need a complex backup schedule
    When I enter CRON expression "0 2 * * 1-5"
    Then the system should display human-readable interpretation:
      """
      At 02:00 AM, Monday through Friday
      """
    And show next 5 scheduled execution times
    And validate the CRON syntax
    And warn if schedule conflicts with existing schedules

  @schedule @multiple
  Scenario: Manage multiple backup schedules
    Given I have different backup requirements for different components
    When I create multiple schedules:
      | schedule_name    | type        | frequency | components    |
      | daily_full       | Full        | Daily 2AM | All           |
      | hourly_db        | Incremental | Hourly    | Database only |
      | weekly_archive   | Full        | Weekly    | All           |
    Then each schedule should operate independently
    And the system should detect overlapping schedules
    And provide a unified schedule calendar view

  @schedule @conflict-detection
  Scenario: Detect and resolve schedule conflicts
    Given an existing backup schedule at 02:00 UTC
    When I create a new schedule also at 02:00 UTC
    Then the system should warn about the conflict
    And suggest alternative times with:
      | suggested_time | reason                    |
      | 01:30 UTC      | 30 minutes before existing|
      | 02:30 UTC      | 30 minutes after existing |
      | 03:00 UTC      | Low system activity       |
    And I should be able to proceed or adjust

  @schedule @disable
  Scenario: Temporarily disable backup schedule
    Given an active backup schedule "daily_full_backup"
    When I disable the schedule with reason "Maintenance window"
    Then the schedule should be marked as disabled
    And scheduled backups should not run
    And a reminder should be set to re-enable
    And a domain event "BackupScheduleDisabled" should be published

  # =============================================================================
  # BACKUP TYPES AND STRATEGIES
  # =============================================================================

  @backup-type @full
  Scenario: Create full backup
    Given I need a complete system snapshot
    When I initiate a full backup
    Then the system should:
      | action                  | description                      |
      | capture_all_data        | All databases and file systems   |
      | include_configurations  | System and application configs   |
      | include_metadata        | User permissions, settings       |
      | generate_manifest       | List of all included items       |
      | calculate_checksum      | SHA-256 for integrity            |
    And display estimated completion time
    And a domain event "BackupInitiated" should be published

  @backup-type @incremental
  Scenario: Create incremental backup
    Given a full backup "BKP-BASE-001" exists as baseline
    And changes have been made since the baseline
    When I initiate an incremental backup
    Then the system should capture only changes since last backup
    And the backup should be smaller than full backup
    And the backup should reference parent backup "BKP-BASE-001"
    And display:
      | metric           | value    |
      | changed_files    | 1,245    |
      | total_size       | 125 MB   |
      | baseline_ref     | BKP-BASE-001 |

  @backup-type @differential
  Scenario: Create differential backup
    Given a full backup "BKP-BASE-001" exists as baseline
    And multiple incremental backups have been created
    When I initiate a differential backup
    Then the system should capture all changes since last full backup
    And the backup should only reference the full backup
    And display comparison:
      | backup_type   | size   | restore_complexity |
      | incremental   | 125 MB | High (chain)       |
      | differential  | 450 MB | Medium (2 backups) |

  @backup-type @selective
  Scenario: Backup specific components
    Given I only need to backup certain components
    When I select components for backup:
      | component        | selected | size_estimate |
      | postgresql       | yes      | 500 MB        |
      | mongodb          | yes      | 2 GB          |
      | redis            | no       | -             |
      | file_storage     | yes      | 1.5 GB        |
      | configurations   | yes      | 50 MB         |
      | secrets          | yes      | 5 MB          |
    Then only selected components should be included
    And dependencies should be automatically included
    And the manifest should reflect component selection

  @backup-type @snapshot
  Scenario: Create database snapshot backup
    Given I need a consistent database snapshot
    When I initiate a database snapshot backup
    Then the system should:
      | step                    | description                      |
      | pause_writes            | Briefly pause write operations   |
      | create_snapshot         | Create point-in-time snapshot    |
      | resume_writes           | Resume normal operations         |
      | export_snapshot         | Export to backup storage         |
    And the write pause should be less than 5 seconds
    And application impact should be minimal

  # =============================================================================
  # RETENTION POLICIES
  # =============================================================================

  @retention @configuration
  Scenario: Configure backup retention policies
    Given I need to manage backup lifecycle
    When I configure retention policy:
      | parameter           | value |
      | daily_retention     | 7     |
      | weekly_retention    | 4     |
      | monthly_retention   | 12    |
      | yearly_retention    | 3     |
      | minimum_copies      | 2     |
    Then the system should calculate storage impact
    And display projected storage usage over time
    And a domain event "RetentionPolicyConfigured" should be published

  @retention @compliance
  Scenario: Configure compliance-based retention
    Given I have regulatory compliance requirements
    When I configure compliance retention:
      | regulation | retention_period | data_types                 |
      | GDPR       | 3 years          | EU user data               |
      | HIPAA      | 7 years          | Healthcare records         |
      | SOX        | 7 years          | Financial transactions     |
      | PCI-DSS    | 1 year           | Payment card data          |
    Then the system should enforce minimum retention periods
    And prevent deletion of compliance-required backups
    And flag backups approaching compliance expiry

  @retention @cleanup
  Scenario: Execute automatic retention cleanup
    Given retention policy specifies 30-day maximum age
    And backup "BKP-OLD-001" is 35 days old
    When the retention cleanup job runs
    Then "BKP-OLD-001" should be marked for deletion
    And the system should verify:
      | check                    | result |
      | not_last_backup          | pass   |
      | no_compliance_hold       | pass   |
      | not_tagged_permanent     | pass   |
    And deletion should execute after 7-day grace period
    And a domain event "BackupExpired" should be published

  @retention @hold
  Scenario: Place legal hold on backup
    Given a backup "BKP-2024-001" exists
    And a legal hold is required for litigation
    When I place a legal hold on the backup
    Then the backup should be marked with hold status
    And the backup should be excluded from retention cleanup
    And deletion should require explicit hold removal
    And the hold should be logged for audit

  # =============================================================================
  # MANUAL BACKUP OPERATIONS
  # =============================================================================

  @manual @happy-path
  Scenario: Create manual backup
    Given I need an immediate backup outside schedule
    When I initiate a manual backup with:
      | field       | value                           |
      | name        | pre-release-backup-v2.5         |
      | reason      | Before major release deployment |
      | type        | Full                            |
      | priority    | High                            |
    Then the backup should start immediately
    And be prioritized over scheduled backups
    And be tagged as "manual" for audit purposes
    And a domain event "ManualBackupInitiated" should be published

  @manual @pre-deployment
  Scenario: Create pre-deployment backup
    Given a deployment "DEPLOY-2024-001" is planned
    When I create a pre-deployment backup
    Then the backup should be tagged with deployment ID
    And marked as rollback point
    And excluded from automatic retention cleanup
    And linked to deployment record
    And quick-restore should be enabled

  @manual @progress-tracking
  Scenario: Track manual backup progress
    Given a manual backup is in progress
    When I view the backup progress
    Then I should see real-time progress:
      | component    | progress | status      |
      | postgresql   | 100%     | completed   |
      | mongodb      | 75%      | in_progress |
      | file_storage | 0%       | pending     |
    And estimated time remaining
    And I should be able to cancel the backup

  @manual @cancel
  Scenario: Cancel in-progress backup
    Given a backup "BKP-2024-100" is 30% complete
    When I cancel the backup
    Then the backup should be marked as "cancelled"
    And partial data should be cleaned up
    And resources should be released
    And a domain event "BackupCancelled" should be published

  # =============================================================================
  # RESTORE POINTS AND RECOVERY
  # =============================================================================

  @restore-points @list
  Scenario: View available restore points
    Given backups have been created over time
    When I view available restore points
    Then I should see a timeline of restore points
    And each point should display:
      | attribute        | value                          |
      | timestamp        | 2024-01-15 02:00:00 UTC        |
      | type             | Full                           |
      | size             | 2.5 GB                         |
      | components       | All                            |
      | integrity_status | Verified                       |
      | tags             | scheduled, verified            |
    And I should be able to filter by date range and type

  @restore-points @search
  Scenario: Search for specific restore point
    Given I need to find a backup from a specific time
    When I search with criteria:
      | criterion     | value                    |
      | date_range    | 2024-01-01 to 2024-01-31 |
      | backup_type   | Full                     |
      | status        | Verified                 |
    Then matching restore points should be displayed
    And sorted by date descending
    And each result should show restore complexity

  @restore-points @compare
  Scenario: Compare restore points
    Given I have selected two restore points
    When I compare "BKP-2024-001" with "BKP-2024-002"
    Then I should see differences:
      | metric           | BKP-2024-001 | BKP-2024-002 |
      | size             | 2.5 GB       | 2.7 GB       |
      | file_count       | 15,234       | 15,456       |
      | schema_version   | 45           | 46           |
    And highlight significant changes

  # =============================================================================
  # TEST RESTORE OPERATIONS
  # =============================================================================

  @test-restore @happy-path
  Scenario: Perform test restore
    Given backup "BKP-2024-001" exists and is verified
    When I initiate a test restore
    Then the system should:
      | step                    | description                      |
      | create_sandbox          | Isolated test environment        |
      | restore_to_sandbox      | Restore backup to sandbox        |
      | run_integrity_checks    | Validate data consistency        |
      | generate_report         | Document test results            |
      | cleanup_sandbox         | Remove test environment          |
    And production should not be affected
    And a domain event "TestRestoreCompleted" should be published

  @test-restore @validation
  Scenario: Validate restored data integrity
    Given a test restore has completed
    When integrity validation runs
    Then the system should verify:
      | check                | expected | actual | status |
      | row_counts           | 50,234   | 50,234 | pass   |
      | checksum_validation  | match    | match  | pass   |
      | relationship_integrity | valid  | valid  | pass   |
      | application_start    | success  | success| pass   |
    And generate detailed validation report
    And the backup should be marked as "test_verified"

  @test-restore @sample
  Scenario: Perform sample data verification
    Given a test restore environment is running
    When I run sample data queries
    Then the system should execute:
      | query_type           | expected_result              |
      | user_count           | matches_production           |
      | latest_transaction   | exists_and_valid             |
      | configuration_hash   | matches_manifest             |
    And report any discrepancies

  @test-restore @cleanup
  Scenario: Clean up test restore environment
    Given a test restore completed 1 hour ago
    When the cleanup job runs
    Then the sandbox environment should be destroyed
    And all test data should be securely deleted
    And resources should be released
    And cleanup should be logged for audit

  # =============================================================================
  # PRODUCTION RESTORE OPERATIONS
  # =============================================================================

  @production-restore @happy-path
  Scenario: Execute production restore
    Given I need to restore production data
    And backup "BKP-2024-001" is verified
    When I initiate a production restore
    Then the system should require:
      | requirement              | provided                     |
      | restore_point_selection  | BKP-2024-001                 |
      | component_selection      | Full                         |
      | maintenance_window       | Scheduled                    |
      | approval                 | Secondary admin approved     |
      | confirmation             | RESTORE                      |
    And create a pre-restore backup automatically
    And a domain event "RestoreInitiated" should be published

  @production-restore @partial
  Scenario: Perform partial restore
    Given I only need to restore specific data
    When I select partial restore with:
      | option              | value                        |
      | specific_database   | postgresql                   |
      | specific_tables     | users, transactions          |
      | exclude_tables      | audit_logs                   |
    Then the system should handle dependencies
    And warn about potential inconsistencies:
      | warning                              | severity |
      | Foreign key references may break     | high     |
      | Related cache may be stale           | medium   |
    And require explicit acknowledgment

  @production-restore @point-in-time
  Scenario: Point-in-time recovery
    Given I need to restore to a specific moment
    And full backup exists from 2024-01-15 02:00
    And transaction logs are available
    When I select point-in-time recovery to "2024-01-15 14:30:00 UTC"
    Then the system should:
      | step                    | description                      |
      | identify_base_backup    | BKP-2024-001                     |
      | locate_transaction_logs | Logs from 02:00 to 14:30         |
      | replay_transactions     | Apply logs up to target time     |
      | validate_consistency    | Verify database state            |
    And confirm the exact recovery point

  @production-restore @progress
  Scenario: Monitor restore progress
    Given a production restore is in progress
    When I view the restore status
    Then I should see real-time progress:
      | phase                | progress | eta        |
      | prepare_environment  | 100%     | completed  |
      | restore_database     | 45%      | 15 minutes |
      | restore_files        | 0%       | pending    |
      | validate_data        | 0%       | pending    |
    And I should see affected services status

  @production-restore @rollback
  Scenario: Rollback failed restore
    Given a restore operation is in progress
    And the restore fails at 60% completion
    When the rollback is triggered
    Then the system should:
      | action                  | description                    |
      | stop_restore            | Halt current operation         |
      | restore_pre_backup      | Use automatic pre-restore backup |
      | verify_rollback         | Confirm system state           |
      | notify_administrators   | Send failure notification      |
    And log failure reason and rollback actions
    And a domain event "RestoreFailed" should be published

  # =============================================================================
  # BACKUP HEALTH MONITORING
  # =============================================================================

  @monitoring @health
  Scenario: Monitor backup health metrics
    Given backups are running on schedule
    When I view backup health metrics
    Then I should see:
      | metric                | value  | threshold | status  |
      | backup_success_rate   | 99.2%  | 99%       | healthy |
      | avg_backup_duration   | 45m    | 60m       | healthy |
      | storage_growth_rate   | 5%/mo  | 10%/mo    | healthy |
      | replication_lag       | 30m    | 60m       | healthy |
      | last_verified_backup  | 2 days | 7 days    | healthy |
    And receive proactive alerts for anomalies

  @monitoring @failures
  Scenario: Handle backup failure
    Given a scheduled backup has failed
    When the failure is detected
    Then the system should:
      | action                | result                         |
      | alert_admins          | Email and Slack notification   |
      | log_failure_details   | Error captured in logs         |
      | attempt_retry         | Retry in 30 minutes            |
      | escalate_if_persistent| After 3 failures, page on-call |
    And a domain event "BackupFailed" should be published
    And dashboard should show failure status

  @monitoring @anomaly-detection
  Scenario: Detect backup anomalies
    Given normal backup size is 2.5 GB
    When a backup completes at 4.0 GB (60% larger)
    Then the system should flag the anomaly
    And generate an investigation alert:
      | field         | value                          |
      | anomaly_type  | size_deviation                 |
      | expected      | 2.5 GB (+/- 10%)               |
      | actual        | 4.0 GB                         |
      | deviation     | +60%                           |
    And the backup should be marked for review

  @monitoring @sla
  Scenario: Track backup SLA compliance
    Given backup SLA requires 99.9% success rate
    When I view SLA compliance report
    Then I should see:
      | period     | target | actual | status     |
      | last_day   | 99.9%  | 100%   | compliant  |
      | last_week  | 99.9%  | 99.5%  | warning    |
      | last_month | 99.9%  | 99.8%  | compliant  |
    And breaches should be highlighted with root cause

  # =============================================================================
  # DISASTER RECOVERY
  # =============================================================================

  @disaster-recovery @test
  Scenario: Execute disaster recovery test
    Given I have a disaster recovery plan configured
    When I initiate a DR test
    Then the system should:
      | step                    | expected_result              |
      | failover_to_secondary   | Secondary site activated     |
      | validate_services       | All services operational     |
      | measure_rto             | 2 hours (target: 4 hours)    |
      | measure_rpo             | 30 minutes (target: 1 hour)  |
      | generate_report         | DR test report generated     |
      | failback_to_primary     | Primary site restored        |
    And a domain event "DisasterRecoveryTestCompleted" should be published

  @disaster-recovery @objectives
  Scenario: Configure recovery objectives
    Given I need to define recovery targets
    When I configure recovery objectives:
      | objective | value    | description                      |
      | RTO       | 4 hours  | Recovery Time Objective          |
      | RPO       | 1 hour   | Recovery Point Objective         |
      | MTPD      | 24 hours | Maximum Tolerable Downtime       |
    Then the system should validate backup frequency meets RPO
    And recommend schedule adjustments if needed
    And alert if objectives cannot be met

  @disaster-recovery @failover
  Scenario: Execute emergency failover
    Given primary site is unavailable
    And disaster has been declared
    When I initiate emergency failover
    Then the system should:
      | action                  | status                       |
      | activate_dr_site        | Secondary site activated     |
      | restore_latest_backup   | BKP-2024-100 restored        |
      | update_dns              | Traffic redirected           |
      | notify_stakeholders     | Emergency notifications sent |
      | begin_incident_tracking | Incident INC-2024-001 created|
    And a domain event "DisasterRecoveryActivated" should be published

  @disaster-recovery @failback
  Scenario: Execute failback to primary site
    Given system is running on DR site
    And primary site has been restored
    When I initiate failback
    Then the system should:
      | step                    | description                  |
      | sync_changes            | Copy changes from DR to primary |
      | validate_sync           | Verify data consistency      |
      | switch_traffic          | Gradually move traffic back  |
      | deactivate_dr           | Return DR to standby         |
    And monitor for issues during transition

  @disaster-recovery @runbook
  Scenario: Access disaster recovery runbook
    Given a disaster scenario is detected
    When I access the DR runbook
    Then I should see step-by-step procedures for:
      | scenario              | steps_count | last_updated  |
      | complete_site_failure | 15          | 2024-01-10    |
      | database_corruption   | 12          | 2024-01-10    |
      | ransomware_attack     | 20          | 2024-01-10    |
      | network_outage        | 10          | 2024-01-10    |
    And each step should have clear instructions

  # =============================================================================
  # BACKUP STORAGE MANAGEMENT
  # =============================================================================

  @storage @configuration
  Scenario: Configure backup storage backend
    Given I need to set up backup storage
    When I configure storage settings:
      | setting              | value                          |
      | primary_storage      | S3                             |
      | bucket_name          | ffl-playoffs-backups           |
      | region               | us-east-1                      |
      | encryption           | AES-256-GCM                    |
      | compression          | ZSTD                           |
    Then the storage backend should be validated
    And connectivity should be tested
    And storage should be ready for use

  @storage @encryption
  Scenario: Configure backup encryption
    Given I need encrypted backups for compliance
    When I configure encryption settings:
      | setting            | value                          |
      | algorithm          | AES-256-GCM                    |
      | key_management     | Customer-managed (KMS)         |
      | key_id             | arn:aws:kms:...                |
      | key_rotation       | Every 90 days                  |
    Then all new backups should be encrypted
    And existing backups should remain accessible
    And key rotation should be scheduled

  @storage @tiers
  Scenario: Configure storage tier transitions
    Given I want to optimize backup storage costs
    When I configure storage tier transitions:
      | age        | tier           | access_time | cost_per_gb |
      | 0-30 days  | S3 Standard    | immediate   | $0.023      |
      | 30-90 days | S3 IA          | immediate   | $0.0125     |
      | 90+ days   | Glacier        | 3-5 hours   | $0.004      |
    Then transitions should be scheduled automatically
    And users should be warned about retrieval delays

  @storage @cleanup
  Scenario: Clean up orphaned backup data
    Given there is orphaned backup data from failed operations
    When I run storage cleanup
    Then the system should identify orphaned data:
      | type               | size   | age        |
      | incomplete_uploads | 500 MB | 7 days     |
      | deleted_references | 1.2 GB | 30 days    |
      | temp_files         | 200 MB | 1 day      |
    And safely remove orphaned data
    And reclaim storage space

  # =============================================================================
  # COMPLIANCE AND REPORTING
  # =============================================================================

  @compliance @report
  Scenario: Generate backup compliance report
    Given I need to demonstrate backup compliance
    When I generate a compliance report for "SOC2"
    Then the report should include:
      | section                | status    |
      | backup_schedule        | Compliant |
      | retention_compliance   | Compliant |
      | encryption_status      | Compliant |
      | integrity_verification | Compliant |
      | dr_test_history        | Compliant |
      | audit_trail            | Compliant |
    And export in PDF, CSV, or JSON format

  @compliance @audit-trail
  Scenario: View backup audit trail
    Given I need to review backup operations history
    When I access the audit trail
    Then I should see all backup-related events:
      | timestamp           | event_type      | user        | details              |
      | 2024-01-15 02:00:00 | backup_created  | system      | Full backup BKP-001  |
      | 2024-01-15 10:30:00 | backup_verified | admin       | Integrity check pass |
      | 2024-01-15 14:00:00 | policy_changed  | admin       | Retention updated    |
    And filter by date, user, or event type
    And export audit logs for external review

  @compliance @data-residency
  Scenario: Enforce data residency requirements
    Given I have data residency requirements for EU data
    When I configure backup storage
    Then the system should:
      | requirement              | enforcement                    |
      | eu_data_location         | Only EU regions allowed        |
      | cross_border_transfer    | Blocked by default             |
      | compliance_tagging       | Auto-tag EU data backups       |
    And alert if non-compliant storage is selected

  # =============================================================================
  # BACKUP AUTOMATION
  # =============================================================================

  @automation @triggers
  Scenario: Configure automated backup triggers
    Given I want intelligent backup automation
    When I configure automation rules:
      | trigger               | action                           |
      | pre_deployment        | Create automatic backup          |
      | schema_migration      | Create database backup           |
      | storage_80_percent    | Alert and cleanup                |
      | failure_count_3       | Escalate to on-call              |
    Then the rules should execute automatically
    And all automated actions should be logged

  @automation @notifications
  Scenario: Configure backup notifications
    Given I want to stay informed about backup status
    When I configure notifications:
      | event                 | channels                         |
      | backup_completed      | Email (daily digest)             |
      | backup_failed         | Email, Slack, PagerDuty          |
      | storage_warning       | Email, Slack                     |
      | verification_failed   | Email, PagerDuty                 |
    Then notifications should include relevant details
    And support notification suppression windows

  @automation @self-healing
  Scenario: Enable self-healing for backup failures
    Given self-healing automation is enabled
    When a backup fails due to transient error
    Then the system should:
      | action               | result                           |
      | analyze_failure      | Identify transient error         |
      | wait_backoff         | Wait 5 minutes                   |
      | retry_backup         | Attempt backup again             |
      | verify_success       | Confirm backup completed         |
    And log all self-healing actions
    And escalate if self-healing fails

  # =============================================================================
  # BACKUP INTEGRITY
  # =============================================================================

  @integrity @validation
  Scenario: Validate backup integrity
    Given backup "BKP-2024-001" needs verification
    When I run integrity validation
    Then the system should perform:
      | check                  | result  |
      | checksum_verification  | pass    |
      | manifest_validation    | pass    |
      | corruption_detection   | pass    |
      | sample_restore         | pass    |
    And mark backup as "verified"
    And a domain event "BackupIntegrityVerified" should be published

  @integrity @scheduled
  Scenario: Schedule automatic integrity checks
    Given I want regular integrity validation
    When I configure integrity check schedule:
      | setting               | value                            |
      | frequency             | Weekly                           |
      | scope                 | All unverified backups           |
      | sample_percentage     | 100% for recent, 10% for old     |
    Then checks should run automatically
    And failed checks should trigger alerts
    And verification history should be maintained

  @integrity @repair
  Scenario: Attempt repair of corrupted backup
    Given backup "BKP-2024-050" has detected corruption
    When I attempt repair
    Then the system should:
      | action               | result                           |
      | identify_corrupted   | 3 files corrupted                |
      | check_redundancy     | Redundant copies available       |
      | replace_corrupted    | Restore from redundant copy      |
      | verify_repair        | Integrity check passes           |
    And mark backup as "repaired"
    And log repair actions

  # =============================================================================
  # CROSS-REGION REPLICATION
  # =============================================================================

  @replication @configuration
  Scenario: Configure cross-region replication
    Given I need geographic redundancy
    When I configure cross-region replication:
      | setting               | value                            |
      | source_region         | us-east-1                        |
      | target_regions        | us-west-2, eu-west-1             |
      | replication_mode      | Asynchronous                     |
      | bandwidth_limit       | 100 MB/s                         |
    Then replication should begin
    And a domain event "ReplicationConfigured" should be published

  @replication @monitoring
  Scenario: Monitor replication lag
    Given cross-region replication is configured
    When I view replication status
    Then I should see:
      | region     | current_lag | bytes_pending | health   |
      | us-west-2  | 15 minutes  | 500 MB        | healthy  |
      | eu-west-1  | 45 minutes  | 1.2 GB        | warning  |
    And receive alerts when lag exceeds threshold

  @replication @failover
  Scenario: Failover to replica region
    Given replication is active to us-west-2
    And primary region us-east-1 is unavailable
    When I failover to replica region
    Then us-west-2 should become primary
    And all backup operations should continue
    And replication should reconfigure when original primary recovers

  # =============================================================================
  # COST OPTIMIZATION
  # =============================================================================

  @cost @analysis
  Scenario: View backup cost breakdown
    Given I want to understand backup costs
    When I view cost reporting
    Then I should see:
      | category              | monthly_cost |
      | storage_costs         | $2,450       |
      | transfer_costs        | $320         |
      | operation_costs       | $85          |
      | total                 | $2,855       |
    And see cost trend over time
    And export for chargeback

  @cost @optimization
  Scenario: Get cost optimization recommendations
    Given I want to reduce backup storage costs
    When I request optimization analysis
    Then recommendations should include:
      | recommendation         | potential_savings | risk_level |
      | enable_deduplication   | $400/month        | low        |
      | adjust_retention       | $300/month        | medium     |
      | use_cold_storage       | $500/month        | low        |
      | reduce_full_backups    | $200/month        | medium     |
    And show implementation steps for each

  @cost @budget-alerts
  Scenario: Configure budget alerts
    Given I have a monthly backup budget of $3,000
    When I configure budget alerts:
      | threshold | action                           |
      | 80%       | Email notification               |
      | 90%       | Slack alert                      |
      | 100%      | PagerDuty and pause non-critical |
    Then alerts should trigger at thresholds
    And forecast should predict budget status

  # =============================================================================
  # API SCENARIOS
  # =============================================================================

  @api @create-backup
  Scenario: Create backup via API
    Given I have a valid API token with backup permissions
    When I send a POST request to /api/v1/admin/backups with:
      """
      {
        "name": "api-backup-001",
        "type": "full",
        "components": ["postgresql", "mongodb"],
        "priority": "normal"
      }
      """
    Then the response status should be 202 Accepted
    And the response should contain:
      | field      | value                |
      | backup_id  | BKP-API-001          |
      | status     | in_progress          |
      | job_url    | /api/v1/jobs/JOB-001 |

  @api @initiate-restore
  Scenario: Initiate restore via API
    Given I have a valid API token with restore permissions
    When I send a POST request to /api/v1/admin/restores with:
      """
      {
        "backup_id": "BKP-2024-001",
        "target": "production",
        "confirmation": "RESTORE"
      }
      """
    Then the response status should be 202 Accepted
    And require X-Approval-Token header for production

  @api @get-status
  Scenario: Get backup status via API
    Given I have a valid API token
    When I send a GET request to /api/v1/admin/backups/BKP-2024-001
    Then the response status should be 200 OK
    And the response should contain backup details and status

  @api @list-backups
  Scenario: List backups via API with pagination
    Given I have a valid API token
    When I send a GET request to /api/v1/admin/backups?page=1&limit=20&type=full
    Then the response should contain paginated backup list
    And include pagination metadata:
      | field        | value |
      | total        | 150   |
      | page         | 1     |
      | limit        | 20    |
      | total_pages  | 8     |

  @api @webhook
  Scenario: Configure backup completion webhook
    Given I want to receive backup notifications via webhook
    When I configure a webhook:
      """
      {
        "url": "https://example.com/webhooks/backup",
        "events": ["backup.completed", "backup.failed"],
        "secret": "webhook-secret-key"
      }
      """
    Then the webhook should be validated
    And events should be delivered with HMAC signature

  # =============================================================================
  # ERROR SCENARIOS
  # =============================================================================

  @error @insufficient-storage
  Scenario: Handle insufficient storage for backup
    Given backup storage is 95% full
    When a backup is initiated
    Then the system should:
      | action               | result                           |
      | warn_low_storage     | Display storage warning          |
      | suggest_cleanup      | Recommend expired backup removal |
      | suggest_expansion    | Provide storage expansion steps  |
    And fail backup if storage is exhausted
    And a domain event "BackupFailed" should be published

  @error @corrupted-backup
  Scenario: Handle corrupted backup detection
    Given a backup integrity check detects corruption
    When corruption is confirmed
    Then the backup should be marked as "corrupted"
    And alerts should be sent to administrators
    And the backup should be excluded from restore options
    And suggest re-creating the backup
    And check other backups for similar corruption

  @error @unauthorized-restore
  Scenario: Prevent unauthorized restore operations
    Given I am logged in without restore permissions
    When I attempt to initiate a restore
    Then the request should be denied with 403 Forbidden
    And display "Insufficient permissions for restore operation"
    And log the unauthorized attempt
    And alert security team if pattern detected

  @error @restore-failure
  Scenario: Handle restore failure gracefully
    Given a restore operation fails at 60% completion
    When the failure is detected
    Then the system should:
      | action                  | result                         |
      | stop_restore            | Halt operation immediately     |
      | capture_state           | Save failure diagnostics       |
      | initiate_rollback       | Restore from pre-backup        |
      | notify_admins           | Send failure notification      |
    And provide detailed failure analysis
    And suggest remediation steps

  @error @network-failure
  Scenario: Handle network failure during backup
    Given a backup is transferring to remote storage
    When network connectivity is lost
    Then the system should:
      | action               | result                           |
      | pause_transfer       | Pause upload immediately         |
      | retry_connection     | Attempt reconnection             |
      | resume_upload        | Continue from checkpoint         |
    And complete backup when connectivity restores
    And log all network interruptions

  @error @concurrent-operations
  Scenario: Prevent conflicting concurrent operations
    Given a restore operation is in progress
    When another restore is attempted
    Then the second restore should be rejected
    And display "Conflicting operation in progress"
    And provide estimated completion time of current operation
    And option to queue the second operation

  # =============================================================================
  # DOMAIN EVENTS
  # =============================================================================

  @domain-events
  Scenario: Publish domain events for backup lifecycle
    Given the event bus is configured
    When backup lifecycle events occur
    Then the following events should be published:
      | event_type                    | payload_includes                     |
      | BackupInitiated               | backup_id, type, components          |
      | BackupCompleted               | backup_id, size, duration, checksum  |
      | BackupFailed                  | backup_id, error, retry_count        |
      | BackupVerified                | backup_id, verification_result       |
      | BackupExpired                 | backup_id, retention_policy          |
      | RestoreInitiated              | restore_id, backup_id, target        |
      | RestoreCompleted              | restore_id, duration, components     |
      | RestoreFailed                 | restore_id, error, rollback_status   |
      | DisasterRecoveryActivated     | dr_site, rto_actual, rpo_actual      |
      | RetentionPolicyConfigured     | policy_id, retention_periods         |
      | ReplicationConfigured         | source, targets, mode                |
