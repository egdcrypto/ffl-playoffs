package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.model.*;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.*;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;
import java.util.UUID;
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
        league.setStatus(document.getStatus() != null ? League.LeagueStatus.valueOf(document.getStatus()) : null);
        league.setStartingWeek(document.getStartingWeek());
        league.setNumberOfWeeks(document.getNumberOfWeeks());
        league.setCurrentWeek(document.getCurrentWeek());
        league.setRosterConfiguration(toRosterConfigurationDomain(document.getRosterConfiguration()));
        league.setScoringRules(toScoringRulesDomain(document.getScoringRules()));
        league.setConfigurationLocked(document.getConfigurationLocked());
        league.setConfigurationLockedAt(document.getConfigurationLockedAt());
        league.setLockReason(document.getLockReason());
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
        document.setSlots(toRosterSlotDocuments(config.getSlots()));
        document.setTotalSlots(config.getTotalSlots());
        document.setFlexSlots(config.getFlexSlots());

        return document;
    }

    private RosterConfiguration toRosterConfigurationDomain(RosterConfigurationDocument document) {
        if (document == null) {
            return null;
        }

        RosterConfiguration config = new RosterConfiguration();
        config.setSlots(toRosterSlotDomains(document.getSlots()));
        config.setTotalSlots(document.getTotalSlots());
        config.setFlexSlots(document.getFlexSlots());

        return config;
    }

    private List<RosterSlotDocument> toRosterSlotDocuments(List<RosterSlot> slots) {
        if (slots == null) {
            return Collections.emptyList();
        }

        return slots.stream()
                .map(this::toRosterSlotDocument)
                .collect(Collectors.toList());
    }

    private RosterSlotDocument toRosterSlotDocument(RosterSlot slot) {
        if (slot == null) {
            return null;
        }

        RosterSlotDocument document = new RosterSlotDocument();
        document.setPosition(slot.getPosition() != null ? slot.getPosition().name() : null);
        document.setCount(slot.getCount());
        document.setIsFlex(slot.isFlex());

        return document;
    }

    private List<RosterSlot> toRosterSlotDomains(List<RosterSlotDocument> documents) {
        if (documents == null) {
            return Collections.emptyList();
        }

        return documents.stream()
                .map(this::toRosterSlotDomain)
                .collect(Collectors.toList());
    }

    private RosterSlot toRosterSlotDomain(RosterSlotDocument document) {
        if (document == null) {
            return null;
        }

        RosterSlot slot = new RosterSlot();
        slot.setPosition(document.getPosition() != null ? Position.valueOf(document.getPosition()) : null);
        slot.setCount(document.getCount());
        slot.setFlex(document.getIsFlex());

        return slot;
    }

    private ScoringRulesDocument toScoringRulesDocument(ScoringRules rules) {
        if (rules == null) {
            return null;
        }

        ScoringRulesDocument document = new ScoringRulesDocument();
        document.setPassingYards(rules.getPassingYards());
        document.setPassingTouchdowns(rules.getPassingTouchdowns());
        document.setPassingInterceptions(rules.getPassingInterceptions());
        document.setRushingYards(rules.getRushingYards());
        document.setRushingTouchdowns(rules.getRushingTouchdowns());
        document.setReceivingYards(rules.getReceivingYards());
        document.setReceivingTouchdowns(rules.getReceivingTouchdowns());
        document.setReceptions(rules.getReceptions());
        document.setFumbles(rules.getFumbles());
        document.setTwoPointConversions(rules.getTwoPointConversions());

        return document;
    }

    private ScoringRules toScoringRulesDomain(ScoringRulesDocument document) {
        if (document == null) {
            return null;
        }

        ScoringRules rules = new ScoringRules();
        rules.setPassingYards(document.getPassingYards());
        rules.setPassingTouchdowns(document.getPassingTouchdowns());
        rules.setPassingInterceptions(document.getPassingInterceptions());
        rules.setRushingYards(document.getRushingYards());
        rules.setRushingTouchdowns(document.getRushingTouchdowns());
        rules.setReceivingYards(document.getReceivingYards());
        rules.setReceivingTouchdowns(document.getReceivingTouchdowns());
        rules.setReceptions(document.getReceptions());
        rules.setFumbles(document.getFumbles());
        rules.setTwoPointConversions(document.getTwoPointConversions());

        return rules;
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
        document.setId(player.getId() != null ? player.getId().toString() : null);
        document.setEmail(player.getEmail());
        document.setName(player.getName());
        document.setStatus(player.getStatus() != null ? player.getStatus().name() : null);
        document.setJoinedAt(player.getJoinedAt());
        document.setEliminatedAt(player.getEliminatedAt());
        document.setEliminationReason(player.getEliminationReason());

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
        player.setId(document.getId() != null ? UUID.fromString(document.getId()) : null);
        player.setEmail(document.getEmail());
        player.setName(document.getName());
        player.setStatus(document.getStatus() != null ? PlayerStatus.valueOf(document.getStatus()) : null);
        player.setJoinedAt(document.getJoinedAt());
        player.setEliminatedAt(document.getEliminatedAt());
        player.setEliminationReason(document.getEliminationReason());

        return player;
    }
}
