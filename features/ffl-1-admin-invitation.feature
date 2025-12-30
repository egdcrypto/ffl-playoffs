@admin @invitation @super-admin @authentication
Feature: Admin Invitation by Super Admin
  As a super admin
  I want to invite users to become admins
  So that I can delegate league management responsibilities

  Background:
    Given a SUPER_ADMIN user exists in the system
    And the email service is configured and operational
    And Google OAuth is configured for authentication

  # =============================================================================
  # INVITATION CREATION
  # =============================================================================

  @invitation @create
  Scenario: Super admin invites a new admin
    Given the super admin is authenticated
    When the super admin sends an admin invitation to "newadmin@example.com"
    Then an AdminInvitation record is created with status "PENDING"
    And an invitation email is sent to "newadmin@example.com"
    And the email contains a unique invitation link
    And the invitation link expires in 7 days
    And the invitation includes:
      | Field               | Description                        |
      | invitationId        | Unique identifier                  |
      | invitedEmail        | Target email address               |
      | invitedBy           | Super admin ID                     |
      | createdAt           | Timestamp of creation              |
      | expiresAt           | Expiration timestamp               |
      | status              | PENDING                            |

  @invitation @create @validation
  Scenario: Validate email format for invitation
    Given the super admin is authenticated
    When the super admin sends an admin invitation to "invalid-email"
    Then the invitation is rejected with error "INVALID_EMAIL_FORMAT"
    And no AdminInvitation record is created
    And no email is sent

  @invitation @create @duplicate
  Scenario: Prevent duplicate pending invitations
    Given the super admin is authenticated
    And an admin invitation exists for "pending@example.com" with status "PENDING"
    When the super admin sends another invitation to "pending@example.com"
    Then the invitation is rejected with error "INVITATION_ALREADY_EXISTS"
    And no new AdminInvitation record is created
    And no duplicate email is sent

  @invitation @create @already-admin
  Scenario: Cannot invite existing admin
    Given the super admin is authenticated
    And a user with email "existing@example.com" already has role ADMIN
    When the super admin sends an admin invitation to "existing@example.com"
    Then the invitation is rejected with error "USER_ALREADY_ADMIN"
    And no AdminInvitation record is created

  @invitation @create @resend
  Scenario: Resend invitation for expired invitation
    Given the super admin is authenticated
    And an admin invitation exists for "expired@example.com" with status "EXPIRED"
    When the super admin sends a new invitation to "expired@example.com"
    Then the old invitation status is changed to "SUPERSEDED"
    And a new AdminInvitation record is created with status "PENDING"
    And a new invitation email is sent

  @invitation @email
  Scenario: Invitation email contains required information
    Given the super admin is authenticated
    When the super admin sends an admin invitation to "newadmin@example.com"
    Then the invitation email should contain:
      | Content             | Description                        |
      | Subject             | "Admin Invitation - FFL Playoffs"  |
      | Invitation link     | Unique secure URL                  |
      | Inviter info        | Super admin name                   |
      | Expiration date     | When invitation expires            |
      | Instructions        | How to accept the invitation       |

  @invitation @link
  Scenario: Invitation link is secure and unique
    Given the super admin is authenticated
    When the super admin sends an admin invitation to "secure@example.com"
    Then the invitation link should:
      | Requirement         | Description                        |
      | Use HTTPS           | Secure protocol                    |
      | Include token       | Unique cryptographic token         |
      | Be single-use       | Invalidated after use              |
      | Not expose email    | Email not in URL                   |

  # =============================================================================
  # INVITATION ACCEPTANCE - NEW USER
  # =============================================================================

  @acceptance @new-user
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

  @acceptance @new-user @profile
  Scenario: New admin profile is populated from Google
    Given an admin invitation exists for "google@example.com"
    And the user's Google profile contains:
      | Field           | Value                              |
      | email           | google@example.com                 |
      | name            | John Smith                         |
      | picture         | https://google.com/photo.jpg       |
      | googleId        | 123456789                          |
    When the user accepts the invitation via Google OAuth
    Then the User record should contain:
      | Field           | Value                              |
      | email           | google@example.com                 |
      | displayName     | John Smith                         |
      | profilePicture  | https://google.com/photo.jpg       |
      | googleId        | 123456789                          |
      | role            | ADMIN                              |

  @acceptance @new-user @session
  Scenario: New admin receives authenticated session
    Given an admin invitation exists for "session@example.com"
    When the user accepts the invitation via Google OAuth
    Then the user receives an authenticated session
    And the session includes:
      | Field           | Description                        |
      | accessToken     | JWT access token                   |
      | refreshToken    | Token for session renewal          |
      | userId          | User identifier                    |
      | role            | ADMIN                              |
      | expiresAt       | Session expiration                 |

  # =============================================================================
  # INVITATION ACCEPTANCE - EXISTING USER
  # =============================================================================

  @acceptance @existing-user
  Scenario: Existing user accepts admin invitation
    Given a user with email "existinguser@example.com" already exists with role PLAYER
    And an admin invitation exists for "existinguser@example.com"
    When the user clicks the invitation link
    And authenticates with their existing Google account
    Then the user's role is upgraded from PLAYER to ADMIN
    And the AdminInvitation status changes to "ACCEPTED"
    And the user retains their existing player league memberships
    And the user can now create and manage leagues

  @acceptance @existing-user @preserve-data
  Scenario: Existing user data is preserved on upgrade
    Given a user with email "player@example.com" exists with role PLAYER
    And the user is a member of 3 leagues
    And the user has game history and statistics
    And an admin invitation exists for "player@example.com"
    When the user accepts the invitation
    Then the user's role is upgraded to ADMIN
    And all 3 league memberships are preserved
    And all game history and statistics are preserved
    And the user gains admin capabilities in addition to player capabilities

  @acceptance @existing-user @existing-admin
  Scenario: Existing admin cannot accept duplicate invitation
    Given a user with email "admin@example.com" already has role ADMIN
    And somehow an admin invitation exists for "admin@example.com"
    When the user attempts to accept the invitation
    Then the acceptance is rejected with "ALREADY_ADMIN"
    And no changes are made to the user account
    And the invitation status changes to "INVALID"

  # =============================================================================
  # INVITATION ERRORS
  # =============================================================================

  @error @email-mismatch
  Scenario: Admin invitation with mismatched email
    Given an admin invitation exists for "invited@example.com"
    When a user authenticates with Google using email "different@example.com"
    Then the invitation is rejected with error "EMAIL_MISMATCH"
    And no user account is created
    And the AdminInvitation status remains "PENDING"
    And the user is shown an error message explaining the mismatch

  @error @expired
  Scenario: Expired admin invitation
    Given an admin invitation exists for "expired@example.com"
    And the invitation was created 8 days ago
    When the user clicks the invitation link
    Then the invitation is rejected with error "INVITATION_EXPIRED"
    And no user account is created
    And the user is prompted to request a new invitation
    And the invitation status changes to "EXPIRED"

  @error @already-used
  Scenario: Invitation link used twice
    Given an admin invitation exists for "used@example.com"
    And the invitation has been accepted
    When someone clicks the invitation link again
    Then the request is rejected with error "INVITATION_ALREADY_USED"
    And no changes are made

  @error @revoked
  Scenario: Revoked invitation cannot be accepted
    Given an admin invitation exists for "revoked@example.com"
    And the invitation has been revoked by super admin
    When the user attempts to accept the invitation
    Then the acceptance is rejected with error "INVITATION_REVOKED"
    And no user account is created
    And the user is informed the invitation is no longer valid

  @error @invalid-token
  Scenario: Invalid invitation token
    Given a user attempts to access an invitation with an invalid token
    When the user clicks the malformed invitation link
    Then the request is rejected with error "INVALID_INVITATION_TOKEN"
    And no authentication flow is initiated
    And the attempt is logged for security review

  @error @oauth-failure
  Scenario: Google OAuth failure during acceptance
    Given an admin invitation exists for "oauth@example.com"
    When the user clicks the invitation link
    And Google OAuth authentication fails
    Then the user is shown an authentication error
    And the invitation status remains "PENDING"
    And the user can retry the authentication

  # =============================================================================
  # INVITATION MANAGEMENT
  # =============================================================================

  @management @list
  Scenario: Super admin views all pending invitations
    Given 5 pending admin invitations exist
    And 3 accepted admin invitations exist
    And 2 expired admin invitations exist
    When the super admin requests all invitations
    Then the system returns all 10 invitations
    And each invitation includes:
      | Field               | Description                        |
      | invitationId        | Unique identifier                  |
      | invitedEmail        | Target email address               |
      | status              | PENDING/ACCEPTED/EXPIRED           |
      | createdAt           | When created                       |
      | expiresAt           | When expires                       |

  @management @filter
  Scenario: Super admin filters invitations by status
    Given multiple invitations exist with various statuses
    When the super admin filters invitations by status "PENDING"
    Then only pending invitations are returned
    And the count matches pending invitation count

  @management @revoke
  Scenario: Super admin revokes pending invitation
    Given an admin invitation exists for "torevoke@example.com" with status "PENDING"
    When the super admin revokes the invitation
    Then the invitation status changes to "REVOKED"
    And the invitation link becomes invalid
    And no notification is sent to the invited user

  @management @extend
  Scenario: Super admin extends invitation expiration
    Given an admin invitation exists for "extend@example.com"
    And the invitation expires in 1 day
    When the super admin extends the invitation by 7 days
    Then the expiration date is updated
    And the invitation remains valid for 8 more days
    And optionally a new email is sent with updated link

  # =============================================================================
  # ADMIN ACCESS AND MANAGEMENT
  # =============================================================================

  @admin @view
  Scenario: Super admin views all admins
    Given 5 ADMIN users exist in the system
    When the super admin requests the list of all admins
    Then the system returns all 5 admin users
    And each admin record includes:
      | Field               | Description                        |
      | id                  | User ID                            |
      | email               | Admin email                        |
      | name                | Display name                       |
      | googleId            | Google account ID                  |
      | createdAt           | Account creation date              |
      | leaguesOwned        | Count of owned leagues             |
      | lastActive          | Last activity timestamp            |

  @admin @revoke
  Scenario: Super admin revokes admin access
    Given an ADMIN user "admin@example.com" exists
    And the admin owns 2 leagues
    When the super admin revokes admin privileges for "admin@example.com"
    Then the user's role is changed to PLAYER
    And the user's owned leagues are marked as "ADMIN_REVOKED"
    And the user can no longer create new leagues
    And the user retains player access to leagues they are a member of

  @admin @revoke @notification
  Scenario: Revoked admin receives notification
    Given an ADMIN user "notify@example.com" exists
    When the super admin revokes admin privileges
    Then the former admin receives an email notification
    And the notification explains:
      | Information         | Description                        |
      | Action taken        | Admin access revoked               |
      | Effective date      | When revocation takes effect       |
      | Player access       | What access remains                |
      | Contact info        | How to appeal or inquire           |

  @admin @revoke @leagues
  Scenario: Revoked admin's leagues are handled appropriately
    Given an ADMIN user owns 3 active leagues with players
    When the super admin revokes admin privileges
    Then each league should be:
      | Status              | Description                        |
      | Flagged             | Marked as ADMIN_REVOKED            |
      | Frozen              | No new configurations allowed      |
      | Playable            | Existing games continue            |
      | Transferable        | Can be transferred to another admin|

  @admin @transfer
  Scenario: Super admin transfers league ownership
    Given an ADMIN user "old@example.com" owns a league
    And another ADMIN user "new@example.com" exists
    When the super admin transfers league ownership to "new@example.com"
    Then the league owner is changed to the new admin
    And the old admin loses management access
    And all players in the league are notified
    And the transfer is logged in audit trail

  # =============================================================================
  # AUTHORIZATION AND ACCESS CONTROL
  # =============================================================================

  @authorization @super-admin-only
  Scenario: Super admin cannot be created through invitation
    Given the super admin attempts to create a SUPER_ADMIN invitation
    Then the system rejects the request with error "INVALID_ROLE"
    And the invitation is not created
    And SUPER_ADMIN can only be bootstrapped via configuration

  @authorization @admin-cannot-invite
  Scenario: Admin cannot invite other admins
    Given a user with ADMIN role exists
    When the admin attempts to send an admin invitation
    Then the request is blocked with 403 Forbidden
    And no AdminInvitation is created
    And only SUPER_ADMIN can invite admins

  @authorization @player-cannot-invite
  Scenario: Player cannot invite admins
    Given a user with PLAYER role exists
    When the player attempts to send an admin invitation
    Then the request is blocked with 403 Forbidden
    And no AdminInvitation is created

  @authorization @unauthenticated
  Scenario: Unauthenticated user cannot create invitations
    Given no user is authenticated
    When a request is made to create an admin invitation
    Then the request is blocked with 401 Unauthorized
    And no invitation is created

  # =============================================================================
  # AUDIT AND LOGGING
  # =============================================================================

  @audit @activities
  Scenario: Super admin audits admin activities
    Given 3 ADMIN users exist
    And the admins have created leagues and invited players
    When the super admin requests audit logs for admin activities
    Then the system returns all admin actions with timestamps
    And the audit log includes:
      | Activity Type       | Details                            |
      | League creation     | League ID, name, date              |
      | Player invitations  | Invited email, league, date        |
      | Config changes      | What changed, old/new values       |
      | Login events        | Login time, IP address             |
    And the audit log includes the admin's id and email for each action

  @audit @invitation-history
  Scenario: Track invitation lifecycle in audit log
    Given an admin invitation is created
    When the invitation goes through its lifecycle
    Then the audit log should record:
      | Event               | Details                            |
      | Created             | By super admin, timestamp          |
      | Email sent          | Delivery status                    |
      | Clicked             | When link was accessed             |
      | Accepted/Rejected   | Outcome and reason                 |

  @audit @security
  Scenario: Log security-relevant events
    Given invitation-related activities occur
    When security events happen
    Then the following should be logged:
      | Event               | Severity | Details                    |
      | Invalid token       | WARNING  | Attempted token, IP        |
      | Email mismatch      | INFO     | Expected vs actual email   |
      | Multiple failures   | WARNING  | Count, pattern             |
      | Successful accept   | INFO     | New admin details          |

  @audit @export
  Scenario: Export audit logs
    Given audit logs exist for a date range
    When the super admin exports audit logs
    Then the export should include:
      | Format              | Availability                       |
      | CSV                 | Downloadable file                  |
      | JSON                | API response                       |
      | PDF                 | Formatted report                   |
    And exports are themselves logged for audit

  # =============================================================================
  # RATE LIMITING AND SECURITY
  # =============================================================================

  @security @rate-limit
  Scenario: Rate limit invitation creation
    Given the super admin is authenticated
    When the super admin attempts to create more than 10 invitations per hour
    Then subsequent invitations are rejected with error "RATE_LIMIT_EXCEEDED"
    And the rate limit resets after one hour

  @security @rate-limit-acceptance
  Scenario: Rate limit invitation acceptance attempts
    Given an admin invitation exists
    When more than 5 acceptance attempts occur within 10 minutes
    Then the invitation is temporarily locked
    And further attempts return "TOO_MANY_ATTEMPTS"
    And the super admin is notified of suspicious activity

  @security @token-security
  Scenario: Invitation token security requirements
    Given an admin invitation is created
    Then the invitation token should:
      | Requirement         | Description                        |
      | Length              | At least 32 characters             |
      | Randomness          | Cryptographically random           |
      | Non-guessable       | Not sequential or predictable      |
      | Hashed storage      | Stored as hash, not plaintext      |

  @security @brute-force
  Scenario: Detect brute force attacks on invitations
    Given multiple invalid token attempts from same IP
    When the threshold is exceeded
    Then the IP is temporarily blocked
    And a security alert is generated
    And the incident is logged for review

  # =============================================================================
  # NOTIFICATIONS
  # =============================================================================

  @notification @invitation-sent
  Scenario: Notification when invitation is sent
    Given the super admin sends an invitation
    Then the super admin receives confirmation
    And the confirmation includes:
      | Information         | Description                        |
      | Recipient email     | Who was invited                    |
      | Expiration          | When invitation expires            |
      | Status link         | Link to track invitation           |

  @notification @invitation-accepted
  Scenario: Notification when invitation is accepted
    Given an admin invitation is accepted
    Then the super admin receives notification
    And the notification includes:
      | Information         | Description                        |
      | New admin email     | Who accepted                       |
      | Acceptance time     | When accepted                      |
      | Admin dashboard     | Link to admin management           |

  @notification @invitation-expired
  Scenario: Notification before invitation expires
    Given an admin invitation will expire in 24 hours
    When the expiration warning is triggered
    Then the super admin receives a reminder
    And the reminder offers option to extend or resend

  # =============================================================================
  # ERROR HANDLING
  # =============================================================================

  @error @email-service
  Scenario: Handle email service failure
    Given the email service is unavailable
    When the super admin sends an invitation
    Then the invitation record is created with status "PENDING_EMAIL"
    And the super admin is notified of email delivery issue
    And the system retries email delivery
    And the invitation link is still valid when email eventually sends

  @error @database-failure
  Scenario: Handle database failure during invitation creation
    Given a database error occurs during invitation creation
    When the super admin sends an invitation
    Then the request fails with error "SERVICE_UNAVAILABLE"
    And no partial invitation record is left
    And the super admin can retry immediately

  @error @oauth-provider
  Scenario: Handle Google OAuth provider unavailable
    Given Google OAuth is temporarily unavailable
    When a user attempts to accept an invitation
    Then the user is shown an appropriate error message
    And the invitation remains valid for retry
    And the user is given alternative contact information
