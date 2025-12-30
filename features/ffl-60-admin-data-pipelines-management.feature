@admin @data-pipelines
Feature: Admin Data Pipelines Management
  As a platform administrator
  I want to manage data pipelines and ETL processes
  So that I can ensure reliable data processing and transformation workflows

  Background:
    Given I am logged in as a platform administrator
    And I have data pipeline management permissions

  # =============================================================================
  # PIPELINE DASHBOARD AND LISTING
  # =============================================================================

  @dashboard @overview
  Scenario: View data pipelines dashboard
    Given multiple data pipelines exist in the system
    When I navigate to the data pipelines dashboard
    Then I should see pipeline overview metrics:
      | Metric                | Description                      |
      | Total pipelines       | Total number of pipelines        |
      | Active pipelines      | Currently running pipelines      |
      | Failed pipelines      | Pipelines in failed state        |
      | Paused pipelines      | Temporarily paused pipelines     |
      | Success rate 24h      | Success rate over last 24 hours  |
      | Records processed     | Total records processed today    |
      | Average latency       | Average pipeline latency in ms   |
    And I should see pipeline status distribution chart
    And I should see recent pipeline activity feed
    And I should see pipelines requiring attention

  @dashboard @list
  Scenario: List all data pipelines
    Given the following pipelines exist:
      | Name              | Status   | Type          | Last Run           |
      | user_sync         | ACTIVE   | scheduled     | 2024-01-15 10:00   |
      | content_ingest    | RUNNING  | event_driven  | 2024-01-15 10:30   |
      | analytics_export  | PAUSED   | scheduled     | 2024-01-14 22:00   |
      | backup_pipeline   | FAILED   | scheduled     | 2024-01-15 02:00   |
    When I view the pipeline list
    Then I should see all 4 pipelines
    And each pipeline should display:
      | Field             | Description                      |
      | ID                | Unique pipeline identifier       |
      | Name              | Pipeline name                    |
      | Status            | Current status                   |
      | Type              | Scheduled/event_driven/manual    |
      | Source            | Data source configuration        |
      | Destination       | Data destination configuration   |
      | Last run          | Last execution timestamp         |
      | Next run          | Next scheduled execution         |
      | Success rate      | Historical success rate          |

  @dashboard @filter
  Scenario Outline: Filter pipelines by criteria
    Given multiple pipelines exist with various configurations
    When I filter pipelines by "<filter>" with value "<value>"
    Then all returned pipelines should match the filter criteria
    And I should see the filtered result count

    Examples:
      | filter      | value        |
      | status      | ACTIVE       |
      | status      | FAILED       |
      | status      | PAUSED       |
      | type        | scheduled    |
      | type        | event_driven |
      | source      | postgres     |
      | destination | s3           |

  @dashboard @search
  Scenario: Search pipelines by name
    Given pipelines with various names exist
    When I search for pipelines with "user" in the name
    Then results should include pipelines with "user" in the name
    And search should be case-insensitive
    And I should be able to clear the search

  # =============================================================================
  # PIPELINE CREATION AND CONFIGURATION
  # =============================================================================

  @create @basic
  Scenario: Create new data pipeline
    Given I have valid source and destination configurations
    When I create a new pipeline with:
      | Field         | Value                                      |
      | Name          | user_activity_sync                         |
      | Description   | Syncs user activity to analytics warehouse |
      | Source type   | postgres                                   |
      | Destination   | bigquery                                   |
      | Schedule      | 0 */2 * * *                                |
      | Enabled       | true                                       |
    Then the pipeline should be created successfully
    And the pipeline should have a unique ID
    And the pipeline should be in INACTIVE status until first run
    And the creation should be logged in audit trail

  @create @validation @error
  Scenario Outline: Reject pipeline with invalid configuration
    When I attempt to create a pipeline with <invalid_config>
    Then the creation should be rejected
    And I should see error message "<error_message>"

    Examples:
      | invalid_config           | error_message                           |
      | missing name             | Pipeline name is required               |
      | duplicate name           | Pipeline name already exists            |
      | invalid source type      | Invalid source type specified           |
      | invalid cron expression  | Invalid schedule format                 |
      | invalid connection_id    | Connection not found                    |

  @configure @source
  Scenario: Configure pipeline source
    Given pipeline "user_sync" exists
    When I configure the pipeline source with:
      | Setting           | Value                              |
      | Type              | postgres                           |
      | Connection        | production-db                      |
      | Query             | SELECT id, name FROM users         |
      | Incremental       | true                               |
      | Watermark column  | updated_at                         |
      | Batch size        | 10000                              |
    Then the source configuration should be saved
    And the configuration should be validated
    And I should see the updated source settings

  @configure @destination
  Scenario: Configure pipeline destination
    Given pipeline "user_sync" exists
    When I configure the pipeline destination with:
      | Setting       | Value              |
      | Type          | s3                 |
      | Bucket        | data-lake-prod     |
      | Path          | raw/users/         |
      | Format        | parquet            |
      | Partition by  | year, month, day   |
      | Compression   | snappy             |
    Then the destination configuration should be saved
    And I should see the updated destination settings

  @configure @transformations
  Scenario: Configure pipeline transformations
    Given pipeline "user_sync" exists
    When I configure pipeline transformations with:
      | Step Type    | Configuration                     |
      | filter       | status = 'active'                 |
      | rename       | user_id -> id, user_name -> name  |
      | add_column   | processed_at = current_timestamp  |
      | hash         | email column with sha256          |
    Then the transformations should be validated
    And transformation order should be preserved
    And I should see the transformation pipeline preview

  @configure @mapping
  Scenario: Configure field mappings
    Given pipeline "user_sync" exists
    When I configure field mappings:
      | Source Field   | Destination Field | Transformation       |
      | user_id        | id                | none                 |
      | email_address  | email             | lowercase            |
      | created_date   | created_at        | to_timestamp         |
      | full_name      | name              | trim                 |
    Then the field mappings should be saved
    And I should see mapping validation results

  # =============================================================================
  # DATA QUALITY VALIDATION
  # =============================================================================

  @quality @rules
  Scenario: Configure data quality rules
    Given pipeline "user_sync" exists
    When I configure data quality rules:
      | Rule Name       | Type      | Column   | Severity | Configuration        |
      | email_not_null  | not_null  | email    | error    |                      |
      | email_format    | regex     | email    | error    | ^.+@.+\..{2,}$       |
      | age_range       | range     | age      | warning  | min=0, max=150       |
      | no_duplicates   | unique    | user_id  | error    |                      |
    And I set the error handling policy to "quarantine"
    Then the quality rules should be associated with the pipeline
    And I should see the rule configuration summary

  @quality @validation
  Scenario: Execute data quality validation during pipeline run
    Given pipeline "user_sync" has quality rules configured
    When the pipeline processes a batch of records
    Then each record should be validated against all rules
    And records failing "error" severity rules should be quarantined
    And records failing "warning" severity rules should be flagged but processed
    And validation results should be logged:
      | Metric              | Description                      |
      | Total records       | Total records processed          |
      | Valid records       | Records passing all rules        |
      | Quarantined records | Records failing error rules      |
      | Warning records     | Records with warnings            |
      | Validation time     | Time spent on validation         |

  @quality @schema
  Scenario: Validate schema compatibility
    Given pipeline "user_sync" has expected schema defined
    When source data schema changes unexpectedly
    Then the pipeline should detect schema drift
    And the system should:
      | Action           | Behavior                            |
      | Detect drift     | Identify new/removed/changed columns|
      | Alert admin      | Send schema drift notification      |
      | Pause option     | Option to pause on schema change    |
      | Log changes      | Record schema changes in audit log  |
    And I should see the schema comparison

  @quality @profiling
  Scenario: Run data profiling on pipeline source
    Given pipeline "user_sync" exists with configured source
    When I run data profiling on the source
    Then I should see profiling results:
      | Metric              | Description                      |
      | Row count           | Total number of rows             |
      | Column statistics   | Min, max, avg, distinct count    |
      | Null percentage     | Percentage of null values        |
      | Data types          | Detected data types              |
      | Pattern analysis    | Common patterns in text fields   |
    And I should be able to export profiling report

  # =============================================================================
  # PIPELINE MONITORING
  # =============================================================================

  @monitoring @history
  Scenario: View pipeline execution history
    Given pipeline "user_sync" has execution history
    When I view the execution history
    Then I should see execution records with:
      | Field             | Description                      |
      | Execution ID      | Unique execution identifier      |
      | Status            | SUCCESS/FAILED/RUNNING/CANCELLED |
      | Started at        | Execution start timestamp        |
      | Completed at      | Execution completion timestamp   |
      | Duration          | Execution duration in ms         |
      | Records read      | Records read from source         |
      | Records written   | Records written to destination   |
      | Records failed    | Records that failed processing   |
      | Error message     | Error details if failed          |
    And I should be able to filter by status and date range

  @monitoring @realtime
  Scenario: Monitor pipeline in real-time
    Given pipeline "user_sync" is currently running
    When I view the pipeline status
    Then I should see real-time metrics:
      | Metric                | Description                      |
      | Status                | RUNNING                          |
      | Progress percent      | Completion percentage            |
      | Records processed     | Records processed so far         |
      | Current stage         | Current transformation stage     |
      | Started at            | Start timestamp                  |
      | Estimated completion  | Estimated completion time        |
      | Throughput            | Records per second               |
    And metrics should update automatically
    And I should see a progress visualization

  @monitoring @logs
  Scenario: View pipeline execution logs
    Given pipeline execution "exec-456" exists
    When I view the execution logs
    Then I should see logs categorized by:
      | Log Type    | Description                      |
      | info        | General execution information    |
      | debug       | Detailed processing steps        |
      | warning     | Non-fatal issues encountered     |
      | error       | Errors and failures              |
    And logs should be sortable by timestamp
    And logs should be filterable by severity
    And I should be able to download logs

  @monitoring @metrics
  Scenario: View pipeline performance metrics
    Given pipeline "user_sync" has historical execution data
    When I view performance metrics for the last 7 days
    Then I should see:
      | Metric              | Description                      |
      | Average duration    | Average execution time           |
      | Average throughput  | Average records per second       |
      | Success rate        | Percentage of successful runs    |
      | Average records     | Average records per run          |
      | P95 duration        | 95th percentile duration         |
      | Total executions    | Total runs in period             |
    And I should see performance trend charts

  @monitoring @lineage
  Scenario: View data lineage
    Given pipeline "user_sync" processes data through multiple stages
    When I view the data lineage
    Then I should see:
      | Lineage Element     | Information                      |
      | Source systems      | Origin of data                   |
      | Transformations     | Processing steps applied         |
      | Destination systems | Where data flows to              |
      | Dependencies        | Related pipelines                |
    And I should see a visual lineage diagram
    And I should be able to trace data flow

  # =============================================================================
  # ERROR HANDLING AND RECOVERY
  # =============================================================================

  @error @retry
  Scenario: Configure automatic retry on failure
    Given pipeline "user_sync" exists
    When I configure retry policy:
      | Setting               | Value                            |
      | Enabled               | true                             |
      | Max attempts          | 3                                |
      | Initial delay         | 60 seconds                       |
      | Backoff multiplier    | 2                                |
      | Max delay             | 3600 seconds                     |
      | Retryable errors      | connection_timeout, rate_limit   |
    Then the retry policy should be saved
    And failed executions should retry according to policy

  @error @dlq
  Scenario: Configure dead letter queue for failed records
    Given pipeline "user_sync" exists
    When I configure dead letter queue:
      | Setting           | Value              |
      | Enabled           | true               |
      | Destination type  | s3                 |
      | Bucket            | pipeline-dlq       |
      | Path              | user_sync/         |
      | Retention days    | 30                 |
      | Alert threshold   | 100                |
    Then the DLQ should be configured
    And failed records should be routed to DLQ
    And alerts should trigger when threshold is exceeded

  @error @dlq-view
  Scenario: View failed records in dead letter queue
    Given pipeline "user_sync" has failed records in DLQ
    When I view the DLQ records
    Then I should see failed records with:
      | Field            | Description                      |
      | Record ID        | Original record identifier       |
      | Failure reason   | Why the record failed            |
      | Failed at        | Failure timestamp                |
      | Original data    | The failed record data           |
      | Retry count      | Number of retry attempts         |
    And I should be able to filter and search records

  @error @reprocess
  Scenario: Reprocess failed records from DLQ
    Given pipeline "user_sync" has 50 records in DLQ
    When I select records to reprocess
    Then selected records should be queued for reprocessing
    And successfully reprocessed records should be removed from DLQ
    And I should see reprocessing progress
    And I should see reprocessing results

  @error @manual-intervention
  Scenario: Manually intervene on stuck pipeline
    Given pipeline "user_sync" is stuck in RUNNING state for 2 hours
    When I force stop the pipeline
    Then the pipeline execution should be terminated
    And partial results should be preserved
    And I should be able to choose to rollback or commit partial data
    And the intervention should be logged

  @error @alerting
  Scenario: Configure pipeline failure alerts
    Given pipeline "user_sync" exists
    When I configure failure alerting:
      | Channel      | Recipients                       |
      | Email        | ops-team@example.com             |
      | Slack        | #pipeline-alerts                 |
      | PagerDuty    | ops-oncall                       |
    Then alerts should be configured
    And I should receive alerts on pipeline failure

  # =============================================================================
  # SCHEDULING
  # =============================================================================

  @schedule @cron
  Scenario: Configure cron-based schedule
    Given pipeline "user_sync" exists
    When I configure cron schedule:
      | Setting      | Value              |
      | Expression   | 0 0 * * *          |
      | Timezone     | America/New_York   |
      | Enabled      | true               |
    Then the schedule should be validated and saved
    And next run time should be calculated and displayed
    And I should see the schedule in human-readable format

  @schedule @event
  Scenario: Configure event-driven trigger
    Given pipeline "user_sync" exists
    When I configure event trigger:
      | Setting         | Value              |
      | Event source    | s3                 |
      | Event type      | object_created     |
      | Bucket filter   | incoming-data      |
      | Prefix filter   | uploads/           |
      | Debounce        | 60 seconds         |
    Then the event trigger should be configured
    And pipeline should run when matching events occur

  @schedule @manual
  Scenario: Manually trigger pipeline execution
    Given pipeline "user_sync" exists and is enabled
    When I manually trigger the pipeline with parameters:
      | Parameter    | Value              |
      | start_date   | 2024-01-01         |
      | end_date     | 2024-01-31         |
    Then the execution should be queued
    And I should receive an execution ID for tracking
    And I should see the execution in the running pipelines list

  @schedule @dependency
  Scenario: Configure pipeline dependencies
    Given pipelines "pipeline-A", "pipeline-B", and "pipeline-C" exist
    When I configure "pipeline-C" to depend on:
      | Pipeline    | Require Success |
      | pipeline-A  | true            |
      | pipeline-B  | true            |
    And I set dependency timeout to 120 minutes
    Then pipeline-C should only run after dependencies complete
    And I should see the dependency graph

  @schedule @dependency @error
  Scenario: Detect circular dependencies
    Given pipeline "pipeline-A" depends on "pipeline-B"
    And pipeline "pipeline-B" depends on "pipeline-C"
    When I attempt to make "pipeline-C" depend on "pipeline-A"
    Then the dependency should be rejected
    And I should see error "Circular dependency detected"
    And the dependency graph should remain unchanged

  @schedule @backfill
  Scenario: Schedule historical data backfill
    Given pipeline "user_sync" exists
    When I schedule a backfill:
      | Setting      | Value              |
      | Start date   | 2023-01-01         |
      | End date     | 2023-12-31         |
      | Parallelism  | 4                  |
      | Priority     | low                |
    Then the backfill should be scheduled
    And I should see backfill progress
    And backfill should not interfere with regular runs

  # =============================================================================
  # ADMIN CONTROLS
  # =============================================================================

  @control @pause
  Scenario: Pause pipeline
    Given pipeline "user_sync" is active and running on schedule
    When I pause the pipeline
    Then the pipeline status should change to PAUSED
    And scheduled runs should be suspended
    And currently running execution should complete
    And I should see the paused status indicator

  @control @resume
  Scenario: Resume paused pipeline
    Given pipeline "user_sync" is paused
    When I resume the pipeline
    Then the pipeline status should change to ACTIVE
    And scheduled runs should resume
    And I should see options for handling missed runs

  @control @disable
  Scenario: Disable pipeline
    Given pipeline "user_sync" exists
    When I disable the pipeline
    Then the pipeline should be disabled
    And no scheduled or event-triggered runs should occur
    And manual runs should be blocked
    And I should see the disabled status

  @control @delete
  Scenario: Delete pipeline
    Given pipeline "user_sync" is disabled
    When I delete the pipeline
    Then the pipeline should be soft-deleted
    And execution history should be retained for 90 days
    And configurations should be archived
    And I should not see the pipeline in active list

  @control @delete @error
  Scenario: Cannot delete active pipeline
    Given pipeline "user_sync" is active
    When I attempt to delete the pipeline
    Then the deletion should be rejected
    And I should see error "Cannot delete active pipeline. Disable first."

  @control @clone
  Scenario: Clone pipeline
    Given pipeline "user_sync" exists with full configuration
    When I clone the pipeline with name "user_sync_v2"
    Then a new pipeline should be created with same configuration
    And the new pipeline should be in INACTIVE status
    And I should be able to modify the cloned configuration

  # =============================================================================
  # VERSION MANAGEMENT
  # =============================================================================

  @version @create
  Scenario: Create new version of pipeline
    Given pipeline "user_sync" exists with version 1
    When I create a new version with configuration changes
    Then version 2 should be created
    And version 1 should remain unchanged and active
    And version 2 should be inactive until promoted

  @version @promote
  Scenario: Promote pipeline version
    Given pipeline "user_sync" has versions 1 (active) and 2 (inactive)
    When I promote version 2
    Then version 2 should become active
    And version 1 should be archived
    And next execution should use version 2

  @version @rollback
  Scenario: Rollback to previous version
    Given pipeline "user_sync" has version 2 active
    And version 1 is archived
    When I rollback to version 1
    Then version 1 should become active
    And the rollback should be logged for audit
    And I should see rollback confirmation

  @version @compare
  Scenario: Compare pipeline versions
    Given pipeline "user_sync" has multiple versions
    When I compare version 1 and version 2
    Then I should see differences highlighted:
      | Category         | Changes                          |
      | Source config    | Modified fields                  |
      | Destination      | Modified fields                  |
      | Transformations  | Added/removed/modified steps     |
      | Quality rules    | Rule changes                     |
      | Schedule         | Schedule changes                 |

  # =============================================================================
  # CONNECTIONS MANAGEMENT
  # =============================================================================

  @connections @create
  Scenario: Create data connection
    When I create a new connection:
      | Field         | Value                            |
      | Name          | Production PostgreSQL            |
      | Type          | postgres                         |
      | Host          | db.example.com                   |
      | Port          | 5432                             |
      | Database      | production                       |
      | Username      | etl_user                         |
      | Secret ref    | vault/postgres/etl               |
    Then the connection should be created
    And password should be stored in secret manager
    And I should see the connection in the list

  @connections @test
  Scenario: Test data connection
    Given connection "production-db" exists
    When I test the connection
    Then I should see connection success or failure status
    And connection details should not be exposed
    And test results should be logged

  @connections @update
  Scenario: Update connection configuration
    Given connection "production-db" exists
    When I update the connection configuration
    Then the changes should be saved
    And pipelines using this connection should be notified
    And I should validate the updated connection

  @connections @delete
  Scenario: Delete unused connection
    Given connection "staging-db" exists and is not used by any pipeline
    When I delete the connection
    Then the connection should be removed
    And connection credentials should be cleaned up

  @connections @delete @error
  Scenario: Cannot delete connection in use
    Given connection "production-db" is used by pipeline "user_sync"
    When I attempt to delete the connection
    Then the deletion should be rejected
    And I should see the pipelines using this connection

  # =============================================================================
  # NOTIFICATIONS AND ALERTS
  # =============================================================================

  @notifications @configure
  Scenario: Configure pipeline notifications
    Given pipeline "user_sync" exists
    When I configure notifications:
      | Event         | Enabled | Channels        | Recipients               |
      | On success    | false   |                 |                          |
      | On failure    | true    | email, slack    | ops-team@example.com     |
      | On SLA breach | true    | pagerduty       | oncall-team              |
    And I set SLA threshold to 60 minutes
    Then notifications should be configured
    And I should see notification summary

  @notifications @sla
  Scenario: Monitor SLA compliance
    Given pipeline "user_sync" has SLA of 60 minutes
    When pipeline execution exceeds SLA threshold
    Then SLA breach alert should be triggered
    And I should see SLA status in dashboard
    And the breach should be logged

  @notifications @digest
  Scenario: Configure notification digest
    When I configure notification digest:
      | Setting       | Value              |
      | Frequency     | daily              |
      | Time          | 09:00              |
      | Include       | failures, warnings |
      | Recipients    | team-leads         |
    Then digest notifications should be scheduled
    And I should receive aggregated pipeline status

  # =============================================================================
  # DOMAIN EVENTS
  # =============================================================================

  @events @lifecycle
  Scenario: Emit domain events for pipeline lifecycle
    Given pipeline operations occur
    Then the following domain events should be emitted:
      | Event Type                      | Payload                           |
      | PipelineCreatedEvent            | pipeline_id, name, created_by     |
      | PipelineUpdatedEvent            | pipeline_id, changes, updated_by  |
      | PipelineDeletedEvent            | pipeline_id, deleted_by           |
      | PipelineExecutionStartedEvent   | pipeline_id, execution_id         |
      | PipelineExecutionCompletedEvent | pipeline_id, status, metrics      |
      | PipelineExecutionFailedEvent    | pipeline_id, error                |
      | PipelineStatusChangedEvent      | pipeline_id, old_status, new_status|
      | PipelineVersionPromotedEvent    | pipeline_id, version              |
      | DataQualityViolationEvent       | pipeline_id, rule_name, count     |
      | DLQThresholdExceededEvent       | pipeline_id, dlq_count, threshold |
    And events should be published to message bus
    And events should support monitoring and alerting

  # =============================================================================
  # RESOURCE MANAGEMENT
  # =============================================================================

  @resources @allocation
  Scenario: Configure pipeline resource allocation
    Given pipeline "user_sync" exists
    When I configure resource allocation:
      | Resource      | Allocation         |
      | Memory        | 4GB                |
      | CPU           | 2 cores            |
      | Parallelism   | 4                  |
      | Timeout       | 120 minutes        |
    Then the resources should be allocated
    And I should see resource usage metrics

  @resources @quotas
  Scenario: Manage pipeline resource quotas
    When I configure resource quotas:
      | Resource              | Limit              |
      | Max concurrent runs   | 10                 |
      | Max daily executions  | 100                |
      | Max record processing | 10 million/day     |
      | Max storage           | 100 GB             |
    Then quotas should be enforced
    And I should see quota usage dashboard

  # =============================================================================
  # ERROR CASES
  # =============================================================================

  @error @permission-denied
  Scenario: Handle insufficient pipeline permissions
    Given I do not have data pipeline management permissions
    When I attempt to access pipeline management
    Then I should see an "Access Denied" error
    And I should see the required permissions
    And the access attempt should be logged

  @error @connection-failed
  Scenario: Handle source connection failure
    Given pipeline "user_sync" exists
    When the source connection fails during execution
    Then the execution should fail with connection error
    And I should see detailed connection error message
    And retry policy should be applied if configured

  @error @destination-failed
  Scenario: Handle destination write failure
    Given pipeline "user_sync" is running
    When the destination write fails
    Then the execution should handle the failure appropriately
    And partial data should be preserved or rolled back
    And I should see the failure details

  @error @quota-exceeded
  Scenario: Handle resource quota exceeded
    Given pipeline resource quotas are configured
    When a pipeline execution would exceed quotas
    Then the execution should be blocked or queued
    And I should see quota exceeded notification
    And I should see options to request quota increase

  @error @timeout
  Scenario: Handle pipeline execution timeout
    Given pipeline "user_sync" has 60 minute timeout
    When the execution exceeds the timeout
    Then the execution should be terminated
    And partial results should be handled per policy
    And timeout event should be logged
