# Authentication and Authorization - Implementation Requirements

> **ANIMA-1165**: Architecture review and implementation requirements for Authentication feature

## Overview

This document provides the Envoy security architecture validation, auth service domain model design, and implementation requirements for the Authentication and Authorization feature as specified in `features/ffl-3-authentication.feature`.

---

## Architecture Validation

### Envoy Security Architecture

The current Envoy configuration (`deployment/envoy.yaml`) correctly implements the sidecar security pattern:

| Component | Address | Purpose |
|-----------|---------|---------|
| Envoy Proxy | 0.0.0.0:443 | External entry point (TLS) |
| Auth Service | 127.0.0.1:9191 | Token validation (internal only) |
| Main API | 127.0.0.1:8080 | Business logic (internal only) |

**Security Boundaries**:
- External traffic → Envoy (443)
- Envoy → Auth Service (localhost:9191)
- Envoy → Main API (localhost:8080)
- Direct access to API/Auth blocked by network binding

**Route-Based Authorization** (from Envoy config):
```yaml
/api/v1/public/*     → No auth (pass-through)
/api/v1/superadmin/* → required_scope: ADMIN
/api/v1/admin/*      → required_scope: WRITE
/api/v1/player/*     → required_scope: READ_ONLY
/*                   → Default auth required
```

### Protocol Mismatch Issue

**Current Problem**: Envoy config specifies gRPC ext_authz but AuthService is REST-based.

```yaml
# Envoy config shows gRPC:
grpc_service:
  envoy_grpc:
    cluster_name: auth_service
```

**Resolution Options**:
1. **Option A**: Convert AuthService to gRPC using `envoy.service.auth.v3.Authorization` protocol
2. **Option B**: Change Envoy to HTTP ext_authz filter (simpler, recommended for MVP)

**Recommendation**: For initial implementation, use HTTP ext_authz to match existing REST AuthService.

---

## Current Implementation Status

### Implemented (Working)

| Scenario | Status | File |
|----------|--------|------|
| Google JWT signature validation | ✅ | `GoogleJwtValidator.java` |
| Google JWT expiration check | ✅ | Google library handles |
| Google JWT issuer validation | ✅ | `GoogleJwtValidator.java:62-66` |
| PAT format validation | ✅ | `TokenValidatorImpl.java:82-89` |
| PAT hash verification | ✅ | `PATValidator.verifyToken()` |
| PAT expiration/revocation check | ✅ | `PersonalAccessToken.validateOrThrow()` |
| PAT lastUsedAt tracking | ✅ | `TokenValidatorImpl.java:116-117` |
| User lastLogin tracking | ✅ | `TokenValidatorImpl.java:64-65` |
| Auth context headers | ✅ | `AuthService.java:134-156` |

### Gaps Requiring Implementation

| Gap | Gherkin Scenario | Priority |
|-----|------------------|----------|
| User auto-creation on first OAuth login | Lines 66-76 | HIGH |
| Scope/role enforcement in auth service | Lines 121-154 | HIGH |
| Resource ownership validation | Lines 162-178 | MEDIUM |
| gRPC ext_authz protocol | Architecture | LOW (use HTTP first) |

---

## Domain Model Design

### 1. AuthenticationContext (Value Object)

Represents the authenticated principal context passed to the API.

**Location**: `domain/model/AuthenticationContext.java`

```java
public class AuthenticationContext {
    private final AuthenticationType type;  // USER or PAT

    // For USER authentication
    private final UUID userId;
    private final String email;
    private final Role role;
    private final String googleId;

    // For PAT authentication
    private final UUID patId;
    private final String serviceName;
    private final PATScope scope;

    // Common
    private final LocalDateTime authenticatedAt;

    // Business methods
    public boolean canAccess(RequiredPermission permission);
    public boolean isUser();
    public boolean isPAT();
}
```

**AuthenticationType Enum**:
```java
public enum AuthenticationType {
    USER,   // Google OAuth authenticated user
    PAT     // Personal Access Token (service)
}
```

