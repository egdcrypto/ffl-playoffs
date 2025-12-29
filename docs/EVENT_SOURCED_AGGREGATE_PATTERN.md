# Event-Sourced Aggregate Pattern Template

> **ANIMA-1159**: Design and documentation for DDD Event-Sourced Aggregate Pattern

## Overview

This document provides a comprehensive template for implementing event-sourced aggregates in the FFL Playoffs domain model. The pattern enables:

- **Full Audit Trail**: Every state change is captured as an immutable event
- **Temporal Queries**: Reconstruct aggregate state at any point in time
- **Event-Driven Architecture**: Enable reactive downstream processing
- **Debugging**: Complete history for troubleshooting

---

## Current State Analysis

### Existing Aggregate Pattern
Current aggregates (League, User, Roster, etc.) are traditional state-based:
- State stored directly in entity fields
- No event history
- State mutations via setter methods
- No built-in audit trail

### Existing Domain Events
Only 2 events exist (`GameCreatedEvent`, `TeamEliminatedEvent`):
- Simple Lombok-based POJOs
- No event metadata (correlation ID, causation ID, version)
- No event store infrastructure
- Published ad-hoc, not integrated into aggregate lifecycle

---

## Event-Sourced Aggregate Pattern

### Core Concepts

1. **Event Sourcing**: Aggregate state is derived from a sequence of events
2. **Event Store**: Append-only log of domain events per aggregate
3. **Event Application**: Events are applied to rebuild current state
4. **Command Handling**: Commands produce events (not direct state changes)

### Pattern Flow
```
Command → Aggregate.handle(command) → Event(s) → EventStore.append()
                                         ↓
                                    Apply to state
                                         ↓
                                    Publish to bus
```

---

## Template Components

### 1. DomainEvent Base Class

**Location**: `domain/event/DomainEvent.java`

```java
package com.ffl.playoffs.domain.event;

import java.time.Instant;
import java.util.UUID;

/**
 * Base class for all domain events.
 * Provides event metadata for tracking, correlation, and versioning.
 */
public abstract class DomainEvent {

    // Event identity
    private final UUID eventId;
    private final Instant occurredAt;
    private final long version;

    // Aggregate reference
    private final UUID aggregateId;
    private final String aggregateType;

    // Correlation for event chains
    private UUID correlationId;
    private UUID causationId;

    // Actor who triggered the event
    private UUID actorId;
    private String actorType; // USER, SYSTEM, PAT

    protected DomainEvent(UUID aggregateId, String aggregateType, long version) {
        this.eventId = UUID.randomUUID();
        this.occurredAt = Instant.now();
        this.aggregateId = aggregateId;
        this.aggregateType = aggregateType;
        this.version = version;
    }

    // Abstract methods for event type identification
    public abstract String getEventType();

    // Getters
    public UUID getEventId() { return eventId; }
    public Instant getOccurredAt() { return occurredAt; }
    public long getVersion() { return version; }
    public UUID getAggregateId() { return aggregateId; }
    public String getAggregateType() { return aggregateType; }
    public UUID getCorrelationId() { return correlationId; }
    public UUID getCausationId() { return causationId; }
    public UUID getActorId() { return actorId; }
    public String getActorType() { return actorType; }

    // Fluent setters for correlation
    public DomainEvent withCorrelationId(UUID correlationId) {
        this.correlationId = correlationId;
        return this;
    }

    public DomainEvent withCausation(UUID causationId) {
        this.causationId = causationId;
        return this;
    }

    public DomainEvent withActor(UUID actorId, String actorType) {
        this.actorId = actorId;
        this.actorType = actorType;
        return this;
    }
}
```

### 2. EventSourcedAggregate Base Class

**Location**: `domain/aggregate/EventSourcedAggregate.java`

