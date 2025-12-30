package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.narrative.AIDirector;
import com.ffl.playoffs.domain.model.narrative.NarrativePhase;
import com.ffl.playoffs.domain.model.narrative.TensionLevel;
import com.ffl.playoffs.domain.port.AIDirectorRepository;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.util.UUID;

/**
 * Use case for updating tension levels and narrative phase
 */
@RequiredArgsConstructor
public class UpdateTensionUseCase {

    private final AIDirectorRepository directorRepository;

    /**
     * Update the tension score directly
     * @param command the update command
     * @return the updated AI Director
     */
    public AIDirector updateTensionScore(UpdateTensionCommand command) {
        AIDirector director = findDirector(command.getLeagueId());

        director.updateTension(command.getNewScore());

        return directorRepository.save(director);
    }

    /**
     * Apply tension impact from an event
     * @param command the impact command
     * @return the updated AI Director
     */
    public AIDirector applyTensionImpact(ApplyTensionImpactCommand command) {
        AIDirector director = findDirector(command.getLeagueId());

        director.applyTensionImpact(command.getImpact());

        return directorRepository.save(director);
    }

    /**
     * Advance to the next narrative phase
     * @param leagueId the league ID
     * @return the updated AI Director
     */
    public AIDirector advancePhase(UUID leagueId) {
        AIDirector director = findDirector(leagueId);

        director.advancePhase();

        return directorRepository.save(director);
    }

    /**
     * Override the narrative phase (curator action)
     * @param command the override command
     * @return the updated AI Director
     */
    public AIDirector overridePhase(OverridePhaseCommand command) {
        AIDirector director = findDirector(command.getLeagueId());

        director.overridePhase(command.getNewPhase());

        return directorRepository.save(director);
    }

    /**
     * Adjust tension towards target over time
     * @param leagueId the league ID
     * @return the updated AI Director
     */
    public AIDirector adjustTensionTowardsTarget(UUID leagueId) {
        AIDirector director = findDirector(leagueId);

        director.adjustTensionTowardsTarget();

        return directorRepository.save(director);
    }

    /**
     * Get current tension state
     * @param leagueId the league ID
     * @return tension state
     */
    public TensionState getTensionState(UUID leagueId) {
        AIDirector director = findDirector(leagueId);
        return new TensionState(
                director.getTensionScore(),
                director.getCurrentTensionLevel(),
                director.getCurrentPhase(),
                director.getTensionTargetScore()
        );
    }

    private AIDirector findDirector(UUID leagueId) {
        return directorRepository.findByLeagueId(leagueId)
                .orElseThrow(() -> new IllegalArgumentException("AI Director not found for league: " + leagueId));
    }

    @Getter
    @RequiredArgsConstructor
    public static class UpdateTensionCommand {
        private final UUID leagueId;
        private final int newScore;
    }

    @Getter
    @RequiredArgsConstructor
    public static class ApplyTensionImpactCommand {
        private final UUID leagueId;
        private final int impact;
    }

    @Getter
    @RequiredArgsConstructor
    public static class OverridePhaseCommand {
        private final UUID leagueId;
        private final NarrativePhase newPhase;
    }

    @Getter
    @RequiredArgsConstructor
    public static class TensionState {
        private final int tensionScore;
        private final TensionLevel tensionLevel;
        private final NarrativePhase currentPhase;
        private final int targetScore;
    }
}
