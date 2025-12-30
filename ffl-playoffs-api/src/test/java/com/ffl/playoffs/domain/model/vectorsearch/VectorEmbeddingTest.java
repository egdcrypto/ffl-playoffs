package com.ffl.playoffs.domain.model.vectorsearch;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("VectorEmbedding Value Object Tests")
class VectorEmbeddingTest {

    @Test
    @DisplayName("should create embedding from float array")
    void shouldCreateEmbeddingFromFloatArray() {
        float[] vector = {0.1f, 0.2f, 0.3f, 0.4f, 0.5f};

        VectorEmbedding embedding = VectorEmbedding.of(vector);

        assertThat(embedding.getDimensions()).isEqualTo(5);
        assertThat(embedding.getVector()).containsExactly(vector);
    }

    @Test
    @DisplayName("should create embedding from double array")
    void shouldCreateEmbeddingFromDoubleArray() {
        double[] vector = {0.1, 0.2, 0.3, 0.4, 0.5};

        VectorEmbedding embedding = VectorEmbedding.of(vector);

        assertThat(embedding.getDimensions()).isEqualTo(5);
    }

    @Test
    @DisplayName("should throw exception for null vector")
    void shouldThrowExceptionForNullVector() {
        assertThatThrownBy(() -> VectorEmbedding.of((float[]) null))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("null or empty");
    }

    @Test
    @DisplayName("should throw exception for empty vector")
    void shouldThrowExceptionForEmptyVector() {
        assertThatThrownBy(() -> VectorEmbedding.of(new float[0]))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("null or empty");
    }

    @Test
    @DisplayName("should calculate cosine similarity correctly")
    void shouldCalculateCosineSimilarityCorrectly() {
        VectorEmbedding v1 = VectorEmbedding.of(new float[]{1.0f, 0.0f, 0.0f});
        VectorEmbedding v2 = VectorEmbedding.of(new float[]{1.0f, 0.0f, 0.0f});

        double similarity = v1.cosineSimilarity(v2);

        assertThat(similarity).isCloseTo(1.0, within(0.001));
    }

    @Test
    @DisplayName("should calculate cosine similarity for orthogonal vectors")
    void shouldCalculateCosineSimilarityForOrthogonalVectors() {
        VectorEmbedding v1 = VectorEmbedding.of(new float[]{1.0f, 0.0f, 0.0f});
        VectorEmbedding v2 = VectorEmbedding.of(new float[]{0.0f, 1.0f, 0.0f});

        double similarity = v1.cosineSimilarity(v2);

        assertThat(similarity).isCloseTo(0.0, within(0.001));
    }

    @Test
    @DisplayName("should calculate euclidean distance correctly")
    void shouldCalculateEuclideanDistanceCorrectly() {
        VectorEmbedding v1 = VectorEmbedding.of(new float[]{0.0f, 0.0f, 0.0f});
        VectorEmbedding v2 = VectorEmbedding.of(new float[]{3.0f, 4.0f, 0.0f});

        double distance = v1.euclideanDistance(v2);

        assertThat(distance).isCloseTo(5.0, within(0.001));
    }

    @Test
    @DisplayName("should normalize vector to unit length")
    void shouldNormalizeVectorToUnitLength() {
        VectorEmbedding embedding = VectorEmbedding.of(new float[]{3.0f, 4.0f});

        VectorEmbedding normalized = embedding.normalize();

        // Check that magnitude is 1
        float[] v = normalized.getVector();
        double magnitude = Math.sqrt(v[0] * v[0] + v[1] * v[1]);
        assertThat(magnitude).isCloseTo(1.0, within(0.001));
    }

    @Test
    @DisplayName("should return copy of vector to ensure immutability")
    void shouldReturnCopyOfVector() {
        float[] original = {0.1f, 0.2f, 0.3f};
        VectorEmbedding embedding = VectorEmbedding.of(original);

        float[] retrieved = embedding.getVector();
        retrieved[0] = 999.0f;

        assertThat(embedding.getVector()[0]).isEqualTo(0.1f);
    }

    @Test
    @DisplayName("should implement equals correctly")
    void shouldImplementEqualsCorrectly() {
        VectorEmbedding v1 = VectorEmbedding.of(new float[]{0.1f, 0.2f, 0.3f});
        VectorEmbedding v2 = VectorEmbedding.of(new float[]{0.1f, 0.2f, 0.3f});
        VectorEmbedding v3 = VectorEmbedding.of(new float[]{0.1f, 0.2f, 0.4f});

        assertThat(v1).isEqualTo(v2);
        assertThat(v1).isNotEqualTo(v3);
    }
}
