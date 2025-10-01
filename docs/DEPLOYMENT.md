# FFL Playoffs Deployment Guide

## Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Envoy Sidecar Pattern](#envoy-sidecar-pattern)
4. [Kubernetes Deployment](#kubernetes-deployment)
5. [Environment Variables](#environment-variables)
6. [Health Checks](#health-checks)
7. [Security](#security)
8. [Monitoring](#monitoring)
9. [Troubleshooting](#troubleshooting)

## Overview

The FFL Playoffs API is deployed as a **three-service Kubernetes pod** with:
1. **Main API** (localhost:8080) - Business logic
2. **Auth Service** (localhost:9191) - Token validation
3. **Envoy Sidecar** (pod IP:443) - External entry point

**Key Principle**: ALL external traffic goes through Envoy → Auth Service → Main API

## Architecture

### Three-Service Pod Model

```
┌──────────────────────────────────────────────────────────────────┐
│                      Kubernetes Pod                               │
│  Name: ffl-playoffs-api-<hash>                                    │
│  Namespace: ffl-playoffs                                          │
│                                                                    │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │              Container 1: Envoy Sidecar                     │  │
│  │  Image: envoyproxy/envoy:v1.28-latest                       │  │
│  │  Port: 0.0.0.0:443 (HTTPS)                                  │  │
│  │  Port: localhost:9901 (Envoy Admin)                         │  │
│  │                                                              │  │
│  │  Responsibilities:                                           │  │
│  │  - TLS termination                                           │  │
│  │  - External authorization (ext_authz)                        │  │
│  │  - Rate limiting                                             │  │
│  │  - Request routing to Main API                               │  │
│  └───────────┬──────────────────────────┬───────────────────────┘  │
│              │ ext_authz call           │ Forward request          │
│              ↓ localhost:9191           ↓ localhost:8080           │
│  ┌───────────────────────┐   ┌──────────────────────────────────┐ │
│  │ Container 2:          │   │ Container 3:                     │ │
│  │ Auth Service          │   │ Main API                         │ │
│  │ Image: auth-service   │   │ Image: ffl-playoffs-api         │ │
│  │ Port: localhost:9191  │   │ Port: localhost:8080             │ │
│  │                       │   │ Port: localhost:8081 (actuator)  │ │
│  │ Responsibilities:     │   │                                  │ │
│  │ - Validate Google JWT │   │ Responsibilities:                │ │
│  │ - Validate PAT        │   │ - Domain logic                   │ │
│  │ - Query User database │   │ - API endpoints                  │ │
│  │ - Return user context │   │ - Database access                │ │
│  └───────────────────────┘   └──────────────────────────────────┘ │
│                                                                    │
└──────────────────────────────────────────────────────────────────┘
```

### Network Flow

```
1. External Client (Internet)
      ↓ HTTPS (port 443)
2. Kubernetes Service (ClusterIP)
      ↓ Forward to Pod IP:443
3. Envoy Sidecar (Pod IP:443)
      ↓ Extract Authorization header
      ↓ Call localhost:9191 (ext_authz)
4. Auth Service (localhost:9191)
      ↓ Validate token (Google JWT or PAT)
      ↓ Query MongoDB for user/role
      ↓ Return HTTP 200 + headers OR HTTP 403
5. Envoy validates role/scope
      ↓ If authorized → Forward to localhost:8080
      ↓ If not authorized → Return 403 to client
6. Main API (localhost:8080)
      ↓ Process request with user context headers
      ↓ Execute business logic
      ↓ Return response
7. Envoy forwards response to client
```

---

## Envoy Sidecar Pattern

### Why Envoy Sidecar?

**Security**:
- API never exposed directly to internet
- Zero-trust model: all authentication at proxy layer
- Centralized security policy enforcement

**Separation of Concerns**:
- API focuses on business logic
- Envoy handles cross-cutting concerns (auth, TLS, rate limiting)
- Auth service focuses solely on token validation

**Flexibility**:
- Change authentication strategy without touching API code
- Swap auth providers (Google → Okta) by updating auth service only
- Add observability, tracing without API changes

---

### Localhost-Only Binding (Zero-Trust Security)

**CRITICAL SECURITY REQUIREMENT**: The Main API (port 8080) and Auth Service (port 9191) MUST bind to localhost (127.0.0.1) ONLY.

**Why Localhost-Only Binding?**
- **Prevents Direct Access**: External clients cannot reach the API or Auth Service directly
- **Enforces Envoy Gateway**: ALL traffic MUST go through Envoy (the only service binding to 0.0.0.0)
- **Zero-Trust Model**: Even if an attacker gains pod network access, they cannot bypass authentication
- **Defense in Depth**: Multiple layers of security (network policy + localhost binding + Envoy auth)

#### Configuration

**Main API (Spring Boot)**

In `application.yml` or `application-production.yml`:

```yaml
server:
  address: 127.0.0.1  # Bind to localhost ONLY
  port: 8080

management:
  server:
    address: 127.0.0.1  # Actuator also localhost-only
    port: 8081
```

Or via environment variables:

```yaml
env:
- name: SERVER_ADDRESS
  value: "127.0.0.1"
- name: SERVER_PORT
  value: "8080"
- name: MANAGEMENT_SERVER_ADDRESS
  value: "127.0.0.1"
- name: MANAGEMENT_SERVER_PORT
  value: "8081"
```

**Auth Service (Spring Boot)**

```yaml
server:
  address: 127.0.0.1  # Bind to localhost ONLY
  port: 9191
```

**Envoy Sidecar (External Entry Point)**

Envoy is the ONLY service that binds to 0.0.0.0 (all interfaces):

```yaml
static_resources:
  listeners:
  - name: main_listener
    address:
      socket_address:
        address: 0.0.0.0  # Bind to all interfaces (external access)
        port_value: 443
```

#### Verification

**Test localhost binding:**

```bash
# From within the pod - these should work
kubectl exec -it ffl-playoffs-api-<hash> -c api -- curl http://127.0.0.1:8080/actuator/health
kubectl exec -it ffl-playoffs-api-<hash> -c auth-service -- curl http://127.0.0.1:9191/health

# From outside the pod - these should FAIL (connection refused)
kubectl run test-pod --rm -it --image=curlimages/curl -- curl http://<pod-ip>:8080/actuator/health
# Expected: Connection refused or timeout

# Only Envoy port 443 should be accessible externally
curl https://api.ffl-playoffs.com/api/v1/public/health
# Expected: Success (goes through Envoy)
```

#### Troubleshooting

**Problem**: API is accessible directly on pod IP (bypassing Envoy)

**Solution**: Verify `server.address` is set to `127.0.0.1` in application.yml

**Problem**: Health checks failing

**Solution**: Ensure health check probes target localhost, not pod IP:
```yaml
livenessProbe:
  httpGet:
    path: /actuator/health/liveness
    port: 8081  # Port only, defaults to pod IP
    scheme: HTTP
```

Spring Boot will accept health checks from any interface even when bound to localhost.

---

### Envoy Configuration

**File**: `/etc/envoy/envoy.yaml` (mounted as ConfigMap)

```yaml
admin:
  address:
    socket_address:
      address: 127.0.0.1
      port_value: 9901

static_resources:
  listeners:
  - name: main_listener
    address:
      socket_address:
        address: 0.0.0.0
        port_value: 443
    filter_chains:
    - filters:
      - name: envoy.filters.network.http_connection_manager
        typed_config:
          "@type": type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
          stat_prefix: ingress_http
          codec_type: AUTO
          route_config:
            name: local_route
            virtual_hosts:
            - name: backend
              domains: ["*"]
              routes:
              - match:
                  prefix: "/"
                route:
                  cluster: main_api
          http_filters:
          # External Authorization Filter
          - name: envoy.filters.http.ext_authz
            typed_config:
              "@type": type.googleapis.com/envoy.extensions.filters.http.ext_authz.v3.ExtAuthz
              transport_api_version: V3
              http_service:
                server_uri:
                  uri: "http://127.0.0.1:9191"
                  cluster: auth_service
                  timeout: 1s
                authorization_request:
                  allowed_headers:
                    patterns:
                    - exact: "authorization"
                    - exact: "cookie"
                authorization_response:
                  allowed_upstream_headers:
                    patterns:
                    - exact: "x-user-id"
                    - exact: "x-user-email"
                    - exact: "x-user-role"
                    - exact: "x-google-id"
                    - exact: "x-service-id"
                    - exact: "x-pat-scope"
                    - exact: "x-pat-id"
          # Rate Limiting Filter
          - name: envoy.filters.http.ratelimit
            typed_config:
              "@type": type.googleapis.com/envoy.extensions.filters.http.ratelimit.v3.RateLimit
              domain: ffl-playoffs
              rate_limit_service:
                grpc_service:
                  envoy_grpc:
                    cluster_name: rate_limit_service
          # Router (must be last)
          - name: envoy.filters.http.router
            typed_config:
              "@type": type.googleapis.com/envoy.extensions.filters.http.router.v3.Router
      transport_socket:
        name: envoy.transport_sockets.tls
        typed_config:
          "@type": type.googleapis.com/envoy.extensions.transport_sockets.tls.v3.DownstreamTlsContext
          common_tls_context:
            tls_certificates:
            - certificate_chain:
                filename: "/etc/envoy/certs/tls.crt"
              private_key:
                filename: "/etc/envoy/certs/tls.key"

  clusters:
  # Main API Cluster
  - name: main_api
    type: STATIC
    connect_timeout: 5s
    load_assignment:
      cluster_name: main_api
      endpoints:
      - lb_endpoints:
        - endpoint:
            address:
              socket_address:
                address: 127.0.0.1
                port_value: 8080

  # Auth Service Cluster
  - name: auth_service
    type: STATIC
    connect_timeout: 1s
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

### Auth Service Implementation

**Endpoint**: `POST http://localhost:9191/auth/validate`

**Request Headers** (from Envoy):
```
Authorization: Bearer <token>
X-Forwarded-Proto: https
X-Forwarded-Host: api.ffl-playoffs.com
```

**Response - Authorized (200 OK)**:
```
HTTP/1.1 200 OK
X-User-Id: 12345
X-User-Email: user@example.com
X-User-Role: ADMIN
X-Google-Id: google-oauth2|123456789
```

**Response - Forbidden (403 Forbidden)**:
```
HTTP/1.1 403 Forbidden
X-Error-Code: INVALID_TOKEN
X-Error-Message: Google JWT signature validation failed
```

**Auth Service Logic**:
```java
@PostMapping("/auth/validate")
public ResponseEntity<?> validateToken(@RequestHeader("Authorization") String authHeader) {
    String token = extractToken(authHeader);

    // Detect token type by prefix
    if (token.startsWith("pat_")) {
        return validatePAT(token);
    } else {
        return validateGoogleJWT(token);
    }
}

private ResponseEntity<?> validateGoogleJWT(String jwt) {
    // 1. Validate JWT signature using Google's public keys
    GoogleIdToken idToken = googleIdTokenVerifier.verify(jwt);
    if (idToken == null) {
        return ResponseEntity.status(403)
            .header("X-Error-Code", "INVALID_TOKEN")
            .build();
    }

    // 2. Extract Google ID and email
    String googleId = idToken.getSubject();
    String email = idToken.getPayload().getEmail();

    // 3. Query database for user
    User user = userRepository.findByGoogleId(googleId);
    if (user == null) {
        return ResponseEntity.status(403)
            .header("X-Error-Code", "USER_NOT_FOUND")
            .build();
    }

    // 4. Return user context headers
    return ResponseEntity.ok()
        .header("X-User-Id", user.getId().toString())
        .header("X-User-Email", user.getEmail())
        .header("X-User-Role", user.getRole().name())
        .header("X-Google-Id", googleId)
        .build();
}

private ResponseEntity<?> validatePAT(String pat) {
    // 1. Hash the PAT
    String patHash = bcrypt.hash(pat);

    // 2. Query PersonalAccessToken table
    PersonalAccessToken token = patRepository.findByTokenHash(patHash);
    if (token == null || token.isRevoked() || token.isExpired()) {
        return ResponseEntity.status(403)
            .header("X-Error-Code", "INVALID_PAT")
            .build();
    }

    // 3. Update last used timestamp
    token.setLastUsedAt(LocalDateTime.now());
    patRepository.save(token);

    // 4. Return service context headers
    return ResponseEntity.ok()
        .header("X-Service-Id", token.getName())
        .header("X-PAT-Scope", token.getScope().name())
        .header("X-PAT-Id", token.getId().toString())
        .build();
}
```

---

## Kubernetes Deployment

### Namespace

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: ffl-playoffs
  labels:
    name: ffl-playoffs
```

---

### ConfigMap: Envoy Configuration

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: envoy-config
  namespace: ffl-playoffs
data:
  envoy.yaml: |
    # (See Envoy configuration above)
```

---

### Secret: TLS Certificates

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: envoy-tls
  namespace: ffl-playoffs
type: kubernetes.io/tls
data:
  tls.crt: <base64-encoded-certificate>
  tls.key: <base64-encoded-private-key>
```

**Generate TLS certificate**:
```bash
# For testing (self-signed)
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout tls.key -out tls.crt \
  -subj "/CN=api.ffl-playoffs.com"

# Create secret
kubectl create secret tls envoy-tls \
  --cert=tls.crt --key=tls.key \
  -n ffl-playoffs
```

---

### Secret: Database Credentials

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mongodb-credentials
  namespace: ffl-playoffs
type: Opaque
data:
  MONGODB_URI: <base64-encoded-connection-string>
  # Example: mongodb://ffl_user:password@mongodb.default.svc:27017/ffl_playoffs
```

---

### Deployment: FFL Playoffs API

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ffl-playoffs-api
  namespace: ffl-playoffs
spec:
  replicas: 3
  selector:
    matchLabels:
      app: ffl-playoffs-api
  template:
    metadata:
      labels:
        app: ffl-playoffs-api
    spec:
      containers:
      # Container 1: Envoy Sidecar
      - name: envoy
        image: envoyproxy/envoy:v1.28-latest
        ports:
        - containerPort: 443
          name: https
          protocol: TCP
        - containerPort: 9901
          name: admin
          protocol: TCP
        volumeMounts:
        - name: envoy-config
          mountPath: /etc/envoy
          readOnly: true
        - name: envoy-tls
          mountPath: /etc/envoy/certs
          readOnly: true
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 512Mi
        livenessProbe:
          httpGet:
            path: /ready
            port: 9901
          initialDelaySeconds: 10
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 9901
          initialDelaySeconds: 5
          periodSeconds: 5

      # Container 2: Auth Service
      - name: auth-service
        image: ffl-playoffs/auth-service:latest
        ports:
        - containerPort: 9191
          name: http
          protocol: TCP
        env:
        - name: SPRING_DATA_MONGODB_URI
          valueFrom:
            secretKeyRef:
              name: mongodb-credentials
              key: MONGODB_URI
        - name: GOOGLE_CLIENT_ID
          valueFrom:
            secretKeyRef:
              name: google-oauth
              key: CLIENT_ID
        resources:
          requests:
            cpu: 200m
            memory: 256Mi
          limits:
            cpu: 1000m
            memory: 1Gi
        livenessProbe:
          httpGet:
            path: /health
            port: 9191
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /health
            port: 9191
          initialDelaySeconds: 10
          periodSeconds: 5

      # Container 3: Main API
      - name: api
        image: ffl-playoffs/api:latest
        ports:
        - containerPort: 8080
          name: http
          protocol: TCP
        - containerPort: 8081
          name: actuator
          protocol: TCP
        env:
        - name: SPRING_PROFILES_ACTIVE
          value: "production"
        - name: SERVER_PORT
          value: "8080"
        - name: MANAGEMENT_SERVER_PORT
          value: "8081"
        - name: SPRING_DATA_MONGODB_URI
          valueFrom:
            secretKeyRef:
              name: mongodb-credentials
              key: MONGODB_URI
        resources:
          requests:
            cpu: 500m
            memory: 1Gi
          limits:
            cpu: 2000m
            memory: 2Gi
        livenessProbe:
          httpGet:
            path: /actuator/health/liveness
            port: 8081
          initialDelaySeconds: 60
          periodSeconds: 10
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /actuator/health/readiness
            port: 8081
          initialDelaySeconds: 30
          periodSeconds: 5
          failureThreshold: 3

      volumes:
      - name: envoy-config
        configMap:
          name: envoy-config
      - name: envoy-tls
        secret:
          secretName: envoy-tls
```

---

### Service: ClusterIP

```yaml
apiVersion: v1
kind: Service
metadata:
  name: ffl-playoffs-api
  namespace: ffl-playoffs
spec:
  type: ClusterIP
  selector:
    app: ffl-playoffs-api
  ports:
  - name: https
    port: 443
    targetPort: 443
    protocol: TCP
```

---

### Ingress (Optional)

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ffl-playoffs-ingress
  namespace: ffl-playoffs
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  tls:
  - hosts:
    - api.ffl-playoffs.com
    secretName: ffl-playoffs-tls
  rules:
  - host: api.ffl-playoffs.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: ffl-playoffs-api
            port:
              number: 443
```

---

## Environment Variables

### Main API

| Variable                     | Description                          | Example                                                    |
|------------------------------|--------------------------------------|------------------------------------------------------------|
| `SPRING_PROFILES_ACTIVE`     | Spring profile                       | `production`                                               |
| `SERVER_PORT`                | API port                             | `8080`                                                     |
| `MANAGEMENT_SERVER_PORT`     | Actuator port                        | `8081`                                                     |
| `SPRING_DATA_MONGODB_URI`    | MongoDB connection string            | `mongodb://ffl_user:password@mongodb.default.svc:27017/ffl_playoffs` |
| `NFL_API_URL`                | External NFL data API                | `https://api.nfl.com/v1`                                   |
| `NFL_API_KEY`                | NFL API key                          | `<secret>`                                                 |

---

### Auth Service

| Variable                     | Description                          | Example                                                    |
|------------------------------|--------------------------------------|------------------------------------------------------------|
| `SERVER_PORT`                | Auth service port                    | `9191`                                                     |
| `SPRING_DATA_MONGODB_URI`    | MongoDB connection string            | `mongodb://ffl_user:password@mongodb.default.svc:27017/ffl_playoffs` |
| `GOOGLE_CLIENT_ID`           | Google OAuth client ID               | `<google-client-id>`                                       |

---

## Health Checks

### Envoy Admin Interface

```bash
curl http://localhost:9901/ready
```

**Response**:
```
LIVE
```

---

### Auth Service Health

```bash
curl http://localhost:9191/health
```

**Response**:
```json
{
  "status": "UP",
  "timestamp": "2025-10-01T12:00:00Z"
}
```

---

### Main API Health

```bash
curl http://localhost:8081/actuator/health
```

**Response**:
```json
{
  "status": "UP",
  "components": {
    "db": {
      "status": "UP",
      "details": {
        "database": "MongoDB",
        "version": "6.0.5"
      }
    },
    "diskSpace": {
      "status": "UP"
    }
  }
}
```

---

## Security

### Network Policies

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ffl-playoffs-network-policy
  namespace: ffl-playoffs
spec:
  podSelector:
    matchLabels:
      app: ffl-playoffs-api
  policyTypes:
  - Ingress
  - Egress
  ingress:
  # Allow traffic from ingress controller
  - from:
    - namespaceSelector:
        matchLabels:
          name: ingress-nginx
    ports:
    - protocol: TCP
      port: 443
  egress:
  # Allow traffic to MongoDB
  - to:
    - namespaceSelector:
        matchLabels:
          name: default
      podSelector:
        matchLabels:
          app: mongodb
    ports:
    - protocol: TCP
      port: 27017
  # Allow traffic to NFL API (external)
  - to:
    - namespaceSelector: {}
    ports:
    - protocol: TCP
      port: 443
```

---

### Bootstrap PAT Setup

**Purpose**: Create the first SUPER_ADMIN user and Personal Access Token to bootstrap the authentication system.

**⚠️ CRITICAL**: This process is required for initial deployment. Without a bootstrap PAT, no API access is possible since all endpoints require authentication.

#### Step 1: Create Bootstrap SUPER_ADMIN User

Connect to MongoDB and create the first user directly in the database:

```bash
# Connect to MongoDB
kubectl exec -it mongodb-0 -n default -- mongosh mongodb://localhost:27017/ffl_playoffs

# Or for local development
mongosh mongodb://ffl_user:ffl_password@localhost:27017/ffl_playoffs
```

Create the bootstrap user:

```javascript
// Switch to database
use ffl_playoffs

// Create first SUPER_ADMIN user
db.users.insertOne({
  _id: UUID("00000000-0000-0000-0000-000000000001"),
  email: "admin@ffl-playoffs.com",
  name: "Bootstrap Admin",
  googleId: null,  // No Google ID for bootstrap user
  role: "SUPER_ADMIN",
  createdAt: new Date(),
  updatedAt: new Date()
})
```

**Verification**:
```javascript
db.users.findOne({ email: "admin@ffl-playoffs.com" })
```

#### Step 2: Generate Bootstrap PAT Token

Generate a secure token and hash it:

```bash
# Generate a secure random token (32 bytes = 64 hex characters)
TOKEN_SECRET=$(openssl rand -hex 32)
echo "Bootstrap PAT Token: pat_${TOKEN_SECRET}"

# IMPORTANT: Save this token securely - it's shown only once!
# Example: pat_a1b2c3d4e5f6...

# Hash the token with bcrypt (cost factor 12)
TOKEN_HASH=$(htpasswd -bnBC 12 "" "pat_${TOKEN_SECRET}" | tr -d ':\n' | sed 's/$2y/$2a/')
echo "Token Hash: ${TOKEN_HASH}"
```

#### Step 3: Insert Bootstrap PAT into Database

```javascript
// In MongoDB shell
use ffl_playoffs

// Insert bootstrap PAT
db.personalAccessTokens.insertOne({
  _id: UUID("00000000-0000-0000-0000-000000000002"),
  name: "Bootstrap PAT",
  tokenIdentifier: "bootstrap-pat-001",  // Unique identifier for lookup
  tokenHash: "<TOKEN_HASH from step 2>",
  scope: "ADMIN",
  expiresAt: null,  // No expiration for bootstrap token
  createdBy: UUID("00000000-0000-0000-0000-000000000001"),
  createdAt: new Date(),
  lastUsedAt: null,
  revoked: false
})
```

**Verification**:
```javascript
db.personalAccessTokens.findOne({ name: "Bootstrap PAT" })
```

#### Step 4: Test Bootstrap PAT

Test the bootstrap token with a simple API call:

```bash
# Using the bootstrap PAT token
curl -H "Authorization: Bearer pat_a1b2c3d4e5f6..." \
  https://api.ffl-playoffs.com/api/v1/superadmin/health

# Expected response:
# {"status": "UP"}
```

#### Step 5: Create Additional Admins via API

Once bootstrap PAT is working, create additional admins via API:

```bash
# Create new admin using bootstrap PAT
curl -X POST https://api.ffl-playoffs.com/api/v1/superadmin/admins \
  -H "Authorization: Bearer pat_a1b2c3d4e5f6..." \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin2@ffl-playoffs.com",
    "name": "Admin User",
    "role": "ADMIN"
  }'

# Create PAT for the new admin
curl -X POST https://api.ffl-playoffs.com/api/v1/superadmin/pats \
  -H "Authorization: Bearer pat_a1b2c3d4e5f6..." \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Admin API Token",
    "scope": "ADMIN",
    "expiresAt": "2026-12-31T23:59:59Z"
  }'
```

#### Security Best Practices

1. **Rotate Bootstrap PAT**: After creating additional admin users and tokens, consider revoking the bootstrap PAT
2. **Secure Storage**: Store bootstrap PAT in a secrets manager (Kubernetes Secret, AWS Secrets Manager, HashiCorp Vault)
3. **Audit Logging**: Monitor all bootstrap PAT usage for suspicious activity
4. **Time-Bound Expiration**: Set expiration dates on all non-bootstrap PATs
5. **Principle of Least Privilege**: Use READ_ONLY or WRITE scope PATs for services that don't need ADMIN access

#### Kubernetes Secret for Bootstrap PAT

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: ffl-playoffs-bootstrap-pat
  namespace: ffl-playoffs
type: Opaque
data:
  bootstrap-pat: <base64-encoded-token>  # base64 encode pat_a1b2c3d4e5f6...
```

Mount in deployment:

```yaml
env:
- name: BOOTSTRAP_PAT
  valueFrom:
    secretKeyRef:
      name: ffl-playoffs-bootstrap-pat
      key: bootstrap-pat
```

#### Troubleshooting Bootstrap PAT

**Problem**: PAT authentication fails with 403

**Solutions**:
1. Verify token hash in database matches your bcrypt hash
2. Check token prefix is `pat_` (not `bearer` or other)
3. Verify user exists and has SUPER_ADMIN role
4. Check Auth Service logs for validation errors
5. Ensure MongoDB connection is working

**Problem**: Token hash mismatch

**Solution**: Regenerate hash using exact same token string:
```bash
echo -n "pat_a1b2c3d4e5f6..." | htpasswd -bnBC 12 "" | tr -d ':\n' | sed 's/$2y/$2a/'
```

---

### Pod Security Policy

```yaml
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
  name: ffl-playoffs-psp
spec:
  privileged: false
  runAsUser:
    rule: MustRunAsNonRoot
  seLinux:
    rule: RunAsAny
  fsGroup:
    rule: RunAsAny
  volumes:
  - configMap
  - secret
  - emptyDir
```

---

## Monitoring

### Prometheus Metrics

**Envoy Metrics**:
- Endpoint: `http://localhost:9901/stats/prometheus`
- Metrics: Request rate, latency, error rate

**Main API Metrics**:
- Endpoint: `http://localhost:8081/actuator/prometheus`
- Metrics: JVM, HTTP requests, database connections

---

### ServiceMonitor (Prometheus Operator)

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: ffl-playoffs-api
  namespace: ffl-playoffs
spec:
  selector:
    matchLabels:
      app: ffl-playoffs-api
  endpoints:
  - port: actuator
    path: /actuator/prometheus
    interval: 30s
  - port: admin
    path: /stats/prometheus
    interval: 30s
```

---

## Troubleshooting

### Issue: 503 Service Unavailable

**Symptom**: Envoy returns 503 error

**Diagnosis**:
```bash
# Check Envoy admin interface
kubectl port-forward -n ffl-playoffs pod/<pod-name> 9901:9901
curl http://localhost:9901/clusters

# Check if main API is healthy
kubectl port-forward -n ffl-playoffs pod/<pod-name> 8081:8081
curl http://localhost:8081/actuator/health
```

**Solution**:
- Verify Main API is running and healthy
- Check Main API logs: `kubectl logs -n ffl-playoffs <pod-name> -c api`

---

### Issue: 403 Forbidden

**Symptom**: All requests return 403

**Diagnosis**:
```bash
# Check auth service logs
kubectl logs -n ffl-playoffs <pod-name> -c auth-service

# Test auth service directly
kubectl port-forward -n ffl-playoffs pod/<pod-name> 9191:9191
curl -H "Authorization: Bearer <token>" http://localhost:9191/auth/validate
```

**Solution**:
- Verify Google OAuth configuration
- Check database connectivity from auth service
- Verify user exists in database

---

### Issue: Database Connection Failure

**Symptom**: API fails to start, logs show database errors

**Diagnosis**:
```bash
# Check database connectivity from pod
kubectl exec -n ffl-playoffs <pod-name> -c api -- \
  mongosh $SPRING_DATA_MONGODB_URI --eval "db.adminCommand('ping')"
```

**Solution**:
- Verify MongoDB is running
- Check connection string in secret
- Verify network policy allows traffic to database

---

## Next Steps

- See [ARCHITECTURE.md](ARCHITECTURE.md) for architecture details
- See [API.md](API.md) for API endpoints
- See [DATA_MODEL.md](DATA_MODEL.md) for database schema
- See [DEVELOPMENT.md](DEVELOPMENT.md) for local development
