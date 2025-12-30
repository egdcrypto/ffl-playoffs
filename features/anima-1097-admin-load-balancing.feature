@admin @load-balancing @ANIMA-1097
Feature: Admin Load Balancing
  As a platform administrator
  I want to manage load balancing and traffic distribution
  So that I can ensure optimal performance and high availability

  Background:
    Given I am logged in as a platform administrator
    And I have load balancing management permissions
    And the load balancing system is active

  # =============================================================================
  # LOAD BALANCER DASHBOARD
  # =============================================================================

  @dashboard @overview
  Scenario: View load balancer dashboard
    When I navigate to the load balancer dashboard
    Then I should see load balancer overview:
      | load_balancer    | status  | backends | requests/sec | latency_p99 |
      | api-gateway-lb   | healthy | 8/8      | 2,500        | 45ms        |
      | web-frontend-lb  | healthy | 6/6      | 1,800        | 85ms        |
      | scoring-lb       | warning | 4/5      | 3,200        | 120ms       |
      | internal-lb      | healthy | 4/4      | 800          | 25ms        |
    And I should see traffic distribution graphs
    And I should see health status indicators

  @dashboard @metrics
  Scenario: View real-time load balancer metrics
    When I view real-time metrics
    Then I should see current metrics:
      | metric                  | value      | trend   |
      | total_requests_per_sec  | 8,300      | +5%     |
      | active_connections      | 12,500     | stable  |
      | avg_response_time       | 68ms       | -8%     |
      | error_rate              | 0.3%       | -15%    |
      | bandwidth_utilization   | 2.5 Gbps   | +10%    |
    And metrics should update in real-time

  @dashboard @topology
  Scenario: View load balancer topology
    When I view the topology
    Then I should see network topology:
      | layer           | components                    |
      | edge            | CDN, WAF                      |
      | global_lb       | geo-dns, global-lb            |
      | regional_lb     | us-east-lb, us-west-lb, eu-lb |
      | service_lb      | api-lb, web-lb, scoring-lb    |
      | backends        | server pools                  |
    And I should see connection flows

  @dashboard @alerts
  Scenario: View load balancer alerts
    When I view active alerts
    Then I should see alert summary:
      | severity | count | latest_alert                    |
      | critical | 0     | -                               |
      | warning  | 2     | Backend unhealthy: scoring-sv-5 |
      | info     | 5     | Traffic spike detected          |
    And I should be able to acknowledge alerts

  # =============================================================================
  # TRAFFIC DISTRIBUTION
  # =============================================================================

  @traffic @algorithms
  Scenario: Configure traffic distribution algorithms
    When I configure traffic distribution for "api-gateway-lb":
      | setting              | value              |
      | algorithm            | weighted_round_robin|
      | health_check_weight  | true               |
      | slow_start           | 30 seconds         |
    Then the algorithm should be applied
    And traffic should distribute accordingly

  @traffic @round-robin
  Scenario: Configure round-robin distribution
    When I configure round-robin:
      | backend          | weight |
      | api-server-1     | 1      |
      | api-server-2     | 1      |
      | api-server-3     | 1      |
      | api-server-4     | 1      |
    Then traffic should distribute evenly
    And I should see distribution metrics

  @traffic @weighted
  Scenario: Configure weighted distribution
    When I configure weighted distribution:
      | backend          | weight | expected_traffic |
      | api-server-1     | 4      | 40%              |
      | api-server-2     | 3      | 30%              |
      | api-server-3     | 2      | 20%              |
      | api-server-4     | 1      | 10%              |
    Then traffic should follow weights
    And I should see weight-based distribution

  @traffic @least-connections
  Scenario: Configure least connections algorithm
    When I configure least connections:
      | setting              | value    |
      | algorithm            | least_conn |
      | connection_timeout   | 60s      |
      | max_connections      | 10000    |
    Then traffic should route to least busy servers
    And I should see connection distribution

  @traffic @ip-hash
  Scenario: Configure IP hash distribution
    When I configure IP hash:
      | setting              | value    |
      | algorithm            | ip_hash  |
      | hash_method          | consistent|
      | virtual_nodes        | 150      |
    Then same IPs should route to same backends
    And I should see hash distribution

  @traffic @header-based
  Scenario: Configure header-based routing
    When I configure header-based routing:
      | header           | value_pattern | destination      |
      | X-API-Version    | v2.*          | api-v2-pool      |
      | X-Premium        | true          | premium-pool     |
      | X-Region         | eu-*          | eu-backend-pool  |
    Then requests should route based on headers
    And I should see routing decisions

  # =============================================================================
  # BACKEND HEALTH
  # =============================================================================

  @health @monitoring
  Scenario: Monitor backend server health
    When I view backend health status
    Then I should see health for each backend:
      | backend          | status  | last_check | response_time | success_rate |
      | api-server-1     | healthy | 5s ago     | 25ms          | 100%         |
      | api-server-2     | healthy | 5s ago     | 28ms          | 99.9%        |
      | api-server-3     | healthy | 5s ago     | 32ms          | 99.8%        |
      | api-server-4     | degraded| 5s ago     | 150ms         | 95%          |
      | api-server-5     | unhealthy| 5s ago    | timeout       | 0%           |
    And I should see health history

  @health @checks
  Scenario: Configure health check parameters
    When I configure health checks for "api-pool":
      | parameter           | value              |
      | check_type          | HTTP               |
      | endpoint            | /health            |
      | interval            | 10 seconds         |
      | timeout             | 5 seconds          |
      | healthy_threshold   | 3                  |
      | unhealthy_threshold | 2                  |
      | expected_codes      | 200,204            |
    Then health checks should be configured
    And checks should run at specified interval

  @health @tcp-checks
  Scenario: Configure TCP health checks
    When I configure TCP health checks:
      | parameter           | value    |
      | check_type          | TCP      |
      | port                | 8080     |
      | interval            | 5 seconds|
      | timeout             | 3 seconds|
    Then TCP checks should be active
    And connection success should be monitored

  @health @custom-checks
  Scenario: Configure custom health checks
    When I configure custom health checks:
      | check_name       | script                    | frequency |
      | db_connectivity  | /scripts/check_db.sh      | 30s       |
      | cache_status     | /scripts/check_cache.sh   | 15s       |
      | disk_space       | /scripts/check_disk.sh    | 60s       |
    Then custom checks should execute
    And results should affect health status

  @health @actions
  Scenario: Configure health-based actions
    When I configure health actions:
      | condition              | action                    |
      | unhealthy_threshold    | remove_from_pool          |
      | degraded_performance   | reduce_weight             |
      | recovered              | gradual_add_to_pool       |
      | all_unhealthy          | failover_to_dr            |
    Then actions should trigger on health changes
    And I should see action history

  # =============================================================================
  # AUTO-SCALING
  # =============================================================================

  @scaling @policies
  Scenario: Configure auto-scaling policies
    When I configure auto-scaling:
      | metric               | scale_up_threshold | scale_down_threshold | cooldown |
      | cpu_utilization      | > 70%              | < 30%                | 5 min    |
      | connections_per_node | > 5000             | < 1000               | 5 min    |
      | response_time_p99    | > 200ms            | < 50ms               | 10 min   |
    Then auto-scaling should be configured
    And scaling should follow policies

  @scaling @limits
  Scenario: Configure scaling limits
    When I configure scaling limits:
      | pool             | min_instances | max_instances | desired |
      | api-pool         | 4             | 20            | 8       |
      | web-pool         | 2             | 12            | 6       |
      | scoring-pool     | 3             | 15            | 5       |
    Then limits should be enforced
    And scaling should stay within limits

  @scaling @predictive
  Scenario: Configure predictive scaling
    When I configure predictive scaling:
      | setting              | value           |
      | prediction_window    | 30 minutes      |
      | historical_data      | 14 days         |
      | pattern_detection    | enabled         |
      | pre_scale_buffer     | 10%             |
    Then predictive scaling should be active
    And I should see scaling predictions

  @scaling @scheduled
  Scenario: Configure scheduled scaling
    When I configure scheduled scaling:
      | schedule         | action     | target_capacity |
      | 0 8 * * 1-5      | scale_up   | 12              |
      | 0 18 * * 1-5     | scale_down | 6               |
      | 0 0 * * 0        | scale_down | 4               |
    Then scheduled scaling should be configured
    And I should see scaling calendar

  @scaling @events
  Scenario: View scaling events
    When I view scaling events
    Then I should see recent events:
      | timestamp           | pool     | action    | from | to | trigger        |
      | 2024-06-15 14:30:00 | api-pool | scale_up  | 8    | 10 | cpu_threshold  |
      | 2024-06-15 10:00:00 | api-pool | scale_up  | 6    | 8  | scheduled      |
      | 2024-06-14 22:00:00 | api-pool | scale_down| 10   | 6  | scheduled      |
    And I should see scaling trends

  # =============================================================================
  # GEOGRAPHIC LOAD BALANCING
  # =============================================================================

  @geo @management
  Scenario: Manage geographic load balancing
    When I configure geographic load balancing:
      | region          | primary_pool     | failover_pool    | weight |
      | north_america   | us-east-pool     | us-west-pool     | 40%    |
      | europe          | eu-west-pool     | eu-central-pool  | 30%    |
      | asia_pacific    | ap-southeast-pool| ap-northeast-pool| 20%    |
      | other           | us-east-pool     | eu-west-pool     | 10%    |
    Then geographic routing should be configured
    And I should see regional traffic distribution

  @geo @dns
  Scenario: Configure GeoDNS
    When I configure GeoDNS:
      | setting              | value           |
      | resolution_method    | geolocation     |
      | fallback_region      | us-east         |
      | ttl                  | 60 seconds      |
      | health_aware         | true            |
    Then GeoDNS should be configured
    And resolution should be location-aware

  @geo @latency
  Scenario: Configure latency-based routing
    When I configure latency-based routing:
      | setting              | value           |
      | measurement_interval | 60 seconds      |
      | latency_threshold    | 100ms           |
      | bias_factor          | 1.2             |
    Then latency routing should be active
    And users should route to lowest latency

  @geo @failover
  Scenario: Configure geographic failover
    When I configure geo-failover:
      | primary_region  | failover_region | failover_threshold |
      | us-east         | us-west         | 3 health failures  |
      | eu-west         | eu-central      | 3 health failures  |
      | ap-southeast    | ap-northeast    | 3 health failures  |
    Then failover should be configured
    And regional failures should trigger failover

  @geo @traffic-policies
  Scenario: Configure regional traffic policies
    When I configure regional policies:
      | region      | policy                    | restrictions          |
      | eu          | gdpr_compliant            | no_data_transfer_out  |
      | china       | icp_compliant             | local_backends_only   |
      | us          | standard                  | none                  |
    Then regional policies should be applied
    And compliance should be enforced

  # =============================================================================
  # SSL/TLS TERMINATION
  # =============================================================================

  @ssl @termination
  Scenario: Manage SSL/TLS termination
    When I configure SSL termination:
      | setting              | value              |
      | termination_point    | load_balancer      |
      | min_tls_version      | TLS 1.2            |
      | preferred_ciphers    | ECDHE-RSA-AES256   |
      | hsts_enabled         | true               |
      | ocsp_stapling        | enabled            |
    Then SSL termination should be configured
    And I should see SSL metrics

  @ssl @certificates
  Scenario: Manage SSL certificates
    When I view SSL certificates
    Then I should see certificate status:
      | domain              | issuer      | expiry      | status  |
      | api.ffl.com         | DigiCert    | 2025-03-15  | valid   |
      | www.ffl.com         | DigiCert    | 2025-03-15  | valid   |
      | app.ffl.com         | LetsEncrypt | 2024-09-15  | warning |
    And I should see renewal reminders

  @ssl @auto-renewal
  Scenario: Configure automatic certificate renewal
    When I configure auto-renewal:
      | setting              | value           |
      | renewal_threshold    | 30 days         |
      | provider             | lets_encrypt    |
      | validation_method    | dns-01          |
      | notification_email   | ops@ffl.com     |
    Then auto-renewal should be configured
    And certificates should renew automatically

  @ssl @client-certs
  Scenario: Configure mutual TLS
    When I configure mutual TLS:
      | setting              | value           |
      | client_cert_required | true            |
      | ca_certificate       | internal-ca.pem |
      | verification_depth   | 2               |
      | crl_check            | enabled         |
    Then mutual TLS should be enabled
    And client certificates should be verified

  @ssl @protocols
  Scenario: Configure TLS protocols and ciphers
    When I configure TLS settings:
      | protocol     | enabled |
      | TLS 1.3      | yes     |
      | TLS 1.2      | yes     |
      | TLS 1.1      | no      |
      | TLS 1.0      | no      |
    And I configure cipher suites:
      | cipher_suite                  | priority |
      | TLS_AES_256_GCM_SHA384        | 1        |
      | TLS_CHACHA20_POLY1305_SHA256  | 2        |
      | ECDHE-RSA-AES256-GCM-SHA384   | 3        |
    Then TLS settings should be applied
    And I should see security grade: A+

  # =============================================================================
  # SESSION PERSISTENCE
  # =============================================================================

  @persistence @configuration
  Scenario: Configure session persistence
    When I configure session persistence:
      | setting              | value           |
      | persistence_type     | cookie          |
      | cookie_name          | SERVERID        |
      | cookie_expiry        | 1 hour          |
      | secure_cookie        | true            |
      | http_only            | true            |
    Then session persistence should be enabled
    And sessions should stick to backends

  @persistence @ip-based
  Scenario: Configure IP-based persistence
    When I configure IP persistence:
      | setting              | value           |
      | persistence_type     | source_ip       |
      | hash_method          | consistent      |
      | timeout              | 30 minutes      |
      | table_size           | 100000          |
    Then IP persistence should be enabled
    And same IPs should route consistently

  @persistence @application
  Scenario: Configure application-controlled persistence
    When I configure application persistence:
      | setting              | value           |
      | persistence_type     | header          |
      | header_name          | X-Session-ID    |
      | fallback             | round_robin     |
    Then header-based persistence should work
    And application can control routing

  @persistence @timeout
  Scenario: Configure persistence timeout
    When I configure persistence timeout:
      | pool             | idle_timeout | absolute_timeout |
      | api-pool         | 30 min       | 8 hours          |
      | web-pool         | 1 hour       | 24 hours         |
      | scoring-pool     | 15 min       | 2 hours          |
    Then timeouts should be enforced
    And expired sessions should re-balance

  # =============================================================================
  # RATE LIMITING
  # =============================================================================

  @rate-limiting @configuration
  Scenario: Configure rate limiting at load balancer
    When I configure rate limiting:
      | rule_name        | limit        | window  | key        |
      | global_limit     | 10000/sec    | 1 sec   | global     |
      | per_ip_limit     | 100/sec      | 1 sec   | source_ip  |
      | per_user_limit   | 50/sec       | 1 sec   | user_id    |
      | api_endpoint     | 1000/min     | 1 min   | endpoint   |
    Then rate limiting should be configured
    And limits should be enforced

  @rate-limiting @response
  Scenario: Configure rate limit responses
    When I configure rate limit responses:
      | setting              | value              |
      | response_code        | 429                |
      | retry_after_header   | true               |
      | rate_limit_headers   | true               |
      | custom_body          | rate_limit.json    |
    Then rate limit responses should be configured
    And headers should be included

  @rate-limiting @tiers
  Scenario: Configure tiered rate limits
    When I configure tiered limits:
      | tier         | rate_limit   | burst    |
      | free         | 100/min      | 20       |
      | basic        | 1000/min     | 100      |
      | premium      | 10000/min    | 500      |
      | enterprise   | unlimited    | n/a      |
    Then tiered limits should be applied
    And I should see tier-based metrics

  @rate-limiting @adaptive
  Scenario: Configure adaptive rate limiting
    When I configure adaptive limits:
      | setting              | value           |
      | base_limit           | 1000/sec        |
      | scale_with_capacity  | true            |
      | protect_threshold    | 80% cpu         |
      | emergency_limit      | 100/sec         |
    Then adaptive limiting should be active
    And limits should adjust with load

  # =============================================================================
  # TRAFFIC ANALYSIS
  # =============================================================================

  @traffic @patterns
  Scenario: Analyze traffic patterns
    When I analyze traffic patterns
    Then I should see pattern analysis:
      | pattern_type     | description              | frequency  |
      | daily_peak       | 8-10 AM, 6-8 PM EST      | daily      |
      | weekly_cycle     | Higher Mon-Thu           | weekly     |
      | seasonal         | NFL season spike         | seasonal   |
      | event_driven     | Game day traffic         | irregular  |
    And I should see traffic predictions
    And I should see capacity recommendations

  @traffic @analysis
  Scenario: View detailed traffic analysis
    When I view traffic analysis
    Then I should see traffic breakdown:
      | dimension        | breakdown                          |
      | by_endpoint      | /api/scores: 35%, /api/players: 25%|
      | by_method        | GET: 80%, POST: 15%, PUT: 5%       |
      | by_client        | iOS: 45%, Android: 35%, Web: 20%   |
      | by_region        | US: 60%, EU: 25%, APAC: 15%        |
    And I should see trend analysis

  @traffic @anomalies
  Scenario: Detect traffic anomalies
    When I analyze for anomalies
    Then I should see detected anomalies:
      | anomaly_type     | details                  | severity |
      | traffic_spike    | 300% increase at 3 AM    | warning  |
      | unusual_pattern  | Bot-like requests        | high     |
      | geographic       | Unexpected traffic from X| medium   |
    And I should see recommended actions

  @traffic @forecasting
  Scenario: Forecast traffic demand
    When I generate traffic forecast
    Then I should see predictions:
      | timeframe    | predicted_peak | confidence |
      | next_hour    | 12,000 rps     | 90%        |
      | next_day     | 15,000 rps     | 85%        |
      | next_week    | 18,000 rps     | 75%        |
    And I should see resource recommendations

  # =============================================================================
  # CIRCUIT BREAKERS
  # =============================================================================

  @circuit-breaker @configuration
  Scenario: Configure circuit breakers
    When I configure circuit breaker for "api-pool":
      | setting              | value           |
      | failure_threshold    | 5               |
      | success_threshold    | 3               |
      | timeout              | 30 seconds      |
      | half_open_requests   | 3               |
    Then circuit breaker should be configured
    And I should see circuit state

  @circuit-breaker @states
  Scenario: Monitor circuit breaker states
    When I view circuit breaker status
    Then I should see states:
      | backend          | state       | failures | last_trip      |
      | api-server-1     | closed      | 0        | -              |
      | api-server-2     | closed      | 2        | -              |
      | api-server-3     | half_open   | 0        | 5 min ago      |
      | api-server-4     | open        | 5        | 2 min ago      |
    And I should see state transitions

  @circuit-breaker @fallback
  Scenario: Configure circuit breaker fallback
    When I configure fallback behavior:
      | condition            | fallback_action           |
      | circuit_open         | route_to_backup_pool      |
      | all_circuits_open    | return_cached_response    |
      | timeout              | return_degraded_response  |
    Then fallback should be configured
    And fallback should activate on trigger

  @circuit-breaker @recovery
  Scenario: Configure circuit recovery
    When I configure recovery settings:
      | setting              | value           |
      | recovery_timeout     | 60 seconds      |
      | probe_interval       | 10 seconds      |
      | gradual_recovery     | true            |
      | recovery_weight      | 10%             |
    Then recovery should be configured
    And circuits should recover gradually

  # =============================================================================
  # SECURITY
  # =============================================================================

  @security @infrastructure
  Scenario: Secure load balancing infrastructure
    When I configure load balancer security:
      | setting              | value              |
      | ddos_protection      | enabled            |
      | waf_integration      | enabled            |
      | ip_reputation        | enabled            |
      | bot_mitigation       | enabled            |
    Then security should be configured
    And I should see security metrics

  @security @access-control
  Scenario: Configure access control
    When I configure access control:
      | rule_type        | source           | action  |
      | ip_whitelist     | 10.0.0.0/8       | allow   |
      | ip_blacklist     | malicious_ips    | deny    |
      | geo_block        | sanctioned_countries| deny  |
      | default          | any              | allow   |
    Then access rules should be applied
    And blocked requests should be logged

  @security @ddos
  Scenario: Configure DDoS protection
    When I configure DDoS protection:
      | protection_type  | threshold        | action          |
      | syn_flood        | 10000/sec        | challenge       |
      | udp_flood        | 50000/sec        | drop            |
      | http_flood       | 5000/sec per IP  | rate_limit      |
      | slowloris        | 100 slow conns   | terminate       |
    Then DDoS protection should be active
    And attacks should be mitigated

  @security @waf
  Scenario: Configure WAF integration
    When I configure WAF:
      | rule_set         | action           |
      | owasp_crs        | block            |
      | sql_injection    | block            |
      | xss_protection   | block            |
      | custom_rules     | as_configured    |
    Then WAF should be integrated
    And I should see WAF metrics

  # =============================================================================
  # MAINTENANCE
  # =============================================================================

  @maintenance @procedures
  Scenario: Perform load balancer maintenance
    When I initiate maintenance mode:
      | setting              | value              |
      | maintenance_window   | 2024-06-20 02:00   |
      | duration             | 2 hours            |
      | drain_timeout        | 30 minutes         |
      | failover_target      | backup-lb          |
    Then maintenance should be scheduled
    And traffic should drain gracefully

  @maintenance @drain
  Scenario: Drain traffic from backend
    When I drain backend "api-server-3"
    Then I should see drain progress:
      | metric               | value    |
      | active_connections   | 150      |
      | new_connections      | 0        |
      | drain_progress       | 75%      |
      | estimated_time       | 2 min    |
    And new requests should route elsewhere

  @maintenance @rolling
  Scenario: Perform rolling maintenance
    When I configure rolling maintenance:
      | setting              | value           |
      | batch_size           | 1 server        |
      | wait_between_batches | 5 minutes       |
      | health_check_wait    | 60 seconds      |
      | rollback_on_failure  | true            |
    Then rolling maintenance should proceed
    And availability should be maintained

  @maintenance @firmware
  Scenario: Update load balancer firmware
    When I schedule firmware update:
      | setting              | value              |
      | version              | 2.4.5              |
      | strategy             | rolling            |
      | backup_config        | true               |
      | validation_tests     | enabled            |
    Then update should be scheduled
    And I should see update progress

  # =============================================================================
  # PERFORMANCE OPTIMIZATION
  # =============================================================================

  @performance @optimization
  Scenario: Optimize load balancer performance
    When I analyze performance
    Then I should see optimization recommendations:
      | optimization         | impact   | effort  |
      | enable_connection_reuse| -30% latency| low  |
      | tune_buffer_sizes    | -15% memory | low    |
      | enable_compression   | -40% bandwidth| medium|
      | optimize_health_checks| -20% overhead| low  |
    And I should be able to apply optimizations

  @performance @connection-pooling
  Scenario: Configure connection pooling
    When I configure connection pooling:
      | setting              | value           |
      | pool_size            | 100             |
      | max_idle_time        | 60 seconds      |
      | connection_timeout   | 10 seconds      |
      | keepalive_enabled    | true            |
    Then connection pooling should be optimized
    And connection overhead should decrease

  @performance @compression
  Scenario: Configure response compression
    When I configure compression:
      | setting              | value           |
      | algorithm            | gzip, brotli    |
      | min_size             | 1 KB            |
      | content_types        | text/*, application/json |
      | compression_level    | 6               |
    Then compression should be enabled
    And bandwidth should decrease

  @performance @caching
  Scenario: Configure load balancer caching
    When I configure LB caching:
      | setting              | value           |
      | cache_size           | 10 GB           |
      | cache_ttl            | 300 seconds     |
      | cache_key            | uri, host       |
      | bypass_header        | Cache-Control   |
    Then caching should be enabled
    And I should see cache hit ratio

  # =============================================================================
  # DISASTER RECOVERY
  # =============================================================================

  @dr @configuration
  Scenario: Configure disaster recovery for load balancers
    When I configure DR:
      | setting              | value              |
      | dr_site              | us-west-2          |
      | replication          | active-passive     |
      | failover_threshold   | 3 failed checks    |
      | dns_ttl              | 60 seconds         |
    Then DR should be configured
    And I should see DR status

  @dr @failover
  Scenario: Perform DR failover
    Given primary load balancer is failing
    When I initiate DR failover
    Then failover should execute:
      | step                 | status    |
      | health_validation    | complete  |
      | dns_update           | complete  |
      | traffic_redirection  | complete  |
      | monitoring_update    | complete  |
    And traffic should route to DR site

  @dr @testing
  Scenario: Test DR failover
    When I initiate DR test:
      | setting              | value           |
      | test_type            | simulated       |
      | traffic_percentage   | 5%              |
      | duration             | 30 minutes      |
    Then DR test should execute
    And I should see test results
    And production should not be affected

  @dr @failback
  Scenario: Perform failback to primary
    Given DR site is active
    And primary site has recovered
    When I initiate failback
    Then traffic should return to primary
    And I should see failback progress
    And DR site should return to standby

  # =============================================================================
  # COST OPTIMIZATION
  # =============================================================================

  @cost @optimization
  Scenario: Optimize load balancing costs
    When I analyze load balancer costs
    Then I should see cost breakdown:
      | component            | monthly_cost | optimization_potential |
      | data_transfer        | $8,500       | 15%                   |
      | lb_instances         | $2,400       | 10%                   |
      | ssl_certificates     | $500         | 0%                    |
      | additional_features  | $1,200       | 25%                   |
    And I should see recommendations

  @cost @rightsizing
  Scenario: Rightsize load balancer resources
    When I analyze resource utilization
    Then I should see sizing recommendations:
      | load_balancer    | current_size | recommended | savings |
      | api-gateway-lb   | large        | medium      | $400/mo |
      | web-frontend-lb  | large        | large       | $0      |
      | internal-lb      | medium       | small       | $200/mo |
    And I should be able to apply changes

  @cost @reserved
  Scenario: Configure reserved capacity
    When I configure reserved capacity:
      | resource         | commitment | discount |
      | lb_capacity      | 1 year     | 30%      |
      | data_transfer    | 100 TB/mo  | 25%      |
    Then reservations should be configured
    And I should see cost projections

  # =============================================================================
  # COMPLIANCE
  # =============================================================================

  @compliance @requirements
  Scenario: Ensure load balancer compliance
    When I verify compliance
    Then I should see compliance status:
      | requirement          | status     | details                |
      | pci_dss              | compliant  | TLS 1.2+, secure config|
      | hipaa                | compliant  | encryption enabled     |
      | soc2                 | compliant  | audit logging active   |
      | gdpr                 | compliant  | data locality enforced |
    And I should see compliance report

  @compliance @audit
  Scenario: Configure compliance auditing
    When I configure audit logging:
      | setting              | value           |
      | log_all_requests     | true            |
      | log_config_changes   | true            |
      | retention_period     | 7 years         |
      | encryption           | enabled         |
    Then audit logging should be enabled
    And logs should be tamper-proof

  @compliance @encryption
  Scenario: Verify encryption compliance
    When I verify encryption status
    Then I should see encryption details:
      | component            | encryption | algorithm  | key_rotation |
      | traffic_in_transit   | yes        | TLS 1.3    | n/a          |
      | traffic_to_backend   | yes        | TLS 1.2    | n/a          |
      | config_data          | yes        | AES-256    | 90 days      |
      | logs                 | yes        | AES-256    | 90 days      |

  # =============================================================================
  # ERROR HANDLING AND EDGE CASES
  # =============================================================================

  @error-handling @backend-failure
  Scenario: Handle complete backend pool failure
    Given all backends in a pool are unhealthy
    When traffic is routed to the pool
    Then failover should trigger
    And I should see fallback behavior:
      | action               | result              |
      | try_backup_pool      | if configured       |
      | return_cached        | if available        |
      | return_503           | with retry-after    |
    And incident should be created

  @error-handling @lb-failure
  Scenario: Handle load balancer failure
    Given load balancer becomes unresponsive
    When failure is detected
    Then automatic failover should occur
    And traffic should route to standby LB
    And administrators should be notified
    And incident should be created

  @edge-case @traffic-spike
  Scenario: Handle sudden traffic spike
    Given traffic increases by 500%
    When spike is detected
    Then auto-scaling should trigger
    And rate limiting should activate if needed
    And I should see spike handling:
      | action               | status    |
      | scale_out            | triggered |
      | queue_excess         | if needed |
      | alert_ops            | sent      |

  @edge-case @slow-backend
  Scenario: Handle slow backend responses
    Given backend response times exceed thresholds
    When slowdown is detected
    Then I should see mitigation:
      | action               | status    |
      | reduce_weight        | applied   |
      | increase_timeout     | optional  |
      | circuit_breaker      | monitoring|
    And performance should be protected
