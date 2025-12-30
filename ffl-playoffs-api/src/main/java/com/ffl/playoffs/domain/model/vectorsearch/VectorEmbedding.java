package com.ffl.playoffs.domain.model.vectorsearch;

import java.util.Arrays;
import java.util.Objects;

/**
 * Value object representing a vector embedding.
 * Immutable and encapsulates embedding data with dimension validation.
 */
public final class VectorEmbedding {

    private final float[] vector;
    private final int dimensions;

    private VectorEmbedding(float[] vector) {
        if (vector == null || vector.length == 0) {
            throw new IllegalArgumentException("Vector cannot be null or empty");
        }
        this.vector = Arrays.copyOf(vector, vector.length);
        this.dimensions = vector.length;
    }

    /**
     * Create a new VectorEmbedding from a float array
     */
    public static VectorEmbedding of(float[] vector) {
        return new VectorEmbedding(vector);
    }

    /**
     * Create a new VectorEmbedding from a double array
     */
    public static VectorEmbedding of(double[] vector) {
        if (vector == null) {
            throw new IllegalArgumentException("Vector cannot be null");
        }
        float[] floatVector = new float[vector.length];
        for (int i = 0; i < vector.length; i++) {
            floatVector[i] = (float) vector[i];
        }
        return new VectorEmbedding(floatVector);
    }

    /**
     * Get a copy of the vector array
     */
    public float[] getVector() {
        return Arrays.copyOf(vector, vector.length);
    }

    /**
     * Get the dimensionality of the embedding
     */
    public int getDimensions() {
        return dimensions;
    }

    /**
     * Calculate cosine similarity with another embedding
     */
    public double cosineSimilarity(VectorEmbedding other) {
        if (other == null || other.dimensions != this.dimensions) {
            throw new IllegalArgumentException("Cannot compare embeddings of different dimensions");
        }

        double dotProduct = 0.0;
        double normA = 0.0;
        double normB = 0.0;

        for (int i = 0; i < dimensions; i++) {
            dotProduct += this.vector[i] * other.vector[i];
            normA += this.vector[i] * this.vector[i];
            normB += other.vector[i] * other.vector[i];
        }

        if (normA == 0.0 || normB == 0.0) {
            return 0.0;
        }

        return dotProduct / (Math.sqrt(normA) * Math.sqrt(normB));
    }

    /**
     * Calculate Euclidean distance with another embedding
     */
    public double euclideanDistance(VectorEmbedding other) {
        if (other == null || other.dimensions != this.dimensions) {
            throw new IllegalArgumentException("Cannot compare embeddings of different dimensions");
        }

        double sum = 0.0;
        for (int i = 0; i < dimensions; i++) {
            double diff = this.vector[i] - other.vector[i];
            sum += diff * diff;
        }

        return Math.sqrt(sum);
    }

    /**
     * Normalize the vector to unit length
     */
    public VectorEmbedding normalize() {
        double norm = 0.0;
        for (float v : vector) {
            norm += v * v;
        }
        norm = Math.sqrt(norm);

        if (norm == 0.0) {
            return this;
        }

        float[] normalized = new float[dimensions];
        for (int i = 0; i < dimensions; i++) {
            normalized[i] = (float) (vector[i] / norm);
        }

        return new VectorEmbedding(normalized);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        VectorEmbedding that = (VectorEmbedding) o;
        return Arrays.equals(vector, that.vector);
    }

    @Override
    public int hashCode() {
        return Arrays.hashCode(vector);
    }

    @Override
    public String toString() {
        return "VectorEmbedding{dimensions=" + dimensions + "}";
    }
}
