@authentication @authorization @security @envoy @oauth
Feature: Authentication and Authorization
  As a system
  I want to secure all API access through Envoy with Google OAuth and PAT authentication
  So that only authorized users and services can access the API

  Background:
    Given the API listens only on localhost:8080
    And the auth service listens only on localhost:9191
    And Envoy sidecar listens on the pod IP (externally accessible)
    And all external requests must go through Envoy
    And Google OAuth is configured with valid client credentials

  # =============================================================================
  # ENVOY SECURITY ARCHITECTURE
  # =============================================================================

  @envoy @architecture
  Scenario: Direct API access is blocked
    When a client attempts to access the API directly on localhost:8080
    Then the request is blocked by network policies
    And only requests from Envoy on localhost are allowed

  @envoy @architecture
  Scenario: Unauthenticated request is blocked at Envoy
    When a client sends a request without an Authorization header
    Then Envoy calls the auth service
    And the auth service returns 403 Forbidden
    And Envoy rejects the request with 401 Unauthorized
    And the request never reaches the main API

  @envoy @architecture
  Scenario: Envoy forwards authenticated user context
    Given a user has authenticated successfully
    When Envoy forwards the request to the API
    Then the following headers are included:
      | Header          | Description                        |
      | X-User-Id       | Authenticated user ID              |
      | X-User-Email    | User's email address               |
      | X-User-Role     | User's role (PLAYER/ADMIN/etc)     |
      | X-Request-Id    | Unique request identifier          |
      | X-Forwarded-For | Original client IP                 |

  @envoy @health
  Scenario: Envoy health checks are unauthenticated
    When Envoy performs a health check on "/health"
    Then the request bypasses authentication
    And the API returns health status
    And no authentication headers are required

  @envoy @rate-limiting
  Scenario: Envoy enforces rate limiting
    Given a client makes requests rapidly
    When the client exceeds 100 requests per minute
    Then Envoy returns 429 Too Many Requests
    And the response includes Retry-After header
    And the request does not reach the auth service

  # =============================================================================
  # GOOGLE OAUTH AUTHENTICATION FLOW
  # =============================================================================

  @oauth @valid
  Scenario: User authenticates with valid Google JWT token
    Given a user has authenticated with Google OAuth
    And received a valid Google JWT token
    When the user sends a request with header "Authorization: Bearer <google-jwt>"
    Then Envoy extracts the token and calls the auth service
    And the auth service validates the JWT signature using Google's public keys
    And the auth service validates the JWT is not expired
    And the auth service validates the issuer is "accounts.google.com"
    And the auth service extracts the user email and Google ID from JWT claims
    And the auth service queries the database for the user by Google ID
    And the auth service finds the user with role "PLAYER"
    And the auth service returns HTTP 200 with headers:
      | X-User-Id    | <user-id>    |
      | X-User-Email | <email>      |
      | X-User-Role  | PLAYER       |
      | X-Google-Id  | <google-id>  |
    And Envoy forwards the request to the API with user context headers
    And the API processes the pre-authenticated request

  @oauth @validation @expired
  Scenario: Google JWT with expired token is rejected
    Given a Google JWT token has expired
    When the user sends a request with the expired token
    Then the auth service returns 403 Forbidden
    And Envoy rejects the request with 401 Unauthorized
    And the error response includes:
      | Field         | Value                              |
      | error         | token_expired                      |
      | message       | Authentication token has expired   |

  @oauth @validation @signature
  Scenario: Google JWT with invalid signature is rejected
    Given a Google JWT token has an invalid signature
    When the user sends a request with the invalid token
    Then the auth service returns 403 Forbidden
    And Envoy rejects the request with 401 Unauthorized
    And the attempt is logged for security review

  @oauth @validation @issuer
  Scenario: Google JWT with invalid issuer is rejected
    Given a JWT token has issuer "malicious.com"
    When the user sends a request with the token
    Then the auth service validates the issuer
    And the auth service returns 403 Forbidden
    And Envoy rejects the request with 401 Unauthorized

  @oauth @validation @audience
  Scenario: Google JWT with wrong audience is rejected
    Given a Google JWT token has audience for different application
    When the user sends a request with the token
    Then the auth service validates the audience claim
    And the auth service returns 403 Forbidden
    And the error indicates "invalid_audience"

  @oauth @claims
  Scenario: Extract and validate JWT claims
    Given a valid Google JWT token
    When the auth service processes the token
    Then the following claims are extracted:
      | Claim         | Description                        |
      | sub           | Google user ID (Subject)           |
      | email         | User's email address               |
      | email_verified| Whether email is verified          |
      | name          | User's display name                |
      | picture       | Profile picture URL                |
      | iat           | Issued at timestamp                |
      | exp           | Expiration timestamp               |
    And unverified emails are rejected

  @oauth @keys
  Scenario: Auth service refreshes Google public keys
    Given Google's public keys are cached
    When the cached keys expire
    Then the auth service fetches new keys from Google
    And the keys are cached for the configured duration
    And token validation continues without interruption

  @oauth @account-creation
  Scenario: User account creation via Google OAuth
    Given a new user has never logged in before
    And the user has a pending player invitation for "newplayer@example.com"
    When the user authenticates with Google OAuth
    And Google returns email "newplayer@example.com" and Google ID "google-123"
    Then the auth service creates a new user account
    And the user is linked to Google ID "google-123"
    And the user email is set to "newplayer@example.com"
    And the user name is extracted from Google profile
    And the user is assigned role "PLAYER"
    And the user is added to the invited league

  @oauth @account-creation @no-invitation
  Scenario: User without invitation cannot create account
    Given no invitation exists for "uninvited@example.com"
    When the user authenticates with Google OAuth
    And Google returns email "uninvited@example.com"
    Then the auth service returns 403 Forbidden
    And the error message is "No pending invitation found"
    And no user account is created

  @oauth @account-linking
  Scenario: Link Google account to existing user
    Given a user exists with email "existing@example.com"
    And the user has no Google ID linked
    And a pending invitation exists for "existing@example.com"
    When the user authenticates with Google OAuth
    Then the existing user is linked to the Google ID
    And no duplicate user is created
    And the user can now authenticate with Google

  # =============================================================================
  # PERSONAL ACCESS TOKEN (PAT) AUTHENTICATION FLOW
  # =============================================================================

  @pat @valid
  Scenario: Service authenticates with valid PAT
    Given a PAT exists with token "pat_abc123xyz"
    And the PAT has scope "WRITE"
    And the PAT is not expired
    And the PAT is not revoked
    When a service sends a request with header "Authorization: Bearer pat_abc123xyz"
    Then Envoy extracts the token and calls the auth service
    And the auth service detects the PAT prefix "pat_"
    And the auth service hashes the token and queries the PersonalAccessToken table
    And the auth service finds the PAT record
    And the auth service validates the PAT is not expired
    And the auth service validates the PAT is not revoked
    And the auth service returns HTTP 200 with headers:
      | X-Service-Id | <service-name> |
      | X-PAT-Scope  | WRITE          |
      | X-PAT-Id     | <pat-id>       |
    And the auth service updates the PAT lastUsedAt timestamp
    And Envoy forwards the request to the API with service context headers
    And the API processes the pre-authenticated service request

  @pat @expired
  Scenario: Expired PAT is rejected
    Given a PAT exists but has expired
    When a service sends a request with the expired PAT
    Then the auth service returns 403 Forbidden
    And Envoy rejects the request with 401 Unauthorized
    And the error response includes:
      | Field         | Value                              |
      | error         | pat_expired                        |
      | message       | Personal access token has expired  |

  @pat @revoked
  Scenario: Revoked PAT is rejected
    Given a PAT exists but has been revoked
    When a service sends a request with the revoked PAT
    Then the auth service returns 403 Forbidden
    And Envoy rejects the request with 401 Unauthorized
    And the revocation reason is logged

  @pat @invalid
  Scenario: Invalid PAT token is rejected
    Given no PAT exists with token "pat_invalid"
    When a service sends a request with token "pat_invalid"
    Then the auth service queries the database and finds no match
    And the auth service returns 403 Forbidden
    And Envoy rejects the request with 401 Unauthorized
    And the invalid attempt is logged

  @pat @creation
  Scenario: Create new PAT for service
    Given an admin user is authenticated
    When the admin creates a new PAT with:
      | Field         | Value                              |
      | name          | CI/CD Pipeline                     |
      | scope         | WRITE                              |
      | expiresIn     | 90 days                            |
    Then a new PAT record is created
    And the token value is returned only once
    And the token is hashed before storage
    And the PAT is associated with the creating admin

  @pat @scopes
  Scenario: PAT scope validation
    Given PATs can have the following scopes:
      | Scope       | Permissions                        |
      | READ_ONLY   | Read access to player endpoints    |
      | WRITE       | Read/write access to admin endpoints |
      | ADMIN       | Full access including super admin  |
    When a PAT is created with a specific scope
    Then access is restricted to that scope's permissions

  @pat @rotation
  Scenario: Rotate PAT before expiration
    Given a PAT exists and will expire in 7 days
    When the admin rotates the PAT
    Then a new token value is generated
    And the old token is immediately revoked
    And the new token has a fresh expiration date
    And the PAT ID and name remain the same

  @pat @listing
  Scenario: List all PATs for admin
    Given an admin has created 5 PATs
    When the admin requests their PAT list
    Then all 5 PATs are returned
    And each PAT includes:
      | Field         | Description                        |
      | id            | PAT identifier                     |
      | name          | Descriptive name                   |
      | scope         | Permission scope                   |
      | createdAt     | Creation timestamp                 |
      | expiresAt     | Expiration timestamp               |
      | lastUsedAt    | Last usage timestamp               |
    And the token values are NOT returned

  @pat @deletion
  Scenario: Delete PAT
    Given a PAT exists with id "pat-123"
    When the admin deletes the PAT
    Then the PAT is permanently deleted
    And subsequent requests with that token fail
    And the deletion is logged in audit trail

  # =============================================================================
  # ROLE-BASED ACCESS CONTROL (RBAC)
  # =============================================================================

  @rbac @roles
  Scenario Outline: Endpoint access control by role
    Given a user is authenticated with role "<user-role>"
    When the user accesses endpoint "<endpoint>"
    Then the request is "<result>"

    Examples:
      | user-role   | endpoint              | result   |
      | SUPER_ADMIN | /api/v1/superadmin/*  | allowed  |
      | SUPER_ADMIN | /api/v1/admin/*       | allowed  |
      | SUPER_ADMIN | /api/v1/player/*      | allowed  |
      | ADMIN       | /api/v1/superadmin/*  | rejected |
      | ADMIN       | /api/v1/admin/*       | allowed  |
      | ADMIN       | /api/v1/player/*      | allowed  |
      | PLAYER      | /api/v1/superadmin/*  | rejected |
      | PLAYER      | /api/v1/admin/*       | rejected |
      | PLAYER      | /api/v1/player/*      | allowed  |

  @rbac @pat-scope
  Scenario Outline: PAT scope-based access control
    Given a PAT is authenticated with scope "<pat-scope>"
    When the PAT accesses endpoint "<endpoint>"
    Then the request is "<result>"

    Examples:
      | pat-scope  | endpoint              | result   |
      | ADMIN      | /api/v1/superadmin/*  | allowed  |
      | ADMIN      | /api/v1/admin/*       | allowed  |
      | ADMIN      | /api/v1/service/*     | allowed  |
      | WRITE      | /api/v1/superadmin/*  | rejected |
      | WRITE      | /api/v1/admin/*       | allowed  |
      | WRITE      | /api/v1/service/*     | allowed  |
      | READ_ONLY  | /api/v1/superadmin/*  | rejected |
      | READ_ONLY  | /api/v1/admin/*       | rejected |
      | READ_ONLY  | /api/v1/player/*      | allowed  |

  @rbac @public
  Scenario: Public endpoints do not require authentication
    When a client accesses endpoint "/api/v1/public/health"
    Then Envoy allows the request without authentication
    And the request reaches the API

  @rbac @role-hierarchy
  Scenario: Role hierarchy is enforced
    Given the role hierarchy is:
      | Role        | Inherits From                      |
      | SUPER_ADMIN | ADMIN                              |
      | ADMIN       | PLAYER                             |
      | PLAYER      | None                               |
    When a SUPER_ADMIN accesses player endpoints
    Then access is granted through role inheritance
    And no explicit PLAYER role is required

  @rbac @method-specific
  Scenario: HTTP method-specific authorization
    Given an endpoint allows different methods by role:
      | Endpoint            | GET    | POST   | PUT    | DELETE |
      | /api/v1/leagues     | PLAYER | ADMIN  | ADMIN  | ADMIN  |
      | /api/v1/teams       | PLAYER | PLAYER | PLAYER | ADMIN  |
    When a PLAYER sends a DELETE request to /api/v1/leagues
    Then the request is rejected with 403 Forbidden
    When a PLAYER sends a GET request to /api/v1/leagues
    Then the request is allowed

  # =============================================================================
  # RESOURCE OWNERSHIP VALIDATION
  # =============================================================================

  @ownership @leagues
  Scenario: Admin can only access their own leagues
    Given admin "admin1@example.com" owns league "League A"
    And admin "admin2@example.com" owns league "League B"
    When admin1 attempts to access league "League A"
    Then the request is allowed
    When admin1 attempts to access league "League B"
    Then the API validates ownership
    And the request is rejected with 403 Forbidden

  @ownership @teams
  Scenario: Player can only modify their own team selections
    Given player "player1@example.com" has made team selections
    And player "player2@example.com" has made team selections
    When player1 attempts to modify their own selections
    Then the request is allowed
    When player1 attempts to modify player2's selections
    Then the API validates ownership
    And the request is rejected with 403 Forbidden

  @ownership @super-admin-override
  Scenario: Super admin can access any resource
    Given admin "admin1@example.com" owns league "League A"
    And super admin "super@example.com" exists
    When the super admin accesses league "League A"
    Then the request is allowed
    And ownership validation is bypassed for super admin

  @ownership @delegation
  Scenario: Admin can delegate access to specific resources
    Given admin "admin1@example.com" owns league "League A"
    And admin "admin2@example.com" is granted read access to "League A"
    When admin2 attempts to read league "League A"
    Then the request is allowed
    When admin2 attempts to modify league "League A"
    Then the request is rejected with 403 Forbidden

  @ownership @validation-caching
  Scenario: Ownership validation is cached for performance
    Given ownership is validated for a resource
    When the same user accesses the same resource again
    Then the cached ownership result is used
    And no additional database query is made
    And the cache expires after 5 minutes

  # =============================================================================
  # TOKEN REFRESH AND SESSION MANAGEMENT
  # =============================================================================

  @session @google
  Scenario: User session with valid Google token
    Given a user has a valid Google JWT token
    And the token expires in 1 hour
    When the user makes requests over 30 minutes
    Then all requests are authenticated successfully
    When the token expires
    Then subsequent requests are rejected
    And the user must re-authenticate with Google

  @session @refresh
  Scenario: Refresh token flow for extended sessions
    Given a user has an active session
    And the access token is about to expire
    When the client uses the refresh token
    Then a new access token is issued
    And the new token has a fresh expiration
    And the session continues without interruption

  @session @refresh-revocation
  Scenario: Revoke refresh token on logout
    Given a user has an active session with refresh token
    When the user logs out
    Then the refresh token is revoked
    And the access token is invalidated
    And the user must re-authenticate to access resources

  @session @concurrent
  Scenario: Handle concurrent sessions
    Given a user is logged in on Device A
    When the same user logs in on Device B
    Then both sessions remain valid
    And each device has its own access token
    And logout on one device does not affect the other

  @session @forced-logout
  Scenario: Admin forces user logout
    Given a user has active sessions on multiple devices
    When an admin forces logout for the user
    Then all sessions are invalidated
    And all access tokens are revoked
    And the user must re-authenticate on all devices

  @session @pat-tracking
  Scenario: PAT usage tracking
    Given a PAT exists with lastUsedAt = null
    When a service makes 5 requests using the PAT
    Then the lastUsedAt timestamp is updated on the first request
    And the lastUsedAt timestamp is updated on subsequent requests
    And the PAT usage is available for audit

  # =============================================================================
  # MULTI-LEAGUE ACCESS
  # =============================================================================

  @multi-league @player
  Scenario: Player accesses multiple leagues
    Given a player is a member of leagues "League A" and "League B"
    When the player authenticates with Google OAuth
    And requests their list of leagues
    Then the response includes both "League A" and "League B"
    And the player can access data from both leagues

  @multi-league @admin
  Scenario: Admin manages multiple leagues
    Given an admin owns leagues "League 1", "League 2", and "League 3"
    When the admin authenticates
    And requests their list of leagues
    Then the response includes all 3 leagues
    And the admin can manage all their leagues

  @multi-league @context-switching
  Scenario: User switches between league contexts
    Given a player is a member of leagues "League A" and "League B"
    When the player selects league "League A" as active context
    Then subsequent requests are scoped to "League A"
    When the player switches to "League B"
    Then subsequent requests are scoped to "League B"

  @multi-league @cross-league-data
  Scenario: Prevent cross-league data leakage
    Given a player is a member of league "League A"
    And league "League B" exists with different players
    When the player attempts to access league "League B" data
    Then the request is rejected with 403 Forbidden
    And no data from "League B" is exposed

  # =============================================================================
  # SECURITY HEADERS AND PROTECTION
  # =============================================================================

  @security @headers
  Scenario: Security headers are set on all responses
    When any authenticated request is made
    Then the response includes security headers:
      | Header                    | Value                          |
      | X-Content-Type-Options    | nosniff                        |
      | X-Frame-Options           | DENY                           |
      | X-XSS-Protection          | 1; mode=block                  |
      | Strict-Transport-Security | max-age=31536000               |
      | Content-Security-Policy   | default-src 'self'             |

  @security @cors
  Scenario: CORS is properly configured
    Given the allowed origins are configured
    When a cross-origin request is made
    Then CORS headers are validated
    And only allowed origins receive CORS headers
    And credentials are handled securely

  @security @brute-force
  Scenario: Brute force protection for authentication
    Given a client attempts 10 failed authentications
    When the threshold is exceeded
    Then the client IP is temporarily blocked
    And a security alert is generated
    And the block expires after 15 minutes

  @security @token-leakage
  Scenario: Prevent token leakage in logs
    Given authentication tokens are processed
    When logs are written
    Then tokens are masked or excluded from logs
    And sensitive headers are redacted
    And only token metadata is logged

  # =============================================================================
  # AUDIT LOGGING
  # =============================================================================

  @audit @authentication
  Scenario: Log all authentication attempts
    Given authentication events occur
    Then the following are logged:
      | Event               | Details                          |
      | Successful login    | User ID, timestamp, method       |
      | Failed login        | Reason, timestamp, source IP     |
      | Token refresh       | User ID, old/new token metadata  |
      | Logout              | User ID, timestamp               |

  @audit @authorization
  Scenario: Log authorization decisions
    Given authorization checks are performed
    Then the following are logged:
      | Decision            | Details                          |
      | Access granted      | User, resource, action           |
      | Access denied       | User, resource, action, reason   |
      | Role escalation     | Before/after roles               |

  @audit @sensitive-operations
  Scenario: Enhanced logging for sensitive operations
    Given a sensitive operation is performed
    Then additional context is logged:
      | Context             | Description                      |
      | IP address          | Client IP                        |
      | User agent          | Browser/client info              |
      | Request ID          | Correlation ID                   |
      | Session ID          | Current session                  |

  # =============================================================================
  # ERROR CASES
  # =============================================================================

  @error @missing-auth
  Scenario: Missing Authorization header
    When a request is sent without an Authorization header
    Then Envoy returns 401 Unauthorized
    And the error message is "Missing authentication token"

  @error @malformed-auth
  Scenario: Malformed Authorization header
    When a request is sent with header "Authorization: InvalidFormat"
    Then the auth service returns 403 Forbidden
    And Envoy returns 401 Unauthorized

  @error @user-not-found
  Scenario: User not found in database
    Given a valid Google JWT token
    But no user exists with the Google ID from the token
    When the request is sent
    Then the auth service returns 403 Forbidden
    And the error message is "User not found"

  @error @disabled-user
  Scenario: Disabled user cannot authenticate
    Given a user account has been disabled
    When the disabled user attempts to authenticate
    Then the auth service returns 403 Forbidden
    And the error message is "Account is disabled"
    And the user must contact support

  @error @network-policy
  Scenario: Network policy prevents API bypass
    When an attacker attempts to access the API on localhost:8080 from outside the pod
    Then the network policy blocks the connection
    And only Envoy within the pod can access the API

  @error @auth-service-down
  Scenario: Handle auth service unavailability
    Given the auth service is temporarily unavailable
    When a client sends an authenticated request
    Then Envoy returns 503 Service Unavailable
    And the error indicates temporary failure
    And Envoy retries the auth request with backoff

  @error @google-unavailable
  Scenario: Handle Google OAuth unavailability
    Given Google OAuth service is unavailable
    When a user attempts to authenticate with Google
    Then the auth service returns 503 Service Unavailable
    And the error message indicates external dependency failure
    And the user is advised to retry later

  # =============================================================================
  # TESTING AND DEVELOPMENT
  # =============================================================================

  @testing @mock-auth
  Scenario: Mock authentication for testing
    Given the environment is configured for testing
    And mock authentication is enabled
    When a test request includes "X-Test-User-Id" header
    Then the auth service bypasses normal authentication
    And the test user context is used
    And this behavior is disabled in production

  @testing @health-check
  Scenario: Auth service health check
    When a health check request is made to the auth service
    Then the service returns:
      | Field               | Value                          |
      | status              | healthy                        |
      | googleKeysAge       | Time since last key refresh    |
      | databaseConnection  | connected                      |
      | uptime              | Service uptime                 |
