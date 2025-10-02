package com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

/**
 * SportsData.io Fantasy API Player Response DTO
 * Maps to Fantasy Sports API /Player/{playerID} endpoint
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

    @JsonProperty("PhotoUrl")
    private String photoUrl;

    @JsonProperty("InjuryStatus")
    private String injuryStatus;

    @JsonProperty("InjuryNotes")
    private String injuryNotes;

    @JsonProperty("FantasyPointsPPR")
    private Double fantasyPointsPPR;

    @JsonProperty("FantasyPointsStandard")
    private Double fantasyPointsStandard;

    @JsonProperty("FantasyPointsHalfPPR")
    private Double fantasyPointsHalfPPR;
}
