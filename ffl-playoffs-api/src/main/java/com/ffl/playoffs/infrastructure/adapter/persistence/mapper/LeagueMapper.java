package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.aggregate.*;
import com.ffl.playoffs.domain.model.*;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.*;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Mapper to convert between League domain model and LeagueDocument
 * Infrastructure layer
 */
@Component
public class LeagueMapper {

    /**
     * Converts League domain entity to LeagueDocument
     * @param league the domain entity
     * @return the MongoDB document
     */
    public LeagueDocument toDocument(League league) {
        if (league == null) {
            return null;
        }

        LeagueDocument document = new LeagueDocument();
        document.setId(league.getId() != null ? league.getId().toString() : null);
        document.setName(league.getName());
        document.setDescription(league.getDescription());
        document.setCode(league.getCode());
        document.setOwnerId(league.getOwnerId() != null ? league.getOwnerId().toString() : null);
        document.setStatus(league.getStatus() != null ? league.getStatus().name() : null);
        document.setStartingWeek(league.getStartingWeek());
        document.setNumberOfWeeks(league.getNumberOfWeeks());
        document.setCurrentWeek(league.getCurrentWeek());
        document.setRosterConfiguration(toRosterConfigurationDocument(league.getRosterConfiguration()));
        document.setScoringRules(toScoringRulesDocument(league.getScoringRules()));
        document.setConfigurationLocked(league.getConfigurationLocked());
        document.setConfigurationLockedAt(league.getConfigurationLockedAt());
        document.setLockReason(league.getLockReason());
        document.setFirstGameStartTime(league.getFirstGameStartTime());
        document.setPlayers(toPlayerDocuments(league.getPlayers()));
        document.setCreatedAt(league.getCreatedAt());
        document.setUpdatedAt(league.getUpdatedAt());

        return document;
    }

    /**
     * Converts LeagueDocument to League domain entity
     * @param document the MongoDB document
     * @return the domain entity
     */
    public League toDomain(LeagueDocument document) {
        if (document == null) {
            return null;
        }

        League league = new League();
        league.setId(document.getId() != null ? UUID.fromString(document.getId()) : null);
        league.setName(document.getName());
        league.setDescription(document.getDescription());
        league.setCode(document.getCode());
        league.setOwnerId(document.getOwnerId() != null ? UUID.fromString(document.getOwnerId()) : null);
        league.setStatus(document.getStatus() != null ? LeagueStatus.valueOf(document.getStatus()) : null);
        // setStartingWeek and setNumberOfWeeks require LocalDateTime parameter in League model
        // Use setStartingWeekAndDuration instead
        if (document.getStartingWeek() != null && document.getNumberOfWeeks() != null) {
            league.setStartingWeekAndDuration(document.getStartingWeek(), document.getNumberOfWeeks());
        }
        league.setCurrentWeek(document.getCurrentWeek());
        league.setRosterConfiguration(toRosterConfigurationDomain(document.getRosterConfiguration()));
        league.setScoringRules(toScoringRulesDomain(document.getScoringRules()));
        league.setConfigurationLocked(document.getConfigurationLocked());
        // setConfigurationLockedAt and setLockReason don't exist - use lockConfiguration() if needed
        if (document.getConfigurationLockedAt() != null) {
            league.lockConfiguration(document.getConfigurationLockedAt(), document.getLockReason());
        }
        league.setFirstGameStartTime(document.getFirstGameStartTime());
        league.setPlayers(toPlayerDomains(document.getPlayers()));
        league.setCreatedAt(document.getCreatedAt());
        league.setUpdatedAt(document.getUpdatedAt());

        return league;
    }

    // Private helper methods

    private RosterConfigurationDocument toRosterConfigurationDocument(RosterConfiguration config) {
        if (config == null) {
            return null;
        }

        RosterConfigurationDocument document = new RosterConfigurationDocument();
        // Convert Map<Position, Integer> to List<RosterSlotDocument>
        List<RosterSlotDocument> slotDocuments = new ArrayList<>();
        for (Map.Entry<Position, Integer> entry : config.getPositionSlots().entrySet()) {
            RosterSlotDocument slotDoc = new RosterSlotDocument();
            slotDoc.setPosition(entry.getKey().name());
            slotDoc.setCount(entry.getValue());
            slotDoc.setIsFlex(false); // Current RosterConfiguration doesn't track this
            slotDocuments.add(slotDoc);
        }
        document.setSlots(slotDocuments);
        document.setTotalSlots(config.getTotalSlots());
        document.setFlexSlots(0); // Current RosterConfiguration doesn't have this field

        return document;
    }

