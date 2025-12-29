package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.EventTemplateDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Spring Data MongoDB repository for EventTemplateDocument.
 * Infrastructure layer - MongoDB specific.
 */
@Repository
public interface EventTemplateMongoRepository extends MongoRepository<EventTemplateDocument, String> {

    /**
     * Find templates by event type
     */
    List<EventTemplateDocument> findByEventType(String eventType);

    /**
     * Find templates by category
     */
    List<EventTemplateDocument> findByCategory(String category);

    /**
     * Find templates by name containing
     */
    List<EventTemplateDocument> findByNameContainingIgnoreCase(String name);
}
