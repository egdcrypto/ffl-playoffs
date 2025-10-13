Feature: Admin Invitation by Super Admin
  As a super admin
  I want to invite users to become admins
  So that I can delegate league management responsibilities

  Background:
    Given a SUPER_ADMIN user exists in the system

  Scenario: Super admin invites a new admin
    Given the super admin is authenticated
    When the super admin sends an admin invitation to "newadmin@example.com"
    Then an AdminInvitation record is created with status "PENDING"
    And an invitation email is sent to "newadmin@example.com"
    And the email contains a unique invitation link
    And the invitation link expires in 7 days

  Scenario: User accepts admin invitation and creates account
    Given an admin invitation exists for "newadmin@example.com"
    And the invitation status is "PENDING"
    When the user clicks the invitation link
    And the user authenticates with Google OAuth
    And the user's Google email matches "newadmin@example.com"
    Then a new User account is created with role ADMIN
    And the User record contains googleId from Google OAuth
    And the User record contains email and name from Google profile
    And the AdminInvitation status changes to "ACCEPTED"
    And the user can now create and manage leagues

  Scenario: Existing user accepts admin invitation
    Given a user with email "existinguser@example.com" already exists with role PLAYER
    And an admin invitation exists for "existinguser@example.com"
    When the user clicks the invitation link
    And authenticates with their existing Google account
    Then the user's role is upgraded from PLAYER to ADMIN
    And the AdminInvitation status changes to "ACCEPTED"
    And the user retains their existing player league memberships
    And the user can now create and manage leagues

  Scenario: Admin invitation with mismatched email
    Given an admin invitation exists for "invited@example.com"
    When a user authenticates with Google using email "different@example.com"
    Then the invitation is rejected with error "EMAIL_MISMATCH"
    And no user account is created
    And the AdminInvitation status remains "PENDING"

  Scenario: Expired admin invitation
    Given an admin invitation exists for "expired@example.com"
    And the invitation was created 8 days ago
    When the user clicks the invitation link
    Then the invitation is rejected with error "INVITATION_EXPIRED"
    And no user account is created
    And the user is prompted to request a new invitation

  Scenario: Super admin views all admins
    Given 5 ADMIN users exist in the system
    When the super admin requests the list of all admins
    Then the system returns all 5 admin users
    And each admin record includes: id, email, name, googleId, createdAt

  Scenario: Super admin revokes admin access
    Given an ADMIN user "admin@example.com" exists
    And the admin owns 2 leagues
    When the super admin revokes admin privileges for "admin@example.com"
    Then the user's role is changed to PLAYER
    And the user's owned leagues are marked as "ADMIN_REVOKED"
    And the user can no longer create new leagues
    And the user retains player access to leagues they are a member of

  Scenario: Super admin cannot be created through invitation
    Given the super admin attempts to create a SUPER_ADMIN invitation
    Then the system rejects the request with error "INVALID_ROLE"
    And the invitation is not created
    And SUPER_ADMIN can only be bootstrapped via configuration

  Scenario: Admin cannot invite other admins
    Given a user with ADMIN role exists
    When the admin attempts to send an admin invitation
    Then the request is blocked with 403 Forbidden
    And no AdminInvitation is created
    And only SUPER_ADMIN can invite admins

  Scenario: Super admin audits admin activities
    Given 3 ADMIN users exist
    And the admins have created leagues and invited players
    When the super admin requests audit logs for admin activities
    Then the system returns all admin actions with timestamps
    And the audit log includes: league creation, player invitations, configuration changes
    And the audit log includes the admin's id and email for each action
