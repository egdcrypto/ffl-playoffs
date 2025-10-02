package com.ffl.playoffs.domain.event;

import lombok.Getter;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Domain event fired when a new game is created.
 */
@Getter
@AllArgsConstructor
public class GameCreatedEvent {
    private final UUID gameId;
    private final String gameName;
    private final UUID creatorId;
    private final LocalDateTime createdAt;
}
