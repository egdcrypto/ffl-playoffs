@authentication @authorization @security @envoy @oauth @jwt @pat @rbac
Feature: Authentication and Authorization
  As a platform operator
  I want to implement secure authentication and authorization
  So that users can securely access resources based on their roles and ownership

  Background:
    Given the Envoy proxy is configured for authentication
    And Google OAuth is configured as the identity provider
    And the JWT validation service is running
    And the RBAC policy engine is active

  # ==========================================
  # Google OAuth Authentication
  # ==========================================

  @oauth @login
  Scenario: Initiate Google OAuth login flow
    Given I am an unauthenticated user
    When I request to login via Google OAuth
    Then I should be redirected to Google's authorization endpoint
    And the redirect should include:
      | parameter     | value                          |
      | client_id     | configured_google_client_id    |
      | redirect_uri  | platform_callback_url          |
      | scope         | openid email profile           |
      | response_type | code                           |
      | state         | csrf_protection_token          |

  @oauth @callback
  Scenario: Handle successful OAuth callback
    Given I have authenticated with Google
    When Google redirects back with authorization code
    Then the platform should exchange the code for tokens
    And I should receive a JWT access token
    And I should receive a refresh token
    And my user profile should be created or updated
    And I should be redirected to the application

  @oauth @token-exchange
  Scenario: Exchange OAuth code for tokens
    Given I have received an authorization code from Google
    When the token exchange is performed
    Then Google should return:
      | token_type    | description           |
      | access_token  | Google access token   |
      | id_token      | OpenID Connect token  |
      | refresh_token | For token renewal     |
    And platform should validate the id_token
    And platform should issue its own JWT

  @oauth @user-info
  Scenario: Extract user information from OAuth tokens
    Given I have completed OAuth authentication
    When user information is extracted
    Then the following should be captured:
      | field         | source                |
      | email         | id_token              |
      | name          | id_token              |
      | picture       | id_token              |
      | google_id     | id_token sub claim    |
    And user record should be created if new
    And user record should be updated if existing

  @oauth @invalid-state
  Scenario: Reject OAuth callback with invalid state
    Given I initiated OAuth login with state token "abc123"
    When callback is received with state token "xyz789"
    Then the callback should be rejected
    And error "Invalid state parameter" should be returned
    And the attempt should be logged as potential CSRF attack

  @oauth @expired-code
  Scenario: Handle expired authorization code
    Given the authorization code has expired
    When token exchange is attempted
    Then the exchange should fail
    And error should indicate code expiration
    And user should be prompted to re-authenticate

  @oauth @account-linking
  Scenario: Link Google account to existing user
    Given I have an existing account with email "user@example.com"
    And I authenticate with Google using same email
    When OAuth flow completes
    Then Google identity should be linked to existing account
    And I should have access to my existing data
    And account linking should be logged

  # ==========================================
  # JWT Token Management
  # ==========================================

  @jwt @issuance
  Scenario: Issue JWT access token after authentication
    Given I have successfully authenticated
    When JWT is issued
    Then token should contain claims:
      | claim     | description                    |
      | sub       | User unique identifier         |
      | email     | User email address             |
      | roles     | User assigned roles            |
      | iat       | Token issued at timestamp      |
      | exp       | Token expiration timestamp     |
      | iss       | Token issuer identifier        |
    And token should be signed with RS256
    And token expiration should be 1 hour

  @jwt @validation
  Scenario: Validate JWT on API request
    Given I have a valid JWT access token
    When I make an API request with the token
    Then Envoy should intercept the request
    And JWT signature should be validated
    And token expiration should be checked
    And issuer should be verified
    And request should proceed if valid

  @jwt @expired
  Scenario: Reject expired JWT token
    Given my JWT token has expired
    When I make an API request with the expired token
    Then the request should be rejected with 401 Unauthorized
    And error should indicate "Token expired"
    And I should be prompted to refresh or re-authenticate

  @jwt @invalid-signature
  Scenario: Reject JWT with invalid signature
    Given I have a JWT with tampered signature
    When I make an API request with the tampered token
    Then the request should be rejected with 401 Unauthorized
    And error should indicate "Invalid token signature"
    And the attempt should be logged as security event

  @jwt @refresh
  Scenario: Refresh JWT using refresh token
    Given my access token is about to expire
    And I have a valid refresh token
    When I request token refresh
    Then a new access token should be issued
    And the new token should have fresh expiration
    And the refresh token may be rotated
    And old access token should become invalid

  @jwt @refresh-expired
  Scenario: Handle expired refresh token
    Given my refresh token has expired
    When I request token refresh
    Then the refresh should fail
    And error should indicate "Refresh token expired"
    And I should be required to re-authenticate

  @jwt @revocation
  Scenario: Revoke JWT tokens on logout
    Given I am logged in with valid tokens
    When I logout
    Then my access token should be revoked
    And my refresh token should be revoked
    And revoked tokens should be added to blacklist
    And subsequent requests with these tokens should fail

  @jwt @claims-extraction
  Scenario: Extract claims from JWT for authorization
    Given I have a valid JWT with roles claim
    When request is processed by authorization layer
    Then claims should be extracted:
      | claim   | usage                        |
      | sub     | Identify the user            |
      | roles   | Determine permissions        |
      | email   | Audit logging                |
    And claims should be available to downstream services

  # ==========================================
  # Personal Access Token (PAT) Authentication
  # ==========================================

  @pat @creation
  Scenario: Create personal access token
    Given I am authenticated as a valid user
    When I create a new PAT with:
      | field       | value                      |
      | name        | CI/CD Integration Token    |
      | scopes      | read:worlds, write:entities|
      | expiration  | 90 days                    |
    Then a new PAT should be generated
    And the token should be displayed once
    And the token should be securely hashed for storage
    And token metadata should be recorded

  @pat @authentication
  Scenario: Authenticate API request with PAT
    Given I have a valid PAT
    When I make an API request with header "Authorization: Bearer <pat>"
    Then the PAT should be validated
    And my user identity should be resolved
    And my scopes should be extracted
    And the request should proceed

  @pat @scopes
  Scenario: Enforce PAT scope restrictions
    Given my PAT has scope "read:worlds" only
    When I attempt to create a new world
    Then the request should be rejected with 403 Forbidden
    And error should indicate "Insufficient scope"
    And the scope violation should be logged

  @pat @expiration
  Scenario: Reject expired PAT
    Given my PAT has expired
    When I make an API request with the expired PAT
    Then the request should be rejected with 401 Unauthorized
    And error should indicate "Token expired"
    And I should generate a new PAT

  @pat @revocation
  Scenario: Revoke personal access token
    Given I have an active PAT "CI/CD Token"
    When I revoke the token
    Then the token should be immediately invalidated
    And subsequent requests with this token should fail
    And revocation should be logged

  @pat @listing
  Scenario: List active personal access tokens
    Given I have multiple PATs
    When I list my PATs
    Then I should see:
      | field         | visibility   |
      | name          | visible      |
      | scopes        | visible      |
      | created_at    | visible      |
      | last_used     | visible      |
      | expires_at    | visible      |
      | token_value   | hidden       |
    And I should be able to revoke any token

  @pat @rate-limiting
  Scenario: Apply rate limits to PAT usage
    Given my PAT has rate limit of 1000 requests/hour
    When I exceed the rate limit
    Then requests should be rejected with 429 Too Many Requests
    And rate limit reset time should be provided
    And rate limit status should be in response headers

  @pat @audit
  Scenario: Audit PAT usage
    Given my PAT is used for API access
    When requests are made
    Then each request should be logged with:
      | field           | value                    |
      | token_name      | CI/CD Integration Token  |
      | user_id         | owning user id           |
      | endpoint        | API endpoint called      |
      | timestamp       | request time             |
      | ip_address      | source IP                |

  @pat @regeneration
  Scenario: Regenerate PAT before expiration
    Given my PAT "API Token" will expire soon
    When I regenerate the token
    Then a new token value should be issued
    And the old token should be invalidated
    And token name and scopes should be preserved
    And new expiration should be set

  # ==========================================
  # Role-Based Access Control (RBAC)
  # ==========================================

  @rbac @roles
  Scenario: Define platform roles
    Given the RBAC system is configured
    Then the following roles should exist:
      | role          | description                          |
      | admin         | Full platform administration         |
      | world_creator | Can create and manage worlds         |
      | world_editor  | Can edit assigned worlds             |
      | viewer        | Read-only access to assigned worlds  |
      | api_user      | Programmatic API access              |

  @rbac @assignment
  Scenario: Assign role to user
    Given I am an admin user
    When I assign role "world_creator" to user "alice@example.com"
    Then user should have the role
    And role assignment should be logged
    And user should gain associated permissions

  @rbac @permission-check
  Scenario: Check permission before action
    Given user has role "viewer"
    When user attempts to delete a world
    Then permission check should evaluate:
      | check           | result   |
      | has_role_admin  | false    |
      | has_role_creator| false    |
      | can_delete_world| false    |
    And action should be denied with 403 Forbidden

  @rbac @multiple-roles
  Scenario: Handle user with multiple roles
    Given user has roles "world_editor" and "api_user"
    When permission is evaluated
    Then permissions from all roles should be combined
    And user should have union of all permissions
    And most permissive access should apply

  @rbac @role-hierarchy
  Scenario: Apply role hierarchy
    Given role hierarchy is configured:
      | role          | inherits_from    |
      | admin         | world_creator    |
      | world_creator | world_editor     |
      | world_editor  | viewer           |
    When admin user accesses resource
    Then admin should have all inherited permissions
    And permission evaluation should follow hierarchy

  @rbac @custom-roles
  Scenario: Create custom role
    Given I am an admin
    When I create custom role:
      | field         | value                    |
      | name          | content_moderator        |
      | permissions   | read:*, moderate:content |
      | description   | Content moderation role  |
    Then custom role should be created
    And role should be assignable to users
    And permissions should be enforced

  @rbac @role-removal
  Scenario: Remove role from user
    Given user "bob@example.com" has role "world_creator"
    When I remove the role
    Then user should no longer have the role
    And associated permissions should be revoked
    And role removal should be logged

  @rbac @conditional-permissions
  Scenario: Apply conditional permissions
    Given role has conditional permission:
      | permission      | condition                    |
      | edit:world      | owner = current_user         |
      | view:world      | world.visibility = public    |
    When user accesses resource
    Then conditions should be evaluated
    And access should be granted only if conditions met

  # ==========================================
  # Resource Ownership
  # ==========================================

  @ownership @creation
  Scenario: Assign ownership on resource creation
    Given I am user "alice@example.com"
    When I create a new world
    Then I should be assigned as owner
    And ownership record should be created:
      | field         | value              |
      | resource_type | world              |
      | resource_id   | new_world_id       |
      | owner_id      | alice_user_id      |
      | created_at    | current_timestamp  |

  @ownership @access
  Scenario: Grant owner full access to resource
    Given I own world "my-fantasy-world"
    When I access the world
    Then I should have full permissions:
      | permission    | granted |
      | read          | yes     |
      | write         | yes     |
      | delete        | yes     |
      | share         | yes     |
      | transfer      | yes     |

  @ownership @transfer
  Scenario: Transfer resource ownership
    Given I own world "shared-world"
    When I transfer ownership to "bob@example.com"
    Then Bob should become the new owner
    And I should lose owner permissions
    And transfer should be logged
    And Bob should be notified

  @ownership @shared-access
  Scenario: Grant shared access to resource
    Given I own world "collaborative-world"
    When I share with user "charlie@example.com":
      | permission | granted |
      | read       | yes     |
      | write      | yes     |
      | delete     | no      |
    Then Charlie should have specified permissions
    And I should retain ownership
    And share should be logged

  @ownership @revoke-access
  Scenario: Revoke shared access
    Given "charlie@example.com" has shared access to my world
    When I revoke Charlie's access
    Then Charlie should lose all permissions
    And revocation should be immediate
    And Charlie should be notified

  @ownership @inheritance
  Scenario: Child resources inherit parent ownership
    Given I own world "parent-world"
    When I create entity in the world
    Then entity should inherit world ownership
    And I should have full access to entity
    And ownership chain should be maintained

  @ownership @admin-override
  Scenario: Admin can access any resource
    Given admin user needs to access user's world
    When admin accesses the resource
    Then access should be granted
    And admin access should be logged
    And resource owner should be notified if configured

  # ==========================================
  # Envoy Proxy Authentication
  # ==========================================

  @envoy @filter-chain
  Scenario: Configure Envoy authentication filter chain
    Given Envoy proxy is the API gateway
    Then authentication filters should be configured:
      | filter              | order | purpose                    |
      | jwt_authn           | 1     | Validate JWT tokens        |
      | ext_authz           | 2     | External authorization     |
      | rbac                | 3     | Role-based access control  |
    And filters should process in order
    And request should fail on any filter rejection

  @envoy @jwt-filter
  Scenario: Envoy validates JWT token
    Given request contains JWT in Authorization header
    When Envoy JWT filter processes request
    Then JWT should be validated against JWKS
    And claims should be extracted to metadata
    And invalid tokens should be rejected
    And valid requests should continue to next filter

  @envoy @ext-authz
  Scenario: External authorization for complex policies
    Given request requires complex authorization
    When ext_authz filter is invoked
    Then authorization service should receive:
      | data            | description              |
      | jwt_claims      | User identity and roles  |
      | request_path    | API endpoint             |
      | request_method  | HTTP method              |
      | headers         | Relevant headers         |
    And authorization decision should be returned

  @envoy @rate-limit
  Scenario: Apply rate limiting at Envoy
    Given rate limiting is configured
    When requests exceed configured limit
    Then Envoy should reject excess requests
    And 429 response should be returned
    And rate limit headers should be included

  @envoy @circuit-breaker
  Scenario: Circuit breaker for auth service
    Given external auth service is unhealthy
    When circuit breaker triggers
    Then requests may fail open or closed per config
    And circuit state should be monitored
    And recovery should be automatic when service healthy

  @envoy @tls
  Scenario: Enforce TLS for all connections
    Given Envoy is configured for TLS
    When non-TLS request is received
    Then request should be rejected or upgraded
    And all traffic should be encrypted
    And certificate validation should be enforced

  # ==========================================
  # Session Management
  # ==========================================

  @session @creation
  Scenario: Create session on successful authentication
    Given I have authenticated successfully
    When session is created
    Then session should contain:
      | field           | value                    |
      | session_id      | unique identifier        |
      | user_id         | authenticated user id    |
      | created_at      | current timestamp        |
      | expires_at      | session timeout          |
      | ip_address      | client IP                |
      | user_agent      | client user agent        |

  @session @validation
  Scenario: Validate session on each request
    Given I have an active session
    When I make an API request
    Then session should be validated:
      | check           | action                   |
      | exists          | continue or reject       |
      | not_expired     | continue or expire       |
      | ip_match        | optional security check  |
    And session last_activity should be updated

  @session @expiration
  Scenario: Expire inactive session
    Given session inactivity timeout is 30 minutes
    And my session has been inactive for 35 minutes
    When I make an API request
    Then session should be expired
    And I should receive 401 Unauthorized
    And I should be required to re-authenticate

  @session @concurrent
  Scenario: Manage concurrent sessions
    Given I am logged in from two devices
    When I view my active sessions
    Then I should see both sessions:
      | device          | location        | last_active |
      | Chrome/Windows  | New York, US    | 5 min ago   |
      | Safari/iPhone   | Boston, US      | 2 hours ago |
    And I should be able to revoke any session

  @session @logout
  Scenario: Terminate session on logout
    Given I have an active session
    When I logout
    Then session should be terminated
    And session token should be invalidated
    And logout should be logged
    And I should be redirected to login page

  # ==========================================
  # Security Events and Audit
  # ==========================================

  @audit @authentication-events
  Scenario: Log authentication events
    Given authentication events occur
    Then the following should be logged:
      | event_type          | data_captured                    |
      | login_success       | user, timestamp, IP, method      |
      | login_failure       | email, timestamp, IP, reason     |
      | logout              | user, timestamp, session_duration|
      | token_refresh       | user, timestamp                  |
      | password_reset      | user, timestamp, IP              |

  @audit @authorization-events
  Scenario: Log authorization events
    Given authorization decisions are made
    Then the following should be logged:
      | event_type          | data_captured                    |
      | access_granted      | user, resource, permission       |
      | access_denied       | user, resource, reason           |
      | role_assigned       | user, role, assigned_by          |
      | role_removed        | user, role, removed_by           |

  @audit @security-alerts
  Scenario: Generate security alerts
    Given suspicious activity is detected
    When alert thresholds are exceeded:
      | threshold                      | action           |
      | 5 failed logins in 5 minutes   | alert + lockout  |
      | login from new country         | alert + verify   |
      | unusual API pattern            | alert            |
    Then security team should be notified
    And incident should be created

  @audit @compliance-report
  Scenario: Generate compliance audit report
    Given audit data is collected
    When compliance report is requested
    Then report should include:
      | section              | content                    |
      | authentication_stats | Login success/failure rates|
      | access_patterns      | Resource access summary    |
      | security_incidents   | Alerts and resolutions     |
      | user_activity        | Active users and sessions  |

  # ==========================================
  # Multi-Factor Authentication
  # ==========================================

  @mfa @enrollment
  Scenario: Enroll in multi-factor authentication
    Given I want to enable MFA
    When I initiate MFA enrollment
    Then I should be presented with options:
      | method            | description              |
      | authenticator_app | TOTP via app             |
      | sms               | Code via SMS             |
      | email             | Code via email           |
    And I should complete setup for chosen method
    And backup codes should be generated

  @mfa @verification
  Scenario: Verify MFA during login
    Given I have MFA enabled
    And I have entered correct password
    When MFA verification is required
    Then I should be prompted for MFA code
    And code should be validated
    And login should complete on valid code
    And login should fail on invalid code

  @mfa @backup-codes
  Scenario: Use backup code when MFA device unavailable
    Given I cannot access my MFA device
    When I use a backup code
    Then code should be validated
    And code should be marked as used
    And I should be prompted to update MFA settings

  @mfa @recovery
  Scenario: Recover account when MFA lost
    Given I have lost access to MFA device
    When I request MFA recovery
    Then identity verification should be required
    And admin approval may be needed
    And MFA should be reset on verification
    And security event should be logged

  # ==========================================
  # Error Handling and Edge Cases
  # ==========================================

  @error-handling @invalid-credentials
  Scenario: Handle invalid credentials
    Given I provide incorrect password
    When login is attempted
    Then login should fail
    And error should not reveal which credential was wrong
    And failed attempt should be rate-limited
    And attempt should be logged

  @error-handling @account-locked
  Scenario: Handle locked account
    Given my account has been locked due to suspicious activity
    When I attempt to login
    Then login should be rejected
    And I should be informed of the lockout
    And unlock instructions should be provided
    And support contact should be available

  @error-handling @token-blacklist
  Scenario: Handle blacklisted token
    Given my token has been blacklisted
    When I make an API request
    Then request should be rejected
    And I should be required to re-authenticate
    And blacklist hit should be logged

  @edge-case @clock-skew
  Scenario: Handle clock skew in token validation
    Given server clocks may have slight skew
    When JWT expiration is validated
    Then small clock skew should be tolerated
    And grace period should be configurable
    And significant skew should still fail

  @edge-case @concurrent-auth
  Scenario: Handle concurrent authentication attempts
    Given I am logging in from two devices simultaneously
    When both attempts succeed
    Then separate sessions should be created
    And no race condition should occur
    And both sessions should be valid

  @edge-case @provider-outage
  Scenario: Handle identity provider outage
    Given Google OAuth is temporarily unavailable
    When user attempts OAuth login
    Then appropriate error should be shown
    And alternative login methods should be suggested if available
    And outage should be logged for monitoring
