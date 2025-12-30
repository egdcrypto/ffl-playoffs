package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.aggregate.VectorIndex;
import com.ffl.playoffs.domain.model.vectorsearch.DocumentType;
import com.ffl.playoffs.domain.model.vectorsearch.VectorEmbedding;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.VectorIndexDocument;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Mapper for converting between VectorIndex domain aggregate and VectorIndexDocument.
 */
public final class VectorIndexMapper {

    private VectorIndexMapper() {
        // Utility class
    }

    /**
     * Convert domain aggregate to MongoDB document
     */
    public static VectorIndexDocument toDocument(VectorIndex vectorIndex) {
        if (vectorIndex == null) {
            return null;
        }

        VectorIndexDocument document = VectorIndexDocument.builder()
                .id(vectorIndex.getId() != null ? vectorIndex.getId().toString() : null)
                .sourceId(vectorIndex.getSourceId())
                .documentType(vectorIndex.getDocumentType().getCode())
                .content(vectorIndex.getContent())
                .metadata(new HashMap<>(vectorIndex.getMetadata()))
                .indexedAt(vectorIndex.getIndexedAt())
                .updatedAt(vectorIndex.getUpdatedAt())
                .active(vectorIndex.isActive())
                .build();

        // Convert embedding if present
        if (vectorIndex.getEmbedding() != null) {
            float[] floatVector = vectorIndex.getEmbedding().getVector();
            List<Double> embedding = new ArrayList<>(floatVector.length);
            for (float v : floatVector) {
                embedding.add((double) v);
            }
            document.setEmbedding(embedding);
        }

        return document;
    }

    /**
     * Convert MongoDB document to domain aggregate
     */
    public static VectorIndex toDomain(VectorIndexDocument document) {
        if (document == null) {
            return null;
        }

        VectorIndex vectorIndex = new VectorIndex();

        if (document.getId() != null) {
            vectorIndex.setId(UUID.fromString(document.getId()));
        }
        vectorIndex.setSourceId(document.getSourceId());
        vectorIndex.setDocumentType(DocumentType.fromCode(document.getDocumentType()));
        vectorIndex.setContent(document.getContent());

        if (document.getMetadata() != null) {
            vectorIndex.setMetadata(new HashMap<>(document.getMetadata()));
        }

        vectorIndex.setIndexedAt(document.getIndexedAt());
        vectorIndex.setUpdatedAt(document.getUpdatedAt());
        vectorIndex.setActive(document.isActive());

        // Convert embedding if present
        if (document.getEmbedding() != null && !document.getEmbedding().isEmpty()) {
            double[] doubles = document.getEmbedding().stream()
                    .mapToDouble(Double::doubleValue)
                    .toArray();
            vectorIndex.setEmbedding(VectorEmbedding.of(doubles));
        }

        return vectorIndex;
    }

    /**
     * Convert list of domain aggregates to documents
     */
    public static List<VectorIndexDocument> toDocuments(List<VectorIndex> vectorIndices) {
        if (vectorIndices == null) {
            return List.of();
        }
        return vectorIndices.stream()
                .map(VectorIndexMapper::toDocument)
                .collect(Collectors.toList());
    }

    /**
     * Convert list of documents to domain aggregates
     */
    public static List<VectorIndex> toDomains(List<VectorIndexDocument> documents) {
        if (documents == null) {
            return List.of();
        }
        return documents.stream()
                .map(VectorIndexMapper::toDomain)
                .collect(Collectors.toList());
    }
}
