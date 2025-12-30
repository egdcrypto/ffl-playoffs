package com.ffl.playoffs.domain.model.vectorsearch;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.Map;

import static org.assertj.core.api.Assertions.*;

@DisplayName("VectorSearchResult Value Object Tests")
class VectorSearchResultTest {

    @Test
    @DisplayName("should build result with required fields")
    void shouldBuildResultWithRequiredFields() {
        VectorSearchResult result = VectorSearchResult.builder()
                .documentId("player-123")
                .documentType(DocumentType.NFL_PLAYER)
                .score(0.95)
                .build();

        assertThat(result.getDocumentId()).isEqualTo("player-123");
        assertThat(result.getDocumentType()).isEqualTo(DocumentType.NFL_PLAYER);
        assertThat(result.getScore()).isEqualTo(0.95);
    }

    @Test
    @DisplayName("should build result with content")
    void shouldBuildResultWithContent() {
        VectorSearchResult result = VectorSearchResult.builder()
                .documentId("player-123")
                .documentType(DocumentType.NFL_PLAYER)
                .score(0.85)
                .content("Patrick Mahomes - QB for Kansas City Chiefs")
                .build();

        assertThat(result.getContent()).isEqualTo("Patrick Mahomes - QB for Kansas City Chiefs");
    }

    @Test
    @DisplayName("should build result with metadata")
    void shouldBuildResultWithMetadata() {
        VectorSearchResult result = VectorSearchResult.builder()
                .documentId("player-123")
                .documentType(DocumentType.NFL_PLAYER)
                .score(0.90)
                .metadata("playerName", "Patrick Mahomes")
                .metadata("team", "KC")
                .build();

        assertThat(result.getMetadata()).containsEntry("playerName", "Patrick Mahomes");
        assertThat(result.getMetadata()).containsEntry("team", "KC");
    }

    @Test
    @DisplayName("should identify highly relevant result")
    void shouldIdentifyHighlyRelevantResult() {
        VectorSearchResult highlyRelevant = VectorSearchResult.builder()
                .documentId("1")
                .documentType(DocumentType.NFL_PLAYER)
                .score(0.85)
                .build();

        VectorSearchResult lessRelevant = VectorSearchResult.builder()
                .documentId("2")
                .documentType(DocumentType.NFL_PLAYER)
                .score(0.65)
                .build();

        assertThat(highlyRelevant.isHighlyRelevant()).isTrue();
        assertThat(lessRelevant.isHighlyRelevant()).isFalse();
    }

    @Test
    @DisplayName("should check if result meets threshold")
    void shouldCheckIfResultMeetsThreshold() {
        VectorSearchResult result = VectorSearchResult.builder()
                .documentId("1")
                .documentType(DocumentType.NFL_PLAYER)
                .score(0.75)
                .build();

        assertThat(result.meetsThreshold(0.7)).isTrue();
        assertThat(result.meetsThreshold(0.8)).isFalse();
    }

    @Test
    @DisplayName("should get typed metadata value")
    void shouldGetTypedMetadataValue() {
        VectorSearchResult result = VectorSearchResult.builder()
                .documentId("1")
                .documentType(DocumentType.NFL_PLAYER)
                .score(0.90)
                .metadata("jerseyNumber", 15)
                .metadata("name", "Patrick Mahomes")
                .build();

        Integer jerseyNumber = result.getMetadataValue("jerseyNumber", Integer.class);
        String name = result.getMetadataValue("name", String.class);

        assertThat(jerseyNumber).isEqualTo(15);
        assertThat(name).isEqualTo("Patrick Mahomes");
    }

    @Test
    @DisplayName("should return null for missing metadata key")
    void shouldReturnNullForMissingMetadataKey() {
        VectorSearchResult result = VectorSearchResult.builder()
                .documentId("1")
                .documentType(DocumentType.NFL_PLAYER)
                .score(0.90)
                .build();

        String missing = result.getMetadataValue("missing", String.class);

        assertThat(missing).isNull();
    }

    @Test
    @DisplayName("should throw exception for wrong metadata type")
    void shouldThrowExceptionForWrongMetadataType() {
        VectorSearchResult result = VectorSearchResult.builder()
                .documentId("1")
                .documentType(DocumentType.NFL_PLAYER)
                .score(0.90)
                .metadata("number", "not a number")
                .build();

        assertThatThrownBy(() -> result.getMetadataValue("number", Integer.class))
                .isInstanceOf(ClassCastException.class);
    }

    @Test
    @DisplayName("should throw exception for invalid score")
    void shouldThrowExceptionForInvalidScore() {
        assertThatThrownBy(() -> VectorSearchResult.builder()
                .documentId("1")
                .documentType(DocumentType.NFL_PLAYER)
                .score(1.5)
                .build())
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("between 0 and 1");
    }

    @Test
    @DisplayName("should return unmodifiable metadata map")
    void shouldReturnUnmodifiableMetadataMap() {
        VectorSearchResult result = VectorSearchResult.builder()
                .documentId("1")
                .documentType(DocumentType.NFL_PLAYER)
                .score(0.90)
                .metadata("key", "value")
                .build();

        Map<String, Object> metadata = result.getMetadata();

        assertThatThrownBy(() -> metadata.put("newKey", "newValue"))
                .isInstanceOf(UnsupportedOperationException.class);
    }
}
