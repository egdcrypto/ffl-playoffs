package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.World;
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
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("DeleteWorldUseCase Tests")
class DeleteWorldUseCaseTest {

    @Mock
    private WorldRepository worldRepository;

    private DeleteWorldUseCase useCase;

    private UUID worldId;
    private UUID ownerId;
    private World draftWorld;

    @BeforeEach
    void setUp() {
        useCase = new DeleteWorldUseCase(worldRepository);

        worldId = UUID.randomUUID();
        ownerId = UUID.randomUUID();

        draftWorld = new World("Test World", ownerId);
        draftWorld.setId(worldId);
        // World is DRAFT by default
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should delete DRAFT world successfully")
        void shouldDeleteDraftWorldSuccessfully() {
            // Arrange
            DeleteWorldUseCase.DeleteWorldCommand command =
                    new DeleteWorldUseCase.DeleteWorldCommand(worldId);

            when(worldRepository.findById(worldId)).thenReturn(Optional.of(draftWorld));

            // Act & Assert - no exception thrown
            assertDoesNotThrow(() -> useCase.execute(command));

            verify(worldRepository).deleteById(worldId);
        }

        @Test
        @DisplayName("should throw exception when world not found")
        void shouldThrowExceptionWhenWorldNotFound() {
            // Arrange
            UUID unknownWorldId = UUID.randomUUID();
            DeleteWorldUseCase.DeleteWorldCommand command =
                    new DeleteWorldUseCase.DeleteWorldCommand(unknownWorldId);

            when(worldRepository.findById(unknownWorldId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("World not found"));
            verify(worldRepository, never()).deleteById(any());
        }

        @Test
        @DisplayName("should throw exception when world is not in DRAFT status")
        void shouldThrowExceptionWhenWorldNotDraft() {
            // Arrange
            World approvedWorld = new World("Approved World", ownerId);
            approvedWorld.setId(worldId);
            approvedWorld.submitForReview();
            approvedWorld.approve();

            DeleteWorldUseCase.DeleteWorldCommand command =
                    new DeleteWorldUseCase.DeleteWorldCommand(worldId);

            when(worldRepository.findById(worldId)).thenReturn(Optional.of(approvedWorld));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("cannot be deleted"));
            assertTrue(exception.getMessage().contains("DRAFT"));
            verify(worldRepository, never()).deleteById(any());
        }

        @Test
        @DisplayName("should throw exception when world is PENDING_REVIEW")
        void shouldThrowExceptionWhenWorldPendingReview() {
            // Arrange
            World pendingWorld = new World("Pending World", ownerId);
            pendingWorld.setId(worldId);
            pendingWorld.submitForReview();

            DeleteWorldUseCase.DeleteWorldCommand command =
                    new DeleteWorldUseCase.DeleteWorldCommand(worldId);

            when(worldRepository.findById(worldId)).thenReturn(Optional.of(pendingWorld));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("cannot be deleted"));
            verify(worldRepository, never()).deleteById(any());
        }

        @Test
        @DisplayName("should call deleteById on repository")
        void shouldCallDeleteByIdOnRepository() {
            // Arrange
            DeleteWorldUseCase.DeleteWorldCommand command =
                    new DeleteWorldUseCase.DeleteWorldCommand(worldId);

            when(worldRepository.findById(worldId)).thenReturn(Optional.of(draftWorld));

            // Act
            useCase.execute(command);

            // Assert
            verify(worldRepository, times(1)).deleteById(worldId);
        }
    }

    @Nested
    @DisplayName("DeleteWorldCommand")
    class DeleteWorldCommandTests {

        @Test
        @DisplayName("should create command with worldId")
        void shouldCreateCommandWithWorldId() {
            // Arrange & Act
            DeleteWorldUseCase.DeleteWorldCommand command =
                    new DeleteWorldUseCase.DeleteWorldCommand(worldId);

            // Assert
            assertEquals(worldId, command.getWorldId());
        }
    }
}
