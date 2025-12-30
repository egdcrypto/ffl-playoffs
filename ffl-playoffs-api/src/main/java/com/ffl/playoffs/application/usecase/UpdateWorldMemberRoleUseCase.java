package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.WorldAccessControl;
import com.ffl.playoffs.domain.model.accesscontrol.WorldRole;
import com.ffl.playoffs.domain.port.WorldAccessControlRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

/**
 * Use case for updating a member's role in a world.
 */
public class UpdateWorldMemberRoleUseCase {

    private final WorldAccessControlRepository repository;

    public UpdateWorldMemberRoleUseCase(WorldAccessControlRepository repository) {
        this.repository = repository;
    }

    /**
     * Updates a member's role.
     *
     * @param command The update role command
     * @return The updated WorldAccessControl
     * @throws IllegalArgumentException if world not found or user not a member
     * @throws IllegalStateException if updater lacks permission
     */
    public WorldAccessControl execute(UpdateMemberRoleCommand command) {
        // Find the access control
        WorldAccessControl accessControl = repository.findByWorldId(command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("World access control not found: " + command.getWorldId()));

        // Update role
        accessControl.updateMemberRole(
                command.getUserId(),
                command.getNewRole(),
                command.getUpdatedBy()
        );

        // Save and return
        return repository.save(accessControl);
    }

    @Getter
    @Builder
    public static class UpdateMemberRoleCommand {
        private final UUID worldId;
        private final UUID userId;
        private final WorldRole newRole;
        private final UUID updatedBy;
    }
}
