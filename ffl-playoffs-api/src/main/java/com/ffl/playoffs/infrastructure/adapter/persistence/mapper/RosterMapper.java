package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.RosterLockStatus;
import com.ffl.playoffs.domain.model.RosterSlot;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.RosterDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.RosterPlayerSlotDocument;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Mapper to convert between Roster domain model and RosterDocument.
 * Infrastructure layer component.
 */
@Component
public class RosterMapper {

    /**
     * Converts Roster domain entity to RosterDocument for MongoDB persistence.
     *
     * @param roster the domain entity
     * @return the MongoDB document
     */
    public RosterDocument toDocument(Roster roster) {
        if (roster == null) {
            return null;
        }

        RosterDocument document = new RosterDocument();
        document.setId(roster.getId() != null ? roster.getId().toString() : null);
        document.setLeaguePlayerId(roster.getLeaguePlayerId() != null
                ? roster.getLeaguePlayerId().toString() : null);
        document.setGameId(roster.getGameId() != null ? roster.getGameId().toString() : null);
        document.setSlots(toSlotDocuments(roster.getSlots()));
        document.setIsLocked(roster.isLocked());
        document.setLockStatus(roster.getLockStatus() != null
                ? roster.getLockStatus().name() : null);
        document.setLockedAt(roster.getLockedAt());
        document.setRosterDeadline(roster.getRosterDeadline());
        document.setCreatedAt(roster.getCreatedAt());
        document.setUpdatedAt(roster.getUpdatedAt());

        return document;
    }

    /**
     * Converts RosterDocument to Roster domain entity.
     *
     * @param document the MongoDB document
     * @return the domain entity
     */
    public Roster toDomain(RosterDocument document) {
        if (document == null) {
            return null;
        }

        Roster roster = new Roster();
        roster.setId(document.getId() != null ? UUID.fromString(document.getId()) : null);
        roster.setLeaguePlayerId(document.getLeaguePlayerId() != null
                ? UUID.fromString(document.getLeaguePlayerId()) : null);
        roster.setGameId(document.getGameId() != null ? UUID.fromString(document.getGameId()) : null);
        roster.setSlots(toSlotDomains(document.getSlots()));
        roster.setLocked(document.getIsLocked() != null && document.getIsLocked());
        roster.setLockStatus(document.getLockStatus() != null
                ? RosterLockStatus.valueOf(document.getLockStatus()) : RosterLockStatus.UNLOCKED);
        roster.setLockedAt(document.getLockedAt());
        roster.setRosterDeadline(document.getRosterDeadline());
        roster.setCreatedAt(document.getCreatedAt());
        roster.setUpdatedAt(document.getUpdatedAt());

        return roster;
    }

    // Private helper methods for slot mapping

    private List<RosterPlayerSlotDocument> toSlotDocuments(List<RosterSlot> slots) {
        if (slots == null) {
            return Collections.emptyList();
        }

        return slots.stream()
                .map(this::toSlotDocument)
                .collect(Collectors.toList());
    }

    private RosterPlayerSlotDocument toSlotDocument(RosterSlot slot) {
        if (slot == null) {
            return null;
        }

        RosterPlayerSlotDocument document = new RosterPlayerSlotDocument();
        document.setId(slot.getId() != null ? slot.getId().toString() : null);
        document.setRosterId(slot.getRosterId() != null ? slot.getRosterId().toString() : null);
        document.setPosition(slot.getPosition() != null ? slot.getPosition().name() : null);
        document.setNflPlayerId(slot.getNflPlayerId());
        document.setSlotOrder(slot.getSlotOrder());
        document.setCreatedAt(slot.getCreatedAt());
        document.setUpdatedAt(slot.getUpdatedAt());

        return document;
    }

    private List<RosterSlot> toSlotDomains(List<RosterPlayerSlotDocument> documents) {
        if (documents == null) {
            return new ArrayList<>();
        }

        return documents.stream()
                .map(this::toSlotDomain)
                .collect(Collectors.toCollection(ArrayList::new));
    }

    private RosterSlot toSlotDomain(RosterPlayerSlotDocument document) {
        if (document == null) {
            return null;
        }

        RosterSlot slot = new RosterSlot();
        slot.setId(document.getId() != null ? UUID.fromString(document.getId()) : null);
        slot.setRosterId(document.getRosterId() != null ? UUID.fromString(document.getRosterId()) : null);
        slot.setPosition(document.getPosition() != null ? Position.valueOf(document.getPosition()) : null);
        slot.setNflPlayerId(document.getNflPlayerId());
        slot.setSlotOrder(document.getSlotOrder());
        slot.setCreatedAt(document.getCreatedAt());
        slot.setUpdatedAt(document.getUpdatedAt());

        return slot;
    }
}
