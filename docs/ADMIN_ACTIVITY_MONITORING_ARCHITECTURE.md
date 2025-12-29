# Admin Activity Monitoring Architecture

## Overview

This document defines the architecture for the Admin Activity Monitoring system in FFL Playoffs. The system provides comprehensive tracking of administrative actions, audit trails for compliance and security, and monitoring dashboards for operational visibility into admin activities.

## Business Context

### Problem Statement
Administrative platforms require robust activity monitoring for:
- **Security Auditing**: Track who performed what actions and when
- **Compliance**: Meet regulatory requirements for audit trails
- **Troubleshooting**: Diagnose issues by reviewing admin actions
- **Accountability**: Ensure administrators are accountable for their actions
- **Anomaly Detection**: Identify suspicious or unusual admin behavior

### Success Criteria
- All admin actions are captured with full context
- Audit logs are immutable and tamper-evident
- Real-time monitoring dashboards provide operational visibility
- Historical data supports forensic investigation
- System scales to handle high-volume admin operations

## Use Cases

### UC-1: Record Admin Activity
**Actor**: System (automatic)
**Trigger**: Admin performs any action
**Flow**:
1. Admin initiates action through API or UI
2. System captures action context (who, what, when, where)
3. Activity event is created with full metadata
4. Event is persisted to audit log
5. Real-time metrics are updated

### UC-2: Query Audit Trail
**Actor**: Super Admin, Compliance Officer
**Trigger**: Investigation or audit requirement
**Flow**:
1. User specifies search criteria (admin, action type, date range)
2. System queries audit log
3. Results are filtered based on user permissions
4. Paginated results returned with full event details

### UC-3: Monitor Real-Time Activity
**Actor**: Operations Team
**Trigger**: Operational monitoring
**Flow**:
1. User opens monitoring dashboard
2. Dashboard subscribes to activity stream
3. Real-time events appear as they occur
4. Alerts trigger for configured thresholds

### UC-4: Generate Compliance Report
**Actor**: Compliance Officer
**Trigger**: Compliance audit requirement
**Flow**:
1. User requests compliance report for period
2. System aggregates activity data
3. Report generated with required audit information
4. Report exported in requested format (PDF, CSV)

### UC-5: Detect Anomalous Behavior
**Actor**: Security System (automatic)
**Trigger**: Activity pattern analysis
**Flow**:
1. System analyzes activity patterns in real-time
2. Anomaly detection algorithms evaluate behavior
3. Suspicious patterns trigger security alerts
4. Alert routed to security team for review

## Domain Model

### Aggregates

#### ActivityEvent Aggregate (Root)
```java
public class ActivityEvent {
    private ActivityEventId id;
    private AdminId adminId;
    private AdminIdentity adminIdentity;      // Snapshot at event time
    private ActionType actionType;
    private ActionCategory category;
    private ResourceReference targetResource;
    private ActivityContext context;
    private ActivityOutcome outcome;
    private Instant timestamp;
    private String correlationId;             // For tracking related actions
    private String sessionId;                 // Admin session
    private IpAddress sourceIp;
    private UserAgent userAgent;
    private GeoLocation geoLocation;
    private List<FieldChange> changes;        // For update actions
    private Map<String, Object> metadata;     // Additional context

    // Factory methods
    public static ActivityEvent recordAction(
            AdminId adminId,
            AdminIdentity identity,
            ActionType actionType,
            ResourceReference target,
            ActivityContext context) {
        return ActivityEvent.builder()
            .id(ActivityEventId.generate())
            .adminId(adminId)
            .adminIdentity(identity)
            .actionType(actionType)
            .category(actionType.getCategory())
            .targetResource(target)
            .context(context)
            .outcome(ActivityOutcome.pending())
            .timestamp(Instant.now())
            .build();
    }

    public void markSucceeded(Object result) {
        this.outcome = ActivityOutcome.succeeded(result);
    }

    public void markFailed(String errorCode, String errorMessage) {
        this.outcome = ActivityOutcome.failed(errorCode, errorMessage);
    }

    public void recordChanges(List<FieldChange> changes) {
        this.changes = new ArrayList<>(changes);
    }

    public boolean isSecuritySensitive() {
        return actionType.isSensitive() ||
               category == ActionCategory.SECURITY ||
               category == ActionCategory.USER_MANAGEMENT;
    }

    public boolean requiresApproval() {
        return actionType.requiresApproval();
    }
}
```

#### AuditTrail Aggregate
```java
public class AuditTrail {
    private AuditTrailId id;
    private ResourceReference resource;
    private List<AuditEntry> entries;
    private Instant createdAt;
    private Instant lastModifiedAt;
    private String checksum;                  // Integrity verification

    public void addEntry(ActivityEvent event) {
        AuditEntry entry = AuditEntry.fromEvent(event);
        entries.add(entry);
        lastModifiedAt = Instant.now();
        recalculateChecksum();
    }

    public List<AuditEntry> getEntriesBetween(Instant start, Instant end) {
        return entries.stream()
            .filter(e -> !e.getTimestamp().isBefore(start) &&
                        !e.getTimestamp().isAfter(end))
            .sorted(Comparator.comparing(AuditEntry::getTimestamp))
            .collect(Collectors.toList());
    }

    public boolean verifyIntegrity() {
        String calculated = calculateChecksum();
        return checksum.equals(calculated);
    }

    private void recalculateChecksum() {
        this.checksum = calculateChecksum();
    }

    private String calculateChecksum() {
        // SHA-256 of all entry hashes chained together
        StringBuilder chain = new StringBuilder();
        for (AuditEntry entry : entries) {
            chain.append(entry.getHash());
        }
        return DigestUtils.sha256Hex(chain.toString());
    }
}
```

#### AdminSession Aggregate
```java
public class AdminSession {
    private SessionId id;
    private AdminId adminId;
    private Instant startedAt;
    private Instant lastActivityAt;
    private Instant endedAt;
    private SessionStatus status;
    private IpAddress ipAddress;
    private UserAgent userAgent;
    private GeoLocation location;
    private List<ActivityEventId> activityIds;
    private int actionCount;
    private Set<ActionCategory> categoriesAccessed;

    public void recordActivity(ActivityEvent event) {
        activityIds.add(event.getId());
        lastActivityAt = Instant.now();
        actionCount++;
        categoriesAccessed.add(event.getCategory());
    }

    public void endSession(SessionEndReason reason) {
        this.status = SessionStatus.ENDED;
        this.endedAt = Instant.now();
    }

    public Duration getSessionDuration() {
        Instant end = endedAt != null ? endedAt : Instant.now();
        return Duration.between(startedAt, end);
    }

    public boolean isActive() {
        return status == SessionStatus.ACTIVE;
    }

    public boolean isIdle(Duration threshold) {
        return Duration.between(lastActivityAt, Instant.now())
            .compareTo(threshold) > 0;
    }
}
```

### Entities

