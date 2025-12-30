@admin @global-deployment @infrastructure @platform
Feature: Admin Global Deployment
  As a platform administrator
  I want to manage global infrastructure deployment and regional operations
  So that I can provide optimal service worldwide while meeting local requirements

  Background:
    Given I am logged in as a platform administrator
    And I have global deployment permissions
    And the following regions are configured in the system:
      | region_id | region_name          | status   | data_center    | availability_zones |
      | us-east   | US East (Virginia)   | active   | AWS us-east-1  | 3                  |
      | us-west   | US West (Oregon)     | active   | AWS us-west-2  | 3                  |
      | eu-west   | EU West (Ireland)    | active   | AWS eu-west-1  | 3                  |
      | ap-south  | Asia Pacific (Mumbai)| active   | AWS ap-south-1 | 2                  |
      | ap-east   | Asia Pacific (Tokyo) | planned  | AWS ap-east-1  | 3                  |

  # ============================================
  # GLOBAL DEPLOYMENT DASHBOARD
  # ============================================

  Scenario: View global deployment dashboard with comprehensive metrics
    When I navigate to the global deployment dashboard
    Then I should see an interactive world map with active regions highlighted
    And each region should display a health indicator:
      | status   | color  | description                    |
      | healthy  | green  | All services operational       |
      | degraded | yellow | Some services experiencing issues |
      | critical | red    | Major outage or failure        |
      | planned  | blue   | Not yet deployed               |
    And I should see service health per region:
      | region   | api_gateway | app_servers | database | cache | overall |
      | us-east  | healthy     | healthy     | healthy  | healthy | 100%   |
      | us-west  | healthy     | healthy     | healthy  | healthy | 100%   |
      | eu-west  | healthy     | degraded    | healthy  | healthy | 92%    |
      | ap-south | healthy     | healthy     | healthy  | healthy | 100%   |
    And I should see latency metrics between regions:
      | from     | to       | latency_p50 | latency_p99 |
      | us-east  | us-west  | 65ms        | 120ms       |
      | us-east  | eu-west  | 85ms        | 150ms       |
      | eu-west  | ap-south | 140ms       | 220ms       |
    And I should see global traffic distribution:
      | region   | requests_per_second | percentage |
      | us-east  | 45,000              | 45%        |
      | us-west  | 25,000              | 25%        |
      | eu-west  | 20,000              | 20%        |
      | ap-south | 10,000              | 10%        |

  Scenario: View detailed region information
    When I click on region "eu-west" on the world map
    Then I should see deployed services with versions:
      | service        | version  | instances | status   | last_deploy         |
      | api-gateway    | 2.5.1    | 3         | healthy  | 2024-12-28 14:30:00 |
      | app-servers    | 3.2.0    | 5         | degraded | 2024-12-29 09:00:00 |
      | auth-service   | 1.8.2    | 2         | healthy  | 2024-12-25 10:00:00 |
      | scoring-engine | 2.1.0    | 3         | healthy  | 2024-12-27 16:45:00 |
    And I should see resource utilization:
      | resource      | used    | available | utilization |
      | CPU           | 240     | 400 vCPU  | 60%         |
      | Memory        | 480 GB  | 800 GB    | 60%         |
      | Storage       | 2.5 TB  | 5 TB      | 50%         |
      | Network       | 8 Gbps  | 20 Gbps   | 40%         |
    And I should see regional costs:
      | category      | daily   | monthly   | trend   |
      | Compute       | $850    | $25,500   | +5%     |
      | Storage       | $120    | $3,600    | +2%     |
      | Network       | $200    | $6,000    | +8%     |
      | Total         | $1,170  | $35,100   | +5%     |
    And I should see compliance status:
      | requirement   | status     | last_audit          |
      | GDPR          | compliant  | 2024-12-15 00:00:00 |
      | SOC2          | compliant  | 2024-11-30 00:00:00 |
      | ISO27001      | compliant  | 2024-10-01 00:00:00 |

  Scenario: Dashboard real-time updates on regional events
    Given the global deployment dashboard is open
    When a health check fails in region "ap-south"
    Then the region status should update to "degraded" within 10 seconds
    And a toast notification should appear: "Health alert: ap-south experiencing issues"
    And the affected service should be highlighted in red

  # ============================================
  # REGIONAL DEPLOYMENT PLANNING
  # ============================================

  Scenario: Create comprehensive regional infrastructure deployment plan
    When I create deployment plan for new region "ap-east" with the following infrastructure:
      | component        | tier    | size    | replicas | availability_zones |
      | api-gateway      | web     | large   | 3        | all                |
      | app-servers      | compute | medium  | 5        | distributed        |
      | database-primary | data    | xlarge  | 1        | az-1               |
      | database-replica | data    | xlarge  | 1        | az-2               |
      | cache-cluster    | cache   | medium  | 3        | distributed        |
      | message-queue    | queue   | medium  | 2        | az-1, az-2         |
    Then the deployment plan should be created with status "draft"
    And the plan should be validated for:
      | validation_type        | result  | details                           |
      | resource_availability  | passed  | All resources available in region |
      | network_connectivity   | passed  | VPN tunnels can be established    |
      | compliance_ready       | warning | Local data laws review needed     |
      | capacity_sufficient    | passed  | Quota allows requested resources  |
    And a cost estimate should be calculated:
      | category      | monthly_estimate | setup_cost |
      | Compute       | $18,500          | $2,500     |
      | Storage       | $4,200           | $500       |
      | Network       | $3,800           | $1,200     |
      | Licensing     | $2,000           | $0         |
      | Total         | $28,500          | $4,200     |
    And a DeploymentPlanCreated domain event should be published with:
      | field         | value            |
      | plan_id       | generated_uuid   |
      | region        | ap-east          |
      | created_by    | current_user_id  |
      | status        | draft            |
      | estimated_cost| $28,500/month    |

  Scenario: Validate deployment prerequisites with detailed checks
    Given a deployment plan exists for region "ap-east"
    When I validate deployment prerequisites
    Then I should see network connectivity status:
      | connection         | status    | latency  | bandwidth |
      | ap-east to us-east | ready     | 180ms    | 10 Gbps   |
      | ap-east to eu-west | ready     | 250ms    | 10 Gbps   |
      | VPN tunnel         | pending   | N/A      | N/A       |
    And I should see compliance requirements:
      | requirement           | status      | action_needed                    |
      | Data localization     | pending     | Review local data storage laws   |
      | Privacy regulations   | in_progress | APPI compliance certification    |
      | Financial regulations | not_started | FSA approval required            |
    And I should see required approvals:
      | approver              | role              | status   | deadline            |
      | Infrastructure Lead   | technical         | pending  | 2025-01-05 00:00:00 |
      | Security Team         | security          | pending  | 2025-01-05 00:00:00 |
      | Finance Director      | budget            | pending  | 2025-01-07 00:00:00 |
      | Compliance Officer    | compliance        | pending  | 2025-01-10 00:00:00 |
    And any blockers should be highlighted:
      | blocker                    | severity | resolution                     |
      | VPN tunnel not established | high     | Network team to provision      |
      | FSA approval pending       | medium   | Compliance team to expedite    |

  Scenario: Submit deployment plan for approval workflow
    Given a deployment plan for "ap-east" has passed validation
    When I submit the plan for approval
    Then the plan status should change to "pending_approval"
    And approval requests should be sent to all required approvers
    And each approver should receive a notification with plan details
    And I should see approval progress:
      | step | approver            | status   |
      | 1    | Infrastructure Lead | pending  |
      | 2    | Security Team       | pending  |
      | 3    | Finance Director    | pending  |
      | 4    | Compliance Officer  | pending  |

  Scenario: Approve deployment plan through workflow
    Given deployment plan for "ap-east" is pending approval
    And I am the "Infrastructure Lead"
    When I approve the plan with comment "Infrastructure requirements verified"
    Then my approval should be recorded
    And the next approver should be notified
    When all approvers have approved
    Then plan status should change to "approved"
    And the deployment can proceed
    And a DeploymentPlanApproved event should be published

  Scenario: Reject deployment plan with feedback
    Given deployment plan for "ap-east" is pending approval
    And I am the "Security Team" approver
    When I reject the plan with reason "Encryption requirements not met"
    Then plan status should change to "rejected"
    And the plan creator should be notified with the rejection reason
    And the plan should be available for revision and resubmission

  # ============================================
  # MULTI-REGION DEPLOYMENT EXECUTION
  # ============================================

  Scenario: Execute regional deployment with step-by-step progress
    Given deployment plan for "ap-east" is approved
    And all prerequisites are satisfied
    When I execute the deployment
    Then I should see deployment progress:
      | step | phase                | status      | duration | details                    |
      | 1    | Network provisioning | completed   | 5m       | VPC and subnets created    |
      | 2    | Security groups      | completed   | 2m       | Firewall rules applied     |
      | 3    | Database setup       | in_progress | 15m      | Primary and replica setup  |
      | 4    | Cache cluster        | pending     | -        | Waiting for database       |
      | 5    | Application deploy   | pending     | -        | Waiting for infrastructure |
      | 6    | Load balancer        | pending     | -        | Waiting for applications   |
      | 7    | Health verification  | pending     | -        | Final validation           |
    And each phase should have detailed logs available
    And upon completion all health checks should pass:
      | check              | status  | response_time |
      | api-gateway        | passed  | 45ms          |
      | app-servers        | passed  | 120ms         |
      | database-primary   | passed  | 15ms          |
      | database-replica   | passed  | 18ms          |
      | cache-cluster      | passed  | 5ms           |
    And a RegionDeployed domain event should be published with:
      | field              | value                      |
      | region             | ap-east                    |
      | deployed_by        | current_user_id            |
      | deployment_time    | total_elapsed_time         |
      | services_deployed  | 6                          |
      | status             | healthy                    |

  Scenario: Configure staged regional rollout for new version
    Given version "3.3.0" is ready for deployment
    When I configure staged rollout with the following stages:
      | stage | regions                  | traffic_percentage | duration    | success_criteria            |
      | 1     | us-east                  | 10%                | 2 hours     | error_rate < 0.1%           |
      | 2     | us-east, us-west         | 50%                | 4 hours     | error_rate < 0.1%, p99 < 200ms |
      | 3     | us-east, us-west, eu-west| 80%                | 24 hours    | error_rate < 0.5%           |
      | 4     | all                      | 100%               | permanent   | full deployment             |
    Then rollout configuration should be saved
    And I should be able to:
      | action                  | description                              |
      | Start rollout           | Begin stage 1 deployment                 |
      | Pause between stages    | Wait for manual approval to continue     |
      | Skip stage              | Move directly to next stage              |
      | Rollback                | Revert to previous version immediately   |
      | Abort                   | Stop rollout and revert all changes      |

  Scenario: Execute staged rollout with automatic progression
    Given a staged rollout is configured for version "3.3.0"
    When I start the rollout with auto-progression enabled
    Then stage 1 should deploy to "us-east" with 10% traffic
    And metrics should be monitored against success criteria
    When stage 1 success criteria are met for 2 hours
    Then stage 2 should automatically begin
    And traffic should increase to 50% across "us-east, us-west"
    And a StageCompleted event should be published for each successful stage

  Scenario: Pause staged rollout due to issues
    Given a staged rollout is in progress at stage 2
    And error rate exceeds 0.1% threshold
    When the monitoring system detects the issue
    Then the rollout should automatically pause
    And an alert should be sent to the deployment team
    And I should see options:
      | option              | description                              |
      | Continue anyway     | Proceed despite threshold breach         |
      | Extend observation  | Wait longer before making decision       |
      | Rollback to stage 1 | Revert stage 2 regions                   |
      | Full rollback       | Revert all regions to previous version   |

  Scenario: Perform blue-green regional deployment
    Given region "eu-west" is running version "3.2.0" (blue environment)
    When I initiate blue-green deployment of version "3.3.0"
    Then a new green environment should be provisioned in "eu-west"
    And version "3.3.0" should be deployed to green environment
    And I should see environment comparison:
      | metric          | blue (3.2.0) | green (3.3.0) |
      | instances       | 5            | 5             |
      | health_status   | healthy      | healthy       |
      | avg_latency     | 45ms         | 42ms          |
      | error_rate      | 0.02%        | 0.01%         |
    When I execute traffic switch
    Then traffic should atomically switch from blue to green
    And blue environment should be kept warm for 1 hour
    And instant rollback to blue should be available
    And a BlueGreenSwitchCompleted event should be published

  Scenario: Perform canary regional deployment with metrics comparison
    Given region "us-east" is running version "3.2.0"
    When I deploy canary version "3.3.0" to "us-east" with configuration:
      | setting                | value              |
      | traffic_percentage     | 5%                 |
      | canary_instances       | 2                  |
      | observation_period     | 1 hour             |
      | auto_promote_threshold | all metrics within 10% |
      | auto_rollback_on       | error_rate > 1%    |
    Then canary instances should receive 5% of traffic
    And metrics should be compared to baseline:
      | metric              | baseline (3.2.0) | canary (3.3.0) | status  |
      | response_time_p50   | 45ms             | 43ms           | better  |
      | response_time_p99   | 150ms            | 145ms          | better  |
      | error_rate          | 0.02%            | 0.02%          | same    |
      | cpu_utilization     | 55%              | 52%            | better  |
      | memory_utilization  | 62%              | 60%            | better  |
    When all metrics are within acceptable range for the observation period
    Then canary should be automatically promoted to full deployment
    And a CanaryPromoted event should be published

  Scenario: Automatic canary rollback on threshold breach
    Given a canary deployment is in progress for version "3.3.0"
    And auto-rollback is configured for error_rate > 1%
    When error rate reaches 1.5%
    Then canary should be automatically rolled back
    And all traffic should return to the stable version
    And an alert should be sent with details:
      | field               | value                                      |
      | reason              | Error rate threshold exceeded              |
      | observed_error_rate | 1.5%                                       |
      | threshold           | 1%                                         |
      | action_taken        | Automatic rollback                         |
    And a CanaryRolledBack event should be published

  # ============================================
  # GEO-REPLICATION
  # ============================================

  Scenario: Configure database geo-replication with detailed settings
    When I configure geo-replication for the primary database:
      | setting              | value                              |
      | primary_region       | us-east                            |
      | replica_regions      | eu-west, ap-south                  |
      | replication_mode     | async                              |
      | consistency_level    | eventual (within 5 seconds)        |
      | conflict_resolution  | last-write-wins                    |
      | encryption_in_transit| enabled                            |
    Then replication should be established between regions
    And initial data sync should complete
    And replication lag should be monitored with thresholds:
      | replica   | target_lag | warning_threshold | critical_threshold |
      | eu-west   | < 1s       | 3s                | 10s                |
      | ap-south  | < 2s       | 5s                | 15s                |
    And a GeoReplicationConfigured domain event should be published with:
      | field             | value                    |
      | primary           | us-east                  |
      | replicas          | eu-west, ap-south        |
      | replication_mode  | async                    |
      | configured_by     | current_user_id          |

  Scenario: Monitor replication status dashboard
    Given geo-replication is configured with replicas in eu-west and ap-south
    When I view the replication dashboard
    Then I should see real-time replication status:
      | replica   | status   | lag      | bytes_behind | last_sync           |
      | eu-west   | healthy  | 0.8s     | 1.2 MB       | 2024-12-29 09:30:45 |
      | ap-south  | healthy  | 1.5s     | 2.8 MB       | 2024-12-29 09:30:44 |
    And I should see sync metrics over time:
      | metric                 | last_hour | last_24h |
      | avg_replication_lag    | 1.1s      | 0.9s     |
      | max_replication_lag    | 3.2s      | 8.5s     |
      | replication_errors     | 0         | 2        |
      | bytes_replicated       | 45 GB     | 1.2 TB   |
    And I should see any replication errors with details

  Scenario: Handle replication lag threshold alert
    Given replication to "ap-south" has lag threshold of 5 seconds
    When replication lag reaches 7 seconds
    Then a warning alert should trigger:
      | alert_type   | severity | message                                  |
      | replication  | warning  | Replication lag to ap-south exceeds 5s   |
    And I should see remediation options:
      | option                   | description                                 |
      | Investigate network      | Check network connectivity between regions  |
      | Increase bandwidth       | Allocate more replication bandwidth         |
      | Pause non-critical ops   | Reduce write load on primary                |
      | Switch to sync mode      | Temporarily use synchronous replication     |
    And the incident should be logged for analysis

  Scenario: Promote replica to primary during regional failure
    Given primary region "us-east" is experiencing an outage
    And replica "eu-west" has lag of 2 seconds
    When I initiate failover to promote "eu-west" to primary
    Then I should see failover confirmation dialog:
      | warning                                                        |
      | Data from the last 2 seconds may be lost                       |
      | Writes will be disabled during transition (estimated 30 seconds)|
      | Existing connections will be terminated                        |
    When I confirm the failover
    Then "eu-west" should become the new primary
    And "ap-south" should reconnect to "eu-west" as primary
    And DNS records should be updated:
      | record           | old_value       | new_value        |
      | db.primary       | us-east.db      | eu-west.db       |
    And a PrimaryFailover domain event should be published
    And when "us-east" recovers it should become a replica

  Scenario: Configure synchronous replication for critical data
    Given async replication is configured between us-east and eu-west
    When I configure synchronous replication for critical tables:
      | table              | sync_mode   | quorum  |
      | financial_txns     | synchronous | 2 of 2  |
      | user_credentials   | synchronous | 2 of 2  |
      | audit_logs         | synchronous | 2 of 2  |
    Then writes to these tables should wait for replica acknowledgment
    And write latency will increase by approximately 85ms (cross-region RTT)
    And data consistency should be guaranteed across regions

  # ============================================
  # CDN MANAGEMENT
  # ============================================

  Scenario: Configure CDN distribution with comprehensive settings
    When I create CDN distribution with the following configuration:
      | setting               | value                              |
      | distribution_name     | ffl-playoffs-global                |
      | origin_domain         | api.fflplayoffs.com                |
      | origin_protocol       | HTTPS only                         |
      | edge_locations        | global (all available POPs)        |
      | price_class           | all edge locations                 |
      | ssl_certificate       | custom (*.fflplayoffs.com)         |
      | minimum_tls           | TLS 1.2                            |
      | http2_enabled         | true                               |
      | ipv6_enabled          | true                               |
    Then CDN distribution should be created with status "deploying"
    And edge locations should be provisioned:
      | region          | pop_count | status     |
      | North America   | 45        | deploying  |
      | Europe          | 32        | deploying  |
      | Asia Pacific    | 28        | deploying  |
      | South America   | 12        | deploying  |
    And a CDNConfigured domain event should be published
    And distribution should be fully deployed within 15 minutes

  Scenario: Configure cache policies for different content types
    Given CDN distribution "ffl-playoffs-global" is active
    When I configure cache policies:
      | path_pattern    | ttl      | compress | cache_methods | query_string | headers_to_forward |
      | /static/*       | 30 days  | gzip, br | GET, HEAD     | ignore       | none               |
      | /api/scores/*   | 30 seconds| gzip    | GET           | include      | Accept, Authorization |
      | /api/players/*  | 5 minutes | gzip    | GET           | include      | Accept             |
      | /api/live/*     | 0 (bypass)| no      | GET           | include      | all                |
      | /images/*       | 7 days   | no       | GET, HEAD     | ignore       | none               |
    Then cache policies should be applied
    And I should see estimated cache performance:
      | path_pattern    | expected_hit_ratio | bandwidth_savings |
      | /static/*       | 95%                | 90%               |
      | /api/scores/*   | 70%                | 60%               |
      | /api/players/*  | 85%                | 75%               |
      | /images/*       | 98%                | 95%               |

  Scenario: Invalidate CDN cache with progress tracking
    Given CDN has cached content for path "/api/v1/*"
    When I invalidate cache for path "/api/v1/*"
    Then cache invalidation should be initiated
    And I should see invalidation progress:
      | region          | status      | completion |
      | North America   | in_progress | 65%        |
      | Europe          | in_progress | 45%        |
      | Asia Pacific    | in_progress | 30%        |
      | South America   | in_progress | 20%        |
    And invalidation should complete within 5 minutes
    And fresh content should be served from origin
    And a CDNCacheInvalidated event should be published

  Scenario: Emergency cache purge for security incident
    Given a security vulnerability is discovered in cached content
    When I execute emergency cache purge for all paths
    Then purge should be prioritized across all edge locations
    And all cached content should be invalidated within 60 seconds
    And origin should be prepared for increased load
    And an EmergencyCachePurge event should be published with incident reference

  Scenario: View CDN analytics dashboard
    When I view CDN analytics for the last 24 hours
    Then I should see performance metrics:
      | metric                 | value       | trend    |
      | total_requests         | 125,000,000 | +15%     |
      | cache_hit_ratio        | 92.5%       | +2%      |
      | bandwidth_served       | 4.2 TB      | +10%     |
      | bandwidth_to_origin    | 320 GB      | -5%      |
      | avg_edge_response_time | 12ms        | -8%      |
      | avg_origin_time        | 145ms       | +3%      |
    And I should see geographic distribution:
      | region          | requests    | hit_ratio | avg_latency |
      | North America   | 56,000,000  | 94%       | 8ms         |
      | Europe          | 42,000,000  | 93%       | 10ms        |
      | Asia Pacific    | 22,000,000  | 88%       | 15ms        |
      | South America   | 5,000,000   | 91%       | 18ms        |
    And I should see top requested paths and error rates

  # ============================================
  # GLOBAL LOAD BALANCING
  # ============================================

  Scenario: Configure global load balancer with geo-proximity routing
    When I configure global load balancer with the following settings:
      | setting              | value                              |
      | name                 | ffl-global-lb                      |
      | algorithm            | geo-proximity                      |
      | health_check_path    | /health                            |
      | health_check_interval| 10 seconds                         |
      | healthy_threshold    | 2 consecutive successes            |
      | unhealthy_threshold  | 3 consecutive failures             |
      | failover_mode        | automatic                          |
      | session_affinity     | client_ip (1 hour TTL)             |
    And I configure backend regions:
      | region   | endpoint                      | weight | priority |
      | us-east  | us-east.api.fflplayoffs.com   | 100    | 1        |
      | us-west  | us-west.api.fflplayoffs.com   | 100    | 1        |
      | eu-west  | eu-west.api.fflplayoffs.com   | 100    | 1        |
      | ap-south | ap-south.api.fflplayoffs.com  | 100    | 1        |
    Then load balancer should be configured
    And traffic should route to nearest healthy region based on user location
    And a GlobalLBConfigured domain event should be published

  Scenario: Configure geographic traffic routing policies
    Given global load balancer "ffl-global-lb" is active
    When I configure traffic routing policies:
      | policy_name     | condition                    | target_region | priority |
      | EU_users        | geo.country IN (EU_COUNTRIES)| eu-west       | 1        |
      | US_east_coast   | geo.region IN (US_EAST)      | us-east       | 1        |
      | US_west_coast   | geo.region IN (US_WEST)      | us-west       | 1        |
      | APAC_users      | geo.country IN (APAC)        | ap-south      | 1        |
      | default         | always                       | nearest       | 100      |
    Then routing policies should be applied in priority order
    And I should see policy match statistics:
      | policy_name     | matches_24h | percentage |
      | EU_users        | 8,500,000   | 22%        |
      | US_east_coast   | 12,000,000  | 31%        |
      | US_west_coast   | 9,500,000   | 25%        |
      | APAC_users      | 5,500,000   | 14%        |
      | default         | 3,000,000   | 8%         |

  Scenario: Configure weighted traffic distribution
    Given I want to gradually shift traffic between regions
    When I configure weighted routing:
      | region   | weight | expected_percentage |
      | us-east  | 60     | 60%                 |
      | us-west  | 25     | 25%                 |
      | eu-west  | 15     | 15%                 |
    Then traffic should distribute according to weights
    And I should see actual distribution metrics:
      | region   | target | actual | deviation |
      | us-east  | 60%    | 59.2%  | -0.8%     |
      | us-west  | 25%    | 25.8%  | +0.8%     |
      | eu-west  | 15%    | 15.0%  | 0%        |
    And weight changes should take effect within 60 seconds

  Scenario: Configure failover routing with priority chain
    When I configure failover routing for "us-east":
      | priority | region   | health_check_override |
      | 1        | us-east  | default               |
      | 2        | us-west  | default               |
      | 3        | eu-west  | increased_frequency   |
    Then failover chain should be configured
    And when "us-east" becomes unhealthy:
      | event                        | action                              |
      | Health check fails 3x        | Mark us-east unhealthy              |
      | Traffic reroute              | Send traffic to us-west (priority 2)|
      | Alert generated              | Notify operations team              |
      | Recovery detection           | Health checks continue on us-east   |
      | Health restored              | Gradually shift traffic back        |

  Scenario: Monitor load balancer health and performance
    When I view load balancer dashboard
    Then I should see health status for all backends:
      | region   | status   | last_check          | response_time | success_rate |
      | us-east  | healthy  | 2024-12-29 09:35:45 | 42ms          | 99.99%       |
      | us-west  | healthy  | 2024-12-29 09:35:44 | 38ms          | 99.98%       |
      | eu-west  | healthy  | 2024-12-29 09:35:46 | 45ms          | 99.97%       |
      | ap-south | degraded | 2024-12-29 09:35:43 | 120ms         | 99.50%       |
    And I should see traffic distribution in real-time
    And I should see connection metrics (active connections, requests/sec)

  # ============================================
  # LATENCY OPTIMIZATION
  # ============================================

  Scenario: Run comprehensive latency analysis
    When I run latency analysis for all regions
    Then I should see user-to-region latency map:
      | user_location    | us-east | us-west | eu-west | ap-south |
      | New York, US     | 15ms    | 75ms    | 85ms    | 210ms    |
      | Los Angeles, US  | 65ms    | 12ms    | 145ms   | 180ms    |
      | London, UK       | 85ms    | 140ms   | 12ms    | 120ms    |
      | Mumbai, India    | 220ms   | 195ms   | 130ms   | 18ms     |
      | Sydney, AU       | 240ms   | 165ms   | 280ms   | 95ms     |
    And I should see optimization recommendations:
      | recommendation                           | impact    | effort |
      | Deploy edge function for auth validation | -50ms p99 | low    |
      | Add ap-east region for APAC users        | -80ms avg | high   |
      | Enable connection pooling to origin      | -25ms avg | medium |
      | Implement request coalescing for hot keys| -15ms p50 | medium |

  Scenario: Deploy edge function for latency reduction
    When I deploy edge function with configuration:
      | setting          | value                              |
      | function_name    | auth-token-validation              |
      | runtime          | javascript                         |
      | memory           | 128 MB                             |
      | timeout          | 50ms                               |
      | edge_locations   | all                                |
      | trigger          | /api/* requests                    |
    And the function code performs:
      | operation                | description                    |
      | JWT validation           | Validate token signature       |
      | Token expiry check       | Verify token not expired       |
      | Basic claims extraction  | Extract user_id, roles         |
    Then function should be deployed to all edge locations
    And origin requests should decrease by estimated 40%
    And average latency should decrease by estimated 35ms
    And an EdgeFunctionDeployed event should be published

  Scenario: Optimize inter-region communication
    When I analyze inter-region traffic patterns
    Then I should see communication matrix:
      | from     | to       | requests_24h | avg_latency | data_volume |
      | us-east  | us-west  | 5,000,000    | 65ms        | 120 GB      |
      | us-east  | eu-west  | 8,000,000    | 85ms        | 200 GB      |
      | eu-west  | ap-south | 2,000,000    | 140ms       | 45 GB       |
    And I should see optimization suggestions:
      | suggestion                            | benefit              |
      | Cache shared config in each region    | Reduce cross-region calls 60% |
      | Use regional read replicas            | Reduce database latency 70%   |
      | Implement request batching            | Reduce round trips 40%        |

  # ============================================
  # DATA RESIDENCY AND COMPLIANCE
  # ============================================

  Scenario: Configure data residency requirements for EU users
    When I configure data residency for EU users:
      | data_category    | residency_requirement | storage_location | replication_allowed |
      | user_pii         | EU only               | eu-west          | within EU only      |
      | payment_data     | EU only               | eu-west          | no                  |
      | game_scores      | any region            | nearest          | global              |
      | analytics        | any region            | any              | global              |
      | audit_logs       | EU only               | eu-west          | within EU only      |
    Then data routing rules should be configured
    And cross-border transfers should be blocked for restricted data:
      | attempt                              | result  | reason                    |
      | Replicate user_pii to us-east        | blocked | EU residency requirement  |
      | Query payment_data from ap-south     | blocked | Data cannot leave EU      |
      | Replicate game_scores to us-east     | allowed | No residency restriction  |
    And a DataResidencyConfigured domain event should be published

  Scenario: View compliance dashboard with regional status
    When I view the compliance dashboard
    Then I should see compliance status per region:
      | region   | gdpr    | ccpa    | soc2    | pci_dss | hipaa   |
      | us-east  | n/a     | compliant| compliant| compliant| n/a    |
      | us-west  | n/a     | compliant| compliant| compliant| n/a    |
      | eu-west  | compliant| n/a     | compliant| compliant| n/a    |
      | ap-south | pending | n/a     | compliant| in_progress| n/a  |
    And I should see required certifications with expiry:
      | certification | region   | status    | expires             |
      | SOC2 Type II  | us-east  | current   | 2025-06-30          |
      | PCI DSS       | eu-west  | current   | 2025-03-15          |
      | ISO 27001     | all      | current   | 2025-09-01          |
    And I should see audit trail for compliance activities

  Scenario Outline: Enforce regional compliance requirements during deployment
    Given I am deploying to region "<region>"
    And region "<region>" has compliance requirement "<compliance>"
    When the deployment executes
    Then the following requirements should be enforced:
      | requirement         | enforced |
      | <requirement_1>     | yes      |
      | <requirement_2>     | yes      |
    And deployment should fail if requirements are not met

    Examples:
      | region   | compliance | requirement_1           | requirement_2              |
      | eu-west  | GDPR       | data_residency_eu       | consent_management_enabled |
      | us-east  | SOC2       | encryption_at_rest      | audit_logging_enabled      |
      | us-west  | CCPA       | data_deletion_capability| privacy_policy_link        |
      | ap-south | local_laws | data_localization       | local_entity_registration  |

  # ============================================
  # REGIONAL CAPACITY MANAGEMENT
  # ============================================

  Scenario: View regional capacity dashboard
    When I view capacity dashboard for "us-east"
    Then I should see current utilization:
      | resource      | used    | limit   | utilization | trend_7d |
      | vCPU          | 240     | 400     | 60%         | +5%      |
      | Memory        | 480 GB  | 800 GB  | 60%         | +3%      |
      | Storage       | 2.5 TB  | 5 TB    | 50%         | +2%      |
      | Load Balancer | 3       | 10      | 30%         | 0%       |
      | Elastic IPs   | 12      | 20      | 60%         | 0%       |
    And I should see capacity limits and quotas
    And I should see scaling headroom:
      | service        | current_instances | max_instances | headroom |
      | app-servers    | 5                 | 20            | 15       |
      | cache-nodes    | 3                 | 10            | 7        |
      | worker-nodes   | 4                 | 15            | 11       |

  Scenario: Scale regional capacity manually
    Given I want to increase capacity in "eu-west" for expected traffic surge
    When I request capacity increase:
      | resource      | current | target | reason                    |
      | app-servers   | 5       | 10     | Playoff games this weekend|
      | cache-nodes   | 3       | 5      | Increased read load       |
      | worker-nodes  | 4       | 8      | Score calculation backlog |
    Then scaling request should be validated:
      | validation          | result  | details                     |
      | quota_available     | passed  | Sufficient quota available  |
      | budget_approved     | warning | Exceeds monthly budget by 15%|
      | resources_available | passed  | Resources can be provisioned|
    When I confirm the scaling request
    Then scaling should execute progressively:
      | time   | app-servers | cache-nodes | worker-nodes |
      | +0m    | 5           | 3           | 4            |
      | +5m    | 7           | 4           | 6            |
      | +10m   | 10          | 5           | 8            |
    And a RegionalScalingCompleted event should be published

  Scenario: Configure global auto-scaling policies
    When I configure global auto-scaling:
      | metric              | threshold | scale_action    | cooldown |
      | cpu_utilization     | > 80%     | add 2 instances | 5 min    |
      | cpu_utilization     | < 30%     | remove 1 instance| 10 min  |
      | request_rate        | > 10k/s   | add 3 instances | 3 min    |
      | memory_utilization  | > 85%     | add 1 instance  | 5 min    |
      | queue_depth         | > 1000    | add 2 workers   | 2 min    |
    Then auto-scaling policies should be applied globally
    And each region should scale independently based on local metrics
    And I should see scaling activity log:
      | timestamp           | region   | action          | trigger         |
      | 2024-12-29 08:15:00 | us-east  | +2 app-servers  | cpu > 80%       |
      | 2024-12-29 09:00:00 | eu-west  | +1 cache-node   | memory > 85%    |
      | 2024-12-29 09:30:00 | us-west  | -1 app-server   | cpu < 30%       |

  Scenario: Handle capacity limits with graceful degradation
    Given region "ap-south" is at 95% capacity
    And auto-scaling cannot provision more resources (quota limit)
    When traffic continues to increase
    Then graceful degradation should activate:
      | action                  | description                              |
      | Enable rate limiting    | Limit requests to 8000/s per user        |
      | Disable non-critical    | Temporarily disable analytics collection |
      | Activate overflow       | Route excess traffic to eu-west          |
    And alerts should be sent to capacity planning team
    And a CapacityLimitReached event should be published

  # ============================================
  # DISASTER RECOVERY
  # ============================================

  Scenario: Configure regional disaster recovery
    When I configure disaster recovery for "us-east":
      | setting              | value                              |
      | dr_region            | us-west                            |
      | rpo                  | 5 minutes (max data loss)          |
      | rto                  | 15 minutes (max downtime)          |
      | failover_mode        | automatic                          |
      | failover_threshold   | 3 failed health checks             |
      | data_sync_method     | continuous async replication       |
      | dns_ttl              | 60 seconds                         |
    Then DR configuration should be validated:
      | check                      | status  | details                    |
      | Network connectivity       | passed  | VPN tunnel established     |
      | Data replication          | passed  | Lag within RPO             |
      | Resource availability     | passed  | DR region has capacity     |
      | DNS configuration         | passed  | Failover records ready     |
    And a DRConfigured domain event should be published

  Scenario: Execute disaster recovery test
    Given DR is configured for "us-east" with DR region "us-west"
    When I initiate DR test with mode "simulate"
    Then a simulated failover should execute:
      | step | action                        | status    | duration |
      | 1    | Verify data sync status       | completed | 2s       |
      | 2    | Validate DR region readiness  | completed | 5s       |
      | 3    | Simulate DNS failover         | completed | 3s       |
      | 4    | Test service health in DR     | completed | 30s      |
      | 5    | Validate data consistency     | completed | 45s      |
      | 6    | Simulate traffic routing      | completed | 10s      |
    And test report should be generated:
      | metric              | target   | actual   | status  |
      | failover_time       | < 15 min | 1.5 min  | passed  |
      | data_loss           | < 5 min  | 0 min    | passed  |
      | service_availability| 100%     | 100%     | passed  |
    And no actual traffic should be affected

  Scenario: Execute actual regional failover during outage
    Given region "us-east" experiences a complete outage
    And automatic failover is enabled
    When health checks fail 3 consecutive times
    Then automatic failover should trigger:
      | step | action                        | status      | timestamp           |
      | 1    | Detect failure                | completed   | 09:30:00            |
      | 2    | Verify DR region health       | completed   | 09:30:05            |
      | 3    | Promote DR database           | in_progress | 09:30:10            |
      | 4    | Update DNS records            | pending     | -                   |
      | 5    | Reroute traffic               | pending     | -                   |
      | 6    | Verify services               | pending     | -                   |
    And traffic should route to "us-west" within 15 minutes
    And I should see failover status dashboard
    And a RegionalFailover domain event should be published with:
      | field              | value                    |
      | failed_region      | us-east                  |
      | dr_region          | us-west                  |
      | failover_type      | automatic                |
      | trigger            | health_check_failure     |
      | data_loss_estimate | 0 seconds                |

  Scenario: Perform controlled failback after recovery
    Given failover to "us-west" occurred 2 hours ago
    And "us-east" has recovered and is healthy
    When I initiate failback to "us-east"
    Then failback should execute with data sync:
      | step | action                        | status    |
      | 1    | Verify us-east health         | completed |
      | 2    | Sync data from us-west        | completed |
      | 3    | Validate data consistency     | completed |
      | 4    | Gradual traffic shift (10%)   | completed |
      | 5    | Gradual traffic shift (50%)   | completed |
      | 6    | Complete traffic shift (100%) | completed |
      | 7    | Update DNS records            | completed |
    And "us-east" should become primary again
    And "us-west" should return to DR standby mode

  # ============================================
  # REGIONAL MONITORING AND ALERTING
  # ============================================

  Scenario: View global infrastructure monitoring dashboard
    When I view global monitoring dashboard
    Then I should see health status per region in real-time:
      | region   | status   | services_healthy | alerts_active |
      | us-east  | healthy  | 12/12            | 0             |
      | us-west  | healthy  | 12/12            | 1 (warning)   |
      | eu-west  | degraded | 11/12            | 2             |
      | ap-south | healthy  | 12/12            | 0             |
    And I should see cross-region latency heatmap
    And I should see global error rates:
      | metric           | value  | threshold | status  |
      | 5xx_error_rate   | 0.02%  | 0.1%      | healthy |
      | 4xx_error_rate   | 1.2%   | 5%        | healthy |
      | timeout_rate     | 0.01%  | 0.5%      | healthy |
    And I should see request distribution across regions

  Scenario: Configure regional alerts with escalation
    When I create regional alert rules:
      | alert_name            | region | metric        | condition  | severity | action              |
      | high_error_rate       | any    | error_rate    | > 1%       | critical | page_oncall         |
      | high_latency          | any    | p99_latency   | > 500ms    | warning  | notify_team         |
      | availability_drop     | any    | availability  | < 99.9%    | critical | page_oncall_manager |
      | capacity_warning      | any    | cpu_util      | > 85%      | warning  | notify_team         |
      | replication_lag       | any    | db_lag        | > 10s      | critical | page_dba            |
    Then alerts should be configured
    And escalation policy should be:
      | level | wait_time | action                    |
      | 1     | 0 min     | Page primary on-call      |
      | 2     | 15 min    | Page secondary on-call    |
      | 3     | 30 min    | Page engineering manager  |
      | 4     | 60 min    | Page VP of Engineering    |

  Scenario: Trigger and acknowledge regional alert
    Given alert rule "high_error_rate" is configured for all regions
    When error rate in "eu-west" reaches 1.5%
    Then alert should trigger:
      | field           | value                                    |
      | alert_name      | high_error_rate                          |
      | region          | eu-west                                  |
      | current_value   | 1.5%                                     |
      | threshold       | 1%                                       |
      | severity        | critical                                 |
    And on-call engineer should be paged
    When engineer acknowledges the alert
    Then alert status should change to "acknowledged"
    And escalation timer should pause
    And incident timeline should be tracked

  # ============================================
  # COST OPTIMIZATION
  # ============================================

  Scenario: View regional cost analysis
    When I view regional cost analysis
    Then I should see costs per region:
      | region   | compute   | storage  | network  | other    | total     | trend  |
      | us-east  | $35,000   | $8,500   | $12,000  | $4,500   | $60,000   | +8%    |
      | us-west  | $22,000   | $5,200   | $7,500   | $2,800   | $37,500   | +5%    |
      | eu-west  | $28,000   | $6,800   | $9,200   | $3,500   | $47,500   | +12%   |
      | ap-south | $15,000   | $3,500   | $4,800   | $1,700   | $25,000   | +3%    |
    And I should see cost optimization recommendations:
      | recommendation                          | savings   | effort | region   |
      | Use reserved instances for steady load  | $15,000/mo| medium | us-east  |
      | Right-size over-provisioned instances   | $8,500/mo | low    | all      |
      | Optimize data transfer between regions  | $4,200/mo | medium | eu-west  |
      | Archive cold data to cheaper storage    | $2,100/mo | low    | all      |

  Scenario: Implement regional budget controls
    When I set budget for "ap-south" at $30,000/month
    Then budget should be configured with alerts:
      | threshold | action                              |
      | 50%       | Send informational email            |
      | 75%       | Send warning to team                |
      | 90%       | Alert finance and engineering leads |
      | 100%      | Trigger cost review meeting         |
    And spending should be tracked daily
    And forecast should predict end-of-month spend

  Scenario: Implement cost allocation tags
    When I configure cost allocation for resources:
      | tag_key       | tag_values                          | required |
      | team          | platform, scoring, analytics        | yes      |
      | environment   | production, staging, development    | yes      |
      | service       | api, worker, database, cache        | yes      |
      | cost_center   | CC-1001, CC-1002, CC-1003           | no       |
    Then all resources should be tagged
    And cost reports should be available by tag:
      | team       | monthly_cost | percentage |
      | platform   | $85,000      | 50%        |
      | scoring    | $52,000      | 31%        |
      | analytics  | $33,000      | 19%        |

  # ============================================
  # SECURITY
  # ============================================

  Scenario: Configure regional security measures
    When I configure security for region "eu-west":
      | security_control      | setting                              |
      | waf_enabled           | true                                 |
      | waf_rules             | OWASP Top 10, rate limiting          |
      | ddos_protection       | advanced (always-on)                 |
      | network_isolation     | vpc_per_region                       |
      | encryption_at_rest    | AES-256 with customer-managed keys   |
      | encryption_in_transit | TLS 1.3                              |
      | private_endpoints     | enabled for database, cache          |
    Then security controls should be applied
    And compliance should be validated against requirements
    And a RegionalSecurityConfigured event should be published

  Scenario: Detect and respond to security threat
    Given WAF is enabled in all regions
    When WAF detects SQL injection attempt in "us-east"
    Then the following actions should occur:
      | action                  | target                              |
      | Block request           | Immediate                           |
      | Log incident            | Security incident log               |
      | Alert security team     | Via PagerDuty                       |
      | Increase monitoring     | Enhanced logging for 1 hour         |
    And if attack persists:
      | threshold         | action                              |
      | 100 attempts/min  | Add IP to temporary blocklist       |
      | 1000 attempts/min | Enable geo-blocking for source      |
    And a SecurityIncident event should be published

  # ============================================
  # DOMAIN EVENTS
  # ============================================

  Scenario: RegionDeployed event triggers downstream configuration
    When RegionDeployed event is published for "ap-east"
    Then the following downstream actions should occur:
      | action                    | description                          |
      | DNS update                | Add ap-east to DNS rotation          |
      | Monitoring setup          | Configure dashboards and alerts      |
      | Load balancer update      | Add ap-east to global LB             |
      | CDN configuration         | Add ap-east as origin                |
      | Replication setup         | Configure database replication       |
    And region should be fully operational within 30 minutes

  Scenario: RegionalFailover event triggers emergency procedures
    When RegionalFailover event is published
    Then the following should occur:
      | action                      | priority | notification              |
      | Update status page          | P0       | Automatic                 |
      | Notify stakeholders         | P0       | Email, Slack, PagerDuty   |
      | Activate incident response  | P0       | Create incident ticket    |
      | Scale DR region             | P1       | Increase capacity by 50%  |
      | Enable enhanced monitoring  | P1       | 1-minute metric intervals |

  # ============================================
  # ERROR SCENARIOS
  # ============================================

  Scenario: Handle deployment failure with automatic rollback
    Given deployment to "ap-east" is in progress
    When deployment fails at database provisioning step
    Then partial deployment should be automatically rolled back:
      | component        | action                    |
      | Network          | Retain (no cost)          |
      | Security groups  | Retain (no cost)          |
      | Failed database  | Terminate and clean up    |
      | Provisioned VMs  | Terminate                 |
    And I should see detailed error logs:
      | field              | value                              |
      | error_type         | DatabaseProvisioningFailed         |
      | error_message      | Insufficient storage quota         |
      | failed_step        | 3 of 7                             |
      | resources_cleaned  | 3                                  |
    And retry should be available after resolving the issue
    And a DeploymentFailed event should be published

  Scenario: Handle region unreachable during management operations
    Given region "us-west" loses network connectivity
    When I attempt to perform management operations on "us-west"
    Then I should see error "Region temporarily unreachable"
    And I should see:
      | information            | value                              |
      | last_known_status      | Healthy at 09:25:00                |
      | connectivity_issue     | Network path unavailable           |
      | estimated_recovery     | Automatic retry in 30 seconds      |
    And other regions should remain fully manageable
    And a RegionUnreachable event should be published

  Scenario: Handle quota exceeded during scaling
    Given region "eu-west" scaling is requested
    And cloud provider quota for EC2 instances is exceeded
    When scaling attempts to provision new instances
    Then scaling should fail gracefully:
      | action              | result                              |
      | New instances       | Not provisioned                     |
      | Existing instances  | Remain operational                  |
      | Auto-scaling        | Temporarily disabled                |
    And alert should be sent:
      | field           | value                              |
      | alert_type      | QuotaExceeded                      |
      | resource        | EC2 instances                      |
      | region          | eu-west                            |
      | action_required | Request quota increase             |
    And quota increase request should be auto-generated

  Scenario: Handle partial regional failure
    Given region "us-east" has 5 app server instances
    When 2 instances become unhealthy
    Then load balancer should remove unhealthy instances
    And traffic should route to remaining 3 healthy instances
    And auto-scaling should attempt to replace failed instances
    And if replacement fails after 3 attempts:
      | action              | description                        |
      | Alert operations    | Notify about persistent failure    |
      | Enable overflow     | Route excess traffic to us-west    |
      | Capacity warning    | Update dashboard with degraded status |
