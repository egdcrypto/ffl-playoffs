Feature: Admin API Management
  As a Platform Administrator
  I want to manage API infrastructure and operations
  So that I can ensure reliable and secure API services

  Background:
    Given I am authenticated as an admin with email "admin@example.com"
    And I have API management permissions
    And the API management system is enabled

  # ===========================================
  # API Management Dashboard
  # ===========================================

  Scenario: Admin views API management dashboard
    When the admin navigates to the API management dashboard
    Then the dashboard displays:
      | metric                    | description                          |
      | Total API Requests (24h)  | Number of API calls in last day      |
      | Active API Keys           | Currently active API credentials     |
      | API Health Score          | Overall API infrastructure health    |
      | Average Latency           | Mean response time                   |
      | Error Rate                | Percentage of failed requests        |
    And API status indicators are shown for each service

  Scenario: Admin views API health overview
    Given multiple API services are running
    When the admin views health status
    Then service health is displayed:
      | service              | status   | uptime  | latency | errors |
      | Players API          | Healthy  | 99.99%  | 45ms    | 0.01%  |
      | Scores API           | Healthy  | 99.95%  | 89ms    | 0.05%  |
      | Leagues API          | Degraded | 99.50%  | 234ms   | 0.50%  |
      | Auth API             | Healthy  | 99.99%  | 23ms    | 0.02%  |
    And degraded services are highlighted

  Scenario: Admin views real-time API traffic
    When the admin views traffic dashboard
    Then real-time metrics are displayed:
      | metric                | value        |
      | Requests/Second       | 1,245        |
      | Active Connections    | 892          |
      | Bandwidth Usage       | 45 MB/s      |
      | Cache Hit Rate        | 78%          |
    And traffic updates in real-time

  # ===========================================
  # API Version Management
  # ===========================================

  Scenario: Admin views API versions
    When the admin navigates to API versions
    Then versions are displayed:
      | version | status      | release_date | users  | traffic_pct |
      | v3.0    | Current     | 2024-01-01   | 12,450 | 65%         |
      | v2.1    | Supported   | 2023-06-01   | 5,890  | 30%         |
      | v2.0    | Deprecated  | 2023-01-01   | 890    | 5%          |
      | v1.0    | Sunset      | 2022-01-01   | 0      | 0%          |

  Scenario: Admin creates new API version
    Given the admin wants to release a new version
    When the admin creates version:
      | field               | value                          |
      | version             | v3.1                           |
      | release_date        | 2024-02-01                     |
      | changelog           | New predictions endpoint       |
      | breaking_changes    | None                           |
      | migration_required  | No                             |
    Then the version is created in draft status
    And documentation is generated

  Scenario: Admin promotes API version
    Given version v3.1 is in draft status
    When the admin promotes to production:
      | setting             | value              |
      | rollout_strategy    | Canary             |
      | initial_traffic     | 10%                |
      | monitoring_period   | 24 hours           |
    Then the version begins rollout
    And traffic gradually shifts

  Scenario: Admin deprecates API version
    Given version v2.0 needs deprecation
    When the admin deprecates the version:
      | setting             | value              |
      | deprecation_date    | 2024-03-01         |
      | sunset_date         | 2024-09-01         |
      | migration_guide     | /docs/v2-to-v3     |
    Then deprecation warnings are added to responses
    And affected users are notified

  Scenario: Admin configures version routing
    When the admin configures version routing:
      | rule                    | version | condition                |
      | Header Version          | v3.0    | X-API-Version: 3.0       |
      | URL Path                | v2.1    | /api/v2.1/*              |
      | Default                 | v3.0    | No version specified     |
      | Legacy Clients          | v2.0    | User-Agent: LegacyApp/*  |
    Then routing rules are applied
    And requests are directed appropriately

  # ===========================================
  # API Endpoint Configuration
  # ===========================================

  Scenario: Admin views API endpoints
    When the admin navigates to endpoint configuration
    Then endpoints are displayed:
      | endpoint             | method | auth_required | rate_limit | status   |
      | /players             | GET    | Yes           | 1000/hour  | Active   |
      | /players/{id}        | GET    | Yes           | 5000/hour  | Active   |
      | /scores/live         | GET    | Yes           | 500/min    | Active   |
      | /leagues             | POST   | Yes           | 100/hour   | Active   |
      | /admin/users         | GET    | Yes (Admin)   | 50/hour    | Active   |

  Scenario: Admin creates new endpoint
    When the admin creates an endpoint:
      | field               | value                          |
      | path                | /predictions/{playerId}        |
      | method              | GET                            |
      | description         | Get player predictions         |
      | auth_required       | Yes                            |
      | rate_limit          | 500/hour                       |
      | cache_ttl           | 5 minutes                      |
      | response_schema     | PlayerPredictionResponse       |
    Then the endpoint is registered
    And documentation is auto-generated

  Scenario: Admin configures endpoint caching
    Given an endpoint exists
    When the admin configures caching:
      | setting             | value              |
      | cache_enabled       | Yes                |
      | cache_ttl           | 300 seconds        |
      | cache_key           | playerId, week     |
      | vary_headers        | Accept, Authorization |
      | stale_while_revalidate | 60 seconds      |
    Then caching rules are applied
    And cache is populated on requests

  Scenario: Admin configures endpoint throttling
    Given an endpoint needs protection
    When the admin configures throttling:
      | setting             | value              |
      | burst_limit         | 50 requests        |
      | sustained_limit     | 1000/hour          |
      | penalty_duration    | 60 seconds         |
      | penalty_response    | 429 Too Many Requests |
    Then throttling is enabled
    And violations are tracked

  Scenario: Admin disables endpoint
    Given an endpoint needs maintenance
    When the admin disables the endpoint:
      | setting             | value              |
      | endpoint            | /scores/live       |
      | reason              | Scheduled maintenance |
      | response_code       | 503                |
      | retry_after         | 3600               |
      | notify_consumers    | Yes                |
    Then the endpoint returns maintenance response
    And consumers are notified

  # ===========================================
  # API Documentation
  # ===========================================

  Scenario: Admin views documentation status
    When the admin views documentation overview
    Then documentation status is displayed:
      | section              | status     | coverage | last_updated    |
      | API Reference        | Published  | 98%      | 2024-01-15      |
      | Authentication       | Published  | 100%     | 2024-01-10      |
      | Rate Limiting        | Published  | 100%     | 2024-01-12      |
      | Error Codes          | Published  | 95%      | 2024-01-08      |
      | Webhooks             | Draft      | 80%      | 2024-01-18      |

  Scenario: Admin generates API documentation
    When the admin generates documentation:
      | setting             | value                |
      | source              | OpenAPI Spec         |
      | format              | HTML, PDF, Markdown  |
      | include_examples    | Yes                  |
      | code_samples        | Python, JavaScript, Java |
    Then documentation is generated
    And published to the developer portal

  Scenario: Admin manages code examples
    Given documentation includes code samples
    When the admin updates examples:
      | endpoint            | language   | example_type |
      | /players            | Python     | Request/Response |
      | /scores/live        | JavaScript | WebSocket    |
      | /leagues            | Java       | Full CRUD    |
    Then code examples are updated
    And validated for correctness

  Scenario: Admin configures API playground
    When the admin sets up interactive playground:
      | setting             | value                |
      | enabled             | Yes                  |
      | authentication      | Sandbox API Keys     |
      | rate_limits         | 100 requests/hour    |
      | mock_data           | Yes                  |
      | request_logging     | Yes                  |
    Then the playground is available
    And developers can test API calls

  # ===========================================
  # API Key Management
  # ===========================================

  Scenario: Admin views API keys
    When the admin navigates to API key management
    Then keys are displayed:
      | key_name             | owner              | scope     | created     | last_used       |
      | Production Key       | partner@espn.com   | Full      | 2023-06-15  | 2 minutes ago   |
      | Test Key             | dev@sleeper.com    | Read-Only | 2023-09-20  | 1 hour ago      |
      | Internal Key         | system             | Admin     | 2023-01-01  | 5 minutes ago   |
    And key prefixes are shown (full keys masked)

  Scenario: Admin creates API key
    When the admin creates an API key:
      | field               | value                |
      | name                | Partner Integration  |
      | owner               | partner@example.com  |
      | scope               | Read-Only            |
      | rate_limit          | 10,000/hour          |
      | ip_whitelist        | 52.0.0.0/8           |
      | expiration          | 2025-01-01           |
    Then the API key is generated
    And the key is displayed once for copying
    And the hashed key is stored

  Scenario: Admin rotates API key
    Given an API key needs rotation
    When the admin initiates rotation:
      | setting             | value              |
      | key_name            | Production Key     |
      | grace_period        | 7 days             |
      | notify_owner        | Yes                |
    Then a new key is generated
    And both keys work during grace period
    And old key is invalidated after grace period

  Scenario: Admin revokes API key
    Given an API key is compromised
    When the admin revokes the key:
      | setting             | value              |
      | key_name            | Compromised Key    |
      | reason              | Security incident  |
      | immediate           | Yes                |
    Then the key is immediately invalidated
    And all active sessions are terminated
    And the owner is notified

  Scenario: Admin configures key permissions
    Given an API key exists
    When the admin configures permissions:
      | resource            | read  | write | delete |
      | Players             | Yes   | No    | No     |
      | Scores              | Yes   | No    | No     |
      | Leagues             | Yes   | Yes   | No     |
      | Users               | No    | No    | No     |
    Then permissions are updated
    And access is enforced immediately

  # ===========================================
  # Rate Limiting Configuration
  # ===========================================

  Scenario: Admin views rate limit configuration
    When the admin views rate limiting
    Then global limits are displayed:
      | tier                | requests/second | requests/hour | burst |
      | Free                | 10              | 1,000         | 20    |
      | Basic               | 50              | 10,000        | 100   |
      | Pro                 | 200             | 50,000        | 500   |
      | Enterprise          | 1,000           | 500,000       | 2,000 |

  Scenario: Admin configures rate limit tiers
    When the admin updates rate limits:
      | tier                | requests/second | requests/hour | burst | cost_per_overage |
      | Free                | 5               | 500           | 10    | Block            |
      | Basic               | 25              | 5,000         | 50    | $0.001           |
      | Pro                 | 100             | 25,000        | 200   | $0.0005          |
      | Enterprise          | 500             | 250,000       | 1,000 | $0.0001          |
    Then rate limits are updated
    And active clients are notified

  Scenario: Admin configures adaptive rate limiting
    When the admin enables adaptive limiting:
      | setting             | value                |
      | enabled             | Yes                  |
      | base_on             | Server Load          |
      | high_load_threshold | 80%                  |
      | reduction_factor    | 50%                  |
      | recovery_time       | 5 minutes            |
    Then adaptive limiting is active
    And limits adjust based on load

  Scenario: Admin views rate limit violations
    When the admin views violations
    Then violations are displayed:
      | client              | violations_24h | last_violation    | action_taken |
      | key_abc123          | 45             | 10 minutes ago    | Warning      |
      | key_def456          | 234            | 5 minutes ago     | Throttled    |
      | key_ghi789          | 1,234          | 1 minute ago      | Blocked      |
    And violation trends are shown

  # ===========================================
  # API Gateway Configuration
  # ===========================================

  Scenario: Admin views gateway configuration
    When the admin views gateway settings
    Then configuration is displayed:
      | setting             | value                |
      | Load Balancer       | Round Robin          |
      | SSL/TLS Version     | TLS 1.3              |
      | Connection Timeout  | 30 seconds           |
      | Request Timeout     | 60 seconds           |
      | Max Request Size    | 10 MB                |

  Scenario: Admin configures load balancing
    When the admin configures load balancing:
      | setting             | value                |
      | algorithm           | Least Connections    |
      | health_check_path   | /health              |
      | health_check_interval | 10 seconds         |
      | unhealthy_threshold | 3 failures           |
      | sticky_sessions     | Disabled             |
    Then load balancing is updated
    And health checks begin

  Scenario: Admin configures request transformation
    When the admin sets up transformations:
      | transformation      | type      | value                    |
      | Add Header          | Request   | X-Request-ID: {uuid}     |
      | Add Header          | Response  | X-Response-Time: {ms}    |
      | Remove Header       | Response  | Server                   |
      | Rewrite Path        | Request   | /v3/* -> /api/v3/*       |
    Then transformations are applied
    And all requests/responses are modified

  Scenario: Admin configures circuit breaker
    When the admin configures circuit breaker:
      | setting             | value              |
      | enabled             | Yes                |
      | failure_threshold   | 5 failures         |
      | timeout             | 30 seconds         |
      | half_open_requests  | 3                  |
      | fallback_response   | {"error": "Service temporarily unavailable"} |
    Then circuit breaker is active
    And failures trigger the breaker

  Scenario: Admin configures CORS settings
    When the admin configures CORS:
      | setting             | value                        |
      | allowed_origins     | https://*.ffl-playoffs.com   |
      | allowed_methods     | GET, POST, PUT, DELETE       |
      | allowed_headers     | Authorization, Content-Type  |
      | expose_headers      | X-Request-ID, X-Rate-Limit   |
      | max_age             | 86400                        |
    Then CORS policy is applied
    And preflight requests are handled

  # ===========================================
  # API Security
  # ===========================================

  Scenario: Admin views security dashboard
    When the admin views security overview
    Then security metrics are displayed:
      | metric                    | value    | status  |
      | Authentication Failures   | 234      | Normal  |
      | Blocked IPs               | 12       | Normal  |
      | Security Alerts (24h)     | 3        | Warning |
      | DDoS Attempts             | 0        | Good    |
      | Suspicious Patterns       | 5        | Warning |

  Scenario: Admin configures authentication
    When the admin configures auth settings:
      | setting             | value                |
      | auth_methods        | API Key, OAuth2, JWT |
      | jwt_issuer          | https://auth.ffl.com |
      | token_expiry        | 1 hour               |
      | refresh_enabled     | Yes                  |
      | mfa_required        | Admin endpoints only |
    Then authentication is configured
    And all endpoints enforce auth

  Scenario: Admin configures IP restrictions
    When the admin sets up IP filtering:
      | rule_type           | ips                  | action  |
      | Whitelist           | 52.0.0.0/8           | Allow   |
      | Whitelist           | 54.0.0.0/8           | Allow   |
      | Blacklist           | 185.234.0.0/16       | Block   |
      | Geo-Block           | Country: CN, RU      | Block   |
    Then IP restrictions are enforced
    And blocked requests are logged

  Scenario: Admin configures request validation
    When the admin sets validation rules:
      | rule                    | setting              |
      | Schema Validation       | Strict               |
      | Max Body Size           | 10 MB                |
      | SQL Injection Check     | Enabled              |
      | XSS Prevention          | Enabled              |
      | Content-Type Validation | Required             |
    Then validation is enforced
    And invalid requests are rejected

  Scenario: Admin views security audit log
    When the admin views security audit
    Then events are displayed:
      | timestamp           | event                    | source_ip      | action  |
      | 2024-01-15 14:32:00 | Failed Authentication    | 192.168.1.100  | Logged  |
      | 2024-01-15 14:31:45 | Rate Limit Exceeded      | 10.0.0.50      | Blocked |
      | 2024-01-15 14:30:00 | SQL Injection Attempt    | 185.234.10.20  | Blocked |
    And events can be filtered and exported

  # ===========================================
  # API Performance Monitoring
  # ===========================================

  Scenario: Admin views performance metrics
    When the admin views performance dashboard
    Then metrics are displayed:
      | metric                | value    | trend   |
      | P50 Latency           | 45ms     | -5%     |
      | P95 Latency           | 234ms    | +2%     |
      | P99 Latency           | 890ms    | +8%     |
      | Throughput            | 1,245 RPS| +12%    |
      | Error Rate            | 0.15%    | -10%    |

  Scenario: Admin views endpoint performance
    When the admin views per-endpoint metrics
    Then performance is broken down:
      | endpoint             | avg_latency | p99_latency | errors | calls_24h |
      | /players             | 23ms        | 89ms        | 0.01%  | 245,000   |
      | /scores/live         | 145ms       | 456ms       | 0.05%  | 125,000   |
      | /leagues             | 89ms        | 234ms       | 0.02%  | 45,000    |
    And slow endpoints are highlighted

  Scenario: Admin configures performance alerts
    When the admin sets performance thresholds:
      | metric                | warning   | critical  | action           |
      | P99 Latency           | > 500ms   | > 1000ms  | Alert + Scale    |
      | Error Rate            | > 1%      | > 5%      | Alert + Rollback |
      | CPU Usage             | > 70%     | > 90%     | Alert + Scale    |
      | Memory Usage          | > 80%     | > 95%     | Alert            |
    Then alerts are configured
    And monitoring is active

  Scenario: Admin views distributed traces
    Given request tracing is enabled
    When the admin views a trace:
      | span                  | service           | duration |
      | Gateway               | api-gateway       | 2ms      |
      | Authentication        | auth-service      | 15ms     |
      | Business Logic        | players-service   | 45ms     |
      | Database Query        | postgres          | 23ms     |
      | Cache Lookup          | redis             | 3ms      |
    Then the full request flow is visible
    And bottlenecks are identified

  # ===========================================
  # API Usage Analytics
  # ===========================================

  Scenario: Admin views usage analytics
    When the admin views usage dashboard
    Then analytics are displayed:
      | metric                    | value       |
      | Total Requests (30d)      | 12,450,000  |
      | Unique Clients            | 1,234       |
      | Most Popular Endpoint     | /players    |
      | Peak Hour                 | Sundays 1PM |
      | Data Transferred          | 2.4 TB      |

  Scenario: Admin views usage by client
    When the admin views client usage
    Then usage is itemized:
      | client              | requests_30d | bandwidth | top_endpoint   |
      | ESPN Fantasy        | 3,450,000    | 890 GB    | /scores/live   |
      | Yahoo Sports        | 2,890,000    | 567 GB    | /players       |
      | Sleeper App         | 1,234,000    | 234 GB    | /leagues       |
    And usage trends are shown

  Scenario: Admin exports usage reports
    When the admin generates usage report:
      | setting             | value              |
      | period              | January 2024       |
      | grouping            | By Client          |
      | metrics             | Requests, Bandwidth, Errors |
      | format              | CSV, PDF           |
    Then the report is generated
    And available for download

  # ===========================================
  # API SDK Management
  # ===========================================

  Scenario: Admin views SDK status
    When the admin views SDK management
    Then SDKs are displayed:
      | language     | version | api_version | downloads | status    |
      | Python       | 2.1.0   | v3.0        | 12,450    | Current   |
      | JavaScript   | 2.0.5   | v3.0        | 23,450    | Current   |
      | Java         | 1.9.0   | v2.1        | 8,900     | Update Needed |
      | Swift        | 1.5.0   | v2.0        | 3,450     | Deprecated|

  Scenario: Admin generates SDK
    When the admin generates SDK:
      | setting             | value              |
      | language            | Go                 |
      | api_version         | v3.0               |
      | package_name        | ffl-playoffs-go    |
      | include_examples    | Yes                |
      | generate_tests      | Yes                |
    Then the SDK is generated
    And published to package registry

  Scenario: Admin configures SDK auto-generation
    When the admin configures auto-generation:
      | setting             | value                    |
      | trigger             | API version release      |
      | languages           | Python, JavaScript, Java |
      | publish_to          | npm, PyPI, Maven         |
      | notify_maintainers  | Yes                      |
    Then auto-generation is configured
    And SDKs update with API changes

  # ===========================================
  # API Testing
  # ===========================================

  Scenario: Admin views test status
    When the admin views API tests
    Then test results are displayed:
      | test_suite          | tests | passed | failed | coverage |
      | Unit Tests          | 456   | 452    | 4      | 89%      |
      | Integration Tests   | 123   | 120    | 3      | 78%      |
      | Contract Tests      | 89    | 89     | 0      | 95%      |
      | Load Tests          | 12    | 11     | 1      | N/A      |

  Scenario: Admin runs API tests
    When the admin triggers test run:
      | setting             | value              |
      | test_suite          | Integration Tests  |
      | environment         | Staging            |
      | parallel            | 4 workers          |
      | timeout             | 30 minutes         |
    Then tests begin execution
    And results are streamed in real-time

  Scenario: Admin configures contract testing
    When the admin sets up contract tests:
      | setting             | value                    |
      | provider            | Players API              |
      | consumers           | ESPN, Yahoo, Sleeper     |
      | run_on              | PR, Merge to main        |
      | fail_on_break       | Yes                      |
    Then contract testing is configured
    And breaking changes are detected

  # ===========================================
  # GraphQL API
  # ===========================================

  Scenario: Admin views GraphQL configuration
    When the admin views GraphQL settings
    Then configuration is displayed:
      | setting             | value              |
      | Endpoint            | /graphql           |
      | Introspection       | Enabled (Dev only) |
      | Max Depth           | 10                 |
      | Query Complexity    | 1000               |
      | Batch Queries       | Enabled            |

  Scenario: Admin configures GraphQL settings
    When the admin updates GraphQL:
      | setting             | value              |
      | max_depth           | 8                  |
      | complexity_limit    | 500                |
      | rate_limit          | 100/minute         |
      | persisted_queries   | Enabled            |
      | tracing             | Enabled            |
    Then settings are applied
    And queries are validated

  Scenario: Admin manages GraphQL schema
    When the admin views schema management
    Then schema options are available:
      | action              | description                  |
      | View Schema         | Browse current schema        |
      | Compare Versions    | Diff schema changes          |
      | Deprecate Field     | Mark field as deprecated     |
      | Add Type            | Define new type              |
    And schema changes are tracked

  # ===========================================
  # Webhook System
  # ===========================================

  Scenario: Admin views webhook configuration
    When the admin views webhooks
    Then webhook settings are displayed:
      | event               | subscribers | last_fired    | success_rate |
      | score.updated       | 12          | 2 minutes ago | 99.5%        |
      | player.traded       | 8           | 1 hour ago    | 98.2%        |
      | league.created      | 5           | 10 minutes ago| 100%         |

  Scenario: Admin configures webhook events
    When the admin adds webhook event:
      | field               | value                    |
      | event_name          | prediction.generated     |
      | payload_schema      | PredictionEvent          |
      | retry_policy        | 3 attempts, exponential  |
      | timeout             | 30 seconds               |
    Then the event is registered
    And subscribers can register

  Scenario: Admin views webhook delivery status
    When the admin views delivery logs
    Then deliveries are displayed:
      | event               | subscriber       | status   | attempts | latency |
      | score.updated       | espn.com/webhook | Success  | 1        | 234ms   |
      | score.updated       | yahoo.com/hook   | Failed   | 3        | Timeout |
      | player.traded       | sleeper.com/api  | Success  | 2        | 456ms   |
    And failed deliveries can be retried

  Scenario: Admin configures webhook security
    When the admin sets webhook security:
      | setting             | value                    |
      | signature_algorithm | HMAC-SHA256              |
      | signature_header    | X-FFL-Signature          |
      | timestamp_header    | X-FFL-Timestamp          |
      | replay_prevention   | 5 minutes                |
    Then webhook security is configured
    And signatures are validated

  # ===========================================
  # API Migration
  # ===========================================

  Scenario: Admin plans API migration
    When the admin creates migration plan:
      | field               | value                    |
      | source_version      | v2.0                     |
      | target_version      | v3.0                     |
      | migration_period    | 6 months                 |
      | breaking_changes    | 5                        |
      | affected_clients    | 890                      |
    Then migration plan is created
    And timeline is generated

  Scenario: Admin tracks migration progress
    When the admin views migration status
    Then progress is displayed:
      | phase               | status      | clients_migrated |
      | Planning            | Complete    | N/A              |
      | Parallel Running    | In Progress | 450/890          |
      | Deprecation Notices | Active      | 440 notified     |
      | Sunset Enforcement  | Pending     | 0                |
    And migration assistance is offered

  # ===========================================
  # Error Cases
  # ===========================================

  Scenario: Admin cannot delete active API version
    Given API version v3.0 has active traffic
    When the admin attempts to delete the version
    Then the request is blocked with error "VERSION_HAS_ACTIVE_TRAFFIC"
    And migration must complete first

  Scenario: Admin cannot create duplicate endpoint
    Given endpoint /players already exists
    When the admin attempts to create /players again
    Then the request is rejected with error "ENDPOINT_ALREADY_EXISTS"

  Scenario: Admin cannot set invalid rate limits
    When the admin sets rate limit to 0 requests/hour
    Then the request is rejected with error "INVALID_RATE_LIMIT"
    And the error message is "Rate limit must be greater than zero"

  Scenario: API key generation fails for invalid scope
    When the admin creates API key with invalid scope "SUPERADMIN"
    Then the request is rejected with error "INVALID_SCOPE"
    And valid scopes are listed

  Scenario: Gateway configuration validation fails
    When the admin sets timeout to 0 seconds
    Then the request is rejected with error "INVALID_TIMEOUT"
    And minimum timeout requirements are shown
