package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.StadiumDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for StadiumDocument.
 */
@Repository
public interface StadiumMongoRepository extends MongoRepository<StadiumDocument, String> {

    /**
     * Find stadium by unique code.
     */
    Optional<StadiumDocument> findByCode(String code);

    /**
     * Find stadium by primary team abbreviation.
     */
    Optional<StadiumDocument> findByPrimaryTeamAbbreviation(String teamAbbreviation);

    /**
     * Find stadiums where team is in tenant list.
     */
    List<StadiumDocument> findByTenantTeamsContaining(String teamAbbreviation);

    /**
     * Find all stadiums of a specific venue type.
     */
    List<StadiumDocument> findByVenueType(String venueType);

    /**
     * Find all stadiums in a weather zone.
     */
    List<StadiumDocument> findByWeatherZoneCode(String weatherZoneCode);

    /**
     * Find all active stadiums.
     */
    List<StadiumDocument> findByIsActiveTrue();

    /**
     * Check if stadium exists for a team.
     */
    boolean existsByPrimaryTeamAbbreviation(String teamAbbreviation);
}
