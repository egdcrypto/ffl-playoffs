@admin @database @infrastructure @operations
Feature: Admin Database Management
  As a platform administrator
  I want to manage database infrastructure and operations
  So that I can ensure data integrity, performance, and availability

  Background:
    Given I am logged in as a platform administrator
    And I have database management permissions
    And the database management system is operational

  # ===========================================================================
  # DATABASE INFRASTRUCTURE DASHBOARD
  # ===========================================================================

  @api @database @dashboard
  Scenario: View database infrastructure dashboard
    Given the platform has multiple database instances
    When I navigate to the database dashboard
    Then I should see a response with status 200
    And I should see overall database health:
      | metric                    | value    | status  |
      | overall_health            | 98%      | healthy |
      | active_connections        | 1,245    | normal  |
      | storage_used              | 2.4 TB   | normal  |
      | replication_lag           | 45ms     | healthy |
    And I should see database instances:
      | instance_name    | type       | status  | role     | region    |
      | prod-primary     | PostgreSQL | healthy | primary  | us-east-1 |
      | prod-replica-1   | PostgreSQL | healthy | replica  | us-east-1 |
      | prod-replica-2   | PostgreSQL | healthy | replica  | us-west-2 |
      | analytics-db     | MongoDB    | healthy | primary  | us-east-1 |
    And I should see recent database events

  @api @database @dashboard
  Scenario: View database instance details
    Given I want to inspect a specific database instance
    When I select "prod-primary" instance
    Then I should see instance details:
      | field              | value                    |
      | instance_type      | db.r6g.2xlarge           |
      | engine_version     | PostgreSQL 15.4          |
      | storage_type       | io2                      |
      | storage_allocated  | 3 TB                     |
      | storage_used       | 2.4 TB (80%)             |
      | cpu_utilization    | 35%                      |
      | memory_utilization | 68%                      |
      | iops_current       | 12,500                   |
    And I should see connection statistics
    And I should see recent slow queries

  @api @database @dashboard
  Scenario: View database connection pool status
    Given the application uses connection pooling
    When I view connection pool status
    Then I should see pool metrics:
      | pool_name          | active | idle | waiting | max  |
      | app-pool-primary   | 85     | 15   | 0       | 100  |
      | app-pool-replica   | 45     | 55   | 0       | 100  |
      | analytics-pool     | 20     | 30   | 0       | 50   |
    And I should see connection trends over time
    And I should see pool health indicators

  # ===========================================================================
  # QUERY PERFORMANCE MONITORING
  # ===========================================================================

  @api @database @performance
  Scenario: Monitor query performance metrics
    Given the database is actively serving queries
    When I view query performance dashboard
    Then I should see performance metrics:
      | metric                    | value      |
      | queries_per_second        | 2,500      |
      | average_query_time        | 12ms       |
      | p95_query_time            | 45ms       |
      | p99_query_time            | 120ms      |
      | slow_queries_last_hour    | 23         |
      | failed_queries_last_hour  | 2          |
    And I should see query time distribution chart
    And I should see top queries by execution time

  @api @database @performance
  Scenario: View slow query log
    Given there are slow queries to analyze
    When I view the slow query log
    Then I should see slow queries:
      | query_hash | avg_time | calls | table          | operation |
      | a1b2c3d4   | 2.5s     | 150   | user_sessions  | SELECT    |
      | e5f6g7h8   | 1.8s     | 89    | activity_logs  | SELECT    |
      | i9j0k1l2   | 1.2s     | 312   | world_entities | JOIN      |
    And I should be able to view full query text
    And I should see execution plan for each query
    And I should see optimization suggestions

  @api @database @performance
  Scenario: Analyze query execution plan
    Given I have identified a slow query
    When I analyze the execution plan for query "a1b2c3d4"
    Then I should see execution plan details:
      | step                | rows_estimate | actual_rows | time_ms |
      | Seq Scan on users   | 10,000        | 12,345      | 450     |
      | Hash Join           | 5,000         | 5,234       | 800     |
      | Sort                | 5,000         | 5,234       | 350     |
    And I should see cost estimates
    And I should see missing index suggestions
    And I should see query rewrite recommendations

  @api @database @performance
  Scenario: Set up query performance alerts
    Given I want to be notified of performance issues
    When I configure query performance alerts:
      | alert_type              | threshold | severity |
      | avg_query_time          | > 100ms   | warning  |
      | p99_query_time          | > 500ms   | critical |
      | slow_queries_per_hour   | > 50      | warning  |
      | failed_queries_per_hour | > 10      | critical |
    Then alerts should be configured
    And I should receive notifications when thresholds exceeded
    And a QueryAlertConfigured event should be published

  # ===========================================================================
  # QUERY OPTIMIZATION
  # ===========================================================================

  @api @database @optimization
  Scenario: Optimize database queries
    Given query analysis has identified optimization opportunities
    When I view optimization recommendations
    Then I should see recommendations:
      | query_id   | recommendation              | estimated_improvement |
      | a1b2c3d4   | Add index on session_id     | 85% faster            |
      | e5f6g7h8   | Partition activity_logs     | 70% faster            |
      | i9j0k1l2   | Rewrite as materialized view| 60% faster            |
    And each recommendation should have implementation steps
    And I should see risk assessment for each change

  @api @database @optimization
  Scenario: Implement query optimization
    Given I want to apply an optimization
    When I implement optimization for query "a1b2c3d4":
      | action              | details                        |
      | create_index        | idx_sessions_user_id           |
      | test_environment    | staging                        |
      | validation_queries  | 100 sample queries             |
    Then optimization should be tested in staging
    And performance improvement should be measured
    And I should see before/after comparison
    And a QueryOptimizationApplied event should be published

  @api @database @optimization
  Scenario: Review query cache effectiveness
    Given query caching is enabled
    When I view cache statistics
    Then I should see cache metrics:
      | metric              | value    |
      | cache_hit_ratio     | 92%      |
      | cache_size_used     | 4.2 GB   |
      | cache_size_max      | 8 GB     |
      | cached_queries      | 15,432   |
      | evictions_last_hour | 234      |
    And I should see most cached queries
    And I should see cache miss analysis

  # ===========================================================================
  # INDEX MANAGEMENT
  # ===========================================================================

  @api @database @indexes
  Scenario: View database indexes
    Given the database has multiple indexes
    When I view index management
    Then I should see all indexes:
      | table           | index_name              | columns           | size   | usage  |
      | users           | users_pkey              | id                | 50 MB  | high   |
      | users           | idx_users_email         | email             | 120 MB | high   |
      | sessions        | idx_sessions_user_id    | user_id           | 200 MB | medium |
      | activity_logs   | idx_activity_created    | created_at        | 500 MB | low    |
    And I should see index usage statistics
    And I should see unused indexes highlighted

  @api @database @indexes
  Scenario: Analyze index health
    Given I want to check index health
    When I run index health analysis
    Then I should see index health report:
      | issue_type        | count | impact   |
      | unused_indexes    | 5     | medium   |
      | duplicate_indexes | 2     | low      |
      | bloated_indexes   | 3     | high     |
      | missing_indexes   | 8     | critical |
    And I should see recommendations for each issue
    And I should see estimated storage savings

  @api @database @indexes
  Scenario: Create new database index
    Given query analysis suggests a new index
    When I create index:
      | field              | value                        |
      | table              | user_sessions                |
      | index_name         | idx_sessions_active_user     |
      | columns            | user_id, is_active           |
      | type               | btree                        |
      | concurrent         | true                         |
    Then index creation should be initiated
    And I should see creation progress
    And creation should not block table operations
    And an IndexCreated event should be published

  @api @database @indexes
  Scenario: Drop unused index
    Given an index "idx_activity_created" is unused
    When I drop the index:
      | confirmation      | verified_unused              |
      | backup_ddl        | true                         |
    Then index should be dropped
    And DDL should be saved for potential recreation
    And storage should be reclaimed
    And an IndexDropped event should be published

  @api @database @indexes
  Scenario: Rebuild bloated indexes
    Given some indexes are bloated
    When I rebuild bloated indexes:
      | index_name              | current_size | expected_size |
      | idx_users_email         | 120 MB       | 80 MB         |
      | idx_sessions_user_id    | 200 MB       | 140 MB        |
    Then indexes should be rebuilt concurrently
    And I should see rebuild progress
    And storage should be reclaimed after rebuild
    And an IndexRebuilt event should be published

  # ===========================================================================
  # DATABASE BACKUPS
  # ===========================================================================

  @api @database @backup
  Scenario: Configure database backup schedule
    Given I need to set up automated backups
    When I configure backup schedule:
      | backup_type     | frequency    | retention | time       |
      | full_backup     | daily        | 30 days   | 02:00 UTC  |
      | incremental     | hourly       | 7 days    | :00        |
      | transaction_log | continuous   | 7 days    | streaming  |
    Then backup schedule should be configured
    And next backup times should be calculated
    And a BackupScheduleConfigured event should be published

  @api @database @backup
  Scenario: View backup inventory
    Given backups have been created
    When I view backup inventory
    Then I should see available backups:
      | backup_id    | type        | created          | size    | status    |
      | bk-20241228  | full        | 2024-12-28 02:00 | 2.1 TB  | completed |
      | bk-20241227  | full        | 2024-12-27 02:00 | 2.0 TB  | completed |
      | inc-20241228 | incremental | 2024-12-28 12:00 | 50 GB   | completed |
    And I should see backup storage usage
    And I should see retention policy status

  @api @database @backup
  Scenario: Initiate manual backup
    Given I need an immediate backup before maintenance
    When I initiate manual backup:
      | field              | value                    |
      | backup_type        | full                     |
      | description        | Pre-maintenance backup   |
      | retention_override | 90 days                  |
    Then backup should be initiated
    And I should see backup progress
    And I should be notified on completion
    And a ManualBackupInitiated event should be published

  @api @database @backup
  Scenario: Verify backup integrity
    Given I want to ensure backups are valid
    When I verify backup "bk-20241228"
    Then verification should run:
      | check                | result  |
      | checksum_valid       | pass    |
      | restore_test         | pass    |
      | data_consistency     | pass    |
      | encryption_valid     | pass    |
    And I should see verification report
    And a BackupVerified event should be published

  @api @database @backup
  Scenario: Configure backup encryption
    Given backups must be encrypted
    When I configure backup encryption:
      | field              | value                    |
      | encryption_type    | AES-256                  |
      | key_management     | AWS KMS                  |
      | key_rotation       | 90 days                  |
    Then encryption should be configured
    And all new backups should be encrypted
    And I should see key rotation schedule

  # ===========================================================================
  # DATABASE RESTORE
  # ===========================================================================

  @api @database @restore
  Scenario: Restore database from backup
    Given I need to restore from backup
    When I initiate restore from "bk-20241228":
      | field              | value                    |
      | target_instance    | restore-test-01          |
      | restore_type       | full                     |
      | point_in_time      | 2024-12-28 01:30:00      |
    Then restore should be initiated
    And I should see restore progress:
      | phase              | status    | progress |
      | snapshot_restore   | completed | 100%     |
      | log_replay         | in_progress| 45%     |
      | consistency_check  | pending   | 0%       |
    And I should be notified on completion
    And a DatabaseRestoreInitiated event should be published

  @api @database @restore
  Scenario: Perform point-in-time recovery
    Given I need to recover to a specific time
    When I configure point-in-time recovery:
      | field              | value                    |
      | recovery_target    | 2024-12-28 15:30:00 UTC  |
      | source_backup      | bk-20241228              |
      | transaction_logs   | apply_until_target       |
    Then PITR should be initiated
    And I should see recovery timeline
    And I should see data consistency verification
    And a PointInTimeRecoveryInitiated event should be published

  @api @database @restore
  Scenario: Restore to new instance
    Given I need to restore to a separate instance
    When I restore to new instance:
      | field              | value                    |
      | source_backup      | bk-20241228              |
      | new_instance_name  | restored-prod-copy       |
      | instance_type      | db.r6g.xlarge            |
      | network            | isolated-vpc             |
    Then new instance should be provisioned
    And data should be restored
    And instance should be isolated from production
    And a DatabaseRestoredToNewInstance event should be published

  @api @database @restore
  Scenario: Validate restored database
    Given database restore has completed
    When I validate the restored database
    Then validation should check:
      | validation_type    | result  | details                  |
      | row_counts         | pass    | All tables match         |
      | referential_integ  | pass    | All FKs valid            |
      | application_test   | pass    | Sample queries succeed   |
      | data_checksums     | pass    | Checksums match source   |
    And I should see validation report
    And restored database should be marked as verified

  # ===========================================================================
  # REPLICATION MONITORING
  # ===========================================================================

  @api @database @replication
  Scenario: Monitor replication health
    Given the database uses replication
    When I view replication status
    Then I should see replication topology:
      | instance        | role     | lag     | status  |
      | prod-primary    | primary  | n/a     | healthy |
      | prod-replica-1  | replica  | 45ms    | healthy |
      | prod-replica-2  | replica  | 120ms   | warning |
    And I should see replication lag trends
    And I should see bytes replicated per second

  @api @database @replication
  Scenario: Configure replication alerts
    Given I want to monitor replication lag
    When I configure replication alerts:
      | alert_type           | threshold | severity |
      | replication_lag      | > 500ms   | warning  |
      | replication_lag      | > 2s      | critical |
      | replication_stopped  | any       | critical |
      | replica_disconnected | any       | critical |
    Then alerts should be configured
    And I should receive notifications on issues
    And a ReplicationAlertConfigured event should be published

  @api @database @replication
  Scenario: Add new replica
    Given I need more read capacity
    When I add a new replica:
      | field              | value                    |
      | replica_name       | prod-replica-3           |
      | instance_type      | db.r6g.xlarge            |
      | region             | eu-west-1                |
      | source             | prod-primary             |
    Then replica provisioning should begin
    And I should see replication setup progress
    And replica should join replication topology
    And an ReplicaAdded event should be published

  @api @database @replication
  Scenario: Promote replica to primary
    Given primary database needs replacement
    When I promote "prod-replica-1" to primary:
      | field              | value                    |
      | promotion_type     | planned                  |
      | dns_update         | automatic                |
      | notify_applications| true                     |
    Then promotion should be initiated
    And I should see promotion progress
    And DNS should be updated
    And applications should reconnect
    And a ReplicaPromoted event should be published

  # ===========================================================================
  # SCHEMA MANAGEMENT
  # ===========================================================================

  @api @database @schema
  Scenario: View database schema
    Given the database has multiple schemas
    When I view schema browser
    Then I should see schema structure:
      | schema    | tables | views | functions | size    |
      | public    | 45     | 12    | 8         | 1.8 TB  |
      | analytics | 15     | 25    | 5         | 500 GB  |
      | audit     | 8      | 2     | 0         | 200 GB  |
    And I should be able to browse tables
    And I should see column definitions
    And I should see relationships

  @api @database @schema
  Scenario: Compare schema versions
    Given schema has changed over time
    When I compare current schema to previous version
    Then I should see schema differences:
      | change_type    | object              | details                    |
      | added_column   | users.last_login    | timestamp with time zone   |
      | added_table    | user_preferences    | 5 columns                  |
      | modified_index | idx_sessions_user   | added include columns      |
      | dropped_column | legacy.old_field    | varchar(255)               |
    And I should see migration script
    And I should see rollback script

  @api @database @schema
  Scenario: Generate schema documentation
    Given I need schema documentation
    When I generate documentation
    Then documentation should include:
      | section              | content                          |
      | table_definitions    | All tables with columns          |
      | relationships        | Foreign key relationships        |
      | indexes              | All indexes with usage stats     |
      | constraints          | Check and unique constraints     |
      | comments             | Column and table comments        |
    And documentation should be exportable
    And ER diagrams should be generated

  @api @database @schema
  Scenario: Apply schema migration
    Given a schema migration is ready
    When I apply migration "v2024.12.28":
      | field              | value                    |
      | environment        | staging                  |
      | pre_check          | run_validation           |
      | backup_before      | true                     |
      | rollback_plan      | available                |
    Then migration should be applied
    And I should see migration progress
    And post-migration validation should run
    And a SchemaMigrationApplied event should be published

  # ===========================================================================
  # DATA MIGRATION
  # ===========================================================================

  @api @database @migration
  Scenario: Plan data migration
    Given I need to migrate data between databases
    When I create migration plan:
      | field              | value                    |
      | source             | legacy-postgres          |
      | target             | prod-primary             |
      | tables             | users, orders, products  |
      | transformation     | schema_mapping_v1        |
      | validation         | row_count, checksums     |
    Then migration plan should be created
    And I should see estimated migration time
    And I should see resource requirements
    And a DataMigrationPlanned event should be published

  @api @database @migration
  Scenario: Execute data migration
    Given a migration plan is ready
    When I execute migration:
      | field              | value                    |
      | mode               | incremental              |
      | batch_size         | 10000                    |
      | parallel_workers   | 4                        |
      | error_handling     | log_and_continue         |
    Then migration should begin
    And I should see real-time progress:
      | table     | total_rows | migrated | errors | progress |
      | users     | 100,000    | 75,000   | 0      | 75%      |
      | orders    | 500,000    | 500,000  | 2      | 100%     |
      | products  | 10,000     | 0        | 0      | 0%       |
    And a DataMigrationExecuted event should be published

  @api @database @migration
  Scenario: Validate migrated data
    Given data migration has completed
    When I validate migrated data
    Then validation should check:
      | check_type         | source   | target   | status |
      | row_count          | 100,000  | 100,000  | pass   |
      | checksum           | abc123   | abc123   | pass   |
      | referential_integ  | valid    | valid    | pass   |
      | sample_comparison  | 100/100  | match    | pass   |
    And I should see detailed validation report
    And discrepancies should be highlighted

  @api @database @migration
  Scenario: Rollback failed migration
    Given a migration has errors
    When I rollback migration:
      | field              | value                    |
      | rollback_point     | pre_migration_snapshot   |
      | preserve_logs      | true                     |
    Then rollback should be initiated
    And database should return to previous state
    And migration errors should be preserved for analysis
    And a MigrationRolledBack event should be published

  # ===========================================================================
  # PERFORMANCE TUNING
  # ===========================================================================

  @api @database @tuning
  Scenario: View database configuration
    Given I want to review database settings
    When I view database configuration
    Then I should see configuration parameters:
      | parameter              | value    | default | impact     |
      | shared_buffers         | 8GB      | 128MB   | high       |
      | work_mem               | 256MB    | 4MB     | medium     |
      | maintenance_work_mem   | 2GB      | 64MB    | medium     |
      | effective_cache_size   | 24GB     | 4GB     | high       |
      | max_connections        | 500      | 100     | medium     |
    And I should see which require restart
    And I should see tuning recommendations

  @api @database @tuning
  Scenario: Apply performance tuning
    Given tuning recommendations are available
    When I apply tuning changes:
      | parameter         | old_value | new_value | requires_restart |
      | work_mem          | 256MB     | 512MB     | no               |
      | random_page_cost  | 4.0       | 1.5       | no               |
    Then changes should be applied
    And I should see before/after metrics
    And changes should be logged
    And a PerformanceTuningApplied event should be published

  @api @database @tuning
  Scenario: Analyze table statistics
    Given I need up-to-date statistics
    When I analyze table statistics
    Then I should see statistics freshness:
      | table           | last_analyze | rows_estimate | dead_tuples |
      | users           | 2 hours ago  | 100,000       | 1,200       |
      | activity_logs   | 6 hours ago  | 5,000,000     | 150,000     |
      | sessions        | 1 hour ago   | 50,000        | 500         |
    And I should be able to trigger manual analyze
    And I should see autovacuum status

  @api @database @tuning
  Scenario: Configure autovacuum settings
    Given autovacuum needs tuning
    When I configure autovacuum:
      | setting                         | value    |
      | autovacuum_vacuum_threshold     | 50       |
      | autovacuum_vacuum_scale_factor  | 0.1      |
      | autovacuum_analyze_threshold    | 50       |
      | autovacuum_naptime              | 30s      |
    Then autovacuum settings should be updated
    And I should see projected impact
    And an AutovacuumConfigured event should be published

  # ===========================================================================
  # DATABASE MONITORING
  # ===========================================================================

  @api @database @monitoring
  Scenario: Configure database monitoring
    Given I want comprehensive monitoring
    When I configure monitoring:
      | metric_category    | collection_interval | retention |
      | performance        | 10 seconds          | 30 days   |
      | connections        | 30 seconds          | 14 days   |
      | storage            | 5 minutes           | 90 days   |
      | replication        | 10 seconds          | 14 days   |
    Then monitoring should be configured
    And metrics should start collecting
    And dashboards should be updated

  @api @database @monitoring
  Scenario: View real-time database metrics
    Given monitoring is active
    When I view real-time metrics
    Then I should see live metrics:
      | metric                    | value    | trend   |
      | queries_per_second        | 2,543    | stable  |
      | active_connections        | 245      | up      |
      | transactions_per_second   | 1,234    | stable  |
      | disk_iops                 | 15,000   | stable  |
      | buffer_cache_hit_ratio    | 99.2%    | stable  |
    And metrics should update in real-time
    And I should see historical comparison

  @api @database @monitoring
  Scenario: Configure database alerts
    Given I want proactive alerting
    When I configure database alerts:
      | alert_type              | condition           | severity | notification    |
      | cpu_utilization         | > 85% for 5 min     | warning  | email, slack    |
      | storage_utilization     | > 90%               | critical | page, email     |
      | connection_count        | > 450               | warning  | slack           |
      | replication_lag         | > 1 second          | critical | page            |
    Then alerts should be configured
    And alert rules should be active
    And a DatabaseAlertConfigured event should be published

  @api @database @monitoring
  Scenario: View database activity logs
    Given the database logs all activity
    When I view activity logs
    Then I should see recent activity:
      | timestamp           | user        | action       | details              |
      | 2024-12-28 10:00    | app_user    | query        | SELECT on users      |
      | 2024-12-28 10:01    | admin       | ddl_change   | ALTER TABLE sessions |
      | 2024-12-28 10:02    | replicator  | replication  | WAL sent             |
    And I should be able to filter logs
    And I should be able to search logs
    And I should be able to export logs

  # ===========================================================================
  # DATABASE SECURITY
  # ===========================================================================

  @api @database @security
  Scenario: Manage database users and roles
    Given database has multiple users
    When I view user management
    Then I should see database users:
      | username     | roles              | last_login       | status   |
      | app_user     | read_write         | 2024-12-28 10:00 | active   |
      | readonly     | read_only          | 2024-12-27 15:00 | active   |
      | admin        | superuser          | 2024-12-28 09:00 | active   |
      | backup_user  | backup_operator    | 2024-12-28 02:00 | active   |
    And I should see role definitions
    And I should see privilege assignments

  @api @database @security
  Scenario: Create database user
    Given I need to add a new database user
    When I create user:
      | field              | value                    |
      | username           | analytics_user           |
      | authentication     | iam_authentication       |
      | roles              | analytics_readonly       |
      | password_policy    | rotate_90_days           |
      | connection_limit   | 10                       |
    Then user should be created
    And credentials should be securely stored
    And a DatabaseUserCreated event should be published

  @api @database @security
  Scenario: Audit database access
    Given I want to review database access
    When I view access audit report
    Then I should see access patterns:
      | user         | queries_today | tables_accessed | sensitive_access |
      | app_user     | 15,432        | 12              | 3                |
      | readonly     | 2,345         | 5               | 0                |
      | admin        | 123           | 25              | 10               |
    And I should see sensitive data access details
    And I should see failed access attempts

  @api @database @security
  Scenario: Configure row-level security
    Given sensitive data requires access control
    When I configure row-level security:
      | table         | policy_name      | condition                    |
      | user_data     | tenant_isolation | tenant_id = current_tenant() |
      | financial     | role_based       | user_role IN ('finance')     |
    Then RLS policies should be created
    And policies should be enforced
    And a RowLevelSecurityConfigured event should be published

  @api @database @security
  Scenario: Rotate database credentials
    Given credentials need rotation
    When I rotate credentials for "app_user":
      | field              | value                    |
      | rotation_type      | immediate                |
      | notify_applications| true                     |
      | old_credential_ttl | 1 hour                   |
    Then new credentials should be generated
    And applications should be notified
    And old credentials should expire after TTL
    And a CredentialsRotated event should be published

  # ===========================================================================
  # CAPACITY PLANNING
  # ===========================================================================

  @api @database @capacity
  Scenario: View capacity metrics
    Given I want to plan for growth
    When I view capacity dashboard
    Then I should see capacity metrics:
      | resource         | current   | limit    | growth_rate | days_to_limit |
      | storage          | 2.4 TB    | 4 TB     | 50 GB/month | 32 days       |
      | connections      | 250       | 500      | 10/month    | 25 days       |
      | iops             | 15,000    | 20,000   | 500/month   | 10 days       |
    And I should see capacity trend graphs
    And I should see growth projections

  @api @database @capacity
  Scenario: Generate capacity forecast
    Given I need to forecast future needs
    When I generate capacity forecast:
      | field              | value                    |
      | forecast_period    | 12 months                |
      | growth_scenario    | current_trend            |
      | confidence_level   | 90%                      |
    Then forecast should be generated:
      | month    | storage   | connections | cost_impact |
      | Jan 2025 | 2.5 TB    | 260         | $500        |
      | Jun 2025 | 2.8 TB    | 310         | $800        |
      | Dec 2025 | 3.2 TB    | 380         | $1,200      |
    And I should see upgrade recommendations
    And I should see cost projections

  @api @database @capacity
  Scenario: Plan capacity upgrade
    Given capacity limits are approaching
    When I plan capacity upgrade:
      | resource         | current   | target    | justification        |
      | instance_type    | r6g.2xl   | r6g.4xl   | CPU and memory needs |
      | storage          | 4 TB      | 8 TB      | Data growth          |
      | iops             | 20,000    | 40,000    | Performance needs    |
    Then upgrade plan should be created
    And I should see estimated downtime
    And I should see cost impact
    And a CapacityUpgradePlanned event should be published

  # ===========================================================================
  # DATA ARCHIVAL
  # ===========================================================================

  @api @database @archival
  Scenario: Configure data archival policies
    Given old data should be archived
    When I configure archival policy:
      | table           | retention    | archive_to    | condition              |
      | activity_logs   | 90 days      | s3_archive    | created_at < threshold |
      | audit_logs      | 1 year       | s3_archive    | created_at < threshold |
      | old_sessions    | 30 days      | delete        | expired = true         |
    Then archival policies should be configured
    And archival jobs should be scheduled
    And an ArchivalPolicyConfigured event should be published

  @api @database @archival
  Scenario: Execute data archival
    Given archival is scheduled
    When archival job runs
    Then I should see archival progress:
      | table           | rows_archived | size_freed | status    |
      | activity_logs   | 5,000,000     | 100 GB     | completed |
      | audit_logs      | 1,000,000     | 25 GB      | completed |
      | old_sessions    | 500,000       | 5 GB       | completed |
    And archived data should be queryable
    And storage should be reclaimed
    And a DataArchivalCompleted event should be published

  @api @database @archival
  Scenario: Query archived data
    Given data has been archived to S3
    When I query archived data:
      | field              | value                    |
      | table              | activity_logs            |
      | date_range         | 2024-01-01 to 2024-06-30 |
      | query              | SELECT * WHERE user_id=1 |
    Then query should execute against archive
    And results should be returned
    And I should see query cost estimate

  # ===========================================================================
  # DATABASE FAILOVER
  # ===========================================================================

  @api @database @failover
  Scenario: Configure failover settings
    Given high availability is required
    When I configure failover:
      | setting                  | value              |
      | automatic_failover       | enabled            |
      | failover_threshold       | 30 seconds         |
      | health_check_interval    | 5 seconds          |
      | dns_ttl                  | 30 seconds         |
    Then failover configuration should be saved
    And health checks should be active
    And a FailoverConfigured event should be published

  @api @database @failover
  Scenario: Test database failover
    Given I want to validate failover works
    When I initiate failover test:
      | field              | value                    |
      | test_type          | controlled               |
      | target_replica     | prod-replica-1           |
      | notify_teams       | true                     |
      | rollback_timeout   | 10 minutes               |
    Then failover test should begin
    And I should see failover progress
    And applications should reconnect
    And I should see failover metrics:
      | metric              | value    |
      | total_failover_time | 45 sec   |
      | connection_recovery | 15 sec   |
      | data_loss           | 0 bytes  |
    And a FailoverTestCompleted event should be published

  @api @database @failover
  Scenario: Handle automatic failover
    Given primary database becomes unavailable
    When automatic failover triggers
    Then I should see failover alert
    And replica should be promoted
    And DNS should be updated
    And applications should reconnect
    And incident should be created
    And an AutomaticFailoverTriggered event should be published

  # ===========================================================================
  # DATABASE MAINTENANCE
  # ===========================================================================

  @api @database @maintenance
  Scenario: Schedule database maintenance
    Given maintenance is needed
    When I schedule maintenance:
      | field              | value                    |
      | maintenance_type   | minor_version_upgrade    |
      | scheduled_time     | 2025-01-05 02:00 UTC     |
      | estimated_duration | 30 minutes               |
      | notification_lead  | 48 hours                 |
    Then maintenance should be scheduled
    And affected parties should be notified
    And maintenance window should be reserved
    And a MaintenanceScheduled event should be published

  @api @database @maintenance
  Scenario: Execute maintenance window
    Given maintenance window has started
    When I execute maintenance:
      | step                  | status    | duration |
      | pre_checks            | completed | 2 min    |
      | create_snapshot       | completed | 5 min    |
      | apply_updates         | in_progress| 10 min  |
      | validate_update       | pending   | 5 min    |
      | restore_traffic       | pending   | 3 min    |
    Then I should see maintenance progress
    And I should see estimated completion time
    And I should have rollback option

  @api @database @maintenance
  Scenario: Perform vacuum and analyze
    Given table maintenance is needed
    When I run maintenance:
      | operation    | tables              | options         |
      | vacuum       | activity_logs       | full, analyze   |
      | reindex      | idx_sessions_user   | concurrently    |
      | analyze      | all                 | verbose         |
    Then maintenance should execute
    And I should see maintenance progress
    And I should see space reclaimed
    And a MaintenanceCompleted event should be published

  # ===========================================================================
  # DATABASE COST OPTIMIZATION
  # ===========================================================================

  @api @database @costs
  Scenario: View database costs
    Given I want to understand database costs
    When I view cost dashboard
    Then I should see cost breakdown:
      | cost_category      | monthly_cost | percentage |
      | compute_instances  | $5,000       | 50%        |
      | storage            | $2,000       | 20%        |
      | iops               | $1,500       | 15%        |
      | backup_storage     | $1,000       | 10%        |
      | data_transfer      | $500         | 5%         |
    And I should see cost trends
    And I should see cost by database instance

  @api @database @costs
  Scenario: Get cost optimization recommendations
    Given I want to reduce database costs
    When I view cost optimization recommendations
    Then I should see recommendations:
      | recommendation              | estimated_savings | risk    |
      | Right-size replica-2        | $800/month        | low     |
      | Use reserved instances      | $1,200/month      | low     |
      | Archive old data            | $300/month        | medium  |
      | Reduce backup retention     | $200/month        | medium  |
    And each recommendation should have implementation steps
    And I should see total potential savings

  @api @database @costs
  Scenario: Implement cost optimization
    Given I want to apply optimization
    When I implement "Right-size replica-2":
      | field              | value                    |
      | current_type       | r6g.2xlarge              |
      | target_type        | r6g.xlarge               |
      | scheduled_time     | 2025-01-05 02:00 UTC     |
    Then optimization should be scheduled
    And I should see expected savings
    And a CostOptimizationApplied event should be published

  # ===========================================================================
  # DOMAIN EVENTS
  # ===========================================================================

  @domain-events
  Scenario: DatabaseHealthDegraded triggers alerting
    Given database health degrades
    When DatabaseHealthDegraded event is published
    Then the event should contain:
      | field           | description                    |
      | instance_id     | Affected database instance     |
      | health_score    | Current health score           |
      | degraded_metrics| Which metrics are degraded     |
      | severity        | Severity level                 |
    And on-call should be alerted
    And incident should be created
    And automatic remediation should be considered

  @domain-events
  Scenario: BackupCompleted updates inventory
    Given a backup completes
    When BackupCompleted event is published
    Then the event should contain:
      | field           | description                    |
      | backup_id       | Unique backup identifier       |
      | backup_type     | Full or incremental            |
      | size            | Backup size                    |
      | duration        | Time taken                     |
    And backup inventory should be updated
    And retention policies should be applied
    And monitoring should be notified

  @domain-events
  Scenario: ReplicationLagExceeded triggers investigation
    Given replication lag exceeds threshold
    When ReplicationLagExceeded event is published
    Then the event should contain:
      | field           | description                    |
      | replica_id      | Affected replica               |
      | current_lag     | Current lag in milliseconds    |
      | threshold       | Configured threshold           |
    And alert should be raised
    And replication health check should run
    And potential causes should be identified

  @domain-events
  Scenario: SchemaChangeApplied triggers documentation
    Given a schema change is applied
    When SchemaChangeApplied event is published
    Then the event should contain:
      | field           | description                    |
      | migration_id    | Migration identifier           |
      | changes         | List of schema changes         |
      | applied_by      | Who applied the change         |
    And schema documentation should update
    And dependent systems should be notified
    And change should be audited

  # ===========================================================================
  # ERROR HANDLING
  # ===========================================================================

  @api @error
  Scenario: Handle database connection failure
    Given database connection fails
    When I attempt to access database dashboard
    Then I should see connection error message
    And cached status should be displayed if available
    And I should see last known state
    And retry options should be available
    And a DatabaseConnectionError event should be published

  @api @error
  Scenario: Handle backup failure
    Given a backup job fails
    When backup error occurs
    Then I should receive alert notification
    And failure details should be logged:
      | field           | value                    |
      | error_type      | insufficient_storage     |
      | failed_at       | snapshot phase           |
      | partial_backup  | preserved                |
    And retry should be scheduled
    And escalation should occur if repeated

  @api @error
  Scenario: Handle migration failure
    Given a schema migration fails
    When migration error occurs
    Then migration should stop safely
    And database should remain consistent
    And rollback options should be presented
    And error details should be logged
    And I should be able to fix and retry

  @api @error
  Scenario: Handle concurrent database operations
    Given two admins attempt conflicting operations
    When both operations are submitted
    Then one operation should succeed
    And the other should be blocked or queued
    And conflict notification should be shown
    And audit log should capture both attempts
