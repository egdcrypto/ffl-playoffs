package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.UserRepository;
import com.ffl.playoffs.domain.service.AccessControlService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

/**
 * Use case for listing users
 * Only SUPER_ADMIN can list all users
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class ListUsersUseCase {

    private final UserRepository userRepository;
    private final AccessControlService accessControlService;

    /**
     * Lists users based on requester's permissions
     * @param command the list command
     * @return list of users visible to the requester
     * @throws AccessControlService.AccessDeniedException if not authorized
     */
    public List<User> execute(ListUsersCommand command) {
        log.info("Listing users for requester: {}", command.getRequestedBy());

        User requester = userRepository.findById(command.getRequestedBy())
                .orElseThrow(() -> new IllegalArgumentException("Requester not found"));

        // Only super admin can list all users
        if (!accessControlService.canViewSystemWideData(requester)) {
            throw new AccessControlService.AccessDeniedException(
                    "Only super admin can view system-wide user list");
        }

        // Get all users based on filter
        List<User> users;
        if (command.getRoleFilter() != null) {
            users = userRepository.findByRole(command.getRoleFilter());
        } else {
            users = userRepository.findAll();
        }

        // Apply active filter if specified
        if (command.isActiveOnly()) {
            users = users.stream()
                    .filter(User::isActive)
                    .toList();
        }

        log.info("Found {} users", users.size());
        return users;
    }

    /**
     * Command object for listing users
     */
    public static class ListUsersCommand {
        private final UUID requestedBy;
        private final Role roleFilter;
        private final boolean activeOnly;

        public ListUsersCommand(UUID requestedBy, Role roleFilter, boolean activeOnly) {
            this.requestedBy = requestedBy;
            this.roleFilter = roleFilter;
            this.activeOnly = activeOnly;
        }

        public ListUsersCommand(UUID requestedBy) {
            this(requestedBy, null, false);
        }

        public UUID getRequestedBy() {
            return requestedBy;
        }

        public Role getRoleFilter() {
            return roleFilter;
        }

        public boolean isActiveOnly() {
            return activeOnly;
        }
    }
}
