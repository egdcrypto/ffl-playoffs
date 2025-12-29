package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.WorldEvent;

import java.util.List;
import java.util.UUID;

/**
 * Port for publishing event notifications to other systems.
 */
public interface EventNotificationPublisher {

    /**
     * Publishes when an event is activated.
     */
    void publishEventActivated(WorldEvent event);

    /**
     * Publishes when an event expires.
     */
    void publishEventExpired(WorldEvent event);

    /**
     * Publishes when an event is cancelled.
     */
    void publishEventCancelled(WorldEvent event, String reason);

    /**
     * Publishes summary of weekly events.
     */
    void publishWeeklyEventSummary(UUID simulationRunId, Integer week, List<WorldEvent> events);
}
