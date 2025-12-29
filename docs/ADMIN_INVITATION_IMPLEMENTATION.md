# Admin Invitation Feature - Implementation Requirements

> **ANIMA-1163**: Architecture review and implementation requirements for Admin Invitation feature

## Overview

This document provides the domain model design, implementation requirements, and gap analysis for the Admin Invitation feature as specified in `features/ffl-1-admin-invitation.feature`.

---

## Domain Model Design

### 1. AdminInvitation Entity (NEW)

A new domain entity is required to track the invitation lifecycle separately from User creation.

**Location**: `domain/entity/AdminInvitation.java`

**Attributes**:
| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Unique identifier |
| `email` | String | Invited email address |
| `status` | AdminInvitationStatus | Current invitation state |
| `invitationToken` | String | Secure token for email link |
| `invitedBy` | UUID | Reference to SUPER_ADMIN who sent invite |
| `createdAt` | LocalDateTime | When invitation was created |
| `expiresAt` | LocalDateTime | Expiration timestamp (createdAt + 7 days) |
| `acceptedAt` | LocalDateTime | When invitation was accepted (nullable) |
| `acceptedByUserId` | UUID | Reference to User who accepted (nullable) |

**AdminInvitationStatus Enum** (`domain/model/AdminInvitationStatus.java`):
```java
public enum AdminInvitationStatus {
    PENDING,    // Invitation sent, awaiting response
    ACCEPTED,   // User accepted and account created/upgraded
    EXPIRED,    // Past expiration date
    REJECTED    // Email mismatch or other rejection
}
```

**Business Methods**:
```java
// Check if invitation is still valid
public boolean isValid() {
    return status == PENDING && LocalDateTime.now().isBefore(expiresAt);
}

// Check if invitation is expired
public boolean isExpired() {
    return LocalDateTime.now().isAfter(expiresAt);
}

// Accept the invitation
public void accept(UUID userId) {
    if (!isValid()) throw new IllegalStateException("Invitation is not valid");
    this.status = AdminInvitationStatus.ACCEPTED;
    this.acceptedAt = LocalDateTime.now();
    this.acceptedByUserId = userId;
}

// Mark as expired
public void markExpired() {
    this.status = AdminInvitationStatus.EXPIRED;
}

// Reject with reason
public void reject() {
    this.status = AdminInvitationStatus.REJECTED;
}
```

**MongoDB Document** (`infrastructure/adapter/persistence/document/AdminInvitationDocument.java`):
```javascript
{
  _id: UUID,
  email: String,
  status: String,           // PENDING, ACCEPTED, EXPIRED, REJECTED
  invitationToken: String,  // Unique secure token
  invitedBy: UUID,          // SUPER_ADMIN who invited
  createdAt: ISODate,
  expiresAt: ISODate,
  acceptedAt: ISODate,      // nullable
  acceptedByUserId: UUID    // nullable
}

// Indexes
db.adminInvitations.createIndex({ email: 1 })
db.adminInvitations.createIndex({ invitationToken: 1 }, { unique: true })
db.adminInvitations.createIndex({ status: 1 })
db.adminInvitations.createIndex({ expiresAt: 1 })
```

---

### 2. User Aggregate Enhancements

The existing `User` aggregate requires additional methods for role management.

**Location**: `domain/aggregate/User.java`

**New Methods Required**:
```java
/**
 * Upgrades user role from PLAYER to ADMIN
 * @throws IllegalStateException if user is already ADMIN or SUPER_ADMIN
 */
public void upgradeToAdmin() {
    if (this.role != Role.PLAYER) {
        throw new IllegalStateException("Can only upgrade PLAYER to ADMIN");
    }
    this.role = Role.ADMIN;
}

/**
 * Downgrades user role from ADMIN to PLAYER
 * @throws IllegalStateException if user is not ADMIN
 */
public void downgradeToPlayer() {
    if (this.role != Role.ADMIN) {
        throw new IllegalStateException("Can only downgrade ADMIN to PLAYER");
    }
    this.role = Role.PLAYER;
}
```

---

### 3. League Aggregate Enhancement

For the admin revocation scenario, leagues owned by revoked admins need status tracking.

**New Field** in `League.java`:
```java
private LeagueOwnerStatus ownerStatus; // ACTIVE, ADMIN_REVOKED
```

**LeagueOwnerStatus Enum** (`domain/model/LeagueOwnerStatus.java`):
```java
public enum LeagueOwnerStatus {
    ACTIVE,         // Normal operation
    ADMIN_REVOKED   // Owner's admin privileges were revoked
}
```

---

### 4. AdminAuditLog Entity (NEW - for audit scenario)

**Location**: `domain/entity/AdminAuditLog.java`

