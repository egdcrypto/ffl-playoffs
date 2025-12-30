package com.ffl.playoffs.application.dto.nfl;

import com.ffl.playoffs.infrastructure.persistence.mongodb.document.NFLPlayerDocument;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO for NFL Player data
 * Used for API responses
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NFLPlayerDTO {
    private String playerId;
    private String name;
    private String firstName;
    private String lastName;
    private String position;
    private String team;
    private Integer jerseyNumber;
    private String status;

    // Physical attributes
    private Integer height;
    private Integer weight;
    private String birthDate;
    private String college;
    private Integer experience;

    // Injury information
    private String injuryStatus;
    private String injuryBodyPart;
    private String injuryStartDate;
    private String injuryNotes;

    // Fantasy-specific fields
    private Integer byeWeek;
    private String fantasyPosition;
    private Integer depthChartOrder;
    private String photoUrl;

    // Draft information
    private Integer draftYear;
    private Integer draftRound;
    private Integer draftPick;
    private String draftTeam;

    // Season stats
    private Integer gamesPlayed;
    private Double fantasyPoints;
    private Double fantasyPointsPPR;
    private Double averagePointsPerGame;

    /**
     * Convert from MongoDB document to DTO
     * @param document the MongoDB document
     * @return the DTO
     */
    public static NFLPlayerDTO fromDocument(NFLPlayerDocument document) {
        if (document == null) {
            return null;
        }
        return NFLPlayerDTO.builder()
                .playerId(document.getPlayerId())
                .name(document.getName())
                .firstName(document.getFirstName())
                .lastName(document.getLastName())
                .position(document.getPosition())
                .team(document.getTeam())
                .jerseyNumber(document.getJerseyNumber())
                .status(document.getStatus())
                .height(document.getHeight())
                .weight(document.getWeight())
                .birthDate(document.getBirthDate())
                .college(document.getCollege())
                .experience(document.getExperience())
                .injuryStatus(document.getInjuryStatus())
                .injuryBodyPart(document.getInjuryBodyPart())
                .injuryStartDate(document.getInjuryStartDate())
                .injuryNotes(document.getInjuryNotes())
                .byeWeek(document.getByeWeek())
                .fantasyPosition(document.getFantasyPosition())
                .depthChartOrder(document.getDepthChartOrder())
                .photoUrl(document.getPhotoUrl())
                .draftYear(document.getDraftYear())
                .draftRound(document.getDraftRound())
                .draftPick(document.getDraftPick())
                .draftTeam(document.getDraftTeam())
                .gamesPlayed(document.getGamesPlayed())
                .fantasyPoints(document.getFantasyPoints())
                .fantasyPointsPPR(document.getFantasyPointsPPR())
                .averagePointsPerGame(document.getAveragePointsPerGame())
                .build();
    }
}