    private RosterConfiguration toRosterConfigurationDomain(RosterConfigurationDocument document) {
        if (document == null) {
            return null;
        }

        RosterConfiguration config = new RosterConfiguration();
        // Convert List<RosterSlotDocument> to Map<Position, Integer>
        Map<Position, Integer> positionSlots = new HashMap<>();
        if (document.getSlots() != null) {
            for (RosterSlotDocument slotDoc : document.getSlots()) {
                if (slotDoc.getPosition() != null) {
                    positionSlots.put(
                        Position.valueOf(slotDoc.getPosition()),
                        slotDoc.getCount() != null ? slotDoc.getCount() : 0
                    );
                }
            }
        }
        config.setPositionSlotsMap(positionSlots);

        return config;
    }

    // RosterSlot mapping methods removed - RosterConfiguration now uses Map<Position, Integer> instead of List<RosterSlot>

    private ScoringRulesDocument toScoringRulesDocument(ScoringRules rules) {
        if (rules == null) {
            return null;
        }

        // ScoringRules has: touchdownPoints, fieldGoalPoints, safetyPoints, extraPointPoints, twoPointConversionPoints
        // ScoringRulesDocument has different fields - mapping as best as possible
        ScoringRulesDocument document = new ScoringRulesDocument();
        // Map the fields that exist
        if (rules.getTwoPointConversionPoints() != null) {
            // Store twoPointConversionPoints in a compatible field if it exists
            // document.setTwoPointConversions(rules.getTwoPointConversionPoints());
        }
        // Other fields don't have direct mappings
        return document;
    }

    private ScoringRules toScoringRulesDomain(ScoringRulesDocument document) {
        if (document == null) {
            return null;
        }

        // Use builder since ScoringRules uses Lombok
        return ScoringRules.builder()
                // Map what we can from the document
                .touchdownPoints(null) // Not in document
                .fieldGoalPoints(null) // Not in document
                .safetyPoints(null) // Not in document
                .extraPointPoints(null) // Not in document
                .twoPointConversionPoints(null) // May or may not be in document
                .build();
    }

    private List<PlayerDocument> toPlayerDocuments(List<Player> players) {
        if (players == null) {
            return Collections.emptyList();
        }

        return players.stream()
                .map(this::toPlayerDocument)
                .collect(Collectors.toList());
    }

    private PlayerDocument toPlayerDocument(Player player) {
        if (player == null) {
            return null;
        }

        PlayerDocument document = new PlayerDocument();
        document.setId(player.getId() != null ? UUID.fromString(player.getId().toString()) : null);
        document.setEmail(player.getEmail());
        document.setName(player.getDisplayName());
        document.setStatus(player.getStatus() != null ? player.getStatus().name() : null);
        document.setJoinedAt(player.getJoinedAt());
        // eliminatedAt and eliminationReason don't exist in PlayerDocument
        // isEliminated can be derived from status
        document.setIsEliminated(player.getStatus() == Player.PlayerStatus.ELIMINATED);

        return document;
    }

    private List<Player> toPlayerDomains(List<PlayerDocument> documents) {
        if (documents == null) {
            return Collections.emptyList();
        }

        return documents.stream()
                .map(this::toPlayerDomain)
                .collect(Collectors.toList());
    }

    private Player toPlayerDomain(PlayerDocument document) {
        if (document == null) {
            return null;
        }

        Player player = new Player();
        player.setId(document.getId() != null ? Long.parseLong(document.getId().hashCode() + "") : null);
        player.setEmail(document.getEmail());
        player.setDisplayName(document.getName());
        player.setStatus(document.getStatus() != null ? Player.PlayerStatus.valueOf(document.getStatus()) : null);
        player.setJoinedAt(document.getJoinedAt());
        // eliminatedAt and eliminationReason don't exist in current Player model
        // googleId is not in PlayerDocument

        return player;
    }
}
