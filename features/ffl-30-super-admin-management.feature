Feature: Super Admin Management
  As a Super Admin
  I want to manage admin accounts and Personal Access Tokens
  So that I can control system access and enable service-to-service authentication

  Background:
    Given the system has been bootstrapped with a super admin account
    And I am authenticated as a super admin

  # Admin Invitation Management

  Scenario: Super admin invites a new admin
    Given there is no admin with email "newadmin@example.com"
    When the super admin sends an invitation to "newadmin@example.com"
    Then an admin invitation is created
    And an invitation email is sent to "newadmin@example.com"
    And the invitation contains a unique invitation link
    And the invitation status is "PENDING"

  Scenario: Admin accepts invitation via Google OAuth
    Given a pending admin invitation exists for "admin@example.com"
    When the user clicks the invitation link
    And authenticates with Google OAuth using email "admin@example.com"
    Then a new admin account is created with role "ADMIN"
    And the account is linked to the Google ID from OAuth
    And the invitation status changes to "ACCEPTED"
    And the admin can now access admin endpoints

  Scenario: Super admin views all admins in the system
    Given the system has 5 admin accounts
    When the super admin requests the list of all admins
    Then the response contains 5 admin records
    And each record includes email, name, Google ID, and creation date

  Scenario: Super admin revokes admin access
    Given an admin account exists with email "revoked@example.com"
    And the admin owns 2 leagues
    When the super admin revokes admin access for "revoked@example.com"
    Then the user role changes from "ADMIN" to "PLAYER"
    And the user can no longer access admin endpoints
    And the leagues owned by the admin remain active
    And an audit log entry is created for the revocation

  Scenario: Prevent duplicate admin invitations
    Given a pending admin invitation exists for "admin@example.com"
    When the super admin sends another invitation to "admin@example.com"
    Then the request is rejected with error "INVITATION_ALREADY_EXISTS"

  Scenario: Admin invitation expires after 7 days
    Given an admin invitation was created 8 days ago for "expired@example.com"
    When the user attempts to accept the expired invitation
    Then the request is rejected with error "INVITATION_EXPIRED"
    And the user is prompted to request a new invitation

  # Personal Access Token (PAT) Management

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

    Examples:
      | scope      |
      | READ_ONLY  |
      | WRITE      |
      | ADMIN      |

  Scenario: Super admin views all active PATs
    Given the system has 3 active PATs
    And the system has 1 revoked PAT
    When the super admin requests the list of all PATs
    Then the response contains 4 PAT records
    And each record includes name, scope, created date, expiration date, last used date, and revoked status
    And the plaintext token is NOT included in the response

  Scenario: Super admin revokes a PAT
    Given an active PAT exists with name "Old API Token"
    When the super admin revokes the PAT "Old API Token"
    Then the PAT revoked status changes to true
    And the PAT revokedAt timestamp is set to the current time
    And subsequent requests using this PAT are rejected with 401 Unauthorized
    And an audit log entry is created for the PAT revocation

  Scenario: Super admin rotates a PAT
    Given an active PAT exists with name "Rotation Test"
    When the super admin rotates the PAT "Rotation Test"
    Then the old PAT is revoked
    And a new PAT is created with the same name and scope
    And the new PAT token is returned in plaintext
    And the new PAT has a fresh expiration date

  Scenario: PAT is never shown in plaintext after creation
    Given a PAT was created 1 hour ago
    When the super admin views the PAT details
    Then the PAT token is displayed as masked: "pat_****"
    And the full plaintext token is not retrievable

  Scenario: Track PAT last used timestamp
    Given an active PAT exists
    And the PAT lastUsedAt is null
    When a service makes an authenticated request using the PAT
    Then the PAT lastUsedAt timestamp is updated to the current time

  # Bootstrap PAT for Initial Setup

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

  Scenario: Use bootstrap PAT to create first super admin
    Given the bootstrap PAT exists
    And there are no super admin accounts
    When a request is made to create a super admin using the bootstrap PAT
    Then the first super admin account is created
    And the account has role "SUPER_ADMIN"
    And the account can access all super admin endpoints

  Scenario: Rotate bootstrap PAT after initial setup
    Given the bootstrap PAT exists
    And a super admin account exists
    When the super admin rotates the bootstrap PAT
    Then the old bootstrap PAT is revoked
    And a new PAT is created to replace it

  # Audit Logging

  Scenario: Audit log captures admin account creation
    When the super admin creates a new admin account
    Then an audit log entry is created with action "ADMIN_CREATED"
    And the audit log includes the super admin user ID
    And the audit log includes the new admin email
    And the audit log includes a timestamp

  Scenario: Audit log captures PAT activities
    When the super admin creates a PAT
    Then an audit log entry is created with action "PAT_CREATED"
    When the super admin revokes a PAT
    Then an audit log entry is created with action "PAT_REVOKED"
    When a service uses a PAT
    Then an audit log entry is created with action "PAT_USED"

  # Error Cases

  Scenario: Non-super-admin cannot invite admins
    Given I am authenticated as an admin (not super admin)
    When I attempt to send an admin invitation
    Then the request is rejected with 403 Forbidden
    And the error message is "Insufficient privileges"

  Scenario: Non-super-admin cannot create PATs
    Given I am authenticated as a player
    When I attempt to create a PAT
    Then the request is rejected with 403 Forbidden

  Scenario: Cannot create PAT with invalid expiration date
    When the super admin creates a PAT with expiration date in the past
    Then the request is rejected with error "INVALID_EXPIRATION_DATE"

  Scenario: Cannot revoke already-revoked PAT
    Given a PAT has already been revoked
    When the super admin attempts to revoke it again
    Then the request is rejected with error "PAT_ALREADY_REVOKED"
