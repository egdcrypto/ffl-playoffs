package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.model.narrative.CuratorActionType;
import com.ffl.playoffs.domain.model.narrative.StallCondition;
import com.ffl.playoffs.domain.model.narrative.StallConditionType;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.StallConditionDocument;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.HashSet;

/**
 * Mapper for StallCondition domain model and document
 */
@Component
public class StallConditionMapper {

    public StallConditionDocument toDocument(StallCondition condition) {
        if (condition == null) {
            return null;
        }

        return StallConditionDocument.builder()
                .id(condition.getId())
                .leagueId(condition.getLeagueId())
                .type(condition.getType().getCode())
                .description(condition.getDescription())
                .detectedAt(condition.getDetectedAt())
                .stallStartedAt(condition.getStallStartedAt())
                .resolvedAt(condition.getResolvedAt())
                .severity(condition.getSeverity().name())
                .stallDurationHours(condition.getStallDurationHours())
                .affectedPlayerIds(new HashSet<>(condition.getAffectedPlayerIds()))
                .diagnosticData(new HashMap<>(condition.getDiagnosticData()))
                .resolved(condition.isResolved())
                .resolutionAction(condition.getResolutionAction() != null ?
                        condition.getResolutionAction().getCode() : null)
                .resolutionNotes(condition.getResolutionNotes())
                .build();
    }

    public StallCondition toDomain(StallConditionDocument document) {
        if (document == null) {
            return null;
        }

        StallCondition condition = StallCondition.builder()
                .id(document.getId())
                .leagueId(document.getLeagueId())
                .type(StallConditionType.fromCode(document.getType()))
                .description(document.getDescription())
                .stallStartedAt(document.getStallStartedAt())
                .affectedPlayerIds(document.getAffectedPlayerIds() != null ?
                        document.getAffectedPlayerIds() : new HashSet<>())
                .diagnosticData(document.getDiagnosticData() != null ?
                        document.getDiagnosticData() : new HashMap<>())
                .build();

        // Reconstitute resolution state
        if (document.isResolved()) {
            CuratorActionType resolutionAction = document.getResolutionAction() != null ?
                    CuratorActionType.fromCode(document.getResolutionAction()) : null;
            condition.resolve(resolutionAction, document.getResolutionNotes());
        }

        return condition;
    }
}
