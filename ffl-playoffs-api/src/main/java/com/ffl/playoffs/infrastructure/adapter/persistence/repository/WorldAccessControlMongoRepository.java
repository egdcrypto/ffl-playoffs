package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.WorldAccessControlDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface WorldAccessControlMongoRepository extends MongoRepository<WorldAccessControlDocument, String> {

    Optional<WorldAccessControlDocument> findByWorldId(String worldId);

    List<WorldAccessControlDocument> findByOwnerId(String ownerId);

    @Query("{ 'members.userId': ?0 }")
    List<WorldAccessControlDocument> findByMemberId(String userId);

    @Query("{ 'members': { $elemMatch: { 'userId': ?0, 'status': 'active' } } }")
    List<WorldAccessControlDocument> findByActiveMemberId(String userId);

    @Query("{ 'isPublic': true }")
    List<WorldAccessControlDocument> findPublicWorlds();

    @Query("{ 'members': { $elemMatch: { 'userId': ?0, 'status': 'pending' } } }")
    List<WorldAccessControlDocument> findWithPendingInvitationForUser(String userId);

    void deleteByWorldId(String worldId);

    boolean existsByWorldId(String worldId);
}
