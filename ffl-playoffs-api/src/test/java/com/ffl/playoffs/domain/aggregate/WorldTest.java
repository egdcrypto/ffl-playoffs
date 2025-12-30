package com.ffl.playoffs.domain.aggregate;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for World aggregate (ANIMA-1211)
 */
class WorldTest {

    private World world;
    private UUID ownerId;

    @BeforeEach
    void setUp() {
        ownerId = UUID.randomUUID();
        world = new World("Test World", ownerId);
    }

    @Test
    @DisplayName("New world starts in DRAFT status")
    void newWorldStartsInDraftStatus() {
        World newWorld = new World();
        assertEquals(World.WorldStatus.DRAFT, newWorld.getStatus());
    }

    @Test
    @DisplayName("New world is private by default")
    void newWorldIsPrivateByDefault() {
        World newWorld = new World();
        assertFalse(newWorld.getIsPublic());
    }

    @Test
    @DisplayName("New world is not deployed by default")
    void newWorldIsNotDeployedByDefault() {
        World newWorld = new World();
        assertFalse(newWorld.getIsDeployed());
    }

    @Test
    @DisplayName("Constructor sets name and owner correctly")
    void constructorSetsFieldsCorrectly() {
        assertEquals("Test World", world.getName());
        assertEquals(ownerId, world.getOwnerId());
    }

    @Test
    @DisplayName("Can submit draft world for review")
    void canSubmitDraftWorldForReview() {
        world.submitForReview();
        assertEquals(World.WorldStatus.PENDING_REVIEW, world.getStatus());
    }

    @Test
    @DisplayName("Cannot submit non-draft world for review")
    void cannotSubmitNonDraftWorldForReview() {
        world.submitForReview(); // Now PENDING_REVIEW
        assertThrows(IllegalStateException.class, () -> world.submitForReview());
    }

    @Test
    @DisplayName("Can approve world pending review")
    void canApproveWorldPendingReview() {
        world.submitForReview();
        world.approve();
        assertEquals(World.WorldStatus.APPROVED, world.getStatus());
    }

    @Test
    @DisplayName("Cannot approve world not pending review")
    void cannotApproveWorldNotPendingReview() {
        assertThrows(IllegalStateException.class, () -> world.approve());
    }

    @Test
    @DisplayName("Can reject world pending review")
    void canRejectWorldPendingReview() {
        world.submitForReview();
        world.reject();
        assertEquals(World.WorldStatus.DRAFT, world.getStatus());
    }

    @Test
    @DisplayName("Cannot reject world not pending review")
    void cannotRejectWorldNotPendingReview() {
        assertThrows(IllegalStateException.class, () -> world.reject());
    }

    @Test
    @DisplayName("Can deploy approved world")
    void canDeployApprovedWorld() {
        world.submitForReview();
        world.approve();
        world.deploy();

        assertEquals(World.WorldStatus.DEPLOYED, world.getStatus());
        assertTrue(world.getIsDeployed());
        assertNotNull(world.getDeployedAt());
    }

    @Test
    @DisplayName("Cannot deploy non-approved world")
    void cannotDeployNonApprovedWorld() {
        assertThrows(IllegalStateException.class, () -> world.deploy());
    }

    @Test
    @DisplayName("Can undeploy deployed world")
    void canUndeployDeployedWorld() {
        world.submitForReview();
        world.approve();
        world.deploy();
        world.undeploy();

        assertEquals(World.WorldStatus.APPROVED, world.getStatus());
        assertFalse(world.getIsDeployed());
    }

    @Test
    @DisplayName("Cannot undeploy non-deployed world")
    void cannotUndeployNonDeployedWorld() {
        assertThrows(IllegalStateException.class, () -> world.undeploy());
    }

    @Test
    @DisplayName("Can archive draft world")
    void canArchiveDraftWorld() {
        world.archive();
        assertEquals(World.WorldStatus.ARCHIVED, world.getStatus());
    }

    @Test
    @DisplayName("Cannot archive deployed world")
    void cannotArchiveDeployedWorld() {
        world.submitForReview();
        world.approve();
        world.deploy();
        assertThrows(IllegalStateException.class, () -> world.archive());
    }

    @Test
    @DisplayName("Cannot archive already archived world")
    void cannotArchiveAlreadyArchivedWorld() {
        world.archive();
        assertThrows(IllegalStateException.class, () -> world.archive());
    }

    @Test
    @DisplayName("Can make world public")
    void canMakeWorldPublic() {
        world.makePublic();
        assertTrue(world.getIsPublic());
    }

    @Test
    @DisplayName("Can make world private")
    void canMakeWorldPrivate() {
        world.makePublic();
        world.makePrivate();
        assertFalse(world.getIsPublic());
    }

    @Test
    @DisplayName("Draft world can be edited")
    void draftWorldCanBeEdited() {
        assertTrue(world.canEdit());
    }

    @Test
    @DisplayName("Approved world can be edited")
    void approvedWorldCanBeEdited() {
        world.submitForReview();
        world.approve();
        assertTrue(world.canEdit());
    }

    @Test
    @DisplayName("Deployed world cannot be edited")
    void deployedWorldCannotBeEdited() {
        world.submitForReview();
        world.approve();
        world.deploy();
        assertFalse(world.canEdit());
    }

    @Test
    @DisplayName("Draft world can be deleted")
    void draftWorldCanBeDeleted() {
        assertTrue(world.canDelete());
    }

    @Test
    @DisplayName("Non-draft world cannot be deleted")
    void nonDraftWorldCannotBeDeleted() {
        world.submitForReview();
        assertFalse(world.canDelete());
    }

    @Test
    @DisplayName("World statuses are valid")
    void worldStatusesAreValid() {
        assertEquals(5, World.WorldStatus.values().length);
        assertNotNull(World.WorldStatus.valueOf("DRAFT"));
        assertNotNull(World.WorldStatus.valueOf("PENDING_REVIEW"));
        assertNotNull(World.WorldStatus.valueOf("APPROVED"));
        assertNotNull(World.WorldStatus.valueOf("DEPLOYED"));
        assertNotNull(World.WorldStatus.valueOf("ARCHIVED"));
    }

    @Test
    @DisplayName("toString returns readable format")
    void toStringReturnsReadableFormat() {
        String result = world.toString();
        assertTrue(result.contains("Test World"));
        assertTrue(result.contains("DRAFT"));
    }
}
