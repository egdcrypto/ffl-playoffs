package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.model.DefensiveScoringRules;
import com.ffl.playoffs.domain.model.FieldGoalScoringRules;
import com.ffl.playoffs.domain.model.PPRScoringRules;
import com.ffl.playoffs.domain.model.ScoringRules;
import com.ffl.playoffs.domain.port.LeagueRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;

/**
 * Use case for configuring league scoring rules.
 * Allows admins to set custom PPR, field goal, and defensive scoring.
 */
@Service
public class ConfigureLeagueScoringUseCase {

    private final LeagueRepository leagueRepository;

    public ConfigureLeagueScoringUseCase(LeagueRepository leagueRepository) {
        this.leagueRepository = leagueRepository;
    }

    /**
     * Configures custom PPR scoring rules for a league.
     *
     * @param command The configuration command
     * @return The updated league
     * @throws IllegalArgumentException if league not found
     * @throws UnauthorizedLeagueAccessException if admin doesn't own the league
     * @throws League.ConfigurationLockedException if league is locked
     */
    @Transactional
    public League configurePPRScoring(ConfigurePPRCommand command) {
        League league = getLeagueAndValidateOwnership(command.getLeagueId(), command.getAdminUserId());
        league.validateConfigurationMutable(LocalDateTime.now());

        PPRScoringRules pprRules = new PPRScoringRules(
                command.getReceptionPoints(),
                command.getRushingYardsPerPoint(),
                command.getReceivingYardsPerPoint(),
                command.getTouchdownPoints(),
                command.getTouchdownPoints(),
                2.0,  // Default 2-point conversion
                2.0   // Default fumble penalty
        );

        ScoringRules currentRules = league.getScoringRules();
        if (currentRules == null) {
            currentRules = ScoringRules.defaultRules();
        }

        ScoringRules updatedRules = ScoringRules.builder()
                .passingYardsPerPoint(command.getPassingYardsPerPoint() != null ?
                        command.getPassingYardsPerPoint() : currentRules.getPassingYardsPerPoint())
                .passingTouchdownPoints(command.getTouchdownPoints())
                .interceptionPenalty(currentRules.getInterceptionPenalty())
                .pprScoringRules(pprRules)
                .fieldGoalScoringRules(currentRules.getFieldGoalScoringRules())
                .defensiveScoringRules(currentRules.getDefensiveScoringRules())
                .build();

        league.setScoringRules(updatedRules);
        return leagueRepository.save(league);
    }

    /**
     * Configures custom field goal scoring for a league.
     *
     * @param command The configuration command
     * @return The updated league
     */
    @Transactional
    public League configureFieldGoalScoring(ConfigureFieldGoalCommand command) {
        League league = getLeagueAndValidateOwnership(command.getLeagueId(), command.getAdminUserId());
        league.validateConfigurationMutable(LocalDateTime.now());

        FieldGoalScoringRules fgRules = new FieldGoalScoringRules(
                command.getFg0to39Points(),  // 0-19
                command.getFg0to39Points(),  // 20-29 (same tier)
                command.getFg0to39Points(),  // 30-39
                command.getFg40to49Points(),
                command.getFg50PlusPoints(),
                1.0,  // Default extra point
                0.0   // Default missed XP penalty
        );

        ScoringRules currentRules = league.getScoringRules();
        if (currentRules == null) {
            currentRules = ScoringRules.defaultRules();
        }

        ScoringRules updatedRules = ScoringRules.builder()
                .passingYardsPerPoint(currentRules.getPassingYardsPerPoint())
                .passingTouchdownPoints(currentRules.getPassingTouchdownPoints())
                .interceptionPenalty(currentRules.getInterceptionPenalty())
                .pprScoringRules(currentRules.getPprScoringRules())
                .fieldGoalScoringRules(fgRules)
                .defensiveScoringRules(currentRules.getDefensiveScoringRules())
                .build();

        league.setScoringRules(updatedRules);
        return leagueRepository.save(league);
    }

    /**
     * Configures custom defensive scoring for a league.
     *
     * @param command The configuration command
     * @return The updated league
     */
    @Transactional
    public League configureDefensiveScoring(ConfigureDefensiveCommand command) {
        League league = getLeagueAndValidateOwnership(command.getLeagueId(), command.getAdminUserId());
        league.validateConfigurationMutable(LocalDateTime.now());

        ScoringRules currentRules = league.getScoringRules();
        DefensiveScoringRules currentDefensive = currentRules != null ?
                currentRules.getDefensiveScoringRules() : DefensiveScoringRules.defaultRules();

        DefensiveScoringRules defRules = new DefensiveScoringRules(
                command.getSackPoints(),
                command.getInterceptionPoints(),
                command.getFumbleRecoveryPoints(),
                command.getSafetyPoints(),
                command.getDefensiveTDPoints(),
                currentDefensive != null ? currentDefensive.getBlockedKickPoints() : 2.0,
                currentDefensive != null ? currentDefensive.getKickReturnTouchdownPoints() : 6.0,
                currentDefensive != null ? currentDefensive.getPuntReturnTouchdownPoints() : 6.0,
                command.getPointsAllowedTiers(),
                currentDefensive != null ? currentDefensive.getYardsAllowedTiers() : null
        );

        if (currentRules == null) {
            currentRules = ScoringRules.defaultRules();
        }

        ScoringRules updatedRules = ScoringRules.builder()
                .passingYardsPerPoint(currentRules.getPassingYardsPerPoint())
                .passingTouchdownPoints(currentRules.getPassingTouchdownPoints())
                .interceptionPenalty(currentRules.getInterceptionPenalty())
                .pprScoringRules(currentRules.getPprScoringRules())
                .fieldGoalScoringRules(currentRules.getFieldGoalScoringRules())
                .defensiveScoringRules(defRules)
                .build();

        league.setScoringRules(updatedRules);
        return leagueRepository.save(league);
    }

