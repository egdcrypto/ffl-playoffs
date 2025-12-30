@admin @security @monitoring @platform
Feature: Admin Security Monitoring
  As a platform administrator
  I want to monitor security threats and incidents
  So that I can protect the platform and its users

  Background:
    Given I am logged in as a platform administrator
    And I have security monitoring permissions
    And the security monitoring system is operational
    And security event collection is enabled

  # ============================================================================
  # SECURITY DASHBOARD
  # ============================================================================

  @api @dashboard
  Scenario: View security dashboard overview
    Given security events have been collected
    When I request the security dashboard via "GET /api/v1/admin/security/dashboard"
    Then the response status should be 200
    And the response should contain dashboard metrics:
      | metric                      | value    | trend    | status   |
      | active_threats              | 3        | -2       | WARNING  |
      | blocked_attacks_24h         | 1,247    | +15%     | NORMAL   |
      | failed_logins_24h           | 89       | +5%      | NORMAL   |
      | active_sessions             | 12,345   | stable   | NORMAL   |
      | security_score              | 94       | +2       | GOOD     |
      | pending_vulnerabilities     | 7        | -3       | WARNING  |

  @api @dashboard
  Scenario: View real-time security event stream
    Given security events are being generated
    When I subscribe to the event stream via "GET /api/v1/admin/security/events/stream"
    Then I should receive real-time events including:
      | event_type           | severity | source            | timestamp            |
      | FAILED_LOGIN         | LOW      | 192.168.1.100     | 2024-01-15T14:30:00Z |
      | SUSPICIOUS_ACTIVITY  | MEDIUM   | 10.0.0.50         | 2024-01-15T14:30:05Z |
      | BLOCKED_REQUEST      | LOW      | 203.0.113.42      | 2024-01-15T14:30:10Z |
    And events should be filtered by my permission level

  @api @dashboard
  Scenario: View security metrics by time range
    Given historical security data is available
    When I request metrics via "GET /api/v1/admin/security/metrics" with:
      | field       | value              |
      | start_date  | 2024-01-01         |
      | end_date    | 2024-01-15         |
      | granularity | DAILY              |
    Then the response status should be 200
    And the response should contain daily metrics:
      | date       | attacks_blocked | threats_detected | incidents | logins_failed |
      | 2024-01-15 | 1,247           | 5                | 1         | 89            |
      | 2024-01-14 | 1,089           | 3                | 0         | 72            |
      | 2024-01-13 | 1,456           | 8                | 2         | 145           |

  @api @dashboard
  Scenario: View geographic distribution of security events
    Given security events have geographic data
    When I request geographic analysis via "GET /api/v1/admin/security/events/geographic"
    Then the response status should be 200
    And the response should contain:
      | country        | events_24h | blocked_ips | threat_level |
      | United States  | 5,432      | 45          | LOW          |
      | China          | 2,156      | 890         | HIGH         |
      | Russia         | 1,234      | 567         | HIGH         |
      | Germany        | 987        | 12          | LOW          |
      | Brazil         | 654        | 34          | MEDIUM       |

  # ============================================================================
  # ACTIVE THREAT MONITORING
  # ============================================================================

  @api @threats
  Scenario: Monitor active threats in real-time
    Given active threats exist in the system
    When I request active threats via "GET /api/v1/admin/security/threats/active"
    Then the response status should be 200
    And the response should contain active threats:
      | threat_id   | type              | severity | status      | target           | detected_at          |
      | THR-001     | BRUTE_FORCE       | HIGH     | MITIGATING  | auth-service     | 2024-01-15T14:00:00Z |
      | THR-002     | SQL_INJECTION     | CRITICAL | BLOCKED     | api-gateway      | 2024-01-15T13:45:00Z |
      | THR-003     | DDoS_ATTEMPT      | HIGH     | MONITORING  | load-balancer    | 2024-01-15T13:30:00Z |

  @api @threats
  Scenario: View threat details and attack patterns
    Given an active threat "THR-001" exists
    When I request threat details via "GET /api/v1/admin/security/threats/THR-001"
    Then the response status should be 200
    And the response should contain:
      | field              | value                            |
      | threat_id          | THR-001                          |
      | type               | BRUTE_FORCE                      |
      | severity           | HIGH                             |
      | attack_vector      | Authentication API               |
      | source_ips         | [203.0.113.42, 203.0.113.43]     |
      | attempts_count     | 15,432                           |
      | unique_usernames   | 234                              |
      | first_seen         | 2024-01-15T14:00:00Z             |
      | last_seen          | 2024-01-15T14:29:00Z             |
      | mitigation_status  | RATE_LIMITING_APPLIED            |

  @domain @threats
  Scenario: Automatically detect brute force attack
    Given normal authentication traffic is established
    When the system detects:
      | metric                    | threshold | actual    |
      | failed_logins_per_minute  | 10        | 150       |
      | unique_ips_attacking      | 5         | 23        |
      | targeted_accounts         | 3         | 45        |
    Then a brute force threat should be created:
      | field         | value               |
      | type          | BRUTE_FORCE         |
      | severity      | HIGH                |
      | auto_mitigate | true                |
    And rate limiting should be automatically applied
    And a domain event "ThreatDetected" should be emitted
    And security team should be alerted

  @domain @threats
  Scenario: Automatically detect SQL injection attempt
    Given the WAF is monitoring incoming requests
    When a request contains SQL injection patterns:
      | pattern                     | location    |
      | ' OR '1'='1                 | query_param |
      | ; DROP TABLE users;--       | body        |
      | UNION SELECT * FROM secrets | query_param |
    Then the request should be blocked
    And a SQL injection threat should be recorded
    And the source IP should be flagged
    And a domain event "SQLInjectionBlocked" should be emitted

  @api @threats
  Scenario: Escalate threat severity manually
    Given a threat "THR-003" exists with severity "MEDIUM"
    When I escalate the threat via "POST /api/v1/admin/security/threats/THR-003/escalate" with:
      | field       | value                              |
      | new_severity| HIGH                               |
      | reason      | Attack pattern indicates APT group |
      | notify_team | true                               |
    Then the response status should be 200
    And the threat severity should be updated to "HIGH"
    And the security team should be notified
    And a domain event "ThreatEscalated" should be emitted

  @api @threats
  Scenario: Mark threat as resolved
    Given a threat "THR-002" exists and has been mitigated
    When I resolve the threat via "POST /api/v1/admin/security/threats/THR-002/resolve" with:
      | field           | value                    |
      | resolution_type | BLOCKED_AND_PATCHED      |
      | notes           | Vulnerability patched in v2.3.1 |
      | prevent_future  | true                     |
    Then the response status should be 200
    And the threat should be marked as "RESOLVED"
    And prevention rules should be updated
    And a domain event "ThreatResolved" should be emitted

  # ============================================================================
  # SECURITY INCIDENT INVESTIGATION
  # ============================================================================

  @api @incidents
  Scenario: Create security incident for investigation
    Given suspicious activity has been detected
    When I create an incident via "POST /api/v1/admin/security/incidents" with:
      | field           | value                          |
      | title           | Unauthorized data access attempt|
      | severity        | HIGH                           |
      | category        | DATA_BREACH_ATTEMPT            |
      | affected_systems| [user-db, api-gateway]         |
      | initial_findings| Suspicious queries detected    |
    Then the response status should be 201
    And an incident ID should be generated
    And the incident timeline should be initialized
    And a domain event "IncidentCreated" should be emitted

  @api @incidents
  Scenario: View incident investigation timeline
    Given an incident "INC-2024-001" exists
    When I request the incident timeline via "GET /api/v1/admin/security/incidents/INC-2024-001/timeline"
    Then the response status should be 200
    And the response should contain timeline events:
      | timestamp            | event_type       | actor         | description                    |
      | 2024-01-15T14:00:00Z | CREATED          | system        | Incident auto-created          |
      | 2024-01-15T14:05:00Z | ASSIGNED         | admin-ops     | Assigned to security team      |
      | 2024-01-15T14:10:00Z | EVIDENCE_ADDED   | sec-analyst   | Added suspicious query logs    |
      | 2024-01-15T14:20:00Z | STATUS_CHANGE    | sec-analyst   | Changed to INVESTIGATING       |
      | 2024-01-15T14:30:00Z | CONTAINMENT      | sec-analyst   | Blocked source IP range        |

  @api @incidents
  Scenario: Add evidence to security incident
    Given an incident "INC-2024-001" is under investigation
    When I add evidence via "POST /api/v1/admin/security/incidents/INC-2024-001/evidence" with:
      | field           | value                    |
      | evidence_type   | LOG_FILE                 |
      | description     | Auth service access logs |
      | file_hash       | sha256:abc123...         |
      | time_range      | 2024-01-15T13:00-14:00   |
      | classification  | CONFIDENTIAL             |
    Then the response status should be 201
    And the evidence should be attached to the incident
    And the evidence should be preserved for forensics
    And a domain event "EvidenceAdded" should be emitted

  @api @incidents
  Scenario: Perform incident containment actions
    Given an incident "INC-2024-001" requires containment
    When I execute containment via "POST /api/v1/admin/security/incidents/INC-2024-001/contain" with:
      | field           | value                    |
      | actions         | [BLOCK_IP, REVOKE_TOKENS, ISOLATE_SYSTEM] |
      | target_ips      | [203.0.113.0/24]         |
      | affected_users  | [user-123, user-456]     |
      | systems         | [compromised-api]        |
    Then the response status should be 202
    And the containment actions should be executed:
      | action          | status     | details                    |
      | BLOCK_IP        | COMPLETED  | IP range blocked           |
      | REVOKE_TOKENS   | COMPLETED  | 12 tokens revoked          |
      | ISOLATE_SYSTEM  | COMPLETED  | System isolated from network|
    And a domain event "IncidentContained" should be emitted

  @api @incidents
  Scenario: Generate incident report
    Given an incident "INC-2024-001" has been resolved
    When I generate report via "POST /api/v1/admin/security/incidents/INC-2024-001/report" with:
      | field           | value                    |
      | report_type     | FULL_INVESTIGATION       |
      | include_sections| [timeline, evidence, impact, remediation] |
      | format          | PDF                      |
    Then the response status should be 202
    And the report should be generated containing:
      | section         | content                          |
      | executive_summary| Brief overview of incident      |
      | timeline        | Complete event timeline          |
      | root_cause      | Analysis of how incident occurred|
      | impact_analysis | Systems and data affected        |
      | remediation     | Actions taken to resolve         |
      | recommendations | Future prevention measures       |

  @api @incidents
  Scenario: List incidents by status and severity
    Given multiple security incidents exist
    When I request incidents via "GET /api/v1/admin/security/incidents" with:
      | field      | value              |
      | status     | ACTIVE             |
      | severity   | HIGH,CRITICAL      |
      | sort_by    | created_at         |
      | order      | desc               |
    Then the response status should be 200
    And the response should contain filtered incidents:
      | incident_id    | title                    | severity | status       | assigned_to  |
      | INC-2024-003   | Data exfiltration attempt| CRITICAL | INVESTIGATING| sec-lead     |
      | INC-2024-002   | Privilege escalation     | HIGH     | CONTAINING   | sec-analyst  |
      | INC-2024-001   | Unauthorized access      | HIGH     | MONITORING   | sec-analyst  |

  # ============================================================================
  # IP BLOCKLIST MANAGEMENT
  # ============================================================================

  @api @blocklist
  Scenario: View current IP blocklist
    Given IPs have been blocked
    When I request the blocklist via "GET /api/v1/admin/security/blocklist"
    Then the response status should be 200
    And the response should contain blocked entries:
      | ip_address      | block_type | reason              | blocked_at           | expires_at           |
      | 203.0.113.42    | PERMANENT  | Confirmed attacker  | 2024-01-10T10:00:00Z | null                 |
      | 198.51.100.0/24 | TEMPORARY  | DDoS source         | 2024-01-15T12:00:00Z | 2024-01-16T12:00:00Z |
      | 192.0.2.100     | PERMANENT  | Malware C2          | 2024-01-05T08:00:00Z | null                 |

  @api @blocklist
  Scenario: Add IP to blocklist
    Given I have identified a malicious IP
    When I add to blocklist via "POST /api/v1/admin/security/blocklist" with:
      | field       | value                    |
      | ip_address  | 203.0.113.99             |
      | block_type  | PERMANENT                |
      | reason      | Repeated attack attempts |
      | category    | MALICIOUS_ACTOR          |
      | evidence_id | EVD-2024-001             |
    Then the response status should be 201
    And the IP should be immediately blocked
    And all active connections from the IP should be terminated
    And a domain event "IPBlocked" should be emitted

  @api @blocklist
  Scenario: Add IP range to blocklist
    Given a range of IPs is attacking
    When I add range to blocklist via "POST /api/v1/admin/security/blocklist" with:
      | field       | value                    |
      | ip_range    | 198.51.100.0/24          |
      | block_type  | TEMPORARY                |
      | duration    | 24 hours                 |
      | reason      | Coordinated attack source|
    Then the response status should be 201
    And 256 IPs should be blocked
    And the block should expire after 24 hours
    And a domain event "IPRangeBlocked" should be emitted

  @api @blocklist
  Scenario: Remove IP from blocklist
    Given an IP "203.0.113.50" is on the blocklist
    And the block was a false positive
    When I remove from blocklist via "DELETE /api/v1/admin/security/blocklist/203.0.113.50" with:
      | field       | value                    |
      | reason      | False positive confirmed |
      | approved_by | security-lead            |
    Then the response status should be 200
    And the IP should be unblocked
    And the removal should be logged
    And a domain event "IPUnblocked" should be emitted

  @api @blocklist
  Scenario: Import blocklist from threat intelligence feed
    Given a threat intelligence feed is configured
    When I import blocklist via "POST /api/v1/admin/security/blocklist/import" with:
      | field       | value                    |
      | source      | threat-intel-feed-1      |
      | category    | KNOWN_ATTACKERS          |
      | auto_expire | 7 days                   |
    Then the response status should be 202
    And the import should process entries:
      | metric           | value    |
      | total_entries    | 15,432   |
      | new_blocks       | 12,345   |
      | already_blocked  | 3,087    |
      | duplicates       | 0        |
    And a domain event "BlocklistImported" should be emitted

  # ============================================================================
  # SUSPICIOUS IP BLOCKING
  # ============================================================================

  @api @suspicious-ip
  Scenario: Detect and flag suspicious IP behavior
    Given traffic analysis is running
    When an IP exhibits suspicious patterns:
      | pattern                    | threshold | actual    |
      | requests_per_second        | 100       | 500       |
      | unique_endpoints_hit       | 20        | 150       |
      | failed_auth_attempts       | 5         | 45        |
      | scanner_signatures         | 0         | 3         |
    Then the IP should be flagged as suspicious
    And a suspicion score should be calculated:
      | factor              | weight | score |
      | rate_abuse          | 0.3    | 0.9   |
      | endpoint_scanning   | 0.25   | 0.95  |
      | auth_attacks        | 0.25   | 0.85  |
      | known_signatures    | 0.2    | 1.0   |
      | total_score         | -      | 0.92  |
    And a domain event "SuspiciousIPDetected" should be emitted

  @api @suspicious-ip
  Scenario: View suspicious IP activity report
    Given suspicious IPs have been detected
    When I request suspicious IPs via "GET /api/v1/admin/security/suspicious-ips"
    Then the response status should be 200
    And the response should contain:
      | ip_address    | suspicion_score | behaviors               | first_seen           | status    |
      | 203.0.113.50  | 0.92            | [SCANNING, BRUTE_FORCE] | 2024-01-15T14:00:00Z | WATCHING  |
      | 198.51.100.25 | 0.78            | [RATE_ABUSE]            | 2024-01-15T13:30:00Z | WATCHING  |
      | 192.0.2.200   | 0.65            | [UNUSUAL_PATTERN]       | 2024-01-15T12:00:00Z | WATCHING  |

  @domain @suspicious-ip
  Scenario: Automatically block IP exceeding suspicion threshold
    Given the auto-block threshold is set to 0.9
    When an IP "203.0.113.75" reaches suspicion score 0.95
    Then the IP should be automatically blocked
    And the block should be temporary (24 hours)
    And the security team should be notified
    And a domain event "AutoBlockTriggered" should be emitted

  @api @suspicious-ip
  Scenario: Review and whitelist legitimate IP
    Given an IP "10.0.0.50" has been flagged as suspicious
    And investigation reveals it's a legitimate monitoring service
    When I whitelist the IP via "POST /api/v1/admin/security/whitelist" with:
      | field       | value                    |
      | ip_address  | 10.0.0.50                |
      | reason      | Authorized monitoring service |
      | category    | INTERNAL_SERVICE         |
      | approved_by | security-lead            |
    Then the response status should be 201
    And the IP should be removed from suspicious list
    And future activity should not trigger alerts
    And a domain event "IPWhitelisted" should be emitted

  # ============================================================================
  # AUTHENTICATION ANOMALY MONITORING
  # ============================================================================

  @api @auth-anomaly
  Scenario: Monitor authentication patterns for anomalies
    Given authentication monitoring is enabled
    When I request auth anomalies via "GET /api/v1/admin/security/auth/anomalies"
    Then the response status should be 200
    And the response should contain detected anomalies:
      | anomaly_id  | type                    | user_id   | severity | detected_at          |
      | ANM-001     | IMPOSSIBLE_TRAVEL       | user-123  | HIGH     | 2024-01-15T14:00:00Z |
      | ANM-002     | UNUSUAL_LOGIN_TIME      | user-456  | MEDIUM   | 2024-01-15T13:45:00Z |
      | ANM-003     | NEW_DEVICE_LOCATION     | user-789  | LOW      | 2024-01-15T13:30:00Z |
      | ANM-004     | CREDENTIAL_STUFFING     | multiple  | CRITICAL | 2024-01-15T13:00:00Z |

  @domain @auth-anomaly
  Scenario: Detect impossible travel anomaly
    Given a user "user-123" logged in from New York at 14:00:00Z
    When the same user attempts login from Tokyo at 14:30:00Z
    Then an impossible travel anomaly should be detected:
      | field              | value                    |
      | anomaly_type       | IMPOSSIBLE_TRAVEL        |
      | distance_km        | 10,850                   |
      | time_difference    | 30 minutes               |
      | required_speed_kmh | 21,700                   |
      | max_possible_kmh   | 900                      |
    And the login attempt should be blocked
    And the user should be notified
    And a domain event "ImpossibleTravelDetected" should be emitted

  @domain @auth-anomaly
  Scenario: Detect credential stuffing attack
    Given baseline authentication patterns are established
    When the system detects:
      | metric                     | baseline | current   |
      | failed_logins_per_minute   | 5        | 500       |
      | unique_usernames_targeted  | 2        | 450       |
      | common_password_attempts   | 0        | 95%       |
      | source_ips                 | varied   | 3 IPs     |
    Then a credential stuffing attack should be detected
    And affected user accounts should be protected
    And source IPs should be blocked
    And a domain event "CredentialStuffingDetected" should be emitted

  @api @auth-anomaly
  Scenario: View user authentication risk profile
    Given user authentication data is available
    When I request user risk profile via "GET /api/v1/admin/security/auth/users/user-123/risk-profile"
    Then the response status should be 200
    And the response should contain:
      | field                 | value                    |
      | user_id               | user-123                 |
      | risk_score            | 65                       |
      | risk_level            | MEDIUM                   |
      | typical_locations     | [New York, Boston]       |
      | typical_devices       | 3                        |
      | typical_login_hours   | 08:00-18:00 EST          |
      | anomalies_30d         | 2                        |
      | last_password_change  | 45 days ago              |
      | mfa_enabled           | true                     |

  @api @auth-anomaly
  Scenario: Configure authentication anomaly detection rules
    Given I want to customize anomaly detection
    When I update rules via "PUT /api/v1/admin/security/auth/anomaly-rules" with:
      | field                    | value                    |
      | impossible_travel_enabled| true                     |
      | min_travel_distance_km   | 500                      |
      | unusual_time_enabled     | true                     |
      | unusual_time_window      | 00:00-05:00              |
      | new_device_enabled       | true                     |
      | new_device_action        | MFA_REQUIRED             |
    Then the response status should be 200
    And the new rules should be applied
    And a domain event "AnomalyRulesUpdated" should be emitted

  # ============================================================================
  # SECURITY POLICY ENFORCEMENT
  # ============================================================================

  @api @policies
  Scenario: View active security policies
    Given security policies are configured
    When I request policies via "GET /api/v1/admin/security/policies"
    Then the response status should be 200
    And the response should contain:
      | policy_id    | name                    | status  | enforcement | last_updated         |
      | POL-001      | Password Complexity     | ACTIVE  | ENFORCING   | 2024-01-01T00:00:00Z |
      | POL-002      | Session Timeout         | ACTIVE  | ENFORCING   | 2024-01-01T00:00:00Z |
      | POL-003      | MFA Requirement         | ACTIVE  | ENFORCING   | 2024-01-05T00:00:00Z |
      | POL-004      | IP Restriction          | ACTIVE  | MONITORING  | 2024-01-10T00:00:00Z |
      | POL-005      | Data Classification     | DRAFT   | -           | 2024-01-15T00:00:00Z |

  @api @policies
  Scenario: Create new security policy
    Given I need to enforce a new security requirement
    When I create a policy via "POST /api/v1/admin/security/policies" with:
      | field           | value                        |
      | name            | API Rate Limiting            |
      | description     | Enforce rate limits on APIs  |
      | category        | ACCESS_CONTROL               |
      | enforcement     | ENFORCING                    |
    And I define policy rules:
      | rule_id | condition                    | action            | exception_groups |
      | R1      | requests_per_minute > 100    | THROTTLE          | [internal-services] |
      | R2      | requests_per_minute > 500    | BLOCK_TEMPORARY   | []               |
      | R3      | requests_per_minute > 1000   | BLOCK_PERMANENT   | []               |
    Then the response status should be 201
    And the policy should be created in DRAFT status
    And a domain event "SecurityPolicyCreated" should be emitted

  @api @policies
  Scenario: Activate security policy
    Given a policy "POL-006" is in DRAFT status
    And the policy has been reviewed
    When I activate the policy via "POST /api/v1/admin/security/policies/POL-006/activate" with:
      | field           | value                    |
      | enforcement_mode| ENFORCING                |
      | rollout_strategy| GRADUAL                  |
      | rollout_percent | 10                       |
    Then the response status should be 200
    And the policy should be activated for 10% of traffic
    And metrics should be collected for impact analysis
    And a domain event "SecurityPolicyActivated" should be emitted

  @domain @policies
  Scenario: Enforce password complexity policy on user registration
    Given the password complexity policy requires:
      | requirement        | value    |
      | min_length         | 12       |
      | require_uppercase  | true     |
      | require_lowercase  | true     |
      | require_numbers    | true     |
      | require_special    | true     |
      | max_repeated_chars | 3        |
    When a user attempts to set password "simple123"
    Then the password should be rejected with violations:
      | violation           | message                          |
      | MIN_LENGTH          | Password must be at least 12 characters |
      | REQUIRE_UPPERCASE   | Password must contain uppercase  |
      | REQUIRE_SPECIAL     | Password must contain special character |
    And a domain event "PasswordPolicyViolation" should be emitted

  @api @policies
  Scenario: View policy compliance report
    Given security policies are being enforced
    When I request compliance report via "GET /api/v1/admin/security/policies/compliance"
    Then the response status should be 200
    And the response should contain:
      | policy_name          | total_checks | compliant | violations | compliance_rate |
      | Password Complexity  | 15,432       | 15,200    | 232        | 98.5%           |
      | Session Timeout      | 45,678       | 45,678    | 0          | 100%            |
      | MFA Requirement      | 12,345       | 11,000    | 1,345      | 89.1%           |
      | IP Restriction       | 8,900        | 8,850     | 50         | 99.4%           |

  # ============================================================================
  # SECURITY VULNERABILITY MANAGEMENT
  # ============================================================================

  @api @vulnerabilities
  Scenario: View security vulnerabilities
    Given vulnerability scans have been performed
    When I request vulnerabilities via "GET /api/v1/admin/security/vulnerabilities"
    Then the response status should be 200
    And the response should contain:
      | vuln_id     | cve_id         | severity | affected_component | status      | discovered_at        |
      | VLN-001     | CVE-2024-1234  | CRITICAL | openssl            | OPEN        | 2024-01-15T10:00:00Z |
      | VLN-002     | CVE-2024-5678  | HIGH     | log4j              | PATCHING    | 2024-01-14T08:00:00Z |
      | VLN-003     | CVE-2024-9012  | MEDIUM   | nginx              | MITIGATED   | 2024-01-10T12:00:00Z |
      | VLN-004     | -              | LOW      | config-exposure    | OPEN        | 2024-01-15T09:00:00Z |

  @api @vulnerabilities
  Scenario: View vulnerability details and remediation
    Given a vulnerability "VLN-001" exists
    When I request vulnerability details via "GET /api/v1/admin/security/vulnerabilities/VLN-001"
    Then the response status should be 200
    And the response should contain:
      | field              | value                              |
      | vuln_id            | VLN-001                            |
      | cve_id             | CVE-2024-1234                      |
      | severity           | CRITICAL                           |
      | cvss_score         | 9.8                                |
      | description        | Remote code execution vulnerability|
      | affected_versions  | < 3.0.2                            |
      | fixed_version      | 3.0.2                              |
      | affected_systems   | [api-server-1, api-server-2]       |
      | exploit_available  | true                               |
      | remediation_steps  | [Update to 3.0.2, Apply WAF rule]  |

  @api @vulnerabilities
  Scenario: Update vulnerability status
    Given a vulnerability "VLN-002" is being remediated
    When I update status via "PATCH /api/v1/admin/security/vulnerabilities/VLN-002" with:
      | field           | value                    |
      | status          | PATCHED                  |
      | resolution_notes| Updated to version 2.17.1|
      | verified_by     | sec-engineer             |
    Then the response status should be 200
    And the vulnerability should be marked as resolved
    And a domain event "VulnerabilityResolved" should be emitted

  @api @vulnerabilities
  Scenario: Create exception for false positive vulnerability
    Given a vulnerability "VLN-005" is a false positive
    When I create exception via "POST /api/v1/admin/security/vulnerabilities/VLN-005/exception" with:
      | field           | value                          |
      | exception_type  | FALSE_POSITIVE                 |
      | justification   | Component not exposed to attack|
      | approved_by     | security-lead                  |
      | expires_at      | 2024-07-15                     |
    Then the response status should be 201
    And the vulnerability should be suppressed from reports
    And the exception should be audited
    And a domain event "VulnerabilityExceptionCreated" should be emitted

  # ============================================================================
  # SECURITY SCANNING
  # ============================================================================

  @api @scanning
  Scenario: Initiate security scan
    Given I need to scan the infrastructure
    When I start a scan via "POST /api/v1/admin/security/scans" with:
      | field           | value                    |
      | scan_type       | FULL                     |
      | targets         | [api-gateway, auth-service, database] |
      | scan_depth      | DEEP                     |
      | include_checks  | [vulnerabilities, misconfigurations, secrets] |
    Then the response status should be 202
    And a scan job should be created
    And the scan should begin execution
    And a domain event "SecurityScanStarted" should be emitted

  @api @scanning
  Scenario: View scan progress and results
    Given a security scan "SCAN-2024-001" is in progress
    When I request scan status via "GET /api/v1/admin/security/scans/SCAN-2024-001"
    Then the response status should be 200
    And the response should contain:
      | field           | value                    |
      | scan_id         | SCAN-2024-001            |
      | status          | IN_PROGRESS              |
      | progress        | 65%                      |
      | started_at      | 2024-01-15T14:00:00Z     |
      | estimated_completion | 2024-01-15T14:30:00Z |
      | findings_so_far | 12                       |

  @domain @scanning
  Scenario: Complete security scan and process findings
    Given a security scan is running
    When the scan completes
    Then the findings should be processed:
      | finding_type       | count | severity_breakdown           |
      | vulnerabilities    | 5     | CRITICAL:1, HIGH:2, MEDIUM:2 |
      | misconfigurations  | 8     | HIGH:3, MEDIUM:5             |
      | exposed_secrets    | 2     | CRITICAL:2                   |
      | compliance_issues  | 4     | MEDIUM:4                     |
    And findings should be correlated with existing issues
    And new vulnerabilities should be created
    And a domain event "SecurityScanCompleted" should be emitted

  @api @scanning
  Scenario: Schedule recurring security scans
    Given I want to automate security scanning
    When I create a scan schedule via "POST /api/v1/admin/security/scans/schedule" with:
      | field           | value                    |
      | schedule_name   | weekly-full-scan         |
      | cron_expression | 0 2 * * 0                |
      | scan_type       | FULL                     |
      | targets         | ALL                      |
      | notify_on       | [CRITICAL, HIGH]         |
    Then the response status should be 201
    And the scan should be scheduled for Sunday 2 AM
    And a domain event "ScanScheduleCreated" should be emitted

  @api @scanning
  Scenario: View scan history and trends
    Given multiple scans have been performed
    When I request scan history via "GET /api/v1/admin/security/scans/history"
    Then the response status should be 200
    And the response should contain:
      | scan_id         | completed_at         | findings | critical | high | remediated |
      | SCAN-2024-005   | 2024-01-15T02:30:00Z | 19       | 1        | 5    | 0          |
      | SCAN-2024-004   | 2024-01-08T02:30:00Z | 23       | 2        | 7    | 18         |
      | SCAN-2024-003   | 2024-01-01T02:30:00Z | 28       | 3        | 8    | 25         |
    And trends should show improvement over time

  # ============================================================================
  # DDoS PROTECTION MONITORING
  # ============================================================================

  @api @ddos
  Scenario: Monitor DDoS protection status
    Given DDoS protection is enabled
    When I request DDoS status via "GET /api/v1/admin/security/ddos/status"
    Then the response status should be 200
    And the response should contain:
      | field                    | value              |
      | protection_status        | ACTIVE             |
      | current_mode             | AUTOMATIC          |
      | attacks_mitigated_24h    | 3                  |
      | traffic_baseline_rps     | 10,000             |
      | current_traffic_rps      | 12,500             |
      | mitigation_capacity_pct  | 15%                |

  @domain @ddos
  Scenario: Detect and mitigate DDoS attack
    Given baseline traffic is 10,000 requests/second
    When traffic suddenly increases to 500,000 requests/second
    And the traffic pattern indicates:
      | indicator              | value              |
      | source_ip_diversity    | LOW                |
      | request_pattern        | IDENTICAL          |
      | geographic_anomaly     | YES                |
      | protocol_distribution  | ABNORMAL           |
    Then a DDoS attack should be detected
    And mitigation should be automatically triggered:
      | action                | status     |
      | ENABLE_RATE_LIMITING  | APPLIED    |
      | ACTIVATE_SCRUBBING    | APPLIED    |
      | BLOCK_ATTACK_SOURCES  | APPLIED    |
      | SCALE_CAPACITY        | APPLIED    |
    And a domain event "DDoSAttackDetected" should be emitted
    And the security team should be alerted

  @api @ddos
  Scenario: View DDoS attack details
    Given a DDoS attack "DDOS-2024-001" is being mitigated
    When I request attack details via "GET /api/v1/admin/security/ddos/attacks/DDOS-2024-001"
    Then the response status should be 200
    And the response should contain:
      | field              | value                    |
      | attack_id          | DDOS-2024-001            |
      | attack_type        | VOLUMETRIC               |
      | peak_traffic       | 500,000 rps              |
      | attack_sources     | 15,432 IPs               |
      | primary_regions    | [CN, RU, BR]             |
      | target_services    | [api-gateway, cdn]       |
      | started_at         | 2024-01-15T14:00:00Z     |
      | status             | MITIGATING               |
      | traffic_dropped    | 95%                      |

  @api @ddos
  Scenario: Configure DDoS protection thresholds
    Given I need to adjust DDoS protection settings
    When I update settings via "PUT /api/v1/admin/security/ddos/settings" with:
      | field                    | value              |
      | detection_sensitivity    | HIGH               |
      | auto_mitigation          | true               |
      | rate_limit_threshold     | 1000 rps/ip        |
      | challenge_threshold      | 500 rps/ip         |
      | block_threshold          | 2000 rps/ip        |
      | geographic_blocking      | [COUNTRY_X]        |
    Then the response status should be 200
    And the new settings should be applied
    And a domain event "DDoSSettingsUpdated" should be emitted

  # ============================================================================
  # SSL CERTIFICATE MONITORING
  # ============================================================================

  @api @ssl
  Scenario: Monitor SSL certificate status
    Given SSL certificates are deployed
    When I request certificate status via "GET /api/v1/admin/security/ssl/certificates"
    Then the response status should be 200
    And the response should contain:
      | domain              | issuer         | expires_at           | days_remaining | status   |
      | api.company.com     | Let's Encrypt  | 2024-03-15T00:00:00Z | 60             | HEALTHY  |
      | app.company.com     | DigiCert       | 2024-02-01T00:00:00Z | 17             | WARNING  |
      | admin.company.com   | Let's Encrypt  | 2024-01-20T00:00:00Z | 5              | CRITICAL |

  @domain @ssl
  Scenario: Alert on expiring SSL certificate
    Given a certificate for "admin.company.com" expires in 7 days
    When the certificate monitor runs daily check
    Then an alert should be generated:
      | field         | value                    |
      | alert_type    | SSL_EXPIRING             |
      | severity      | HIGH                     |
      | domain        | admin.company.com        |
      | days_remaining| 7                        |
      | action_needed | Renew certificate        |
    And responsible team should be notified
    And a domain event "SSLExpiryWarning" should be emitted

  @api @ssl
  Scenario: Trigger certificate renewal
    Given a certificate for "admin.company.com" needs renewal
    When I request renewal via "POST /api/v1/admin/security/ssl/certificates/admin.company.com/renew"
    Then the response status should be 202
    And the renewal process should start:
      | step                    | status     |
      | Generate CSR            | COMPLETED  |
      | Request certificate     | COMPLETED  |
      | Validate domain         | COMPLETED  |
      | Install certificate     | COMPLETED  |
      | Verify installation     | COMPLETED  |
    And a domain event "SSLCertificateRenewed" should be emitted

  @api @ssl
  Scenario: View SSL configuration security grade
    Given SSL is configured for endpoints
    When I request SSL analysis via "GET /api/v1/admin/security/ssl/analysis"
    Then the response status should be 200
    And the response should contain:
      | domain              | grade | issues                           |
      | api.company.com     | A+    | []                               |
      | app.company.com     | A     | [TLS 1.0 enabled]                |
      | legacy.company.com  | B     | [Weak cipher suites, No HSTS]    |

  # ============================================================================
  # SECURITY ALERT CONFIGURATION
  # ============================================================================

  @api @alerts
  Scenario: View active security alerts
    Given security alerts have been triggered
    When I request alerts via "GET /api/v1/admin/security/alerts"
    Then the response status should be 200
    And the response should contain:
      | alert_id    | type                  | severity | status      | triggered_at         |
      | ALT-001     | BRUTE_FORCE_DETECTED  | HIGH     | ACTIVE      | 2024-01-15T14:00:00Z |
      | ALT-002     | SSL_EXPIRING          | MEDIUM   | ACKNOWLEDGED| 2024-01-15T10:00:00Z |
      | ALT-003     | ANOMALY_DETECTED      | HIGH     | ACTIVE      | 2024-01-15T13:30:00Z |

  @api @alerts
  Scenario: Configure security alert rules
    Given I need to create a custom alert
    When I create an alert rule via "POST /api/v1/admin/security/alerts/rules" with:
      | field           | value                          |
      | rule_name       | high-privilege-access          |
      | description     | Alert on admin resource access |
      | condition       | resource.type == 'admin' AND user.role != 'admin' |
      | severity        | CRITICAL                       |
      | notification    | [pagerduty, slack, email]      |
      | cooldown_minutes| 5                              |
    Then the response status should be 201
    And the alert rule should be active
    And a domain event "AlertRuleCreated" should be emitted

  @api @alerts
  Scenario: Configure alert notification channels
    Given I need to update notification settings
    When I configure notifications via "PUT /api/v1/admin/security/alerts/notifications" with:
      | field           | value                    |
      | channels        | [slack, pagerduty, email, sms] |
    And I specify channel configurations:
      | channel    | severity_filter  | recipients              | schedule      |
      | pagerduty  | CRITICAL         | security-oncall         | 24x7          |
      | slack      | HIGH,CRITICAL    | #security-alerts        | 24x7          |
      | email      | ALL              | security-team@company.com| business_hours|
      | sms        | CRITICAL         | +1-555-123-4567         | 24x7          |
    Then the response status should be 200
    And notifications should be configured
    And a domain event "AlertNotificationsConfigured" should be emitted

  @api @alerts
  Scenario: Acknowledge and resolve alert
    Given an alert "ALT-001" is active
    When I acknowledge the alert via "POST /api/v1/admin/security/alerts/ALT-001/acknowledge" with:
      | field       | value                    |
      | assignee    | sec-analyst              |
      | notes       | Investigating attack pattern |
    Then the response status should be 200
    And the alert should be marked as "ACKNOWLEDGED"
    And a domain event "AlertAcknowledged" should be emitted

  @domain @alerts
  Scenario: Automatically escalate unacknowledged critical alert
    Given a critical alert "ALT-005" has been active for 15 minutes
    And the alert has not been acknowledged
    When the escalation check runs
    Then the alert should be escalated:
      | field              | value                    |
      | escalation_level   | 2                        |
      | new_recipients     | [security-manager, ciso] |
      | escalation_reason  | UNACKNOWLEDGED_TIMEOUT   |
    And a domain event "AlertEscalated" should be emitted

  # ============================================================================
  # COMPLIANCE STATUS MONITORING
  # ============================================================================

  @api @compliance
  Scenario: View compliance dashboard
    Given compliance monitoring is configured
    When I request compliance status via "GET /api/v1/admin/security/compliance"
    Then the response status should be 200
    And the response should contain:
      | framework   | overall_score | controls_passed | controls_failed | last_assessed        |
      | SOC2        | 94%           | 85              | 5               | 2024-01-15T00:00:00Z |
      | PCI-DSS     | 98%           | 250             | 4               | 2024-01-14T00:00:00Z |
      | HIPAA       | 92%           | 44              | 4               | 2024-01-13T00:00:00Z |
      | GDPR        | 96%           | 48              | 2               | 2024-01-12T00:00:00Z |

  @api @compliance
  Scenario: View compliance control details
    Given SOC2 compliance is being monitored
    When I request control details via "GET /api/v1/admin/security/compliance/soc2/controls"
    Then the response status should be 200
    And the response should contain controls:
      | control_id | name                    | status  | evidence_count | last_verified        |
      | CC6.1      | Logical Access          | PASSED  | 15             | 2024-01-15T10:00:00Z |
      | CC6.2      | Access Authentication   | PASSED  | 12             | 2024-01-15T10:00:00Z |
      | CC6.3      | Access Authorization    | FAILED  | 8              | 2024-01-15T10:00:00Z |
      | CC7.1      | Change Management       | PASSED  | 20             | 2024-01-15T10:00:00Z |

  @api @compliance
  Scenario: Upload compliance evidence
    Given a compliance control "CC6.3" needs evidence
    When I upload evidence via "POST /api/v1/admin/security/compliance/soc2/CC6.3/evidence" with:
      | field           | value                    |
      | evidence_type   | POLICY_DOCUMENT          |
      | description     | Updated access control policy |
      | document_hash   | sha256:abc123...         |
      | effective_date  | 2024-01-15               |
    Then the response status should be 201
    And the evidence should be attached
    And the control should be re-evaluated
    And a domain event "ComplianceEvidenceAdded" should be emitted

  @domain @compliance
  Scenario: Detect compliance drift
    Given compliance baseline is established
    When a configuration change violates compliance:
      | change_type        | resource         | violation              |
      | ENCRYPTION_DISABLED| storage-bucket   | CC6.7 - Data at rest   |
    Then a compliance violation should be detected
    And the affected control should be marked as FAILED
    And stakeholders should be notified
    And a domain event "ComplianceDriftDetected" should be emitted

  @api @compliance
  Scenario: Generate compliance audit report
    Given compliance data is available
    When I generate report via "POST /api/v1/admin/security/compliance/report" with:
      | field           | value                    |
      | frameworks      | [SOC2, PCI-DSS]          |
      | period_start    | 2024-01-01               |
      | period_end      | 2024-01-31               |
      | include_evidence| true                     |
      | format          | PDF                      |
    Then the response status should be 202
    And the report should be generated
    And the report should be suitable for auditor review
    And a domain event "ComplianceReportGenerated" should be emitted

  # ============================================================================
  # INCIDENT RESPONSE EXECUTION
  # ============================================================================

  @api @incident-response
  Scenario: View incident response playbooks
    Given incident response playbooks are configured
    When I request playbooks via "GET /api/v1/admin/security/incident-response/playbooks"
    Then the response status should be 200
    And the response should contain:
      | playbook_id | name                    | incident_type      | steps | last_updated         |
      | PB-001      | Data Breach Response    | DATA_BREACH        | 12    | 2024-01-10T00:00:00Z |
      | PB-002      | Ransomware Response     | RANSOMWARE         | 15    | 2024-01-08T00:00:00Z |
      | PB-003      | DDoS Response           | DDOS_ATTACK        | 8     | 2024-01-05T00:00:00Z |
      | PB-004      | Insider Threat Response | INSIDER_THREAT     | 10    | 2024-01-01T00:00:00Z |

  @api @incident-response
  Scenario: Execute incident response playbook
    Given an incident "INC-2024-001" requires response
    When I execute playbook via "POST /api/v1/admin/security/incident-response/execute" with:
      | field           | value                    |
      | incident_id     | INC-2024-001             |
      | playbook_id     | PB-001                   |
      | responders      | [sec-lead, sec-analyst]  |
    Then the response status should be 202
    And the playbook should begin execution
    And responders should be notified
    And a domain event "PlaybookExecutionStarted" should be emitted

  @domain @incident-response
  Scenario: Track playbook execution progress
    Given playbook "PB-001" is executing for incident "INC-2024-001"
    When I check execution status
    Then I should see step progress:
      | step_order | step_name              | status      | completed_by | completed_at         |
      | 1          | Assess and Triage      | COMPLETED   | sec-lead     | 2024-01-15T14:05:00Z |
      | 2          | Contain Breach         | COMPLETED   | sec-analyst  | 2024-01-15T14:15:00Z |
      | 3          | Preserve Evidence      | IN_PROGRESS | sec-analyst  | -                    |
      | 4          | Notify Stakeholders    | PENDING     | -            | -                    |
      | 5          | Investigate Root Cause | PENDING     | -            | -                    |

  @api @incident-response
  Scenario: Complete playbook step with documentation
    Given playbook step "Preserve Evidence" is in progress
    When I complete the step via "POST /api/v1/admin/security/incident-response/INC-2024-001/steps/3/complete" with:
      | field           | value                    |
      | completion_notes| Logs and memory dumps collected |
      | evidence_refs   | [EVD-001, EVD-002]       |
      | time_spent_min  | 45                       |
    Then the response status should be 200
    And the step should be marked complete
    And the next step should be activated
    And a domain event "PlaybookStepCompleted" should be emitted

  @api @incident-response
  Scenario: Create custom incident response playbook
    Given I need a new playbook for a specific threat
    When I create playbook via "POST /api/v1/admin/security/incident-response/playbooks" with:
      | field           | value                    |
      | name            | API Credential Leak      |
      | incident_type   | CREDENTIAL_EXPOSURE      |
      | severity        | CRITICAL                 |
    And I define playbook steps:
      | step_order | name                    | description                      | required | assignee_role |
      | 1          | Revoke Credentials      | Immediately revoke exposed creds | true     | SEC_ENGINEER  |
      | 2          | Assess Exposure         | Determine scope of exposure      | true     | SEC_ANALYST   |
      | 3          | Rotate Secrets          | Generate new credentials         | true     | SEC_ENGINEER  |
      | 4          | Notify Affected Parties | Inform affected users/systems    | true     | SEC_LEAD      |
      | 5          | Post-Mortem             | Document lessons learned         | true     | SEC_LEAD      |
    Then the response status should be 201
    And the playbook should be available
    And a domain event "PlaybookCreated" should be emitted

  # ============================================================================
  # SECURITY REPORT GENERATION
  # ============================================================================

  @api @reports
  Scenario: Generate security summary report
    Given security data is available
    When I request report via "POST /api/v1/admin/security/reports/generate" with:
      | field           | value                    |
      | report_type     | EXECUTIVE_SUMMARY        |
      | period          | MONTHLY                  |
      | month           | 2024-01                  |
    Then the response status should be 202
    And the report should contain:
      | section               | content                          |
      | security_posture      | Overall score and trends         |
      | incidents_summary     | Count by severity and type       |
      | threats_blocked       | Attack statistics                |
      | vulnerabilities       | Open/closed/critical counts      |
      | compliance_status     | Framework compliance scores      |
      | recommendations       | Top priority actions             |

  @api @reports
  Scenario: Generate detailed threat report
    Given threat data is available
    When I request report via "POST /api/v1/admin/security/reports/generate" with:
      | field           | value                    |
      | report_type     | THREAT_ANALYSIS          |
      | period_start    | 2024-01-01               |
      | period_end      | 2024-01-31               |
      | include_iocs    | true                     |
    Then the response status should be 202
    And the report should contain:
      | section               | content                          |
      | threat_landscape      | Overview of observed threats     |
      | attack_vectors        | Methods used by attackers        |
      | threat_actors         | Identified threat sources        |
      | ioc_list              | Indicators of compromise         |
      | mitigation_effectiveness | Defense success rates         |
      | trending_threats      | Emerging attack patterns         |

  @api @reports
  Scenario: Schedule recurring security reports
    Given I want automated reporting
    When I schedule report via "POST /api/v1/admin/security/reports/schedule" with:
      | field           | value                    |
      | schedule_name   | weekly-security-digest   |
      | report_type     | SECURITY_DIGEST          |
      | frequency       | WEEKLY                   |
      | day_of_week     | MONDAY                   |
      | recipients      | [security-team@company.com, ciso@company.com] |
      | format          | PDF                      |
    Then the response status should be 201
    And the report should be scheduled
    And recipients should receive reports every Monday
    And a domain event "ReportScheduleCreated" should be emitted

  @api @reports
  Scenario: View report history
    Given reports have been generated
    When I request report history via "GET /api/v1/admin/security/reports/history"
    Then the response status should be 200
    And the response should contain:
      | report_id    | type               | generated_at         | generated_by | download_url         |
      | RPT-2024-015 | EXECUTIVE_SUMMARY  | 2024-01-15T08:00:00Z | scheduled    | /reports/RPT-2024-015|
      | RPT-2024-014 | THREAT_ANALYSIS    | 2024-01-14T10:00:00Z | admin-ops    | /reports/RPT-2024-014|
      | RPT-2024-013 | COMPLIANCE_AUDIT   | 2024-01-13T09:00:00Z | admin-ops    | /reports/RPT-2024-013|

  # ============================================================================
  # SECURITY TRAINING TRACKING
  # ============================================================================

  @api @training
  Scenario: View security training compliance
    Given security training is required
    When I request training status via "GET /api/v1/admin/security/training/compliance"
    Then the response status should be 200
    And the response should contain:
      | metric                    | value    |
      | total_employees           | 500      |
      | training_completed        | 465      |
      | training_overdue          | 15       |
      | training_in_progress      | 20       |
      | compliance_rate           | 93%      |
      | average_score             | 87%      |

  @api @training
  Scenario: View training completion by department
    Given training data is available by department
    When I request department stats via "GET /api/v1/admin/security/training/departments"
    Then the response status should be 200
    And the response should contain:
      | department    | employees | completed | overdue | compliance_rate |
      | Engineering   | 150       | 148       | 2       | 98.7%           |
      | Operations    | 100       | 95        | 5       | 95%             |
      | Sales         | 120       | 110       | 5       | 91.7%           |
      | HR            | 30        | 28        | 2       | 93.3%           |
      | Finance       | 50        | 45        | 3       | 90%             |

  @api @training
  Scenario: Assign security training module
    Given a new security training is available
    When I assign training via "POST /api/v1/admin/security/training/assign" with:
      | field           | value                    |
      | training_id     | TRN-2024-PHISHING        |
      | title           | Phishing Awareness 2024  |
      | target_groups   | [ALL_EMPLOYEES]          |
      | due_date        | 2024-02-28               |
      | required        | true                     |
      | passing_score   | 80                       |
    Then the response status should be 201
    And training should be assigned to all employees
    And notification emails should be sent
    And a domain event "TrainingAssigned" should be emitted

  @api @training
  Scenario: View individual training records
    Given training records exist
    When I request user training via "GET /api/v1/admin/security/training/users/user-123"
    Then the response status should be 200
    And the response should contain:
      | training_id        | title                    | status     | score | completed_at         |
      | TRN-2024-PHISHING  | Phishing Awareness 2024  | COMPLETED  | 92%   | 2024-01-10T14:00:00Z |
      | TRN-2024-PASSWORD  | Password Security        | COMPLETED  | 88%   | 2024-01-05T10:00:00Z |
      | TRN-2024-DATA      | Data Protection          | IN_PROGRESS| -     | -                    |

  @domain @training
  Scenario: Send training reminder for overdue users
    Given training "TRN-2024-PHISHING" is due in 3 days
    And 20 users have not completed the training
    When the reminder system runs
    Then reminder emails should be sent to overdue users
    And managers should be notified of team compliance
    And a domain event "TrainingRemindersSent" should be emitted

  # ============================================================================
  # AUDIT LOGGING
  # ============================================================================

  @api @audit
  Scenario: View security audit log
    Given security actions have been performed
    When I request audit log via "GET /api/v1/admin/security/audit-log"
    Then the response status should be 200
    And the response should contain audit entries:
      | timestamp            | actor        | action              | resource            | outcome | ip_address    |
      | 2024-01-15T14:30:00Z | admin-ops    | BLOCK_IP            | 203.0.113.42        | SUCCESS | 10.0.0.50     |
      | 2024-01-15T14:25:00Z | sec-analyst  | VIEW_INCIDENT       | INC-2024-001        | SUCCESS | 10.0.0.51     |
      | 2024-01-15T14:20:00Z | system       | AUTO_BLOCK          | 198.51.100.0/24     | SUCCESS | -             |
      | 2024-01-15T14:15:00Z | admin-ops    | MODIFY_POLICY       | POL-001             | SUCCESS | 10.0.0.50     |

  @api @audit
  Scenario: Search audit log with filters
    Given extensive audit data exists
    When I search audit log via "GET /api/v1/admin/security/audit-log" with:
      | field       | value              |
      | actor       | admin-ops          |
      | action_type | BLOCK*, MODIFY*    |
      | start_date  | 2024-01-15         |
      | end_date    | 2024-01-15         |
    Then the response status should be 200
    And only matching entries should be returned
    And results should be sorted by timestamp descending

  @api @audit
  Scenario: Export audit log for compliance
    Given audit log needs to be exported
    When I export audit log via "POST /api/v1/admin/security/audit-log/export" with:
      | field           | value                    |
      | period_start    | 2024-01-01               |
      | period_end      | 2024-01-31               |
      | format          | CSV                      |
      | include_fields  | [timestamp, actor, action, resource, outcome, ip_address] |
    Then the response status should be 202
    And the export should be generated
    And the export should be tamper-evident
    And a domain event "AuditLogExported" should be emitted

  @domain @audit
  Scenario: Log all security-sensitive actions
    Given a user performs a security-sensitive action
    When the action is "GRANT_ADMIN_ROLE" to user "user-456"
    Then an audit entry should be created with:
      | field           | value                    |
      | action          | GRANT_ADMIN_ROLE         |
      | actor           | admin-ops                |
      | target_user     | user-456                 |
      | previous_roles  | [user]                   |
      | new_roles       | [user, admin]            |
      | justification   | <required>               |
      | approval        | security-lead            |
    And the entry should be immutable
    And a domain event "SecurityAuditLogged" should be emitted

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Handle unauthorized access to security data
    Given I do not have security monitoring permissions
    When I request security dashboard via "GET /api/v1/admin/security/dashboard"
    Then the response status should be 403
    And the response should contain error:
      | field   | value                              |
      | code    | INSUFFICIENT_PERMISSIONS           |
      | message | Security monitoring access required|
    And the access attempt should be logged

  @error
  Scenario: Handle invalid threat ID
    Given a threat "THR-INVALID" does not exist
    When I request threat details via "GET /api/v1/admin/security/threats/THR-INVALID"
    Then the response status should be 404
    And the response should contain error:
      | field   | value                    |
      | code    | THREAT_NOT_FOUND         |
      | message | Threat ID not found      |

  @error
  Scenario: Handle invalid IP address format
    Given I want to block an IP
    When I add to blocklist via "POST /api/v1/admin/security/blocklist" with:
      | field       | value                    |
      | ip_address  | 999.999.999.999          |
    Then the response status should be 400
    And the response should contain error:
      | field   | value                    |
      | code    | INVALID_IP_FORMAT        |
      | message | Invalid IP address format|

  # ============================================================================
  # DOMAIN EVENTS
  # ============================================================================

  @domain-events
  Scenario: Emit domain events for security operations
    Given security monitoring is active
    When various security operations occur
    Then the following domain events should be emitted:
      | operation                  | event_type                    |
      | Threat detected            | ThreatDetected                |
      | Threat resolved            | ThreatResolved                |
      | Incident created           | IncidentCreated               |
      | Incident contained         | IncidentContained             |
      | IP blocked                 | IPBlocked                     |
      | IP unblocked               | IPUnblocked                   |
      | Vulnerability found        | VulnerabilityDetected         |
      | Vulnerability fixed        | VulnerabilityResolved         |
      | Policy violation           | PolicyViolationDetected       |
      | Compliance drift           | ComplianceDriftDetected       |
      | Alert triggered            | SecurityAlertTriggered        |
      | Certificate expiring       | SSLExpiryWarning              |
    And each event should contain:
      | field         | description                    |
      | event_id      | Unique event identifier        |
      | timestamp     | When the event occurred        |
      | severity      | Event severity level           |
      | source        | System or user that triggered  |
      | details       | Operation-specific details     |