#### AuditEntry Entity
```java
public class AuditEntry {
    private AuditEntryId id;
    private ActivityEventId eventId;
    private AdminId adminId;
    private String adminName;                 // Denormalized for history
    private ActionType actionType;
    private String actionDescription;
    private ActivityOutcome outcome;
    private Instant timestamp;
    private String previousHash;              // Chain to previous entry
    private String hash;                      // This entry's hash

    public static AuditEntry fromEvent(ActivityEvent event) {
        return AuditEntry.builder()
            .id(AuditEntryId.generate())
            .eventId(event.getId())
            .adminId(event.getAdminId())
            .adminName(event.getAdminIdentity().getDisplayName())
            .actionType(event.getActionType())
            .actionDescription(event.getActionType().getDescription())
            .outcome(event.getOutcome())
            .timestamp(event.getTimestamp())
            .build();
    }

    public void chainTo(AuditEntry previous) {
        this.previousHash = previous != null ? previous.getHash() : "GENESIS";
        this.hash = calculateHash();
    }

    private String calculateHash() {
        String content = String.join("|",
            id.toString(),
            eventId.toString(),
            adminId.toString(),
            actionType.name(),
            timestamp.toString(),
            previousHash
        );
        return DigestUtils.sha256Hex(content);
    }
}
```

#### ActivityAlert Entity
```java
public class ActivityAlert {
    private AlertId id;
    private AlertType type;
    private AlertSeverity severity;
    private String title;
    private String description;
    private AdminId subjectAdminId;
    private List<ActivityEventId> triggeringEvents;
    private AlertStatus status;
    private Instant createdAt;
    private Instant acknowledgedAt;
    private AdminId acknowledgedBy;
    private String resolution;

    public static ActivityAlert securityAlert(
            String title,
            String description,
            AdminId subjectAdmin,
            List<ActivityEvent> events) {
        return ActivityAlert.builder()
            .id(AlertId.generate())
            .type(AlertType.SECURITY)
            .severity(AlertSeverity.HIGH)
            .title(title)
            .description(description)
            .subjectAdminId(subjectAdmin)
            .triggeringEvents(events.stream()
                .map(ActivityEvent::getId)
                .collect(Collectors.toList()))
            .status(AlertStatus.OPEN)
            .createdAt(Instant.now())
            .build();
    }

    public void acknowledge(AdminId acknowledger, String notes) {
        this.status = AlertStatus.ACKNOWLEDGED;
        this.acknowledgedAt = Instant.now();
        this.acknowledgedBy = acknowledger;
        this.resolution = notes;
    }

    public void resolve(String resolution) {
        this.status = AlertStatus.RESOLVED;
        this.resolution = resolution;
    }

    public void escalate() {
        this.severity = this.severity.escalate();
    }
}
```

### Value Objects

#### ActionType Value Object
```java
public enum ActionType {
    // User Management
    USER_CREATE(ActionCategory.USER_MANAGEMENT, "Created user", true, false),
    USER_UPDATE(ActionCategory.USER_MANAGEMENT, "Updated user", false, false),
    USER_DELETE(ActionCategory.USER_MANAGEMENT, "Deleted user", true, true),
    USER_SUSPEND(ActionCategory.USER_MANAGEMENT, "Suspended user", true, false),
    USER_ACTIVATE(ActionCategory.USER_MANAGEMENT, "Activated user", true, false),
    USER_PASSWORD_RESET(ActionCategory.USER_MANAGEMENT, "Reset user password", true, false),

    // Role Management
    ROLE_CREATE(ActionCategory.SECURITY, "Created role", true, false),
    ROLE_UPDATE(ActionCategory.SECURITY, "Updated role", true, false),
    ROLE_DELETE(ActionCategory.SECURITY, "Deleted role", true, true),
    ROLE_ASSIGN(ActionCategory.SECURITY, "Assigned role to user", true, false),
    ROLE_REVOKE(ActionCategory.SECURITY, "Revoked role from user", true, false),

    // Permission Management
    PERMISSION_GRANT(ActionCategory.SECURITY, "Granted permission", true, false),
    PERMISSION_REVOKE(ActionCategory.SECURITY, "Revoked permission", true, false),

    // League Management
    LEAGUE_CREATE(ActionCategory.LEAGUE_MANAGEMENT, "Created league", false, false),
    LEAGUE_UPDATE(ActionCategory.LEAGUE_MANAGEMENT, "Updated league", false, false),
    LEAGUE_DELETE(ActionCategory.LEAGUE_MANAGEMENT, "Deleted league", false, true),
    LEAGUE_ARCHIVE(ActionCategory.LEAGUE_MANAGEMENT, "Archived league", false, false),

    // Draft Management
    DRAFT_SCHEDULE(ActionCategory.DRAFT_MANAGEMENT, "Scheduled draft", false, false),
    DRAFT_START(ActionCategory.DRAFT_MANAGEMENT, "Started draft", false, false),
    DRAFT_PAUSE(ActionCategory.DRAFT_MANAGEMENT, "Paused draft", false, false),
    DRAFT_CANCEL(ActionCategory.DRAFT_MANAGEMENT, "Cancelled draft", false, true),
    DRAFT_OVERRIDE_PICK(ActionCategory.DRAFT_MANAGEMENT, "Override draft pick", true, false),

    // Scoring
    SCORE_MANUAL_ADJUST(ActionCategory.SCORING, "Manual score adjustment", true, false),
    SCORE_RECALCULATE(ActionCategory.SCORING, "Triggered score recalculation", false, false),

    // Simulation
    SIMULATION_START(ActionCategory.SIMULATION, "Started simulation", false, false),
    SIMULATION_STOP(ActionCategory.SIMULATION, "Stopped simulation", false, false),
    SIMULATION_RESET(ActionCategory.SIMULATION, "Reset simulation", true, true),

    // Feature Flags
    FLAG_CREATE(ActionCategory.FEATURE_FLAGS, "Created feature flag", false, false),
    FLAG_UPDATE(ActionCategory.FEATURE_FLAGS, "Updated feature flag", false, false),
    FLAG_ENABLE(ActionCategory.FEATURE_FLAGS, "Enabled feature flag", false, false),
    FLAG_DISABLE(ActionCategory.FEATURE_FLAGS, "Disabled feature flag", false, false),

    // System Configuration
    CONFIG_UPDATE(ActionCategory.SYSTEM, "Updated system configuration", true, false),
    MAINTENANCE_MODE_ENABLE(ActionCategory.SYSTEM, "Enabled maintenance mode", true, false),
    MAINTENANCE_MODE_DISABLE(ActionCategory.SYSTEM, "Disabled maintenance mode", true, false),

    // Data Management
    DATA_EXPORT(ActionCategory.DATA, "Exported data", true, false),
    DATA_IMPORT(ActionCategory.DATA, "Imported data", true, false),
    DATA_PURGE(ActionCategory.DATA, "Purged data", true, true),
    BACKUP_CREATE(ActionCategory.DATA, "Created backup", false, false),
    BACKUP_RESTORE(ActionCategory.DATA, "Restored from backup", true, true),

    // Authentication
    LOGIN_SUCCESS(ActionCategory.AUTHENTICATION, "Successful login", false, false),
    LOGIN_FAILURE(ActionCategory.AUTHENTICATION, "Failed login attempt", true, false),
    LOGOUT(ActionCategory.AUTHENTICATION, "Logged out", false, false),
    SESSION_TIMEOUT(ActionCategory.AUTHENTICATION, "Session timed out", false, false),
    MFA_ENABLE(ActionCategory.AUTHENTICATION, "Enabled MFA", true, false),
    MFA_DISABLE(ActionCategory.AUTHENTICATION, "Disabled MFA", true, false),

    // Invitations
    INVITATION_SEND(ActionCategory.USER_MANAGEMENT, "Sent admin invitation", false, false),
    INVITATION_CANCEL(ActionCategory.USER_MANAGEMENT, "Cancelled invitation", false, false),
    INVITATION_RESEND(ActionCategory.USER_MANAGEMENT, "Resent invitation", false, false);

    private final ActionCategory category;
    private final String description;
    private final boolean sensitive;
    private final boolean requiresApproval;

    public boolean isSensitive() {
        return sensitive;
    }

    public boolean requiresApproval() {
        return requiresApproval;
    }
}

public enum ActionCategory {
    USER_MANAGEMENT,
    SECURITY,
    LEAGUE_MANAGEMENT,
    DRAFT_MANAGEMENT,
    SCORING,
    SIMULATION,
    FEATURE_FLAGS,
    SYSTEM,
    DATA,
    AUTHENTICATION
}
```