```java
package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.event.DomainEvent;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

/**
 * Base class for event-sourced aggregates.
 *
 * Provides:
 * - Uncommitted event collection
 * - Version tracking for optimistic concurrency
 * - Event application mechanism
 * - State reconstruction from event history
 */
public abstract class EventSourcedAggregate {

    private final UUID id;
    private long version;
    private final List<DomainEvent> uncommittedEvents;

    protected EventSourcedAggregate() {
        this.id = UUID.randomUUID();
        this.version = 0;
        this.uncommittedEvents = new ArrayList<>();
    }

    protected EventSourcedAggregate(UUID id) {
        this.id = id;
        this.version = 0;
        this.uncommittedEvents = new ArrayList<>();
    }

    // ==================== Event Application ====================

    /**
     * Applies an event to update aggregate state.
     * Called during replay and when handling new commands.
     *
     * @param event The domain event to apply
     */
    protected abstract void apply(DomainEvent event);

    /**
     * Raises a new event: increments version, applies it, and adds to uncommitted.
     * Use this method in command handlers.
     *
     * @param event The event to raise
     */
    protected void raiseEvent(DomainEvent event) {
        this.version++;
        apply(event);
        uncommittedEvents.add(event);
    }

    /**
     * Replays an event from history.
     * Used during aggregate reconstruction. Does NOT add to uncommitted.
     *
     * @param event The historical event to replay
     */
    protected void replayEvent(DomainEvent event) {
        apply(event);
        this.version = event.getVersion();
    }

    /**
     * Reconstructs aggregate state from event history.
     *
     * @param events The ordered list of historical events
     */
    public void loadFromHistory(List<DomainEvent> events) {
        for (DomainEvent event : events) {
            replayEvent(event);
        }
    }

    // ==================== Uncommitted Events ====================

    /**
     * Returns uncommitted events for persistence.
     * Called by repository after command handling.
     *
     * @return Immutable list of uncommitted events
     */
    public List<DomainEvent> getUncommittedEvents() {
        return Collections.unmodifiableList(uncommittedEvents);
    }

    /**
     * Clears uncommitted events after successful persistence.
     * Called by repository after saving to event store.
     */
    public void markEventsAsCommitted() {
        uncommittedEvents.clear();
    }

    // ==================== Identity and Version ====================

    public UUID getId() {
        return id;
    }

    public long getVersion() {
        return version;
    }

    /**
     * Returns the aggregate type name for event metadata.
     */
    public abstract String getAggregateType();
}
```

### 3. Event Store Interface

**Location**: `domain/port/EventStore.java`

```java
package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.event.DomainEvent;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Port interface for event store operations.
 * Append-only storage for domain events.
 */
public interface EventStore {

    /**
     * Appends events to the event store.
     * Implements optimistic concurrency via expected version.
     *
     * @param aggregateId The aggregate identifier
     * @param aggregateType The aggregate type name
     * @param events The events to append
     * @param expectedVersion The expected current version (for optimistic locking)
     * @throws ConcurrencyException if expectedVersion doesn't match
     */
    void append(UUID aggregateId, String aggregateType,
                List<DomainEvent> events, long expectedVersion);

    /**
     * Loads all events for an aggregate.
     *
     * @param aggregateId The aggregate identifier
     * @return Ordered list of events (oldest first)
     */
    List<DomainEvent> loadEvents(UUID aggregateId);

    /**
     * Loads events for an aggregate starting from a specific version.
     *
     * @param aggregateId The aggregate identifier
     * @param fromVersion The version to start from (exclusive)
     * @return Ordered list of events after the specified version
     */
    List<DomainEvent> loadEventsFromVersion(UUID aggregateId, long fromVersion);

    /**
     * Loads events for an aggregate up to a specific point in time.
     * Enables temporal queries.
     *
     * @param aggregateId The aggregate identifier
     * @param asOf The point in time to query up to
     * @return Events that occurred before the specified time
     */
    List<DomainEvent> loadEventsAsOf(UUID aggregateId, Instant asOf);

    /**
     * Gets the current version of an aggregate.
     *
     * @param aggregateId The aggregate identifier
     * @return The current version, or empty if aggregate doesn't exist
     */
    Optional<Long> getCurrentVersion(UUID aggregateId);

    /**
     * Exception thrown when optimistic concurrency check fails.
     */
    class ConcurrencyException extends RuntimeException {
        private final UUID aggregateId;
        private final long expectedVersion;
        private final long actualVersion;

        public ConcurrencyException(UUID aggregateId, long expected, long actual) {
            super(String.format(
                "Concurrency conflict for aggregate %s. Expected version %d, actual %d",
                aggregateId, expected, actual
            ));
            this.aggregateId = aggregateId;
            this.expectedVersion = expected;
            this.actualVersion = actual;
        }

        public UUID getAggregateId() { return aggregateId; }
        public long getExpectedVersion() { return expectedVersion; }
        public long getActualVersion() { return actualVersion; }
    }
}
```

