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
