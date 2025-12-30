package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.IntegrationTestBase;
import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.UserRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Integration tests for GetUserUseCase
 */
@DisplayName("GetUserUseCase Integration Tests")
class GetUserUseCaseTest extends IntegrationTestBase {

    @Autowired
    private UserRepository userRepository;

    private GetUserUseCase useCase;

    @org.junit.jupiter.api.BeforeEach
    void setUp() {
        useCase = new GetUserUseCase(userRepository);
    }

    private User createAndSaveUser(String email, String name, String googleId, Role role) {
        User user = new User(email, name, googleId, role);
        return userRepository.save(user);
    }

    @Nested
    @DisplayName("getById")
    class GetById {

        @Test
        @DisplayName("should return user when found")
        void shouldReturnUserWhenFound() {
            // Given
            User savedUser = createAndSaveUser("test@example.com", "Test User", "google-123", Role.PLAYER);

            // When
            Optional<User> result = useCase.getById(savedUser.getId());

            // Then
            assertThat(result).isPresent();
            assertThat(result.get().getId()).isEqualTo(savedUser.getId());
            assertThat(result.get().getEmail()).isEqualTo("test@example.com");
        }

        @Test
        @DisplayName("should return empty when not found")
        void shouldReturnEmptyWhenNotFound() {
            // When
            Optional<User> result = useCase.getById(UUID.randomUUID());

            // Then
            assertThat(result).isEmpty();
        }
    }

    @Nested
    @DisplayName("getByEmail")
    class GetByEmail {

        @Test
        @DisplayName("should return user when found")
        void shouldReturnUserWhenFound() {
            // Given
            createAndSaveUser("findme@example.com", "Find Me", "google-456", Role.ADMIN);

            // When
            Optional<User> result = useCase.getByEmail("findme@example.com");

            // Then
            assertThat(result).isPresent();
            assertThat(result.get().getEmail()).isEqualTo("findme@example.com");
            assertThat(result.get().getRole()).isEqualTo(Role.ADMIN);
        }

        @Test
        @DisplayName("should return empty when not found")
        void shouldReturnEmptyWhenNotFound() {
            // When
            Optional<User> result = useCase.getByEmail("nonexistent@example.com");

            // Then
            assertThat(result).isEmpty();
        }
    }

    @Nested
    @DisplayName("getByGoogleId")
    class GetByGoogleId {

        @Test
        @DisplayName("should return user when found")
        void shouldReturnUserWhenFound() {
            // Given
            createAndSaveUser("oauth@example.com", "OAuth User", "google-oauth-123", Role.SUPER_ADMIN);

            // When
            Optional<User> result = useCase.getByGoogleId("google-oauth-123");

            // Then
            assertThat(result).isPresent();
            assertThat(result.get().getGoogleId()).isEqualTo("google-oauth-123");
            assertThat(result.get().getRole()).isEqualTo(Role.SUPER_ADMIN);
        }

        @Test
        @DisplayName("should return empty when not found")
        void shouldReturnEmptyWhenNotFound() {
            // When
            Optional<User> result = useCase.getByGoogleId("nonexistent-google-id");

            // Then
            assertThat(result).isEmpty();
        }
    }
}
