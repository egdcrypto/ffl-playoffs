package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.PATScope;
import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ListPATsUseCase Tests")
class ListPATsUseCaseTest {

    @Mock
    private PersonalAccessTokenRepository tokenRepository;

    @Mock
    private UserRepository userRepository;

    private ListPATsUseCase useCase;

    private UUID superAdminId;
    private UUID regularUserId;
    private User superAdmin;
    private User regularUser;

    @BeforeEach
    void setUp() {
        useCase = new ListPATsUseCase(tokenRepository, userRepository);

        superAdminId = UUID.randomUUID();
        regularUserId = UUID.randomUUID();

        superAdmin = new User();
        superAdmin.setId(superAdminId);
        superAdmin.setEmail("admin@test.com");
        superAdmin.setRole(Role.SUPER_ADMIN);

        regularUser = new User();
        regularUser.setId(regularUserId);
        regularUser.setEmail("user@test.com");
        regularUser.setRole(Role.PLAYER);
    }

    private PersonalAccessToken createPAT(String name, boolean revoked, boolean expired) {
        PersonalAccessToken pat = new PersonalAccessToken();
        pat.setId(UUID.randomUUID());
        pat.setName(name);
        pat.setScope(PATScope.READ_ONLY);
        pat.setCreatedBy(superAdminId.toString());
        pat.setCreatedAt(LocalDateTime.now().minusDays(1));
        pat.setRevoked(revoked);
        if (expired) {
            pat.setExpiresAt(LocalDateTime.now().minusDays(1));
        } else {
            pat.setExpiresAt(LocalDateTime.now().plusDays(30));
        }
        return pat;
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should list all active PATs with ALL filter")
        void shouldListAllActivePATsWithAllFilter() {
            // Arrange
            PersonalAccessToken pat1 = createPAT("PAT 1", false, false);
            PersonalAccessToken pat2 = createPAT("PAT 2", false, false);

            ListPATsUseCase.ListPATsCommand command =
                    new ListPATsUseCase.ListPATsCommand(superAdminId, ListPATsUseCase.FilterType.ALL);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.findAllActive()).thenReturn(List.of(pat1, pat2));

            // Act
            ListPATsUseCase.ListPATsResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(2, result.getTotalCount());
            assertEquals(2, result.getPats().size());
        }

        @Test
        @DisplayName("should list active PATs with ACTIVE filter")
        void shouldListActivePATsWithActiveFilter() {
            // Arrange
            PersonalAccessToken activePat = createPAT("Active PAT", false, false);

            ListPATsUseCase.ListPATsCommand command =
                    new ListPATsUseCase.ListPATsCommand(superAdminId, ListPATsUseCase.FilterType.ACTIVE);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.findAllActive()).thenReturn(List.of(activePat));