#### ResourceReference Value Object
```java
public class ResourceReference {
    private ResourceType type;
    private String resourceId;
    private String resourceName;              // Denormalized for display
    private String resourcePath;              // Hierarchical path

    public static ResourceReference user(UserId userId, String userName) {
        return new ResourceReference(
            ResourceType.USER,
            userId.toString(),
            userName,
            "/users/" + userId
        );
    }

    public static ResourceReference league(LeagueId leagueId, String leagueName) {
        return new ResourceReference(
            ResourceType.LEAGUE,
            leagueId.toString(),
            leagueName,
            "/leagues/" + leagueId
        );
    }

    public static ResourceReference featureFlag(String flagKey) {
        return new ResourceReference(
            ResourceType.FEATURE_FLAG,
            flagKey,
            flagKey,
            "/feature-flags/" + flagKey
        );
    }

    public static ResourceReference system(String component) {
        return new ResourceReference(
            ResourceType.SYSTEM,
            component,
            component,
            "/system/" + component
        );
    }
}

public enum ResourceType {
    USER,
    ADMIN,
    ROLE,
    PERMISSION,
    LEAGUE,
    TEAM,
    DRAFT,
    PLAYER,
    SCORE,
    SIMULATION,
    FEATURE_FLAG,
    CONFIGURATION,
    SYSTEM
}
```

#### ActivityContext Value Object
```java
public class ActivityContext {
    private String requestId;
    private String endpoint;
    private HttpMethod method;
    private Map<String, String> requestHeaders;
    private String requestBody;               // Sanitized, no secrets
    private Integer responseStatus;
    private Long durationMs;

    public static ActivityContext fromRequest(HttpServletRequest request) {
        return ActivityContext.builder()
            .requestId(MDC.get("requestId"))
            .endpoint(request.getRequestURI())
            .method(HttpMethod.valueOf(request.getMethod()))
            .requestHeaders(extractSafeHeaders(request))
            .build();
    }

    private static Map<String, String> extractSafeHeaders(HttpServletRequest request) {
        Map<String, String> headers = new HashMap<>();
        // Only include non-sensitive headers
        List<String> safeHeaders = List.of(
            "Content-Type", "Accept", "User-Agent", "X-Request-ID"
        );
        for (String header : safeHeaders) {
            String value = request.getHeader(header);
            if (value != null) {
                headers.put(header, value);
            }
        }
        return headers;
    }

    public void recordResponse(int status, long durationMs) {
        this.responseStatus = status;
        this.durationMs = durationMs;
    }
}
```

#### ActivityOutcome Value Object
```java
public class ActivityOutcome {
    private OutcomeStatus status;
    private String resultSummary;
    private String errorCode;
    private String errorMessage;
    private Map<String, Object> resultData;

    public static ActivityOutcome pending() {
        return new ActivityOutcome(OutcomeStatus.PENDING, null, null, null, null);
    }

    public static ActivityOutcome succeeded(Object result) {
        String summary = result != null ?
            summarizeResult(result) : "Action completed successfully";
        return new ActivityOutcome(
            OutcomeStatus.SUCCESS,
            summary,
            null,
            null,
            extractResultData(result)
        );
    }

    public static ActivityOutcome failed(String errorCode, String errorMessage) {
        return new ActivityOutcome(
            OutcomeStatus.FAILURE,
            null,
            errorCode,
            errorMessage,
            null
        );
    }

    public boolean isSuccessful() {
        return status == OutcomeStatus.SUCCESS;
    }

    public boolean isFailed() {
        return status == OutcomeStatus.FAILURE;
    }
}

public enum OutcomeStatus {
    PENDING,
    SUCCESS,
    FAILURE
}
```

#### FieldChange Value Object
```java
public class FieldChange {
    private String fieldPath;
    private String fieldName;
    private Object previousValue;
    private Object newValue;
    private ChangeType changeType;

    public static FieldChange modification(String path, Object oldVal, Object newVal) {
        return new FieldChange(
            path,
            extractFieldName(path),
            oldVal,
            newVal,
            ChangeType.MODIFIED
        );
    }

    public static FieldChange addition(String path, Object value) {
        return new FieldChange(
            path,
            extractFieldName(path),
            null,
            value,
            ChangeType.ADDED
        );
    }

    public static FieldChange removal(String path, Object value) {
        return new FieldChange(
            path,
            extractFieldName(path),
            value,
            null,
            ChangeType.REMOVED
        );
    }

    public String getHumanReadableChange() {
        return switch (changeType) {
            case ADDED -> fieldName + " set to '" + newValue + "'";
            case REMOVED -> fieldName + " removed (was '" + previousValue + "')";
            case MODIFIED -> fieldName + " changed from '" + previousValue +
                            "' to '" + newValue + "'";
        };
    }
}

public enum ChangeType {
    ADDED,
    MODIFIED,
    REMOVED
}
```

#### GeoLocation Value Object
```java
public class GeoLocation {
    private String country;
    private String countryCode;
    private String region;
    private String city;
    private Double latitude;
    private Double longitude;
    private String timezone;

    public static GeoLocation fromIp(IpAddress ip, GeoIpService geoService) {
        return geoService.lookup(ip.getValue());
    }

    public boolean isUnusualFor(List<GeoLocation> previousLocations) {
        // Check if this location is significantly different from usual
        return previousLocations.stream()
            .noneMatch(prev -> isSameRegion(prev));
    }

    private boolean isSameRegion(GeoLocation other) {
        return this.countryCode.equals(other.countryCode) &&
               this.region.equals(other.region);
    }

    public String getDisplayLocation() {
        return city + ", " + region + ", " + countryCode;
    }
}
```

### Domain Services

#### ActivityMonitoringService
```java
@Service
public class ActivityMonitoringService {
    private final ActivityEventRepository eventRepository;
    private final AuditTrailRepository auditTrailRepository;
    private final AdminSessionRepository sessionRepository;
    private final ActivityAlertService alertService;
    private final AnomalyDetector anomalyDetector;
    private final ApplicationEventPublisher eventPublisher;

    @Transactional
    public ActivityEvent recordActivity(
            AdminId adminId,
            AdminIdentity identity,
            ActionType actionType,
            ResourceReference target,
            ActivityContext context) {

        // Create activity event
        ActivityEvent event = ActivityEvent.recordAction(
            adminId, identity, actionType, target, context
        );

        // Enrich with session and location data
        AdminSession session = sessionRepository.findActiveByAdminId(adminId)
            .orElseGet(() -> createSession(adminId, context));
        event.setSessionId(session.getId().toString());

        // Check for anomalies before persisting
        if (anomalyDetector.isAnomalous(event, getRecentActivity(adminId))) {
            alertService.createAnomalyAlert(event);
        }

        // Persist event
        eventRepository.save(event);

        // Update session
        session.recordActivity(event);
        sessionRepository.save(session);

        // Publish for real-time subscribers
        eventPublisher.publishEvent(new ActivityRecordedEvent(event));

        return event;
    }

    public void completeActivity(
            ActivityEventId eventId,
            ActivityOutcome outcome,
            List<FieldChange> changes) {

        ActivityEvent event = eventRepository.findById(eventId)
            .orElseThrow(() -> new ActivityEventNotFoundException(eventId));

        if (outcome.isSuccessful()) {
            event.markSucceeded(outcome.getResultData());
        } else {
            event.markFailed(outcome.getErrorCode(), outcome.getErrorMessage());
        }

        if (changes != null && !changes.isEmpty()) {
            event.recordChanges(changes);
        }

        eventRepository.save(event);

        // Update audit trail for the resource
        updateAuditTrail(event);

        // Publish completion event
        eventPublisher.publishEvent(new ActivityCompletedEvent(event));
    }

    private void updateAuditTrail(ActivityEvent event) {
        ResourceReference resource = event.getTargetResource();

        AuditTrail trail = auditTrailRepository
            .findByResource(resource)
            .orElseGet(() -> AuditTrail.create(resource));

        trail.addEntry(event);
        auditTrailRepository.save(trail);
    }

    private List<ActivityEvent> getRecentActivity(AdminId adminId) {
        Instant since = Instant.now().minus(Duration.ofHours(24));
        return eventRepository.findByAdminIdSince(adminId, since);
    }
}
```

