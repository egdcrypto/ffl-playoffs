package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.World;
import com.ffl.playoffs.domain.port.WorldRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("UpdateWorldUseCase Tests")
class UpdateWorldUseCaseTest {

    @Mock
    private WorldRepository worldRepository;

    @Captor
    private ArgumentCaptor<World> worldCaptor;

    private UpdateWorldUseCase useCase;

    private UUID worldId;
    private UUID ownerId;
    private World draftWorld;

    @BeforeEach
    void setUp() {
        useCase = new UpdateWorldUseCase(worldRepository);

        worldId = UUID.randomUUID();
        ownerId = UUID.randomUUID();

        draftWorld = new World("Original Name", ownerId);
        draftWorld.setId(worldId);
        draftWorld.setDescription("Original Description");
        // World is DRAFT by default, which canEdit() = true
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should update world name successfully")
        void shouldUpdateWorldNameSuccessfully() {
            // Arrange
            UpdateWorldUseCase.UpdateWorldCommand command =
                    new UpdateWorldUseCase.UpdateWorldCommand(worldId);
            command.setName("Updated Name");

            when(worldRepository.findById(worldId)).thenReturn(Optional.of(draftWorld));
            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            World result = useCase.execute(command);

            // Assert
            assertEquals("Updated Name", result.getName());
        }

        @Test
        @DisplayName("should update world description successfully")
        void shouldUpdateWorldDescriptionSuccessfully() {
            // Arrange
            UpdateWorldUseCase.UpdateWorldCommand command =
                    new UpdateWorldUseCase.UpdateWorldCommand(worldId);
            command.setDescription("Updated Description");

            when(worldRepository.findById(worldId)).thenReturn(Optional.of(draftWorld));
            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            World result = useCase.execute(command);

            // Assert
            assertEquals("Updated Description", result.getDescription());
        }

        @Test
        @DisplayName("should update multiple fields at once")
        void shouldUpdateMultipleFieldsAtOnce() {
            // Arrange
            UpdateWorldUseCase.UpdateWorldCommand command =
                    new UpdateWorldUseCase.UpdateWorldCommand(worldId);
            command.setName("New Name");
            command.setDescription("New Description");
            command.setNarrativeSource("New Source");
            command.setMaxPlayers(100);

            when(worldRepository.findById(worldId)).thenReturn(Optional.of(draftWorld));
            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            World result = useCase.execute(command);

            // Assert
            assertEquals("New Name", result.getName());
            assertEquals("New Description", result.getDescription());
            assertEquals("New Source", result.getNarrativeSource());
            assertEquals(100, result.getMaxPlayers());
        }

        @Test
        @DisplayName("should throw exception when world not found")
        void shouldThrowExceptionWhenWorldNotFound() {
            // Arrange
            UUID unknownWorldId = UUID.randomUUID();
            UpdateWorldUseCase.UpdateWorldCommand command =
                    new UpdateWorldUseCase.UpdateWorldCommand(unknownWorldId);

            when(worldRepository.findById(unknownWorldId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("World not found"));
            verify(worldRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when world cannot be edited (DEPLOYED)")
        void shouldThrowExceptionWhenWorldDeployed() {
            // Arrange
            World deployedWorld = new World("Deployed World", ownerId);
            deployedWorld.setId(worldId);
            deployedWorld.submitForReview();
            deployedWorld.approve();
            deployedWorld.deploy();

            UpdateWorldUseCase.UpdateWorldCommand command =
                    new UpdateWorldUseCase.UpdateWorldCommand(worldId);
            command.setName("Attempt Update");

            when(worldRepository.findById(worldId)).thenReturn(Optional.of(deployedWorld));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("cannot be edited"));
            verify(worldRepository, never()).save(any());
        }

        @Test
        @DisplayName("should allow update for APPROVED world")
        void shouldAllowUpdateForApprovedWorld() {
            // Arrange
            World approvedWorld = new World("Approved World", ownerId);
            approvedWorld.setId(worldId);
            approvedWorld.submitForReview();
            approvedWorld.approve();

            UpdateWorldUseCase.UpdateWorldCommand command =
                    new UpdateWorldUseCase.UpdateWorldCommand(worldId);
            command.setName("Updated Approved World");

            when(worldRepository.findById(worldId)).thenReturn(Optional.of(approvedWorld));
            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            World result = useCase.execute(command);

            // Assert
            assertEquals("Updated Approved World", result.getName());
            verify(worldRepository).save(any(World.class));
        }

        @Test
        @DisplayName("should not update field when null in command")
        void shouldNotUpdateFieldWhenNullInCommand() {
            // Arrange
            UpdateWorldUseCase.UpdateWorldCommand command =
                    new UpdateWorldUseCase.UpdateWorldCommand(worldId);
            // Only set name, leave others null
            command.setName("Updated Name");

            when(worldRepository.findById(worldId)).thenReturn(Optional.of(draftWorld));
            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            World result = useCase.execute(command);

            // Assert
            assertEquals("Updated Name", result.getName());
            assertEquals("Original Description", result.getDescription()); // Unchanged
        }

        @Test
        @DisplayName("should save world to repository")
        void shouldSaveWorldToRepository() {
            // Arrange
            UpdateWorldUseCase.UpdateWorldCommand command =
                    new UpdateWorldUseCase.UpdateWorldCommand(worldId);
            command.setName("Updated Name");

            when(worldRepository.findById(worldId)).thenReturn(Optional.of(draftWorld));
            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(worldRepository, times(1)).save(worldCaptor.capture());
            assertEquals("Updated Name", worldCaptor.getValue().getName());
        }
    }

    @Nested
    @DisplayName("UpdateWorldCommand")
    class UpdateWorldCommandTests {

        @Test
        @DisplayName("should create command with worldId")
        void shouldCreateCommandWithWorldId() {
            // Arrange & Act
            UpdateWorldUseCase.UpdateWorldCommand command =
                    new UpdateWorldUseCase.UpdateWorldCommand(worldId);

            // Assert
            assertEquals(worldId, command.getWorldId());
            assertNull(command.getName());
            assertNull(command.getDescription());
            assertNull(command.getNarrativeSource());
            assertNull(command.getMaxPlayers());
        }

        @Test
        @DisplayName("should set all optional fields")
        void shouldSetAllOptionalFields() {
            // Arrange
            UpdateWorldUseCase.UpdateWorldCommand command =
                    new UpdateWorldUseCase.UpdateWorldCommand(worldId);

            // Act
            command.setName("Name");
            command.setDescription("Description");
            command.setNarrativeSource("Source");
            command.setMaxPlayers(50);

            // Assert
            assertEquals("Name", command.getName());
            assertEquals("Description", command.getDescription());
            assertEquals("Source", command.getNarrativeSource());
            assertEquals(50, command.getMaxPlayers());
        }
    }
}
