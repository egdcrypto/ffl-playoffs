package com.ffl.playoffs.infrastructure.persistence.mongodb.repository;

import com.ffl.playoffs.infrastructure.persistence.mongodb.document.NFLTeamDocument;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for NFL Team documents
 * Provides access to the 'nfl_teams' collection
 */
@Repository
public interface MongoNFLTeamRepository extends MongoRepository<NFLTeamDocument, String> {

    /**
     * Find a team by its team ID
     * @param teamId the team ID
     * @return Optional containing the team if found
     */
    Optional<NFLTeamDocument> findByTeamId(String teamId);

    /**
     * Find a team by its abbreviation
     * @param abbreviation the team abbreviation (e.g., "KC")
     * @return Optional containing the team if found
     */
    Optional<NFLTeamDocument> findByAbbreviation(String abbreviation);

    /**
     * Find all teams in a conference
     * @param conference the conference ("AFC" or "NFC")
     * @return list of teams in that conference
     */
    List<NFLTeamDocument> findByConference(String conference);

    /**
     * Find all teams in a conference with pagination
     * @param conference the conference ("AFC" or "NFC")
     * @param pageable pagination info
     * @return page of teams in that conference
     */
    Page<NFLTeamDocument> findByConference(String conference, Pageable pageable);

    /**
     * Find all teams in a division
     * @param conference the conference
     * @param division the division
     * @return list of teams in that division
     */
    List<NFLTeamDocument> findByConferenceAndDivision(String conference, String division);

    /**
     * Check if a team exists by abbreviation
     * @param abbreviation the team abbreviation
     * @return true if the team exists
     */
    boolean existsByAbbreviation(String abbreviation);
}
