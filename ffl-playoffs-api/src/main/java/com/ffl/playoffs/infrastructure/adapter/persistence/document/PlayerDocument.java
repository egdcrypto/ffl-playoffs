package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * MongoDB embedded document for Player
 * Used within GameDocument
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PlayerDocument {

    private UUID id;
    private UUID gameId;
    private String name;
    private String email;
    private String status;
    private LocalDateTime joinedAt;
    private Boolean isEliminated;

    // Embedded team selections
    private List<TeamSelectionDocument> teamSelections;
}
