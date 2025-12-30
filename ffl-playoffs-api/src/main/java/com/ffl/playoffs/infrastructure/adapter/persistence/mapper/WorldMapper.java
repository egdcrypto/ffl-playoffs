package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.aggregate.World;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.WorldDocument;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * Mapper to convert between World domain model and WorldDocument.
 * Infrastructure layer - handles bidirectional conversion.
 */
@Component
public class WorldMapper {

    /**
     * Converts World domain entity to WorldDocument
     * @param world the domain entity
     * @return the MongoDB document
     */
    public WorldDocument toDocument(World world) {
        if (world == null) {
            return null;
        }

        WorldDocument document = new WorldDocument();
        document.setId(world.getId() != null ? world.getId().toString() : null);
        document.setName(world.getName());
        document.setDescription(world.getDescription());
        document.setOwnerId(world.getOwnerId() != null ? world.getOwnerId().toString() : null);
        document.setNarrativeSource(world.getNarrativeSource());
        document.setStatus(world.getStatus() != null ? world.getStatus().name() : null);
        document.setIsPublic(world.getIsPublic());
        document.setMaxPlayers(world.getMaxPlayers());
        document.setIsDeployed(world.getIsDeployed());
        document.setDeployedAt(world.getDeployedAt());
        document.setCreatedAt(world.getCreatedAt());
        document.setUpdatedAt(world.getUpdatedAt());

        return document;
    }

    /**
     * Converts WorldDocument to World domain entity
     * @param document the MongoDB document
     * @return the domain entity
     */
    public World toDomain(WorldDocument document) {
        if (document == null) {
            return null;
        }

        World world = new World();
        world.setId(document.getId() != null ? UUID.fromString(document.getId()) : null);
        world.setName(document.getName());
        world.setDescription(document.getDescription());
        world.setOwnerId(document.getOwnerId() != null ? UUID.fromString(document.getOwnerId()) : null);
        world.setNarrativeSource(document.getNarrativeSource());
        world.setStatus(document.getStatus() != null ?
            World.WorldStatus.valueOf(document.getStatus()) : null);
        world.setIsPublic(document.getIsPublic());
        world.setMaxPlayers(document.getMaxPlayers());
        world.setIsDeployed(document.getIsDeployed());
        world.setDeployedAt(document.getDeployedAt());
        world.setCreatedAt(document.getCreatedAt());
        world.setUpdatedAt(document.getUpdatedAt());

        return world;
    }
}
