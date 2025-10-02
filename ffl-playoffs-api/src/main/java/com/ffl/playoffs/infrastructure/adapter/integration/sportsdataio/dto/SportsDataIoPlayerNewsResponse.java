package com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * SportsData.io Fantasy API Player News Response DTO
 * Maps to Fantasy Sports API /PlayerNews endpoint
 * Real-time injury updates and player news
 */
@Data
public class SportsDataIoPlayerNewsResponse {

    @JsonProperty("NewsID")
    private Long newsID;

    @JsonProperty("PlayerID")
    private Long playerID;

    @JsonProperty("Name")
    private String name;

    @JsonProperty("Team")
    private String team;

    @JsonProperty("Position")
    private String position;

    @JsonProperty("Title")
    private String title;

    @JsonProperty("Updated")
    private String updated;

    @JsonProperty("Content")
    private String content;

    @JsonProperty("Source")
    private String source;

    @JsonProperty("Url")
    private String url;

    @JsonProperty("InjuryStatus")
    private String injuryStatus;
}
