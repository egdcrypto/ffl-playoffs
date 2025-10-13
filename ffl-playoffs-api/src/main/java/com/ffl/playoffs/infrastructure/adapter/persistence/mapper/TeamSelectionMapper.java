package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.model.TeamSelection;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.TeamSelectionDocument;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * Mapper to convert between TeamSelection domain model and TeamSelectionDocument
 * Infrastructure layer
 */
@Component
public class TeamSelectionMapper {

    /**
     * Converts TeamSelection domain entity to TeamSelectionDocument
     * @param teamSelection the domain entity
     * @return the MongoDB document
     */
    public TeamSelectionDocument toDocument(TeamSelection teamSelection) {
        if (teamSelection == null) {
            return null;
        }

        TeamSelectionDocument document = new TeamSelectionDocument();
        document.setId(teamSelection.getId() != null ? teamSelection.getId().toString() : null);
        document.setPlayerId(teamSelection.getPlayerId() != null ? teamSelection.getPlayerId().toString() : null);
        document.setGameId(teamSelection.getGameId() != null ? teamSelection.getGameId().toString() : null);
        document.setTeamName(teamSelection.getTeamName());
        document.setWeek(teamSelection.getWeek());
        document.setSelectedAt(teamSelection.getSelectedAt());
        document.setLocked(teamSelection.isLocked());

        return document;
    }

    /**
     * Converts TeamSelectionDocument to TeamSelection domain entity
     * @param document the MongoDB document
     * @return the domain entity
     */
    public TeamSelection toDomain(TeamSelectionDocument document) {
        if (document == null) {
            return null;
        }

        TeamSelection teamSelection = new TeamSelection();
        teamSelection.setId(document.getId() != null ? UUID.fromString(document.getId()) : null);
        teamSelection.setPlayerId(document.getPlayerId() != null ? UUID.fromString(document.getPlayerId()) : null);
        teamSelection.setGameId(document.getGameId() != null ? UUID.fromString(document.getGameId()) : null);
        teamSelection.setTeamName(document.getTeamName());
        teamSelection.setWeek(document.getWeek());
        teamSelection.setSelectedAt(document.getSelectedAt());
        teamSelection.setLocked(document.isLocked());

        return teamSelection;
    }
}
