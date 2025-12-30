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

  # ============================================
  # INVITATION LIFECYCLE - CREATION
  # ============================================

  Scenario: Super admin invites admin with custom expiration
    Given the super admin is authenticated
    When the super admin sends an admin invitation to "newadmin@example.com" with 14 day expiration
    Then an AdminInvitation record is created
    And the invitation expires in 14 days
    And the invitation link includes the custom expiration

  Scenario: Super admin invites admin with personalized message
    Given the super admin is authenticated
    When the super admin sends an admin invitation to "newadmin@example.com" with message:
      """
      Welcome to FFL Playoffs! We'd like you to help manage our fantasy leagues.
      Please accept this invitation to get started.
      """
    Then the invitation email includes the personalized message
    And the email maintains professional formatting

  Scenario: Super admin creates bulk admin invitations
    Given the super admin is authenticated
    When the super admin sends bulk invitations to:
      | email                   |
      | admin1@example.com      |
      | admin2@example.com      |
      | admin3@example.com      |
    Then 3 AdminInvitation records are created
    And each invitation has unique token
    And 3 invitation emails are sent
    And the super admin receives a summary of sent invitations

  Scenario: Bulk invitation with some invalid emails
    Given the super admin is authenticated
    When the super admin sends bulk invitations to:
      | email                   |
      | valid@example.com       |
      | invalid-email           |
      | another@example.com     |
    Then 2 AdminInvitation records are created for valid emails
    And "invalid-email" is rejected with validation error
    And the response includes success and failure details

  Scenario: Prevent duplicate pending invitations
    Given an admin invitation exists for "duplicate@example.com" with status "PENDING"
    When the super admin sends another invitation to "duplicate@example.com"
    Then the request is rejected with error "INVITATION_ALREADY_EXISTS"
    And no new invitation is created
    And the existing invitation remains unchanged

  Scenario: Allow re-invitation after expiration
    Given an admin invitation exists for "expired@example.com"
    And the invitation status is "EXPIRED"
    When the super admin sends a new invitation to "expired@example.com"
    Then a new AdminInvitation record is created
    And the old invitation is marked as "SUPERSEDED"
    And a new invitation email is sent

  Scenario: Allow re-invitation after rejection
    Given an admin invitation exists for "rejected@example.com"
    And the invitation status is "DECLINED"
    When the super admin sends a new invitation to "rejected@example.com"
    Then a new AdminInvitation record is created
    And a new invitation email is sent

  # ============================================
  # INVITATION LIFECYCLE - ACCEPTANCE
  # ============================================

  Scenario: User accepts invitation within grace period after expiration
    Given an admin invitation exists for "grace@example.com"
    And the invitation expired 2 hours ago
    And the system has a 24-hour grace period configured
    When the user clicks the invitation link
    And authenticates with Google OAuth matching "grace@example.com"
    Then the invitation is accepted
    And a new Admin user is created
    And a warning is logged about grace period acceptance

  Scenario: Track invitation acceptance metadata
    Given an admin invitation exists for "tracked@example.com"
    When the user accepts the invitation
    Then the acceptance record includes:
      | acceptedAt          | current timestamp    |
      | acceptedFromIP      | user's IP address    |
      | userAgent           | browser user agent   |
      | acceptanceMethod    | GOOGLE_OAUTH         |

  Scenario: User must verify email before admin access
    Given email verification is required for admins
    And an admin invitation exists for "verify@example.com"
    When the user accepts the invitation via Google OAuth
    And Google OAuth email is verified
    Then the user is granted immediate admin access
    And no additional email verification is required

  Scenario: Handle OAuth failure during acceptance
    Given an admin invitation exists for "oauthfail@example.com"
    When the user clicks the invitation link
    And Google OAuth authentication fails
    Then the invitation remains in "PENDING" status
    And the user is shown an error message
    And the user can retry the OAuth flow

  # ============================================
  # INVITATION LIFECYCLE - DECLINE AND CANCEL
  # ============================================

  Scenario: User explicitly declines admin invitation
    Given an admin invitation exists for "decline@example.com"
    When the user clicks "Decline Invitation" link
    Then the invitation status changes to "DECLINED"
    And the super admin is notified of the declined invitation
    And the user cannot use this invitation link anymore

  Scenario: User declines with reason
    Given an admin invitation exists for "decline@example.com"
    When the user declines with reason "Not interested in admin responsibilities"
    Then the decline reason is recorded
    And the super admin can view the decline reason

  Scenario: Super admin cancels pending invitation
    Given an admin invitation exists for "cancel@example.com" with status "PENDING"
    When the super admin cancels the invitation
    Then the invitation status changes to "CANCELLED"
    And the invitation link becomes invalid
    And an optional cancellation notification is sent to the invitee

  Scenario: Super admin cannot cancel accepted invitation
    Given an admin invitation exists for "accepted@example.com"
    And the invitation status is "ACCEPTED"
    When the super admin attempts to cancel the invitation
    Then the request is rejected with error "CANNOT_CANCEL_ACCEPTED"
    And the invitation status remains "ACCEPTED"

  # ============================================
  # INVITATION LIFECYCLE - RESEND AND EXTEND
  # ============================================

  Scenario: Super admin resends pending invitation
    Given an admin invitation exists for "resend@example.com"
    And the invitation has not been opened
    When the super admin resends the invitation
    Then a new invitation email is sent
    And the invitation token remains the same
    And the expiration is extended by 7 days
    And resend count is incremented

  Scenario: Limit invitation resends
    Given an admin invitation has been resent 3 times
    When the super admin attempts to resend again
    Then the request is rejected with error "MAX_RESENDS_EXCEEDED"
    And the super admin is advised to create a new invitation

  Scenario: Super admin extends invitation expiration
    Given an admin invitation exists for "extend@example.com"
    And the invitation expires in 2 days
    When the super admin extends the invitation by 7 days
    Then the new expiration is 9 days from now
    And the invitee is notified of the extension

  Scenario: Track invitation email opens
    Given an admin invitation exists for "track@example.com"
    When the invitation email is opened
    Then the openedAt timestamp is recorded
    And the email open count is incremented
    And the super admin can see email engagement metrics

  # ============================================
  # ROLE MANAGEMENT - ADMIN HIERARCHY
  # ============================================

  Scenario: Define admin permission levels
    Given the system supports admin permission levels:
      | level         | permissions                                      |
      | FULL_ADMIN    | create leagues, manage players, configure scoring|
      | LEAGUE_ADMIN  | manage assigned leagues only                     |
      | READ_ONLY_ADMIN| view all leagues and players, no modifications  |
    When the super admin invites an admin with level "LEAGUE_ADMIN"
    Then the invitation specifies the permission level
    And the accepted admin has only league management permissions

  Scenario: Super admin assigns specific leagues to admin
    Given an ADMIN user "leagueadmin@example.com" exists
    When the super admin assigns leagues to the admin:
      | leagueId | leagueName      |
      | 1        | NFL 2024 Pool   |
      | 2        | Super Bowl 2025 |
    Then the admin can only manage assigned leagues
    And the admin cannot see other leagues
    And the admin cannot create new leagues

  Scenario: Super admin promotes admin to full access
    Given an ADMIN user exists with LEAGUE_ADMIN level
    When the super admin promotes them to FULL_ADMIN
    Then the admin can now create new leagues
    And the admin can manage all leagues
    And an audit entry records the promotion

  Scenario: Super admin demotes admin to limited access
    Given an ADMIN user exists with FULL_ADMIN level
    And they own 3 leagues
    When the super admin demotes them to LEAGUE_ADMIN for 2 specific leagues
    Then the admin retains access to 2 specified leagues
    And the admin loses access to 1 league
    And the orphaned league is reassigned or flagged

  Scenario: Prevent admin from modifying own permissions
    Given an ADMIN user is authenticated
    When the admin attempts to modify their own permission level
    Then the request is blocked with 403 Forbidden
    And only SUPER_ADMIN can modify admin permissions

  # ============================================
  # ROLE MANAGEMENT - TRANSITIONS
  # ============================================

  Scenario: Admin requests voluntary demotion to player
    Given an ADMIN user "volunteer@example.com" exists
    When the admin requests to relinquish admin privileges
    Then a demotion request is created
    And the super admin is notified
    And the super admin must approve the demotion

  Scenario: Super admin approves admin demotion
    Given an admin demotion request exists
    When the super admin approves the demotion
    Then the admin role is changed to PLAYER
    And their leagues are handled according to policy
    And the former admin is notified of the change

  Scenario: Handle admin with active leagues during demotion
    Given an ADMIN user owns 2 active leagues with ongoing games
    When the super admin demotes the admin
    Then the demotion is blocked with "ACTIVE_LEAGUES_EXIST"
    And the super admin must transfer or pause the leagues first

  Scenario: Transfer league ownership during admin demotion
    Given an ADMIN user owns league "2024 Playoffs"
    When the super admin demotes the admin and transfers league to "newadmin@example.com"
    Then the league ownership is transferred
    And all players are notified of the ownership change
    And the former admin retains player membership if enrolled

  Scenario Outline: Role transition validation
    Given a user with role <currentRole>
    When transitioning to role <targetRole>
    Then the transition is <result>

    Examples:
      | currentRole  | targetRole   | result   |
      | PLAYER       | ADMIN        | allowed  |
      | ADMIN        | PLAYER       | allowed  |
      | ADMIN        | SUPER_ADMIN  | blocked  |
      | SUPER_ADMIN  | ADMIN        | blocked  |
      | PLAYER       | SUPER_ADMIN  | blocked  |

  # ============================================
  # SECURITY - TOKEN VALIDATION
  # ============================================

  Scenario: Invitation token format validation
    Given an invitation token must be:
      | requirement         | value              |
      | length              | 64 characters      |
      | characters          | alphanumeric only  |
      | entropy             | cryptographically secure |
    When generating a new invitation token
    Then the token meets all requirements
    And the token is URL-safe

  Scenario: Prevent token enumeration attacks
    Given a user attempts to guess invitation tokens
    When they submit 10 invalid tokens within 1 minute
    Then their IP is temporarily blocked
    And subsequent requests return generic "Invalid invitation" error
    And security team is alerted

  Scenario: Token single-use enforcement
    Given an admin invitation was accepted using token "abc123..."
    When another user attempts to use the same token
    Then the request is rejected with "TOKEN_ALREADY_USED"
    And no account is created
    And the attempt is logged for security review

  Scenario: Secure token transmission
    Given an invitation link is generated
    Then the token is transmitted only over HTTPS
    And the token is never logged in plaintext
    And the token hash is stored, not the raw token

  Scenario: Token hash collision prevention
    Given the system generates invitation tokens
    When generating 10000 tokens
    Then no hash collisions should occur
    And each token produces a unique hash

  # ============================================
  # SECURITY - RATE LIMITING
  # ============================================

  Scenario: Rate limit invitation creation
    Given rate limiting is configured at 10 invitations per hour
    When the super admin sends 11 invitations within 1 hour
    Then the 11th invitation is rejected with "RATE_LIMIT_EXCEEDED"
    And the super admin is informed of the wait time

  Scenario: Rate limit invitation acceptance attempts
    Given rate limiting is configured at 5 attempts per 15 minutes
    When a user fails acceptance 5 times
    Then subsequent attempts are blocked for 15 minutes
    And the user sees "Too many attempts, please wait"

  Scenario: Rate limit per IP address
    Given multiple invitation attempts from the same IP
    When 20 attempts occur within 5 minutes
    Then the IP is temporarily blocked
    And legitimate users from that IP are affected
    And a CAPTCHA challenge is presented after cooldown

  Scenario: Bypass rate limiting for super admin emergency
    Given rate limiting is active
    And an emergency situation requires bulk invitations
    When the super admin uses emergency bypass with 2FA confirmation
    Then rate limiting is temporarily suspended
    And all actions are logged as emergency operations

  # ============================================
  # SECURITY - AUDIT AND LOGGING
  # ============================================

  Scenario: Comprehensive invitation audit trail
    Given an admin invitation lifecycle completes
    Then the audit log contains:
      | event                | timestamp | actor      | details           |
      | INVITATION_CREATED   | t1        | superadmin | email, expiration |
      | EMAIL_SENT           | t2        | system     | email provider    |
      | EMAIL_OPENED         | t3        | invitee    | IP, user agent    |
      | LINK_CLICKED         | t4        | invitee    | IP, user agent    |
      | OAUTH_INITIATED      | t5        | invitee    | provider          |
      | OAUTH_COMPLETED      | t6        | invitee    | email match       |
      | INVITATION_ACCEPTED  | t7        | invitee    | user ID created   |

  Scenario: Log failed invitation attempts
    Given an invitation acceptance fails
    Then the failure is logged with:
      | failureReason        | EMAIL_MISMATCH       |
      | attemptedEmail       | wrong@example.com    |
      | expectedEmail        | correct@example.com  |
      | timestamp            | current time         |
      | ipAddress            | user's IP            |

  Scenario: Super admin exports audit logs
    Given audit logs exist for the past 30 days
    When the super admin exports audit logs
    Then a CSV file is generated with all entries
    And sensitive data is masked appropriately
    And the export is logged as an audit event itself

  Scenario: Real-time security alerts
    Given security monitoring is enabled
    When suspicious activity is detected:
      | activity                           |
      | Multiple failed attempts from IP   |
      | Token enumeration pattern          |
      | Unusual geographic access          |
    Then an immediate alert is sent to super admin
    And the incident is flagged for review

  Scenario: Audit log retention policy
    Given audit logs older than 2 years exist
    When the retention policy is enforced
    Then logs older than 2 years are archived
    And archived logs are compressed and stored securely
    And a record of the archival is maintained

  # ============================================
  # SECURITY - MULTI-FACTOR CONSIDERATIONS
  # ============================================

  Scenario: Require additional verification for admin creation
    Given enhanced security is enabled
    When a user accepts an admin invitation
    Then they must complete additional verification:
      | step | verification              |
      | 1    | Google OAuth              |
      | 2    | Email confirmation click  |
      | 3    | Phone number verification |
    And admin access is granted only after all steps

  Scenario: Super admin requires 2FA for sensitive operations
    Given 2FA is enabled for super admin
    When the super admin attempts to:
      | operation                 |
      | Revoke admin access       |
      | Bulk invite admins        |
      | Export audit logs         |
      | Modify rate limits        |
    Then 2FA confirmation is required
    And the operation proceeds only after verification

  Scenario: Admin session security
    Given an admin user is authenticated
    Then the session has:
      | property             | value         |
      | maxDuration          | 8 hours       |
      | idleTimeout          | 30 minutes    |
      | refreshRequired      | every 1 hour  |
      | ipBinding            | optional      |
    And suspicious session changes trigger re-authentication

  # ============================================
  # INVITATION ANALYTICS
  # ============================================

  Scenario: View invitation funnel analytics
    Given 100 admin invitations have been sent
    When the super admin views invitation analytics
    Then they see the conversion funnel:
      | stage              | count | rate |
      | Sent               | 100   | 100% |
      | Opened             | 75    | 75%  |
      | Link Clicked       | 50    | 50%  |
      | OAuth Started      | 45    | 45%  |
      | Accepted           | 40    | 40%  |
      | Declined           | 5     | 5%   |
      | Expired            | 55    | 55%  |

  Scenario: Track invitation response time
    Given invitations have been accepted over time
    When viewing response time analytics
    Then the dashboard shows:
      | metric                    | value    |
      | averageTimeToAccept       | 2.5 days |
      | medianTimeToAccept        | 1 day    |
      | fastestAcceptance         | 5 minutes|
      | slowestBeforeExpiry       | 6.9 days |

  Scenario: Identify invitation bottlenecks
    Given invitation analytics show low conversion
    When analyzing bottlenecks
    Then the system identifies:
      | bottleneck              | suggestion                    |
      | Low email open rate     | Check spam folder placement   |
      | OAuth drop-off          | Review OAuth flow UX          |
      | Email mismatch failures | Allow email change option     |

  Scenario: Compare invitation sources
    Given invitations have been sent with different methods
    When comparing sources
    Then the report shows:
      | source          | sent | accepted | rate |
      | Manual single   | 50   | 25       | 50%  |
      | Bulk import     | 100  | 35       | 35%  |
      | API integration | 25   | 20       | 80%  |

  # ============================================
  # NOTIFICATION PREFERENCES
  # ============================================

  Scenario: Super admin configures notification preferences
    Given the super admin accesses notification settings
    When they configure preferences:
      | event                      | email | push | slack |
      | Invitation accepted        | yes   | yes  | yes   |
      | Invitation declined        | yes   | no   | yes   |
      | Invitation expired         | no    | no   | yes   |
      | Security alert             | yes   | yes  | yes   |
    Then notifications are sent according to preferences

  Scenario: Invitee receives reminder notification
    Given an admin invitation has been pending for 3 days
    When the reminder schedule triggers
    Then the invitee receives a reminder email
    And the reminder count is incremented
    And maximum 3 reminders are sent before expiration

  Scenario: Configure reminder schedule
    Given the super admin configures reminder schedule:
      | reminder | days before expiry |
      | 1st      | 3 days             |
      | 2nd      | 1 day              |
      | 3rd      | 6 hours            |
    Then reminders are sent according to schedule

  Scenario: Opt-out of invitation reminders
    Given an invitee clicks "unsubscribe from reminders"
    Then no further reminders are sent
    And the invitation remains valid until expiry
    And the opt-out is recorded

  # ============================================
  # EDGE CASES AND ERROR HANDLING
  # ============================================

  Scenario: Handle email delivery failure
    Given an admin invitation is created
    When the invitation email fails to send
    Then the invitation remains in "PENDING" status
    And the delivery failure is recorded
    And the super admin is notified of the failure
    And a retry is automatically attempted

  Scenario: Handle concurrent invitation acceptance
    Given an admin invitation exists for "race@example.com"
    When two browser sessions attempt to accept simultaneously
    Then only one acceptance succeeds
    And the other receives "INVITATION_ALREADY_ACCEPTED"
    And no duplicate admin accounts are created

  Scenario: Handle OAuth provider outage
    Given Google OAuth is temporarily unavailable
    When a user attempts to accept an invitation
    Then a friendly error message is displayed
    And the invitation remains valid
    And the user is advised to try again later

  Scenario: Handle email provider rate limiting
    Given the email provider rate limits sending
    When a bulk invitation exceeds provider limits
    Then emails are queued for delayed sending
    And the super admin is informed of the delay
    And all emails are eventually sent

  Scenario: Validate email domain restrictions
    Given the system is configured to allow only corporate emails
    When the super admin invites "user@gmail.com"
    Then the invitation is rejected with "INVALID_EMAIL_DOMAIN"
    And only @company.com emails are accepted

  Scenario: Handle unicode in email addresses
    Given the super admin invites "用户@example.com"
    Then the invitation is created with proper encoding
    And the email is sent with correct character encoding
    And the invitation link works correctly

  Scenario: Handle very long email addresses
    Given an email address with 254 characters (maximum valid length)
    When the super admin sends an invitation to this address
    Then the invitation is created successfully
    And the email is sent correctly

  Scenario: Prevent invitation to system addresses
    Given protected email addresses exist:
      | email                    |
      | admin@fflplayoffs.com    |
      | support@fflplayoffs.com  |
      | noreply@fflplayoffs.com  |
    When the super admin attempts to invite these addresses
    Then the invitations are rejected with "PROTECTED_ADDRESS"

  # ============================================
  # API AND INTEGRATION
  # ============================================

  Scenario: Create invitation via API
    Given a valid API key with admin scope
    When POST /api/v1/admin/invitations with:
      """
      {
        "email": "apiinvite@example.com",
        "expirationDays": 7,
        "permissionLevel": "FULL_ADMIN"
      }
      """
    Then response status is 201 Created
    And response includes invitation ID and status
    And the invitation email is sent

  Scenario: List pending invitations via API
    Given 5 pending admin invitations exist
    When GET /api/v1/admin/invitations?status=PENDING
    Then response status is 200 OK
    And response includes array of 5 invitations
    And each invitation shows: id, email, status, createdAt, expiresAt

  Scenario: Cancel invitation via API
    Given an admin invitation with ID "inv123" exists
    When DELETE /api/v1/admin/invitations/inv123
    Then response status is 200 OK
    And the invitation status is "CANCELLED"

  Scenario: Webhook notification on invitation events
    Given a webhook URL is configured for invitation events
    When an invitation is accepted
    Then a webhook POST is sent to the configured URL
    And the payload includes event type and invitation details
    And the webhook includes a signature for verification

  Scenario: API rate limiting per key
    Given API rate limits are configured
    When an API key exceeds 100 requests per minute
    Then subsequent requests return 429 Too Many Requests
    And Retry-After header indicates wait time

  # ============================================
  # COMPLIANCE AND PRIVACY
  # ============================================

  Scenario: GDPR-compliant invitation data handling
    Given GDPR compliance is required
    Then invitation records include:
      | field               | purpose                    |
      | email               | invitation delivery        |
      | ipAddress           | security, masked after 30d |
      | acceptedAt          | audit trail                |
      | consentTimestamp    | legal compliance           |
    And data is automatically purged after retention period

  Scenario: Right to be forgotten for declined invitations
    Given an invitee declined an invitation
    When they request data deletion
    Then their email is anonymized in records
    And invitation history is marked as "DELETED_BY_REQUEST"
    And the deletion is logged for compliance

  Scenario: Export personal data for invitee
    Given an invitee requests their data
    When the data export is generated
    Then it includes all invitation-related data:
      | Invitation details    |
      | Email communications  |
      | Access attempts       |
      | Current role status   |
    And the export is provided in machine-readable format

  Scenario: Data residency compliance
    Given data residency requirements exist
    When invitations are created for users in EU
    Then invitation data is stored in EU-region servers
    And audit logs comply with local regulations

  # ============================================
  # DISASTER RECOVERY
  # ============================================

  Scenario: Recover from invitation data loss
    Given a database failure occurs
    When the system recovers from backup
    Then pending invitations are restored
    And expired invitations during outage are handled gracefully
    And affected invitees receive apology/extension emails

  Scenario: Handle invitation during maintenance
    Given system maintenance is scheduled
    When a user tries to accept an invitation during maintenance
    Then a maintenance page is displayed
    And the invitation link remains valid
    And a retry after maintenance is suggested

  Scenario: Invitation system failover
    Given the primary invitation service fails
    When failover to secondary service occurs
    Then invitation processing continues
    And no invitations are lost
    And the failover is logged for review
