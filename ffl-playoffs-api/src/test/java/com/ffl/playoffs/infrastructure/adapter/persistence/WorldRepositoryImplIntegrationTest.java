package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.application.IntegrationTestBase;
import com.ffl.playoffs.domain.aggregate.World;
import com.ffl.playoffs.domain.port.WorldRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Integration tests for WorldRepositoryImpl (ANIMA-1211)
 */
class WorldRepositoryImplIntegrationTest extends IntegrationTestBase {

    @Autowired
    private WorldRepository worldRepository;

    @Test
    @DisplayName("Can save and find world by ID")
    void canSaveAndFindById() {
        World world = createWorld("Test World");

        World saved = worldRepository.save(world);
        Optional<World> found = worldRepository.findById(saved.getId());

        assertTrue(found.isPresent());
        assertEquals(saved.getId(), found.get().getId());
        assertEquals("Test World", found.get().getName());
    }

    @Test
    @DisplayName("Can find all worlds")
    void canFindAll() {
        worldRepository.save(createWorld("World 1"));
        worldRepository.save(createWorld("World 2"));

        List<World> all = worldRepository.findAll();

        assertEquals(2, all.size());
    }

    @Test
    @DisplayName("Can find worlds by owner ID")
    void canFindByOwnerId() {
        UUID ownerId = UUID.randomUUID();
        World world1 = createWorld("World 1");
        world1.setOwnerId(ownerId);
        World world2 = createWorld("World 2");
        world2.setOwnerId(ownerId);
        World world3 = createWorld("World 3"); // Different owner

        worldRepository.save(world1);
        worldRepository.save(world2);
        worldRepository.save(world3);

        List<World> found = worldRepository.findByOwnerId(ownerId);

        assertEquals(2, found.size());
        assertTrue(found.stream().allMatch(w -> ownerId.equals(w.getOwnerId())));
    }

    @Test
    @DisplayName("Can find worlds by status")
    void canFindByStatus() {
        World draft = createWorld("Draft World");
        World approved = createWorld("Approved World");
        approved.submitForReview();
        approved.approve();

        worldRepository.save(draft);
        worldRepository.save(approved);

        List<World> drafts = worldRepository.findByStatus(World.WorldStatus.DRAFT);
        List<World> approvedList = worldRepository.findByStatus(World.WorldStatus.APPROVED);

        assertEquals(1, drafts.size());
        assertEquals("Draft World", drafts.get(0).getName());
        assertEquals(1, approvedList.size());
        assertEquals("Approved World", approvedList.get(0).getName());
    }

    @Test
    @DisplayName("Can find public worlds")
    void canFindPublicWorlds() {
        World publicWorld = createWorld("Public World");
        publicWorld.makePublic();
        World privateWorld = createWorld("Private World");

        worldRepository.save(publicWorld);
        worldRepository.save(privateWorld);

        List<World> publicWorlds = worldRepository.findPublicWorlds();

        assertEquals(1, publicWorlds.size());
        assertTrue(publicWorlds.get(0).getIsPublic());
    }

    @Test
    @DisplayName("Can find deployed worlds")
    void canFindDeployedWorlds() {
        World deployed = createWorld("Deployed World");
        deployed.submitForReview();
        deployed.approve();
        deployed.deploy();
        World notDeployed = createWorld("Not Deployed");

        worldRepository.save(deployed);
        worldRepository.save(notDeployed);

        List<World> deployedWorlds = worldRepository.findDeployedWorlds();

        assertEquals(1, deployedWorlds.size());
        assertTrue(deployedWorlds.get(0).getIsDeployed());
    }

    @Test
    @DisplayName("Can check if world exists")
    void canCheckExistsById() {
        World saved = worldRepository.save(createWorld("Test World"));

        assertTrue(worldRepository.existsById(saved.getId()));
        assertFalse(worldRepository.existsById(UUID.randomUUID()));
    }

    @Test
    @DisplayName("Can delete world by ID")
    void canDeleteById() {
        World saved = worldRepository.save(createWorld("To Delete"));
        assertTrue(worldRepository.existsById(saved.getId()));

        worldRepository.deleteById(saved.getId());

        assertFalse(worldRepository.existsById(saved.getId()));
    }

    @Test
    @DisplayName("Can count worlds by owner")
    void canCountByOwnerId() {
        UUID ownerId = UUID.randomUUID();
        World world1 = createWorld("World 1");
        world1.setOwnerId(ownerId);
        World world2 = createWorld("World 2");
        world2.setOwnerId(ownerId);

        worldRepository.save(world1);
        worldRepository.save(world2);

        assertEquals(2, worldRepository.countByOwnerId(ownerId));
    }

    @Test
    @DisplayName("Update existing world persists changes")
    void updateExistingWorldPersistsChanges() {
        World saved = worldRepository.save(createWorld("Original Name"));

        saved.setName("Updated Name");
        saved.setDescription("New description");
        worldRepository.save(saved);

        Optional<World> found = worldRepository.findById(saved.getId());

        assertTrue(found.isPresent());
        assertEquals("Updated Name", found.get().getName());
        assertEquals("New description", found.get().getDescription());
    }

    @Test
    @DisplayName("Persists all world fields")
    void persistsAllWorldFields() {
        World world = new World();
        UUID ownerId = UUID.randomUUID();

        world.setName("Full World");
        world.setDescription("Complete world");
        world.setOwnerId(ownerId);
        world.setNarrativeSource("Romeo and Juliet");
        world.setIsPublic(true);
        world.setMaxPlayers(8);

        World saved = worldRepository.save(world);
        Optional<World> found = worldRepository.findById(saved.getId());

        assertTrue(found.isPresent());
        World retrieved = found.get();
        assertEquals("Full World", retrieved.getName());
        assertEquals("Complete world", retrieved.getDescription());
        assertEquals(ownerId, retrieved.getOwnerId());
        assertEquals("Romeo and Juliet", retrieved.getNarrativeSource());
        assertTrue(retrieved.getIsPublic());
        assertEquals(8, retrieved.getMaxPlayers());
    }

    // Helper method
    private World createWorld(String name) {
        World world = new World();
        world.setName(name);
        world.setOwnerId(UUID.randomUUID());
        return world;
    }
}
