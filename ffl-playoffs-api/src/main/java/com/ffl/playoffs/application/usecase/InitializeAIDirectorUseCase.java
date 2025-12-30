package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.narrative.AIDirector;
import com.ffl.playoffs.domain.model.narrative.NarrativePhase;
import com.ffl.playoffs.domain.model.narrative.StoryArc;
import com.ffl.playoffs.domain.model.narrative.StoryBeat;
import com.ffl.playoffs.domain.model.narrative.StoryBeatType;
import com.ffl.playoffs.domain.port.AIDirectorRepository;
import com.ffl.playoffs.domain.port.StoryArcRepository;
import com.ffl.playoffs.domain.port.StoryBeatRepository;
import lombok.RequiredArgsConstructor;

import java.util.UUID;

/**
 * Use case for initializing an AI Director for a league
 */
@RequiredArgsConstructor
public class InitializeAIDirectorUseCase {

    private final AIDirectorRepository directorRepository;
    private final StoryArcRepository storyArcRepository;
    private final StoryBeatRepository storyBeatRepository;

    /**
     * Initialize an AI Director for a league
     * @param leagueId the league ID
     * @return the initialized AI Director
     * @throws IllegalStateException if director already exists for the league
     */
    public AIDirector execute(UUID leagueId) {
        if (directorRepository.existsByLeagueId(leagueId)) {
            throw new IllegalStateException("AI Director already exists for league: " + leagueId);
        }

        // Create the AI Director
        AIDirector director = AIDirector.create(leagueId);

        // Create the initial story arc
        StoryArc arc = StoryArc.create(leagueId, "Season Story", "The main narrative arc for this season");
        arc = storyArcRepository.save(arc);

        // Create the opening story beat
        StoryBeat openingBeat = StoryBeat.builder()
                .leagueId(leagueId)
                .type(StoryBeatType.SEASON_START)
                .title("The Season Begins")
                .description("A new season of fantasy football competition begins")
                .phase(NarrativePhase.SETUP)
                .storyArcId(arc.getId())
                .build();

        openingBeat = storyBeatRepository.save(openingBeat);

        // Link the beat to the arc
        arc.addBeat(openingBeat);
        storyArcRepository.save(arc);

        // Set the active story arc and record the beat
        director.setActiveStoryArc(arc.getId());
        director.recordStoryBeatGenerated();

        return directorRepository.save(director);
    }

    /**
     * Get or initialize an AI Director for a league
     * @param leagueId the league ID
     * @return the AI Director
     */
    public AIDirector getOrInitialize(UUID leagueId) {
        return directorRepository.findByLeagueId(leagueId)
                .orElseGet(() -> execute(leagueId));
    }
}