### 2. RequiredPermission (Value Object)

Represents permission requirements for an endpoint.

**Location**: `domain/model/RequiredPermission.java`

```java
public class RequiredPermission {
    private final Role minimumRole;        // For user auth
    private final PATScope minimumScope;   // For PAT auth

    public static RequiredPermission superAdmin();  // SUPER_ADMIN / ADMIN scope
    public static RequiredPermission admin();       // ADMIN / WRITE scope
    public static RequiredPermission player();      // PLAYER / READ_ONLY scope
    public static RequiredPermission none();        // Public access
}
```

### 3. ResourceOwnership (Domain Service)

Validates that authenticated principal owns the requested resource.

**Location**: `domain/service/ResourceOwnershipValidator.java`

```java
public interface ResourceOwnershipValidator {
    boolean canAccessLeague(AuthenticationContext ctx, UUID leagueId);
    boolean canModifyRoster(AuthenticationContext ctx, UUID rosterId);
    boolean canAccessUser(AuthenticationContext ctx, UUID userId);
}
```

---

## Use Cases

### 1. AuthenticateRequestUseCase (UPDATE)

Enhance to support scope/role validation per route.

**Current**: Validates token only
**Required**: Validate token + check required scope/role

```java
public class AuthenticateRequestUseCase {

    public AuthenticateResult execute(AuthenticateCommand command) {
        // 1. Validate token (existing logic)
        AuthenticationResult tokenResult = validateToken(command.getToken());

        // 2. NEW: Check route-level permission
        RequiredPermission required = command.getRequiredPermission();
        if (!tokenResult.canAccess(required)) {
            return AuthenticateResult.forbidden("Insufficient permissions");
        }

        // 3. Return auth context headers
        return AuthenticateResult.success(tokenResult.toContext());
    }
}
```

### 2. CreateUserOnFirstLoginUseCase (NEW)

Auto-create user account when valid Google JWT but user not found.

**Location**: `application/usecase/CreateUserOnFirstLoginUseCase.java`

```java
public class CreateUserOnFirstLoginUseCase {

    public CreateUserResult execute(CreateUserOnFirstLoginCommand command) {
        // 1. Validate Google JWT
        GoogleJwtClaims claims = googleJwtValidator.validateAndExtractClaims(command.getToken());

        // 2. Check if user already exists
        Optional<User> existingUser = userRepository.findByGoogleId(claims.getGoogleId());
        if (existingUser.isPresent()) {
            return CreateUserResult.existingUser(existingUser.get());
        }

        // 3. Check for pending invitation (player or admin)
        Optional<AdminInvitation> adminInvite = adminInvitationRepository
            .findByEmailAndStatus(claims.getEmail(), PENDING);
        Optional<LeaguePlayer> playerInvite = leaguePlayerRepository
            .findByEmailAndStatus(claims.getEmail(), INVITED);

        // 4. Determine role based on invitation type
        Role role = adminInvite.isPresent() ? Role.ADMIN : Role.PLAYER;

        // 5. Create user
        User newUser = new User(
            claims.getEmail(),
            claims.getName(),
            claims.getGoogleId(),
            role
        );
        newUser = userRepository.save(newUser);

        // 6. Accept invitation if exists
        if (adminInvite.isPresent()) {
            AdminInvitation invite = adminInvite.get();
            invite.accept(newUser.getId());
            adminInvitationRepository.save(invite);
        }

        if (playerInvite.isPresent()) {
            LeaguePlayer player = playerInvite.get();
            player.acceptInvitation();
            leaguePlayerRepository.save(player);
        }

        return CreateUserResult.newUser(newUser);
    }
}
```

### 3. ValidateResourceOwnershipUseCase (NEW)

Validates resource access at API level (not auth service level).