#### AnomalyDetector Domain Service
```java
@Service
public class AnomalyDetector {
    private final AdminBehaviorProfileRepository profileRepository;

    public boolean isAnomalous(ActivityEvent event, List<ActivityEvent> recentActivity) {
        AdminBehaviorProfile profile = profileRepository
            .findByAdminId(event.getAdminId())
            .orElse(AdminBehaviorProfile.defaultProfile());

        return checkLocationAnomaly(event, profile) ||
               checkTimeAnomaly(event, profile) ||
               checkVelocityAnomaly(event, recentActivity) ||
               checkPatternAnomaly(event, recentActivity, profile);
    }

    private boolean checkLocationAnomaly(ActivityEvent event, AdminBehaviorProfile profile) {
        if (event.getGeoLocation() == null) {
            return false;
        }
        return event.getGeoLocation().isUnusualFor(profile.getUsualLocations());
    }

    private boolean checkTimeAnomaly(ActivityEvent event, AdminBehaviorProfile profile) {
        LocalTime eventTime = event.getTimestamp()
            .atZone(ZoneId.of(profile.getTimezone()))
            .toLocalTime();
        return !profile.isWithinUsualHours(eventTime);
    }

    private boolean checkVelocityAnomaly(
            ActivityEvent event,
            List<ActivityEvent> recentActivity) {
        // Check for impossibly fast location changes
        if (event.getGeoLocation() == null || recentActivity.isEmpty()) {
            return false;
        }

        ActivityEvent lastEvent = recentActivity.get(recentActivity.size() - 1);
        if (lastEvent.getGeoLocation() == null) {
            return false;
        }

        double distanceKm = calculateDistance(
            event.getGeoLocation(),
            lastEvent.getGeoLocation()
        );
        Duration timeDiff = Duration.between(
            lastEvent.getTimestamp(),
            event.getTimestamp()
        );

        // More than 1000km in less than 1 hour is suspicious
        double hoursElapsed = timeDiff.toMinutes() / 60.0;
        return hoursElapsed > 0 && (distanceKm / hoursElapsed) > 1000;
    }

    private boolean checkPatternAnomaly(
            ActivityEvent event,
            List<ActivityEvent> recentActivity,
            AdminBehaviorProfile profile) {

        // Check for unusual action patterns
        long sensitiveActionsCount = recentActivity.stream()
            .filter(ActivityEvent::isSecuritySensitive)
            .count();

        // Too many sensitive actions in short period
        return sensitiveActionsCount > profile.getSensitiveActionThreshold();
    }
}
```

#### DashboardMetricsService
```java
@Service
public class DashboardMetricsService {
    private final ActivityEventRepository eventRepository;
    private final AdminSessionRepository sessionRepository;
    private final ActivityAlertRepository alertRepository;

    public DashboardSummary getCurrentSummary() {
        Instant now = Instant.now();
        Instant hourAgo = now.minus(Duration.ofHours(1));
        Instant dayAgo = now.minus(Duration.ofDays(1));

        return DashboardSummary.builder()
            .activeAdmins(sessionRepository.countActiveSessions())
            .actionsLastHour(eventRepository.countSince(hourAgo))
            .actionsLast24Hours(eventRepository.countSince(dayAgo))
            .openAlerts(alertRepository.countByStatus(AlertStatus.OPEN))
            .failedActionsLastHour(eventRepository.countFailedSince(hourAgo))
            .categoryBreakdown(eventRepository.countByCategory(dayAgo))
            .topActiveAdmins(eventRepository.findTopActiveAdmins(dayAgo, 10))
            .recentSecurityEvents(eventRepository.findRecentSensitive(10))
            .build();
    }

    public List<ActivityTrend> getActivityTrends(Duration period, Duration interval) {
        Instant start = Instant.now().minus(period);
        return eventRepository.getActivityTrends(start, interval);
    }

    public AdminActivitySummary getAdminSummary(AdminId adminId, Duration period) {
        Instant start = Instant.now().minus(period);
        List<ActivityEvent> events = eventRepository.findByAdminIdSince(adminId, start);

        return AdminActivitySummary.builder()
            .adminId(adminId)
            .totalActions(events.size())
            .successfulActions(events.stream()
                .filter(e -> e.getOutcome().isSuccessful())
                .count())
            .failedActions(events.stream()
                .filter(e -> e.getOutcome().isFailed())
                .count())
            .actionsByCategory(groupByCategory(events))
            .mostCommonActions(findMostCommonActions(events))
            .averageSessionDuration(calculateAverageSessionDuration(adminId, start))
            .lastActiveAt(events.isEmpty() ? null :
                events.get(events.size() - 1).getTimestamp())
            .build();
    }

    public ComplianceReport generateComplianceReport(
            Instant startDate,
            Instant endDate,
            Set<ActionCategory> categories) {

        List<ActivityEvent> events = eventRepository
            .findBetweenDates(startDate, endDate)
            .stream()
            .filter(e -> categories.isEmpty() ||
                        categories.contains(e.getCategory()))
            .collect(Collectors.toList());

        return ComplianceReport.builder()
            .reportId(ReportId.generate())
            .periodStart(startDate)
            .periodEnd(endDate)
            .generatedAt(Instant.now())
            .totalEvents(events.size())
            .uniqueAdmins(countUniqueAdmins(events))
            .eventsByCategory(groupByCategory(events))
            .sensitiveActions(filterSensitiveActions(events))
            .failedActions(filterFailedActions(events))
            .securityAlerts(alertRepository.findBetweenDates(startDate, endDate))
            .build();
    }
}
```

## Port Interfaces

### Inbound Ports

