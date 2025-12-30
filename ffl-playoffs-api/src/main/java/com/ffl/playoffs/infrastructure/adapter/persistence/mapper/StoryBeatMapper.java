package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.model.narrative.NarrativePhase;
import com.ffl.playoffs.domain.model.narrative.StoryBeat;
import com.ffl.playoffs.domain.model.narrative.StoryBeatType;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.StoryBeatDocument;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.HashSet;

/**
 * Mapper for StoryBeat domain model and document
 */
@Component
public class StoryBeatMapper {

    public StoryBeatDocument toDocument(StoryBeat beat) {
        if (beat == null) {
            return null;
        }

        return StoryBeatDocument.builder()
                .id(beat.getId())
                .leagueId(beat.getLeagueId())
                .type(beat.getType().getCode())
                .title(beat.getTitle())
                .description(beat.getDescription())
                .phase(beat.getPhase().getCode())
                .tensionImpact(beat.getTensionImpact())
                .occurredAt(beat.getOccurredAt())
                .createdAt(beat.getCreatedAt())
                .parentBeatIds(new HashSet<>(beat.getParentBeatIds()))
                .childBeatIds(new HashSet<>(beat.getChildBeatIds()))
                .storyArcId(beat.getStoryArcId())
                .weekNumber(beat.getWeekNumber())
                .involvedPlayerIds(new HashSet<>(beat.getInvolvedPlayerIds()))
                .metadata(new HashMap<>(beat.getMetadata()))
                .published(beat.isPublished())
                .publishedAt(beat.getPublishedAt())
                .build();
    }

    public StoryBeat toDomain(StoryBeatDocument document) {
        if (document == null) {
            return null;
        }

        StoryBeat beat = StoryBeat.builder()
                .id(document.getId())
                .leagueId(document.getLeagueId())
                .type(StoryBeatType.fromCode(document.getType()))
                .title(document.getTitle())
                .description(document.getDescription())
                .phase(NarrativePhase.fromCode(document.getPhase()))
                .tensionImpact(document.getTensionImpact())
                .occurredAt(document.getOccurredAt())
                .parentBeatIds(document.getParentBeatIds() != null ? document.getParentBeatIds() : new HashSet<>())
                .childBeatIds(document.getChildBeatIds() != null ? document.getChildBeatIds() : new HashSet<>())
                .storyArcId(document.getStoryArcId())
                .weekNumber(document.getWeekNumber())
                .involvedPlayerIds(document.getInvolvedPlayerIds() != null ? document.getInvolvedPlayerIds() : new HashSet<>())
                .metadata(document.getMetadata() != null ? document.getMetadata() : new HashMap<>())
                .build();

        // Reconstitute publication state
        if (document.isPublished()) {
            beat.publish();
        }

        return beat;
    }
}
