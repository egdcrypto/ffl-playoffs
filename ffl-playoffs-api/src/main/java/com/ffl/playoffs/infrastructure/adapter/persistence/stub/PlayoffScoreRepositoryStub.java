package com.ffl.playoffs.infrastructure.adapter.persistence.stub;

import com.ffl.playoffs.domain.model.PlayoffRound;
import com.ffl.playoffs.domain.model.RosterScore;
import com.ffl.playoffs.domain.port.PlayoffScoreRepository;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

/**
 * Stub implementation of PlayoffScoreRepository for testing and development
 */
@Repository
public class PlayoffScoreRepositoryStub implements PlayoffScoreRepository {

    private final Map<UUID, RosterScore> storage = new ConcurrentHashMap<>();

    @Override
    public Optional<RosterScore> findById(UUID id) {
        return Optional.ofNullable(storage.get(id));
    }

    @Override
    public Optional<RosterScore> findByPlayerIdAndRound(UUID leaguePlayerId, PlayoffRound round) {
        return storage.values().stream()
                .filter(s -> leaguePlayerId.equals(s.getLeaguePlayerId()) && round.equals(s.getRound()))
                .findFirst();
    }

    @Override
    public List<RosterScore> findByLeagueIdAndRound(UUID leagueId, PlayoffRound round) {
        // RosterScore doesn't have leagueId - return scores by round only
        return storage.values().stream()
                .filter(s -> round.equals(s.getRound()))
                .collect(Collectors.toList());
    }

    @Override
    public List<RosterScore> findByPlayerId(UUID leaguePlayerId) {
        return storage.values().stream()
                .filter(s -> leaguePlayerId.equals(s.getLeaguePlayerId()))
                .collect(Collectors.toList());
    }

    @Override
    public Map<UUID, BigDecimal> getCumulativeScores(UUID leagueId) {
        // Return cumulative scores grouped by player
        return storage.values().stream()
                .collect(Collectors.groupingBy(
                        RosterScore::getLeaguePlayerId,
                        Collectors.reducing(BigDecimal.ZERO, RosterScore::getTotalScore, BigDecimal::add)
                ));
    }

    @Override
    public RosterScore save(RosterScore score) {
        // RosterScore is immutable with auto-generated ID
        storage.put(score.getId(), score);
        return score;
    }

    @Override
    public List<RosterScore> saveAll(List<RosterScore> scores) {
        scores.forEach(this::save);
        return scores;
    }

    @Override
    public void deleteById(UUID id) {
        storage.remove(id);
    }

    @Override
    public void deleteByPlayerId(UUID leaguePlayerId) {
        storage.entrySet().removeIf(e -> leaguePlayerId.equals(e.getValue().getLeaguePlayerId()));
    }
}
