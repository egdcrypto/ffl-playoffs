package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.TrainingExample;
import com.ffl.playoffs.domain.model.TrainingExampleType;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for TrainingExample aggregate
 * Port in hexagonal architecture
 */
public interface TrainingExampleRepository {

    /**
     * Find training example by ID
     * @param id the example ID
     * @return Optional containing the example if found
     */
    Optional<TrainingExample> findById(UUID id);

    /**
     * Find training example by conversation ID
     * @param conversationId the conversation ID
     * @return Optional containing the example if found
     */
    Optional<TrainingExample> findByConversationId(UUID conversationId);

    /**
     * Find all training examples
     * @return list of all examples
     */
    List<TrainingExample> findAll();

    /**
     * Find training examples by character
     * @param characterId the character ID
     * @return list of examples for the character
     */
    List<TrainingExample> findByCharacterId(UUID characterId);

    /**
     * Find training examples by type
     * @param type the example type (positive/negative)
     * @return list of examples of the specified type
     */
    List<TrainingExample> findByType(TrainingExampleType type);

    /**
     * Find training examples by tag
     * @param tag the tag to search for
     * @return list of examples with the tag
     */
    List<TrainingExample> findByTag(String tag);

    /**
     * Find high-quality training examples
     * @param minRating minimum quality rating
     * @return list of high-quality examples
     */
    List<TrainingExample> findByMinRating(int minRating);

    /**
     * Count examples by type for a character
     * @param characterId the character ID
     * @param type the example type
     * @return count of examples
     */
    long countByCharacterIdAndType(UUID characterId, TrainingExampleType type);

    /**
     * Save a training example
     * @param example the example to save
     * @return the saved example
     */
    TrainingExample save(TrainingExample example);

    /**
     * Delete a training example
     * @param id the example ID
     */
    void deleteById(UUID id);
}
