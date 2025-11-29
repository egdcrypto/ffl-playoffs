package com.ffl.playoffs.infrastructure.persistence.mongodb.repository;

import com.ffl.playoffs.infrastructure.persistence.mongodb.document.ScoringConfigurationDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for Scoring Configuration documents
 */
@Repository
public interface MongoScoringConfigurationRepository extends MongoRepository<ScoringConfigurationDocument, String> {

    /**
     * Find active scoring configuration for a league and season
     */
    Optional<ScoringConfigurationDocument> findByLeagueIdAndSeasonAndActiveTrue(Long leagueId, Integer season);

    /**
     * Find all configurations for a league
     */
    List<ScoringConfigurationDocument> findByLeagueId(Long leagueId);

    /**
     * Find all active configurations for a league
     */
    List<ScoringConfigurationDocument> findByLeagueIdAndActiveTrue(Long leagueId);

    /**
     * Check if an active configuration exists for a league and season
     */
    boolean existsByLeagueIdAndSeasonAndActiveTrue(Long leagueId, Integer season);
}
