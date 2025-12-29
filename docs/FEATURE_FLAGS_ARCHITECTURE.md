# Admin Feature Flags Architecture

> **ANIMA-1050**: Design and architecture for Feature Flag management

## Overview

Feature Flags provide controlled feature rollouts and runtime configuration, enabling:

- **Gradual Rollouts**: Release features to a percentage of users
- **Targeted Releases**: Enable features for specific users, leagues, or tiers
- **Kill Switches**: Instantly disable problematic features
- **A/B Testing**: Compare feature variants
- **Environment Control**: Different configurations per environment

This system allows safe deployment of new functionality with the ability to quickly respond to issues.

---

## Use Cases

### Primary Use Cases

1. **Create Feature Flag**
   - Define flag with unique key
   - Set initial state and rollout strategy
   - Configure targeting rules
   - Add metadata and description

2. **Toggle Feature Flag**
   - Enable/disable flag globally
   - Adjust rollout percentage
   - Modify targeting rules
   - Schedule state changes

3. **Evaluate Feature Flag**
   - Check if flag is enabled for user/context
   - Apply rollout percentage logic
   - Evaluate targeting rules
   - Return variant for A/B tests

4. **Monitor Flag Usage**
   - Track flag evaluations
   - Monitor error rates when enabled
   - Analyze rollout impact
   - Alert on anomalies

5. **Manage Flag Lifecycle**
   - Archive old flags
   - Clean up fully-rolled-out features
   - Audit flag changes
   - Document flag purpose

---

## Domain Model

### 1. FeatureFlag (Aggregate Root)

Represents a configurable feature toggle.

**Location**: `domain/aggregate/FeatureFlag.java`

```java
public class FeatureFlag {

    private UUID id;
    private String key;                     // "new-scoring-engine"
    private String name;                    // "New Scoring Engine"
    private String description;

    // State
    private FlagStatus status;              // ACTIVE, DISABLED, ARCHIVED
    private boolean enabled;                // Global on/off
    private FlagType type;                  // BOOLEAN, PERCENTAGE, VARIANT

    // Rollout configuration
    private RolloutStrategy rolloutStrategy;
    private List<TargetingRule> targetingRules;
    private Integer rolloutPercentage;      // 0-100 for percentage rollout

    // Variants (for A/B testing)
    private List<FlagVariant> variants;
    private String defaultVariant;

    // Scheduling
    private Instant enableAt;               // Scheduled enable time
    private Instant disableAt;              // Scheduled disable time

    // Categorization
    private FlagCategory category;          // RELEASE, EXPERIMENT, OPS, PERMISSION
    private Set<String> tags;

    // Ownership
    private String owner;                   // Team or person responsible
    private String jiraTicket;              // Related ticket

    // Metadata
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String createdBy;
    private String lastModifiedBy;
    private Long version;

    // Business methods
    public boolean isEnabledFor(EvaluationContext context);
    public String getVariantFor(EvaluationContext context);
    public void enable();
    public void disable();
    public void setRolloutPercentage(int percentage);
    public void archive();
    public void addTargetingRule(TargetingRule rule);
}
```

**FlagStatus Enum**:
```java
public enum FlagStatus {
    ACTIVE("Flag is in use and can be toggled"),
    DISABLED("Flag is off and cannot be enabled"),
    ARCHIVED("Flag is deprecated and should be removed"),
    SCHEDULED("Flag has scheduled state change");

    private final String description;
}
```

**FlagType Enum**:
```java
public enum FlagType {
    BOOLEAN("Simple on/off toggle"),
    PERCENTAGE("Rollout to percentage of users"),
    VARIANT("A/B test with multiple variants"),
    PERMISSION("Role-based access control");

    private final String description;
}
```

**FlagCategory Enum**:
```java
public enum FlagCategory {
    RELEASE("Feature release flag"),
    EXPERIMENT("A/B test or experiment"),
    OPS("Operational toggle"),
    PERMISSION("Access control flag"),
    KILL_SWITCH("Emergency disable switch");

    private final String description;
}
```

