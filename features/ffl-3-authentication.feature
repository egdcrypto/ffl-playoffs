Feature: Authentication and Authorization
  As a system
  I want to secure all API access through Envoy with Google OAuth and PAT authentication
  So that only authorized users and services can access the API

  Background:
    Given the API listens only on localhost:8080
    And the auth service listens only on localhost:9191
    And Envoy sidecar listens on the pod IP (externally accessible)
    And all external requests must go through Envoy

  # Envoy Security Architecture

  Scenario: Direct API access is blocked
    When a client attempts to access the API directly on localhost:8080
    Then the request is blocked by network policies
    And only requests from Envoy on localhost are allowed

  Scenario: Unauthenticated request is blocked at Envoy
    When a client sends a request without an Authorization header
    Then Envoy calls the auth service
    And the auth service returns 403 Forbidden
    And Envoy rejects the request with 401 Unauthorized
    And the request never reaches the main API

  # Google OAuth Authentication Flow

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

  Scenario: Google JWT with expired token is rejected
    Given a Google JWT token has expired
    When the user sends a request with the expired token
    Then the auth service returns 403 Forbidden
    And Envoy rejects the request with 401 Unauthorized

  Scenario: Google JWT with invalid signature is rejected
    Given a Google JWT token has an invalid signature
    When the user sends a request with the invalid token
    Then the auth service returns 403 Forbidden
    And Envoy rejects the request with 401 Unauthorized

  Scenario: Google JWT with invalid issuer is rejected
    Given a JWT token has issuer "malicious.com"
    When the user sends a request with the token
    Then the auth service validates the issuer
    And the auth service returns 403 Forbidden
    And Envoy rejects the request with 401 Unauthorized

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

  # Personal Access Token (PAT) Authentication Flow

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

  Scenario: Expired PAT is rejected
    Given a PAT exists but has expired
    When a service sends a request with the expired PAT
    Then the auth service returns 403 Forbidden
    And Envoy rejects the request with 401 Unauthorized

  Scenario: Revoked PAT is rejected
    Given a PAT exists but has been revoked
    When a service sends a request with the revoked PAT
    Then the auth service returns 403 Forbidden
    And Envoy rejects the request with 401 Unauthorized

  Scenario: Invalid PAT token is rejected
    Given no PAT exists with token "pat_invalid"
    When a service sends a request with token "pat_invalid"
    Then the auth service queries the database and finds no match
    And the auth service returns 403 Forbidden
    And Envoy rejects the request with 401 Unauthorized

  # Role-Based Access Control (RBAC)

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

  Scenario: Public endpoints do not require authentication
    When a client accesses endpoint "/api/v1/public/health"
    Then Envoy allows the request without authentication
    And the request reaches the API

  # Resource Ownership Validation

  Scenario: Admin can only access their own leagues
    Given admin "admin1@example.com" owns league "League A"
    And admin "admin2@example.com" owns league "League B"
    When admin1 attempts to access league "League A"
    Then the request is allowed
    When admin1 attempts to access league "League B"
    Then the API validates ownership
    And the request is rejected with 403 Forbidden

  Scenario: Player can only modify their own team selections
    Given player "player1@example.com" has made team selections
    And player "player2@example.com" has made team selections
    When player1 attempts to modify their own selections
    Then the request is allowed
    When player1 attempts to modify player2's selections
    Then the API validates ownership
    And the request is rejected with 403 Forbidden

  # Token Refresh and Session Management

  Scenario: User session with valid Google token
    Given a user has a valid Google JWT token
    And the token expires in 1 hour
    When the user makes requests over 30 minutes
    Then all requests are authenticated successfully
    When the token expires
    Then subsequent requests are rejected
    And the user must re-authenticate with Google

  Scenario: PAT usage tracking
    Given a PAT exists with lastUsedAt = null
    When a service makes 5 requests using the PAT
    Then the lastUsedAt timestamp is updated on the first request
    And the lastUsedAt timestamp is updated on subsequent requests
    And the PAT usage is available for audit

  # Multi-League Access

  Scenario: Player accesses multiple leagues
    Given a player is a member of leagues "League A" and "League B"
    When the player authenticates with Google OAuth
    And requests their list of leagues
    Then the response includes both "League A" and "League B"
    And the player can access data from both leagues

  Scenario: Admin manages multiple leagues
    Given an admin owns leagues "League 1", "League 2", and "League 3"
    When the admin authenticates
    And requests their list of leagues
    Then the response includes all 3 leagues
    And the admin can manage all their leagues

  # Error Cases

  Scenario: Missing Authorization header
    When a request is sent without an Authorization header
    Then Envoy returns 401 Unauthorized
    And the error message is "Missing authentication token"

  Scenario: Malformed Authorization header
    When a request is sent with header "Authorization: InvalidFormat"
    Then the auth service returns 403 Forbidden
    And Envoy returns 401 Unauthorized

  Scenario: User not found in database
    Given a valid Google JWT token
    But no user exists with the Google ID from the token
    When the request is sent
    Then the auth service returns 403 Forbidden
    And the error message is "User not found"

  Scenario: Network policy prevents API bypass
    When an attacker attempts to access the API on localhost:8080 from outside the pod
    Then the network policy blocks the connection
    And only Envoy within the pod can access the API

  # ============================================
  # GOOGLE OAUTH - ADVANCED FLOWS
  # ============================================

  Scenario: Google OAuth with additional scopes
    Given a user authenticates with Google OAuth
    And requests additional scopes:
      | scope                              |
      | openid                             |
      | email                              |
      | profile                            |
    When the OAuth flow completes
    Then the JWT contains all requested scope claims
    And user profile data is extracted from ID token
    And email verification status is checked

  Scenario: Handle Google token refresh
    Given a user's Google access token expires in 5 minutes
    And the refresh token is still valid
    When the client requests a token refresh
    Then a new access token is issued
    And the new token has fresh expiration
    And the user session continues seamlessly

  Scenario: Google OAuth with prompt=consent
    Given a user has previously authorized the app
    When re-authentication with prompt=consent is required
    Then Google forces the user to re-consent
    And updated permissions are captured
    And the auth flow completes with fresh tokens

  Scenario: Handle Google OAuth callback errors
    Given a user initiates Google OAuth
    When Google returns an error:
      | error             | description                    |
      | access_denied     | User denied permission         |
      | server_error      | Google internal error          |
      | temporarily_unavailable | Rate limited           |
    Then the error is captured and logged
    And an appropriate user message is displayed
    And the user can retry authentication

  Scenario: Validate Google JWT audience claim
    Given a Google JWT token is received
    When validating the token
    Then the aud (audience) claim must match our client ID
    And tokens issued for other applications are rejected
    And audience mismatch returns 403 Forbidden

  Scenario: Handle clock skew in JWT validation
    Given JWT validation uses timestamp claims
    And clock skew of up to 5 minutes is allowed
    When a token's iat claim is 3 minutes in the future
    Then the token is still accepted
    When a token's exp claim was 3 minutes ago
    Then the token is still accepted
    When the skew exceeds 5 minutes
    Then the token is rejected

  Scenario: Refresh Google public keys periodically
    Given Google rotates JWT signing keys periodically
    When the auth service starts
    Then it fetches Google's public keys from JWKS endpoint
    And keys are cached for 24 hours
    And keys are refreshed before cache expires
    And key rotation is handled gracefully

  Scenario: Handle Google account linking
    Given a user authenticated with Google ID "google-123"
    And the same user tries to authenticate with Google ID "google-456"
    But both share the same email "user@example.com"
    When the conflict is detected
    Then the system prevents duplicate accounts
    And the user is prompted to resolve the conflict

  # ============================================
  # PAT - ADVANCED AUTHENTICATION
  # ============================================

  Scenario: PAT token format validation
    Given a PAT must follow the format "pat_<64-char-alphanumeric>"
    When validating token format
    Then "pat_abc123xyz789..." (valid format) is accepted for hash lookup
    And "invalid_token" is rejected immediately without database query
    And "pat_short" is rejected (insufficient length)

  Scenario: PAT hash verification with BCrypt
    Given a PAT "pat_rawtoken123..." is stored as BCrypt hash
    When the auth service receives "pat_rawtoken123..."
    Then the raw token is hashed with BCrypt
    And the hash is compared against stored hash
    And timing-safe comparison is used to prevent timing attacks

  Scenario: PAT with IP restriction
    Given a PAT is configured with allowed IPs:
      | allowedIPs            |
      | 192.168.1.0/24        |
      | 10.0.0.1              |
    When a request comes from IP 192.168.1.100
    Then the IP is validated against allowed list
    And the request is authorized
    When a request comes from IP 203.0.113.50
    Then the IP fails validation
    And the request is rejected with 403 Forbidden

  Scenario: PAT rate limiting per token
    Given a PAT has rate limit of 100 requests per minute
    When the PAT makes 101 requests in 1 minute
    Then the 101st request is rejected with 429 Too Many Requests
    And the Retry-After header indicates wait time
    And rate limit headers are included in response

  Scenario: PAT with specific allowed endpoints
    Given a PAT is configured with endpoint restrictions:
      | allowedEndpoints              |
      | /api/v1/service/sync          |
      | /api/v1/service/health        |
    When the PAT accesses /api/v1/service/sync
    Then the request is authorized
    When the PAT accesses /api/v1/admin/leagues
    Then the request is rejected with 403 Forbidden
    And the error indicates endpoint not allowed for this PAT

  Scenario: PAT automatic rotation reminder
    Given a PAT expires in 7 days
    When the PAT is used for authentication
    Then the response includes header X-PAT-Expires-Soon: true
    And the owner is notified via email about expiration
    And suggestions for rotation are provided

  Scenario: PAT usage analytics
    Given a PAT is used for authentication
    Then the following metrics are tracked:
      | metric           | value                    |
      | lastUsedAt       | current timestamp        |
      | usageCount       | incremented              |
      | lastUsedIP       | request source IP        |
      | lastUsedEndpoint | requested endpoint       |
    And analytics are available via admin API

  Scenario: Emergency PAT revocation
    Given a PAT is suspected to be compromised
    When an admin triggers emergency revocation
    Then the PAT is immediately revoked
    And all active sessions using the PAT are terminated
    And a security alert is generated
    And an audit entry is created

  # ============================================
  # SESSION MANAGEMENT
  # ============================================

  Scenario: Concurrent session handling
    Given a user has an active session on Device A
    When the same user authenticates on Device B
    Then both sessions remain active
    And the session limit of 5 concurrent sessions is enforced
    When a 6th session is created
    Then the oldest session is terminated
    And the user is notified of session termination

  Scenario: Session fixation prevention
    Given a user has a pre-authentication session ID
    When the user successfully authenticates
    Then a new session ID is generated
    And the old session ID is invalidated
    And session fixation attacks are prevented

  Scenario: Session idle timeout
    Given a session has 30-minute idle timeout
    When no activity occurs for 30 minutes
    Then the session is marked as inactive
    And the next request requires re-authentication
    And the user is notified of session expiration

  Scenario: Session absolute timeout
    Given a session has 8-hour absolute timeout
    When a session has been active for 8 hours
    Then the session is terminated regardless of activity
    And the user must re-authenticate
    And long-running sessions are prevented

  Scenario: Secure session cookie attributes
    Given session cookies are issued
    Then cookies have the following attributes:
      | attribute | value     |
      | HttpOnly  | true      |
      | Secure    | true      |
      | SameSite  | Strict    |
      | Path      | /         |
    And cookie security is enforced

  Scenario: Remember me functionality
    Given a user opts for "Remember Me" during login
    When authentication succeeds
    Then a persistent token is issued (30-day validity)
    And the token is stored securely in database
    When the user returns within 30 days
    Then the persistent token is validated
    And a new session is created without re-login

  # ============================================
  # MULTI-FACTOR AUTHENTICATION (MFA)
  # ============================================

  Scenario: Enable MFA for admin accounts
    Given MFA is required for ADMIN and SUPER_ADMIN roles
    When an admin authenticates with Google OAuth
    Then a second factor is required before access
    And options include TOTP or WebAuthn
    And access is denied until MFA is complete

  Scenario: TOTP-based MFA verification
    Given an admin has TOTP MFA configured
    And Google authenticator generates code "123456"
    When the admin enters code "123456"
    Then the code is validated against server-generated code
    And time drift of 30 seconds is allowed
    And authentication completes successfully

  Scenario: WebAuthn security key authentication
    Given an admin has registered a security key
    When prompted for MFA
    Then the user can authenticate with security key
    And the WebAuthn challenge is validated
    And authentication completes successfully

  Scenario: MFA recovery codes
    Given an admin loses access to their MFA device
    When they use a recovery code
    Then the recovery code is validated
    And the code is marked as used (single-use)
    And the admin is prompted to set up new MFA

  Scenario: Trusted device for MFA
    Given an admin marks their device as trusted
    When they authenticate from the trusted device
    Then MFA is not required for 30 days
    And the device fingerprint is validated
    When authenticating from a new device
    Then MFA is always required

  # ============================================
  # TOKEN SECURITY
  # ============================================

  Scenario: JWT token contains minimal claims
    Given a JWT token is issued
    Then the token contains only:
      | claim   | description              |
      | sub     | user identifier          |
      | iat     | issued at timestamp      |
      | exp     | expiration timestamp     |
      | iss     | token issuer             |
      | aud     | intended audience        |
    And sensitive data like email is not in JWT
    And additional data is fetched from database

  Scenario: Prevent JWT token leakage in logs
    Given JWT tokens are used in requests
    When logging request headers
    Then the Authorization header value is masked
    And only first/last 4 characters are shown
    And full tokens are never logged

  Scenario: Token blacklist for immediate revocation
    Given a JWT token needs immediate revocation
    When the token is added to blacklist
    Then subsequent requests with this token are rejected
    And blacklist is checked before token validation
    And blacklist entries expire when token would expire

  Scenario: Short-lived access tokens with refresh
    Given access tokens have 15-minute expiration
    And refresh tokens have 7-day expiration
    When an access token expires
    Then the client uses refresh token to get new access token
    And the refresh token rotation is optional
    And long-lived access is enabled securely

  # ============================================
  # AUTHORIZATION CONTEXT
  # ============================================

  Scenario: Propagate authorization context to downstream services
    Given a user is authenticated with role ADMIN
    When the request is forwarded to microservices
    Then the following headers are propagated:
      | header           | value                |
      | X-User-Id        | user-id-123          |
      | X-User-Email     | admin@example.com    |
      | X-User-Role      | ADMIN                |
      | X-Request-Id     | unique-request-id    |
      | X-Correlation-Id | correlation-id       |
    And downstream services trust these headers
    And headers are signed to prevent tampering

  Scenario: Validate authorization headers signature
    Given Envoy signs authorization headers with HMAC
    When the backend receives headers
    Then the signature is validated
    And tampered headers are rejected
    And requests with missing signatures are rejected

  Scenario: Authorization context caching
    Given the auth service validates tokens
    When the same token is used within 30 seconds
    Then the cached authorization result is used
    And database lookups are avoided
    And cache is invalidated on token revocation

  # ============================================
  # SECURITY HEADERS AND PROTECTIONS
  # ============================================

  Scenario: Security headers in responses
    Given a response is sent to the client
    Then the following security headers are included:
      | header                        | value                    |
      | X-Content-Type-Options        | nosniff                  |
      | X-Frame-Options               | DENY                     |
      | X-XSS-Protection              | 1; mode=block            |
      | Strict-Transport-Security     | max-age=31536000         |
      | Content-Security-Policy       | default-src 'self'       |
    And browser security features are enabled

  Scenario: CORS configuration for OAuth callbacks
    Given OAuth callbacks come from Google domains
    When CORS preflight requests are received
    Then allowed origins include:
      | origin                        |
      | https://accounts.google.com   |
      | https://fflplayoffs.com       |
    And other origins are rejected
    And credentials are allowed for trusted origins

  Scenario: Rate limiting on authentication endpoints
    Given authentication endpoints have rate limits:
      | endpoint           | limit              |
      | /auth/login        | 5 attempts/minute  |
      | /auth/token        | 10 requests/minute |
      | /auth/refresh      | 30 requests/hour   |
    When limits are exceeded
    Then requests are rejected with 429
    And exponential backoff is suggested

  Scenario: Brute force protection
    Given an IP makes 10 failed login attempts
    When the threshold is exceeded
    Then the IP is temporarily blocked for 15 minutes
    And a CAPTCHA is required after unblock
    And the security team is alerted

  # ============================================
  # AUDIT LOGGING
  # ============================================

  Scenario: Comprehensive authentication audit log
    Given authentication events occur
    Then the following events are logged:
      | event                  | details                      |
      | LOGIN_SUCCESS          | user, method, IP, timestamp  |
      | LOGIN_FAILURE          | attempted user, reason, IP   |
      | TOKEN_REFRESH          | user, old token ID           |
      | LOGOUT                 | user, session ID             |
      | MFA_SUCCESS            | user, method                 |
      | MFA_FAILURE            | user, reason                 |
      | PAT_CREATED            | owner, scope                 |
      | PAT_REVOKED            | owner, reason                |
    And logs are stored for 2 years

  Scenario: Suspicious activity detection
    Given authentication patterns are monitored
    When suspicious patterns are detected:
      | pattern                              |
      | Login from new geographic location   |
      | Multiple failed attempts             |
      | Unusual time of access               |
      | Multiple simultaneous sessions       |
    Then security alerts are generated
    And the user is optionally notified
    And additional verification may be required

  Scenario: Export authentication logs
    Given an admin requests authentication logs
    When the export is generated
    Then the following formats are supported:
      | format | description          |
      | CSV    | Comma-separated      |
      | JSON   | Machine readable     |
      | PDF    | Human readable       |
    And sensitive data is appropriately masked

  # ============================================
  # ERROR HANDLING
  # ============================================

  Scenario Outline: Authentication error responses
    Given an authentication error occurs
    When the error type is <errorType>
    Then the response status is <status>
    And the error message is <message>
    And the error code is <code>

    Examples:
      | errorType            | status | message                    | code                |
      | InvalidToken         | 401    | Invalid authentication     | AUTH_INVALID_TOKEN  |
      | ExpiredToken         | 401    | Token has expired          | AUTH_TOKEN_EXPIRED  |
      | RevokedToken         | 401    | Token has been revoked     | AUTH_TOKEN_REVOKED  |
      | InsufficientScope    | 403    | Insufficient permissions   | AUTH_SCOPE_DENIED   |
      | UserNotFound         | 403    | User account not found     | AUTH_USER_NOT_FOUND |
      | AccountDisabled      | 403    | Account is disabled        | AUTH_ACCOUNT_DISABLED|
      | RateLimited          | 429    | Too many requests          | AUTH_RATE_LIMITED   |

  Scenario: Graceful handling of auth service unavailability
    Given the auth service is temporarily unavailable
    When a request requires authentication
    Then the system returns 503 Service Unavailable
    And the client is advised to retry
    And a circuit breaker prevents cascade failures
    And the issue is logged for immediate attention

  Scenario: Handle malformed tokens gracefully
    Given a request contains a malformed token
    When token parsing fails
    Then a generic "Invalid token" error is returned
    And specific parsing errors are not exposed
    And the malformed token is logged for analysis

  # ============================================
  # TESTING AND DEBUGGING
  # ============================================

  Scenario: Authentication bypass for testing (non-production only)
    Given the environment is "development" or "test"
    When a request includes header X-Test-User: test-user@example.com
    Then authentication is bypassed
    And the specified test user context is used
    And this feature is disabled in production

  Scenario: Token introspection endpoint
    Given an admin needs to inspect a token
    When calling POST /auth/introspect with the token
    Then the response includes:
      | field     | description              |
      | active    | true/false               |
      | sub       | subject (user ID)        |
      | exp       | expiration timestamp     |
      | scope     | granted scopes           |
      | client_id | OAuth client ID          |
    And this endpoint is admin-only

  Scenario: Debug mode for auth troubleshooting
    Given debug mode is enabled for a specific user
    When the user authenticates
    Then detailed auth logs are generated
    And the logs include:
      | Token validation steps        |
      | Claims extraction             |
      | Database queries              |
      | Authorization decisions       |
    And debug mode auto-disables after 1 hour
