package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.narrative.*;
import com.ffl.playoffs.domain.port.AIDirectorRepository;
import com.ffl.playoffs.domain.port.StoryArcRepository;
import com.ffl.playoffs.domain.port.StoryBeatRepository;
import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.time.Instant;
import java.util.*;

/**
 * Use case for creating story beats in the narrative DAG
 */
@RequiredArgsConstructor
public class CreateStoryBeatUseCase {

    private final AIDirectorRepository directorRepository;
    private final StoryBeatRepository storyBeatRepository;
    private final StoryArcRepository storyArcRepository;

    /**
     * Create a new story beat
     * @param command the creation command
     * @return the created story beat
     */
    public StoryBeat execute(CreateStoryBeatCommand command) {
        AIDirector director = findDirector(command.getLeagueId());

        // Build the story beat
        StoryBeat beat = StoryBeat.builder()
                .leagueId(command.getLeagueId())
                .type(command.getType())
                .title(command.getTitle())
                .description(command.getDescription())
                .phase(director.getCurrentPhase())
                .tensionImpact(command.getTensionImpact() != null ?
                        command.getTensionImpact() : command.getType().getTensionImpact())
                .occurredAt(command.getOccurredAt() != null ? command.getOccurredAt() : Instant.now())
                .parentBeatIds(command.getParentBeatIds())
                .storyArcId(command.getStoryArcId() != null ?
                        command.getStoryArcId() : director.getActiveStoryArcId())
                .weekNumber(command.getWeekNumber())
                .involvedPlayerIds(command.getInvolvedPlayerIds())
                .metadata(command.getMetadata())
                .build();

        final StoryBeat savedBeat = storyBeatRepository.save(beat);

        // Link to parent beats
        for (UUID parentId : command.getParentBeatIds()) {
            storyBeatRepository.findById(parentId).ifPresent(parent -> {
                parent.addChild(savedBeat.getId());
                storyBeatRepository.save(parent);
            });
        }

        // Add to story arc if applicable
        if (savedBeat.getStoryArcId() != null) {
            storyArcRepository.findById(savedBeat.getStoryArcId()).ifPresent(arc -> {
                arc.addBeat(savedBeat);
                storyArcRepository.save(arc);
            });
        }

        // Apply tension impact and record the beat
        director.applyTensionImpact(savedBeat.getTensionImpact());
        director.recordStoryBeatGenerated();
        directorRepository.save(director);

        return savedBeat;
    }

    /**
     * Publish a story beat to players
     * @param beatId the beat ID
     * @return the published story beat
     */
    public StoryBeat publishBeat(UUID beatId) {
        StoryBeat beat = storyBeatRepository.findById(beatId)
                .orElseThrow(() -> new IllegalArgumentException("Story beat not found: " + beatId));

        beat.publish();
        return storyBeatRepository.save(beat);
    }

    /**
     * Get story beats for a league
     * @param leagueId the league ID
     * @return list of story beats
     */
    public List<StoryBeat> getBeatsForLeague(UUID leagueId) {
        return storyBeatRepository.findByLeagueId(leagueId);
    }

    /**
     * Get recent story beats for a league
     * @param leagueId the league ID
     * @param limit max number of beats
     * @return list of recent story beats
     */
    public List<StoryBeat> getRecentBeats(UUID leagueId, int limit) {
        return storyBeatRepository.findRecentByLeagueId(leagueId, limit);
    }

    /**
     * Get story beats involving a player
     * @param leagueId the league ID
     * @param playerId the player ID
     * @return list of story beats
     */
    public List<StoryBeat> getBeatsForPlayer(UUID leagueId, UUID playerId) {
        return storyBeatRepository.findByLeagueIdAndInvolvedPlayerId(leagueId, playerId);
    }

    private AIDirector findDirector(UUID leagueId) {
        return directorRepository.findByLeagueId(leagueId)
                .orElseThrow(() -> new IllegalArgumentException("AI Director not found for league: " + leagueId));
    }

    @Getter
    @Builder
    public static class CreateStoryBeatCommand {
        private final UUID leagueId;
        private final StoryBeatType type;
        private final String title;
        private final String description;
        private final Integer tensionImpact;
        private final Instant occurredAt;
        @Builder.Default
        private final Set<UUID> parentBeatIds = new HashSet<>();
        private final UUID storyArcId;
        private final Integer weekNumber;
        @Builder.Default
        private final Set<UUID> involvedPlayerIds = new HashSet<>();
        @Builder.Default
        private final Map<String, Object> metadata = new HashMap<>();
    }
}
