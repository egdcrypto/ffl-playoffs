package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.WorldDTO;
import com.ffl.playoffs.application.usecase.CreateWorldUseCase;
import com.ffl.playoffs.application.usecase.DeleteWorldUseCase;
import com.ffl.playoffs.application.usecase.UpdateWorldUseCase;
import com.ffl.playoffs.application.usecase.WorldLifecycleUseCase;
import com.ffl.playoffs.domain.aggregate.World;
import com.ffl.playoffs.domain.port.WorldRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * REST controller for World management.
 * Infrastructure layer adapter for HTTP requests.
 */
@RestController
@RequestMapping("/api/v1/worlds")
@RequiredArgsConstructor
@Tag(name = "World Management", description = "APIs for managing narrative worlds")
public class WorldController {

    private final CreateWorldUseCase createWorldUseCase;
    private final UpdateWorldUseCase updateWorldUseCase;
    private final DeleteWorldUseCase deleteWorldUseCase;
    private final WorldLifecycleUseCase worldLifecycleUseCase;
    private final WorldRepository worldRepository;

    // ==================== CRUD Endpoints ====================

    @PostMapping
    @Operation(summary = "Create a new world", description = "Creates a new narrative world")
    public ResponseEntity<WorldDTO> createWorld(@Valid @RequestBody WorldDTO worldDTO) {
        CreateWorldUseCase.CreateWorldCommand command = new CreateWorldUseCase.CreateWorldCommand(
                worldDTO.getName(),
                worldDTO.getOwnerId()
        );

        if (worldDTO.getDescription() != null) {
            command.setDescription(worldDTO.getDescription());
        }
        if (worldDTO.getNarrativeSource() != null) {
            command.setNarrativeSource(worldDTO.getNarrativeSource());
        }
        if (worldDTO.getIsPublic() != null) {
            command.setIsPublic(worldDTO.getIsPublic());
        }
        if (worldDTO.getMaxPlayers() != null) {
            command.setMaxPlayers(worldDTO.getMaxPlayers());
        }

        World createdWorld = createWorldUseCase.execute(command);
        return ResponseEntity.status(HttpStatus.CREATED).body(mapToDTO(createdWorld));
    }

