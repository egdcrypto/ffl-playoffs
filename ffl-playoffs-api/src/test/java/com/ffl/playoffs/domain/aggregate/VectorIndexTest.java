package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.vectorsearch.DocumentType;
import com.ffl.playoffs.domain.model.vectorsearch.VectorEmbedding;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("VectorIndex Aggregate Tests")
class VectorIndexTest {

    @Test
    @DisplayName("should create vector index with required fields")
    void shouldCreateVectorIndexWithRequiredFields() {
        VectorIndex index = new VectorIndex("player-123", DocumentType.NFL_PLAYER, "Patrick Mahomes - QB");

        assertThat(index.getId()).isNotNull();
        assertThat(index.getSourceId()).isEqualTo("player-123");
        assertThat(index.getDocumentType()).isEqualTo(DocumentType.NFL_PLAYER);
        assertThat(index.getContent()).isEqualTo("Patrick Mahomes - QB");
        assertThat(index.isActive()).isTrue();
        assertThat(index.getIndexedAt()).isNotNull();
    }

    @Test
    @DisplayName("should create vector index for NFL player")
    void shouldCreateVectorIndexForNFLPlayer() {
        VectorIndex index = VectorIndex.forNFLPlayer(123L, "Patrick Mahomes", "QB", "Kansas City Chiefs");

        assertThat(index.getSourceId()).isEqualTo("123");
        assertThat(index.getDocumentType()).isEqualTo(DocumentType.NFL_PLAYER);
        assertThat(index.getContent()).contains("Patrick Mahomes");
        assertThat(index.getMetadata()).containsEntry("playerName", "Patrick Mahomes");
        assertThat(index.getMetadata()).containsEntry("position", "QB");
        assertThat(index.getMetadata()).containsEntry("team", "Kansas City Chiefs");
    }

    @Test
    @DisplayName("should create vector index for league")
    void shouldCreateVectorIndexForLeague() {
        UUID leagueId = UUID.randomUUID();
        VectorIndex index = VectorIndex.forLeague(leagueId, "Champions League", "A competitive fantasy league");

        assertThat(index.getSourceId()).isEqualTo(leagueId.toString());
        assertThat(index.getDocumentType()).isEqualTo(DocumentType.LEAGUE);
        assertThat(index.getContent()).contains("Champions League");
        assertThat(index.getMetadata()).containsEntry("leagueName", "Champions League");
    }

    @Test
    @DisplayName("should create vector index for news")
    void shouldCreateVectorIndexForNews() {
        VectorIndex index = VectorIndex.forNews("news-456", "Player Injury Update", "Mahomes cleared to play");

        assertThat(index.getSourceId()).isEqualTo("news-456");
        assertThat(index.getDocumentType()).isEqualTo(DocumentType.NEWS);
        assertThat(index.getContent()).contains("Player Injury Update");
        assertThat(index.getMetadata()).containsEntry("headline", "Player Injury Update");
    }

    @Test
    @DisplayName("should update embedding")
    void shouldUpdateEmbedding() {
        VectorIndex index = new VectorIndex("source-1", DocumentType.NFL_PLAYER, "Test content");
        VectorEmbedding embedding = VectorEmbedding.of(new float[]{0.1f, 0.2f, 0.3f});

        index.updateEmbedding(embedding);

        assertThat(index.getEmbedding()).isEqualTo(embedding);
        assertThat(index.needsEmbedding()).isFalse();
    }

    @Test
    @DisplayName("should update content and clear embedding")
    void shouldUpdateContentAndClearEmbedding() {
        VectorIndex index = new VectorIndex("source-1", DocumentType.NFL_PLAYER, "Original content");
        VectorEmbedding embedding = VectorEmbedding.of(new float[]{0.1f, 0.2f, 0.3f});
        index.updateEmbedding(embedding);

        index.updateContent("Updated content");

        assertThat(index.getContent()).isEqualTo("Updated content");
        assertThat(index.getEmbedding()).isNull();
        assertThat(index.needsEmbedding()).isTrue();
    }

    @Test
    @DisplayName("should add metadata")
    void shouldAddMetadata() {
        VectorIndex index = new VectorIndex("source-1", DocumentType.NFL_PLAYER, "Test content");

        index.addMetadata("key1", "value1");
        index.addMetadata("key2", 42);

        assertThat(index.getMetadata()).containsEntry("key1", "value1");
        assertThat(index.getMetadata()).containsEntry("key2", 42);
    }

    @Test
    @DisplayName("should deactivate index")
    void shouldDeactivateIndex() {
        VectorIndex index = new VectorIndex("source-1", DocumentType.NFL_PLAYER, "Test content");
        assertThat(index.isActive()).isTrue();

        index.deactivate();

        assertThat(index.isActive()).isFalse();
    }

    @Test
    @DisplayName("should reactivate index")
    void shouldReactivateIndex() {
        VectorIndex index = new VectorIndex("source-1", DocumentType.NFL_PLAYER, "Test content");
        index.deactivate();

        index.activate();

        assertThat(index.isActive()).isTrue();
    }

    @Test
    @DisplayName("should check if index needs embedding")
    void shouldCheckIfIndexNeedsEmbedding() {
        VectorIndex index = new VectorIndex("source-1", DocumentType.NFL_PLAYER, "Test content");

        assertThat(index.needsEmbedding()).isTrue();

        index.updateEmbedding(VectorEmbedding.of(new float[]{0.1f, 0.2f}));

        assertThat(index.needsEmbedding()).isFalse();
    }

    @Test
    @DisplayName("should check if index is searchable")
    void shouldCheckIfIndexIsSearchable() {
        VectorIndex index = new VectorIndex("source-1", DocumentType.NFL_PLAYER, "Test content");

        // Not searchable without embedding
        assertThat(index.isSearchable()).isFalse();

        // Add embedding
        index.updateEmbedding(VectorEmbedding.of(new float[]{0.1f, 0.2f}));
        assertThat(index.isSearchable()).isTrue();

        // Deactivate
        index.deactivate();
        assertThat(index.isSearchable()).isFalse();
    }

    @Test
    @DisplayName("should implement equals based on id")
    void shouldImplementEqualsBasedOnId() {
        VectorIndex index1 = new VectorIndex("source-1", DocumentType.NFL_PLAYER, "Content 1");
        VectorIndex index2 = new VectorIndex("source-2", DocumentType.NFL_PLAYER, "Content 2");

        // Same ID means equal
        UUID sharedId = UUID.randomUUID();
        index1.setId(sharedId);
        index2.setId(sharedId);

        assertThat(index1).isEqualTo(index2);

        // Different ID means not equal
        index2.setId(UUID.randomUUID());
        assertThat(index1).isNotEqualTo(index2);
    }
}
