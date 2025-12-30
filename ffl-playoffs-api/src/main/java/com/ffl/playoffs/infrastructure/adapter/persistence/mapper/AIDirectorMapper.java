package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.model.narrative.AIDirector;
import com.ffl.playoffs.domain.model.narrative.NarrativePhase;
import com.ffl.playoffs.domain.model.narrative.TensionLevel;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.AIDirectorDocument;
import org.springframework.stereotype.Component;

import java.util.HashSet;

/**
 * Mapper for AIDirector domain model and document
 */
@Component
public class AIDirectorMapper {

    public AIDirectorDocument toDocument(AIDirector director) {
        if (director == null) {
            return null;
        }

        return AIDirectorDocument.builder()
                .id(director.getId())
                .leagueId(director.getLeagueId())
                .currentPhase(director.getCurrentPhase().getCode())
                .currentTensionLevel(director.getCurrentTensionLevel().getCode())
                .tensionScore(director.getTensionScore())
                .status(director.getStatus().getCode())
                .automationEnabled(director.isAutomationEnabled())
                .createdAt(director.getCreatedAt())
                .updatedAt(director.getUpdatedAt())
                .lastActivityAt(director.getLastActivityAt())
                .activeStoryArcId(director.getActiveStoryArcId())
                .activeStallConditionIds(new HashSet<>(director.getActiveStallConditionIds()))
                .pendingActionIds(new HashSet<>(director.getPendingActionIds()))
                .stallDetectionThresholdHours(director.getStallDetectionThresholdHours())
                .tensionTargetScore(director.getTensionTargetScore())
                .autoGenerateStoryBeats(director.isAutoGenerateStoryBeats())
                .autoResolveStalls(director.isAutoResolveStalls())
                .totalStoryBeatsGenerated(director.getTotalStoryBeatsGenerated())
                .totalStallsDetected(director.getTotalStallsDetected())
                .totalActionsExecuted(director.getTotalActionsExecuted())
                .build();
    }

    public AIDirector toDomain(AIDirectorDocument document) {
        if (document == null) {
            return null;
        }

        return AIDirector.reconstitute(
                document.getId(),
                document.getLeagueId(),
                NarrativePhase.fromCode(document.getCurrentPhase()),
                TensionLevel.fromCode(document.getCurrentTensionLevel()),
                document.getTensionScore(),
                AIDirector.DirectorStatus.fromCode(document.getStatus()),
                document.isAutomationEnabled(),
                document.getCreatedAt(),
                document.getUpdatedAt(),
                document.getLastActivityAt(),
                document.getActiveStoryArcId(),
                document.getActiveStallConditionIds() != null ? document.getActiveStallConditionIds() : new HashSet<>(),
                document.getPendingActionIds() != null ? document.getPendingActionIds() : new HashSet<>(),
                document.getStallDetectionThresholdHours(),
                document.getTensionTargetScore(),
                document.isAutoGenerateStoryBeats(),
                document.isAutoResolveStalls(),
                document.getTotalStoryBeatsGenerated(),
                document.getTotalStallsDetected(),
                document.getTotalActionsExecuted()
        );
    }
}