### 2. RolloutStrategy (Value Object)

Defines how a flag is rolled out.

**Location**: `domain/model/RolloutStrategy.java`

```java
public class RolloutStrategy {

    private StrategyType type;
    private Integer percentage;             // For PERCENTAGE type
    private List<String> targetUserIds;     // For SPECIFIC_USERS type
    private List<String> targetLeagueIds;   // For SPECIFIC_LEAGUES type
    private List<String> targetRoles;       // For ROLE_BASED type

    // Gradual rollout
    private GradualRollout gradualRollout;

    // Ring-based deployment
    private List<RolloutRing> rings;

    // Stickiness (consistent user experience)
    private String stickinessAttribute;     // "userId", "sessionId", etc.
    private boolean sticky;

    // Factory methods
    public static RolloutStrategy allUsers();
    public static RolloutStrategy percentage(int percent);
    public static RolloutStrategy specificUsers(List<String> userIds);
    public static RolloutStrategy specificLeagues(List<String> leagueIds);
    public static RolloutStrategy roleBased(List<String> roles);
    public static RolloutStrategy gradual(int startPercent, int endPercent, Duration duration);
    public static RolloutStrategy rings(List<RolloutRing> rings);
}
```

**StrategyType Enum**:
```java
public enum StrategyType {
    ALL_USERS("Enabled for everyone"),
    NO_USERS("Disabled for everyone"),
    PERCENTAGE("Random percentage of users"),
    SPECIFIC_USERS("Specific user IDs"),
    SPECIFIC_LEAGUES("Specific league IDs"),
    ROLE_BASED("Based on user role"),
    ATTRIBUTE_BASED("Based on user attributes"),
    GRADUAL("Increasing percentage over time"),
    RING_BASED("Deployment rings"),
    CUSTOM("Custom evaluation logic");

    private final String description;
}
```

### 3. TargetingRule (Value Object)

Conditional logic for flag evaluation.

**Location**: `domain/model/TargetingRule.java`

```java
public class TargetingRule {

    private String name;
    private Integer priority;               // Lower = higher priority
    private boolean enabled;

    // Conditions
    private List<RuleCondition> conditions;
    private ConditionLogic logic;           // AND, OR

    // Result when matched
    private boolean enabledWhenMatched;
    private String variantWhenMatched;
    private Integer rolloutPercentage;      // Override percentage for this rule

    // Metadata
    private String description;

    // Evaluation
    public boolean matches(EvaluationContext context);
    public RuleResult evaluate(EvaluationContext context);

    // Factory methods
    public static TargetingRule forSuperAdmins();
    public static TargetingRule forBetaTesters();
    public static TargetingRule forInternalUsers();
    public static TargetingRule forPremiumLeagues();
}
```

**RuleCondition (Value Object)**:
```java
public class RuleCondition {

    private String attribute;               // "userId", "role", "email", "leagueId"
    private ConditionOperator operator;
    private Object value;

    // Factory methods
    public static RuleCondition userIdIn(List<String> ids);
    public static RuleCondition roleEquals(String role);
    public static RuleCondition emailEndsWith(String domain);
    public static RuleCondition attributeEquals(String attr, Object value);
    public static RuleCondition attributeContains(String attr, String value);
}
```

**ConditionOperator Enum**:
```java
public enum ConditionOperator {
    EQUALS,
    NOT_EQUALS,
    CONTAINS,
    NOT_CONTAINS,
    STARTS_WITH,
    ENDS_WITH,
    IN,
    NOT_IN,
    GREATER_THAN,
    LESS_THAN,
    MATCHES_REGEX,
    EXISTS,
    NOT_EXISTS
}
```

### 4. FlagVariant (Value Object)

A variant for A/B testing.

**Location**: `domain/model/FlagVariant.java`

