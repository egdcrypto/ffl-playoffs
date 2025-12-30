package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.worldowner.OwnershipRole;
import com.ffl.playoffs.domain.model.worldowner.WorldOwnerPlayer;
import com.ffl.playoffs.domain.port.WorldOwnerPlayerRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

/**
 * Use case for transferring primary ownership of a world.
 */
public class TransferWorldPrimaryOwnershipUseCase {

    private final WorldOwnerPlayerRepository repository;

    public TransferWorldPrimaryOwnershipUseCase(WorldOwnerPlayerRepository repository) {
        this.repository = repository;
    }

    /**
     * Transfers primary ownership to another owner.
     *
     * @param command The transfer command
     * @return The new primary owner
     * @throws IllegalArgumentException if owners not found
     * @throws IllegalStateException if current owner is not PRIMARY_OWNER or new owner is not active
     */
    public WorldOwnerPlayer execute(TransferOwnershipCommand command) {
        // Get current owner
        WorldOwnerPlayer currentOwner = repository.findByUserIdAndWorldId(
                command.getCurrentOwnerId(), command.getWorldId()
        ).orElseThrow(() -> new IllegalArgumentException("Current owner not found"));

        // Verify current owner is PRIMARY_OWNER
        if (currentOwner.getRole() != OwnershipRole.PRIMARY_OWNER) {
            throw new IllegalStateException("Only PRIMARY_OWNER can transfer ownership");
        }

        // Get new owner
        WorldOwnerPlayer newOwner = repository.findByUserIdAndWorldId(
                command.getNewOwnerId(), command.getWorldId()
        ).orElseThrow(() -> new IllegalArgumentException("New owner is not an owner of this world"));

        // Verify new owner is active
        if (!newOwner.isActive()) {
            throw new IllegalStateException("New owner must be an active owner");
        }

        // Transfer ownership
        currentOwner.demoteFromPrimaryOwner(command.getDemoteTo() != null ?
                command.getDemoteTo() : OwnershipRole.CO_OWNER);
        newOwner.promoteToPrimaryOwner();

        // Save both
        repository.save(currentOwner);
        return repository.save(newOwner);
    }

    @Getter
    @Builder
    public static class TransferOwnershipCommand {
        private final UUID worldId;
        private final UUID currentOwnerId;
        private final UUID newOwnerId;
        private final OwnershipRole demoteTo; // Optional: what role current owner becomes
    }
}
