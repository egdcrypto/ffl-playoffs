package com.ffl.playoffs.domain.service;

import com.ffl.playoffs.domain.aggregate.WorldEvent;
import com.ffl.playoffs.domain.model.*;
import com.ffl.playoffs.domain.port.WorldEventRepository;

import java.util.*;

/**
 * Domain service for applying active events to simulation calculations.
 */
public class EventApplicationService {

    private final WorldEventRepository eventRepository;

    public EventApplicationService(WorldEventRepository eventRepository) {
        this.eventRepository = eventRepository;
    }

    /**
     * Gets all stat modifiers for a player in a given week.
     */
    public List<StatModifier> getModifiersForPlayer(
            UUID simulationRunId,
            Long nflPlayerId,
            Integer week) {

        List<WorldEvent> activeEvents = eventRepository
                .findActiveEventsForPlayer(simulationRunId, nflPlayerId, week);

        List<StatModifier> modifiers = new ArrayList<>();
        for (WorldEvent event : activeEvents) {
            modifiers.addAll(event.getStatModifiers());
        }

        return resolveModifierConflicts(modifiers);
    }

    /**
     * Gets all stat modifiers for a team in a given week.
     */
    public List<StatModifier> getModifiersForTeam(
            UUID simulationRunId,
            String teamAbbreviation,
            Integer week) {

        List<WorldEvent> activeEvents = eventRepository
                .findActiveEventsForTeam(simulationRunId, teamAbbreviation, week);

        List<StatModifier> modifiers = new ArrayList<>();
        for (WorldEvent event : activeEvents) {
            modifiers.addAll(event.getStatModifiers());
        }

        return resolveModifierConflicts(modifiers);
    }

    /**
     * Applies modifiers to a base stat value.
     */
    public Double applyModifiers(Double baseValue, List<StatModifier> modifiers, StatCategory category) {
        if (baseValue == null || modifiers == null || modifiers.isEmpty()) {
            return baseValue;
        }

        Double result = baseValue;

        // Apply multipliers first, then additives, then caps/floors
        List<StatModifier> multipliers = new ArrayList<>();
        List<StatModifier> additives = new ArrayList<>();
        List<StatModifier> caps = new ArrayList<>();
        List<StatModifier> floors = new ArrayList<>();

        for (StatModifier modifier : modifiers) {
            if (!modifier.appliesToCategory(category)) {
                continue;
            }

            switch (modifier.getModifierType()) {
                case MULTIPLIER -> multipliers.add(modifier);
                case ADDITIVE -> additives.add(modifier);
                case CAP -> caps.add(modifier);
                case FLOOR -> floors.add(modifier);
                case REPLACEMENT -> result = modifier.getValue();
            }
        }

        // Apply multipliers (compound them)
        for (StatModifier mod : multipliers) {
            result = mod.apply(result);
        }

        // Apply additives
        for (StatModifier mod : additives) {
            result = mod.apply(result);
        }

        // Apply caps (use lowest cap)
        if (!caps.isEmpty()) {
            double lowestCap = caps.stream()
                    .mapToDouble(StatModifier::getValue)
                    .min()
                    .orElse(Double.MAX_VALUE);
            result = Math.min(result, lowestCap);
        }

        // Apply floors (use highest floor)
        if (!floors.isEmpty()) {
            double highestFloor = floors.stream()
                    .mapToDouble(StatModifier::getValue)
                    .max()
                    .orElse(0.0);
            result = Math.max(result, highestFloor);
        }

        return result;
    }

    /**
     * Checks if a player is available for a game.
     */
    public boolean isPlayerAvailable(
            UUID simulationRunId,
            Long nflPlayerId,
            UUID gameId,
            Integer week) {

        List<WorldEvent> events = eventRepository
                .findActiveEventsForPlayer(simulationRunId, nflPlayerId, week);

        for (WorldEvent event : events) {
            if (event.causesUnavailability()) {
                return false;
            }
        }

        return true;
    }

    /**
     * Gets the combined availability modifier for a player.
     * Returns value between 0.0 (out) and 1.0 (full availability).
     */
    public Double getAvailabilityModifier(
            UUID simulationRunId,
            Long nflPlayerId,
            Integer week) {

        List<WorldEvent> events = eventRepository
                .findActiveEventsForPlayer(simulationRunId, nflPlayerId, week);

        Double availability = 1.0;

        for (WorldEvent event : events) {
            for (EventEffect effect : event.getEffects()) {
                if (effect.getForceOut() != null && effect.getForceOut()) {
                    return 0.0;
                }
                if (effect.getAvailabilityChance() != null) {
                    availability = Math.min(availability, effect.getAvailabilityChance());
                }
            }
        }

        return availability;
    }

    /**
     * Resolves conflicts between modifiers according to stacking rules.
     */
    private List<StatModifier> resolveModifierConflicts(List<StatModifier> modifiers) {
        if (modifiers.size() <= 1) {
            return modifiers;
        }

        // Group by category
        Map<StatCategory, List<StatModifier>> byCategory = new HashMap<>();
        for (StatModifier mod : modifiers) {
            byCategory.computeIfAbsent(mod.getCategory(), k -> new ArrayList<>()).add(mod);
        }

        List<StatModifier> resolved = new ArrayList<>();

        for (List<StatModifier> categoryMods : byCategory.values()) {
            // Remove conflicting modifiers (keep first non-stackable in each group)
            Map<StatModifier.StackingGroup, StatModifier> seenGroups = new HashMap<>();

            for (StatModifier mod : categoryMods) {
                if (mod.isStackable()) {
                    resolved.add(mod);
                } else {
                    StatModifier.StackingGroup group = mod.getStackingGroup();
                    if (group == null || !seenGroups.containsKey(group)) {
                        resolved.add(mod);
                        if (group != null) {
                            seenGroups.put(group, mod);
                        }
                    }
                }
            }
        }

        return resolved;
    }
}