```java
public class FlagVariant {

    private String key;                     // "control", "variant-a", "variant-b"
    private String name;                    // Display name
    private String description;
    private Integer weight;                 // Relative weight for distribution
    private Map<String, Object> payload;    // Additional configuration

    // Factory methods
    public static FlagVariant control();
    public static FlagVariant treatment(String key, int weight);
    public static FlagVariant withPayload(String key, Map<String, Object> payload);
}
```

### 5. EvaluationContext (Value Object)

Context for flag evaluation.

**Location**: `domain/model/EvaluationContext.java`

```java
public class EvaluationContext {

    private String userId;
    private String sessionId;
    private String email;
    private String role;                    // SUPER_ADMIN, ADMIN, PLAYER
    private String leagueId;
    private Map<String, Object> attributes;

    // Environment
    private String environment;             // dev, staging, prod
    private Instant evaluationTime;

    // Builder pattern
    public static EvaluationContextBuilder builder();

    // Factory methods
    public static EvaluationContext forUser(String userId);
    public static EvaluationContext forAnonymous();
    public static EvaluationContext forService(String serviceName);

    // Accessors
    public Object getAttribute(String key);
    public boolean hasAttribute(String key);
}
```

### 6. GradualRollout (Value Object)

Configuration for gradual percentage increase.

**Location**: `domain/model/GradualRollout.java`

```java
public class GradualRollout {

    private Integer startPercentage;        // Starting percentage
    private Integer endPercentage;          // Target percentage
    private Duration duration;              // Time to reach target
    private Instant startTime;

    // Ramp strategy
    private RampStrategy rampStrategy;      // LINEAR, EXPONENTIAL, STEP

    // Steps (for STEP strategy)
    private List<RolloutStep> steps;

    // Methods
    public int getCurrentPercentage(Instant now);
    public boolean isComplete(Instant now);
    public Duration getTimeRemaining(Instant now);

    // Factory methods
    public static GradualRollout linear(int start, int end, Duration duration);
    public static GradualRollout steps(List<RolloutStep> steps);
}
```

### 7. RolloutRing (Value Object)

Ring-based deployment configuration.

**Location**: `domain/model/RolloutRing.java`

```java
public class RolloutRing {

    private String name;                    // "canary", "beta", "ga"
    private Integer order;                  // Deployment order
    private RingCriteria criteria;          // Who's in this ring

    // Ring configuration
    private Integer percentage;             // Percentage within ring
    private boolean enabled;
    private Instant enabledAt;

    // Factory methods
    public static RolloutRing canary();     // 1% internal users
    public static RolloutRing beta();       // 10% beta testers
    public static RolloutRing earlyAccess(); // 25% opted-in users
    public static RolloutRing generalAvailability(); // 100% all users
}
```

### 8. FlagAuditEntry (Entity)

Audit log for flag changes.

**Location**: `domain/entity/FlagAuditEntry.java`

```java
public class FlagAuditEntry {

    private UUID id;
    private UUID flagId;
    private String flagKey;

    // Change details
    private AuditAction action;             // CREATED, UPDATED, ENABLED, DISABLED, ARCHIVED
    private String changedBy;
    private Instant changedAt;

    // Before/after state
    private Map<String, Object> previousState;
    private Map<String, Object> newState;
    private String changeReason;

    // Context
    private String ipAddress;
    private String userAgent;
}
```

**AuditAction Enum**:
```java
public enum AuditAction {
    CREATED,
    ENABLED,
    DISABLED,
    PERCENTAGE_CHANGED,
    TARGETING_UPDATED,
    VARIANT_ADDED,
    VARIANT_REMOVED,
    SCHEDULED,
    ARCHIVED,
    RESTORED
}
```

---

## Flag Evaluation Engine

### FeatureFlagService (Domain Service)

Core service for flag evaluation.

**Location**: `domain/service/FeatureFlagService.java`

