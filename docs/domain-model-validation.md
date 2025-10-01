# Domain Model Validation Rules

## League Aggregate - Configuration Immutability

### Business Rule: Configuration Lock After First Game Starts

**Rule**: ALL league configuration becomes IMMUTABLE once the first game of the league's starting NFL week begins.

**Lock Trigger**: The timestamp when the first scheduled NFL game of `league.startingWeek` kicks off.

**Rationale**: Ensures fairness by preventing mid-game rule changes that could advantage/disadvantage players after competition begins.

---

## League Domain Model

### Attributes

```java
public class League {
    private Long id;
    private String name;
    private String description;
    private Integer startingWeek;        // IMMUTABLE after lock
    private Integer numberOfWeeks;       // IMMUTABLE after lock
    private LeagueStatus status;
    private ScoringRules scoringRules;   // IMMUTABLE after lock
    private Boolean isPublic;            // IMMUTABLE after lock
    private Integer maxPlayers;          // IMMUTABLE after lock

    // NEW: Configuration lock tracking
    private Boolean configurationLocked; // true after first game starts
    private Instant lockTimestamp;       // when first game started
    private LockReason lockReason;       // FIRST_GAME_STARTED

    // Derived from data integration
    private Instant firstGameStartTime; // fetched from NFL schedule
}
```

### Validation Methods

#### `isConfigurationLocked(): boolean`

Determines if configuration is locked based on current time vs. first game start time.

```java
public boolean isConfigurationLocked() {
    if (this.firstGameStartTime == null) {
        return false; // no schedule loaded yet
    }
    return Instant.now().isAfter(this.firstGameStartTime);
}
```

#### `validateConfigurationMutable()`

Called before any configuration change. Throws `ConfigurationLockedException` if locked.

```java
public void validateConfigurationMutable() {
    if (isConfigurationLocked()) {
        throw new ConfigurationLockedException(
            "LEAGUE_STARTED_CONFIGURATION_LOCKED",
            "Configuration cannot be changed after first game starts at " + lockTimestamp
        );
    }
}
```

#### `updateName(String newName)`

```java
public void updateName(String newName) {
    validateConfigurationMutable(); // VALIDATION GUARD

    if (newName == null || newName.isBlank()) {
        throw new InvalidLeagueNameException();
    }

    this.name = newName;
}
```

#### `updateScoringRules(ScoringRules newRules)`

```java
public void updateScoringRules(ScoringRules newRules) {
    validateConfigurationMutable(); // VALIDATION GUARD

    if (newRules == null || !newRules.isValid()) {
        throw new InvalidScoringRulesException();
    }

    this.scoringRules = newRules;
}
```

#### `updateStartingWeek(Integer newStartingWeek)`

```java
public void updateStartingWeek(Integer newStartingWeek) {
    validateConfigurationMutable(); // VALIDATION GUARD

    if (newStartingWeek < 1 || newStartingWeek > 22) {
        throw new InvalidStartingWeekException();
    }

    // Additional validation
    if (newStartingWeek + this.numberOfWeeks - 1 > 22) {
        throw new LeagueExceedsNFLSeasonException();
    }

    this.startingWeek = newStartingWeek;
}
```

---

## Configuration Lock Lifecycle

### Phase 1: DRAFT (Before Activation)
- **Status**: `DRAFT`
- **Configuration Locked**: `false`
- **Actions Allowed**: All configuration changes

### Phase 2: ACTIVE (After Activation, Before First Game)
- **Status**: `ACTIVE`
- **Configuration Locked**: `false`
- **Actions Allowed**: All configuration changes
- **Note**: Admin has window between activation and first game kickoff to make final adjustments

### Phase 3: STARTED (First Game Kicks Off)
- **Status**: `ACTIVE`
- **Configuration Locked**: `true` (automatically set when `Instant.now() > firstGameStartTime`)
- **Lock Timestamp**: Set to `firstGameStartTime`
- **Actions Allowed**: NO configuration changes whatsoever
- **Lock Duration**: Permanent for the lifetime of the league

### Phase 4: COMPLETED/ARCHIVED
- **Configuration Locked**: `true` (remains locked)
- **Actions Allowed**: None (league is read-only)

---

## Immutable Configuration Fields

Once `configurationLocked = true`, the following fields CANNOT be modified:

### Core Configuration
- ✅ `startingWeek`
- ✅ `numberOfWeeks`
- ✅ `name`
- ✅ `description`

### Scoring Rules
- ✅ `scoringRules.pprRules` (passing/rushing/receiving yards, receptions, TDs)
- ✅ `scoringRules.fieldGoalRules` (points by distance)
- ✅ `scoringRules.defensiveRules` (sacks, INTs, fumbles, TDs)
- ✅ `scoringRules.pointsAllowedTiers`
- ✅ `scoringRules.yardsAllowedTiers`

### League Settings
- ✅ `isPublic` (privacy settings)
- ✅ `maxPlayers`
- ✅ All `pickDeadlines` for all weeks

### Elimination Settings
- ✅ Elimination mode (e.g., "team loses = zero points")
- ✅ Any elimination-related configuration

---

## Domain Events

### `LeagueConfigurationLockedEvent`

Triggered when configuration lock occurs (first game starts).