### 4. Event Publisher Interface

**Location**: `domain/port/EventPublisher.java`

```java
package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.event.DomainEvent;

import java.util.List;

/**
 * Port interface for publishing domain events.
 * Enables event-driven architecture patterns.
 */
public interface EventPublisher {

    /**
     * Publishes a single event.
     *
     * @param event The event to publish
     */
    void publish(DomainEvent event);

    /**
     * Publishes multiple events in order.
     *
     * @param events The events to publish
     */
    void publishAll(List<DomainEvent> events);
}
```

### 5. Event-Sourced Repository Base

**Location**: `domain/port/EventSourcedRepository.java`

```java
package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.EventSourcedAggregate;
import com.ffl.playoffs.domain.event.DomainEvent;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Base interface for event-sourced aggregate repositories.
 *
 * @param <T> The aggregate type
 */
public interface EventSourcedRepository<T extends EventSourcedAggregate> {

    /**
     * Saves an aggregate by appending its uncommitted events.
     *
     * @param aggregate The aggregate to save
     */
    void save(T aggregate);

    /**
     * Loads an aggregate by ID, reconstructing from event history.
     *
     * @param id The aggregate identifier
     * @return The reconstructed aggregate, or empty if not found
     */
    Optional<T> findById(UUID id);

    /**
     * Loads an aggregate as it existed at a specific point in time.
     *
     * @param id The aggregate identifier
     * @param asOf The point in time to reconstruct
     * @return The aggregate state at that time
     */
    Optional<T> findByIdAsOf(UUID id, Instant asOf);

    /**
     * Gets the event history for an aggregate.
     *
     * @param id The aggregate identifier
     * @return The list of all events for the aggregate
     */
    List<DomainEvent> getEventHistory(UUID id);
}
```

---

## Example: Event-Sourced League Aggregate

### League Domain Events

**Location**: `domain/event/league/`

