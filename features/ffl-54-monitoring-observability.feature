@monitoring @observability @infrastructure @devops
Feature: FFL-54: Application Monitoring and Observability
  As a DevOps engineer
  I want comprehensive monitoring and observability for the FFL Playoffs application
  So that I can ensure system health, debug issues, and optimize performance

  Background:
    Given the FFL Playoffs application is deployed
    And the observability stack is configured
    And monitoring endpoints are accessible

  # ==========================================
  # PROMETHEUS METRICS - APPLICATION METRICS
  # ==========================================

  @prometheus @metrics @application
  Scenario: Expose application metrics via Prometheus endpoint
    Given the application is running
    When I request the "/actuator/prometheus" endpoint
    Then I should receive a 200 OK response
    And the response should be in Prometheus text format
    And the response should contain standard JVM metrics
    And the response should contain custom application metrics

  @prometheus @metrics @jvm
  Scenario: Collect JVM metrics
    Given the application is running with Micrometer configured
    When I scrape the Prometheus metrics endpoint
    Then I should see JVM metrics including:
      | metric_name                    | description                    |
      | jvm_memory_used_bytes          | Current memory usage           |
      | jvm_memory_max_bytes           | Maximum memory                 |
      | jvm_memory_committed_bytes     | Committed memory               |
      | jvm_gc_pause_seconds           | GC pause duration              |
      | jvm_gc_memory_allocated_bytes  | Memory allocated by GC         |
      | jvm_threads_live_threads       | Current live threads           |
      | jvm_threads_peak_threads       | Peak thread count              |
      | jvm_classes_loaded_classes     | Loaded class count             |

  @prometheus @metrics @http
  Scenario: Collect HTTP request metrics
    Given the application is handling HTTP requests
    When multiple API calls are made to various endpoints
    And I scrape the Prometheus metrics endpoint
    Then I should see HTTP metrics including:
      | metric_name                          | labels                      |
      | http_server_requests_seconds_count   | method, uri, status         |
      | http_server_requests_seconds_sum     | method, uri, status         |
      | http_server_requests_seconds_max     | method, uri, status         |
    And I should see request counts by endpoint
    And I should see request durations in histogram buckets

  @prometheus @metrics @custom
  Scenario: Collect custom business metrics
    Given the application is processing fantasy football operations
    When I scrape the Prometheus metrics endpoint
    Then I should see custom business metrics:
      | metric_name                      | type      | description                    |
      | ffl_roster_submissions_total     | counter   | Total roster submissions       |
      | ffl_score_calculations_total     | counter   | Score calculations performed   |
      | ffl_active_leagues_gauge         | gauge     | Currently active leagues       |
      | ffl_active_users_gauge           | gauge     | Currently active users         |
      | ffl_nfl_api_calls_total          | counter   | NFL data API calls             |
      | ffl_nfl_api_latency_seconds      | histogram | NFL API response latency       |
      | ffl_cache_hits_total             | counter   | Cache hit count                |
      | ffl_cache_misses_total           | counter   | Cache miss count               |

  @prometheus @metrics @database
  Scenario: Collect database connection pool metrics
    Given the application is connected to MongoDB
    When I scrape the Prometheus metrics endpoint
    Then I should see database metrics:
      | metric_name                          | description                   |
      | mongodb_driver_pool_size             | Connection pool size          |
      | mongodb_driver_pool_checkedout       | Checked out connections       |
      | mongodb_driver_pool_waitqueuesize    | Wait queue size               |
      | mongodb_driver_commands_seconds      | Command execution time        |

  @prometheus @metrics @labels
  Scenario: Metrics include appropriate labels for filtering
    Given the application exposes Prometheus metrics
    When I analyze the metric labels
    Then all metrics should include standard labels:
      | label       | description                      |
      | application | Application name (ffl-playoffs)  |
      | environment | Deployment environment           |
      | instance    | Instance identifier              |
    And HTTP metrics should include:
      | label    | description              |
      | method   | HTTP method              |
      | uri      | Request URI pattern      |
      | status   | HTTP response status     |
      | outcome  | Success/failure outcome  |

  @prometheus @metrics @cardinality
  Scenario: Metric cardinality is controlled
    Given the application is configured for metrics
    When high-cardinality fields are encountered
    Then user IDs should not be used as metric labels
    And request paths should be normalized to patterns
    And unique identifiers should be excluded from labels
    And the total unique label combinations should be under 10000

  # ==========================================
  # PROMETHEUS METRICS - ALERTING RULES
  # ==========================================

  @prometheus @alerting @rules
  Scenario: Define alerting rules for critical metrics
    Given Prometheus alerting is configured
    When I review the alerting rules
    Then the following alert rules should be defined:
      | alert_name                  | condition                                    | severity |
      | HighErrorRate               | error_rate > 5% for 5 minutes                | critical |
      | HighLatency                 | p99_latency > 2s for 5 minutes               | warning  |
      | ServiceDown                 | up == 0 for 1 minute                         | critical |
      | HighMemoryUsage             | memory_usage > 85% for 10 minutes            | warning  |
      | HighCPUUsage                | cpu_usage > 80% for 10 minutes               | warning  |
      | DatabaseConnectionExhausted | pool_available == 0 for 1 minute             | critical |
      | NFLAPIErrors                | nfl_api_errors > 10 in 5 minutes             | warning  |
      | CacheHitRateLow             | cache_hit_rate < 70% for 15 minutes          | warning  |

  @prometheus @alerting @notifications
  Scenario: Alert notifications are sent to appropriate channels
    Given an alert condition is triggered
    When the alert fires
    Then notifications should be sent to:
      | channel      | severity_threshold |
      | Slack        | warning            |
      | PagerDuty    | critical           |
      | Email        | warning            |
    And the notification should include:
      | field       | description                    |
      | alert_name  | Name of the triggered alert    |
      | severity    | Alert severity level           |
      | description | Human-readable description     |
      | runbook_url | Link to troubleshooting guide  |
      | dashboard   | Link to relevant dashboard     |

  # ==========================================
  # GRAFANA DASHBOARDS
  # ==========================================

  @grafana @dashboard @overview
  Scenario: Application overview dashboard exists
    Given Grafana is configured with FFL Playoffs datasources
    When I access the "FFL Playoffs Overview" dashboard
    Then I should see the following panels:
      | panel_name              | visualization | description                      |
      | Request Rate            | graph         | Requests per second over time    |
      | Error Rate              | graph         | Error percentage over time       |
      | Response Time           | graph         | P50, P95, P99 latency            |
      | Active Users            | stat          | Current active user count        |
      | Active Leagues          | stat          | Current active league count      |
      | Service Health          | status map    | Health status of all services    |
      | Recent Errors           | table         | Latest error messages            |

  @grafana @dashboard @jvm
  Scenario: JVM performance dashboard exists
    Given Grafana is configured
    When I access the "JVM Performance" dashboard
    Then I should see panels for:
      | panel_name             | metrics_shown                          |
      | Heap Memory Usage      | Used, committed, max heap memory       |
      | Non-Heap Memory        | Metaspace, code cache usage            |
      | GC Activity            | GC pause time, frequency, reclaimed    |
      | Thread Activity        | Live, daemon, peak thread counts       |
      | Class Loading          | Loaded/unloaded class counts           |
      | CPU Usage              | Process and system CPU usage           |

  @grafana @dashboard @api
  Scenario: API performance dashboard exists
    Given Grafana is configured
    When I access the "API Performance" dashboard
    Then I should see panels for each API endpoint:
      | endpoint                | metrics_shown                          |
      | /api/auth/*             | Rate, latency, errors                  |
      | /api/leagues/*          | Rate, latency, errors                  |
      | /api/rosters/*          | Rate, latency, errors                  |
      | /api/scores/*           | Rate, latency, errors                  |
      | /api/players/*          | Rate, latency, errors                  |
    And I should be able to filter by:
      | filter       | options                           |
      | Time Range   | Last 1h, 6h, 24h, 7d, custom      |
      | Environment  | dev, staging, production          |
      | HTTP Method  | GET, POST, PUT, DELETE            |
      | Status Code  | 2xx, 4xx, 5xx                     |

  @grafana @dashboard @business
  Scenario: Business metrics dashboard exists
    Given Grafana is configured
    When I access the "FFL Business Metrics" dashboard
    Then I should see panels for:
      | panel_name              | description                            |
      | Roster Submissions      | Submissions per hour/day               |
      | Score Calculations      | Calculations per minute                |
      | League Activity         | League creation, joins, updates        |
      | User Engagement         | Active users, session duration         |
      | NFL Data Sync           | Sync frequency, data freshness         |
      | Feature Usage           | Usage of different app features        |

  @grafana @dashboard @infrastructure
  Scenario: Infrastructure dashboard exists
    Given Grafana is configured
    When I access the "Infrastructure" dashboard
    Then I should see panels for:
      | panel_name              | metrics_shown                          |
      | Container CPU           | CPU usage per container                |
      | Container Memory        | Memory usage per container             |
      | Network I/O             | Bytes in/out per service               |
      | Disk Usage              | Disk space usage                       |
      | MongoDB Stats           | Connections, operations, latency       |
      | Redis Stats             | Memory, connections, hit rate          |

  @grafana @dashboard @alerts
  Scenario: Alerts dashboard shows current and historical alerts
    Given Grafana is configured with alerting
    When I access the "Alerts" dashboard
    Then I should see:
      | section                 | content                               |
      | Active Alerts           | Currently firing alerts               |
      | Alert History           | Recent alert timeline                 |
      | Alert Statistics        | Alerts by severity, by service        |
      | Silences                | Currently active silences             |
    And I should be able to acknowledge alerts from the dashboard

  @grafana @dashboard @variables
  Scenario: Dashboards support template variables
    Given I am viewing any Grafana dashboard
    Then I should see template variable dropdowns for:
      | variable     | purpose                              |
      | environment  | Filter by env (dev/staging/prod)     |
      | service      | Filter by service name               |
      | instance     | Filter by specific instance          |
      | time_range   | Adjust time window                   |
    And changing variables should update all panels

  # ==========================================
  # STRUCTURED LOGGING
  # ==========================================

  @logging @structured @format
  Scenario: Application produces structured JSON logs
    Given the application is running
    When log events are generated
    Then all logs should be in JSON format
    And each log entry should contain:
      | field          | description                         |
      | timestamp      | ISO 8601 formatted timestamp        |
      | level          | Log level (DEBUG, INFO, WARN, ERROR)|
      | logger         | Logger name/class                   |
      | message        | Log message                         |
      | thread         | Thread name                         |
      | traceId        | Distributed trace ID                |
      | spanId         | Current span ID                     |

  @logging @structured @context
  Scenario: Logs include request context
    Given a user is making an API request
    When the request generates log entries
    Then the logs should include context fields:
      | field          | description                         |
      | requestId      | Unique request identifier           |
      | userId         | Authenticated user ID               |
      | sessionId      | User session identifier             |
      | clientIp       | Client IP address (anonymized)      |
      | userAgent      | Client user agent                   |
      | path           | Request path                        |
      | method         | HTTP method                         |

  @logging @structured @levels
  Scenario: Log levels are used appropriately
    Given the application is running
    When different types of events occur
    Then log levels should be applied as follows:
      | level   | usage                                           |
      | ERROR   | Exceptions, failures requiring attention        |
      | WARN    | Unexpected but handled conditions               |
      | INFO    | Significant business events, state changes      |
      | DEBUG   | Detailed diagnostic information                 |
      | TRACE   | Very detailed debugging, method entry/exit      |

  @logging @structured @sensitive
  Scenario: Sensitive data is not logged
    Given the application processes user data
    When log entries are created
    Then the following should never appear in logs:
      | sensitive_data     | reason                              |
      | passwords          | Security                            |
      | tokens             | Security                            |
      | full credit cards  | PCI compliance                      |
      | SSN                | PII protection                      |
      | API keys           | Security                            |
    And email addresses should be masked
    And user IDs should be hashed in production logs

  @logging @structured @correlation
  Scenario: Logs are correlated across services
    Given a request spans multiple services
    When each service logs events
    Then all logs should share the same traceId
    And logs should be searchable by traceId
    And the full request flow should be reconstructable

  @logging @aggregation @elk
  Scenario: Logs are aggregated in centralized system
    Given the ELK stack is configured
    When applications generate logs
    Then logs should be shipped to Elasticsearch
    And logs should be queryable in Kibana
    And logs should be retained for 30 days
    And log indices should be automatically rotated

  @logging @search @kibana
  Scenario: Logs are searchable in Kibana
    Given logs are aggregated in Elasticsearch
    When I access Kibana
    Then I should be able to search logs by:
      | search_criteria | example_query                       |
      | Full text       | "roster submission failed"          |
      | Log level       | level:ERROR                         |
      | Service         | service:roster-service              |
      | Time range      | Last 24 hours                       |
      | Trace ID        | traceId:abc123                      |
      | User ID         | userId:user_xyz                     |
    And I should be able to create saved searches
    And I should be able to create visualizations from logs

  @logging @performance
  Scenario: Logging does not impact application performance
    Given the application is under normal load
    When logging is enabled at INFO level
    Then log writing should be asynchronous
    And logging should add less than 1ms to request latency
    And log buffer overflow should not block the application
    And disk I/O for logging should be minimized

  # ==========================================
  # DISTRIBUTED TRACING - OPENTELEMETRY
  # ==========================================

  @tracing @opentelemetry @setup
  Scenario: OpenTelemetry is configured for distributed tracing
    Given the application is deployed
    When I check the OpenTelemetry configuration
    Then the following should be configured:
      | component          | configuration                        |
      | SDK                | OpenTelemetry Java SDK               |
      | Exporter           | OTLP exporter to collector           |
      | Propagator         | W3C Trace Context, Baggage           |
      | Sampler            | ParentBased with configurable ratio  |
      | Resource           | Service name, version, environment   |

  @tracing @opentelemetry @auto-instrumentation
  Scenario: Automatic instrumentation captures traces
    Given OpenTelemetry auto-instrumentation is enabled
    When a request flows through the application
    Then traces should be automatically captured for:
      | component              | captured_operations                  |
      | HTTP Server            | Incoming requests                    |
      | HTTP Client            | Outgoing HTTP calls                  |
      | MongoDB                | Database queries                     |
      | Redis                  | Cache operations                     |
      | Kafka                  | Message production/consumption       |
      | Spring MVC             | Controller method invocations        |

  @tracing @opentelemetry @spans
  Scenario: Traces contain meaningful spans
    Given a user submits their roster
    When the request is traced
    Then the trace should contain spans for:
      | span_name                    | attributes                          |
      | HTTP POST /api/rosters       | http.method, http.url, http.status  |
      | validateRoster               | roster.size, roster.valid           |
      | checkPlayerAvailability      | player.count                        |
      | MongoDB roster.insert        | db.operation, db.collection         |
      | notifyLeagueMembers          | notification.count                  |
    And each span should have start and end times
    And parent-child relationships should be correct

  @tracing @opentelemetry @custom-spans
  Scenario: Custom spans are created for business operations
    Given the application processes business logic
    When significant operations occur
    Then custom spans should be created for:
      | operation                    | span_attributes                     |
      | calculatePlayerScore         | player.id, week, score              |
      | processWeeklyResults         | league.id, week, matchups.count     |
      | syncNFLData                  | data.type, records.count            |
      | generateLeaderboard          | league.id, teams.count              |

  @tracing @opentelemetry @context-propagation
  Scenario: Trace context is propagated across services
    Given a request originates from the frontend
    When the request traverses multiple backend services
    Then the same trace ID should appear in:
      | service              | component                           |
      | API Gateway          | Envoy access logs                   |
      | Auth Service         | Authentication spans                |
      | Roster Service       | Business logic spans                |
      | Database             | Query spans                         |
    And W3C traceparent header should be forwarded

  @tracing @opentelemetry @sampling
  Scenario: Trace sampling is configured appropriately
    Given the application is in production
    When trace sampling is applied
    Then the sampling configuration should be:
      | rule                        | sample_rate                         |
      | Default                     | 10%                                 |
      | Errors                      | 100%                                |
      | Slow requests (>2s)         | 100%                                |
      | Health checks               | 0%                                  |
      | Debug header present        | 100%                                |

  @tracing @visualization @jaeger
  Scenario: Traces are visualized in Jaeger
    Given traces are exported to Jaeger
    When I access the Jaeger UI
    Then I should be able to:
      | action                     | description                          |
      | Search by service          | Find traces for specific service     |
      | Search by operation        | Find traces for specific endpoint    |
      | Search by duration         | Find slow traces                     |
      | Search by tags             | Find traces with specific attributes |
      | View trace timeline        | See span waterfall                   |
      | Compare traces             | Compare two trace timelines          |
      | View span details          | See span attributes and logs         |

  @tracing @opentelemetry @errors
  Scenario: Errors are captured in traces
    Given an error occurs during request processing
    When the trace is recorded
    Then the span should include:
      | attribute            | value                                |
      | status.code          | ERROR                                |
      | exception.type       | Exception class name                 |
      | exception.message    | Error message                        |
      | exception.stacktrace | Full stack trace                     |
    And the error should be searchable in Jaeger

  @tracing @opentelemetry @baggage
  Scenario: Baggage is used for cross-cutting concerns
    Given a request includes tenant context
    When baggage items are set
    Then the following should propagate across services:
      | baggage_key      | purpose                              |
      | tenant.id        | Multi-tenant context                 |
      | feature.flags    | Active feature flags                 |
      | request.priority | Request priority level               |
    And baggage should be accessible in any service

  # ==========================================
  # HEALTH CHECKS
  # ==========================================

  @health @liveness
  Scenario: Liveness probe indicates application is running
    Given the application is started
    When I request "/actuator/health/liveness"
    Then I should receive a 200 OK response
    And the response should indicate status "UP"
    And the check should complete within 100ms

  @health @readiness
  Scenario: Readiness probe indicates application can serve traffic
    Given the application is running
    When I request "/actuator/health/readiness"
    Then the response should check:
      | component        | required_status                      |
      | MongoDB          | Connected                            |
      | Redis            | Connected                            |
      | Disk Space       | Sufficient                           |
    And the response should indicate overall status

  @health @readiness @dependency-failure
  Scenario: Readiness fails when critical dependency is down
    Given the application is running
    And MongoDB becomes unavailable
    When I request "/actuator/health/readiness"
    Then I should receive a 503 Service Unavailable response
    And the response should indicate MongoDB is DOWN
    And Kubernetes should stop routing traffic

  @health @detailed
  Scenario: Detailed health information is available
    Given the application is running
    When I request "/actuator/health" with management access
    Then I should see detailed health for all components:
      | component        | details_shown                        |
      | mongo            | Connection status, version           |
      | redis            | Connection status, cluster info      |
      | diskSpace        | Total, free, threshold               |
      | nflApi           | Reachable, last successful call      |

  # ==========================================
  # OBSERVABILITY INTEGRATION
  # ==========================================

  @integration @correlation
  Scenario: Metrics, logs, and traces are correlated
    Given all observability components are configured
    When an error occurs in the application
    Then I should be able to:
      | step | action                                           |
      | 1    | See error rate spike in Grafana dashboard        |
      | 2    | Click through to find related logs in Kibana     |
      | 3    | Use traceId from logs to find trace in Jaeger    |
      | 4    | See full request flow and identify root cause    |

  @integration @exemplars
  Scenario: Prometheus exemplars link to traces
    Given exemplars are enabled in Prometheus
    When I view a histogram metric in Grafana
    Then I should see exemplar data points
    And clicking an exemplar should link to the trace in Jaeger
    And I should be able to investigate high-latency requests

  @integration @slo
  Scenario: SLO monitoring is configured
    Given SLOs are defined for the application
    When I view the SLO dashboard
    Then I should see:
      | SLO                     | target  | current | burn_rate |
      | Availability            | 99.9%   | 99.95%  | 0.5x      |
      | Latency (p99 < 500ms)   | 99%     | 98.5%   | 1.5x      |
      | Error Rate (< 1%)       | 99%     | 99.8%   | 0.2x      |
    And I should see error budget remaining
    And alerts should fire when burn rate is too high

  # ==========================================
  # PERFORMANCE AND SCALABILITY
  # ==========================================

  @performance @metrics-overhead
  Scenario: Metrics collection has minimal overhead
    Given the application is processing requests
    When metrics collection is enabled
    Then the additional latency should be less than 1ms per request
    And memory overhead should be less than 50MB
    And CPU overhead should be less than 2%

  @performance @tracing-overhead
  Scenario: Tracing has minimal overhead
    Given the application is processing requests
    When distributed tracing is enabled at 10% sampling
    Then the additional latency should be less than 2ms per request
    And the overhead should scale with sampling rate

  @scalability @high-cardinality
  Scenario: System handles high-cardinality data
    Given the application serves many users
    When metrics are collected with user context
    Then user IDs should not be metric labels
    And trace attributes should handle high cardinality
    And log aggregation should handle large log volumes

  @scalability @retention
  Scenario: Data retention is configured appropriately
    Given observability data is being collected
    Then retention policies should be:
      | data_type        | retention_period                     |
      | Metrics (raw)    | 15 days                              |
      | Metrics (1m avg) | 90 days                              |
      | Logs             | 30 days                              |
      | Traces           | 7 days                               |
    And old data should be automatically purged

  # ==========================================
  # SECURITY
  # ==========================================

  @security @access-control
  Scenario: Observability endpoints are secured
    Given the observability stack is deployed
    When accessing monitoring endpoints
    Then the following access controls should apply:
      | endpoint              | access_level                         |
      | /actuator/health      | Public (for load balancer)           |
      | /actuator/prometheus  | Prometheus service account only      |
      | Grafana dashboards    | Authenticated users                  |
      | Kibana                | Authenticated users                  |
      | Jaeger UI             | Authenticated users                  |

  @security @data-protection
  Scenario: Sensitive data is protected in observability tools
    Given observability data is collected
    When viewing data in monitoring tools
    Then PII should be masked or excluded
    And API keys should not appear in traces
    And passwords should not appear in logs
    And sensitive headers should be filtered

  # ==========================================
  # RUNBOOKS AND DOCUMENTATION
  # ==========================================

  @documentation @runbooks
  Scenario: Runbooks exist for common alerts
    Given alerts are configured
    When an alert fires
    Then there should be a runbook linked for:
      | alert                    | runbook_content                      |
      | HighErrorRate            | Debugging steps, escalation          |
      | ServiceDown              | Recovery steps, failover             |
      | HighLatency              | Performance investigation            |
      | DatabaseConnectionIssues | Connection pool tuning               |
    And runbooks should be accessible from alert notifications

  @documentation @dashboards
  Scenario: Dashboards have documentation
    Given Grafana dashboards are created
    When I view a dashboard
    Then each panel should have:
      | element           | description                          |
      | Title             | Clear, descriptive name              |
      | Description       | What the metric shows                |
      | Query             | Documented PromQL/query              |
    And the dashboard should have an overview description

  # ==========================================
  # DISASTER RECOVERY
  # ==========================================

  @disaster-recovery @backup
  Scenario: Observability configurations are backed up
    Given the observability stack is running
    Then the following should be backed up:
      | component         | backup_frequency                     |
      | Grafana           | Dashboards, datasources, alerts      |
      | Prometheus        | Alert rules, recording rules         |
      | Kibana            | Saved searches, visualizations       |
    And backups should be tested monthly
    And recovery should be documented

  @disaster-recovery @failover
  Scenario: Observability survives service restarts
    Given the application is being monitored
    When the application restarts
    Then Prometheus should detect the restart
    And metrics should resume collection within 30 seconds
    And no significant gap should appear in dashboards
    And alerts should not false-fire due to restart
