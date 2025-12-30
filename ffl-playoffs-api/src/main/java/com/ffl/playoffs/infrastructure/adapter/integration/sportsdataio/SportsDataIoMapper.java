package com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio;

import com.ffl.playoffs.domain.aggregate.NFLPlayer;
import com.ffl.playoffs.domain.aggregate.*;
import com.ffl.playoffs.domain.model.*;
import com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio.dto.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * Mapper to convert SportsData.io DTOs to Domain Models
 * Follows hexagonal architecture - infrastructure layer mapping to domain
 */
@Component
@Slf4j
public class SportsDataIoMapper {

    /**
     * Map SportsData.io Player Response to Domain NFLPlayer
     *
     * @param response SportsData.io API response
     * @return Domain NFLPlayer model
     */
    public NFLPlayer toDomainPlayer(SportsDataIoPlayerResponse response) {
        if (response == null) {
            return null;
        }

        NFLPlayer player = new NFLPlayer();
        player.setId(response.getPlayerID());
        player.setName(response.getName());
        player.setFirstName(response.getFirstName());
        player.setLastName(response.getLastName());
        player.setPosition(mapPosition(response.getPosition()));
        player.setNflTeam(response.getTeam());
        player.setNflTeamAbbreviation(response.getTeam());
        player.setJerseyNumber(response.getNumber());
        player.setStatus(mapPlayerStatus(response.getStatus(), response.getInjuryStatus()));

        // Fantasy points (season totals)
        if (response.getFantasyPointsPPR() != null) {
            player.setFantasyPoints(response.getFantasyPointsPPR());
        }

        return player;
    }

    /**
     * Map SportsData.io Player Response to NFLPlayerDocument for MongoDB storage
     *
     * @param response SportsData.io API response
     * @return MongoDB NFLPlayerDocument
     */
    public com.ffl.playoffs.infrastructure.persistence.mongodb.document.NFLPlayerDocument toDocument(SportsDataIoPlayerResponse response) {
        if (response == null) {
            return null;
        }

        return com.ffl.playoffs.infrastructure.persistence.mongodb.document.NFLPlayerDocument.builder()
                .playerId(String.valueOf(response.getPlayerID()))
                .name(response.getName())
                .firstName(response.getFirstName())
                .lastName(response.getLastName())
                .position(response.getPosition())
                .team(response.getTeam())
                .jerseyNumber(response.getNumber())
                .status(mapPlayerStatus(response.getStatus(), response.getInjuryStatus()))
                .height(response.getHeightInInches())
                .weight(response.getWeight())
                .birthDate(response.getBirthDate())
                .college(response.getCollege())
                .experience(response.getExperience())
                .injuryStatus(response.getInjuryStatus())
                .injuryBodyPart(response.getInjuryBodyPart())
                .injuryStartDate(response.getInjuryStartDate())
                .injuryNotes(response.getInjuryNotes())
                .byeWeek(response.getByeWeek())
                .fantasyPosition(response.getFantasyPosition())
                .depthChartOrder(response.getDepthOrder())
                .photoUrl(response.getPhotoUrl())
                .draftYear(response.getDraftYear())
                .draftRound(response.getDraftRound())
                .draftPick(response.getDraftPick())
                .draftTeam(response.getDraftTeam())
                .gamesPlayed(response.getGamesPlayed())
                .fantasyPoints(response.getFantasyPoints())
                .fantasyPointsPPR(response.getFantasyPointsPPR())
                .createdAt(java.time.LocalDateTime.now())
                .updatedAt(java.time.LocalDateTime.now())
                .build();
    }

