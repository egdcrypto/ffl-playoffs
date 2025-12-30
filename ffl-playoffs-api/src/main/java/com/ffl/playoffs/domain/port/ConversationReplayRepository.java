package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.ConversationReplay;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for ConversationReplay aggregate
 * Port in hexagonal architecture
 */
public interface ConversationReplayRepository {

    /**
     * Find conversation replay by ID
     * @param id the replay ID
     * @return Optional containing the replay if found
     */
    Optional<ConversationReplay> findById(UUID id);

    /**
     * Find all replays for an original conversation
     * @param originalConversationId the original conversation ID
     * @return list of replays
     */
    List<ConversationReplay> findByOriginalConversationId(UUID originalConversationId);

    /**
     * Find all replays for a character
     * @param characterId the character ID
     * @return list of replays
     */
    List<ConversationReplay> findByCharacterId(UUID characterId);

    /**
     * Find replays by admin who performed them
     * @param adminId the admin ID
     * @return list of replays
     */
    List<ConversationReplay> findByReplayedBy(UUID adminId);

    /**
     * Find replays within a date range
     * @param from start date
     * @param to end date
     * @return list of replays
     */
    List<ConversationReplay> findByDateRange(LocalDateTime from, LocalDateTime to);

    /**
     * Save a conversation replay
     * @param replay the replay to save
     * @return the saved replay
     */
    ConversationReplay save(ConversationReplay replay);

    /**
     * Delete a conversation replay
     * @param id the replay ID
     */
    void deleteById(UUID id);
}