```java
public class FeatureFlagService {

    private final FeatureFlagRepository flagRepository;
    private final FlagCache flagCache;
    private final FlagEvaluationMetrics metrics;

    /**
     * Evaluates if a flag is enabled for the given context.
     */
    public boolean isEnabled(String flagKey, EvaluationContext context) {
        FeatureFlag flag = getFlag(flagKey);

        if (flag == null || flag.getStatus() == FlagStatus.ARCHIVED) {
            metrics.recordMiss(flagKey);
            return false;
        }

        if (!flag.isEnabled()) {
            return false;
        }

        // Check targeting rules first (highest priority)
        for (TargetingRule rule : flag.getTargetingRules()) {
            if (rule.matches(context)) {
                return rule.isEnabledWhenMatched();
            }
        }

        // Apply rollout strategy
        return evaluateRollout(flag, context);
    }

    /**
     * Gets the variant for A/B testing.
     */
    public String getVariant(String flagKey, EvaluationContext context) {
        FeatureFlag flag = getFlag(flagKey);

        if (flag == null || !flag.isEnabled()) {
            return flag != null ? flag.getDefaultVariant() : null;
        }

        // Check targeting rules for variant
        for (TargetingRule rule : flag.getTargetingRules()) {
            if (rule.matches(context) && rule.getVariantWhenMatched() != null) {
                return rule.getVariantWhenMatched();
            }
        }

        // Consistent variant assignment based on stickiness
        return assignVariant(flag, context);
    }

    /**
     * Evaluates rollout based on strategy.
     */
    private boolean evaluateRollout(FeatureFlag flag, EvaluationContext context) {
        RolloutStrategy strategy = flag.getRolloutStrategy();

        switch (strategy.getType()) {
            case ALL_USERS:
                return true;
            case NO_USERS:
                return false;
            case PERCENTAGE:
                return evaluatePercentage(flag, context);
            case SPECIFIC_USERS:
                return strategy.getTargetUserIds().contains(context.getUserId());
            case SPECIFIC_LEAGUES:
                return strategy.getTargetLeagueIds().contains(context.getLeagueId());
            case ROLE_BASED:
                return strategy.getTargetRoles().contains(context.getRole());
            case GRADUAL:
                return evaluateGradual(flag, context);
            default:
                return false;
        }
    }

    /**
     * Percentage rollout with consistent hashing.
     */
    private boolean evaluatePercentage(FeatureFlag flag, EvaluationContext context) {
        String stickinessKey = getStickinessKey(flag, context);
        int bucket = consistentHash(stickinessKey, flag.getKey());
        return bucket < flag.getRolloutPercentage();
    }

    /**
     * Consistent hash for percentage rollout.
     */
    private int consistentHash(String stickinessKey, String flagKey) {
        String combined = stickinessKey + ":" + flagKey;
        int hash = MurmurHash3.hash32(combined.getBytes());
        return Math.abs(hash % 100);
    }
}
```

### FlagCache (Domain Service)

Caching layer for flag data.

**Location**: `domain/service/FlagCache.java`

```java
public interface FlagCache {

    /**
     * Gets flag from cache.
     */
    Optional<FeatureFlag> get(String flagKey);

    /**
     * Puts flag in cache.
     */
    void put(FeatureFlag flag);

    /**
     * Invalidates specific flag.
     */
    void invalidate(String flagKey);

    /**
     * Invalidates all flags.
     */
    void invalidateAll();

    /**
     * Refreshes cache from repository.
     */
    void refresh();
}
```

---

## Port Interfaces

### FeatureFlagRepository

**Location**: `domain/port/FeatureFlagRepository.java`

```java
public interface FeatureFlagRepository {

    // CRUD
    FeatureFlag save(FeatureFlag flag);
    Optional<FeatureFlag> findById(UUID id);
    Optional<FeatureFlag> findByKey(String key);
    List<FeatureFlag> findAll();
    void delete(UUID id);

    // Queries
    List<FeatureFlag> findByStatus(FlagStatus status);
    List<FeatureFlag> findByCategory(FlagCategory category);
    List<FeatureFlag> findByTag(String tag);
    List<FeatureFlag> findByOwner(String owner);
    List<FeatureFlag> findEnabled();
    List<FeatureFlag> findScheduled();

    // Audit
    void saveAuditEntry(FlagAuditEntry entry);
    List<FlagAuditEntry> findAuditEntries(UUID flagId);
    List<FlagAuditEntry> findRecentAuditEntries(int limit);
}
```

