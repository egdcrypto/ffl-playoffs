package com.ffl.playoffs.infrastructure.config;

import com.ffl.playoffs.application.service.ApplicationService;
import com.ffl.playoffs.application.usecase.*;
import com.ffl.playoffs.domain.port.GameRepository;
import com.ffl.playoffs.domain.port.NflDataProvider;
import com.ffl.playoffs.domain.port.PlayerRepository;
import com.ffl.playoffs.domain.service.ScoringService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Spring configuration for dependency injection.
 * Wires together domain, application, and infrastructure layers.
 */
@Configuration
public class SpringConfig {

    @Bean
    public ScoringService scoringService(NflDataProvider nflDataProvider) {
        return new ScoringService(nflDataProvider);
    }

    @Bean
    public CreateGameUseCase createGameUseCase(GameRepository gameRepository) {
        return new CreateGameUseCase(gameRepository);
    }

    @Bean
    public InvitePlayerUseCase invitePlayerUseCase(GameRepository gameRepository, 
                                                   PlayerRepository playerRepository) {
        return new InvitePlayerUseCase(gameRepository, playerRepository);
    }

    @Bean
    public SelectTeamUseCase selectTeamUseCase(PlayerRepository playerRepository,
                                              GameRepository gameRepository,
                                              NflDataProvider nflDataProvider) {
        return new SelectTeamUseCase(playerRepository, gameRepository, nflDataProvider);
    }

    @Bean
    public CalculateScoresUseCase calculateScoresUseCase(GameRepository gameRepository,
                                                         PlayerRepository playerRepository,
                                                         ScoringService scoringService) {
        return new CalculateScoresUseCase(gameRepository, playerRepository, scoringService);
    }

    @Bean
    public ApplicationService applicationService(CreateGameUseCase createGameUseCase,
                                                 InvitePlayerUseCase invitePlayerUseCase,
                                                 SelectTeamUseCase selectTeamUseCase,
                                                 CalculateScoresUseCase calculateScoresUseCase) {
        return new ApplicationService(createGameUseCase, invitePlayerUseCase, 
                                     selectTeamUseCase, calculateScoresUseCase);
    }
}
