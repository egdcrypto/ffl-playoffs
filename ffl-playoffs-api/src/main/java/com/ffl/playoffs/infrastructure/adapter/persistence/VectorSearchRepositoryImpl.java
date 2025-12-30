package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.VectorIndex;
import com.ffl.playoffs.domain.model.vectorsearch.DocumentType;
import com.ffl.playoffs.domain.model.vectorsearch.VectorSearchQuery;
import com.ffl.playoffs.domain.model.vectorsearch.VectorSearchResult;
import com.ffl.playoffs.domain.port.VectorSearchRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.VectorIndexMapper;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.VectorIndexDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoVectorIndexRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.bson.Document;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.Aggregation;
import org.springframework.data.mongodb.core.aggregation.AggregationOperation;
import org.springframework.data.mongodb.core.aggregation.AggregationResults;
import org.springframework.stereotype.Repository;

import java.util.*;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of VectorSearchRepository.
 * Uses MongoDB Atlas Vector Search for similarity queries.
 */
@Slf4j
@Repository
@RequiredArgsConstructor
public class VectorSearchRepositoryImpl implements VectorSearchRepository {

    private final MongoVectorIndexRepository mongoRepository;
    private final MongoTemplate mongoTemplate;

    private static final String VECTOR_SEARCH_INDEX = "vector_index";
    private static final String COLLECTION_NAME = "vector_indices";

    @Override
    public VectorIndex save(VectorIndex vectorIndex) {
        log.debug("Saving vector index for source: {} type: {}",
                vectorIndex.getSourceId(), vectorIndex.getDocumentType());

        VectorIndexDocument document = VectorIndexMapper.toDocument(vectorIndex);
        VectorIndexDocument saved = mongoRepository.save(document);
        return VectorIndexMapper.toDomain(saved);
    }

    @Override
    public List<VectorIndex> saveAll(List<VectorIndex> vectorIndices) {
        log.debug("Saving {} vector indices", vectorIndices.size());

        List<VectorIndexDocument> documents = VectorIndexMapper.toDocuments(vectorIndices);
        List<VectorIndexDocument> saved = mongoRepository.saveAll(documents);
        return VectorIndexMapper.toDomains(saved);
    }

