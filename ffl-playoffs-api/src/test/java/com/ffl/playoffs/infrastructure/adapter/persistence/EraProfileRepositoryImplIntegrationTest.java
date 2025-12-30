package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.application.IntegrationTestBase;
import com.ffl.playoffs.domain.aggregate.EraProfile;
import com.ffl.playoffs.domain.port.EraProfileRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Integration tests for EraProfileRepositoryImpl (ANIMA-1210)
 */
class EraProfileRepositoryImplIntegrationTest extends IntegrationTestBase {

    @Autowired
    private EraProfileRepository eraProfileRepository;

    @Test
    @DisplayName("Can save and find era profile by ID")
    void canSaveAndFindById() {
        EraProfile eraProfile = createEraProfile("Renaissance Italy");

        EraProfile saved = eraProfileRepository.save(eraProfile);
        Optional<EraProfile> found = eraProfileRepository.findById(saved.getId());

        assertTrue(found.isPresent());
        assertEquals(saved.getId(), found.get().getId());
        assertEquals("Renaissance Italy", found.get().getName());
    }

    @Test
    @DisplayName("Can find all era profiles")
    void canFindAll() {
        eraProfileRepository.save(createEraProfile("Era 1"));
        eraProfileRepository.save(createEraProfile("Era 2"));

        List<EraProfile> all = eraProfileRepository.findAll();

        assertEquals(2, all.size());
    }

    @Test
    @DisplayName("Can find era profiles by world ID")
    void canFindByWorldId() {
        UUID worldId = UUID.randomUUID();
        EraProfile era1 = createEraProfile("Era 1");
        era1.setWorldId(worldId);
        EraProfile era2 = createEraProfile("Era 2");
        era2.setWorldId(worldId);
        EraProfile era3 = createEraProfile("Era 3"); // Different world

        eraProfileRepository.save(era1);
        eraProfileRepository.save(era2);
        eraProfileRepository.save(era3);

        List<EraProfile> found = eraProfileRepository.findByWorldId(worldId);

        assertEquals(2, found.size());
        assertTrue(found.stream().allMatch(era -> worldId.equals(era.getWorldId())));
    }

    @Test
    @DisplayName("Can find era profiles by status")
    void canFindByStatus() {
        EraProfile draft = createEraProfile("Draft Era");
        draft.setStatus(EraProfile.EraStatus.DRAFT);
        EraProfile approved = createEraProfile("Approved Era");
        approved.setStatus(EraProfile.EraStatus.APPROVED);

        eraProfileRepository.save(draft);
        eraProfileRepository.save(approved);

        List<EraProfile> drafts = eraProfileRepository.findByStatus(EraProfile.EraStatus.DRAFT);
        List<EraProfile> approvedList = eraProfileRepository.findByStatus(EraProfile.EraStatus.APPROVED);

        assertEquals(1, drafts.size());
        assertEquals("Draft Era", drafts.get(0).getName());
        assertEquals(1, approvedList.size());
        assertEquals("Approved Era", approvedList.get(0).getName());
    }

    @Test
    @DisplayName("Can find era profiles by creator")
    void canFindByCreatedBy() {
        UUID userId = UUID.randomUUID();
        EraProfile era1 = createEraProfile("Era 1");
        era1.setCreatedBy(userId);
        EraProfile era2 = createEraProfile("Era 2"); // Different creator

        eraProfileRepository.save(era1);
        eraProfileRepository.save(era2);

        List<EraProfile> found = eraProfileRepository.findByCreatedBy(userId);

        assertEquals(1, found.size());
        assertEquals(userId, found.get(0).getCreatedBy());
    }

    @Test
    @DisplayName("Can find locked era profiles by world ID")
    void canFindLockedByWorldId() {
        UUID worldId = UUID.randomUUID();
        EraProfile locked = createEraProfile("Locked Era");
        locked.setWorldId(worldId);
        locked.setIsLocked(true);
        EraProfile unlocked = createEraProfile("Unlocked Era");
        unlocked.setWorldId(worldId);
        unlocked.setIsLocked(false);

        eraProfileRepository.save(locked);
        eraProfileRepository.save(unlocked);

        List<EraProfile> lockedList = eraProfileRepository.findLockedByWorldId(worldId);

        assertEquals(1, lockedList.size());
        assertTrue(lockedList.get(0).getIsLocked());
    }

    @Test
    @DisplayName("Can check if era profile exists")
    void canCheckExistsById() {
        EraProfile saved = eraProfileRepository.save(createEraProfile("Test Era"));

        assertTrue(eraProfileRepository.existsById(saved.getId()));
        assertFalse(eraProfileRepository.existsById(UUID.randomUUID()));
    }

