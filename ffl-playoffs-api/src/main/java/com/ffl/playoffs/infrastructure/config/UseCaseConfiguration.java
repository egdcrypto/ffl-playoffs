package com.ffl.playoffs.infrastructure.config;

import com.ffl.playoffs.application.usecase.*;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import com.ffl.playoffs.domain.port.WorldAccessControlRepository;
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
    // World Access Control Use Cases
    // ===================

    @Bean
    public CreateWorldAccessControlUseCase createWorldAccessControlUseCase(
            WorldAccessControlRepository repository) {
        return new CreateWorldAccessControlUseCase(repository);
    }

    @Bean
    public AddWorldMemberUseCase addWorldMemberUseCase(
            WorldAccessControlRepository repository) {
        return new AddWorldMemberUseCase(repository);
    }

    @Bean
    public UpdateWorldMemberRoleUseCase updateWorldMemberRoleUseCase(
            WorldAccessControlRepository repository) {
        return new UpdateWorldMemberRoleUseCase(repository);
    }

    @Bean
    public RemoveWorldMemberUseCase removeWorldMemberUseCase(
            WorldAccessControlRepository repository) {
        return new RemoveWorldMemberUseCase(repository);
    }

    @Bean
    public TransferWorldOwnershipUseCase transferWorldOwnershipUseCase(
            WorldAccessControlRepository repository) {
        return new TransferWorldOwnershipUseCase(repository);
    }

    @Bean
    public AcceptWorldInvitationUseCase acceptWorldInvitationUseCase(
            WorldAccessControlRepository repository) {
        return new AcceptWorldInvitationUseCase(repository);
    }

    @Bean
    public GetWorldAccessUseCase getWorldAccessUseCase(
            WorldAccessControlRepository repository) {
        return new GetWorldAccessUseCase(repository);
    }
}