    @Override
    public Optional<VectorIndex> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(VectorIndexMapper::toDomain);
    }

    @Override
    public Optional<VectorIndex> findBySourceIdAndType(String sourceId, DocumentType documentType) {
        return mongoRepository.findBySourceIdAndDocumentType(sourceId, documentType.getCode())
                .map(VectorIndexMapper::toDomain);
    }

    @Override
    public List<VectorIndex> findByDocumentType(DocumentType documentType) {
        List<VectorIndexDocument> documents = mongoRepository.findByDocumentType(documentType.getCode());
        return VectorIndexMapper.toDomains(documents);
    }

    @Override
    public List<VectorIndex> findPendingEmbedding() {
        List<VectorIndexDocument> documents = mongoRepository.findByActiveIsTrueAndEmbeddingIsNull();
        return VectorIndexMapper.toDomains(documents);
    }

    @Override
    public List<VectorSearchResult> search(VectorSearchQuery query) {
        log.debug("Executing text search: {}", query.getQueryText());

        // For text-based search without vector, fall back to text search
        if (!query.hasQueryVector()) {
            return performTextSearch(query);
        }

        return searchByVector(query);
    }

    @Override
    public List<VectorSearchResult> searchByVector(VectorSearchQuery query) {
        log.debug("Executing vector search with {} dimensions",
                query.getQueryVector() != null ? query.getQueryVector().getDimensions() : 0);

        if (query.getQueryVector() == null) {
            return List.of();
        }

        try {
            // Build MongoDB Atlas Vector Search aggregation
            List<AggregationOperation> operations = new ArrayList<>();

            // Vector search stage
            Document vectorSearchStage = buildVectorSearchStage(query);
            operations.add(context -> vectorSearchStage);

            // Add filters if present
            if (query.hasFilters() || query.getDocumentType() != null) {
                Document matchStage = buildMatchStage(query);
                operations.add(context -> matchStage);
            }

            // Limit results
            operations.add(Aggregation.limit(query.getLimit()));

            // Project score and fields
            operations.add(context -> new Document("$project", new Document()
                    .append("_id", 1)
                    .append("source_id", 1)
                    .append("document_type", 1)
                    .append("content", 1)
                    .append("metadata", 1)
                    .append("score", new Document("$meta", "vectorSearchScore"))
            ));

            Aggregation aggregation = Aggregation.newAggregation(operations);
            AggregationResults<Document> results = mongoTemplate.aggregate(
                    aggregation,
                    COLLECTION_NAME,
                    Document.class
            );

            return results.getMappedResults().stream()
                    .map(this::documentToSearchResult)
                    .filter(result -> result.getScore() >= query.getMinScore())
                    .collect(Collectors.toList());

        } catch (Exception e) {
            log.warn("Vector search failed, falling back to text search: {}", e.getMessage());
            return performTextSearch(query);
        }
    }

    @Override
    public void deleteById(UUID id) {
        log.debug("Deleting vector index: {}", id);
        mongoRepository.deleteById(id.toString());
    }

    @Override
    public void deleteBySourceIdAndType(String sourceId, DocumentType documentType) {
        log.debug("Deleting vector index for source: {} type: {}", sourceId, documentType);
        mongoRepository.deleteBySourceIdAndDocumentType(sourceId, documentType.getCode());
    }

    @Override
    public boolean existsBySourceIdAndType(String sourceId, DocumentType documentType) {
        return mongoRepository.existsBySourceIdAndDocumentType(sourceId, documentType.getCode());
    }

    @Override
    public long countByDocumentType(DocumentType documentType) {
        return mongoRepository.countByDocumentType(documentType.getCode());
    }

    @Override
    public long countActive() {
        return mongoRepository.countByActiveIsTrue();
    }

    /**
     * Build the $vectorSearch stage for MongoDB Atlas
     */
    private Document buildVectorSearchStage(VectorSearchQuery query) {
        float[] vector = query.getQueryVector().getVector();
        List<Double> vectorList = new ArrayList<>(vector.length);
        for (float v : vector) {
            vectorList.add((double) v);
        }

        Document vectorSearch = new Document()
                .append("index", VECTOR_SEARCH_INDEX)
                .append("path", "embedding")
                .append("queryVector", vectorList)
                .append("numCandidates", query.getLimit() * 10)
                .append("limit", query.getLimit());

        // Add filter for document type if specified
        if (query.getDocumentType() != null) {
            Document filter = new Document("document_type", query.getDocumentType().getCode());
            if (query.hasFilters()) {
                query.getFilters().forEach(filter::append);
            }
            vectorSearch.append("filter", filter);
        }

        return new Document("$vectorSearch", vectorSearch);
    }

    /**
     * Build match stage for additional filtering
     */
    private Document buildMatchStage(VectorSearchQuery query) {
        Document match = new Document();

        if (query.getDocumentType() != null) {
            match.append("document_type", query.getDocumentType().getCode());
        }

        match.append("active", true);

        if (query.hasFilters()) {
            query.getFilters().forEach((key, value) ->
                    match.append("metadata." + key, value)
            );
        }

        return new Document("$match", match);
    }

    /**
     * Convert MongoDB document to VectorSearchResult
     */
    private VectorSearchResult documentToSearchResult(Document doc) {
        String documentType = doc.getString("document_type");
        Double score = doc.getDouble("score");

        @SuppressWarnings("unchecked")
        Map<String, Object> metadata = (Map<String, Object>) doc.get("metadata");

        return VectorSearchResult.builder()
                .documentId(doc.getString("source_id"))
                .documentType(DocumentType.fromCode(documentType))
                .score(score != null ? score : 0.0)
                .content(doc.getString("content"))
                .metadata(metadata != null ? metadata : Map.of())
                .build();
    }

    /**
     * Fallback text search when vector search is not available
     */
    private List<VectorSearchResult> performTextSearch(VectorSearchQuery query) {
        log.debug("Performing fallback text search for: {}", query.getQueryText());

        // Simple text matching fallback
        List<VectorIndexDocument> documents;
        if (query.getDocumentType() != null) {
            documents = mongoRepository.findByDocumentTypeAndActiveIsTrue(query.getDocumentType().getCode());
        } else {
            documents = mongoRepository.findByActiveIsTrue();
        }

        String searchText = query.getQueryText() != null ? query.getQueryText().toLowerCase() : "";

        return documents.stream()
                .filter(doc -> doc.getContent() != null &&
                        doc.getContent().toLowerCase().contains(searchText))
                .limit(query.getLimit())
                .map(doc -> VectorSearchResult.builder()
                        .documentId(doc.getSourceId())
                        .documentType(DocumentType.fromCode(doc.getDocumentType()))
                        .score(0.5) // Default score for text match
                        .content(doc.getContent())
                        .metadata(doc.getMetadata() != null ? doc.getMetadata() : Map.of())
                        .build())
                .collect(Collectors.toList());
    }
}
