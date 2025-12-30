package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.narrative.AIDirector;
import com.ffl.playoffs.domain.model.narrative.CuratorActionType;
import com.ffl.playoffs.domain.model.narrative.StallCondition;
import com.ffl.playoffs.domain.model.narrative.StallConditionType;
import com.ffl.playoffs.domain.port.AIDirectorRepository;
import com.ffl.playoffs.domain.port.StallConditionRepository;
import com.ffl.playoffs.domain.port.StoryBeatRepository;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.UUID;

/**
 * Use case for detecting stall conditions in narrative
 */
@RequiredArgsConstructor
public class DetectStallsUseCase {

    private final AIDirectorRepository directorRepository;
    private final StallConditionRepository stallConditionRepository;
    private final StoryBeatRepository storyBeatRepository;

    /**
     * Detect all stall conditions for a league
     * @param leagueId the league ID
     * @return list of detected stall conditions
     */
    public List<StallCondition> detectStalls(UUID leagueId) {
        AIDirector director = findDirector(leagueId);
        List<StallCondition> detectedStalls = new ArrayList<>();

        // Check for narrative gap
        StallCondition narrativeGap = checkNarrativeGap(leagueId, director);
        if (narrativeGap != null) {
            detectedStalls.add(narrativeGap);
        }

        // Check for engagement drop (based on tension)
        StallCondition engagementDrop = checkEngagementDrop(leagueId, director);
        if (engagementDrop != null) {
            detectedStalls.add(engagementDrop);
        }

        // Register detected stalls with the director
        for (StallCondition stall : detectedStalls) {
            StallCondition saved = stallConditionRepository.save(stall);
            director.registerStallCondition(saved.getId());
        }

        if (!detectedStalls.isEmpty()) {
            directorRepository.save(director);
        }

        return detectedStalls;
    }

    /**
     * Detect a specific type of stall condition
     * @param command the detection command
     * @return the detected stall condition, or null if none detected
     */
    public StallCondition detectSpecificStall(DetectStallCommand command) {
        AIDirector director = findDirector(command.getLeagueId());

        StallCondition stall = StallCondition.builder()
                .leagueId(command.getLeagueId())
                .type(command.getType())
                .stallStartedAt(command.getStallStartedAt())
                .description(command.getDescription())
                .affectedPlayerIds(command.getAffectedPlayerIds())
                .build();

        stall = stallConditionRepository.save(stall);
        director.registerStallCondition(stall.getId());
        directorRepository.save(director);

        return stall;
    }

    /**
     * Resolve a stall condition
     * @param command the resolution command
     * @return the resolved stall condition
     */
    public StallCondition resolveStall(ResolveStallCommand command) {
        StallCondition stall = stallConditionRepository.findById(command.getStallConditionId())
                .orElseThrow(() -> new IllegalArgumentException("Stall condition not found: " + command.getStallConditionId()));

        stall.resolve(command.getResolutionAction(), command.getNotes());
        stall = stallConditionRepository.save(stall);

        AIDirector director = findDirector(stall.getLeagueId());
        director.resolveStallCondition(stall.getId());
        directorRepository.save(director);

        return stall;
    }

    /**
     * Get all active stall conditions for a league
     * @param leagueId the league ID
     * @return list of active stall conditions
     */
    public List<StallCondition> getActiveStalls(UUID leagueId) {
        return stallConditionRepository.findActiveByLeagueId(leagueId);
    }

    /**
     * Get stall conditions requiring immediate attention
     * @param leagueId the league ID
     * @return list of urgent stall conditions
     */
    public List<StallCondition> getUrgentStalls(UUID leagueId) {
        return stallConditionRepository.findRequiringImmediateAttention(leagueId);
    }

    private StallCondition checkNarrativeGap(UUID leagueId, AIDirector director) {
        int thresholdHours = director.getStallDetectionThresholdHours();
        Instant threshold = Instant.now().minus(thresholdHours, ChronoUnit.HOURS);

        long recentBeats = storyBeatRepository.findByLeagueIdAndOccurredAfter(leagueId, threshold).size();

        if (recentBeats == 0) {
            return StallCondition.detect(
                    leagueId,
                    StallConditionType.NARRATIVE_GAP,
                    Instant.now().minus(thresholdHours, ChronoUnit.HOURS),
                    "No story beats generated in the last " + thresholdHours + " hours"
            );
        }
        return null;
    }

    private StallCondition checkEngagementDrop(UUID leagueId, AIDirector director) {
        if (director.isTensionLow() && director.isInactive()) {
            return StallCondition.detect(
                    leagueId,
                    StallConditionType.ENGAGEMENT_DROP,
                    director.getLastActivityAt(),
                    "Low tension and no director activity detected"
            );
        }
        return null;
    }

    private AIDirector findDirector(UUID leagueId) {
        return directorRepository.findByLeagueId(leagueId)
                .orElseThrow(() -> new IllegalArgumentException("AI Director not found for league: " + leagueId));
    }

    @Getter
    @RequiredArgsConstructor
    public static class DetectStallCommand {
        private final UUID leagueId;
        private final StallConditionType type;
        private final Instant stallStartedAt;
        private final String description;
        private final Set<UUID> affectedPlayerIds;
    }

    @Getter
    @RequiredArgsConstructor
    public static class ResolveStallCommand {
        private final UUID stallConditionId;
        private final CuratorActionType resolutionAction;
        private final String notes;
    }
}
