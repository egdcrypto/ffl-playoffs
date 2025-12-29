package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.WorldEventDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Spring Data MongoDB repository for WorldEventDocument.
 * Infrastructure layer - MongoDB specific.
 */
@Repository
public interface WorldEventMongoRepository extends MongoRepository<WorldEventDocument, String> {

    /**
     * Find all events for a simulation world
     */
    List<WorldEventDocument> findBySimulationWorldId(String worldId);

    /**
     * Find all events for a simulation run
     */
    List<WorldEventDocument> findBySimulationRunId(String runId);

    /**
     * Find active events for a simulation run
     */
    List<WorldEventDocument> findBySimulationRunIdAndStatus(String runId, String status);

    /**
     * Find scheduled events for a world
     */
    List<WorldEventDocument> findBySimulationWorldIdAndStatus(String worldId, String status);

    /**
     * Find active events for a week
     */
    @Query("{ 'simulationRunId': ?0, 'status': 'ACTIVE', 'startWeek': { $lte: ?1 }, $or: [ { 'endWeek': { $gte: ?1 } }, { 'endWeek': null } ] }")
    List<WorldEventDocument> findActiveEventsForWeek(String runId, Integer week);

    /**
     * Find active events for a player
     */
    @Query("{ 'simulationRunId': ?0, 'targets.targetId': ?1, 'status': 'ACTIVE', 'startWeek': { $lte: ?2 }, $or: [ { 'endWeek': { $gte: ?2 } }, { 'endWeek': null } ] }")
    List<WorldEventDocument> findActiveEventsForPlayer(String runId, String playerId, Integer week);

    /**
     * Find active events for a team
     */
    @Query("{ 'simulationRunId': ?0, 'targets.targetId': ?1, 'targets.type': 'TEAM', 'status': 'ACTIVE', 'startWeek': { $lte: ?2 }, $or: [ { 'endWeek': { $gte: ?2 } }, { 'endWeek': null } ] }")
    List<WorldEventDocument> findActiveEventsForTeam(String runId, String teamAbbr, Integer week);

    /**
     * Find events for a specific game
     */
    @Query("{ 'simulationRunId': ?0, 'targets.targetId': ?1, 'targets.type': 'GAME' }")
    List<WorldEventDocument> findEventsForGame(String runId, String gameId);

    /**
     * Find events by type
     */
    List<WorldEventDocument> findBySimulationRunIdAndType(String runId, String type);

    /**
     * Find events by category
     */
    List<WorldEventDocument> findBySimulationRunIdAndCategory(String runId, String category);

    /**
     * Find expired events
     */
    @Query("{ 'simulationRunId': ?0, 'status': 'EXPIRED' }")
    List<WorldEventDocument> findExpiredEvents(String runId);
}
