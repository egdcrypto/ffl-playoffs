package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.aggregate.EraProfile;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.EraProfileDocument;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import java.time.LocalDateTime;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for EraProfileMapper (ANIMA-1210)
 */
class EraProfileMapperTest {

    private EraProfileMapper mapper;
    private UUID testId;
    private UUID worldId;
    private UUID createdBy;

    @BeforeEach
    void setUp() {
        mapper = new EraProfileMapper();
        testId = UUID.randomUUID();
        worldId = UUID.randomUUID();
        createdBy = UUID.randomUUID();
    }

    @Test
    @DisplayName("Maps domain to document correctly")
    void mapsDomainToDocumentCorrectly() {
        EraProfile domain = createFullyPopulatedEraProfile();

        EraProfileDocument document = mapper.toDocument(domain);

        assertNotNull(document);
        assertEquals(testId.toString(), document.getId());
        assertEquals("Renaissance Italy", document.getName());
        assertEquals("An era of art and culture", document.getDescription());
        assertEquals(worldId.toString(), document.getWorldId());
        assertEquals(1400, document.getStartYear());
        assertEquals(1600, document.getEndYear());
        assertEquals("Early Modern Period", document.getTimePeriodLabel());
        assertEquals("RENAISSANCE", document.getTechnologyLevel());
        assertEquals("APPROVED", document.getStatus());
        assertFalse(document.getIsLocked());
        assertTrue(document.getTechnologyApproved());
        assertTrue(document.getCharactersValidated());
        assertTrue(document.getObjectsValidated());
        assertTrue(document.getLocationsValidated());
        assertTrue(document.getConflictsResolved());
        assertEquals(createdBy.toString(), document.getCreatedBy());
    }

    @Test
    @DisplayName("Maps document to domain correctly")
    void mapsDocumentToDomainCorrectly() {
        EraProfileDocument document = createFullyPopulatedDocument();

        EraProfile domain = mapper.toDomain(document);

        assertNotNull(domain);
        assertEquals(testId, domain.getId());
        assertEquals("Renaissance Italy", domain.getName());
        assertEquals("An era of art and culture", domain.getDescription());
        assertEquals(worldId, domain.getWorldId());
        assertEquals(1400, domain.getStartYear());
        assertEquals(1600, domain.getEndYear());
        assertEquals("Early Modern Period", domain.getTimePeriodLabel());
        assertEquals(EraProfile.TechnologyLevel.RENAISSANCE, domain.getTechnologyLevel());
        assertEquals(EraProfile.EraStatus.APPROVED, domain.getStatus());
        assertFalse(domain.getIsLocked());
        assertTrue(domain.getTechnologyApproved());
        assertTrue(domain.getCharactersValidated());
        assertTrue(domain.getObjectsValidated());
        assertTrue(domain.getLocationsValidated());
        assertTrue(domain.getConflictsResolved());
        assertEquals(createdBy, domain.getCreatedBy());
    }

    @Test
    @DisplayName("Handles null domain gracefully")
    void handlesNullDomainGracefully() {
        EraProfileDocument document = mapper.toDocument(null);
        assertNull(document);
    }

    @Test
    @DisplayName("Handles null document gracefully")
    void handlesNullDocumentGracefully() {
        EraProfile domain = mapper.toDomain(null);
        assertNull(domain);
    }

    @Test
    @DisplayName("Handles null nested fields in domain")
    void handlesNullNestedFieldsInDomain() {
        EraProfile domain = new EraProfile();
        domain.setId(null);
        domain.setWorldId(null);
        domain.setTechnologyLevel(null);
        domain.setStatus(null);
        domain.setCreatedBy(null);

        EraProfileDocument document = mapper.toDocument(domain);

        assertNotNull(document);
        assertNull(document.getId());
        assertNull(document.getWorldId());
        assertNull(document.getTechnologyLevel());
        assertNull(document.getStatus());
        assertNull(document.getCreatedBy());
    }

    @Test
    @DisplayName("Handles null nested fields in document")
    void handlesNullNestedFieldsInDocument() {
        EraProfileDocument document = new EraProfileDocument();
        document.setId(null);
        document.setWorldId(null);
        document.setTechnologyLevel(null);
        document.setStatus(null);
        document.setCreatedBy(null);

        EraProfile domain = mapper.toDomain(document);

        assertNotNull(domain);
        assertNull(domain.getId());
        assertNull(domain.getWorldId());
        assertNull(domain.getTechnologyLevel());
        assertNull(domain.getStatus());
        assertNull(domain.getCreatedBy());
    }

