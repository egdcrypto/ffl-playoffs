@infrastructure @priority_2 @depends-FFL-3 @depends-FFL-4 @depends-FFL-22
Feature: Envoy Gateway with External Authorization
  As a system architect
  I want to use Envoy as an API gateway with external authorization
  So that authentication/authorization is handled at the gateway level before reaching the backend API

  Background:
    Given the Envoy gateway is running on port 8080
    And the auth service is running on port 9000
    And the backend API is running on port 8090
    And MongoDB is available for token storage

  # Architecture Overview:
  # Client → Envoy (8080) → Auth Service (9000) → if OK → Backend API (8090)
  #                              ↓
  #                          MongoDB (PAT/session lookup)

  @gateway @authentication
  Scenario: Envoy intercepts requests and validates JWT tokens
    Given a user has a valid JWT token
    When the user makes a request to the API through Envoy
    Then Envoy calls the auth service with the authorization header
    And the auth service validates the JWT signature
    And the auth service returns user context headers:
      | header        | description           |
      | x-user-id     | User's unique ID      |
      | x-user-email  | User's email address  |
      | x-user-roles  | Comma-separated roles |
      | x-auth-method | "jwt"                 |
    And Envoy forwards the request to the backend with these headers
    And the backend receives the authenticated user context

  @gateway @authentication
  Scenario: Envoy intercepts requests and validates PAT tokens
    Given a user has a valid Personal Access Token
    When the user makes a request to the API through Envoy
    Then Envoy calls the auth service with the authorization header
    And the auth service looks up the PAT hash in MongoDB
    And the auth service retrieves the associated user
    And the auth service returns user context headers with x-auth-method "pat"
    And Envoy forwards the request to the backend

  @gateway @authentication @negative
  Scenario: Envoy rejects requests with invalid tokens
    Given a user has an invalid or expired token
    When the user makes a request to the API through Envoy
    Then Envoy calls the auth service with the authorization header
    And the auth service returns 401 Unauthorized
    And Envoy returns 401 to the client without calling the backend

  @gateway @authentication @negative
  Scenario: Envoy rejects requests without authorization header
    Given a request has no authorization header
    When the request is sent to the API through Envoy
    Then Envoy calls the auth service
    And the auth service returns 401 Unauthorized
    And Envoy returns 401 to the client

  @docker @deployment
  Scenario: All services run via docker-compose
    Given the docker-compose.yml is configured
    When I run "docker-compose up"
    Then the following services start:
      | service       | port | description                    |
      | envoy         | 8080 | API Gateway                    |
      | auth-service  | 9000 | External authorization service |
      | backend-api   | 8090 | Java Spring Boot API           |
      | mongodb       | 27017| Database                       |
      | nfl-data-sync | 8001 | NFL data sync service          |
    And all services pass health checks
    And Envoy can reach auth-service
    And Envoy can reach backend-api

  @configuration
  Scenario: Envoy configuration includes ext_authz filter
    Given the envoy.yaml configuration file
    Then it should have:
      | setting                    | value                                      |
      | listener port              | 8080                                       |
      | ext_authz filter           | envoy.filters.http.ext_authz               |
      | auth service cluster       | auth_service on port 9000                  |
      | backend cluster            | backend_cluster on port 8090               |
      | allowed_headers            | authorization, x-forwarded-for             |
      | allowed_upstream_headers   | x-user-id, x-user-email, x-user-roles      |

  @auth-service @implementation
  Scenario: Auth service validates both JWT and PAT
    Given the auth service is configured with:
      | setting      | value                     |
      | JWT_SECRET   | From environment variable |
      | JWT_ENABLED  | true                      |
      | PAT_ENABLED  | true                      |
      | MONGODB_URI  | mongodb://mongodb:27017   |
    When a bearer token is received
    Then the service first attempts JWT validation
    And if JWT fails, falls back to PAT validation
    And returns appropriate user context on success

  @tls @security
  Scenario: Envoy supports mTLS for backend communication
    Given mTLS certificates are generated
    When Envoy communicates with the backend
    Then TLS encryption is used
    And client certificates are validated

  # Implementation files needed:
  # - gateway/envoy.yaml (Envoy configuration)
  # - gateway/auth-service/auth_server.py (Python auth service)
  # - gateway/auth-service/Dockerfile
  # - gateway/auth-service/requirements.txt
  # - docker-compose.yml (orchestrate all services)
  # - ffl-playoffs-api/Dockerfile (backend containerization)