```java
public interface ActivityMonitoringPort {
    // Record activity
    ActivityEvent recordActivity(RecordActivityCommand command);
    void completeActivity(CompleteActivityCommand command);

    // Query activity
    Page<ActivityEvent> searchActivities(ActivitySearchCriteria criteria, Pageable pageable);
    Optional<ActivityEvent> getActivityById(ActivityEventId id);
    List<ActivityEvent> getAdminActivities(AdminId adminId, Instant since);

    // Audit trails
    AuditTrail getResourceAuditTrail(ResourceReference resource);
    boolean verifyAuditTrailIntegrity(AuditTrailId id);

    // Sessions
    Optional<AdminSession> getCurrentSession(AdminId adminId);
    List<AdminSession> getAdminSessions(AdminId adminId, Instant since);

    // Dashboard
    DashboardSummary getDashboardSummary();
    List<ActivityTrend> getActivityTrends(Duration period, Duration interval);
    AdminActivitySummary getAdminSummary(AdminId adminId, Duration period);

    // Alerts
    Page<ActivityAlert> getAlerts(AlertSearchCriteria criteria, Pageable pageable);
    void acknowledgeAlert(AlertId alertId, AdminId acknowledger, String notes);
    void resolveAlert(AlertId alertId, String resolution);

    // Reports
    ComplianceReport generateComplianceReport(ComplianceReportRequest request);
    byte[] exportReport(ReportId reportId, ExportFormat format);
}

// Commands
@Value
public class RecordActivityCommand {
    AdminId adminId;
    AdminIdentity adminIdentity;
    ActionType actionType;
    ResourceReference targetResource;
    ActivityContext context;
    IpAddress sourceIp;
    UserAgent userAgent;
}

@Value
public class CompleteActivityCommand {
    ActivityEventId eventId;
    ActivityOutcome outcome;
    List<FieldChange> changes;
}

// Search criteria
@Value
@Builder
public class ActivitySearchCriteria {
    Set<AdminId> adminIds;
    Set<ActionType> actionTypes;
    Set<ActionCategory> categories;
    Set<OutcomeStatus> outcomes;
    ResourceReference targetResource;
    Instant startDate;
    Instant endDate;
    String keyword;
    Boolean sensitiveOnly;
}
```

### Outbound Ports

```java
public interface ActivityEventRepository {
    ActivityEvent save(ActivityEvent event);
    Optional<ActivityEvent> findById(ActivityEventId id);
    List<ActivityEvent> findByAdminIdSince(AdminId adminId, Instant since);
    Page<ActivityEvent> search(ActivitySearchCriteria criteria, Pageable pageable);
    long countSince(Instant since);
    long countFailedSince(Instant since);
    Map<ActionCategory, Long> countByCategory(Instant since);
    List<AdminActivityCount> findTopActiveAdmins(Instant since, int limit);
    List<ActivityEvent> findRecentSensitive(int limit);
    List<ActivityTrend> getActivityTrends(Instant start, Duration interval);
    List<ActivityEvent> findBetweenDates(Instant start, Instant end);
}

public interface AuditTrailRepository {
    AuditTrail save(AuditTrail trail);
    Optional<AuditTrail> findById(AuditTrailId id);
    Optional<AuditTrail> findByResource(ResourceReference resource);
    List<AuditTrail> findByResourceType(ResourceType type);
}

public interface AdminSessionRepository {
    AdminSession save(AdminSession session);
    Optional<AdminSession> findById(SessionId id);
    Optional<AdminSession> findActiveByAdminId(AdminId adminId);
    List<AdminSession> findByAdminIdSince(AdminId adminId, Instant since);
    long countActiveSessions();
    List<AdminSession> findIdleSessions(Duration threshold);
}

public interface ActivityAlertRepository {
    ActivityAlert save(ActivityAlert alert);
    Optional<ActivityAlert> findById(AlertId id);
    Page<ActivityAlert> search(AlertSearchCriteria criteria, Pageable pageable);
    long countByStatus(AlertStatus status);
    List<ActivityAlert> findBetweenDates(Instant start, Instant end);
}

public interface AdminBehaviorProfileRepository {
    AdminBehaviorProfile save(AdminBehaviorProfile profile);
    Optional<AdminBehaviorProfile> findByAdminId(AdminId adminId);
}

public interface GeoIpService {
    GeoLocation lookup(String ipAddress);
}

public interface ActivityNotificationPort {
    void notifySecurityAlert(ActivityAlert alert);
    void notifyAnomalousActivity(ActivityEvent event);
    void broadcastActivityStream(ActivityEvent event);
}
```

## REST API Endpoints

### Activity Events API
```yaml
/api/v1/admin/activities:
  get:
    summary: Search activity events
    parameters:
      - name: adminIds
        in: query
        schema:
          type: array
          items:
            type: string
      - name: actionTypes
        in: query
        schema:
          type: array
          items:
            type: string
      - name: categories
        in: query
        schema:
          type: array
          items:
            type: string
      - name: startDate
        in: query
        schema:
          type: string
          format: date-time
      - name: endDate
        in: query
        schema:
          type: string
          format: date-time
      - name: sensitiveOnly
        in: query
        schema:
          type: boolean
      - name: page
        in: query
        schema:
          type: integer
      - name: size
        in: query
        schema:
          type: integer
    responses:
      200:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/PagedActivityEvents'

/api/v1/admin/activities/{eventId}:
  get:
    summary: Get activity event by ID
    parameters:
      - name: eventId
        in: path
        required: true
        schema:
          type: string
    responses:
      200:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ActivityEventResponse'
      404:
        description: Activity event not found
```

### Audit Trails API
```yaml
/api/v1/admin/audit-trails:
  get:
    summary: Get audit trail for a resource
    parameters:
      - name: resourceType
        in: query
        required: true
        schema:
          type: string
      - name: resourceId
        in: query
        required: true
        schema:
          type: string
    responses:
      200:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/AuditTrailResponse'

/api/v1/admin/audit-trails/{trailId}/verify:
  post:
    summary: Verify audit trail integrity
    parameters:
      - name: trailId
        in: path
        required: true
        schema:
          type: string
    responses:
      200:
        content:
          application/json:
            schema:
              type: object
              properties:
                valid:
                  type: boolean
                verifiedAt:
                  type: string
                  format: date-time
                entriesVerified:
                  type: integer
```

### Dashboard API
```yaml
/api/v1/admin/monitoring/dashboard:
  get:
    summary: Get dashboard summary
    responses:
      200:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/DashboardSummary'

/api/v1/admin/monitoring/trends:
  get:
    summary: Get activity trends
    parameters:
      - name: period
        in: query
        schema:
          type: string
          enum: [HOUR, DAY, WEEK, MONTH]
      - name: interval
        in: query
        schema:
          type: string
          enum: [MINUTE, HOUR, DAY]
    responses:
      200:
        content:
          application/json:
            schema:
              type: array
              items:
                $ref: '#/components/schemas/ActivityTrend'

/api/v1/admin/monitoring/admins/{adminId}/summary:
  get:
    summary: Get admin activity summary
    parameters:
      - name: adminId
        in: path
        required: true
        schema:
          type: string
      - name: period
        in: query
        schema:
          type: string
          enum: [DAY, WEEK, MONTH, QUARTER]
    responses:
      200:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/AdminActivitySummary'
```

### Alerts API
```yaml
/api/v1/admin/monitoring/alerts:
  get:
    summary: Get activity alerts
    parameters:
      - name: status
        in: query
        schema:
          type: string
          enum: [OPEN, ACKNOWLEDGED, RESOLVED]
      - name: severity
        in: query
        schema:
          type: string
          enum: [LOW, MEDIUM, HIGH, CRITICAL]
      - name: page
        in: query
        schema:
          type: integer
      - name: size
        in: query
        schema:
          type: integer
    responses:
      200:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/PagedAlerts'

/api/v1/admin/monitoring/alerts/{alertId}/acknowledge:
  post:
    summary: Acknowledge an alert
    parameters:
      - name: alertId
        in: path
        required: true
        schema:
          type: string
    requestBody:
      content:
        application/json:
          schema:
            type: object
            properties:
              notes:
                type: string
    responses:
      200:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/AlertResponse'

/api/v1/admin/monitoring/alerts/{alertId}/resolve:
  post:
    summary: Resolve an alert
    parameters:
      - name: alertId
        in: path
        required: true
        schema:
          type: string
    requestBody:
      content:
        application/json:
          schema:
            type: object
            properties:
              resolution:
                type: string
                required: true
    responses:
      200:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/AlertResponse'
```