    /**
     * Map SportsData.io Fantasy Stats Response to Domain PlayerStats
     *
     * @param response SportsData.io fantasy stats response
     * @return Domain PlayerStats model
     */
    public PlayerStats toDomainPlayerStats(SportsDataIoFantasyStatsResponse response) {
        if (response == null) {
            return null;
        }

        PlayerStats stats = new PlayerStats();
        stats.setId(UUID.randomUUID());
        stats.setNflPlayerId(response.getPlayerID());
        stats.setWeek(response.getWeek());
        stats.setSeason(response.getSeason());

        // Passing stats
        stats.setPassingYards(response.getPassingYards());
        stats.setPassingTouchdowns(response.getPassingTouchdowns());
        stats.setInterceptions(response.getPassingInterceptions());
        stats.setPassingAttempts(response.getPassingAttempts());
        stats.setPassingCompletions(response.getPassingCompletions());

        // Rushing stats
        stats.setRushingYards(response.getRushingYards());
        stats.setRushingTouchdowns(response.getRushingTouchdowns());
        stats.setRushingAttempts(response.getRushingAttempts());

        // Receiving stats
        stats.setReceptions(response.getReceptions());
        stats.setReceivingYards(response.getReceivingYards());
        stats.setReceivingTouchdowns(response.getReceivingTouchdowns());
        stats.setTargets(response.getTargets());

        // Two-point conversions
        Integer twoPointTotal = safeAdd(
            safeAdd(response.getTwoPointConversionPasses(), response.getTwoPointConversionRuns()),
            response.getTwoPointConversionReceptions()
        );
        stats.setTwoPointConversions(twoPointTotal);

        // Fumbles
        stats.setFumbles(response.getFumbles());
        stats.setFumblesLost(response.getFumblesLost());

        // Kicking stats
        stats.setFieldGoalsMade(response.getFieldGoalsMade());
        stats.setFieldGoalsAttempted(response.getFieldGoalsAttempted());
        stats.setFieldGoalsMade0_19(response.getFieldGoalsMade0to19());
        stats.setFieldGoalsMade20_29(response.getFieldGoalsMade20to29());
        stats.setFieldGoalsMade30_39(response.getFieldGoalsMade30to39());
        stats.setFieldGoalsMade40_49(response.getFieldGoalsMade40to49());
        stats.setFieldGoalsMade50Plus(response.getFieldGoalsMade50Plus());
        stats.setExtraPointsMade(response.getExtraPointsMade());

        return stats;
    }

    /**
     * Map SportsData.io position string to Domain Position enum
     *
     * @param sportsDataPosition Position string from API (e.g., "QB", "RB")
     * @return Domain Position enum
     */
    private Position mapPosition(String sportsDataPosition) {
        if (sportsDataPosition == null) {
            log.warn("Null position provided, defaulting to null");
            return null;
        }

        return switch (sportsDataPosition.toUpperCase()) {
            case "QB" -> Position.QB;
            case "RB" -> Position.RB;
            case "WR" -> Position.WR;
            case "TE" -> Position.TE;
            case "K" -> Position.K;
            case "DEF", "DST" -> Position.DEF;
            default -> {
                log.warn("Unknown position: {}, defaulting to null", sportsDataPosition);
                yield null;
            }
        };
    }

    /**
     * Map SportsData.io player status and injury status to domain status string
     *
     * @param status Player status (Active, Injured, etc.)
     * @param injuryStatus Specific injury status (Healthy, Questionable, Out, etc.)
     * @return Domain status string
     */
    private String mapPlayerStatus(String status, String injuryStatus) {
        // Priority: injuryStatus > status
        if (injuryStatus != null && !injuryStatus.equalsIgnoreCase("Healthy")) {
            return switch (injuryStatus.toUpperCase()) {
                case "OUT" -> "OUT";
                case "QUESTIONABLE" -> "QUESTIONABLE";
                case "DOUBTFUL" -> "DOUBTFUL";
                case "INJURED RESERVE", "IR" -> "INJURED";
                default -> "ACTIVE";
            };
        }

        if (status != null) {
            return switch (status.toUpperCase()) {
                case "ACTIVE" -> "ACTIVE";
                case "INJURED" -> "INJURED";
                case "OUT" -> "OUT";
                default -> "ACTIVE";
            };
        }

        return "ACTIVE";
    }

    /**
     * Safely add two integers, treating null as 0
     *
     * @param a First integer (can be null)
     * @param b Second integer (can be null)
     * @return Sum of a and b, with nulls treated as 0
     */
    private Integer safeAdd(Integer a, Integer b) {
        int aVal = (a != null) ? a : 0;
        int bVal = (b != null) ? b : 0;
        return aVal + bVal;
    }

    /**
     * Extract injury status from player news
     *
     * @param newsResponse Player news response
     * @return Injury status string or null
     */
    public String extractInjuryStatus(SportsDataIoPlayerNewsResponse newsResponse) {
        if (newsResponse == null) {
            return null;
        }

        String injuryStatus = newsResponse.getInjuryStatus();
        if (injuryStatus != null && !injuryStatus.equalsIgnoreCase("Healthy")) {
            return injuryStatus;
        }

        return null;
    }
}