### FlagEvaluationMetrics

**Location**: `domain/port/FlagEvaluationMetrics.java`

```java
public interface FlagEvaluationMetrics {

    /**
     * Records a flag evaluation.
     */
    void recordEvaluation(String flagKey, boolean enabled, Duration duration);

    /**
     * Records a cache miss.
     */
    void recordMiss(String flagKey);

    /**
     * Records an evaluation error.
     */
    void recordError(String flagKey, Exception error);

    /**
     * Gets evaluation statistics.
     */
    FlagStatistics getStatistics(String flagKey);

    /**
     * Gets all flag statistics.
     */
    Map<String, FlagStatistics> getAllStatistics();
}
```

### FlagChangeNotifier

**Location**: `domain/port/FlagChangeNotifier.java`

```java
public interface FlagChangeNotifier {

    /**
     * Notifies listeners of flag change.
     */
    void notifyFlagChanged(FeatureFlag flag, AuditAction action);

    /**
     * Notifies of bulk refresh.
     */
    void notifyRefresh();

    /**
     * Registers a listener for flag changes.
     */
    void registerListener(FlagChangeListener listener);
}
```

---

## API Endpoints

### Admin Flag Management

```
POST   /api/v1/superadmin/flags
       Create new feature flag

GET    /api/v1/superadmin/flags
       List all feature flags

GET    /api/v1/superadmin/flags/{key}
       Get flag details

PUT    /api/v1/superadmin/flags/{key}
       Update feature flag

DELETE /api/v1/superadmin/flags/{key}
       Archive feature flag

POST   /api/v1/superadmin/flags/{key}/enable
       Enable flag

POST   /api/v1/superadmin/flags/{key}/disable
       Disable flag

PUT    /api/v1/superadmin/flags/{key}/rollout
       Update rollout percentage

PUT    /api/v1/superadmin/flags/{key}/targeting
       Update targeting rules

POST   /api/v1/superadmin/flags/{key}/schedule
       Schedule flag state change
```

### Flag Evaluation

```
GET    /api/v1/flags/{key}
       Evaluate flag for current user

POST   /api/v1/flags/evaluate
       Bulk evaluate multiple flags

GET    /api/v1/flags/{key}/variant
       Get variant for A/B test
```

### Audit and Metrics

```
GET    /api/v1/superadmin/flags/{key}/audit
       Get audit history for flag

GET    /api/v1/superadmin/flags/{key}/metrics
       Get evaluation metrics

GET    /api/v1/superadmin/flags/metrics/summary
       Get overall flag usage summary
```

---

## Client SDK

### Java SDK Usage

```java
@Component
public class FeatureFlagClient {

    private final FeatureFlagService flagService;

    /**
     * Check if feature is enabled.
     */
    public boolean isEnabled(String flagKey) {
        EvaluationContext context = getCurrentContext();
        return flagService.isEnabled(flagKey, context);
    }

    /**
     * Check with custom context.
     */
    public boolean isEnabled(String flagKey, EvaluationContext context) {
        return flagService.isEnabled(flagKey, context);
    }

    /**
     * Get variant for A/B test.
     */
    public String getVariant(String flagKey) {
        EvaluationContext context = getCurrentContext();
        return flagService.getVariant(flagKey, context);
    }

    /**
     * Execute if flag is enabled.
     */
    public <T> T ifEnabled(String flagKey, Supplier<T> enabled, Supplier<T> disabled) {
        return isEnabled(flagKey) ? enabled.get() : disabled.get();
    }
}
```

### Annotation-Based Usage