### Reports API
```yaml
/api/v1/admin/monitoring/reports/compliance:
  post:
    summary: Generate compliance report
    requestBody:
      content:
        application/json:
          schema:
            type: object
            required:
              - startDate
              - endDate
            properties:
              startDate:
                type: string
                format: date-time
              endDate:
                type: string
                format: date-time
              categories:
                type: array
                items:
                  type: string
    responses:
      200:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ComplianceReport'

/api/v1/admin/monitoring/reports/{reportId}/export:
  get:
    summary: Export report
    parameters:
      - name: reportId
        in: path
        required: true
        schema:
          type: string
      - name: format
        in: query
        schema:
          type: string
          enum: [PDF, CSV, JSON]
    responses:
      200:
        content:
          application/octet-stream:
            schema:
              type: string
              format: binary
```

### WebSocket API
```yaml
/ws/admin/activity-stream:
  description: Real-time activity event stream
  subscribe:
    message:
      $ref: '#/components/schemas/ActivityStreamEvent'

/ws/admin/alert-stream:
  description: Real-time alert stream
  subscribe:
    message:
      $ref: '#/components/schemas/AlertStreamEvent'
```

## MongoDB Collections

### activity_events Collection
```javascript
{
  _id: ObjectId,
  eventId: "evt_abc123",
  adminId: "adm_xyz789",
  adminIdentity: {
    email: "admin@example.com",
    displayName: "John Admin",
    roles: ["SUPER_ADMIN"]
  },
  actionType: "USER_CREATE",
  category: "USER_MANAGEMENT",
  targetResource: {
    type: "USER",
    resourceId: "usr_new123",
    resourceName: "newuser@example.com",
    resourcePath: "/users/usr_new123"
  },
  context: {
    requestId: "req_abc123",
    endpoint: "/api/v1/users",
    method: "POST",
    requestHeaders: {
      "Content-Type": "application/json",
      "User-Agent": "Mozilla/5.0..."
    },
    responseStatus: 201,
    durationMs: 145
  },
  outcome: {
    status: "SUCCESS",
    resultSummary: "User created successfully",
    resultData: {
      userId: "usr_new123"
    }
  },
  timestamp: ISODate("2024-01-15T10:30:00Z"),
  correlationId: "corr_xyz789",
  sessionId: "sess_abc123",
  sourceIp: "192.168.1.100",
  userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)...",
  geoLocation: {
    country: "United States",
    countryCode: "US",
    region: "California",
    city: "San Francisco",
    latitude: 37.7749,
    longitude: -122.4194,
    timezone: "America/Los_Angeles"
  },
  changes: [
    {
      fieldPath: "status",
      fieldName: "status",
      previousValue: null,
      newValue: "ACTIVE",
      changeType: "ADDED"
    }
  ],
  metadata: {
    clientVersion: "2.1.0",
    feature: "user-management"
  },
  createdAt: ISODate("2024-01-15T10:30:00Z")
}

// Indexes
db.activity_events.createIndex({ "eventId": 1 }, { unique: true })
db.activity_events.createIndex({ "adminId": 1, "timestamp": -1 })
db.activity_events.createIndex({ "actionType": 1, "timestamp": -1 })
db.activity_events.createIndex({ "category": 1, "timestamp": -1 })
db.activity_events.createIndex({ "targetResource.type": 1, "targetResource.resourceId": 1 })
db.activity_events.createIndex({ "timestamp": -1 })
db.activity_events.createIndex({ "sessionId": 1 })
db.activity_events.createIndex({ "outcome.status": 1, "timestamp": -1 })
db.activity_events.createIndex({
  "adminIdentity.email": "text",
  "targetResource.resourceName": "text"
})

// TTL index for automatic cleanup (retain 2 years)
db.activity_events.createIndex(
  { "timestamp": 1 },
  { expireAfterSeconds: 63072000 }  // 730 days
)
```

### audit_trails Collection
```javascript
{
  _id: ObjectId,
  trailId: "trail_abc123",
  resource: {
    type: "USER",
    resourceId: "usr_xyz789",
    resourceName: "user@example.com",
    resourcePath: "/users/usr_xyz789"
  },
  entries: [
    {
      entryId: "entry_001",
      eventId: "evt_aaa111",
      adminId: "adm_abc",
      adminName: "John Admin",
      actionType: "USER_CREATE",
      actionDescription: "Created user",
      outcome: {
        status: "SUCCESS",
        resultSummary: "User created"
      },
      timestamp: ISODate("2024-01-10T09:00:00Z"),
      previousHash: "GENESIS",
      hash: "a1b2c3d4e5f6..."
    },
    {
      entryId: "entry_002",
      eventId: "evt_bbb222",
      adminId: "adm_def",
      adminName: "Jane Admin",
      actionType: "USER_UPDATE",
      actionDescription: "Updated user",
      outcome: {
        status: "SUCCESS",
        resultSummary: "User email updated"
      },
      timestamp: ISODate("2024-01-12T14:30:00Z"),
      previousHash: "a1b2c3d4e5f6...",
      hash: "f6e5d4c3b2a1..."
    }
  ],
  checksum: "sha256:abc123def456...",
  createdAt: ISODate("2024-01-10T09:00:00Z"),
  lastModifiedAt: ISODate("2024-01-12T14:30:00Z")
}

// Indexes
db.audit_trails.createIndex({ "trailId": 1 }, { unique: true })
db.audit_trails.createIndex({
  "resource.type": 1,
  "resource.resourceId": 1
}, { unique: true })
db.audit_trails.createIndex({ "lastModifiedAt": -1 })
```

### admin_sessions Collection
```javascript
{
  _id: ObjectId,
  sessionId: "sess_abc123",
  adminId: "adm_xyz789",
  startedAt: ISODate("2024-01-15T08:00:00Z"),
  lastActivityAt: ISODate("2024-01-15T11:45:00Z"),
  endedAt: null,
  status: "ACTIVE",
  ipAddress: "192.168.1.100",
  userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)...",
  location: {
    country: "United States",
    countryCode: "US",
    region: "California",
    city: "San Francisco"
  },
  activityIds: [
    "evt_001", "evt_002", "evt_003"
  ],
  actionCount: 47,
  categoriesAccessed: ["USER_MANAGEMENT", "LEAGUE_MANAGEMENT", "SECURITY"],
  createdAt: ISODate("2024-01-15T08:00:00Z")
}

// Indexes
db.admin_sessions.createIndex({ "sessionId": 1 }, { unique: true })
db.admin_sessions.createIndex({ "adminId": 1, "status": 1 })
db.admin_sessions.createIndex({ "status": 1, "lastActivityAt": -1 })
db.admin_sessions.createIndex({ "startedAt": -1 })
```

