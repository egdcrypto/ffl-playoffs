@admin @debugging @ANIMA-1091
Feature: Admin Debugging Tools
  As a platform administrator
  I want access to advanced debugging tools
  So that I can quickly diagnose and resolve production issues

  Background:
    Given I am logged in as a platform administrator
    And I have debugging tools permissions
    And the debugging system is active

  # =============================================================================
  # DEBUG DASHBOARD
  # =============================================================================

  @dashboard @overview
  Scenario: View debugging dashboard
    When I navigate to the debugging dashboard
    Then I should see system health overview:
      | component           | status  | last_check   |
      | api_gateway         | healthy | 30 sec ago   |
      | database_cluster    | healthy | 15 sec ago   |
      | cache_service       | warning | 1 min ago    |
      | message_queue       | healthy | 45 sec ago   |
    And I should see active debugging sessions
    And I should see recent error summary
    And I should see quick action shortcuts

  @dashboard @alerts
  Scenario: View active debug alerts
    Given there are active issues in the system
    When I view the debug alerts panel
    Then I should see active alerts:
      | severity | alert_type      | component       | duration   |
      | critical | high_error_rate | scoring_service | 15 minutes |
      | warning  | slow_queries    | database        | 30 minutes |
      | info     | high_memory     | cache_service   | 5 minutes  |
    And I should be able to investigate each alert

  @dashboard @quick-actions
  Scenario: Access quick debugging actions
    Given I am on the debugging dashboard
    When I view quick actions
    Then I should see available actions:
      | action              | description                    |
      | start_trace         | Begin request tracing          |
      | capture_heap_dump   | Capture memory snapshot        |
      | enable_verbose_logs | Increase log verbosity         |
      | restart_service     | Gracefully restart a service   |
    And I should be able to execute any action

  @dashboard @search
  Scenario: Search debug data globally
    When I search for "NullPointerException"
    Then I should see results across:
      | source         | matches | timeframe    |
      | logs           | 45      | last 24 hrs  |
      | error_reports  | 12      | last 24 hrs  |
      | traces         | 8       | last 24 hrs  |
    And I should be able to filter results

  # =============================================================================
  # APPLICATION LOGS
  # =============================================================================

  @logs @analysis
  Scenario: Analyze application logs
    When I access the log analysis tool
    Then I should see log streams:
      | service             | log_level | volume      |
      | api_gateway         | info      | 5,000/min   |
      | scoring_service     | debug     | 2,500/min   |
      | user_service        | info      | 3,200/min   |
      | notification_service| warn      | 450/min     |
    And I should be able to filter by service
    And I should see log level distribution

  @logs @search
  Scenario: Search logs with advanced filters
    When I search logs with filters:
      | filter      | value                    |
      | service     | scoring_service          |
      | level       | error, warn              |
      | time_range  | last 1 hour              |
      | contains    | "calculation failed"     |
    Then I should see matching log entries
    And I should see log context for each entry
    And I should be able to export results

  @logs @streaming
  Scenario: Stream logs in real-time
    When I enable real-time log streaming for "api_gateway"
    Then I should see live log entries
    And entries should appear within 1 second of generation
    And I should be able to pause streaming
    And I should be able to apply live filters

  @logs @correlation
  Scenario: Correlate logs across services
    Given a request ID "req-abc-123" exists
    When I correlate logs for this request
    Then I should see logs from all services:
      | service             | entries | first_log   | last_log    |
      | api_gateway         | 3       | 10:00:00.00 | 10:00:00.05 |
      | scoring_service     | 8       | 10:00:00.02 | 10:00:00.45 |
      | database_adapter    | 2       | 10:00:00.10 | 10:00:00.12 |
    And I should see request flow visualization

  @logs @patterns
  Scenario: Detect log patterns and anomalies
    When I run log pattern analysis
    Then I should see detected patterns:
      | pattern                    | frequency | trend   | severity |
      | "Connection refused"       | 45/hour   | +120%   | warning  |
      | "Query timeout"            | 12/hour   | stable  | info     |
      | "Memory threshold exceeded"| 3/hour    | +200%   | critical |
    And I should see pattern timeline
    And I should see correlation with system events

  # =============================================================================
  # REQUEST TRACING
  # =============================================================================

  @tracing @distributed
  Scenario: Trace request across services
    When I initiate a trace for request "req-xyz-456"
    Then I should see the complete request path:
      | service             | operation        | duration | status  |
      | api_gateway         | route_request    | 5ms      | success |
      | auth_service        | validate_token   | 15ms     | success |
      | scoring_service     | calculate_score  | 180ms    | success |
      | database            | query_scores     | 45ms     | success |
      | cache_service       | store_result     | 8ms      | success |
    And I should see service dependency graph
    And I should see timing waterfall

  @tracing @live
  Scenario: Enable live request tracing
    When I enable live tracing:
      | setting          | value            |
      | sample_rate      | 10%              |
      | target_service   | scoring_service  |
      | capture_headers  | true             |
      | capture_body     | sanitized        |
    Then live tracing should be active
    And I should see traced requests in real-time
    And performance overhead should be minimal

  @tracing @search
  Scenario: Search historical traces
    When I search traces with criteria:
      | filter           | value            |
      | time_range       | last 24 hours    |
      | min_duration     | 500ms            |
      | status           | error            |
      | service          | any              |
    Then I should see matching traces
    And I should see trace summaries
    And I should be able to view trace details

  @tracing @comparison
  Scenario: Compare request traces
    Given I have two traces to compare
    When I compare trace "trace-001" with "trace-002"
    Then I should see comparison:
      | aspect          | trace_001 | trace_002 | difference |
      | total_duration  | 250ms     | 850ms     | +240%      |
      | db_time         | 45ms      | 380ms     | +744%      |
      | service_count   | 5         | 5         | same       |
    And I should see highlighted differences
    And I should see root cause suggestion

  @tracing @spans
  Scenario: Analyze trace spans in detail
    Given I am viewing a trace
    When I drill into span "database.query"
    Then I should see span details:
      | attribute       | value                    |
      | operation       | SELECT                   |
      | table           | player_scores            |
      | rows_scanned    | 15,000                   |
      | duration        | 180ms                    |
      | query           | [sanitized SQL]          |
    And I should see span events
    And I should see span annotations

  # =============================================================================
  # PERFORMANCE PROFILING
  # =============================================================================

  @profiling @cpu
  Scenario: Profile application CPU usage
    When I start CPU profiling for "scoring_service"
    Then I should see CPU profile data:
      | method                    | cpu_time | calls   | avg_time |
      | ScoreCalculator.compute   | 45%      | 12,000  | 0.8ms    |
      | PlayerStats.aggregate     | 25%      | 8,500   | 0.5ms    |
      | JsonSerializer.serialize  | 15%      | 24,000  | 0.2ms    |
    And I should see flame graph visualization
    And I should see CPU hotspots

  @profiling @memory
  Scenario: Profile memory allocation
    When I capture memory profile for "user_service"
    Then I should see memory allocation:
      | object_type       | instances | size     | retained  |
      | UserDTO           | 45,000    | 180 MB   | 180 MB    |
      | String            | 250,000   | 95 MB    | 45 MB     |
      | ArrayList         | 35,000    | 28 MB    | 12 MB     |
      | HashMap           | 12,000    | 45 MB    | 45 MB     |
    And I should see heap histogram
    And I should see GC activity

  @profiling @latency
  Scenario: Profile request latency
    When I profile latency for "api_gateway"
    Then I should see latency distribution:
      | percentile | latency |
      | p50        | 45ms    |
      | p75        | 85ms    |
      | p90        | 180ms   |
      | p99        | 450ms   |
      | p99.9      | 850ms   |
    And I should see latency histogram
    And I should see slow request samples

  @profiling @continuous
  Scenario: Enable continuous profiling
    When I enable continuous profiling:
      | setting          | value          |
      | services         | all            |
      | sample_rate      | 1%             |
      | retention        | 7 days         |
      | overhead_limit   | 2%             |
    Then continuous profiling should be active
    And historical profiles should be searchable
    And overhead should be monitored

  @profiling @comparison
  Scenario: Compare profiles before and after deployment
    When I compare profiles:
      | comparison       | before_deploy | after_deploy |
      | avg_cpu          | 35%           | 55%          |
      | avg_memory       | 2.5 GB        | 3.2 GB       |
      | avg_latency      | 120ms         | 180ms        |
    Then I should see regression analysis
    And I should see top regressions by method
    And I should see suggested optimizations

  # =============================================================================
  # DATABASE DEBUGGING
  # =============================================================================

  @database @issues
  Scenario: Debug database connection issues
    When I diagnose database connectivity
    Then I should see connection status:
      | pool_name        | active | idle | waiting | max  |
      | primary_pool     | 45     | 15   | 5       | 100  |
      | replica_pool     | 12     | 28   | 0       | 50   |
      | analytics_pool   | 8      | 12   | 0       | 30   |
    And I should see connection wait times
    And I should see connection errors

  @database @locks
  Scenario: Investigate database locks
    When I check for database locks
    Then I should see active locks:
      | lock_type     | table          | waiting | holder_query      | duration |
      | row_exclusive | player_scores  | 3       | UPDATE scores...  | 5 sec    |
      | share         | rosters        | 0       | SELECT FROM...    | 2 sec    |
    And I should see lock wait chains
    And I should be able to terminate blocking queries

  @database @deadlocks
  Scenario: Analyze deadlock events
    When I analyze recent deadlocks
    Then I should see deadlock history:
      | timestamp           | victim_query        | other_query         |
      | 2024-06-15 14:30:00 | UPDATE players...   | UPDATE scores...    |
      | 2024-06-15 12:15:00 | INSERT INTO trades..| UPDATE rosters...   |
    And I should see deadlock graphs
    And I should see prevention recommendations

  @database @replication
  Scenario: Debug replication lag
    When I check replication status
    Then I should see replica status:
      | replica          | lag        | status  | behind_bytes |
      | replica_1        | 0.5 sec    | healthy | 1.2 MB       |
      | replica_2        | 2.5 sec    | warning | 8.5 MB       |
      | replica_3        | 0.2 sec    | healthy | 0.5 MB       |
    And I should see replication timeline
    And I should see lag causes

  # =============================================================================
  # SLOW QUERY ANALYSIS
  # =============================================================================

  @queries @slow
  Scenario: Analyze slow queries
    When I access slow query analysis
    Then I should see slow queries:
      | query_hash | avg_time | calls | table_scans | index_used |
      | abc123     | 850ms    | 450   | yes         | partial    |
      | def456     | 520ms    | 1,200 | no          | yes        |
      | ghi789     | 380ms    | 2,800 | yes         | no         |
    And I should see query execution plans
    And I should see optimization suggestions

  @queries @explain
  Scenario: Explain query execution plan
    When I explain query "abc123"
    Then I should see execution plan:
      | step                    | rows_estimated | actual_rows | cost    |
      | Seq Scan on players     | 50,000         | 48,500      | 15,000  |
      | Filter on status        | 10,000         | 9,800       | 12,000  |
      | Sort by score           | 9,800          | 9,800       | 8,000   |
    And I should see missing index suggestions
    And I should see plan visualization

  @queries @optimization
  Scenario: Get query optimization recommendations
    When I request optimization for slow queries
    Then I should see recommendations:
      | query_hash | recommendation              | estimated_improvement |
      | abc123     | Add index on (status, date) | -70% time             |
      | def456     | Rewrite as JOIN             | -40% time             |
      | ghi789     | Add covering index          | -85% time             |
    And I should see implementation scripts
    And I should see impact analysis

  @queries @realtime
  Scenario: Monitor queries in real-time
    When I enable real-time query monitoring
    Then I should see live query stream:
      | query_type | count/sec | avg_time | errors |
      | SELECT     | 850       | 12ms     | 0.1%   |
      | INSERT     | 120       | 25ms     | 0.0%   |
      | UPDATE     | 85        | 35ms     | 0.2%   |
      | DELETE     | 15        | 20ms     | 0.0%   |
    And I should see query histogram
    And I should be able to capture samples

  # =============================================================================
  # API DEBUGGING
  # =============================================================================

  @api @debugging
  Scenario: Debug API endpoints
    When I access API debugging tools
    Then I should see endpoint status:
      | endpoint            | success_rate | avg_latency | errors_1hr |
      | GET /api/v1/scores  | 99.8%        | 85ms        | 12         |
      | POST /api/v1/trades | 98.5%        | 180ms       | 45         |
      | PUT /api/v1/rosters | 99.2%        | 120ms       | 28         |
    And I should see endpoint details on click

  @api @request-replay
  Scenario: Replay failed API requests
    Given a failed request is captured
    When I replay the request:
      | modify        | value                |
      | header        | X-Debug: true        |
      | query_param   | verbose=1            |
    Then the request should be replayed
    And I should see detailed response
    And I should see execution trace

  @api @mock
  Scenario: Mock API dependencies for debugging
    When I configure API mocking:
      | dependency        | mock_response       | delay   |
      | external_scores   | cached_data         | 0ms     |
      | payment_gateway   | success_response    | 50ms    |
      | notification_api  | async_accepted      | 10ms    |
    Then mocking should be enabled
    And API should use mocked responses
    And real calls should be bypassed

  @api @rate-limiting
  Scenario: Debug rate limiting issues
    When I investigate rate limiting for client "client-xyz"
    Then I should see rate limit status:
      | limit_type    | limit     | current | remaining | reset_in |
      | requests/min  | 1000      | 985     | 15        | 45 sec   |
      | requests/hour | 10000     | 8500    | 1500      | 25 min   |
    And I should see request history
    And I should see burst patterns

  @api @payload
  Scenario: Inspect API request and response payloads
    When I inspect request "req-abc-123"
    Then I should see payload details:
      | direction | size   | content_type     | compressed |
      | request   | 2.5 KB | application/json | no         |
      | response  | 15 KB  | application/json | gzip       |
    And I should see sanitized payload content
    And I should see validation results

  # =============================================================================
  # USER SESSION DEBUGGING
  # =============================================================================

  @sessions @debugging
  Scenario: Debug user session issues
    When I search for user session "user-123"
    Then I should see session details:
      | attribute       | value                    |
      | session_id      | sess-abc-456             |
      | created_at      | 2024-06-15 10:00:00      |
      | last_activity   | 2024-06-15 14:30:00      |
      | device          | iPhone 14, iOS 17.2      |
      | location        | New York, US             |
    And I should see session activity log
    And I should see authentication events

  @sessions @impersonation
  Scenario: Impersonate user for debugging
    Given proper authorization is obtained
    When I impersonate user "user-123"
    Then I should see the app as that user
    And all actions should be logged as impersonation
    And impersonation should have time limit
    And user should be notified of impersonation

  @sessions @state
  Scenario: Inspect session state
    When I inspect session state for "sess-abc-456"
    Then I should see state contents:
      | key                | value_type | size   |
      | user_preferences   | object     | 2.5 KB |
      | active_league      | string     | 36 B   |
      | roster_draft       | object     | 8 KB   |
      | notification_queue | array      | 1.2 KB |
    And I should see state history
    And I should be able to modify state for debugging

  @sessions @timeline
  Scenario: View user journey timeline
    When I view timeline for user "user-123"
    Then I should see activity timeline:
      | timestamp           | action              | result   | duration |
      | 14:30:00            | view_scores         | success  | 120ms    |
      | 14:28:00            | update_roster       | success  | 450ms    |
      | 14:25:00            | search_players      | success  | 85ms     |
      | 14:20:00            | login               | success  | 280ms    |
    And I should see errors in timeline
    And I should see performance issues

  # =============================================================================
  # ERROR INVESTIGATION
  # =============================================================================

  @errors @patterns
  Scenario: Investigate error patterns
    When I analyze error patterns
    Then I should see error clusters:
      | error_type              | count | first_seen  | last_seen   | trend   |
      | NullPointerException    | 145   | 2 hours ago | 5 min ago   | +45%    |
      | ConnectionTimeout       | 89    | 6 hours ago | 10 min ago  | stable  |
      | ValidationException     | 234   | 1 day ago   | 1 min ago   | -15%    |
    And I should see error distribution by service
    And I should see error correlation

  @errors @stacktrace
  Scenario: Analyze error stack traces
    When I analyze stack trace for error cluster "cluster-001"
    Then I should see aggregated stack trace
    And I should see common frames:
      | frame                              | occurrences |
      | ScoreCalculator.compute():125      | 145         |
      | PlayerService.getStats():89        | 145         |
      | RosterController.update():45       | 138         |
    And I should see variable values at error
    And I should see similar historical errors

  @errors @root-cause
  Scenario: Perform root cause analysis
    Given an error spike is detected
    When I perform root cause analysis
    Then I should see potential causes:
      | cause                     | confidence | evidence              |
      | Database connection pool  | 85%        | Pool exhausted logs   |
      | Recent deployment         | 70%        | Errors started at 3PM |
      | External API degradation  | 45%        | Increased latency     |
    And I should see timeline correlation
    And I should see recommended actions

  @errors @alerting
  Scenario: Configure error alerting
    When I configure error alerts:
      | condition              | threshold | window  | notify        |
      | error_rate             | > 5%      | 5 min   | oncall        |
      | new_error_type         | any       | instant | dev_team      |
      | error_spike            | +200%     | 10 min  | oncall, leads |
    Then alerts should be configured
    And I should see alert history

  # =============================================================================
  # MEMORY DEBUGGING
  # =============================================================================

  @memory @leaks
  Scenario: Debug memory leaks
    When I analyze memory for leaks in "user_service"
    Then I should see potential leaks:
      | object_type       | growth_rate | retained | suspects      |
      | SessionCache      | +5 MB/hr    | 450 MB   | high          |
      | EventListener     | +2 MB/hr    | 120 MB   | medium        |
      | BufferedImage     | +8 MB/hr    | 280 MB   | high          |
    And I should see memory growth timeline
    And I should see GC behavior

  @memory @heap-dump
  Scenario: Capture and analyze heap dump
    When I capture heap dump for "scoring_service"
    Then the heap dump should be captured
    And I should see heap summary:
      | metric              | value    |
      | heap_size           | 4 GB     |
      | objects             | 2.5M     |
      | classes             | 12,500   |
      | gc_roots            | 8,500    |
    And I should see dominator tree
    And I should see object references

  @memory @gc
  Scenario: Analyze garbage collection
    When I analyze GC for "api_gateway"
    Then I should see GC metrics:
      | gc_type     | count/hr | avg_pause | max_pause | reclaimed |
      | young_gc    | 120      | 25ms      | 85ms      | 2.5 GB    |
      | old_gc      | 5        | 180ms     | 450ms     | 1.2 GB    |
      | full_gc     | 0        | n/a       | n/a       | n/a       |
    And I should see GC timeline
    And I should see heap utilization

  @memory @allocation
  Scenario: Track memory allocation hotspots
    When I track allocation hotspots
    Then I should see top allocators:
      | location                    | allocations/sec | size/sec |
      | JsonParser.parse():145      | 15,000          | 45 MB    |
      | DTOMapper.convert():89      | 8,500           | 28 MB    |
      | StringBuffer.append():234   | 25,000          | 12 MB    |
    And I should see allocation flame graph
    And I should see optimization suggestions

  # =============================================================================
  # NETWORK DEBUGGING
  # =============================================================================

  @network @connectivity
  Scenario: Debug network connectivity issues
    When I diagnose network connectivity
    Then I should see connection status:
      | destination         | status    | latency | packet_loss |
      | database_primary    | connected | 2ms     | 0%          |
      | cache_cluster       | connected | 1ms     | 0%          |
      | external_api        | degraded  | 250ms   | 2%          |
      | message_queue       | connected | 3ms     | 0%          |
    And I should see network topology
    And I should see bandwidth utilization

  @network @dns
  Scenario: Debug DNS resolution
    When I check DNS resolution
    Then I should see DNS status:
      | hostname                | resolved_ip    | ttl    | cache_hit |
      | db.internal.ffl.com     | 10.0.1.15      | 300s   | yes       |
      | api.external.com        | 203.0.113.50   | 3600s  | yes       |
      | cache.internal.ffl.com  | 10.0.2.20      | 300s   | yes       |
    And I should see DNS query history
    And I should see resolution failures

  @network @tcp
  Scenario: Analyze TCP connections
    When I analyze TCP connections for "api_gateway"
    Then I should see connection details:
      | state         | count | avg_age  |
      | ESTABLISHED   | 450   | 45 sec   |
      | TIME_WAIT     | 125   | 60 sec   |
      | CLOSE_WAIT    | 12    | 5 min    |
    And I should see connection distribution
    And I should see connection anomalies

  @network @ssl
  Scenario: Debug SSL/TLS issues
    When I diagnose SSL configuration
    Then I should see SSL status:
      | endpoint            | protocol | cipher              | cert_expiry |
      | api.ffl.com         | TLS 1.3  | AES_256_GCM_SHA384  | 90 days     |
      | payments.ffl.com    | TLS 1.2  | AES_128_GCM_SHA256  | 45 days     |
    And I should see SSL handshake details
    And I should see certificate chain

  # =============================================================================
  # CONFIGURATION DEBUGGING
  # =============================================================================

  @config @issues
  Scenario: Debug configuration issues
    When I access configuration debugging
    Then I should see configuration sources:
      | source              | entries | last_updated | status  |
      | environment_vars    | 45      | deployment   | active  |
      | config_files        | 120     | 2 hours ago  | active  |
      | config_server       | 85      | 5 min ago    | active  |
      | feature_flags       | 35      | 1 min ago    | active  |
    And I should see configuration conflicts
    And I should see effective configuration

  @config @diff
  Scenario: Compare configurations across environments
    When I compare configuration:
      | env_1       | env_2       |
      | staging     | production  |
    Then I should see differences:
      | key                 | staging_value | prod_value   | impact   |
      | db.pool.size        | 20            | 100          | expected |
      | cache.ttl           | 300           | 600          | expected |
      | debug.enabled       | true          | false        | expected |
      | feature.new_ui      | true          | false        | review   |
    And I should see configuration recommendations

  @config @validation
  Scenario: Validate configuration
    When I validate configuration for "scoring_service"
    Then I should see validation results:
      | check                   | status  | message                |
      | required_keys           | pass    | All required present   |
      | type_validation         | pass    | All types correct      |
      | connection_strings      | warning | Using deprecated format|
      | feature_flags           | pass    | All flags valid        |
    And I should see validation details

  @config @history
  Scenario: View configuration change history
    When I view configuration history
    Then I should see recent changes:
      | timestamp           | key             | old_value | new_value | changed_by |
      | 2024-06-15 14:00    | cache.size      | 512MB     | 1GB       | ops-bot    |
      | 2024-06-15 12:00    | log.level       | INFO      | DEBUG     | admin      |
      | 2024-06-14 18:00    | api.timeout     | 30s       | 60s       | deploy     |
    And I should be able to rollback changes

  # =============================================================================
  # LOAD TESTING DEBUG
  # =============================================================================

  @load @debugging
  Scenario: Debug performance under load
    When I analyze load test results
    Then I should see performance under load:
      | load_level | requests/sec | avg_latency | error_rate | cpu   |
      | 100 rps    | 100          | 85ms        | 0.1%       | 25%   |
      | 500 rps    | 498          | 120ms       | 0.3%       | 55%   |
      | 1000 rps   | 985          | 250ms       | 1.2%       | 85%   |
      | 1500 rps   | 1200         | 850ms       | 8.5%       | 98%   |
    And I should see saturation point
    And I should see bottleneck analysis

  @load @bottlenecks
  Scenario: Identify load bottlenecks
    When I analyze bottlenecks during load
    Then I should see bottleneck analysis:
      | component       | saturation | limiting_factor     |
      | database        | 85%        | connection_pool     |
      | api_gateway     | 45%        | n/a                 |
      | cache           | 25%        | n/a                 |
      | cpu             | 92%        | scoring_calculation |
    And I should see resource utilization graphs
    And I should see scaling recommendations

  @load @stress
  Scenario: Run stress test for debugging
    When I run a stress test:
      | parameter        | value        |
      | target_rps       | 2000         |
      | ramp_up          | 5 minutes    |
      | duration         | 15 minutes   |
      | concurrent_users | 500          |
    Then the stress test should execute
    And I should see real-time metrics
    And I should see failure points

  # =============================================================================
  # REAL-TIME MONITORING
  # =============================================================================

  @realtime @monitoring
  Scenario: Monitor system in real-time
    When I enable real-time system monitoring
    Then I should see live metrics:
      | metric              | value    | trend   |
      | requests_per_second | 1,250    | +5%     |
      | active_connections  | 2,450    | stable  |
      | error_rate          | 0.3%     | -10%    |
      | avg_latency         | 125ms    | +8%     |
    And metrics should update every second
    And I should see threshold violations highlighted

  @realtime @dashboards
  Scenario: Create custom debug dashboard
    When I create a debug dashboard:
      | widget           | metric                | refresh |
      | gauge            | cpu_utilization       | 1s      |
      | line_chart       | request_rate          | 5s      |
      | heatmap          | error_distribution    | 10s     |
      | log_stream       | error_logs            | live    |
    Then the dashboard should be created
    And widgets should update in real-time

  @realtime @alerts
  Scenario: Configure real-time debug alerts
    When I configure real-time alerts:
      | condition              | threshold | action          |
      | latency_spike          | > 500ms   | notify_slack    |
      | error_burst            | > 10/min  | page_oncall     |
      | memory_critical        | > 90%     | auto_heap_dump  |
    Then alerts should be active
    And alerts should trigger immediately

  # =============================================================================
  # DEBUG SESSION MANAGEMENT
  # =============================================================================

  @sessions @management
  Scenario: Manage debugging sessions
    When I view active debugging sessions
    Then I should see sessions:
      | session_id  | user        | target_service  | started     | expires    |
      | debug-001   | admin@ffl   | scoring_service | 30 min ago  | in 30 min  |
      | debug-002   | ops@ffl     | api_gateway     | 1 hour ago  | in 2 hours |
    And I should be able to extend sessions
    And I should be able to terminate sessions

  @sessions @isolation
  Scenario: Create isolated debug environment
    When I create an isolated debug environment:
      | setting          | value                |
      | clone_from       | production           |
      | traffic_routing  | shadow               |
      | data_masking     | enabled              |
      | expiry           | 4 hours              |
    Then the debug environment should be created
    And traffic should be mirrored
    And changes should not affect production

  @sessions @recording
  Scenario: Record debugging session
    When I enable session recording
    Then all debug actions should be recorded
    And I should see recording timeline:
      | timestamp | action              | result     |
      | 14:00:00  | started_trace       | success    |
      | 14:05:00  | captured_heap_dump  | success    |
      | 14:10:00  | modified_config     | success    |
    And recording should be shareable

  @sessions @collaboration
  Scenario: Collaborate on debugging session
    When I invite team members to debug session
    Then invited members should see same view
    And actions should be synchronized
    And we should have shared cursor visibility
    And chat should be available in session

  # =============================================================================
  # INCIDENT INTEGRATION
  # =============================================================================

  @incident @integration
  Scenario: Integrate debugging with incident response
    Given an incident is open "INC-001"
    When I link debugging session to incident
    Then debug findings should be attached to incident
    And incident timeline should show debug actions
    And I should be able to add debug notes to incident

  @incident @automated
  Scenario: Automated debug data collection for incidents
    When an incident is triggered
    Then automated collection should gather:
      | data_type           | scope              | retention |
      | logs                | affected_services  | 7 days    |
      | traces              | related_requests   | 7 days    |
      | metrics             | time_window        | 30 days   |
      | config_snapshot     | current_state      | permanent |
    And data should be linked to incident

  @incident @postmortem
  Scenario: Generate debug report for postmortem
    When I generate debug report for incident "INC-001"
    Then the report should include:
      | section              | content                    |
      | timeline             | Debug actions with results |
      | root_cause           | Identified causes          |
      | evidence             | Logs, traces, metrics      |
      | recommendations      | Prevention measures        |
    And report should be exportable
    And report should link to raw data

  # =============================================================================
  # ERROR HANDLING AND EDGE CASES
  # =============================================================================

  @error-handling @debug-failure
  Scenario: Handle debug tool failure
    Given a debugging operation is in progress
    When the debug tool encounters an error
    Then the operation should fail gracefully
    And I should see clear error message
    And partial data should be preserved
    And retry should be available

  @error-handling @resource-limits
  Scenario: Handle resource limits during debugging
    Given heap dump would exceed available disk
    When I attempt to capture heap dump
    Then I should see resource warning
    And I should see alternative options:
      | option              | description              |
      | partial_dump        | Capture top 1000 objects |
      | stream_to_external  | Stream to S3 bucket      |
      | schedule_off_peak   | Capture during low load  |
    And I should be able to proceed with alternative

  @edge-case @production-safety
  Scenario: Ensure production safety during debugging
    Given I am debugging in production
    When I attempt a potentially dangerous action
    Then I should see safety warning
    And action should require additional confirmation
    And action should be logged with justification
    And rollback should be available

  @edge-case @sensitive-data
  Scenario: Handle sensitive data in debug output
    Given debug output contains sensitive data
    When I view the debug output
    Then sensitive data should be masked:
      | data_type       | masking          |
      | passwords       | ********         |
      | api_keys        | ****-****-xxx    |
      | credit_cards    | ****-****-****-1234 |
      | ssn             | ***-**-xxxx      |
    And I should be able to request unmasked view with approval
