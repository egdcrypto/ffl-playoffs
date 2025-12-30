package com.ffl.playoffs.infrastructure.persistence.mongodb.mapper;

import com.ffl.playoffs.domain.aggregate.World;
import com.ffl.playoffs.domain.model.world.SeasonInfo;
import com.ffl.playoffs.domain.model.world.WorldConfiguration;
import com.ffl.playoffs.domain.model.world.WorldStatus;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.WorldDocument;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Mapper between World domain aggregate and WorldDocument
 */
@Component
public class WorldMapper {

    /**
     * Convert domain World to MongoDB document
     * @param world the domain world
     * @return the MongoDB document
     */
    public WorldDocument toDocument(World world) {
        if (world == null) {
            return null;
        }

        WorldDocument.WorldDocumentBuilder builder = WorldDocument.builder()
                .id(world.getId() != null ? world.getId().toString() : null)
                .name(world.getName())
                .description(world.getDescription())
                .status(world.getStatus() != null ? world.getStatus().name() : null)
                .createdBy(world.getCreatedBy() != null ? world.getCreatedBy().toString() : null)
                .createdAt(world.getCreatedAt())
                .updatedAt(world.getUpdatedAt())
                .activatedAt(world.getActivatedAt())
                .completedAt(world.getCompletedAt())
                .completionReason(world.getCompletionReason())
                .activeLeagueCount(world.getActiveLeagueCount())
                .totalParticipants(world.getTotalParticipants())
                .totalGamesPlayed(world.getTotalGamesPlayed());

        // Map league IDs
        if (world.getLeagueIds() != null) {
            builder.leagueIds(world.getLeagueIds().stream()
                    .map(UUID::toString)
                    .collect(Collectors.toList()));
        }

        // Map configuration
        WorldConfiguration config = world.getConfiguration();
        if (config != null) {
            builder.season(config.getSeason())
                    .startingNflWeek(config.getStartingNflWeek())
                    .endingNflWeek(config.getEndingNflWeek())
                    .maxLeagues(config.getMaxLeagues())
                    .maxPlayersPerLeague(config.getMaxPlayersPerLeague())
                    .allowLateRegistration(config.getAllowLateRegistration())
                    .autoAdvanceWeeks(config.getAutoAdvanceWeeks())
                    .timezone(config.getTimezone());
        }

        // Map season info
        SeasonInfo seasonInfo = world.getSeasonInfo();
        if (seasonInfo != null) {
            builder.currentWeek(seasonInfo.getCurrentWeek())
                    .totalWeeks(seasonInfo.getTotalWeeks())
                    .seasonStartDate(seasonInfo.getSeasonStartDate())
                    .seasonEndDate(seasonInfo.getSeasonEndDate())
                    .currentWeekStartDate(seasonInfo.getCurrentWeekStartDate())
                    .currentWeekEndDate(seasonInfo.getCurrentWeekEndDate());
        }

        return builder.build();
    }

    /**
     * Convert MongoDB document to domain World
     * @param document the MongoDB document
     * @return the domain world
     */
    public World toDomain(WorldDocument document) {
        if (document == null) {
            return null;
        }

        World world = new World();

        // Set basic fields
        world.setId(document.getId() != null ? UUID.fromString(document.getId()) : null);
        world.setName(document.getName());
        world.setDescription(document.getDescription());
        world.setStatus(document.getStatus() != null ? WorldStatus.valueOf(document.getStatus()) : null);
        world.setCreatedBy(document.getCreatedBy() != null ? UUID.fromString(document.getCreatedBy()) : null);
        world.setCreatedAt(document.getCreatedAt());
        world.setUpdatedAt(document.getUpdatedAt());
        world.setActivatedAt(document.getActivatedAt());
        world.setCompletedAt(document.getCompletedAt());
        world.setCompletionReason(document.getCompletionReason());
        world.setActiveLeagueCount(document.getActiveLeagueCount());
        world.setTotalParticipants(document.getTotalParticipants());
        world.setTotalGamesPlayed(document.getTotalGamesPlayed());

        // Map league IDs
        if (document.getLeagueIds() != null) {
            List<UUID> leagueIds = document.getLeagueIds().stream()
                    .map(UUID::fromString)
                    .collect(Collectors.toList());
            world.setLeagueIds(leagueIds);
        } else {
            world.setLeagueIds(new ArrayList<>());
        }

        // Map configuration
        if (document.getSeason() != null) {
            WorldConfiguration config = WorldConfiguration.builder()
                    .season(document.getSeason())
                    .startingNflWeek(document.getStartingNflWeek())
                    .endingNflWeek(document.getEndingNflWeek())
                    .maxLeagues(document.getMaxLeagues())
                    .maxPlayersPerLeague(document.getMaxPlayersPerLeague())
                    .allowLateRegistration(document.getAllowLateRegistration())
                    .autoAdvanceWeeks(document.getAutoAdvanceWeeks())
                    .timezone(document.getTimezone())
                    .build();
            world.setConfiguration(config);
        }

        // Map season info
        if (document.getCurrentWeek() != null && document.getTotalWeeks() != null) {
            SeasonInfo seasonInfo = SeasonInfo.builder()
                    .season(document.getSeason())
                    .currentWeek(document.getCurrentWeek())
                    .totalWeeks(document.getTotalWeeks())
                    .seasonStartDate(document.getSeasonStartDate())
                    .seasonEndDate(document.getSeasonEndDate())
                    .currentWeekStartDate(document.getCurrentWeekStartDate())
                    .currentWeekEndDate(document.getCurrentWeekEndDate())
                    .build();
            world.setSeasonInfo(seasonInfo);
        }

        return world;
    }
}