### activity_alerts Collection
```javascript
{
  _id: ObjectId,
  alertId: "alert_abc123",
  type: "SECURITY",
  severity: "HIGH",
  title: "Unusual login location detected",
  description: "Admin logged in from a new geographic location",
  subjectAdminId: "adm_xyz789",
  triggeringEvents: ["evt_001", "evt_002"],
  status: "OPEN",
  createdAt: ISODate("2024-01-15T10:30:00Z"),
  acknowledgedAt: null,
  acknowledgedBy: null,
  resolution: null
}

// Indexes
db.activity_alerts.createIndex({ "alertId": 1 }, { unique: true })
db.activity_alerts.createIndex({ "status": 1, "severity": -1 })
db.activity_alerts.createIndex({ "subjectAdminId": 1, "createdAt": -1 })
db.activity_alerts.createIndex({ "createdAt": -1 })
db.activity_alerts.createIndex({ "type": 1, "status": 1 })
```

### admin_behavior_profiles Collection
```javascript
{
  _id: ObjectId,
  adminId: "adm_xyz789",
  usualLocations: [
    {
      country: "United States",
      countryCode: "US",
      region: "California",
      city: "San Francisco"
    },
    {
      country: "United States",
      countryCode: "US",
      region: "New York",
      city: "New York"
    }
  ],
  timezone: "America/Los_Angeles",
  usualHoursStart: "08:00",
  usualHoursEnd: "20:00",
  sensitiveActionThreshold: 10,
  averageActionsPerDay: 45.5,
  commonActionTypes: ["USER_CREATE", "LEAGUE_UPDATE", "SCORE_RECALCULATE"],
  lastUpdated: ISODate("2024-01-15T00:00:00Z"),
  createdAt: ISODate("2024-01-01T00:00:00Z")
}

// Indexes
db.admin_behavior_profiles.createIndex({ "adminId": 1 }, { unique: true })
```

## Gherkin Feature File

```gherkin
Feature: Admin Activity Monitoring
  As a system administrator
  I want to monitor and audit admin activities
  So that I can ensure security and compliance

  Background:
    Given an authenticated super admin "security@example.com"
    And the activity monitoring system is enabled

  # Activity Recording

  Scenario: Record successful admin action
    Given admin "admin@example.com" is authenticated
    When the admin creates a new user with email "newuser@example.com"
    Then an activity event should be recorded with:
      | field        | value           |
      | actionType   | USER_CREATE     |
      | category     | USER_MANAGEMENT |
      | outcome      | SUCCESS         |
    And the event should include the admin's identity
    And the event should include the request context
    And the event should include the target resource details

  Scenario: Record failed admin action
    Given admin "admin@example.com" is authenticated
    When the admin attempts to delete a non-existent user "usr_invalid"
    Then an activity event should be recorded with:
      | field        | value        |
      | actionType   | USER_DELETE  |
      | outcome      | FAILURE      |
    And the event should include the error details

  Scenario: Capture field changes for update actions
    Given admin "admin@example.com" is authenticated
    And a user "existing@example.com" exists with role "USER"
    When the admin updates the user's role to "LEAGUE_ADMIN"
    Then an activity event should be recorded
    And the event should include field changes:
      | field | previousValue | newValue     |
      | role  | USER          | LEAGUE_ADMIN |

  # Audit Trail

  Scenario: Build audit trail for resource
    Given a user "tracked@example.com" was created by "admin1@example.com"
    And the user was updated by "admin2@example.com"
    And the user was suspended by "admin1@example.com"
    When I request the audit trail for user "tracked@example.com"
    Then I should receive an audit trail with 3 entries
    And the entries should be in chronological order
    And each entry should be linked to the previous via hash

  Scenario: Verify audit trail integrity
    Given a user "audited@example.com" with 5 audit entries
    When I verify the audit trail integrity
    Then the verification should pass
    And all entry hashes should be valid

  Scenario: Detect tampered audit trail
    Given a user "tampered@example.com" with audit entries
    And one audit entry has been modified externally
    When I verify the audit trail integrity
    Then the verification should fail
    And the system should report the tampered entry

  # Activity Search

  Scenario: Search activities by admin
    Given the following activities have been recorded:
      | admin              | actionType  | timestamp           |
      | admin1@example.com | USER_CREATE | 2024-01-15T10:00:00 |
      | admin1@example.com | USER_UPDATE | 2024-01-15T11:00:00 |
      | admin2@example.com | ROLE_CREATE | 2024-01-15T10:30:00 |
    When I search activities for admin "admin1@example.com"
    Then I should receive 2 activity events
    And the events should be sorted by timestamp descending

  Scenario: Search activities by date range
    Given activities recorded over the past week
    When I search activities from "2024-01-14" to "2024-01-15"
    Then I should receive only activities within that range

  Scenario: Search security-sensitive activities only
    Given activities with mixed sensitivity levels
    When I search for sensitive activities only
    Then I should receive only events marked as security-sensitive

  # Dashboard Metrics

  Scenario: View dashboard summary
    Given 50 activities recorded in the last hour
    And 500 activities recorded in the last 24 hours
    And 3 open security alerts
    When I request the dashboard summary
    Then I should see:
      | metric               | value |
      | actionsLastHour      | 50    |
      | actionsLast24Hours   | 500   |
      | openAlerts           | 3     |

  Scenario: View activity trends
    Given activities recorded over the past week
    When I request activity trends with daily interval
    Then I should receive trend data for each day
    And each data point should include action counts by category

  Scenario: View admin activity summary
    Given admin "monitored@example.com" has performed 100 actions this month
    When I request the activity summary for "monitored@example.com"
    Then I should see:
      | metric           | expectedValue |
      | totalActions     | 100           |
    And I should see action breakdown by category
    And I should see most common action types

  # Anomaly Detection

  Scenario: Detect unusual login location
    Given admin "admin@example.com" usually logs in from "San Francisco, CA"
    When the admin logs in from "Tokyo, Japan"
    Then a security alert should be created
    And the alert should have severity "HIGH"
    And the alert should reference the login event

  Scenario: Detect impossible travel
    Given admin "admin@example.com" performed action from "New York" at "10:00"
    When the admin performs action from "London" at "10:30"
    Then a velocity anomaly alert should be created
    And the alert description should mention impossible travel

  Scenario: Detect unusual activity volume
    Given admin "admin@example.com" typically performs 50 actions per day
    When the admin performs 200 sensitive actions in one hour
    Then an anomaly alert should be created
    And the alert should indicate unusual activity volume

  # Alerts Management

  Scenario: Acknowledge security alert
    Given an open security alert "alert_123"
    When I acknowledge the alert with notes "Verified legitimate access"
    Then the alert status should be "ACKNOWLEDGED"
    And the acknowledgment should record my admin ID and timestamp

  Scenario: Resolve security alert
    Given an acknowledged alert "alert_123"
    When I resolve the alert with resolution "False positive - admin traveling"
    Then the alert status should be "RESOLVED"
    And the resolution should be recorded

  # Session Tracking

  Scenario: Track admin session activity
    Given admin "admin@example.com" starts a new session
    When the admin performs multiple actions
    Then all actions should be linked to the session
    And the session should track total action count
    And the session should track categories accessed

  Scenario: Detect idle sessions
    Given admin "admin@example.com" has an active session
    And the session has been idle for 30 minutes
    When the system checks for idle sessions
    Then the session should be flagged as idle

  # Compliance Reports

  Scenario: Generate compliance report
    Given activities recorded for January 2024
    When I request a compliance report for January 2024
    Then I should receive a report including:
      | section            | expected                       |
      | totalEvents        | count of all events            |
      | uniqueAdmins       | count of distinct admins       |
      | sensitiveActions   | list of sensitive actions      |
      | securityAlerts     | list of alerts in period       |

  Scenario: Export compliance report as PDF
    Given a generated compliance report "report_123"
    When I export the report as PDF
    Then I should receive a PDF document
    And the document should include all report sections

  # Real-time Monitoring

  Scenario: Subscribe to activity stream
    Given I am connected to the activity WebSocket
    When admin "admin@example.com" performs an action
    Then I should receive the activity event in real-time

  Scenario: Receive alert notifications
    Given I am subscribed to the alert stream
    When a new security alert is created
    Then I should receive the alert notification immediately
```

