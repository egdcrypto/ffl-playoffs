package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.WorldAccessControl;
import com.ffl.playoffs.domain.port.WorldAccessControlRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

/**
 * Use case for removing a member from a world.
 */
public class RemoveWorldMemberUseCase {

    private final WorldAccessControlRepository repository;

    public RemoveWorldMemberUseCase(WorldAccessControlRepository repository) {
        this.repository = repository;
    }

    /**
     * Removes a member from a world.
     *
     * @param command The remove member command
     * @return The updated WorldAccessControl
     * @throws IllegalArgumentException if world not found or user not a member
     * @throws IllegalStateException if remover lacks permission or trying to remove owner
     */
    public WorldAccessControl execute(RemoveMemberCommand command) {
        // Find the access control
        WorldAccessControl accessControl = repository.findByWorldId(command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("World access control not found: " + command.getWorldId()));

        // Remove member
        accessControl.removeMember(command.getUserId(), command.getRemovedBy());

        // Save and return
        return repository.save(accessControl);
    }

    @Getter
    @Builder
    public static class RemoveMemberCommand {
        private final UUID worldId;
        private final UUID userId;
        private final UUID removedBy;
    }
}
