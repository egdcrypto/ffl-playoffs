package com.ffl.playoffs.domain.model.world;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("World Entity Tests")
class WorldTest {

    private UUID ownerId;

    @BeforeEach
    void setUp() {
        ownerId = UUID.randomUUID();
    }

    @Nested
    @DisplayName("create tests")
    class CreateTests {

        @Test
        @DisplayName("should create world with valid parameters")
        void shouldCreateWorldWithValidParameters() {
            World world = World.create("Test World", "TESTCODE", ownerId);

            assertThat(world.getId()).isNotNull();
            assertThat(world.getName()).isEqualTo("Test World");
            assertThat(world.getCode()).isEqualTo("TESTCODE");
            assertThat(world.getPrimaryOwnerId()).isEqualTo(ownerId);
            assertThat(world.getStatus()).isEqualTo(WorldStatus.DRAFT);
            assertThat(world.getVisibility()).isEqualTo(WorldVisibility.PRIVATE);
            assertThat(world.getSettings()).isNotNull();
            assertThat(world.getCreatedAt()).isNotNull();
        }

        @Test
        @DisplayName("should uppercase the code")
        void shouldUppercaseTheCode() {
            World world = World.create("Test World", "lowercase", ownerId);
            assertThat(world.getCode()).isEqualTo("LOWERCASE");
        }

        @Test
        @DisplayName("should trim name and code")
        void shouldTrimNameAndCode() {
            World world = World.create("  Test World  ", "  CODE  ", ownerId);
            assertThat(world.getName()).isEqualTo("Test World");
            assertThat(world.getCode()).isEqualTo("CODE");
        }

        @Test
        @DisplayName("should throw exception for null name")
        void shouldThrowExceptionForNullName() {
            assertThatThrownBy(() -> World.create(null, "CODE", ownerId))
                    .isInstanceOf(NullPointerException.class);
        }

        @Test
        @DisplayName("should throw exception for blank name")
        void shouldThrowExceptionForBlankName() {
            assertThatThrownBy(() -> World.create("   ", "CODE", ownerId))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Name cannot be blank");
        }

        @Test
        @DisplayName("should throw exception for null code")
        void shouldThrowExceptionForNullCode() {
            assertThatThrownBy(() -> World.create("Test World", null, ownerId))
                    .isInstanceOf(NullPointerException.class);
        }

        @Test
        @DisplayName("should initialize counts to zero")
        void shouldInitializeCountsToZero() {
            World world = World.create("Test World", "CODE", ownerId);
            assertThat(world.getLeagueCount()).isZero();
            assertThat(world.getMemberCount()).isZero();
            assertThat(world.getOwnerCount()).isEqualTo(1); // Primary owner
        }
    }

    @Nested
    @DisplayName("lifecycle tests")
    class LifecycleTests {

        @Test
        @DisplayName("should activate draft world")
        void shouldActivateDraftWorld() {
            World world = World.create("Test World", "CODE", ownerId);
            assertThat(world.getStatus()).isEqualTo(WorldStatus.DRAFT);

            world.activate();

            assertThat(world.getStatus()).isEqualTo(WorldStatus.ACTIVE);
            assertThat(world.getActivatedAt()).isNotNull();
        }

        @Test
        @DisplayName("should suspend active world")
        void shouldSuspendActiveWorld() {
            World world = World.create("Test World", "CODE", ownerId);
            world.activate();

            world.suspend();

            assertThat(world.getStatus()).isEqualTo(WorldStatus.SUSPENDED);
        }

        @Test
        @DisplayName("should archive active world")
        void shouldArchiveActiveWorld() {
            World world = World.create("Test World", "CODE", ownerId);
            world.activate();

            world.archive();

            assertThat(world.getStatus()).isEqualTo(WorldStatus.ARCHIVED);
            assertThat(world.getArchivedAt()).isNotNull();
        }

        @Test
        @DisplayName("should throw exception when activating archived world")
        void shouldThrowExceptionWhenActivatingArchivedWorld() {
            World world = World.create("Test World", "CODE", ownerId);
            world.activate();
            world.archive();

            assertThatThrownBy(() -> world.activate())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot activate world in status");
        }

        @Test
        @DisplayName("should throw exception when suspending draft world")
        void shouldThrowExceptionWhenSuspendingDraftWorld() {
            World world = World.create("Test World", "CODE", ownerId);

            assertThatThrownBy(() -> world.suspend())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot suspend world in status");
        }

        @Test
        @DisplayName("should mark as deleted")
        void shouldMarkAsDeleted() {
            World world = World.create("Test World", "CODE", ownerId);
            world.activate();

            world.markDeleted();

            assertThat(world.getStatus()).isEqualTo(WorldStatus.DELETED);
        }
    }

    @Nested
    @DisplayName("update tests")
    class UpdateTests {

        @Test
        @DisplayName("should update name")
        void shouldUpdateName() {
            World world = World.create("Test World", "CODE", ownerId);

            world.updateName("New Name");

            assertThat(world.getName()).isEqualTo("New Name");
        }

