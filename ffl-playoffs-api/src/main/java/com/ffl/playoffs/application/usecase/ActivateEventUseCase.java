package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.WorldEvent;
import com.ffl.playoffs.domain.model.EventStatus;
import com.ffl.playoffs.domain.port.EventNotificationPublisher;
import com.ffl.playoffs.domain.port.WorldEventRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.UUID;

/**
 * Use case for activating a scheduled event.
 */
public class ActivateEventUseCase {

    private static final Logger log = LoggerFactory.getLogger(ActivateEventUseCase.class);

    private final WorldEventRepository eventRepository;
    private final EventNotificationPublisher notificationPublisher;

    public ActivateEventUseCase(WorldEventRepository eventRepository,
                                 EventNotificationPublisher notificationPublisher) {
        this.eventRepository = eventRepository;
        this.notificationPublisher = notificationPublisher;
    }

    public WorldEvent execute(UUID eventId) {
        log.info("Activating event: {}", eventId);

        WorldEvent event = eventRepository.findById(eventId)
                .orElseThrow(() -> new EventNotFoundException("Event not found: " + eventId));

        if (event.getStatus() != EventStatus.SCHEDULED) {
            throw new InvalidEventStateException(
                    "Cannot activate event in status: " + event.getStatus());
        }

        event.activate();
        WorldEvent saved = eventRepository.save(event);

        notificationPublisher.publishEventActivated(saved);

        log.info("Activated event: id={}, type={}", saved.getId(), saved.getType());
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
