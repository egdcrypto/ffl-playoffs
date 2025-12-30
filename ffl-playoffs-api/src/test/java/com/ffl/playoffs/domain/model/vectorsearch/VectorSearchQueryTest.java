package com.ffl.playoffs.domain.model.vectorsearch;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.Map;

import static org.assertj.core.api.Assertions.*;

@DisplayName("VectorSearchQuery Value Object Tests")
class VectorSearchQueryTest {

    @Test
    @DisplayName("should build query with text")
    void shouldBuildQueryWithText() {
        VectorSearchQuery query = VectorSearchQuery.builder()
                .queryText("Patrick Mahomes")
                .build();

        assertThat(query.getQueryText()).isEqualTo("Patrick Mahomes");
        assertThat(query.hasQueryVector()).isFalse();
    }

    @Test
    @DisplayName("should build query with vector")
    void shouldBuildQueryWithVector() {
        VectorEmbedding embedding = VectorEmbedding.of(new float[]{0.1f, 0.2f, 0.3f});

        VectorSearchQuery query = VectorSearchQuery.builder()
                .queryVector(embedding)
                .build();

        assertThat(query.hasQueryVector()).isTrue();
        assertThat(query.getQueryVector()).isEqualTo(embedding);
    }

    @Test
    @DisplayName("should build query with document type filter")
    void shouldBuildQueryWithDocumentTypeFilter() {
        VectorSearchQuery query = VectorSearchQuery.builder()
                .queryText("quarterback")
                .documentType(DocumentType.NFL_PLAYER)
                .build();

        assertThat(query.getDocumentType()).isEqualTo(DocumentType.NFL_PLAYER);
    }

    @Test
    @DisplayName("should build query with limit")
    void shouldBuildQueryWithLimit() {
        VectorSearchQuery query = VectorSearchQuery.builder()
                .queryText("running back")
                .limit(20)
                .build();

        assertThat(query.getLimit()).isEqualTo(20);
    }

    @Test
    @DisplayName("should build query with min score")
    void shouldBuildQueryWithMinScore() {
        VectorSearchQuery query = VectorSearchQuery.builder()
                .queryText("wide receiver")
                .minScore(0.7)
                .build();

        assertThat(query.getMinScore()).isEqualTo(0.7);
    }

    @Test
    @DisplayName("should build query with filters")
    void shouldBuildQueryWithFilters() {
        VectorSearchQuery query = VectorSearchQuery.builder()
                .queryText("Kansas City")
                .filter("team", "KC")
                .filter("position", "QB")
                .build();

        assertThat(query.hasFilters()).isTrue();
        assertThat(query.getFilters()).containsEntry("team", "KC");
        assertThat(query.getFilters()).containsEntry("position", "QB");
    }

    @Test
    @DisplayName("should use default limit of 10")
    void shouldUseDefaultLimitOf10() {
        VectorSearchQuery query = VectorSearchQuery.builder()
                .queryText("test")
                .build();

        assertThat(query.getLimit()).isEqualTo(10);
    }

    @Test
    @DisplayName("should throw exception for invalid limit")
    void shouldThrowExceptionForInvalidLimit() {
        assertThatThrownBy(() -> VectorSearchQuery.builder()
                .queryText("test")
                .limit(0)
                .build())
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("positive");
    }

    @Test
    @DisplayName("should throw exception for invalid min score")
    void shouldThrowExceptionForInvalidMinScore() {
        assertThatThrownBy(() -> VectorSearchQuery.builder()
                .queryText("test")
                .minScore(1.5)
                .build())
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("between 0 and 1");
    }

    @Test
    @DisplayName("should throw exception when neither text nor vector provided")
    void shouldThrowExceptionWhenNeitherTextNorVectorProvided() {
        assertThatThrownBy(() -> VectorSearchQuery.builder()
                .limit(10)
                .build())
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("queryText or queryVector must be provided");
    }

    @Test
    @DisplayName("should return unmodifiable filters map")
    void shouldReturnUnmodifiableFiltersMap() {
        VectorSearchQuery query = VectorSearchQuery.builder()
                .queryText("test")
                .filter("key", "value")
                .build();

        Map<String, Object> filters = query.getFilters();

        assertThatThrownBy(() -> filters.put("newKey", "newValue"))
                .isInstanceOf(UnsupportedOperationException.class);
    }
}
