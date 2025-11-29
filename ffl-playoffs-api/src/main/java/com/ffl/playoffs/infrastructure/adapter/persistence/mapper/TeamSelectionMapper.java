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
        document.setId(teamSelection.getId() != null ? UUID.fromString(teamSelection.getId().toString()) : null);
        document.setPlayerId(teamSelection.getPlayerId() != null ? UUID.fromString(teamSelection.getPlayerId().toString()) : null);
        // gameId doesn't exist in current TeamSelection model or TeamSelectionDocument
        document.setTeamName(teamSelection.getNflTeam());
        document.setWeekNumber(teamSelection.getWeekId() != null ? teamSelection.getWeekId().intValue() : null);
        document.setSelectedAt(teamSelection.getSelectedAt());
        document.setIsEliminated(teamSelection.getStatus() == TeamSelection.SelectionStatus.SCORED && teamSelection.getScore() != null && teamSelection.getScore() == 0.0);

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
        teamSelection.setId(document.getId() != null ? Long.parseLong(document.getId().toString().hashCode() + "") : null);
        teamSelection.setPlayerId(document.getPlayerId() != null ? Long.parseLong(document.getPlayerId().toString().hashCode() + "") : null);
        // gameId doesn't exist in current TeamSelection model
        teamSelection.setNflTeam(document.getTeamName());
        teamSelection.setWeekId(document.getWeekNumber() != null ? document.getWeekNumber().longValue() : null);
        teamSelection.setSelectedAt(document.getSelectedAt());
        teamSelection.setStatus(document.getIsEliminated() != null && document.getIsEliminated() ? TeamSelection.SelectionStatus.SCORED : TeamSelection.SelectionStatus.PENDING);

        return teamSelection;
    }
}
