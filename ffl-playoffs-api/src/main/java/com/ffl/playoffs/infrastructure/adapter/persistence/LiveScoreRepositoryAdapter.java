package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.LiveScoreStatus;
import com.ffl.playoffs.domain.model.ScoreUpdate;
import com.ffl.playoffs.domain.port.LiveScoreRepository;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.LiveScoreDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.ScoreUpdateDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoLiveScoreRepository;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoScoreUpdateRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Infrastructure adapter implementing LiveScoreRepository
 * Provides persistence for live scoring data using MongoDB
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class LiveScoreRepositoryAdapter implements LiveScoreRepository {

    private final MongoLiveScoreRepository liveScoreRepository;
    private final MongoScoreUpdateRepository scoreUpdateRepository;

    // In-memory idempotency key cache for fast lookups
    private final Map<String, Boolean> idempotencyCache = new ConcurrentHashMap<>();

    @Override
    public void save(ScoreUpdate scoreUpdate) {
        // Save to score updates collection (audit trail)
        ScoreUpdateDocument updateDoc = ScoreUpdateDocument.builder()
                .leagueId(scoreUpdate.getLeagueId())
                .leaguePlayerId(scoreUpdate.getLeaguePlayerId())
                .previousScore(scoreUpdate.getPreviousScore())
                .newScore(scoreUpdate.getNewScore())
                .scoreDelta(scoreUpdate.getScoreDelta())
                .updatedPosition(scoreUpdate.getUpdatedPosition())
                .nflPlayerId(scoreUpdate.getNflPlayerId())
                .nflPlayerName(scoreUpdate.getNflPlayerName())
                .statUpdate(scoreUpdate.getStatUpdate())
                .status(scoreUpdate.getStatus().name())
                .idempotencyKey(scoreUpdate.getIdempotencyKey())
                .timestamp(scoreUpdate.getTimestamp())
                .build();

        scoreUpdateRepository.save(updateDoc);

        // Update/create live score document
        LiveScoreDocument liveDoc = liveScoreRepository.findByLeaguePlayerId(scoreUpdate.getLeaguePlayerId())
                .orElse(LiveScoreDocument.builder()
                        .leagueId(scoreUpdate.getLeagueId())
                        .leaguePlayerId(scoreUpdate.getLeaguePlayerId())
                        .createdAt(LocalDateTime.now())
                        .build());

        liveDoc.setPreviousScore(scoreUpdate.getPreviousScore());
        liveDoc.setCurrentScore(scoreUpdate.getNewScore());
        liveDoc.setScoreDelta(scoreUpdate.getScoreDelta());
        liveDoc.setStatus(scoreUpdate.getStatus().name());
        liveDoc.setUpdatedAt(scoreUpdate.getTimestamp());

        liveScoreRepository.save(liveDoc);

        // Mark idempotency key
        idempotencyCache.put(scoreUpdate.getIdempotencyKey(), true);

        log.debug("Saved score update for player {}: {} -> {}",
                scoreUpdate.getLeaguePlayerId(), scoreUpdate.getPreviousScore(), scoreUpdate.getNewScore());
    }

    @Override
    public void saveAll(List<ScoreUpdate> scoreUpdates) {
        for (ScoreUpdate update : scoreUpdates) {
            save(update);
        }
        log.debug("Saved {} score updates in batch", scoreUpdates.size());
    }

    @Override
    public Optional<BigDecimal> getCurrentScore(String leaguePlayerId) {
        return liveScoreRepository.findByLeaguePlayerId(leaguePlayerId)
                .map(LiveScoreDocument::getCurrentScore);
    }

    @Override
    public Map<String, BigDecimal> getAllScoresForLeague(String leagueId) {
        Map<String, BigDecimal> scores = new HashMap<>();

        List<LiveScoreDocument> docs = liveScoreRepository.findByLeagueId(leagueId);
        for (LiveScoreDocument doc : docs) {
            scores.put(doc.getLeaguePlayerId(), doc.getCurrentScore());
        }

        return scores;
    }

    @Override
    public LiveScoreStatus getScoreStatus(String leaguePlayerId) {
        return liveScoreRepository.findByLeaguePlayerId(leaguePlayerId)
                .map(doc -> LiveScoreStatus.valueOf(doc.getStatus()))
                .orElse(LiveScoreStatus.LIVE);
    }

    @Override
    public void updateScoreStatus(String leaguePlayerId, LiveScoreStatus status) {
        liveScoreRepository.findByLeaguePlayerId(leaguePlayerId)
                .ifPresent(doc -> {
                    doc.setStatus(status.name());
                    doc.setUpdatedAt(LocalDateTime.now());
                    liveScoreRepository.save(doc);
                });
    }

    @Override
    public List<ScoreUpdate> getRecentUpdates(String leaguePlayerId, LocalDateTime since) {
        return scoreUpdateRepository.findByLeaguePlayerIdAndTimestampAfterOrderByTimestampDesc(
                        leaguePlayerId, since)
                .stream()
                .map(this::toScoreUpdate)
                .toList();
    }

    @Override
    public List<ScoreUpdate> getRecentLeagueUpdates(String leagueId, LocalDateTime since) {
        return scoreUpdateRepository.findByLeagueIdAndTimestampAfterOrderByTimestampDesc(
                        leagueId, since)
                .stream()
                .map(this::toScoreUpdate)
                .toList();
    }

    @Override
    public boolean isDuplicateUpdate(String idempotencyKey) {
        // Check cache first
        if (idempotencyCache.containsKey(idempotencyKey)) {
            return true;
        }

        // Check database
        boolean exists = scoreUpdateRepository.existsByIdempotencyKey(idempotencyKey);
        if (exists) {
            idempotencyCache.put(idempotencyKey, true);
        }

        return exists;
    }

    @Override
    public void markIdempotencyKey(String idempotencyKey) {
        idempotencyCache.put(idempotencyKey, true);
    }

    @Override
    public Optional<LocalDateTime> getLastUpdateTime(String leagueId) {
        return liveScoreRepository.findTopByLeagueIdOrderByUpdatedAtDesc(leagueId)
                .map(LiveScoreDocument::getUpdatedAt);
    }

    @Override
    public void clearCache(String leagueId) {
        liveScoreRepository.deleteByLeagueId(leagueId);
        idempotencyCache.clear();
        log.info("Cleared live score cache for league {}", leagueId);
    }

    private ScoreUpdate toScoreUpdate(ScoreUpdateDocument doc) {
        return ScoreUpdate.builder()
                .leaguePlayerId(doc.getLeaguePlayerId())
                .leagueId(doc.getLeagueId())
                .previousScore(doc.getPreviousScore())
                .newScore(doc.getNewScore())
                .updatedPosition(doc.getUpdatedPosition())
                .nflPlayerId(doc.getNflPlayerId())
                .nflPlayerName(doc.getNflPlayerName())
                .statUpdate(doc.getStatUpdate())
                .status(LiveScoreStatus.valueOf(doc.getStatus()))
                .timestamp(doc.getTimestamp())
                .build();
    }
}
