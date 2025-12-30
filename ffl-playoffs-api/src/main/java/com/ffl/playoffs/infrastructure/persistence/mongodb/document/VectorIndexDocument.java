package com.ffl.playoffs.infrastructure.persistence.mongodb.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * MongoDB document for vector index storage.
 * Supports MongoDB Atlas Vector Search for similarity queries.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "vector_indices")
@CompoundIndex(name = "source_type_idx", def = "{'source_id': 1, 'document_type': 1}", unique = true)
public class VectorIndexDocument {

    @Id
    private String id;

    @Field("source_id")
    @Indexed
    private String sourceId;

    @Field("document_type")
    @Indexed
    private String documentType;

    @Field("content")
    private String content;

    /**
     * Vector embedding for similarity search.
     * This field is used by MongoDB Atlas Vector Search.
     * Dimension should match the embedding model (e.g., 1536 for OpenAI ada-002)
     */
    @Field("embedding")
    private List<Double> embedding;

    @Field("metadata")
    private Map<String, Object> metadata;

    @Field("indexed_at")
    private LocalDateTime indexedAt;

    @Field("updated_at")
    private LocalDateTime updatedAt;

    @Field("active")
    @Indexed
    @Builder.Default
    private boolean active = true;

    /**
     * Create a document for an NFL player
     */
    public static VectorIndexDocument forNFLPlayer(
            String playerId,
            String content,
            List<Double> embedding,
            Map<String, Object> metadata) {
        return VectorIndexDocument.builder()
                .sourceId(playerId)
                .documentType("nfl_player")
                .content(content)
                .embedding(embedding)
                .metadata(metadata)
                .indexedAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .active(true)
                .build();
    }

    /**
     * Create a document for a league
     */
    public static VectorIndexDocument forLeague(
            String leagueId,
            String content,
            List<Double> embedding,
            Map<String, Object> metadata) {
        return VectorIndexDocument.builder()
                .sourceId(leagueId)
                .documentType("league")
                .content(content)
                .embedding(embedding)
                .metadata(metadata)
                .indexedAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .active(true)
                .build();
    }
}
