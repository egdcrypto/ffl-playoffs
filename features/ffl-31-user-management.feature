Feature: User Management and Role Hierarchy
  As a system administrator
  I want to manage users with different role levels
  So that the system maintains proper access control and security

  Background:
    Given the system has three role levels: SUPER_ADMIN, ADMIN, and PLAYER
    And SUPER_ADMIN cannot be created through invitation
    And SUPER_ADMIN is bootstrapped via configuration

  Scenario: Super admin has full system access
    Given a user with SUPER_ADMIN role exists
    When the super admin accesses system-wide endpoints
    Then the super admin can view all leagues across the system
    And the super admin can manage admin accounts
    And the super admin can generate Personal Access Tokens
    And the super admin can audit all system activities

  Scenario: Admin has league-scoped access
    Given a user with ADMIN role exists
    And the admin owns 2 leagues
    When the admin attempts to access system resources
    Then the admin can create and manage their own leagues
    And the admin can configure their league settings
    And the admin can invite players to their leagues
    And the admin cannot access other admins' leagues
    And the admin cannot view system-wide data

  Scenario: Player has participant-level permissions
    Given a user with PLAYER role exists
    And the player is a member of a league
    When the player attempts to access system resources
    Then the player can build their roster with NFL player selections
    And the player can view standings and scores for their league
    And the player cannot create leagues
    And the player cannot invite other users
    And the player cannot access admin functions

  Scenario: User belongs to multiple leagues
    Given a PLAYER user exists
    And the player is invited to "League A" by Admin A
    And the player is invited to "League B" by Admin B
    When the player accepts both invitations
    Then the player is a member of both leagues
    And the player can build separate rosters for each league
    And the player can view standings for both leagues independently

  Scenario: Role hierarchy enforcement
    Given users exist with roles: SUPER_ADMIN, ADMIN, and PLAYER
    When each user attempts to access role-restricted endpoints
    Then SUPER_ADMIN can access all endpoints
    And ADMIN can only access admin and player endpoints
    And PLAYER can only access player endpoints
    And unauthorized access attempts return 403 Forbidden
