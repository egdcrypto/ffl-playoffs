package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.UserRepository;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Use case for listing all admin users in the system
 * Returns users with ADMIN or SUPER_ADMIN roles
 */
public class ListAdminsUseCase {

    private final UserRepository userRepository;

    public ListAdminsUseCase(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    /**
     * Lists all admin users with pagination
     *
     * @param command The list admins command
     * @return Paginated list of admin users
     */
    public ListAdminsResult execute(ListAdminsCommand command) {
        // Get all users with ADMIN or SUPER_ADMIN roles
        List<User> allAdmins = userRepository.findByRoles(
                Arrays.asList(Role.ADMIN, Role.SUPER_ADMIN)
        );

        // Calculate pagination
        int totalElements = allAdmins.size();
        int startIndex = command.getPage() * command.getSize();
        int endIndex = Math.min(startIndex + command.getSize(), totalElements);

        // Get paginated subset
        List<User> pagedAdmins = startIndex < totalElements
                ? allAdmins.subList(startIndex, endIndex)
                : List.of();

        // Convert to DTOs
        List<AdminSummary> adminSummaries = pagedAdmins.stream()
                .map(user -> new AdminSummary(
                        user.getId(),
                        user.getEmail(),
                        user.getName(),
                        user.getRole().name(),
                        user.getCreatedAt(),
                        user.getLastLoginAt(),
                        user.isActive()
                ))
                .collect(Collectors.toList());

        return new ListAdminsResult(
                adminSummaries,
                command.getPage(),
                command.getSize(),
                totalElements
        );
    }

    /**
     * Command object for listing admins
     */
    public static class ListAdminsCommand {
        private final int page;
        private final int size;

        public ListAdminsCommand(int page, int size) {
            this.page = Math.max(0, page);
            this.size = Math.max(1, Math.min(100, size)); // Cap at 100
        }

        public int getPage() {
            return page;
        }

        public int getSize() {
            return size;
        }
    }

    /**
     * Result object containing paginated admin list
     */
    public static class ListAdminsResult {
        private final List<AdminSummary> admins;
        private final int page;
        private final int size;
        private final long totalElements;
        private final int totalPages;
        private final boolean hasNext;
        private final boolean hasPrevious;

        public ListAdminsResult(List<AdminSummary> admins, int page, int size, long totalElements) {
            this.admins = admins;
            this.page = page;
            this.size = size;
            this.totalElements = totalElements;
            this.totalPages = (int) Math.ceil((double) totalElements / size);
            this.hasNext = page < totalPages - 1;
            this.hasPrevious = page > 0;
        }

        public List<AdminSummary> getAdmins() {
            return admins;
        }

        public int getPage() {
            return page;
        }

        public int getSize() {
            return size;
        }

        public long getTotalElements() {
            return totalElements;
        }

        public int getTotalPages() {
            return totalPages;
        }

        public boolean isHasNext() {
            return hasNext;
        }

        public boolean isHasPrevious() {
            return hasPrevious;
        }
    }

    /**
     * Summary DTO for admin user
     */
    public static class AdminSummary {
        private final UUID id;
        private final String email;
        private final String name;
        private final String role;
        private final LocalDateTime createdAt;
        private final LocalDateTime lastLoginAt;
        private final boolean active;

        public AdminSummary(UUID id, String email, String name, String role,
                           LocalDateTime createdAt, LocalDateTime lastLoginAt, boolean active) {
            this.id = id;
            this.email = email;
            this.name = name;
            this.role = role;
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

        public String getRole() {
            return role;
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
}
