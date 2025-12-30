package com.ffl.playoffs.infrastructure.config;

import com.ffl.playoffs.application.usecase.*;
import com.ffl.playoffs.domain.port.*;
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
    // AI Director Use Cases
    // ===================

    @Bean
    public InitializeAIDirectorUseCase initializeAIDirectorUseCase(
            AIDirectorRepository directorRepository,
            StoryArcRepository storyArcRepository,
            StoryBeatRepository storyBeatRepository) {
        return new InitializeAIDirectorUseCase(directorRepository, storyArcRepository, storyBeatRepository);
    }

    @Bean
    public UpdateTensionUseCase updateTensionUseCase(
            AIDirectorRepository directorRepository) {
        return new UpdateTensionUseCase(directorRepository);
    }

    @Bean
    public DetectStallsUseCase detectStallsUseCase(
            AIDirectorRepository directorRepository,
            StallConditionRepository stallConditionRepository,
            StoryBeatRepository storyBeatRepository) {
        return new DetectStallsUseCase(directorRepository, stallConditionRepository, storyBeatRepository);
    }

    @Bean
    public CreateStoryBeatUseCase createStoryBeatUseCase(
            AIDirectorRepository directorRepository,
            StoryBeatRepository storyBeatRepository,
            StoryArcRepository storyArcRepository) {
        return new CreateStoryBeatUseCase(directorRepository, storyBeatRepository, storyArcRepository);
    }

    @Bean
    public ExecuteCuratorActionUseCase executeCuratorActionUseCase(
            AIDirectorRepository directorRepository,
            CuratorActionRepository curatorActionRepository) {
        return new ExecuteCuratorActionUseCase(directorRepository, curatorActionRepository);
    }
}
