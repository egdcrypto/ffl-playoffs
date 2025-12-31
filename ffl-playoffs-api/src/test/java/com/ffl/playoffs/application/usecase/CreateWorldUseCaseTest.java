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

import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CreateWorldUseCase Tests")
class CreateWorldUseCaseTest {

    @Mock
    private WorldRepository worldRepository;

    @Captor
    private ArgumentCaptor<World> worldCaptor;

    private CreateWorldUseCase useCase;

    private UUID ownerId;

    @BeforeEach
    void setUp() {
        useCase = new CreateWorldUseCase(worldRepository);
        ownerId = UUID.randomUUID();
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should create world with required fields only")
        void shouldCreateWorldWithRequiredFieldsOnly() {
            // Arrange
            CreateWorldUseCase.CreateWorldCommand command =
                    new CreateWorldUseCase.CreateWorldCommand("Test World", ownerId);

            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            World result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals("Test World", result.getName());
            assertEquals(ownerId, result.getOwnerId());
        }

        @Test
        @DisplayName("should create world with all optional fields")
        void shouldCreateWorldWithAllOptionalFields() {
            // Arrange
            CreateWorldUseCase.CreateWorldCommand command =
                    new CreateWorldUseCase.CreateWorldCommand("Test World", ownerId);
            command.setDescription("Test Description");
            command.setNarrativeSource("Romeo and Juliet");
            command.setIsPublic(true);
            command.setMaxPlayers(50);

            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            World result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals("Test World", result.getName());
            assertEquals("Test Description", result.getDescription());
            assertEquals("Romeo and Juliet", result.getNarrativeSource());
            assertTrue(result.getIsPublic());
            assertEquals(50, result.getMaxPlayers());
        }

        @Test
        @DisplayName("should save world to repository")
        void shouldSaveWorldToRepository() {
            // Arrange
            CreateWorldUseCase.CreateWorldCommand command =
                    new CreateWorldUseCase.CreateWorldCommand("Test World", ownerId);

            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(worldRepository, times(1)).save(worldCaptor.capture());
            World savedWorld = worldCaptor.getValue();
            assertEquals("Test World", savedWorld.getName());
            assertEquals(ownerId, savedWorld.getOwnerId());
        }

        @Test
        @DisplayName("should handle null optional fields")
        void shouldHandleNullOptionalFields() {
            // Arrange
            CreateWorldUseCase.CreateWorldCommand command =
                    new CreateWorldUseCase.CreateWorldCommand("Test World", ownerId);
            // Optional fields are null by default

            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            World result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertNull(command.getDescription());
            assertNull(command.getNarrativeSource());
            assertNull(command.getIsPublic());
            assertNull(command.getMaxPlayers());
        }

        @Test
        @DisplayName("should set description when provided")
        void shouldSetDescriptionWhenProvided() {
            // Arrange
            CreateWorldUseCase.CreateWorldCommand command =
                    new CreateWorldUseCase.CreateWorldCommand("Test World", ownerId);
            command.setDescription("My World Description");

            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(worldRepository).save(worldCaptor.capture());
            assertEquals("My World Description", worldCaptor.getValue().getDescription());
        }

        @Test
        @DisplayName("should set narrative source when provided")
        void shouldSetNarrativeSourceWhenProvided() {
            // Arrange
            CreateWorldUseCase.CreateWorldCommand command =
                    new CreateWorldUseCase.CreateWorldCommand("Test World", ownerId);
            command.setNarrativeSource("Hamlet");

            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(worldRepository).save(worldCaptor.capture());
            assertEquals("Hamlet", worldCaptor.getValue().getNarrativeSource());
        }

        @Test
        @DisplayName("should set isPublic when provided")
        void shouldSetIsPublicWhenProvided() {
            // Arrange
            CreateWorldUseCase.CreateWorldCommand command =
                    new CreateWorldUseCase.CreateWorldCommand("Test World", ownerId);
            command.setIsPublic(false);

            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(worldRepository).save(worldCaptor.capture());
            assertFalse(worldCaptor.getValue().getIsPublic());
        }

        @Test
        @DisplayName("should set maxPlayers when provided")
        void shouldSetMaxPlayersWhenProvided() {
            // Arrange
            CreateWorldUseCase.CreateWorldCommand command =
                    new CreateWorldUseCase.CreateWorldCommand("Test World", ownerId);
            command.setMaxPlayers(100);

            when(worldRepository.save(any(World.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(worldRepository).save(worldCaptor.capture());
            assertEquals(100, worldCaptor.getValue().getMaxPlayers());
        }
    }

    @Nested
    @DisplayName("CreateWorldCommand")
    class CreateWorldCommandTests {

        @Test
        @DisplayName("should create command with required fields")
        void shouldCreateCommandWithRequiredFields() {
            // Arrange & Act
            CreateWorldUseCase.CreateWorldCommand command =
                    new CreateWorldUseCase.CreateWorldCommand("Test World", ownerId);

            // Assert
            assertEquals("Test World", command.getName());
            assertEquals(ownerId, command.getOwnerId());
        }

        @Test
        @DisplayName("should set all optional fields")
        void shouldSetAllOptionalFields() {
            // Arrange
            CreateWorldUseCase.CreateWorldCommand command =
                    new CreateWorldUseCase.CreateWorldCommand("Test World", ownerId);

            // Act
            command.setDescription("Description");
            command.setNarrativeSource("Source");
            command.setIsPublic(true);
            command.setMaxPlayers(25);

            // Assert
            assertEquals("Description", command.getDescription());
            assertEquals("Source", command.getNarrativeSource());
            assertTrue(command.getIsPublic());
            assertEquals(25, command.getMaxPlayers());
        }
    }
}
