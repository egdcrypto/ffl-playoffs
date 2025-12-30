package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.WorldLoadTestDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for WorldLoadTestDocument.
 */
@Repository
public interface WorldLoadTestMongoRepository extends MongoRepository<WorldLoadTestDocument, String> {

    Optional<WorldLoadTestDocument> findByWorldId(String worldId);

    List<WorldLoadTestDocument> findByOverallStatus(String status);

    boolean existsByWorldId(String worldId);

    void deleteByWorldId(String worldId);
}
