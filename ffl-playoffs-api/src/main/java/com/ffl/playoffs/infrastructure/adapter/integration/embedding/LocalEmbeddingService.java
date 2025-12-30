package com.ffl.playoffs.infrastructure.adapter.integration.embedding;

import com.ffl.playoffs.domain.model.vectorsearch.VectorEmbedding;
import com.ffl.playoffs.domain.service.EmbeddingService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Local implementation of EmbeddingService.
 * Uses a simple hashing-based approach for generating consistent embeddings.
 * This is a fallback when external embedding services are not available.
 *
 * For production, this should be replaced with an actual embedding service
 * like OpenAI Ada, Cohere, or a local model like Sentence-BERT.
 */
@Slf4j
@Service
public class LocalEmbeddingService implements EmbeddingService {

    private static final int EMBEDDING_DIMENSION = 384;

    @Override
    public VectorEmbedding embed(String text) {
        if (text == null || text.isBlank()) {
            throw new IllegalArgumentException("Text cannot be null or blank");
        }

        log.debug("Generating embedding for text of length: {}", text.length());

        float[] embedding = generateEmbedding(text);
        return VectorEmbedding.of(embedding).normalize();
    }

    @Override
    public List<VectorEmbedding> embedBatch(List<String> texts) {
        if (texts == null || texts.isEmpty()) {
            return List.of();
        }

        log.debug("Generating embeddings for {} texts", texts.size());

        return texts.stream()
                .map(this::embed)
                .collect(Collectors.toList());
    }

    @Override
    public int getEmbeddingDimension() {
        return EMBEDDING_DIMENSION;
    }

    @Override
    public boolean isAvailable() {
        return true;
    }

    /**
     * Generate a deterministic embedding from text using hashing.
     * This creates a consistent vector representation that preserves
     * some semantic properties (similar words will have overlapping hashes).
     */
    private float[] generateEmbedding(String text) {
        float[] embedding = new float[EMBEDDING_DIMENSION];

        // Normalize text
        String normalizedText = text.toLowerCase().trim();

        // Generate base embedding from full text hash
        byte[] textHash = hashText(normalizedText);
        for (int i = 0; i < Math.min(textHash.length, EMBEDDING_DIMENSION); i++) {
            embedding[i] = (textHash[i] & 0xFF) / 255.0f;
        }

        // Add word-level features
        String[] words = normalizedText.split("\\s+");
        for (int wordIdx = 0; wordIdx < words.length; wordIdx++) {
            String word = words[wordIdx];
            if (word.length() < 2) continue;

            byte[] wordHash = hashText(word);
            int offset = (wordHash[0] & 0xFF) % (EMBEDDING_DIMENSION - 32);

            for (int i = 0; i < Math.min(wordHash.length, 32); i++) {
                int idx = (offset + i) % EMBEDDING_DIMENSION;
                // Blend with position-weighted contribution
                float contribution = (wordHash[i] & 0xFF) / 255.0f * 0.1f;
                embedding[idx] = (embedding[idx] + contribution) / 2.0f;
            }
        }

        // Add character n-gram features for better matching
        for (int n = 2; n <= 3; n++) {
            for (int i = 0; i <= normalizedText.length() - n; i++) {
                String ngram = normalizedText.substring(i, i + n);
                int hashCode = ngram.hashCode();
                int idx = Math.abs(hashCode) % EMBEDDING_DIMENSION;
                embedding[idx] += 0.05f;
            }
        }

        return embedding;
    }

    /**
     * Hash text using SHA-256
     */
    private byte[] hashText(String text) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            return digest.digest(text.getBytes(StandardCharsets.UTF_8));
        } catch (NoSuchAlgorithmException e) {
            // SHA-256 is always available
            throw new RuntimeException("SHA-256 not available", e);
        }
    }
}
