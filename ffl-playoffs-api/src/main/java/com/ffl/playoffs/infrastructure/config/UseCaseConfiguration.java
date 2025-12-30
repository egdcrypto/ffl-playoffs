package com.ffl.playoffs.infrastructure.config;

import com.ffl.playoffs.application.usecase.*;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import com.ffl.playoffs.domain.port.WorldRepository;
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
    // World Management Use Cases
    // ===================

    @Bean
    public CreateWorldUseCase createWorldUseCase(WorldRepository worldRepository) {
        return new CreateWorldUseCase(worldRepository);
    }

    @Bean
    public GetWorldUseCase getWorldUseCase(WorldRepository worldRepository) {
        return new GetWorldUseCase(worldRepository);
    }

    @Bean
    public UpdateWorldUseCase updateWorldUseCase(WorldRepository worldRepository) {
        return new UpdateWorldUseCase(worldRepository);
    }

    @Bean
    public ActivateWorldUseCase activateWorldUseCase(WorldRepository worldRepository) {
        return new ActivateWorldUseCase(worldRepository);
    }

    @Bean
    public ArchiveWorldUseCase archiveWorldUseCase(WorldRepository worldRepository) {
        return new ArchiveWorldUseCase(worldRepository);
    }

    @Bean
    public TransferWorldOwnershipUseCase transferWorldOwnershipUseCase(WorldRepository worldRepository) {
        return new TransferWorldOwnershipUseCase(worldRepository);
    }

    @Bean
    public DeleteWorldUseCase deleteWorldUseCase(WorldRepository worldRepository) {
        return new DeleteWorldUseCase(worldRepository);
    }
}
