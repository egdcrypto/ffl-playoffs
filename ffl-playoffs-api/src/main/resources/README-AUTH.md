# Authentication Service

## Overview
The authentication service is a standalone Spring Boot application that runs on `localhost:9191` and validates authentication tokens for Envoy's External Authorization (ext_authz) filter.

## Architecture

### Pod Deployment
The authentication service runs in the same Kubernetes pod as:
1. **Main API** - localhost:8080 (business logic)
2. **Auth Service** - localhost:9191 (token validation)
3. **Envoy Sidecar** - pod IP:443 (external entry point)

### Request Flow
```
Client Request
    ↓
Envoy (pod IP:443)
    ↓
Auth Service Check (localhost:9191/auth/check)
    ↓ (if authorized)
Main API (localhost:8080)
```

## Supported Authentication Methods

### 1. Google OAuth JWT Tokens
- **Format**: `Authorization: Bearer <google-jwt>`
- **Validation**:
  - JWT signature verified using Google's public keys
  - JWT expiration checked
  - Issuer validated (accounts.google.com)
  - User looked up in database by Google ID
  - Last login timestamp updated
- **Response Headers**:
  - `X-User-Id`: User UUID
  - `X-User-Email`: User email
  - `X-User-Role`: User role (SUPER_ADMIN, ADMIN, PLAYER)
  - `X-Google-Id`: Google OAuth ID
  - `X-Auth-Type`: USER

### 2. Personal Access Tokens (PATs)
- **Format**: `Authorization: Bearer pat_<token>`
- **Validation**:
  - Token matched against bcrypt hashes in database
  - Expiration checked
  - Revocation status checked
  - Last used timestamp updated
- **Response Headers**:
  - `X-Service-Id`: PAT name
  - `X-PAT-Scope`: PAT scope (READ_ONLY, WRITE, ADMIN)
  - `X-PAT-Id`: PAT UUID
  - `X-Auth-Type`: PAT

## Configuration

### Environment Variables
```bash
# Google OAuth Client ID (required)
export GOOGLE_OAUTH_CLIENT_ID=your-client-id.apps.googleusercontent.com

# MongoDB connection
export MONGODB_URI=mongodb://localhost:27017/ffl-playoffs
```

### Running Standalone
```bash
# Run auth service on port 9191
./gradlew bootRun --args='--spring.profiles.active=auth'
```

## Endpoints

### POST /auth/check
Main authorization endpoint called by Envoy ext_authz.

**Request**: All headers from original request
**Response**:
- `200 OK` with context headers if authorized
- `403 Forbidden` if authentication fails

### GET /auth/health
Health check endpoint.

**Response**: `200 OK` with status

## Envoy Configuration

```yaml
# Envoy ext_authz filter configuration
http_filters:
  - name: envoy.filters.http.ext_authz
    typed_config:
      "@type": type.googleapis.com/envoy.extensions.filters.http.ext_authz.v3.ExtAuthz
      http_service:
        server_uri:
          uri: http://localhost:9191
          cluster: auth_service
          timeout: 1s
        path_prefix: /auth
        authorization_request:
          allowed_headers:
            patterns:
              - exact: authorization
        authorization_response:
          allowed_upstream_headers:
            patterns:
              - prefix: x-user
              - prefix: x-pat
              - prefix: x-service
              - prefix: x-google
              - prefix: x-auth
```

## Security

### Network Isolation
- Auth service listens **only** on localhost:9191
- Not accessible from outside the pod
- All external traffic goes through Envoy
- Network policies prevent direct access

### Token Security
- PAT tokens hashed with bcrypt before storage
- Google JWT signatures verified with Google's public keys
- Failed authentication attempts logged
- Token usage tracked for audit

## Error Handling

### Common Errors
- **Missing Authorization header**: 401 Unauthorized
- **Malformed token**: 403 Forbidden
- **Expired token**: 403 Forbidden
- **Revoked PAT**: 403 Forbidden
- **User not found**: 403 Forbidden
- **Invalid signature**: 403 Forbidden

## Logging
All authentication attempts are logged at INFO level:
```
2025-10-01 22:30:15 - Authentication successful for: user@example.com
2025-10-01 22:30:20 - Authentication failed: Token has expired
```

## Testing

### Test Google JWT Authentication
```bash
curl -X POST http://localhost:9191/auth/check \
  -H "Authorization: Bearer <google-jwt-token>"
```

### Test PAT Authentication
```bash
curl -X POST http://localhost:9191/auth/check \
  -H "Authorization: Bearer pat_<your-token>"
```

### Health Check
```bash
curl http://localhost:9191/auth/health
```

## Database Dependencies

The auth service requires access to:
- **users** collection (User lookup by Google ID)
- **personal_access_tokens** collection (PAT validation)

Both collections must be accessible via the configured MongoDB URI.

## Implementation Details

### Classes
- **AuthService**: Main REST controller for ext_authz protocol
- **TokenValidator**: Interface for token validation
- **TokenValidatorImpl**: Orchestrates validation logic
- **GoogleJwtValidator**: Validates Google JWT tokens
- **PATValidator**: Validates PAT tokens
- **AuthenticationResult**: Result object with user/PAT context

### Repositories Used
- **UserRepository**: Find users by Google ID
- **PersonalAccessTokenRepository**: Find PATs by token hash

## Monitoring

### Metrics to Monitor
- Authentication success/failure rates
- Token validation latency
- PAT usage patterns
- Failed authentication attempts by IP

### Health Checks
- MongoDB connectivity
- Google OAuth reachability
- Memory and CPU usage
