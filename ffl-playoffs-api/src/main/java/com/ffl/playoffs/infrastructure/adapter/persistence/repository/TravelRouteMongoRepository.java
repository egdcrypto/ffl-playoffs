package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.TravelRouteDocument;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for TravelRouteDocument.
 */
@Repository
public interface TravelRouteMongoRepository extends MongoRepository<TravelRouteDocument, String> {

    /**
     * Find route between two stadiums.
     */
    Optional<TravelRouteDocument> findByOriginCodeAndDestinationCode(
            String originCode,
            String destinationCode
    );

    /**
     * Find all routes from an origin.
     */
    List<TravelRouteDocument> findByOriginCode(String originCode);

    /**
     * Find all routes to a destination.
     */
    List<TravelRouteDocument> findByDestinationCode(String destinationCode);

    /**
     * Find routes by fatigue level.
     */
    List<TravelRouteDocument> findByFatigueLevel(String fatigueLevel);

    /**
     * Check if route exists.
     */
    boolean existsByOriginCodeAndDestinationCode(String originCode, String destinationCode);

    /**
     * Delete route.
     */
    void deleteByOriginCodeAndDestinationCode(String originCode, String destinationCode);

    /**
     * Find all routes sorted by distance descending.
     */
    List<TravelRouteDocument> findAll(Sort sort);
}
