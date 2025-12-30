package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.aggregate.World;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.WorldDocument;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import java.time.LocalDateTime;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for WorldMapper (ANIMA-1211)
 */
class WorldMapperTest {

    private WorldMapper mapper;
    private UUID testId;
    private UUID ownerId;

    @BeforeEach
    void setUp() {
        mapper = new WorldMapper();
        testId = UUID.randomUUID();
        ownerId = UUID.randomUUID();
    }

    @Test
    @DisplayName("Maps domain to document correctly")
    void mapsDomainToDocumentCorrectly() {
        World domain = createFullyPopulatedWorld();

        WorldDocument document = mapper.toDocument(domain);

        assertNotNull(document);
        assertEquals(testId.toString(), document.getId());
        assertEquals("Test World", document.getName());
        assertEquals("A test world", document.getDescription());
        assertEquals(ownerId.toString(), document.getOwnerId());
        assertEquals("Romeo and Juliet", document.getNarrativeSource());
        assertEquals("APPROVED", document.getStatus());
        assertTrue(document.getIsPublic());
        assertEquals(10, document.getMaxPlayers());
        assertFalse(document.getIsDeployed());
    }

    @Test
    @DisplayName("Maps document to domain correctly")
    void mapsDocumentToDomainCorrectly() {
        WorldDocument document = createFullyPopulatedDocument();

        World domain = mapper.toDomain(document);

        assertNotNull(domain);
        assertEquals(testId, domain.getId());
        assertEquals("Test World", domain.getName());
        assertEquals("A test world", domain.getDescription());
        assertEquals(ownerId, domain.getOwnerId());
        assertEquals("Romeo and Juliet", domain.getNarrativeSource());
        assertEquals(World.WorldStatus.APPROVED, domain.getStatus());
        assertTrue(domain.getIsPublic());
        assertEquals(10, domain.getMaxPlayers());
        assertFalse(domain.getIsDeployed());
    }

    @Test
    @DisplayName("Handles null domain gracefully")
    void handlesNullDomainGracefully() {
        WorldDocument document = mapper.toDocument(null);
        assertNull(document);
    }

    @Test
    @DisplayName("Handles null document gracefully")
    void handlesNullDocumentGracefully() {
        World domain = mapper.toDomain(null);
        assertNull(domain);
    }

    @Test
    @DisplayName("Handles null nested fields in domain")
    void handlesNullNestedFieldsInDomain() {
        World domain = new World();
        domain.setId(null);
        domain.setOwnerId(null);
        domain.setStatus(null);

        WorldDocument document = mapper.toDocument(domain);

        assertNotNull(document);
        assertNull(document.getId());
        assertNull(document.getOwnerId());
        assertNull(document.getStatus());
    }

    @Test
    @DisplayName("Handles null nested fields in document")
    void handlesNullNestedFieldsInDocument() {
        WorldDocument document = new WorldDocument();
        document.setId(null);
        document.setOwnerId(null);
        document.setStatus(null);

        World domain = mapper.toDomain(document);

        assertNotNull(domain);
        assertNull(domain.getId());
        assertNull(domain.getOwnerId());
        assertNull(domain.getStatus());
    }

    @Test
    @DisplayName("Round trip mapping preserves data")
    void roundTripMappingPreservesData() {
        World original = createFullyPopulatedWorld();

        WorldDocument document = mapper.toDocument(original);
        World restored = mapper.toDomain(document);

        assertEquals(original.getId(), restored.getId());
        assertEquals(original.getName(), restored.getName());
        assertEquals(original.getDescription(), restored.getDescription());
        assertEquals(original.getOwnerId(), restored.getOwnerId());
        assertEquals(original.getNarrativeSource(), restored.getNarrativeSource());
        assertEquals(original.getStatus(), restored.getStatus());
        assertEquals(original.getIsPublic(), restored.getIsPublic());
        assertEquals(original.getMaxPlayers(), restored.getMaxPlayers());
        assertEquals(original.getIsDeployed(), restored.getIsDeployed());
    }

    @Test
    @DisplayName("Maps all statuses correctly")
    void mapsAllStatusesCorrectly() {
        for (World.WorldStatus status : World.WorldStatus.values()) {
            World domain = new World();
            domain.setStatus(status);

            WorldDocument document = mapper.toDocument(domain);
            World restored = mapper.toDomain(document);

            assertEquals(status, restored.getStatus());
        }
    }

    // Helper methods
    private World createFullyPopulatedWorld() {
        World world = new World();
        world.setId(testId);
        world.setName("Test World");
        world.setDescription("A test world");
        world.setOwnerId(ownerId);
        world.setNarrativeSource("Romeo and Juliet");
        world.setStatus(World.WorldStatus.APPROVED);
        world.setIsPublic(true);
        world.setMaxPlayers(10);
        world.setIsDeployed(false);
        world.setCreatedAt(LocalDateTime.now());
        world.setUpdatedAt(LocalDateTime.now());
        return world;
    }

    private WorldDocument createFullyPopulatedDocument() {
        WorldDocument document = new WorldDocument();
        document.setId(testId.toString());
        document.setName("Test World");
        document.setDescription("A test world");
        document.setOwnerId(ownerId.toString());
        document.setNarrativeSource("Romeo and Juliet");
        document.setStatus("APPROVED");
        document.setIsPublic(true);
        document.setMaxPlayers(10);
        document.setIsDeployed(false);
        document.setCreatedAt(LocalDateTime.now());
        document.setUpdatedAt(LocalDateTime.now());
        return document;
    }
}
