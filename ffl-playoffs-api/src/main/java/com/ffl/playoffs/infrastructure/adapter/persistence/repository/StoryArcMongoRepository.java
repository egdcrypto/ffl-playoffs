package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.StoryArcDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

/**
 * Spring Data MongoDB repository for Story Arc
 */
@Repository
public interface StoryArcMongoRepository extends MongoRepository<StoryArcDocument, UUID> {

    List<StoryArcDocument> findByLeagueId(UUID leagueId);

    List<StoryArcDocument> findByLeagueIdAndStatus(UUID leagueId, String status);

    List<StoryArcDocument> findByLeagueIdAndCurrentPhase(UUID leagueId, String currentPhase);

    @Query("{ 'leagueId': ?0, 'involvedPlayerIds': ?1 }")
    List<StoryArcDocument> findByLeagueIdAndInvolvedPlayerId(UUID leagueId, UUID playerId);

    long countByLeagueIdAndStatus(UUID leagueId, String status);

    void deleteByLeagueId(UUID leagueId);
}
