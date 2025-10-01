# Personal Access Token (PAT) Management

## Table of Contents
1. [Overview](#overview)
2. [Bootstrap PAT for Initial Setup](#bootstrap-pat-for-initial-setup)
3. [PAT Lifecycle](#pat-lifecycle)
4. [Security Model](#security-model)
5. [PAT Scopes and Permissions](#pat-scopes-and-permissions)
6. [Initial Super Admin Setup Process](#initial-super-admin-setup-process)
7. [PAT Management Operations](#pat-management-operations)
8. [Best Practices](#best-practices)
9. [Troubleshooting](#troubleshooting)

---

## Overview

Personal Access Tokens (PATs) provide service-to-service authentication for the FFL Playoffs API. They enable external services, CI/CD pipelines, and administrative tools to access the API without requiring human user authentication.

### Key Features

- **Service Authentication**: PATs authenticate services instead of human users
- **Scope-Based Access Control**: PATs have READ_ONLY, WRITE, or ADMIN scope
- **Secure Storage**: PAT plaintext is never stored; only bcrypt hashes are persisted
- **One-Time Display**: Plaintext tokens are shown only once upon creation
- **Lifecycle Management**: Create, rotate, revoke, and delete PATs
- **Audit Logging**: All PAT operations and usage are logged
- **Bootstrap Support**: Special bootstrap PAT enables initial system setup

### When to Use PATs

Use PATs for:
- **CI/CD Pipelines**: Automated deployment and testing
- **Monitoring Services**: Read-only access to metrics and data
- **Data Sync Services**: Write access for external integrations
- **Administrative Automation**: Bulk operations and system management
- **Initial Setup**: Bootstrap PAT for creating the first super admin

Do NOT use PATs for:
- Human user authentication (use Google OAuth instead)
- Frontend web applications (use Google JWT tokens)
- Mobile applications (use Google OAuth)

---

## Bootstrap PAT for Initial Setup

### What is the Bootstrap PAT?

The **bootstrap PAT** is a special Personal Access Token created during initial system deployment to enable the creation of the first super admin account. It solves the "chicken-and-egg" problem: how do you create a super admin when there are no super admins yet?

### Bootstrap PAT Properties

```yaml
Name: bootstrap
Scope: ADMIN
Created By: SYSTEM
Expiration: 1 year from creation
Revoked: false (initially)
Purpose: Create the first super admin account
```

### Creating the Bootstrap PAT

#### Prerequisites

1. Database is initialized and accessible
2. `PersonalAccessToken` table exists
3. No super admin accounts exist yet
4. Bootstrap setup script is ready to run

#### Bootstrap Script Execution

Run the bootstrap setup script:

```bash
# From ffl-playoffs-api directory
cd ffl-playoffs-api
./scripts/bootstrap-pat.sh
```

Or run directly with Gradle:

```bash
cd ffl-playoffs-api
./gradlew bootRun --main-class=com.ffl.playoffs.scripts.BootstrapPATScript
```

**Script Behavior**:

1. **Check for Existing Bootstrap PAT**:
   - Queries database for PAT with name "bootstrap"
   - If exists, displays message and exits without creating duplicate
   - If not exists, proceeds to step 2

2. **Generate Secure Token**:
   - Creates cryptographically secure random token
   - Token format: `pat_<64+ random characters>`
   - Example: `pat_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6_ABCDefgh123456789xyz012345678901234567890abcdef`

3. **Hash Token**:
   - Hashes plaintext token using bcrypt (cost factor 12)
   - Only the hash is stored in database

4. **Create Database Record**:
   ```json
   {
     "id": "<uuid>",
     "name": "bootstrap",
     "tokenHash": "$2a$12$...",
     "scope": "ADMIN",
     "expiresAt": "2026-01-01T00:00:00Z",
     "createdBy": "SYSTEM",
     "createdAt": "2025-01-01T00:00:00Z",
     "lastUsedAt": null,
     "revoked": false,
     "revokedAt": null
   }
   ```

5. **Display Plaintext Token (ONE TIME ONLY)**:
   ```
   ========================================
   ⚠️  BOOTSTRAP PAT - SAVE THIS NOW!
   ========================================

   Token: pat_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6_ABCDefgh123456789xyz012345678901234567890abc...

   This token will NEVER be shown again!

   Use this token to create your first super admin account:

     POST /api/v1/superadmin/bootstrap
     Authorization: Bearer pat_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6_ABCDefgh123456789xyz012345678901234567890abc...
     {
       "email": "admin@example.com",
       "googleId": "google-user-123"
     }

   After creating your super admin, rotate this token immediately!
   ========================================
   ```

6. **Security Measures**:
   - Plaintext token is NEVER logged to files
   - Plaintext token is NEVER stored in database
   - Plaintext token is displayed only on console output
   - Administrator must copy and save the token immediately

### Bootstrap PAT Security Considerations

| Security Measure | Implementation |
|-----------------|----------------|
| Plaintext Display | Console output only, one-time |
| File Logging | NEVER logged (excluded from all loggers) |
| Database Storage | Only bcrypt hash stored |
| Token Length | Minimum 64 characters |
| Expiration | 1 year (365 days) |
| Scope | ADMIN (sufficient for super admin creation) |
| Revocation | Can be revoked immediately after use |
| Audit Logging | Creation and usage logged (not plaintext) |

---

## PAT Lifecycle

### 1. Creation

**Who Can Create**: SUPER_ADMIN users only

**Creation Process**:

```http
POST /api/v1/superadmin/pats
Authorization: Bearer <google-jwt-token>
Content-Type: application/json

{
  "name": "CI/CD Pipeline Token",
  "scope": "WRITE",
  "expiresAt": "2025-12-31T23:59:59Z"
}
```

**Response** (plaintext token shown ONLY in creation response):

```json
{
  "success": true,
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "name": "CI/CD Pipeline Token",
    "token": "pat_b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7_XYZ123abc789def456ghi012jkl345mno678pqr901stu234vwx567yz",
    "scope": "WRITE",
    "expiresAt": "2025-12-31T23:59:59Z",
    "createdBy": "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11",
    "createdAt": "2025-01-15T10:30:00Z"
  },
  "message": "PAT created successfully. SAVE THIS TOKEN - it will not be shown again!"
}
```

**What Happens**:
1. Super admin sends creation request
2. System validates request (name unique, scope valid, expiration in future)
3. Generates cryptographically secure random token with `pat_` prefix
4. Hashes token with bcrypt (cost factor 12)
5. Stores hash in `PersonalAccessToken` table
6. Returns plaintext token in response (ONLY TIME)
7. Creates audit log entry: `PAT_CREATED`

### 2. Active Usage

**Authentication Flow**:

```
1. Service → Request with Authorization: Bearer pat_xyz...
2. Envoy → Calls auth service (localhost:9191)
3. Auth Service:
   - Detects "pat_" prefix
   - Hashes incoming token with bcrypt
   - Queries PersonalAccessToken by tokenHash
   - Validates: not expired, not revoked
   - Updates lastUsedAt timestamp
   - Returns HTTP 200 with headers
4. Envoy → Checks PAT scope against endpoint requirements
5. Envoy → Forwards request if authorized
6. Main API → Receives pre-authenticated request
```

**Service Context Headers** (added by Envoy):

```
X-Service-Id: <service-identifier>
X-PAT-Scope: WRITE
X-PAT-Id: 550e8400-e29b-41d4-a716-446655440000
```

**Usage Tracking**:
- Every successful request updates `lastUsedAt` timestamp
- Failed authentication attempts are logged
- PAT ID and metadata are logged (not plaintext)

### 3. Rotation

**Why Rotate**: Regularly rotating PATs reduces risk of token compromise

**Rotation Process**:

```http
PUT /api/v1/superadmin/pats/{patId}/rotate
Authorization: Bearer <google-jwt-token>
```

**What Happens**:
1. Generates new cryptographically secure token
2. Hashes new token with bcrypt
3. Updates `tokenHash` in database (atomic operation)
4. Old token is IMMEDIATELY invalidated
5. Returns new plaintext token (ONLY TIME)
6. Resets `lastUsedAt` to null
7. Keeps same name, scope, expiresAt, createdBy, createdAt
8. Creates audit log entry: `PAT_ROTATED`

**Response**:

```json
{
  "success": true,
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "name": "CI/CD Pipeline Token",
    "token": "pat_c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8_NEW789xyz456abc012def345ghi678jkl901mno234pqr567stu890vwx",
    "scope": "WRITE",
    "expiresAt": "2025-12-31T23:59:59Z",
    "rotatedAt": "2025-06-15T14:20:00Z"
  },
  "message": "PAT rotated successfully. Update your services with the new token!"
}
```

### 4. Revocation

**Why Revoke**: Immediately disable a PAT if compromised or no longer needed

**Revocation Process**:

```http
DELETE /api/v1/superadmin/pats/{patId}/revoke
Authorization: Bearer <google-jwt-token>
```

**What Happens**:
1. Sets `revoked = true`
2. Sets `revokedAt = <current_timestamp>`
3. PAT is IMMEDIATELY rejected by auth service
4. PAT record remains in database for audit purposes
5. Creates audit log entry: `PAT_REVOKED`

**Revoked PAT Behavior**:
- Any request with revoked PAT returns 403 Forbidden
- PAT appears in listing with `revoked: true`
- Cannot un-revoke (create new PAT instead)
- Historical usage data preserved

### 5. Expiration

**Automatic Expiration**:
- Auth service checks `expiresAt` on every request
- If `current_time > expiresAt`, PAT is rejected
- Returns 403 Forbidden with reason "PAT_EXPIRED"

**Extending Expiration**:

```http
PUT /api/v1/superadmin/pats/{patId}/expiration
Authorization: Bearer <google-jwt-token>
Content-Type: application/json

{
  "expiresAt": "2026-12-31T23:59:59Z"
}
```

**Constraints**:
- New `expiresAt` must be in the future
- Cannot set expiration on revoked PATs
- Creates audit log entry: `PAT_EXPIRATION_UPDATED`

### 6. Deletion

**Permanent Removal**:

```http
DELETE /api/v1/superadmin/pats/{patId}
Authorization: Bearer <google-jwt-token>
```

**What Happens**:
1. PAT record is PERMANENTLY deleted from database
2. PAT no longer appears in any listings
3. Creates audit log entry: `PAT_DELETED` (preserves metadata)
4. Cannot be recovered

**When to Delete vs Revoke**:
- **Revoke**: If you might need audit trail or want to preserve history
- **Delete**: If you want to permanently remove all traces (still logged in audit)

---

## Security Model

### Token Generation

**Token Format**: `pat_<identifier>_<random>`

**Components**:
- **Prefix**: `pat_` (for token type identification)
- **Identifier**: 32-character UUID without hyphens (for efficient database lookup)
- **Separator**: `_` (separates identifier from random portion)
- **Random**: 64-character cryptographically secure random string

**Requirements**:
- Identifier: UUID v4 without hyphens (32 hex characters)
- Random portion: Cryptographically secure random generation (SecureRandom)
- Character set: alphanumeric (Base62 or hex encoding)
- Total length: 99 characters (`pat_` + 32 + `_` + 64)

**Example Token**:
```
pat_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6_ABCDefgh123...xyz789
│   └──────────────────────────────┘ └────────────────────────┘
│            identifier (32)              random (64)
└─ prefix
```

**Why Two-Part Format?**
1. **Efficient Lookup**: The identifier allows direct database queries without hashing
2. **Performance**: Avoids expensive bcrypt operations during token lookup
3. **Security**: Full token is still bcrypt hashed for verification
4. **Validation**: Auth service queries by identifier, then verifies full token hash

### Hashing and Storage

**Hashing Algorithm**: bcrypt with cost factor 12

**Storage Model**:

```javascript
// Database record (MongoDB example)
{
  _id: "550e8400-e29b-41d4-a716-446655440000",
  name: "CI/CD Pipeline Token",
  tokenIdentifier: "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6", // UUID without hyphens (for lookup)
  tokenHash: "$2a$12$abc123...", // bcrypt hash of FULL token (identifier + random)
  scope: "WRITE",
  expiresAt: ISODate("2025-12-31T23:59:59Z"),
  createdBy: "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11",
  createdAt: ISODate("2025-01-15T10:30:00Z"),
  lastUsedAt: ISODate("2025-01-20T14:45:00Z"),
  revoked: false,
  revokedAt: null
}
```

**Two-Field Storage**:
- `tokenIdentifier`: Stored in plaintext for efficient database queries
- `tokenHash`: BCrypt hash of the complete token (`pat_<identifier>_<random>`)
- The random portion is NEVER stored separately or in plaintext

**What is NEVER Stored**:
- Plaintext token
- Reversible encryption of token
- Token in any recoverable form

### Token Display Policy

| Scenario | Plaintext Token Visible? |
|----------|-------------------------|
| Creation Response | ✅ YES (one-time only) |
| Rotation Response | ✅ YES (one-time only) |
| List PATs Response | ❌ NO (never) |
| Get PAT Details | ❌ NO (never) |
| Application Logs | ❌ NO (never) |
| Audit Logs | ❌ NO (never) |
| Database | ❌ NO (never) |
| Error Messages | ❌ NO (never) |

**If Token is Lost**:
1. Token cannot be recovered (not stored in plaintext)
2. Rotate the PAT to generate a new token
3. Update services with the new token

### Authentication Validation

**Auth Service Validation Steps**:

1. **Extract Token**: Get `Authorization: Bearer <token>` from header
2. **Detect Type**: Check for `pat_` prefix
3. **Parse Token**: Split token into `identifier` and `random` parts
   - Example: `pat_abc123_xyz789` → identifier=`abc123`, full token=`pat_abc123_xyz789`
4. **Query Database**: Find `PersonalAccessToken` by `tokenIdentifier` (fast indexed lookup)
5. **Hash Full Token**: Apply bcrypt to complete incoming token (`pat_<identifier>_<random>`)
6. **Verify Hash**: Compare bcrypt hash with stored `tokenHash`
7. **Validate Not Expired**: Check `expiresAt > current_time`
8. **Validate Not Revoked**: Check `revoked == false`
9. **Update Usage**: Set `lastUsedAt = current_time`
10. **Return Context**: Send headers with PAT scope and ID

**Performance Benefit**: Querying by `tokenIdentifier` (indexed field) is much faster than attempting bcrypt comparison against all PAT records.

**Rejection Scenarios**:
- Token not found: 403 Forbidden
- Token expired: 403 Forbidden ("PAT_EXPIRED")
- Token revoked: 403 Forbidden ("PAT_REVOKED")
- Invalid format: 401 Unauthorized

### Audit Logging

**What is Logged**:

| Event | Logged Data |
|-------|------------|
| PAT Creation | PAT ID, name, scope, creator ID, timestamp |
| PAT Rotation | PAT ID, name, rotator ID, timestamp |
| PAT Revocation | PAT ID, name, revoker ID, timestamp |
| PAT Deletion | PAT ID, name, deleter ID, timestamp |
| PAT Usage | PAT ID, endpoint, success/failure, timestamp |
| PAT Expiration Update | PAT ID, old expiration, new expiration, timestamp |

**What is NOT Logged**:
- Plaintext tokens
- Token hashes
- Bcrypt salt or parameters

**Audit Log Format** (example):

```json
{
  "timestamp": "2025-01-15T10:30:00Z",
  "action": "PAT_CREATED",
  "actorId": "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11",
  "actorRole": "SUPER_ADMIN",
  "patId": "550e8400-e29b-41d4-a716-446655440000",
  "patName": "CI/CD Pipeline Token",
  "patScope": "WRITE",
  "success": true
}
```

---

## PAT Scopes and Permissions

### Scope Hierarchy

```
ADMIN (highest)
  └─ Can access ALL endpoints (including /api/v1/superadmin/*)
     └─ WRITE
        └─ Can access /api/v1/admin/* and /api/v1/player/*
           └─ READ_ONLY (lowest)
              └─ Can access /api/v1/player/* (read operations only)
```

### Scope Definitions

#### READ_ONLY

**Purpose**: Monitoring, analytics, read-only integrations

**Accessible Endpoints**:
- `GET /api/v1/player/*` (read player data)
- `GET /api/v1/public/*` (public data)

**Cannot Access**:
- Any POST, PUT, DELETE operations
- `/api/v1/admin/*` endpoints
- `/api/v1/superadmin/*` endpoints

**Use Cases**:
- Monitoring dashboards
- Analytics services
- Read-only reporting tools

#### WRITE

**Purpose**: Data sync, integrations that modify data

**Accessible Endpoints**:
- `ALL /api/v1/player/*` (full player operations)
- `ALL /api/v1/admin/*` (admin operations)
- `GET /api/v1/public/*` (public data)

**Cannot Access**:
- `/api/v1/superadmin/*` endpoints

**Use Cases**:
- CI/CD pipelines
- Data synchronization services
- Automated admin tasks

#### ADMIN

**Purpose**: Full system access, bootstrap setup, super admin operations

**Accessible Endpoints**:
- `ALL /api/v1/superadmin/*` (super admin operations)
- `ALL /api/v1/admin/*` (admin operations)
- `ALL /api/v1/player/*` (player operations)
- `ALL /api/v1/public/*` (public data)
- `ALL /api/v1/service/*` (service endpoints)

**Use Cases**:
- Bootstrap PAT (initial setup)
- Full system automation
- Administrative automation tools

### Endpoint Authorization Matrix

| Endpoint Pattern | READ_ONLY | WRITE | ADMIN |
|-----------------|-----------|-------|-------|
| `GET /api/v1/player/*` | ✅ | ✅ | ✅ |
| `POST /api/v1/player/*` | ❌ | ✅ | ✅ |
| `GET /api/v1/admin/*` | ❌ | ✅ | ✅ |
| `POST /api/v1/admin/*` | ❌ | ✅ | ✅ |
| `GET /api/v1/superadmin/*` | ❌ | ❌ | ✅ |
| `POST /api/v1/superadmin/*` | ❌ | ❌ | ✅ |
| `GET /api/v1/public/*` | ✅ | ✅ | ✅ |
| `/api/v1/service/*` | ❌ | ❌ | ✅ |

---

## Initial Super Admin Setup Process

### Step-by-Step Guide

#### Prerequisites

1. System is deployed (Kubernetes pods running)
2. Database is initialized and accessible
3. Envoy sidecar is configured for ext_authz
4. Auth service is running on localhost:9191
5. Main API is running on localhost:8080

#### Step 1: Create Bootstrap PAT

Run the bootstrap setup script:

```bash
cd ffl-playoffs-api
./scripts/bootstrap-pat.sh
```

Or with Gradle:

```bash
cd ffl-playoffs-api
./gradlew bootRun --main-class=com.ffl.playoffs.scripts.BootstrapPATScript
```

**Save the displayed token immediately!** It will look like:

```
Token: pat_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6_ABCDefgh123456789xyz012345678901234567890abcdef
```

#### Step 2: Create First Super Admin Account

Use the bootstrap PAT to create your first super admin:

```bash
curl -X POST https://<pod-ip>/api/v1/superadmin/bootstrap \
  -H "Authorization: Bearer pat_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6_ABCDefgh123456789xyz012345678901234567890abcdef" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@example.com",
    "googleId": "google-oauth2|123456789",
    "name": "System Administrator"
  }'
```

**Response**:

```json
{
  "success": true,
  "data": {
    "id": "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11",
    "email": "admin@example.com",
    "name": "System Administrator",
    "role": "SUPER_ADMIN",
    "googleId": "google-oauth2|123456789",
    "createdAt": "2025-01-15T10:30:00Z"
  },
  "message": "Super admin account created successfully"
}
```

#### Step 3: Login as Super Admin

1. Navigate to the application login page
2. Click "Sign in with Google"
3. Authenticate with Google using `admin@example.com`
4. System validates your Google JWT
5. Auth service finds your User record with SUPER_ADMIN role
6. You are granted super admin access

#### Step 4: Rotate Bootstrap PAT

**IMPORTANT**: For security, rotate the bootstrap PAT immediately:

```http
PUT /api/v1/superadmin/pats/{bootstrap-pat-id}/rotate
Authorization: Bearer <your-google-jwt>
```

Or revoke it entirely:

```http
DELETE /api/v1/superadmin/pats/{bootstrap-pat-id}/revoke
Authorization: Bearer <your-google-jwt>
```

**Why Rotate?**
- Bootstrap PAT has ADMIN scope (full access)
- It was displayed on console (potential exposure)
- Best practice: rotate after one-time use

#### Step 5: Create Service-Specific PATs

Now that you're a super admin, create PATs for your services:

**CI/CD Pipeline PAT**:

```http
POST /api/v1/superadmin/pats
Authorization: Bearer <your-google-jwt>
Content-Type: application/json

{
  "name": "CI/CD Pipeline",
  "scope": "WRITE",
  "expiresAt": "2025-12-31T23:59:59Z"
}
```

**Monitoring Service PAT**:

```http
POST /api/v1/superadmin/pats
Authorization: Bearer <your-google-jwt>
Content-Type: application/json

{
  "name": "Monitoring Dashboard",
  "scope": "READ_ONLY",
  "expiresAt": "2025-12-31T23:59:59Z"
}
```

### Bootstrap Flow Diagram

```
┌────────────────────────────────────────────────────────────────┐
│ 1. Run bootstrap-pat.sh                                        │
│    → Creates bootstrap PAT in database                         │
│    → Displays plaintext token on console (one-time)            │
└────────────────────────────────────────────────────────────────┘
                          ↓
┌────────────────────────────────────────────────────────────────┐
│ 2. Save Bootstrap PAT                                          │
│    Token: pat_abc123...                                        │
└────────────────────────────────────────────────────────────────┘
                          ↓
┌────────────────────────────────────────────────────────────────┐
│ 3. POST /api/v1/superadmin/bootstrap                           │
│    Authorization: Bearer pat_abc123...                         │
│    Body: { email, googleId, name }                             │
│                                                                 │
│    → Envoy calls auth service with PAT                         │
│    → Auth service validates PAT (hashes, checks DB)            │
│    → Auth service returns ADMIN scope authorization            │
│    → Main API creates User with SUPER_ADMIN role               │
└────────────────────────────────────────────────────────────────┘
                          ↓
┌────────────────────────────────────────────────────────────────┐
│ 4. Login with Google OAuth                                     │
│    → User authenticates with Google                            │
│    → Receives Google JWT                                       │
│    → System validates JWT, finds User with SUPER_ADMIN role    │
│    → User is now logged in as super admin                      │
└────────────────────────────────────────────────────────────────┘
                          ↓
┌────────────────────────────────────────────────────────────────┐
│ 5. Rotate/Revoke Bootstrap PAT                                 │
│    PUT /api/v1/superadmin/pats/{id}/rotate                     │
│    Authorization: Bearer <google-jwt>                          │
│                                                                 │
│    → Bootstrap PAT is invalidated                              │
│    → New PAT created (if rotating)                             │
│    → System secured                                            │
└────────────────────────────────────────────────────────────────┘
                          ↓
┌────────────────────────────────────────────────────────────────┐
│ 6. Create Service PATs                                         │
│    POST /api/v1/superadmin/pats (for each service)             │
│    Authorization: Bearer <google-jwt>                          │
│                                                                 │
│    → CI/CD PAT created (WRITE scope)                           │
│    → Monitoring PAT created (READ_ONLY scope)                  │
│    → Services configured with their PATs                       │
└────────────────────────────────────────────────────────────────┘
                          ↓
                 ✅ Setup Complete!
```

---

## PAT Management Operations

### List All PATs

```http
GET /api/v1/superadmin/pats
Authorization: Bearer <google-jwt>
```

**Query Parameters**:
- `filter=active` - Only non-revoked, non-expired PATs
- `filter=revoked` - Only revoked PATs
- `filter=expired` - Only expired PATs

**Response**:

```json
{
  "success": true,
  "data": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "name": "CI/CD Pipeline",
      "scope": "WRITE",
      "expiresAt": "2025-12-31T23:59:59Z",
      "createdBy": "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11",
      "createdAt": "2025-01-15T10:30:00Z",
      "lastUsedAt": "2025-01-20T14:45:00Z",
      "revoked": false,
      "revokedAt": null
    }
  ]
}
```

**Note**: `token` and `tokenHash` are NEVER included in responses

### Get PAT Details

```http
GET /api/v1/superadmin/pats/{patId}
Authorization: Bearer <google-jwt>
```

**Response**: Same structure as list item (without plaintext token)

### Update PAT Name

```http
PUT /api/v1/superadmin/pats/{patId}/name
Authorization: Bearer <google-jwt>
Content-Type: application/json

{
  "name": "New CI/CD Pipeline Token"
}
```

### Update PAT Scope

```http
PUT /api/v1/superadmin/pats/{patId}/scope
Authorization: Bearer <google-jwt>
Content-Type: application/json

{
  "scope": "ADMIN"
}
```

**Constraints**:
- Only super admins can change scope
- Cannot change scope of revoked PATs

---

## Best Practices

### 1. Token Naming

**Good Names** (descriptive, purpose-driven):
- ✅ "Production CI/CD Pipeline"
- ✅ "Staging Deployment Token"
- ✅ "Datadog Monitoring Service"
- ✅ "Weekly Analytics Sync"

**Bad Names** (vague, unclear):
- ❌ "Token 1"
- ❌ "My PAT"
- ❌ "Test"
- ❌ "Temporary"

### 2. Scope Selection

**Principle of Least Privilege**: Use the minimum scope required

| Service Type | Recommended Scope |
|-------------|-------------------|
| Monitoring/Dashboards | READ_ONLY |
| Data Sync (one-way) | READ_ONLY |
| CI/CD Deployment | WRITE |
| Admin Automation | WRITE |
| Bootstrap Setup | ADMIN |
| Full System Access | ADMIN |

### 3. Expiration Strategy

**Short-Lived PATs** (recommended):
- Monthly rotation: 30-90 days
- Quarterly rotation: 3-6 months
- Annual rotation: 12 months maximum

**Long-Lived PATs** (not recommended):
- Only for stable, critical services
- Requires strict monitoring
- Must rotate immediately if service changes

### 4. Rotation Schedule

**Regular Rotation**:
- Production PATs: Every 90 days
- Staging PATs: Every 6 months
- Development PATs: Every 12 months
- Bootstrap PAT: Immediately after use

**Incident-Driven Rotation**:
- Immediately if token is exposed
- Immediately if service is compromised
- Immediately if employee with access leaves

### 5. Token Storage

**Secure Storage Locations**:
- ✅ Kubernetes Secrets (encrypted)
- ✅ HashiCorp Vault
- ✅ AWS Secrets Manager
- ✅ Azure Key Vault
- ✅ Environment variables (server-side only)

**NEVER Store In**:
- ❌ Source code repositories
- ❌ Frontend JavaScript
- ❌ Client-side storage (localStorage, cookies)
- ❌ Plain text configuration files
- ❌ Container images
- ❌ Log files

### 6. Monitoring and Alerts

**Monitor**:
- `lastUsedAt` timestamps (detect unused PATs)
- Authentication failures (detect compromise attempts)
- Scope escalation requests (detect abuse)

**Alert On**:
- PAT used from unexpected IP/region
- Multiple failed authentication attempts
- PAT approaching expiration (30 days before)
- Revoked PAT usage attempts

### 7. Audit Review

**Monthly Review**:
- List all active PATs
- Identify unused PATs (lastUsedAt > 30 days ago)
- Verify each PAT still needed
- Revoke unused PATs

**Quarterly Review**:
- Review all PAT scopes (ensure least privilege)
- Rotate high-risk PATs
- Update documentation

---

## Troubleshooting

### PAT Authentication Fails (403 Forbidden)

**Possible Causes**:

1. **Token is Revoked**:
   - Check: `GET /api/v1/superadmin/pats/{patId}`
   - Look for: `"revoked": true`
   - Solution: Create new PAT, update service configuration

2. **Token is Expired**:
   - Check: Compare `expiresAt` to current time
   - Solution: Extend expiration or create new PAT

3. **Insufficient Scope**:
   - Check: PAT scope vs endpoint requirements
   - Example: READ_ONLY PAT cannot POST to `/api/v1/admin/*`
   - Solution: Create new PAT with WRITE or ADMIN scope

4. **Token Hash Mismatch**:
   - Check: Auth service logs for validation errors
   - Cause: Corrupted token or database issue
   - Solution: Rotate PAT to generate new token

### Bootstrap PAT Creation Fails

**Error**: "DATABASE_CONNECTION_FAILED"

**Solution**:
1. Check database connectivity: `mongosh mongodb://...`
2. Verify `PersonalAccessToken` collection exists
3. Check database credentials
4. Retry bootstrap script

**Error**: "Bootstrap PAT already exists"

**Solution**:
1. Query existing bootstrap PAT:
   ```javascript
   db.personal_access_tokens.findOne({ name: "bootstrap" })
   ```
2. If found, use existing PAT
3. If lost, revoke existing and create new one

### Cannot Recover Lost PAT

**Situation**: PAT plaintext token was lost and not saved

**Solutions**:

1. **If PAT is still active**:
   - Rotate the PAT: `PUT /api/v1/superadmin/pats/{patId}/rotate`
   - Save the new token immediately

2. **If PAT cannot be identified**:
   - Create a new PAT with a new name
   - Revoke the old unknown PAT when identified

**Prevention**:
- Always save PAT tokens immediately upon creation
- Store in secure secret management system
- Document which service uses which PAT

### Multiple Services Using Same PAT

**Problem**: Using one PAT for multiple services makes rotation risky

**Solution**:
1. Create separate PAT for each service
2. Name PATs after their service (e.g., "Service-A-Production")
3. Rotate PATs independently
4. Revoke service-specific PAT without affecting others

### PAT Never Used (lastUsedAt is null)

**Investigation**:
1. Check service configuration (is PAT configured?)
2. Check service logs (is service making requests?)
3. Check auth service logs (is PAT reaching auth service?)

**Actions**:
- If service is inactive: Revoke PAT
- If configuration issue: Fix and monitor `lastUsedAt`
- If PAT not needed: Delete PAT

---

## Additional Resources

### Related Documentation

- [API Authentication](./API.md#authentication) - Full authentication overview
- [API Endpoints](./API.md#api-endpoints) - Endpoint documentation
- [Architecture](./ARCHITECTURE.md) - System architecture
- [Deployment](./DEPLOYMENT.md) - Kubernetes deployment with Envoy

### Feature Files

- [bootstrap-setup.feature](../features/bootstrap-setup.feature) - Bootstrap PAT requirements
- [pat-management.feature](../features/pat-management.feature) - PAT lifecycle requirements
- [authorization.feature](../features/authorization.feature) - Authorization rules

### Support

For issues or questions:
1. Check auth service logs: `kubectl logs <pod> -c auth-service`
2. Check audit logs for PAT events
3. Review this documentation
4. Contact system administrator

---

**Document Version**: 1.0
**Last Updated**: 2025-01-15
**Maintained By**: Documentation Team
