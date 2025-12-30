package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.worldowner.OwnershipRole;
import com.ffl.playoffs.domain.model.worldowner.WorldOwnerPermission;
import com.ffl.playoffs.domain.model.worldowner.WorldOwnerPlayer;
import com.ffl.playoffs.domain.port.WorldOwnerPlayerRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

/**
 * Use case for updating an owner's role.
 */
public class UpdateWorldOwnerRoleUseCase {

    private final WorldOwnerPlayerRepository repository;

    public UpdateWorldOwnerRoleUseCase(WorldOwnerPlayerRepository repository) {
        this.repository = repository;
    }

    /**
     * Updates an owner's role.
     *
     * @param command The update command
     * @return The updated WorldOwnerPlayer
     * @throws IllegalArgumentException if owner not found
     * @throws IllegalStateException if updater lacks permission
     */
    public WorldOwnerPlayer execute(UpdateRoleCommand command) {
        // Get the owner to be updated
        WorldOwnerPlayer ownerToUpdate = repository.findByUserIdAndWorldId(command.getUserId(), command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("User is not an owner of this world"));

        // Verify updater has permission
        WorldOwnerPlayer updater = repository.findByUserIdAndWorldId(command.getUpdatedBy(), command.getWorldId())
                .orElseThrow(() -> new IllegalStateException("Updater is not an owner of this world"));

        if (!updater.hasPermission(WorldOwnerPermission.MANAGE_OWNERS)) {
            throw new IllegalStateException("Updater does not have permission to manage owners");
        }

        // Cannot update to or from PRIMARY_OWNER
        if (ownerToUpdate.getRole() == OwnershipRole.PRIMARY_OWNER) {
            throw new IllegalStateException("Cannot change PRIMARY_OWNER role; use transfer ownership");
        }
        if (command.getNewRole() == OwnershipRole.PRIMARY_OWNER) {
            throw new IllegalStateException("Cannot promote to PRIMARY_OWNER; use transfer ownership");
        }

        // Cannot grant role higher than own
        if (!updater.getRole().canGrantRole(command.getNewRole())) {
            throw new IllegalStateException("Cannot grant role equal to or higher than own role");
        }

        // Update role
        ownerToUpdate.updateRole(command.getNewRole());

        // Save and return
        return repository.save(ownerToUpdate);
    }

    @Getter
    @Builder
    public static class UpdateRoleCommand {
        private final UUID userId;
        private final UUID worldId;
        private final OwnershipRole newRole;
        private final UUID updatedBy;
    }
}
