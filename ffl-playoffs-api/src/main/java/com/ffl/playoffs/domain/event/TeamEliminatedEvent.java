package com.ffl.playoffs.domain.event;

import lombok.Getter;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Domain event fired when a team is eliminated from the game.
 */
@Getter
@AllArgsConstructor
public class TeamEliminatedEvent {
    private final UUID gameId;
    private final UUID playerId;
    private final String playerName;
    private final Integer weekNumber;
    private final LocalDateTime eliminatedAt;
}
