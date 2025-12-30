package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.WorldAccessControl;
import com.ffl.playoffs.domain.port.WorldAccessControlRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

/**
 * Use case for transferring world ownership to another user.
 */
public class TransferWorldOwnershipUseCase {

    private final WorldAccessControlRepository repository;

    public TransferWorldOwnershipUseCase(WorldAccessControlRepository repository) {
        this.repository = repository;
    }

    /**
     * Transfers ownership of a world to a new owner.
     *
     * @param command The transfer ownership command
     * @return The updated WorldAccessControl
     * @throws IllegalArgumentException if world not found
     * @throws IllegalStateException if requester is not the current owner
     */
    public WorldAccessControl execute(TransferOwnershipCommand command) {
        // Find the access control
        WorldAccessControl accessControl = repository.findByWorldId(command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("World access control not found: " + command.getWorldId()));

        // Transfer ownership
        accessControl.transferOwnership(command.getNewOwnerId(), command.getCurrentOwnerId());

        // Save and return
        return repository.save(accessControl);
    }

    @Getter
    @Builder
    public static class TransferOwnershipCommand {
        private final UUID worldId;
        private final UUID newOwnerId;
        private final UUID currentOwnerId;
    }
}
