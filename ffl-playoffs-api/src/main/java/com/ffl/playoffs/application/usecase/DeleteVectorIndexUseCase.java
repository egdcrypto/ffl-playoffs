package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.vectorsearch.DocumentType;
import com.ffl.playoffs.domain.port.VectorSearchRepository;

import java.util.Objects;
import java.util.UUID;

/**
 * Use case for deleting vector index entries.
 * Supports deletion by ID or by source document reference.
 */
public class DeleteVectorIndexUseCase {

    private final VectorSearchRepository vectorSearchRepository;

    public DeleteVectorIndexUseCase(VectorSearchRepository vectorSearchRepository) {
        this.vectorSearchRepository = vectorSearchRepository;
    }

    /**
     * Delete a vector index by its ID
     */
    public void executeById(UUID indexId) {
        Objects.requireNonNull(indexId, "indexId cannot be null");
        vectorSearchRepository.deleteById(indexId);
    }

    /**
     * Delete a vector index by source document reference
     */
    public void executeBySource(DeleteBySourceCommand command) {
        Objects.requireNonNull(command, "command cannot be null");
        vectorSearchRepository.deleteBySourceIdAndType(
                command.getSourceId(),
                command.getDocumentType()
        );
    }

    /**
     * Deactivate (soft delete) a vector index
     */
    public void deactivate(UUID indexId) {
        Objects.requireNonNull(indexId, "indexId cannot be null");
        vectorSearchRepository.findById(indexId)
                .ifPresent(index -> {
                    index.deactivate();
                    vectorSearchRepository.save(index);
                });
    }

    /**
     * Deactivate a vector index by source document reference
     */
    public void deactivateBySource(String sourceId, DocumentType documentType) {
        Objects.requireNonNull(sourceId, "sourceId cannot be null");
        Objects.requireNonNull(documentType, "documentType cannot be null");
        vectorSearchRepository.findBySourceIdAndType(sourceId, documentType)
                .ifPresent(index -> {
                    index.deactivate();
                    vectorSearchRepository.save(index);
                });
    }

    /**
     * Command object for deleting by source
     */
    public static class DeleteBySourceCommand {
        private final String sourceId;
        private final DocumentType documentType;

        public DeleteBySourceCommand(String sourceId, DocumentType documentType) {
            this.sourceId = Objects.requireNonNull(sourceId, "sourceId cannot be null");
            this.documentType = Objects.requireNonNull(documentType, "documentType cannot be null");
        }

        public String getSourceId() {
            return sourceId;
        }

        public DocumentType getDocumentType() {
            return documentType;
        }
    }
}
