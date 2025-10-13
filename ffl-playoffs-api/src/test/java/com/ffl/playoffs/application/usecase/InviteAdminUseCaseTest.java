package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.IntegrationTestBase;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.model.User;
import com.ffl.playoffs.domain.port.UserRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

/**
 * Integration tests for InviteAdminUseCase
 * Tests complete end-to-end flow with MongoDB persistence
 */
@DisplayName("InviteAdminUseCase Integration Tests")
class InviteAdminUseCaseTest extends IntegrationTestBase {

    @Autowired
    private UserRepository userRepository;

    private InviteAdminUseCase useCase;
    private User superAdmin;

    @Override
    protected void baseSetUp() {
        super.baseSetUp();
        useCase = new InviteAdminUseCase(userRepository);

        // Create a super admin user for testing
        superAdmin = new User(
                "superadmin@example.com",
                "Super Admin",
                "google-super-admin",
                Role.SUPER_ADMIN
        );
        superAdmin = userRepository.save(superAdmin);
    }

    @Test
    @DisplayName("Should invite admin successfully")
    void shouldInviteAdminSuccessfully() {
        // Given
        var command = new InviteAdminUseCase.InviteAdminCommand(
                "newadmin@example.com",
                "New Admin User",
                superAdmin.getId()
        );

        // When
        InviteAdminUseCase.InviteAdminResult result = useCase.execute(command);

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getAdmin()).isNotNull();
        assertThat(result.getAdmin().getId()).isNotNull();
        assertThat(result.getAdmin().getEmail()).isEqualTo("newadmin@example.com");
        assertThat(result.getAdmin().getName()).isEqualTo("New Admin User");
        assertThat(result.getAdmin().getRole()).isEqualTo(Role.ADMIN);
        assertThat(result.getAdmin().getGoogleId()).isNull(); // Not set until first login
        assertThat(result.getAdmin().getCreatedAt()).isNotNull();

        // Verify invitation token is generated
        assertThat(result.getInvitationToken()).isNotNull();
        assertThat(result.getInvitationToken()).startsWith("admin_invite_");

