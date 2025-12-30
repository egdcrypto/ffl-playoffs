package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.model.world.*;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.WorldDocument;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * Mapper for converting between World domain model and MongoDB document.
 */
@Component
public class WorldMapper {

    /**
     * Convert domain model to document.
     */
    public WorldDocument toDocument(World world) {
        if (world == null) {
            return null;
        }

        return WorldDocument.builder()
                .id(world.getId() != null ? world.getId().toString() : null)
                .name(world.getName())
                .description(world.getDescription())
                .code(world.getCode())
                .primaryOwnerId(world.getPrimaryOwnerId() != null ? world.getPrimaryOwnerId().toString() : null)
                .status(world.getStatus() != null ? world.getStatus().getCode() : null)
                .visibility(world.getVisibility() != null ? world.getVisibility().getCode() : null)
                .settings(toSettingsDocument(world.getSettings()))
                .leagueCount(world.getLeagueCount())
                .ownerCount(world.getOwnerCount())
                .memberCount(world.getMemberCount())
                .createdAt(world.getCreatedAt())
                .updatedAt(world.getUpdatedAt())
                .activatedAt(world.getActivatedAt())
                .archivedAt(world.getArchivedAt())
                .build();
    }

    /**
     * Convert document to domain model.
     */
    public World toDomain(WorldDocument doc) {
        if (doc == null) {
            return null;
        }

        return World.builder()
                .id(doc.getId() != null ? UUID.fromString(doc.getId()) : null)
                .name(doc.getName())
                .description(doc.getDescription())
                .code(doc.getCode())
                .primaryOwnerId(doc.getPrimaryOwnerId() != null ? UUID.fromString(doc.getPrimaryOwnerId()) : null)
                .status(doc.getStatus() != null ? WorldStatus.fromCode(doc.getStatus()) : null)
                .visibility(doc.getVisibility() != null ? WorldVisibility.fromCode(doc.getVisibility()) : null)
                .settings(toSettingsDomain(doc.getSettings()))
                .leagueCount(doc.getLeagueCount())
                .ownerCount(doc.getOwnerCount())
                .memberCount(doc.getMemberCount())
                .createdAt(doc.getCreatedAt())
                .updatedAt(doc.getUpdatedAt())
                .activatedAt(doc.getActivatedAt())
                .archivedAt(doc.getArchivedAt())
                .build();
    }

    /**
     * Convert settings domain model to document.
     */
    private WorldDocument.WorldSettingsDocument toSettingsDocument(WorldSettings settings) {
        if (settings == null) {
            return null;
        }

        return WorldDocument.WorldSettingsDocument.builder()
                .maxLeagues(settings.getMaxLeagues())
                .maxOwners(settings.getMaxOwners())
                .maxMembers(settings.getMaxMembers())
                .leagueCreationEnabled(settings.getLeagueCreationEnabled())
                .invitationsEnabled(settings.getInvitationsEnabled())
                .publicLeaderboard(settings.getPublicLeaderboard())
                .defaultScoringTemplate(settings.getDefaultScoringTemplate())
                .defaultRosterTemplate(settings.getDefaultRosterTemplate())
                .theme(settings.getTheme())
                .welcomeMessage(settings.getWelcomeMessage())
                .build();
    }

    /**
     * Convert settings document to domain model.
     */
    private WorldSettings toSettingsDomain(WorldDocument.WorldSettingsDocument doc) {
        if (doc == null) {
            return WorldSettings.defaults();
        }

        return WorldSettings.builder()
                .maxLeagues(doc.getMaxLeagues())
                .maxOwners(doc.getMaxOwners())
                .maxMembers(doc.getMaxMembers())
                .leagueCreationEnabled(doc.getLeagueCreationEnabled())
                .invitationsEnabled(doc.getInvitationsEnabled())
                .publicLeaderboard(doc.getPublicLeaderboard())
                .defaultScoringTemplate(doc.getDefaultScoringTemplate())
                .defaultRosterTemplate(doc.getDefaultRosterTemplate())
                .theme(doc.getTheme())
                .welcomeMessage(doc.getWelcomeMessage())
                .build();
    }
}