    @Test
    @DisplayName("Can delete era profile by ID")
    void canDeleteById() {
        EraProfile saved = eraProfileRepository.save(createEraProfile("To Delete"));
        assertTrue(eraProfileRepository.existsById(saved.getId()));

        eraProfileRepository.deleteById(saved.getId());

        assertFalse(eraProfileRepository.existsById(saved.getId()));
    }

    @Test
    @DisplayName("Can delete era profiles by world ID")
    void canDeleteByWorldId() {
        UUID worldId = UUID.randomUUID();
        EraProfile era1 = createEraProfile("Era 1");
        era1.setWorldId(worldId);
        EraProfile era2 = createEraProfile("Era 2");
        era2.setWorldId(worldId);

        eraProfileRepository.save(era1);
        eraProfileRepository.save(era2);

        assertEquals(2, eraProfileRepository.countByWorldId(worldId));

        eraProfileRepository.deleteByWorldId(worldId);

        assertEquals(0, eraProfileRepository.countByWorldId(worldId));
    }

    @Test
    @DisplayName("Can count era profiles by world ID")
    void canCountByWorldId() {
        UUID worldId = UUID.randomUUID();
        EraProfile era1 = createEraProfile("Era 1");
        era1.setWorldId(worldId);
        EraProfile era2 = createEraProfile("Era 2");
        era2.setWorldId(worldId);

        eraProfileRepository.save(era1);
        eraProfileRepository.save(era2);

        assertEquals(2, eraProfileRepository.countByWorldId(worldId));
    }

    @Test
    @DisplayName("Update existing era profile persists changes")
    void updateExistingEraProfilePersistsChanges() {
        EraProfile saved = eraProfileRepository.save(createEraProfile("Original Name"));

        saved.setName("Updated Name");
        saved.setTechnologyLevel(EraProfile.TechnologyLevel.INDUSTRIAL);
        eraProfileRepository.save(saved);

        Optional<EraProfile> found = eraProfileRepository.findById(saved.getId());

        assertTrue(found.isPresent());
        assertEquals("Updated Name", found.get().getName());
        assertEquals(EraProfile.TechnologyLevel.INDUSTRIAL, found.get().getTechnologyLevel());
    }

    @Test
    @DisplayName("Persists all era profile fields")
    void persistsAllEraProfileFields() {
        EraProfile era = new EraProfile();
        UUID worldId = UUID.randomUUID();
        UUID createdBy = UUID.randomUUID();

        era.setName("Full Era");
        era.setDescription("Complete era profile");
        era.setWorldId(worldId);
        era.setStartYear(1500);
        era.setEndYear(1700);
        era.setTimePeriodLabel("Early Modern");
        era.setTechnologyLevel(EraProfile.TechnologyLevel.RENAISSANCE);
        era.setStatus(EraProfile.EraStatus.APPROVED);
        era.setTechnologyApproved(true);
        era.setCharactersValidated(true);
        era.setObjectsValidated(true);
        era.setLocationsValidated(true);
        era.setConflictsResolved(true);
        era.setCreatedBy(createdBy);

        EraProfile saved = eraProfileRepository.save(era);
        Optional<EraProfile> found = eraProfileRepository.findById(saved.getId());

        assertTrue(found.isPresent());
        EraProfile retrieved = found.get();
        assertEquals("Full Era", retrieved.getName());
        assertEquals("Complete era profile", retrieved.getDescription());
        assertEquals(worldId, retrieved.getWorldId());
        assertEquals(1500, retrieved.getStartYear());
        assertEquals(1700, retrieved.getEndYear());
        assertEquals("Early Modern", retrieved.getTimePeriodLabel());
        assertEquals(EraProfile.TechnologyLevel.RENAISSANCE, retrieved.getTechnologyLevel());
        assertEquals(EraProfile.EraStatus.APPROVED, retrieved.getStatus());
        assertTrue(retrieved.getTechnologyApproved());
        assertTrue(retrieved.getCharactersValidated());
        assertTrue(retrieved.getObjectsValidated());
        assertTrue(retrieved.getLocationsValidated());
        assertTrue(retrieved.getConflictsResolved());
        assertEquals(createdBy, retrieved.getCreatedBy());
    }

    // Helper method
    private EraProfile createEraProfile(String name) {
        EraProfile era = new EraProfile();
        era.setName(name);
        era.setWorldId(UUID.randomUUID());
        era.setStartYear(1400);
        era.setEndYear(1600);
        era.setTechnologyLevel(EraProfile.TechnologyLevel.RENAISSANCE);
        era.setCreatedBy(UUID.randomUUID());
        return era;
    }
}
