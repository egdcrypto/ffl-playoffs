package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.aggregate.EraProfile;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.EraProfileDocument;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * Mapper to convert between EraProfile domain model and EraProfileDocument.
 * Infrastructure layer - handles bidirectional conversion.
 */
@Component
public class EraProfileMapper {

    /**
     * Converts EraProfile domain entity to EraProfileDocument
     * @param eraProfile the domain entity
     * @return the MongoDB document
     */
    public EraProfileDocument toDocument(EraProfile eraProfile) {
        if (eraProfile == null) {
            return null;
        }

        EraProfileDocument document = new EraProfileDocument();
        document.setId(eraProfile.getId() != null ? eraProfile.getId().toString() : null);
        document.setName(eraProfile.getName());
        document.setDescription(eraProfile.getDescription());
        document.setWorldId(eraProfile.getWorldId() != null ? eraProfile.getWorldId().toString() : null);
        document.setStartYear(eraProfile.getStartYear());
        document.setEndYear(eraProfile.getEndYear());
        document.setTimePeriodLabel(eraProfile.getTimePeriodLabel());
        document.setTechnologyLevel(eraProfile.getTechnologyLevel() != null ?
            eraProfile.getTechnologyLevel().name() : null);
        document.setStatus(eraProfile.getStatus() != null ? eraProfile.getStatus().name() : null);
        document.setIsLocked(eraProfile.getIsLocked());
        document.setLockedAt(eraProfile.getLockedAt());
        document.setLockReason(eraProfile.getLockReason());
        document.setTechnologyApproved(eraProfile.getTechnologyApproved());
        document.setCharactersValidated(eraProfile.getCharactersValidated());
        document.setObjectsValidated(eraProfile.getObjectsValidated());
        document.setLocationsValidated(eraProfile.getLocationsValidated());
        document.setConflictsResolved(eraProfile.getConflictsResolved());
        document.setCreatedAt(eraProfile.getCreatedAt());
        document.setUpdatedAt(eraProfile.getUpdatedAt());
        document.setCreatedBy(eraProfile.getCreatedBy() != null ?
            eraProfile.getCreatedBy().toString() : null);

        return document;
    }

    /**
     * Converts EraProfileDocument to EraProfile domain entity
     * @param document the MongoDB document
     * @return the domain entity
     */
    public EraProfile toDomain(EraProfileDocument document) {
        if (document == null) {
            return null;
        }

        EraProfile eraProfile = new EraProfile();
        eraProfile.setId(document.getId() != null ? UUID.fromString(document.getId()) : null);
        eraProfile.setName(document.getName());
        eraProfile.setDescription(document.getDescription());
        eraProfile.setWorldId(document.getWorldId() != null ? UUID.fromString(document.getWorldId()) : null);
        eraProfile.setStartYear(document.getStartYear());
        eraProfile.setEndYear(document.getEndYear());
        eraProfile.setTimePeriodLabel(document.getTimePeriodLabel());
        eraProfile.setTechnologyLevel(document.getTechnologyLevel() != null ?
            EraProfile.TechnologyLevel.valueOf(document.getTechnologyLevel()) : null);
        eraProfile.setStatus(document.getStatus() != null ?
            EraProfile.EraStatus.valueOf(document.getStatus()) : null);
        eraProfile.setIsLocked(document.getIsLocked());
        eraProfile.setLockedAt(document.getLockedAt());
        eraProfile.setLockReason(document.getLockReason());
        eraProfile.setTechnologyApproved(document.getTechnologyApproved());
        eraProfile.setCharactersValidated(document.getCharactersValidated());
        eraProfile.setObjectsValidated(document.getObjectsValidated());
        eraProfile.setLocationsValidated(document.getLocationsValidated());
        eraProfile.setConflictsResolved(document.getConflictsResolved());
        eraProfile.setCreatedAt(document.getCreatedAt());
        eraProfile.setUpdatedAt(document.getUpdatedAt());
        eraProfile.setCreatedBy(document.getCreatedBy() != null ?
            UUID.fromString(document.getCreatedBy()) : null);

        return eraProfile;
    }
}