**Attributes**:
| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Unique identifier |
| `adminId` | UUID | Admin who performed the action |
| `adminEmail` | String | Admin's email (denormalized for queries) |
| `action` | AdminAction | Type of action performed |
| `targetId` | UUID | ID of affected entity (nullable) |
| `targetType` | String | Type of affected entity |
| `details` | Map<String, Object> | Additional action details |
| `timestamp` | LocalDateTime | When action occurred |

**AdminAction Enum**:
```java
public enum AdminAction {
    LEAGUE_CREATED,
    LEAGUE_CONFIGURED,
    PLAYER_INVITED,
    PLAYER_REMOVED,
    CONFIGURATION_CHANGED
}
```

---

## Repository Interfaces (Ports)

### AdminInvitationRepository (NEW)

**Location**: `domain/port/AdminInvitationRepository.java`

```java
public interface AdminInvitationRepository {
    AdminInvitation save(AdminInvitation invitation);
    Optional<AdminInvitation> findById(UUID id);
    Optional<AdminInvitation> findByEmail(String email);
    Optional<AdminInvitation> findByInvitationToken(String token);
    List<AdminInvitation> findByStatus(AdminInvitationStatus status);
    List<AdminInvitation> findPendingExpired(LocalDateTime now);
    boolean existsByEmailAndStatus(String email, AdminInvitationStatus status);
}
```

### AdminAuditLogRepository (NEW)

**Location**: `domain/port/AdminAuditLogRepository.java`

```java
public interface AdminAuditLogRepository {
    AdminAuditLog save(AdminAuditLog log);
    List<AdminAuditLog> findByAdminId(UUID adminId);
    List<AdminAuditLog> findAll(PageRequest pageRequest);
    List<AdminAuditLog> findByAction(AdminAction action);
    List<AdminAuditLog> findByTimestampBetween(LocalDateTime start, LocalDateTime end);
}
```

---

## Use Cases to Implement/Update

### 1. SendAdminInvitationUseCase (REPLACE InviteAdminUseCase)

**Current Issue**: Existing `InviteAdminUseCase` creates User directly without tracking invitation lifecycle.

**New Behavior**:
```java
public class SendAdminInvitationUseCase {

    public SendAdminInvitationResult execute(SendAdminInvitationCommand command) {
        // 1. Verify inviter is SUPER_ADMIN
        // 2. Validate target role is not SUPER_ADMIN (INVALID_ROLE error)
        // 3. Check no pending invitation exists for email
        // 4. Create AdminInvitation with PENDING status
        // 5. Generate secure invitation token
        // 6. Set expiresAt = now + 7 days
        // 7. Return result with invitation token for email
    }
}
```

### 2. AcceptAdminInvitationUseCase (UPDATE)

**Current Issue**: Doesn't validate email match, doesn't handle existing players.

**New Behavior**:
```java
public class AcceptAdminInvitationUseCase {

    public AcceptAdminInvitationResult execute(AcceptAdminInvitationCommand command) {
        // 1. Find invitation by token
        // 2. Check if expired → INVITATION_EXPIRED error
        // 3. Validate Google email matches invitation email → EMAIL_MISMATCH error
        // 4. Check if user exists:
        //    a. NEW USER: Create User with ADMIN role, link googleId
        //    b. EXISTING PLAYER: Upgrade role to ADMIN
        //    c. EXISTING ADMIN/SUPER_ADMIN: Error - already admin
        // 5. Mark invitation as ACCEPTED
        // 6. Return created/upgraded user
    }
}
```

### 3. ListAdminsUseCase (NEW)

```java
public class ListAdminsUseCase {

    public ListAdminsResult execute(ListAdminsCommand command) {
        // 1. Verify requester is SUPER_ADMIN
        // 2. Query all users with role ADMIN
        // 3. Return list with: id, email, name, googleId, createdAt
    }
}
```

### 4. RevokeAdminUseCase (NEW)

```java
public class RevokeAdminUseCase {

    public RevokeAdminResult execute(RevokeAdminCommand command) {
        // 1. Verify requester is SUPER_ADMIN
        // 2. Find admin user by email
        // 3. Downgrade role from ADMIN to PLAYER
        // 4. Find all leagues owned by this user
        // 5. Mark owned leagues as ADMIN_REVOKED
        // 6. Return result with affected leagues count
    }
}
```

### 5. GetAdminAuditLogsUseCase (NEW)

```java
public class GetAdminAuditLogsUseCase {

    public GetAdminAuditLogsResult execute(GetAdminAuditLogsCommand command) {
        // 1. Verify requester is SUPER_ADMIN
        // 2. Query audit logs with optional filters
        // 3. Return paginated audit entries
    }
}
```

---

## API Endpoints

All endpoints under `/api/v1/superadmin/` require SUPER_ADMIN role.

