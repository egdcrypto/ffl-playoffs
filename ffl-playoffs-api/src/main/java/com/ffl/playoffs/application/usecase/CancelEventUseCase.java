package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.WorldEvent;
import com.ffl.playoffs.domain.model.EventStatus;
import com.ffl.playoffs.domain.port.EventNotificationPublisher;
import com.ffl.playoffs.domain.port.WorldEventRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.UUID;

/**
 * Use case for cancelling an active or scheduled event.
 */
public class CancelEventUseCase {

    private static final Logger log = LoggerFactory.getLogger(CancelEventUseCase.class);

    private final WorldEventRepository eventRepository;
    private final EventNotificationPublisher notificationPublisher;

    public CancelEventUseCase(WorldEventRepository eventRepository,
                               EventNotificationPublisher notificationPublisher) {
        this.eventRepository = eventRepository;
        this.notificationPublisher = notificationPublisher;
    }

    public WorldEvent execute(UUID eventId, String reason) {
        log.info("Cancelling event: {}, reason: {}", eventId, reason);

        WorldEvent event = eventRepository.findById(eventId)
                .orElseThrow(() -> new EventNotFoundException("Event not found: " + eventId));

        if (event.getStatus() == EventStatus.EXPIRED || event.getStatus() == EventStatus.CANCELLED) {
            throw new InvalidEventStateException(
                    "Cannot cancel event in status: " + event.getStatus());
        }

        event.cancel(reason);
        WorldEvent saved = eventRepository.save(event);

        notificationPublisher.publishEventCancelled(saved, reason);

        log.info("Cancelled event: id={}, reason={}", saved.getId(), reason);
        return saved;
    }

    public static class EventNotFoundException extends RuntimeException {
        public EventNotFoundException(String message) {
            super(message);
        }
    }

    public static class InvalidEventStateException extends RuntimeException {
        public InvalidEventStateException(String message) {
            super(message);
        }
    }
}
