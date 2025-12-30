Feature: Role-Based Access Control and Authorization
  As a system security architect
  I want to enforce role-based access control at the Envoy layer
  So that users and services can only access authorized resources

  Background:
    Given Envoy sidecar handles all authentication and authorization
    And the auth service validates tokens and returns user/service context
    And endpoint security requirements are defined
    And the role hierarchy is: SUPER_ADMIN > ADMIN > PLAYER
    And PAT scope hierarchy is: ADMIN > WRITE > READ_ONLY

  # =============================================================================
  # ROLE HIERARCHY - SUPER_ADMIN ACCESS
  # =============================================================================

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

  Scenario: SUPER_ADMIN can access all super admin management endpoints
    Given a user with SUPER_ADMIN role is authenticated
    When the user accesses super admin endpoints:
      | Endpoint                                  | Method | Expected Result |
      | /api/v1/superadmin/admins                 | GET    | 200 OK          |
      | /api/v1/superadmin/admins                 | POST   | 201 Created     |
      | /api/v1/superadmin/admins/123             | PUT    | 200 OK          |
      | /api/v1/superadmin/admins/123             | DELETE | 204 No Content  |
      | /api/v1/superadmin/invite                 | POST   | 201 Created     |
      | /api/v1/superadmin/pats                   | GET    | 200 OK          |
      | /api/v1/superadmin/pats                   | POST   | 201 Created     |
      | /api/v1/superadmin/pats/pat-123           | DELETE | 204 No Content  |
      | /api/v1/superadmin/system-status          | GET    | 200 OK          |
      | /api/v1/superadmin/audit-logs             | GET    | 200 OK          |
      | /api/v1/superadmin/config                 | GET    | 200 OK          |
      | /api/v1/superadmin/config                 | PUT    | 200 OK          |
    Then all requests are authorized by Envoy
    And the API receives X-User-Role: SUPER_ADMIN

  Scenario: SUPER_ADMIN can manage all leagues regardless of ownership
    Given a user with SUPER_ADMIN role is authenticated
    And a league "league-123" exists owned by admin "other-admin-id"
    When the SUPER_ADMIN accesses:
      | Endpoint                                      | Method | Expected Result |
      | /api/v1/admin/leagues/league-123              | GET    | 200 OK          |
      | /api/v1/admin/leagues/league-123              | PUT    | 200 OK          |
      | /api/v1/admin/leagues/league-123              | DELETE | 204 No Content  |
      | /api/v1/admin/leagues/league-123/config       | PUT    | 200 OK          |
      | /api/v1/admin/leagues/league-123/invitations  | POST   | 201 Created     |
    Then all requests are authorized
    And resource ownership is bypassed for SUPER_ADMIN

  # =============================================================================
  # ROLE HIERARCHY - ADMIN ACCESS
  # =============================================================================

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
      | GET /api/v1/superadmin/audit-logs     |
      | PUT /api/v1/superadmin/config         |
      | DELETE /api/v1/superadmin/admins/123  |
    Then Envoy blocks all requests with 403 Forbidden
    And the requests never reach the API
    And the response includes "Insufficient permissions"
    And audit logs record all blocked attempts

  Scenario: ADMIN can only manage their own leagues
    Given an ADMIN user "admin-1" owns leagues:
      | League ID   |
      | league-100  |
      | league-101  |
    And ADMIN user "admin-2" owns league "league-200"
    When admin-1 attempts to access:
      | Endpoint                              | Method | Expected Result   |
      | /api/v1/admin/leagues/league-100      | PUT    | 200 OK            |
      | /api/v1/admin/leagues/league-101      | DELETE | 204 No Content    |
      | /api/v1/admin/leagues/league-200      | PUT    | 403 Forbidden     |
      | /api/v1/admin/leagues/league-200      | DELETE | 403 Forbidden     |
    Then Envoy authorizes based on ADMIN role
    But the API validates resource ownership for non-owned leagues
    And returns 403 for league-200 operations

  Scenario: ADMIN can view all leagues but only modify owned leagues
    Given an ADMIN user "admin-1" is authenticated
    And multiple leagues exist in the system
    When admin-1 accesses:
      | Endpoint                              | Method | Expected Result |
      | /api/v1/admin/leagues                 | GET    | 200 OK          |
      | /api/v1/admin/leagues/any-league      | GET    | 200 OK          |
    Then read access is allowed for all leagues
    But write access is restricted to owned leagues only

  # =============================================================================
  # ROLE HIERARCHY - PLAYER ACCESS
  # =============================================================================

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
      | DELETE /api/v1/admin/leagues/123      |
    Then Envoy blocks all requests with 403 Forbidden
    And the requests never reach the API

  Scenario: PLAYER blocked from super admin endpoints
    Given a user with PLAYER role is authenticated
    When the user attempts to access:
      | Endpoint                              |
      | GET /api/v1/superadmin/admins         |
      | POST /api/v1/superadmin/pats          |
      | PUT /api/v1/superadmin/config         |
    Then Envoy blocks all requests with 403 Forbidden
    And the requests never reach the API

  Scenario: PLAYER can only access leagues they belong to
    Given a PLAYER "player-1" is a member of:
      | League ID   |
      | league-100  |
      | league-101  |
    And league "league-200" exists but player-1 is not a member
    When player-1 attempts to access:
      | Endpoint                                 | Method | Expected Result |
      | /api/v1/player/leagues/league-100        | GET    | 200 OK          |
      | /api/v1/player/leagues/league-100/roster | GET    | 200 OK          |
      | /api/v1/player/leagues/league-200        | GET    | 403 Forbidden   |
      | /api/v1/player/leagues/league-200/roster | GET    | 403 Forbidden   |
    Then Envoy authorizes based on PLAYER role
    But the API validates league membership
    And returns 403 for non-member league access

  Scenario: PLAYER can only modify their own roster
    Given a PLAYER "player-1" has roster "roster-100" in league "league-100"
    And PLAYER "player-2" has roster "roster-200" in league "league-100"
    When player-1 attempts to modify:
      | Endpoint                              | Method | Expected Result |
      | /api/v1/player/rosters/roster-100     | PUT    | 200 OK          |
      | /api/v1/player/rosters/roster-200     | PUT    | 403 Forbidden   |
    Then the API validates roster ownership
    And returns 403 for attempts to modify other players' rosters

  # =============================================================================
  # ROLE TRANSITIONS - PROMOTION AND DEMOTION
  # =============================================================================

  Scenario: SUPER_ADMIN promotes PLAYER to ADMIN
    Given a user with SUPER_ADMIN role is authenticated
    And a PLAYER user "player-to-promote" exists
    When the SUPER_ADMIN calls:
      | Endpoint                                          | Method | Payload                    |
      | /api/v1/superadmin/users/player-to-promote/role   | PUT    | {"role": "ADMIN"}          |
    Then the request is authorized
    And the player's role is updated to ADMIN
    And an audit log entry records the promotion:
      | Field           | Value                  |
      | action          | ROLE_PROMOTION         |
      | previousRole    | PLAYER                 |
      | newRole         | ADMIN                  |
      | performedBy     | super-admin-id         |
      | targetUser      | player-to-promote      |
    And the player can now access admin endpoints

  Scenario: SUPER_ADMIN demotes ADMIN to PLAYER
    Given a user with SUPER_ADMIN role is authenticated
    And an ADMIN user "admin-to-demote" exists with owned leagues
    When the SUPER_ADMIN calls:
      | Endpoint                                         | Method | Payload              |
      | /api/v1/superadmin/users/admin-to-demote/role    | PUT    | {"role": "PLAYER"}   |
    Then the request is authorized
    And the admin's role is updated to PLAYER
    And the admin's leagues are reassigned or archived
    And an audit log entry records the demotion
    And the demoted user can no longer access admin endpoints

  Scenario: SUPER_ADMIN promotes ADMIN to SUPER_ADMIN
    Given a user with SUPER_ADMIN role is authenticated
    And an ADMIN user "admin-to-promote" exists
    When the SUPER_ADMIN calls:
      | Endpoint                                          | Method | Payload                      |
      | /api/v1/superadmin/users/admin-to-promote/role    | PUT    | {"role": "SUPER_ADMIN"}      |
    Then the request is authorized
    And the admin's role is updated to SUPER_ADMIN
    And a security audit alert is generated
    And the promoted user can now access super admin endpoints

  Scenario: ADMIN cannot promote users
    Given a user with ADMIN role is authenticated
    And a PLAYER user "player-123" exists
    When the ADMIN attempts to call:
      | Endpoint                                    | Method | Payload              |
      | /api/v1/superadmin/users/player-123/role    | PUT    | {"role": "ADMIN"}    |
    Then Envoy blocks the request with 403 Forbidden
    And the player's role remains unchanged
    And an unauthorized access attempt is logged

  Scenario: PLAYER cannot promote users
    Given a user with PLAYER role is authenticated
    When the PLAYER attempts to access any role management endpoint
    Then all requests are blocked with 403 Forbidden
    And unauthorized attempts are logged

  # =============================================================================
  # PAT SCOPES - ADMIN SCOPE
  # =============================================================================

  Scenario: PAT with ADMIN scope accesses super admin endpoints
    Given a PAT with ADMIN scope is used
    When a request uses the PAT to access:
      | Endpoint                              |
      | POST /api/v1/superadmin/bootstrap     |
      | GET /api/v1/superadmin/system-status  |
      | GET /api/v1/superadmin/audit-logs     |
    Then Envoy authorizes the requests
    And the auth service returns X-PAT-Scope: ADMIN
    And the API receives the requests

  Scenario: PAT with ADMIN scope can access all endpoint tiers
    Given a PAT with ADMIN scope is used
    When a request uses the PAT to access:
      | Endpoint                                    | Method | Expected Result |
      | /api/v1/superadmin/system-status            | GET    | 200 OK          |
      | /api/v1/admin/leagues                       | GET    | 200 OK          |
      | /api/v1/admin/leagues                       | POST   | 201 Created     |
      | /api/v1/player/leagues                      | GET    | 200 OK          |
      | /api/v1/service/internal-sync               | POST   | 200 OK          |
    Then all requests are authorized
    And the API receives X-PAT-Scope: ADMIN for all requests

  Scenario: PAT with ADMIN scope bypasses resource ownership
    Given a PAT with ADMIN scope is used
    And a league "league-123" exists owned by admin "some-admin"
    When a service uses the PAT to access:
      | Endpoint                              | Method | Expected Result |
      | /api/v1/admin/leagues/league-123      | PUT    | 200 OK          |
      | /api/v1/admin/leagues/league-123      | DELETE | 204 No Content  |
    Then resource ownership checks are bypassed for ADMIN scope PATs
    And all modifications succeed

  # =============================================================================
  # PAT SCOPES - WRITE SCOPE
  # =============================================================================

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

  Scenario: PAT with WRITE scope can perform all HTTP methods on admin endpoints
    Given a PAT with WRITE scope is used
    When a request uses the PAT to access:
      | Endpoint                       | Method | Expected Result |
      | /api/v1/admin/leagues          | GET    | 200 OK          |
      | /api/v1/admin/leagues          | POST   | 201 Created     |
      | /api/v1/admin/leagues/123      | PUT    | 200 OK          |
      | /api/v1/admin/leagues/123      | PATCH  | 200 OK          |
      | /api/v1/admin/leagues/123      | DELETE | 204 No Content  |
    Then all requests are authorized
    And write operations succeed

  Scenario: PAT with WRITE scope blocked from super admin endpoints
    Given a PAT with WRITE scope is used
    When a request uses the PAT to access:
      | Endpoint                              | Method | Expected Result |
      | /api/v1/superadmin/admins             | GET    | 403 Forbidden   |
      | /api/v1/superadmin/pats               | POST   | 403 Forbidden   |
      | /api/v1/superadmin/config             | PUT    | 403 Forbidden   |
    Then Envoy blocks all super admin requests
    And the response includes "PAT scope insufficient"

  # =============================================================================
  # PAT SCOPES - READ_ONLY SCOPE
  # =============================================================================

  Scenario: PAT with READ_ONLY scope blocked from write endpoints
    Given a PAT with READ_ONLY scope is used
    When a request uses the PAT to access:
      | Endpoint                       | Expected Result |
      | GET /api/v1/player/leagues     | 200 OK          |
      | POST /api/v1/admin/leagues     | 403 Forbidden   |
      | PUT /api/v1/admin/leagues/123  | 403 Forbidden   |
    Then Envoy blocks write operations
    And read operations are allowed

  Scenario: PAT with READ_ONLY scope can only perform GET requests
    Given a PAT with READ_ONLY scope is used
    When a request uses the PAT to access:
      | Endpoint                       | Method | Expected Result |
      | /api/v1/player/leagues         | GET    | 200 OK          |
      | /api/v1/admin/leagues          | GET    | 200 OK          |
      | /api/v1/admin/leagues          | POST   | 403 Forbidden   |
      | /api/v1/admin/leagues/123      | PUT    | 403 Forbidden   |
      | /api/v1/admin/leagues/123      | PATCH  | 403 Forbidden   |
      | /api/v1/admin/leagues/123      | DELETE | 403 Forbidden   |
    Then only GET requests are authorized
    And all mutation methods are blocked

  Scenario: PAT with READ_ONLY scope blocked from super admin endpoints
    Given a PAT with READ_ONLY scope is used
    When a request uses the PAT to access:
      | Endpoint                              | Method | Expected Result |
      | /api/v1/superadmin/admins             | GET    | 403 Forbidden   |
      | /api/v1/superadmin/system-status      | GET    | 403 Forbidden   |
    Then Envoy blocks all super admin requests regardless of method

  Scenario: PAT with READ_ONLY scope blocked from service endpoints
    Given a PAT with READ_ONLY scope is used
    When a request uses the PAT to access:
      | Endpoint                              | Method | Expected Result |
      | /api/v1/service/sync-data             | POST   | 403 Forbidden   |
      | /api/v1/service/internal-sync         | POST   | 403 Forbidden   |
    Then service endpoints require at least WRITE scope

  # =============================================================================
  # RESOURCE OWNERSHIP VALIDATION
  # =============================================================================

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

  Scenario: Player can view their own roster details
    Given a PLAYER "player-1" with roster "roster-100"
    When the player accesses:
      | Endpoint                              | Method | Expected Result |
      | /api/v1/player/rosters/roster-100     | GET    | 200 OK          |
      | /api/v1/player/rosters/roster-100     | PUT    | 200 OK          |
    Then all requests succeed for owned roster

  Scenario: Player cannot view or modify other players' roster details
    Given a PLAYER "player-1" with roster "roster-100"
    And PLAYER "player-2" with roster "roster-200"
    When player-1 attempts to access:
      | Endpoint                              | Method | Expected Result |
      | /api/v1/player/rosters/roster-200     | GET    | 403 Forbidden   |
      | /api/v1/player/rosters/roster-200     | PUT    | 403 Forbidden   |
    Then the API returns 403 for non-owned rosters

  Scenario: Admin can view all rosters in their leagues
    Given an ADMIN "admin-1" owns league "league-100"
    And league "league-100" has rosters from multiple players
    When admin-1 accesses:
      | Endpoint                                          | Method | Expected Result |
      | /api/v1/admin/leagues/league-100/rosters          | GET    | 200 OK          |
      | /api/v1/admin/leagues/league-100/rosters/any-id   | GET    | 200 OK          |
    Then the admin can view all rosters in their owned leagues

  Scenario: Admin cannot view rosters in leagues they don't own
    Given an ADMIN "admin-1" owns league "league-100"
    And an ADMIN "admin-2" owns league "league-200"
    When admin-1 attempts to access:
      | Endpoint                                          | Method | Expected Result |
      | /api/v1/admin/leagues/league-200/rosters          | GET    | 403 Forbidden   |
    Then the API validates league ownership
    And returns 403 for non-owned league resources

  # =============================================================================
  # CROSS-RESOURCE ACCESS
  # =============================================================================

  Scenario: Player accessing week scores across multiple leagues
    Given a PLAYER "player-1" is a member of leagues:
      | League ID   |
      | league-100  |
      | league-101  |
    And player-1 is not a member of league "league-200"
    When player-1 accesses:
      | Endpoint                                           | Expected Result |
      | /api/v1/player/leagues/league-100/scores/week-1    | 200 OK          |
      | /api/v1/player/leagues/league-101/scores/week-1    | 200 OK          |
      | /api/v1/player/leagues/league-200/scores/week-1    | 403 Forbidden   |
    Then access is granted only for member leagues

  Scenario: Admin accessing scores across owned leagues
    Given an ADMIN "admin-1" owns leagues:
      | League ID   |
      | league-100  |
      | league-101  |
    And ADMIN "admin-2" owns league "league-200"
    When admin-1 accesses:
      | Endpoint                                           | Expected Result |
      | /api/v1/admin/leagues/league-100/scores            | 200 OK          |
      | /api/v1/admin/leagues/league-101/scores            | 200 OK          |
      | /api/v1/admin/leagues/league-200/scores            | 403 Forbidden   |
    Then access is granted only for owned leagues

  Scenario: Cross-league player lookup by admin
    Given an ADMIN "admin-1" owns league "league-100"
    And PLAYER "player-1" is a member of "league-100" and "league-200"
    When admin-1 accesses:
      | Endpoint                                           | Expected Result |
      | /api/v1/admin/leagues/league-100/players/player-1  | 200 OK          |
    Then only player data relevant to league-100 is returned
    And player's data from league-200 is not exposed

  # =============================================================================
  # PUBLIC ENDPOINTS
  # =============================================================================

  Scenario: Public endpoints accessible without authentication
    Given no authentication token is provided
    When a request accesses:
      | Endpoint                   |
      | GET /api/v1/public/health  |
      | GET /api/v1/public/version |
    Then Envoy allows the requests without authentication
    And the API returns public data

  Scenario: Public endpoints return limited information
    Given no authentication token is provided
    When a request accesses /api/v1/public/health
    Then the response includes only:
      | Field     | Description              |
      | status    | Service health status    |
      | timestamp | Current server time      |
    And no sensitive information is exposed

  Scenario: Public endpoints are rate limited
    Given no authentication token is provided
    When 100 requests are made to /api/v1/public/health within 1 minute
    Then the first 60 requests succeed with 200 OK
    And subsequent requests return 429 Too Many Requests
    And the response includes Retry-After header

  Scenario: Public endpoints do not accept authentication headers
    Given a valid authentication token is provided
    When the token is included in a request to /api/v1/public/health
    Then the authentication headers are ignored
    And the request is processed as unauthenticated
    And the response matches unauthenticated behavior

  # =============================================================================
  # AUTHENTICATION FAILURES
  # =============================================================================

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

  Scenario: Malformed JWT token rejected
    Given a malformed JWT token is provided
    When a user attempts to access /api/v1/player/leagues
    Then the auth service fails to parse the token
    And the auth service returns HTTP 403 to Envoy
    And Envoy blocks the request with 401 Unauthorized
    And the response includes "Invalid token format"

  Scenario: JWT with wrong issuer rejected
    Given a JWT token with issuer "https://wrong-issuer.com" is provided
    When a user attempts to access /api/v1/player/leagues
    Then the auth service validates the issuer
    And the auth service returns HTTP 403 to Envoy
    And Envoy blocks the request with 401 Unauthorized
    And the response includes "Invalid token issuer"

  Scenario: JWT with tampered signature rejected
    Given a JWT token with an invalid signature is provided
    When a user attempts to access /api/v1/player/leagues
    Then the auth service validates the signature
    And the auth service returns HTTP 403 to Envoy
    And Envoy blocks the request with 401 Unauthorized
    And the response includes "Invalid token signature"

  Scenario: PAT with invalid format rejected
    Given a PAT with invalid format "not-a-valid-pat" is provided
    When a service attempts to access /api/v1/admin/leagues
    Then the auth service fails to validate the PAT
    And Envoy blocks the request with 401 Unauthorized
    And the response includes "Invalid PAT format"

  Scenario: PAT not found in database rejected
    Given a PAT "pat-nonexistent" is not in the database
    When a service attempts to access /api/v1/admin/leagues
    Then the auth service cannot find the PAT
    And Envoy blocks the request with 401 Unauthorized
    And the response includes "PAT not found"

  # =============================================================================
  # SERVICE-TO-SERVICE AUTHENTICATION
  # =============================================================================

  Scenario: Service-to-service endpoints require PAT only
    Given an endpoint requires PAT authentication
    And a user attempts access with Google OAuth token
    When the user accesses /api/v1/service/internal-sync
    Then Envoy rejects the request with 403 Forbidden
    And the auth service validates only PAT tokens for service endpoints
    And Google OAuth tokens cannot access service endpoints

  Scenario: Service endpoints accept WRITE or ADMIN scope PATs
    Given a service endpoint /api/v1/service/sync-data requires PAT
    When different PAT scopes are used:
      | PAT Scope   | Expected Result |
      | ADMIN       | 200 OK          |
      | WRITE       | 200 OK          |
      | READ_ONLY   | 403 Forbidden   |
    Then only WRITE and ADMIN scope PATs are accepted

  Scenario: Service endpoints pass service identity to API
    Given a PAT "pat-data-sync" with service ID "data-sync-service" is used
    When the service accesses /api/v1/service/internal-sync
    Then the API receives headers:
      | Header        | Value             |
      | X-Service-Id  | data-sync-service |
      | X-PAT-Id      | pat-data-sync     |
      | X-PAT-Scope   | WRITE             |
    And the API can identify the calling service

  Scenario: Multiple services with different PATs
    Given service "stats-importer" has PAT with WRITE scope
    And service "backup-service" has PAT with READ_ONLY scope
    When each service accesses /api/v1/service/sync-data
    Then stats-importer request succeeds with 200 OK
    And backup-service request fails with 403 Forbidden

  Scenario: Service endpoint rate limiting by service ID
    Given service "heavy-loader" has a PAT with WRITE scope
    When the service makes 1000 requests in 1 minute
    Then the first 500 requests succeed
    And subsequent requests return 429 Too Many Requests
    And rate limits are tracked per service ID

  # =============================================================================
  # AUTHORIZATION HEADERS
  # =============================================================================

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

  Scenario: All role levels include complete headers
    Given users of different roles are authenticated
    When each user accesses their respective endpoints:
      | Role        | Endpoint                   |
      | SUPER_ADMIN | /api/v1/superadmin/admins  |
      | ADMIN       | /api/v1/admin/leagues      |
      | PLAYER      | /api/v1/player/leagues     |
    Then each request includes complete headers:
      | Header       | Presence |
      | X-User-Id    | Always   |
      | X-User-Email | Always   |
      | X-User-Role  | Always   |
      | X-Google-Id  | Always   |

  Scenario: Headers cannot be spoofed by clients
    Given a client attempts to send fake headers:
      | Header       | Fake Value    |
      | X-User-Id    | fake-admin    |
      | X-User-Role  | SUPER_ADMIN   |
    When the request reaches Envoy
    Then Envoy strips all X-User-* and X-PAT-* headers
    And only headers from auth service are passed to API
    And the spoofed headers are ignored

  # =============================================================================
  # NETWORK SECURITY
  # =============================================================================

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

  Scenario: Envoy validates auth service response before forwarding
    Given Envoy receives a request with valid-looking token
    When auth service returns unexpected response:
      | Response Code | Action                    |
      | 200           | Forward to API            |
      | 403           | Block with 401/403        |
      | 500           | Block with 503            |
      | Timeout       | Block with 504            |
    Then Envoy only forwards on explicit 200 OK from auth service

  # =============================================================================
  # COMPREHENSIVE AUDIT LOGGING
  # =============================================================================

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

  Scenario: Audit logging for successful access
    Given a SUPER_ADMIN user accesses /api/v1/superadmin/admins
    When the request succeeds with 200 OK
    Then an audit log entry is created:
      | Field      | Value                        |
      | userId     | superadmin-user-id           |
      | role       | SUPER_ADMIN                  |
      | endpoint   | /api/v1/superadmin/admins    |
      | method     | GET                          |
      | result     | SUCCESS                      |
      | statusCode | 200                          |
      | timestamp  | current_timestamp            |

  Scenario: Audit logging for authentication failures
    Given an expired token is used to access /api/v1/player/leagues
    When the request is blocked with 401 Unauthorized
    Then an audit log entry is created:
      | Field      | Value                        |
      | tokenType  | GOOGLE_JWT                   |
      | endpoint   | /api/v1/player/leagues       |
      | result     | BLOCKED_TOKEN_EXPIRED        |
      | timestamp  | current_timestamp            |
      | clientIp   | request_source_ip            |

  Scenario: Audit logging for sensitive operations
    Given a SUPER_ADMIN performs sensitive operations:
      | Operation                          |
      | Create new admin                   |
      | Delete admin                       |
      | Promote user to SUPER_ADMIN        |
      | Create system PAT                  |
      | Revoke PAT                         |
      | Modify system configuration        |
    When each operation is performed
    Then audit log entries include:
      | Field           | Presence |
      | operationType   | Always   |
      | performedBy     | Always   |
      | targetResource  | Always   |
      | previousState   | When applicable |
      | newState        | When applicable |
      | justification   | Optional |

  Scenario: Audit logging for resource ownership violations
    Given an ADMIN attempts to modify another admin's league
    When the API returns 403 for ownership violation
    Then an audit log entry is created:
      | Field           | Value                            |
      | userId          | requesting-admin-id              |
      | resourceId      | league-not-owned                 |
      | resourceOwnerId | actual-owner-id                  |
      | result          | BLOCKED_NOT_OWNER                |
      | endpoint        | /api/v1/admin/leagues/league-id  |

  Scenario: Audit logs are immutable
    Given audit logs have been created
    When any attempt is made to modify or delete audit logs
    Then the operation is blocked
    And an alert is generated
    And the attempt is logged in a separate security log

  Scenario: Audit logs include request correlation ID
    Given a request with correlation ID "corr-123-abc" is made
    When the request is processed (success or failure)
    Then the audit log includes correlationId: "corr-123-abc"
    And related log entries can be traced by correlation ID

  # =============================================================================
  # IMPERSONATION
  # =============================================================================

  Scenario: SUPER_ADMIN can impersonate other users
    Given a SUPER_ADMIN "super-admin-1" is authenticated
    And the SUPER_ADMIN wants to impersonate ADMIN "admin-123"
    When the SUPER_ADMIN sends a request with header:
      | Header            | Value      |
      | X-Impersonate-As  | admin-123  |
    Then the auth service validates impersonation permission
    And the request is processed with admin-123's context
    And audit log records the impersonation:
      | Field           | Value           |
      | impersonator    | super-admin-1   |
      | impersonated    | admin-123       |
      | action          | IMPERSONATION   |

  Scenario: SUPER_ADMIN impersonation sees user's resource view
    Given a SUPER_ADMIN impersonates ADMIN "admin-123"
    And admin-123 owns leagues: league-100, league-101
    When the SUPER_ADMIN (impersonating) accesses /api/v1/admin/leagues
    Then only league-100 and league-101 are returned
    And the response matches what admin-123 would see

  Scenario: ADMIN cannot impersonate other users
    Given an ADMIN "admin-1" is authenticated
    When the ADMIN sends a request with header:
      | Header            | Value      |
      | X-Impersonate-As  | player-123 |
    Then the impersonation header is ignored
    And the request is processed with admin-1's own context
    And a security warning is logged

  Scenario: PLAYER cannot impersonate other users
    Given a PLAYER "player-1" is authenticated
    When the PLAYER sends a request with header:
      | Header            | Value        |
      | X-Impersonate-As  | other-player |
    Then the impersonation header is ignored
    And the request is processed with player-1's own context

  Scenario: SUPER_ADMIN cannot impersonate another SUPER_ADMIN
    Given a SUPER_ADMIN "super-admin-1" is authenticated
    And another SUPER_ADMIN "super-admin-2" exists
    When super-admin-1 attempts to impersonate super-admin-2
    Then the impersonation is blocked
    And a security alert is generated
    And the request fails with 403 Forbidden

  # =============================================================================
  # DELEGATED PERMISSIONS
  # =============================================================================

  Scenario: Admin delegates league management to another admin
    Given an ADMIN "admin-1" owns league "league-100"
    And ADMIN "admin-2" exists but doesn't own league-100
    When admin-1 grants delegation to admin-2 for league-100:
      | Delegation Type | Permissions              |
      | FULL            | All management actions   |
    Then admin-2 can manage league-100 as if they owned it
    And delegation is recorded in audit log

  Scenario: Delegated admin can perform allowed actions
    Given ADMIN "admin-2" has delegated access to league "league-100"
    With permissions: VIEW, EDIT (not DELETE)
    When admin-2 attempts:
      | Action                            | Expected Result   |
      | View league-100 details           | 200 OK            |
      | Edit league-100 configuration     | 200 OK            |
      | Delete league-100                 | 403 Forbidden     |
    Then actions are restricted to delegated permissions

  Scenario: Admin revokes delegation
    Given ADMIN "admin-1" has delegated access to ADMIN "admin-2" for league-100
    When admin-1 revokes the delegation
    Then admin-2 can no longer access league-100
    And revocation is recorded in audit log

  Scenario: Delegation expires automatically
    Given ADMIN "admin-1" grants time-limited delegation to admin-2
    With expiration: 24 hours from now
    When 25 hours pass
    Then admin-2's delegation is automatically revoked
    And access attempts return 403 Forbidden
    And expiration is recorded in audit log

  Scenario: SUPER_ADMIN can view all delegations
    Given multiple delegations exist in the system
    When a SUPER_ADMIN accesses /api/v1/superadmin/delegations
    Then all active delegations are listed
    And the SUPER_ADMIN can revoke any delegation

  # =============================================================================
  # ENDPOINT SECURITY REQUIREMENTS
  # =============================================================================

  Scenario: Role hierarchy respected
    Given the role hierarchy is: SUPER_ADMIN > ADMIN > PLAYER
    Then SUPER_ADMIN can access: /api/v1/superadmin/*, /api/v1/admin/*, /api/v1/player/*
    And ADMIN can access: /api/v1/admin/*, /api/v1/player/*
    And PLAYER can access: /api/v1/player/*
    And lower roles cannot access higher role endpoints

  Scenario: Endpoint patterns are correctly matched
    Given endpoint patterns are defined:
      | Pattern                      | Required Role |
      | /api/v1/superadmin/**        | SUPER_ADMIN   |
      | /api/v1/admin/**             | ADMIN         |
      | /api/v1/player/**            | PLAYER        |
      | /api/v1/service/**           | PAT_WRITE     |
      | /api/v1/public/**            | NONE          |
    When requests are made with various paths
    Then pattern matching follows most-specific-first rule
    And wildcards are correctly expanded

  Scenario: New endpoints default to most restrictive access
    Given a new endpoint /api/v1/admin/new-feature is deployed
    When no explicit security rule is configured
    Then the endpoint defaults to SUPER_ADMIN only access
    And all non-SUPER_ADMIN requests are blocked
    And a configuration warning is logged

  # =============================================================================
  # API ERROR RESPONSES
  # =============================================================================

  Scenario: Authorization errors return consistent format
    Given various authorization failures occur
    When error responses are generated
    Then all responses follow the format:
      | Field      | Type    | Description                |
      | error      | String  | Error code                 |
      | message    | String  | Human-readable message     |
      | timestamp  | ISO8601 | When error occurred        |
      | requestId  | String  | Correlation ID             |

  Scenario: Error messages do not leak sensitive information
    Given an authorization failure occurs
    When the error response is generated
    Then the response does not include:
      | Sensitive Data              |
      | Internal user IDs           |
      | Database query details      |
      | Stack traces                |
      | Internal endpoint paths     |
      | Token values                |
    And only safe, generic messages are returned

  Scenario: Rate limit errors include retry information
    Given a client exceeds rate limits
    When the 429 response is generated
    Then the response includes:
      | Header         | Description                    |
      | Retry-After    | Seconds until limit resets     |
      | X-RateLimit-Limit | Maximum requests allowed    |
      | X-RateLimit-Remaining | Requests remaining       |
      | X-RateLimit-Reset | Timestamp when limit resets  |

  # =============================================================================
  # SESSION MANAGEMENT
  # =============================================================================

  Scenario: User sessions are tracked
    Given a user authenticates via Google OAuth
    When the authentication succeeds
    Then a session record is created:
      | Field         | Value                  |
      | userId        | user-id                |
      | sessionId     | unique-session-id      |
      | createdAt     | current_timestamp      |
      | expiresAt     | timestamp + TTL        |
      | clientIp      | request_source_ip      |
      | userAgent     | client_user_agent      |

  Scenario: Users can list their active sessions
    Given a PLAYER "player-1" has multiple active sessions
    When player-1 accesses /api/v1/player/sessions
    Then all active sessions are listed
    And each session shows device/browser information

  Scenario: Users can terminate specific sessions
    Given a PLAYER "player-1" has session "session-123"
    When player-1 calls DELETE /api/v1/player/sessions/session-123
    Then the session is terminated
    And requests using that session's token are rejected
    And other sessions remain active

  Scenario: SUPER_ADMIN can terminate any user session
    Given a SUPER_ADMIN is authenticated
    And PLAYER "player-1" has active session "session-123"
    When the SUPER_ADMIN calls:
      DELETE /api/v1/superadmin/users/player-1/sessions/session-123
    Then the session is terminated
    And an audit log records the administrative action

  Scenario: Concurrent session limits enforced
    Given the system allows maximum 5 concurrent sessions per user
    And a PLAYER "player-1" has 5 active sessions
    When player-1 attempts a 6th authentication
    Then the oldest session is automatically terminated
    And the new session is created
    And the user is notified of session limit

  # =============================================================================
  # RATE LIMITING BY ROLE
  # =============================================================================

  Scenario: Rate limits vary by role
    Given rate limits are configured:
      | Role        | Requests/Minute |
      | SUPER_ADMIN | 1000            |
      | ADMIN       | 500             |
      | PLAYER      | 200             |
      | Public      | 60              |
    When users of each role make requests
    Then rate limits are enforced per role

  Scenario: Rate limit exceeded returns proper error
    Given a PLAYER exceeds their rate limit of 200 requests/minute
    When the 201st request is made
    Then the response is 429 Too Many Requests
    And the response includes:
      | Header              | Value           |
      | Retry-After         | seconds_to_wait |
      | X-RateLimit-Limit   | 200             |
      | X-RateLimit-Remaining | 0             |

  Scenario: PAT rate limits are separate from user rate limits
    Given a user has both OAuth token and PAT
    When the user makes 200 requests with OAuth token
    And then makes requests with PAT
    Then PAT requests are not affected by OAuth rate limit
    And each authentication method has independent limits

  Scenario: Rate limits reset correctly
    Given a PLAYER has exceeded their rate limit
    And 1 minute passes
    When the player makes a new request
    Then the request succeeds
    And the rate limit counter is reset

  # =============================================================================
  # MOBILE AND API CLIENTS
  # =============================================================================

  Scenario: Mobile app uses OAuth token
    Given a mobile client authenticates via Google OAuth
    When the client includes the token in Authorization header
    Then requests are processed normally
    And mobile-specific headers are recognized:
      | Header            | Value        |
      | X-Client-Type     | mobile-ios   |
      | X-App-Version     | 2.1.0        |

  Scenario: Web app uses OAuth token
    Given a web browser authenticates via Google OAuth
    When the client includes the token in Authorization header
    Then requests are processed normally
    And web-specific headers are recognized

  Scenario: API clients use PAT
    Given an API integration client has a PAT
    When the client includes the PAT in Authorization header
    Then requests are processed as service requests
    And service-specific rate limits apply

  Scenario: Unknown client type uses conservative limits
    Given a client with unknown type makes requests
    When no client identification headers are present
    Then conservative rate limits apply
    And the client is treated as potentially automated

  # =============================================================================
  # EDGE CASES AND ERROR HANDLING
  # =============================================================================

  Scenario: User with no role assigned
    Given a user exists but has no role assigned
    When the user attempts to access any protected endpoint
    Then all requests are blocked with 403 Forbidden
    And the response includes "No role assigned"
    And an alert is generated for user without role

  Scenario: Race condition in role update
    Given an ADMIN user's role is being changed to PLAYER
    And the user has an active request in flight
    When the role change completes
    Then in-flight requests complete with original role
    And subsequent requests use new PLAYER role
    And no inconsistent state occurs

  Scenario: Auth service unavailable
    Given the auth service is temporarily unavailable
    When a request reaches Envoy
    Then Envoy returns 503 Service Unavailable
    And the response includes "Authentication service temporarily unavailable"
    And retry logic allows eventual success

  Scenario: Database unavailable during authorization
    Given the database is temporarily unavailable
    When the auth service attempts to validate a request
    Then the auth service returns 503 to Envoy
    And Envoy returns 503 to the client
    And cached authorizations may be used if within TTL

  Scenario: Token with future expiration date
    Given a token has expiration date in the distant future (year 2100)
    When the token is validated
    Then the token is rejected as invalid
    And a security alert is generated
    And the response includes "Invalid token expiration"

  Scenario: Request with multiple Authorization headers
    Given a request includes multiple Authorization headers
    When Envoy processes the request
    Then only the first valid header is used
    And subsequent headers are ignored
    And a warning is logged

  Scenario: Very long Authorization header
    Given a request includes an Authorization header > 8KB
    When Envoy processes the request
    Then the request is rejected with 400 Bad Request
    And the response includes "Header too large"

  Scenario: Special characters in user identity
    Given a user with email "user+special@example.com"
    When the user authenticates and makes requests
    Then the email is properly encoded in headers
    And the API correctly decodes the email
    And no injection vulnerabilities exist
