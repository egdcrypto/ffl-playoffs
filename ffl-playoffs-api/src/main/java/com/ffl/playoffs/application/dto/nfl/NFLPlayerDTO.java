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
                .build();
    }
}