        @Test
        @DisplayName("should update description")
        void shouldUpdateDescription() {
            World world = World.create("Test World", "CODE", ownerId);

            world.updateDescription("A description");

            assertThat(world.getDescription()).isEqualTo("A description");
        }

        @Test
        @DisplayName("should update visibility")
        void shouldUpdateVisibility() {
            World world = World.create("Test World", "CODE", ownerId);

            world.updateVisibility(WorldVisibility.PUBLIC);

            assertThat(world.getVisibility()).isEqualTo(WorldVisibility.PUBLIC);
        }

        @Test
        @DisplayName("should throw exception when updating archived world")
        void shouldThrowExceptionWhenUpdatingArchivedWorld() {
            World world = World.create("Test World", "CODE", ownerId);
            world.activate();
            world.archive();

            assertThatThrownBy(() -> world.updateName("New Name"))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot modify world in status");
        }

        @Test
        @DisplayName("should regenerate code")
        void shouldRegenerateCode() {
            World world = World.create("Test World", "OLDCODE", ownerId);
            String oldCode = world.getCode();

            world.regenerateCode();

            assertThat(world.getCode()).isNotEqualTo(oldCode);
            assertThat(world.getCode()).hasSize(8);
        }
    }

    @Nested
    @DisplayName("ownership tests")
    class OwnershipTests {

        @Test
        @DisplayName("should identify primary owner")
        void shouldIdentifyPrimaryOwner() {
            World world = World.create("Test World", "CODE", ownerId);

            assertThat(world.isPrimaryOwner(ownerId)).isTrue();
            assertThat(world.isPrimaryOwner(UUID.randomUUID())).isFalse();
        }

        @Test
        @DisplayName("should transfer ownership")
        void shouldTransferOwnership() {
            World world = World.create("Test World", "CODE", ownerId);
            UUID newOwnerId = UUID.randomUUID();

            world.transferPrimaryOwnership(newOwnerId);

            assertThat(world.getPrimaryOwnerId()).isEqualTo(newOwnerId);
            assertThat(world.isPrimaryOwner(newOwnerId)).isTrue();
            assertThat(world.isPrimaryOwner(ownerId)).isFalse();
        }

        @Test
        @DisplayName("should throw exception when transferring ownership of archived world")
        void shouldThrowExceptionWhenTransferringOwnershipOfArchivedWorld() {
            World world = World.create("Test World", "CODE", ownerId);
            world.activate();
            world.archive();

            assertThatThrownBy(() -> world.transferPrimaryOwnership(UUID.randomUUID()))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot transfer ownership");
        }
    }

    @Nested
    @DisplayName("capacity tests")
    class CapacityTests {

        @Test
        @DisplayName("should check league capacity")
        void shouldCheckLeagueCapacity() {
            World world = World.create("Test World", "CODE", ownerId);
            world.activate();

            assertThat(world.canAddLeague()).isTrue();
        }

        @Test
        @DisplayName("should check owner capacity")
        void shouldCheckOwnerCapacity() {
            World world = World.create("Test World", "CODE", ownerId);

            assertThat(world.canAddOwner()).isTrue();
        }

        @Test
        @DisplayName("should check member capacity")
        void shouldCheckMemberCapacity() {
            World world = World.create("Test World", "CODE", ownerId);
            world.activate();

            assertThat(world.canAddMember()).isTrue();
        }

        @Test
        @DisplayName("should not allow members when not active")
        void shouldNotAllowMembersWhenNotActive() {
            World world = World.create("Test World", "CODE", ownerId);

            assertThat(world.canAddMember()).isFalse();
        }

        @Test
        @DisplayName("should increment league count")
        void shouldIncrementLeagueCount() {
            World world = World.create("Test World", "CODE", ownerId);

            world.incrementLeagueCount();

            assertThat(world.getLeagueCount()).isEqualTo(1);
        }

        @Test
        @DisplayName("should decrement league count")
        void shouldDecrementLeagueCount() {
            World world = World.create("Test World", "CODE", ownerId);
            world.incrementLeagueCount();
            world.incrementLeagueCount();

            world.decrementLeagueCount();

            assertThat(world.getLeagueCount()).isEqualTo(1);
        }
    }

    @Nested
    @DisplayName("utility tests")
    class UtilityTests {

        @Test
        @DisplayName("isActive should return correct value")
        void isActiveShouldReturnCorrectValue() {
            World world = World.create("Test World", "CODE", ownerId);
            assertThat(world.isActive()).isFalse();

            world.activate();
            assertThat(world.isActive()).isTrue();
        }

        @Test
        @DisplayName("isDraft should return correct value")
        void isDraftShouldReturnCorrectValue() {
            World world = World.create("Test World", "CODE", ownerId);
            assertThat(world.isDraft()).isTrue();

            world.activate();
            assertThat(world.isDraft()).isFalse();
        }

        @Test
        @DisplayName("isArchived should return correct value")
        void isArchivedShouldReturnCorrectValue() {
            World world = World.create("Test World", "CODE", ownerId);
            world.activate();
            assertThat(world.isArchived()).isFalse();

            world.archive();
            assertThat(world.isArchived()).isTrue();
        }
    }
}
