package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.StoryBeatDocument;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

/**
 * Spring Data MongoDB repository for Story Beat
 */
@Repository
public interface StoryBeatMongoRepository extends MongoRepository<StoryBeatDocument, UUID> {

    List<StoryBeatDocument> findByLeagueId(UUID leagueId);

    List<StoryBeatDocument> findByStoryArcId(UUID storyArcId);

    List<StoryBeatDocument> findByLeagueIdAndType(UUID leagueId, String type);

    List<StoryBeatDocument> findByLeagueIdAndPhase(UUID leagueId, String phase);

    @Query("{ 'leagueId': ?0, 'involvedPlayerIds': ?1 }")
    List<StoryBeatDocument> findByLeagueIdAndInvolvedPlayerId(UUID leagueId, UUID playerId);

    List<StoryBeatDocument> findByLeagueIdAndWeekNumber(UUID leagueId, Integer weekNumber);

    List<StoryBeatDocument> findByLeagueIdAndPublishedTrue(UUID leagueId);

    List<StoryBeatDocument> findByLeagueIdAndPublishedFalse(UUID leagueId);

    @Query("{ 'leagueId': ?0, 'parentBeatIds': { $size: 0 } }")
    List<StoryBeatDocument> findRootBeatsByLeagueId(UUID leagueId);

    @Query("{ 'leagueId': ?0, 'childBeatIds': { $size: 0 } }")
    List<StoryBeatDocument> findLeafBeatsByLeagueId(UUID leagueId);

    List<StoryBeatDocument> findByLeagueIdOrderByOccurredAtDesc(UUID leagueId, Pageable pageable);

    List<StoryBeatDocument> findByLeagueIdAndOccurredAtAfter(UUID leagueId, Instant since);

    long countByLeagueId(UUID leagueId);

    long countByLeagueIdAndType(UUID leagueId, String type);

    void deleteByLeagueId(UUID leagueId);
}
