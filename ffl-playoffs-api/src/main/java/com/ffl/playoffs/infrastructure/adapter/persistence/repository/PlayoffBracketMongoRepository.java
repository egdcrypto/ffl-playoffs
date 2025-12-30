package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.PlayoffBracketDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for PlayoffBracket documents
 */
@Repository
public interface PlayoffBracketMongoRepository extends MongoRepository<PlayoffBracketDocument, String> {

    /**
     * Find bracket by league ID
     */
    Optional<PlayoffBracketDocument> findByLeagueId(String leagueId);

    /**
     * Find all active brackets (not complete)
     */
    List<PlayoffBracketDocument> findByIsCompleteFalse();

    /**
     * Check if bracket exists for a league
     */
    boolean existsByLeagueId(String leagueId);
}
