package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.model.narrative.CuratorAction;
import com.ffl.playoffs.domain.model.narrative.CuratorActionType;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.CuratorActionDocument;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;

/**
 * Mapper for CuratorAction domain model and document
 */
@Component
public class CuratorActionMapper {

    public CuratorActionDocument toDocument(CuratorAction action) {
        if (action == null) {
            return null;
        }

        return CuratorActionDocument.builder()
                .id(action.getId())
                .leagueId(action.getLeagueId())
                .type(action.getType().getCode())
                .description(action.getDescription())
                .automated(action.isAutomated())
                .initiatedBy(action.getInitiatedBy())
                .createdAt(action.getCreatedAt())
                .executedAt(action.getExecutedAt())
                .completedAt(action.getCompletedAt())
                .status(action.getStatus().name())
                .statusMessage(action.getStatusMessage())
                .relatedStallConditionId(action.getRelatedStallConditionId())
                .relatedStoryArcId(action.getRelatedStoryArcId())
                .targetPlayerIds(new HashSet<>(action.getTargetPlayerIds()))
                .parameters(new HashMap<>(action.getParameters()))
                .results(new HashMap<>(action.getResults()))
                .build();
    }

    public CuratorAction toDomain(CuratorActionDocument document) {
        if (document == null) {
            return null;
        }

        CuratorAction action = CuratorAction.builder()
                .id(document.getId())
                .leagueId(document.getLeagueId())
                .type(CuratorActionType.fromCode(document.getType()))
                .description(document.getDescription())
                .automated(document.isAutomated())
                .initiatedBy(document.getInitiatedBy())
                .relatedStallConditionId(document.getRelatedStallConditionId())
                .relatedStoryArcId(document.getRelatedStoryArcId())
                .targetPlayerIds(document.getTargetPlayerIds() != null ?
                        document.getTargetPlayerIds() : new HashSet<>())
                .parameters(document.getParameters() != null ?
                        document.getParameters() : new HashMap<>())
                .build();

        // Reconstitute execution state
        CuratorAction.ActionStatus status = CuratorAction.ActionStatus.valueOf(document.getStatus());
        switch (status) {
            case IN_PROGRESS:
                action.startExecution();
                break;
            case COMPLETED:
                action.startExecution();
                Map<String, Object> results = document.getResults() != null ?
                        document.getResults() : new HashMap<>();
                action.complete(results);
                break;
            case FAILED:
                action.startExecution();
                action.fail(document.getStatusMessage());
                break;
            case CANCELLED:
                action.cancel(document.getStatusMessage());
                break;
            case PENDING:
            default:
                // Already in PENDING state
                break;
        }

        return action;
    }
}
