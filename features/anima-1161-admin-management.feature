@admin @management @security @permissions
Feature: Admin Management
  As a Super Admin
  I want to manage administrator accounts and permissions
  So that I can control access to the platform and maintain security

  Background:
    Given the admin management system is configured
    And I am authenticated as a Super Admin
    And the following admin roles are defined:
      | role          | level | description                    |
      | SUPER_ADMIN   | 100   | Full platform access           |
      | ADMIN         | 80    | Standard admin permissions     |
      | CONTENT_ADMIN | 60    | Content management only        |
      | BILLING_ADMIN | 60    | Billing and subscription mgmt  |
      | SUPPORT_ADMIN | 40    | Customer support access        |
      | READ_ONLY     | 20    | View-only access               |

  # ============================================
  # ADMIN CREATION
  # ============================================

  @api @admin @create
  Scenario: Create new admin account with role assignment
    Given I have permission to create admin accounts
    When I send a POST request to "/api/v1/admin/admins" with:
      """json
      {
        "email": "newadmin@example.com",
        "firstName": "Alice",
        "lastName": "Johnson",
        "role": "CONTENT_ADMIN",
        "phone": "+1-555-1234",
        "sendInvitation": true
      }
      """
    Then the response status should be 201
    And the response should contain the created admin:
      | field        | value                  |
      | email        | newadmin@example.com   |
      | firstName    | Alice                  |
      | lastName     | Johnson                |
      | role         | CONTENT_ADMIN          |
      | status       | PENDING_ACTIVATION     |
    And an invitation email should be sent to "newadmin@example.com"
    And the invitation should contain a secure activation link
    And the invitation should expire after 72 hours
    And an audit log entry should be created for admin creation

  @api @admin @create
  Scenario: Create admin with immediate activation
    Given I have permission to create admin accounts
    When I send a POST request to "/api/v1/admin/admins" with:
      """json
      {
        "email": "directadmin@example.com",
        "firstName": "Bob",
        "lastName": "Williams",
        "role": "SUPPORT_ADMIN",
        "temporaryPassword": "TempP@ss123!",
        "sendInvitation": false,
        "requirePasswordChange": true
      }
      """
    Then the response status should be 201
    And the admin should be created with status "ACTIVE"
    And the admin should be required to change password on first login
    And no invitation email should be sent

  @api @admin @create @validation
  Scenario: Validate admin creation input
    Given I have permission to create admin accounts
    When I send a POST request to "/api/v1/admin/admins" with invalid data:
      | field     | value           | expected_error                    |
      | email     | invalid-email   | Invalid email format              |
      | email     | (empty)         | Email is required                 |
      | firstName | (empty)         | First name is required            |
      | role      | INVALID_ROLE    | Invalid role specified            |
    Then the response status should be 400
    And the response should contain validation errors

  @api @admin @create @error
  Scenario: Cannot create admin with duplicate email
    Given admin with email "existing@example.com" already exists
    When I send a POST request to "/api/v1/admin/admins" with:
      """json
      {
        "email": "existing@example.com",
        "firstName": "Test",
        "lastName": "User",
        "role": "ADMIN"
      }
      """
    Then the response status should be 409
    And the response should contain error "Admin with this email already exists"

  @api @admin @create @error
  Scenario: Cannot create admin with role higher than own
    Given I am authenticated as an Admin with level 80
    When I attempt to create an admin with role "SUPER_ADMIN" (level 100)
    Then the response status should be 403
    And the response should contain error "Cannot assign role higher than your own"

  @api @admin @create
  Scenario: Create admin with custom permissions
    Given I have permission to create admin accounts
    When I send a POST request to "/api/v1/admin/admins" with:
      """json
      {
        "email": "customadmin@example.com",
        "firstName": "Carol",
        "lastName": "Davis",
        "role": "READ_ONLY",
        "customPermissions": ["content:create", "analytics:read"],
        "permissionReason": "Special project access needed"
      }
      """
    Then the response status should be 201
    And the admin should have base READ_ONLY permissions
    And the admin should have additional custom permissions:
      | permission      | source       |
      | content:create  | custom_grant |
      | analytics:read  | custom_grant |
    And the custom permissions should be logged with reason

  # ============================================
  # ADMIN LISTING AND SEARCH
  # ============================================

  @api @admin @list
  Scenario: List all administrators with details
    Given the following admins exist:
      | email               | name         | role          | status   | last_login          |
      | super@example.com   | Super Admin  | SUPER_ADMIN   | ACTIVE   | 2024-02-19T10:00:00 |
      | admin1@example.com  | John Smith   | ADMIN         | ACTIVE   | 2024-02-18T15:30:00 |
      | admin2@example.com  | Jane Doe     | CONTENT_ADMIN | ACTIVE   | 2024-02-17T09:00:00 |
      | admin3@example.com  | Bob Wilson   | BILLING_ADMIN | INACTIVE | 2024-01-15T12:00:00 |
    When I send a GET request to "/api/v1/admin/admins"
    Then the response status should be 200
    And the response should contain 4 admins
    And each admin should include the following fields:
      | field        | description                              |
      | id           | Unique admin identifier                  |
      | email        | Admin email address                      |
      | firstName    | First name                               |
      | lastName     | Last name                                |
      | role         | Assigned role                            |
      | roleLevel    | Numeric role level                       |
      | status       | ACTIVE/INACTIVE/SUSPENDED/PENDING        |
      | mfaEnabled   | Whether MFA is enabled                   |
      | createdAt    | Account creation timestamp               |
      | lastLogin    | Last login timestamp                     |
      | lastActivity | Last activity timestamp                  |
    And admins should be sorted by last activity descending

  @api @admin @search
  Scenario: Search admins by name
    Given the following admins exist:
      | email               | firstName | lastName  |
      | john@example.com    | John      | Smith     |
      | johnny@example.com  | Johnny    | Walker    |
      | jane@example.com    | Jane      | Johnson   |
    When I send a GET request to "/api/v1/admin/admins?search=john"
    Then the response status should be 200
    And the response should contain 3 admins
    And results should include admins matching "john" in name or email
    And search should be case-insensitive
    And results should be highlighted at matching positions

  @api @admin @search
  Scenario: Search admins by email domain
    Given admins exist from different email domains
    When I send a GET request to "/api/v1/admin/admins?search=@company.com"
    Then the response status should be 200
    And results should include only admins with "@company.com" in their email

  @api @admin @filter
  Scenario Outline: Filter admins by criteria
    Given admins exist with various roles and statuses
    When I send a GET request to "/api/v1/admin/admins?<filter>=<value>"
    Then the response status should be 200
    And all returned admins should match <filter>=<value>
    And filter should be exact match

    Examples:
      | filter  | value         |
      | role    | ADMIN         |
      | role    | CONTENT_ADMIN |
      | role    | BILLING_ADMIN |
      | status  | ACTIVE        |
      | status  | INACTIVE      |
      | status  | SUSPENDED     |
      | status  | PENDING       |

  @api @admin @filter
  Scenario: Filter admins by multiple criteria
    Given admins exist with various roles and statuses
    When I send a GET request to "/api/v1/admin/admins?role=ADMIN&status=ACTIVE"
    Then the response status should be 200
    And all returned admins should have role "ADMIN" AND status "ACTIVE"

  @api @admin @filter
  Scenario: Filter admins by date range
    Given admins were created on various dates
    When I send a GET request to "/api/v1/admin/admins?createdAfter=2024-01-01&createdBefore=2024-02-01"
    Then the response status should be 200
    And all returned admins should have been created within the date range

  @api @admin @filter
  Scenario: Filter admins by MFA status
    Given some admins have MFA enabled and some do not
    When I send a GET request to "/api/v1/admin/admins?mfaEnabled=false"
    Then the response status should be 200
    And all returned admins should not have MFA enabled
    And response should include count of admins without MFA

  @api @admin @pagination
  Scenario: Paginate admin list with metadata
    Given 50 admins exist in the system
    When I send a GET request to "/api/v1/admin/admins?page=2&limit=20"
    Then the response status should be 200
    And the response should contain 20 admins
    And the response should include pagination metadata:
      | field       | value |
      | total       | 50    |
      | page        | 2     |
      | limit       | 20    |
      | totalPages  | 3     |
      | hasNext     | true  |
      | hasPrevious | true  |
    And the response should include links:
      | rel      | available |
      | first    | true      |
      | previous | true      |
      | next     | true      |
      | last     | true      |

  @api @admin @sort
  Scenario Outline: Sort admin list by field
    Given multiple admins exist with varying data
    When I send a GET request to "/api/v1/admin/admins?sortBy=<field>&sortOrder=<order>"
    Then the response status should be 200
    And admins should be sorted by <field> in <order> order

    Examples:
      | field       | order |
      | createdAt   | asc   |
      | createdAt   | desc  |
      | lastLogin   | asc   |
      | lastLogin   | desc  |
      | email       | asc   |
      | lastName    | asc   |
      | role        | desc  |

  # ============================================
  # ADMIN DETAILS AND PROFILE
  # ============================================

  @api @admin @view
  Scenario: View admin details with full profile
    Given admin "admin-123" exists with the following data:
      | field      | value                  |
      | email      | john@example.com       |
      | firstName  | John                   |
      | lastName   | Smith                  |
      | role       | CONTENT_ADMIN          |
      | status     | ACTIVE                 |
      | phone      | +1-555-1234            |
      | mfaEnabled | true                   |
    When I send a GET request to "/api/v1/admin/admins/admin-123"
    Then the response status should be 200
    And the response should contain complete admin profile:
      | field           | description                            |
      | id              | Admin ID                               |
      | email           | Email address                          |
      | firstName       | First name                             |
      | lastName        | Last name                              |
      | role            | Assigned role with permissions list    |
      | roleLevel       | Numeric role level                     |
      | status          | Account status                         |
      | phone           | Contact phone                          |
      | avatarUrl       | Profile picture URL                    |
      | mfaEnabled      | Whether MFA is enabled                 |
      | mfaMethod       | MFA method if enabled                  |
      | customPermissions| List of custom-granted permissions    |
      | createdAt       | Account creation timestamp             |
      | createdBy       | ID of admin who created this account   |
      | lastLogin       | Last login timestamp                   |
      | lastActivity    | Last activity timestamp                |
      | lastPasswordChange| When password was last changed       |
      | failedLoginAttempts| Count of recent failed logins       |

  @api @admin @view
  Scenario: View admin login history
    Given admin "admin-123" has login history
    When I send a GET request to "/api/v1/admin/admins/admin-123?include=loginHistory"
    Then the response status should be 200
    And the response should include recent login history:
      | field      | description              |
      | timestamp  | Login time               |
      | ipAddress  | Client IP                |
      | userAgent  | Browser/device info      |
      | location   | Geographic location      |
      | success    | Whether login succeeded  |
      | failReason | Reason if failed         |

  @api @admin @view @error
  Scenario: Cannot view non-existent admin
    When I send a GET request to "/api/v1/admin/admins/non-existent-id"
    Then the response status should be 404
    And the response should contain error "Admin not found"

  @api @admin @view @authorization
  Scenario: Cannot view admin with higher role level
    Given I am authenticated as an Admin with level 80
    And Super Admin "super-123" exists with level 100
    When I send a GET request to "/api/v1/admin/admins/super-123"
    Then the response status should be 403
    And the response should contain error "Cannot view admins with higher role level"

  # ============================================
  # ADMIN UPDATE
  # ============================================

  @api @admin @update
  Scenario: Update admin profile information
    Given admin "admin-123" exists with name "John Smith"
    When I send a PATCH request to "/api/v1/admin/admins/admin-123" with:
      """json
      {
        "firstName": "Jonathan",
        "lastName": "Smith-Jones",
        "phone": "+1-555-9999",
        "timezone": "America/Los_Angeles"
      }
      """
    Then the response status should be 200
    And the admin profile should be updated with new values
    And the response should contain the updated admin
    And an audit log entry should be created with changed fields
    And the admin should receive notification of profile update

  @api @admin @update @role
  Scenario: Change admin role with permission transfer
    Given admin "admin-123" has role "CONTENT_ADMIN" with permissions:
      | permission       |
      | content:read     |
      | content:create   |
      | content:update   |
    When I send a PATCH request to "/api/v1/admin/admins/admin-123" with:
      """json
      {
        "role": "BILLING_ADMIN",
        "roleChangeReason": "Department transfer"
      }
      """
    Then the response status should be 200
    And admin role should be changed to "BILLING_ADMIN"
    And content-related permissions should be revoked
    And billing-related permissions should be granted
    And custom permissions should be retained if compatible
    And the admin should receive notification of role change
    And an audit log entry should record the role change with reason

  @api @admin @update @role
  Scenario: Upgrade admin to higher role
    Given admin "admin-123" has role "SUPPORT_ADMIN" (level 40)
    And I am authenticated as Super Admin
    When I send a PATCH request to "/api/v1/admin/admins/admin-123" with:
      """json
      {
        "role": "ADMIN",
        "roleChangeReason": "Promotion to full admin"
      }
      """
    Then the response status should be 200
    And admin role should be upgraded to "ADMIN" (level 80)
    And additional permissions should be granted
    And the admin should receive congratulatory notification

  @api @admin @update @role
  Scenario: Downgrade admin role with confirmation
    Given admin "admin-123" has role "ADMIN" (level 80)
    When I send a PATCH request to "/api/v1/admin/admins/admin-123" with:
      """json
      {
        "role": "READ_ONLY",
        "roleChangeReason": "Access restriction required",
        "confirmDowngrade": true
      }
      """
    Then the response status should be 200
    And admin role should be downgraded to "READ_ONLY"
    And elevated permissions should be revoked
    And active sessions should be refreshed with new permissions

  @api @admin @update @error
  Scenario: Cannot change own role
    Given I am admin "super-admin-1"
    When I send a PATCH request to "/api/v1/admin/admins/super-admin-1" with:
      """json
      {
        "role": "ADMIN"
      }
      """
    Then the response status should be 403
    And the response should contain error "Cannot modify your own role"

  @api @admin @update @error
  Scenario: Cannot assign higher role than own
    Given I am authenticated as an Admin with level 80
    And admin "admin-123" exists with level 60
    When I attempt to change admin-123's role to "SUPER_ADMIN" (level 100)
    Then the response status should be 403
    And the response should contain error "Cannot assign role higher than your own"

  @api @admin @update @error
  Scenario: Cannot demote admin below minimum level for active permissions
    Given admin "admin-123" has role "ADMIN" and custom permission "billing:manage"
    When I attempt to change admin-123's role to "READ_ONLY"
    Then the response status should be 400
    And the response should contain error "Admin has custom permissions requiring higher role level"
    And the response should list conflicting permissions

  # ============================================
  # ADMIN STATUS MANAGEMENT
  # ============================================

  @api @admin @status
  Scenario: Deactivate admin account with reason
    Given admin "admin-123" is currently active
    And admin "admin-123" has 3 active sessions
    When I send a POST request to "/api/v1/admin/admins/admin-123/deactivate" with:
      """json
      {
        "reason": "Employee resignation",
        "effectiveImmediately": true,
        "notifyAdmin": true
      }
      """
    Then the response status should be 200
    And admin status should be "INACTIVE"
    And all 3 active sessions should be terminated immediately
    And admin should not be able to log in
    And admin should receive deactivation notification
    And audit log should record deactivation with reason
    And admin's scheduled tasks should be reassigned or cancelled

  @api @admin @status
  Scenario: Schedule admin deactivation for future date
    Given admin "admin-123" is currently active
    When I send a POST request to "/api/v1/admin/admins/admin-123/deactivate" with:
      """json
      {
        "reason": "Contract ending",
        "effectiveDate": "2024-03-31T23:59:59Z",
        "notifyAdmin": true
      }
      """
    Then the response status should be 200
    And admin status should remain "ACTIVE" until effective date
    And a scheduled deactivation should be created
    And admin should receive advance notification
    And reminder should be sent 7 days before deactivation

  @api @admin @status
  Scenario: Reactivate inactive admin account
    Given admin "admin-123" is currently inactive
    And admin was deactivated 30 days ago
    When I send a POST request to "/api/v1/admin/admins/admin-123/reactivate" with:
      """json
      {
        "reason": "Rehired employee",
        "requirePasswordReset": true,
        "requireMfaSetup": true
      }
      """
    Then the response status should be 200
    And admin status should be "ACTIVE"
    And admin should be required to reset password on next login
    And admin should be required to set up MFA
    And admin should receive reactivation notification with instructions
    And audit log should record reactivation with reason

  @api @admin @status
  Scenario: Suspend admin account temporarily
    Given admin "admin-123" is currently active
    When I send a POST request to "/api/v1/admin/admins/admin-123/suspend" with:
      """json
      {
        "reason": "Security investigation pending",
        "durationDays": 7,
        "notifyAdmin": true,
        "preserveSessions": false
      }
      """
    Then the response status should be 200
    And admin status should be "SUSPENDED"
    And all active sessions should be terminated
    And suspension should automatically expire after 7 days
    And admin should receive suspension notification with duration
    And calendar event should be created for suspension expiry

  @api @admin @status
  Scenario: Extend admin suspension
    Given admin "admin-123" is currently suspended for 7 days
    And 3 days have passed
    When I send a POST request to "/api/v1/admin/admins/admin-123/suspend" with:
      """json
      {
        "reason": "Investigation extended",
        "durationDays": 14,
        "extendFromNow": true
      }
      """
    Then the response status should be 200
    And suspension should be extended by 14 days from now
    And admin should receive updated suspension notification
    And audit log should record suspension extension

  @api @admin @status
  Scenario: Lift admin suspension early
    Given admin "admin-123" is currently suspended
    When I send a POST request to "/api/v1/admin/admins/admin-123/unsuspend" with:
      """json
      {
        "reason": "Investigation completed - no issues found"
      }
      """
    Then the response status should be 200
    And admin status should be "ACTIVE"
    And admin should receive notification that suspension is lifted
    And audit log should record early suspension lift

  @api @admin @status @error
  Scenario: Cannot deactivate last Super Admin
    Given there is only one Super Admin in the system
    And that Super Admin is "super-admin-1"
    When I attempt to deactivate "super-admin-1"
    Then the response status should be 400
    And the response should contain error "Cannot deactivate the last Super Admin"
    And the response should suggest "Assign Super Admin role to another admin first"

  @api @admin @status @error
  Scenario: Cannot deactivate own account
    Given I am admin "super-admin-1"
    When I send a POST request to "/api/v1/admin/admins/super-admin-1/deactivate"
    Then the response status should be 403
    And the response should contain error "Cannot deactivate your own account"

  @api @admin @status @error
  Scenario: Cannot suspend admin with higher role level
    Given I am authenticated as Admin with level 80
    And Super Admin "super-123" exists with level 100
    When I attempt to suspend "super-123"
    Then the response status should be 403
    And the response should contain error "Cannot suspend admin with higher role level"

  # ============================================
  # ADMIN DELETION
  # ============================================

  @api @admin @delete
  Scenario: Soft delete inactive admin account
    Given admin "admin-123" exists and has status "INACTIVE"
    And admin has been inactive for 30 days
    When I send a DELETE request to "/api/v1/admin/admins/admin-123" with:
      """json
      {
        "reason": "Account cleanup",
        "confirmDeletion": true
      }
      """
    Then the response status should be 200
    And admin account should be soft-deleted
    And admin should not appear in admin list
    And admin data should be retained for 90 days
    And admin email should be released for reuse after deletion
    And audit log should record deletion with reason

  @api @admin @delete @error
  Scenario: Cannot delete active admin
    Given admin "admin-123" is currently active
    When I send a DELETE request to "/api/v1/admin/admins/admin-123"
    Then the response status should be 400
    And the response should contain error "Cannot delete an active admin"
    And the response should suggest "Deactivate the admin first"

  @api @admin @delete @error
  Scenario: Cannot delete own account
    Given I am admin "super-admin-1"
    When I send a DELETE request to "/api/v1/admin/admins/super-admin-1"
    Then the response status should be 403
    And the response should contain error "Cannot delete your own account"

  @api @admin @delete @error
  Scenario: Cannot delete admin with pending data requests
    Given admin "admin-123" is inactive
    And admin has pending GDPR data export requests
    When I send a DELETE request to "/api/v1/admin/admins/admin-123"
    Then the response status should be 400
    And the response should contain error "Admin has pending data requests"
    And the response should list pending requests

  @api @admin @delete
  Scenario: Permanently delete admin after retention period
    Given admin "admin-123" was soft-deleted 91 days ago
    When the data retention cleanup job runs
    Then admin personal data should be permanently deleted:
      | data_type        | action      |
      | email            | anonymized  |
      | firstName        | deleted     |
      | lastName         | deleted     |
      | phone            | deleted     |
      | avatarUrl        | deleted     |
      | ipAddresses      | anonymized  |
    And audit logs should be anonymized but retained
    And admin ID should remain for referential integrity
    And the permanent deletion should be logged

  @api @admin @delete
  Scenario: Restore soft-deleted admin within retention period
    Given admin "admin-123" was soft-deleted 45 days ago
    When I send a POST request to "/api/v1/admin/admins/admin-123/restore"
    Then the response status should be 200
    And admin should be restored with status "INACTIVE"
    And all admin data should be intact
    And admin should be required to reset password
    And audit log should record restoration

  # ============================================
  # ROLE MANAGEMENT
  # ============================================

  @api @admin @roles
  Scenario: List all available admin roles
    When I send a GET request to "/api/v1/admin/roles"
    Then the response status should be 200
    And the response should contain the following roles:
      | role          | description                         | level | adminCount |
      | SUPER_ADMIN   | Full platform access                | 100   | 2          |
      | ADMIN         | Standard admin permissions          | 80    | 5          |
      | CONTENT_ADMIN | Content management only             | 60    | 8          |
      | BILLING_ADMIN | Billing and subscription management | 60    | 3          |
      | SUPPORT_ADMIN | Customer support access             | 40    | 12         |
      | READ_ONLY     | View-only access                    | 20    | 4          |
    And each role should include permission count

  @api @admin @roles
  Scenario: View role permissions in detail
    When I send a GET request to "/api/v1/admin/roles/CONTENT_ADMIN"
    Then the response status should be 200
    And the response should contain:
      | field        | value                               |
      | role         | CONTENT_ADMIN                       |
      | level        | 60                                  |
      | description  | Content management only             |
      | isDefault    | false                               |
      | isAssignable | true                                |
    And the response should include permissions:
      | permission       | description                    | category |
      | content:read     | View content                   | content  |
      | content:create   | Create new content             | content  |
      | content:update   | Edit existing content          | content  |
      | content:delete   | Delete content                 | content  |
      | content:publish  | Publish content                | content  |
      | content:archive  | Archive content                | content  |
      | media:read       | View media files               | media    |
      | media:upload     | Upload media files             | media    |
    And the response should include admin count with this role

  @api @admin @roles
  Scenario: Create custom role
    Given I am a Super Admin
    When I send a POST request to "/api/v1/admin/roles" with:
      """json
      {
        "name": "MARKETING_ADMIN",
        "description": "Marketing and campaigns management",
        "level": 55,
        "permissions": [
          "content:read",
          "content:create",
          "analytics:read",
          "campaigns:manage"
        ]
      }
      """
    Then the response status should be 201
    And the new role should be available for assignment
    And audit log should record role creation

  @api @admin @roles
  Scenario: Update role permissions
    Given I am a Super Admin
    And role "CONTENT_ADMIN" exists
    When I send a PATCH request to "/api/v1/admin/roles/CONTENT_ADMIN" with:
      """json
      {
        "permissions": {
          "add": ["analytics:read"],
          "remove": ["content:delete"]
        },
        "reason": "Content admins should view analytics but not delete content"
      }
      """
    Then the response status should be 200
    And the role permissions should be updated
    And all admins with this role should have updated permissions
    And admins should be notified of permission changes

  @api @admin @roles @error
  Scenario: Cannot delete role with assigned admins
    Given role "CONTENT_ADMIN" has 5 assigned admins
    When I send a DELETE request to "/api/v1/admin/roles/CONTENT_ADMIN"
    Then the response status should be 400
    And the response should contain error "Cannot delete role with assigned admins"
    And the response should include count of affected admins

  @api @admin @roles @error
  Scenario: Cannot delete system roles
    When I send a DELETE request to "/api/v1/admin/roles/SUPER_ADMIN"
    Then the response status should be 403
    And the response should contain error "Cannot delete system-defined roles"

  # ============================================
  # PERMISSION MANAGEMENT
  # ============================================

  @api @admin @permissions
  Scenario: Grant additional permission to admin
    Given admin "admin-123" has role "CONTENT_ADMIN"
    And admin does not have "billing:read" permission
    When I send a POST request to "/api/v1/admin/admins/admin-123/permissions" with:
      """json
      {
        "permission": "billing:read",
        "reason": "Needs to view billing for content reporting",
        "expiresAt": "2024-12-31T23:59:59Z"
      }
      """
    Then the response status should be 200
    And admin should have "billing:read" permission
    And the permission should be flagged as:
      | field     | value                                      |
      | source    | custom_grant                               |
      | grantedBy | current admin ID                           |
      | grantedAt | current timestamp                          |
      | expiresAt | 2024-12-31T23:59:59Z                       |
      | reason    | Needs to view billing for content reporting|
    And admin should receive notification of new permission

  @api @admin @permissions
  Scenario: Grant permanent custom permission
    Given admin "admin-123" has role "SUPPORT_ADMIN"
    When I send a POST request to "/api/v1/admin/admins/admin-123/permissions" with:
      """json
      {
        "permission": "users:export",
        "reason": "Required for compliance reporting",
        "permanent": true
      }
      """
    Then the response status should be 200
    And permission should be granted without expiration
    And permission should persist across role changes if compatible

  @api @admin @permissions
  Scenario: Revoke custom permission from admin
    Given admin "admin-123" has custom permission "billing:read"
    When I send a DELETE request to "/api/v1/admin/admins/admin-123/permissions/billing:read" with:
      """json
      {
        "reason": "Permission no longer required"
      }
      """
    Then the response status should be 200
    And admin should no longer have "billing:read" permission
    And admin should receive notification of permission revocation
    And audit log should record permission revocation with reason

  @api @admin @permissions @error
  Scenario: Cannot revoke role-based permission
    Given admin "admin-123" has role "CONTENT_ADMIN"
    And "content:read" is a role-based permission
    When I send a DELETE request to "/api/v1/admin/admins/admin-123/permissions/content:read"
    Then the response status should be 400
    And the response should contain error "Cannot revoke role-based permission"
    And the response should suggest "Change admin role to remove this permission"

  @api @admin @permissions @error
  Scenario: Cannot grant Super Admin permissions without Super Admin role
    Given admin "admin-123" has role "ADMIN"
    When I attempt to grant "system:configure" permission to admin-123
    Then the response status should be 403
    And the response should contain error "This permission requires Super Admin role"

  @api @admin @permissions
  Scenario: View admin's effective permissions
    Given admin "admin-123" has:
      | attribute          | value                            |
      | role               | CONTENT_ADMIN                    |
      | customPermissions  | billing:read, analytics:export   |
    When I send a GET request to "/api/v1/admin/admins/admin-123/permissions"
    Then the response status should be 200
    And the response should contain all effective permissions:
      | permission       | source       | expiresAt     |
      | content:read     | role         | null          |
      | content:create   | role         | null          |
      | content:update   | role         | null          |
      | billing:read     | custom_grant | 2024-12-31    |
      | analytics:export | custom_grant | null          |
    And each permission should indicate its source
    And expired permissions should not be included

  @api @admin @permissions
  Scenario: Bulk grant permissions to multiple admins
    Given admins "admin-1", "admin-2", "admin-3" exist
    When I send a POST request to "/api/v1/admin/permissions/bulk-grant" with:
      """json
      {
        "adminIds": ["admin-1", "admin-2", "admin-3"],
        "permissions": ["analytics:read", "reports:generate"],
        "reason": "New reporting project team",
        "expiresAt": "2024-06-30T23:59:59Z"
      }
      """
    Then the response status should be 200
    And all specified admins should receive the permissions
    And a single audit entry should record the bulk grant

  # ============================================
  # SECURITY CONTROLS
  # ============================================

  @api @admin @security
  Scenario: Force password reset for admin
    Given admin "admin-123" exists and is active
    When I send a POST request to "/api/v1/admin/admins/admin-123/force-password-reset" with:
      """json
      {
        "reason": "Suspected credential compromise",
        "terminateSessions": true,
        "notifyAdmin": true
      }
      """
    Then the response status should be 200
    And admin's password should be invalidated
    And admin should receive password reset email
    And admin should be required to change password on next login
    And all active sessions should be terminated
    And security alert should be logged

  @api @admin @security
  Scenario: View admin active sessions
    Given admin "admin-123" has the following active sessions:
      | session_id  | ip_address    | user_agent          | created_at          | last_active         |
      | sess-1      | 192.168.1.100 | Chrome/Windows      | 2024-02-19T08:00:00 | 2024-02-19T10:30:00 |
      | sess-2      | 10.0.0.50     | Safari/macOS        | 2024-02-18T14:00:00 | 2024-02-19T09:00:00 |
      | sess-3      | 172.16.0.25   | Mobile Safari/iOS   | 2024-02-19T07:00:00 | 2024-02-19T10:00:00 |
    When I send a GET request to "/api/v1/admin/admins/admin-123/sessions"
    Then the response status should be 200
    And the response should contain 3 sessions with:
      | field       | description                    |
      | sessionId   | Session identifier             |
      | ipAddress   | Client IP address              |
      | userAgent   | Browser/device information     |
      | createdAt   | Session start time             |
      | lastActive  | Last activity timestamp        |
      | location    | Approximate geographic location|
      | isCurrent   | Whether this is my session     |

  @api @admin @security
  Scenario: Terminate specific admin session
    Given admin "admin-123" has session "session-456"
    When I send a DELETE request to "/api/v1/admin/admins/admin-123/sessions/session-456" with:
      """json
      {
        "reason": "Suspicious activity detected"
      }
      """
    Then the response status should be 200
    And session "session-456" should be terminated
    And admin should be logged out from that session
    And admin should receive notification of forced logout
    And audit log should record session termination

  @api @admin @security
  Scenario: Terminate all admin sessions except current
    Given admin "admin-123" has 5 active sessions
    And one of them is my current session
    When I send a DELETE request to "/api/v1/admin/admins/admin-123/sessions" with:
      """json
      {
        "preserveCurrent": true,
        "reason": "Security audit"
      }
      """
    Then the response status should be 200
    And 4 sessions should be terminated
    And my current session should remain active
    And admin should receive notification

  @api @admin @security
  Scenario: Terminate all admin sessions including current
    Given admin "admin-123" has 5 active sessions
    When I send a DELETE request to "/api/v1/admin/admins/admin-123/sessions" with:
      """json
      {
        "preserveCurrent": false,
        "reason": "Complete session reset required"
      }
      """
    Then the response status should be 200
    And all 5 sessions should be terminated
    And admin should be logged out from all devices

  @api @admin @security @mfa
  Scenario: Require MFA for admin
    Given admin "admin-123" does not have MFA enabled
    When I send a POST request to "/api/v1/admin/admins/admin-123/require-mfa" with:
      """json
      {
        "enforcementDate": "2024-03-01T00:00:00Z",
        "allowedMethods": ["totp", "sms", "email"]
      }
      """
    Then the response status should be 200
    And admin should be marked as MFA required
    And admin should receive notification about MFA requirement
    And admin should see MFA setup prompt on next login
    And admin should be forced to set up MFA by enforcement date

  @api @admin @security @mfa
  Scenario: Reset admin MFA after device loss
    Given admin "admin-123" has MFA enabled via authenticator app
    And admin has reported lost device
    When I send a POST request to "/api/v1/admin/admins/admin-123/reset-mfa" with:
      """json
      {
        "reason": "Device lost - employee verified via HR",
        "requireImmediateSetup": true,
        "terminateSessions": true
      }
      """
    Then the response status should be 200
    And admin's MFA configuration should be cleared
    And all active sessions should be terminated
    And admin should be required to set up new MFA on next login
    And security alert should be logged
    And admin should receive MFA reset notification

  @api @admin @security
  Scenario: Lock admin account after failed login attempts
    Given admin "admin-123" has 5 consecutive failed login attempts
    When the system detects the 5th failed attempt
    Then admin account should be temporarily locked for 30 minutes
    And admin should receive account lock notification
    And security team should be alerted
    And audit log should record the lock event

  @api @admin @security
  Scenario: Unlock admin account manually
    Given admin "admin-123" is currently locked
    When I send a POST request to "/api/v1/admin/admins/admin-123/unlock" with:
      """json
      {
        "reason": "Identity verified via phone call",
        "resetFailedAttempts": true
      }
      """
    Then the response status should be 200
    And admin account should be unlocked
    And failed login attempt counter should be reset
    And admin should receive unlock notification

  @api @admin @security
  Scenario: View admin security status
    Given admin "admin-123" exists
    When I send a GET request to "/api/v1/admin/admins/admin-123/security"
    Then the response status should be 200
    And the response should contain security status:
      | field                  | description                     |
      | mfaEnabled             | Whether MFA is active           |
      | mfaMethod              | Current MFA method              |
      | mfaBackupCodesRemaining| Count of unused backup codes    |
      | passwordLastChanged    | Password change timestamp       |
      | passwordExpiresAt      | Password expiration date        |
      | accountLocked          | Whether account is locked       |
      | lockExpiresAt          | Lock expiration time            |
      | failedLoginAttempts    | Recent failed login count       |
      | lastSuccessfulLogin    | Last successful login           |
      | suspiciousActivityFlag | Any suspicious activity flagged |

  # ============================================
  # AUDIT LOGGING
  # ============================================

  @api @admin @audit
  Scenario: View admin activity log
    Given admin "admin-123" has performed various actions
    When I send a GET request to "/api/v1/admin/admins/admin-123/activity"
    Then the response status should be 200
    And the response should contain recent activities:
      | field       | description                    |
      | id          | Activity log entry ID          |
      | action      | Action performed               |
      | resource    | Resource type affected         |
      | resourceId  | Specific resource ID           |
      | details     | Action details (JSON)          |
      | ipAddress   | Client IP address              |
      | userAgent   | Browser/device info            |
      | timestamp   | When action occurred           |
      | success     | Whether action succeeded       |
    And activities should be sorted by timestamp descending
    And activities should be paginated

  @api @admin @audit
  Scenario: Filter admin activity by action type
    Given admin "admin-123" has various activity types
    When I send a GET request to "/api/v1/admin/admins/admin-123/activity?action=LOGIN"
    Then the response status should be 200
    And all results should be login events
    And results should include both successful and failed logins

  @api @admin @audit
  Scenario: Filter admin activity by date range
    Given admin "admin-123" has activity spanning 90 days
    When I send a GET request to "/api/v1/admin/admins/admin-123/activity?startDate=2024-02-01&endDate=2024-02-15"
    Then the response status should be 200
    And all results should be within the specified date range

  @api @admin @audit
  Scenario: Filter admin activity by resource type
    Given admin "admin-123" has activity on various resources
    When I send a GET request to "/api/v1/admin/admins/admin-123/activity?resource=USER"
    Then the response status should be 200
    And all results should be actions on user resources

  @api @admin @audit
  Scenario: Export admin audit logs
    Given admin "admin-123" has activity spanning 90 days
    When I send a POST request to "/api/v1/admin/admins/admin-123/activity/export" with:
      """json
      {
        "format": "csv",
        "startDate": "2024-01-01",
        "endDate": "2024-03-31",
        "includeDetails": true
      }
      """
    Then the response status should be 202
    And an export job should be queued
    And I should receive download link when export is ready
    And export should include all activity fields

  @api @admin @audit
  Scenario: View system-wide admin audit log
    Given multiple admins have performed actions
    When I send a GET request to "/api/v1/admin/audit-log"
    Then the response status should be 200
    And the response should contain activities from all admins
    And each entry should include admin identifier
    And results should be filterable by admin, action, resource, and date

  @domain @audit
  Scenario: Track all admin management actions
    Given admin management actions are performed
    Then the following actions should be logged in the audit system:
      | action_type           | logged_fields                               |
      | ADMIN_CREATED         | admin_id, email, role, created_by           |
      | ADMIN_UPDATED         | admin_id, changed_fields, updated_by        |
      | ADMIN_ROLE_CHANGED    | admin_id, old_role, new_role, changed_by    |
      | ADMIN_DEACTIVATED     | admin_id, reason, deactivated_by            |
      | ADMIN_REACTIVATED     | admin_id, reactivated_by                    |
      | ADMIN_SUSPENDED       | admin_id, reason, duration, suspended_by    |
      | ADMIN_DELETED         | admin_id, deleted_by                        |
      | ADMIN_RESTORED        | admin_id, restored_by                       |
      | PERMISSION_GRANTED    | admin_id, permission, granted_by, reason    |
      | PERMISSION_REVOKED    | admin_id, permission, revoked_by, reason    |
      | PASSWORD_RESET_FORCED | admin_id, forced_by, reason                 |
      | MFA_REQUIRED          | admin_id, required_by                       |
      | MFA_RESET             | admin_id, reset_by, reason                  |
      | SESSION_TERMINATED    | admin_id, session_id, terminated_by, reason |
      | ACCOUNT_LOCKED        | admin_id, trigger_reason                    |
      | ACCOUNT_UNLOCKED      | admin_id, unlocked_by, reason               |
    And all entries should include timestamp and IP address
    And audit logs should be immutable

  # ============================================
  # CONCURRENT MODIFICATION HANDLING
  # ============================================

  @api @admin @concurrent @error
  Scenario: Handle concurrent admin updates with optimistic locking
    Given admin "admin-123" has version 5
    And I have loaded admin-123 with version 5
    And another admin updates admin-123 (now version 6)
    When I attempt to update admin-123 with my stale version:
      """json
      {
        "firstName": "Updated Name",
        "version": 5
      }
      """
    Then the response status should be 409
    And the response should contain error "Admin has been modified by another user"
    And the response should include the current version (6)
    And the response should include the current admin data
    And the response should suggest reloading and retrying

  @api @admin @concurrent
  Scenario: Successful update with correct version
    Given admin "admin-123" has version 5
    When I send a PATCH request to "/api/v1/admin/admins/admin-123" with:
      """json
      {
        "firstName": "Updated Name",
        "version": 5
      }
      """
    Then the response status should be 200
    And admin version should be incremented to 6
    And the update should succeed

  # ============================================
  # SELF-SERVICE PROFILE MANAGEMENT
  # ============================================

  @api @admin @profile
  Scenario: Admin views own profile
    Given I am admin "admin-123"
    When I send a GET request to "/api/v1/admin/profile"
    Then the response status should be 200
    And the response should contain my complete profile
    And I should see my permissions
    And I should see my security status

  @api @admin @profile
  Scenario: Admin updates own profile
    Given I am admin "admin-123"
    When I send a PATCH request to "/api/v1/admin/profile" with:
      """json
      {
        "phone": "+1-555-1234",
        "timezone": "America/New_York",
        "language": "en-US",
        "notificationPreferences": {
          "email": true,
          "sms": false,
          "pushNotifications": true
        }
      }
      """
    Then the response status should be 200
    And my profile should be updated
    And I should not be able to modify my own role
    And I should not be able to modify my own permissions
    And I should not be able to modify my own status

  @api @admin @profile
  Scenario: Admin changes own password
    Given I am admin "admin-123"
    When I send a POST request to "/api/v1/admin/profile/change-password" with:
      """json
      {
        "currentPassword": "OldP@ssw0rd!",
        "newPassword": "NewSecureP@ss123!",
        "confirmPassword": "NewSecureP@ss123!"
      }
      """
    Then the response status should be 200
    And my password should be updated
    And other sessions should be terminated
    And I should remain logged in on current session
    And password change should be logged
    And I should receive confirmation email

  @api @admin @profile @error
  Scenario: Reject weak new password
    Given I am admin "admin-123"
    When I attempt to change password to "password123"
    Then the response status should be 400
    And the response should contain password validation errors:
      | error                                      |
      | Password must contain uppercase letters    |
      | Password must contain special characters   |
      | Password is too common                     |

  @api @admin @profile @error
  Scenario: Reject incorrect current password
    Given I am admin "admin-123"
    When I attempt to change password with wrong current password
    Then the response status should be 401
    And the response should contain error "Current password is incorrect"
    And failed attempt should be logged
    And I should receive security notification

  @api @admin @profile
  Scenario: Admin sets up MFA
    Given I am admin "admin-123"
    And I do not have MFA enabled
    When I send a POST request to "/api/v1/admin/profile/mfa/setup" with:
      """json
      {
        "method": "totp"
      }
      """
    Then the response status should be 200
    And I should receive TOTP secret and QR code
    And MFA should not be active until verified

  @api @admin @profile
  Scenario: Admin verifies and activates MFA
    Given I am admin "admin-123"
    And I have initiated MFA setup with TOTP
    When I send a POST request to "/api/v1/admin/profile/mfa/verify" with:
      """json
      {
        "code": "123456"
      }
      """
    Then the response status should be 200
    And MFA should be activated
    And I should receive backup codes
    And MFA activation should be logged

  @api @admin @profile
  Scenario: Admin uploads profile picture
    Given I am admin "admin-123"
    When I send a POST request to "/api/v1/admin/profile/avatar" with image file
    Then the response status should be 200
    And image should be validated:
      | validation   | requirement           |
      | max_size     | 2MB                   |
      | formats      | jpg, png, gif, webp   |
      | dimensions   | min 100x100, max 2000x2000 |
    And image should be resized to standard sizes
    And old avatar should be replaced
    And avatar URL should be returned

  @api @admin @profile
  Scenario: Admin views own activity log
    Given I am admin "admin-123"
    When I send a GET request to "/api/v1/admin/profile/activity"
    Then the response status should be 200
    And I should see my own activity history
    And I should not see other admins' activities

  @api @admin @profile
  Scenario: Admin views own active sessions
    Given I am admin "admin-123"
    And I have 3 active sessions
    When I send a GET request to "/api/v1/admin/profile/sessions"
    Then the response status should be 200
    And I should see all 3 sessions
    And current session should be marked
    And I should be able to terminate other sessions

  @api @admin @profile
  Scenario: Admin terminates own other sessions
    Given I am admin "admin-123"
    And I have session "other-session-456" from another device
    When I send a DELETE request to "/api/v1/admin/profile/sessions/other-session-456"
    Then the response status should be 200
    And the other session should be terminated
    And I should remain logged in on current session

  # ============================================
  # AUTHORIZATION EDGE CASES
  # ============================================

  @api @admin @authorization @error
  Scenario: Regular admin cannot access admin management
    Given I am authenticated as a regular user without admin permissions
    When I send a GET request to "/api/v1/admin/admins"
    Then the response status should be 403
    And the response should contain error "Insufficient permissions"

  @api @admin @authorization
  Scenario: Admin can only view admins at or below their level
    Given I am authenticated as an Admin with level 80
    And the following admins exist:
      | email               | role          | level |
      | super@example.com   | SUPER_ADMIN   | 100   |
      | admin@example.com   | ADMIN         | 80    |
      | content@example.com | CONTENT_ADMIN | 60    |
      | support@example.com | SUPPORT_ADMIN | 40    |
    When I send a GET request to "/api/v1/admin/admins"
    Then the response status should be 200
    And I should see admins at level 80 and below
    And Super Admins (level 100) should be hidden from results

  @api @admin @authorization
  Scenario: Admin can only manage admins below their level
    Given I am authenticated as an Admin with level 80
    And admin "content-123" has level 60
    When I send a PATCH request to "/api/v1/admin/admins/content-123"
    Then the request should be allowed

  @api @admin @authorization @error
  Scenario: Admin cannot manage admins at same level
    Given I am authenticated as an Admin with level 80
    And admin "other-admin-123" also has level 80
    When I send a PATCH request to "/api/v1/admin/admins/other-admin-123"
    Then the response status should be 403
    And the response should contain error "Cannot manage admins at or above your level"

  @api @admin @authorization
  Scenario: Super Admin can manage all admins
    Given I am authenticated as a Super Admin with level 100
    When I send a GET request to "/api/v1/admin/admins"
    Then I should see all admins regardless of level

  # ============================================
  # BULK OPERATIONS
  # ============================================

  @api @admin @bulk
  Scenario: Bulk deactivate admins
    Given I am authenticated as a Super Admin
    And the following admins are active: "admin-1", "admin-2", "admin-3"
    When I send a POST request to "/api/v1/admin/admins/bulk/deactivate" with:
      """json
      {
        "adminIds": ["admin-1", "admin-2", "admin-3"],
        "reason": "Department restructuring"
      }
      """
    Then the response status should be 200
    And all 3 admins should be deactivated
    And the response should include results for each admin
    And bulk operation should be atomic (all or none)
    And single audit entry should record bulk action
    And all affected admins should receive notifications

  @api @admin @bulk
  Scenario: Bulk change admin roles
    Given I am authenticated as a Super Admin
    And admins "admin-1", "admin-2" have role "SUPPORT_ADMIN"
    When I send a POST request to "/api/v1/admin/admins/bulk/change-role" with:
      """json
      {
        "adminIds": ["admin-1", "admin-2"],
        "newRole": "CONTENT_ADMIN",
        "reason": "Team reorganization"
      }
      """
    Then the response status should be 200
    And both admins should have role "CONTENT_ADMIN"
    And permissions should be updated for both

  @api @admin @bulk @error
  Scenario: Bulk operation fails if any admin is protected
    Given I attempt to bulk deactivate including the last Super Admin
    Then the response status should be 400
    And the response should contain error "Cannot deactivate last Super Admin"
    And the response should identify the protected admin
    And no admins should be deactivated (atomic rollback)

  @api @admin @bulk @error
  Scenario: Bulk operation partial failure returns detailed results
    Given I attempt to bulk update admins with mixed permissions
    And some updates would exceed my authority
    When the bulk operation is processed
    Then the response status should be 207 (Multi-Status)
    And the response should include status for each admin:
      | adminId  | status  | error                           |
      | admin-1  | success | null                            |
      | admin-2  | failed  | Cannot modify admin at same level |
      | admin-3  | success | null                            |

  @api @admin @bulk
  Scenario: Bulk grant permissions
    Given admins "admin-1", "admin-2", "admin-3" exist
    When I send a POST request to "/api/v1/admin/admins/bulk/grant-permissions" with:
      """json
      {
        "adminIds": ["admin-1", "admin-2", "admin-3"],
        "permissions": ["analytics:read", "reports:generate"],
        "reason": "New reporting project team",
        "expiresAt": "2024-06-30T23:59:59Z"
      }
      """
    Then the response status should be 200
    And all specified admins should receive the permissions
    And a single audit entry should record the bulk grant

  # ============================================
  # INVITATION MANAGEMENT
  # ============================================

  @api @admin @invitation
  Scenario: View pending admin invitations
    Given there are pending admin invitations
    When I send a GET request to "/api/v1/admin/invitations"
    Then the response status should be 200
    And the response should contain pending invitations:
      | field        | description              |
      | id           | Invitation ID            |
      | email        | Invited email            |
      | role         | Assigned role            |
      | invitedBy    | Admin who sent invite    |
      | invitedAt    | Invitation timestamp     |
      | expiresAt    | Expiration timestamp     |
      | status       | pending/expired/accepted |

  @api @admin @invitation
  Scenario: Resend admin invitation
    Given invitation "inv-123" exists and is pending
    When I send a POST request to "/api/v1/admin/invitations/inv-123/resend"
    Then the response status should be 200
    And a new invitation email should be sent
    And expiration should be extended by 72 hours
    And resend should be logged

  @api @admin @invitation
  Scenario: Cancel admin invitation
    Given invitation "inv-123" exists and is pending
    When I send a DELETE request to "/api/v1/admin/invitations/inv-123"
    Then the response status should be 200
    And invitation should be cancelled
    And invitation link should no longer work

  @api @admin @invitation
  Scenario: Clean up expired invitations
    Given there are expired invitations older than 7 days
    When the invitation cleanup job runs
    Then expired invitations should be archived
    And emails should be released for new invitations

  # ============================================
  # DOMAIN EVENTS
  # ============================================

  @domain-events
  Scenario: AdminCreatedEvent triggers notifications and setup
    When the AdminCreatedEvent is published with:
      | field       | value                |
      | adminId     | admin-123            |
      | email       | new@example.com      |
      | role        | CONTENT_ADMIN        |
      | createdBy   | super-admin-1        |
    Then invitation email should be queued
    And admin should be added to appropriate groups
    And welcome materials should be prepared
    And analytics should track new admin

  @domain-events
  Scenario: AdminRoleChangedEvent triggers permission sync
    When the AdminRoleChangedEvent is published with:
      | field       | value         |
      | adminId     | admin-123     |
      | oldRole     | CONTENT_ADMIN |
      | newRole     | BILLING_ADMIN |
      | changedBy   | super-admin-1 |
    Then old role permissions should be revoked
    And new role permissions should be granted
    And active sessions should be updated
    And admin should receive notification

  @domain-events
  Scenario: AdminDeactivatedEvent triggers cleanup
    When the AdminDeactivatedEvent is published with:
      | field         | value              |
      | adminId       | admin-123          |
      | reason        | Employee departure |
      | deactivatedBy | super-admin-1      |
    Then all active sessions should be terminated
    And scheduled tasks should be reassigned
    And API keys should be revoked
    And admin should be removed from active rosters

  @domain-events
  Scenario: AdminSuspendedEvent triggers security measures
    When the AdminSuspendedEvent is published with:
      | field       | value                  |
      | adminId     | admin-123              |
      | reason      | Security investigation |
      | duration    | 7 days                 |
      | suspendedBy | super-admin-1          |
    Then all active sessions should be terminated
    And login should be blocked
    And security team should be notified
    And suspension expiry job should be scheduled

  @domain-events
  Scenario: AdminPasswordResetEvent triggers security audit
    When the AdminPasswordResetEvent is published with:
      | field      | value              |
      | adminId    | admin-123          |
      | forced     | true               |
      | resetBy    | super-admin-1      |
      | reason     | Suspected compromise|
    Then security audit should be initiated
    And related accounts should be reviewed
    And admin should receive secure notification

  @domain-events
  Scenario: Emit domain events for admin lifecycle
    Given admin management actions occur
    Then the following domain events should be emitted:
      | event_type                   | payload                                  |
      | AdminCreatedEvent            | adminId, email, role, createdBy          |
      | AdminUpdatedEvent            | adminId, changedFields, updatedBy        |
      | AdminRoleChangedEvent        | adminId, oldRole, newRole, changedBy     |
      | AdminDeactivatedEvent        | adminId, reason, deactivatedBy           |
      | AdminReactivatedEvent        | adminId, reactivatedBy                   |
      | AdminSuspendedEvent          | adminId, reason, duration, suspendedBy   |
      | AdminUnsuspendedEvent        | adminId, unsuspendedBy                   |
      | AdminDeletedEvent            | adminId, deletedBy                       |
      | AdminRestoredEvent           | adminId, restoredBy                      |
      | AdminPermissionGrantedEvent  | adminId, permission, grantedBy           |
      | AdminPermissionRevokedEvent  | adminId, permission, revokedBy           |
      | AdminPasswordResetEvent      | adminId, forced, resetBy                 |
      | AdminMfaRequiredEvent        | adminId, requiredBy                      |
      | AdminMfaResetEvent           | adminId, resetBy                         |
      | AdminSessionTerminatedEvent  | adminId, sessionId, terminatedBy         |
      | AdminAccountLockedEvent      | adminId, reason                          |
      | AdminAccountUnlockedEvent    | adminId, unlockedBy                      |
      | AdminInvitationSentEvent     | invitationId, email, role, sentBy        |
      | AdminInvitationAcceptedEvent | invitationId, adminId                    |
    And events should be published to message bus
    And events should support audit and compliance requirements

  # ============================================
  # ERROR HANDLING
  # ============================================

  @api @error
  Scenario: Handle database connection failure gracefully
    Given the database is temporarily unavailable
    When I send a GET request to "/api/v1/admin/admins"
    Then the response status should be 503
    And the response should contain error "Service temporarily unavailable"
    And the response should include retry-after header
    And the error should be logged with correlation ID

  @api @error
  Scenario: Handle invalid admin ID format
    When I send a GET request to "/api/v1/admin/admins/invalid-format!"
    Then the response status should be 400
    And the response should contain error "Invalid admin ID format"

  @api @error
  Scenario: Handle request timeout
    Given a complex query that exceeds timeout
    When I send the request
    Then the response status should be 504
    And the response should contain error "Request timeout"
    And partial results should not be returned
    And the request should be logged for analysis

  @api @error
  Scenario: Handle rate limiting
    Given I have exceeded the API rate limit
    When I send a request to any admin endpoint
    Then the response status should be 429
    And the response should contain error "Rate limit exceeded"
    And the response should include rate limit headers:
      | header                | description              |
      | X-RateLimit-Limit     | Maximum requests allowed |
      | X-RateLimit-Remaining | Requests remaining       |
      | X-RateLimit-Reset     | When limit resets        |
    And the response should include retry-after header

  @api @error
  Scenario: Handle malformed JSON in request body
    When I send a POST request with malformed JSON
    Then the response status should be 400
    And the response should contain error "Invalid JSON in request body"
    And the response should indicate the parse error location
