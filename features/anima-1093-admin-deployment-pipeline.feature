@admin @deployment @pipeline @ANIMA-1093
Feature: Admin Deployment Pipeline
  As a platform administrator
  I want to manage deployment pipelines and releases
  So that I can ensure safe and efficient software delivery

  Background:
    Given I am logged in as a platform administrator
    And I have deployment pipeline permissions
    And the deployment system is active

  # =============================================================================
  # PIPELINE DASHBOARD
  # =============================================================================

  @dashboard @overview
  Scenario: View deployment pipeline dashboard
    When I navigate to the deployment pipeline dashboard
    Then I should see pipeline overview:
      | pipeline           | status   | last_run     | duration | success_rate |
      | main-release       | success  | 2 hours ago  | 18 min   | 98%          |
      | hotfix             | idle     | 1 day ago    | 12 min   | 100%         |
      | staging-deploy     | running  | now          | 5 min    | 95%          |
      | infrastructure     | success  | 4 hours ago  | 25 min   | 97%          |
    And I should see deployment activity timeline
    And I should see environment status summary

  @dashboard @active
  Scenario: View active deployments
    When I view active deployments
    Then I should see running deployments:
      | deployment         | environment | stage        | progress | started_by |
      | v3.2.1-scoring     | staging     | integration  | 65%      | ci-bot     |
      | v3.2.0-hotfix      | production  | canary       | 25%      | admin      |
    And I should see deployment logs
    And I should be able to cancel deployments

  @dashboard @history
  Scenario: View deployment history
    When I view deployment history
    Then I should see recent deployments:
      | version   | environment | status   | deployed_at         | deployed_by |
      | v3.2.0    | production  | success  | 2024-06-15 10:00    | release-mgr |
      | v3.1.9    | production  | success  | 2024-06-14 15:00    | ci-bot      |
      | v3.1.8    | production  | rollback | 2024-06-13 12:00    | admin       |
    And I should see deployment details on click
    And I should be able to compare deployments

  @dashboard @health
  Scenario: View pipeline health metrics
    When I view pipeline health
    Then I should see health metrics:
      | metric                  | value    | trend   |
      | avg_deployment_time     | 15 min   | -10%    |
      | success_rate            | 97%      | +2%     |
      | rollback_rate           | 3%       | -1%     |
      | mean_time_to_recovery   | 8 min    | -25%    |
    And I should see pipeline bottlenecks
    And I should see improvement recommendations

  # =============================================================================
  # RELEASE MANAGEMENT
  # =============================================================================

  @release @creation
  Scenario: Create new release
    When I create a new release:
      | field           | value                    |
      | version         | v3.3.0                   |
      | source_branch   | release/3.3.0            |
      | release_type    | minor                    |
      | description     | Q3 feature release       |
    Then the release should be created
    And release artifacts should be generated
    And I should see release checklist

  @release @artifacts
  Scenario: Manage release artifacts
    Given release "v3.3.0" exists
    When I view release artifacts
    Then I should see artifacts:
      | artifact              | type      | size   | checksum_verified |
      | ffl-api-3.3.0.jar     | binary    | 45 MB  | yes               |
      | ffl-web-3.3.0.zip     | bundle    | 12 MB  | yes               |
      | migrations-3.3.0.sql  | script    | 125 KB | yes               |
      | config-3.3.0.yaml     | config    | 8 KB   | yes               |
    And I should be able to download artifacts
    And I should see artifact provenance

  @release @notes
  Scenario: Generate release notes
    When I generate release notes for "v3.3.0"
    Then release notes should include:
      | section           | content                          |
      | features          | 15 new features                  |
      | bug_fixes         | 28 bug fixes                     |
      | breaking_changes  | 2 breaking changes               |
      | deprecations      | 5 deprecations                   |
      | contributors      | 12 contributors                  |
    And I should see linked JIRA tickets
    And I should see commit history

  @release @versioning
  Scenario: Configure semantic versioning
    When I configure versioning rules:
      | rule                    | action              |
      | breaking_change         | increment_major     |
      | new_feature             | increment_minor     |
      | bug_fix                 | increment_patch     |
      | pre_release             | add_suffix          |
    Then versioning should be configured
    And auto-versioning should follow rules

  @release @changelog
  Scenario: Maintain release changelog
    When I view the changelog
    Then I should see version history:
      | version | date       | changes | breaking |
      | v3.3.0  | 2024-06-20 | 45      | 2        |
      | v3.2.0  | 2024-06-01 | 38      | 0        |
      | v3.1.0  | 2024-05-15 | 52      | 1        |
    And I should see formatted changelog
    And changelog should be exportable

  # =============================================================================
  # ENVIRONMENT MANAGEMENT
  # =============================================================================

  @environments @management
  Scenario: Manage deployment environments
    When I access environment management
    Then I should see environments:
      | environment | status  | current_version | last_deploy      |
      | development | active  | v3.3.0-dev      | 30 min ago       |
      | staging     | active  | v3.2.1-rc1      | 2 hours ago      |
      | production  | active  | v3.2.0          | 1 day ago        |
      | dr-site     | standby | v3.2.0          | 1 day ago        |
    And I should see environment configuration
    And I should see environment dependencies

  @environments @configuration
  Scenario: Configure environment settings
    When I configure environment "staging":
      | setting              | value              |
      | auto_deploy          | enabled            |
      | deploy_branch        | develop            |
      | approval_required    | false              |
      | health_check_url     | /api/health        |
      | rollback_on_failure  | true               |
    Then environment settings should be saved
    And settings should take effect immediately

  @environments @promotion
  Scenario: Promote release between environments
    Given "v3.2.1" is deployed to staging
    When I promote "v3.2.1" to production
    Then I should see promotion workflow:
      | step              | status   |
      | approval_check    | pending  |
      | pre_deploy_tests  | pending  |
      | deployment        | pending  |
      | health_checks     | pending  |
      | monitoring        | pending  |
    And I should be able to track promotion progress

  @environments @parity
  Scenario: Check environment parity
    When I check parity between staging and production
    Then I should see parity report:
      | component        | staging     | production  | parity   |
      | api_version      | v3.2.1      | v3.2.0      | behind   |
      | db_schema        | v45         | v44         | behind   |
      | config_version   | c123        | c122        | behind   |
      | infra_version    | i15         | i15         | match    |
    And I should see detailed differences

  @environments @isolation
  Scenario: Configure environment isolation
    When I configure environment isolation:
      | environment | network_isolation | data_isolation | access_control |
      | production  | strict            | complete       | rbac_strict    |
      | staging     | moderate          | masked         | rbac_standard  |
      | development | minimal           | synthetic      | rbac_open      |
    Then isolation should be configured
    And isolation should be enforced

  # =============================================================================
  # BUILD PIPELINE
  # =============================================================================

  @build @configuration
  Scenario: Configure build pipeline
    When I configure build pipeline:
      | stage          | steps                          | timeout |
      | checkout       | git_clone, submodules          | 2 min   |
      | dependencies   | gradle_deps, npm_install       | 10 min  |
      | compile        | gradle_build, webpack          | 15 min  |
      | test           | unit_tests, integration_tests  | 20 min  |
      | package        | docker_build, artifact_upload  | 10 min  |
    Then build pipeline should be configured
    And I should see pipeline visualization

  @build @triggers
  Scenario: Configure build triggers
    When I configure build triggers:
      | trigger_type    | condition              | action        |
      | push            | branch: main           | full_build    |
      | push            | branch: feature/*      | quick_build   |
      | pull_request    | target: main           | full_build    |
      | schedule        | cron: 0 0 * * *        | nightly_build |
      | manual          | any                    | custom_build  |
    Then triggers should be configured
    And builds should trigger automatically

  @build @caching
  Scenario: Configure build caching
    When I configure build caching:
      | cache_type      | path                   | key                    |
      | dependencies    | ~/.gradle/caches       | gradle-$checksum       |
      | node_modules    | node_modules           | npm-$lockfile_hash     |
      | docker_layers   | /var/lib/docker        | docker-$dockerfile     |
    Then caching should be configured
    And build times should improve

  @build @parallelization
  Scenario: Configure parallel build stages
    When I configure parallel execution:
      | parallel_group  | stages                          |
      | tests           | unit_tests, integration_tests   |
      | packaging       | docker_amd64, docker_arm64      |
      | scanning        | sast_scan, dependency_scan      |
    Then parallel execution should be enabled
    And I should see parallel stage visualization

  @build @artifacts
  Scenario: Configure artifact management
    When I configure artifact settings:
      | setting              | value              |
      | artifact_repository  | artifactory        |
      | retention_days       | 90                 |
      | immutable_releases   | true               |
      | signing_required     | true               |
    Then artifact settings should be saved
    And artifacts should be managed accordingly

  # =============================================================================
  # DEPLOYMENT STRATEGY
  # =============================================================================

  @strategy @configuration
  Scenario: Configure deployment strategy
    When I configure deployment strategy:
      | strategy        | setting              | value         |
      | rolling_update  | max_unavailable      | 25%           |
      | rolling_update  | max_surge            | 25%           |
      | rolling_update  | health_check_grace   | 60 seconds    |
    Then rolling update strategy should be configured
    And deployments should follow this strategy

  @strategy @blue-green
  Scenario: Configure blue-green deployment
    When I configure blue-green deployment:
      | setting              | value              |
      | switch_method        | load_balancer      |
      | health_check_count   | 3                  |
      | rollback_timeout     | 10 minutes         |
      | cleanup_delay        | 30 minutes         |
    Then blue-green deployment should be configured
    And I should see blue/green environment status

  @strategy @canary
  Scenario: Configure canary deployment
    When I configure canary deployment:
      | phase   | traffic_percentage | duration   | success_criteria    |
      | 1       | 5%                 | 15 min     | error_rate < 1%     |
      | 2       | 25%                | 30 min     | error_rate < 1%     |
      | 3       | 50%                | 1 hour     | error_rate < 0.5%   |
      | 4       | 100%               | continuous | error_rate < 0.5%   |
    Then canary deployment should be configured
    And I should see canary traffic controls

  @strategy @recreate
  Scenario: Configure recreate deployment
    When I configure recreate deployment:
      | setting              | value              |
      | pre_stop_hook        | drain_connections  |
      | termination_grace    | 30 seconds         |
      | startup_probe        | enabled            |
    Then recreate strategy should be configured
    And I should see maintenance window option

  # =============================================================================
  # TESTING PIPELINE
  # =============================================================================

  @testing @configuration
  Scenario: Configure testing pipeline
    When I configure testing stages:
      | stage               | tests                    | required | timeout |
      | unit_tests          | all_unit                 | true     | 10 min  |
      | integration_tests   | api_integration          | true     | 20 min  |
      | e2e_tests           | critical_paths           | true     | 30 min  |
      | performance_tests   | load_test_baseline       | false    | 45 min  |
      | security_tests      | owasp_scan               | true     | 15 min  |
    Then testing pipeline should be configured
    And tests should run in order

  @testing @gates
  Scenario: Configure quality gates
    When I configure quality gates:
      | gate                | threshold    | action_on_fail |
      | code_coverage       | >= 80%       | block          |
      | security_vulns      | 0 critical   | block          |
      | test_pass_rate      | >= 95%       | block          |
      | performance_delta   | <= 10%       | warn           |
    Then quality gates should be active
    And failures should block deployment

  @testing @environments
  Scenario: Configure test environments
    When I configure test environments:
      | environment     | purpose              | lifecycle      |
      | test-ephemeral  | PR testing           | per_pr         |
      | test-persistent | integration          | persistent     |
      | test-performance| load testing         | on_demand      |
    Then test environments should be configured
    And environments should provision automatically

  @testing @results
  Scenario: View test results
    Given a deployment is in progress
    When I view test results
    Then I should see test summary:
      | test_type           | passed | failed | skipped | duration |
      | unit_tests          | 1,245  | 3      | 12      | 8 min    |
      | integration_tests   | 156    | 0      | 5       | 18 min   |
      | e2e_tests           | 45     | 1      | 2       | 25 min   |
    And I should see failure details
    And I should see test trends

  # =============================================================================
  # APPROVAL WORKFLOW
  # =============================================================================

  @approval @configuration
  Scenario: Configure release approval workflow
    When I configure approval workflow:
      | stage              | approvers           | required | timeout   |
      | code_review        | dev_lead            | 2        | 24 hours  |
      | qa_signoff         | qa_team             | 1        | 8 hours   |
      | security_review    | security_team       | 1        | 4 hours   |
      | release_approval   | release_manager     | 1        | 2 hours   |
    Then approval workflow should be configured
    And approvals should be enforced

  @approval @request
  Scenario: Request deployment approval
    Given release "v3.3.0" is ready for production
    When I request deployment approval
    Then approval request should be created
    And approvers should be notified
    And I should see approval status:
      | approver          | status   | responded_at |
      | dev_lead_1        | approved | 10:00 AM     |
      | dev_lead_2        | pending  | -            |
      | qa_lead           | pending  | -            |

  @approval @review
  Scenario: Review and approve deployment
    Given I am an approver for release "v3.3.0"
    When I review the deployment request
    Then I should see deployment details:
      | section          | content                    |
      | changes          | 45 commits, 15 features    |
      | test_results     | 98% passed                 |
      | security_scan    | no critical issues         |
      | risk_assessment  | low                        |
    And I should be able to approve or reject
    And I should add approval comments

  @approval @escalation
  Scenario: Configure approval escalation
    When I configure escalation:
      | condition              | action                   |
      | pending > 4 hours      | notify_manager           |
      | pending > 8 hours      | escalate_to_director     |
      | urgent_flag            | skip_to_final_approver   |
    Then escalation should be configured
    And approvals should escalate automatically

  @approval @emergency
  Scenario: Emergency approval bypass
    Given there is a critical production issue
    When I request emergency bypass:
      | justification    | Critical security patch      |
      | incident_ref     | INC-12345                    |
      | post_approval    | required                     |
    Then bypass should be granted
    And deployment should proceed immediately
    And post-deployment review should be scheduled

  # =============================================================================
  # DEPLOYMENT MONITORING
  # =============================================================================

  @monitoring @integration
  Scenario: Integrate deployment monitoring
    When I configure deployment monitoring:
      | metric               | source         | threshold      | action      |
      | error_rate           | prometheus     | > 5%           | auto_pause  |
      | latency_p99          | prometheus     | > 500ms        | alert       |
      | cpu_utilization      | kubernetes     | > 90%          | alert       |
      | memory_usage         | kubernetes     | > 85%          | alert       |
    Then monitoring should be integrated
    And metrics should be collected during deployment

  @monitoring @healthchecks
  Scenario: Configure deployment health checks
    When I configure health checks:
      | check_type      | endpoint         | interval | threshold |
      | liveness        | /health/live     | 10s      | 3 failures|
      | readiness       | /health/ready    | 5s       | 2 failures|
      | startup         | /health/startup  | 5s       | 30 retries|
    Then health checks should be configured
    And failed health checks should trigger rollback

  @monitoring @realtime
  Scenario: Monitor deployment in real-time
    Given a deployment is in progress
    When I view deployment monitoring
    Then I should see real-time metrics:
      | metric           | baseline | current | status  |
      | error_rate       | 0.5%     | 0.8%    | normal  |
      | response_time    | 120ms    | 135ms   | normal  |
      | throughput       | 1000/s   | 980/s   | normal  |
    And I should see deployment progress
    And I should see instance health

  @monitoring @comparison
  Scenario: Compare pre and post deployment metrics
    Given deployment "v3.2.1" is complete
    When I compare deployment metrics
    Then I should see comparison:
      | metric           | before   | after    | change  |
      | error_rate       | 0.5%     | 0.3%     | -40%    |
      | response_time    | 150ms    | 120ms    | -20%    |
      | memory_usage     | 2.5GB    | 2.8GB    | +12%    |
    And I should see regression analysis
    And I should see optimization suggestions

  # =============================================================================
  # ROLLBACK
  # =============================================================================

  @rollback @emergency
  Scenario: Perform emergency rollback
    Given deployment "v3.2.1" is causing issues
    When I initiate emergency rollback
    Then rollback should execute:
      | step                  | status   | duration |
      | pause_traffic         | complete | 5s       |
      | switch_to_previous    | complete | 30s      |
      | verify_health         | complete | 60s      |
      | resume_traffic        | complete | 10s      |
    And I should see rollback confirmation
    And incident should be created

  @rollback @automatic
  Scenario: Configure automatic rollback
    When I configure automatic rollback:
      | trigger              | threshold    | action          |
      | error_rate_spike     | > 10%        | immediate       |
      | health_check_fail    | 3 consecutive| immediate       |
      | response_time        | > 2x baseline| after 5 min     |
    Then automatic rollback should be configured
    And rollback should trigger automatically

  @rollback @partial
  Scenario: Perform partial rollback
    Given canary deployment at 25% traffic
    When I perform partial rollback
    Then canary traffic should route to stable
    And I should see traffic distribution:
      | version  | traffic |
      | v3.2.0   | 100%    |
      | v3.2.1   | 0%      |
    And canary instances should be terminated

  @rollback @database
  Scenario: Coordinate database rollback
    Given deployment included database migrations
    When I initiate rollback with database:
      | step                    | action                    |
      | 1                       | stop_new_transactions     |
      | 2                       | run_rollback_migrations   |
      | 3                       | verify_data_integrity     |
      | 4                       | deploy_previous_version   |
    Then database rollback should execute
    And data integrity should be verified

  # =============================================================================
  # CANARY DEPLOYMENT
  # =============================================================================

  @canary @management
  Scenario: Manage canary deployment
    When I start canary deployment for "v3.2.1"
    Then I should see canary status:
      | metric           | canary   | stable   | threshold |
      | error_rate       | 0.3%     | 0.5%     | < 1%      |
      | latency_p95      | 180ms    | 200ms    | < 250ms   |
      | success_rate     | 99.7%    | 99.5%    | > 99%     |
    And I should see traffic distribution
    And I should be able to adjust traffic

  @canary @promotion
  Scenario: Promote canary to full deployment
    Given canary "v3.2.1" has passed all checks
    When I promote canary to 100%
    Then traffic should shift gradually
    And I should see promotion progress:
      | time     | canary_traffic |
      | 0 min    | 25%            |
      | 5 min    | 50%            |
      | 10 min   | 75%            |
      | 15 min   | 100%           |
    And stable version should be decommissioned

  @canary @analysis
  Scenario: Analyze canary performance
    When I analyze canary "v3.2.1"
    Then I should see analysis:
      | dimension        | canary_score | confidence |
      | error_rate       | 95%          | high       |
      | latency          | 88%          | high       |
      | resource_usage   | 75%          | medium     |
      | business_metrics | 92%          | high       |
    And I should see recommendation: promote/rollback

  @canary @traffic
  Scenario: Configure canary traffic rules
    When I configure traffic rules:
      | rule_type        | condition              | routing      |
      | header_match     | X-Canary: true         | canary       |
      | user_segment     | beta_users             | canary       |
      | percentage       | 10%                    | canary       |
      | region           | us-west-2              | canary       |
    Then traffic rules should be applied
    And I should see traffic distribution

  # =============================================================================
  # DATABASE MIGRATIONS
  # =============================================================================

  @migrations @management
  Scenario: Manage database migrations
    When I view pending migrations
    Then I should see migration queue:
      | migration_id | description           | type      | risk    |
      | V45          | Add player_stats idx  | index     | low     |
      | V46          | Alter roster table    | schema    | medium  |
      | V47          | Migrate legacy data   | data      | high    |
    And I should see migration dependencies
    And I should see rollback scripts

  @migrations @execution
  Scenario: Execute database migration
    When I execute migration "V45":
      | setting          | value           |
      | timeout          | 30 minutes      |
      | lock_wait        | 10 seconds      |
      | batch_size       | 10000           |
      | dry_run          | false           |
    Then migration should execute
    And I should see progress:
      | phase            | status   | duration |
      | acquire_lock     | complete | 2s       |
      | execute_ddl      | complete | 45s      |
      | verify           | complete | 10s      |
    And migration should be recorded

  @migrations @zero-downtime
  Scenario: Configure zero-downtime migrations
    When I configure zero-downtime migration:
      | technique              | setting           |
      | online_ddl             | enabled           |
      | ghost_table            | enabled           |
      | backwards_compatible   | required          |
      | dual_write            | during_transition |
    Then zero-downtime should be configured
    And migrations should not lock tables

  @migrations @validation
  Scenario: Validate migration before execution
    When I validate migration "V46"
    Then I should see validation results:
      | check                  | status   | details              |
      | syntax_valid           | pass     | -                    |
      | backwards_compatible   | pass     | -                    |
      | rollback_exists        | pass     | rollback script found|
      | estimated_duration     | warn     | > 10 minutes         |
      | table_lock_required    | fail     | blocks writes        |
    And I should see remediation suggestions

  # =============================================================================
  # FEATURE TOGGLES
  # =============================================================================

  @feature-toggles @deployment
  Scenario: Deploy with feature toggles
    When I configure feature flags for deployment:
      | flag                  | default | deployment_state |
      | new_scoring_engine    | false   | enabled_canary   |
      | redesigned_dashboard  | false   | disabled         |
      | beta_trade_analyzer   | false   | enabled_internal |
    Then feature flags should be configured
    And I should see flag override options

  @feature-toggles @progressive
  Scenario: Progressive feature rollout
    When I configure progressive rollout:
      | flag                  | phase_1  | phase_2  | phase_3  | full    |
      | new_scoring_engine    | 5%       | 25%      | 50%      | 100%    |
      | phase_duration        | 1 hour   | 4 hours  | 1 day    | -       |
      | success_criteria      | no_errors| < 1% err | < 0.5%   | stable  |
    Then progressive rollout should be configured
    And flags should advance automatically

  @feature-toggles @emergency-kill
  Scenario: Emergency feature kill switch
    Given "new_scoring_engine" is causing issues
    When I trigger kill switch
    Then feature should be disabled immediately
    And all users should see old behavior
    And I should see kill switch audit log

  @feature-toggles @targeting
  Scenario: Configure feature targeting
    When I configure feature targeting:
      | flag                  | targeting_rule               |
      | beta_features         | user.tier == 'premium'       |
      | new_dashboard         | user.region in ['US', 'CA']  |
      | experimental          | user.id in beta_list         |
    Then targeting rules should be applied
    And I should see affected user count

  # =============================================================================
  # SECURITY SCANNING
  # =============================================================================

  @security @scanning
  Scenario: Integrate security scanning
    When I configure security scanning:
      | scan_type        | tool          | stage        | blocking |
      | sast             | sonarqube     | build        | true     |
      | dependency       | snyk          | build        | true     |
      | container        | trivy         | package      | true     |
      | dast             | zap           | post_deploy  | false    |
    Then security scanning should be integrated
    And scans should run automatically

  @security @results
  Scenario: View security scan results
    Given security scans have completed
    When I view security results
    Then I should see vulnerability summary:
      | severity  | count | fixed | new  |
      | critical  | 0     | 2     | 0    |
      | high      | 3     | 5     | 1    |
      | medium    | 12    | 8     | 2    |
      | low       | 25    | 15    | 5    |
    And I should see detailed findings
    And I should see remediation guidance

  @security @gates
  Scenario: Configure security gates
    When I configure security gates:
      | gate                    | threshold        | action      |
      | critical_vulnerabilities| 0                | block       |
      | high_vulnerabilities    | 0                | block       |
      | medium_vulnerabilities  | < 10             | warn        |
      | secrets_detected        | 0                | block       |
    Then security gates should be enforced
    And violations should block deployment

  @security @compliance
  Scenario: Verify deployment compliance
    When I verify compliance for deployment
    Then I should see compliance status:
      | requirement          | status     | evidence           |
      | code_review          | compliant  | PR #1234 approved  |
      | security_scan        | compliant  | scan-id-xyz        |
      | approval_workflow    | compliant  | 3/3 approvals      |
      | audit_trail          | compliant  | all actions logged |
    And I should see compliance report

  # =============================================================================
  # DEPLOYMENT METRICS
  # =============================================================================

  @metrics @tracking
  Scenario: Track deployment metrics
    When I view deployment metrics
    Then I should see DORA metrics:
      | metric                      | value    | target   | status |
      | deployment_frequency        | 8/week   | 5/week   | good   |
      | lead_time_for_changes       | 4 hours  | 1 day    | good   |
      | mean_time_to_recovery       | 15 min   | 1 hour   | good   |
      | change_failure_rate         | 5%       | 15%      | good   |
    And I should see metric trends
    And I should see team comparisons

  @metrics @performance
  Scenario: Track deployment performance
    When I view deployment performance
    Then I should see performance metrics:
      | stage              | avg_duration | p95_duration | trend   |
      | build              | 8 min        | 12 min       | -10%    |
      | test               | 15 min       | 22 min       | stable  |
      | deploy             | 5 min        | 8 min        | -15%    |
      | verification       | 3 min        | 5 min        | stable  |
    And I should see bottleneck analysis

  @metrics @reliability
  Scenario: Track deployment reliability
    When I view reliability metrics
    Then I should see reliability data:
      | metric                  | last_7_days | last_30_days | trend   |
      | successful_deploys      | 28          | 95           | +12%    |
      | failed_deploys          | 2           | 8            | -25%    |
      | rollbacks               | 1           | 5            | -40%    |
      | hotfixes                | 3           | 12           | stable  |
    And I should see failure analysis

  @metrics @reporting
  Scenario: Generate deployment report
    When I generate deployment report:
      | parameter        | value           |
      | date_range       | last 30 days    |
      | environments     | all             |
      | include_details  | true            |
    Then report should be generated
    And I should see executive summary
    And report should be exportable

  # =============================================================================
  # MULTI-SERVICE DEPLOYMENT
  # =============================================================================

  @multi-service @coordination
  Scenario: Coordinate multi-service deployment
    When I configure multi-service deployment:
      | service          | version | order | dependencies     |
      | api-gateway      | v2.1.0  | 1     | none             |
      | user-service     | v3.0.0  | 2     | api-gateway      |
      | scoring-service  | v2.5.0  | 2     | api-gateway      |
      | notification-svc | v1.8.0  | 3     | user-service     |
    Then deployment order should be configured
    And I should see dependency graph

  @multi-service @orchestration
  Scenario: Execute coordinated deployment
    When I execute multi-service deployment
    Then I should see orchestration status:
      | service          | status     | progress |
      | api-gateway      | complete   | 100%     |
      | user-service     | deploying  | 65%      |
      | scoring-service  | deploying  | 45%      |
      | notification-svc | waiting    | 0%       |
    And dependencies should be respected

  @multi-service @rollback
  Scenario: Rollback multi-service deployment
    Given multi-service deployment is failing
    When I initiate coordinated rollback
    Then rollback should occur in reverse order
    And I should see rollback status:
      | service          | rolled_back | version   |
      | notification-svc | yes         | v1.7.0    |
      | scoring-service  | yes         | v2.4.0    |
      | user-service     | yes         | v2.9.0    |
      | api-gateway      | yes         | v2.0.0    |
    And all services should be healthy

  @multi-service @compatibility
  Scenario: Verify service compatibility
    When I verify service compatibility
    Then I should see compatibility matrix:
      | service_a        | service_b        | compatible | api_version |
      | user-service     | scoring-service  | yes        | v2          |
      | api-gateway      | user-service     | yes        | v3          |
      | scoring-service  | notification-svc | warning    | v1/v2       |
    And I should see compatibility issues

  # =============================================================================
  # NOTIFICATIONS
  # =============================================================================

  @notifications @configuration
  Scenario: Configure deployment notifications
    When I configure notifications:
      | event                | channel      | recipients          |
      | deployment_started   | slack        | #deployments        |
      | deployment_success   | slack, email | #deployments, team  |
      | deployment_failed    | slack, pager | #incidents, oncall  |
      | approval_needed      | email        | approvers           |
    Then notifications should be configured
    And notifications should be sent on events

  @notifications @templates
  Scenario: Configure notification templates
    When I configure notification templates:
      | template         | content                              |
      | deploy_start     | "Deploying {version} to {env}"       |
      | deploy_success   | "{version} deployed successfully"    |
      | deploy_failed    | "ALERT: {version} deployment failed" |
    Then templates should be saved
    And notifications should use templates

  @notifications @preferences
  Scenario: Configure notification preferences
    When users configure preferences:
      | preference           | setting              |
      | notification_level   | failures_only        |
      | quiet_hours          | 22:00 - 08:00        |
      | preferred_channel    | slack                |
    Then preferences should be saved
    And notifications should respect preferences

  # =============================================================================
  # INFRASTRUCTURE DEPLOYMENT
  # =============================================================================

  @infrastructure @management
  Scenario: Manage infrastructure deployments
    When I access infrastructure deployments
    Then I should see infrastructure components:
      | component        | current_version | pending | last_updated |
      | kubernetes       | 1.28            | 1.29    | 1 week ago   |
      | database_cluster | 15.3            | -       | 2 weeks ago  |
      | redis_cluster    | 7.2             | -       | 1 month ago  |
      | load_balancer    | 2.4             | 2.5     | 3 days ago   |
    And I should see upgrade paths

  @infrastructure @iac
  Scenario: Deploy infrastructure as code
    When I deploy infrastructure changes:
      | resource         | action   | config_file         |
      | scaling_policy   | update   | scaling.tf          |
      | security_groups  | create   | security.tf         |
      | dns_records      | update   | dns.tf              |
    Then I should see terraform plan
    And changes should require approval
    And I should see resource diff

  @infrastructure @drift
  Scenario: Detect infrastructure drift
    When I check for infrastructure drift
    Then I should see drift report:
      | resource             | expected  | actual    | drift    |
      | instance_count       | 5         | 6         | yes      |
      | security_group_rules | 10        | 12        | yes      |
      | dns_records          | 15        | 15        | no       |
    And I should be able to remediate drift

  # =============================================================================
  # DEPLOYMENT SCHEDULING
  # =============================================================================

  @scheduling @configuration
  Scenario: Schedule deployments
    When I schedule a deployment:
      | parameter        | value                    |
      | release          | v3.3.0                   |
      | environment      | production               |
      | scheduled_time   | 2024-06-20 02:00 UTC     |
      | maintenance_window| 2 hours                 |
    Then deployment should be scheduled
    And I should see deployment in calendar

  @scheduling @windows
  Scenario: Configure deployment windows
    When I configure deployment windows:
      | environment | allowed_days     | allowed_hours | blackout_dates    |
      | production  | Mon-Thu          | 02:00-06:00   | holidays          |
      | staging     | Mon-Fri          | any           | none              |
      | development | any              | any           | none              |
    Then deployment windows should be enforced
    And out-of-window deploys should require override

  @scheduling @conflicts
  Scenario: Detect scheduling conflicts
    Given a deployment is scheduled
    When I check for conflicts
    Then I should see conflict analysis:
      | conflict_type      | details                    |
      | maintenance_window | overlaps with AWS maintenance|
      | other_deployment   | api-gateway deploying same time|
      | peak_traffic       | scheduled during peak hours|
    And I should see rescheduling suggestions

  # =============================================================================
  # ERROR HANDLING AND EDGE CASES
  # =============================================================================

  @error-handling @deployment-failure
  Scenario: Handle deployment failure gracefully
    Given a deployment is in progress
    When deployment fails at verification stage
    Then automatic rollback should trigger
    And I should see failure details:
      | field              | value                    |
      | failed_stage       | health_check             |
      | error_message      | Readiness probe failed   |
      | affected_instances | 3/10                     |
    And incident should be created
    And stakeholders should be notified

  @error-handling @timeout
  Scenario: Handle deployment timeout
    Given deployment exceeds timeout
    When timeout is reached
    Then deployment should be paused
    And I should see timeout options:
      | option           | description              |
      | extend_timeout   | Add 30 more minutes      |
      | force_complete   | Mark as complete         |
      | rollback         | Revert to previous       |
    And decision should be logged

  @edge-case @concurrent-deployments
  Scenario: Handle concurrent deployment requests
    Given a deployment is in progress
    When another deployment is requested
    Then new deployment should be queued
    And I should see queue status
    And I should be able to prioritize queue

  @edge-case @partial-failure
  Scenario: Handle partial deployment failure
    Given multi-region deployment is in progress
    When one region fails while others succeed
    Then I should see partial failure status:
      | region    | status  | action_required |
      | us-east-1 | success | none            |
      | us-west-2 | success | none            |
      | eu-west-1 | failed  | retry/rollback  |
    And I should be able to retry failed region
    And I should be able to rollback all regions
