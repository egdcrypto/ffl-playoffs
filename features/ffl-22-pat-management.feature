Feature: Personal Access Token (PAT) Management
  As a Super Admin
  I want to manage Personal Access Tokens for service-to-service authentication
  So that external services can securely access the API

  Background:
    Given the PAT system is enabled
    And all PATs are stored in the PersonalAccessToken table
    And PAT tokens are hashed with bcrypt before storage

  # Bootstrap PAT for Initial Setup

  Scenario: Setup script creates bootstrap PAT in database
    Given the system has no super admin users
    And the database is initialized
    When the setup script runs
    Then a bootstrap PAT is created in the database
    And the bootstrap PAT has the following properties:
      | name       | bootstrap                              |
      | scope      | ADMIN                                  |
      | expiresAt  | 1 year from now                        |
      | createdBy  | SYSTEM                                 |
      | revoked    | false                                  |
    And the plaintext PAT token is displayed in the console:
      """
      ⚠️  BOOTSTRAP PAT (save this - it will not be shown again):
      pat_abc123xyz...

      Use this token to create your first super admin account via API.
      Rotate this token after creating your super admin.
      """
    And the PAT token is hashed with bcrypt before storing in database
    And the plaintext token is never logged or stored

  Scenario: Bootstrap PAT token format
    When the setup script creates a bootstrap PAT
    Then the token starts with prefix "pat_"
    And the token is at least 64 characters long
    And the token contains cryptographically secure random characters

  Scenario: Bootstrap PAT is used to create first super admin
    Given the bootstrap PAT exists with token "pat_bootstrap123"
    And no super admin exists in the system
    When a request is sent to create a super admin:
      | Authorization | Bearer pat_bootstrap123 |
      | POST          | /api/v1/superadmin/users |
    Then the request is authenticated by Envoy using the bootstrap PAT
    And the super admin account is created
    And the response includes super admin details

  Scenario: Bootstrap PAT should be rotated after super admin creation
    Given the bootstrap PAT exists
    And a super admin has been created
    When the super admin logs in
    Then the super admin is warned:
      """
      ⚠️ The bootstrap PAT is still active. You should rotate it immediately for security.
      """
    And the super admin can rotate the bootstrap PAT

  Scenario: Multiple setup script runs do not create duplicate bootstrap PATs
    Given the setup script has already created a bootstrap PAT
    When the setup script runs again
    Then no new bootstrap PAT is created
    And the existing bootstrap PAT is returned
    And a message is displayed:
      """
      ℹ️  Bootstrap PAT already exists. Use the existing token or revoke and regenerate.
      """

  # Super Admin PAT Creation

  Scenario: Super admin creates a PAT with ADMIN scope
    Given I am authenticated as a super admin
    When I create a PAT with the following details:
      | name      | CI/CD Pipeline Token |
      | scope     | ADMIN                |
      | expiresAt | 2025-12-31T23:59:59Z |
    Then the PAT is created successfully
    And the plaintext token is returned in the response (one-time only):
      | token | pat_xyz789abc... |
    And a success message is displayed:
      """
      ✅ PAT created successfully. Save this token - it will not be shown again.
      """
    And the token is hashed with bcrypt and stored in the database
    And the plaintext token is never stored or logged

  Scenario: Super admin creates a PAT with WRITE scope
    Given I am authenticated as a super admin
    When I create a PAT with the following details:
      | name      | Data Sync Service Token |
      | scope     | WRITE                   |
      | expiresAt | 2026-06-30T23:59:59Z    |
    Then the PAT is created successfully
    And the PAT has WRITE scope
    And the PAT can access /api/v1/admin/* endpoints
    But the PAT cannot access /api/v1/superadmin/* endpoints

  Scenario: Super admin creates a PAT with READ_ONLY scope
    Given I am authenticated as a super admin
    When I create a PAT with the following details:
      | name      | Monitoring Service Token |
      | scope     | READ_ONLY                |
      | expiresAt | 2025-12-31T23:59:59Z     |
    Then the PAT is created successfully
    And the PAT has READ_ONLY scope
    And the PAT can access /api/v1/player/* endpoints for reading
    But the PAT cannot access /api/v1/admin/* endpoints
    And the PAT cannot access /api/v1/superadmin/* endpoints

  Scenario: PAT token generation is cryptographically secure
    Given I am authenticated as a super admin
    When I create 10 PATs
    Then all tokens start with prefix "pat_"
    And all tokens are unique
    And all tokens are at least 64 characters long
    And all tokens use cryptographically secure random generation

  Scenario: PAT name must be unique per super admin
    Given I am authenticated as a super admin
    And I have a PAT named "CI/CD Pipeline Token"
    When I attempt to create another PAT with name "CI/CD Pipeline Token"
    Then the request is rejected with error "PAT_NAME_ALREADY_EXISTS"
    And the error message is "A PAT with this name already exists"

  Scenario: PAT name is required
    Given I am authenticated as a super admin
    When I attempt to create a PAT without a name
    Then the request is rejected with error "PAT_NAME_REQUIRED"

  Scenario: PAT scope is required
    Given I am authenticated as a super admin
    When I attempt to create a PAT without a scope
    Then the request is rejected with error "PAT_SCOPE_REQUIRED"

  Scenario: PAT expiration date must be in the future
    Given I am authenticated as a super admin
    When I attempt to create a PAT with expiresAt = "2023-01-01T00:00:00Z" (in the past)
    Then the request is rejected with error "INVALID_EXPIRATION_DATE"
    And the error message is "Expiration date must be in the future"

  # Viewing PATs

  Scenario: Super admin views all active PATs
    Given I am authenticated as a super admin
    And the following PATs exist:
      | name                     | scope     | expiresAt            | revoked |
      | bootstrap                | ADMIN     | 2025-12-31T23:59:59Z | false   |
      | CI/CD Pipeline Token     | WRITE     | 2026-06-30T23:59:59Z | false   |
      | Monitoring Service Token | READ_ONLY | 2025-12-31T23:59:59Z | false   |
    When I request all PATs
    Then the response includes all 3 PATs
    And each PAT includes:
      | id                |
      | name              |
      | scope             |
      | expiresAt         |
      | createdBy         |
      | createdAt         |
      | lastUsedAt        |
      | revoked           |
      | revokedAt         |
    But the response does NOT include the token plaintext or tokenHash

  Scenario: Super admin views only active (non-revoked) PATs
    Given I am authenticated as a super admin
    And 3 active PATs exist
    And 2 revoked PATs exist
    When I request all PATs with filter "active"
    Then the response includes only the 3 active PATs
    And revoked PATs are not included

  Scenario: Super admin views PAT usage details
    Given I am authenticated as a super admin
    And a PAT named "CI/CD Pipeline Token" exists
    And the PAT was last used at "2024-10-01T14:30:00Z"
    When I request details for "CI/CD Pipeline Token"
    Then the response includes:
      | lastUsedAt | 2024-10-01T14:30:00Z |
    And the response shows how many times the PAT has been used

  Scenario: Super admin views expired PATs
    Given I am authenticated as a super admin
    And a PAT exists that expired yesterday
    When I request all PATs
    Then the expired PAT is marked as expired
    And the response includes:
      | status | EXPIRED |

  # Revoking PATs

  Scenario: Super admin revokes an active PAT
    Given I am authenticated as a super admin
    And a PAT named "CI/CD Pipeline Token" exists and is active
    When I revoke the PAT "CI/CD Pipeline Token"
    Then the PAT is marked as revoked
    And the PAT revokedAt timestamp is set to now
    And the PAT can no longer be used for authentication

  Scenario: Revoked PAT is immediately rejected by auth service
    Given a PAT named "CI/CD Pipeline Token" was revoked 1 minute ago
    When a service sends a request with the revoked PAT
    Then the auth service validates the PAT
    And finds that the PAT is revoked
    And the auth service returns 403 Forbidden
    And Envoy rejects the request with 401 Unauthorized

  Scenario: Super admin cannot revoke an already-revoked PAT
    Given I am authenticated as a super admin
    And a PAT named "Old Token" is already revoked
    When I attempt to revoke "Old Token" again
    Then the request is rejected with error "PAT_ALREADY_REVOKED"

  Scenario: Revoked PATs remain in the database for audit purposes
    Given I am authenticated as a super admin
    And I revoke a PAT named "CI/CD Pipeline Token"
    When I request all PATs (including revoked)
    Then the revoked PAT appears in the list
    And the PAT shows:
      | revoked   | true                 |
      | revokedAt | 2024-10-01T15:00:00Z |
    And the PAT record is not deleted

  # Rotating/Regenerating PATs

  Scenario: Super admin rotates a PAT (regenerates token)
    Given I am authenticated as a super admin
    And a PAT named "CI/CD Pipeline Token" exists with token "pat_old123"
    When I rotate the PAT "CI/CD Pipeline Token"
    Then a new token is generated
    And the new plaintext token is returned (one-time only):
      | token | pat_new456... |
    And the new token hash is stored in the database
    And the old token "pat_old123" is immediately invalidated
    And the PAT keeps the same:
      | name      |
      | scope     |
      | expiresAt |
      | createdBy |
      | createdAt |
    And the PAT lastUsedAt is reset to null

  Scenario: Old token is invalidated immediately after rotation
    Given a PAT named "CI/CD Pipeline Token" had token "pat_old123"
    And the PAT was rotated to new token "pat_new456"
    When a service sends a request with the old token "pat_old123"
    Then the auth service cannot find the old token in the database
    And the auth service returns 403 Forbidden

  Scenario: New token works immediately after rotation
    Given a PAT was rotated from "pat_old123" to "pat_new456"
    When a service sends a request with the new token "pat_new456"
    Then the auth service validates the new token
    And the request is authenticated successfully

  # Deleting PATs

  Scenario: Super admin deletes a PAT permanently
    Given I am authenticated as a super admin
    And a PAT named "Temporary Token" exists
    When I delete the PAT "Temporary Token"
    Then the PAT is permanently removed from the database
    And the PAT no longer appears in any PAT lists
    And an audit log entry is created recording the deletion

  Scenario: Deleted PAT cannot be used
    Given a PAT with token "pat_deleted123" was deleted
    When a service sends a request with token "pat_deleted123"
    Then the auth service cannot find the token
    And the auth service returns 403 Forbidden

  # PAT Security

  Scenario: PAT token is hashed before storage
    Given I am authenticated as a super admin
    When I create a PAT with token "pat_plaintext123"
    Then the token "pat_plaintext123" is hashed using bcrypt
    And the hash is stored in the tokenHash column
    And the plaintext token is never stored in the database

  Scenario: PAT plaintext is only displayed once upon creation
    Given I am authenticated as a super admin
    When I create a PAT named "New Token"
    Then the plaintext token is returned in the creation response
    When I request details for "New Token" later
    Then the plaintext token is not included in the response
    And only metadata is returned (id, name, scope, etc.)

  Scenario: PAT tokens are never logged
    Given I am authenticated as a super admin
    When I create a PAT with token "pat_secret789"
    Then application logs do not contain "pat_secret789"
    And audit logs do not contain the plaintext token
    And only the PAT ID and metadata are logged

  # PAT Expiration

  Scenario: Expired PAT is automatically rejected
    Given a PAT exists with expiresAt = "2024-09-30T23:59:59Z"
    And the current time is "2024-10-01T00:00:00Z"
    When a service sends a request with the expired PAT
    Then the auth service validates the expiration date
    And the auth service returns 403 Forbidden with reason "PAT_EXPIRED"

  Scenario: Super admin extends PAT expiration date
    Given I am authenticated as a super admin
    And a PAT named "CI/CD Pipeline Token" expires on "2025-12-31T23:59:59Z"
    When I update the expiration date to "2026-12-31T23:59:59Z"
    Then the PAT expiration is updated
    And the PAT continues to work until the new expiration date

  Scenario: Super admin cannot set expiration to a past date
    Given I am authenticated as a super admin
    And a PAT named "CI/CD Pipeline Token" exists
    When I attempt to set expiresAt to "2023-01-01T00:00:00Z"
    Then the request is rejected with error "INVALID_EXPIRATION_DATE"

  # Audit Logging

  Scenario: PAT creation is logged
    Given I am authenticated as a super admin
    When I create a PAT named "New Token" with scope "WRITE"
    Then an audit log entry is created:
      | action       | PAT_CREATED             |
      | actorId      | <super-admin-id>        |
      | patId        | <pat-id>                |
      | patName      | New Token               |
      | patScope     | WRITE                   |
      | timestamp    | <now>                   |

  Scenario: PAT usage is tracked
    Given a PAT exists with lastUsedAt = null
    When a service uses the PAT to make a request
    Then the auth service updates the PAT lastUsedAt timestamp
    And the timestamp reflects the most recent usage

  Scenario: PAT revocation is logged
    Given I am authenticated as a super admin
    When I revoke a PAT named "Old Token"
    Then an audit log entry is created:
      | action       | PAT_REVOKED      |
      | actorId      | <super-admin-id> |
      | patId        | <pat-id>         |
      | patName      | Old Token        |
      | timestamp    | <now>            |

  Scenario: PAT rotation is logged
    Given I am authenticated as a super admin
    When I rotate a PAT named "CI/CD Pipeline Token"
    Then an audit log entry is created:
      | action       | PAT_ROTATED             |
      | actorId      | <super-admin-id>        |
      | patId        | <pat-id>                |
      | patName      | CI/CD Pipeline Token    |
      | timestamp    | <now>                   |

  Scenario: PAT deletion is logged
    Given I am authenticated as a super admin
    When I delete a PAT named "Temporary Token"
    Then an audit log entry is created:
      | action       | PAT_DELETED      |
      | actorId      | <super-admin-id> |
      | patId        | <pat-id>         |
      | patName      | Temporary Token  |
      | timestamp    | <now>            |

  # Multi-Service PAT Usage

  Scenario: Multiple services use different PATs concurrently
    Given service A has PAT "pat_serviceA123" with scope WRITE
    And service B has PAT "pat_serviceB456" with scope READ_ONLY
    When both services make concurrent requests
    Then service A can write data
    And service B can only read data
    And each service is tracked independently

  Scenario: PAT scope determines accessible endpoints
    Given a PAT has scope READ_ONLY
    When the PAT attempts to POST to /api/v1/admin/leagues
    Then Envoy checks the PAT scope
    And Envoy rejects the request with 403 Forbidden
    And the error message is "Insufficient PAT scope for this endpoint"

  # Error Cases

  Scenario: Only super admins can manage PATs
    Given I am authenticated as an admin (not super admin)
    When I attempt to create a PAT
    Then the request is rejected with 403 Forbidden
    And the error message is "Only SUPER_ADMIN can manage PATs"

  Scenario: Players cannot manage PATs
    Given I am authenticated as a player
    When I attempt to view all PATs
    Then the request is rejected with 403 Forbidden

  Scenario: Unauthenticated users cannot manage PATs
    Given I am not authenticated
    When I attempt to create a PAT
    Then Envoy rejects the request with 401 Unauthorized

  Scenario: PAT name exceeds maximum length
    Given I am authenticated as a super admin
    When I attempt to create a PAT with a name of 256 characters
    Then the request is rejected with error "PAT_NAME_TOO_LONG"
    And the error message is "PAT name cannot exceed 255 characters"

  Scenario: Invalid PAT scope
    Given I am authenticated as a super admin
    When I attempt to create a PAT with scope "INVALID_SCOPE"
    Then the request is rejected with error "INVALID_PAT_SCOPE"
    And the error message is "Valid scopes are: READ_ONLY, WRITE, ADMIN"
