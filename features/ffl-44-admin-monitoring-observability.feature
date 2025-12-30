@admin @monitoring @observability @platform
Feature: Admin Monitoring and Observability
  As a platform administrator
  I want to implement comprehensive monitoring and observability
  So that I can ensure system reliability, performance, and proactive issue resolution

  Background:
    Given I am logged in as a platform administrator
    And I have monitoring and observability permissions
    And observability infrastructure is operational

  # ============================================
  # OBSERVABILITY DASHBOARD
  # ============================================

  @api @observability @dashboard
  Scenario: Access comprehensive observability dashboard
    When I send a GET request to "/api/v1/admin/observability/dashboard"
    Then the response status should be 200
    And the response should contain:
      | section              | description                              |
      | system_health        | Overall system health overview           |
      | active_alerts        | Count of active alerts by severity       |
      | key_performance      | Critical KPIs and performance indicators |
      | service_map          | Service dependency visualization         |
      | recent_incidents     | Last 5 incidents summary                 |

  @api @observability @dashboard
  Scenario: Dashboard real-time updates via WebSocket
    When I establish WebSocket connection to "/ws/admin/observability/metrics"
    Then I should receive metric updates within 15 seconds
    And anomalies should be highlighted in real-time
    And threshold breaches should trigger visual alerts

  @api @observability @dashboard
  Scenario: View dashboard with custom time range
    When I send a GET request to "/api/v1/admin/observability/dashboard?from=2024-01-01T00:00:00Z&to=2024-01-01T23:59:59Z"
    Then the response status should be 200
    And all metrics should reflect the specified time range
    And comparison data with previous period should be included

  # ============================================
  # APPLICATION PERFORMANCE MONITORING
  # ============================================

  @api @observability @apm
  Scenario: Monitor application performance metrics
    When I send a GET request to "/api/v1/admin/observability/apm/overview"
    Then the response status should be 200
    And the response should contain:
      | metric               | description                              |
      | response_time_p50    | 50th percentile response time            |
      | response_time_p95    | 95th percentile response time            |
      | response_time_p99    | 99th percentile response time            |
      | request_throughput   | Requests per second                      |
      | error_rate           | Percentage of failed requests            |
      | apdex_score          | Application performance index            |

  @api @observability @apm
  Scenario: View service performance breakdown
    When I send a GET request to "/api/v1/admin/observability/apm/services/api-gateway"
    Then the response status should be 200
    And the response should contain:
      | section              | description                              |
      | endpoint_metrics     | Performance metrics per endpoint         |
      | slowest_endpoints    | Top 10 slowest endpoints                 |
      | error_prone          | Endpoints with highest error rates       |
      | traffic_distribution | Request distribution by endpoint         |

  @api @observability @apm
  Scenario: Compare performance across time periods
    When I send a GET request to "/api/v1/admin/observability/apm/compare?current=this_week&previous=last_week"
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | performance_delta    | Change in performance metrics            |
      | trend_indicators     | Up/down/stable trend for each metric     |
      | regressions          | Identified performance regressions       |
      | improvements         | Identified performance improvements      |

  @api @observability @apm
  Scenario: Get endpoint-level latency breakdown
    When I send a GET request to "/api/v1/admin/observability/apm/endpoints/POST-api-v1-leagues"
    Then the response status should be 200
    And the response should contain latency percentiles
    And the response should include database time
    And the response should include external API time

  # ============================================
  # INFRASTRUCTURE MONITORING
  # ============================================

  @api @observability @infrastructure
  Scenario: Monitor infrastructure components
    When I send a GET request to "/api/v1/admin/observability/infrastructure"
    Then the response status should be 200
    And the response should contain:
      | metric               | description                              |
      | cpu_utilization      | CPU usage by host/container              |
      | memory_usage         | Memory usage and available               |
      | disk_io              | Disk read/write operations               |
      | disk_capacity        | Disk usage percentage                    |
      | network_throughput   | Network ingress/egress bytes             |

  @api @observability @infrastructure @kubernetes
  Scenario: Monitor Kubernetes cluster health
    When I send a GET request to "/api/v1/admin/observability/infrastructure/kubernetes"
    Then the response status should be 200
    And the response should contain:
      | section              | description                              |
      | node_status          | Health status of all nodes               |
      | pod_health           | Running/pending/failed pod counts        |
      | resource_usage       | Requests vs limits utilization           |
      | pending_pods         | Pods waiting for scheduling              |
      | deployment_status    | Status of all deployments                |

  @api @observability @infrastructure @database
  Scenario: Monitor database health
    When I send a GET request to "/api/v1/admin/observability/infrastructure/database"
    Then the response status should be 200
    And the response should contain:
      | metric               | description                              |
      | connection_pool      | Active/idle/max connections              |
      | query_latency        | Average query execution time             |
      | replication_lag      | Seconds behind primary                   |
      | slow_queries         | Queries exceeding threshold              |
      | deadlocks            | Recent deadlock count                    |

  # ============================================
  # CENTRALIZED LOGGING
  # ============================================

  @api @observability @logging
  Scenario: Access centralized log aggregation
    When I send a GET request to "/api/v1/admin/observability/logs?limit=100"
    Then the response status should be 200
    And the response should contain logs from all services
    And each log entry should include timestamp, service, level, and message

  @api @observability @logging
  Scenario: Search logs with complex queries
    When I send a POST request to "/api/v1/admin/observability/logs/search" with:
      """json
      {
        "query": "level:error AND service:api-gateway",
        "from": "2024-01-01T00:00:00Z",
        "to": "2024-01-01T23:59:59Z",
        "limit": 50,
        "offset": 0
      }
      """
    Then the response status should be 200
    And the response should contain matching log entries
    And results should be paginated
    And total count should be included

  @api @observability @logging
  Scenario: Export log search results
    When I send a POST request to "/api/v1/admin/observability/logs/export" with:
      """json
      {
        "query": "level:error",
        "from": "2024-01-01T00:00:00Z",
        "to": "2024-01-01T23:59:59Z",
        "format": "csv"
      }
      """
    Then the response status should be 202
    And export job should be created
    And download link should be provided when ready

  @api @observability @logging
  Scenario: Create log-based alert
    When I send a POST request to "/api/v1/admin/observability/logs/alerts" with:
      """json
      {
        "name": "High Error Rate",
        "query": "level:error",
        "threshold": 10,
        "window_minutes": 1,
        "severity": "critical",
        "channels": ["slack", "pagerduty"]
      }
      """
    Then the response status should be 201
    And alert should be active
    And a LogAlertCreatedEvent should be published

  @api @observability @logging
  Scenario: Configure log retention policy
    When I send a PUT request to "/api/v1/admin/observability/logs/retention" with:
      """json
      {
        "retention_days": 30,
        "archive_days": 90,
        "archive_storage": "s3"
      }
      """
    Then the response status should be 200
    And retention policy should be updated
    And archived logs should remain searchable

  # ============================================
  # DISTRIBUTED TRACING
  # ============================================

  @api @observability @tracing
  Scenario: View distributed traces
    When I send a GET request to "/api/v1/admin/observability/traces?limit=20"
    Then the response status should be 200
    And the response should contain traces with:
      | field                | description                              |
      | trace_id             | Unique trace identifier                  |
      | root_service         | Service that initiated the request       |
      | total_duration_ms    | End-to-end latency                       |
      | span_count           | Number of spans in trace                 |
      | has_errors           | Whether trace contains errors            |

  @api @observability @tracing
  Scenario: Get specific trace details
    Given trace with ID "abc123" exists
    When I send a GET request to "/api/v1/admin/observability/traces/abc123"
    Then the response status should be 200
    And the response should contain:
      | section              | description                              |
      | spans                | All spans in the trace                   |
      | timing_breakdown     | Duration per service                     |
      | error_details        | Any errors in the chain                  |
      | metadata             | Request headers, parameters              |

  @api @observability @tracing
  Scenario: Analyze trace bottlenecks
    When I send a GET request to "/api/v1/admin/observability/traces/analysis?period=24h"
    Then the response status should be 200
    And the response should contain:
      | section              | description                              |
      | high_latency_services| Services with highest latency            |
      | dependency_heatmap   | Latency between service pairs            |
      | critical_path        | Most common critical paths               |
      | bottleneck_frequency | How often each service is bottleneck     |

  @api @observability @tracing
  Scenario: Correlate traces with logs
    Given trace with ID "abc123" exists
    When I send a GET request to "/api/v1/admin/observability/traces/abc123/logs"
    Then the response status should be 200
    And the response should contain logs linked by trace context
    And logs should be ordered by timestamp

  # ============================================
  # ALERTING SYSTEM
  # ============================================

  @api @observability @alerting
  Scenario: Create alert rule
    When I send a POST request to "/api/v1/admin/observability/alerts/rules" with:
      """json
      {
        "name": "High Error Rate",
        "condition": "error_rate > 5%",
        "duration_minutes": 5,
        "severity": "critical",
        "channels": ["slack", "pagerduty"],
        "labels": {"team": "platform", "priority": "p1"}
      }
      """
    Then the response status should be 201
    And alert rule should be active
    And an AlertRuleCreatedEvent should be published

  @api @observability @alerting
  Scenario: Enable anomaly-based alerting
    When I send a POST request to "/api/v1/admin/observability/alerts/anomaly" with:
      """json
      {
        "metric": "request_latency_p99",
        "enabled": true,
        "sensitivity": "medium",
        "learning_period_days": 7
      }
      """
    Then the response status should be 200
    And baseline should be learned automatically
    And alerts should trigger on statistical deviations

  @api @observability @alerting
  Scenario: Configure alert routing rules
    When I send a PUT request to "/api/v1/admin/observability/alerts/routing" with:
      """json
      {
        "rules": [
          {"severity": "critical", "time": "any", "route": "on-call-engineer"},
          {"severity": "high", "time": "business_hours", "route": "team-lead"},
          {"severity": "high", "time": "after_hours", "route": "on-call"}
        ]
      }
      """
    Then the response status should be 200
    And routing rules should be active
    And alerts should route according to rules

  @api @observability @alerting
  Scenario: Configure alert escalation policy
    When I send a PUT request to "/api/v1/admin/observability/alerts/escalation" with:
      """json
      {
        "policy": [
          {"step": 1, "wait_minutes": 0, "action": "notify_primary"},
          {"step": 2, "wait_minutes": 5, "action": "notify_secondary"},
          {"step": 3, "wait_minutes": 15, "action": "page_manager"}
        ]
      }
      """
    Then the response status should be 200
    And unacknowledged alerts should escalate according to policy

  @api @observability @alerting
  Scenario: View alert history
    When I send a GET request to "/api/v1/admin/observability/alerts/history?days=7"
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | alert_id             | Unique alert identifier                  |
      | rule_name            | Name of triggered rule                   |
      | triggered_at         | When alert was triggered                 |
      | resolved_at          | When alert was resolved                  |
      | resolution_time_min  | Time to resolution                       |
      | acknowledged_by      | Who acknowledged the alert               |

  # ============================================
  # METRICS AND TIME-SERIES
  # ============================================

  @api @observability @metrics
  Scenario: View metrics catalog
    When I send a GET request to "/api/v1/admin/observability/metrics/catalog"
    Then the response status should be 200
    And the response should contain all collected metrics
    And each metric should include name, type, and cardinality

  @api @observability @metrics
  Scenario: Create custom metric
    When I send a POST request to "/api/v1/admin/observability/metrics" with:
      """json
      {
        "name": "user_session_duration",
        "type": "histogram",
        "labels": ["tier", "region"],
        "description": "Duration of user sessions in seconds",
        "buckets": [10, 30, 60, 120, 300, 600]
      }
      """
    Then the response status should be 201
    And metric should be registered
    And dashboards can use this metric

  @api @observability @metrics
  Scenario: Query metrics with PromQL
    When I send a POST request to "/api/v1/admin/observability/metrics/query" with:
      """json
      {
        "query": "rate(http_requests_total[5m])",
        "start": "2024-01-01T00:00:00Z",
        "end": "2024-01-01T23:59:59Z",
        "step": "1m"
      }
      """
    Then the response status should be 200
    And the response should contain time-series data
    And data points should match the step interval

  # ============================================
  # SYNTHETIC MONITORING
  # ============================================

  @api @observability @synthetic
  Scenario: Create synthetic HTTP test
    When I send a POST request to "/api/v1/admin/observability/synthetic/tests" with:
      """json
      {
        "name": "API Health Check",
        "type": "HTTP",
        "url": "https://api.example.com/health",
        "method": "GET",
        "interval_seconds": 60,
        "locations": ["us-east", "eu-west", "ap-south"],
        "assertions": [
          {"type": "status_code", "value": 200},
          {"type": "response_time_ms", "operator": "lt", "value": 500}
        ]
      }
      """
    Then the response status should be 201
    And test should run from all locations
    And failures should trigger alerts

  @api @observability @synthetic
  Scenario: Create multi-step browser synthetic test
    When I send a POST request to "/api/v1/admin/observability/synthetic/tests" with:
      """json
      {
        "name": "Login Flow",
        "type": "BROWSER",
        "interval_seconds": 300,
        "steps": [
          {"action": "navigate", "url": "/login", "assertion": {"type": "element_visible", "selector": "#login-form"}},
          {"action": "fill", "selector": "#email", "value": "test@example.com"},
          {"action": "fill", "selector": "#password", "value": "********"},
          {"action": "click", "selector": "#submit-btn", "assertion": {"type": "url_contains", "value": "/dashboard"}}
        ]
      }
      """
    Then the response status should be 201
    And user journey should be monitored

  @api @observability @synthetic
  Scenario: View synthetic test results
    Given synthetic test "API Health Check" exists
    When I send a GET request to "/api/v1/admin/observability/synthetic/tests/api-health-check/results?period=24h"
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | uptime_percent       | Availability percentage                  |
      | response_time_avg    | Average response time                    |
      | response_by_location | Response time per location               |
      | failure_history      | Recent failures with details             |

  # ============================================
  # BUSINESS METRICS
  # ============================================

  @api @observability @business
  Scenario: View business metrics dashboard
    When I send a GET request to "/api/v1/admin/observability/business/metrics"
    Then the response status should be 200
    And the response should contain:
      | metric               | description                              |
      | active_users_rt      | Real-time active users                   |
      | transactions_ps      | Transactions per second                  |
      | revenue_rate         | Revenue per hour                         |
      | conversion_funnel    | Funnel conversion rates                  |

  @api @observability @business
  Scenario: Configure business KPI tracking
    When I send a POST request to "/api/v1/admin/observability/business/kpis" with:
      """json
      {
        "name": "Daily Active Users",
        "metric": "active_users_daily",
        "thresholds": [
          {"level": "warning", "condition": "< 1000", "channel": "slack"},
          {"level": "critical", "condition": "< 500", "channel": "pagerduty"}
        ]
      }
      """
    Then the response status should be 201
    And KPI should be monitored
    And threshold breaches should trigger alerts

  # ============================================
  # SECURITY MONITORING
  # ============================================

  @api @observability @security
  Scenario: View security monitoring dashboard
    When I send a GET request to "/api/v1/admin/observability/security"
    Then the response status should be 200
    And the response should contain:
      | metric               | description                              |
      | auth_failures        | Failed authentication attempts           |
      | suspicious_ips       | IPs with unusual activity                |
      | authz_violations     | Authorization policy violations          |
      | api_abuse_patterns   | Detected API abuse patterns              |

  @api @observability @security
  Scenario: Configure security alert
    When I send a POST request to "/api/v1/admin/observability/security/alerts" with:
      """json
      {
        "type": "brute_force_detection",
        "threshold_failures": 10,
        "window_minutes": 5,
        "action": "block_ip",
        "notify": ["security-team"]
      }
      """
    Then the response status should be 201
    And failed login patterns should be monitored
    And suspicious activity should trigger alerts

  # ============================================
  # CUSTOM DASHBOARDS
  # ============================================

  @api @observability @dashboards
  Scenario: Create custom monitoring dashboard
    When I send a POST request to "/api/v1/admin/observability/dashboards" with:
      """json
      {
        "name": "API Performance",
        "panels": [
          {"title": "Request Rate", "metric": "http_requests_total", "visualization": "line_chart"},
          {"title": "Error Rate", "metric": "http_errors_total", "visualization": "gauge"},
          {"title": "Latency p99", "metric": "http_latency_p99", "visualization": "line_chart"}
        ]
      }
      """
    Then the response status should be 201
    And dashboard should be saved
    And panels should be configured correctly

  @api @observability @dashboards
  Scenario: Share dashboard with team
    Given dashboard "API Performance" exists
    When I send a POST request to "/api/v1/admin/observability/dashboards/api-performance/share" with:
      """json
      {
        "team": "engineering-team",
        "permission": "view"
      }
      """
    Then the response status should be 200
    And team members should have view access

  # ============================================
  # INCIDENT MANAGEMENT
  # ============================================

  @api @observability @incidents
  Scenario: Automatic incident creation from critical alert
    Given a critical alert fires for "API Gateway Down"
    When the alert is processed
    Then an incident should be created automatically
    And on-call engineer should be paged
    And an IncidentCreatedEvent should be published

  @api @observability @incidents
  Scenario: View incident timeline
    Given incident "INC-123" exists
    When I send a GET request to "/api/v1/admin/observability/incidents/INC-123/timeline"
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | related_alerts       | All alerts associated with incident      |
      | metrics_snapshot     | Key metrics at incident time             |
      | actions_taken        | Actions logged during incident           |
      | status_changes       | History of status transitions            |

  @api @observability @incidents
  Scenario: Generate post-incident report
    Given incident "INC-123" is resolved
    When I send a POST request to "/api/v1/admin/observability/incidents/INC-123/report"
    Then the response status should be 200
    And the response should contain:
      | section              | description                              |
      | root_cause_timeline  | Sequence of events leading to incident   |
      | affected_services    | Services impacted                        |
      | remediation_steps    | Actions taken to resolve                 |
      | lessons_learned      | Recommendations for prevention           |

  # ============================================
  # SLO/SLI MANAGEMENT
  # ============================================

  @api @observability @slo
  Scenario: Define service level objective
    When I send a POST request to "/api/v1/admin/observability/slos" with:
      """json
      {
        "name": "API Availability",
        "target_percent": 99.9,
        "window_days": 30,
        "indicator": "successful_requests / total_requests",
        "alert_on_burn_rate": 2.0
      }
      """
    Then the response status should be 201
    And SLO should be tracked
    And error budget should be calculated

  @api @observability @slo
  Scenario: View error budget status
    Given SLO "API Availability" exists
    When I send a GET request to "/api/v1/admin/observability/slos/api-availability/budget"
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | remaining_budget     | Remaining error budget percentage        |
      | consumed_budget      | Consumed error budget percentage         |
      | burn_rate            | Current burn rate                        |
      | projected_exhaustion | Projected date of budget exhaustion      |

  @api @observability @slo
  Scenario: Alert on error budget burn rate
    Given SLO "API Availability" exists
    And error budget burn rate exceeds 2x
    When the burn rate is evaluated
    Then a warning alert should be triggered
    And team should be notified via configured channels

  # ============================================
  # CAPACITY PLANNING
  # ============================================

  @api @observability @capacity
  Scenario: View capacity planning dashboard
    When I send a GET request to "/api/v1/admin/observability/capacity"
    Then the response status should be 200
    And the response should contain:
      | section              | description                              |
      | utilization_trends   | Resource usage trends over time          |
      | growth_projections   | Projected growth based on trends         |
      | scaling_recommendations| Suggested scaling actions               |
      | cost_implications    | Cost impact of recommendations           |

  @api @observability @capacity
  Scenario: Forecast resource needs
    When I send a POST request to "/api/v1/admin/observability/capacity/forecast" with:
      """json
      {
        "horizon_days": 90,
        "resources": ["cpu", "memory", "storage"],
        "confidence_level": 0.95
      }
      """
    Then the response status should be 200
    And the response should contain predicted requirements
    And the response should include cost projections

  # ============================================
  # HEALTH CHECKS
  # ============================================

  @api @observability @health
  Scenario: Configure service health check
    When I send a POST request to "/api/v1/admin/observability/health/checks" with:
      """json
      {
        "service": "api-service",
        "checks": [
          {"type": "liveness", "endpoint": "/health/live", "interval_seconds": 10, "timeout_seconds": 5},
          {"type": "readiness", "endpoint": "/health/ready", "interval_seconds": 30, "timeout_seconds": 10}
        ]
      }
      """
    Then the response status should be 201
    And health should be monitored continuously
    And failures should trigger alerts

  @api @observability @health
  Scenario: View service health overview
    When I send a GET request to "/api/v1/admin/observability/health/overview"
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | services             | All services with health status          |
      | dependency_health    | Health of service dependencies           |
      | recent_events        | Recent health state changes              |

  # ============================================
  # DATA GOVERNANCE
  # ============================================

  @api @observability @governance
  Scenario: Configure observability data retention
    When I send a PUT request to "/api/v1/admin/observability/governance/retention" with:
      """json
      {
        "policies": [
          {"data_type": "metrics", "retention_days": 30, "archive_days": 365},
          {"data_type": "logs", "retention_days": 14, "archive_days": 90},
          {"data_type": "traces", "retention_days": 7, "archive_days": 30}
        ]
      }
      """
    Then the response status should be 200
    And retention policies should be applied
    And storage cost estimate should be returned

  @api @observability @governance
  Scenario: View data storage costs
    When I send a GET request to "/api/v1/admin/observability/governance/costs"
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | metrics_cost         | Storage cost for metrics                 |
      | logs_cost            | Storage cost for logs                    |
      | traces_cost          | Storage cost for traces                  |
      | total_monthly        | Total monthly storage cost               |
      | projected_growth     | Projected cost growth                    |

  # ============================================
  # ERROR SCENARIOS
  # ============================================

  @api @observability @error
  Scenario: Handle metrics collection failure
    Given metrics collector is unavailable
    When I send a GET request to "/api/v1/admin/observability/dashboard"
    Then the response status should be 206
    And the response should indicate "Metrics temporarily unavailable"
    And last known values should be displayed
    And an alert should be sent to ops team

  @api @observability @error
  Scenario: Handle log ingestion backlog
    Given log volume exceeds ingestion capacity
    When I send a GET request to "/api/v1/admin/observability/logs/pipeline/status"
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | backlog_size         | Number of logs pending ingestion         |
      | ingestion_rate       | Current ingestion rate                   |
      | estimated_catchup    | Estimated time to clear backlog          |

  @api @observability @error @authorization
  Scenario: Unauthorized access to observability features
    Given I am logged in as a regular user without monitoring permissions
    When I send a GET request to "/api/v1/admin/observability/dashboard"
    Then the response status should be 403
    And the response should contain error "Access denied to observability features"

  # ============================================
  # DOMAIN EVENTS
  # ============================================

  @domain @events
  Scenario: Emit domain events for observability operations
    Given observability operations occur
    Then the following domain events should be emitted:
      | event_type                      | payload                               |
      | AlertRuleCreatedEvent           | rule_id, name, condition, severity    |
      | AlertRuleUpdatedEvent           | rule_id, changes                      |
      | AlertTriggeredEvent             | alert_id, rule_id, severity, value    |
      | AlertAcknowledgedEvent          | alert_id, admin_id, note              |
      | AlertResolvedEvent              | alert_id, admin_id, resolution        |
      | IncidentCreatedEvent            | incident_id, title, severity          |
      | IncidentResolvedEvent           | incident_id, resolution, duration     |
      | SLOCreatedEvent                 | slo_id, name, target, window          |
      | SLOBudgetBurnAlertEvent         | slo_id, burn_rate, remaining_budget   |
      | SyntheticTestCreatedEvent       | test_id, name, type, locations        |
      | SyntheticTestFailedEvent        | test_id, location, error              |
      | DashboardCreatedEvent           | dashboard_id, name, admin_id          |
      | LogAlertCreatedEvent            | alert_id, query, threshold            |
    And events should be published for analytics and audit
