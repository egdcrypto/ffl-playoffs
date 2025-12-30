package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.VectorIndex;
import com.ffl.playoffs.domain.model.vectorsearch.DocumentType;
import com.ffl.playoffs.domain.model.vectorsearch.VectorEmbedding;
import com.ffl.playoffs.domain.port.VectorSearchRepository;
import com.ffl.playoffs.domain.service.EmbeddingService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("IndexDocumentUseCase Tests")
class IndexDocumentUseCaseTest {

    @Mock
    private VectorSearchRepository vectorSearchRepository;

    @Mock
    private EmbeddingService embeddingService;

    @Captor
    private ArgumentCaptor<VectorIndex> indexCaptor;

    private IndexDocumentUseCase useCase;

    @BeforeEach
    void setUp() {
        useCase = new IndexDocumentUseCase(vectorSearchRepository, embeddingService);
    }

    @Test
    @DisplayName("should index new document successfully")
    void shouldIndexNewDocumentSuccessfully() {
        // Given
        String sourceId = "player-123";
        String content = "Patrick Mahomes - QB for Kansas City Chiefs";
        VectorEmbedding embedding = VectorEmbedding.of(new float[]{0.1f, 0.2f, 0.3f});

        when(vectorSearchRepository.findBySourceIdAndType(sourceId, DocumentType.NFL_PLAYER))
                .thenReturn(Optional.empty());
        when(embeddingService.embed(content)).thenReturn(embedding);
        when(vectorSearchRepository.save(any(VectorIndex.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        // When
        IndexDocumentUseCase.IndexDocumentCommand command =
                new IndexDocumentUseCase.IndexDocumentCommand(sourceId, DocumentType.NFL_PLAYER, content);
        VectorIndex result = useCase.execute(command);

        // Then
        assertThat(result.getSourceId()).isEqualTo(sourceId);
        assertThat(result.getContent()).isEqualTo(content);
        assertThat(result.getEmbedding()).isEqualTo(embedding);

        verify(embeddingService).embed(content);
        verify(vectorSearchRepository).save(any(VectorIndex.class));
    }

    @Test
    @DisplayName("should update existing document")
    void shouldUpdateExistingDocument() {
        // Given
        String sourceId = "player-123";
        String oldContent = "Old content";
        String newContent = "New updated content";

        VectorIndex existingIndex = new VectorIndex(sourceId, DocumentType.NFL_PLAYER, oldContent);
        VectorEmbedding embedding = VectorEmbedding.of(new float[]{0.1f, 0.2f, 0.3f});

        when(vectorSearchRepository.findBySourceIdAndType(sourceId, DocumentType.NFL_PLAYER))
                .thenReturn(Optional.of(existingIndex));
        when(embeddingService.embed(newContent)).thenReturn(embedding);
        when(vectorSearchRepository.save(any(VectorIndex.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        // When
        IndexDocumentUseCase.IndexDocumentCommand command =
                new IndexDocumentUseCase.IndexDocumentCommand(sourceId, DocumentType.NFL_PLAYER, newContent);
        VectorIndex result = useCase.execute(command);

        // Then
        assertThat(result.getContent()).isEqualTo(newContent);
        verify(embeddingService).embed(newContent);
    }

    @Test
    @DisplayName("should index document with metadata")
    void shouldIndexDocumentWithMetadata() {
        // Given
        VectorEmbedding embedding = VectorEmbedding.of(new float[]{0.1f, 0.2f, 0.3f});
        when(vectorSearchRepository.findBySourceIdAndType(anyString(), any()))
                .thenReturn(Optional.empty());
        when(embeddingService.embed(anyString())).thenReturn(embedding);
        when(vectorSearchRepository.save(any(VectorIndex.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        // When
        IndexDocumentUseCase.IndexDocumentCommand command =
                IndexDocumentUseCase.IndexDocumentCommand.forNFLPlayer(
                        123L, "Patrick Mahomes", "QB", "Kansas City Chiefs"
                );
        VectorIndex result = useCase.execute(command);

        // Then
        assertThat(result.getMetadata()).containsEntry("playerName", "Patrick Mahomes");
        assertThat(result.getMetadata()).containsEntry("position", "QB");
        assertThat(result.getMetadata()).containsEntry("team", "Kansas City Chiefs");
    }

    @Test
    @DisplayName("should index batch of documents")
    void shouldIndexBatchOfDocuments() {
        // Given
        List<VectorEmbedding> embeddings = List.of(
                VectorEmbedding.of(new float[]{0.1f, 0.2f}),
                VectorEmbedding.of(new float[]{0.3f, 0.4f}),
                VectorEmbedding.of(new float[]{0.5f, 0.6f})
        );

        when(vectorSearchRepository.findBySourceIdAndType(anyString(), any()))
                .thenReturn(Optional.empty());
        when(embeddingService.embedBatch(anyList())).thenReturn(embeddings);
        when(vectorSearchRepository.saveAll(anyList()))
                .thenAnswer(invocation -> invocation.getArgument(0));

        // When
        List<IndexDocumentUseCase.IndexDocumentCommand> commands = List.of(
                new IndexDocumentUseCase.IndexDocumentCommand("1", DocumentType.NFL_PLAYER, "Player 1"),
                new IndexDocumentUseCase.IndexDocumentCommand("2", DocumentType.NFL_PLAYER, "Player 2"),
                new IndexDocumentUseCase.IndexDocumentCommand("3", DocumentType.NFL_PLAYER, "Player 3")
        );
        List<VectorIndex> results = useCase.executeBatch(commands);

        // Then
        assertThat(results).hasSize(3);
        verify(embeddingService).embedBatch(anyList());
        verify(vectorSearchRepository).saveAll(anyList());
    }

    @Test
    @DisplayName("should process pending embeddings")
    void shouldProcessPendingEmbeddings() {
        // Given
        VectorIndex pending1 = new VectorIndex("1", DocumentType.NFL_PLAYER, "Content 1");
        VectorIndex pending2 = new VectorIndex("2", DocumentType.NFL_PLAYER, "Content 2");

        when(vectorSearchRepository.findPendingEmbedding())
                .thenReturn(List.of(pending1, pending2));
        when(embeddingService.embedBatch(anyList()))
                .thenReturn(List.of(
                        VectorEmbedding.of(new float[]{0.1f, 0.2f}),
                        VectorEmbedding.of(new float[]{0.3f, 0.4f})
                ));
        when(vectorSearchRepository.saveAll(anyList()))
                .thenAnswer(invocation -> invocation.getArgument(0));

        // When
        int processed = useCase.processPendingEmbeddings(10);

        // Then
        assertThat(processed).isEqualTo(2);
        verify(vectorSearchRepository).findPendingEmbedding();
        verify(embeddingService).embedBatch(anyList());
        verify(vectorSearchRepository).saveAll(anyList());
    }

    @Test
    @DisplayName("should return zero when no pending embeddings")
    void shouldReturnZeroWhenNoPendingEmbeddings() {
        // Given
        when(vectorSearchRepository.findPendingEmbedding()).thenReturn(List.of());

        // When
        int processed = useCase.processPendingEmbeddings(10);

        // Then
        assertThat(processed).isZero();
        verify(embeddingService, never()).embedBatch(anyList());
    }

    @Test
    @DisplayName("should return empty list for null or empty batch")
    void shouldReturnEmptyListForNullOrEmptyBatch() {
        assertThat(useCase.executeBatch(null)).isEmpty();
        assertThat(useCase.executeBatch(List.of())).isEmpty();
    }
}