        // Verify persistence
        User savedAdmin = userRepository.findByEmail("newadmin@example.com").orElse(null);
        assertThat(savedAdmin).isNotNull();
        assertThat(savedAdmin.getId()).isEqualTo(result.getAdmin().getId());
        assertThat(savedAdmin.getRole()).isEqualTo(Role.ADMIN);
    }

    @Test
    @DisplayName("Should throw exception when inviter is not SUPER_ADMIN")
    void shouldThrowExceptionWhenInviterNotSuperAdmin() {
        // Given - create regular ADMIN user
        User admin = new User(
                "admin@example.com",
                "Regular Admin",
                "google-admin",
                Role.ADMIN
        );
        admin = userRepository.save(admin);

        var command = new InviteAdminUseCase.InviteAdminCommand(
                "newadmin@example.com",
                "New Admin",
                admin.getId()
        );

        // When/Then
        assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("Only SUPER_ADMIN can invite admins");
    }

    @Test
    @DisplayName("Should throw exception when inviter is PLAYER")
    void shouldThrowExceptionWhenInviterIsPlayer() {
        // Given - create PLAYER user
        User player = new User(
                "player@example.com",
                "Player User",
                "google-player",
                Role.PLAYER
        );
        player = userRepository.save(player);

        var command = new InviteAdminUseCase.InviteAdminCommand(
                "newadmin@example.com",
                "New Admin",
                player.getId()
        );

        // When/Then
        assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("Only SUPER_ADMIN can invite admins");
    }

    @Test
    @DisplayName("Should throw exception when inviter not found")
    void shouldThrowExceptionWhenInviterNotFound() {
        // Given
        UUID nonExistentUserId = UUID.randomUUID();
        var command = new InviteAdminUseCase.InviteAdminCommand(
                "newadmin@example.com",
                "New Admin",
                nonExistentUserId
        );

        // When/Then
        assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Inviter not found");
    }

    @Test
    @DisplayName("Should throw exception when user with email already exists")
    void shouldThrowExceptionWhenEmailExists() {
        // Given - create existing user
        User existingUser = new User(
                "existing@example.com",
                "Existing User",
                "google-existing",
                Role.PLAYER
        );
        userRepository.save(existingUser);

        var command = new InviteAdminUseCase.InviteAdminCommand(
                "existing@example.com",
                "New Admin",
                superAdmin.getId()
        );

        // When/Then
        assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("User with email already exists: existing@example.com");
    }

    @Test
    @DisplayName("Should create admin with null Google ID")
    void shouldCreateAdminWithNullGoogleId() {
        // Given
        var command = new InviteAdminUseCase.InviteAdminCommand(
                "invited@example.com",
                "Invited Admin",
                superAdmin.getId()
        );

        // When
        InviteAdminUseCase.InviteAdminResult result = useCase.execute(command);

        // Then - Google ID should be null until first login
        assertThat(result.getAdmin().getGoogleId()).isNull();

        User savedAdmin = userRepository.findById(result.getAdmin().getId()).orElse(null);
        assertThat(savedAdmin).isNotNull();
        assertThat(savedAdmin.getGoogleId()).isNull();
    }

    @Test
    @DisplayName("Should generate unique invitation tokens")
    void shouldGenerateUniqueInvitationTokens() {
        // Given/When - invite two admins
        var command1 = new InviteAdminUseCase.InviteAdminCommand(
                "admin1@example.com",
                "Admin One",
                superAdmin.getId()
        );
        InviteAdminUseCase.InviteAdminResult result1 = useCase.execute(command1);

        var command2 = new InviteAdminUseCase.InviteAdminCommand(
                "admin2@example.com",
                "Admin Two",
                superAdmin.getId()
        );
        InviteAdminUseCase.InviteAdminResult result2 = useCase.execute(command2);

        // Then - invitation tokens should be different
        assertThat(result1.getInvitationToken()).isNotEqualTo(result2.getInvitationToken());
    }

    @Test
    @DisplayName("Should create multiple admins successfully")
    void shouldCreateMultipleAdminsSuccessfully() {
        // Given/When - invite three admins
        var command1 = new InviteAdminUseCase.InviteAdminCommand(
                "admin1@example.com",
                "Admin One",
                superAdmin.getId()
        );
        InviteAdminUseCase.InviteAdminResult result1 = useCase.execute(command1);

        var command2 = new InviteAdminUseCase.InviteAdminCommand(
                "admin2@example.com",
                "Admin Two",
                superAdmin.getId()
        );
        InviteAdminUseCase.InviteAdminResult result2 = useCase.execute(command2);

        var command3 = new InviteAdminUseCase.InviteAdminCommand(
                "admin3@example.com",
                "Admin Three",
                superAdmin.getId()
        );
        InviteAdminUseCase.InviteAdminResult result3 = useCase.execute(command3);

        // Then - all should be created successfully
        assertThat(result1.getAdmin().getRole()).isEqualTo(Role.ADMIN);
        assertThat(result2.getAdmin().getRole()).isEqualTo(Role.ADMIN);
        assertThat(result3.getAdmin().getRole()).isEqualTo(Role.ADMIN);

        // Verify all are in database
        assertThat(userRepository.findByEmail("admin1@example.com")).isPresent();
        assertThat(userRepository.findByEmail("admin2@example.com")).isPresent();
        assertThat(userRepository.findByEmail("admin3@example.com")).isPresent();
    }

    @Test
    @DisplayName("Should persist all user fields correctly")
    void shouldPersistAllUserFields() {
        // Given
        var command = new InviteAdminUseCase.InviteAdminCommand(
                "complete@example.com",
                "Complete Admin",
                superAdmin.getId()
        );

        // When
        InviteAdminUseCase.InviteAdminResult result = useCase.execute(command);

        // Then - retrieve from database and verify all fields
        User retrievedAdmin = userRepository.findById(result.getAdmin().getId()).orElse(null);
        assertThat(retrievedAdmin).isNotNull();
        assertThat(retrievedAdmin.getEmail()).isEqualTo("complete@example.com");
        assertThat(retrievedAdmin.getName()).isEqualTo("Complete Admin");
        assertThat(retrievedAdmin.getRole()).isEqualTo(Role.ADMIN);
        assertThat(retrievedAdmin.getGoogleId()).isNull();
        assertThat(retrievedAdmin.getCreatedAt()).isNotNull();
        assertThat(retrievedAdmin.getLastLoginAt()).isNull(); // Never logged in
    }

    @Test
    @DisplayName("Should allow same super admin to invite multiple times")
    void shouldAllowSameSuperAdminToInviteMultipleTimes() {
        // Given - same super admin invites multiple people
        var command1 = new InviteAdminUseCase.InviteAdminCommand(
                "first@example.com",
                "First Admin",
                superAdmin.getId()
        );
        var command2 = new InviteAdminUseCase.InviteAdminCommand(
                "second@example.com",
                "Second Admin",
                superAdmin.getId()
        );

        // When
        InviteAdminUseCase.InviteAdminResult result1 = useCase.execute(command1);
        InviteAdminUseCase.InviteAdminResult result2 = useCase.execute(command2);

        // Then
        assertThat(result1.getAdmin().getId()).isNotEqualTo(result2.getAdmin().getId());
        assertThat(userRepository.findByEmail("first@example.com")).isPresent();
        assertThat(userRepository.findByEmail("second@example.com")).isPresent();
    }

    @Test
    @DisplayName("Should work with multiple super admins")
    void shouldWorkWithMultipleSuperAdmins() {
        // Given - create second super admin
        User superAdmin2 = new User(
                "superadmin2@example.com",
                "Second Super Admin",
                "google-super-admin-2",
                Role.SUPER_ADMIN
        );
        superAdmin2 = userRepository.save(superAdmin2);

        // When - each super admin invites someone
        var command1 = new InviteAdminUseCase.InviteAdminCommand(
                "invited1@example.com",
                "Invited by Super 1",
                superAdmin.getId()
        );
        InviteAdminUseCase.InviteAdminResult result1 = useCase.execute(command1);

        var command2 = new InviteAdminUseCase.InviteAdminCommand(
                "invited2@example.com",
                "Invited by Super 2",
                superAdmin2.getId()
        );
        InviteAdminUseCase.InviteAdminResult result2 = useCase.execute(command2);

        // Then
        assertThat(result1.getAdmin().getRole()).isEqualTo(Role.ADMIN);
        assertThat(result2.getAdmin().getRole()).isEqualTo(Role.ADMIN);
    }

    @Test
    @DisplayName("Should find invited admin by email after creation")
    void shouldFindInvitedAdminByEmail() {
        // Given
        var command = new InviteAdminUseCase.InviteAdminCommand(
                "findable@example.com",
                "Findable Admin",
                superAdmin.getId()
        );
        InviteAdminUseCase.InviteAdminResult result = useCase.execute(command);

        // When
        User foundAdmin = userRepository.findByEmail("findable@example.com").orElse(null);

        // Then
        assertThat(foundAdmin).isNotNull();
        assertThat(foundAdmin.getId()).isEqualTo(result.getAdmin().getId());
        assertThat(foundAdmin.getName()).isEqualTo("Findable Admin");
        assertThat(foundAdmin.getRole()).isEqualTo(Role.ADMIN);
    }
}
