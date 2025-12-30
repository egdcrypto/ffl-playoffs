package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.VectorIndex;
import com.ffl.playoffs.domain.model.vectorsearch.DocumentType;
import com.ffl.playoffs.domain.model.vectorsearch.VectorEmbedding;
import com.ffl.playoffs.domain.model.vectorsearch.VectorSearchQuery;
import com.ffl.playoffs.domain.model.vectorsearch.VectorSearchResult;
import com.ffl.playoffs.domain.port.VectorSearchRepository;
import com.ffl.playoffs.domain.service.EmbeddingService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("VectorSearchUseCase Tests")
class VectorSearchUseCaseTest {

    @Mock
    private VectorSearchRepository vectorSearchRepository;

    @Mock
    private EmbeddingService embeddingService;

    private VectorSearchUseCase useCase;

    @BeforeEach
    void setUp() {
        useCase = new VectorSearchUseCase(vectorSearchRepository, embeddingService);
    }

    @Test
    @DisplayName("should execute text search successfully")
    void shouldExecuteTextSearchSuccessfully() {
        // Given
        String queryText = "Patrick Mahomes quarterback";
        VectorEmbedding queryEmbedding = VectorEmbedding.of(new float[]{0.1f, 0.2f, 0.3f});

        VectorSearchResult expectedResult = VectorSearchResult.builder()
                .documentId("player-123")
                .documentType(DocumentType.NFL_PLAYER)
                .score(0.95)
                .content("Patrick Mahomes - QB for Kansas City Chiefs")
                .build();

        when(embeddingService.embed(queryText)).thenReturn(queryEmbedding);
        when(vectorSearchRepository.searchByVector(any(VectorSearchQuery.class)))
                .thenReturn(List.of(expectedResult));

        // When
        VectorSearchUseCase.SearchCommand command = new VectorSearchUseCase.SearchCommand(queryText);
        VectorSearchUseCase.SearchResponse response = useCase.execute(command);

        // Then
        assertThat(response.hasResults()).isTrue();
        assertThat(response.getTotalResults()).isEqualTo(1);
        assertThat(response.getTopResult().getDocumentId()).isEqualTo("player-123");

        verify(embeddingService).embed(queryText);
        verify(vectorSearchRepository).searchByVector(any(VectorSearchQuery.class));
    }

    @Test
    @DisplayName("should search NFL players")
    void shouldSearchNFLPlayers() {
        // Given
        VectorEmbedding queryEmbedding = VectorEmbedding.of(new float[]{0.1f, 0.2f, 0.3f});
        when(embeddingService.embed(anyString())).thenReturn(queryEmbedding);
        when(vectorSearchRepository.searchByVector(any(VectorSearchQuery.class)))
                .thenReturn(List.of(
                        VectorSearchResult.builder()
                                .documentId("1")
                                .documentType(DocumentType.NFL_PLAYER)
                                .score(0.9)
                                .build()
                ));

        // When
        VectorSearchUseCase.SearchResponse response = useCase.searchNFLPlayers("quarterback", 5);

        // Then
        assertThat(response.hasResults()).isTrue();
        verify(embeddingService).embed("quarterback");
    }

    @Test
    @DisplayName("should search leagues")
    void shouldSearchLeagues() {
        // Given
        VectorEmbedding queryEmbedding = VectorEmbedding.of(new float[]{0.1f, 0.2f, 0.3f});
        when(embeddingService.embed(anyString())).thenReturn(queryEmbedding);
        when(vectorSearchRepository.searchByVector(any(VectorSearchQuery.class)))
                .thenReturn(List.of(
                        VectorSearchResult.builder()
                                .documentId("league-1")
                                .documentType(DocumentType.LEAGUE)
                                .score(0.85)
                                .build()
                ));

        // When
        VectorSearchUseCase.SearchResponse response = useCase.searchLeagues("competitive fantasy", 10);

        // Then
        assertThat(response.hasResults()).isTrue();
    }

    @Test
    @DisplayName("should find similar items")
    void shouldFindSimilarItems() {
        // Given
        String sourceId = "player-123";
        VectorIndex sourceIndex = new VectorIndex(sourceId, DocumentType.NFL_PLAYER, "Patrick Mahomes");
        sourceIndex.updateEmbedding(VectorEmbedding.of(new float[]{0.1f, 0.2f, 0.3f}));

        when(vectorSearchRepository.findBySourceIdAndType(sourceId, DocumentType.NFL_PLAYER))
                .thenReturn(Optional.of(sourceIndex));
        when(vectorSearchRepository.searchByVector(any(VectorSearchQuery.class)))
                .thenReturn(List.of(
                        VectorSearchResult.builder()
                                .documentId("player-123")
                                .documentType(DocumentType.NFL_PLAYER)
                                .score(1.0)
                                .build(),
                        VectorSearchResult.builder()
                                .documentId("player-456")
                                .documentType(DocumentType.NFL_PLAYER)
                                .score(0.85)
                                .build()
                ));

        // When
        VectorSearchUseCase.SearchResponse response = useCase.findSimilar(sourceId, DocumentType.NFL_PLAYER, 5);

        // Then
        assertThat(response.hasResults()).isTrue();
        // Should exclude the source document
        assertThat(response.getResults()).noneMatch(r -> r.getDocumentId().equals(sourceId));
    }

    @Test
    @DisplayName("should return empty results when source document not found")
    void shouldReturnEmptyResultsWhenSourceDocumentNotFound() {
        // Given
        when(vectorSearchRepository.findBySourceIdAndType(anyString(), any(DocumentType.class)))
                .thenReturn(Optional.empty());

        // When
        VectorSearchUseCase.SearchResponse response = useCase.findSimilar("non-existent", DocumentType.NFL_PLAYER, 5);

        // Then
        assertThat(response.hasResults()).isFalse();
    }

    @Test
    @DisplayName("should apply filters to search")
    void shouldApplyFiltersToSearch() {
        // Given
        VectorEmbedding queryEmbedding = VectorEmbedding.of(new float[]{0.1f, 0.2f, 0.3f});
        when(embeddingService.embed(anyString())).thenReturn(queryEmbedding);
        when(vectorSearchRepository.searchByVector(any(VectorSearchQuery.class)))
                .thenReturn(List.of());

        // When
        VectorSearchUseCase.SearchCommand command = new VectorSearchUseCase.SearchCommand("quarterback");
        command.setDocumentType(DocumentType.NFL_PLAYER);
        command.setFilters(java.util.Map.of("team", "KC"));
        command.setMinScore(0.7);

        useCase.execute(command);

        // Then
        verify(vectorSearchRepository).searchByVector(argThat(query ->
                query.getDocumentType() == DocumentType.NFL_PLAYER &&
                        query.getMinScore() == 0.7 &&
                        query.getFilters().containsKey("team")
        ));
    }
}
