package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.port.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.UUID;

/**
 * Use case for retrieving user details
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class GetUserUseCase {

    private final UserRepository userRepository;

    /**
     * Get user by ID
     * @param userId the user ID
     * @return Optional containing the user if found
     */
    public Optional<User> getById(UUID userId) {
        log.debug("Getting user by ID: {}", userId);
        return userRepository.findById(userId);
    }

    /**
     * Get user by email
     * @param email the user email
     * @return Optional containing the user if found
     */
    public Optional<User> getByEmail(String email) {
        log.debug("Getting user by email: {}", email);
        return userRepository.findByEmail(email);
    }

    /**
     * Get user by Google ID
     * @param googleId the Google OAuth ID
     * @return Optional containing the user if found
     */
    public Optional<User> getByGoogleId(String googleId) {
        log.debug("Getting user by Google ID: {}", googleId);
        return userRepository.findByGoogleId(googleId);
    }
}
