package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.model.LeaguePlayer;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.LeaguePlayerDocument;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * Mapper to convert between LeaguePlayer domain model and LeaguePlayerDocument
 * Infrastructure layer
 */
@Component
public class LeaguePlayerMapper {

    /**
     * Converts LeaguePlayer domain entity to LeaguePlayerDocument
     * @param leaguePlayer the domain entity
     * @return the MongoDB document
     */
    public LeaguePlayerDocument toDocument(LeaguePlayer leaguePlayer) {
        if (leaguePlayer == null) {
            return null;
        }

        LeaguePlayerDocument document = new LeaguePlayerDocument();
        document.setId(leaguePlayer.getId() != null ? leaguePlayer.getId().toString() : null);
        document.setUserId(leaguePlayer.getUserId() != null ? leaguePlayer.getUserId().toString() : null);
        document.setLeagueId(leaguePlayer.getLeagueId() != null ? leaguePlayer.getLeagueId().toString() : null);
        document.setStatus(leaguePlayer.getStatus() != null ? leaguePlayer.getStatus().name() : null);
        document.setJoinedAt(leaguePlayer.getJoinedAt());
        document.setInvitedAt(leaguePlayer.getInvitedAt());
        document.setLastActiveAt(leaguePlayer.getLastActiveAt());
        document.setInvitationToken(leaguePlayer.getInvitationToken());
        document.setCreatedAt(leaguePlayer.getCreatedAt());
        document.setUpdatedAt(leaguePlayer.getUpdatedAt());

        return document;
    }

    /**
     * Converts LeaguePlayerDocument to LeaguePlayer domain entity
     * @param document the MongoDB document
     * @return the domain entity
     */
    public LeaguePlayer toDomain(LeaguePlayerDocument document) {
        if (document == null) {
            return null;
        }

        LeaguePlayer leaguePlayer = new LeaguePlayer();
        leaguePlayer.setId(document.getId() != null ? UUID.fromString(document.getId()) : null);
        leaguePlayer.setUserId(document.getUserId() != null ? UUID.fromString(document.getUserId()) : null);
        leaguePlayer.setLeagueId(document.getLeagueId() != null ? UUID.fromString(document.getLeagueId()) : null);
        leaguePlayer.setStatus(document.getStatus() != null ? LeaguePlayer.LeaguePlayerStatus.valueOf(document.getStatus()) : null);
        leaguePlayer.setJoinedAt(document.getJoinedAt());
        leaguePlayer.setInvitedAt(document.getInvitedAt());
        leaguePlayer.setLastActiveAt(document.getLastActiveAt());
        leaguePlayer.setInvitationToken(document.getInvitationToken());
        leaguePlayer.setCreatedAt(document.getCreatedAt());
        leaguePlayer.setUpdatedAt(document.getUpdatedAt());

        return leaguePlayer;
    }
}
