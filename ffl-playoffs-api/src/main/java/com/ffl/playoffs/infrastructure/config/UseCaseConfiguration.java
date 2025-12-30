package com.ffl.playoffs.infrastructure.config;

import com.ffl.playoffs.application.usecase.*;
import com.ffl.playoffs.domain.port.*;
import com.ffl.playoffs.domain.service.ResourceOwnershipValidator;
import com.ffl.playoffs.domain.service.ScoringService;
import com.ffl.playoffs.infrastructure.auth.GoogleJwtValidator;
import org.springframework.beans.factory.annotation.Qualifier;
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

    @Bean
    public CreateUserOnFirstLoginUseCase createUserOnFirstLoginUseCase(
            UserRepository userRepository,
            PlayerInvitationRepository invitationRepository,
            LeaguePlayerRepository leaguePlayerRepository) {
        return new CreateUserOnFirstLoginUseCase(userRepository, invitationRepository, leaguePlayerRepository);
    }

    @Bean
    public ValidateResourceOwnershipUseCase validateResourceOwnershipUseCase(
            ResourceOwnershipValidator ownershipValidator) {
        return new ValidateResourceOwnershipUseCase(ownershipValidator);
    }

    @Bean
    public CreateUserAccountUseCase createUserAccountUseCase(UserRepository userRepository) {
        return new CreateUserAccountUseCase(userRepository);
    }

    @Bean
    public AcceptAdminInvitationUseCase acceptAdminInvitationUseCase(UserRepository userRepository) {
        return new AcceptAdminInvitationUseCase(userRepository);
    }

    @Bean
    public AssignRoleUseCase assignRoleUseCase(UserRepository userRepository) {
        return new AssignRoleUseCase(userRepository);
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

    @Bean
    public ValidatePATUseCase validatePATUseCase(
            PersonalAccessTokenRepository tokenRepository,
            UserRepository userRepository) {
        return new ValidatePATUseCase(tokenRepository, userRepository);
    }

    @Bean
    public UpdatePATLastUsedUseCase updatePATLastUsedUseCase(
            PersonalAccessTokenRepository tokenRepository) {
        return new UpdatePATLastUsedUseCase(tokenRepository);
    }

    @Bean
    public ValidateGoogleJWTUseCase validateGoogleJWTUseCase(
            GoogleJwtValidator jwtValidator,
            UserRepository userRepository) {
        return new ValidateGoogleJWTUseCase(jwtValidator, userRepository);
    }

    // ===================
    // League Management Use Cases
    // ===================

    @Bean
    public CreateLeagueUseCase createLeagueUseCase(LeagueRepository leagueRepository) {
        return new CreateLeagueUseCase(leagueRepository);
    }

    @Bean
    public ConfigureLeagueUseCase configureLeagueUseCase(LeagueRepository leagueRepository) {
        return new ConfigureLeagueUseCase(leagueRepository);
    }

    @Bean
    public ConfigureLeagueScoringUseCase configureLeagueScoringUseCase(LeagueRepository leagueRepository) {
        return new ConfigureLeagueScoringUseCase(leagueRepository);
    }

    @Bean
    public ActivateLeagueUseCase activateLeagueUseCase(
            LeagueRepository leagueRepository,
            WeekRepository weekRepository) {
        return new ActivateLeagueUseCase(leagueRepository, weekRepository);
    }

    @Bean
    public DeactivateLeagueUseCase deactivateLeagueUseCase(LeagueRepository leagueRepository) {
        return new DeactivateLeagueUseCase(leagueRepository);
    }

    @Bean
    public ReactivateLeagueUseCase reactivateLeagueUseCase(LeagueRepository leagueRepository) {
        return new ReactivateLeagueUseCase(leagueRepository);
    }

    @Bean
    public PauseLeagueUseCase pauseLeagueUseCase(LeagueRepository leagueRepository) {
        return new PauseLeagueUseCase(leagueRepository);
    }

    @Bean
    public ResumeLeagueUseCase resumeLeagueUseCase(LeagueRepository leagueRepository) {
        return new ResumeLeagueUseCase(leagueRepository);
    }

    @Bean
    public CompleteLeagueUseCase completeLeagueUseCase(LeagueRepository leagueRepository) {
        return new CompleteLeagueUseCase(leagueRepository);
    }

    @Bean
    public CancelLeagueUseCase cancelLeagueUseCase(LeagueRepository leagueRepository) {
        return new CancelLeagueUseCase(leagueRepository);
    }

    @Bean
    public ArchiveLeagueUseCase archiveLeagueUseCase(LeagueRepository leagueRepository) {
        return new ArchiveLeagueUseCase(leagueRepository);
    }

    @Bean
    public DeleteLeagueUseCase deleteLeagueUseCase(
            LeagueRepository leagueRepository,
            WeekRepository weekRepository) {
        return new DeleteLeagueUseCase(leagueRepository, weekRepository);
    }

    @Bean
    public CloneLeagueSettingsUseCase cloneLeagueSettingsUseCase(LeagueRepository leagueRepository) {
        return new CloneLeagueSettingsUseCase(leagueRepository);
    }

    @Bean
    public ValidateConfigurationLockUseCase validateConfigurationLockUseCase(LeagueRepository leagueRepository) {
        return new ValidateConfigurationLockUseCase(leagueRepository);
    }

    @Bean
    public LeagueLifecycleUseCase leagueLifecycleUseCase(
            LeagueRepository leagueRepository,
            LeaguePlayerRepository leaguePlayerRepository) {
        return new LeagueLifecycleUseCase(leagueRepository, leaguePlayerRepository);
    }

    @Bean
    public AdvanceWeekUseCase advanceWeekUseCase(
            LeagueRepository leagueRepository,
            WeekRepository weekRepository) {
        return new AdvanceWeekUseCase(leagueRepository, weekRepository);
    }

    // ===================
    // Player Invitation Use Cases
    // ===================

    @Bean
    public InvitePlayerToLeagueUseCase invitePlayerToLeagueUseCase(
            LeagueRepository leagueRepository,
            PlayerInvitationRepository invitationRepository) {
        return new InvitePlayerToLeagueUseCase(leagueRepository, invitationRepository);
    }

    @Bean
    public AcceptPlayerInvitationUseCase acceptPlayerInvitationUseCase(
            LeaguePlayerRepository leaguePlayerRepository) {
        return new AcceptPlayerInvitationUseCase(leaguePlayerRepository);
    }

    @Bean
    public AcceptLeagueInvitationUseCase acceptLeagueInvitationUseCase(
            PlayerInvitationRepository invitationRepository,
            LeagueRepository leagueRepository,
            UserRepository userRepository,
            LeaguePlayerRepository leaguePlayerRepository) {
        return new AcceptLeagueInvitationUseCase(invitationRepository, leagueRepository, userRepository, leaguePlayerRepository);
    }

    @Bean
    public RemovePlayerFromLeagueUseCase removePlayerFromLeagueUseCase(
            LeagueRepository leagueRepository,
            LeaguePlayerRepository leaguePlayerRepository) {
        return new RemovePlayerFromLeagueUseCase(leagueRepository, leaguePlayerRepository);
    }

    // ===================
    // Roster Use Cases
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

    @Bean
    public AddNFLPlayerToSlotUseCase addNFLPlayerToSlotUseCase(
            RosterRepository rosterRepository,
            NFLPlayerRepository nflPlayerRepository) {
        return new AddNFLPlayerToSlotUseCase(rosterRepository, nflPlayerRepository);
    }

    // ===================
    // NFL Data Use Cases
    // ===================

    @Bean
    public SyncNFLDataUseCase syncNFLDataUseCase(
            @Qualifier("sportsDataIoAdapter") NflDataProvider nflDataProvider) {
        return new SyncNFLDataUseCase(nflDataProvider);
    }

    @Bean
    public FetchNFLScheduleUseCase fetchNFLScheduleUseCase(
            @Qualifier("sportsDataIoAdapter") NflDataProvider nflDataProvider) {
        return new FetchNFLScheduleUseCase(nflDataProvider);
    }

    // ===================
    // Game Use Cases
    // ===================

    @Bean
    public GetGameHealthUseCase getGameHealthUseCase(
            LeagueRepository leagueRepository,
            WeekRepository weekRepository,
            TeamSelectionRepository teamSelectionRepository) {
        return new GetGameHealthUseCase(leagueRepository, weekRepository, teamSelectionRepository);
    }

    @Bean
    public ProcessGameResultsUseCase processGameResultsUseCase(
            @Qualifier("sportsDataIoAdapter") NflDataProvider nflDataProvider,
            TeamSelectionRepository teamSelectionRepository,
            GameRepository gameRepository,
            ScoringService scoringService) {
        return new ProcessGameResultsUseCase(nflDataProvider, teamSelectionRepository, gameRepository, scoringService);
    }

    // ===================
    // Scoring Use Cases
    // ===================

    @Bean
    public CalculatePlayoffScoreUseCase calculatePlayoffScoreUseCase(
            PlayoffBracketRepository bracketRepository,
            RosterRepository rosterRepository,
            PlayoffScoreRepository scoreRepository,
            @Qualifier("sportsDataIoAdapter") NflDataProvider nflDataProvider) {
        return new CalculatePlayoffScoreUseCase(bracketRepository, rosterRepository, scoreRepository, nflDataProvider);
    }

    @Bean
    public CalculateScoresUseCase calculateScoresUseCase(
            ScoringService scoringService,
            @Qualifier("sportsDataIoAdapter") NflDataProvider nflDataProvider) {
        return new CalculateScoresUseCase(scoringService, nflDataProvider);
    }

    @Bean
    public CalculateFieldGoalScoringUseCase calculateFieldGoalScoringUseCase() {
        return new CalculateFieldGoalScoringUseCase();
    }

    // ===================
    // Playoff Bracket Use Cases
    // ===================

    @Bean
    public InitializePlayoffBracketUseCase initializePlayoffBracketUseCase(
            PlayoffBracketRepository bracketRepository,
            LeagueRepository leagueRepository,
            LeaguePlayerRepository leaguePlayerRepository) {
        return new InitializePlayoffBracketUseCase(bracketRepository, leagueRepository, leaguePlayerRepository);
    }

    @Bean
    public ProcessBracketAdvancementUseCase processBracketAdvancementUseCase(
            PlayoffBracketRepository bracketRepository) {
        return new ProcessBracketAdvancementUseCase(bracketRepository);
    }

    @Bean
    public GetMatchupDetailsUseCase getMatchupDetailsUseCase(
            PlayoffBracketRepository bracketRepository) {
        return new GetMatchupDetailsUseCase(bracketRepository);
    }

    @Bean
    public GeneratePlayoffRankingsUseCase generatePlayoffRankingsUseCase(
            PlayoffBracketRepository bracketRepository,
            PlayoffRankingRepository rankingRepository) {
        return new GeneratePlayoffRankingsUseCase(bracketRepository, rankingRepository);
    }
}
