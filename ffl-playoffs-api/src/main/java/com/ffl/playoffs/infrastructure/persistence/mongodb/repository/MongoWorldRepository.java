package com.ffl.playoffs.infrastructure.persistence.mongodb.repository;

import com.ffl.playoffs.infrastructure.persistence.mongodb.document.WorldDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for World documents
 */
@Repository
public interface MongoWorldRepository extends MongoRepository<WorldDocument, String> {

    /**
     * Find world by name
     * @param name the world name
     * @return Optional containing the world if found
     */
    Optional<WorldDocument> findByName(String name);

    /**
     * Find worlds by status
     * @param status the world status
     * @return list of matching worlds
     */
    List<WorldDocument> findByStatus(String status);

    /**
     * Find worlds by season
     * @param season the NFL season year
     * @return list of matching worlds
     */
    List<WorldDocument> findBySeason(Integer season);

    /**
     * Find worlds by season and status
     * @param season the NFL season year
     * @param status the world status
     * @return list of matching worlds
     */
    List<WorldDocument> findBySeasonAndStatus(Integer season, String status);

    /**
     * Find worlds by creator
     * @param createdBy the creator user ID
     * @return list of matching worlds
     */
    List<WorldDocument> findByCreatedBy(String createdBy);

    /**
     * Find world containing a league
     * @param leagueId the league ID
     * @return Optional containing the world if found
     */
    @Query("{'league_ids': ?0}")
    Optional<WorldDocument> findByLeagueIdsContaining(String leagueId);

    /**
     * Check if world name exists
     * @param name the world name
     * @return true if exists
     */
    boolean existsByName(String name);

    /**
     * Check if world exists for season
     * @param season the season year
     * @return true if exists
     */
    boolean existsBySeason(Integer season);

    /**
     * Count worlds by status
     * @param status the world status
     * @return count
     */
    long countByStatus(String status);
}