    @GetMapping("/{worldId}")
    @Operation(summary = "Get world details", description = "Retrieves details of a specific world")
    public ResponseEntity<WorldDTO> getWorld(@PathVariable UUID worldId) {
        return worldRepository.findById(worldId)
                .map(this::mapToDTO)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping
    @Operation(summary = "List all worlds", description = "Retrieves a list of all worlds")
    public ResponseEntity<List<WorldDTO>> listWorlds() {
        List<World> worlds = worldRepository.findAll();
        List<WorldDTO> worldDTOs = worlds.stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(worldDTOs);
    }

    @GetMapping("/owner/{ownerId}")
    @Operation(summary = "List worlds by owner", description = "Retrieves all worlds owned by a specific user")
    public ResponseEntity<List<WorldDTO>> listWorldsByOwner(@PathVariable UUID ownerId) {
        List<World> worlds = worldRepository.findByOwnerId(ownerId);
        List<WorldDTO> worldDTOs = worlds.stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(worldDTOs);
    }

    @GetMapping("/public")
    @Operation(summary = "List public worlds", description = "Retrieves all public worlds")
    public ResponseEntity<List<WorldDTO>> listPublicWorlds() {
        List<World> worlds = worldRepository.findPublicWorlds();
        List<WorldDTO> worldDTOs = worlds.stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(worldDTOs);
    }

    @GetMapping("/deployed")
    @Operation(summary = "List deployed worlds", description = "Retrieves all deployed worlds")
    public ResponseEntity<List<WorldDTO>> listDeployedWorlds() {
        List<World> worlds = worldRepository.findDeployedWorlds();
        List<WorldDTO> worldDTOs = worlds.stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(worldDTOs);
    }

    @PutMapping("/{worldId}")
    @Operation(summary = "Update a world", description = "Updates an existing world")
    public ResponseEntity<WorldDTO> updateWorld(
            @PathVariable UUID worldId,
            @Valid @RequestBody WorldDTO worldDTO) {

        UpdateWorldUseCase.UpdateWorldCommand command = new UpdateWorldUseCase.UpdateWorldCommand(worldId);

        if (worldDTO.getName() != null) {
            command.setName(worldDTO.getName());
        }
        if (worldDTO.getDescription() != null) {
            command.setDescription(worldDTO.getDescription());
        }
        if (worldDTO.getNarrativeSource() != null) {
            command.setNarrativeSource(worldDTO.getNarrativeSource());
        }
        if (worldDTO.getMaxPlayers() != null) {
            command.setMaxPlayers(worldDTO.getMaxPlayers());
        }

        World updatedWorld = updateWorldUseCase.execute(command);
        return ResponseEntity.ok(mapToDTO(updatedWorld));
    }

    @DeleteMapping("/{worldId}")
    @Operation(summary = "Delete a world", description = "Deletes a draft world")
    public ResponseEntity<Void> deleteWorld(@PathVariable UUID worldId) {
        deleteWorldUseCase.execute(new DeleteWorldUseCase.DeleteWorldCommand(worldId));
        return ResponseEntity.noContent().build();
    }

    // ==================== Lifecycle Endpoints ====================

    @PostMapping("/{worldId}/submit-for-review")
    @Operation(summary = "Submit world for review", description = "Submits a draft world for review")
    public ResponseEntity<WorldDTO> submitForReview(@PathVariable UUID worldId) {
        World world = worldLifecycleUseCase.submitForReview(worldId);
        return ResponseEntity.ok(mapToDTO(world));
    }

    @PostMapping("/{worldId}/approve")
    @Operation(summary = "Approve world", description = "Approves a world after review")
    public ResponseEntity<WorldDTO> approveWorld(@PathVariable UUID worldId) {
        World world = worldLifecycleUseCase.approve(worldId);
        return ResponseEntity.ok(mapToDTO(world));
    }

    @PostMapping("/{worldId}/reject")
    @Operation(summary = "Reject world", description = "Rejects a world, returning it to draft")
    public ResponseEntity<WorldDTO> rejectWorld(@PathVariable UUID worldId) {
        World world = worldLifecycleUseCase.reject(worldId);
        return ResponseEntity.ok(mapToDTO(world));
    }

    @PostMapping("/{worldId}/deploy")
    @Operation(summary = "Deploy world", description = "Deploys an approved world for players")
    public ResponseEntity<WorldDTO> deployWorld(@PathVariable UUID worldId) {
        World world = worldLifecycleUseCase.deploy(worldId);
        return ResponseEntity.ok(mapToDTO(world));
    }

    @PostMapping("/{worldId}/undeploy")
    @Operation(summary = "Undeploy world", description = "Takes a deployed world offline")
    public ResponseEntity<WorldDTO> undeployWorld(@PathVariable UUID worldId) {
        World world = worldLifecycleUseCase.undeploy(worldId);
        return ResponseEntity.ok(mapToDTO(world));
    }

    @PostMapping("/{worldId}/archive")
    @Operation(summary = "Archive world", description = "Archives a world")
    public ResponseEntity<WorldDTO> archiveWorld(@PathVariable UUID worldId) {
        World world = worldLifecycleUseCase.archive(worldId);
        return ResponseEntity.ok(mapToDTO(world));
    }

    @PostMapping("/{worldId}/make-public")
    @Operation(summary = "Make world public", description = "Makes a world publicly visible")
    public ResponseEntity<WorldDTO> makePublic(@PathVariable UUID worldId) {
        World world = worldLifecycleUseCase.makePublic(worldId);
        return ResponseEntity.ok(mapToDTO(world));
    }

    @PostMapping("/{worldId}/make-private")
    @Operation(summary = "Make world private", description = "Makes a world private")
    public ResponseEntity<WorldDTO> makePrivate(@PathVariable UUID worldId) {
        World world = worldLifecycleUseCase.makePrivate(worldId);
        return ResponseEntity.ok(mapToDTO(world));
    }

    // ==================== Mapping Methods ====================

    private WorldDTO mapToDTO(World world) {
        WorldDTO dto = new WorldDTO();
        dto.setId(world.getId());
        dto.setName(world.getName());
        dto.setDescription(world.getDescription());
        dto.setOwnerId(world.getOwnerId());
        dto.setNarrativeSource(world.getNarrativeSource());
        dto.setStatus(world.getStatus() != null ? world.getStatus().name() : null);
        dto.setIsPublic(world.getIsPublic());
        dto.setMaxPlayers(world.getMaxPlayers());
        dto.setIsDeployed(world.getIsDeployed());
        dto.setDeployedAt(world.getDeployedAt());
        dto.setCreatedAt(world.getCreatedAt());
        dto.setUpdatedAt(world.getUpdatedAt());
        return dto;
    }
}
