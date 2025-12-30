package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.aggregate.Stadium;
import com.ffl.playoffs.domain.model.Address;
import com.ffl.playoffs.domain.model.GeoCoordinates;
import com.ffl.playoffs.domain.model.SurfaceType;
import com.ffl.playoffs.domain.model.VenueType;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.StadiumDocument;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.UUID;

/**
 * Mapper to convert between Stadium domain model and StadiumDocument.
 */
@Component
public class StadiumMapper {

    /**
     * Converts Stadium domain entity to StadiumDocument.
     */
    public StadiumDocument toDocument(Stadium stadium) {
        if (stadium == null) {
            return null;
        }

        StadiumDocument document = new StadiumDocument();
        document.setId(stadium.getId() != null ? stadium.getId().toString() : null);
        document.setName(stadium.getName());
        document.setCode(stadium.getCode());
        document.setPrimaryTeamAbbreviation(stadium.getPrimaryTeamAbbreviation());
        document.setTenantTeams(stadium.getTenantTeams() != null ? new ArrayList<>(stadium.getTenantTeams()) : null);
        document.setTimeZone(stadium.getTimeZone());
        document.setWeatherZoneCode(stadium.getWeatherZoneCode());
        document.setVenueType(stadium.getVenueType() != null ? stadium.getVenueType().name() : null);
        document.setSurfaceType(stadium.getSurfaceType() != null ? stadium.getSurfaceType().name() : null);
        document.setCapacity(stadium.getCapacity());
        document.setElevation(stadium.getElevation());
        document.setHomeFieldAdvantage(stadium.getHomeFieldAdvantage());
        document.setNoiseFactor(stadium.getNoiseFactor());
        document.setWeatherExposure(stadium.getWeatherExposure());
        document.setOpenedYear(stadium.getOpenedYear());
        document.setIsActive(stadium.getIsActive());
        document.setUpdatedAt(stadium.getUpdatedAt());

        if (stadium.getCoordinates() != null) {
            StadiumDocument.CoordinatesDocument coords = new StadiumDocument.CoordinatesDocument(
                    stadium.getCoordinates().getLatitude(),
                    stadium.getCoordinates().getLongitude()
            );
            document.setCoordinates(coords);
        }

        if (stadium.getAddress() != null) {
            StadiumDocument.AddressDocument addr = new StadiumDocument.AddressDocument();
            addr.setStreet(stadium.getAddress().getStreet());
            addr.setCity(stadium.getAddress().getCity());
            addr.setState(stadium.getAddress().getState());
            addr.setPostalCode(stadium.getAddress().getPostalCode());
            addr.setCountry(stadium.getAddress().getCountry());
            document.setAddress(addr);
        }

        return document;
    }

    /**
     * Converts StadiumDocument to Stadium domain entity.
     */
    public Stadium toDomain(StadiumDocument document) {
        if (document == null) {
            return null;
        }

        Stadium stadium = new Stadium();
        stadium.setId(document.getId() != null ? UUID.fromString(document.getId()) : null);
        stadium.setName(document.getName());
        stadium.setCode(document.getCode());
        stadium.setPrimaryTeamAbbreviation(document.getPrimaryTeamAbbreviation());
        stadium.setTenantTeams(document.getTenantTeams() != null ? new ArrayList<>(document.getTenantTeams()) : null);
        stadium.setTimeZone(document.getTimeZone());
        stadium.setWeatherZoneCode(document.getWeatherZoneCode());
        stadium.setVenueType(document.getVenueType() != null ? VenueType.valueOf(document.getVenueType()) : null);
        stadium.setSurfaceType(document.getSurfaceType() != null ? SurfaceType.valueOf(document.getSurfaceType()) : null);
        stadium.setCapacity(document.getCapacity());
        stadium.setElevation(document.getElevation());
        stadium.setHomeFieldAdvantage(document.getHomeFieldAdvantage());
        stadium.setNoiseFactor(document.getNoiseFactor());
        stadium.setWeatherExposure(document.getWeatherExposure());
        stadium.setOpenedYear(document.getOpenedYear());
        stadium.setIsActive(document.getIsActive());
        stadium.setUpdatedAt(document.getUpdatedAt());

        if (document.getCoordinates() != null) {
            stadium.setCoordinates(GeoCoordinates.of(
                    document.getCoordinates().getLatitude(),
                    document.getCoordinates().getLongitude()
            ));
        }

        if (document.getAddress() != null) {
            StadiumDocument.AddressDocument addr = document.getAddress();
            stadium.setAddress(Address.builder()
                    .street(addr.getStreet())
                    .city(addr.getCity())
                    .state(addr.getState())
                    .postalCode(addr.getPostalCode())
                    .country(addr.getCountry())
                    .build());
        }

        return stadium;
    }
}
