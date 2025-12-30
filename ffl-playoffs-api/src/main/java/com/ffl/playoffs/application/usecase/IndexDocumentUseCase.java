package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.VectorIndex;
import com.ffl.playoffs.domain.model.vectorsearch.DocumentType;
import com.ffl.playoffs.domain.model.vectorsearch.VectorEmbedding;
import com.ffl.playoffs.domain.port.VectorSearchRepository;
import com.ffl.playoffs.domain.service.EmbeddingService;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Use case for indexing documents for vector search.
 * Creates or updates vector indices with embeddings.
 */
public class IndexDocumentUseCase {

    private final VectorSearchRepository vectorSearchRepository;
    private final EmbeddingService embeddingService;

    public IndexDocumentUseCase(
            VectorSearchRepository vectorSearchRepository,
            EmbeddingService embeddingService) {
        this.vectorSearchRepository = vectorSearchRepository;
        this.embeddingService = embeddingService;
    }

    /**
     * Index a single document
     */
    public VectorIndex execute(IndexDocumentCommand command) {
        Objects.requireNonNull(command, "command cannot be null");

        // Check if document already indexed
        VectorIndex vectorIndex = vectorSearchRepository
                .findBySourceIdAndType(command.getSourceId(), command.getDocumentType())
                .orElseGet(() -> new VectorIndex(
                        command.getSourceId(),
                        command.getDocumentType(),
                        command.getContent()
                ));

        // Update content if changed
        if (!command.getContent().equals(vectorIndex.getContent())) {
            vectorIndex.updateContent(command.getContent());
        }

        // Add metadata
        if (command.getMetadata() != null) {
            command.getMetadata().forEach(vectorIndex::addMetadata);
        }

        // Generate embedding
        VectorEmbedding embedding = embeddingService.embed(command.getContent());
        vectorIndex.updateEmbedding(embedding);

        // Save and return
        return vectorSearchRepository.save(vectorIndex);
    }

    /**
     * Index multiple documents in batch
     */
    public List<VectorIndex> executeBatch(List<IndexDocumentCommand> commands) {
        if (commands == null || commands.isEmpty()) {
            return List.of();
        }

        // Extract contents for batch embedding
        List<String> contents = commands.stream()
                .map(IndexDocumentCommand::getContent)
                .collect(Collectors.toList());

        // Generate embeddings in batch
        List<VectorEmbedding> embeddings = embeddingService.embedBatch(contents);

        // Create/update indices with embeddings
        List<VectorIndex> indices = new java.util.ArrayList<>();
        for (int i = 0; i < commands.size(); i++) {
            IndexDocumentCommand command = commands.get(i);
            VectorEmbedding embedding = embeddings.get(i);

            VectorIndex vectorIndex = vectorSearchRepository
                    .findBySourceIdAndType(command.getSourceId(), command.getDocumentType())
                    .orElseGet(() -> new VectorIndex(
                            command.getSourceId(),
                            command.getDocumentType(),
                            command.getContent()
                    ));

            if (!command.getContent().equals(vectorIndex.getContent())) {
                vectorIndex.updateContent(command.getContent());
            }

            if (command.getMetadata() != null) {
                command.getMetadata().forEach(vectorIndex::addMetadata);
            }

            vectorIndex.updateEmbedding(embedding);
            indices.add(vectorIndex);
        }

        return vectorSearchRepository.saveAll(indices);
    }

    /**
     * Process pending embeddings for documents that need re-indexing
     */
    public int processPendingEmbeddings(int batchSize) {
        List<VectorIndex> pending = vectorSearchRepository.findPendingEmbedding();
        if (pending.isEmpty()) {
            return 0;
        }

        // Process in batches
        int processed = 0;
        for (int i = 0; i < pending.size(); i += batchSize) {
            List<VectorIndex> batch = pending.subList(
                    i,
                    Math.min(i + batchSize, pending.size())
            );

            List<String> contents = batch.stream()
                    .map(VectorIndex::getContent)
                    .collect(Collectors.toList());

            List<VectorEmbedding> embeddings = embeddingService.embedBatch(contents);

            for (int j = 0; j < batch.size(); j++) {
                batch.get(j).updateEmbedding(embeddings.get(j));
            }

            vectorSearchRepository.saveAll(batch);
            processed += batch.size();
        }

        return processed;
    }

    /**
     * Command object for indexing a document
     */
    public static class IndexDocumentCommand {
        private final String sourceId;
        private final DocumentType documentType;
        private final String content;
        private Map<String, Object> metadata;

        public IndexDocumentCommand(String sourceId, DocumentType documentType, String content) {
            this.sourceId = Objects.requireNonNull(sourceId, "sourceId cannot be null");
            this.documentType = Objects.requireNonNull(documentType, "documentType cannot be null");
            this.content = Objects.requireNonNull(content, "content cannot be null");
        }

        public static IndexDocumentCommand forNFLPlayer(
                Long playerId,
                String playerName,
                String position,
                String team) {
            String content = String.format("%s - %s for %s", playerName, position, team);
            IndexDocumentCommand command = new IndexDocumentCommand(
                    playerId.toString(),
                    DocumentType.NFL_PLAYER,
                    content
            );
            command.setMetadata(Map.of(
                    "playerName", playerName,
                    "position", position,
                    "team", team
            ));
            return command;
        }

        public static IndexDocumentCommand forLeague(UUID leagueId, String leagueName, String description) {
            String content = String.format("%s: %s", leagueName, description != null ? description : "");
            IndexDocumentCommand command = new IndexDocumentCommand(
                    leagueId.toString(),
                    DocumentType.LEAGUE,
                    content
            );
            command.setMetadata(Map.of("leagueName", leagueName));
            return command;
        }

        public String getSourceId() {
            return sourceId;
        }

        public DocumentType getDocumentType() {
            return documentType;
        }

        public String getContent() {
            return content;
        }

        public Map<String, Object> getMetadata() {
            return metadata;
        }

        public void setMetadata(Map<String, Object> metadata) {
            this.metadata = metadata;
        }
    }
}
