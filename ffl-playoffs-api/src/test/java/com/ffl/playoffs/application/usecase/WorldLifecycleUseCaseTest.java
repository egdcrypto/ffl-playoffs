package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.World;
import com.ffl.playoffs.domain.aggregate.World.WorldStatus;
import com.ffl.playoffs.domain.port.WorldRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("WorldLifecycleUseCase Tests")
class WorldLifecycleUseCaseTest {

    @Mock
    private WorldRepository worldRepository;

    private WorldLifecycleUseCase useCase;

    private UUID worldId;
    private UUID ownerId;

    @BeforeEach
    void setUp() {
        useCase = new WorldLifecycleUseCase(worldRepository);
        worldId = UUID.randomUUID();
        ownerId = UUID.randomUUID();
    }

    private World createWorldInStatus(WorldStatus status) {
        World world = new World("Test World", ownerId);
        world.setId(worldId);
        // Transition to desired status
        switch (status) {
            case PENDING_REVIEW:
                world.submitForReview();
                break;
            case APPROVED:
                world.submitForReview();
                world.approve();
                break;
            case DEPLOYED:
                world.submitForReview();
                world.approve();
                world.deploy();
                break;
            case ARCHIVED:
                world.archive();
                break;
            case DRAFT:
            default:
                // Already in DRAFT
                break;
        }
        return world;
    }

    @Nested
    @DisplayName("submitForReview")
    class SubmitForReview {

        @Test
        @DisplayName("should submit DRAFT world for review successfully")
        void shouldSubmitDraftWorldForReviewSuccessfully() {
            // Arrange
            World draftWorld = createWorldInStatus(WorldStatus.DRAFT);
            when(worldRepository.findById(worldId)).thenReturn(Optional.of(draftWorld));
            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            World result = useCase.submitForReview(worldId);

            // Assert
            assertEquals(WorldStatus.PENDING_REVIEW, result.getStatus());
            verify(worldRepository).save(any(World.class));
        }

