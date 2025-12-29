package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.EventScenarioDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Spring Data MongoDB repository for EventScenarioDocument.
 * Infrastructure layer - MongoDB specific.
 */
@Repository
public interface EventScenarioMongoRepository extends MongoRepository<EventScenarioDocument, String> {

    /**
     * Find scenarios by type
     */
    List<EventScenarioDocument> findByType(String type);

    /**
     * Find scenarios by tag
     */
    List<EventScenarioDocument> findByTagsContaining(String tag);

    /**
     * Find scenarios by author
     */
    List<EventScenarioDocument> findByAuthorId(String authorId);

    /**
     * Find scenarios by historical season
     */
    List<EventScenarioDocument> findByHistoricalSeason(Integer season);
}
