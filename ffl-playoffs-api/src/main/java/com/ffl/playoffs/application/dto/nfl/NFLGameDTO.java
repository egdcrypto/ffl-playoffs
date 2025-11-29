package com.ffl.playoffs.application.dto.nfl;

import com.ffl.playoffs.infrastructure.persistence.mongodb.document.NFLGameDocument;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * DTO for NFL Game data
 * Used for API responses
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NFLGameDTO {
    private String gameId;
    private Integer season;
    private Integer week;
    private String homeTeam;
    private String awayTeam;
    private Integer homeScore;
    private Integer awayScore;
    private LocalDateTime gameTime;
    private LocalDateTime gameDate;
    private String status;
    private String quarter;
    private String timeRemaining;
    private String venue;

    /**
     * Convert from MongoDB document to DTO
     * @param document the MongoDB document
     * @return the DTO
     */
    public static NFLGameDTO fromDocument(NFLGameDocument document) {
        if (document == null) {
            return null;
        }
        return NFLGameDTO.builder()
                .gameId(document.getGameId())
                .season(document.getSeason())
                .week(document.getWeek())
                .homeTeam(document.getHomeTeam())
                .awayTeam(document.getAwayTeam())
                .homeScore(document.getHomeScore())
                .awayScore(document.getAwayScore())
                .gameTime(document.getGameTime())
                .gameDate(document.getGameDate())
                .status(document.getStatus())
                .quarter(document.getQuarter())
                .timeRemaining(document.getTimeRemaining())
                .venue(document.getVenue())
                .build();
    }
}
