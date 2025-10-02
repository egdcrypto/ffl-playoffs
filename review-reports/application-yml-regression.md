# Critical Issue: application.yml Database Regression
Date: 2025-10-01
Reviewer: Product Manager
Severity: **CRITICAL**
Status: ❌ **BLOCKING ISSUE**

## Summary
Engineer 2 has introduced a **REGRESSION** in `application.yml` by reverting from MongoDB back to PostgreSQL, violating project requirements and undoing a previous fix.

## Issue Details

### What Happened
1. **Commit 5052652**: Initial implementation used PostgreSQL
2. **Commit 1831a36**: Fixed to use MongoDB (correct)
3. **Current uncommitted changes**: Reverted BACK to PostgreSQL (WRONG)

### Evidence

**File:** `ffl-playoffs-api/src/main/resources/application.yml`

**Current (INCORRECT):**
```yaml
datasource:
  url: ${DB_URL:jdbc:postgresql://localhost:5432/ffl_playoffs}
  username: ${DB_USERNAME:ffl_user}
  password: ${DB_PASSWORD:ffl_password}
  driver-class-name: org.postgresql.Driver

jpa:
  hibernate:
    ddl-auto: update
```

**Required (from commit 1831a36):**
```yaml
data:
  mongodb:
    uri: ${MONGODB_URI:mongodb://localhost:27017/ffl_playoffs}
```

## Requirements Violation

### ❌ FAIL - Database Technology

**Requirement:** requirements.md:545
```
Database: MongoDB 6+
```

**Requirement:** requirements.md:544-545
```
- Framework: Spring Boot, Spring Data MongoDB
- Database: MongoDB 6+
```

**Actual:** PostgreSQL with JPA/Hibernate

**Impact:**
- ❌ Wrong database technology (PostgreSQL instead of MongoDB)
- ❌ Wrong Spring Data framework (JPA instead of MongoDB)
- ❌ Wrong ORM (Hibernate instead of MongoDB drivers)
- ❌ Regression - undoes previous fix (commit 1831a36)

## Additional Issues

### Logging Configuration
**Line 42** (current):
```yaml
org.hibernate: WARN
```

**Should be:**
```yaml
org.mongodb: WARN
```

## Root Cause Analysis

This appears to be a **regression** where Engineer 2:
1. Made changes to application.yml
2. Accidentally reverted to PostgreSQL configuration
3. Did not review git history before making changes
4. Did not verify requirements.md before committing

## Required Fix

**Action:** REVERT to MongoDB configuration from commit 1831a36

**Correct configuration:**
```yaml
spring:
  application:
    name: ffl-playoffs-api

  data:
    mongodb:
      uri: ${MONGODB_URI:mongodb://localhost:27017/ffl_playoffs}

  jackson:
    serialization:
      write-dates-as-timestamps: false
    default-property-inclusion: non_null

server:
  port: 8080
  error:
    include-message: always
    include-binding-errors: always

springdoc:
  api-docs:
    path: /api-docs
  swagger-ui:
    path: /swagger-ui.html
    enabled: true

logging:
  level:
    com.ffl.playoffs: INFO
    org.springframework: WARN
    org.mongodb: WARN
```

## build.gradle Verification Needed

Also verify `build.gradle` still has:
- ✅ `spring-boot-starter-data-mongodb` dependency
- ❌ NO `spring-boot-starter-data-jpa` dependency
- ❌ NO `postgresql` JDBC driver dependency

If build.gradle was also changed, revert those changes too.

## Recommendation

❌ **REJECT** - Critical requirements violation

**Status:** BLOCKING - Must be fixed before ANY other work proceeds

## Next Steps

1. **IMMEDIATE**: Revert application.yml to MongoDB configuration
2. **IMMEDIATE**: Verify build.gradle has correct MongoDB dependencies
3. **IMMEDIATE**: Remove any PostgreSQL/JPA dependencies added
4. **IMMEDIATE**: Commit fix with message: "fix: revert application.yml regression to MongoDB"
5. **REQUIRED**: Engineer 2 must review requirements.md before making configuration changes
6. **REQUIRED**: Engineer 2 must check git history before reverting previous fixes

## Prevention

**For Engineer 2:**
- Always review `git log <file>` before making changes
- Always verify requirements.md for technology stack requirements
- Never revert fixes without understanding why they were made
- Use `git diff` to verify changes match requirements

---

**Severity:** CRITICAL
**Priority:** P0 - BLOCKING
**Assigned To:** Engineer 2 (Project Structure)
**Review Status:** ❌ FAILED - Must fix immediately
