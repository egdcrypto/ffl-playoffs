package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.model.narrative.NarrativePhase;
import com.ffl.playoffs.domain.model.narrative.StoryArc;
import com.ffl.playoffs.domain.model.narrative.StoryArcStatus;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.StoryArcDocument;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashSet;

/**
 * Mapper for StoryArc domain model and document
 */
@Component
public class StoryArcMapper {

    public StoryArcDocument toDocument(StoryArc arc) {
        if (arc == null) {
            return null;
        }

        return StoryArcDocument.builder()
                .id(arc.getId())
                .leagueId(arc.getLeagueId())
                .title(arc.getTitle())
                .description(arc.getDescription())
                .status(arc.getStatus().getCode())
                .currentPhase(arc.getCurrentPhase().getCode())
                .createdAt(arc.getCreatedAt())
                .updatedAt(arc.getUpdatedAt())
                .completedAt(arc.getCompletedAt())
                .beatIds(new ArrayList<>(arc.getBeatIds()))
                .involvedPlayerIds(new HashSet<>(arc.getInvolvedPlayerIds()))
                .rootBeatId(arc.getRootBeatId())
                .peakTensionLevel(arc.getPeakTensionLevel())
                .beatCount(arc.getBeatCount())
                .build();
    }

    public StoryArc toDomain(StoryArcDocument document) {
        if (document == null) {
            return null;
        }

        return StoryArc.reconstitute(
                document.getId(),
                document.getLeagueId(),
                document.getTitle(),
                document.getDescription(),
                StoryArcStatus.fromCode(document.getStatus()),
                NarrativePhase.fromCode(document.getCurrentPhase()),
                document.getCreatedAt(),
                document.getUpdatedAt(),
                document.getCompletedAt(),
                document.getBeatIds() != null ? document.getBeatIds() : new ArrayList<>(),
                document.getInvolvedPlayerIds() != null ? document.getInvolvedPlayerIds() : new HashSet<>(),
                document.getRootBeatId(),
                document.getPeakTensionLevel(),
                document.getBeatCount()
        );
    }
}
