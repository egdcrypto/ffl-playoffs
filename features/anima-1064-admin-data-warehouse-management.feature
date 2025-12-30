@admin @data-warehouse @etl @platform
Feature: Admin Data Warehouse Management
  As a platform administrator
  I want to manage the data warehouse and analytics infrastructure
  So that I can provide reliable business intelligence and reporting capabilities

  Background:
    Given I am logged in as a platform administrator
    And I have data warehouse management permissions
    And the data warehouse infrastructure is operational
    And the following databases exist in the warehouse:
      | database  | schema_count | table_count |
      | raw       | 3            | 25          |
      | staging   | 2            | 15          |
      | analytics | 4            | 40          |
      | reports   | 2            | 20          |

  # ============================================
  # DATA WAREHOUSE DASHBOARD
  # ============================================

  Scenario: View data warehouse dashboard with comprehensive metrics
    When I navigate to the data warehouse dashboard
    Then I should see warehouse storage utilization showing:
      | metric                    | display_format    |
      | total_storage_used        | in GB/TB          |
      | total_storage_available   | in GB/TB          |
      | utilization_percentage    | as percentage     |
      | storage_trend_7_days      | as sparkline      |
    And I should see active ETL job status showing:
      | metric                    | value_type        |
      | jobs_running              | integer           |
      | jobs_queued               | integer           |
      | jobs_failed_last_24h      | integer           |
      | jobs_completed_last_24h   | integer           |
    And I should see data freshness indicators for each critical table:
      | table               | max_acceptable_age |
      | user_events         | 1 hour             |
      | revenue_daily       | 24 hours           |
      | player_stats        | 15 minutes         |
    And I should see query performance metrics showing:
      | metric                      | display_format    |
      | avg_query_time_1h           | in milliseconds   |
      | p95_query_time_1h           | in milliseconds   |
      | queries_per_minute          | as rate           |
      | slow_query_count_24h        | integer           |

  Scenario: Dashboard real-time updates on ETL completion
    Given the dashboard is open
    And table "user_events" shows data freshness as "15 minutes ago"
    And ETL job "user_events_hourly" is running
    When ETL job "user_events_hourly" completes successfully
    Then data freshness for "user_events" should update to "Just now"
    And job status should reflect completion
    And the ETL job count should decrement from running to completed
    And a toast notification should appear: "ETL job user_events_hourly completed successfully"

  Scenario: Dashboard shows warning indicators for data freshness violations
    Given the dashboard is open
    And table "player_stats" has max acceptable age of 15 minutes
    When the data in "player_stats" becomes 20 minutes old
    Then the freshness indicator for "player_stats" should turn yellow/warning
    And a "Stale Data" warning badge should appear
    And the dashboard should suggest running the refresh pipeline

  Scenario: View warehouse health status with cluster details
    When I check warehouse health
    Then I should see cluster node status showing:
      | node_id   | status  | cpu_usage | memory_usage | disk_usage |
      | node-1    | healthy | 45%       | 62%          | 71%        |
      | node-2    | healthy | 52%       | 58%          | 71%        |
      | node-3    | warning | 85%       | 78%          | 71%        |
    And I should see resource utilization trends for the last 24 hours
    And I should see performance alerts:
      | alert_type        | severity | message                                    |
      | high_cpu          | warning  | Node node-3 CPU above 80% threshold        |
      | query_queue       | info     | 5 queries queued waiting for resources     |

  Scenario: Dashboard auto-refresh configuration
    Given the dashboard is open
    And auto-refresh is set to 30 seconds
    When 30 seconds elapse
    Then the dashboard should automatically refresh all metrics
    And a "Last updated: Just now" timestamp should appear
    When I disable auto-refresh
    Then the dashboard should stop automatic updates
    And manual refresh button should be prominent

  # ============================================
  # SCHEMA MANAGEMENT
  # ============================================

  Scenario: View schema catalog with full metadata
    When I view the schema catalog
    Then I should see all databases and schemas organized hierarchically
    And for each database I should see:
      | attribute           | description                          |
      | name                | database name                        |
      | owner               | owning team/user                     |
      | created_at          | creation timestamp                   |
      | schema_count        | number of schemas                    |
    And for each schema I should see:
      | attribute           | description                          |
      | name                | schema name                          |
      | table_count         | number of tables                     |
      | total_size          | storage used by schema               |
    And for each table I should see:
      | attribute           | description                          |
      | name                | table name                           |
      | row_count           | approximate row count                |
      | size                | table size in MB/GB                  |
      | last_modified       | last data modification time          |
      | partitioned         | whether table is partitioned         |
    And I should be able to expand tables to view column metadata:
      | column_attribute    | description                          |
      | name                | column name                          |
      | data_type           | SQL data type                        |
      | nullable            | whether null is allowed              |
      | primary_key         | whether part of primary key          |
      | foreign_key         | FK reference if applicable           |
    And I should see data lineage links for each table

  Scenario: Create new schema with all required metadata
    When I create schema with the following details:
      | field         | value                                 |
      | name          | analytics_v2                          |
      | database      | analytics                             |
      | owner         | data-team                             |
      | description   | New analytics layer with v2 metrics   |
      | access_roles  | analyst, data-engineer, admin         |
    Then schema "analytics_v2" should be created in database "analytics"
    And owner should be set to "data-team"
    And the following permissions should be set:
      | role          | permission  |
      | analyst       | SELECT      |
      | data-engineer | ALL         |
      | admin         | ALL         |
    And a SchemaCreated domain event should be published with:
      | field         | value                 |
      | schema_name   | analytics_v2          |
      | database      | analytics             |
      | created_by    | current_user_id       |
      | timestamp     | current_timestamp     |
    And the schema should appear in the catalog within 5 seconds

  Scenario: Modify table schema with column addition
    Given table "user_events" exists in schema "raw.events"
    And table "user_events" has 1,000,000 rows
    When I add column with the following details:
      | field         | value                 |
      | column_name   | session_duration      |
      | data_type     | INTEGER               |
      | nullable      | true                  |
      | default_value | 0                     |
      | comment       | Duration in seconds   |
    Then column "session_duration" should be added to "user_events"
    And existing data should be preserved with null/default values
    And dependent views should be identified:
      | view_name              | impact        |
      | user_events_summary    | none          |
      | session_analytics      | needs_update  |
    And I should be prompted to update affected views
    And a SchemaModified event should be published

  Scenario: Modify table schema with column type change
    Given table "transactions" exists with column "amount" of type "INTEGER"
    And the column "amount" has no precision-losing data
    When I change column "amount" type from INTEGER to DECIMAL(10,2)
    Then the column type should be changed
    And existing integer values should be converted to decimal
    And a preview of sample converted values should be shown
    And I should be warned about any potential precision issues

  Scenario: Schema migration management with versioning
    When I create schema migration with the following details:
      | field           | value                                    |
      | name            | add_user_metrics_table                   |
      | description     | Add new user_metrics aggregate table     |
      | target_schema   | analytics                                |
      | operations      | CREATE TABLE, CREATE INDEX               |
    Then migration "add_user_metrics_table" should be created
    And migration should be assigned version "V20241229_001"
    And migration file should be stored in version control
    And I should be able to preview the migration SQL
    And a rollback script should be automatically generated
    And the migration should appear in pending migrations list

  Scenario: Apply schema migration to production with safety checks
    Given migration "V20241229_001_add_user_metrics_table" exists
    And migration has been tested in staging environment
    And migration is marked as "approved"
    When I apply migration to production
    Then a pre-migration backup should be created
    And changes should be applied atomically in a transaction
    And migration should be recorded in schema_migrations table with:
      | field           | value                           |
      | version         | V20241229_001                   |
      | name            | add_user_metrics_table          |
      | applied_at      | current_timestamp               |
      | applied_by      | current_user                    |
      | execution_time  | recorded_in_ms                  |
    And a SchemaMigrated domain event should be published
    And dependent ETL pipelines should be notified

  Scenario: Rollback schema migration
    Given migration "V20241229_001" has been applied
    And no dependent migrations exist
    When I rollback migration "V20241229_001"
    Then the rollback script should be executed
    And the migration should be removed from schema_migrations table
    And a SchemaMigrationRolledBack event should be published
    And affected tables should be restored to previous state

  Scenario: View schema change history with full audit trail
    When I view schema history for table "user_events"
    Then I should see all historical changes in chronological order:
      | version       | change_type   | change_description        | applied_by    | applied_at          |
      | V20241001_001 | CREATE        | Initial table creation    | system        | 2024-10-01 10:00:00 |
      | V20241015_002 | ALTER         | Added user_id index       | john.doe      | 2024-10-15 14:30:00 |
      | V20241101_003 | ALTER         | Added session_duration    | jane.smith    | 2024-11-01 09:15:00 |
    And I should be able to view the full SQL for each change
    And I should be able to compare schemas between versions

  Scenario Outline: Prevent invalid schema names
    When I attempt to create schema with name "<invalid_name>"
    Then the request should be rejected with error "<error_message>"

    Examples:
      | invalid_name    | error_message                              |
      | 123_schema      | Schema name cannot start with a number     |
      | schema-name     | Schema name cannot contain hyphens         |
      | drop table;--   | Schema name contains invalid characters    |
      |                 | Schema name cannot be empty                |
      | analytics       | Schema 'analytics' already exists          |

  # ============================================
  # ETL PROCESSES
  # ============================================

  Scenario: View ETL pipeline catalog with status
    When I view ETL pipelines
    Then I should see all configured pipelines with:
      | pipeline_name         | source              | destination              | schedule      | last_run_status | last_run_time       | rows_processed |
      | user_events_daily     | raw.user_events     | analytics.user_metrics   | 0 2 * * *     | success         | 2024-12-29 02:00:00 | 1,500,000      |
      | revenue_hourly        | raw.transactions    | analytics.revenue        | 0 * * * *     | success         | 2024-12-29 09:00:00 | 45,000         |
      | player_stats_realtime | raw.game_stats      | analytics.player_stats   | */5 * * * *   | running         | 2024-12-29 09:25:00 | 12,000         |
    And I should be able to filter pipelines by status, schedule, or source/destination

  Scenario: Create ETL pipeline with full configuration
    When I create ETL pipeline with the following details:
      | field               | value                           |
      | name                | user_events_daily               |
      | source_table        | raw.user_events                 |
      | destination_table   | analytics.user_metrics          |
      | schedule            | 0 2 * * *                       |
      | timezone            | America/New_York                |
      | incremental_column  | event_timestamp                 |
      | batch_size          | 10000                           |
      | parallelism         | 4                               |
      | retry_on_failure    | true                            |
      | alert_on_failure    | data-team@company.com           |
    And I configure the following transformations:
      | step | type      | config                                          |
      | 1    | filter    | event_type IN ('click', 'view', 'purchase')     |
      | 2    | dedupe    | DISTINCT ON (user_id, event_id)                 |
      | 3    | aggregate | GROUP BY user_id, DATE(event_timestamp)         |
      | 4    | enrich    | LEFT JOIN dim_users ON user_id                  |
    Then pipeline "user_events_daily" should be created
    And pipeline should be scheduled according to cron expression
    And an ETLPipelineCreated domain event should be published with:
      | field           | value                     |
      | pipeline_id     | generated_uuid            |
      | pipeline_name   | user_events_daily         |
      | created_by      | current_user_id           |
      | schedule        | 0 2 * * *                 |
    And pipeline should appear in the pipeline catalog

  Scenario: Configure complex ETL transformations with validation
    Given pipeline "user_events_daily" exists
    When I configure transformations:
      | step | type        | config                                    | expected_impact     |
      | 1    | filter      | status = 'active' AND event_type != null  | reduces rows ~30%   |
      | 2    | aggregate   | group by user_id, date                    | aggregates by day   |
      | 3    | enrich      | join with dim_users on user_id            | adds user attributes|
      | 4    | calculate   | add column: session_score = duration * 10 | adds computed column|
    Then transformations should be validated for:
      | validation_type     | result  |
      | syntax_check        | passed  |
      | column_references   | passed  |
      | join_cardinality    | warning |
    And a preview with 100 sample rows should show expected output
    And estimated row counts after each step should be displayed

  Scenario: Run ETL pipeline manually with progress tracking
    Given pipeline "user_events_daily" exists and is not currently running
    When I trigger manual run of "user_events_daily"
    Then pipeline should start execution immediately
    And execution should be assigned a unique run_id
    And I should see real-time progress showing:
      | metric              | value                       |
      | current_stage       | 2 of 4                      |
      | stage_name          | Aggregation                 |
      | rows_read           | 1,200,000                   |
      | rows_written        | 450,000                     |
      | elapsed_time        | 2m 34s                      |
      | estimated_remaining | 1m 45s                      |
    And upon completion I should see:
      | metric              | value                       |
      | status              | SUCCESS                     |
      | total_rows_read     | 1,500,000                   |
      | total_rows_written  | 500,000                     |
      | execution_time      | 4m 19s                      |
    And an ETLCompleted event should be published

  Scenario: Monitor ETL pipeline execution with detailed stages
    Given pipeline "user_events_daily" is running with run_id "run-12345"
    When I view execution details for run "run-12345"
    Then I should see stage-by-stage breakdown:
      | stage_num | stage_name   | status    | rows_in   | rows_out  | duration | error_count |
      | 1         | Extract      | completed | 1,500,000 | 1,500,000 | 1m 20s   | 0           |
      | 2         | Filter       | completed | 1,500,000 | 1,050,000 | 0m 45s   | 0           |
      | 3         | Aggregate    | running   | 1,050,000 | 350,000   | ongoing  | 0           |
      | 4         | Load         | pending   | -         | -         | -        | -           |
    And I should see resource utilization during execution:
      | resource    | current | peak   |
      | CPU         | 65%     | 82%    |
      | Memory      | 4.2GB   | 5.1GB  |
      | Disk I/O    | 120MB/s | 180MB/s|

  Scenario: Handle ETL pipeline failure with recovery options
    Given pipeline "user_events_daily" fails during "Aggregate" stage
    And 350,000 of 1,050,000 rows were processed before failure
    When I view failure details
    Then I should see error information:
      | field              | value                                    |
      | error_type         | OutOfMemoryError                         |
      | error_message      | Java heap space exceeded during groupBy  |
      | failed_stage       | Aggregate (3 of 4)                       |
      | rows_processed     | 350,000 of 1,050,000                     |
      | stack_trace        | available for download                   |
    And I should see recovery options:
      | option                  | description                                |
      | Retry from failure      | Resume from row 350,001 in Aggregate stage |
      | Retry from beginning    | Start fresh with new extraction            |
      | Skip failed rows        | Continue with successfully processed rows  |
    And an ETLFailed event should be published with failure details

  Scenario: Retry failed ETL pipeline from failure point
    Given pipeline "user_events_daily" failed at row 350,000 in Aggregate stage
    And checkpoint data is available
    When I retry from failure point
    Then pipeline should resume from row 350,001
    And previously processed rows should not be re-processed
    And upon successful completion all data should be consistent
    And the run should be marked as "RECOVERED"

  Scenario: Configure ETL error handling policies
    When I configure error handling for pipeline "user_events_daily":
      | setting                 | value                   |
      | retry_attempts          | 3                       |
      | retry_delay             | 5 minutes               |
      | retry_backoff           | exponential             |
      | max_retry_delay         | 30 minutes              |
      | dead_letter_table       | raw.error_records       |
      | alert_on_failure        | data-team@company.com   |
      | alert_on_retry          | false                   |
      | max_error_percentage    | 1%                      |
      | fail_on_error_threshold | true                    |
    Then error handling settings should be saved
    And subsequent pipeline runs should:
      | behavior                                                    |
      | Retry up to 3 times on transient failures                   |
      | Send failed records to raw.error_records table              |
      | Alert data-team@company.com on pipeline failure             |
      | Fail pipeline if >1% of records encounter errors            |

  Scenario: ETL pipeline schedule management
    Given pipeline "revenue_hourly" has schedule "0 * * * *"
    When I update the schedule to "*/30 * * * *"
    Then the pipeline schedule should be updated
    And next scheduled run should reflect the new schedule
    And an ETLScheduleUpdated event should be published

  Scenario Outline: Validate ETL pipeline schedule expressions
    When I set pipeline schedule to "<cron_expression>"
    Then the schedule should be "<validation_result>"
    And next run time should be "<next_run>"

    Examples:
      | cron_expression | validation_result | next_run                    |
      | 0 2 * * *       | valid             | Tomorrow at 2:00 AM         |
      | */15 * * * *    | valid             | In 15 minutes or less       |
      | 0 0 1 * *       | valid             | First of next month         |
      | invalid         | invalid           | Error: Invalid cron syntax  |
      | * * * * * *     | invalid           | Error: Too many fields      |

  # ============================================
  # DATA PIPELINE ORCHESTRATION
  # ============================================

  Scenario: View pipeline dependency graph (DAG)
    When I view pipeline orchestration
    Then I should see a directed acyclic graph (DAG) showing:
      | pipeline               | depends_on                        | triggers            |
      | raw_data_ingest        | []                                | staging_transform   |
      | staging_transform      | [raw_data_ingest]                 | analytics_daily     |
      | user_events_daily      | [raw_data_ingest]                 | analytics_summary   |
      | revenue_daily          | [raw_data_ingest]                 | analytics_summary   |
      | analytics_summary      | [user_events_daily, revenue_daily]| []                  |
    And I should be able to visualize the execution order
    And critical path should be highlighted
    And estimated total execution time should be displayed

  Scenario: Configure pipeline dependencies with validation
    Given pipeline "analytics_summary" exists
    When I set pipeline "analytics_summary" to depend on:
      | pipeline            |
      | user_events_daily   |
      | revenue_daily       |
    Then dependencies should be validated:
      | validation              | result  |
      | no_circular_dependency  | passed  |
      | all_pipelines_exist     | passed  |
      | compatible_schedules    | warning |
    And dependencies should be enforced at runtime
    And "analytics_summary" should only run after both dependencies complete
    And a DependencyConfigured event should be published

  Scenario: Prevent circular pipeline dependencies
    Given pipeline "A" depends on pipeline "B"
    And pipeline "B" depends on pipeline "C"
    When I attempt to set pipeline "C" to depend on pipeline "A"
    Then the request should be rejected with error "CIRCULAR_DEPENDENCY_DETECTED"
    And the error should show the cycle: "C -> A -> B -> C"

  Scenario: Pause all pipeline orchestration for maintenance
    Given 3 pipelines are currently running
    And 5 pipelines are scheduled to run in the next hour
    When I pause all pipelines for maintenance with reason "Database maintenance"
    Then running jobs should be allowed to complete
    And no new executions should start
    And scheduled runs should be queued with original scheduled time
    And I should see maintenance mode indicator on dashboard
    And a MaintenanceModeEnabled event should be published

  Scenario: Resume pipeline orchestration after maintenance
    Given pipeline orchestration is paused
    And 5 pipeline runs are queued
    When I resume pipeline orchestration
    Then queued jobs should start executing in priority order
    And normal schedule should resume for future runs
    And maintenance mode indicator should be removed
    And a MaintenanceModeDisabled event should be published

  Scenario: Handle cascade failure in pipeline dependencies
    Given pipeline "user_events_daily" triggers "analytics_summary"
    When "user_events_daily" fails
    Then "analytics_summary" should not be triggered
    And "analytics_summary" should be marked as "BLOCKED"
    And blocked reason should show "Upstream dependency failed: user_events_daily"
    And alerts should be sent for both failed and blocked pipelines

  # ============================================
  # DATA QUALITY MONITORING
  # ============================================

  Scenario: Configure comprehensive data quality rules
    When I create data quality rules for table "user_events":
      | rule_name        | rule_type   | condition                         | severity | auto_quarantine |
      | null_user_check  | null_check  | user_id IS NOT NULL               | critical | true            |
      | age_range        | range_check | age BETWEEN 0 AND 150             | warning  | false           |
      | event_unique     | uniqueness  | event_id is unique                | critical | true            |
      | data_freshness   | freshness   | max_age < 24 hours                | warning  | false           |
      | email_format     | pattern     | email LIKE '%@%.%'                | warning  | false           |
      | referential      | foreign_key | user_id EXISTS IN dim_users       | error    | true            |
    Then rules should be saved and activated
    And validation should run automatically on each data load
    And rules should be versioned for audit trail

  Scenario: View data quality dashboard with scores
    When I view data quality dashboard
    Then I should see quality score summary:
      | table            | overall_score | critical_issues | warnings | last_checked        |
      | user_events      | 98.5%         | 0               | 12       | 2024-12-29 09:30:00 |
      | transactions     | 99.2%         | 0               | 3        | 2024-12-29 09:30:00 |
      | player_stats     | 95.8%         | 2               | 45       | 2024-12-29 09:25:00 |
    And I should see quality trends over time (30-day history)
    And I should see most frequent violation types
    And I should be able to drill down into specific violations

  Scenario: Handle critical data quality violation with quarantine
    Given data quality rule "null_user_check" is configured as critical
    And auto_quarantine is enabled for this rule
    When new data load contains 50 records with null user_id
    Then violation should be detected during load
    And I should receive immediate alert
    And 50 violating records should be quarantined to "quarantine.user_events"
    And remaining valid records should be loaded successfully
    And a DataQualityViolation domain event should be published with:
      | field           | value                    |
      | table           | user_events              |
      | rule_name       | null_user_check          |
      | violation_count | 50                       |
      | severity        | critical                 |
      | action_taken    | quarantined              |
    And quarantine table should include:
      | field               | value                |
      | original_record     | full record data     |
      | violation_rule      | null_user_check      |
      | quarantine_time     | current_timestamp    |
      | source_load_id      | load batch id        |

  Scenario: Review and remediate quarantined records
    Given 50 records are quarantined for "null_user_check" violation
    When I view quarantined records
    Then I should see all 50 records with violation details
    And I should have remediation options:
      | action              | description                               |
      | Fix and reload      | Edit records and reload to source table   |
      | Delete permanently  | Remove records from quarantine            |
      | Override and load   | Load records ignoring quality rule        |
    When I fix the null user_id values and reload
    Then records should pass quality check
    And records should be loaded to main table
    And quarantine should be cleared for those records

  Scenario: Run comprehensive data profiling
    When I run data profiling on table "user_events"
    Then I should see column-level statistics:
      | column            | data_type | null_count | unique_count | min_value | max_value | avg_value |
      | user_id           | VARCHAR   | 0          | 500,000      | U0001     | U999999   | N/A       |
      | age               | INTEGER   | 1,200      | 120          | 13        | 98        | 34.5      |
      | event_timestamp   | TIMESTAMP | 0          | 1,450,000    | 2024-01-01| 2024-12-29| N/A       |
      | session_duration  | INTEGER   | 50,000     | 3,600        | 1         | 7200      | 245.3     |
    And I should see data distribution histograms for numeric columns
    And I should see value frequency analysis for categorical columns
    And I should see anomaly detection results:
      | column           | anomaly_type     | description                    | confidence |
      | session_duration | outlier          | 15 values > 3 std dev from mean| 95%        |
      | age              | unusual_pattern  | Spike in age=99                | 87%        |

  Scenario: Configure anomaly detection thresholds
    When I configure anomaly detection for "user_events.session_duration":
      | setting                  | value      |
      | method                   | z_score    |
      | threshold                | 3.0        |
      | min_sample_size          | 1000       |
      | alert_on_anomaly         | true       |
      | block_anomalous_records  | false      |
    Then anomaly detection should run on each data load
    And anomalies exceeding threshold should trigger alerts
    And anomaly history should be tracked for trend analysis

  # ============================================
  # QUERY OPTIMIZATION
  # ============================================

  Scenario: View query performance dashboard
    When I view query performance dashboard
    Then I should see slowest queries in last 24 hours:
      | query_id    | query_pattern                     | avg_time | executions | user        |
      | Q-12345     | SELECT * FROM user_events WHERE...| 45.2s    | 12         | analyst-1   |
      | Q-12346     | SELECT COUNT(*) FROM transactions | 32.1s    | 45         | report-svc  |
      | Q-12347     | JOIN user_events WITH player_stats| 28.5s    | 8          | analyst-2   |
    And I should see query pattern analysis:
      | pattern_type    | count | avg_time | optimization_opportunity |
      | Full table scan | 23    | 15.2s    | Add index                |
      | Cross join      | 5     | 42.3s    | Review join conditions   |
      | SELECT *        | 45    | 8.5s     | Select specific columns  |
    And I should see resource consumption by query type

  Scenario: Analyze slow query with execution plan
    Given query "Q-12345" has average execution time of 45.2 seconds
    When I analyze query execution plan for "Q-12345"
    Then I should see execution stages:
      | stage          | operation         | rows_scanned | cost   | bottleneck |
      | 1              | Table Scan        | 50,000,000   | 85000  | yes        |
      | 2              | Filter            | 1,200,000    | 2400   | no         |
      | 3              | Sort              | 1,200,000    | 15000  | partial    |
      | 4              | Limit             | 100          | 1      | no         |
    And I should see bottleneck identification: "Full table scan on user_events"
    And I should see optimization suggestions:
      | suggestion                                        | estimated_improvement |
      | Create index on (user_id, event_timestamp)        | 90% reduction         |
      | Add WHERE clause to filter by partition           | 75% reduction         |
      | Consider materialized view for frequent pattern   | 95% reduction         |

  Scenario: Create materialized view for query optimization
    When I create materialized view with the following configuration:
      | field           | value                                           |
      | name            | mv_daily_user_summary                           |
      | source_query    | SELECT date, user_id, COUNT(*), SUM(duration)   |
      |                 | FROM user_events GROUP BY date, user_id         |
      | refresh_type    | incremental                                     |
      | refresh_schedule| every 1 hour                                    |
      | cluster_by      | date, user_id                                   |
    Then materialized view should be created
    And initial data should be populated
    And it should refresh on schedule
    And query optimizer should automatically use this view when appropriate
    And a MaterializedViewCreated event should be published

  Scenario: Configure and verify table partitioning
    When I configure partitioning for table "events":
      | setting           | value        |
      | partition_column  | event_date   |
      | partition_type    | daily        |
      | retention_days    | 90           |
      | auto_create       | true         |
    Then table should be partitioned by event_date
    And existing data should be redistributed to partitions
    And partitions older than 90 days should be automatically dropped
    And I should see partition statistics:
      | partition_date | row_count  | size_mb | status  |
      | 2024-12-29     | 1,500,000  | 450     | active  |
      | 2024-12-28     | 1,480,000  | 442     | active  |
      | 2024-09-30     | 1,200,000  | 380     | pending_drop |
    And a TablePartitioned event should be published

  Scenario: Optimize table clustering for query performance
    Given table "user_events" is frequently queried by user_id and event_date
    When I cluster table "user_events" by columns:
      | column       | order |
      | user_id      | 1     |
      | event_date   | 2     |
    Then data should be reorganized by cluster keys
    And clustering operation should run in background
    And I should see before/after metrics:
      | metric                    | before    | after     | improvement |
      | avg_query_time            | 12.5s     | 1.8s      | 85%         |
      | bytes_scanned_per_query   | 15GB      | 2.1GB     | 86%         |
    And a TableClustered event should be published

  Scenario: Configure query result caching
    When I configure query cache with the following settings:
      | setting               | value           |
      | cache_size            | 10GB            |
      | default_ttl           | 1 hour          |
      | max_result_size       | 100MB           |
      | invalidation_policy   | on_source_update|
      | exclude_patterns      | SELECT * FROM raw.* |
    Then caching should be enabled with specified settings
    And cache metrics should be tracked:
      | metric              | display     |
      | cache_hit_rate      | percentage  |
      | cache_size_used     | GB          |
      | entries_count       | integer     |
      | avg_time_saved      | seconds     |
    And cache should be automatically invalidated when source tables change

  # ============================================
  # DATA RETENTION
  # ============================================

  Scenario: Configure comprehensive data retention policies
    When I create data retention policy:
      | table          | hot_retention | warm_tier | warm_retention | cold_tier | delete_after |
      | raw_events     | 30 days       | S3        | 90 days        | Glacier   | 3 years      |
      | analytics      | 1 year        | S3        | 3 years        | Glacier   | 7 years      |
      | user_data      | indefinite    | none      | N/A            | none      | on_request   |
      | temp_staging   | 7 days        | none      | N/A            | none      | 7 days       |
    Then policies should be saved and scheduled for enforcement
    And data lifecycle jobs should be created for each policy
    And compliance requirements should be validated
    And a RetentionPolicyCreated event should be published

  Scenario: View data lifecycle dashboard
    When I view data lifecycle dashboard
    Then I should see data distribution by age:
      | age_bucket    | data_size | table_count | tier    |
      | < 30 days     | 2.5 TB    | 15          | hot     |
      | 30-90 days    | 4.2 TB    | 12          | warm    |
      | 90-365 days   | 8.1 TB    | 10          | cold    |
      | > 365 days    | 12.3 TB   | 8           | archive |
    And I should see upcoming data movements:
      | action    | table        | data_size | scheduled_date |
      | archive   | raw_events   | 450 GB    | 2024-12-30     |
      | delete    | temp_staging | 25 GB     | 2024-12-30     |
    And I should see storage costs by tier:
      | tier      | monthly_cost | data_size |
      | hot       | $2,500       | 2.5 TB    |
      | warm      | $420         | 4.2 TB    |
      | cold      | $81          | 8.1 TB    |
      | archive   | $12.30       | 12.3 TB   |

  Scenario: Execute scheduled data archival
    Given retention policy specifies raw_events older than 30 days should be archived
    And 500 GB of data is older than 30 days
    When archival job runs for "raw_events"
    Then data older than 30 days should be:
      | action           | detail                                    |
      | Compressed       | Using GZIP with 60% compression ratio     |
      | Transferred      | Moved to S3 bucket ffl-archive            |
      | Cataloged        | Metadata stored for query federation      |
      | Removed          | Deleted from warehouse hot storage        |
    And warehouse storage should decrease by ~500 GB
    And archived data should remain queryable via external tables
    And a DataArchived event should be published

  Scenario: Restore archived data for analysis
    Given data for "2024-01" is archived in S3/Glacier
    When I request restore of data for date range "2024-01-01" to "2024-01-31"
    Then restore job should be initiated
    And I should see restore progress:
      | stage              | status    | estimated_time |
      | Glacier retrieval  | completed | N/A            |
      | S3 staging         | completed | N/A            |
      | Loading to DW      | running   | 25 minutes     |
    And upon completion data should be available for queries
    And restored data should follow temporary retention (e.g., 7 days)
    And a DataRestored event should be published

  Scenario: Handle GDPR data deletion request
    Given user with id "U12345" requests data deletion
    And user data exists in tables: user_events, transactions, user_profiles
    When I process GDPR deletion request for user "U12345"
    Then all user data should be identified across all tables:
      | table         | records_found |
      | user_events   | 15,234        |
      | transactions  | 523           |
      | user_profiles | 1             |
    And all identified records should be permanently deleted
    And archived data should also be deleted
    And deletion should be logged for compliance audit
    And a GDPRDeletionCompleted event should be published

  # ============================================
  # WAREHOUSE ANALYTICS
  # ============================================

  Scenario: View comprehensive warehouse usage analytics
    When I view warehouse analytics
    Then I should see query volume trends:
      | period      | queries | avg_time | peak_time         |
      | Last 24h    | 45,230  | 2.3s     | 09:00-10:00       |
      | Last 7d     | 312,450 | 2.1s     | Tuesday 14:00     |
      | Last 30d    | 1.2M    | 2.4s     | Month-end periods |
    And I should see storage growth:
      | period      | growth    | projected_30d |
      | Last 7d     | +125 GB   | +540 GB       |
      | Last 30d    | +520 GB   | +520 GB       |
    And I should see user activity:
      | user_type    | query_count | avg_queries_per_day |
      | analysts     | 25,000      | 3,571               |
      | services     | 18,000      | 2,571               |
      | dashboards   | 2,230       | 318                 |

  Scenario: View cost analysis breakdown
    When I view cost analysis
    Then I should see compute costs:
      | period      | cost       | trend    |
      | Last 7d     | $12,450    | +5%      |
      | Last 30d    | $48,200    | +12%     |
    And I should see storage costs:
      | tier        | cost       | data_size |
      | Hot         | $2,500/mo  | 2.5 TB    |
      | Warm        | $420/mo    | 4.2 TB    |
      | Cold        | $93/mo     | 20.4 TB   |
    And I should see cost allocation by team:
      | team          | compute   | storage  | total    |
      | analytics     | $8,200    | $1,800   | $10,000  |
      | data-eng      | $3,100    | $800     | $3,900   |
      | reporting     | $1,150    | $413     | $1,563   |

  Scenario: Generate capacity planning forecast
    When I run capacity forecast with 12-month horizon
    Then I should see projected storage needs:
      | month       | projected_size | confidence |
      | +3 months   | 35 TB          | 95%        |
      | +6 months   | 48 TB          | 85%        |
      | +12 months  | 72 TB          | 70%        |
    And I should see projected compute needs:
      | month       | projected_vcpu_hours | confidence |
      | +3 months   | 45,000               | 90%        |
      | +6 months   | 62,000               | 80%        |
      | +12 months  | 95,000               | 65%        |
    And I should see budget implications:
      | period      | projected_cost | current_budget | variance   |
      | +3 months   | $52,000/mo     | $50,000/mo     | +4%        |
      | +6 months   | $68,000/mo     | $50,000/mo     | +36%       |
    And recommendations should be provided for cost optimization

  # ============================================
  # ACCESS CONTROL
  # ============================================

  Scenario: Configure team-based warehouse access
    When I configure access for team "analytics":
      | database   | schema    | permission    |
      | raw        | *         | SELECT        |
      | staging    | *         | SELECT        |
      | analytics  | public    | SELECT, INSERT, UPDATE, DELETE |
      | analytics  | internal  | SELECT        |
      | reports    | *         | SELECT        |
    Then permissions should be applied to all team members
    And access should be audited in access_logs table
    And a TeamAccessConfigured event should be published

  Scenario: Configure row-level security for multi-tenant data
    Given table "customer_data" contains data for multiple regions
    When I configure row-level security on "customer_data":
      | policy_name    | filter_expression              |
      | region_filter  | region = current_user_region() |
    Then users should only see data for their assigned region
    And policy should be enforced on all queries including joins
    And EXPLAIN plan should show policy application
    And super admins should be able to bypass policy when needed

  Scenario: Audit access control changes
    When I modify access permissions for team "analytics"
    Then an audit log entry should be created with:
      | field              | value                      |
      | action             | ACCESS_MODIFIED            |
      | actor              | current_user_id            |
      | target_team        | analytics                  |
      | changes            | detailed permission diff   |
      | timestamp          | current_timestamp          |
    And audit log should be immutable
    And audit retention should be 7 years for compliance

  Scenario Outline: Access control validation for sensitive operations
    Given I am a user with role "<role>"
    When I attempt to "<operation>" on "<resource>"
    Then the operation should be "<result>"
    And access attempt should be logged

    Examples:
      | role          | operation           | resource            | result    |
      | admin         | DROP TABLE          | analytics.users     | allowed   |
      | analyst       | DROP TABLE          | analytics.users     | denied    |
      | analyst       | SELECT              | analytics.users     | allowed   |
      | analyst       | SELECT              | raw.sensitive_data  | denied    |
      | data-engineer | CREATE TABLE        | staging.temp        | allowed   |
      | viewer        | CREATE TABLE        | staging.temp        | denied    |

  # ============================================
  # DATA LINEAGE
  # ============================================

  Scenario: View comprehensive data lineage
    When I view lineage for table "daily_revenue"
    Then I should see upstream lineage (sources):
      | source_table          | transformation_type | relationship |
      | raw.transactions      | ETL                 | direct       |
      | raw.refunds           | ETL                 | direct       |
      | dim.products          | JOIN                | enrichment   |
      | dim.regions           | JOIN                | enrichment   |
    And I should see transformation steps:
      | step | operation        | description                    |
      | 1    | FILTER           | Remove test transactions       |
      | 2    | AGGREGATE        | Sum by date and product        |
      | 3    | JOIN             | Enrich with product details    |
      | 4    | CALCULATE        | Compute net_revenue            |
    And I should see downstream dependencies:
      | dependent_table       | dependency_type |
      | reports.executive_summary | VIEW          |
      | analytics.kpi_metrics    | ETL            |
      | ml.revenue_forecast      | MODEL_INPUT    |
    And lineage should be visualized as an interactive graph

  Scenario: Impact analysis for schema changes
    Given table "user_events" has downstream dependencies
    When I analyze impact of adding column "device_type" to "user_events"
    Then I should see affected objects:
      | object_type   | object_name              | impact_level | action_required           |
      | ETL Pipeline  | user_events_daily        | none         | Column will be propagated |
      | View          | user_events_summary      | low          | No change needed          |
      | Report        | user_analytics_dashboard | medium       | May want to add new chart |
      | ML Model      | user_segmentation        | high         | Feature engineering update|
    And I should see recommended actions for each affected object
    And a what-if simulation should be available

  Scenario: Track data lineage across ETL execution
    Given ETL pipeline "user_events_daily" runs
    When the pipeline completes successfully
    Then lineage should be automatically updated with:
      | field                  | value                         |
      | source_snapshot        | commit hash or timestamp      |
      | transformation_version | pipeline version              |
      | execution_id           | run_id                        |
      | row_counts             | input/output row counts       |
    And lineage metadata should be queryable
    And historical lineage should be preserved for audit

  # ============================================
  # DOMAIN EVENTS
  # ============================================

  Scenario: ETLCompleted event triggers downstream processes
    Given pipeline "user_events_daily" completes successfully
    When ETLCompleted event is published
    Then dependent pipelines should receive notification:
      | pipeline           | action                    |
      | analytics_summary  | Triggered for execution   |
      | user_kpis         | Queued pending other deps |
    And dashboard "User Analytics" should refresh
    And data freshness indicators should update
    And monitoring systems should log completion

  Scenario: DataQualityViolation event triggers alerting
    When DataQualityViolation event is published with severity "critical"
    Then the following actions should occur:
      | action                  | target                     |
      | Email alert             | data-team@company.com      |
      | Slack notification      | #data-alerts channel       |
      | PagerDuty incident      | On-call data engineer      |
      | Dashboard update        | Data Quality dashboard     |
    And incident ticket should be created if configured
    And event should be logged for analysis

  Scenario: SchemaChanged event triggers validation
    When SchemaChanged event is published for table "user_events"
    Then downstream objects should be validated:
      | object_type   | validation              |
      | Views         | Check for broken refs   |
      | ETL Pipelines | Validate column mapping |
      | Reports       | Flag for review         |
    And any issues should be reported via alerts
    And lineage should be updated

  # ============================================
  # ERROR SCENARIOS
  # ============================================

  Scenario: Handle warehouse connection failure gracefully
    Given warehouse cluster is unreachable due to network issue
    When I attempt to access the warehouse dashboard
    Then I should see error message "Data warehouse is temporarily unavailable"
    And I should see:
      | information           | value                           |
      | last_known_status     | Healthy at 09:25:00             |
      | estimated_recovery    | Automatic retry in 30 seconds   |
      | support_contact       | data-platform@company.com       |
    And operations should be queued for retry
    And a WarehouseUnavailable event should be published
    And monitoring should be alerted

  Scenario: Handle ETL job timeout with cleanup
    Given ETL job "large_data_migration" has timeout of 4 hours
    And the job has been running for 4 hours
    When timeout occurs
    Then job should be terminated gracefully
    And partial data should be rolled back to maintain consistency
    And temporary tables should be cleaned up
    And alert should be sent with:
      | field           | value                              |
      | job_name        | large_data_migration               |
      | failure_reason  | Timeout exceeded (4h limit)        |
      | rows_processed  | 45,000,000 of estimated 100,000,000|
      | recommendation  | Increase timeout or optimize job   |
    And an ETLTimeout event should be published

  Scenario: Handle storage quota exceeded with warnings
    Given warehouse storage is at 95% capacity (9.5 TB of 10 TB)
    When new data load attempts to write 600 GB
    Then I should see warning "Storage quota will be exceeded"
    And I should see recommendations:
      | recommendation                        | potential_savings |
      | Archive raw_events older than 30 days | 1.2 TB            |
      | Drop unused temp tables               | 300 GB            |
      | Increase compression on analytics     | 500 GB            |
    And admin should be alerted before quota is reached
    And a StorageWarning event should be published

  Scenario: Handle concurrent schema migration conflict
    Given migration "V001" is currently running on table "user_events"
    When another migration "V002" attempts to modify "user_events"
    Then the second migration should be blocked
    And error "CONCURRENT_MIGRATION_CONFLICT" should be returned
    And I should see the blocking migration details
    And V002 should be queued to run after V001 completes

  Scenario: Recover from failed data archival
    Given archival job for "raw_events" fails at 50% completion
    And 250 GB has been archived but 250 GB remains
    When I view the failed archival job
    Then I should see partial completion status
    And I should have recovery options:
      | option              | description                           |
      | Resume archival     | Continue from last checkpoint         |
      | Rollback            | Restore already-archived data to hot  |
      | Retry from start    | Re-run complete archival job          |
    And data consistency should be verified before any action
