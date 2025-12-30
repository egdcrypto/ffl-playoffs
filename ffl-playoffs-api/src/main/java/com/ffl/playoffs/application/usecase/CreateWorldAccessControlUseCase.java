package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.WorldAccessControl;
import com.ffl.playoffs.domain.port.WorldAccessControlRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

/**
 * Use case for creating access control for a new world.
 */
public class CreateWorldAccessControlUseCase {

    private final WorldAccessControlRepository repository;

    public CreateWorldAccessControlUseCase(WorldAccessControlRepository repository) {
        this.repository = repository;
    }

    /**
     * Creates access control for a new world.
     *
     * @param command The create command
     * @return The created WorldAccessControl
     * @throws IllegalStateException if access control already exists for the world
     */
    public WorldAccessControl execute(CreateWorldAccessControlCommand command) {
        // Check if access control already exists
        if (repository.existsByWorldId(command.getWorldId())) {
            throw new IllegalStateException("Access control already exists for world: " + command.getWorldId());
        }

        // Create access control
        WorldAccessControl accessControl = WorldAccessControl.create(
                command.getWorldId(),
                command.getOwnerId()
        );

        // Set optional properties
        if (command.getIsPublic() != null) {
            accessControl.setPublic(command.getIsPublic());
        }
        if (command.getRequiresApproval() != null) {
            accessControl.setRequiresApproval(command.getRequiresApproval());
        }
        if (command.getMaxMembers() != null) {
            accessControl.setMaxMembers(command.getMaxMembers());
        }

        // Save and return
        return repository.save(accessControl);
    }

    @Getter
    @Builder
    public static class CreateWorldAccessControlCommand {
        private final UUID worldId;
        private final UUID ownerId;
        private final Boolean isPublic;
        private final Boolean requiresApproval;
        private final Integer maxMembers;
    }
}
