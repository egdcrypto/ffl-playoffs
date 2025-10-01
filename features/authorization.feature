Feature: Role-Based Access Control and Authorization
  As a system security architect
  I want to enforce role-based access control at the Envoy layer
  So that users and services can only access authorized resources

  Background:
    Given Envoy sidecar handles all authentication and authorization
    And the auth service validates tokens and returns user/service context
    And endpoint security requirements are defined

  Scenario: SUPER_ADMIN accesses all endpoints
    Given a user with SUPER_ADMIN role is authenticated
    When the user accesses the following endpoints:
      | Endpoint                         |
      | GET /api/v1/superadmin/admins    |
      | POST /api/v1/admin/leagues       |
      | GET /api/v1/player/leagues       |
      | GET /api/v1/public/health        |
    Then all requests are authorized by Envoy
    And the API receives pre-validated requests with X-User-Role: SUPER_ADMIN
    And all endpoints return successful responses

  Scenario: ADMIN accesses admin and player endpoints only
    Given a user with ADMIN role is authenticated
    When the user accesses admin endpoints:
      | Endpoint                              | Expected Result |
      | POST /api/v1/admin/leagues            | 200 OK          |
      | PUT /api/v1/admin/leagues/123         | 200 OK          |
      | GET /api/v1/player/leagues/123        | 200 OK          |
    Then all requests are authorized
    And the API receives X-User-Role: ADMIN

  Scenario: ADMIN blocked from super admin endpoints
    Given a user with ADMIN role is authenticated
    When the user attempts to access:
      | Endpoint                              |
      | GET /api/v1/superadmin/admins         |
      | POST /api/v1/superadmin/invite        |
      | POST /api/v1/superadmin/pats          |
    Then Envoy blocks all requests with 403 Forbidden
    And the requests never reach the API
    And the response includes "Insufficient permissions"

  Scenario: PLAYER accesses player endpoints only
    Given a user with PLAYER role is authenticated
    When the user accesses player endpoints:
      | Endpoint                              | Expected Result |
      | GET /api/v1/player/leagues            | 200 OK          |
      | GET /api/v1/player/rosters/123        | 200 OK          |
      | PUT /api/v1/player/rosters/123        | 200 OK          |
    Then all requests are authorized
    And the API receives X-User-Role: PLAYER

  Scenario: PLAYER blocked from admin endpoints
    Given a user with PLAYER role is authenticated
    When the user attempts to access:
      | Endpoint                              |
      | POST /api/v1/admin/leagues            |
      | PUT /api/v1/admin/leagues/123/config  |
      | POST /api/v1/admin/invitations        |
    Then Envoy blocks all requests with 403 Forbidden
    And the requests never reach the API

  Scenario: PLAYER blocked from super admin endpoints
    Given a user with PLAYER role is authenticated
    When the user attempts to access:
      | Endpoint                              |
      | GET /api/v1/superadmin/admins         |
      | POST /api/v1/superadmin/pats          |
    Then Envoy blocks all requests with 403 Forbidden
    And the requests never reach the API

  Scenario: Public endpoints accessible without authentication
    Given no authentication token is provided
    When a request accesses:
      | Endpoint                   |
      | GET /api/v1/public/health  |
      | GET /api/v1/public/version |
    Then Envoy allows the requests without authentication
    And the API returns public data

  Scenario: PAT with ADMIN scope accesses super admin endpoints
    Given a PAT with ADMIN scope is used
    When a request uses the PAT to access:
      | Endpoint                              |
      | POST /api/v1/superadmin/bootstrap     |
      | GET /api/v1/superadmin/system-status  |
    Then Envoy authorizes the requests
    And the auth service returns X-PAT-Scope: ADMIN
    And the API receives the requests

  Scenario: PAT with WRITE scope accesses admin endpoints
    Given a PAT with WRITE scope is used
    When a request uses the PAT to access:
      | Endpoint                       |
      | POST /api/v1/admin/leagues     |
      | PUT /api/v1/admin/leagues/123  |
      | POST /api/v1/service/sync-data |
    Then Envoy authorizes the requests
    And the auth service returns X-PAT-Scope: WRITE
    And the API receives the requests

  Scenario: PAT with READ_ONLY scope blocked from write endpoints
    Given a PAT with READ_ONLY scope is used
    When a request uses the PAT to access:
      | Endpoint                       | Expected Result |
      | GET /api/v1/player/leagues     | 200 OK          |
      | POST /api/v1/admin/leagues     | 403 Forbidden   |
      | PUT /api/v1/admin/leagues/123  | 403 Forbidden   |
    Then Envoy blocks write operations
    And read operations are allowed

  Scenario: Service-to-service endpoints require PAT only
    Given an endpoint requires PAT authentication
    And a user attempts access with Google OAuth token
    When the user accesses /api/v1/service/internal-sync
    Then Envoy rejects the request with 403 Forbidden
    And the auth service validates only PAT tokens for service endpoints
    And Google OAuth tokens cannot access service endpoints

  Scenario: Unauthenticated request to protected endpoint
    Given no authentication token is provided
    When a request accesses /api/v1/admin/leagues
    Then Envoy blocks the request with 401 Unauthorized
    And the response includes "Authentication required"
    And the request never reaches the API

  Scenario: Expired Google JWT token blocked
    Given a Google OAuth token is expired
    When a user attempts to access /api/v1/player/leagues
    Then the auth service validates JWT expiration
    And the auth service returns HTTP 403 to Envoy
    And Envoy blocks the request with 401 Unauthorized
    And the response includes "Token expired"

  Scenario: Expired PAT blocked
    Given a PAT is expired
    When a service attempts to access /api/v1/admin/leagues
    Then the auth service validates PAT expiration
    And the auth service returns HTTP 403 to Envoy
    And Envoy blocks the request with 401 Unauthorized
    And the response includes "PAT expired"

  Scenario: Revoked PAT blocked
    Given a PAT is revoked
    When a service attempts to access /api/v1/admin/leagues
    Then the auth service checks revoked status
    And the auth service returns HTTP 403 to Envoy
    And Envoy blocks the request with 401 Unauthorized
    And the response includes "PAT revoked"

  Scenario: Resource ownership validation in API
    Given an ADMIN user owns league "league-123"
    And another admin owns league "league-456"
    When the admin accesses PUT /api/v1/admin/leagues/league-456
    Then Envoy authorizes based on ADMIN role
    And the request reaches the API
    But the API validates resource ownership
    And the API returns 403 Forbidden with "League not owned by user"
    And resource ownership is validated in business logic

  Scenario: League-scoped authorization for players
    Given a PLAYER is a member of league "league-123"
    And the player is not a member of league "league-456"
    When the player accesses GET /api/v1/player/leagues/league-456/roster
    Then Envoy authorizes based on PLAYER role
    And the request reaches the API
    But the API validates league membership
    And the API returns 403 Forbidden with "Not a member of this league"

  Scenario: Authorization headers passed to API
    Given a SUPER_ADMIN user with Google ID "google-123" is authenticated
    When the user accesses /api/v1/superadmin/admins
    Then Envoy calls auth service for validation
    And auth service returns HTTP 200 with headers:
      | Header       | Value               |
      | X-User-Id    | user-id-123         |
      | X-User-Email | admin@example.com   |
      | X-User-Role  | SUPER_ADMIN         |
      | X-Google-Id  | google-123          |
    And Envoy forwards request to API with all headers
    And the API uses headers for business logic

  Scenario: PAT authorization headers passed to API
    Given a PAT with WRITE scope is used
    When a service accesses /api/v1/admin/leagues
    Then Envoy calls auth service for validation
    And auth service returns HTTP 200 with headers:
      | Header        | Value     |
      | X-Service-Id  | data-sync |
      | X-PAT-Scope   | WRITE     |
      | X-PAT-Id      | pat-123   |
    And Envoy forwards request to API with PAT headers
    And the API processes service request

  Scenario: API listens only on localhost
    Given the API is configured to listen on localhost:8080
    When an external request attempts direct access to API
    Then network policies prevent external access
    And all traffic must go through Envoy sidecar
    And the API is not exposed outside the pod

  Scenario: Auth service listens only on localhost
    Given the auth service listens on localhost:9191
    When an external request attempts direct access to auth service
    Then network policies prevent external access
    And only Envoy can call the auth service
    And the auth service is not exposed outside the pod

  Scenario: Envoy is the only external entry point
    Given Envoy listens on pod IP (externally accessible)
    And the API listens on localhost only
    And the auth service listens on localhost only
    When a user sends a request to the pod
    Then the request must go to Envoy first
    And Envoy calls auth service on localhost:9191
    And Envoy forwards authorized requests to API on localhost:8080
    And there is no way to bypass Envoy authentication

  Scenario: Role hierarchy respected
    Given the role hierarchy is: SUPER_ADMIN > ADMIN > PLAYER
    Then SUPER_ADMIN can access: /api/v1/superadmin/*, /api/v1/admin/*, /api/v1/player/*
    And ADMIN can access: /api/v1/admin/*, /api/v1/player/*
    And PLAYER can access: /api/v1/player/*
    And lower roles cannot access higher role endpoints

  Scenario: Audit logging for authorization failures
    Given an ADMIN user attempts to access /api/v1/superadmin/admins
    When Envoy blocks the request with 403 Forbidden
    Then an audit log entry is created:
      | Field      | Value                        |
      | userId     | admin-user-id                |
      | role       | ADMIN                        |
      | endpoint   | /api/v1/superadmin/admins    |
      | result     | BLOCKED_INSUFFICIENT_ROLE    |
      | timestamp  | current_timestamp            |
    And all authorization failures are logged for security review
