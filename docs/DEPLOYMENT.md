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
      ↓ Query PostgreSQL for user/role
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
  name: postgres-credentials
  namespace: ffl-playoffs
type: Opaque
data:
  POSTGRES_HOST: <base64-encoded-host>
  POSTGRES_PORT: <base64-encoded-port>
  POSTGRES_DB: <base64-encoded-dbname>
  POSTGRES_USER: <base64-encoded-user>
  POSTGRES_PASSWORD: <base64-encoded-password>
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
        - name: POSTGRES_HOST
          valueFrom:
            secretKeyRef:
              name: postgres-credentials
              key: POSTGRES_HOST
        - name: POSTGRES_PORT
          valueFrom:
            secretKeyRef:
              name: postgres-credentials
              key: POSTGRES_PORT
        - name: POSTGRES_DB
          valueFrom:
            secretKeyRef:
              name: postgres-credentials
              key: POSTGRES_DB
        - name: POSTGRES_USER
          valueFrom:
            secretKeyRef:
              name: postgres-credentials
              key: POSTGRES_USER
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: postgres-credentials
              key: POSTGRES_PASSWORD
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
        - name: POSTGRES_HOST
          valueFrom:
            secretKeyRef:
              name: postgres-credentials
              key: POSTGRES_HOST
        - name: POSTGRES_PORT
          valueFrom:
            secretKeyRef:
              name: postgres-credentials
              key: POSTGRES_PORT
        - name: POSTGRES_DB
          valueFrom:
            secretKeyRef:
              name: postgres-credentials
              key: POSTGRES_DB
        - name: POSTGRES_USER
          valueFrom:
            secretKeyRef:
              name: postgres-credentials
              key: POSTGRES_USER
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: postgres-credentials
              key: POSTGRES_PASSWORD
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

| Variable                  | Description                          | Example                     |
|---------------------------|--------------------------------------|-----------------------------|
| `SPRING_PROFILES_ACTIVE`  | Spring profile                       | `production`                |
| `SERVER_PORT`             | API port                             | `8080`                      |
| `MANAGEMENT_SERVER_PORT`  | Actuator port                        | `8081`                      |
| `POSTGRES_HOST`           | PostgreSQL host                      | `postgres.default.svc`      |
| `POSTGRES_PORT`           | PostgreSQL port                      | `5432`                      |
| `POSTGRES_DB`             | Database name                        | `ffl_playoffs`              |
| `POSTGRES_USER`           | Database user                        | `ffl_user`                  |
| `POSTGRES_PASSWORD`       | Database password                    | `<secret>`                  |
| `NFL_API_URL`             | External NFL data API                | `https://api.nfl.com/v1`    |
| `NFL_API_KEY`             | NFL API key                          | `<secret>`                  |

---

### Auth Service

| Variable              | Description                          | Example                     |
|-----------------------|--------------------------------------|-----------------------------|
| `SERVER_PORT`         | Auth service port                    | `9191`                      |
| `POSTGRES_HOST`       | PostgreSQL host                      | `postgres.default.svc`      |
| `POSTGRES_PORT`       | PostgreSQL port                      | `5432`                      |
| `POSTGRES_DB`         | Database name                        | `ffl_playoffs`              |
| `POSTGRES_USER`       | Database user                        | `ffl_user`                  |
| `POSTGRES_PASSWORD`   | Database password                    | `<secret>`                  |
| `GOOGLE_CLIENT_ID`    | Google OAuth client ID               | `<google-client-id>`        |

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
        "database": "PostgreSQL",
        "validationQuery": "isValid()"
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
  # Allow traffic to PostgreSQL
  - to:
    - namespaceSelector:
        matchLabels:
          name: default
      podSelector:
        matchLabels:
          app: postgres
    ports:
    - protocol: TCP
      port: 5432
  # Allow traffic to NFL API (external)
  - to:
    - namespaceSelector: {}
    ports:
    - protocol: TCP
      port: 443
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
  psql -h $POSTGRES_HOST -U $POSTGRES_USER -d $POSTGRES_DB -c "SELECT 1"
```

**Solution**:
- Verify PostgreSQL is running
- Check credentials in secret
- Verify network policy allows traffic to database

---

## Next Steps

- See [ARCHITECTURE.md](ARCHITECTURE.md) for architecture details
- See [API.md](API.md) for API endpoints
- See [DATA_MODEL.md](DATA_MODEL.md) for database schema
- See [DEVELOPMENT.md](DEVELOPMENT.md) for local development
