package com.ffl.playoffs.infrastructure.adapter.persistence.stub;

import com.ffl.playoffs.domain.model.PlayoffRanking;
import com.ffl.playoffs.domain.model.PlayoffRound;
import com.ffl.playoffs.domain.port.PlayoffRankingRepository;
import org.springframework.stereotype.Repository;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

/**
 * Stub implementation of PlayoffRankingRepository for testing and development
 */
@Repository
public class PlayoffRankingRepositoryStub implements PlayoffRankingRepository {

    private final Map<String, PlayoffRanking> storage = new ConcurrentHashMap<>();

    private String buildKey(UUID playerId, PlayoffRound round, boolean isCumulative) {
        return playerId + "-" + round + "-" + isCumulative;
    }

    @Override
    public Optional<PlayoffRanking> findByPlayerIdAndRound(UUID leaguePlayerId, PlayoffRound round, boolean isCumulative) {
        return Optional.ofNullable(storage.get(buildKey(leaguePlayerId, round, isCumulative)));
    }

    @Override
    public List<PlayoffRanking> findByLeagueIdAndRound(UUID leagueId, PlayoffRound round, boolean isCumulative) {
        // PlayoffRanking doesn't have leagueId - filter by round and cumulative flag only
        return storage.values().stream()
                .filter(r -> round.equals(r.getRound()) && r.isCumulative() == isCumulative)
                .sorted(Comparator.comparingInt(PlayoffRanking::getRank))
                .collect(Collectors.toList());
    }

    @Override
    public List<PlayoffRanking> findByPlayerId(UUID leaguePlayerId) {
        return storage.values().stream()
                .filter(r -> leaguePlayerId.equals(r.getLeaguePlayerId()))
                .collect(Collectors.toList());
    }

    @Override
    public List<PlayoffRanking> findCurrentCumulativeRankings(UUID leagueId) {
        // PlayoffRanking doesn't have leagueId - return all cumulative rankings
        return storage.values().stream()
                .filter(PlayoffRanking::isCumulative)
                .sorted(Comparator.comparingInt(PlayoffRanking::getRank))
                .collect(Collectors.toList());
    }

    @Override
    public PlayoffRanking save(PlayoffRanking ranking) {
        storage.put(buildKey(ranking.getLeaguePlayerId(), ranking.getRound(), ranking.isCumulative()), ranking);
        return ranking;
    }

    @Override
    public List<PlayoffRanking> saveAll(List<PlayoffRanking> rankings) {
        rankings.forEach(this::save);
        return rankings;
    }

    @Override
    public void deleteByLeagueIdAndRound(UUID leagueId, PlayoffRound round) {
        // PlayoffRanking doesn't have leagueId - delete by round only
        storage.entrySet().removeIf(e -> round.equals(e.getValue().getRound()));
    }
}