```java
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface FeatureFlag {
    String value();                         // Flag key
    String fallback() default "";           // Fallback method name
}

// Usage
@Service
public class ScoringService {

    @FeatureFlag("new-scoring-engine")
    public Score calculateScore(Roster roster) {
        // New implementation
        return newScoringEngine.calculate(roster);
    }

    public Score calculateScore_fallback(Roster roster) {
        // Old implementation
        return legacyScoringEngine.calculate(roster);
    }
}
```

---

## MongoDB Collections

### feature_flags Collection

```javascript
{
  _id: UUID,
  key: String,
  name: String,
  description: String,

  status: String,                         // ACTIVE, DISABLED, ARCHIVED
  enabled: Boolean,
  type: String,                           // BOOLEAN, PERCENTAGE, VARIANT

  rolloutStrategy: {
    type: String,
    percentage: Number,
    targetUserIds: [String],
    targetLeagueIds: [String],
    targetRoles: [String],
    stickinessAttribute: String,
    gradualRollout: {
      startPercentage: Number,
      endPercentage: Number,
      duration: String,
      startTime: ISODate,
      rampStrategy: String
    }
  },

  targetingRules: [{
    name: String,
    priority: Number,
    enabled: Boolean,
    conditions: [{
      attribute: String,
      operator: String,
      value: Mixed
    }],
    logic: String,
    enabledWhenMatched: Boolean,
    variantWhenMatched: String,
    rolloutPercentage: Number
  }],

  variants: [{
    key: String,
    name: String,
    description: String,
    weight: Number,
    payload: Object
  }],
  defaultVariant: String,

  enableAt: ISODate,
  disableAt: ISODate,

  category: String,
  tags: [String],
  owner: String,
  jiraTicket: String,

  createdAt: ISODate,
  updatedAt: ISODate,
  createdBy: String,
  lastModifiedBy: String,
  version: Long
}

// Indexes
db.feature_flags.createIndex({ key: 1 }, { unique: true })
db.feature_flags.createIndex({ status: 1 })
db.feature_flags.createIndex({ category: 1 })
db.feature_flags.createIndex({ tags: 1 })
db.feature_flags.createIndex({ owner: 1 })
db.feature_flags.createIndex({ enabled: 1 })
```

### flag_audit_entries Collection

```javascript
{
  _id: UUID,
  flagId: UUID,
  flagKey: String,

  action: String,
  changedBy: String,
  changedAt: ISODate,

  previousState: Object,
  newState: Object,
  changeReason: String,

  ipAddress: String,
  userAgent: String
}

// Indexes
db.flag_audit_entries.createIndex({ flagId: 1, changedAt: -1 })
db.flag_audit_entries.createIndex({ flagKey: 1 })
db.flag_audit_entries.createIndex({ changedBy: 1 })
db.flag_audit_entries.createIndex({ changedAt: -1 })
```

### flag_evaluations Collection (Time-series)

```javascript
{
  _id: UUID,
  flagKey: String,
  timestamp: ISODate,
  hour: ISODate,                          // Bucketed by hour

  evaluations: Number,
  enabledCount: Number,
  disabledCount: Number,
  errorCount: Number,
  avgDurationMs: Double,

  byVariant: {
    "control": Number,
    "variant-a": Number
  }
}

// Indexes
db.flag_evaluations.createIndex({ flagKey: 1, hour: -1 })
db.flag_evaluations.createIndex({ hour: -1 }, { expireAfterSeconds: 2592000 }) // 30 days
```

---

## Feature File

**Location**: `features/ffl-feature-flags.feature`

