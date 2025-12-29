package com.ffl.playoffs.infrastructure.event;

import com.ffl.playoffs.domain.aggregate.WorldEvent;
import com.ffl.playoffs.domain.port.EventNotificationPublisher;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.UUID;

/**
 * Spring-based implementation of EventNotificationPublisher.
 * Publishes domain events through Spring's event system.
 */
@Component
public class SpringEventNotificationPublisher implements EventNotificationPublisher {

    private static final Logger log = LoggerFactory.getLogger(SpringEventNotificationPublisher.class);

    private final ApplicationEventPublisher applicationEventPublisher;

    public SpringEventNotificationPublisher(ApplicationEventPublisher applicationEventPublisher) {
        this.applicationEventPublisher = applicationEventPublisher;
    }

    @Override
    public void publishEventActivated(WorldEvent event) {
        log.info("Publishing event activated: id={}, type={}, name='{}'",
                event.getId(), event.getType(), event.getName());

        WorldEventActivatedEvent springEvent = new WorldEventActivatedEvent(this, event);
        applicationEventPublisher.publishEvent(springEvent);
    }

    @Override
    public void publishEventExpired(WorldEvent event) {
        log.info("Publishing event expired: id={}, type={}, name='{}'",
                event.getId(), event.getType(), event.getName());

        WorldEventExpiredEvent springEvent = new WorldEventExpiredEvent(this, event);
        applicationEventPublisher.publishEvent(springEvent);
    }

    @Override
    public void publishEventCancelled(WorldEvent event, String reason) {
        log.info("Publishing event cancelled: id={}, type={}, reason='{}'",
                event.getId(), event.getType(), reason);

        WorldEventCancelledEvent springEvent = new WorldEventCancelledEvent(this, event, reason);
        applicationEventPublisher.publishEvent(springEvent);
    }

    @Override
    public void publishWeeklyEventSummary(UUID simulationRunId, Integer week, List<WorldEvent> events) {
        log.info("Publishing weekly event summary: runId={}, week={}, eventCount={}",
                simulationRunId, week, events.size());

        WeeklyEventSummaryEvent springEvent = new WeeklyEventSummaryEvent(this, simulationRunId, week, events);
        applicationEventPublisher.publishEvent(springEvent);
    }

    // ==================== Spring Event Classes ====================

    /**
     * Spring event for world event activation.
     */
    public static class WorldEventActivatedEvent extends org.springframework.context.ApplicationEvent {
        private final WorldEvent worldEvent;

        public WorldEventActivatedEvent(Object source, WorldEvent worldEvent) {
            super(source);
            this.worldEvent = worldEvent;
        }

        public WorldEvent getWorldEvent() {
            return worldEvent;
        }
    }

    /**
     * Spring event for world event expiration.
     */
    public static class WorldEventExpiredEvent extends org.springframework.context.ApplicationEvent {
        private final WorldEvent worldEvent;

        public WorldEventExpiredEvent(Object source, WorldEvent worldEvent) {
            super(source);
            this.worldEvent = worldEvent;
        }

        public WorldEvent getWorldEvent() {
            return worldEvent;
        }
    }

    /**
     * Spring event for world event cancellation.
     */
    public static class WorldEventCancelledEvent extends org.springframework.context.ApplicationEvent {
        private final WorldEvent worldEvent;
        private final String reason;

        public WorldEventCancelledEvent(Object source, WorldEvent worldEvent, String reason) {
            super(source);
            this.worldEvent = worldEvent;
            this.reason = reason;
        }

        public WorldEvent getWorldEvent() {
            return worldEvent;
        }

        public String getReason() {
            return reason;
        }
    }

    /**
     * Spring event for weekly event summary.
     */
    public static class WeeklyEventSummaryEvent extends org.springframework.context.ApplicationEvent {
        private final UUID simulationRunId;
        private final Integer week;
        private final List<WorldEvent> events;

        public WeeklyEventSummaryEvent(Object source, UUID simulationRunId, Integer week, List<WorldEvent> events) {
            super(source);
            this.simulationRunId = simulationRunId;
            this.week = week;
            this.events = events;
        }

        public UUID getSimulationRunId() {
            return simulationRunId;
        }

        public Integer getWeek() {
            return week;
        }

        public List<WorldEvent> getEvents() {
            return events;
        }
    }
}