```java
public class LeagueConfigurationLockedEvent {
    private Long leagueId;
    private Instant lockTimestamp;
    private LockReason reason; // FIRST_GAME_STARTED
    private Integer nflWeekNumber;
}
```

**Event Handlers**:
1. Notify admin via email/notification
2. Create audit log entry
3. Update league status display
4. Disable configuration UI elements

---

## Validation Error Handling

### Exception: `ConfigurationLockedException`

```java
public class ConfigurationLockedException extends DomainException {
    private String errorCode = "LEAGUE_STARTED_CONFIGURATION_LOCKED";
    private Instant lockTimestamp;
    private String message;

    public ConfigurationLockedException(String code, String message) {
        super(code, message);
        this.lockTimestamp = lockTimestamp;
    }
}
```

**HTTP Response**:
```json
{
  "error": "LEAGUE_STARTED_CONFIGURATION_LOCKED",
  "message": "Configuration cannot be changed after first game starts",
  "lockTimestamp": "2024-12-15T13:00:00Z",
  "lockReason": "FIRST_GAME_STARTED",
  "nflWeek": 15
}
```

**Status Code**: `400 Bad Request` or `409 Conflict`

---

## Integration with NFL Data Service

### Fetching First Game Start Time

When league is activated, the system must:

1. Query NFL schedule API for league's `startingWeek`
2. Find earliest game kickoff time for that NFL week
3. Set `league.firstGameStartTime = <earliest-kickoff>`
4. Store timestamp in League aggregate

**Example**:
```java
// Application Service
public void activateLeague(Long leagueId) {
    League league = leagueRepository.findById(leagueId);

    // Fetch first game time from NFL schedule
    Instant firstGameStart = nflScheduleService
        .getFirstGameKickoffTime(league.getStartingWeek());

    league.setFirstGameStartTime(firstGameStart);
    league.activate();

    leagueRepository.save(league);
}
```

---

## Repository Method

### `findLeaguesNeedingConfigurationLock()`

Background job queries leagues where:
- `status = ACTIVE`
- `configurationLocked = false`
- `firstGameStartTime < NOW()`

Automatically sets `configurationLocked = true` and publishes domain event.

---

## Admin Warning System

### Pre-Lock Warning Notification

When admin accesses league configuration page:

**If** `firstGameStartTime - NOW() < 24 hours`:
- Display prominent warning banner
- Show countdown timer
- Highlight that ALL changes will be locked soon

**If** `configurationLocked = true`:
- Display read-only view
- Show lock icon on all fields
- Display message: "Configuration locked since [timestamp]"

---

## Audit Logging

### All configuration change attempts must be logged:

**Before Lock**:
```
Action: CONFIG_UPDATED
Field: scoringRules.pprRules.receptionPoints
OldValue: 1
NewValue: 1.5
AdminId: 123
LeagueId: 456
Timestamp: 2024-12-15T10:00:00Z
Status: SUCCESS
```

**After Lock**:
```
Action: CONFIG_UPDATE_REJECTED
Field: scoringRules.pprRules.receptionPoints
AttemptedNewValue: 1.5
AdminId: 123
LeagueId: 456
Timestamp: 2024-12-15T14:00:00Z
Status: REJECTED
Reason: LEAGUE_STARTED_CONFIGURATION_LOCKED
LockTimestamp: 2024-12-15T13:00:00Z
```

---

## Testing Validation Rules

### Unit Test: Configuration Lock After First Game

```java
@Test
public void shouldRejectConfigurationChangeAfterFirstGameStarts() {
    // Arrange
    League league = new League();
    league.setStartingWeek(15);
    league.setFirstGameStartTime(Instant.parse("2024-12-15T18:00:00Z")); // 1PM ET

    // Act - simulate time after first game starts
    Clock.fixed(Instant.parse("2024-12-15T18:01:00Z"));

    // Assert
    assertTrue(league.isConfigurationLocked());

    assertThrows(ConfigurationLockedException.class, () -> {
        league.updateName("New Name");
    });
}
```

### Integration Test: Lock Prevents All Modifications

```java
@Test
public void shouldRejectAllConfigurationChangesAfterLock() {
    League league = createLockedLeague(); // first game already started

    // All these should throw ConfigurationLockedException
    assertThrows(ConfigurationLockedException.class,
        () -> league.updateName("New Name"));
    assertThrows(ConfigurationLockedException.class,
        () -> league.updateDescription("New Description"));
    assertThrows(ConfigurationLockedException.class,
        () -> league.updateStartingWeek(16));
    assertThrows(ConfigurationLockedException.class,
        () -> league.updateNumberOfWeeks(5));
    assertThrows(ConfigurationLockedException.class,
        () -> league.updateScoringRules(newRules));
    assertThrows(ConfigurationLockedException.class,
        () -> league.setPublic(false));
    assertThrows(ConfigurationLockedException.class,
        () -> league.updateMaxPlayers(50));
}
```

---

## Summary

**Key Points**:
1. ✅ Configuration lock based on **NFL game start time**, not league activation
2. ✅ **ALL** fields become immutable (not just critical ones)
3. ✅ Validation in domain model via `validateConfigurationMutable()` guard
4. ✅ Domain event published when lock occurs
5. ✅ Audit logging for all attempts (successful and rejected)
6. ✅ Admin warnings before lock occurs
7. ✅ HTTP 400/409 error responses with clear messaging
8. ✅ Background job enforces lock if missed by real-time checks