        @Test
        @DisplayName("should throw exception when world not found")
        void shouldThrowExceptionWhenWorldNotFound() {
            // Arrange
            UUID unknownId = UUID.randomUUID();
            when(worldRepository.findById(unknownId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.submitForReview(unknownId)
            );

            assertTrue(exception.getMessage().contains("World not found"));
            verify(worldRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when world is not DRAFT")
        void shouldThrowExceptionWhenWorldNotDraft() {
            // Arrange
            World approvedWorld = createWorldInStatus(WorldStatus.APPROVED);
            when(worldRepository.findById(worldId)).thenReturn(Optional.of(approvedWorld));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.submitForReview(worldId)
            );

            assertTrue(exception.getMessage().contains("Only DRAFT"));
            verify(worldRepository, never()).save(any());
        }
    }

    @Nested
    @DisplayName("approve")
    class Approve {

        @Test
        @DisplayName("should approve PENDING_REVIEW world successfully")
        void shouldApprovePendingReviewWorldSuccessfully() {
            // Arrange
            World pendingWorld = createWorldInStatus(WorldStatus.PENDING_REVIEW);
            when(worldRepository.findById(worldId)).thenReturn(Optional.of(pendingWorld));
            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            World result = useCase.approve(worldId);

            // Assert
            assertEquals(WorldStatus.APPROVED, result.getStatus());
            verify(worldRepository).save(any(World.class));
        }

        @Test
        @DisplayName("should throw exception when world not found")
        void shouldThrowExceptionWhenWorldNotFound() {
            // Arrange
            UUID unknownId = UUID.randomUUID();
            when(worldRepository.findById(unknownId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.approve(unknownId)
            );

            assertTrue(exception.getMessage().contains("World not found"));
        }

        @Test
        @DisplayName("should throw exception when world is not PENDING_REVIEW")
        void shouldThrowExceptionWhenWorldNotPendingReview() {
            // Arrange
            World draftWorld = createWorldInStatus(WorldStatus.DRAFT);
            when(worldRepository.findById(worldId)).thenReturn(Optional.of(draftWorld));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.approve(worldId)
            );

            assertTrue(exception.getMessage().contains("Only worlds PENDING_REVIEW"));
            verify(worldRepository, never()).save(any());
        }
    }

    @Nested
    @DisplayName("reject")
    class Reject {

        @Test
        @DisplayName("should reject PENDING_REVIEW world successfully")
        void shouldRejectPendingReviewWorldSuccessfully() {
            // Arrange
            World pendingWorld = createWorldInStatus(WorldStatus.PENDING_REVIEW);
            when(worldRepository.findById(worldId)).thenReturn(Optional.of(pendingWorld));
            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            World result = useCase.reject(worldId);

            // Assert
            assertEquals(WorldStatus.DRAFT, result.getStatus());
            verify(worldRepository).save(any(World.class));
        }

        @Test
        @DisplayName("should throw exception when world not found")
        void shouldThrowExceptionWhenWorldNotFound() {
            // Arrange
            UUID unknownId = UUID.randomUUID();
            when(worldRepository.findById(unknownId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.reject(unknownId)
            );

            assertTrue(exception.getMessage().contains("World not found"));
        }

        @Test
        @DisplayName("should throw exception when world is not PENDING_REVIEW")
        void shouldThrowExceptionWhenWorldNotPendingReview() {
            // Arrange
            World approvedWorld = createWorldInStatus(WorldStatus.APPROVED);
            when(worldRepository.findById(worldId)).thenReturn(Optional.of(approvedWorld));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.reject(worldId)
            );

            assertTrue(exception.getMessage().contains("Only worlds PENDING_REVIEW"));
            verify(worldRepository, never()).save(any());
        }
    }

    @Nested
    @DisplayName("deploy")
    class Deploy {

        @Test
        @DisplayName("should deploy APPROVED world successfully")
        void shouldDeployApprovedWorldSuccessfully() {
            // Arrange
            World approvedWorld = createWorldInStatus(WorldStatus.APPROVED);
            when(worldRepository.findById(worldId)).thenReturn(Optional.of(approvedWorld));
            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            World result = useCase.deploy(worldId);

            // Assert
            assertEquals(WorldStatus.DEPLOYED, result.getStatus());
            assertTrue(result.getIsDeployed());
            assertNotNull(result.getDeployedAt());
            verify(worldRepository).save(any(World.class));
        }

        @Test
        @DisplayName("should throw exception when world not found")
        void shouldThrowExceptionWhenWorldNotFound() {
            // Arrange
            UUID unknownId = UUID.randomUUID();
            when(worldRepository.findById(unknownId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.deploy(unknownId)
            );

            assertTrue(exception.getMessage().contains("World not found"));
        }

        @Test
        @DisplayName("should throw exception when world is not APPROVED")
        void shouldThrowExceptionWhenWorldNotApproved() {
            // Arrange
            World draftWorld = createWorldInStatus(WorldStatus.DRAFT);
            when(worldRepository.findById(worldId)).thenReturn(Optional.of(draftWorld));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.deploy(worldId)
            );

            assertTrue(exception.getMessage().contains("Only APPROVED worlds"));
            verify(worldRepository, never()).save(any());
        }
    }

    @Nested
    @DisplayName("undeploy")
    class Undeploy {

        @Test
        @DisplayName("should undeploy DEPLOYED world successfully")
        void shouldUndeployDeployedWorldSuccessfully() {
            // Arrange
            World deployedWorld = createWorldInStatus(WorldStatus.DEPLOYED);
            when(worldRepository.findById(worldId)).thenReturn(Optional.of(deployedWorld));
            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            World result = useCase.undeploy(worldId);

            // Assert
            assertEquals(WorldStatus.APPROVED, result.getStatus());
            assertFalse(result.getIsDeployed());
            verify(worldRepository).save(any(World.class));
        }

        @Test
        @DisplayName("should throw exception when world not found")
        void shouldThrowExceptionWhenWorldNotFound() {
            // Arrange
            UUID unknownId = UUID.randomUUID();
            when(worldRepository.findById(unknownId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.undeploy(unknownId)
            );

            assertTrue(exception.getMessage().contains("World not found"));
        }

        @Test
        @DisplayName("should throw exception when world is not DEPLOYED")
        void shouldThrowExceptionWhenWorldNotDeployed() {
            // Arrange
            World approvedWorld = createWorldInStatus(WorldStatus.APPROVED);
            when(worldRepository.findById(worldId)).thenReturn(Optional.of(approvedWorld));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.undeploy(worldId)
            );

            assertTrue(exception.getMessage().contains("Only DEPLOYED worlds"));
            verify(worldRepository, never()).save(any());
        }
    }

    @Nested
    @DisplayName("archive")
    class Archive {

        @Test
        @DisplayName("should archive DRAFT world successfully")
        void shouldArchiveDraftWorldSuccessfully() {
            // Arrange
            World draftWorld = createWorldInStatus(WorldStatus.DRAFT);
            when(worldRepository.findById(worldId)).thenReturn(Optional.of(draftWorld));
            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            World result = useCase.archive(worldId);

            // Assert
            assertEquals(WorldStatus.ARCHIVED, result.getStatus());
            verify(worldRepository).save(any(World.class));
        }

        @Test
        @DisplayName("should archive APPROVED world successfully")
        void shouldArchiveApprovedWorldSuccessfully() {
            // Arrange
            World approvedWorld = createWorldInStatus(WorldStatus.APPROVED);
            when(worldRepository.findById(worldId)).thenReturn(Optional.of(approvedWorld));
            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            World result = useCase.archive(worldId);

            // Assert
            assertEquals(WorldStatus.ARCHIVED, result.getStatus());
            verify(worldRepository).save(any(World.class));
        }

        @Test
        @DisplayName("should throw exception when world not found")
        void shouldThrowExceptionWhenWorldNotFound() {
            // Arrange
            UUID unknownId = UUID.randomUUID();
            when(worldRepository.findById(unknownId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.archive(unknownId)
            );

            assertTrue(exception.getMessage().contains("World not found"));
        }

        @Test
        @DisplayName("should throw exception when world is already ARCHIVED")
        void shouldThrowExceptionWhenWorldAlreadyArchived() {
            // Arrange
            World archivedWorld = createWorldInStatus(WorldStatus.ARCHIVED);
            when(worldRepository.findById(worldId)).thenReturn(Optional.of(archivedWorld));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.archive(worldId)
            );

            assertTrue(exception.getMessage().contains("already archived"));
            verify(worldRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when world is DEPLOYED")
        void shouldThrowExceptionWhenWorldDeployed() {
            // Arrange
            World deployedWorld = createWorldInStatus(WorldStatus.DEPLOYED);
            when(worldRepository.findById(worldId)).thenReturn(Optional.of(deployedWorld));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.archive(worldId)
            );

            assertTrue(exception.getMessage().contains("Cannot archive a deployed world"));
            verify(worldRepository, never()).save(any());
        }
    }

    @Nested
    @DisplayName("makePublic")
    class MakePublic {

        @Test
        @DisplayName("should make world public successfully")
        void shouldMakeWorldPublicSuccessfully() {
            // Arrange
            World world = createWorldInStatus(WorldStatus.DRAFT);
            world.setIsPublic(false);
            when(worldRepository.findById(worldId)).thenReturn(Optional.of(world));
            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            World result = useCase.makePublic(worldId);

            // Assert
            assertTrue(result.getIsPublic());
            verify(worldRepository).save(any(World.class));
        }

        @Test
        @DisplayName("should throw exception when world not found")
        void shouldThrowExceptionWhenWorldNotFound() {
            // Arrange
            UUID unknownId = UUID.randomUUID();
            when(worldRepository.findById(unknownId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.makePublic(unknownId)
            );

            assertTrue(exception.getMessage().contains("World not found"));
        }

        @Test
        @DisplayName("should succeed even if world is already public")
        void shouldSucceedEvenIfWorldAlreadyPublic() {
            // Arrange
            World world = createWorldInStatus(WorldStatus.DRAFT);
            world.setIsPublic(true);
            when(worldRepository.findById(worldId)).thenReturn(Optional.of(world));
            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            World result = useCase.makePublic(worldId);

            // Assert
            assertTrue(result.getIsPublic());
            verify(worldRepository).save(any(World.class));
        }
    }

    @Nested
    @DisplayName("makePrivate")
    class MakePrivate {

        @Test
        @DisplayName("should make world private successfully")
        void shouldMakeWorldPrivateSuccessfully() {
            // Arrange
            World world = createWorldInStatus(WorldStatus.DRAFT);
            world.setIsPublic(true);
            when(worldRepository.findById(worldId)).thenReturn(Optional.of(world));
            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            World result = useCase.makePrivate(worldId);

            // Assert
            assertFalse(result.getIsPublic());
            verify(worldRepository).save(any(World.class));
        }

        @Test
        @DisplayName("should throw exception when world not found")
        void shouldThrowExceptionWhenWorldNotFound() {
            // Arrange
            UUID unknownId = UUID.randomUUID();
            when(worldRepository.findById(unknownId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.makePrivate(unknownId)
            );

            assertTrue(exception.getMessage().contains("World not found"));
        }

        @Test
        @DisplayName("should succeed even if world is already private")
        void shouldSucceedEvenIfWorldAlreadyPrivate() {
            // Arrange
            World world = createWorldInStatus(WorldStatus.DRAFT);
            world.setIsPublic(false);
            when(worldRepository.findById(worldId)).thenReturn(Optional.of(world));
            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            World result = useCase.makePrivate(worldId);

            // Assert
            assertFalse(result.getIsPublic());
            verify(worldRepository).save(any(World.class));
        }
    }
}
