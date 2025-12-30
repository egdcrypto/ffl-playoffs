@infrastructure @gateway @security @priority-critical
Feature: FFL-42: Envoy Gateway with External Authorization
  As a platform security architect
  I want to implement Envoy as an API gateway with external authorization
  So that all API requests are authenticated and authorized before reaching the backend

  Background:
    Given the Envoy gateway is running on port 8080
    And the external auth service is running on port 9000
    And the backend API is running on port 8090
    And MongoDB is available at port 27017
    And all services are containerized with Docker

  # ========================================
  # SECTION 1: JWT TOKEN VALIDATION
  # ========================================

  @jwt @validation @priority-critical
  Scenario: Validate JWT token with correct signature
    Given a user has a valid JWT token with claims:
      | claim     | value                          |
      | sub       | user-123                       |
      | email     | user@example.com               |
      | roles     | ["PLAYER", "ADMIN"]            |
      | iat       | current timestamp              |
      | exp       | current timestamp + 1 hour     |
    When the user makes a GET request to "/api/leagues" through Envoy
    Then Envoy forwards the Authorization header to the auth service
    And the auth service validates the JWT signature using the secret key
    And the auth service extracts user claims from the token
    And the auth service returns 200 OK with headers:
      | header          | value                |
      | x-user-id       | user-123             |
      | x-user-email    | user@example.com     |
      | x-user-roles    | PLAYER,ADMIN         |
      | x-auth-method   | jwt                  |
    And Envoy forwards the request to the backend with user context headers
    And the backend processes the authenticated request

  @jwt @validation @priority-critical
  Scenario: Validate JWT token with Google OAuth claims
    Given a user authenticated with Google OAuth
    And the JWT contains Google-specific claims:
      | claim         | value                              |
      | iss           | https://accounts.google.com        |
      | aud           | ffl-playoffs-client-id             |
      | sub           | google-user-id-12345               |
      | email         | player@gmail.com                   |
      | email_verified| true                               |
      | name          | John Player                        |
    When the user makes a request through Envoy
    Then the auth service validates the Google JWT
    And the auth service verifies the issuer and audience
    And the auth service returns user context with Google user ID

  @jwt @expiration @priority-critical
  Scenario: Reject expired JWT token
    Given a user has a JWT token that expired 5 minutes ago
    When the user makes a request through Envoy
    Then the auth service detects the token is expired
    And the auth service returns 401 Unauthorized with body:
      """
      {
        "error": "TOKEN_EXPIRED",
        "message": "JWT token has expired",
        "expired_at": "<expiration timestamp>"
      }
      """
    And Envoy returns 401 to the client
    And the request is NOT forwarded to the backend

  @jwt @signature @priority-critical
  Scenario: Reject JWT token with invalid signature
    Given a user has a JWT token signed with wrong secret
    When the user makes a request through Envoy
    Then the auth service fails to verify the signature
    And the auth service returns 401 Unauthorized with body:
      """
      {
        "error": "INVALID_SIGNATURE",
        "message": "JWT signature verification failed"
      }
      """
    And Envoy returns 401 to the client

  @jwt @malformed @priority-high
  Scenario: Reject malformed JWT token
    Given a user has a malformed JWT token "not.a.valid.jwt"
    When the user makes a request through Envoy
    Then the auth service fails to parse the token
    And the auth service returns 401 Unauthorized with error "MALFORMED_TOKEN"

  @jwt @claims @priority-high
  Scenario: Reject JWT token with missing required claims
    Given a user has a JWT token missing the "sub" claim
    When the user makes a request through Envoy
    Then the auth service detects missing required claim
    And the auth service returns 401 Unauthorized with error "MISSING_CLAIMS"

  # ========================================
  # SECTION 2: PAT TOKEN VALIDATION
  # ========================================

  @pat @validation @priority-critical
  Scenario: Validate Personal Access Token from MongoDB
    Given a user has a valid Personal Access Token "ffl_pat_abc123xyz"
    And the PAT exists in MongoDB with:
      | field       | value                |
      | tokenHash   | SHA256 hash of token |
      | userId      | user-456             |
      | name        | "API Access Token"   |
      | scopes      | ["read", "write"]    |
      | expiresAt   | future timestamp     |
      | lastUsedAt  | null                 |
    When the user makes a request with header "Authorization: Bearer ffl_pat_abc123xyz"
    Then the auth service hashes the token
    And the auth service looks up the hash in MongoDB
    And the auth service retrieves the associated user
    And the auth service returns 200 OK with headers:
      | header          | value        |
      | x-user-id       | user-456     |
      | x-auth-method   | pat          |
      | x-pat-scopes    | read,write   |
    And the PAT's lastUsedAt is updated in MongoDB

  @pat @expiration @priority-critical
  Scenario: Reject expired Personal Access Token
    Given a PAT exists in MongoDB with expiresAt in the past
    When the user makes a request with this PAT
    Then the auth service finds the PAT but detects expiration
    And the auth service returns 401 Unauthorized with error "PAT_EXPIRED"
    And the request is NOT forwarded to the backend

  @pat @revoked @priority-high
  Scenario: Reject revoked Personal Access Token
    Given a PAT exists in MongoDB with isRevoked = true
    When the user makes a request with this PAT
    Then the auth service returns 401 Unauthorized with error "PAT_REVOKED"

  @pat @notfound @priority-high
  Scenario: Reject unknown Personal Access Token
    Given a PAT "ffl_pat_unknown999" does not exist in MongoDB
    When the user makes a request with this PAT
    Then the auth service fails to find the token hash
    And the auth service returns 401 Unauthorized with error "PAT_NOT_FOUND"

  @pat @scopes @priority-high
  Scenario: Validate PAT scopes for operation
    Given a PAT has only "read" scope
    When the user makes a POST request (write operation)
    Then the auth service validates the PAT
    And the auth service checks scope requirements
    And the auth service returns 403 Forbidden with error "INSUFFICIENT_SCOPE"

  @pat @ratelimit @priority-medium
  Scenario: Rate limit PAT usage
    Given a PAT has exceeded 1000 requests per hour
    When the user makes another request
    Then the auth service returns 429 Too Many Requests
    And the response includes Retry-After header

  # ========================================
  # SECTION 3: TOKEN REJECTION SCENARIOS
  # ========================================

  @rejection @noheader @priority-critical
  Scenario: Reject request without Authorization header
    Given a request has no Authorization header
    When the request is sent to Envoy
    Then Envoy calls the auth service without credentials
    And the auth service returns 401 Unauthorized with error "NO_CREDENTIALS"
    And Envoy returns 401 to the client

  @rejection @invalidscheme @priority-high
  Scenario: Reject request with unsupported auth scheme
    Given a request has header "Authorization: Basic dXNlcjpwYXNz"
    When the request is sent to Envoy
    Then the auth service rejects the Basic auth scheme
    And returns 401 Unauthorized with error "UNSUPPORTED_AUTH_SCHEME"
    And the error message indicates only Bearer tokens are supported

  @rejection @emptytoken @priority-high
  Scenario: Reject request with empty Bearer token
    Given a request has header "Authorization: Bearer "
    When the request is sent to Envoy
    Then the auth service returns 401 Unauthorized with error "EMPTY_TOKEN"

  @rejection @fallback @priority-high
  Scenario: JWT validation fails, fallback to PAT validation
    Given a token that is not a valid JWT
    And the token matches a valid PAT in MongoDB
    When the request is sent to Envoy
    Then the auth service first attempts JWT validation
    And JWT validation fails (not a JWT format)
    And the auth service falls back to PAT validation
    And PAT validation succeeds
    And the request is forwarded to the backend

  @rejection @bothtypes @priority-medium
  Scenario: Neither JWT nor PAT validation succeeds
    Given a token that is neither valid JWT nor valid PAT
    When the request is sent to Envoy
    Then JWT validation fails
    And PAT validation fails
    And the auth service returns 401 Unauthorized with error "INVALID_CREDENTIALS"

  # ========================================
  # SECTION 4: DOCKER-COMPOSE SETUP
  # ========================================

  @docker @compose @priority-critical
  Scenario: Define all services in docker-compose.yml
    Given docker-compose.yml is configured
    Then it should define the following services:
      | service        | image                    | port  | depends_on      |
      | envoy          | envoyproxy/envoy:v1.28   | 8080  | auth-service    |
      | auth-service   | ffl/auth-service:latest  | 9000  | mongodb         |
      | backend-api    | ffl/backend-api:latest   | 8090  | mongodb         |
      | mongodb        | mongo:7.0                | 27017 | -               |
      | redis          | redis:7-alpine           | 6379  | -               |

  @docker @network @priority-high
  Scenario: Configure Docker network for service communication
    Given all services need internal communication
    When docker-compose starts
    Then all services should be on the "ffl-network" network
    And services can reach each other by service name
    And only Envoy port 8080 is exposed externally

  @docker @volumes @priority-high
  Scenario: Configure volumes for persistent data
    Given data needs to persist across restarts
    Then docker-compose should define volumes:
      | volume          | mount point         | service   |
      | mongodb_data    | /data/db            | mongodb   |
      | envoy_config    | /etc/envoy          | envoy     |

  @docker @healthcheck @priority-high
  Scenario: Configure health checks for all services
    Given services need health monitoring
    Then each service should have a health check:
      | service        | endpoint              | interval |
      | envoy          | /ready                | 10s      |
      | auth-service   | /health               | 10s      |
      | backend-api    | /actuator/health      | 10s      |
      | mongodb        | mongosh ping          | 10s      |

  @docker @environment @priority-high
  Scenario: Configure environment variables
    Given services need configuration
    Then environment variables should be set:
      | service        | variable              | source              |
      | auth-service   | JWT_SECRET            | .env file           |
      | auth-service   | MONGODB_URI           | mongodb://mongodb   |
      | backend-api    | SPRING_DATA_MONGODB_URI| mongodb://mongodb  |
      | backend-api    | SERVER_PORT           | 8090                |

  @docker @startup @priority-critical
  Scenario: Services start in correct order
    Given docker-compose up is executed
    Then services should start in order:
      | order | service        |
      | 1     | mongodb        |
      | 2     | redis          |
      | 3     | auth-service   |
      | 4     | backend-api    |
      | 5     | envoy          |
    And each service waits for dependencies to be healthy

  # ========================================
  # SECTION 5: EXT_AUTHZ FILTER CONFIGURATION
  # ========================================

  @envoy @extauthz @priority-critical
  Scenario: Configure ext_authz filter in Envoy
    Given envoy.yaml configuration file
    Then the HTTP filter chain should include:
      """
      - name: envoy.filters.http.ext_authz
        typed_config:
          "@type": type.googleapis.com/envoy.extensions.filters.http.ext_authz.v3.ExtAuthz
          grpc_service:
            envoy_grpc:
              cluster_name: auth_service
            timeout: 1s
          failure_mode_allow: false
          with_request_body:
            max_request_bytes: 8192
            allow_partial_message: true
      """

  @envoy @extauthz @priority-high
  Scenario: Configure allowed headers to forward to auth service
    Given Envoy needs to forward specific headers
    Then ext_authz should be configured with:
      | setting                      | headers                           |
      | allowed_headers              | authorization, x-forwarded-for    |
      | allowed_headers              | x-request-id, content-type        |
      | headers_to_add               | x-envoy-external-address          |

  @envoy @extauthz @priority-high
  Scenario: Configure headers to forward to backend
    Given auth service returns user context headers
    Then ext_authz should allow upstream headers:
      | header              | description                |
      | x-user-id           | Authenticated user ID      |
      | x-user-email        | User's email address       |
      | x-user-roles        | User's roles               |
      | x-auth-method       | jwt or pat                 |
      | x-pat-scopes        | PAT scopes if applicable   |

  @envoy @cluster @priority-high
  Scenario: Configure auth service cluster
    Given auth service runs on port 9000
    Then Envoy cluster configuration should be:
      """
      - name: auth_service
        type: STRICT_DNS
        lb_policy: ROUND_ROBIN
        http2_protocol_options: {}
        load_assignment:
          cluster_name: auth_service
          endpoints:
            - lb_endpoints:
                - endpoint:
                    address:
                      socket_address:
                        address: auth-service
                        port_value: 9000
      """

  @envoy @cluster @priority-high
  Scenario: Configure backend API cluster
    Given backend API runs on port 8090
    Then Envoy cluster configuration should include backend_cluster
    And the cluster should use HTTP/1.1 for Spring Boot compatibility
    And load balancing should be ROUND_ROBIN

  @envoy @routes @priority-high
  Scenario: Configure route matching for API requests
    Given API requests should be routed to backend
    Then Envoy routes should be configured:
      | match prefix | cluster          | require_auth |
      | /api/        | backend_cluster  | true         |
      | /health      | backend_cluster  | false        |
      | /actuator/   | backend_cluster  | false        |

  @envoy @bypass @priority-medium
  Scenario: Bypass authentication for health endpoints
    Given health check endpoints should not require auth
    When a request is made to /health or /actuator/health
    Then the request should bypass ext_authz filter
    And be forwarded directly to the backend

  # ========================================
  # SECTION 6: MTLS CONFIGURATION
  # ========================================

  @mtls @certificates @priority-high
  Scenario: Generate mTLS certificates for services
    Given mTLS is required for internal communication
    When I generate certificates
    Then the following certificates should be created:
      | certificate        | purpose                    |
      | ca.crt             | Certificate Authority      |
      | envoy.crt          | Envoy server certificate   |
      | envoy.key          | Envoy private key          |
      | auth-service.crt   | Auth service certificate   |
      | auth-service.key   | Auth service private key   |
      | backend-api.crt    | Backend API certificate    |
      | backend-api.key    | Backend API private key    |

  @mtls @envoy @priority-high
  Scenario: Configure Envoy for mTLS to auth service
    Given mTLS certificates are available
    Then Envoy transport socket should be configured:
      """
      transport_socket:
        name: envoy.transport_sockets.tls
        typed_config:
          "@type": type.googleapis.com/envoy.extensions.transport_sockets.tls.v3.UpstreamTlsContext
          common_tls_context:
            tls_certificates:
              - certificate_chain:
                  filename: /etc/envoy/certs/envoy.crt
                private_key:
                  filename: /etc/envoy/certs/envoy.key
            validation_context:
              trusted_ca:
                filename: /etc/envoy/certs/ca.crt
      """

  @mtls @backend @priority-high
  Scenario: Configure mTLS for backend communication
    Given Envoy needs secure communication with backend
    Then the backend cluster should use TLS transport socket
    And client certificates should be presented
    And server certificates should be validated against CA

  @mtls @verification @priority-medium
  Scenario: Verify mTLS connection establishment
    Given mTLS is configured for all services
    When services communicate
    Then TLS handshake should complete successfully
    And client certificates should be verified
    And connections without valid certificates should be rejected

  # ========================================
  # SECTION 7: SECURITY SCENARIOS
  # ========================================

  @security @injection @priority-critical
  Scenario: Prevent header injection attacks
    Given a malicious request includes injected headers:
      | header       | value          |
      | x-user-id    | attacker-123   |
      | x-user-roles | SUPER_ADMIN    |
    When the request is sent through Envoy
    Then Envoy should strip these headers before forwarding to auth service
    And only auth service can set x-user-* headers
    And the backend should receive only legitimate headers

  @security @replay @priority-high
  Scenario: Prevent token replay attacks
    Given JWT tokens include jti (JWT ID) claim
    When the same token is used multiple times
    Then the auth service should track used jti values
    And reject tokens with previously seen jti after threshold
    Or implement sliding window rate limiting per token

  @security @bruteforce @priority-high
  Scenario: Protect against brute force attacks
    Given an attacker sends multiple invalid tokens
    When more than 10 failed attempts occur from same IP in 1 minute
    Then the auth service should temporarily block the IP
    And return 429 Too Many Requests
    And log the suspicious activity

  @security @logging @priority-high
  Scenario: Log authentication events for audit
    Given authentication attempts are made
    Then the auth service should log:
      | event                  | fields                              |
      | AUTH_SUCCESS           | userId, method, timestamp, ip       |
      | AUTH_FAILURE           | reason, timestamp, ip, token_prefix |
      | TOKEN_EXPIRED          | userId, expiredAt, timestamp        |
      | SUSPICIOUS_ACTIVITY    | ip, reason, timestamp               |

  @security @cors @priority-medium
  Scenario: Configure CORS policy in Envoy
    Given frontend requests come from different origins
    Then Envoy should configure CORS:
      | setting                    | value                        |
      | allow_origin_string_match  | exact: https://fflplayoffs.com |
      | allow_methods              | GET, POST, PUT, DELETE       |
      | allow_headers              | Authorization, Content-Type  |
      | expose_headers             | X-Request-Id                 |
      | max_age                    | 86400                        |

  @security @ratelimit @priority-high
  Scenario: Configure global rate limiting
    Given API endpoints need rate limiting
    Then Envoy should configure rate limiting:
      | endpoint     | limit        | window  |
      | /api/*       | 100 requests | 1 minute|
      | /api/auth/*  | 20 requests  | 1 minute|
    And rate limit headers should be included in responses

  @security @timeout @priority-medium
  Scenario: Configure appropriate timeouts
    Given requests should not hang indefinitely
    Then Envoy should configure timeouts:
      | setting              | value   |
      | connection_timeout   | 5s      |
      | request_timeout      | 30s     |
      | idle_timeout         | 300s    |
      | ext_authz_timeout    | 1s      |

  # ========================================
  # SECTION 8: AUTH SERVICE IMPLEMENTATION
  # ========================================

  @authservice @grpc @priority-critical
  Scenario: Implement auth service with gRPC ext_authz protocol
    Given auth service implements Envoy ext_authz protocol
    Then the service should implement:
      | method  | request                    | response                  |
      | Check   | CheckRequest with headers  | CheckResponse with status |
    And the service should be gRPC-based on port 9000
    And support streaming for performance

  @authservice @response @priority-high
  Scenario: Auth service returns proper response structure
    Given a valid authentication request
    When auth service validates successfully
    Then the response should include:
      """
      {
        "status": {"code": 0},
        "ok_response": {
          "headers": [
            {"header": {"key": "x-user-id", "value": "user-123"}},
            {"header": {"key": "x-user-email", "value": "user@example.com"}},
            {"header": {"key": "x-user-roles", "value": "PLAYER,ADMIN"}}
          ]
        }
      }
      """

  @authservice @deny @priority-high
  Scenario: Auth service returns proper denial response
    Given an invalid authentication request
    When auth service rejects the request
    Then the response should include:
      """
      {
        "status": {"code": 16},
        "denied_response": {
          "status": {"code": "Unauthorized"},
          "headers": [
            {"header": {"key": "content-type", "value": "application/json"}}
          ],
          "body": "{\"error\": \"INVALID_CREDENTIALS\"}"
        }
      }
      """

  @authservice @cache @priority-medium
  Scenario: Auth service caches validated tokens
    Given token validation is expensive
    When the same valid token is used within 5 minutes
    Then the auth service should return cached result
    And not re-validate the token
    And cache should be invalidated on token revocation
