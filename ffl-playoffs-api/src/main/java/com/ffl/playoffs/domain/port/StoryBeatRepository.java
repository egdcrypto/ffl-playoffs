package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.narrative.NarrativePhase;
import com.ffl.playoffs.domain.model.narrative.StoryBeat;
import com.ffl.playoffs.domain.model.narrative.StoryBeatType;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository port for Story Beat persistence
 */
public interface StoryBeatRepository {

    /**
     * Save a story beat
     */
    StoryBeat save(StoryBeat beat);

    /**
     * Find a story beat by ID
     */
    Optional<StoryBeat> findById(UUID id);

    /**
     * Find all story beats for a league
     */
    List<StoryBeat> findByLeagueId(UUID leagueId);

    /**
     * Find story beats for a story arc
     */
    List<StoryBeat> findByStoryArcId(UUID storyArcId);

    /**
     * Find story beats by type
     */
    List<StoryBeat> findByLeagueIdAndType(UUID leagueId, StoryBeatType type);

    /**
     * Find story beats by phase
     */
    List<StoryBeat> findByLeagueIdAndPhase(UUID leagueId, NarrativePhase phase);

    /**
     * Find story beats involving a player
     */
    List<StoryBeat> findByLeagueIdAndInvolvedPlayerId(UUID leagueId, UUID playerId);

    /**
     * Find story beats for a week
     */
    List<StoryBeat> findByLeagueIdAndWeekNumber(UUID leagueId, Integer weekNumber);

    /**
     * Find published story beats
     */
    List<StoryBeat> findPublishedByLeagueId(UUID leagueId);

    /**
     * Find unpublished story beats
     */
    List<StoryBeat> findUnpublishedByLeagueId(UUID leagueId);

    /**
     * Find root beats (no parents)
     */
    List<StoryBeat> findRootBeatsByLeagueId(UUID leagueId);

    /**
     * Find leaf beats (no children)
     */
    List<StoryBeat> findLeafBeatsByLeagueId(UUID leagueId);

    /**
     * Find recent story beats
     */
    List<StoryBeat> findRecentByLeagueId(UUID leagueId, int limit);

    /**
     * Find story beats since a given time
     */
    List<StoryBeat> findByLeagueIdAndOccurredAfter(UUID leagueId, Instant since);

    /**
     * Count story beats for a league
     */
    long countByLeagueId(UUID leagueId);

    /**
     * Count story beats by type for a league
     */
    long countByLeagueIdAndType(UUID leagueId, StoryBeatType type);

    /**
     * Delete a story beat
     */
    void delete(UUID id);

    /**
     * Delete all story beats for a league
     */
    void deleteByLeagueId(UUID leagueId);
}