```java
// LeagueCreatedEvent.java
public class LeagueCreatedEvent extends DomainEvent {
    private final String name;
    private final String code;
    private final UUID ownerId;
    private final Integer startingWeek;
    private final Integer numberOfWeeks;

    public LeagueCreatedEvent(UUID aggregateId, long version,
                              String name, String code, UUID ownerId,
                              Integer startingWeek, Integer numberOfWeeks) {
        super(aggregateId, "League", version);
        this.name = name;
        this.code = code;
        this.ownerId = ownerId;
        this.startingWeek = startingWeek;
        this.numberOfWeeks = numberOfWeeks;
    }

    @Override
    public String getEventType() {
        return "LeagueCreatedEvent";
    }

    // Getters...
}

// LeagueStartedEvent.java
public class LeagueStartedEvent extends DomainEvent {
    public LeagueStartedEvent(UUID aggregateId, long version) {
        super(aggregateId, "League", version);
    }

    @Override
    public String getEventType() {
        return "LeagueStartedEvent";
    }
}

// LeagueConfigurationLockedEvent.java
public class LeagueConfigurationLockedEvent extends DomainEvent {
    private final Instant lockedAt;
    private final String reason;

    public LeagueConfigurationLockedEvent(UUID aggregateId, long version,
                                          Instant lockedAt, String reason) {
        super(aggregateId, "League", version);
        this.lockedAt = lockedAt;
        this.reason = reason;
    }

    @Override
    public String getEventType() {
        return "LeagueConfigurationLockedEvent";
    }

    // Getters...
}

// PlayerAddedToLeagueEvent.java
public class PlayerAddedToLeagueEvent extends DomainEvent {
    private final UUID playerId;
    private final String playerEmail;

    public PlayerAddedToLeagueEvent(UUID aggregateId, long version,
                                    UUID playerId, String playerEmail) {
        super(aggregateId, "League", version);
        this.playerId = playerId;
        this.playerEmail = playerEmail;
    }

    @Override
    public String getEventType() {
        return "PlayerAddedToLeagueEvent";
    }

    // Getters...
}

// LeagueWeekAdvancedEvent.java
public class LeagueWeekAdvancedEvent extends DomainEvent {
    private final Integer previousWeek;
    private final Integer newWeek;

    public LeagueWeekAdvancedEvent(UUID aggregateId, long version,
                                   Integer previousWeek, Integer newWeek) {
        super(aggregateId, "League", version);
        this.previousWeek = previousWeek;
        this.newWeek = newWeek;
    }

    @Override
    public String getEventType() {
        return "LeagueWeekAdvancedEvent";
    }

    // Getters...
}

// LeagueCompletedEvent.java
public class LeagueCompletedEvent extends DomainEvent {
    private final UUID winnerId;
    private final Instant completedAt;

    public LeagueCompletedEvent(UUID aggregateId, long version,
                                UUID winnerId) {
        super(aggregateId, "League", version);
        this.winnerId = winnerId;
        this.completedAt = Instant.now();
    }

    @Override
    public String getEventType() {
        return "LeagueCompletedEvent";
    }

    // Getters...
}
```

### Event-Sourced League Aggregate

