package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * MongoDB embedded document for TeamSelection
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TeamSelectionDocument {

    private UUID id;
    private UUID playerId;
    private String teamName;
    private Integer weekNumber;
    private LocalDateTime selectedAt;
    private Boolean isEliminated;
}
