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

  # PAT Description and Metadata

  Scenario: Super admin creates PAT with description
    Given I am authenticated as a super admin
    When I create a PAT with the following details:
      | name        | Data Sync Service        |
      | scope       | WRITE                    |
      | description | Used by nfl-data-sync    |
      | expiresAt   | 2026-12-31T23:59:59Z     |
    Then the PAT is created with the description
    And the description is returned when viewing PAT details

  Scenario: Super admin updates PAT description
    Given I am authenticated as a super admin
    And a PAT named "Data Sync Service" exists with description "Original description"
    When I update the PAT description to "Updated for 2025 season"
    Then the PAT description is updated
    And the PAT token and other properties remain unchanged

  Scenario: Super admin adds labels to PAT
    Given I am authenticated as a super admin
    And a PAT named "CI/CD Pipeline Token" exists
    When I add labels to the PAT:
      | environment | production |
      | team        | devops     |
      | service     | jenkins    |
    Then the PAT has the labels attached
    And the labels are returned when viewing PAT details

  # Bulk Operations

  Scenario: Super admin revokes multiple PATs at once
    Given I am authenticated as a super admin
    And the following PATs exist:
      | name              | status |
      | Old Service 1     | active |
      | Old Service 2     | active |
      | Old Service 3     | active |
    When I bulk revoke PATs: ["Old Service 1", "Old Service 2", "Old Service 3"]
    Then all 3 PATs are revoked
    And an audit log entry is created for each revocation
    And none of the revoked PATs can be used

  Scenario: Super admin bulk deletes expired PATs
    Given I am authenticated as a super admin
    And 5 PATs expired more than 30 days ago
    When I request to clean up expired PATs older than 30 days
    Then all 5 expired PATs are deleted
    And an audit log records the bulk deletion
    And the response shows how many PATs were deleted

  # PAT Search and Filtering

  Scenario: Super admin searches PATs by name
    Given I am authenticated as a super admin
    And PATs exist with names:
      | CI/CD Pipeline Token    |
      | Data Sync Service       |
      | Monitoring Service      |
      | CI/CD Deploy Token      |
    When I search for PATs with name containing "CI/CD"
    Then the response includes:
      | CI/CD Pipeline Token |
      | CI/CD Deploy Token   |
    And other PATs are not included

  Scenario: Super admin filters PATs by scope
    Given I am authenticated as a super admin
    And PATs exist with scopes:
      | name       | scope     |
      | Admin PAT  | ADMIN     |
      | Write PAT  | WRITE     |
      | Read PAT   | READ_ONLY |
    When I filter PATs by scope "ADMIN"
    Then only "Admin PAT" is returned

  Scenario: Super admin filters PATs by expiration status
    Given I am authenticated as a super admin
    And the following PATs exist:
      | name          | expiresAt            |
      | Expired PAT   | 2024-01-01T00:00:00Z |
      | Expiring Soon | 2024-12-15T00:00:00Z |
      | Valid PAT     | 2026-12-31T00:00:00Z |
    And current date is "2024-12-01"
    When I filter PATs by "expiring_within_30_days"
    Then only "Expiring Soon" is returned

  Scenario: Super admin filters PATs by last used date
    Given I am authenticated as a super admin
    And the following PATs exist:
      | name          | lastUsedAt           |
      | Active PAT    | 2024-11-30T10:00:00Z |
      | Stale PAT     | 2024-01-01T10:00:00Z |
      | Never Used    | null                 |
    And current date is "2024-12-01"
    When I filter PATs by "not_used_in_90_days"
    Then the response includes:
      | Stale PAT  |
      | Never Used |

  # Rate Limiting

  Scenario: Rate limit PAT creation requests
    Given I am authenticated as a super admin
    And I have created 10 PATs in the last minute
    When I attempt to create another PAT
    Then the request is rate limited
    And the error is "PAT_CREATION_RATE_LIMIT_EXCEEDED"
    And the error message includes retry time

  Scenario: Rate limit PAT validation requests
    Given a PAT exists
    And 1000 validation requests occur in 1 minute
    When the 1001st validation request is made
    Then the request is temporarily blocked
    And the error is "VALIDATION_RATE_LIMIT_EXCEEDED"
    And the block is per-token, not global

  # Concurrent Operations

  Scenario: Handle concurrent PAT rotation requests
    Given a PAT named "Shared Token" exists
    When two rotation requests are received simultaneously
    Then only one rotation succeeds
    And the other receives error "PAT_ROTATION_IN_PROGRESS"
    And the final token is consistent
    And no duplicate tokens are created

  Scenario: Handle concurrent PAT usage tracking
    Given a PAT is used by 100 concurrent requests
    When all requests are processed
    Then lastUsedAt reflects the most recent request
    And all requests are authenticated
    And no race conditions affect token validity

  # PAT Usage Statistics

  Scenario: View PAT usage statistics
    Given I am authenticated as a super admin
    And a PAT named "CI/CD Pipeline Token" has been used 500 times
    When I request statistics for "CI/CD Pipeline Token"
    Then the response includes:
      | totalUsageCount     | 500                  |
      | lastUsedAt          | 2024-12-01T10:00:00Z |
      | firstUsedAt         | 2024-01-01T08:00:00Z |
      | averageUsagePerDay  | 1.5                  |
      | peakUsageHour       | 14:00                |

  Scenario: View aggregate PAT statistics
    Given I am authenticated as a super admin
    When I request aggregate PAT statistics
    Then the response includes:
      | totalPATs           | 15   |
      | activePATs          | 12   |
      | revokedPATs         | 2    |
      | expiredPATs         | 1    |
      | totalValidations    | 5000 |
      | validationsLast24h  | 150  |

  # Expiration Notifications

  Scenario: System sends notification when PAT is about to expire
    Given a PAT named "Important Service" expires in 14 days
    And notification is configured for 14-day warning
    When the system runs expiration check
    Then an email notification is sent to the super admin:
      """
      ⚠️ PAT Expiration Warning

      The following PAT is expiring soon:
      - Name: Important Service
      - Expires: 2024-12-15T23:59:59Z
      - Days remaining: 14

      Please rotate this PAT before expiration.
      """
    And the notification is logged in audit trail

  Scenario: Super admin configures expiration notification settings
    Given I am authenticated as a super admin
    When I configure expiration notifications:
      | warningDays | 30, 14, 7, 1 |
      | recipients  | admin@example.com, ops@example.com |
    Then notifications are sent at each warning interval
    And multiple recipients receive the notification

  # PAT Clone/Copy

  Scenario: Super admin clones PAT with same configuration
    Given I am authenticated as a super admin
    And a PAT named "Production Service" exists with:
      | scope       | WRITE                  |
      | description | Production data sync   |
      | expiresAt   | 2026-12-31T23:59:59Z   |
    When I clone the PAT with new name "Staging Service"
    Then a new PAT is created with:
      | name        | Staging Service        |
      | scope       | WRITE                  |
      | description | Production data sync   |
    And a new token is generated
    And the original PAT is unchanged

  # Maximum PATs Limit

  Scenario: Enforce maximum PATs per super admin
    Given I am authenticated as a super admin
    And I have 50 active PATs (the maximum allowed)
    When I attempt to create another PAT
    Then the request is rejected with error "MAX_PATS_EXCEEDED"
    And the error message is "Maximum of 50 active PATs allowed. Revoke or delete unused PATs."

  Scenario: Maximum PATs limit excludes revoked PATs
    Given I am authenticated as a super admin
    And I have 49 active PATs and 10 revoked PATs
    When I create a new PAT
    Then the PAT is created successfully
    And revoked PATs do not count toward the limit

  # Emergency Security

  Scenario: Emergency revoke all PATs except bootstrap
    Given I am authenticated as a super admin
    And a security incident is detected
    When I trigger emergency PAT revocation
    Then all PATs except bootstrap are revoked
    And an emergency audit log entry is created:
      | action    | EMERGENCY_REVOKE_ALL |
      | reason    | Security incident    |
      | revokedBy | <super-admin-id>     |
    And all services using revoked PATs lose access immediately

  Scenario: Super admin can lock PAT system temporarily
    Given I am authenticated as a super admin
    And a security investigation is in progress
    When I lock the PAT system
    Then all PAT validations fail with "PAT_SYSTEM_LOCKED"
    And new PAT creation is disabled
    And PAT rotations are disabled
    And super admin can unlock the system when investigation completes

  # PAT with IP Restrictions

  Scenario: Create PAT with IP whitelist
    Given I am authenticated as a super admin
    When I create a PAT with IP restrictions:
      | name          | Restricted Service                |
      | scope         | WRITE                             |
      | allowedIPs    | 10.0.0.0/8, 192.168.1.0/24       |
    Then the PAT is created with IP restrictions
    And requests from allowed IPs are authenticated
    And requests from other IPs are rejected with "IP_NOT_ALLOWED"

  Scenario: Update PAT IP whitelist
    Given I am authenticated as a super admin
    And a PAT named "Restricted Service" has IP whitelist ["10.0.0.0/8"]
    When I update the IP whitelist to ["10.0.0.0/8", "172.16.0.0/12"]
    Then the PAT IP restrictions are updated
    And the new IP range is allowed immediately

  # PAT Scope Upgrade/Downgrade

  Scenario: Super admin upgrades PAT scope
    Given I am authenticated as a super admin
    And a PAT named "Service Token" has scope READ_ONLY
    When I upgrade the PAT scope to WRITE
    Then the PAT scope is updated to WRITE
    And the token itself is not changed
    And the PAT can now access write endpoints

  Scenario: Super admin downgrades PAT scope
    Given I am authenticated as a super admin
    And a PAT named "Service Token" has scope ADMIN
    When I downgrade the PAT scope to READ_ONLY
    Then the PAT scope is updated to READ_ONLY
    And the PAT can no longer access write or admin endpoints
    And an audit log records the scope change

  Scenario: Cannot upgrade scope beyond super admin's own scope
    Given I am authenticated as a super admin with limited permissions
    When I attempt to create a PAT with scope ADMIN
    Then the request is rejected if my permissions don't allow ADMIN scope creation

  # PAT Token Format Validation

  Scenario Outline: Validate PAT token format
    Given the auth service receives token "<Token>"
    When the token format is validated
    Then the result is "<Result>"
    And the error is "<Error>"

    Examples:
      | Token                                           | Result   | Error                     |
      | pat_abc123_xyz789abcdef...                     | VALID    | none                      |
      | pat_abc123                                      | INVALID  | INCOMPLETE_PAT_TOKEN      |
      | abc123_xyz789                                   | INVALID  | MISSING_PAT_PREFIX        |
      | pat_                                            | INVALID  | MISSING_TOKEN_IDENTIFIER  |
      | PAT_abc123_xyz789                               | INVALID  | INVALID_PREFIX_CASE       |
      | pat_abc123_xyz789_extra                         | VALID    | none (extra parts OK)     |

  # PAT Recovery

  Scenario: Super admin generates recovery PAT when locked out
    Given no super admin can access the system
    And the bootstrap PAT is expired or revoked
    When an administrator with database access runs recovery script
    Then a new recovery PAT is generated
    And the PAT is displayed in console (one-time only)
    And the recovery is logged in database audit table
    And the super admin can regain access

  Scenario: Recovery PAT has limited validity
    Given a recovery PAT was generated
    Then the PAT expires in 1 hour
    And the PAT can only be used to create/update super admin
    And the PAT is automatically revoked after first super admin action

  # Reporting

  Scenario: Generate PAT audit report
    Given I am authenticated as a super admin
    When I request a PAT audit report for the last 30 days
    Then the report includes:
      | Section            | Contents                              |
      | Created PATs       | List with names, scopes, creators     |
      | Revoked PATs       | List with revocation dates, reasons   |
      | Rotated PATs       | List with rotation dates              |
      | Most Used PATs     | Top 10 by usage count                 |
      | Unused PATs        | PATs not used in reporting period     |
      | Expiring Soon      | PATs expiring in next 30 days         |
    And the report can be exported as CSV or JSON

  Scenario: Schedule automated PAT reports
    Given I am authenticated as a super admin
    When I configure weekly PAT reports:
      | schedule   | Every Monday at 09:00    |
      | recipients | security@example.com     |
      | format     | PDF                      |
    Then reports are automatically generated and sent
    And report history is maintained for compliance
