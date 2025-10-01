package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.index.Indexed;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * MongoDB document for Game entity
 * Infrastructure layer - contains framework-specific annotations
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "games")
public class GameDocument {

    @Id
    private UUID id;

    private String name;

    @Indexed(unique = true)
    private String code;

    private UUID creatorId;
    private String status;
    private Integer startingWeek;
    private Integer currentWeek;
    private Integer numberOfWeeks;
    private String eliminationMode;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime configurationLockedAt;
    private String lockReason;
    private LocalDateTime firstGameStartTime;

    // Embedded players
    private List<PlayerDocument> players;

    // Embedded scoring rules
    private ScoringRulesDocument scoringRules;
}
