Feature: Admin API Partnerships
  As a Platform Administrator
  I want to manage API partnerships and third-party integrations
  So that I can expand platform functionality through strategic API collaborations

  Background:
    Given I am authenticated as an admin with email "admin@example.com"
    And I have API partnership management permissions
    And the API partnership system is enabled

  # ===========================================
  # API Partnership Dashboard
  # ===========================================

  Scenario: Admin views API partnership dashboard
    When the admin navigates to the API partnership dashboard
    Then the dashboard displays:
      | metric                    | description                          |
      | Total Partners            | Number of active API partners        |
      | Active Integrations       | Currently connected integrations     |
      | API Calls (24h)           | Total API requests in last day       |
      | Revenue (MTD)             | Month-to-date partnership revenue    |
      | Partner Health Score      | Overall partnership health indicator |
    And partnership status distribution is shown

  Scenario: Admin views partnership summary by tier
    Given API partners are categorized by tier
    When the admin views partnership breakdown
    Then partners are shown by tier:
      | tier        | partners | api_calls_pct | revenue_pct |
      | Enterprise  | 5        | 65%           | 78%         |
      | Professional| 12       | 25%           | 18%         |
      | Starter     | 28       | 10%           | 4%          |
    And each tier shows SLA compliance metrics

  Scenario: Admin views partnership growth trends
    Given historical partnership data exists
    When the admin views growth trends
    Then the chart shows:
      | metric              | this_month | last_month | change  |
      | New Partners        | 8          | 5          | +60%    |
      | Churned Partners    | 1          | 2          | -50%    |
      | API Call Volume     | 2.4M       | 2.1M       | +14%    |
      | Partner Revenue     | $45,230    | $38,450    | +18%    |

  # ===========================================
  # Inbound API Partnerships
  # ===========================================

  Scenario: Admin views inbound API partnerships
    When the admin navigates to inbound partnerships
    Then the following integrations are displayed:
      | partner              | status   | api_version | calls_24h | last_active      |
      | ESPN Fantasy         | Active   | v2.1        | 125,000   | 2 minutes ago    |
      | Yahoo Sports         | Active   | v2.0        | 89,000    | 5 minutes ago    |
      | Sleeper App          | Active   | v2.1        | 45,000    | 1 minute ago     |
      | NFL Official         | Pending  | v2.1        | 0         | Never            |

  Scenario: Admin configures inbound API access
    Given a partner "ESPN Fantasy" exists
    When the admin configures their API access:
      | setting              | value                        |
      | allowed_endpoints    | /players, /scores, /rosters  |
      | rate_limit           | 10,000 requests/hour         |
      | ip_whitelist         | 52.0.0.0/8, 54.0.0.0/8       |
      | data_access_level    | Standard                     |
    Then the configuration is saved
    And the partner is notified of changes

  Scenario: Admin grants additional API permissions
    Given a partner requests extended access
    When the admin grants permissions:
      | permission               | granted |
      | Read Player Stats        | Yes     |
      | Read Historical Data     | Yes     |
      | Write User Preferences   | No      |
      | Access Premium Endpoints | Yes     |
    Then the permissions are updated
    And an audit log entry is created

  Scenario: Admin revokes inbound API access
    Given a partner "Inactive Partner" has API access
    When the admin revokes access with reason "Contract expired"
    Then the partner's API keys are deactivated
    And all active sessions are terminated
    And the partner receives revocation notification

  # ===========================================
  # Outbound API Integrations
  # ===========================================

  Scenario: Admin views outbound API integrations
    When the admin navigates to outbound integrations
    Then the following integrations are displayed:
      | integration          | status   | purpose               | health    |
      | NFL Data API         | Active   | Live game data        | Healthy   |
      | Sportsdata.io        | Active   | Player statistics     | Healthy   |
      | SendGrid             | Active   | Email delivery        | Degraded  |
      | Stripe               | Active   | Payment processing    | Healthy   |

  Scenario: Admin configures outbound API connection
    Given an outbound integration "NFL Data API" exists
    When the admin configures the connection:
      | setting              | value                        |
      | base_url             | https://api.nfl.com/v3       |
      | auth_type            | OAuth2                       |
      | timeout              | 30 seconds                   |
      | retry_attempts       | 3                            |
      | circuit_breaker      | Enabled                      |
    Then the configuration is saved
    And connection is tested successfully

  Scenario: Admin adds new outbound integration
    Given the admin wants to add a new data source
    When the admin creates an integration:
      | field                | value                        |
      | name                 | Weather API                  |
      | provider             | OpenWeather                  |
      | purpose              | Game day weather conditions  |
      | base_url             | https://api.openweather.org  |
      | auth_type            | API Key                      |
    Then the integration is created
    And credentials are securely stored
    And the integration is ready for use

  Scenario: Admin monitors outbound integration health
    Given outbound integrations are active
    When the admin views integration health
    Then health metrics are displayed:
      | integration     | uptime  | avg_latency | error_rate | last_failure     |
      | NFL Data API    | 99.95%  | 145ms       | 0.02%      | 3 days ago       |
      | Sportsdata.io   | 99.87%  | 234ms       | 0.08%      | 1 day ago        |
      | SendGrid        | 98.50%  | 890ms       | 1.20%      | 2 hours ago      |
    And degraded services are highlighted

  # ===========================================
  # Partner Onboarding
  # ===========================================

  Scenario: Admin initiates partner onboarding
    Given a new partner application is received
    When the admin starts onboarding for "New Partner Inc"
    Then the onboarding workflow is created:
      | step                     | status    | required  |
      | Application Review       | Pending   | Yes       |
      | Legal Agreement          | Pending   | Yes       |
      | Technical Requirements   | Pending   | Yes       |
      | Security Assessment      | Pending   | Yes       |
      | API Credentials          | Pending   | Yes       |
      | Sandbox Testing          | Pending   | Yes       |
      | Production Access        | Pending   | Yes       |

  Scenario: Admin reviews partner application
    Given a partner application exists
    When the admin reviews the application:
      | field                | value                          |
      | company_name         | New Partner Inc                |
      | use_case             | Fantasy sports mobile app      |
      | expected_volume      | 500,000 requests/day           |
      | requested_endpoints  | /players, /scores, /leagues    |
      | technical_contact    | dev@newpartner.com             |
    Then the admin can approve or request changes
    And the decision is logged

  Scenario: Admin completes legal agreement step
    Given the partner has submitted agreements
    When the admin verifies legal documents:
      | document             | status     |
      | API Terms of Service | Signed     |
      | Data Processing Agmt | Signed     |
      | SLA Agreement        | Signed     |
      | NDA                  | Signed     |
    Then the legal step is marked complete
    And documents are stored securely

  Scenario: Admin provisions sandbox environment
    Given the partner has passed security assessment
    When the admin provisions sandbox access:
      | resource             | value                          |
      | sandbox_api_key      | Generated                      |
      | sandbox_url          | https://sandbox.ffl-api.com    |
      | test_data            | Sample league with 100 players |
      | rate_limit           | 1,000 requests/hour            |
      | expiration           | 30 days                        |
    Then sandbox credentials are sent to the partner
    And sandbox usage is monitored

  Scenario: Admin promotes partner to production
    Given the partner has completed sandbox testing
    When the admin promotes to production:
      | check                    | status  |
      | Sandbox tests passed     | Yes     |
      | Error rate acceptable    | Yes     |
      | Rate limits respected    | Yes     |
      | Documentation reviewed   | Yes     |
    Then production API keys are generated
    And the partner status changes to "Active"
    And welcome documentation is sent

  # ===========================================
  # API Authentication Management
  # ===========================================

  Scenario: Admin views partner API credentials
    Given a partner "ESPN Fantasy" exists
    When the admin views their credentials
    Then the following are displayed:
      | credential_type    | status   | created         | last_used        |
      | API Key (Primary)  | Active   | 2023-06-15      | 2 minutes ago    |
      | API Key (Secondary)| Active   | 2023-09-20      | 1 hour ago       |
      | OAuth Client       | Active   | 2023-06-15      | 5 minutes ago    |
    And sensitive values are masked

  Scenario: Admin rotates partner API key
    Given a partner's API key needs rotation
    When the admin initiates key rotation:
      | setting              | value                |
      | rotation_type        | Graceful             |
      | grace_period         | 24 hours             |
      | notify_partner       | Yes                  |
    Then a new API key is generated
    And the old key remains valid during grace period
    And the partner is notified

  Scenario: Admin revokes compromised credentials
    Given a partner's credentials may be compromised
    When the admin emergency revokes credentials
    Then all API keys are immediately invalidated
    And all OAuth tokens are revoked
    And the partner is notified urgently
    And a security incident is logged

  Scenario: Admin configures OAuth settings for partner
    Given the admin manages OAuth configuration
    When the admin updates OAuth settings:
      | setting                | value                   |
      | allowed_scopes         | read:players, read:scores|
      | token_expiry           | 1 hour                  |
      | refresh_token_expiry   | 30 days                 |
      | allowed_redirect_urls  | https://partner.com/*   |
    Then OAuth configuration is updated
    And existing tokens remain valid until expiry

  Scenario: Admin enables mTLS for partner
    Given a partner requires enhanced security
    When the admin enables mTLS:
      | setting              | value                        |
      | client_cert_required | Yes                          |
      | cert_validity        | 1 year                       |
      | cert_dn              | CN=partner.espn.com          |
    Then a client certificate is generated
    And the certificate is securely delivered
    And mTLS is enforced for the partner

  # ===========================================
  # API Rate Limiting
  # ===========================================

  Scenario: Admin configures rate limits for partner
    Given a partner "ESPN Fantasy" exists
    When the admin configures rate limits:
      | limit_type           | value                |
      | requests_per_second  | 100                  |
      | requests_per_hour    | 50,000               |
      | requests_per_day     | 500,000              |
      | burst_limit          | 200                  |
      | concurrent_requests  | 50                   |
    Then rate limits are applied immediately
    And the partner is notified of changes

  Scenario: Admin configures endpoint-specific limits
    Given a partner has different needs per endpoint
    When the admin sets endpoint limits:
      | endpoint             | requests_per_min | notes                   |
      | /players             | 1,000            | High frequency allowed  |
      | /scores/live         | 500              | Real-time data          |
      | /historical/*        | 100              | Resource intensive      |
      | /export/*            | 10               | Bulk data exports       |
    Then endpoint-specific limits are enforced
    And default limits apply to unlisted endpoints

  Scenario: Admin views rate limit usage
    Given partners are consuming API resources
    When the admin views rate limit dashboard
    Then usage is displayed:
      | partner         | hourly_usage | hourly_limit | percentage | status    |
      | ESPN Fantasy    | 42,350       | 50,000       | 85%        | Warning   |
      | Yahoo Sports    | 28,900       | 100,000      | 29%        | Normal    |
      | Sleeper App     | 9,800        | 10,000       | 98%        | Critical  |
    And alerts are triggered for critical usage

  Scenario: Admin grants temporary rate limit increase
    Given a partner requests higher limits for an event
    When the admin grants temporary increase:
      | setting              | value                |
      | partner              | ESPN Fantasy         |
      | new_hourly_limit     | 100,000              |
      | start_time           | 2024-01-21 12:00 UTC |
      | end_time             | 2024-01-21 20:00 UTC |
      | reason               | Super Bowl coverage  |
    Then the temporary limit is scheduled
    And limits auto-revert after end time

  Scenario: Admin configures rate limit penalties
    Given the admin wants to enforce rate limit compliance
    When the admin configures penalty settings:
      | violation_type       | penalty                     |
      | Soft limit exceeded  | Warning email               |
      | Hard limit exceeded  | 429 response, 60s cooldown  |
      | Repeated violations  | Temporary suspension (1h)   |
      | Abuse detected       | Account review required     |
    Then penalty rules are enforced
    And violations are logged for review

  # ===========================================
  # API Partnership Monitoring
  # ===========================================

  Scenario: Admin views real-time API traffic
    When the admin views real-time traffic
    Then the dashboard shows:
      | metric                | value        |
      | Current RPS           | 1,245        |
      | Active Connections    | 89           |
      | Average Latency       | 125ms        |
      | Error Rate            | 0.15%        |
      | Top Partner           | ESPN Fantasy |
    And traffic is updated in real-time

  Scenario: Admin views partner API usage analytics
    Given a partner "ESPN Fantasy" exists
    When the admin views their analytics
    Then usage patterns are displayed:
      | metric                    | value       |
      | Total Requests (30d)      | 3,245,000   |
      | Unique Endpoints Used     | 12          |
      | Peak Hour                 | Sundays 1PM |
      | Average Response Time     | 145ms       |
      | Cache Hit Rate            | 67%         |
    And usage trends are charted

  Scenario: Admin views API error analytics
    Given API errors have occurred
    When the admin views error analytics
    Then errors are categorized:
      | error_type           | count | percentage | top_partner     |
      | 400 Bad Request      | 1,234 | 45%        | Sleeper App     |
      | 401 Unauthorized     | 567   | 21%        | New Partner Inc |
      | 429 Rate Limited     | 456   | 17%        | ESPN Fantasy    |
      | 500 Server Error     | 234   | 9%         | Internal        |
      | 503 Unavailable      | 212   | 8%         | NFL Data API    |
    And error patterns are identified

  Scenario: Admin configures monitoring alerts
    Given the admin wants proactive notifications
    When the admin configures alerts:
      | alert_type               | threshold          | channels          |
      | Partner Error Rate       | > 5%               | Slack, Email      |
      | Response Time P99        | > 2 seconds        | Slack             |
      | Rate Limit Violations    | > 100/hour         | Email             |
      | Partner Downtime         | > 5 minutes        | PagerDuty, Slack  |
    Then alerts are configured
    And notifications trigger automatically

  Scenario: Admin views partner SLA compliance
    Given partners have SLA agreements
    When the admin views SLA compliance
    Then compliance metrics are displayed:
      | partner         | uptime_sla | actual_uptime | latency_sla | actual_latency | compliant |
      | ESPN Fantasy    | 99.9%      | 99.95%        | 200ms       | 145ms          | Yes       |
      | Yahoo Sports    | 99.5%      | 99.87%        | 300ms       | 234ms          | Yes       |
      | Sleeper App     | 99.0%      | 98.50%        | 500ms       | 890ms          | No        |
    And SLA breaches trigger notifications

  # ===========================================
  # API Versioning
  # ===========================================

  Scenario: Admin views API version status
    When the admin views API versions
    Then version status is displayed:
      | version | status      | release_date | deprecation  | partners_using |
      | v2.1    | Current     | 2024-01-01   | -            | 35             |
      | v2.0    | Supported   | 2023-06-01   | 2024-06-01   | 12             |
      | v1.5    | Deprecated  | 2022-12-01   | 2023-12-01   | 3              |
      | v1.0    | Sunset      | 2022-01-01   | 2023-01-01   | 0              |

  Scenario: Admin deprecates API version
    Given API version v2.0 needs deprecation
    When the admin deprecates the version:
      | setting              | value                |
      | version              | v2.0                 |
      | deprecation_date     | 2024-06-01           |
      | sunset_date          | 2024-12-01           |
      | migration_guide      | https://docs/v2-to-v21|
    Then the version is marked deprecated
    And affected partners are notified
    And deprecation warnings are added to responses

  Scenario: Admin tracks partner version migration
    Given partners need to migrate to v2.1
    When the admin views migration status
    Then migration progress is shown:
      | partner         | current_version | target_version | migration_status |
      | ESPN Fantasy    | v2.1            | v2.1           | Completed        |
      | Yahoo Sports    | v2.0            | v2.1           | In Progress      |
      | Sleeper App     | v2.0            | v2.1           | Not Started      |
    And migration assistance can be offered

  Scenario: Admin configures version sunset enforcement
    Given v1.5 is past its sunset date
    When the admin enforces sunset:
      | setting              | value                        |
      | enforcement_mode     | Warn then Block              |
      | warning_period       | 30 days                      |
      | block_date           | 2024-02-01                   |
      | response_on_block    | 410 Gone + migration info    |
    Then sunset enforcement is scheduled
    And affected partners receive urgent notifications

  # ===========================================
  # API Documentation
  # ===========================================

  Scenario: Admin manages partner documentation portal
    When the admin views documentation settings
    Then the documentation portal shows:
      | section              | status     | last_updated    |
      | API Reference        | Published  | 2024-01-15      |
      | Authentication Guide | Published  | 2024-01-10      |
      | Rate Limiting        | Published  | 2024-01-12      |
      | Best Practices       | Draft      | 2024-01-18      |
      | Changelog            | Published  | 2024-01-20      |

  Scenario: Admin publishes documentation update
    Given documentation changes are ready
    When the admin publishes updates:
      | section              | changes                      |
      | API Reference        | Added new /predictions endpoint|
      | Changelog            | v2.1.5 release notes         |
    Then documentation is updated
    And partners are notified of changes
    And previous version is archived

  Scenario: Admin generates partner-specific documentation
    Given a partner has custom API access
    When the admin generates custom docs:
      | partner              | ESPN Fantasy                 |
      | included_endpoints   | Based on their permissions   |
      | custom_examples      | Yes                          |
      | branding             | Co-branded                   |
    Then personalized documentation is generated
    And accessible via partner portal

  Scenario: Admin views documentation analytics
    Given partners access documentation
    When the admin views docs analytics
    Then usage is displayed:
      | page                     | views_30d | unique_visitors | avg_time  |
      | API Reference            | 2,450     | 342             | 5m 23s    |
      | Authentication Guide     | 1,890     | 298             | 8m 45s    |
      | Error Codes              | 1,234     | 256             | 3m 12s    |
      | Getting Started          | 987       | 445             | 12m 30s   |

  # ===========================================
  # API Partnership Revenue
  # ===========================================

  Scenario: Admin views partnership revenue dashboard
    When the admin views revenue analytics
    Then the dashboard shows:
      | metric                    | value       |
      | Total Revenue (MTD)       | $45,230     |
      | Revenue vs Last Month     | +18%        |
      | Top Revenue Partner       | ESPN Fantasy|
      | Average Revenue/Partner   | $1,006      |
      | Overdue Invoices          | 2           |

  Scenario: Admin views revenue by partner
    Given partners generate revenue
    When the admin views partner revenue
    Then revenue is itemized:
      | partner         | tier         | monthly_fee | usage_fees | total     |
      | ESPN Fantasy    | Enterprise   | $5,000      | $3,450     | $8,450    |
      | Yahoo Sports    | Enterprise   | $5,000      | $2,890     | $7,890    |
      | Sleeper App     | Professional | $1,000      | $890       | $1,890    |

  Scenario: Admin configures pricing tiers
    Given the admin manages API pricing
    When the admin updates pricing:
      | tier         | monthly_base | included_calls | overage_rate |
      | Enterprise   | $5,000       | 1,000,000      | $0.001       |
      | Professional | $1,000       | 100,000        | $0.005       |
      | Starter      | $100         | 10,000         | $0.01        |
    Then pricing is updated
    And new partners use updated pricing
    And existing partners are grandfathered if applicable

  Scenario: Admin generates partner invoice
    Given a billing period has ended
    When the admin generates invoices
    Then invoices include:
      | field                | value                    |
      | partner              | ESPN Fantasy             |
      | period               | January 2024             |
      | base_fee             | $5,000                   |
      | api_calls            | 3,450,000                |
      | overage_calls        | 2,450,000                |
      | overage_charges      | $2,450                   |
      | total                | $7,450                   |
    And invoices are sent automatically

  Scenario: Admin tracks revenue forecasting
    Given historical revenue data exists
    When the admin views revenue forecast
    Then projections are displayed:
      | period     | projected_revenue | confidence |
      | February   | $48,500           | High       |
      | March      | $52,200           | Medium     |
      | Q2 2024    | $165,000          | Medium     |
      | 2024       | $680,000          | Low        |

  # ===========================================
  # Partner Support
  # ===========================================

  Scenario: Admin views partner support tickets
    When the admin views support queue
    Then tickets are displayed:
      | ticket_id | partner         | subject                    | priority | status    |
      | SUP-001   | ESPN Fantasy    | Rate limit increase request| Medium   | Open      |
      | SUP-002   | Sleeper App     | 500 errors on /scores      | High     | In Progress|
      | SUP-003   | Yahoo Sports    | Documentation question     | Low      | Resolved  |

  Scenario: Admin responds to partner inquiry
    Given a support ticket exists
    When the admin responds:
      | ticket_id    | SUP-001                          |
      | response     | Rate limit increased to 100k/hr  |
      | action_taken | Updated rate limit configuration |
      | status       | Resolved                         |
    Then the partner is notified
    And ticket is closed

  Scenario: Admin schedules partner technical call
    Given a partner needs technical assistance
    When the admin schedules a call:
      | partner              | ESPN Fantasy               |
      | topic                | Migration to v2.1          |
      | attendees            | Partner dev team, API team |
      | date_time            | 2024-01-25 10:00 UTC       |
    Then calendar invites are sent
    And meeting notes template is created

  # ===========================================
  # Security and Compliance
  # ===========================================

  Scenario: Admin views partner security status
    When the admin views security dashboard
    Then security metrics are displayed:
      | partner         | last_security_review | compliance_score | issues |
      | ESPN Fantasy    | 2024-01-10           | 95%              | 0      |
      | Yahoo Sports    | 2024-01-05           | 92%              | 1      |
      | Sleeper App     | 2023-12-15           | 78%              | 3      |

  Scenario: Admin initiates partner security audit
    Given a partner requires security review
    When the admin initiates audit:
      | partner              | Sleeper App                |
      | audit_type           | Comprehensive              |
      | areas                | Auth, Data handling, Logs  |
      | deadline             | 2024-02-15                 |
    Then audit checklist is generated
    And partner is notified of requirements

  Scenario: Admin manages data access agreements
    Given partners access user data
    When the admin reviews data agreements
    Then agreements are displayed:
      | partner         | dpa_status | data_categories        | expiry_date |
      | ESPN Fantasy    | Active     | Player stats, Scores   | 2025-06-15  |
      | Yahoo Sports    | Active     | Player stats           | 2025-03-20  |
      | Sleeper App     | Expiring   | Player stats, Rosters  | 2024-02-01  |
    And expiring agreements are flagged

  Scenario: Admin configures IP restrictions for partner
    Given a partner needs IP-based security
    When the admin configures IP restrictions:
      | partner              | ESPN Fantasy                |
      | allowed_ips          | 52.0.0.0/8, 54.0.0.0/8      |
      | enforcement          | Block unlisted IPs          |
      | notification         | Alert on blocked attempts   |
    Then IP restrictions are enforced
    And violations are logged

  # ===========================================
  # Error Cases
  # ===========================================

  Scenario: Admin cannot onboard partner without legal agreements
    Given a partner application is incomplete
    When the admin attempts to provision API access
    Then the request is rejected with error "LEGAL_AGREEMENTS_REQUIRED"
    And the missing documents are listed

  Scenario: Admin cannot exceed maximum partners for tier
    Given the platform has partner limits
    When the admin attempts to add a partner beyond limits
    Then the request is rejected with error "PARTNER_LIMIT_EXCEEDED"
    And upgrade options are displayed

  Scenario: Admin cannot delete active partner
    Given a partner has active API traffic
    When the admin attempts to delete the partner
    Then the request is blocked with warning:
      """
      Cannot delete partner with active API traffic.
      Last API call: 2 minutes ago
      Active sessions: 12

      Please deactivate the partner first and wait for
      all sessions to expire before deletion.
      """

  Scenario: Partner credentials expired
    Given a partner's API key has expired
    When the partner attempts API access
    Then requests are rejected with 401 Unauthorized
    And the admin is notified of expired credentials
    And renewal options are sent to the partner

  Scenario: Admin views partner incident history
    Given security incidents have occurred
    When the admin views incident history
    Then incidents are displayed:
      | incident_id | partner      | type                 | date       | resolution    |
      | INC-001     | Old Partner  | Credential leak      | 2024-01-05 | Keys rotated  |
      | INC-002     | Test Partner | Excessive 4xx errors | 2024-01-10 | Rate limited  |
    And incident details can be expanded
