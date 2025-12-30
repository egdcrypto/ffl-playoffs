Feature: Admin CI/CD Pipeline Management
  As an Admin
  I want to manage CI/CD pipelines, builds, and deployments
  So that I can automate and monitor software delivery processes

  Background:
    Given I am authenticated as an admin with email "admin@example.com"
    And the CI/CD system is enabled
    And I have access to the pipeline management console

  # ===========================================
  # Build Automation
  # ===========================================

  Scenario: Admin views build dashboard
    When the admin navigates to the build dashboard
    Then the dashboard displays:
      | metric                    | description                    |
      | Total Builds (24h)        | Number of builds in last day   |
      | Success Rate              | Percentage of successful builds|
      | Average Build Time        | Mean build duration            |
      | Queued Builds             | Builds waiting to start        |
      | Running Builds            | Currently executing builds     |
    And recent builds are listed with status indicators

  Scenario: Admin triggers manual build
    Given a repository "ffl-playoffs-api" is configured
    When the admin triggers a manual build with:
      | field       | value                |
      | repository  | ffl-playoffs-api     |
      | branch      | main                 |
      | commit      | HEAD                 |
    Then a new build is queued
    And the build ID is returned
    And the admin can track build progress

  Scenario: Admin triggers build with custom parameters
    Given a repository supports parameterized builds
    When the admin triggers a build with parameters:
      | parameter        | value              |
      | SKIP_TESTS       | false              |
      | BUILD_PROFILE    | production         |
      | CACHE_ENABLED    | true               |
      | PARALLEL_JOBS    | 4                  |
    Then the build uses the specified parameters
    And parameter values are logged for audit

  Scenario: Admin configures build triggers
    Given the admin is on build configuration
    When the admin configures automatic triggers:
      | trigger_type     | condition                        |
      | Push             | Any push to main branch          |
      | Pull Request     | PR opened or updated             |
      | Schedule         | Daily at 02:00 UTC               |
      | Tag              | Tags matching v*                 |
      | Manual           | Always available                 |
    Then the triggers are saved
    And builds will automatically start when conditions are met

  Scenario: Admin views build logs
    Given a build "BUILD-001234" has completed
    When the admin views the build logs
    Then the logs display:
      | section              | content                          |
      | Checkout             | Git clone and checkout output    |
      | Dependencies         | Dependency resolution logs       |
      | Compilation          | Compile output and warnings      |
      | Tests                | Test execution and results       |
      | Artifacts            | Artifact generation logs         |
    And logs can be downloaded for offline analysis

  Scenario: Admin views build artifacts
    Given a successful build "BUILD-001234" exists
    When the admin views build artifacts
    Then the following artifacts are available:
      | artifact                    | size    | retention |
      | ffl-playoffs-api-1.2.3.jar  | 45.2 MB | 30 days   |
      | test-reports.zip            | 2.1 MB  | 14 days   |
      | coverage-report.html        | 512 KB  | 14 days   |
      | docker-image-digest.txt     | 128 B   | 30 days   |
    And artifacts can be downloaded or promoted

  Scenario: Admin configures build caching
    Given the admin wants to optimize build times
    When the admin configures build cache:
      | cache_type       | path                    | ttl     |
      | Dependencies     | ~/.gradle/caches        | 7 days  |
      | Build Output     | build/                  | 1 day   |
      | Docker Layers    | /var/lib/docker         | 14 days |
    Then caching is enabled for future builds
    And cache hit/miss statistics are tracked

  Scenario: Admin views build resource usage
    Given builds consume compute resources
    When the admin views resource utilization
    Then the report shows:
      | resource        | current | average | peak    |
      | CPU Usage       | 45%     | 62%     | 95%     |
      | Memory Usage    | 8.2 GB  | 6.4 GB  | 12.0 GB |
      | Disk I/O        | 120 MB/s| 85 MB/s | 250 MB/s|
      | Network         | 45 MB/s | 32 MB/s | 120 MB/s|
    And resource trends are displayed over time

  Scenario: Admin cancels running build
    Given a build "BUILD-001235" is currently running
    When the admin cancels the build
    Then the build status changes to "CANCELLED"
    And running processes are terminated gracefully
    And partial artifacts are cleaned up
    And a cancellation reason can be provided

  # ===========================================
  # Deployment Pipelines
  # ===========================================

  Scenario: Admin views deployment pipeline overview
    When the admin navigates to deployment pipelines
    Then the following pipelines are displayed:
      | pipeline            | stages | last_run           | status    |
      | Production Deploy   | 5      | 2024-01-15 10:30   | Success   |
      | Staging Deploy      | 4      | 2024-01-15 14:45   | Running   |
      | Development Deploy  | 3      | 2024-01-15 15:00   | Success   |
    And each pipeline shows stage progression

  Scenario: Admin views pipeline stages
    Given a pipeline "Production Deploy" exists
    When the admin views the pipeline details
    Then the following stages are displayed:
      | stage            | order | type        | status    | duration |
      | Build            | 1     | Automatic   | Completed | 5m 23s   |
      | Unit Tests       | 2     | Automatic   | Completed | 3m 45s   |
      | Integration Tests| 3     | Automatic   | Completed | 8m 12s   |
      | Staging Deploy   | 4     | Automatic   | Completed | 2m 30s   |
      | Production Deploy| 5     | Manual Gate | Pending   | -        |
    And stage dependencies are visualized

  Scenario: Admin creates new deployment pipeline
    Given the admin wants to create a new pipeline
    When the admin creates a pipeline with:
      | field           | value                          |
      | name            | Feature Branch Deploy          |
      | description     | Deploy feature branches to dev |
      | trigger         | Push to feature/* branches     |
      | target_env      | development                    |
    Then the pipeline is created
    And stages can be added to the pipeline

  Scenario: Admin adds stage to pipeline
    Given a pipeline "Feature Branch Deploy" exists
    When the admin adds a stage:
      | field           | value                    |
      | name            | Security Scan            |
      | type            | Automatic                |
      | order           | 3                        |
      | timeout         | 15 minutes               |
      | retry_count     | 2                        |
      | commands        | ./run-security-scan.sh   |
    Then the stage is added to the pipeline
    And the pipeline order is updated

  Scenario: Admin configures manual approval gate
    Given a pipeline stage requires approval
    When the admin configures a manual gate:
      | field              | value                        |
      | stage              | Production Deploy            |
      | required_approvers | 2                            |
      | approver_groups    | release-managers, tech-leads |
      | timeout            | 24 hours                     |
      | auto_reject        | true                         |
    Then the manual gate is configured
    And deployments wait for approval before proceeding

  Scenario: Admin approves deployment
    Given a deployment is waiting at "Production Deploy" gate
    When the admin approves the deployment with:
      | field       | value                              |
      | comment     | Approved after QA sign-off         |
      | conditions  | None                               |
    Then the approval is recorded
    And the deployment proceeds to the next stage
    And the approval is logged with timestamp

  Scenario: Admin rejects deployment
    Given a deployment is waiting at "Production Deploy" gate
    When the admin rejects the deployment with:
      | field       | value                              |
      | reason      | Security vulnerability detected    |
      | action      | Return to development              |
    Then the deployment is rejected
    And the pipeline is marked as failed
    And stakeholders are notified

  Scenario: Admin configures environment-specific deployments
    Given the admin manages multiple environments
    When the admin configures environment settings:
      | environment   | variables                          | secrets_source |
      | development   | DEBUG=true, LOG_LEVEL=debug        | vault-dev      |
      | staging       | DEBUG=false, LOG_LEVEL=info        | vault-staging  |
      | production    | DEBUG=false, LOG_LEVEL=warn        | vault-prod     |
    Then environment configurations are saved
    And deployments use correct settings per environment

  Scenario: Admin configures deployment strategy
    Given the admin wants to control deployment behavior
    When the admin configures deployment strategy:
      | strategy         | settings                                |
      | Blue-Green       | instant_switch=true, keep_old=30m       |
      | Canary           | initial_percent=10, increment=20        |
      | Rolling          | max_unavailable=25%, max_surge=25%      |
    Then the strategy is applied to production deployments
    And rollback is configured accordingly

  Scenario: Admin views deployment history
    Given deployments have been executed
    When the admin views deployment history
    Then the history shows:
      | deployment_id | version | environment | timestamp           | status    | deployer         |
      | DEP-001234    | 1.2.3   | production  | 2024-01-15 10:30:00 | Success   | admin@example.com|
      | DEP-001233    | 1.2.2   | production  | 2024-01-14 09:15:00 | Success   | ci-bot           |
      | DEP-001232    | 1.2.1   | production  | 2024-01-13 11:00:00 | Rolled Back| admin@example.com|
    And each deployment can be expanded for details

  # ===========================================
  # Testing Stages
  # ===========================================

  Scenario: Admin views test execution overview
    When the admin navigates to test results
    Then the test dashboard shows:
      | metric              | value    |
      | Total Tests         | 1,245    |
      | Passing             | 1,198    |
      | Failing             | 12       |
      | Skipped             | 35       |
      | Pass Rate           | 96.2%    |
      | Coverage            | 82.4%    |

  Scenario: Admin views test results by category
    Given tests are categorized by type
    When the admin views test breakdown
    Then results are shown by category:
      | category            | total | passed | failed | duration |
      | Unit Tests          | 892   | 885    | 7      | 3m 45s   |
      | Integration Tests   | 234   | 229    | 5      | 8m 12s   |
      | API Tests           | 89    | 89     | 0      | 4m 30s   |
      | E2E Tests           | 30    | 25     | 5      | 12m 45s  |

  Scenario: Admin investigates test failures
    Given there are failing tests
    When the admin views failed test details
    Then each failure shows:
      | field              | content                           |
      | Test Name          | PlayerServiceTest.testCreatePlayer|
      | Failure Message    | Expected 200 but got 500          |
      | Stack Trace        | Full stack trace                  |
      | Duration           | 245ms                             |
      | Flaky History      | Failed 2/10 recent runs           |
      | Related Changes    | Commit abc123 by developer@...    |

  Scenario: Admin marks test as flaky
    Given a test "testNetworkTimeout" fails intermittently
    When the admin marks the test as flaky with:
      | field           | value                        |
      | reason          | Network timing sensitivity   |
      | ticket          | JIRA-4567                    |
      | auto_retry      | true                         |
      | retry_count     | 3                            |
    Then the test is marked as flaky
    And flaky test failures don't fail the build
    And flaky tests are tracked separately

  Scenario: Admin configures test parallelization
    Given the admin wants to speed up test execution
    When the admin configures parallelization:
      | setting              | value          |
      | max_parallel_suites  | 4              |
      | shard_count          | 8              |
      | timeout_per_test     | 5 minutes      |
      | rebalance_on_failure | true           |
    Then tests are distributed across workers
    And test duration is reduced

  Scenario: Admin views code coverage report
    Given a build includes coverage data
    When the admin views the coverage report
    Then coverage is displayed by:
      | package                          | line_coverage | branch_coverage |
      | com.ffl.playoffs.domain          | 89.5%         | 85.2%           |
      | com.ffl.playoffs.application     | 82.3%         | 78.9%           |
      | com.ffl.playoffs.infrastructure  | 75.8%         | 71.4%           |
    And uncovered lines are highlighted
    And coverage trends are shown

  Scenario: Admin configures quality gates
    Given the admin wants to enforce code quality
    When the admin configures quality gates:
      | metric              | threshold | action_on_fail |
      | Code Coverage       | >= 80%    | Warn           |
      | Test Pass Rate      | >= 95%    | Block          |
      | Critical Bugs       | = 0       | Block          |
      | Code Smells         | <= 10     | Warn           |
      | Security Hotspots   | = 0       | Block          |
    Then quality gates are enforced
    And builds are blocked or warned based on thresholds

  Scenario: Admin views security scan results
    Given a security scan has completed
    When the admin views security results
    Then vulnerabilities are displayed:
      | severity   | count | categories                        |
      | Critical   | 0     | -                                 |
      | High       | 2     | SQL Injection, XSS                |
      | Medium     | 5     | Insecure Dependencies, Hardcoded  |
      | Low        | 12    | Info Disclosure, Deprecated APIs  |
    And each vulnerability includes remediation guidance

  Scenario: Admin configures test environment provisioning
    Given integration tests require infrastructure
    When the admin configures test environment:
      | resource         | specification              |
      | Database         | PostgreSQL 15, ephemeral   |
      | Cache            | Redis 7, ephemeral         |
      | Message Queue    | RabbitMQ, ephemeral        |
      | Mock Services    | WireMock containers        |
    Then test environments are provisioned on-demand
    And resources are cleaned up after tests

  # ===========================================
  # Rollback Procedures
  # ===========================================

  Scenario: Admin views rollback options
    Given a deployment "DEP-001234" is in production
    When the admin views rollback options
    Then available rollback targets are shown:
      | version   | deployed_at         | status     | rollback_type |
      | 1.2.2     | 2024-01-14 09:15:00 | Previous   | Instant       |
      | 1.2.1     | 2024-01-13 11:00:00 | Stable     | Instant       |
      | 1.2.0     | 2024-01-10 14:30:00 | Stable     | Requires DB   |
    And incompatible versions show migration requirements

  Scenario: Admin initiates instant rollback
    Given the current production version has issues
    When the admin initiates rollback to version "1.2.2"
    Then the rollback confirmation shows:
      """
      Rollback Details:
      - Current Version: 1.2.3
      - Target Version: 1.2.2
      - Rollback Type: Instant (Blue-Green switch)
      - Estimated Duration: < 1 minute
      - Database Migration: Not required

      Traffic will be switched immediately.
      """
    And upon confirmation, traffic switches to the previous version

  Scenario: Admin performs rollback with database migration
    Given the current version has breaking database changes
    When the admin initiates rollback to version "1.2.0"
    Then the rollback process includes:
      | step                    | duration | status    |
      | Pause incoming traffic  | 5s       | Completed |
      | Run rollback migrations | 45s      | Running   |
      | Verify data integrity   | 30s      | Pending   |
      | Switch traffic          | 5s       | Pending   |
      | Health check            | 60s      | Pending   |
    And the admin monitors each step

  Scenario: Admin configures automatic rollback triggers
    Given the admin wants automatic rollback on failure
    When the admin configures rollback triggers:
      | trigger                   | threshold        | action           |
      | Error Rate                | > 5% for 5 min   | Auto Rollback    |
      | Response Time P99         | > 2s for 5 min   | Alert + Rollback |
      | Health Check Failures     | 3 consecutive    | Auto Rollback    |
      | Memory Usage              | > 95% for 10 min | Alert Only       |
    Then automatic rollback is enabled
    And triggers are monitored continuously

  Scenario: Admin views rollback history
    Given rollbacks have been performed
    When the admin views rollback history
    Then the history shows:
      | rollback_id | from_version | to_version | reason              | executed_by      | duration |
      | RB-001234   | 1.2.3        | 1.2.2      | High error rate     | system           | 45s      |
      | RB-001233   | 1.2.1        | 1.2.0      | Memory leak         | admin@example.com| 2m 15s   |
    And each rollback includes detailed logs

  Scenario: Admin creates rollback checkpoint
    Given a stable deployment exists
    When the admin creates a rollback checkpoint:
      | field           | value                          |
      | name            | Pre-Holiday Stable             |
      | version         | 1.2.3                          |
      | database_state  | Snapshot taken                 |
      | expiration      | 30 days                        |
    Then the checkpoint is created
    And it can be used for future rollbacks

  Scenario: Admin tests rollback procedure
    Given the admin wants to verify rollback readiness
    When the admin initiates a rollback test in staging
    Then the test performs:
      | step                       | result   |
      | Deploy current version     | Success  |
      | Trigger rollback           | Success  |
      | Verify previous version    | Success  |
      | Validate data integrity    | Success  |
      | Measure rollback duration  | 43 seconds|
    And a rollback readiness report is generated

  Scenario: Admin configures rollback notifications
    Given rollbacks should notify stakeholders
    When the admin configures rollback notifications:
      | event                  | channels              | recipients               |
      | Rollback Initiated     | Slack, Email          | ops-team, dev-team       |
      | Rollback Completed     | Slack, Email          | ops-team, dev-team       |
      | Rollback Failed        | Slack, Email, PagerDuty| on-call, management     |
    Then notification rules are saved
    And stakeholders are notified during rollbacks

  # ===========================================
  # Pipeline Monitoring
  # ===========================================

  Scenario: Admin views pipeline health dashboard
    When the admin navigates to pipeline monitoring
    Then the health dashboard shows:
      | metric                  | value    | status  |
      | Pipeline Success Rate   | 94.5%    | Healthy |
      | Average Pipeline Time   | 18m 32s  | Warning |
      | Queue Wait Time         | 2m 15s   | Healthy |
      | Failed Pipelines (24h)  | 3        | Warning |
      | Infrastructure Health   | 98.5%    | Healthy |

  Scenario: Admin views pipeline execution timeline
    Given pipelines are running
    When the admin views the execution timeline
    Then a Gantt-style chart shows:
      | pipeline            | start_time | end_time | status    |
      | Build #1234         | 10:00      | 10:18    | Completed |
      | Build #1235         | 10:05      | 10:22    | Completed |
      | Build #1236         | 10:15      | -        | Running   |
    And resource utilization is overlaid

  Scenario: Admin views pipeline bottleneck analysis
    Given pipelines have performance data
    When the admin views bottleneck analysis
    Then the analysis shows:
      | stage              | avg_duration | % of total | trend    | recommendation           |
      | Checkout           | 45s          | 4%         | Stable   | -                        |
      | Compile            | 3m 20s       | 18%        | +15%     | Enable incremental build |
      | Unit Tests         | 5m 45s       | 31%        | Stable   | -                        |
      | Integration Tests  | 8m 15s       | 45%        | +25%     | Increase parallelization |
    And optimization suggestions are provided

  Scenario: Admin configures pipeline alerts
    Given the admin wants proactive notifications
    When the admin configures pipeline alerts:
      | alert_type           | condition                  | severity |
      | Pipeline Failure     | Any failure                | High     |
      | Long Queue Time      | > 10 minutes               | Medium   |
      | Slow Pipeline        | > 30 minutes               | Low      |
      | Resource Exhaustion  | Queue > 20 builds          | High     |
    Then alerts are configured
    And notifications are sent when conditions are met

  Scenario: Admin views build agent status
    Given multiple build agents are configured
    When the admin views agent status
    Then agents are displayed:
      | agent_id   | status    | current_job     | capacity | last_active        |
      | agent-01   | Busy      | Build #1236     | 4/4      | Now                |
      | agent-02   | Idle      | -               | 0/4      | 2 minutes ago      |
      | agent-03   | Offline   | -               | 0/4      | 1 hour ago         |
      | agent-04   | Busy      | Build #1237     | 2/4      | Now                |
    And agent health metrics are shown

  Scenario: Admin scales build infrastructure
    Given build queue is growing
    When the admin scales infrastructure:
      | action           | setting                   |
      | Add Agents       | 2 additional agents       |
      | Scale Type       | Temporary (4 hours)       |
      | Agent Size       | Large (8 CPU, 16GB RAM)   |
    Then additional agents are provisioned
    And queue processing accelerates
    And agents are terminated after timeout

  Scenario: Admin views pipeline cost metrics
    Given pipelines consume cloud resources
    When the admin views cost metrics
    Then the report shows:
      | metric                    | value    | trend   |
      | Total Cost (MTD)          | $1,245   | +8%     |
      | Cost per Build            | $0.45    | -5%     |
      | Cost per Deployment       | $2.30    | +12%    |
      | Wasted Compute (failures) | $156     | -15%    |
    And cost optimization opportunities are highlighted

  Scenario: Admin configures pipeline SLOs
    Given the admin wants to track pipeline reliability
    When the admin configures SLOs:
      | slo_name                | target   | window    |
      | Build Success Rate      | 95%      | 7 days    |
      | Deploy Success Rate     | 99%      | 30 days   |
      | Mean Time to Deploy     | < 20 min | 30 days   |
      | Rollback Success Rate   | 100%     | 30 days   |
    Then SLOs are tracked
    And SLO violations trigger alerts

  Scenario: Admin views pipeline audit log
    Given pipeline activities are logged
    When the admin views the audit log
    Then activities are displayed:
      | timestamp           | action                  | actor            | details               |
      | 2024-01-15 10:30:00 | Deployment Approved     | admin@example.com| Production v1.2.3     |
      | 2024-01-15 10:28:00 | Build Triggered         | github-webhook   | Commit abc123         |
      | 2024-01-15 10:15:00 | Pipeline Config Changed | admin@example.com| Added security stage  |
    And logs can be filtered and exported

  # ===========================================
  # Pipeline Configuration
  # ===========================================

  Scenario: Admin imports pipeline from YAML
    Given the admin has a pipeline definition file
    When the admin imports the pipeline:
      """yaml
      name: Production Pipeline
      stages:
        - name: Build
          script: ./gradlew build
        - name: Test
          script: ./gradlew test
          parallel: 4
        - name: Deploy
          script: ./deploy.sh
          environment: production
          manual_approval: true
      """
    Then the pipeline is created from the definition
    And the configuration is validated

  Scenario: Admin exports pipeline configuration
    Given a pipeline exists
    When the admin exports the configuration
    Then a YAML file is generated
    And it can be version-controlled
    And imported to other environments

  Scenario: Admin configures pipeline secrets
    Given pipelines need access to credentials
    When the admin configures secrets:
      | secret_name          | source          | scope        |
      | DOCKER_PASSWORD      | Vault           | Build stage  |
      | AWS_ACCESS_KEY       | AWS Secrets Mgr | Deploy stage |
      | SONAR_TOKEN          | Vault           | Analysis     |
    Then secrets are securely injected
    And secret values are never logged

  Scenario: Admin configures webhook integrations
    Given the admin wants to trigger external actions
    When the admin configures webhooks:
      | event               | url                              | secret     |
      | Build Completed     | https://api.example.com/builds   | webhook123 |
      | Deploy Completed    | https://api.example.com/deploys  | webhook456 |
      | Pipeline Failed     | https://api.example.com/failures | webhook789 |
    Then webhooks are registered
    And events trigger HTTP callbacks

  # ===========================================
  # Error Cases
  # ===========================================

  Scenario: Admin cannot deploy to production without approval
    Given a deployment requires manual approval
    When the admin attempts to skip the approval gate
    Then the request is rejected with error "APPROVAL_REQUIRED"
    And the pipeline remains at the approval stage

  Scenario: Admin cannot rollback to incompatible version
    Given the target version requires incompatible database state
    When the admin attempts to rollback
    Then a warning is displayed:
      """
      Rollback Blocked: Version 1.1.0 requires database migration.
      The current database schema is incompatible.

      Options:
      1. Create database backup and proceed with migration
      2. Choose a compatible version (1.2.0 or later)
      3. Contact database admin for manual intervention
      """

  Scenario: Pipeline fails due to resource constraints
    Given all build agents are busy
    And queue limit is reached
    When a new build is triggered
    Then the build is rejected with error "QUEUE_LIMIT_EXCEEDED"
    And the admin is notified to scale infrastructure

  Scenario: Admin cannot modify running pipeline
    Given a pipeline is currently executing
    When the admin attempts to modify the pipeline configuration
    Then the request is rejected with error "PIPELINE_RUNNING"
    And modifications must wait until pipeline completes

  Scenario: Deployment fails health check
    Given a deployment has completed
    When health checks fail for the new version
    Then automatic rollback is triggered
    And the admin is notified:
      """
      Deployment DEP-001235 failed health checks.
      Error: Service returned HTTP 503 for 3 consecutive checks.
      Action: Automatic rollback to version 1.2.2 initiated.
      """

  Scenario: Admin views failed pipeline diagnostics
    Given a pipeline has failed
    When the admin views failure diagnostics
    Then the report includes:
      | field                | content                          |
      | Failure Point        | Integration Tests stage          |
      | Error Type           | Test Assertion Failure           |
      | Root Cause           | Database connection timeout      |
      | Similar Failures     | 3 in last 7 days                 |
      | Suggested Fix        | Check database connectivity      |
    And related logs are highlighted