```java
package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.event.DomainEvent;
import com.ffl.playoffs.domain.event.league.*;
import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.model.RosterConfiguration;
import com.ffl.playoffs.domain.model.ScoringRules;

import java.time.Instant;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Event-sourced League aggregate.
 * All state changes produce domain events.
 */
public class EventSourcedLeague extends EventSourcedAggregate {

    // State (derived from events)
    private String name;
    private String code;
    private UUID ownerId;
    private LeagueStatus status;
    private Integer startingWeek;
    private Integer numberOfWeeks;
    private Integer currentWeek;
    private boolean configurationLocked;
    private Instant configurationLockedAt;
    private String lockReason;
    private List<Player> players;
    private RosterConfiguration rosterConfiguration;
    private ScoringRules scoringRules;

    // ==================== Factory Methods ====================

    /**
     * Creates a new league (factory method).
     * Raises LeagueCreatedEvent.
     */
    public static EventSourcedLeague create(String name, String code, UUID ownerId,
                                            Integer startingWeek, Integer numberOfWeeks) {
        // Validate inputs
        validateWeekConfiguration(startingWeek, numberOfWeeks);

        EventSourcedLeague league = new EventSourcedLeague();
        league.raiseEvent(new LeagueCreatedEvent(
            league.getId(),
            league.getVersion() + 1,
            name, code, ownerId, startingWeek, numberOfWeeks
        ));
        return league;
    }

    private EventSourcedLeague() {
        super();
        this.players = new ArrayList<>();
        this.status = LeagueStatus.CREATED;
        this.configurationLocked = false;
    }

    // For reconstruction
    public EventSourcedLeague(UUID id) {
        super(id);
        this.players = new ArrayList<>();
    }

    // ==================== Command Handlers ====================

    /**
     * Adds a player to the league.
     * Raises PlayerAddedToLeagueEvent.
     */
    public void addPlayer(UUID playerId, String playerEmail) {
        if (this.status != LeagueStatus.CREATED &&
            this.status != LeagueStatus.WAITING_FOR_PLAYERS) {
            throw new IllegalStateException("Cannot add players to a league that has started");
        }

        raiseEvent(new PlayerAddedToLeagueEvent(
            getId(), getVersion() + 1, playerId, playerEmail
        ));
    }

    /**
     * Starts the league.
     * Raises LeagueStartedEvent.
     */
    public void start() {
        if (this.status != LeagueStatus.WAITING_FOR_PLAYERS &&
            this.status != LeagueStatus.CREATED) {
            throw new IllegalStateException("League cannot be started in current status: " + this.status);
        }
        if (this.players.size() < 2) {
            throw new IllegalStateException("League requires at least 2 players to start");
        }
        if (this.rosterConfiguration == null) {
            throw new IllegalStateException("League requires roster configuration to start");
        }

        raiseEvent(new LeagueStartedEvent(getId(), getVersion() + 1));
    }

    /**
     * Locks the league configuration.
     * Raises LeagueConfigurationLockedEvent.
     */
    public void lockConfiguration(String reason) {
        if (this.configurationLocked) {
            return; // Already locked, idempotent
        }

        raiseEvent(new LeagueConfigurationLockedEvent(
            getId(), getVersion() + 1, Instant.now(), reason
        ));
    }

    /**
     * Advances to the next week.
     * Raises LeagueWeekAdvancedEvent or LeagueCompletedEvent.
     */
    public void advanceWeek() {
        if (this.status != LeagueStatus.ACTIVE) {
            throw new IllegalStateException("Can only advance week for active leagues");
        }

        int endWeek = this.startingWeek + this.numberOfWeeks - 1;
        if (this.currentWeek >= endWeek) {
            // Complete the league
            UUID winnerId = determineWinner();
            raiseEvent(new LeagueCompletedEvent(getId(), getVersion() + 1, winnerId));
        } else {
            raiseEvent(new LeagueWeekAdvancedEvent(
                getId(), getVersion() + 1, this.currentWeek, this.currentWeek + 1
            ));
        }
    }

    // ==================== Event Application ====================

    @Override
    protected void apply(DomainEvent event) {
        if (event instanceof LeagueCreatedEvent e) {
            this.name = e.getName();
            this.code = e.getCode();
            this.ownerId = e.getOwnerId();
            this.startingWeek = e.getStartingWeek();
            this.numberOfWeeks = e.getNumberOfWeeks();
            this.currentWeek = e.getStartingWeek();
            this.status = LeagueStatus.CREATED;
        } else if (event instanceof PlayerAddedToLeagueEvent e) {
            Player player = new Player();
            player.setId(e.getPlayerId());
            player.setEmail(e.getPlayerEmail());
            this.players.add(player);
        } else if (event instanceof LeagueStartedEvent) {
            this.status = LeagueStatus.ACTIVE;
        } else if (event instanceof LeagueConfigurationLockedEvent e) {
            this.configurationLocked = true;
            this.configurationLockedAt = e.getLockedAt();
            this.lockReason = e.getReason();
        } else if (event instanceof LeagueWeekAdvancedEvent e) {
            this.currentWeek = e.getNewWeek();
        } else if (event instanceof LeagueCompletedEvent) {
            this.status = LeagueStatus.COMPLETED;
        }
    }

    @Override
    public String getAggregateType() {
        return "League";
    }

    // ==================== Private Helpers ====================

    private static void validateWeekConfiguration(Integer startingWeek, Integer numberOfWeeks) {
        if (startingWeek == null || numberOfWeeks == null) {
            throw new IllegalArgumentException("Starting week and number of weeks cannot be null");
        }
        if (startingWeek < 1 || startingWeek > 22) {
            throw new IllegalArgumentException("Starting week must be between 1 and 22");
        }
        if (numberOfWeeks < 1 || numberOfWeeks > 17) {
            throw new IllegalArgumentException("Number of weeks must be between 1 and 17");
        }
        int endWeek = startingWeek + numberOfWeeks - 1;
        if (endWeek > 22) {
            throw new IllegalArgumentException("League duration exceeds NFL calendar");
        }
    }

    private UUID determineWinner() {
        // Business logic to determine winner
        // Placeholder - would query scores
        return players.isEmpty() ? null : players.get(0).getId();
    }

    // ==================== Query Methods (Getters) ====================

    public String getName() { return name; }
    public String getCode() { return code; }
    public UUID getOwnerId() { return ownerId; }
    public LeagueStatus getStatus() { return status; }
    public Integer getCurrentWeek() { return currentWeek; }
    public boolean isConfigurationLocked() { return configurationLocked; }
    public List<Player> getPlayers() { return new ArrayList<>(players); }

    public enum LeagueStatus {
        CREATED, WAITING_FOR_PLAYERS, ACTIVE, COMPLETED, CANCELLED
    }
}
```