    private League getLeagueAndValidateOwnership(UUID leagueId, UUID adminUserId) {
        League league = leagueRepository.findById(leagueId)
                .orElseThrow(() -> new IllegalArgumentException(
                    "League not found: " + leagueId));

        if (!league.getOwnerId().equals(adminUserId)) {
            throw new UnauthorizedLeagueAccessException(
                "Admin does not own this league");
        }

        return league;
    }

    // Command classes

    public static class ConfigurePPRCommand {
        private final UUID leagueId;
        private final UUID adminUserId;
        private final Double passingYardsPerPoint;
        private final Double rushingYardsPerPoint;
        private final Double receivingYardsPerPoint;
        private final Double receptionPoints;
        private final Double touchdownPoints;

        public ConfigurePPRCommand(UUID leagueId, UUID adminUserId,
                                   Double passingYardsPerPoint, Double rushingYardsPerPoint,
                                   Double receivingYardsPerPoint, Double receptionPoints,
                                   Double touchdownPoints) {
            this.leagueId = leagueId;
            this.adminUserId = adminUserId;
            this.passingYardsPerPoint = passingYardsPerPoint;
            this.rushingYardsPerPoint = rushingYardsPerPoint;
            this.receivingYardsPerPoint = receivingYardsPerPoint;
            this.receptionPoints = receptionPoints;
            this.touchdownPoints = touchdownPoints;
        }

        public UUID getLeagueId() { return leagueId; }
        public UUID getAdminUserId() { return adminUserId; }
        public Double getPassingYardsPerPoint() { return passingYardsPerPoint; }
        public Double getRushingYardsPerPoint() { return rushingYardsPerPoint; }
        public Double getReceivingYardsPerPoint() { return receivingYardsPerPoint; }
        public Double getReceptionPoints() { return receptionPoints; }
        public Double getTouchdownPoints() { return touchdownPoints; }
    }

    public static class ConfigureFieldGoalCommand {
        private final UUID leagueId;
        private final UUID adminUserId;
        private final Double fg0to39Points;
        private final Double fg40to49Points;
        private final Double fg50PlusPoints;

        public ConfigureFieldGoalCommand(UUID leagueId, UUID adminUserId,
                                         Double fg0to39Points, Double fg40to49Points,
                                         Double fg50PlusPoints) {
            this.leagueId = leagueId;
            this.adminUserId = adminUserId;
            this.fg0to39Points = fg0to39Points;
            this.fg40to49Points = fg40to49Points;
            this.fg50PlusPoints = fg50PlusPoints;
        }

        public UUID getLeagueId() { return leagueId; }
        public UUID getAdminUserId() { return adminUserId; }
        public Double getFg0to39Points() { return fg0to39Points; }
        public Double getFg40to49Points() { return fg40to49Points; }
        public Double getFg50PlusPoints() { return fg50PlusPoints; }
    }

    public static class ConfigureDefensiveCommand {
        private final UUID leagueId;
        private final UUID adminUserId;
        private final Double sackPoints;
        private final Double interceptionPoints;
        private final Double fumbleRecoveryPoints;
        private final Double safetyPoints;
        private final Double defensiveTDPoints;
        private final Map<Integer, Double> pointsAllowedTiers;

        public ConfigureDefensiveCommand(UUID leagueId, UUID adminUserId,
                                         Double sackPoints, Double interceptionPoints,
                                         Double fumbleRecoveryPoints, Double safetyPoints,
                                         Double defensiveTDPoints,
                                         Map<Integer, Double> pointsAllowedTiers) {
            this.leagueId = leagueId;
            this.adminUserId = adminUserId;
            this.sackPoints = sackPoints;
            this.interceptionPoints = interceptionPoints;
            this.fumbleRecoveryPoints = fumbleRecoveryPoints;
            this.safetyPoints = safetyPoints;
            this.defensiveTDPoints = defensiveTDPoints;
            this.pointsAllowedTiers = pointsAllowedTiers;
        }

        public UUID getLeagueId() { return leagueId; }
        public UUID getAdminUserId() { return adminUserId; }
        public Double getSackPoints() { return sackPoints; }
        public Double getInterceptionPoints() { return interceptionPoints; }
        public Double getFumbleRecoveryPoints() { return fumbleRecoveryPoints; }
        public Double getSafetyPoints() { return safetyPoints; }
        public Double getDefensiveTDPoints() { return defensiveTDPoints; }
        public Map<Integer, Double> getPointsAllowedTiers() { return pointsAllowedTiers; }
    }

    public static class UnauthorizedLeagueAccessException extends RuntimeException {
        public UnauthorizedLeagueAccessException(String message) {
            super(message);
        }

        public String getErrorCode() {
            return "UNAUTHORIZED_LEAGUE_ACCESS";
        }
    }
}