| Method | Endpoint | Use Case | Description |
|--------|----------|----------|-------------|
| POST | `/invitations` | SendAdminInvitationUseCase | Send admin invitation |
| GET | `/invitations` | - | List all admin invitations |
| GET | `/invitations/{token}/accept` | AcceptAdminInvitationUseCase | Accept invitation (callback URL) |
| GET | `/admins` | ListAdminsUseCase | List all admin users |
| DELETE | `/admins/{email}` | RevokeAdminUseCase | Revoke admin privileges |
| GET | `/audit-logs` | GetAdminAuditLogsUseCase | View admin audit logs |

---

## Error Handling

| Error Code | HTTP Status | Scenario |
|------------|-------------|----------|
| `EMAIL_MISMATCH` | 400 | Google OAuth email doesn't match invitation email |
| `INVITATION_EXPIRED` | 410 | Invitation is past 7-day expiration |
| `INVALID_ROLE` | 400 | Attempt to create SUPER_ADMIN invitation |
| `INVITATION_NOT_FOUND` | 404 | Invalid invitation token |
| `USER_ALREADY_ADMIN` | 409 | User already has ADMIN or SUPER_ADMIN role |
| `PENDING_INVITATION_EXISTS` | 409 | Active invitation already exists for email |

---

## Gherkin Scenario Coverage Matrix

| Scenario | Use Cases Required | Status |
|----------|-------------------|--------|
| Super admin invites a new admin | SendAdminInvitationUseCase | New |
| User accepts admin invitation and creates account | AcceptAdminInvitationUseCase | Update |
| Existing user accepts admin invitation | AcceptAdminInvitationUseCase | Update |
| Admin invitation with mismatched email | AcceptAdminInvitationUseCase | Update |
| Expired admin invitation | AcceptAdminInvitationUseCase | Update |
| Super admin views all admins | ListAdminsUseCase | New |
| Super admin revokes admin access | RevokeAdminUseCase | New |
| Super admin cannot be created through invitation | SendAdminInvitationUseCase | New |
| Admin cannot invite other admins | SendAdminInvitationUseCase | Existing (authorization) |
| Super admin audits admin activities | GetAdminAuditLogsUseCase | New |

---

## Implementation Priority

1. **Phase 1 - Core Invitation Flow**:
   - AdminInvitation entity + repository
   - AdminInvitationStatus enum
   - SendAdminInvitationUseCase
   - AcceptAdminInvitationUseCase (updated)

2. **Phase 2 - Admin Management**:
   - User.upgradeToAdmin() / downgradeToPlayer()
   - ListAdminsUseCase
   - RevokeAdminUseCase
   - LeagueOwnerStatus enum

3. **Phase 3 - Audit Logging**:
   - AdminAuditLog entity + repository
   - AdminAction enum
   - GetAdminAuditLogsUseCase
   - Integrate audit logging into existing use cases

---

## Files to Create/Modify

### New Files:
- `domain/entity/AdminInvitation.java`
- `domain/model/AdminInvitationStatus.java`
- `domain/model/LeagueOwnerStatus.java`
- `domain/model/AdminAction.java`
- `domain/entity/AdminAuditLog.java`
- `domain/port/AdminInvitationRepository.java`
- `domain/port/AdminAuditLogRepository.java`
- `application/usecase/SendAdminInvitationUseCase.java`
- `application/usecase/ListAdminsUseCase.java`
- `application/usecase/RevokeAdminUseCase.java`
- `application/usecase/GetAdminAuditLogsUseCase.java`
- `infrastructure/adapter/persistence/document/AdminInvitationDocument.java`
- `infrastructure/adapter/persistence/document/AdminAuditLogDocument.java`
- `infrastructure/adapter/persistence/mapper/AdminInvitationMapper.java`
- `infrastructure/adapter/persistence/mapper/AdminAuditLogMapper.java`
- `infrastructure/adapter/persistence/AdminInvitationRepositoryImpl.java`
- `infrastructure/adapter/persistence/AdminAuditLogRepositoryImpl.java`
- `infrastructure/adapter/persistence/repository/AdminInvitationMongoRepository.java`
- `infrastructure/adapter/persistence/repository/AdminAuditLogMongoRepository.java`

### Files to Modify:
- `domain/aggregate/User.java` - Add upgradeToAdmin(), downgradeToPlayer()
- `domain/aggregate/League.java` - Add ownerStatus field
- `application/usecase/AcceptAdminInvitationUseCase.java` - Complete rewrite
- `application/usecase/InviteAdminUseCase.java` - Deprecate/remove
- `infrastructure/adapter/rest/SuperAdminController.java` - Add new endpoints

---

## Testing Requirements

Each scenario in the Gherkin feature file should have:
1. Unit tests for use cases
2. Integration tests for repository implementations
3. E2E tests via Cucumber step definitions

---

**Document Status**: Ready for Backend Implementation
**Created**: 2025-12-29
**Ticket**: ANIMA-1163
