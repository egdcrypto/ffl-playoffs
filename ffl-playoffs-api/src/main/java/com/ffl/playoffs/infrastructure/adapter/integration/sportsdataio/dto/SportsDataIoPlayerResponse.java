package com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

/**
 * SportsData.io Fantasy API Player Response DTO
 * Maps to Fantasy Sports API /Player/{playerID} endpoint
 * Comprehensive player data from SportsData.io API
 */
@Data
public class SportsDataIoPlayerResponse {

    @JsonProperty("PlayerID")
    private Long playerID;

    @JsonProperty("Name")
    private String name;

    @JsonProperty("FirstName")
    private String firstName;

    @JsonProperty("LastName")
    private String lastName;

    @JsonProperty("Position")
    private String position;

    @JsonProperty("Team")
    private String team;

    @JsonProperty("Number")
    private Integer number;

    @JsonProperty("Status")
    private String status;

    // Physical attributes
    @JsonProperty("Height")
    private String height; // e.g., "6'3\""

    @JsonProperty("Weight")
    private Integer weight;

    @JsonProperty("BirthDate")
    private String birthDate;

    @JsonProperty("College")
    private String college;

    @JsonProperty("Experience")
    private Integer experience;

    // Injury information
    @JsonProperty("InjuryStatus")
    private String injuryStatus;

    @JsonProperty("InjuryBodyPart")
    private String injuryBodyPart;

    @JsonProperty("InjuryStartDate")
    private String injuryStartDate;

    @JsonProperty("InjuryNotes")
    private String injuryNotes;

    // Fantasy-specific fields
    @JsonProperty("ByeWeek")
    private Integer byeWeek;

    @JsonProperty("FantasyPosition")
    private String fantasyPosition;

    @JsonProperty("DepthOrder")
    private Integer depthOrder;

    @JsonProperty("DepthPositionCategory")
    private String depthPositionCategory;

    @JsonProperty("PhotoUrl")
    private String photoUrl;

    // Draft information
    @JsonProperty("DraftYear")
    private Integer draftYear;

    @JsonProperty("DraftRound")
    private Integer draftRound;

    @JsonProperty("DraftPick")
    private Integer draftPick;

    @JsonProperty("DraftTeam")
    private String draftTeam;

    // Fantasy points
    @JsonProperty("FantasyPointsPPR")
    private Double fantasyPointsPPR;

    @JsonProperty("FantasyPoints")
    private Double fantasyPoints;

    @JsonProperty("FantasyPointsStandard")
    private Double fantasyPointsStandard;

    @JsonProperty("FantasyPointsHalfPPR")
    private Double fantasyPointsHalfPPR;

    @JsonProperty("AverageDraftPosition")
    private Double averageDraftPosition;

    // Season stats
    @JsonProperty("Played")
    private Integer gamesPlayed;

    @JsonProperty("LastUpdated")
    private String lastUpdated;

    /**
     * Parse height string (e.g., "6'3\"") to inches
     * @return height in inches, or null if parsing fails
     */
    public Integer getHeightInInches() {
        if (height == null || height.isEmpty()) {
            return null;
        }
        try {
            // Parse format like "6'3\""
            String[] parts = height.replace("\"", "").split("'");
            if (parts.length == 2) {
                int feet = Integer.parseInt(parts[0].trim());
                int inches = Integer.parseInt(parts[1].trim());
                return feet * 12 + inches;
            }
        } catch (Exception e) {
            // Return null if parsing fails
        }
        return null;
    }
}
