package com.ffl.playoffs.infrastructure.config;

import com.ffl.playoffs.application.usecase.*;
import com.ffl.playoffs.domain.port.CharacterRepository;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Configuration for Application Use Cases
 * Defines beans for use cases following hexagonal architecture
 */
@Configuration
public class UseCaseConfiguration {

    // ===================
    // User Management Use Cases
    // ===================

    @Bean
    public CreateSuperAdminUseCase createSuperAdminUseCase(UserRepository userRepository) {
        return new CreateSuperAdminUseCase(userRepository);
    }

    @Bean
    public InviteAdminUseCase inviteAdminUseCase(UserRepository userRepository) {
        return new InviteAdminUseCase(userRepository);
    }

    // ===================
    // Personal Access Token (PAT) Management Use Cases
    // ===================

    @Bean
    public CreateBootstrapPATUseCase createBootstrapPATUseCase(
            PersonalAccessTokenRepository tokenRepository) {
        return new CreateBootstrapPATUseCase(tokenRepository);
    }

    @Bean
    public CreatePATUseCase createPATUseCase(
            PersonalAccessTokenRepository tokenRepository,
            UserRepository userRepository) {
        return new CreatePATUseCase(tokenRepository, userRepository);
    }

    @Bean
    public ListPATsUseCase listPATsUseCase(
            PersonalAccessTokenRepository tokenRepository,
            UserRepository userRepository) {
        return new ListPATsUseCase(tokenRepository, userRepository);
    }

    @Bean
    public RevokePATUseCase revokePATUseCase(
            PersonalAccessTokenRepository tokenRepository,
            UserRepository userRepository) {
        return new RevokePATUseCase(tokenRepository, userRepository);
    }

    @Bean
    public RotatePATUseCase rotatePATUseCase(
            PersonalAccessTokenRepository tokenRepository,
            UserRepository userRepository) {
        return new RotatePATUseCase(tokenRepository, userRepository);
    }

    @Bean
    public DeletePATUseCase deletePATUseCase(
            PersonalAccessTokenRepository tokenRepository,
            UserRepository userRepository) {
        return new DeletePATUseCase(tokenRepository, userRepository);
    }

    // ===================
    // Character Lifecycle Use Cases
    // ===================

    @Bean
    public CreateCharacterUseCase createCharacterUseCase(
            CharacterRepository characterRepository) {
        return new CreateCharacterUseCase(characterRepository);
    }

    @Bean
    public ActivateCharacterUseCase activateCharacterUseCase(
            CharacterRepository characterRepository) {
        return new ActivateCharacterUseCase(characterRepository);
    }

    @Bean
    public EliminateCharacterUseCase eliminateCharacterUseCase(
            CharacterRepository characterRepository) {
        return new EliminateCharacterUseCase(characterRepository);
    }

    @Bean
    public GetCharacterUseCase getCharacterUseCase(
            CharacterRepository characterRepository) {
        return new GetCharacterUseCase(characterRepository);
    }
}