---

## MongoDB Event Store Implementation

**Location**: `infrastructure/adapter/persistence/MongoEventStore.java`

```java
package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.event.DomainEvent;
import com.ffl.playoffs.domain.port.EventStore;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * MongoDB implementation of EventStore.
 *
 * Collection: events
 * Document structure:
 * {
 *   _id: ObjectId,
 *   eventId: UUID,
 *   eventType: String,
 *   aggregateId: UUID,
 *   aggregateType: String,
 *   version: Long,
 *   occurredAt: ISODate,
 *   correlationId: UUID,
 *   causationId: UUID,
 *   actorId: UUID,
 *   actorType: String,
 *   payload: Object (event-specific data)
 * }
 *
 * Indexes:
 * - { aggregateId: 1, version: 1 } unique
 * - { aggregateId: 1, occurredAt: 1 }
 * - { eventType: 1, occurredAt: 1 }
 * - { correlationId: 1 }
 */
@Repository
public class MongoEventStore implements EventStore {

    private final MongoTemplate mongoTemplate;
    private static final String COLLECTION = "events";

    public MongoEventStore(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    @Override
    public void append(UUID aggregateId, String aggregateType,
                       List<DomainEvent> events, long expectedVersion) {
        // Check current version for optimistic locking
        Optional<Long> currentVersion = getCurrentVersion(aggregateId);
        long actualVersion = currentVersion.orElse(0L);

        if (actualVersion != expectedVersion) {
            throw new ConcurrencyException(aggregateId, expectedVersion, actualVersion);
        }

        // Convert and insert events
        for (DomainEvent event : events) {
            EventDocument doc = EventDocument.fromDomainEvent(event);
            mongoTemplate.insert(doc, COLLECTION);
        }
    }

    @Override
    public List<DomainEvent> loadEvents(UUID aggregateId) {
        Query query = Query.query(
            Criteria.where("aggregateId").is(aggregateId)
        ).with(org.springframework.data.domain.Sort.by("version"));

        return mongoTemplate.find(query, EventDocument.class, COLLECTION)
            .stream()
            .map(EventDocument::toDomainEvent)
            .toList();
    }

    @Override
    public List<DomainEvent> loadEventsFromVersion(UUID aggregateId, long fromVersion) {
        Query query = Query.query(
            Criteria.where("aggregateId").is(aggregateId)
                    .and("version").gt(fromVersion)
        ).with(org.springframework.data.domain.Sort.by("version"));

        return mongoTemplate.find(query, EventDocument.class, COLLECTION)
            .stream()
            .map(EventDocument::toDomainEvent)
            .toList();
    }

    @Override
    public List<DomainEvent> loadEventsAsOf(UUID aggregateId, Instant asOf) {
        Query query = Query.query(
            Criteria.where("aggregateId").is(aggregateId)
                    .and("occurredAt").lte(asOf)
        ).with(org.springframework.data.domain.Sort.by("version"));

        return mongoTemplate.find(query, EventDocument.class, COLLECTION)
            .stream()
            .map(EventDocument::toDomainEvent)
            .toList();
    }

    @Override
    public Optional<Long> getCurrentVersion(UUID aggregateId) {
        Query query = Query.query(
            Criteria.where("aggregateId").is(aggregateId)
        ).with(org.springframework.data.domain.Sort.by("version").descending())
         .limit(1);

        EventDocument latest = mongoTemplate.findOne(query, EventDocument.class, COLLECTION);
        return Optional.ofNullable(latest).map(EventDocument::getVersion);
    }
}
```

---

## Event Document Schema

