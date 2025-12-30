@admin @infrastructure @automation @platform
Feature: Admin Infrastructure Automation
  As a platform administrator
  I want to automate infrastructure provisioning and management
  So that I can ensure consistent, scalable, and efficient infrastructure operations

  Background:
    Given I am logged in as a platform administrator
    And I have infrastructure automation permissions
    And the infrastructure automation system is operational
    And the following cloud providers are configured:
      | provider | status    | regions                    |
      | AWS      | connected | us-east-1, us-west-2, eu-west-1 |
      | GCP      | connected | us-central1, europe-west1  |
      | Azure    | connected | eastus, westeurope         |

  # ============================================================================
  # INFRASTRUCTURE AS CODE MANAGEMENT
  # ============================================================================

  @api @iac
  Scenario: Create infrastructure as code template
    Given I have a new infrastructure requirement for "production-cluster"
    When I create an IaC template via "POST /api/v1/admin/infrastructure/iac/templates" with:
      | field           | value                    |
      | name            | production-cluster       |
      | provider        | AWS                      |
      | format          | TERRAFORM                |
      | version         | 1.0.0                    |
      | description     | Production K8s cluster   |
    And I include the following resource definitions:
      | resource_type     | name              | configuration                    |
      | kubernetes_cluster| prod-k8s          | node_count: 5, instance: m5.large|
      | load_balancer     | prod-lb           | type: application, scheme: internet-facing |
      | database          | prod-db           | engine: postgresql, version: 14  |
      | vpc               | prod-vpc          | cidr: 10.0.0.0/16               |
    Then the response status should be 201
    And the template should be stored in the template repository
    And the template should pass syntax validation
    And a domain event "IaCTemplateCreated" should be emitted

  @api @iac
  Scenario: Validate infrastructure as code template before deployment
    Given an IaC template "web-application-stack" exists
    When I request validation via "POST /api/v1/admin/infrastructure/iac/templates/web-application-stack/validate"
    Then the response status should be 200
    And the validation should check:
      | check_type          | result  | details                        |
      | syntax_validation   | PASSED  | No syntax errors               |
      | security_scan       | PASSED  | No vulnerabilities detected    |
      | cost_estimate       | $450/mo | Based on resource definitions  |
      | compliance_check    | PASSED  | Meets SOC2 requirements        |
      | dependency_check    | PASSED  | All dependencies available     |

  @api @iac
  Scenario: Deploy infrastructure from IaC template
    Given an IaC template "microservices-platform" exists and is validated
    And the target environment "staging" is available
    When I deploy the template via "POST /api/v1/admin/infrastructure/iac/deploy" with:
      | field           | value                  |
      | template_id     | microservices-platform |
      | environment     | staging                |
      | region          | us-east-1              |
      | approval_bypass | false                  |
    Then the response status should be 202
    And a deployment plan should be generated
    And the plan should require approval from authorized personnel
    And a domain event "IaCDeploymentInitiated" should be emitted

  @api @iac
  Scenario: Track IaC template version history
    Given an IaC template "api-gateway" has multiple versions
    When I request version history via "GET /api/v1/admin/infrastructure/iac/templates/api-gateway/versions"
    Then the response status should be 200
    And the response should contain version history:
      | version | created_at          | author      | changes                    |
      | 3.0.0   | 2024-01-15T10:00:00Z| admin-ops   | Added rate limiting config |
      | 2.1.0   | 2024-01-10T14:30:00Z| admin-ops   | Updated security groups    |
      | 2.0.0   | 2024-01-05T09:00:00Z| platform-eng| Major refactoring          |
      | 1.0.0   | 2024-01-01T00:00:00Z| platform-eng| Initial version            |

  @api @iac
  Scenario: Rollback infrastructure to previous IaC version
    Given infrastructure "payment-service" is deployed with version "2.0.0"
    And version "1.5.0" is available for rollback
    When I initiate rollback via "POST /api/v1/admin/infrastructure/iac/rollback" with:
      | field           | value            |
      | deployment_id   | payment-service  |
      | target_version  | 1.5.0            |
      | reason          | Performance regression |
    Then the response status should be 202
    And a rollback plan should be generated
    And the system should preserve current state for recovery
    And a domain event "IaCRollbackInitiated" should be emitted

  @domain @iac
  Scenario: Detect IaC drift from deployed infrastructure
    Given infrastructure "data-pipeline" was deployed from template version "1.2.0"
    And manual changes have been made to the infrastructure
    When the drift detection scan runs
    Then the system should detect the following drift:
      | resource          | attribute       | expected    | actual      |
      | worker-nodes      | instance_count  | 3           | 5           |
      | security-group    | inbound_rules   | 3 rules     | 5 rules     |
      | storage-bucket    | versioning      | enabled     | disabled    |
    And a drift report should be generated
    And a domain event "InfrastructureDriftDetected" should be emitted
    And administrators should be notified

  # ============================================================================
  # AUTO-SCALING POLICIES
  # ============================================================================

  @api @autoscaling
  Scenario: Configure horizontal pod autoscaler policy
    Given a Kubernetes deployment "game-server" exists
    When I configure autoscaling via "POST /api/v1/admin/infrastructure/autoscaling/policies" with:
      | field                | value              |
      | target_resource      | game-server        |
      | scaling_type         | HORIZONTAL_POD     |
      | min_replicas         | 2                  |
      | max_replicas         | 20                 |
      | target_cpu_percent   | 70                 |
      | target_memory_percent| 80                 |
      | scale_up_cooldown    | 60 seconds         |
      | scale_down_cooldown  | 300 seconds        |
    Then the response status should be 201
    And the autoscaling policy should be active
    And a domain event "AutoscalingPolicyCreated" should be emitted

  @api @autoscaling
  Scenario: Configure cluster autoscaler for node pools
    Given a Kubernetes cluster "production-cluster" exists
    When I configure cluster autoscaling via "POST /api/v1/admin/infrastructure/autoscaling/cluster" with:
      | field               | value                    |
      | cluster_id          | production-cluster       |
      | min_nodes           | 3                        |
      | max_nodes           | 50                       |
      | scale_down_enabled  | true                     |
      | scale_down_delay    | 10 minutes               |
      | node_pool_configs   | [standard, high-memory]  |
    And I specify node pool configurations:
      | pool_name    | min_nodes | max_nodes | instance_type | priority |
      | standard     | 2         | 30        | m5.large      | 1        |
      | high-memory  | 1         | 20        | r5.xlarge     | 2        |
    Then the response status should be 201
    And the cluster autoscaler should be configured
    And a domain event "ClusterAutoscalerConfigured" should be emitted

  @api @autoscaling
  Scenario: Configure predictive autoscaling based on historical patterns
    Given historical traffic data for "api-gateway" is available
    When I enable predictive autoscaling via "POST /api/v1/admin/infrastructure/autoscaling/predictive" with:
      | field                  | value              |
      | target_resource        | api-gateway        |
      | prediction_window      | 30 minutes         |
      | confidence_threshold   | 0.85               |
      | data_lookback_period   | 30 days            |
      | seasonal_adjustment    | true               |
    Then the response status should be 201
    And the system should analyze traffic patterns
    And a predictive model should be created
    And a domain event "PredictiveAutoscalingEnabled" should be emitted

  @domain @autoscaling
  Scenario: Autoscaling responds to traffic spike
    Given a service "user-authentication" has autoscaling configured
    And current replica count is 3
    And CPU utilization exceeds 80% for 2 minutes
    When the autoscaler evaluates metrics
    Then the replica count should increase to 6
    And the scale-up should complete within 60 seconds
    And a domain event "AutoscaleUpTriggered" should be emitted with:
      | field           | value              |
      | resource        | user-authentication|
      | previous_count  | 3                  |
      | new_count       | 6                  |
      | trigger_reason  | CPU_THRESHOLD      |

  @api @autoscaling
  Scenario: View autoscaling history and metrics
    Given autoscaling events have occurred for "payment-processor"
    When I request autoscaling history via "GET /api/v1/admin/infrastructure/autoscaling/history/payment-processor"
    Then the response status should be 200
    And the response should contain scaling events:
      | timestamp            | action     | from_count | to_count | trigger          |
      | 2024-01-15T14:30:00Z | SCALE_UP   | 5          | 10       | CPU > 75%        |
      | 2024-01-15T18:00:00Z | SCALE_DOWN | 10         | 6        | CPU < 30%        |
      | 2024-01-16T09:00:00Z | SCALE_UP   | 6          | 12       | Predictive       |
    And metrics should include average response times during scaling

  @api @autoscaling @error
  Scenario: Prevent autoscaling policy with invalid configuration
    Given a deployment "critical-service" exists
    When I attempt to configure autoscaling via "POST /api/v1/admin/infrastructure/autoscaling/policies" with:
      | field           | value           |
      | target_resource | critical-service|
      | min_replicas    | 10              |
      | max_replicas    | 5               |
    Then the response status should be 400
    And the response should contain error:
      | field   | value                                |
      | code    | INVALID_SCALING_CONFIGURATION        |
      | message | min_replicas cannot exceed max_replicas |

  # ============================================================================
  # RESOURCE PROVISIONING WORKFLOWS
  # ============================================================================

  @api @provisioning
  Scenario: Create automated resource provisioning workflow
    Given I need to provision resources for a new service
    When I create a provisioning workflow via "POST /api/v1/admin/infrastructure/provisioning/workflows" with:
      | field           | value                      |
      | name            | new-service-provisioning   |
      | trigger_type    | MANUAL                     |
      | approval_required| true                      |
      | timeout         | 30 minutes                 |
    And I define the provisioning steps:
      | step_order | action              | resource_type    | parameters                        |
      | 1          | CREATE_NAMESPACE    | kubernetes       | name: ${service_name}             |
      | 2          | PROVISION_DATABASE  | postgresql       | size: medium, replicas: 2         |
      | 3          | CREATE_SECRETS      | vault            | paths: [db-creds, api-keys]       |
      | 4          | DEPLOY_SERVICE      | kubernetes       | manifest: ${service_manifest}     |
      | 5          | CONFIGURE_MONITORING| prometheus       | dashboard: ${service_name}        |
    Then the response status should be 201
    And the workflow should be saved and ready for execution
    And a domain event "ProvisioningWorkflowCreated" should be emitted

  @api @provisioning
  Scenario: Execute resource provisioning workflow
    Given a provisioning workflow "new-service-provisioning" exists
    And the workflow has been approved
    When I execute the workflow via "POST /api/v1/admin/infrastructure/provisioning/workflows/new-service-provisioning/execute" with:
      | field         | value              |
      | service_name  | order-processing   |
      | environment   | staging            |
    Then the response status should be 202
    And the provisioning should begin executing steps in order
    And each step should report progress
    And a domain event "ProvisioningWorkflowStarted" should be emitted

  @domain @provisioning
  Scenario: Track provisioning workflow progress
    Given a provisioning workflow is in progress for "inventory-service"
    When I check the workflow status
    Then I should see the following step statuses:
      | step                 | status     | duration  | details                    |
      | CREATE_NAMESPACE     | COMPLETED  | 5s        | Namespace created          |
      | PROVISION_DATABASE   | COMPLETED  | 120s      | PostgreSQL provisioned     |
      | CREATE_SECRETS       | IN_PROGRESS| 15s       | Creating vault secrets     |
      | DEPLOY_SERVICE       | PENDING    | -         | Waiting for secrets        |
      | CONFIGURE_MONITORING | PENDING    | -         | Waiting for deployment     |
    And the overall progress should be 50%

  @api @provisioning
  Scenario: Handle provisioning failure with automatic rollback
    Given a provisioning workflow is executing for "analytics-service"
    And the "DEPLOY_SERVICE" step fails due to resource constraints
    When the workflow detects the failure
    Then the system should automatically initiate rollback
    And completed steps should be rolled back in reverse order:
      | step                 | rollback_action        | status     |
      | CREATE_SECRETS       | DELETE_SECRETS         | COMPLETED  |
      | PROVISION_DATABASE   | DELETE_DATABASE        | COMPLETED  |
      | CREATE_NAMESPACE     | DELETE_NAMESPACE       | COMPLETED  |
    And a domain event "ProvisioningRollbackCompleted" should be emitted
    And administrators should be notified of the failure

  @api @provisioning
  Scenario: Provision resources with quota validation
    Given a team "backend-team" has the following resource quotas:
      | resource_type | limit    | current_usage |
      | cpu_cores     | 100      | 75            |
      | memory_gb     | 500      | 400           |
      | storage_gb    | 2000     | 1500          |
    When the team requests provisioning via "POST /api/v1/admin/infrastructure/provisioning/request" with:
      | field         | value        |
      | team_id       | backend-team |
      | cpu_cores     | 30           |
      | memory_gb     | 150          |
      | storage_gb    | 400          |
    Then the response status should be 400
    And the response should indicate quota exceeded for:
      | resource    | requested | available | status   |
      | cpu_cores   | 30        | 25        | EXCEEDED |
      | memory_gb   | 150       | 100       | EXCEEDED |
      | storage_gb  | 400       | 500       | OK       |

  # ============================================================================
  # CONFIGURATION DEPLOYMENT
  # ============================================================================

  @api @config-deployment
  Scenario: Deploy configuration changes across environments
    Given a configuration "feature-flags" exists
    And the configuration has been updated with new values
    When I deploy the configuration via "POST /api/v1/admin/infrastructure/config/deploy" with:
      | field            | value              |
      | config_name      | feature-flags      |
      | target_envs      | [staging, production] |
      | strategy         | ROLLING            |
      | validation_enabled| true              |
    Then the response status should be 202
    And the configuration should deploy to staging first
    And after validation, it should deploy to production
    And a domain event "ConfigurationDeploymentStarted" should be emitted

  @api @config-deployment
  Scenario: Manage configuration with version control
    Given a configuration "service-settings" has multiple versions
    When I request configuration versions via "GET /api/v1/admin/infrastructure/config/service-settings/versions"
    Then the response status should be 200
    And the response should contain:
      | version | environment | deployed_at          | deployed_by | status   |
      | 5.0.0   | production  | 2024-01-15T10:00:00Z | admin-ops   | ACTIVE   |
      | 5.0.0   | staging     | 2024-01-14T16:00:00Z | admin-ops   | ACTIVE   |
      | 4.5.0   | production  | 2024-01-10T09:00:00Z | admin-ops   | ARCHIVED |

  @api @config-deployment
  Scenario: Perform canary configuration deployment
    Given a configuration "api-rate-limits" needs to be updated
    When I deploy with canary strategy via "POST /api/v1/admin/infrastructure/config/deploy" with:
      | field              | value            |
      | config_name        | api-rate-limits  |
      | target_env         | production       |
      | strategy           | CANARY           |
      | canary_percentage  | 10               |
      | evaluation_period  | 15 minutes       |
      | success_criteria   | error_rate < 1%  |
    Then the response status should be 202
    And configuration should apply to 10% of instances
    And the system should monitor error rates
    And a domain event "CanaryConfigDeploymentStarted" should be emitted

  @domain @config-deployment
  Scenario: Automatic configuration rollback on failure
    Given a canary configuration deployment is in progress
    And the error rate exceeds 5% during evaluation
    When the system evaluates the canary
    Then automatic rollback should be triggered
    And all instances should revert to previous configuration
    And a domain event "ConfigurationRollbackTriggered" should be emitted with:
      | field           | value                   |
      | config_name     | api-rate-limits         |
      | rollback_reason | ERROR_RATE_EXCEEDED     |
      | rolled_back_to  | 2.3.0                   |

  @api @config-deployment
  Scenario: Synchronize configuration across clusters
    Given multiple Kubernetes clusters exist:
      | cluster_name     | region      | environment |
      | cluster-east     | us-east-1   | production  |
      | cluster-west     | us-west-2   | production  |
      | cluster-europe   | eu-west-1   | production  |
    When I request configuration sync via "POST /api/v1/admin/infrastructure/config/sync" with:
      | field         | value                            |
      | config_name   | global-settings                  |
      | clusters      | [cluster-east, cluster-west, cluster-europe] |
      | sync_mode     | IMMEDIATE                        |
    Then the response status should be 202
    And configuration should sync to all clusters simultaneously
    And sync status should be tracked per cluster
    And a domain event "ConfigurationSyncInitiated" should be emitted

  # ============================================================================
  # MULTI-ENVIRONMENT DEPLOYMENTS
  # ============================================================================

  @api @multi-env
  Scenario: Orchestrate deployment across multiple environments
    Given an application "payment-gateway" is ready for release
    When I create a deployment pipeline via "POST /api/v1/admin/infrastructure/deployments/pipeline" with:
      | field            | value                    |
      | application      | payment-gateway          |
      | version          | 2.5.0                    |
      | pipeline_type    | PROGRESSIVE              |
    And I define the deployment stages:
      | stage_order | environment | approval_required | validation_tests | wait_period |
      | 1           | dev         | false            | unit, integration| 0           |
      | 2           | staging     | false            | e2e, performance | 1 hour      |
      | 3           | production  | true             | smoke, canary    | 0           |
    Then the response status should be 201
    And the pipeline should be created and ready
    And a domain event "DeploymentPipelineCreated" should be emitted

  @api @multi-env
  Scenario: Execute multi-environment deployment pipeline
    Given a deployment pipeline "payment-gateway-release" exists
    When I trigger the pipeline via "POST /api/v1/admin/infrastructure/deployments/pipeline/payment-gateway-release/execute"
    Then the response status should be 202
    And deployment should begin with the first stage
    And each stage should:
      | action                    | description                        |
      | Deploy to environment     | Apply deployment manifests         |
      | Run validation tests      | Execute configured test suites     |
      | Wait for approval         | If required, pause for approval    |
      | Proceed to next stage     | After validation and wait period   |
    And a domain event "DeploymentPipelineStarted" should be emitted

  @domain @multi-env
  Scenario: Handle deployment failure in staging environment
    Given a deployment pipeline is executing
    And deployment to "staging" environment fails
    When the failure is detected
    Then the pipeline should halt at the failed stage
    And subsequent stages should not execute
    And the deployment should be rolled back in staging
    And stakeholders should be notified via:
      | channel  | recipients           |
      | slack    | #deployments         |
      | email    | ops-team@company.com |
      | pagerduty| on-call-engineer     |
    And a domain event "DeploymentStageFailed" should be emitted

  @api @multi-env
  Scenario: Promote deployment from staging to production
    Given a deployment "order-service-v3.0" has passed staging validation
    And production approval is required
    When I approve promotion via "POST /api/v1/admin/infrastructure/deployments/promote" with:
      | field           | value               |
      | deployment_id   | order-service-v3.0  |
      | from_env        | staging             |
      | to_env          | production          |
      | approval_token  | <valid_token>       |
    Then the response status should be 202
    And deployment to production should begin
    And a domain event "DeploymentPromoted" should be emitted

  @api @multi-env
  Scenario: View deployment status across all environments
    Given deployments exist across multiple environments
    When I request deployment status via "GET /api/v1/admin/infrastructure/deployments/status"
    Then the response status should be 200
    And the response should contain:
      | application       | dev_version | staging_version | prod_version | last_deployed        |
      | payment-gateway   | 2.6.0       | 2.5.0           | 2.4.0        | 2024-01-15T14:00:00Z |
      | order-service     | 3.1.0       | 3.1.0           | 3.0.0        | 2024-01-15T10:00:00Z |
      | user-auth         | 1.8.0       | 1.8.0           | 1.8.0        | 2024-01-14T16:00:00Z |

  # ============================================================================
  # INFRASTRUCTURE AUTOMATION HEALTH MONITORING
  # ============================================================================

  @api @health-monitoring
  Scenario: Monitor infrastructure automation system health
    Given the infrastructure automation system is running
    When I request health status via "GET /api/v1/admin/infrastructure/health"
    Then the response status should be 200
    And the response should contain component health:
      | component               | status  | latency_ms | last_check           |
      | iac_engine              | HEALTHY | 45         | 2024-01-15T14:59:00Z |
      | autoscaler              | HEALTHY | 12         | 2024-01-15T14:59:00Z |
      | provisioning_controller | HEALTHY | 23         | 2024-01-15T14:59:00Z |
      | config_manager          | HEALTHY | 18         | 2024-01-15T14:59:00Z |
      | deployment_orchestrator | HEALTHY | 31         | 2024-01-15T14:59:00Z |

  @api @health-monitoring
  Scenario: View automation job execution metrics
    Given automation jobs have been running
    When I request job metrics via "GET /api/v1/admin/infrastructure/metrics/jobs"
    Then the response status should be 200
    And the response should contain:
      | metric                    | value  | trend    |
      | total_jobs_24h            | 1234   | +5%      |
      | successful_jobs_24h       | 1198   | +3%      |
      | failed_jobs_24h           | 36     | -10%     |
      | average_duration_seconds  | 145    | -5%      |
      | jobs_in_progress          | 12     | stable   |

  @domain @health-monitoring
  Scenario: Detect and alert on automation system degradation
    Given the automation system is being monitored
    When the IaC engine response time exceeds 500ms for 5 minutes
    Then a health alert should be triggered
    And the alert should contain:
      | field         | value                      |
      | severity      | WARNING                    |
      | component     | iac_engine                 |
      | metric        | response_time              |
      | threshold     | 500ms                      |
      | current_value | 650ms                      |
    And on-call personnel should be notified
    And a domain event "AutomationHealthDegraded" should be emitted

  @api @health-monitoring
  Scenario: View automation audit trail
    Given automation activities have occurred
    When I request the audit trail via "GET /api/v1/admin/infrastructure/audit"
    Then the response status should be 200
    And the response should contain audit entries:
      | timestamp            | action              | user        | resource            | outcome |
      | 2024-01-15T14:30:00Z | DEPLOY_TEMPLATE     | admin-ops   | web-app-stack       | SUCCESS |
      | 2024-01-15T14:25:00Z | SCALE_UP            | autoscaler  | api-gateway         | SUCCESS |
      | 2024-01-15T14:20:00Z | CONFIG_UPDATE       | admin-ops   | feature-flags       | SUCCESS |
      | 2024-01-15T14:15:00Z | PROVISION_WORKFLOW  | admin-ops   | new-service-setup   | FAILED  |

  # ============================================================================
  # INFRASTRUCTURE COST OPTIMIZATION
  # ============================================================================

  @api @cost-optimization
  Scenario: Analyze infrastructure cost by service
    Given infrastructure resources are deployed and tagged
    When I request cost analysis via "GET /api/v1/admin/infrastructure/costs/analysis"
    Then the response status should be 200
    And the response should contain cost breakdown:
      | service           | monthly_cost | trend    | optimization_potential |
      | payment-gateway   | $2,450       | +5%      | $300                   |
      | order-service     | $1,800       | -2%      | $150                   |
      | user-auth         | $950         | stable   | $50                    |
      | data-pipeline     | $3,200       | +15%     | $800                   |

  @api @cost-optimization
  Scenario: Configure automated cost optimization rules
    Given I want to optimize infrastructure costs
    When I create optimization rules via "POST /api/v1/admin/infrastructure/costs/rules" with:
      | field              | value                    |
      | rule_name          | idle-resource-cleanup    |
      | trigger_condition  | cpu_usage < 5% for 7 days|
      | action             | SCHEDULE_TERMINATION     |
      | notification_lead  | 48 hours                 |
      | excluded_tags      | [critical, always-on]    |
    Then the response status should be 201
    And the optimization rule should be active
    And a domain event "CostOptimizationRuleCreated" should be emitted

  @domain @cost-optimization
  Scenario: Automatically right-size over-provisioned resources
    Given a resource "analytics-worker" is over-provisioned
    And actual usage shows:
      | metric       | provisioned | actual_usage | recommended |
      | cpu_cores    | 8           | 2            | 4           |
      | memory_gb    | 32          | 8            | 16          |
    When the cost optimization analyzer runs
    Then a right-sizing recommendation should be generated
    And the recommendation should include:
      | field               | value                    |
      | current_cost        | $500/month               |
      | recommended_cost    | $250/month               |
      | savings             | $250/month               |
      | confidence          | HIGH                     |
    And a domain event "RightSizingRecommendation" should be emitted

  @api @cost-optimization
  Scenario: Schedule resources for off-hours shutdown
    Given a development environment has non-essential resources
    When I configure scheduling via "POST /api/v1/admin/infrastructure/costs/scheduling" with:
      | field             | value                  |
      | resource_selector | environment=dev        |
      | shutdown_schedule | 0 20 * * 1-5           |
      | startup_schedule  | 0 8 * * 1-5            |
      | timezone          | America/New_York       |
    Then the response status should be 201
    And development resources should shut down at 8 PM EST weekdays
    And resources should restart at 8 AM EST weekdays
    And estimated monthly savings should be calculated

  @api @cost-optimization
  Scenario: View cost optimization recommendations
    Given cost analysis has generated recommendations
    When I request recommendations via "GET /api/v1/admin/infrastructure/costs/recommendations"
    Then the response status should be 200
    And the response should contain:
      | recommendation_type    | resources_affected | potential_savings | priority |
      | RIGHT_SIZE             | 15                 | $2,500/month     | HIGH     |
      | RESERVED_INSTANCES     | 8                  | $3,000/month     | MEDIUM   |
      | SPOT_INSTANCES         | 12                 | $1,800/month     | MEDIUM   |
      | UNUSED_RESOURCES       | 5                  | $800/month       | HIGH     |
      | STORAGE_OPTIMIZATION   | 20                 | $500/month       | LOW      |

  # ============================================================================
  # BACKUP AND DISASTER RECOVERY AUTOMATION
  # ============================================================================

  @api @backup-dr
  Scenario: Configure automated backup policy
    Given a database "production-db" needs backup protection
    When I create a backup policy via "POST /api/v1/admin/infrastructure/backup/policies" with:
      | field              | value                |
      | policy_name        | prod-db-backup       |
      | resource_id        | production-db        |
      | backup_frequency   | HOURLY               |
      | retention_days     | 30                   |
      | cross_region       | true                 |
      | backup_regions     | [us-west-2, eu-west-1] |
      | encryption         | AES-256              |
    Then the response status should be 201
    And the backup policy should be active
    And a domain event "BackupPolicyCreated" should be emitted

  @domain @backup-dr
  Scenario: Execute scheduled backup
    Given a backup policy "prod-db-backup" is configured
    When the scheduled backup time arrives
    Then the backup should be initiated automatically
    And the backup should:
      | step                    | status     | duration |
      | Create snapshot         | COMPLETED  | 30s      |
      | Encrypt backup          | COMPLETED  | 15s      |
      | Upload to primary region| COMPLETED  | 120s     |
      | Replicate to DR region  | COMPLETED  | 180s     |
      | Verify integrity        | COMPLETED  | 45s      |
    And a domain event "BackupCompleted" should be emitted

  @api @backup-dr
  Scenario: Configure disaster recovery plan
    Given critical infrastructure needs DR protection
    When I create a DR plan via "POST /api/v1/admin/infrastructure/dr/plans" with:
      | field              | value                  |
      | plan_name          | critical-systems-dr    |
      | rpo_hours          | 1                      |
      | rto_hours          | 4                      |
      | primary_region     | us-east-1              |
      | dr_region          | us-west-2              |
      | failover_type      | WARM_STANDBY           |
    And I define protected resources:
      | resource_type | resource_name     | priority | sync_mode   |
      | database      | production-db     | 1        | SYNCHRONOUS |
      | storage       | user-data-bucket  | 2        | ASYNCHRONOUS|
      | compute       | api-servers       | 3        | ON_DEMAND   |
    Then the response status should be 201
    And the DR plan should be created and tested
    And a domain event "DRPlanCreated" should be emitted

  @api @backup-dr
  Scenario: Initiate disaster recovery failover
    Given a disaster has been declared in the primary region
    And DR plan "critical-systems-dr" is activated
    When I initiate failover via "POST /api/v1/admin/infrastructure/dr/failover" with:
      | field            | value               |
      | plan_id          | critical-systems-dr |
      | failover_type    | FULL                |
      | reason           | PRIMARY_REGION_OUTAGE |
    Then the response status should be 202
    And failover should execute in priority order:
      | resource          | action             | status     |
      | production-db     | PROMOTE_REPLICA    | COMPLETED  |
      | user-data-bucket  | ENABLE_DR_COPY     | COMPLETED  |
      | api-servers       | LAUNCH_DR_INSTANCES| COMPLETED  |
    And DNS should be updated to DR region
    And a domain event "DRFailoverCompleted" should be emitted

  @api @backup-dr
  Scenario: Test disaster recovery plan without actual failover
    Given a DR plan "critical-systems-dr" exists
    When I request DR test via "POST /api/v1/admin/infrastructure/dr/test" with:
      | field           | value                |
      | plan_id         | critical-systems-dr  |
      | test_type       | SIMULATION           |
      | isolated        | true                 |
    Then the response status should be 202
    And the test should simulate failover in isolation
    And the test report should include:
      | metric           | result    | target   |
      | rto_achieved     | 3.5 hours | 4 hours  |
      | rpo_achieved     | 45 minutes| 1 hour   |
      | data_integrity   | 100%      | 100%     |
      | service_recovery | SUCCESS   | SUCCESS  |
    And production should remain unaffected

  @api @backup-dr
  Scenario: View backup and recovery status dashboard
    Given backup and DR operations are ongoing
    When I request status via "GET /api/v1/admin/infrastructure/backup/status"
    Then the response status should be 200
    And the response should contain:
      | resource        | last_backup          | backup_status | dr_status  | rpo_met |
      | production-db   | 2024-01-15T14:00:00Z | HEALTHY       | SYNCED     | true    |
      | user-data       | 2024-01-15T13:00:00Z | HEALTHY       | SYNCED     | true    |
      | config-store    | 2024-01-15T14:30:00Z | HEALTHY       | SYNCED     | true    |
      | analytics-db    | 2024-01-15T10:00:00Z | WARNING       | LAG_4_HOURS| false   |

  # ============================================================================
  # SECURITY AUTOMATION
  # ============================================================================

  @api @security-automation
  Scenario: Configure automated security scanning
    Given infrastructure resources need security scanning
    When I configure security scanning via "POST /api/v1/admin/infrastructure/security/scanning" with:
      | field              | value                    |
      | scan_name          | infrastructure-security  |
      | scan_frequency     | DAILY                    |
      | scan_types         | [vulnerability, compliance, secrets] |
      | severity_threshold | MEDIUM                   |
      | auto_remediate     | true                     |
    Then the response status should be 201
    And security scanning should be scheduled
    And a domain event "SecurityScanningConfigured" should be emitted

  @domain @security-automation
  Scenario: Detect and remediate security vulnerability
    Given a security scan is running
    When a critical vulnerability is detected:
      | field           | value                          |
      | vulnerability_id| CVE-2024-1234                  |
      | severity        | CRITICAL                       |
      | affected_resource| api-gateway-pod               |
      | description     | Remote code execution          |
    Then automatic remediation should be triggered
    And remediation should:
      | step                      | action                    |
      | Isolate affected resource | Network policy applied    |
      | Apply security patch      | Container image updated   |
      | Restart affected pods     | Rolling restart initiated |
      | Verify remediation        | Rescan confirms fix       |
    And a domain event "VulnerabilityRemediated" should be emitted
    And security team should be notified

  @api @security-automation
  Scenario: Automate secret rotation
    Given secrets exist in the vault
    When I configure secret rotation via "POST /api/v1/admin/infrastructure/security/rotation" with:
      | field              | value                |
      | rotation_policy    | api-keys-rotation    |
      | secret_paths       | [api/keys/*, db/creds/*] |
      | rotation_interval  | 30 days              |
      | notification_lead  | 7 days               |
      | auto_update_refs   | true                 |
    Then the response status should be 201
    And secret rotation should be scheduled
    And dependent services should be updated automatically
    And a domain event "SecretRotationConfigured" should be emitted

  @domain @security-automation
  Scenario: Automatically rotate expiring secrets
    Given a secret "database-password" is set to expire in 3 days
    When the rotation scheduler runs
    Then the secret should be rotated:
      | step                    | status     |
      | Generate new secret     | COMPLETED  |
      | Update in vault         | COMPLETED  |
      | Update dependent configs| COMPLETED  |
      | Verify connectivity     | COMPLETED  |
      | Archive old secret      | COMPLETED  |
    And dependent services should continue without interruption
    And a domain event "SecretRotated" should be emitted

  @api @security-automation
  Scenario: Configure network security policy automation
    Given network security needs to be managed
    When I create security policy automation via "POST /api/v1/admin/infrastructure/security/network-policies" with:
      | field                | value                    |
      | policy_name          | zero-trust-network       |
      | default_action       | DENY                     |
      | audit_mode           | false                    |
    And I define allowed traffic patterns:
      | source_namespace | dest_namespace | ports      | protocols |
      | frontend         | backend        | 8080, 8443 | TCP       |
      | backend          | database       | 5432       | TCP       |
      | monitoring       | *              | 9090       | TCP       |
    Then the response status should be 201
    And network policies should be applied across clusters
    And a domain event "NetworkPoliciesApplied" should be emitted

  @api @security-automation
  Scenario: View security posture dashboard
    Given security automation is active
    When I request security posture via "GET /api/v1/admin/infrastructure/security/posture"
    Then the response status should be 200
    And the response should contain:
      | metric                     | value    | status  |
      | critical_vulnerabilities   | 0        | GOOD    |
      | high_vulnerabilities       | 3        | WARNING |
      | secrets_expiring_soon      | 5        | WARNING |
      | compliance_score           | 94%      | GOOD    |
      | last_security_scan         | 2 hours ago | OK   |
      | failed_login_attempts_24h  | 12       | NORMAL  |

  # ============================================================================
  # PERFORMANCE OPTIMIZATION AUTOMATION
  # ============================================================================

  @api @performance
  Scenario: Configure automated performance optimization
    Given services need performance optimization
    When I configure optimization via "POST /api/v1/admin/infrastructure/performance/rules" with:
      | field              | value                    |
      | rule_name          | api-performance-opt      |
      | target_services    | [api-gateway, backend]   |
      | metrics_to_monitor | [latency, throughput, error_rate] |
      | optimization_type  | ADAPTIVE                 |
    Then the response status should be 201
    And performance monitoring should begin
    And a domain event "PerformanceOptimizationConfigured" should be emitted

  @domain @performance
  Scenario: Automatically optimize based on traffic patterns
    Given traffic patterns are being analyzed for "api-gateway"
    And the system detects:
      | pattern           | observation                      |
      | peak_hours        | 9 AM - 11 AM, 2 PM - 4 PM        |
      | low_traffic       | 11 PM - 6 AM                     |
      | burst_frequency   | Every 15 minutes during peaks    |
    When the optimization engine runs
    Then the following optimizations should be applied:
      | optimization               | when                    | action                  |
      | Pre-warm instances         | 8:45 AM, 1:45 PM        | Scale up 20%            |
      | Increase connection pool   | peak hours              | Pool size +50%          |
      | Enable aggressive caching  | peak hours              | TTL +100%               |
      | Reduce resources           | 11 PM                   | Scale down 60%          |
    And a domain event "PerformanceOptimizationsApplied" should be emitted

  @api @performance
  Scenario: Configure database query optimization
    Given database performance needs improvement
    When I configure query optimization via "POST /api/v1/admin/infrastructure/performance/database" with:
      | field              | value                  |
      | database_id        | production-db          |
      | slow_query_threshold| 500ms                 |
      | auto_index         | true                   |
      | query_cache        | ADAPTIVE               |
    Then the response status should be 201
    And query monitoring should begin
    And slow queries should be identified and optimized

  @domain @performance
  Scenario: Automatically add database index for slow queries
    Given query analysis shows a slow query pattern
    And the slow query is:
      | query_pattern                          | avg_duration | frequency   |
      | SELECT * FROM orders WHERE user_id=?   | 2.5s         | 500/minute  |
    When the database optimizer analyzes the query
    Then an index recommendation should be generated:
      | index_name      | table   | columns   | estimated_improvement |
      | idx_orders_user | orders  | user_id   | 95%                   |
    And the index should be created during low-traffic period
    And a domain event "DatabaseIndexCreated" should be emitted

  @api @performance
  Scenario: View performance optimization report
    Given performance optimizations have been applied
    When I request report via "GET /api/v1/admin/infrastructure/performance/report"
    Then the response status should be 200
    And the response should contain:
      | metric                    | before    | after     | improvement |
      | avg_response_time         | 450ms     | 180ms     | 60%         |
      | p99_latency               | 2.5s      | 800ms     | 68%         |
      | throughput_rps            | 5000      | 12000     | 140%        |
      | error_rate                | 2.5%      | 0.3%      | 88%         |
      | resource_utilization      | 85%       | 55%       | 35%         |

  # ============================================================================
  # COMPLIANCE AND GOVERNANCE AUTOMATION
  # ============================================================================

  @api @compliance
  Scenario: Configure compliance policy enforcement
    Given compliance requirements need to be enforced
    When I create compliance policies via "POST /api/v1/admin/infrastructure/compliance/policies" with:
      | field              | value                    |
      | policy_set         | soc2-type2               |
      | enforcement_mode   | ENFORCING                |
      | audit_logging      | true                     |
      | exception_workflow | APPROVAL_REQUIRED        |
    And I define compliance rules:
      | rule_id           | description                    | severity | auto_remediate |
      | ENCRYPT_AT_REST   | All storage must be encrypted  | CRITICAL | true           |
      | ENCRYPT_IN_TRANSIT| All traffic must use TLS       | CRITICAL | true           |
      | ACCESS_LOGGING    | Enable access logging          | HIGH     | true           |
      | MFA_REQUIRED      | MFA for admin access           | CRITICAL | false          |
    Then the response status should be 201
    And compliance policies should be enforced
    And a domain event "CompliancePoliciesConfigured" should be emitted

  @domain @compliance
  Scenario: Detect and remediate compliance violation
    Given compliance monitoring is active
    When a new S3 bucket is created without encryption
    Then the violation should be detected:
      | field           | value                      |
      | rule_violated   | ENCRYPT_AT_REST            |
      | resource        | s3://new-data-bucket       |
      | severity        | CRITICAL                   |
    And automatic remediation should enable encryption
    And a compliance violation report should be generated
    And a domain event "ComplianceViolationRemediated" should be emitted

  @api @compliance
  Scenario: Generate compliance audit report
    Given compliance monitoring has been running
    When I request audit report via "GET /api/v1/admin/infrastructure/compliance/audit-report" with:
      | field           | value              |
      | report_type     | SOC2_TYPE2         |
      | period_start    | 2024-01-01         |
      | period_end      | 2024-01-31         |
    Then the response status should be 200
    And the report should contain:
      | section                   | status    | findings |
      | Access Controls           | COMPLIANT | 0        |
      | Data Encryption           | COMPLIANT | 0        |
      | Change Management         | COMPLIANT | 2 minor  |
      | Incident Response         | COMPLIANT | 0        |
      | Backup and Recovery       | COMPLIANT | 1 minor  |
    And the report should be suitable for auditor review

  @api @compliance
  Scenario: Configure governance guardrails
    Given infrastructure governance needs enforcement
    When I create guardrails via "POST /api/v1/admin/infrastructure/governance/guardrails" with:
      | field              | value                    |
      | guardrail_set      | production-guardrails    |
    And I define guardrail rules:
      | guardrail_id        | description                        | action        |
      | MAX_INSTANCE_SIZE   | Limit instance size to 4xlarge     | DENY          |
      | APPROVED_REGIONS    | Only us-east-1, us-west-2 allowed  | DENY          |
      | REQUIRED_TAGS       | cost-center, owner, environment    | DENY          |
      | PUBLIC_ACCESS       | No public IP without approval      | REQUIRE_APPROVAL |
    Then the response status should be 201
    And guardrails should be enforced on all provisioning requests
    And a domain event "GovernanceGuardrailsConfigured" should be emitted

  @domain @compliance
  Scenario: Block non-compliant resource creation
    Given governance guardrails are active
    When a user attempts to create a resource:
      | field           | value              |
      | instance_type   | m5.8xlarge         |
      | region          | ap-south-1         |
      | tags            | [name: test-server]|
    Then the creation should be blocked
    And the user should receive violation details:
      | guardrail_violated | reason                           |
      | MAX_INSTANCE_SIZE  | m5.8xlarge exceeds 4xlarge limit |
      | APPROVED_REGIONS   | ap-south-1 is not approved       |
      | REQUIRED_TAGS      | Missing: cost-center, owner, environment |
    And a domain event "GuardrailViolationBlocked" should be emitted

  # ============================================================================
  # AUTOMATION WORKFLOWS
  # ============================================================================

  @api @workflows
  Scenario: Create custom automation workflow
    Given I need to create a complex automation workflow
    When I create a workflow via "POST /api/v1/admin/infrastructure/workflows" with:
      | field           | value                      |
      | workflow_name   | incident-response-auto     |
      | trigger_type    | EVENT                      |
      | trigger_event   | HIGH_SEVERITY_ALERT        |
    And I define workflow steps:
      | step_order | step_type    | action                    | condition               |
      | 1          | NOTIFY       | page_on_call_engineer     | always                  |
      | 2          | ANALYZE      | gather_system_metrics     | always                  |
      | 3          | DECISION     | check_auto_remediation    | if known_issue          |
      | 4          | REMEDIATE    | apply_standard_fix        | if auto_remediation=yes |
      | 5          | ESCALATE     | create_incident_ticket    | if auto_remediation=no  |
      | 6          | VERIFY       | run_health_checks         | always                  |
    Then the response status should be 201
    And the workflow should be active and ready
    And a domain event "AutomationWorkflowCreated" should be emitted

  @domain @workflows
  Scenario: Execute automation workflow on trigger
    Given an automation workflow "incident-response-auto" exists
    When a high severity alert is triggered:
      | field         | value                    |
      | alert_type    | SERVICE_DOWN             |
      | service       | payment-gateway          |
      | severity      | HIGH                     |
    Then the workflow should execute automatically
    And workflow execution should be logged:
      | step                    | status     | output                   |
      | page_on_call_engineer   | COMPLETED  | Notification sent        |
      | gather_system_metrics   | COMPLETED  | Metrics collected        |
      | check_auto_remediation  | COMPLETED  | Known issue: pod crash   |
      | apply_standard_fix      | COMPLETED  | Pods restarted           |
      | run_health_checks       | COMPLETED  | Service recovered        |
    And a domain event "WorkflowExecutionCompleted" should be emitted

  @api @workflows
  Scenario: Schedule recurring automation workflow
    Given I need to run maintenance tasks regularly
    When I schedule a workflow via "POST /api/v1/admin/infrastructure/workflows/schedule" with:
      | field           | value                    |
      | workflow_id     | weekly-maintenance       |
      | schedule        | 0 2 * * 0                |
      | timezone        | UTC                      |
      | enabled         | true                     |
    Then the response status should be 201
    And the workflow should be scheduled for Sunday 2 AM UTC
    And a domain event "WorkflowScheduled" should be emitted

  @api @workflows
  Scenario: View workflow execution history
    Given workflows have been executed
    When I request workflow history via "GET /api/v1/admin/infrastructure/workflows/history"
    Then the response status should be 200
    And the response should contain execution records:
      | workflow_name        | triggered_at          | duration | status    | trigger_type |
      | incident-response    | 2024-01-15T14:30:00Z  | 45s      | SUCCESS   | EVENT        |
      | weekly-maintenance   | 2024-01-14T02:00:00Z  | 15m      | SUCCESS   | SCHEDULED    |
      | deployment-pipeline  | 2024-01-13T10:00:00Z  | 1h 30m   | SUCCESS   | MANUAL       |
      | cost-optimization    | 2024-01-13T00:00:00Z  | 5m       | FAILED    | SCHEDULED    |

  # ============================================================================
  # API AND SERVICE INTEGRATIONS
  # ============================================================================

  @api @integrations
  Scenario: Configure external service integration
    Given I need to integrate with external services
    When I create an integration via "POST /api/v1/admin/infrastructure/integrations" with:
      | field           | value                    |
      | integration_name| slack-notifications      |
      | service_type    | SLACK                    |
      | webhook_url     | https://hooks.slack.com/... |
      | events          | [DEPLOYMENT, ALERT, INCIDENT] |
      | channels        | [#ops-alerts, #deployments] |
    Then the response status should be 201
    And the integration should be tested and verified
    And a domain event "IntegrationConfigured" should be emitted

  @api @integrations
  Scenario: Configure CI/CD pipeline integration
    Given I need to integrate with CI/CD systems
    When I create pipeline integration via "POST /api/v1/admin/infrastructure/integrations/cicd" with:
      | field           | value                    |
      | integration_name| github-actions           |
      | provider        | GITHUB                   |
      | repository      | org/infrastructure-repo  |
      | trigger_events  | [push, pull_request]     |
      | target_workflows| [deploy, validate]       |
    Then the response status should be 201
    And webhooks should be configured
    And pipeline triggers should be set up
    And a domain event "CICDIntegrationConfigured" should be emitted

  @api @integrations
  Scenario: Configure monitoring system integration
    Given I need to integrate monitoring systems
    When I create monitoring integration via "POST /api/v1/admin/infrastructure/integrations/monitoring" with:
      | field           | value                    |
      | integration_name| datadog-integration      |
      | provider        | DATADOG                  |
      | api_key         | <encrypted>              |
      | metrics_forward | true                     |
      | logs_forward    | true                     |
      | traces_forward  | true                     |
    Then the response status should be 201
    And metrics should begin flowing to Datadog
    And integration health should be monitored
    And a domain event "MonitoringIntegrationConfigured" should be emitted

  @api @integrations
  Scenario: View integration status and health
    Given multiple integrations are configured
    When I request integration status via "GET /api/v1/admin/infrastructure/integrations/status"
    Then the response status should be 200
    And the response should contain:
      | integration          | status  | last_successful | error_rate_24h |
      | slack-notifications  | HEALTHY | 2 min ago       | 0%             |
      | github-actions       | HEALTHY | 1 hour ago      | 0%             |
      | datadog-integration  | WARNING | 30 min ago      | 2.5%           |
      | pagerduty            | HEALTHY | 5 min ago       | 0%             |

  # ============================================================================
  # EVENT-DRIVEN AUTOMATION
  # ============================================================================

  @api @event-driven
  Scenario: Configure event-driven automation trigger
    Given I need event-driven infrastructure automation
    When I create an event trigger via "POST /api/v1/admin/infrastructure/events/triggers" with:
      | field           | value                    |
      | trigger_name    | high-cpu-response        |
      | event_source    | prometheus               |
      | event_type      | METRIC_THRESHOLD         |
      | condition       | cpu_utilization > 90%    |
      | sustained_for   | 5 minutes                |
      | action          | scale_up                 |
    Then the response status should be 201
    And the trigger should be active
    And a domain event "EventTriggerCreated" should be emitted

  @domain @event-driven
  Scenario: Process infrastructure event and trigger action
    Given an event trigger "high-cpu-response" is configured
    When Prometheus reports CPU > 90% for 5 minutes for "api-gateway"
    Then the event should be processed
    And the configured action should be triggered:
      | action_type | target      | parameters         |
      | SCALE_UP    | api-gateway | increment: 2 pods  |
    And the action should be logged
    And a domain event "EventTriggeredAction" should be emitted

  @api @event-driven
  Scenario: Configure event routing rules
    Given multiple automation systems need events
    When I create event routing via "POST /api/v1/admin/infrastructure/events/routing" with:
      | field           | value                    |
      | routing_name    | infrastructure-events    |
    And I define routing rules:
      | event_pattern         | destination        | transform          |
      | deployment.*          | slack, datadog     | standard           |
      | security.*            | pagerduty, slack   | enriched           |
      | cost.*                | email, dashboard   | summary            |
      | performance.*         | datadog            | metrics            |
    Then the response status should be 201
    And events should be routed according to rules
    And a domain event "EventRoutingConfigured" should be emitted

  @api @event-driven
  Scenario: View event processing metrics
    Given event-driven automation is active
    When I request event metrics via "GET /api/v1/admin/infrastructure/events/metrics"
    Then the response status should be 200
    And the response should contain:
      | metric                    | value    | trend    |
      | events_processed_24h      | 15,234   | +5%      |
      | actions_triggered_24h     | 456      | +12%     |
      | average_processing_time   | 45ms     | -10%     |
      | failed_actions_24h        | 3        | -50%     |
      | event_queue_depth         | 12       | stable   |

  # ============================================================================
  # INFRASTRUCTURE TEMPLATES AND BLUEPRINTS
  # ============================================================================

  @api @templates
  Scenario: Create reusable infrastructure blueprint
    Given I need to create a standard infrastructure pattern
    When I create a blueprint via "POST /api/v1/admin/infrastructure/blueprints" with:
      | field           | value                      |
      | blueprint_name  | microservice-standard      |
      | description     | Standard microservice setup|
      | version         | 1.0.0                      |
      | category        | APPLICATION                |
    And I define blueprint components:
      | component_type    | component_name    | configuration                    |
      | kubernetes_deploy | service-deploy    | replicas: 3, resources: standard |
      | service           | service-svc       | type: ClusterIP, port: 8080      |
      | ingress           | service-ingress   | tls: true, path: /api            |
      | hpa               | service-hpa       | min: 2, max: 10, cpu: 70%        |
      | pdb               | service-pdb       | minAvailable: 1                  |
      | configmap         | service-config    | from_template: true              |
      | secret            | service-secrets   | vault_path: /services/${name}    |
    Then the response status should be 201
    And the blueprint should be available for use
    And a domain event "BlueprintCreated" should be emitted

  @api @templates
  Scenario: Instantiate infrastructure from blueprint
    Given a blueprint "microservice-standard" exists
    When I instantiate the blueprint via "POST /api/v1/admin/infrastructure/blueprints/microservice-standard/instantiate" with:
      | field           | value              |
      | service_name    | order-processor    |
      | namespace       | production         |
      | environment     | prod               |
      | custom_config   | {memory: 2Gi}      |
    Then the response status should be 202
    And all blueprint components should be created
    And variable substitution should be applied
    And a domain event "BlueprintInstantiated" should be emitted

  @api @templates
  Scenario: Browse infrastructure template library
    Given multiple templates and blueprints exist
    When I request template library via "GET /api/v1/admin/infrastructure/templates/library"
    Then the response status should be 200
    And the response should contain categorized templates:
      | category      | template_name          | version | usage_count | rating |
      | APPLICATION   | microservice-standard  | 1.0.0   | 45          | 4.8    |
      | APPLICATION   | api-gateway-template   | 2.1.0   | 32          | 4.6    |
      | DATABASE      | postgres-ha            | 1.2.0   | 28          | 4.9    |
      | DATABASE      | redis-cluster          | 1.0.0   | 22          | 4.7    |
      | NETWORKING    | vpc-standard           | 1.1.0   | 50          | 4.5    |
      | SECURITY      | zero-trust-network     | 1.0.0   | 15          | 4.8    |

  @api @templates
  Scenario: Version and update infrastructure blueprint
    Given a blueprint "microservice-standard" version "1.0.0" exists
    When I update the blueprint via "PUT /api/v1/admin/infrastructure/blueprints/microservice-standard" with:
      | field              | value                    |
      | version            | 1.1.0                    |
      | changelog          | Added service mesh config|
    And I add new components:
      | component_type    | component_name      | configuration           |
      | service_mesh      | istio-sidecar       | mtls: strict            |
    Then the response status should be 200
    And a new version should be created
    And existing instances should not be affected
    And a domain event "BlueprintVersionCreated" should be emitted

  @api @templates
  Scenario: Share blueprint across organizations
    Given a blueprint "microservice-standard" exists
    And the blueprint has been validated and approved
    When I share the blueprint via "POST /api/v1/admin/infrastructure/blueprints/microservice-standard/share" with:
      | field           | value                    |
      | visibility      | ORGANIZATION             |
      | allowed_teams   | [platform, backend, frontend] |
      | require_approval| false                    |
    Then the response status should be 200
    And the blueprint should be available to specified teams
    And usage should be tracked
    And a domain event "BlueprintShared" should be emitted

  # ============================================================================
  # ERROR HANDLING AND RECOVERY
  # ============================================================================

  @error @recovery
  Scenario: Handle infrastructure automation failure
    Given an automation workflow is executing
    When a critical step fails
    Then the system should:
      | action                    | result                        |
      | Halt workflow execution   | Prevent further damage        |
      | Capture failure details   | Log error context             |
      | Initiate rollback         | Revert partial changes        |
      | Notify stakeholders       | Alert ops team                |
    And a domain event "AutomationFailure" should be emitted

  @error @recovery
  Scenario: Recover from provider API failure
    Given an AWS API call fails due to rate limiting
    When the system detects the failure
    Then exponential backoff should be applied
    And the operation should be retried up to 5 times
    And if recovery fails, manual intervention should be requested
    And a domain event "ProviderAPIFailure" should be emitted

  @error @recovery
  Scenario: Handle partial deployment failure
    Given a multi-resource deployment is in progress
    And 3 of 5 resources have been created
    When the 4th resource creation fails
    Then the system should:
      | action              | detail                          |
      | Stop deployment     | Prevent further resource creation|
      | Mark partial state  | Track what was created          |
      | Offer options       | Rollback all or continue manual |
    And a domain event "PartialDeploymentFailure" should be emitted

  @api @error
  Scenario: View automation failure diagnostics
    Given an automation failure has occurred
    When I request diagnostics via "GET /api/v1/admin/infrastructure/failures/{failure_id}/diagnostics"
    Then the response status should be 200
    And the response should contain:
      | field              | value                          |
      | failure_id         | fail-12345                     |
      | workflow_name      | deployment-pipeline            |
      | failed_step        | PROVISION_DATABASE             |
      | error_message      | Insufficient quota             |
      | stack_trace        | <detailed trace>               |
      | related_resources  | [vpc-123, subnet-456]          |
      | suggested_actions  | [Request quota increase]       |

  # ============================================================================
  # DOMAIN EVENTS
  # ============================================================================

  @domain-events
  Scenario: Emit domain events for infrastructure operations
    Given infrastructure automation is active
    When various operations are performed
    Then the following domain events should be emitted:
      | operation                  | event_type                        |
      | IaC template created       | IaCTemplateCreated                |
      | IaC deployed               | IaCDeploymentCompleted            |
      | Autoscaling triggered      | AutoscaleTriggered                |
      | Resource provisioned       | ResourceProvisioned               |
      | Config deployed            | ConfigurationDeployed             |
      | Backup completed           | BackupCompleted                   |
      | DR failover executed       | DRFailoverCompleted               |
      | Security scan completed    | SecurityScanCompleted             |
      | Compliance violation found | ComplianceViolationDetected       |
      | Workflow executed          | WorkflowExecutionCompleted        |
    And each event should contain:
      | field         | description                    |
      | event_id      | Unique event identifier        |
      | timestamp     | When the event occurred        |
      | actor         | User or system that triggered  |
      | resource_id   | Affected resource              |
      | details       | Operation-specific details     |

  @domain-events
  Scenario: Subscribe to infrastructure automation events
    Given external systems need infrastructure events
    When I configure event subscription via "POST /api/v1/admin/infrastructure/events/subscriptions" with:
      | field           | value                    |
      | subscriber_name | audit-system             |
      | event_patterns  | [IaC*, Security*, DR*]   |
      | delivery_method | WEBHOOK                  |
      | webhook_url     | https://audit.company.com/events |
    Then the response status should be 201
    And matching events should be delivered to the subscriber
    And delivery should be guaranteed with retries
    And a domain event "EventSubscriptionCreated" should be emitted
