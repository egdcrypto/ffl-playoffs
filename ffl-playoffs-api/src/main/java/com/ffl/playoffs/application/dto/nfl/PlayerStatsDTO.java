package com.ffl.playoffs.application.dto.nfl;

import com.ffl.playoffs.infrastructure.persistence.mongodb.document.PlayerStatsDocument;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO for Player Statistics data
 * Used for API responses
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PlayerStatsDTO {
    private String playerId;
    private String playerName;
    private Integer week;
    private Integer season;
    private String team;
    private String position;

    // Passing stats
    private Integer passingYards;
    private Integer passingTds;
    private Integer interceptions;
    private Integer passingAttempts;
    private Integer passingCompletions;

    // Rushing stats
    private Integer rushingYards;
    private Integer rushingTds;
    private Integer rushingAttempts;

    // Receiving stats
    private Integer receptions;
    private Integer receivingYards;
    private Integer receivingTds;
    private Integer targets;

    // Other offensive stats
    private Integer twoPointConversions;
    private Integer fumblesLost;

    // Kicker stats
    private Integer fieldGoalsMade;
    private Integer fieldGoalsAttempted;
    private Integer fgMade0To19;
    private Integer fgMade20To29;
    private Integer fgMade30To39;
    private Integer fgMade40To49;
    private Integer fgMade50Plus;
    private Integer extraPointsMade;
    private Integer extraPointsAttempted;

    // Calculated fantasy points
    private Double fantasyPoints;
    private Double pprFantasyPoints;
    private Double halfPprFantasyPoints;

    /**
     * Convert from MongoDB document to DTO
     * @param document the MongoDB document
     * @return the DTO
     */
    public static PlayerStatsDTO fromDocument(PlayerStatsDocument document) {
        if (document == null) {
            return null;
        }
        PlayerStatsDTO dto = PlayerStatsDTO.builder()
                .playerId(document.getPlayerId())
                .playerName(document.getPlayerName())
                .week(document.getWeek())
                .season(document.getSeason())
                .team(document.getTeam())
                .position(document.getPosition())
                .passingYards(document.getPassingYards())
                .passingTds(document.getPassingTds())
                .interceptions(document.getInterceptions())
                .passingAttempts(document.getPassingAttempts())
                .passingCompletions(document.getPassingCompletions())
                .rushingYards(document.getRushingYards())
                .rushingTds(document.getRushingTds())
                .rushingAttempts(document.getRushingAttempts())
                .receptions(document.getReceptions())
                .receivingYards(document.getReceivingYards())
                .receivingTds(document.getReceivingTds())
                .targets(document.getTargets())
                .twoPointConversions(document.getTwoPointConversions())
                .fumblesLost(document.getFumblesLost())
                .fieldGoalsMade(document.getFieldGoalsMade())
                .fieldGoalsAttempted(document.getFieldGoalsAttempted())
                .fgMade0To19(document.getFgMade0To19())
                .fgMade20To29(document.getFgMade20To29())
                .fgMade30To39(document.getFgMade30To39())
                .fgMade40To49(document.getFgMade40To49())
                .fgMade50Plus(document.getFgMade50Plus())
                .extraPointsMade(document.getExtraPointsMade())
                .extraPointsAttempted(document.getExtraPointsAttempted())
                .build();

        // Calculate fantasy points
        dto.setFantasyPoints(calculateStandardPoints(document));
        dto.setPprFantasyPoints(calculatePPRPoints(document));
        dto.setHalfPprFantasyPoints(calculateHalfPPRPoints(document));

        return dto;
    }

    private static double calculateStandardPoints(PlayerStatsDocument stats) {
        double points = 0.0;

        // Passing
        if (stats.getPassingYards() != null) points += stats.getPassingYards() * 0.04;
        if (stats.getPassingTds() != null) points += stats.getPassingTds() * 4;
        if (stats.getInterceptions() != null) points -= stats.getInterceptions() * 2;

        // Rushing
        if (stats.getRushingYards() != null) points += stats.getRushingYards() * 0.1;
        if (stats.getRushingTds() != null) points += stats.getRushingTds() * 6;

        // Receiving
        if (stats.getReceivingYards() != null) points += stats.getReceivingYards() * 0.1;
        if (stats.getReceivingTds() != null) points += stats.getReceivingTds() * 6;

        // Other
        if (stats.getTwoPointConversions() != null) points += stats.getTwoPointConversions() * 2;
        if (stats.getFumblesLost() != null) points -= stats.getFumblesLost() * 2;

        // Kicker
        if (stats.getFgMade0To19() != null) points += stats.getFgMade0To19() * 3;
        if (stats.getFgMade20To29() != null) points += stats.getFgMade20To29() * 3;
        if (stats.getFgMade30To39() != null) points += stats.getFgMade30To39() * 3;
        if (stats.getFgMade40To49() != null) points += stats.getFgMade40To49() * 4;
        if (stats.getFgMade50Plus() != null) points += stats.getFgMade50Plus() * 5;
        if (stats.getExtraPointsMade() != null) points += stats.getExtraPointsMade() * 1;

        return Math.round(points * 100.0) / 100.0;
    }

    private static double calculatePPRPoints(PlayerStatsDocument stats) {
        double points = calculateStandardPoints(stats);
        if (stats.getReceptions() != null) points += stats.getReceptions() * 1.0;
        return Math.round(points * 100.0) / 100.0;
    }

    private static double calculateHalfPPRPoints(PlayerStatsDocument stats) {
        double points = calculateStandardPoints(stats);
        if (stats.getReceptions() != null) points += stats.getReceptions() * 0.5;
        return Math.round(points * 100.0) / 100.0;
    }
}
