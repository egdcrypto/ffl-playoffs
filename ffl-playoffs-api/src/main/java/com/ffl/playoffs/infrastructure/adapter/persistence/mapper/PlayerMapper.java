package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.StandalonePlayerDocument;
import org.springframework.stereotype.Component;

/**
 * Mapper to convert between Player domain model and StandalonePlayerDocument
 * Infrastructure layer
 */
@Component
public class PlayerMapper {

    /**
     * Converts Player domain entity to StandalonePlayerDocument
     * @param player the domain entity
     * @return the MongoDB document
     */
    public StandalonePlayerDocument toDocument(Player player) {
        if (player == null) {
            return null;
        }

        StandalonePlayerDocument document = new StandalonePlayerDocument();
        document.setId(player.getId() != null ? player.getId().toString() : null);
        document.setEmail(player.getEmail());
        document.setDisplayName(player.getDisplayName());
        document.setGoogleId(player.getGoogleId());
        document.setJoinedAt(player.getJoinedAt());
        document.setStatus(player.getStatus() != null ? player.getStatus().name() : null);

        return document;
    }

    /**
     * Converts StandalonePlayerDocument to Player domain entity
     * @param document the MongoDB document
     * @return the domain entity
     */
    public Player toDomain(StandalonePlayerDocument document) {
        if (document == null) {
            return null;
        }

        return Player.builder()
                .id(document.getId() != null ? Long.parseLong(document.getId()) : null)
                .email(document.getEmail())
                .displayName(document.getDisplayName())
                .googleId(document.getGoogleId())
                .joinedAt(document.getJoinedAt())
                .status(document.getStatus() != null ?
                        Player.PlayerStatus.valueOf(document.getStatus()) : null)
                .build();
    }
}
