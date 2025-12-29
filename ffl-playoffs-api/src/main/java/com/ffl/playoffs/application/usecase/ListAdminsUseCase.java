package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.UserRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Use case for listing all admin users.
 * Only SUPER_ADMIN can view the list of admins.
 */
@Service
public class ListAdminsUseCase {

    private final UserRepository userRepository;

    public ListAdminsUseCase(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    /**
     * Lists all admin users in the system.
     *
     * @param command the list command
     * @return the result containing admin list
     * @throws IllegalStateException if requester is not SUPER_ADMIN
     */
    public ListAdminsResult execute(ListAdminsCommand command) {
        // Verify requester is SUPER_ADMIN
        User requester = userRepository.findById(command.getRequesterId())
                .orElseThrow(() -> new IllegalArgumentException("Requester not found"));

        if (!requester.isSuperAdmin()) {
            throw new IllegalStateException("Only SUPER_ADMIN can view admin list");
        }

        // Get all admin users
        List<User> admins = userRepository.findByRole(Role.ADMIN);

        List<AdminSummary> adminSummaries = admins.stream()
                .map(user -> new AdminSummary(
                        user.getId(),
                        user.getEmail(),
                        user.getName(),
                        user.getGoogleId(),
                        user.getCreatedAt(),
                        user.getLastLoginAt(),
                        user.isActive()
                ))
                .collect(Collectors.toList());

        return new ListAdminsResult(adminSummaries, adminSummaries.size());
    }

    /**
     * Command for listing admins
     */
    public static class ListAdminsCommand {
        private final UUID requesterId;

        public ListAdminsCommand(UUID requesterId) {
            this.requesterId = requesterId;
        }

        public UUID getRequesterId() {
            return requesterId;
        }
    }

    /**
     * Summary of an admin user
     */
    public static class AdminSummary {
        private final UUID id;
        private final String email;
        private final String name;
        private final String googleId;
        private final LocalDateTime createdAt;
        private final LocalDateTime lastLoginAt;
        private final boolean active;

        public AdminSummary(UUID id, String email, String name, String googleId,
                           LocalDateTime createdAt, LocalDateTime lastLoginAt, boolean active) {
            this.id = id;
            this.email = email;
            this.name = name;
            this.googleId = googleId;
            this.createdAt = createdAt;
            this.lastLoginAt = lastLoginAt;
            this.active = active;
        }

        public UUID getId() {
            return id;
        }

        public String getEmail() {
            return email;
        }

        public String getName() {
            return name;
        }

        public String getGoogleId() {
            return googleId;
        }

        public LocalDateTime getCreatedAt() {
            return createdAt;
        }

        public LocalDateTime getLastLoginAt() {
            return lastLoginAt;
        }

        public boolean isActive() {
            return active;
        }
    }

    /**
     * Result containing the list of admins
     */
    public static class ListAdminsResult {
        private final List<AdminSummary> admins;
        private final int totalCount;

        public ListAdminsResult(List<AdminSummary> admins, int totalCount) {
            this.admins = admins;
            this.totalCount = totalCount;
        }

        public List<AdminSummary> getAdmins() {
            return admins;
        }

        public int getTotalCount() {
            return totalCount;
        }
    }
}
