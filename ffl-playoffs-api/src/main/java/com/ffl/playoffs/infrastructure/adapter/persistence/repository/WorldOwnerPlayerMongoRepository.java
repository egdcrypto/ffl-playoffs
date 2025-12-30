package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.WorldOwnerPlayerDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface WorldOwnerPlayerMongoRepository extends MongoRepository<WorldOwnerPlayerDocument, String> {

    Optional<WorldOwnerPlayerDocument> findByUserIdAndWorldId(String userId, String worldId);

    List<WorldOwnerPlayerDocument> findByWorldId(String worldId);

    @Query("{ 'worldId': ?0, 'status': 'active' }")
    List<WorldOwnerPlayerDocument> findActiveByWorldId(String worldId);

    List<WorldOwnerPlayerDocument> findByWorldIdAndRole(String worldId, String role);

    List<WorldOwnerPlayerDocument> findByWorldIdAndStatus(String worldId, String status);

    List<WorldOwnerPlayerDocument> findByUserId(String userId);

    @Query("{ 'userId': ?0, 'status': 'active' }")
    List<WorldOwnerPlayerDocument> findActiveByUserId(String userId);

    Optional<WorldOwnerPlayerDocument> findByInvitationToken(String token);

    boolean existsByUserIdAndWorldId(String userId, String worldId);

    @Query(value = "{ 'userId': ?0, 'worldId': ?1, 'status': 'active' }", exists = true)
    boolean isActiveOwner(String userId, String worldId);

    @Query(value = "{ 'worldId': ?0, 'status': 'active' }", count = true)
    long countActiveByWorldId(String worldId);

    @Query(value = "{ 'worldId': ?0, 'role': 'primary_owner' }", count = true)
    long countPrimaryOwnersByWorldId(String worldId);

    void deleteByWorldId(String worldId);
}
