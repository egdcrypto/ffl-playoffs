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
