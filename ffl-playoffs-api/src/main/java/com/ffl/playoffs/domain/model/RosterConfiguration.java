package com.ffl.playoffs.domain.model;

import java.util.HashMap;
import java.util.Map;

/**
 * Roster Configuration Value Object
 * Defines how many slots of each position a roster must have
 * Configured at the league level by admin
 */
public class RosterConfiguration {
    private Map<Position, Integer> positionSlots;
    private Integer totalSlots;

    // Constructors
    public RosterConfiguration() {
        this.positionSlots = new HashMap<>();
        this.totalSlots = 0;
    }

    // Static factory methods for common configurations
    public static RosterConfiguration standardRoster() {
        RosterConfiguration config = new RosterConfiguration();
        config.setPositionSlots(Position.QB, 1);
        config.setPositionSlots(Position.RB, 2);
        config.setPositionSlots(Position.WR, 2);
        config.setPositionSlots(Position.TE, 1);
        config.setPositionSlots(Position.FLEX, 1);
        config.setPositionSlots(Position.K, 1);
        config.setPositionSlots(Position.DEF, 1);
        config.calculateTotalSlots();
        return config;
    }

    public static RosterConfiguration superflexRoster() {
        RosterConfiguration config = new RosterConfiguration();
        config.setPositionSlots(Position.QB, 1);
        config.setPositionSlots(Position.RB, 2);
        config.setPositionSlots(Position.WR, 2);
        config.setPositionSlots(Position.TE, 1);
        config.setPositionSlots(Position.FLEX, 1);
        config.setPositionSlots(Position.SUPERFLEX, 1);
        config.setPositionSlots(Position.K, 1);
        config.setPositionSlots(Position.DEF, 1);
        config.calculateTotalSlots();
        return config;
    }

    // Business Logic
    public void setPositionSlots(Position position, Integer count) {
        if (count < 0) {
            throw new IllegalArgumentException("Position slot count cannot be negative");
        }
        if (count == 0) {
            positionSlots.remove(position);
        } else {
            positionSlots.put(position, count);
        }
        calculateTotalSlots();
    }

    public Integer getPositionSlots(Position position) {
        return positionSlots.getOrDefault(position, 0);
    }

    public boolean hasPosition(Position position) {
        return positionSlots.containsKey(position) && positionSlots.get(position) > 0;
    }

    public void calculateTotalSlots() {
        this.totalSlots = positionSlots.values().stream()
            .mapToInt(Integer::intValue)
            .sum();
    }

    public void validate() {
        if (totalSlots == 0) {
            throw new IllegalStateException("Roster configuration must have at least one position slot");
        }
        if (totalSlots > 20) {
            throw new IllegalStateException("Roster configuration cannot exceed 20 total slots");
        }
        // Ensure at least 1 QB or SUPERFLEX
        if (getPositionSlots(Position.QB) == 0 && getPositionSlots(Position.SUPERFLEX) == 0) {
            throw new IllegalStateException("Roster must have at least 1 QB or 1 SUPERFLEX slot");
        }
    }

    // Getters
    public Map<Position, Integer> getPositionSlots() {
        return new HashMap<>(positionSlots); // Return defensive copy
    }

    public void setPositionSlotsMap(Map<Position, Integer> positionSlots) {
        this.positionSlots = new HashMap<>(positionSlots);
        calculateTotalSlots();
    }

    public Integer getTotalSlots() {
        return totalSlots;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("Roster Configuration: ");
        positionSlots.forEach((position, count) ->
            sb.append(position.name()).append("(").append(count).append(") ")
        );
        sb.append("| Total: ").append(totalSlots);
        return sb.toString();
    }
}
