@admin @integration-management @ANIMA-1084
Feature: Admin Integration Management
  As a platform administrator
  I want to manage third-party integrations and APIs
  So that I can ensure smooth operation of external services

  Background:
    Given I am logged in as a platform administrator
    And I have integration management permissions
    And the integration management system is active

  # =============================================================================
  # INTEGRATIONS DASHBOARD
  # =============================================================================

  @dashboard @overview
  Scenario: View integrations dashboard overview
    When I navigate to the integrations dashboard
    Then I should see the total number of active integrations: 24
    And I should see the integration health summary:
      | status   | count |
      | healthy  | 20    |
      | degraded | 3     |
      | offline  | 1     |
    And I should see recent integration activity
    And I should see API request volume trends

  @dashboard @metrics
  Scenario: View integration performance metrics
    Given I am on the integrations dashboard
    When I view the performance metrics section
    Then I should see aggregate metrics:
      | metric              | value      |
      | total_requests_24h  | 1,250,000  |
      | avg_response_time   | 145 ms     |
      | success_rate        | 99.2%      |
      | error_rate          | 0.8%       |
    And I should see metrics broken down by integration

  @dashboard @filtering
  Scenario: Filter integrations by category
    Given I am on the integrations dashboard
    When I filter integrations by category "payment"
    Then I should see only payment-related integrations
    And I should see 4 integrations in the filtered list
    And the metrics should reflect only filtered integrations

  @dashboard @search
  Scenario: Search for specific integration
    Given I am on the integrations dashboard
    When I search for "stripe"
    Then I should see the Stripe integration in the results
    And I should see relevant configuration details
    And I should be able to navigate to the integration details

  # =============================================================================
  # INTEGRATION DETAILS
  # =============================================================================

  @integration @details
  Scenario: View detailed integration information
    Given the "ESPN Fantasy API" integration exists
    When I view the details for "ESPN Fantasy API"
    Then I should see integration metadata:
      | field           | value                    |
      | name            | ESPN Fantasy API         |
      | type            | REST API                 |
      | version         | v3.0                     |
      | status          | active                   |
      | created_at      | 2024-01-15               |
      | last_sync       | 5 minutes ago            |
    And I should see connection settings
    And I should see authentication configuration
    And I should see data mapping rules

  @integration @configuration
  Scenario: Configure integration settings
    Given the "Sleeper API" integration exists
    When I update the configuration:
      | setting           | value            |
      | timeout           | 30 seconds       |
      | retry_attempts    | 3                |
      | retry_delay       | 1000 ms          |
      | circuit_breaker   | enabled          |
    Then the configuration should be saved
    And the integration should be reconfigured
    And a configuration change should be logged

  @integration @versioning
  Scenario: View integration version history
    Given the "Yahoo Fantasy API" integration has multiple versions
    When I view the version history
    Then I should see version changes:
      | version | date       | changes                    |
      | 3.0     | 2024-06-01 | Added new endpoints        |
      | 2.5     | 2024-03-15 | Updated authentication     |
      | 2.0     | 2024-01-10 | Major API restructure      |
    And I should be able to view details for each version

  @integration @endpoints
  Scenario: View integration endpoints
    Given the "NFL Data API" integration exists
    When I view the endpoints configuration
    Then I should see available endpoints:
      | endpoint           | method | rate_limit | status  |
      | /players           | GET    | 1000/hour  | active  |
      | /scores            | GET    | 5000/hour  | active  |
      | /schedules         | GET    | 500/hour   | active  |
      | /injuries          | GET    | 1000/hour  | beta    |
    And I should see endpoint documentation links

  # =============================================================================
  # API KEY MANAGEMENT
  # =============================================================================

  @api-keys @management
  Scenario: View all API keys
    When I navigate to API key management
    Then I should see a list of all API keys:
      | key_name        | integration      | created    | expires    | status  |
      | espn-prod-key   | ESPN Fantasy API | 2024-01-15 | 2025-01-15 | active  |
      | stripe-live     | Stripe Payments  | 2024-02-01 | 2025-02-01 | active  |
      | analytics-key   | Analytics API    | 2024-03-01 | 2024-09-01 | expired |
    And I should see key usage statistics
    And I should see expiration warnings for keys expiring soon

  @api-keys @creation
  Scenario: Create new API key
    Given I am on the API key management page
    When I create a new API key:
      | field         | value              |
      | name          | yahoo-fantasy-key  |
      | integration   | Yahoo Fantasy API  |
      | permissions   | read, write        |
      | expires_in    | 365 days           |
      | rate_limit    | 10000/hour         |
    Then a new API key should be generated
    And I should see the key value once
    And I should be prompted to securely store the key
    And the key creation should be logged

  @api-keys @rotation
  Scenario: Rotate API key
    Given the "espn-prod-key" API key exists
    And the key is due for rotation
    When I initiate key rotation for "espn-prod-key"
    Then a new key should be generated
    And the old key should remain active for 24 hours
    And applications should be notified of the rotation
    And I should see the rotation status
    And the rotation should be logged

  @api-keys @rotation @automatic
  Scenario: Configure automatic key rotation
    Given the "stripe-live" API key exists
    When I configure automatic rotation:
      | setting             | value          |
      | rotation_interval   | 90 days        |
      | notification_before | 7 days         |
      | overlap_period      | 24 hours       |
      | auto_update_apps    | true           |
    Then automatic rotation should be scheduled
    And notifications should be configured
    And the schedule should appear in the calendar

  @api-keys @revocation
  Scenario: Revoke compromised API key
    Given the "compromised-key" API key may be exposed
    When I revoke the "compromised-key" immediately
    Then the key should be invalidated instantly
    And all active sessions using the key should be terminated
    And dependent services should be notified
    And a security incident should be logged
    And I should be prompted to create a replacement key

  @api-keys @permissions
  Scenario: Configure API key permissions
    Given the "limited-access-key" API key exists
    When I configure permissions:
      | resource      | read | write | delete |
      | players       | yes  | no    | no     |
      | rosters       | yes  | yes   | no     |
      | scores        | yes  | no    | no     |
      | transactions  | no   | no    | no     |
    Then the permissions should be applied
    And requests exceeding permissions should be rejected
    And permission changes should be logged

  @api-keys @usage
  Scenario: Monitor API key usage
    Given the "analytics-key" API key exists
    When I view usage statistics for "analytics-key"
    Then I should see usage metrics:
      | metric            | value      |
      | requests_today    | 5,432      |
      | requests_week     | 38,450     |
      | avg_latency       | 125 ms     |
      | error_rate        | 0.5%       |
      | quota_used        | 54%        |
    And I should see usage trends over time
    And I should see top endpoints accessed

  # =============================================================================
  # WEBHOOK MANAGEMENT
  # =============================================================================

  @webhooks @configuration
  Scenario: Configure webhooks for integration
    Given the "Score Update Service" integration exists
    When I configure webhooks:
      | event_type        | endpoint_url                          | active |
      | score.updated     | https://api.ffl.com/webhooks/scores   | true   |
      | player.injured    | https://api.ffl.com/webhooks/injuries | true   |
      | game.started      | https://api.ffl.com/webhooks/games    | true   |
      | game.completed    | https://api.ffl.com/webhooks/games    | true   |
    Then the webhooks should be configured
    And I should see webhook endpoint status
    And test payloads should be available

  @webhooks @security
  Scenario: Configure webhook security
    Given webhooks are configured for "Score Update Service"
    When I configure webhook security:
      | setting              | value                    |
      | signing_secret       | whsec_xxx...             |
      | signature_header     | X-Signature-256          |
      | timestamp_tolerance  | 300 seconds              |
      | ip_whitelist         | 10.0.0.0/8, 172.16.0.0/12|
    Then webhook security should be enabled
    And unsigned requests should be rejected
    And requests from non-whitelisted IPs should be blocked

  @webhooks @testing
  Scenario: Test webhook endpoint
    Given a webhook is configured for "score.updated" events
    When I send a test webhook payload
    Then the webhook should be delivered successfully
    And I should see the response from the endpoint
    And the test should be logged
    And I should see delivery time metrics

  @webhooks @debugging
  Scenario: Debug webhook failures
    Given webhooks have been failing for "player.injured" events
    When I view the webhook failure log
    Then I should see recent failures:
      | timestamp           | event_type     | error                | attempts |
      | 2024-06-15 14:30:00 | player.injured | Connection timeout   | 3        |
      | 2024-06-15 14:25:00 | player.injured | 500 Internal Error   | 3        |
      | 2024-06-15 14:20:00 | player.injured | Connection refused   | 3        |
    And I should see the full request/response details
    And I should be able to retry failed deliveries
    And I should see suggested resolutions

  @webhooks @retry
  Scenario: Configure webhook retry policy
    Given webhooks are configured
    When I configure retry policy:
      | setting           | value                |
      | max_retries       | 5                    |
      | initial_delay     | 1 second             |
      | max_delay         | 5 minutes            |
      | backoff_type      | exponential          |
      | dead_letter_queue | enabled              |
    Then the retry policy should be applied
    And failed webhooks should be retried according to policy
    And exhausted retries should go to dead letter queue

  @webhooks @replay
  Scenario: Replay webhook events
    Given webhook events have been stored for the past 7 days
    When I select events to replay:
      | filter        | value                  |
      | event_type    | score.updated          |
      | date_range    | 2024-06-10 to 2024-06-12|
      | status        | failed                 |
    Then I should see 45 events matching criteria
    And I should be able to replay all or selected events
    And replay progress should be tracked

  @webhooks @monitoring
  Scenario: Monitor webhook delivery metrics
    When I view webhook monitoring dashboard
    Then I should see delivery metrics:
      | metric              | value    |
      | total_24h           | 15,432   |
      | successful          | 15,210   |
      | failed              | 222      |
      | avg_delivery_time   | 245 ms   |
      | success_rate        | 98.6%    |
    And I should see delivery trends over time
    And I should see breakdown by event type

  # =============================================================================
  # OAUTH PROVIDER MANAGEMENT
  # =============================================================================

  @oauth @providers
  Scenario: View configured OAuth providers
    When I navigate to OAuth provider management
    Then I should see configured providers:
      | provider    | client_id_set | status  | users_connected |
      | Google      | yes           | active  | 1,250           |
      | Facebook    | yes           | active  | 890             |
      | Apple       | yes           | active  | 456             |
      | Twitter     | yes           | inactive| 0               |
    And I should see provider configuration options

  @oauth @configuration
  Scenario: Configure new OAuth provider
    When I add a new OAuth provider:
      | field          | value                              |
      | provider       | Discord                            |
      | client_id      | 123456789012345678                 |
      | client_secret  | xxxxxxxxxxxxxxxxxxxxxxxxxx         |
      | scopes         | identify, email, guilds            |
      | redirect_uri   | https://ffl.com/auth/discord/callback |
    Then the OAuth provider should be configured
    And the configuration should be validated
    And a test authentication should be available

  @oauth @token-management
  Scenario: Manage OAuth tokens
    Given users have connected via "Google" OAuth
    When I view token management for "Google"
    Then I should see token statistics:
      | metric              | value    |
      | active_tokens       | 1,250    |
      | expired_tokens      | 45       |
      | revoked_tokens      | 12       |
      | avg_token_age       | 45 days  |
    And I should be able to revoke tokens
    And I should see token refresh activity

  @oauth @refresh
  Scenario: Configure token refresh behavior
    Given "Google" OAuth provider is configured
    When I configure token refresh:
      | setting                | value      |
      | auto_refresh           | enabled    |
      | refresh_before_expiry  | 5 minutes  |
      | max_refresh_attempts   | 3          |
      | on_refresh_failure     | notify_user|
    Then the refresh configuration should be saved
    And tokens should refresh automatically

  @oauth @revocation
  Scenario: Revoke all tokens for a provider
    Given there is a security concern with "Facebook" OAuth
    When I revoke all tokens for "Facebook"
    Then all 890 active tokens should be revoked
    And users should be logged out of sessions using Facebook auth
    And users should be notified to re-authenticate
    And the revocation should be logged

  @oauth @scopes
  Scenario: Update OAuth provider scopes
    Given "Google" OAuth is configured with basic scopes
    When I update the scopes to include:
      | scope                   |
      | profile                 |
      | email                   |
      | https://www.googleapis.com/auth/calendar.readonly |
    Then the scopes should be updated
    And existing users should be prompted to re-authorize
    And new authorizations should request updated scopes

  # =============================================================================
  # INTEGRATION HEALTH MONITORING
  # =============================================================================

  @health @monitoring
  Scenario: Monitor integration health
    When I view the integration health dashboard
    Then I should see health status for all integrations:
      | integration      | status   | uptime    | last_check      |
      | ESPN Fantasy API | healthy  | 99.95%    | 30 seconds ago  |
      | Stripe Payments  | healthy  | 99.99%    | 15 seconds ago  |
      | Email Service    | degraded | 98.5%     | 1 minute ago    |
      | Analytics API    | offline  | 95.2%     | 5 minutes ago   |
    And I should see health trends over time

  @health @checks
  Scenario: Configure health check parameters
    Given the "ESPN Fantasy API" integration exists
    When I configure health checks:
      | parameter         | value            |
      | check_interval    | 30 seconds       |
      | timeout           | 5 seconds        |
      | healthy_threshold | 3 consecutive    |
      | unhealthy_threshold| 2 consecutive   |
      | check_endpoint    | /health          |
    Then health checks should be configured
    And checks should run at the specified interval

  @health @degraded
  Scenario: Investigate degraded integration
    Given "Email Service" integration shows degraded status
    When I investigate the degraded integration
    Then I should see diagnostic information:
      | metric           | current | normal   | status   |
      | response_time    | 2500 ms | 200 ms   | high     |
      | error_rate       | 5%      | 0.1%     | elevated |
      | throughput       | 50/min  | 500/min  | low      |
    And I should see recent error logs
    And I should see recommended actions

  @health @recovery
  Scenario: Track integration recovery
    Given "Analytics API" integration was offline
    And the integration has recovered
    When I view the recovery details
    Then I should see:
      | field              | value                   |
      | outage_start       | 2024-06-15 10:00:00     |
      | outage_end         | 2024-06-15 10:45:00     |
      | outage_duration    | 45 minutes              |
      | root_cause         | Provider maintenance    |
      | impact             | 1,234 requests failed   |
    And I should see the incident timeline
    And I should see post-incident report

  @health @dependencies
  Scenario: View integration dependency map
    When I view the integration dependency map
    Then I should see integration relationships:
      | integration      | depends_on                    | depended_by           |
      | Game Engine      | ESPN API, NFL Data API        | Scoring Service       |
      | Scoring Service  | Game Engine, Player Stats API | Leaderboard, Notifications |
      | Notifications    | Email Service, Push Service   | none                  |
    And I should see impact analysis for failures

  # =============================================================================
  # INTEGRATION ALERTS
  # =============================================================================

  @alerts @configuration
  Scenario: Configure integration alerts
    Given the "Payment Gateway" integration exists
    When I configure alerts:
      | alert_type       | threshold    | severity | recipients           |
      | error_rate       | > 5%         | critical | oncall, platform-team|
      | response_time    | > 2000 ms    | warning  | platform-team        |
      | availability     | < 99%        | critical | oncall, executives   |
      | rate_limit       | > 80%        | warning  | platform-team        |
    Then alerts should be configured
    And alert rules should be active

  @alerts @notification
  Scenario: Receive integration alert
    Given alerts are configured for "API Gateway"
    And error rate has exceeded 5% threshold
    When the alert is triggered
    Then notification should be sent to configured recipients
    And the alert should appear in the alerts dashboard
    And an incident should be automatically created
    And escalation timer should start

  @alerts @acknowledgement
  Scenario: Acknowledge and resolve alert
    Given there is an active alert for "Database Sync"
    When I acknowledge the alert
    Then the alert status should change to "acknowledged"
    And escalation should be paused
    When I resolve the alert with notes "Fixed connection pool exhaustion"
    Then the alert should be marked as resolved
    And resolution time should be recorded
    And the incident should be closed

  @alerts @suppression
  Scenario: Configure alert suppression during maintenance
    Given a maintenance window is scheduled
    When I configure alert suppression:
      | integration      | suppression_window          | suppress_types    |
      | All              | 2024-06-20 02:00 - 06:00    | warning           |
      | Database Sync    | 2024-06-20 02:00 - 06:00    | all               |
    Then alerts should be suppressed during the window
    And suppressed alerts should be logged but not notified
    And alerts should resume after the window

  @alerts @escalation
  Scenario: Configure alert escalation policy
    When I configure escalation policy for critical alerts:
      | level | wait_time  | notify                    |
      | 1     | 0 minutes  | primary-oncall            |
      | 2     | 15 minutes | secondary-oncall          |
      | 3     | 30 minutes | platform-lead, oncall-mgr |
      | 4     | 60 minutes | cto, vp-engineering       |
    Then escalation policy should be active
    And unacknowledged alerts should escalate automatically

  @alerts @history
  Scenario: View alert history
    When I view alert history for the past 30 days
    Then I should see historical alerts:
      | date       | integration      | type         | duration  | resolution        |
      | 2024-06-14 | ESPN API         | availability | 15 min    | auto-recovered    |
      | 2024-06-10 | Payment Gateway  | error_rate   | 45 min    | manual fix        |
      | 2024-06-05 | Email Service    | response_time| 30 min    | scaled resources  |
    And I should see alert trends and patterns
    And I should see MTTR (Mean Time To Resolution) metrics

  # =============================================================================
  # RATE LIMIT MANAGEMENT
  # =============================================================================

  @rate-limits @configuration
  Scenario: View rate limit configuration
    When I navigate to rate limit management
    Then I should see rate limits by integration:
      | integration      | limit        | window   | current_usage |
      | ESPN Fantasy API | 10,000/hour  | 1 hour   | 4,532 (45%)   |
      | NFL Data API     | 5,000/hour   | 1 hour   | 3,890 (78%)   |
      | Stripe API       | 100/second   | 1 second | 45 (45%)      |
    And I should see usage trends over time

  @rate-limits @update
  Scenario: Update rate limit configuration
    Given the "ESPN Fantasy API" has a rate limit of 10,000/hour
    When I update the rate limit:
      | setting         | value        |
      | requests_limit  | 15,000       |
      | window          | 1 hour       |
      | burst_limit     | 500          |
      | burst_window    | 1 minute     |
    Then the rate limit should be updated
    And the change should take effect immediately
    And the update should be logged

  @rate-limits @throttling
  Scenario: Configure throttling behavior
    Given rate limits are configured
    When I configure throttling behavior:
      | setting              | value                |
      | throttle_response    | 429 Too Many Requests|
      | retry_after_header   | enabled              |
      | queue_excess         | false                |
      | notify_at_threshold  | 80%                  |
    Then throttling should be configured
    And excess requests should receive 429 responses
    And Retry-After header should be included

  @rate-limits @per-client
  Scenario: Configure per-client rate limits
    When I configure per-client rate limits:
      | client_type      | limit       | window   |
      | free_tier        | 1,000/hour  | 1 hour   |
      | premium          | 10,000/hour | 1 hour   |
      | enterprise       | 100,000/hour| 1 hour   |
      | internal         | unlimited   | n/a      |
    Then per-client limits should be applied
    And clients should receive appropriate limits
    And usage should be tracked per client

  @rate-limits @monitoring
  Scenario: Monitor rate limit usage
    When I view rate limit monitoring dashboard
    Then I should see:
      | metric                   | value    |
      | total_requests_24h       | 850,000  |
      | throttled_requests_24h   | 1,234    |
      | throttle_rate            | 0.15%    |
      | peak_usage_time          | 8 PM EST |
      | clients_near_limit       | 15       |
    And I should see clients approaching limits
    And I should see throttling events over time

  @rate-limits @quotas
  Scenario: Configure request quotas
    When I configure request quotas:
      | integration      | daily_quota | monthly_quota | action_on_exceed |
      | ESPN Fantasy API | 200,000     | 5,000,000     | throttle         |
      | NFL Data API     | 100,000     | 2,500,000     | block            |
      | Analytics API    | 50,000      | 1,000,000     | notify_only      |
    Then quotas should be configured
    And usage should be tracked against quotas
    And appropriate actions should occur on exceed

  # =============================================================================
  # INTEGRATION CONNECTIVITY TESTING
  # =============================================================================

  @connectivity @test
  Scenario: Test integration connectivity
    Given the "ESPN Fantasy API" integration is configured
    When I run a connectivity test
    Then the test should execute:
      | test_step          | result  | details              |
      | DNS resolution     | pass    | 15 ms                |
      | TCP connection     | pass    | 45 ms                |
      | TLS handshake      | pass    | 120 ms, TLS 1.3      |
      | Authentication     | pass    | token valid          |
      | API health check   | pass    | 200 OK, 180 ms       |
    And I should see overall connectivity status: healthy

  @connectivity @latency
  Scenario: Measure integration latency
    When I run latency tests for "NFL Data API"
    Then I should see latency metrics:
      | endpoint      | avg_latency | p50    | p95    | p99    |
      | /players      | 145 ms      | 120 ms | 250 ms | 450 ms |
      | /scores       | 95 ms       | 80 ms  | 180 ms | 320 ms |
      | /schedules    | 110 ms      | 95 ms  | 200 ms | 380 ms |
    And I should see latency comparison with historical data

  @connectivity @throughput
  Scenario: Test integration throughput
    Given I want to verify throughput for "Stripe API"
    When I run a throughput test with 100 concurrent requests
    Then I should see throughput results:
      | metric               | value        |
      | requests_per_second  | 85           |
      | avg_response_time    | 115 ms       |
      | error_rate           | 0%           |
      | timeout_rate         | 0%           |
    And I should see if throughput meets SLA requirements

  @connectivity @ssl
  Scenario: Verify SSL/TLS configuration
    When I verify SSL configuration for "Payment Gateway"
    Then I should see SSL details:
      | field              | value                   |
      | protocol           | TLS 1.3                 |
      | cipher_suite       | TLS_AES_256_GCM_SHA384  |
      | certificate_valid  | yes                     |
      | certificate_expiry | 2025-03-15              |
      | chain_valid        | yes                     |
    And I should see certificate chain details
    And I should see SSL vulnerability scan results

  @connectivity @network
  Scenario: Diagnose network connectivity issues
    Given "Analytics API" is experiencing connectivity issues
    When I run network diagnostics
    Then I should see diagnostic results:
      | test              | result  | details                      |
      | ping              | pass    | 25 ms average                |
      | traceroute        | pass    | 12 hops                      |
      | dns_lookup        | pass    | 8 ms                         |
      | port_check        | fail    | port 443 blocked by firewall |
    And I should see recommended resolutions

  # =============================================================================
  # INTEGRATION COST ANALYSIS
  # =============================================================================

  @cost @analysis
  Scenario: Analyze integration costs
    When I navigate to integration cost analysis
    Then I should see cost breakdown:
      | integration      | monthly_cost | cost_per_request | trend    |
      | ESPN Fantasy API | $500         | $0.00005         | stable   |
      | Stripe Payments  | $2,500       | $0.25 per txn    | +15%     |
      | Email Service    | $350         | $0.0007          | -5%      |
      | SMS Provider     | $800         | $0.02            | +25%     |
    And I should see total integration costs: $4,150/month

  @cost @projection
  Scenario: Project future integration costs
    Given current usage patterns are established
    When I generate cost projections for next 6 months
    Then I should see projected costs:
      | month    | projected_cost | growth   |
      | July     | $4,350         | +5%      |
      | August   | $4,567         | +5%      |
      | September| $5,024         | +10%     |
      | October  | $5,526         | +10%     |
      | November | $6,079         | +10%     |
      | December | $7,295         | +20%     |
    And I should see cost drivers identified

  @cost @optimization
  Scenario: View cost optimization recommendations
    When I request cost optimization analysis
    Then I should see recommendations:
      | recommendation                      | potential_savings |
      | Batch API requests for ESPN API     | $50/month         |
      | Use cached responses where possible | $75/month         |
      | Upgrade to enterprise tier          | $200/month        |
      | Consolidate redundant integrations  | $150/month        |
    And I should see implementation complexity for each

  @cost @budget
  Scenario: Set integration budget alerts
    When I configure budget alerts:
      | threshold | alert_type   | recipients       |
      | 75%       | warning      | finance-team     |
      | 90%       | urgent       | finance, platform|
      | 100%      | critical     | all-stakeholders |
      | 110%      | escalation   | executives       |
    Then budget alerts should be configured
    And alerts should trigger at thresholds

  @cost @allocation
  Scenario: Allocate integration costs to teams
    When I configure cost allocation:
      | integration      | allocation_method | teams                    |
      | ESPN Fantasy API | usage_based       | fantasy-engine (80%), api (20%) |
      | Stripe Payments  | transaction_count | payments (100%)          |
      | Email Service    | equal_split       | marketing, notifications  |
    Then costs should be allocated to teams
    And team-level cost reports should be generated

  # =============================================================================
  # API GATEWAY CONFIGURATION
  # =============================================================================

  @gateway @configuration
  Scenario: Configure API gateway
    When I configure the API gateway:
      | setting              | value              |
      | default_timeout      | 30 seconds         |
      | max_request_size     | 10 MB              |
      | cors_enabled         | true               |
      | compression          | gzip               |
      | request_logging      | enabled            |
    Then gateway configuration should be applied
    And configuration should be validated
    And a deployment should be triggered

  @gateway @routing
  Scenario: Configure API routing rules
    When I configure routing rules:
      | path_pattern        | target_service    | method | priority |
      | /api/v1/players/*   | player-service    | ALL    | 1        |
      | /api/v1/scores/*    | scoring-service   | GET    | 2        |
      | /api/v1/rosters/*   | roster-service    | ALL    | 3        |
      | /api/v2/*           | v2-service        | ALL    | 4        |
    Then routing rules should be configured
    And requests should be routed accordingly
    And route conflicts should be detected

  @gateway @transformation
  Scenario: Configure request/response transformation
    Given the "/api/v1/legacy/*" route exists
    When I configure transformations:
      | type           | transformation                          |
      | request_header | Add X-API-Version: 2.0                  |
      | request_body   | Map legacy.field to new.field           |
      | response_body  | Transform snake_case to camelCase       |
      | response_header| Remove X-Internal-Debug                 |
    Then transformations should be applied
    And legacy clients should work with new API

  @gateway @caching
  Scenario: Configure gateway caching
    When I configure caching rules:
      | path_pattern    | cache_ttl | cache_key_params | invalidation      |
      | /api/v1/players | 5 minutes | none             | player.updated    |
      | /api/v1/scores  | 30 seconds| gameId           | score.updated     |
      | /api/v1/static/*| 24 hours  | none             | manual            |
    Then caching should be configured
    And cache hit rates should be tracked
    And invalidation should work correctly

  @gateway @security
  Scenario: Configure gateway security
    When I configure security settings:
      | setting              | value                    |
      | jwt_validation       | enabled                  |
      | api_key_required     | true                     |
      | ip_whitelist         | enabled                  |
      | waf_rules            | OWASP-CRS-3.3            |
      | ddos_protection      | enabled                  |
    Then security settings should be applied
    And unauthorized requests should be rejected
    And security events should be logged

  @gateway @load-balancing
  Scenario: Configure load balancing
    When I configure load balancing:
      | setting              | value              |
      | algorithm            | round_robin        |
      | health_check_path    | /health            |
      | health_check_interval| 10 seconds         |
      | unhealthy_threshold  | 3                  |
      | sticky_sessions      | disabled           |
    Then load balancing should be configured
    And traffic should be distributed across targets
    And unhealthy targets should be removed

  # =============================================================================
  # INTEGRATION MARKETPLACE
  # =============================================================================

  @marketplace @browse
  Scenario: Browse integration marketplace
    When I navigate to the integration marketplace
    Then I should see available integrations by category:
      | category        | count |
      | Fantasy Sports  | 12    |
      | Payments        | 8     |
      | Analytics       | 15    |
      | Communication   | 10    |
      | Data Providers  | 20    |
    And I should see featured integrations
    And I should be able to search integrations

  @marketplace @details
  Scenario: View marketplace integration details
    When I view details for "Sleeper Fantasy API" in marketplace
    Then I should see:
      | field           | value                        |
      | name            | Sleeper Fantasy API          |
      | provider        | Sleeper Inc.                 |
      | version         | 2.5.0                        |
      | pricing         | Free up to 10k requests/day  |
      | rating          | 4.5/5 (120 reviews)          |
      | installations   | 500+                         |
    And I should see documentation link
    And I should see setup requirements

  @marketplace @install
  Scenario: Install integration from marketplace
    Given "Sleeper Fantasy API" is available in marketplace
    When I install the integration:
      | configuration   | value              |
      | api_key         | sl_xxxxxxxxxxxxx   |
      | environment     | production         |
      | auto_sync       | enabled            |
    Then the integration should be installed
    And configuration validation should run
    And initial sync should be triggered
    And the integration should appear in my integrations

  @marketplace @updates
  Scenario: Update installed integration
    Given "ESPN Fantasy API" has an update available
    And current version is 2.8 and available version is 3.0
    When I view update details
    Then I should see:
      | field             | value                          |
      | current_version   | 2.8                            |
      | new_version       | 3.0                            |
      | breaking_changes  | yes                            |
      | migration_guide   | available                      |
      | changelog         | New endpoints, auth changes    |
    And I should be able to schedule the update

  @marketplace @review
  Scenario: Review installed integration
    Given I have used "Analytics Dashboard API" for 3 months
    When I submit a review:
      | field      | value                                    |
      | rating     | 4                                        |
      | title      | Solid integration with minor issues      |
      | review     | Great data, occasional latency spikes    |
      | recommend  | yes                                      |
    Then my review should be submitted
    And it should appear on the integration page

  # =============================================================================
  # CUSTOM INTEGRATIONS
  # =============================================================================

  @custom @creation
  Scenario: Create custom integration
    When I create a custom integration:
      | field           | value                              |
      | name            | Internal Stats API                 |
      | type            | REST API                           |
      | base_url        | https://stats.internal.ffl.com/api |
      | authentication  | API Key                            |
      | description     | Internal statistics service        |
    Then the custom integration should be created
    And I should be able to configure endpoints
    And the integration should appear in my list

  @custom @endpoints
  Scenario: Configure custom integration endpoints
    Given "Internal Stats API" custom integration exists
    When I configure endpoints:
      | path          | method | description          | response_type |
      | /stats/{id}   | GET    | Get player stats     | JSON          |
      | /rankings     | GET    | Get rankings         | JSON          |
      | /projections  | POST   | Generate projections | JSON          |
    Then endpoints should be configured
    And endpoint documentation should be generated
    And endpoints should be testable

  @custom @mapping
  Scenario: Configure data mapping for custom integration
    Given "Internal Stats API" has endpoints configured
    When I configure data mapping:
      | source_field      | target_field    | transformation      |
      | player_id         | playerId        | none                |
      | total_points      | points.total    | none                |
      | games_played      | gamesPlayed     | integer             |
      | last_updated      | updatedAt       | ISO8601 datetime    |
    Then data mapping should be saved
    And transformations should be applied on sync

  @custom @testing
  Scenario: Test custom integration
    Given "Internal Stats API" is fully configured
    When I run integration tests
    Then tests should execute:
      | test_case               | result | details              |
      | connection_test         | pass   | 200 OK               |
      | authentication_test     | pass   | Valid credentials    |
      | endpoint_stats_test     | pass   | Returns valid data   |
      | endpoint_rankings_test  | pass   | Returns valid data   |
      | data_mapping_test       | pass   | All fields mapped    |
    And I should see test report

  @custom @versioning
  Scenario: Version custom integration
    Given "Internal Stats API" is in production
    When I create a new version:
      | version | changes                          |
      | 1.1     | Added /projections endpoint      |
      |         | Updated authentication headers   |
    Then a new version should be created
    And both versions should be available
    And I should be able to migrate clients

  # =============================================================================
  # INTEGRATION FAILOVER
  # =============================================================================

  @failover @configuration
  Scenario: Configure integration failover
    Given "ESPN Fantasy API" is a critical integration
    When I configure failover:
      | setting             | value                    |
      | failover_target     | Yahoo Fantasy API        |
      | trigger_condition   | 3 consecutive failures   |
      | health_check_interval| 30 seconds              |
      | auto_failback       | enabled                  |
      | failback_delay      | 5 minutes                |
    Then failover should be configured
    And health monitoring should be active

  @failover @trigger
  Scenario: Automatic failover on primary failure
    Given failover is configured for "ESPN Fantasy API"
    And "ESPN Fantasy API" has failed 3 consecutive health checks
    When automatic failover is triggered
    Then traffic should route to "Yahoo Fantasy API"
    And an alert should be sent to administrators
    And failover event should be logged
    And I should see failover status in dashboard

  @failover @manual
  Scenario: Manual failover initiation
    Given "ESPN Fantasy API" is experiencing degraded performance
    When I initiate manual failover to "Yahoo Fantasy API"
    Then failover should execute:
      | step                   | status    |
      | validate_target        | complete  |
      | drain_connections      | complete  |
      | switch_routing         | complete  |
      | verify_traffic         | complete  |
    And I should see confirmation of successful failover

  @failover @failback
  Scenario: Automatic failback after recovery
    Given system is in failover state
    And primary "ESPN Fantasy API" has recovered
    And health checks have passed for 5 minutes
    When automatic failback is triggered
    Then traffic should gradually return to primary
    And failback should complete without errors
    And administrators should be notified

  @failover @circuit-breaker
  Scenario: Configure circuit breaker
    When I configure circuit breaker for "Payment Gateway":
      | setting              | value       |
      | failure_threshold    | 5           |
      | success_threshold    | 3           |
      | timeout              | 30 seconds  |
      | half_open_requests   | 3           |
    Then circuit breaker should be configured
    And circuit should open after failures
    And circuit should test recovery in half-open state

  @failover @testing
  Scenario: Test failover procedure
    Given failover is configured
    When I initiate a failover test
    Then the test should:
      | step                    | result  |
      | simulate_primary_failure| success |
      | trigger_failover        | success |
      | verify_secondary_active | success |
      | simulate_recovery       | success |
      | verify_failback         | success |
    And test results should be documented
    And no production impact should occur

  # =============================================================================
  # INTEGRATION ACCESS AUDIT
  # =============================================================================

  @audit @access-log
  Scenario: View integration access audit log
    When I view the audit log for integrations
    Then I should see recent access events:
      | timestamp           | user         | integration      | action           |
      | 2024-06-15 14:30:00 | admin@ffl.com| ESPN Fantasy API | view_config      |
      | 2024-06-15 14:25:00 | dev@ffl.com  | Stripe Payments  | update_key       |
      | 2024-06-15 14:20:00 | ops@ffl.com  | Email Service    | restart_service  |
    And I should be able to filter by date range
    And I should be able to filter by user or integration

  @audit @api-usage
  Scenario: Audit API usage patterns
    When I generate API usage audit report
    Then I should see usage patterns:
      | integration      | unique_clients | requests_24h | anomalies |
      | ESPN Fantasy API | 45             | 125,000      | 0         |
      | Stripe Payments  | 3              | 8,500        | 0         |
      | NFL Data API     | 12             | 45,000       | 2         |
    And I should see flagged anomalies with details

  @audit @configuration-changes
  Scenario: Audit configuration changes
    When I view configuration change audit
    Then I should see changes:
      | timestamp           | user         | integration  | change_type       | details           |
      | 2024-06-15 10:00:00 | admin@ffl.com| API Gateway  | routing_update    | Added new route   |
      | 2024-06-14 15:30:00 | ops@ffl.com  | Rate Limits  | threshold_update  | Increased to 15k  |
      | 2024-06-14 09:00:00 | dev@ffl.com  | Webhooks     | endpoint_added    | score.updated     |
    And I should be able to view change details
    And I should be able to revert changes

  @audit @security-events
  Scenario: Review security audit events
    When I view security audit for integrations
    Then I should see security events:
      | timestamp           | event_type         | severity | integration      | details                |
      | 2024-06-15 13:00:00 | invalid_auth       | medium   | ESPN Fantasy API | Invalid API key used   |
      | 2024-06-15 12:30:00 | rate_limit_exceeded| low      | NFL Data API     | Client exceeded quota  |
      | 2024-06-14 18:00:00 | key_rotation       | info     | Stripe Payments  | Scheduled rotation     |
    And I should see recommendations for high severity events

  @audit @compliance
  Scenario: Generate compliance audit report
    When I generate compliance audit report for integrations
    Then the report should include:
      | section                   | status    | findings |
      | API key management        | compliant | 0        |
      | Access control            | compliant | 0        |
      | Data encryption           | partial   | 2        |
      | Audit logging             | compliant | 0        |
      | Third-party certifications| review    | 3        |
    And I should see detailed findings
    And I should see remediation recommendations

  @audit @export
  Scenario: Export audit data
    When I export audit data:
      | format    | date_range                     | scope            |
      | CSV       | 2024-06-01 to 2024-06-15       | all_integrations |
    Then audit data should be exported
    And the export should include all relevant fields
    And the export should be available for download

  # =============================================================================
  # DATA SYNCHRONIZATION
  # =============================================================================

  @sync @configuration
  Scenario: Configure data synchronization
    Given "ESPN Fantasy API" integration exists
    When I configure data sync:
      | setting           | value                |
      | sync_frequency    | every 5 minutes      |
      | sync_type         | incremental          |
      | conflict_resolution| source_wins         |
      | retry_on_failure  | 3 attempts           |
    Then sync configuration should be saved
    And sync schedule should be created

  @sync @manual
  Scenario: Trigger manual data sync
    Given data sync is configured for "Player Stats API"
    When I trigger a manual full sync
    Then sync should execute:
      | step                  | status    | records   |
      | fetch_source_data     | complete  | 2,500     |
      | validate_data         | complete  | 2,498     |
      | transform_data        | complete  | 2,498     |
      | load_to_destination   | complete  | 2,498     |
    And sync completion should be logged
    And I should see 2 validation failures

  @sync @monitoring
  Scenario: Monitor sync status
    When I view sync monitoring dashboard
    Then I should see sync status:
      | integration      | last_sync       | next_sync      | status  | records_synced |
      | ESPN Fantasy API | 2 minutes ago   | in 3 minutes   | healthy | 15,432         |
      | Player Stats API | 5 minutes ago   | in 10 minutes  | healthy | 2,498          |
      | Injury Reports   | 1 hour ago      | in 30 minutes  | warning | 245            |
    And I should see sync history trends

  @sync @conflict
  Scenario: Handle sync conflicts
    Given data sync is running for "Player Stats API"
    And there are conflicting records
    When sync conflict occurs
    Then I should see conflict details:
      | record_id | field        | source_value | local_value | resolution   |
      | player-123| total_points | 156.5        | 154.0       | source_wins  |
      | player-456| status       | active       | injured     | manual_review|
    And I should be able to resolve manual conflicts
    And conflict resolution should be logged

  @sync @rollback
  Scenario: Rollback failed sync
    Given a sync operation has failed
    When I initiate sync rollback
    Then rollback should execute:
      | step                   | status    |
      | identify_changes       | complete  |
      | restore_previous_data  | complete  |
      | verify_integrity       | complete  |
      | update_sync_state      | complete  |
    And data should be restored to pre-sync state
    And rollback should be logged

  # =============================================================================
  # ERROR HANDLING AND EDGE CASES
  # =============================================================================

  @error-handling @authentication
  Scenario: Handle authentication failure
    Given "ESPN Fantasy API" integration is active
    When authentication fails due to expired credentials
    Then the integration should be marked as "auth_error"
    And an alert should be sent to administrators
    And affected requests should be queued if possible
    And I should see clear error details in dashboard

  @error-handling @timeout
  Scenario: Handle integration timeout
    Given "Slow External API" integration has 30 second timeout
    When a request times out
    Then the request should be retried according to policy
    And if retries exhausted, error should be returned to caller
    And timeout should be logged with context
    And circuit breaker should record the failure

  @error-handling @rate-limited
  Scenario: Handle external rate limiting
    Given "ESPN Fantasy API" is externally rate limited
    When rate limit response (429) is received
    Then requests should be queued for retry
    And Retry-After header should be respected
    And internal callers should receive appropriate error
    And rate limit event should be logged

  @edge-case @duplicate-integration
  Scenario: Prevent duplicate integration creation
    Given "ESPN Fantasy API" integration already exists
    When I attempt to create another "ESPN Fantasy API" integration
    Then creation should be rejected
    And I should see "Integration with this name already exists"
    And I should be offered to edit existing integration

  @edge-case @circular-dependency
  Scenario: Detect circular integration dependencies
    Given "Service A" depends on "Service B"
    And "Service B" depends on "Service C"
    When I attempt to make "Service C" depend on "Service A"
    Then the dependency should be rejected
    And I should see circular dependency warning
    And the dependency chain should be displayed

  @edge-case @orphaned-webhooks
  Scenario: Handle orphaned webhooks
    Given webhooks were configured for a deleted integration
    When I run webhook cleanup
    Then orphaned webhooks should be identified:
      | webhook_id | original_integration | status   |
      | wh-123     | Deleted Service      | orphaned |
      | wh-456     | Deleted Service      | orphaned |
    And I should be able to delete or reassign orphaned webhooks

  @edge-case @concurrent-updates
  Scenario: Handle concurrent integration updates
    Given two administrators are editing the same integration
    When both submit changes simultaneously
    Then optimistic locking should prevent conflicts
    And one update should succeed
    And the other should receive a conflict notification
    And the rejected update should show current state for retry
