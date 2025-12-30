@orchestrator @automation @jira @gherkin @mvp-foundation
Feature: Complete Gherkin-JIRA Sync with Labels
  As a project manager
  I want Gherkin feature files to be synchronized with JIRA tickets
  So that I can track feature implementation progress in JIRA

  Background:
    Given the orchestrator CLI is installed
    And JIRA credentials are configured
    And the features directory contains Gherkin files
    And the project has MVP-FOUNDATION label configured

  # =============================================================================
  # FEATURE FILE DISCOVERY
  # =============================================================================

  @discovery @scan
  Scenario: Discover all Gherkin feature files in project
    Given the project has a features directory
    When I run the orchestrator sync command
    Then the system should discover all .feature files
    And the discovery should include:
      | Directory           | Description                              |
      | features/           | Root features directory                  |
      | features/backlog/   | Backlog features subdirectory            |
      | **/features/        | Nested feature directories               |
    And the total file count should be logged

  @discovery @parse
  Scenario: Parse feature file metadata
    Given a feature file exists at "features/ffl-42-example.feature"
    When the orchestrator parses the file
    Then it should extract:
      | Field               | Description                              |
      | featureTitle        | Feature name from Feature: line          |
      | featureDescription  | Feature description text                 |
      | tags                | All @ tags on feature                    |
      | scenarios           | List of scenario names                   |
      | scenarioCount       | Total number of scenarios                |
      | filePath            | Relative path to file                    |

  @discovery @tags
  Scenario: Extract feature-level tags
    Given a feature file with tags:
      """
      @admin @security @mvp-foundation
      Feature: Admin Security Dashboard
      """
    When the orchestrator extracts tags
    Then the following tags should be identified:
      | Tag               | Type        |
      | @admin            | Category    |
      | @security         | Category    |
      | @mvp-foundation   | Label       |
    And tags should be normalized to lowercase

  @discovery @filter
  Scenario: Filter feature files by tag
    Given multiple feature files exist with various tags
    When I filter by tag "mvp-foundation"
    Then only features with @mvp-foundation should be returned
    And the filter should be case-insensitive

  # =============================================================================
  # JIRA TICKET CREATION
  # =============================================================================

  @jira @create
  Scenario: Create JIRA ticket from feature file
    Given a feature file "ffl-50-new-feature.feature" exists
    And no corresponding JIRA ticket exists
    When the orchestrator syncs the feature
    Then a new JIRA ticket should be created with:
      | Field               | Value                                    |
      | summary             | Feature title from file                  |
      | description         | Feature description and scenarios        |
      | labels              | Extracted from feature tags              |
      | issueType           | Story or Task                            |
      | project             | Configured project key                   |

  @jira @description
  Scenario: Format JIRA ticket description
    Given a feature file with scenarios:
      | Scenario Name                     |
      | User logs in successfully         |
      | User sees error on invalid login  |
      | User can reset password           |
    When the orchestrator creates the ticket
    Then the description should include:
      | Section             | Content                                  |
      | Overview            | Feature description                      |
      | Scenarios           | Bulleted list of scenarios               |
      | Source              | Link to feature file                     |
      | Generated           | Timestamp of creation                    |

  @jira @labels
  Scenario: Apply labels from feature tags
    Given a feature file with tags "@admin @security @mvp-foundation"
    When the orchestrator creates the ticket
    Then the JIRA ticket should have labels:
      | Label               |
      | admin               |
      | security            |
      | MVP-FOUNDATION      |
    And label case should match JIRA configuration

  @jira @custom-fields
  Scenario: Set custom JIRA fields
    Given custom field mappings are configured
    When the orchestrator creates a ticket
    Then custom fields should be populated:
      | Custom Field        | Source                                   |
      | Feature File        | Relative file path                       |
      | Scenario Count      | Number of scenarios                      |
      | Sync Status         | SYNCED                                   |
      | Last Sync           | Current timestamp                        |

  # =============================================================================
  # DUPLICATE PREVENTION
  # =============================================================================

  @duplicate @detection
  Scenario: Detect existing JIRA ticket for feature
    Given a feature file "ffl-42-existing.feature" exists
    And a JIRA ticket already exists for this feature
    When the orchestrator syncs the feature
    Then the system should detect the existing ticket
    And no duplicate ticket should be created
    And the sync should log "Ticket already exists"

  @duplicate @matching
  Scenario: Match feature files to existing tickets
    Given existing JIRA tickets with feature references
    When the orchestrator checks for duplicates
    Then matching should use:
      | Strategy            | Description                              |
      | Feature ID          | Match by ffl-XX identifier               |
      | Summary match       | Match by ticket summary                  |
      | Custom field        | Match by Feature File custom field       |
      | Label combination   | Match by unique label combination        |

  @duplicate @update
  Scenario: Update existing ticket instead of creating duplicate
    Given a feature file has been modified
    And the corresponding JIRA ticket exists
    When the orchestrator syncs with update mode
    Then the existing ticket should be updated
    And the update should include:
      | Field               | Action                                   |
      | description         | Update if changed                        |
      | labels              | Add new labels, preserve existing        |
      | scenarios           | Update scenario list                     |
      | lastSyncTimestamp   | Update to current time                   |

  @duplicate @conflict
  Scenario: Handle sync conflicts
    Given a feature file and JIRA ticket have diverged
    When the orchestrator detects a conflict
    Then the system should:
      | Action              | Description                              |
      | Log conflict        | Record conflicting changes               |
      | Prefer source       | Gherkin file is source of truth          |
      | Preserve manual     | Keep manual JIRA additions               |
      | Flag for review     | Mark ticket for human review             |

  # =============================================================================
  # ONE-WAY SYNC (GHERKIN TO JIRA)
  # =============================================================================

  @sync @direction
  Scenario: Enforce one-way sync from Gherkin to JIRA
    Given the sync direction is configured as "gherkin-to-jira"
    When synchronization runs
    Then changes should flow only from feature files to JIRA
    And JIRA changes should not modify feature files
    And the sync should be idempotent

  @sync @batch
  Scenario: Batch sync multiple feature files
    Given 50 feature files need synchronization
    When I run batch sync
    Then all files should be processed
    And the system should:
      | Action              | Description                              |
      | Track progress      | Show progress indicator                  |
      | Handle errors       | Continue on individual failures          |
      | Report summary      | Show created/updated/skipped counts      |
      | Rate limit          | Respect JIRA API rate limits             |

  @sync @incremental
  Scenario: Incremental sync based on file changes
    Given some feature files have changed since last sync
    When I run incremental sync
    Then only changed files should be processed
    And unchanged files should be skipped
    And the sync should use:
      | Detection Method    | Description                              |
      | File modification   | Check file modified timestamp            |
      | Content hash        | Compare content hash                     |
      | Git diff            | Use git to detect changes                |

  @sync @dry-run
  Scenario: Preview sync without making changes
    Given feature files need synchronization
    When I run sync with --dry-run flag
    Then no JIRA tickets should be created or modified
    And the output should show:
      | Information         | Description                              |
      | Would create        | Tickets that would be created            |
      | Would update        | Tickets that would be updated            |
      | Would skip          | Tickets that would be skipped            |
      | Label changes       | Labels that would be applied             |

  # =============================================================================
  # AUTO-LABEL APPLICATION
  # =============================================================================

  @labels @auto
  Scenario: Automatically apply labels from feature tags
    Given a feature file with tags:
      | Tag                 |
      | @world              |
      | @entities           |
      | @retrieval          |
      | @mvp-foundation     |
    When the orchestrator syncs the feature
    Then JIRA labels should be applied:
      | Label               |
      | world               |
      | entities            |
      | retrieval           |
      | MVP-FOUNDATION      |

  @labels @mapping
  Scenario: Map feature tags to JIRA labels
    Given label mapping configuration:
      | Feature Tag         | JIRA Label                               |
      | @mvp-foundation     | MVP-FOUNDATION                           |
      | @admin              | admin                                    |
      | @system             | backend                                  |
      | @error              | error-handling                           |
    When tags are processed
    Then mapped labels should be applied
    And unmapped tags should be applied as-is

  @labels @validation
  Scenario: Validate labels against JIRA configuration
    Given JIRA project has allowed labels configured
    When applying labels to a ticket
    Then the system should:
      | Validation          | Action                                   |
      | Check existence     | Verify label exists in JIRA              |
      | Create if missing   | Optionally create new labels             |
      | Skip invalid        | Skip labels not allowed                  |
      | Log warnings        | Warn about skipped labels                |

  @labels @hierarchy
  Scenario: Apply hierarchical label structure
    Given a feature file with hierarchical tags:
      | Tag                 | Hierarchy                                |
      | @admin              | Category                                 |
      | @admin-security     | Subcategory                              |
      | @admin-security-mfa | Specific feature                         |
    When labels are applied
    Then hierarchical labels should be created:
      | Label               |
      | admin               |
      | admin-security      |
      | admin-security-mfa  |

  # =============================================================================
  # ORCHESTRATOR CLI COMMANDS
  # =============================================================================

  @cli @sync-command
  Scenario: Run sync via orchestrator CLI
    Given the orchestrator is properly configured
    When I run "orchestrator jira sync"
    Then the sync process should execute
    And output should show:
      | Information         | Format                                   |
      | Files discovered    | "Found X feature files"                  |
      | Tickets created     | "Created X new tickets"                  |
      | Tickets updated     | "Updated X existing tickets"             |
      | Errors              | "X errors encountered"                   |

  @cli @options
  Scenario: Support CLI options for sync
    Given various sync configurations needed
    When I use CLI options
    Then the following options should be supported:
      | Option              | Description                              |
      | --dry-run           | Preview without changes                  |
      | --force             | Force sync all files                     |
      | --filter            | Filter by tag or pattern                 |
      | --project           | Target JIRA project                      |
      | --labels            | Additional labels to apply               |
      | --verbose           | Detailed output                          |

  @cli @status
  Scenario: Check sync status via CLI
    Given previous syncs have been performed
    When I run "orchestrator jira status"
    Then I should see:
      | Status Information  | Description                              |
      | Last sync time      | When last sync occurred                  |
      | Files synced        | Number of files in last sync             |
      | Pending changes     | Files changed since last sync            |
      | Sync errors         | Any outstanding errors                   |

  @cli @single-file
  Scenario: Sync single feature file
    Given I want to sync one specific file
    When I run "orchestrator jira sync features/ffl-42-example.feature"
    Then only that file should be synced
    And the result should be displayed immediately

  # =============================================================================
  # TAG EXTRACTION
  # =============================================================================

  @extraction @feature-tags
  Scenario: Extract tags from feature level
    Given a feature file:
      """
      @world @entities @aggregation @mvp-foundation
      Feature: World Entities Aggregation
        As a world creator...
      """
    When I extract feature-level tags
    Then all four tags should be captured
    And tags should be associated with the feature

  @extraction @scenario-tags
  Scenario: Extract tags from scenarios
    Given a feature file with scenario tags:
      """
      @aggregation
      Feature: Entity Aggregation

        @happy-path @critical
        Scenario: Successful aggregation

        @error-case
        Scenario: Handle aggregation error
      """
    When I extract all tags
    Then both feature and scenario tags should be captured
    And scenario tags should be aggregated for the feature

  @extraction @tag-categories
  Scenario: Categorize extracted tags
    Given extracted tags from a feature
    When I categorize tags
    Then tags should be grouped:
      | Category            | Tags                                     |
      | Label tags          | mvp-foundation, sprint-1                 |
      | Domain tags         | admin, world, entities                   |
      | Type tags           | happy-path, error-case                   |
      | Priority tags       | critical, low-priority                   |

  @extraction @special-tags
  Scenario: Handle special tag formats
    Given tags with special formats:
      | Tag                 | Format                                   |
      | @FFL-42             | Ticket reference                         |
      | @wip                | Work in progress                         |
      | @skip               | Skip indicator                           |
      | @manual             | Manual test required                     |
    When I process special tags
    Then special tags should be handled appropriately:
      | Tag                 | Handling                                 |
      | @FFL-42             | Link to existing ticket                  |
      | @wip                | Set status to In Progress                |
      | @skip               | Exclude from sync                        |
      | @manual             | Add manual-testing label                 |

  # =============================================================================
  # SYNC REPORTING
  # =============================================================================

  @reporting @summary
  Scenario: Generate sync summary report
    Given a sync operation has completed
    When I request the sync report
    Then the report should include:
      | Section             | Content                                  |
      | Overview            | Total files, success rate                |
      | Created tickets     | List of new tickets created              |
      | Updated tickets     | List of updated tickets                  |
      | Skipped files       | Files not synced and reasons             |
      | Errors              | Any errors with details                  |
      | Labels applied      | Summary of labels used                   |

  @reporting @history
  Scenario: Track sync history
    Given multiple sync operations have occurred
    When I request sync history
    Then I should see:
      | History Entry       | Information                              |
      | Timestamp           | When sync occurred                       |
      | User                | Who initiated sync                       |
      | Files processed     | Number of files                          |
      | Changes made        | Created/updated counts                   |
      | Duration            | How long sync took                       |

  @reporting @audit
  Scenario: Audit trail for sync operations
    Given sync operations modify JIRA
    When sync completes
    Then an audit record should be created:
      | Audit Field         | Value                                    |
      | operation           | JIRA_SYNC                                |
      | timestamp           | Current time                             |
      | filesProcessed      | List of files                            |
      | ticketsCreated      | List of ticket IDs                       |
      | ticketsUpdated      | List of ticket IDs                       |
      | labelsApplied       | Labels used                              |

  # =============================================================================
  # ERROR HANDLING
  # =============================================================================

  @error @parse-failure
  Scenario: Handle feature file parse errors
    Given a malformed feature file exists
    When the orchestrator attempts to parse it
    Then the error should be logged:
      | Error Field         | Value                                    |
      | file                | Path to malformed file                   |
      | line                | Line number of error                     |
      | message             | Description of parse error               |
    And other files should continue processing

  @error @jira-api
  Scenario: Handle JIRA API errors
    Given JIRA API returns an error
    When creating a ticket fails
    Then the system should:
      | Action              | Description                              |
      | Log error           | Record API error details                 |
      | Retry               | Retry transient errors                   |
      | Continue            | Process remaining files                  |
      | Report              | Include in summary report                |

  @error @rate-limit
  Scenario: Handle JIRA rate limiting
    Given JIRA API rate limit is reached
    When the rate limit response is received
    Then the system should:
      | Action              | Description                              |
      | Pause               | Wait for rate limit reset                |
      | Backoff             | Apply exponential backoff                |
      | Resume              | Continue after limit resets              |
      | Log                 | Record rate limiting event               |

  @error @network
  Scenario: Handle network connectivity issues
    Given network connectivity to JIRA is lost
    When sync encounters network error
    Then the system should:
      | Action              | Description                              |
      | Detect              | Identify network failure                 |
      | Retry               | Retry with backoff                       |
      | Fail gracefully     | Complete with partial results            |
      | Report              | Show which files failed                  |

  # =============================================================================
  # CONFIGURATION
  # =============================================================================

  @config @file
  Scenario: Configure sync via configuration file
    Given a configuration file exists at ".orchestrator/config.yml"
    When the orchestrator loads configuration
    Then the following should be configurable:
      | Setting             | Description                              |
      | jira.baseUrl        | JIRA instance URL                        |
      | jira.project        | Target project key                       |
      | jira.issueType      | Default issue type                       |
      | sync.direction      | Sync direction (one-way)                 |
      | sync.dryRun         | Default dry-run mode                     |
      | labels.mapping      | Tag to label mapping                     |
      | labels.default      | Default labels to apply                  |

  @config @credentials
  Scenario: Secure credential configuration
    Given JIRA requires authentication
    When configuring credentials
    Then credentials should be stored:
      | Method              | Description                              |
      | Environment vars    | JIRA_API_TOKEN, JIRA_USERNAME            |
      | Config file         | Encrypted in config file                 |
      | Keychain            | System keychain integration              |
    And credentials should never appear in logs

  @config @project-specific
  Scenario: Support project-specific configuration
    Given multiple projects with different settings
    When I configure per-project settings
    Then each project can have:
      | Setting             | Description                              |
      | Project key         | Different JIRA project                   |
      | Label mapping       | Project-specific mappings                |
      | Feature directory   | Custom features location                 |
      | Issue type          | Project-specific issue type              |

  # =============================================================================
  # INTEGRATION
  # =============================================================================

  @integration @git
  Scenario: Integrate sync with git workflow
    Given the project uses git
    When I configure git integration
    Then sync can be triggered:
      | Trigger             | Description                              |
      | Pre-commit hook     | Validate features before commit          |
      | Post-push hook      | Sync after push to main                  |
      | CI/CD pipeline      | Sync as pipeline step                    |
      | Manual              | On-demand via CLI                        |

  @integration @ci
  Scenario: Run sync in CI/CD pipeline
    Given a CI/CD pipeline is configured
    When the sync step runs
    Then the sync should:
      | Requirement         | Description                              |
      | Non-interactive     | Run without user input                   |
      | Exit codes          | Return proper exit codes                 |
      | Machine output      | Support JSON output for parsing          |
      | Secrets             | Use CI secrets for credentials           |

  @integration @notifications
  Scenario: Send notifications on sync events
    Given notifications are configured
    When significant sync events occur
    Then notifications should be sent for:
      | Event               | Notification                             |
      | Sync complete       | Summary of changes                       |
      | Errors occurred     | Error details                            |
      | New tickets         | List of created tickets                  |
      | Conflicts           | Conflicts requiring attention            |

  # =============================================================================
  # VALIDATION
  # =============================================================================

  @validation @feature
  Scenario: Validate feature file format
    Given a feature file to be synced
    When validation runs
    Then the file should be checked for:
      | Validation          | Description                              |
      | Gherkin syntax      | Valid Gherkin format                     |
      | Required sections   | Feature, Background, Scenarios           |
      | Tag format          | Tags follow naming convention            |
      | Description         | Feature has description                  |

  @validation @pre-sync
  Scenario: Run pre-sync validation
    Given multiple feature files to sync
    When pre-sync validation runs
    Then validation should check:
      | Check               | Description                              |
      | Duplicate features  | No duplicate feature IDs                 |
      | Tag consistency     | Tags are consistent across files         |
      | Required tags       | MVP-FOUNDATION tag present               |
      | File naming         | Files follow naming convention           |

  # =============================================================================
  # STATISTICS
  # =============================================================================

  @stats @coverage
  Scenario: Track sync coverage statistics
    Given sync has been running
    When I request coverage statistics
    Then I should see:
      | Statistic           | Description                              |
      | Total features      | Number of feature files                  |
      | Synced features     | Features with JIRA tickets               |
      | Coverage percentage | Percentage synced                        |
      | By label            | Features per label                       |
      | By directory        | Features per directory                   |

  @stats @trends
  Scenario: Track sync trends over time
    Given historical sync data exists
    When I request trend analysis
    Then I should see:
      | Trend               | Description                              |
      | Features growth     | New features over time                   |
      | Sync frequency      | How often sync runs                      |
      | Error trends        | Error rate over time                     |
      | Label distribution  | How labels are used over time            |

  # =============================================================================
  # MVP FOUNDATION SPECIFIC
  # =============================================================================

  @mvp @tracking
  Scenario: Track MVP Foundation feature completion
    Given features are tagged with @mvp-foundation
    When I query MVP Foundation status
    Then I should see:
      | Metric              | Description                              |
      | Total MVP features  | Features with MVP-FOUNDATION tag         |
      | Tickets created     | JIRA tickets for MVP features            |
      | In progress         | MVP features being worked on             |
      | Completed           | MVP features marked done                 |

  @mvp @labels
  Scenario: Apply MVP-FOUNDATION label consistently
    Given a feature file has @mvp-foundation tag
    When the feature is synced to JIRA
    Then the MVP-FOUNDATION label should be applied
    And the label should be uppercase in JIRA
    And the feature should be queryable by this label

  @mvp @dashboard
  Scenario: Generate MVP Foundation dashboard data
    Given MVP Foundation sync is complete
    When I request dashboard data
    Then I should receive:
      | Dashboard Element   | Description                              |
      | Feature count       | Total MVP features                       |
      | Ticket status       | Status distribution of tickets           |
      | Label breakdown     | Other labels on MVP features             |
      | Progress            | Completion percentage                    |