    @Test
    @DisplayName("Round trip mapping preserves data")
    void roundTripMappingPreservesData() {
        EraProfile original = createFullyPopulatedEraProfile();

        EraProfileDocument document = mapper.toDocument(original);
        EraProfile restored = mapper.toDomain(document);

        assertEquals(original.getId(), restored.getId());
        assertEquals(original.getName(), restored.getName());
        assertEquals(original.getDescription(), restored.getDescription());
        assertEquals(original.getWorldId(), restored.getWorldId());
        assertEquals(original.getStartYear(), restored.getStartYear());
        assertEquals(original.getEndYear(), restored.getEndYear());
        assertEquals(original.getTimePeriodLabel(), restored.getTimePeriodLabel());
        assertEquals(original.getTechnologyLevel(), restored.getTechnologyLevel());
        assertEquals(original.getStatus(), restored.getStatus());
        assertEquals(original.getIsLocked(), restored.getIsLocked());
        assertEquals(original.getTechnologyApproved(), restored.getTechnologyApproved());
        assertEquals(original.getCharactersValidated(), restored.getCharactersValidated());
        assertEquals(original.getObjectsValidated(), restored.getObjectsValidated());
        assertEquals(original.getLocationsValidated(), restored.getLocationsValidated());
        assertEquals(original.getConflictsResolved(), restored.getConflictsResolved());
        assertEquals(original.getCreatedBy(), restored.getCreatedBy());
    }

    @Test
    @DisplayName("Maps all technology levels correctly")
    void mapsAllTechnologyLevelsCorrectly() {
        for (EraProfile.TechnologyLevel level : EraProfile.TechnologyLevel.values()) {
            EraProfile domain = new EraProfile();
            domain.setTechnologyLevel(level);

            EraProfileDocument document = mapper.toDocument(domain);
            EraProfile restored = mapper.toDomain(document);

            assertEquals(level, restored.getTechnologyLevel());
        }
    }

    @Test
    @DisplayName("Maps all statuses correctly")
    void mapsAllStatusesCorrectly() {
        for (EraProfile.EraStatus status : EraProfile.EraStatus.values()) {
            EraProfile domain = new EraProfile();
            domain.setStatus(status);

            EraProfileDocument document = mapper.toDocument(domain);
            EraProfile restored = mapper.toDomain(document);

            assertEquals(status, restored.getStatus());
        }
    }

    // Helper methods
    private EraProfile createFullyPopulatedEraProfile() {
        EraProfile profile = new EraProfile();
        profile.setId(testId);
        profile.setName("Renaissance Italy");
        profile.setDescription("An era of art and culture");
        profile.setWorldId(worldId);
        profile.setStartYear(1400);
        profile.setEndYear(1600);
        profile.setTimePeriodLabel("Early Modern Period");
        profile.setTechnologyLevel(EraProfile.TechnologyLevel.RENAISSANCE);
        profile.setStatus(EraProfile.EraStatus.APPROVED);
        profile.setIsLocked(false);
        profile.setTechnologyApproved(true);
        profile.setCharactersValidated(true);
        profile.setObjectsValidated(true);
        profile.setLocationsValidated(true);
        profile.setConflictsResolved(true);
        profile.setCreatedAt(LocalDateTime.now());
        profile.setUpdatedAt(LocalDateTime.now());
        profile.setCreatedBy(createdBy);
        return profile;
    }

    private EraProfileDocument createFullyPopulatedDocument() {
        EraProfileDocument document = new EraProfileDocument();
        document.setId(testId.toString());
        document.setName("Renaissance Italy");
        document.setDescription("An era of art and culture");
        document.setWorldId(worldId.toString());
        document.setStartYear(1400);
        document.setEndYear(1600);
        document.setTimePeriodLabel("Early Modern Period");
        document.setTechnologyLevel("RENAISSANCE");
        document.setStatus("APPROVED");
        document.setIsLocked(false);
        document.setTechnologyApproved(true);
        document.setCharactersValidated(true);
        document.setObjectsValidated(true);
        document.setLocationsValidated(true);
        document.setConflictsResolved(true);
        document.setCreatedAt(LocalDateTime.now());
        document.setUpdatedAt(LocalDateTime.now());
        document.setCreatedBy(createdBy.toString());
        return document;
    }
}