```java
public class ValidateResourceOwnershipUseCase {

    public boolean canAccessLeague(UUID userId, UUID leagueId) {
        // SUPER_ADMIN can access all leagues
        User user = userRepository.findById(userId).orElse(null);
        if (user != null && user.isSuperAdmin()) {
            return true;
        }

        // ADMIN must own the league
        if (user != null && user.isAdmin()) {
            League league = leagueRepository.findById(leagueId).orElse(null);
            return league != null && league.getCreatorId().equals(userId);
        }

        // PLAYER must be active member
        return leaguePlayerRepository.isActivePlayer(userId, leagueId);
    }
}
```

---

## Auth Service Updates

### Required Changes to AuthService.java

1. **Add required_scope extraction from Envoy context**:
```java
@PostMapping("/check")
public ResponseEntity<Map<String, String>> checkAuthorization(
        @RequestHeader Map<String, String> headers,
        @RequestHeader(value = "x-envoy-auth-partial-body", required = false) String body) {

    // Extract required scope from Envoy context
    String requiredScope = headers.get("x-ext-authz-check-required_scope");

    // ... validate token ...

    // Check scope/role authorization
    if (requiredScope != null && !result.hasPermission(requiredScope)) {
        return forbidden("Insufficient permissions for this endpoint");
    }
}
```

2. **Handle user creation on first login**:
```java
// In TokenValidatorImpl.validateGoogleJWT()
if (user == null) {
    // Attempt auto-creation instead of failing
    user = createUserOnFirstLoginUseCase.execute(claims);
    if (user == null) {
        return AuthenticationResult.failure("No invitation found for email");
    }
}
```

---

## API-Level Authorization

Resource ownership must be validated in the API layer (after Envoy auth).

### Authorization Filter Pattern

**Location**: `infrastructure/filter/ResourceAuthorizationFilter.java`

```java
@Component
public class ResourceAuthorizationFilter implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request,
                            HttpServletResponse response,
                            Object handler) {
        // Extract auth context from headers (set by Envoy)
        AuthenticationContext ctx = extractContext(request);

        // Extract resource ID from path (e.g., /leagues/{id})
        UUID resourceId = extractResourceId(request);

        // Validate ownership based on endpoint pattern
        if (isLeagueEndpoint(request) && !canAccessLeague(ctx, resourceId)) {
            response.setStatus(403);
            return false;
        }

        return true;
    }
}
```

---

## Envoy Configuration Updates

### Option 1: HTTP ext_authz (Recommended for MVP)

Update `deployment/envoy.yaml`:

```yaml
http_filters:
- name: envoy.filters.http.ext_authz
  typed_config:
    "@type": type.googleapis.com/envoy.extensions.filters.http.ext_authz.v3.ExtAuthz
    transport_api_version: V3
    http_service:
      server_uri:
        uri: http://127.0.0.1:9191
        cluster: auth_service
        timeout: 0.5s
      path_prefix: "/auth"
      authorization_request:
        allowed_headers:
          patterns:
          - exact: "authorization"
          - exact: "content-type"
      authorization_response:
        allowed_upstream_headers:
          patterns:
          - exact: "x-user-id"
          - exact: "x-user-email"
          - exact: "x-user-role"
          - exact: "x-google-id"
          - exact: "x-auth-type"
          - exact: "x-service-id"
          - exact: "x-pat-scope"
          - exact: "x-pat-id"
    failure_mode_allow: false
```

Also update cluster to remove gRPC settings:

```yaml
- name: auth_service
  connect_timeout: 0.5s
  type: STATIC
  lb_policy: ROUND_ROBIN
  # Remove: http2_protocol_options: {}
  load_assignment:
    cluster_name: auth_service
    endpoints:
    - lb_endpoints:
      - endpoint:
          address:
            socket_address:
              address: 127.0.0.1
              port_value: 9191
```

---

## Gherkin Scenario Coverage Matrix

