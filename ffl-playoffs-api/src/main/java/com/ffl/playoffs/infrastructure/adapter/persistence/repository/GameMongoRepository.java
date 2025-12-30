package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.GameDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Spring Data MongoDB repository for Game documents
 * Infrastructure layer
 */
@Repository
public interface GameMongoRepository extends MongoRepository<GameDocument, UUID> {

    Optional<GameDocument> findByCode(String code);

    boolean existsByCode(String code);

    /**
     * Find games where a player is participating
     * @param playerId the player's ID
     * @return list of games containing the player
     */
    @Query("{ 'players.id': ?0 }")
    List<GameDocument> findByPlayerId(UUID playerId);
}
