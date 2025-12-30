package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.WeatherZoneDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for WeatherZoneDocument.
 */
@Repository
public interface WeatherZoneMongoRepository extends MongoRepository<WeatherZoneDocument, String> {

    /**
     * Find weather zone by unique code.
     */
    Optional<WeatherZoneDocument> findByCode(String code);

    /**
     * Find weather zones by climate type.
     */
    List<WeatherZoneDocument> findByClimateType(String climateType);

    /**
     * Check if weather zone exists.
     */
    boolean existsByCode(String code);

    /**
     * Delete by code.
     */
    void deleteByCode(String code);
}
