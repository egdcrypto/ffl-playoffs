package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import com.ffl.playoffs.domain.model.WeekStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.CompoundIndexes;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

/**
 * MongoDB document for Week entity
 * Infrastructure layer - MongoDB specific
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "weeks")
@CompoundIndexes({
    @CompoundIndex(name = "league_gameWeek_idx", def = "{'leagueId': 1, 'gameWeekNumber': 1}", unique = true),
    @CompoundIndex(name = "league_nflWeek_idx", def = "{'leagueId': 1, 'nflWeekNumber': 1}", unique = true),
    @CompoundIndex(name = "league_status_idx", def = "{'leagueId': 1, 'status': 1}")
})
public class WeekDocument {

    @Id
    private String id;
    private String leagueId;
    private Integer gameWeekNumber;
    private Integer nflWeekNumber;
    private String status;
    private LocalDateTime pickDeadline;
    private LocalDateTime startDate;
    private LocalDateTime endDate;

    // Metadata
    private Integer totalNFLGames;
    private Integer gamesCompleted;
    private Integer gamesInProgress;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
