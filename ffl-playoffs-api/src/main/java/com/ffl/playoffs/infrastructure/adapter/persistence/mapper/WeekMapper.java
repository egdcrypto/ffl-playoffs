package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.aggregate.Week;
import com.ffl.playoffs.domain.model.WeekStatus;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.WeekDocument;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * Mapper to convert between Week domain model and WeekDocument
 * Infrastructure layer
 */
@Component
public class WeekMapper {

    /**
     * Converts Week domain entity to WeekDocument
     * @param week the domain entity
     * @return the MongoDB document
     */
    public WeekDocument toDocument(Week week) {
        if (week == null) {
            return null;
        }

        return WeekDocument.builder()
                .id(week.getId() != null ? week.getId().toString() : null)
                .leagueId(week.getLeagueId() != null ? week.getLeagueId().toString() : null)
                .gameWeekNumber(week.getGameWeekNumber())
                .nflWeekNumber(week.getNflWeekNumber())
                .status(week.getStatus() != null ? week.getStatus().name() : null)
                .pickDeadline(week.getPickDeadline())
                .startDate(week.getStartDate())
                .endDate(week.getEndDate())
                .totalNFLGames(week.getTotalNFLGames())
                .gamesCompleted(week.getGamesCompleted())
                .gamesInProgress(week.getGamesInProgress())
                .createdAt(week.getCreatedAt())
                .updatedAt(week.getUpdatedAt())
                .build();
    }

    /**
     * Converts WeekDocument to Week domain entity
     * @param document the MongoDB document
     * @return the domain entity
     */
    public Week toDomain(WeekDocument document) {
        if (document == null) {
            return null;
        }

        Week week = new Week();
        week.setId(document.getId() != null ? UUID.fromString(document.getId()) : null);
        week.setLeagueId(document.getLeagueId() != null ? UUID.fromString(document.getLeagueId()) : null);
        week.setGameWeekNumber(document.getGameWeekNumber());
        week.setNflWeekNumber(document.getNflWeekNumber());
        week.setStatus(document.getStatus() != null ? WeekStatus.valueOf(document.getStatus()) : null);
        week.setPickDeadline(document.getPickDeadline());
        week.setStartDate(document.getStartDate());
        week.setEndDate(document.getEndDate());
        week.setTotalNFLGames(document.getTotalNFLGames());
        week.setGamesCompleted(document.getGamesCompleted());
        week.setGamesInProgress(document.getGamesInProgress());
        week.setCreatedAt(document.getCreatedAt());
        week.setUpdatedAt(document.getUpdatedAt());

        return week;
    }
}