```gherkin
Feature: Admin Feature Flags
  As a system administrator
  I want to manage feature flags
  So that I can control feature rollouts and experiments

  Background:
    Given I am authenticated as a super admin

  # Flag Creation

  Scenario: Create boolean feature flag
    When I create a feature flag:
      | Key         | new-scoring-engine    |
      | Name        | New Scoring Engine    |
      | Type        | BOOLEAN               |
      | Category    | RELEASE               |
      | Enabled     | false                 |
    Then the flag is created with status "ACTIVE"
    And the flag is disabled by default
    And an audit entry is created

  Scenario: Create percentage rollout flag
    When I create a feature flag:
      | Key         | improved-ui           |
      | Type        | PERCENTAGE            |
      | Rollout     | 10%                   |
    Then the flag is created
    And approximately 10% of users will see the feature

  Scenario: Create A/B test flag
    When I create a feature flag:
      | Key          | checkout-flow-test   |
      | Type         | VARIANT              |
      | Variants     | control (50%), variant-a (50%) |
    Then the flag is created with two variants
    And users are consistently assigned to variants

  # Flag Toggling

  Scenario: Enable feature flag
    Given a feature flag "new-feature" exists and is disabled
    When I enable the flag
    Then the flag becomes enabled
    And an audit entry records the change
    And the cache is invalidated

  Scenario: Disable feature flag (kill switch)
    Given a feature flag "problematic-feature" is enabled at 100%
    When I disable the flag
    Then the flag is immediately disabled
    And all users stop seeing the feature
    And an alert is sent to the owner

  Scenario: Adjust rollout percentage
    Given a feature flag at 10% rollout
    When I increase rollout to 25%
    Then the rollout percentage updates
    And new users may start seeing the feature
    And existing enabled users remain enabled (sticky)

  # Targeting Rules

  Scenario: Enable for super admins only
    Given a feature flag "admin-dashboard-v2"
    When I add targeting rule:
      | Condition | role equals SUPER_ADMIN |
      | Result    | enabled                 |
    Then super admins see the feature
    And regular users do not

  Scenario: Enable for specific users
    Given a feature flag "beta-feature"
    When I add targeting rule for users:
      | user-123 |
      | user-456 |
    Then only those users see the feature

  Scenario: Enable for internal users
    Given a feature flag "internal-tools"
    When I add targeting rule:
      | Condition | email ends with @company.com |
      | Result    | enabled                       |
    Then internal users see the feature

  # Rollout Strategies

  Scenario: Gradual rollout over time
    Given a feature flag with gradual rollout:
      | Start     | 5%                |
      | End       | 100%              |
      | Duration  | 7 days            |
      | Strategy  | LINEAR            |
    When 3.5 days have passed
    Then rollout is approximately 52%

  Scenario: Ring-based deployment
    Given a feature flag with rings:
      | canary | 1%  | internal users    |
      | beta   | 10% | beta testers      |
      | ga     | 100%| all users         |
    When canary ring is enabled
    Then only internal users at 1% see feature
    When beta ring is enabled
    Then beta testers at 10% also see feature

  # Flag Evaluation

  Scenario: Evaluate flag for user
    Given a feature flag "new-feature" at 50% rollout
    When user "user-123" evaluates the flag
    Then result is consistently true or false
    And subsequent evaluations return same result (sticky)

  Scenario: Evaluate A/B variant
    Given an A/B test flag with variants:
      | control   | 50% |
      | variant-a | 50% |
    When user evaluates the flag
    Then a consistent variant is returned
    And variant is tracked for analytics

  Scenario: Evaluate with targeting rules
    Given a flag with rules:
      | Priority 1 | super_admin | enabled  |
      | Priority 2 | beta_tester | enabled  |
      | Default    | 10% rollout |          |
    When a super admin evaluates
    Then the flag is enabled (rule priority)
    When a regular user evaluates
    Then 10% rollout applies

  # Scheduling

  Scenario: Schedule flag enable
    Given a feature flag "holiday-theme"
    When I schedule enable at "2024-12-20 00:00 UTC"
    Then flag remains disabled now
    And flag auto-enables at scheduled time

  Scenario: Schedule flag disable
    Given a feature flag "limited-promotion"
    When I schedule disable at "2024-12-31 23:59 UTC"
    Then flag remains enabled now
    And flag auto-disables at scheduled time

  # Audit and Metrics

  Scenario: View flag audit history
    Given a feature flag with multiple changes
    When I view audit history
    Then I see all changes with:
      | Who made the change    |
      | What was changed       |
      | When it was changed    |
      | Previous and new state |

  Scenario: View evaluation metrics
    Given a feature flag with many evaluations
    When I view metrics
    Then I see:
      | Total evaluations |
      | Enabled count     |
      | Disabled count    |
      | Error rate        |
      | Avg eval time     |

  # Lifecycle Management

  Scenario: Archive old flag
    Given a feature flag that's been 100% for 30 days
    When I archive the flag
    Then flag status becomes ARCHIVED
    And flag evaluations return false
    And reminder to remove code is created

  Scenario: Clean up stale flags
    When I request stale flag report
    Then I see flags that are:
      | 100% enabled for > 30 days |
      | 0% for > 14 days           |
      | No evaluations in 7 days   |
```

