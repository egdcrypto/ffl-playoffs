package com.ffl.playoffs.infrastructure.persistence.mongodb.repository;

import com.ffl.playoffs.infrastructure.persistence.mongodb.document.PerformanceDashboardDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for PerformanceDashboardDocument.
 */
@Repository
public interface MongoPerformanceDashboardRepository extends MongoRepository<PerformanceDashboardDocument, String> {

    List<PerformanceDashboardDocument> findByOwnerId(String ownerId);

    Optional<PerformanceDashboardDocument> findByOwnerIdAndIsDefaultTrue(String ownerId);

    List<PerformanceDashboardDocument> findByIsSharedTrue();

    @Query("{ '$or': [ { 'ownerId': ?0 }, { 'isShared': true } ] }")
    List<PerformanceDashboardDocument> findAccessibleByUserId(String userId);

    boolean existsByNameAndOwnerId(String name, String ownerId);
}
