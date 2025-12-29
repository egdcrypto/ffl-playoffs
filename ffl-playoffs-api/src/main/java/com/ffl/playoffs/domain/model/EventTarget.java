package com.ffl.playoffs.domain.model;

import java.util.Objects;
import java.util.UUID;

/**
 * Value object specifying what entity is affected by an event.
 */
public class EventTarget {

    private final EventTargetType type;
    private final String targetId;
    private final String targetName;

    // For position-based targeting
    private final Position position;
    private final String teamContext;

    // Scope refinement
    private final TargetRole role;
    private final Integer limit;

    private EventTarget(EventTargetType type, String targetId, String targetName,
                        Position position, String teamContext, TargetRole role, Integer limit) {
        this.type = type;
        this.targetId = targetId;
        this.targetName = targetName;
        this.position = position;
        this.teamContext = teamContext;
        this.role = role;
        this.limit = limit;
    }

    // Factory methods

    public static EventTarget player(Long nflPlayerId, String name) {
        return new EventTarget(EventTargetType.PLAYER, nflPlayerId.toString(), name,
                null, null, null, null);
    }

    public static EventTarget team(String abbreviation, String name) {
        return new EventTarget(EventTargetType.TEAM, abbreviation, name,
                null, null, null, null);
    }

    public static EventTarget game(UUID gameId, String description) {
        return new EventTarget(EventTargetType.GAME, gameId.toString(), description,
                null, null, null, null);
    }

    public static EventTarget position(Position pos, String team, TargetRole role) {
        return new EventTarget(EventTargetType.POSITION, null, pos.name() + " on " + team,
                pos, team, role, null);
    }

    public static EventTarget allPlayers(String team) {
        return new EventTarget(EventTargetType.TEAM, team, "All " + team + " players",
                null, team, TargetRole.ALL, null);
    }

    public static EventTarget matchup(UUID gameId, String description) {
        return new EventTarget(EventTargetType.MATCHUP, gameId.toString(), description,
                null, null, null, null);
    }

    public static EventTarget league() {
        return new EventTarget(EventTargetType.LEAGUE, null, "All teams",
                null, null, null, null);
    }

    // Business methods

    public boolean matchesPlayer(Long playerId, Position playerPosition, String playerTeam) {
        return switch (type) {
            case PLAYER -> targetId.equals(playerId.toString());
            case TEAM -> teamContext != null && teamContext.equals(playerTeam);
            case POSITION -> position == playerPosition &&
                    (teamContext == null || teamContext.equals(playerTeam));
            case LEAGUE -> true;
            default -> false;
        };
    }

    public boolean matchesTeam(String teamAbbreviation) {
        return switch (type) {
            case TEAM -> targetId.equals(teamAbbreviation);
            case LEAGUE -> true;
            default -> false;
        };
    }

    // Getters

    public EventTargetType getType() {
        return type;
    }

    public String getTargetId() {
        return targetId;
    }

    public String getTargetName() {
        return targetName;
    }

    public Position getPosition() {
        return position;
    }

    public String getTeamContext() {
        return teamContext;
    }

    public TargetRole getRole() {
        return role;
    }

    public Integer getLimit() {
        return limit;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        EventTarget that = (EventTarget) o;
        return type == that.type &&
                Objects.equals(targetId, that.targetId) &&
                Objects.equals(position, that.position) &&
                Objects.equals(teamContext, that.teamContext);
    }

    @Override
    public int hashCode() {
        return Objects.hash(type, targetId, position, teamContext);
    }

    @Override
    public String toString() {
        return String.format("EventTarget{type=%s, target=%s}", type, targetName);
    }
}