```java
// EventDocument.java
@Document(collection = "events")
public class EventDocument {
    @Id
    private String id;
    private UUID eventId;
    private String eventType;
    private UUID aggregateId;
    private String aggregateType;
    private long version;
    private Instant occurredAt;
    private UUID correlationId;
    private UUID causationId;
    private UUID actorId;
    private String actorType;
    private Map<String, Object> payload;

    // Conversion methods...
}
```

---

## Migration Strategy

### Phase 1: Add Event Infrastructure (Non-Breaking)
1. Create `DomainEvent` base class
2. Create `EventStore` and `EventPublisher` interfaces
3. Implement MongoDB event store
4. Add event publishing after existing repository saves

### Phase 2: Dual-Write Mode
1. Create event-sourced versions of aggregates
2. Existing state-based saves continue working
3. Events are also written for new operations
4. Read still from state, verify against events

### Phase 3: Event-First Mode
1. Switch to event-sourced repositories
2. State derived from events
3. Optionally maintain read projections
4. Remove direct state persistence

---

## Recommended League Events Catalog

| Event | Trigger | Data |
|-------|---------|------|
| `LeagueCreatedEvent` | New league | name, code, ownerId, weeks |
| `LeagueNameChangedEvent` | Name update | oldName, newName |
| `LeagueConfigurationUpdatedEvent` | Config change | rosterConfig, scoringRules |
| `PlayerAddedToLeagueEvent` | Player join | playerId, email |
| `PlayerRemovedFromLeagueEvent` | Player leave | playerId, reason |
| `LeagueStartedEvent` | League start | - |
| `LeagueConfigurationLockedEvent` | Config lock | lockedAt, reason |
| `LeagueWeekAdvancedEvent` | Week advance | prevWeek, newWeek |
| `LeagueCompletedEvent` | League end | winnerId |
| `LeagueCancelledEvent` | Cancellation | reason |

---

## Testing Strategy

### Unit Tests
```java
@Test
void shouldReconstructLeagueFromEvents() {
    // Given
    List<DomainEvent> history = List.of(
        new LeagueCreatedEvent(id, 1, "Test League", "ABC123", ownerId, 1, 17),
        new PlayerAddedToLeagueEvent(id, 2, player1Id, "p1@test.com"),
        new PlayerAddedToLeagueEvent(id, 3, player2Id, "p2@test.com"),
        new LeagueStartedEvent(id, 4)
    );

    // When
    EventSourcedLeague league = new EventSourcedLeague(id);
    league.loadFromHistory(history);

    // Then
    assertThat(league.getStatus()).isEqualTo(LeagueStatus.ACTIVE);
    assertThat(league.getPlayers()).hasSize(2);
    assertThat(league.getVersion()).isEqualTo(4);
}

@Test
void shouldProduceEventsOnCommand() {
    // Given
    EventSourcedLeague league = EventSourcedLeague.create(
        "Test", "ABC", ownerId, 1, 17
    );

    // When
    league.addPlayer(playerId, "player@test.com");

    // Then
    List<DomainEvent> events = league.getUncommittedEvents();
    assertThat(events).hasSize(2);
    assertThat(events.get(0)).isInstanceOf(LeagueCreatedEvent.class);
    assertThat(events.get(1)).isInstanceOf(PlayerAddedToLeagueEvent.class);
}
```

---

## Files to Create

### Domain Layer
- `domain/event/DomainEvent.java` - Base event class
- `domain/aggregate/EventSourcedAggregate.java` - Base aggregate
- `domain/port/EventStore.java` - Event store interface
- `domain/port/EventPublisher.java` - Publisher interface
- `domain/port/EventSourcedRepository.java` - Repository base
- `domain/event/league/*.java` - League-specific events

### Infrastructure Layer
- `infrastructure/adapter/persistence/document/EventDocument.java`
- `infrastructure/adapter/persistence/MongoEventStore.java`
- `infrastructure/adapter/event/SpringEventPublisher.java`
- `infrastructure/adapter/persistence/EventSourcedLeagueRepository.java`

---

**Document Status**: Ready for Implementation
**Created**: 2025-12-29
**Ticket**: ANIMA-1159
