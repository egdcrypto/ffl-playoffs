package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("ListAdminsUseCase Tests")
class ListAdminsUseCaseTest {

    @Mock
    private UserRepository userRepository;

    private ListAdminsUseCase listAdminsUseCase;

    @BeforeEach
    void setUp() {
        listAdminsUseCase = new ListAdminsUseCase(userRepository);
    }

    @Test
    @DisplayName("should return paginated list of admins")
    void shouldReturnPaginatedListOfAdmins() {
        // Arrange
        User admin1 = createAdmin("admin1@example.com", "Admin One", Role.ADMIN);
        User admin2 = createAdmin("admin2@example.com", "Admin Two", Role.ADMIN);
        User superAdmin = createAdmin("superadmin@example.com", "Super Admin", Role.SUPER_ADMIN);

        when(userRepository.findByRoles(anyList())).thenReturn(Arrays.asList(admin1, admin2, superAdmin));

        ListAdminsUseCase.ListAdminsCommand command = new ListAdminsUseCase.ListAdminsCommand(0, 10);

        // Act
        ListAdminsUseCase.ListAdminsResult result = listAdminsUseCase.execute(command);

        // Assert
        assertNotNull(result);
        assertEquals(3, result.getAdmins().size());
        assertEquals(0, result.getPage());
        assertEquals(10, result.getSize());
        assertEquals(3, result.getTotalElements());
        assertEquals(1, result.getTotalPages());
        assertFalse(result.isHasNext());
        assertFalse(result.isHasPrevious());
    }

    @Test
    @DisplayName("should return empty list when no admins exist")
    void shouldReturnEmptyListWhenNoAdmins() {
        // Arrange
        when(userRepository.findByRoles(anyList())).thenReturn(List.of());

        ListAdminsUseCase.ListAdminsCommand command = new ListAdminsUseCase.ListAdminsCommand(0, 10);

        // Act
        ListAdminsUseCase.ListAdminsResult result = listAdminsUseCase.execute(command);

        // Assert
        assertNotNull(result);
        assertEquals(0, result.getAdmins().size());
        assertEquals(0, result.getTotalElements());
    }

    @Test
    @DisplayName("should handle pagination correctly")
    void shouldHandlePaginationCorrectly() {
        // Arrange
        User admin1 = createAdmin("admin1@example.com", "Admin One", Role.ADMIN);
        User admin2 = createAdmin("admin2@example.com", "Admin Two", Role.ADMIN);
        User admin3 = createAdmin("admin3@example.com", "Admin Three", Role.ADMIN);

        when(userRepository.findByRoles(anyList())).thenReturn(Arrays.asList(admin1, admin2, admin3));

        ListAdminsUseCase.ListAdminsCommand command = new ListAdminsUseCase.ListAdminsCommand(0, 2);

        // Act
        ListAdminsUseCase.ListAdminsResult result = listAdminsUseCase.execute(command);

        // Assert
        assertNotNull(result);
        assertEquals(2, result.getAdmins().size());
        assertEquals(3, result.getTotalElements());
        assertEquals(2, result.getTotalPages());
        assertTrue(result.isHasNext());
        assertFalse(result.isHasPrevious());
    }

    @Test
    @DisplayName("should return second page correctly")
    void shouldReturnSecondPageCorrectly() {
        // Arrange
        User admin1 = createAdmin("admin1@example.com", "Admin One", Role.ADMIN);
        User admin2 = createAdmin("admin2@example.com", "Admin Two", Role.ADMIN);
        User admin3 = createAdmin("admin3@example.com", "Admin Three", Role.ADMIN);

        when(userRepository.findByRoles(anyList())).thenReturn(Arrays.asList(admin1, admin2, admin3));

        ListAdminsUseCase.ListAdminsCommand command = new ListAdminsUseCase.ListAdminsCommand(1, 2);

        // Act
        ListAdminsUseCase.ListAdminsResult result = listAdminsUseCase.execute(command);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.getAdmins().size());
        assertEquals(1, result.getPage());
        assertFalse(result.isHasNext());
        assertTrue(result.isHasPrevious());
    }

    @Test
    @DisplayName("should return empty list for out of range page")
    void shouldReturnEmptyListForOutOfRangePage() {
        // Arrange
        User admin1 = createAdmin("admin1@example.com", "Admin One", Role.ADMIN);

        when(userRepository.findByRoles(anyList())).thenReturn(List.of(admin1));

        ListAdminsUseCase.ListAdminsCommand command = new ListAdminsUseCase.ListAdminsCommand(10, 10);

        // Act
        ListAdminsUseCase.ListAdminsResult result = listAdminsUseCase.execute(command);

        // Assert
        assertNotNull(result);
        assertEquals(0, result.getAdmins().size());
    }

    @Test
    @DisplayName("should include admin summary with all fields")
    void shouldIncludeAdminSummaryWithAllFields() {
        // Arrange
        User admin = createAdmin("admin@example.com", "Admin User", Role.ADMIN);
        admin.setActive(true);
        admin.setLastLoginAt(LocalDateTime.now());

        when(userRepository.findByRoles(anyList())).thenReturn(List.of(admin));

        ListAdminsUseCase.ListAdminsCommand command = new ListAdminsUseCase.ListAdminsCommand(0, 10);

        // Act
        ListAdminsUseCase.ListAdminsResult result = listAdminsUseCase.execute(command);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.getAdmins().size());

        ListAdminsUseCase.AdminSummary summary = result.getAdmins().get(0);
        assertNotNull(summary.getId());
        assertEquals("admin@example.com", summary.getEmail());
        assertEquals("Admin User", summary.getName());
        assertEquals("ADMIN", summary.getRole());
        assertNotNull(summary.getCreatedAt());
        assertNotNull(summary.getLastLoginAt());
        assertTrue(summary.isActive());
    }

    private User createAdmin(String email, String name, Role role) {
        User user = new User(email, name, "google" + UUID.randomUUID(), role);
        user.setId(UUID.randomUUID());
        user.setCreatedAt(LocalDateTime.now());
        user.setActive(true);
        return user;
    }
}