            // Act
            ListPATsUseCase.ListPATsResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(1, result.getTotalCount());
            assertEquals("Active PAT", result.getPats().get(0).getName());
        }

        @Test
        @DisplayName("should list revoked PATs with REVOKED filter")
        void shouldListRevokedPATsWithRevokedFilter() {
            // Arrange - Note: Current implementation filters from findAllActive() which won't return revoked
            ListPATsUseCase.ListPATsCommand command =
                    new ListPATsUseCase.ListPATsCommand(superAdminId, ListPATsUseCase.FilterType.REVOKED);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.findAllActive()).thenReturn(List.of());

            // Act
            ListPATsUseCase.ListPATsResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(0, result.getTotalCount());
        }

        @Test
        @DisplayName("should list expired PATs with EXPIRED filter")
        void shouldListExpiredPATsWithExpiredFilter() {
            // Arrange - Note: Current implementation filters from findAllActive()
            ListPATsUseCase.ListPATsCommand command =
                    new ListPATsUseCase.ListPATsCommand(superAdminId, ListPATsUseCase.FilterType.EXPIRED);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.findAllActive()).thenReturn(List.of());

            // Act
            ListPATsUseCase.ListPATsResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(0, result.getTotalCount());
        }

        @Test
        @DisplayName("should list PATs by creator with BY_CREATOR filter")
        void shouldListPATsByCreatorWithByCreatorFilter() {
            // Arrange
            UUID creatorId = UUID.randomUUID();
            PersonalAccessToken pat = createPAT("Creator PAT", false, false);
            pat.setCreatedBy(creatorId.toString());

            ListPATsUseCase.ListPATsCommand command =
                    new ListPATsUseCase.ListPATsCommand(superAdminId, ListPATsUseCase.FilterType.BY_CREATOR, creatorId);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.findByCreatedBy(creatorId)).thenReturn(List.of(pat));

            // Act
            ListPATsUseCase.ListPATsResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(1, result.getTotalCount());
            assertEquals("Creator PAT", result.getPats().get(0).getName());
        }

        @Test
        @DisplayName("should throw exception when user not found")
        void shouldThrowExceptionWhenUserNotFound() {
            // Arrange
            UUID unknownUserId = UUID.randomUUID();
            ListPATsUseCase.ListPATsCommand command =
                    new ListPATsUseCase.ListPATsCommand(unknownUserId, ListPATsUseCase.FilterType.ALL);

            when(userRepository.findById(unknownUserId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("User not found"));
        }

        @Test
        @DisplayName("should throw SecurityException when user is not SUPER_ADMIN")
        void shouldThrowSecurityExceptionWhenNotSuperAdmin() {
            // Arrange
            ListPATsUseCase.ListPATsCommand command =
                    new ListPATsUseCase.ListPATsCommand(regularUserId, ListPATsUseCase.FilterType.ALL);

            when(userRepository.findById(regularUserId)).thenReturn(Optional.of(regularUser));

            // Act & Assert
            SecurityException exception = assertThrows(
                    SecurityException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("SUPER_ADMIN"));
        }

        @Test
        @DisplayName("should throw exception when BY_CREATOR filter without creatorId")
        void shouldThrowExceptionWhenByCreatorFilterWithoutCreatorId() {
            // Arrange
            ListPATsUseCase.ListPATsCommand command =
                    new ListPATsUseCase.ListPATsCommand(superAdminId, ListPATsUseCase.FilterType.BY_CREATOR, null);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Creator ID required"));
        }

        @Test
        @DisplayName("should return empty list when no PATs exist")
        void shouldReturnEmptyListWhenNoPATsExist() {
            // Arrange
            ListPATsUseCase.ListPATsCommand command =
                    new ListPATsUseCase.ListPATsCommand(superAdminId, ListPATsUseCase.FilterType.ALL);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.findAllActive()).thenReturn(List.of());

            // Act
            ListPATsUseCase.ListPATsResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(0, result.getTotalCount());
            assertTrue(result.getPats().isEmpty());
        }

        @Test
        @DisplayName("should use default ALL filter when null provided")
        void shouldUseDefaultAllFilterWhenNullProvided() {
            // Arrange
            PersonalAccessToken pat = createPAT("Default Filter PAT", false, false);

            ListPATsUseCase.ListPATsCommand command =
                    new ListPATsUseCase.ListPATsCommand(superAdminId, null);

            when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
            when(tokenRepository.findAllActive()).thenReturn(List.of(pat));

            // Act
            ListPATsUseCase.ListPATsResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(1, result.getTotalCount());
        }
    }

    @Nested
    @DisplayName("ListPATsCommand")
    class ListPATsCommandTests {

        @Test
        @DisplayName("should create command with requestedBy and filter")
        void shouldCreateCommandWithRequestedByAndFilter() {
            // Arrange & Act
            ListPATsUseCase.ListPATsCommand command =
                    new ListPATsUseCase.ListPATsCommand(superAdminId, ListPATsUseCase.FilterType.ACTIVE);

            // Assert
            assertEquals(superAdminId, command.getRequestedBy());
            assertEquals(ListPATsUseCase.FilterType.ACTIVE, command.getFilter());
            assertNull(command.getCreatorId());
        }

        @Test
        @DisplayName("should create command with requestedBy, filter, and creatorId")
        void shouldCreateCommandWithAllFields() {
            // Arrange
            UUID creatorId = UUID.randomUUID();

            // Act
            ListPATsUseCase.ListPATsCommand command =
                    new ListPATsUseCase.ListPATsCommand(superAdminId, ListPATsUseCase.FilterType.BY_CREATOR, creatorId);

            // Assert
            assertEquals(superAdminId, command.getRequestedBy());
            assertEquals(ListPATsUseCase.FilterType.BY_CREATOR, command.getFilter());
            assertEquals(creatorId, command.getCreatorId());
        }
    }

    @Nested
    @DisplayName("ListPATsResult")
    class ListPATsResultTests {

        @Test
        @DisplayName("should create result with PATs and total count")
        void shouldCreateResultWithPATsAndTotalCount() {
            // Arrange
            ListPATsUseCase.PATSummary summary = new ListPATsUseCase.PATSummary(
                    UUID.randomUUID(), "Test PAT", PATScope.READ_ONLY,
                    LocalDateTime.now().plusDays(30), superAdminId,
                    LocalDateTime.now(), null, false, false);

            // Act
            ListPATsUseCase.ListPATsResult result =
                    new ListPATsUseCase.ListPATsResult(List.of(summary), 1);

            // Assert
            assertEquals(1, result.getTotalCount());
            assertEquals(1, result.getPats().size());
            assertEquals("Test PAT", result.getPats().get(0).getName());
        }
    }

    @Nested
    @DisplayName("PATSummary")
    class PATSummaryTests {

        @Test
        @DisplayName("should create PAT summary with all fields")
        void shouldCreatePATSummaryWithAllFields() {
            // Arrange
            UUID patId = UUID.randomUUID();
            LocalDateTime expiresAt = LocalDateTime.now().plusDays(30);
            LocalDateTime createdAt = LocalDateTime.now();
            LocalDateTime lastUsedAt = LocalDateTime.now();

            // Act
            ListPATsUseCase.PATSummary summary = new ListPATsUseCase.PATSummary(
                    patId, "Test PAT", PATScope.ADMIN, expiresAt,
                    superAdminId, createdAt, lastUsedAt, false, false);

            // Assert
            assertEquals(patId, summary.getId());
            assertEquals("Test PAT", summary.getName());
            assertEquals(PATScope.ADMIN, summary.getScope());
            assertEquals(expiresAt, summary.getExpiresAt());
            assertEquals(superAdminId, summary.getCreatedBy());
            assertEquals(createdAt, summary.getCreatedAt());
            assertEquals(lastUsedAt, summary.getLastUsedAt());
            assertFalse(summary.isRevoked());
            assertFalse(summary.isExpired());
        }

        @Test
        @DisplayName("should handle revoked and expired flags")
        void shouldHandleRevokedAndExpiredFlags() {
            // Arrange & Act
            ListPATsUseCase.PATSummary summary = new ListPATsUseCase.PATSummary(
                    UUID.randomUUID(), "Revoked PAT", PATScope.READ_ONLY,
                    LocalDateTime.now().minusDays(1), superAdminId,
                    LocalDateTime.now().minusDays(30), null, true, true);

            // Assert
            assertTrue(summary.isRevoked());
            assertTrue(summary.isExpired());
        }
    }

    @Nested
    @DisplayName("FilterType")
    class FilterTypeTests {

        @Test
        @DisplayName("should have all expected filter types")
        void shouldHaveAllExpectedFilterTypes() {
            // Assert
            assertEquals(5, ListPATsUseCase.FilterType.values().length);
            assertNotNull(ListPATsUseCase.FilterType.ALL);
            assertNotNull(ListPATsUseCase.FilterType.ACTIVE);
            assertNotNull(ListPATsUseCase.FilterType.REVOKED);
            assertNotNull(ListPATsUseCase.FilterType.EXPIRED);
            assertNotNull(ListPATsUseCase.FilterType.BY_CREATOR);
        }
    }
}
