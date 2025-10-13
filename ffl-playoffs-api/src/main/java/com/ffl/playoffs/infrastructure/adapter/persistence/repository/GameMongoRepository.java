package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.GameDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

/**
 * Spring Data MongoDB repository for Game documents
 * Infrastructure layer
 */
@Repository
public interface GameMongoRepository extends MongoRepository<GameDocument, UUID> {

    Optional<GameDocument> findByCode(String code);
}
