package com.ffl.playoffs.infrastructure.persistence.mongodb.repository;

import com.ffl.playoffs.infrastructure.persistence.mongodb.document.ScoreAuditDocument;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for Score Audit documents
 */
@Repository
public interface MongoScoreAuditRepository extends MongoRepository<ScoreAuditDocument, String> {

    /**
     * Find audit record for a player in a specific week
     */
    Optional<ScoreAuditDocument> findByPlayerIdAndWeekId(Long playerId, Long weekId);

    /**
     * Find all audit records for a player
     */
    List<ScoreAuditDocument> findByPlayerId(Long playerId);

    /**
     * Find all audit records for a specific week
     */
    List<ScoreAuditDocument> findByWeekId(Long weekId);

    /**
     * Find all audit records for a specific week with pagination
     */
    Page<ScoreAuditDocument> findByWeekId(Long weekId, Pageable pageable);

    /**
     * Find all eliminated players in a week
     */
    List<ScoreAuditDocument> findByWeekIdAndEliminatedTrue(Long weekId);

    /**
     * Find audit records for a team selection
     */
    Optional<ScoreAuditDocument> findByTeamSelectionId(Long teamSelectionId);

    /**
     * Check if an audit record exists for a player in a week
     */
    boolean existsByPlayerIdAndWeekId(Long playerId, Long weekId);
}
