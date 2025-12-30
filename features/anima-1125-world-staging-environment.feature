@world @staging @deployment @testing @ANIMA-1125
Feature: World Staging Environment
  As a world owner
  I want to deploy my world to a staging environment
  So that I can perform final testing and validation before publishing to production

  Background:
    Given an authenticated world owner
    And I have a world "Fantasy Realm" ready for staging deployment
    And the world has passed simulation testing
    And staging environment management is available

  # =============================================================================
  # STAGING ENVIRONMENT SETUP
  # =============================================================================

  @setup @provision @happy-path
  Scenario: Set up and configure staging environment
    Given my world has passed simulation testing with score 95%
    When I request a staging environment
    Then a staging instance should be provisioned
    And I should see staging details:
      | field              | value                          |
      | environment_id     | STG-WLD-001                    |
      | url                | stg.fantasy-realm.example.com  |
      | status             | provisioning                   |
      | estimated_time     | 5 minutes                      |
    And staging should mirror production configuration
    And a domain event "StagingEnvironmentCreated" should be published

  @setup @configure
  Scenario: Configure staging environment settings
    Given a staging environment "STG-001" exists
    When I configure staging settings:
      | setting              | value           |
      | region               | us-east-1       |
      | instance_size        | medium          |
      | auto_shutdown        | 24_hours        |
      | data_refresh         | daily           |
    Then settings should be applied to staging
    And I should see resource cost estimate:
      | resource     | hourly_cost |
      | compute      | $0.50       |
      | storage      | $0.10       |
      | bandwidth    | $0.05       |
      | total        | $0.65       |

  @setup @versioning
  Scenario: Deploy specific world version to staging
    Given my world has multiple versions:
      | version | date       | changes              |
      | 2.0.0   | 2024-01-01 | Major content update |
      | 2.1.0   | 2024-01-15 | Bug fixes            |
      | 2.2.0   | 2024-01-20 | New features         |
    When I deploy version "2.1.0" to staging
    Then staging should run version "2.1.0"
    And version should be clearly displayed in staging UI
    And I should be able to switch versions easily

  @setup @quota
  Scenario: Handle staging environment quota exceeded
    Given I have 3 active staging environments
    And my account limit is 3 environments
    When I attempt to create another staging
    Then I should see error "Staging environment quota exceeded"
    And I should see current usage:
      | active_environments | 3 |
      | quota_limit         | 3 |
    And I should be offered options:
      | option              | description                |
      | terminate_existing  | Free up a slot             |
      | upgrade_plan        | Increase quota limit       |

  @setup @templates
  Scenario: Create staging from template
    Given staging templates are available
    When I create staging from template "Production Mirror":
      | template_setting    | value              |
      | data_source         | production_snapshot|
      | config_source       | production         |
      | size                | production_match   |
    Then staging should be configured automatically
    And match production specifications

  # =============================================================================
  # DATA AND CONTENT MANAGEMENT
  # =============================================================================

  @data @options @happy-path
  Scenario: View data management options
    Given staging environment "STG-001" is running
    When I view data management options
    Then I should see available options:
      | option                | description                    |
      | sync_from_production  | Copy live data (anonymized)    |
      | load_test_data        | Use predefined test sets       |
      | reset_to_clean        | Restore to baseline            |
      | export_staging_data   | Download staging data          |

  @data @sync
  Scenario: Sync production data to staging
    Given production world has 10,000 player records
    When I sync production data to staging
    Then data should be anonymized:
      | field           | anonymization           |
      | email           | hashed                  |
      | username        | randomized              |
      | payment_info    | removed                 |
      | personal_data   | pseudonymized           |
    And I should see sync progress:
      | phase            | status    |
      | export           | complete  |
      | anonymization    | complete  |
      | import           | in_progress |
    And sync completion should be confirmed

  @data @test-data
  Scenario: Load test data set into staging
    Given test data sets are available:
      | data_set              | users  | purpose           |
      | stress_test_1000      | 1,000  | Load testing      |
      | edge_case_scenarios   | 100    | Edge case testing |
      | full_feature_test     | 500    | Feature coverage  |
    When I load test data set "stress_test_1000_users"
    Then staging should be populated with test data
    And I should see data load summary:
      | metric           | value    |
      | users_created    | 1,000    |
      | content_items    | 5,000    |
      | transactions     | 10,000   |
    And test accounts should be accessible

  @data @reset
  Scenario: Reset staging data to clean state
    Given staging has accumulated test data over 2 weeks
    When I reset staging to clean state
    Then all test data should be cleared
    And configuration should remain intact
    And I should see reset confirmation:
      | data_cleared      | yes                |
      | config_preserved  | yes                |
      | reset_time        | 2 minutes          |

  @data @snapshot
  Scenario: Create data snapshot before testing
    Given staging has current test state
    When I create a data snapshot "before_uat"
    Then snapshot should be saved
    And I should be able to restore to this snapshot
    And snapshot should be listed in recovery options

  # =============================================================================
  # ACCESS CONTROL
  # =============================================================================

  @access @configure @happy-path
  Scenario: Configure access control for staging
    Given staging environment "STG-001" exists
    When I configure access control
    Then I should see access management options:
      | option              | description                |
      | invite_testers      | Add users by email         |
      | set_permissions     | Define access levels       |
      | set_expiration      | Time-limited access        |
      | ip_whitelist        | Restrict by IP             |

  @access @invite
  Scenario: Invite beta testers to staging
    Given staging environment is ready for testing
    When I invite testers:
      | email                | role        | expires_in |
      | tester1@example.com  | full_access | 7_days     |
      | tester2@example.com  | view_only   | 3_days     |
      | qa_lead@example.com  | admin       | 14_days    |
    Then invitations should be sent
    And testers should receive:
      | email_content        | included            |
      | access_url           | yes                 |
      | credentials          | temporary_password  |
      | expiration_date      | yes                 |
    And access should be logged

  @access @revoke
  Scenario: Revoke staging access
    Given tester "tester1@example.com" has staging access
    And they have an active session
    When I revoke their access
    Then access should be immediately terminated
    And tester should receive notification:
      | notification_type | access_revoked         |
      | reason            | Access period ended    |
    And active sessions should be ended

  @access @temporary-links
  Scenario: Generate temporary access links
    Given I need to share staging with stakeholders
    When I generate a temporary access link:
      | validity         | 24 hours       |
      | access_level     | view_only      |
      | max_uses         | 10             |
    Then a unique access URL should be created
    And link metadata should be:
      | field            | value          |
      | expires_at       | in 24 hours    |
      | remaining_uses   | 10             |
      | created_by       | owner          |
    And usage should be trackable

  @access @audit
  Scenario: View access audit log
    Given staging has had multiple access events
    When I view the access audit log
    Then I should see all access events:
      | timestamp   | user              | action       | result  |
      | 2024-01-20  | tester1@example   | login        | success |
      | 2024-01-20  | unknown@hacker    | login        | denied  |
      | 2024-01-21  | tester2@example   | logout       | success |

  # =============================================================================
  # PRE-PRODUCTION TESTING
  # =============================================================================

  @testing @suite @happy-path
  Scenario: Run comprehensive pre-production test suite
    Given staging environment is ready
    When I initiate pre-production test suite
    Then automated tests should run:
      | test_category    | tests | duration  |
      | functional       | 150   | 15 min    |
      | integration      | 50    | 10 min    |
      | regression       | 200   | 20 min    |
      | security         | 30    | 5 min     |
    And test progress should be displayed
    And a domain event "PreProductionTestCompleted" should be published

  @testing @integration
  Scenario: Run integration tests in staging
    Given staging has platform integrations configured
    When I run integration test suite
    Then all platform integrations should be tested:
      | integration       | status | response_time |
      | authentication    | pass   | 150ms         |
      | payments          | pass   | 320ms         |
      | leaderboards      | pass   | 85ms          |
      | achievements      | pass   | 90ms          |
    And external API connections should be verified
    And payment flows should be tested in sandbox mode

  @testing @regression
  Scenario: Run regression tests
    Given previous test baseline exists from version 2.0.0
    When I run regression tests
    Then tests should compare against baseline:
      | metric              | baseline | current | status  |
      | functional_tests    | 150/150  | 148/150 | warning |
      | performance_avg     | 200ms    | 185ms   | improved|
      | error_rate          | 0.5%     | 0.3%    | improved|
    And regressions should be highlighted with details
    And new issues should be flagged

  @testing @security
  Scenario: Run security tests
    Given staging has security testing enabled
    When I run security test suite
    Then vulnerability scans should execute:
      | scan_type           | findings | severity |
      | sql_injection       | 0        | -        |
      | xss                 | 1        | low      |
      | authentication      | 0        | -        |
      | authorization       | 0        | -        |
    And security report should be generated
    And critical vulnerabilities should block sign-off

  @testing @custom
  Scenario: Run custom test scenarios
    Given I have defined custom test scenarios
    When I run custom tests:
      | scenario_name       | steps | expected_outcome |
      | new_user_journey    | 10    | complete_tutorial|
      | purchase_flow       | 5     | successful_buy   |
      | multiplayer_session | 8     | stable_gameplay  |
    Then custom scenarios should execute
    And results should be recorded for each scenario

  # =============================================================================
  # PERFORMANCE VALIDATION
  # =============================================================================

  @performance @validation @happy-path
  Scenario: Validate world performance in staging
    Given staging is running with 5,000 test user records
    When I run performance validation
    Then I should see performance metrics:
      | metric              | value   | target  | status  |
      | avg_response_time   | 180ms   | <200ms  | pass    |
      | p95_latency         | 450ms   | <500ms  | pass    |
      | throughput          | 500 rps | >400rps | pass    |
      | error_rate          | 0.2%    | <1%     | pass    |
    And resource utilization should be tracked
    And performance report should be generated

  @performance @load-test
  Scenario: Conduct load testing in staging
    Given staging environment is stable
    When I run load test with:
      | parameter          | value |
      | concurrent_users   | 500   |
      | duration_minutes   | 30    |
      | ramp_up_minutes    | 5     |
    Then load should be applied gradually:
      | time_elapsed | users | response_time |
      | 5 min        | 100   | 150ms         |
      | 10 min       | 200   | 180ms         |
      | 20 min       | 400   | 250ms         |
      | 30 min       | 500   | 320ms         |
    And breaking points should be identified

  @performance @sla
  Scenario: Validate performance against SLAs
    Given SLA targets are defined:
      | metric              | target      |
      | availability        | 99.9%       |
      | response_time_avg   | < 200ms     |
      | response_time_p99   | < 1000ms    |
      | error_rate          | < 0.1%      |
    When performance tests complete
    Then SLA compliance should be reported:
      | metric              | result  | compliant |
      | availability        | 99.95%  | yes       |
      | response_time_avg   | 175ms   | yes       |
      | response_time_p99   | 850ms   | yes       |
      | error_rate          | 0.05%   | yes       |

  @performance @stress
  Scenario: Conduct stress testing
    Given I want to find system limits
    When I run stress test:
      | parameter          | value           |
      | max_users          | 2000            |
      | ramp_pattern       | aggressive      |
      | monitor_resources  | true            |
    Then system breaking point should be identified
    And recovery behavior should be observed
    And recommendations should be provided

  # =============================================================================
  # CONTENT VALIDATION
  # =============================================================================

  @content @validation @happy-path
  Scenario: Validate all world content in staging
    Given content is deployed to staging
    When I run content validation
    Then all assets should be verified:
      | asset_type    | total  | valid | issues |
      | images        | 500    | 498   | 2      |
      | audio         | 100    | 100   | 0      |
      | models        | 200    | 199   | 1      |
      | scripts       | 150    | 150   | 0      |
    And broken links should be detected
    And content report should be generated

  @content @localization
  Scenario: Validate localization in staging
    Given world supports languages:
      | language | code  |
      | English  | en-US |
      | Spanish  | es-ES |
      | French   | fr-FR |
      | German   | de-DE |
    When I validate localization
    Then each language should be tested:
      | language | coverage | issues |
      | en-US    | 100%     | 0      |
      | es-ES    | 95%      | 12     |
      | fr-FR    | 92%      | 18     |
      | de-DE    | 88%      | 25     |
    And display issues should be captured with screenshots

  @content @policy
  Scenario: Validate content against policies
    Given platform content policies are defined
    When I run policy compliance check
    Then content should be scanned:
      | policy_area     | status    | findings |
      | age_rating      | compliant | 0        |
      | violence        | warning   | 2        |
      | language        | compliant | 0        |
      | copyright       | compliant | 0        |
    And compliance score should be: 98%

  # =============================================================================
  # USER ACCEPTANCE TESTING
  # =============================================================================

  @uat @session @happy-path
  Scenario: Conduct user acceptance testing session
    Given 10 beta testers have staging access
    When I initiate UAT session:
      | session_name     | Pre-launch UAT        |
      | duration         | 5 days                |
      | scenarios        | 25                    |
    Then testers should receive test scenarios
    And feedback collection should be enabled
    And session dashboard should be available

  @uat @feedback
  Scenario: Collect and manage UAT feedback
    Given UAT session is in progress
    When testers submit feedback:
      | tester          | feedback_type | severity |
      | tester1         | bug           | high     |
      | tester2         | suggestion    | low      |
      | tester3         | bug           | medium   |
    Then feedback should be captured with context:
      | field           | captured |
      | screenshot      | yes      |
      | session_replay  | yes      |
      | system_info     | yes      |
    And feedback should be categorized automatically

  @uat @progress
  Scenario: Track UAT completion and coverage
    Given UAT has 25 test scenarios
    And 5 testers are participating
    When I view UAT progress
    Then I should see completion status:
      | scenario_group    | completed | total |
      | core_functionality| 15        | 15    |
      | edge_cases        | 5         | 5     |
      | new_features      | 3         | 5     |
    And tester participation should be tracked:
      | tester    | scenarios_completed | feedback_submitted |
      | tester1   | 20                  | 5                  |
      | tester2   | 18                  | 3                  |

  @uat @close
  Scenario: Close UAT and summarize results
    Given UAT period has ended
    And all critical scenarios are completed
    When I close UAT
    Then feedback should be summarized:
      | category      | count | status     |
      | critical_bugs | 2     | must_fix   |
      | major_bugs    | 5     | should_fix |
      | minor_bugs    | 10    | nice_to_fix|
      | suggestions   | 15    | evaluate   |
    And UAT sign-off status should be determined

  # =============================================================================
  # HEALTH MONITORING
  # =============================================================================

  @monitoring @dashboard @happy-path
  Scenario: Monitor staging environment health
    Given staging environment is running
    When I view monitoring dashboard
    Then I should see real-time metrics:
      | metric          | value   | status  |
      | cpu_usage       | 35%     | healthy |
      | memory_usage    | 60%     | healthy |
      | disk_usage      | 45%     | healthy |
      | network_io      | 50 Mbps | healthy |
      | active_sessions | 15      | normal  |
    And error rates should be displayed
    And alerts should be configurable

  @monitoring @alerts
  Scenario: Configure staging alerts
    Given I want proactive notifications
    When I configure staging alerts:
      | metric         | threshold | action     |
      | error_rate     | 5%        | notify     |
      | cpu_usage      | 80%       | warn       |
      | memory_usage   | 90%       | critical   |
      | disk_usage     | 85%       | warn       |
    Then alerts should trigger at thresholds
    And I should receive notifications via:
      | channel  | enabled |
      | email    | yes     |
      | slack    | yes     |
      | sms      | no      |

  @monitoring @logs
  Scenario: View staging logs and traces
    Given staging is handling test requests
    When I view staging logs
    Then I should see log entries:
      | level   | count  | sample_message              |
      | info    | 1,500  | Request processed           |
      | warn    | 50     | Slow query detected         |
      | error   | 5      | Connection timeout          |
    And I should be able to filter by:
      | filter_type | options              |
      | level       | info, warn, error    |
      | time_range  | last hour, day, week |
      | component   | api, database, cache |
    And request traces should be available

  # =============================================================================
  # DEPLOYMENT PIPELINE
  # =============================================================================

  @pipeline @status @happy-path
  Scenario: View deployment pipeline status
    Given deployment pipeline is configured
    When I view pipeline status
    Then I should see:
      | field              | value                |
      | current_version    | 2.1.0                |
      | deployed_at        | 2024-01-20 10:00 UTC |
      | deployed_by        | owner                |
      | pipeline_status    | healthy              |
    And I should see deployment history
    And pending deployments should be listed

  @pipeline @deploy
  Scenario: Deploy new version to staging
    Given version 2.2.0 is available for deployment
    When I deploy to staging
    Then deployment should follow pipeline stages:
      | stage           | status     | duration |
      | build           | completed  | 2 min    |
      | test            | completed  | 5 min    |
      | deploy          | completed  | 3 min    |
      | health_check    | completed  | 1 min    |
    And rollback should be available if needed
    And deployment should be logged

  @pipeline @rollback
  Scenario: Rollback staging deployment
    Given version 2.2.0 is deployed but has issues
    When I initiate rollback to version 2.1.0
    Then rollback should execute:
      | phase           | status     |
      | stop_current    | completed  |
      | restore_previous| completed  |
      | verify_health   | completed  |
    And rollback should complete within 5 minutes
    And rollback reason should be logged

  @pipeline @compare
  Scenario: Compare staging and production versions
    Given staging runs version 2.2.0
    And production runs version 2.1.0
    When I compare staging to production
    Then I should see version differences:
      | category        | changes |
      | code_changes    | 45      |
      | config_changes  | 3       |
      | content_changes | 12      |
    And critical changes should be highlighted

  # =============================================================================
  # ISSUE TRACKING
  # =============================================================================

  @issues @list @happy-path
  Scenario: Track issues found in staging
    Given testing has identified 15 issues
    When I view staging issues
    Then I should see all reported issues:
      | severity | count | status       |
      | critical | 2     | in_progress  |
      | high     | 5     | open         |
      | medium   | 5     | open         |
      | low      | 3     | backlog      |
    And issues should link to staging environment

  @issues @create
  Scenario: Create issue from staging finding
    Given I found a bug during testing
    When I create an issue:
      | field       | value                        |
      | title       | Login fails on mobile Safari |
      | severity    | high                         |
      | category    | functionality                |
      | steps       | 1. Open on iOS Safari 2. Tap login 3. Error appears |
      | expected    | Should navigate to dashboard |
      | actual      | Shows blank screen           |
    Then issue should be created and tracked
    And issue should include:
      | attachment     | included |
      | screenshot     | yes      |
      | environment    | staging  |
      | version        | 2.2.0    |

  @issues @verify
  Scenario: Verify issue resolution in staging
    Given issue "Login fails on mobile" has been fixed
    And fix is deployed to staging
    When I verify the fix in staging
    Then I should be able to test the scenario
    And mark issue as verified:
      | verification_status | passed           |
      | verified_by         | owner            |
      | verified_at         | current_time     |
    And issue status should update to "verified"

  @issues @report
  Scenario: Generate staging issues report
    Given testing has been ongoing for 2 weeks
    When I generate issues report
    Then report should include:
      | section              | content              |
      | summary              | Total issues: 15     |
      | by_severity          | Critical: 2, High: 5 |
      | by_status            | Open: 8, Closed: 7   |
      | blocking_issues      | 2 blockers listed    |
      | resolution_trend     | Chart included       |

  # =============================================================================
  # PRODUCTION SIGN-OFF
  # =============================================================================

  @signoff @checklist @happy-path
  Scenario: Complete staging sign-off for production readiness
    Given all staging tests have passed
    And all critical issues are resolved
    When I initiate production sign-off
    Then sign-off checklist should be presented:
      | item                      | status    |
      | functional_tests_passed   | complete  |
      | performance_validated     | complete  |
      | security_scan_passed      | complete  |
      | uat_completed             | complete  |
      | critical_issues_resolved  | complete  |
    And sign-off should be recorded with timestamp

  @signoff @stakeholders
  Scenario: Obtain stakeholder sign-off
    Given sign-off requires multiple stakeholders:
      | stakeholder     | role              |
      | qa_lead         | Quality Assurance |
      | product_owner   | Product           |
      | tech_lead       | Engineering       |
    When I request stakeholder approvals
    Then approval requests should be sent
    And approval status should be tracked:
      | stakeholder     | status    |
      | qa_lead         | approved  |
      | product_owner   | pending   |
      | tech_lead       | approved  |

  @signoff @blocked
  Scenario: Block sign-off with unresolved blockers
    Given 2 critical issues remain unresolved:
      | issue_id | title                   |
      | ISS-001  | Payment processing fails|
      | ISS-002  | Data loss on save       |
    When I attempt sign-off
    Then sign-off should be blocked
    And blocker issues should be displayed
    And I should see message "Resolve 2 critical issues before sign-off"
    And override should require elevated permissions

  # =============================================================================
  # RESOURCE CLEANUP
  # =============================================================================

  @cleanup @terminate @happy-path
  Scenario: Terminate staging environment
    Given staging testing is complete
    And sign-off has been obtained
    When I initiate staging termination
    Then I should confirm termination
    And data should be archived per policy
    And resources should be released
    And a domain event "StagingEnvironmentTerminated" should be published

  @cleanup @auto
  Scenario: Configure automatic staging cleanup
    Given I want automatic resource management
    When I configure auto-cleanup:
      | trigger              | value        |
      | inactive_days        | 7            |
      | after_signoff        | 24_hours     |
      | archive_data         | true         |
      | notify_before        | 24_hours     |
    Then cleanup should be scheduled
    And I should receive warning notification before cleanup

  @cleanup @extend
  Scenario: Extend staging retention
    Given staging is scheduled for cleanup in 24 hours
    And I need more testing time
    When I extend staging retention by 7 days
    Then staging should not be auto-terminated
    And extended cost should be displayed:
      | extension    | 7 days  |
      | extra_cost   | $108.00 |
    And extension should be logged

  @cleanup @archive
  Scenario: Archive staging data before cleanup
    Given staging contains valuable test data
    When I archive staging data
    Then data should be exported and stored:
      | data_type       | archived |
      | test_results    | yes      |
      | logs            | yes      |
      | configurations  | yes      |
      | feedback        | yes      |
    And archive should be accessible for 90 days

  # =============================================================================
  # PRODUCTION READINESS
  # =============================================================================

  @readiness @checklist @happy-path
  Scenario: Complete production readiness checklist
    Given staging validation is complete
    When I view production readiness checklist
    Then I should see all required items:
      | item                      | status    | required |
      | all_tests_passed          | complete  | yes      |
      | performance_validated     | complete  | yes      |
      | security_approved         | complete  | yes      |
      | content_validated         | complete  | yes      |
      | uat_signed_off            | complete  | yes      |
      | documentation_updated     | complete  | yes      |
    And overall readiness score should be: 100%

  @readiness @package
  Scenario: Generate production deployment package
    Given all readiness criteria are met
    When I generate deployment package
    Then package should include:
      | component             | included |
      | application_build     | yes      |
      | configuration         | yes      |
      | database_migrations   | yes      |
      | content_assets        | yes      |
      | deployment_scripts    | yes      |
    And rollback plan should be documented

  @readiness @deploy
  Scenario: Initiate production deployment from staging
    Given production readiness is confirmed
    And sign-off is complete
    When I initiate production deployment
    Then deployment should be scheduled:
      | field            | value                |
      | scheduled_time   | 2024-01-25 02:00 UTC |
      | maintenance_window | 2 hours            |
    And production team should be notified
    And deployment tracking should begin

  # =============================================================================
  # DOMAIN EVENTS
  # =============================================================================

  @domain-events @created
  Scenario: StagingEnvironmentCreated triggers setup
    Given a staging environment is requested
    When "StagingEnvironmentCreated" event is published
    Then monitoring should be configured
    And access logging should begin
    And resource tracking should start
    And owner should be notified

  @domain-events @test-completed
  Scenario: StagingTestCompleted triggers readiness update
    Given staging tests have finished
    When "StagingTestCompleted" event is published
    Then readiness checklist should update
    And test results should be stored
    And stakeholders should be notified:
      | stakeholder  | notification           |
      | owner        | Test results summary   |
      | qa_lead      | Detailed test report   |

  @domain-events @signoff
  Scenario: StagingSignOffCompleted enables production
    Given sign-off is complete
    When "StagingSignOffCompleted" event is published
    Then production deployment should be enabled
    And deployment window should open
    And audit trail should be recorded

  # =============================================================================
  # ERROR HANDLING
  # =============================================================================

  @error @provisioning
  Scenario: Handle staging provisioning failure
    Given infrastructure has capacity issues
    When staging provisioning fails
    Then I should see error details:
      | field          | value                    |
      | error_code     | PROVISION_FAILED         |
      | reason         | Insufficient resources   |
      | suggestion     | Try different region     |
    And I should be able to retry
    And partial resources should be cleaned up

  @error @crash
  Scenario: Handle staging environment crash
    Given staging is running with active sessions
    When staging environment crashes
    Then I should be notified immediately:
      | notification   | details              |
      | channel        | email, slack         |
      | severity       | critical             |
    And crash details should be captured
    And auto-recovery should be attempted
    And I should see recovery status

  @error @sync-failure
  Scenario: Handle data sync failure
    Given data sync from production is in progress
    When sync fails at 60% completion
    Then partial sync should be rolled back
    And I should see failure reason:
      | error          | Connection timeout    |
      | progress       | 60%                   |
      | data_at_risk   | none (rolled back)    |
    And retry options should be offered
