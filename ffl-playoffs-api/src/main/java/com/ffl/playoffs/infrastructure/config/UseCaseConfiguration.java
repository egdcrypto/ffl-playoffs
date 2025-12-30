package com.ffl.playoffs.infrastructure.config;

import com.ffl.playoffs.application.usecase.*;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import com.ffl.playoffs.domain.port.WorldOwnerPlayerRepository;
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
    // World Owner Player Management Use Cases
    // ===================

    @Bean
    public InviteWorldOwnerUseCase inviteWorldOwnerUseCase(
            WorldOwnerPlayerRepository repository) {
        return new InviteWorldOwnerUseCase(repository);
    }

    @Bean
    public AcceptWorldOwnerInvitationUseCase acceptWorldOwnerInvitationUseCase(
            WorldOwnerPlayerRepository repository) {
        return new AcceptWorldOwnerInvitationUseCase(repository);
    }

    @Bean
    public RevokeWorldOwnerUseCase revokeWorldOwnerUseCase(
            WorldOwnerPlayerRepository repository) {
        return new RevokeWorldOwnerUseCase(repository);
    }

    @Bean
    public UpdateWorldOwnerRoleUseCase updateWorldOwnerRoleUseCase(
            WorldOwnerPlayerRepository repository) {
        return new UpdateWorldOwnerRoleUseCase(repository);
    }

    @Bean
    public TransferWorldPrimaryOwnershipUseCase transferWorldPrimaryOwnershipUseCase(
            WorldOwnerPlayerRepository repository) {
        return new TransferWorldPrimaryOwnershipUseCase(repository);
    }

    @Bean
    public GetWorldOwnersUseCase getWorldOwnersUseCase(
            WorldOwnerPlayerRepository repository) {
        return new GetWorldOwnersUseCase(repository);
    }
}
