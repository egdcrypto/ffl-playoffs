package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.LoadTestScenarioDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Spring Data MongoDB repository for LoadTestScenarioDocument.
 */
@Repository
public interface LoadTestScenarioMongoRepository extends MongoRepository<LoadTestScenarioDocument, String> {

    List<LoadTestScenarioDocument> findByWorldId(String worldId);

    List<LoadTestScenarioDocument> findByWorldIdAndEnabled(String worldId, boolean enabled);

    List<LoadTestScenarioDocument> findByTestType(String testType);

    List<LoadTestScenarioDocument> findByTagsContaining(String tag);
}