## Files to Create

### Domain Layer
```
src/main/java/com/fflplayoffs/admin/monitoring/domain/
├── model/
│   ├── ActivityEvent.java
│   ├── ActivityEventId.java
│   ├── AuditTrail.java
│   ├── AuditTrailId.java
│   ├── AuditEntry.java
│   ├── AuditEntryId.java
│   ├── AdminSession.java
│   ├── SessionId.java
│   ├── ActivityAlert.java
│   ├── AlertId.java
│   └── AdminBehaviorProfile.java
├── vo/
│   ├── ActionType.java
│   ├── ActionCategory.java
│   ├── ResourceReference.java
│   ├── ResourceType.java
│   ├── ActivityContext.java
│   ├── ActivityOutcome.java
│   ├── OutcomeStatus.java
│   ├── FieldChange.java
│   ├── ChangeType.java
│   ├── GeoLocation.java
│   ├── IpAddress.java
│   ├── UserAgent.java
│   ├── AdminIdentity.java
│   ├── AlertType.java
│   ├── AlertSeverity.java
│   ├── AlertStatus.java
│   ├── SessionStatus.java
│   └── SessionEndReason.java
├── service/
│   ├── ActivityMonitoringService.java
│   ├── AnomalyDetector.java
│   └── DashboardMetricsService.java
└── event/
    ├── ActivityRecordedEvent.java
    └── ActivityCompletedEvent.java
```

### Port Layer
```
src/main/java/com/fflplayoffs/admin/monitoring/port/
├── inbound/
│   ├── ActivityMonitoringPort.java
│   ├── command/
│   │   ├── RecordActivityCommand.java
│   │   └── CompleteActivityCommand.java
│   └── query/
│       ├── ActivitySearchCriteria.java
│       ├── AlertSearchCriteria.java
│       └── ComplianceReportRequest.java
└── outbound/
    ├── ActivityEventRepository.java
    ├── AuditTrailRepository.java
    ├── AdminSessionRepository.java
    ├── ActivityAlertRepository.java
    ├── AdminBehaviorProfileRepository.java
    ├── GeoIpService.java
    └── ActivityNotificationPort.java
```

### Adapter Layer
```
src/main/java/com/fflplayoffs/admin/monitoring/adapter/
├── inbound/
│   └── rest/
│       ├── ActivityController.java
│       ├── AuditTrailController.java
│       ├── DashboardController.java
│       ├── AlertController.java
│       ├── ReportController.java
│       └── dto/
│           ├── ActivityEventResponse.java
│           ├── AuditTrailResponse.java
│           ├── DashboardSummary.java
│           ├── AdminActivitySummary.java
│           ├── ActivityTrend.java
│           ├── AlertResponse.java
│           ├── AcknowledgeAlertRequest.java
│           ├── ResolveAlertRequest.java
│           ├── ComplianceReportResponse.java
│           └── ComplianceReportRequest.java
├── outbound/
│   ├── persistence/
│   │   ├── MongoActivityEventRepository.java
│   │   ├── MongoAuditTrailRepository.java
│   │   ├── MongoAdminSessionRepository.java
│   │   ├── MongoActivityAlertRepository.java
│   │   ├── MongoAdminBehaviorProfileRepository.java
│   │   └── document/
│   │       ├── ActivityEventDocument.java
│   │       ├── AuditTrailDocument.java
│   │       ├── AdminSessionDocument.java
│   │       ├── ActivityAlertDocument.java
│   │       └── AdminBehaviorProfileDocument.java
│   ├── geoip/
│   │   └── MaxMindGeoIpAdapter.java
│   └── notification/
│       └── WebSocketActivityNotificationAdapter.java
└── websocket/
    ├── ActivityStreamHandler.java
    └── AlertStreamHandler.java
```

### Application Layer
```
src/main/java/com/fflplayoffs/admin/monitoring/application/
├── ActivityMonitoringApplicationService.java
├── ActivityInterceptor.java           # AOP interceptor for automatic tracking
└── mapper/
    ├── ActivityEventMapper.java
    ├── AuditTrailMapper.java
    └── AlertMapper.java
```

### Infrastructure
```
src/main/java/com/fflplayoffs/admin/monitoring/infrastructure/
├── config/
│   ├── MonitoringConfig.java
│   └── WebSocketConfig.java
└── aspect/
    └── ActivityTrackingAspect.java
```

### Test Files
```
src/test/java/com/fflplayoffs/admin/monitoring/
├── domain/
│   ├── ActivityEventTest.java
│   ├── AuditTrailTest.java
│   ├── AnomalyDetectorTest.java
│   └── DashboardMetricsServiceTest.java
├── adapter/
│   ├── ActivityControllerTest.java
│   ├── MongoActivityEventRepositoryTest.java
│   └── WebSocketActivityStreamTest.java
└── integration/
    ├── ActivityMonitoringIntegrationTest.java
    └── AuditTrailIntegrationTest.java

src/test/resources/features/
└── admin-activity-monitoring.feature
```

## Implementation Priority

### Phase 1: Core Activity Recording (Sprint 1)
1. ActivityEvent domain model and value objects
2. ActivityEventRepository with MongoDB persistence
3. ActivityMonitoringService for recording actions
4. ActivityInterceptor/Aspect for automatic tracking
5. Basic REST API for querying activities

### Phase 2: Audit Trail (Sprint 1-2)
1. AuditTrail and AuditEntry domain models
2. Hash-chain implementation for tamper detection
3. AuditTrailRepository with MongoDB persistence
4. Audit trail query API
5. Integrity verification endpoint

### Phase 3: Session Tracking (Sprint 2)
1. AdminSession domain model
2. Session lifecycle management
3. Session-activity linking
4. Idle session detection

### Phase 4: Dashboard & Metrics (Sprint 2-3)
1. DashboardMetricsService implementation
2. Aggregation queries for trends
3. Dashboard REST API
4. WebSocket for real-time updates

### Phase 5: Anomaly Detection & Alerts (Sprint 3)
1. AdminBehaviorProfile domain model
2. AnomalyDetector implementation
3. ActivityAlert domain model
4. Alert management API
5. Alert notification system

### Phase 6: Compliance & Reporting (Sprint 3-4)
1. ComplianceReport generation
2. Report export (PDF, CSV)
3. Data retention policies
4. Complete Gherkin test coverage

## Security Considerations

1. **Data Sensitivity**: Activity logs may contain sensitive information
   - Sanitize request bodies (remove passwords, tokens)
   - Limit access to monitoring features by role
   - Encrypt sensitive fields at rest

2. **Audit Trail Integrity**:
   - Hash chain for tamper detection
   - Separate write permissions from read
   - Consider blockchain-based audit for high-security needs

3. **Privacy Compliance**:
   - Respect data retention policies (GDPR)
   - Implement right to erasure with audit exceptions
   - Log access to activity logs themselves

4. **Performance**:
   - Async activity recording to avoid blocking
   - Efficient indexing for common queries
   - Consider time-series optimizations for trends
