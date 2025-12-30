package com.ffl.playoffs.domain.aggregate;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for EraProfile aggregate (ANIMA-1210)
 */
class EraProfileTest {

    private EraProfile eraProfile;
    private UUID worldId;

    @BeforeEach
    void setUp() {
        worldId = UUID.randomUUID();
        eraProfile = new EraProfile("Renaissance Italy", worldId, 1400, 1600);
        eraProfile.setTechnologyLevel(EraProfile.TechnologyLevel.RENAISSANCE);
    }

    @Test
    @DisplayName("New era profile starts in DRAFT status")
    void newEraProfileStartsInDraftStatus() {
        EraProfile newEra = new EraProfile();
        assertEquals(EraProfile.EraStatus.DRAFT, newEra.getStatus());
    }

    @Test
    @DisplayName("Era profile initializes with all curation flags as false")
    void eraProfileInitializesWithCurationFlagsAsFalse() {
        EraProfile newEra = new EraProfile();
        assertFalse(newEra.getTechnologyApproved());
        assertFalse(newEra.getCharactersValidated());
        assertFalse(newEra.getObjectsValidated());
        assertFalse(newEra.getLocationsValidated());
        assertFalse(newEra.getConflictsResolved());
    }

    @Test
    @DisplayName("Can approve technology level")
    void canApproveTechnologyLevel() {
        eraProfile.approveTechnology();
        assertTrue(eraProfile.getTechnologyApproved());
    }

    @Test
    @DisplayName("Can validate characters")
    void canValidateCharacters() {
        eraProfile.validateCharacters();
        assertTrue(eraProfile.getCharactersValidated());
    }

    @Test
    @DisplayName("Can validate objects")
    void canValidateObjects() {
        eraProfile.validateObjects();
        assertTrue(eraProfile.getObjectsValidated());
    }

    @Test
    @DisplayName("Can validate locations")
    void canValidateLocations() {
        eraProfile.validateLocations();
        assertTrue(eraProfile.getLocationsValidated());
    }

    @Test
    @DisplayName("Can resolve conflicts")
    void canResolveConflicts() {
        eraProfile.resolveConflicts();
        assertTrue(eraProfile.getConflictsResolved());
    }

    @Test
    @DisplayName("Curation is complete when all flags are true")
    void curationIsCompleteWhenAllFlagsAreTrue() {
        assertFalse(eraProfile.isCurationComplete());

        eraProfile.approveTechnology();
        eraProfile.validateCharacters();
        eraProfile.validateObjects();
        eraProfile.validateLocations();
        eraProfile.resolveConflicts();

        assertTrue(eraProfile.isCurationComplete());
    }

    @Test
    @DisplayName("Can lock era after curation is complete")
    void canLockEraAfterCurationComplete() {
        completeCuration();

        eraProfile.lock("World deployment");

        assertTrue(eraProfile.getIsLocked());
        assertNotNull(eraProfile.getLockedAt());
        assertEquals("World deployment", eraProfile.getLockReason());
        assertEquals(EraProfile.EraStatus.LOCKED, eraProfile.getStatus());
    }

    @Test
    @DisplayName("Cannot lock era with incomplete curation")
    void cannotLockEraWithIncompleteCuration() {
        // Only approve technology, leave others incomplete
        eraProfile.approveTechnology();

        assertThrows(EraProfile.IncompleteCurationException.class,
            () -> eraProfile.lock("Premature lock"));
    }

    @Test
    @DisplayName("Cannot modify locked era")
    void cannotModifyLockedEra() {
        completeCuration();
        eraProfile.lock("Locked");

        assertThrows(EraProfile.EraLockedException.class, () -> eraProfile.approveTechnology());
        assertThrows(EraProfile.EraLockedException.class, () -> eraProfile.validateCharacters());
        assertThrows(EraProfile.EraLockedException.class, () -> eraProfile.validateObjects());
        assertThrows(EraProfile.EraLockedException.class, () -> eraProfile.validateLocations());
        assertThrows(EraProfile.EraLockedException.class, () -> eraProfile.resolveConflicts());
    }

    @Test
    @DisplayName("Can submit era for review")
    void canSubmitEraForReview() {
        eraProfile.submitForReview();
        assertEquals(EraProfile.EraStatus.PENDING_REVIEW, eraProfile.getStatus());
    }

    @Test
    @DisplayName("Cannot submit non-draft era for review")
    void cannotSubmitNonDraftEraForReview() {
        eraProfile.submitForReview();

        assertThrows(IllegalStateException.class, () -> eraProfile.submitForReview());
    }

    @Test
    @DisplayName("Can approve era after review")
    void canApproveEraAfterReview() {
        eraProfile.submitForReview();
        eraProfile.approve();

        assertEquals(EraProfile.EraStatus.APPROVED, eraProfile.getStatus());
    }

    @Test
    @DisplayName("Cannot approve era not in review")
    void cannotApproveEraNotInReview() {
        assertThrows(IllegalStateException.class, () -> eraProfile.approve());
    }

    @Test
    @DisplayName("Can reject era after review")
    void canRejectEraAfterReview() {
        eraProfile.submitForReview();
        eraProfile.reject();

        assertEquals(EraProfile.EraStatus.DRAFT, eraProfile.getStatus());
    }

    @Test
    @DisplayName("Cannot reject era not in review")
    void cannotRejectEraNotInReview() {
        assertThrows(IllegalStateException.class, () -> eraProfile.reject());
    }

    @Test
    @DisplayName("Era profile constructor sets fields correctly")
    void constructorSetsFieldsCorrectly() {
        assertEquals("Renaissance Italy", eraProfile.getName());
        assertEquals(worldId, eraProfile.getWorldId());
        assertEquals(1400, eraProfile.getStartYear());
        assertEquals(1600, eraProfile.getEndYear());
    }

    @Test
    @DisplayName("Technology levels are valid")
    void technologyLevelsAreValid() {
        for (EraProfile.TechnologyLevel level : EraProfile.TechnologyLevel.values()) {
            eraProfile.setTechnologyLevel(level);
            assertEquals(level, eraProfile.getTechnologyLevel());
        }
    }

    @Test
    @DisplayName("Era statuses are valid")
    void eraStatusesAreValid() {
        assertEquals(4, EraProfile.EraStatus.values().length);
        assertNotNull(EraProfile.EraStatus.valueOf("DRAFT"));
        assertNotNull(EraProfile.EraStatus.valueOf("PENDING_REVIEW"));
        assertNotNull(EraProfile.EraStatus.valueOf("APPROVED"));
        assertNotNull(EraProfile.EraStatus.valueOf("LOCKED"));
    }

    @Test
    @DisplayName("toString returns readable format")
    void toStringReturnsReadableFormat() {
        String result = eraProfile.toString();
        assertTrue(result.contains("Renaissance Italy"));
        assertTrue(result.contains("1400"));
        assertTrue(result.contains("1600"));
    }

    // Helper method
    private void completeCuration() {
        eraProfile.approveTechnology();
        eraProfile.validateCharacters();
        eraProfile.validateObjects();
        eraProfile.validateLocations();
        eraProfile.resolveConflicts();
    }
}
