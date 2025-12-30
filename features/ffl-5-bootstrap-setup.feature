Feature: Bootstrap PAT Setup for Initial System Configuration
  As a system administrator
  I want to create a bootstrap PAT for initial super admin setup
  So that the system can be securely initialized without pre-existing accounts

  Background:
    Given the system is newly deployed
    And no super admin accounts exist yet
    And the PersonalAccessToken table exists in the database

  Scenario: Setup script creates bootstrap PAT
    When the bootstrap setup script runs
    Then a new PersonalAccessToken is created with name "bootstrap"
    And the PAT has scope "ADMIN"
    And the PAT expiration is set to 1 year from creation
    And the PAT createdBy is set to "SYSTEM"
    And the PAT token is hashed with bcrypt before storage
    And the plaintext PAT is output to console one-time only
    And the PAT has prefix "pat_" in plaintext format

  Scenario: Bootstrap PAT plaintext displayed only once
    When the bootstrap setup script creates the PAT
    Then the console displays: "Bootstrap PAT (SAVE THIS - shown only once): pat_abc123xyz..."
    And the plaintext PAT is never logged to files
    And the plaintext PAT is never stored in database
    And only the bcrypt hash is persisted
    And the administrator must save the PAT immediately

  Scenario: Bootstrap PAT stored in database with hash
    Given the bootstrap setup script generates PAT "pat_abc123xyz456"
    When the PAT is persisted to database
    Then the PersonalAccessToken record contains:
      | Field      | Value                           |
      | name       | bootstrap                       |
      | tokenHash  | bcrypt(pat_abc123xyz456)        |
      | scope      | ADMIN                           |
      | expiresAt  | current_time + 1 year           |
      | createdBy  | SYSTEM                          |
      | createdAt  | current_timestamp               |
      | lastUsedAt | null                            |
      | revoked    | false                           |
      | revokedAt  | null                            |
    And the plaintext token is not in the database

  Scenario: Use bootstrap PAT to create first super admin account
    Given the bootstrap PAT "pat_abc123xyz456" was created
    And the PAT has ADMIN scope
    When a request is sent to create super admin with bootstrap PAT:
      """
      POST /api/v1/superadmin/bootstrap
      Authorization: Bearer pat_abc123xyz456
      {
        "email": "admin@example.com",
        "googleId": "google-user-123"
      }
      """
    Then Envoy validates the PAT via auth service
    And the auth service validates PAT hash
    And the request is authorized with ADMIN scope
    And a new User is created with role SUPER_ADMIN
    And the first super admin account is established

  Scenario: Bootstrap PAT authentication flow
    Given the bootstrap PAT exists in database
    When a service sends request with "Authorization: Bearer pat_abc123xyz456"
    Then Envoy calls auth service with the PAT
    And auth service detects PAT prefix "pat_"
    And auth service hashes "pat_abc123xyz456" with bcrypt
    And auth service queries PersonalAccessToken by tokenHash
    And auth service validates PAT is not expired
    And auth service validates PAT is not revoked
    And auth service returns HTTP 200 with headers:
      | Header        | Value     |
      | X-Service-Id  | SYSTEM    |
      | X-PAT-Scope   | ADMIN     |
      | X-PAT-Id      | pat-id    |
    And auth service updates lastUsedAt timestamp

  Scenario: Rotate bootstrap PAT after super admin creation
    Given the first super admin account is created
    And the bootstrap PAT was used successfully
    When the super admin generates a new PAT for system access
    Then the super admin should revoke the bootstrap PAT
    And the bootstrap PAT revoked flag is set to true
    And the bootstrap PAT revokedAt is set to current timestamp
    And the bootstrap PAT can no longer be used
    And the system now uses the new PAT for service access

  Scenario: Bootstrap PAT expires after 1 year
    Given the bootstrap PAT was created on "2024-01-01"
    And the PAT expiration is "2025-01-01"
    And the current time is "2025-01-02"
    When a request uses the bootstrap PAT
    Then the auth service validates expiration
    And the PAT is rejected as expired
    And the request fails with 401 Unauthorized
    And the system shows "PAT has expired"

  Scenario: Bootstrap script prevents duplicate bootstrap PAT creation
    Given a bootstrap PAT already exists
    When the bootstrap setup script runs again
    Then the script checks for existing bootstrap PAT
    And the script displays "Bootstrap PAT already exists"
    And no new PAT is created
    And the existing PAT is not modified
    And the administrator can view existing PAT metadata (not plaintext)

  Scenario: Bootstrap PAT scope validation
    Given the bootstrap PAT has ADMIN scope
    When a request uses bootstrap PAT for SUPER_ADMIN endpoint
    Then the auth service validates scope
    And ADMIN scope grants access to SUPER_ADMIN endpoints
    And the request is authorized
    And the super admin bootstrap endpoint is accessible

  Scenario: Security best practices for bootstrap PAT
    When the bootstrap PAT is created
    Then the following security measures are enforced:
      | Security Measure                              |
      | Plaintext shown only once on console          |
      | Never logged to files                         |
      | Never exposed in API responses                |
      | Stored as bcrypt hash in database             |
      | 1-year expiration enforced                    |
      | Can be revoked immediately                    |
      | lastUsedAt tracked for audit                  |
      | Creation logged in audit log                  |
    And the bootstrap PAT follows same security model as user PATs

  Scenario: Bootstrap script with database connection failure
    Given the database is not accessible
    When the bootstrap setup script runs
    Then the script fails with error "DATABASE_CONNECTION_FAILED"
    And no bootstrap PAT is created
    And the administrator is notified to check database connectivity

  Scenario: View bootstrap PAT metadata without plaintext
    Given the bootstrap PAT was created 30 days ago
    And the super admin queries PAT metadata
    When the super admin requests bootstrap PAT details
    Then the system returns:
      | Field      | Value              |
      | name       | bootstrap          |
      | scope      | ADMIN              |
      | createdBy  | SYSTEM             |
      | createdAt  | 2024-01-01         |
      | expiresAt  | 2025-01-01         |
      | lastUsedAt | 2024-01-15         |
      | revoked    | false              |
    And the tokenHash is NOT returned
    And the plaintext PAT is NOT returned
    And the super admin cannot recover the plaintext

  Scenario: Audit logging for bootstrap PAT usage
    Given the bootstrap PAT is used to create super admin
    When each request using bootstrap PAT is processed
    Then an audit log entry is created with:
      | Field       | Value                      |
      | patId       | bootstrap-pat-id           |
      | action      | CREATE_SUPER_ADMIN         |
      | scope       | ADMIN                      |
      | timestamp   | current_timestamp          |
      | successful  | true                       |
    And all bootstrap PAT usage is tracked
    And administrators can audit bootstrap activities

  # Token Format Validation Scenarios

  Scenario: Bootstrap PAT format follows security standards
    When the bootstrap PAT is generated
    Then the token has format: "pat_<identifier>_<random>"
    And the identifier is 32 hexadecimal characters (UUID without hyphens)
    And the random part is 64+ URL-safe Base64 characters
    And the total token length is at least 100 characters
    And the token contains sufficient entropy for security

  Scenario: Validate PAT prefix during authentication
    Given the auth service receives an authorization header
    When the token starts with "pat_"
    Then the auth service treats it as a Personal Access Token
    When the token starts with "eyJ" (JWT prefix)
    Then the auth service treats it as a Google JWT
    When the token has no recognized prefix
    Then the auth service rejects with 401 Unauthorized
    And the error is "INVALID_TOKEN_FORMAT"

  Scenario: Malformed PAT token rejected
    Given the auth service receives token "pat_invalid"
    When the token format is validated
    Then the request is rejected with 401 Unauthorized
    And the error is "MALFORMED_PAT_TOKEN"
    And the token is not queried in database
    And no database lookup is performed for invalid formats

  Scenario: PAT with missing parts rejected
    Given the auth service receives token "pat_abc123"
    When the token format is validated
    Then the request is rejected with 401 Unauthorized
    And the error is "INCOMPLETE_PAT_TOKEN"
    And the error message is "PAT token must have format: pat_<identifier>_<random>"

  # Token Hash Verification Scenarios

  Scenario: BCrypt hash verification for valid token
    Given the bootstrap PAT "pat_abc123_xyz789" is stored with BCrypt hash
    When a request uses "pat_abc123_xyz789"
    Then the auth service extracts the full token
    And BCrypt.checkpw(token, storedHash) returns true
    And the PAT is validated successfully
    And the request is authorized

  Scenario: BCrypt hash verification rejects tampered token
    Given the bootstrap PAT "pat_abc123_xyz789" is stored with BCrypt hash
    When a request uses "pat_abc123_xyz790" (modified last character)
    Then BCrypt.checkpw(token, storedHash) returns false
    And the request is rejected with 401 Unauthorized
    And the error is "INVALID_PAT_TOKEN"
    And failed authentication is logged

  Scenario: Token lookup uses identifier for efficient query
    Given multiple PATs exist in the database
    When a request uses token "pat_abc123def456_randompart"
    Then the auth service extracts identifier "abc123def456"
    And queries PersonalAccessToken by tokenIdentifier
    And the database uses indexed lookup (not full table scan)
    And then verifies BCrypt hash of full token

  # Super Admin Creation Scenarios

  Scenario: Create first super admin with valid Google account
    Given the bootstrap PAT is valid
    And no super admin accounts exist
    When a request creates super admin with:
      | email     | admin@example.com   |
      | googleId  | google-oauth-id-123 |
    Then a new User is created with:
      | Field     | Value                |
      | email     | admin@example.com    |
      | googleId  | google-oauth-id-123  |
      | role      | SUPER_ADMIN          |
      | active    | true                 |
    And the super admin can log in with Google OAuth
    And the super admin can create admin users

  Scenario: Prevent duplicate super admin creation
    Given a super admin already exists with email "admin@example.com"
    When a request attempts to create another super admin with same email
    Then the request is rejected with error "SUPER_ADMIN_EXISTS"
    And the existing super admin is not modified
    And only one super admin per email is allowed

  Scenario: Multiple super admins can be created with different emails
    Given a super admin exists with email "admin1@example.com"
    And the bootstrap PAT is still valid
    When a request creates super admin with email "admin2@example.com"
    Then the second super admin is created successfully
    And both super admins can manage the system

  # Rate Limiting and Security Scenarios

  Scenario: Rate limit bootstrap PAT creation attempts
    Given the bootstrap setup script has been attempted 5 times
    When the script runs again within 1 minute
    Then the attempt is rate limited
    And the error is "BOOTSTRAP_RATE_LIMIT_EXCEEDED"
    And the administrator must wait before retrying
    And suspicious activity is logged

  Scenario: Rate limit authentication attempts with invalid PAT
    Given 10 failed authentication attempts with invalid PATs occur
    When the 11th attempt is made within 1 minute
    Then the request is temporarily blocked
    And the error is "TOO_MANY_FAILED_ATTEMPTS"
    And the IP address is logged for security review
    And normal operation resumes after cooldown period

  Scenario: Bootstrap PAT creation is idempotent after first creation
    Given the bootstrap PAT was successfully created
    When the bootstrap script is run multiple times
    Then subsequent runs detect existing PAT
    And no new PAT is created
    And the existing PAT metadata is displayed
    And the system state remains consistent

  # Emergency Revocation Scenarios

  Scenario: Emergency revoke bootstrap PAT
    Given the bootstrap PAT is suspected of being compromised
    When a super admin revokes the bootstrap PAT
    Then the revoked flag is set to true immediately
    And the revokedAt timestamp is set
    And all subsequent requests with the PAT fail
    And the revocation is logged as security event

  Scenario: Revoked bootstrap PAT cannot be used
    Given the bootstrap PAT was revoked 5 minutes ago
    When a request attempts to use the revoked PAT
    Then the auth service detects revoked status
    And the request fails with 401 Unauthorized
    And the error is "PAT_REVOKED"
    And the error message includes revocation timestamp

  Scenario: Cannot un-revoke a bootstrap PAT
    Given the bootstrap PAT has been revoked
    When a super admin attempts to un-revoke the PAT
    Then the request is rejected
    And the error is "REVOCATION_PERMANENT"
    And a new bootstrap PAT must be created through proper channels

  # Token Lifecycle Scenarios

  Scenario: Track PAT usage with lastUsedAt timestamp
    Given the bootstrap PAT was last used "2024-01-15T10:00:00Z"
    When the PAT is used for authentication at "2024-01-16T14:30:00Z"
    Then the lastUsedAt is updated to "2024-01-16T14:30:00Z"
    And the update is atomic
    And the usage history is available for audit

  Scenario: View bootstrap PAT remaining validity
    Given the bootstrap PAT was created on "2024-01-01"
    And the PAT expires on "2025-01-01"
    And the current date is "2024-07-01"
    When a super admin views bootstrap PAT details
    Then the system shows:
      | Field           | Value       |
      | expiresAt       | 2025-01-01  |
      | daysRemaining   | 184         |
      | status          | ACTIVE      |

  Scenario: Warning when bootstrap PAT nears expiration
    Given the bootstrap PAT expires in 30 days
    When a super admin logs in
    Then the system displays a warning:
      """
      ⚠️ Bootstrap PAT expires in 30 days.
      Please rotate to a new PAT to maintain system access.
      """
    And the warning is logged
    And email notification is sent to super admins

  # Multi-Environment Scenarios

  Scenario: Separate bootstrap PAT per environment
    Given the application runs in "production" environment
    When the bootstrap PAT is created
    Then the PAT name includes environment: "bootstrap-production"
    And the PAT is only valid for production environment
    And development/staging environments have separate PATs

  Scenario: Bootstrap PAT environment validation
    Given a bootstrap PAT was created for "staging" environment
    When the PAT is used in "production" environment
    Then the auth service detects environment mismatch
    And the request is rejected with "ENVIRONMENT_MISMATCH"
    And cross-environment PAT usage is prevented

  # Concurrent Access Scenarios

  Scenario: Handle concurrent bootstrap PAT creation attempts
    Given two bootstrap script instances start simultaneously
    When both attempt to create the bootstrap PAT
    Then only one PAT is created (optimistic locking)
    And the second attempt receives "BOOTSTRAP_PAT_ALREADY_EXISTS"
    And no duplicate PATs are created
    And database integrity is maintained

  Scenario: Handle concurrent authentication with same PAT
    Given multiple services use the bootstrap PAT simultaneously
    When 10 concurrent requests are authenticated
    Then all requests are authenticated independently
    And lastUsedAt is updated atomically
    And no race conditions occur
    And all requests complete successfully

  # Token Rotation Scenarios

  Scenario: Rotate to new PAT before bootstrap expires
    Given the bootstrap PAT expires in 60 days
    And a super admin account exists
    When the super admin creates a new service PAT:
      | name        | service-access-prod |
      | scope       | ADMIN               |
      | expiresIn   | 1 year              |
    Then the new PAT is created successfully
    And the super admin revokes the bootstrap PAT
    And all services migrate to the new PAT
    And the system continues operating with new PAT

  Scenario: Audit trail for PAT rotation
    Given the bootstrap PAT is being replaced
    When a super admin creates new PAT and revokes bootstrap
    Then audit log records:
      | Timestamp           | Action                    | Actor          |
      | 2024-06-01T10:00:00 | CREATE_PAT               | super-admin-id |
      | 2024-06-01T10:01:00 | REVOKE_BOOTSTRAP_PAT     | super-admin-id |
    And the rotation is fully auditable
    And compliance requirements are met

  # Error Handling Scenarios

  Scenario: Handle token generation failure gracefully
    Given the secure random generator fails
    When the bootstrap script attempts to create PAT
    Then the error is logged securely (no token data)
    And the script exits with error "TOKEN_GENERATION_FAILED"
    And no partial PAT data is stored
    And the administrator is advised to retry

  Scenario: Handle database write failure during PAT creation
    Given the token is generated successfully
    When the database write fails
    Then the plaintext token is NOT displayed
    And the error is "DATABASE_WRITE_FAILED"
    And no orphan PAT data exists
    And the operation is fully rolled back

  Scenario: Handle hash computation failure
    Given the token is generated successfully
    When BCrypt hashing fails (e.g., insufficient resources)
    Then the plaintext token is securely discarded
    And the error is "HASH_COMPUTATION_FAILED"
    And no unhashed token is stored
    And the administrator is notified

  # Security Headers Scenarios

  Scenario: Auth service returns security headers
    Given the bootstrap PAT is valid
    When the auth service validates the PAT
    Then the response includes security headers:
      | Header                | Value                |
      | X-Service-Id          | SYSTEM               |
      | X-PAT-Scope           | ADMIN                |
      | X-PAT-Id              | <pat-uuid>           |
      | X-Auth-Type           | PAT                  |
      | X-Token-Expires       | 2025-01-01T00:00:00Z |
    And Envoy forwards these headers to upstream services

  Scenario: Sensitive data not exposed in auth response
    Given the bootstrap PAT is validated
    When the auth service returns response to Envoy
    Then the response does NOT include:
      | Field          |
      | tokenHash      |
      | plaintextToken |
      | createdBy      |
    And only necessary metadata is exposed
    And security-sensitive fields are filtered

  # Scope Hierarchy Scenarios

  Scenario Outline: PAT scope hierarchy validation
    Given a PAT with scope <PAT Scope>
    When accessing an endpoint requiring <Required Scope>
    Then the access is <Result>

    Examples:
      | PAT Scope   | Required Scope | Result  |
      | ADMIN       | ADMIN          | ALLOWED |
      | ADMIN       | WRITE          | ALLOWED |
      | ADMIN       | READ_ONLY      | ALLOWED |
      | WRITE       | ADMIN          | DENIED  |
      | WRITE       | WRITE          | ALLOWED |
      | WRITE       | READ_ONLY      | ALLOWED |
      | READ_ONLY   | ADMIN          | DENIED  |
      | READ_ONLY   | WRITE          | DENIED  |
      | READ_ONLY   | READ_ONLY      | ALLOWED |

  # Bootstrap Recovery Scenarios

  Scenario: Recovery when bootstrap PAT is lost
    Given the bootstrap PAT plaintext was not saved
    And the super admin account was not yet created
    When the administrator needs to regain access
    Then the administrator must:
      | Step | Action                                           |
      | 1    | Delete bootstrap PAT from database directly      |
      | 2    | Run bootstrap script to create new PAT           |
      | 3    | Save the new plaintext PAT securely              |
      | 4    | Create super admin account with new PAT          |
    And the recovery is documented in runbooks
    And database access is required for recovery

  Scenario: Reset bootstrap state for clean installation
    Given a corrupted or test bootstrap state exists
    When an administrator with database access runs cleanup
    Then all bootstrap PATs are removed
    And all SYSTEM-created records are purged
    And the system returns to initial state
    And a new bootstrap can be performed