| Scenario | Lines | Implementation Status | Action Required |
|----------|-------|----------------------|-----------------|
| Direct API access blocked | 14-17 | ✅ Network config | None |
| Unauthenticated request blocked | 19-24 | ✅ AuthService | None |
| Valid Google JWT | 28-45 | ✅ GoogleJwtValidator | None |
| Expired JWT rejected | 47-51 | ✅ Google library | None |
| Invalid signature rejected | 53-57 | ✅ Google library | None |
| Invalid issuer rejected | 59-64 | ✅ GoogleJwtValidator | None |
| User account creation on OAuth | 66-77 | ❌ Missing | CreateUserOnFirstLoginUseCase |
| Valid PAT | 80-98 | ✅ TokenValidatorImpl | None |
| Expired PAT rejected | 100-104 | ✅ validateOrThrow() | None |
| Revoked PAT rejected | 106-110 | ✅ validateOrThrow() | None |
| Invalid PAT rejected | 112-117 | ✅ TokenValidatorImpl | None |
| Role-based endpoint access | 121-136 | ⚠️ Partial | Scope enforcement in auth |
| PAT scope-based access | 138-153 | ⚠️ Partial | Scope enforcement in auth |
| Public endpoints | 155-158 | ✅ Envoy config | None |
| Admin league ownership | 162-169 | ❌ Missing | ResourceOwnershipValidator |
| Player roster ownership | 171-178 | ❌ Missing | ResourceOwnershipValidator |
| Token session management | 182-189 | ✅ JWT expiration | None |
| PAT usage tracking | 191-196 | ✅ lastUsedAt | None |
| Multi-league access | 200-212 | ✅ LeaguePlayer model | None |
| Missing auth header | 216-219 | ✅ AuthService | None |
| Malformed auth header | 221-224 | ✅ AuthService | None |
| User not found | 226-231 | ⚠️ Partial | Should try auto-create |
| Network policy | 233-236 | ✅ K8s config | None |

---

## Implementation Priority

### Phase 1 - Core Auth Fixes (HIGH)
1. Fix Envoy to use HTTP ext_authz instead of gRPC
2. Add scope/role enforcement in AuthService
3. Implement CreateUserOnFirstLoginUseCase

### Phase 2 - Resource Authorization (MEDIUM)
1. Implement ResourceOwnershipValidator service
2. Add ResourceAuthorizationFilter to API
3. Configure filter for league and roster endpoints

### Phase 3 - Production Hardening (LOW)
1. Add rate limiting in Envoy
2. Implement token refresh hints
3. Add audit logging for auth events
4. Consider gRPC migration for performance

---

## Files to Create/Modify

### New Files:
- `domain/model/AuthenticationContext.java`
- `domain/model/AuthenticationType.java`
- `domain/model/RequiredPermission.java`
- `domain/service/ResourceOwnershipValidator.java`
- `application/usecase/CreateUserOnFirstLoginUseCase.java`
- `application/usecase/ValidateResourceOwnershipUseCase.java`
- `infrastructure/filter/ResourceAuthorizationFilter.java`

### Files to Modify:
- `infrastructure/auth/AuthService.java` - Add scope enforcement
- `infrastructure/auth/TokenValidatorImpl.java` - Add auto-create logic
- `deployment/envoy.yaml` - Switch to HTTP ext_authz
- `gateway/envoy.yaml` - Switch to HTTP ext_authz

---

## Security Considerations

1. **Token Replay**: Mitigated by JWT expiration and lastUsedAt tracking
2. **Privilege Escalation**: Prevented by role hierarchy and scope checks
3. **Resource Access**: Enforced at both gateway (role) and API (ownership) levels
4. **Token Leakage**: PAT hashed with BCrypt, only shown once on creation

---

## Testing Requirements

1. **Unit Tests**:
   - CreateUserOnFirstLoginUseCase with various invitation states
   - ResourceOwnershipValidator for all resource types
   - AuthenticationContext permission checks

2. **Integration Tests**:
   - Envoy → AuthService → API flow
   - Full OAuth login with user creation
   - PAT authentication with scope validation

3. **E2E Tests (Cucumber)**:
   - All 20+ scenarios in ffl-3-authentication.feature

---

**Document Status**: Ready for Backend Implementation
**Created**: 2025-12-29
**Ticket**: ANIMA-1165
