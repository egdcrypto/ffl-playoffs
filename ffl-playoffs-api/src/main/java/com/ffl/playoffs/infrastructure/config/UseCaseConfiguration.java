package com.ffl.playoffs.infrastructure.config;

import com.ffl.playoffs.application.usecase.*;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;
import com.ffl.playoffs.domain.port.ResourcePoolRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import com.ffl.playoffs.domain.port.WorldResourcesRepository;
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
    // World Resource Management Use Cases
    // ===================

    @Bean
    public CreateWorldResourcesUseCase createWorldResourcesUseCase(
            WorldResourcesRepository worldResourcesRepository) {
        return new CreateWorldResourcesUseCase(worldResourcesRepository);
    }

    @Bean
    public AllocateResourcesUseCase allocateResourcesUseCase(
            WorldResourcesRepository worldResourcesRepository,
            ResourcePoolRepository resourcePoolRepository) {
        return new AllocateResourcesUseCase(worldResourcesRepository, resourcePoolRepository);
    }

    @Bean
    public SetResourcePriorityUseCase setResourcePriorityUseCase(
            WorldResourcesRepository worldResourcesRepository) {
        return new SetResourcePriorityUseCase(worldResourcesRepository);
    }

    @Bean
    public ConfigureAutoScalingUseCase configureAutoScalingUseCase(
            WorldResourcesRepository worldResourcesRepository) {
        return new ConfigureAutoScalingUseCase(worldResourcesRepository);
    }

    @Bean
    public ConfigureResourceSharingUseCase configureResourceSharingUseCase(
            WorldResourcesRepository worldResourcesRepository) {
        return new ConfigureResourceSharingUseCase(worldResourcesRepository);
    }

    @Bean
    public SetResourceQuotaUseCase setResourceQuotaUseCase(
            WorldResourcesRepository worldResourcesRepository) {
        return new SetResourceQuotaUseCase(worldResourcesRepository);
    }

    @Bean
    public GetWorldResourcesUseCase getWorldResourcesUseCase(
            WorldResourcesRepository worldResourcesRepository) {
        return new GetWorldResourcesUseCase(worldResourcesRepository);
    }

    // ===================
    // Resource Pool Management Use Cases
    // ===================

    @Bean
    public CreateResourcePoolUseCase createResourcePoolUseCase(
            ResourcePoolRepository resourcePoolRepository) {
        return new CreateResourcePoolUseCase(resourcePoolRepository);
    }

    @Bean
    public UpdateResourcePoolUseCase updateResourcePoolUseCase(
            ResourcePoolRepository resourcePoolRepository) {
        return new UpdateResourcePoolUseCase(resourcePoolRepository);
    }

    @Bean
    public GetResourcePoolUseCase getResourcePoolUseCase(
            ResourcePoolRepository resourcePoolRepository) {
        return new GetResourcePoolUseCase(resourcePoolRepository);
    }
}
