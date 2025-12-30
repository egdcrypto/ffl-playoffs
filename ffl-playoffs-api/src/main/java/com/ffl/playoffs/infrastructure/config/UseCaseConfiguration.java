package com.ffl.playoffs.infrastructure.config;

import com.ffl.playoffs.application.usecase.*;
import com.ffl.playoffs.domain.port.AuthSessionRepository;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;
import com.ffl.playoffs.domain.port.RosterRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import com.ffl.playoffs.domain.port.VectorSearchRepository;
import com.ffl.playoffs.domain.service.EmbeddingService;
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
    // Roster Management Use Cases
    // ===================

    @Bean
    public BuildRosterUseCase buildRosterUseCase(
            LeagueRepository leagueRepository,
            RosterRepository rosterRepository) {
        return new BuildRosterUseCase(leagueRepository, rosterRepository);
    }

    @Bean
    public LockRosterUseCase lockRosterUseCase(RosterRepository rosterRepository) {
        return new LockRosterUseCase(rosterRepository);
    }

    @Bean
    public ValidateRosterUseCase validateRosterUseCase(RosterRepository rosterRepository) {
        return new ValidateRosterUseCase(rosterRepository);
    }

    // ===================
    // Vector Search Use Cases
    // ===================

    @Bean
    public IndexDocumentUseCase indexDocumentUseCase(
            VectorSearchRepository vectorSearchRepository,
            EmbeddingService embeddingService) {
        return new IndexDocumentUseCase(vectorSearchRepository, embeddingService);
    }

    @Bean
    public VectorSearchUseCase vectorSearchUseCase(
            VectorSearchRepository vectorSearchRepository,
            EmbeddingService embeddingService) {
        return new VectorSearchUseCase(vectorSearchRepository, embeddingService);
    }

    @Bean
    public DeleteVectorIndexUseCase deleteVectorIndexUseCase(
            VectorSearchRepository vectorSearchRepository) {
        return new DeleteVectorIndexUseCase(vectorSearchRepository);
    }

    // ===================
    // Authentication & Authorization Use Cases
    // ===================

    @Bean
    public CreateAuthSessionUseCase createAuthSessionUseCase(
            AuthSessionRepository sessionRepository,
            UserRepository userRepository) {
        return new CreateAuthSessionUseCase(sessionRepository, userRepository);
    }

    @Bean
    public ValidateAuthSessionUseCase validateAuthSessionUseCase(
            AuthSessionRepository sessionRepository,
            UserRepository userRepository) {
        return new ValidateAuthSessionUseCase(sessionRepository, userRepository);
    }

    @Bean
    public RefreshAuthSessionUseCase refreshAuthSessionUseCase(
            AuthSessionRepository sessionRepository) {
        return new RefreshAuthSessionUseCase(sessionRepository);
    }

    @Bean
    public InvalidateAuthSessionUseCase invalidateAuthSessionUseCase(
            AuthSessionRepository sessionRepository) {
        return new InvalidateAuthSessionUseCase(sessionRepository);
    }

    @Bean
    public CheckPermissionUseCase checkPermissionUseCase(
            AuthSessionRepository sessionRepository,
            UserRepository userRepository) {
        return new CheckPermissionUseCase(sessionRepository, userRepository);
    }
}
