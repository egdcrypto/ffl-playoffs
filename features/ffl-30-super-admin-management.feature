Feature: Super Admin Management
  As a Super Admin
  I want to manage admin accounts and Personal Access Tokens
  So that I can control system access and enable service-to-service authentication

  Background:
    Given the system has been bootstrapped with a super admin account
    And I am authenticated as a super admin

  # =============================================================================
  # ADMIN INVITATION MANAGEMENT
  # =============================================================================

  # --- Basic Admin Invitation ---

  Scenario: Super admin invites a new admin
    Given there is no admin with email "newadmin@example.com"
    When the super admin sends an invitation to "newadmin@example.com"
    Then an admin invitation is created
    And an invitation email is sent to "newadmin@example.com"
    And the invitation contains a unique invitation link
    And the invitation status is "PENDING"
    And the invitation token is cryptographically secure (at least 32 bytes)
    And the invitation is associated with the inviting super admin

  Scenario: Admin accepts invitation via Google OAuth
    Given a pending admin invitation exists for "admin@example.com"
    When the user clicks the invitation link
    And authenticates with Google OAuth using email "admin@example.com"
    Then a new admin account is created with role "ADMIN"
    And the account is linked to the Google ID from OAuth
    And the invitation status changes to "ACCEPTED"
    And the admin can now access admin endpoints
    And the accepted timestamp is recorded

  Scenario: Existing player accepts admin invitation
    Given a user exists with email "player@example.com" and role "PLAYER"
    And a pending admin invitation exists for "player@example.com"
    When the player clicks the invitation link
    And authenticates with Google OAuth using email "player@example.com"
    Then the user's role is upgraded from "PLAYER" to "ADMIN"
    And the user retains all existing league memberships
    And the user retains all team selections and history
    And the invitation status changes to "ACCEPTED"

  Scenario: Super admin views all admins in the system
    Given the system has 5 admin accounts
    When the super admin requests the list of all admins
    Then the response contains 5 admin records
    And each record includes email, name, Google ID, and creation date
    And the list is sorted by creation date descending

  Scenario: Super admin views admin details
    Given an admin account exists with email "admin@example.com"
    When the super admin requests details for admin "admin@example.com"
    Then the response includes:
      | id            | <admin-id>          |
      | email         | admin@example.com   |
      | name          | Admin User          |
      | role          | ADMIN               |
      | createdAt     | <timestamp>         |
      | lastLoginAt   | <timestamp>         |
      | invitedBy     | <super-admin-email> |
      | leaguesOwned  | 3                   |
      | status        | ACTIVE              |

  # --- Admin Invitation Workflow ---

  Scenario: Invitation email contains required information
    When the super admin sends an invitation to "newadmin@example.com"
    Then the invitation email includes:
      | inviter name  | Super Admin              |
      | invitation link | https://ffl.../accept?token=... |
      | expiration notice | This link expires in 7 days |
      | instructions | Click to accept and sign in with Google |

  Scenario: Invitation link leads to OAuth flow
    Given a pending admin invitation exists for "admin@example.com"
    When the user clicks the invitation link
    Then the user is redirected to the invitation acceptance page
    And the page displays "You've been invited to become an admin"
    And the page shows a "Sign in with Google" button
    And the invitation token is validated before proceeding

  Scenario: Invitation token is validated on acceptance
    Given a pending admin invitation exists with token "abc123"
    When a request is made to accept with token "abc123"
    Then the system validates the token exists
    And the system validates the token is not expired
    And the system validates the token is not already used
    And the acceptance flow proceeds

  # --- Admin Revocation ---

  Scenario: Super admin revokes admin access
    Given an admin account exists with email "revoked@example.com"
    And the admin owns 2 leagues
    When the super admin revokes admin access for "revoked@example.com"
    Then the user role changes from "ADMIN" to "PLAYER"
    And the user can no longer access admin endpoints
    And the leagues owned by the admin remain active
    And an audit log entry is created for the revocation
    And the revocation reason is recorded

  Scenario: Revoked admin receives notification
    Given an admin account exists with email "revoked@example.com"
    When the super admin revokes admin access for "revoked@example.com"
    Then an email notification is sent to "revoked@example.com"
    And the email explains their admin access has been revoked
    And the email explains they retain player access

  Scenario: Revoked admin's leagues require new commissioner
    Given an admin "revoked@example.com" owns 2 active leagues
    And each league has ongoing seasons
    When the super admin revokes admin access
    Then the leagues are flagged as "NEEDS_COMMISSIONER"
    And existing players in those leagues can continue playing
    And the super admin receives a notification about orphaned leagues

  Scenario: Super admin can reassign league ownership
    Given an admin's access has been revoked
    And the admin owned a league "Fantasy Champions"
    When the super admin assigns the league to admin "newadmin@example.com"
    Then the league ownership is transferred
    And the new admin can manage the league
    And an audit log records the ownership transfer

  # --- Invitation Edge Cases ---

  Scenario: Prevent duplicate admin invitations
    Given a pending admin invitation exists for "admin@example.com"
    When the super admin sends another invitation to "admin@example.com"
    Then the request is rejected with error "INVITATION_ALREADY_EXISTS"
    And the existing invitation remains active

  Scenario: Resend expired invitation
    Given an admin invitation for "expired@example.com" expired 2 days ago
    When the super admin resends the invitation
    Then a new invitation is created
    And the old invitation is marked as "SUPERSEDED"
    And a fresh 7-day expiration is set
    And a new invitation email is sent

  Scenario: Admin invitation expires after 7 days
    Given an admin invitation was created 8 days ago for "expired@example.com"
    When the user attempts to accept the expired invitation
    Then the request is rejected with error "INVITATION_EXPIRED"
    And the user is shown a message to contact the super admin
    And the invitation status is marked as "EXPIRED"

  Scenario: Cancel pending admin invitation
    Given a pending admin invitation exists for "cancelled@example.com"
    When the super admin cancels the invitation
    Then the invitation status changes to "CANCELLED"
    And the invitation link becomes invalid
    And an audit log entry records the cancellation

  Scenario: Invitation email mismatch at OAuth
    Given a pending admin invitation exists for "invited@example.com"
    When the user authenticates with Google using email "different@example.com"
    Then the acceptance is rejected with error "EMAIL_MISMATCH"
    And the invitation remains in "PENDING" status
    And the user sees "Please sign in with the email address that received the invitation"

  Scenario: Cannot invite existing admin
    Given an admin account exists with email "existing@example.com"
    When the super admin sends an invitation to "existing@example.com"
    Then the request is rejected with error "USER_ALREADY_ADMIN"
    And no invitation is created

  Scenario: Cannot invite super admin
    Given a super admin exists with email "super@example.com"
    When the super admin sends an invitation to "super@example.com"
    Then the request is rejected with error "USER_IS_SUPER_ADMIN"
    And no invitation is created

  # --- Bulk Admin Operations ---

  Scenario: Super admin invites multiple admins at once
    When the super admin sends invitations to:
      | email                  |
      | admin1@example.com     |
      | admin2@example.com     |
      | admin3@example.com     |
    Then 3 admin invitations are created
    And 3 invitation emails are sent
    And the response includes status for each invitation

  Scenario: Bulk invitation with some failures
    Given an admin exists with email "existing@example.com"
    When the super admin sends invitations to:
      | email                  |
      | new@example.com        |
      | existing@example.com   |
    Then the response shows:
      | new@example.com      | SUCCESS              |
      | existing@example.com | USER_ALREADY_ADMIN   |
    And 1 invitation is created for "new@example.com"

  Scenario: Super admin searches admins
    Given multiple admin accounts exist
    When the super admin searches for admins with query "john"
    Then the results include admins with "john" in name or email
    And the results are sorted by relevance

  Scenario: Super admin filters admins by status
    Given 3 active admins and 2 revoked admins exist
    When the super admin filters by status "ACTIVE"
    Then only 3 active admin accounts are returned

  # =============================================================================
  # PERSONAL ACCESS TOKEN (PAT) MANAGEMENT
  # =============================================================================

  # --- PAT Creation ---

  Scenario: Super admin creates a PAT with ADMIN scope
    When the super admin creates a PAT with the following details:
      | name       | API Service Token |
      | scope      | ADMIN             |
      | expiresAt  | 2026-01-01        |
    Then a new PAT is created
    And the PAT token is returned in plaintext starting with "pat_"
    And the PAT token hash is stored in the database using bcrypt
    And the PAT has scope "ADMIN"
    And the PAT expiration date is "2026-01-01"
    And a warning message indicates "This token will only be shown once"

  Scenario Outline: Super admin creates PATs with different scopes
    When the super admin creates a PAT with scope "<scope>"
    Then the PAT is created successfully
    And the PAT scope is "<scope>"
    And the PAT can access endpoints matching its scope

    Examples:
      | scope      | accessible_endpoints                  |
      | READ_ONLY  | GET /api/v1/player/*                  |
      | WRITE      | GET,POST,PUT,DELETE /api/v1/admin/*   |
      | ADMIN      | GET,POST,PUT,DELETE /api/v1/**        |

  Scenario: PAT token format and security
    When the super admin creates a PAT
    Then the token starts with prefix "pat_"
    And the token is at least 64 characters long
    And the token contains cryptographically secure random bytes
    And the token passes entropy validation
    And the token is URL-safe (no special characters requiring encoding)

  Scenario: Super admin creates PAT with custom description
    When the super admin creates a PAT with:
      | name        | CI/CD Pipeline Token               |
      | scope       | WRITE                              |
      | description | Used by GitHub Actions for deploy  |
      | expiresAt   | 2026-06-30                         |
    Then the PAT includes the description in metadata
    And the description is searchable

  Scenario: Super admin creates short-lived PAT
    When the super admin creates a PAT with:
      | name       | Temporary Debug Token |
      | scope      | READ_ONLY             |
      | expiresAt  | tomorrow              |
    Then the PAT is created with 24-hour expiration
    And the PAT will auto-expire after the deadline

  # --- PAT Viewing ---

  Scenario: Super admin views all active PATs
    Given the system has 3 active PATs
    And the system has 1 revoked PAT
    When the super admin requests the list of all PATs
    Then the response contains 4 PAT records
    And each record includes name, scope, created date, expiration date, last used date, and revoked status
    And the plaintext token is NOT included in the response
    And the token hash is NOT included in the response

  Scenario: Super admin views PAT usage statistics
    Given a PAT "Service Token" has been used 150 times
    And the PAT was last used 2 hours ago
    When the super admin views PAT details for "Service Token"
    Then the response includes:
      | usageCount  | 150                  |
      | lastUsedAt  | <2-hours-ago>        |
      | lastUsedIp  | 10.0.1.50            |
      | lastUsedEndpoint | GET /api/v1/players |

  Scenario: Super admin views PAT with masked token
    Given a PAT was created with token "pat_abc123def456..."
    When the super admin views the PAT details
    Then the token is displayed as "pat_abc1...6789"
    And only the first 8 and last 4 characters are visible
    And the full plaintext token cannot be retrieved

  Scenario: Super admin filters PATs by scope
    Given PATs exist with scopes: ADMIN, WRITE, READ_ONLY
    When the super admin filters PATs by scope "WRITE"
    Then only WRITE-scoped PATs are returned

  Scenario: Super admin views expiring PATs
    Given PATs exist expiring in 3 days, 10 days, 30 days
    When the super admin requests PATs expiring soon
    Then PATs expiring within 7 days are highlighted
    And the response is sorted by expiration date ascending

  # --- PAT Revocation ---

  Scenario: Super admin revokes a PAT
    Given an active PAT exists with name "Old API Token"
    When the super admin revokes the PAT "Old API Token"
    Then the PAT revoked status changes to true
    And the PAT revokedAt timestamp is set to the current time
    And subsequent requests using this PAT are rejected with 401 Unauthorized
    And an audit log entry is created for the PAT revocation

  Scenario: Revoked PAT is immediately invalidated
    Given an active PAT "Service Token" is in use by a service
    When the super admin revokes "Service Token"
    Then the next request using this PAT fails
    And the failure occurs within 1 second
    And no caching delays the revocation effect

  Scenario: Super admin revokes PAT with reason
    Given an active PAT exists with name "Compromised Token"
    When the super admin revokes the PAT with reason "Security incident #123"
    Then the revocation reason is recorded
    And the reason appears in audit logs
    And the reason is visible in PAT history

  Scenario: Cannot revoke already-revoked PAT
    Given a PAT has already been revoked
    When the super admin attempts to revoke it again
    Then the request is rejected with error "PAT_ALREADY_REVOKED"
    And the original revocation timestamp is preserved

  Scenario: Revoke all PATs for emergency lockdown
    Given 5 active PATs exist
    When the super admin initiates emergency PAT revocation
    Then all 5 PATs are revoked
    And the revocation reason is "EMERGENCY_LOCKDOWN"
    And a security alert is logged
    And all active sessions using PATs are terminated

  # --- PAT Rotation ---

  Scenario: Super admin rotates a PAT
    Given an active PAT exists with name "Rotation Test"
    When the super admin rotates the PAT "Rotation Test"
    Then the old PAT token is revoked
    And a new PAT is created with the same name and scope
    And the new PAT token is returned in plaintext
    And the new PAT has a fresh expiration date
    And the old token is immediately invalidated

  Scenario: PAT rotation preserves metadata
    Given a PAT exists with:
      | name        | Service Token           |
      | scope       | WRITE                   |
      | description | Used by data pipeline   |
    When the super admin rotates the PAT
    Then the new PAT has the same name
    And the new PAT has the same scope
    And the new PAT has the same description
    And the createdAt reflects the rotation time

  Scenario: Grace period for PAT rotation
    Given an active PAT "Graceful Rotate" exists
    When the super admin rotates with grace period of 1 hour
    Then both old and new tokens work for 1 hour
    And after 1 hour only the new token works
    And the old token is marked as "ROTATING_OUT"

  Scenario: Cancel PAT rotation during grace period
    Given a PAT rotation is in progress with 30 minutes remaining
    When the super admin cancels the rotation
    Then the old token remains active
    And the new token is invalidated
    And the rotation is cancelled

  # --- Bootstrap PAT for Initial Setup ---

  Scenario: Bootstrap script creates initial PAT
    Given the database is empty
    When the bootstrap setup script runs
    Then a bootstrap PAT is created in the database
    And the bootstrap PAT has name "bootstrap"
    And the bootstrap PAT has scope "ADMIN"
    And the bootstrap PAT expiration is 1 year from creation
    And the bootstrap PAT creator is "SYSTEM"
    And the plaintext bootstrap PAT is output to the console
    And the PAT token hash is stored in the database

  Scenario: Bootstrap PAT console output format
    When the bootstrap script creates the initial PAT
    Then the console displays:
      """
      ============================================
      BOOTSTRAP PAT CREATED
      ============================================
      Token: pat_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

      IMPORTANT: Save this token securely!
      It will NOT be shown again.

      Use this token to create your first super admin.
      Rotate this token immediately after setup.
      ============================================
      """

  Scenario: Use bootstrap PAT to create first super admin
    Given the bootstrap PAT exists
    And there are no super admin accounts
    When a request is made to create a super admin using the bootstrap PAT
    Then the first super admin account is created
    And the account has role "SUPER_ADMIN"
    And the account can access all super admin endpoints
    And an audit log records the super admin creation

  Scenario: Rotate bootstrap PAT after initial setup
    Given the bootstrap PAT exists
    And a super admin account exists
    When the super admin rotates the bootstrap PAT
    Then the old bootstrap PAT is revoked
    And a new PAT is created to replace it
    And the system no longer displays bootstrap warnings

  Scenario: Bootstrap PAT warning on login
    Given the bootstrap PAT has not been rotated
    And a super admin logs in
    Then a security warning is displayed:
      """
      The bootstrap PAT is still active. Rotate it immediately for security.
      """
    And the warning persists until the PAT is rotated

  Scenario: Prevent duplicate bootstrap PAT creation
    Given the bootstrap PAT already exists
    When the setup script runs again
    Then no new bootstrap PAT is created
    And the script outputs "Bootstrap PAT already exists"
    And the existing PAT remains unchanged

  # --- PAT Security Features ---

  Scenario: PAT is never logged in plaintext
    When the super admin creates a PAT
    Then the plaintext token does not appear in:
      | application logs     |
      | audit logs           |
      | error logs           |
      | database query logs  |

  Scenario: PAT hash uses bcrypt with proper cost factor
    When the super admin creates a PAT
    Then the token is hashed with bcrypt
    And the bcrypt cost factor is at least 12
    And the hash verification takes ~100ms (timing attack resistant)

  Scenario: Rate limit PAT creation
    Given the super admin has created 9 PATs in the last hour
    When the super admin attempts to create a 10th PAT
    Then the request is rejected with error "RATE_LIMIT_EXCEEDED"
    And the error message is "Maximum 10 PATs per hour"

  Scenario: PAT cannot be created with scope higher than creator
    Given I am authenticated as an admin (not super admin)
    When I attempt to create a PAT with scope "ADMIN"
    Then the request is rejected with 403 Forbidden
    And the error message is "Cannot create PAT with higher scope than your role"

  Scenario: IP restriction for PAT
    When the super admin creates a PAT with IP whitelist:
      | allowed_ips |
      | 10.0.0.0/8  |
      | 192.168.1.0/24 |
    Then the PAT only works from whitelisted IP ranges
    And requests from other IPs are rejected with 403

  Scenario: PAT usage from suspicious IP triggers alert
    Given a PAT has been used from IP range 10.0.0.0/8
    When the PAT is used from a new IP range 203.0.113.0/24
    Then a security alert is logged
    And the super admin receives an email notification
    And the request is allowed but flagged

  # =============================================================================
  # SUPER ADMIN PRIVILEGE MANAGEMENT
  # =============================================================================

  Scenario: Super admin can manage all leagues
    Given 10 leagues exist across different admins
    When the super admin requests all leagues
    Then all 10 leagues are visible
    And the super admin can modify any league configuration
    And the super admin can access any league's data

  Scenario: Super admin can impersonate admin for debugging
    Given an admin "admin@example.com" owns a league
    When the super admin impersonates "admin@example.com"
    Then the super admin sees the admin's view
    And actions are logged as impersonation
    And the admin receives notification of impersonation
    And impersonation sessions auto-expire after 1 hour

  Scenario: Super admin cannot delete themselves
    Given I am the only super admin
    When I attempt to delete my super admin account
    Then the request is rejected with error "CANNOT_DELETE_ONLY_SUPER_ADMIN"
    And the system requires at least one super admin

  Scenario: Transfer super admin privileges
    Given I am a super admin
    And another admin "newsuper@example.com" exists
    When I transfer super admin privileges to "newsuper@example.com"
    Then "newsuper@example.com" becomes a super admin
    And I am demoted to admin
    And an audit log records the privilege transfer

  Scenario: Add additional super admin
    Given I am a super admin
    And an admin "promote@example.com" exists
    When I promote "promote@example.com" to super admin
    Then the system now has 2 super admins
    And both can perform super admin operations
    And an audit log records the promotion

  Scenario: Demote super admin to admin
    Given 2 super admins exist
    When super admin A demotes super admin B
    Then super admin B becomes a regular admin
    And super admin B can no longer access super admin endpoints
    And an audit log records the demotion

  # =============================================================================
  # AUDIT LOGGING
  # =============================================================================

  Scenario: Audit log captures admin account creation
    When the super admin creates a new admin account
    Then an audit log entry is created with action "ADMIN_CREATED"
    And the audit log includes the super admin user ID
    And the audit log includes the new admin email
    And the audit log includes a timestamp
    And the audit log includes the source IP address

  Scenario: Audit log captures PAT activities
    When the super admin creates a PAT
    Then an audit log entry is created with action "PAT_CREATED"
    When the super admin revokes a PAT
    Then an audit log entry is created with action "PAT_REVOKED"
    When a service uses a PAT
    Then an audit log entry is created with action "PAT_USED"

  Scenario: Audit log captures admin invitation lifecycle
    When the super admin sends an invitation
    Then an audit log entry "INVITATION_SENT" is created
    When the invitation is accepted
    Then an audit log entry "INVITATION_ACCEPTED" is created
    When an invitation expires
    Then an audit log entry "INVITATION_EXPIRED" is created

  Scenario: Super admin views audit logs
    Given multiple audit events exist
    When the super admin requests audit logs
    Then the logs are returned in reverse chronological order
    And each log entry includes:
      | action      |
      | actorId     |
      | actorEmail  |
      | targetId    |
      | targetType  |
      | timestamp   |
      | ipAddress   |
      | userAgent   |
      | details     |

  Scenario: Super admin filters audit logs by action type
    When the super admin filters audit logs by action "PAT_*"
    Then only PAT-related audit entries are returned

  Scenario: Super admin filters audit logs by date range
    When the super admin requests audit logs for the past 7 days
    Then only entries within that date range are returned

  Scenario: Super admin exports audit logs
    When the super admin exports audit logs for compliance
    Then a CSV file is generated
    And the file includes all requested entries
    And the file is signed for integrity verification

  Scenario: Audit logs cannot be modified or deleted
    Given audit log entries exist
    When an attempt is made to modify or delete audit logs
    Then the operation is rejected
    And an alert is generated for tampering attempt

  # =============================================================================
  # ERROR CASES AND AUTHORIZATION
  # =============================================================================

  Scenario: Non-super-admin cannot invite admins
    Given I am authenticated as an admin (not super admin)
    When I attempt to send an admin invitation
    Then the request is rejected with 403 Forbidden
    And the error message is "Insufficient privileges"

  Scenario: Non-super-admin cannot create PATs
    Given I am authenticated as a player
    When I attempt to create a PAT
    Then the request is rejected with 403 Forbidden
    And the error message is "Only SUPER_ADMIN can manage PATs"

  Scenario: Cannot create PAT with invalid expiration date
    When the super admin creates a PAT with expiration date in the past
    Then the request is rejected with error "INVALID_EXPIRATION_DATE"
    And the error message is "Expiration date must be in the future"

  Scenario: Cannot create PAT without required fields
    When the super admin attempts to create a PAT without a name
    Then the request is rejected with error "PAT_NAME_REQUIRED"
    When the super admin attempts to create a PAT without a scope
    Then the request is rejected with error "PAT_SCOPE_REQUIRED"
    When the super admin attempts to create a PAT without expiration
    Then the request is rejected with error "PAT_EXPIRATION_REQUIRED"

  Scenario: Cannot create PAT with invalid scope
    When the super admin creates a PAT with scope "SUPERUSER"
    Then the request is rejected with error "INVALID_PAT_SCOPE"
    And the error message includes valid scopes: READ_ONLY, WRITE, ADMIN

  Scenario: Cannot create PAT with name exceeding limit
    When the super admin creates a PAT with a 256-character name
    Then the request is rejected with error "PAT_NAME_TOO_LONG"
    And the error message is "Name cannot exceed 255 characters"

  Scenario: Cannot create duplicate PAT name
    Given a PAT named "Service Token" exists
    When the super admin creates another PAT named "Service Token"
    Then the request is rejected with error "PAT_NAME_ALREADY_EXISTS"

  # =============================================================================
  # NOTIFICATION AND EMAIL SCENARIOS
  # =============================================================================

  Scenario: Admin invitation email is sent
    When the super admin invites "newadmin@example.com"
    Then an email is sent within 5 seconds
    And the email subject is "You're invited to become an FFL Playoffs Admin"
    And the email is from "noreply@fflplayoffs.com"

  Scenario: Admin receives welcome email on acceptance
    When an admin accepts their invitation
    Then a welcome email is sent
    And the email includes quick start guides
    And the email includes support contact information

  Scenario: Super admin notified of admin acceptance
    When an admin accepts their invitation
    Then the inviting super admin receives a notification
    And the notification includes the new admin's email

  Scenario: PAT expiration warning emails
    Given a PAT expires in 7 days
    Then the PAT creator receives an email warning
    And the email is sent 7 days before expiration
    And a second reminder is sent 1 day before expiration

  Scenario: Security alert for PAT usage anomaly
    Given a PAT is typically used 100 times per day
    When the PAT is used 1000 times in an hour
    Then a security alert email is sent to the super admin
    And the alert includes usage graphs
    And the alert includes a link to revoke the PAT

  # =============================================================================
  # API ENDPOINTS
  # =============================================================================

  Scenario: List admin invitations endpoint
    When a GET request is sent to "/api/v1/superadmin/invitations"
    Then the response status is 200
    And the response contains paginated invitation records

  Scenario: Create admin invitation endpoint
    When a POST request is sent to "/api/v1/superadmin/invitations" with:
      | email | newadmin@example.com |
    Then the response status is 201
    And the response contains the invitation ID

  Scenario: Cancel invitation endpoint
    When a DELETE request is sent to "/api/v1/superadmin/invitations/{id}"
    Then the response status is 204
    And the invitation is cancelled

  Scenario: List admins endpoint
    When a GET request is sent to "/api/v1/superadmin/admins"
    Then the response status is 200
    And the response contains paginated admin records

  Scenario: Revoke admin endpoint
    When a POST request is sent to "/api/v1/superadmin/admins/{id}/revoke"
    Then the response status is 200
    And the admin is demoted to player

  Scenario: Create PAT endpoint
    When a POST request is sent to "/api/v1/superadmin/pats" with:
      | name      | Service Token |
      | scope     | WRITE         |
      | expiresAt | 2026-01-01    |
    Then the response status is 201
    And the response contains the plaintext token (once only)

  Scenario: List PATs endpoint
    When a GET request is sent to "/api/v1/superadmin/pats"
    Then the response status is 200
    And the response contains paginated PAT records
    And no plaintext tokens are included

  Scenario: Revoke PAT endpoint
    When a POST request is sent to "/api/v1/superadmin/pats/{id}/revoke"
    Then the response status is 200
    And the PAT is revoked

  Scenario: Rotate PAT endpoint
    When a POST request is sent to "/api/v1/superadmin/pats/{id}/rotate"
    Then the response status is 200
    And the response contains the new plaintext token

  Scenario: Get audit logs endpoint
    When a GET request is sent to "/api/v1/superadmin/audit-logs"
    Then the response status is 200
    And the response contains paginated audit entries

  # =============================================================================
  # SYSTEM HEALTH AND MONITORING
  # =============================================================================

  Scenario: Super admin views system health dashboard
    When the super admin accesses the system health endpoint
    Then the response includes:
      | total_admins        | 15        |
      | active_admins       | 14        |
      | pending_invitations | 3         |
      | active_pats         | 8         |
      | expiring_pats       | 2         |
      | recent_logins       | 45        |

  Scenario: Super admin views PAT usage metrics
    When the super admin requests PAT usage metrics
    Then the response includes:
      | total_requests_today    | 15000     |
      | requests_by_scope       | {...}     |
      | top_used_pats           | [...]     |
      | failed_auth_attempts    | 23        |

  Scenario: Super admin receives daily digest
    Given daily digest is enabled
    Then the super admin receives a daily email at 9 AM
    And the digest includes:
      | new_admins_today      |
      | invitations_pending   |
      | pats_expiring_soon    |
      | security_alerts       |
      | system_health_summary |

  # =============================================================================
  # EDGE CASES AND SPECIAL SCENARIOS
  # =============================================================================

  Scenario: Handle concurrent admin invitation acceptance
    Given a pending invitation for "admin@example.com"
    When two browsers attempt to accept simultaneously
    Then only one acceptance succeeds
    And the second attempt receives "INVITATION_ALREADY_ACCEPTED"
    And no duplicate admin accounts are created

  Scenario: Handle database connection loss during PAT creation
    When a database failure occurs during PAT creation
    Then the transaction is rolled back
    And no partial PAT record exists
    And no plaintext token was exposed
    And the super admin is notified of the failure

  Scenario: Recover from failed email delivery
    When an invitation email fails to send
    Then the invitation remains in "PENDING" status
    And the email is queued for retry
    And the super admin is notified of delivery failure
    And the super admin can manually resend

  Scenario: Handle very long admin lists with pagination
    Given 1000 admin accounts exist
    When the super admin requests admin list with page size 50
    Then the response includes 50 records
    And pagination metadata is included
    And subsequent pages can be requested

  Scenario: Super admin account lockout after failed attempts
    Given 5 failed login attempts for the super admin
    Then the account is temporarily locked
    And an alert email is sent to backup contact
    And the lockout expires after 30 minutes
    And a manual unlock is available

  Scenario: Expired session handling
    Given the super admin's session expires during an operation
    Then the operation is rejected with 401 Unauthorized
    And partial changes are rolled back
    And the super admin must re-authenticate

  # =============================================================================
  # MOBILE AND ACCESSIBILITY
  # =============================================================================

  Scenario: Admin invitation email is mobile-friendly
    When an invitation email is viewed on mobile
    Then the email renders correctly
    And the accept button is easily tappable
    And the text is readable without zooming

  Scenario: Super admin dashboard is accessible
    When a screen reader accesses the super admin dashboard
    Then all elements have proper ARIA labels
    And keyboard navigation works correctly
    And color contrast meets WCAG AA standards

  Scenario: PAT management works on tablet
    When the super admin manages PATs on a tablet
    Then all actions are accessible via touch
    And modals display correctly
    And form inputs are appropriately sized