---

## Files to Create

### Domain Layer
- `domain/aggregate/FeatureFlag.java`
- `domain/entity/FlagAuditEntry.java`
- `domain/model/FlagStatus.java`
- `domain/model/FlagType.java`
- `domain/model/FlagCategory.java`
- `domain/model/RolloutStrategy.java`
- `domain/model/StrategyType.java`
- `domain/model/TargetingRule.java`
- `domain/model/RuleCondition.java`
- `domain/model/ConditionOperator.java`
- `domain/model/FlagVariant.java`
- `domain/model/EvaluationContext.java`
- `domain/model/GradualRollout.java`
- `domain/model/RolloutRing.java`
- `domain/model/AuditAction.java`
- `domain/service/FeatureFlagService.java`
- `domain/service/FlagCache.java`
- `domain/port/FeatureFlagRepository.java`
- `domain/port/FlagEvaluationMetrics.java`
- `domain/port/FlagChangeNotifier.java`

### Application Layer
- `application/usecase/CreateFeatureFlagUseCase.java`
- `application/usecase/ToggleFlagUseCase.java`
- `application/usecase/UpdateRolloutUseCase.java`
- `application/usecase/EvaluateFlagUseCase.java`
- `application/usecase/ScheduleFlagUseCase.java`
- `application/usecase/ArchiveFlagUseCase.java`
- `application/dto/FeatureFlagDTO.java`
- `application/dto/FlagEvaluationDTO.java`
- `application/dto/FlagAuditDTO.java`

### Infrastructure Layer
- `infrastructure/adapter/rest/FeatureFlagController.java`
- `infrastructure/adapter/rest/FlagEvaluationController.java`
- `infrastructure/adapter/persistence/document/FeatureFlagDocument.java`
- `infrastructure/adapter/persistence/document/FlagAuditDocument.java`
- `infrastructure/adapter/persistence/FeatureFlagRepositoryImpl.java`
- `infrastructure/flags/InMemoryFlagCache.java`
- `infrastructure/flags/MurmurHash3.java`
- `infrastructure/flags/FeatureFlagAspect.java`
- `infrastructure/flags/FeatureFlagClient.java`
- `infrastructure/flags/FlagScheduler.java`

### Feature File
- `features/ffl-feature-flags.feature`

---

## Implementation Priority

### Phase 1: Core Flag Model
1. FeatureFlag aggregate and repository
2. FlagStatus, FlagType enums
3. Basic CRUD operations
4. Boolean flag evaluation

### Phase 2: Rollout Strategies
1. RolloutStrategy value object
2. Percentage rollout with consistent hashing
3. Specific user/league targeting
4. Role-based targeting

### Phase 3: Targeting Rules
1. TargetingRule value object
2. Rule conditions and operators
3. Rule evaluation logic
4. Priority handling

### Phase 4: Advanced Features
1. A/B testing variants
2. Gradual rollout
3. Ring-based deployment
4. Scheduling

### Phase 5: Operations
1. Audit logging
2. Metrics collection
3. Cache management
4. Client SDK and annotations

---

**Document Status**: Ready for Implementation
**Created**: 2025-12-29
**Ticket**: ANIMA-1050
