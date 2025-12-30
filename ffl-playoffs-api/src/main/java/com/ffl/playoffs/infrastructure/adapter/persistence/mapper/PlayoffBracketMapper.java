package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.aggregate.PlayoffBracket;
import com.ffl.playoffs.domain.aggregate.PlayoffMatchup;
import com.ffl.playoffs.domain.model.*;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.*;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Mapper for converting between PlayoffBracket domain model and MongoDB document
 */
@Component
public class PlayoffBracketMapper {

    public PlayoffBracket toDomain(PlayoffBracketDocument doc) {
        if (doc == null) return null;

        PlayoffBracket bracket = new PlayoffBracket();
        bracket.setId(UUID.fromString(doc.getId()));
        bracket.setLeagueId(UUID.fromString(doc.getLeagueId()));
        bracket.setLeagueName(doc.getLeagueName());
        bracket.setCurrentRound(PlayoffRound.valueOf(doc.getCurrentRound()));
        bracket.setTotalPlayers(doc.getTotalPlayers() != null ? doc.getTotalPlayers() : 0);
        bracket.setComplete(doc.isComplete());
        bracket.setCreatedAt(doc.getCreatedAt());
        bracket.setUpdatedAt(doc.getUpdatedAt());

        // Map tiebreaker configuration
        if (doc.getTiebreakerConfiguration() != null) {
            List<TiebreakerMethod> methods = doc.getTiebreakerConfiguration().getTiebreakerCascade()
                .stream()
                .map(TiebreakerMethod::valueOf)
                .collect(Collectors.toList());
            bracket.setTiebreakerConfiguration(new TiebreakerConfiguration(methods));
        }

        // Map player entries
        if (doc.getPlayerEntries() != null) {
            Map<UUID, PlayoffBracket.PlayerBracketEntry> entries = new HashMap<>();
            for (PlayoffBracketDocument.PlayerBracketEntryDocument entryDoc : doc.getPlayerEntries()) {
                UUID playerId = UUID.fromString(entryDoc.getPlayerId());
                PlayoffBracket.PlayerBracketEntry entry = new PlayoffBracket.PlayerBracketEntry(
                    playerId,
                    entryDoc.getPlayerName(),
                    entryDoc.getSeed(),
                    entryDoc.getRegularSeasonScore(),
                    PlayerPlayoffStatus.valueOf(entryDoc.getStatus()),
                    PlayoffRound.WILD_CARD
                );
                if (entryDoc.getEliminatedInRound() != null) {
                    entry.eliminate(
                        PlayoffRound.valueOf(entryDoc.getEliminatedInRound()),
                        entryDoc.getEliminatedByPlayerId() != null
                            ? UUID.fromString(entryDoc.getEliminatedByPlayerId())
                            : null
                    );
                }
                entries.put(playerId, entry);
            }
            bracket.setPlayerEntries(entries);
        }

        // Map matchups by round
        if (doc.getMatchupsByRound() != null) {
            Map<PlayoffRound, List<PlayoffMatchup>> matchups = new HashMap<>();
            for (Map.Entry<String, List<PlayoffMatchupDocument>> entry : doc.getMatchupsByRound().entrySet()) {
                PlayoffRound round = PlayoffRound.valueOf(entry.getKey());
                List<PlayoffMatchup> roundMatchups = entry.getValue().stream()
                    .map(this::mapMatchupToDomain)
                    .collect(Collectors.toList());
                matchups.put(round, roundMatchups);
            }
            bracket.setMatchupsByRound(matchups);
        }

        // Map scores by round
        if (doc.getScoresByRound() != null) {
            Map<PlayoffRound, List<RosterScore>> scores = new HashMap<>();
            for (Map.Entry<String, List<RosterScoreDocument>> entry : doc.getScoresByRound().entrySet()) {
                PlayoffRound round = PlayoffRound.valueOf(entry.getKey());
                List<RosterScore> roundScores = entry.getValue().stream()
                    .map(this::mapRosterScoreToDomain)
                    .collect(Collectors.toList());
                scores.put(round, roundScores);
            }
            bracket.setScoresByRound(scores);
        }

        // Map rankings by round
        if (doc.getRankingsByRound() != null) {
            Map<PlayoffRound, List<PlayoffRanking>> rankings = new HashMap<>();
            for (Map.Entry<String, List<PlayoffRankingDocument>> entry : doc.getRankingsByRound().entrySet()) {
                PlayoffRound round = PlayoffRound.valueOf(entry.getKey());
                List<PlayoffRanking> roundRankings = entry.getValue().stream()
                    .map(this::mapRankingToDomain)
                    .collect(Collectors.toList());
                rankings.put(round, roundRankings);
            }
            bracket.setRankingsByRound(rankings);
        }

        // Map cumulative scores
        if (doc.getCumulativeScores() != null) {
            Map<UUID, BigDecimal> cumulativeScores = new HashMap<>();
            for (Map.Entry<String, BigDecimal> entry : doc.getCumulativeScores().entrySet()) {
                cumulativeScores.put(UUID.fromString(entry.getKey()), entry.getValue());
            }
            bracket.setCumulativeScores(cumulativeScores);
        }

        return bracket;
    }

    public PlayoffBracketDocument toDocument(PlayoffBracket bracket) {
        if (bracket == null) return null;

        PlayoffBracketDocument doc = new PlayoffBracketDocument();
        doc.setId(bracket.getId().toString());
        doc.setLeagueId(bracket.getLeagueId().toString());
        doc.setLeagueName(bracket.getLeagueName());
        doc.setCurrentRound(bracket.getCurrentRound().name());
        doc.setTotalPlayers(bracket.getTotalPlayers());
        doc.setComplete(bracket.isComplete());
        doc.setCreatedAt(bracket.getCreatedAt());
        doc.setUpdatedAt(bracket.getUpdatedAt());

        // Map tiebreaker configuration
        if (bracket.getTiebreakerConfiguration() != null) {
            PlayoffBracketDocument.TiebreakerConfigurationDocument tiebreakerDoc =
                new PlayoffBracketDocument.TiebreakerConfigurationDocument();
            tiebreakerDoc.setTiebreakerCascade(
                bracket.getTiebreakerConfiguration().getTiebreakerCascade().stream()
                    .map(TiebreakerMethod::name)
                    .collect(Collectors.toList())
            );
            doc.setTiebreakerConfiguration(tiebreakerDoc);
        }

        // Map player entries
        if (bracket.getPlayerEntries() != null) {
            List<PlayoffBracketDocument.PlayerBracketEntryDocument> entries = bracket.getPlayerEntries().values()
                .stream()
                .map(this::mapPlayerEntryToDocument)
                .collect(Collectors.toList());
            doc.setPlayerEntries(entries);
        }

        // Map matchups by round
        if (bracket.getMatchupsByRound() != null) {
            Map<String, List<PlayoffMatchupDocument>> matchups = new HashMap<>();
            for (Map.Entry<PlayoffRound, List<PlayoffMatchup>> entry : bracket.getMatchupsByRound().entrySet()) {
                List<PlayoffMatchupDocument> roundMatchups = entry.getValue().stream()
                    .map(this::mapMatchupToDocument)
                    .collect(Collectors.toList());
                matchups.put(entry.getKey().name(), roundMatchups);
            }
            doc.setMatchupsByRound(matchups);
        }

        // Map scores by round
        if (bracket.getScoresByRound() != null) {
            Map<String, List<RosterScoreDocument>> scores = new HashMap<>();
            for (Map.Entry<PlayoffRound, List<RosterScore>> entry : bracket.getScoresByRound().entrySet()) {
                List<RosterScoreDocument> roundScores = entry.getValue().stream()
                    .map(this::mapRosterScoreToDocument)
                    .collect(Collectors.toList());
                scores.put(entry.getKey().name(), roundScores);
            }
            doc.setScoresByRound(scores);
        }

        // Map rankings by round
        if (bracket.getRankingsByRound() != null) {
            Map<String, List<PlayoffRankingDocument>> rankings = new HashMap<>();
            for (Map.Entry<PlayoffRound, List<PlayoffRanking>> entry : bracket.getRankingsByRound().entrySet()) {
                List<PlayoffRankingDocument> roundRankings = entry.getValue().stream()
                    .map(this::mapRankingToDocument)
                    .collect(Collectors.toList());
                rankings.put(entry.getKey().name(), roundRankings);
            }
            doc.setRankingsByRound(rankings);
        }

        // Map cumulative scores
        if (bracket.getCumulativeScores() != null) {
            Map<String, BigDecimal> cumulativeScores = new HashMap<>();
            for (Map.Entry<UUID, BigDecimal> entry : bracket.getCumulativeScores().entrySet()) {
                cumulativeScores.put(entry.getKey().toString(), entry.getValue());
            }
            doc.setCumulativeScores(cumulativeScores);
        }

        return doc;
    }

    private PlayoffBracketDocument.PlayerBracketEntryDocument mapPlayerEntryToDocument(
            PlayoffBracket.PlayerBracketEntry entry) {
        PlayoffBracketDocument.PlayerBracketEntryDocument doc =
            new PlayoffBracketDocument.PlayerBracketEntryDocument();
        doc.setPlayerId(entry.getPlayerId().toString());
        doc.setPlayerName(entry.getPlayerName());
        doc.setSeed(entry.getSeed());
        doc.setRegularSeasonScore(entry.getRegularSeasonScore());
        doc.setStatus(entry.getStatus().name());
        if (entry.getEliminatedInRound() != null) {
            doc.setEliminatedInRound(entry.getEliminatedInRound().name());
        }
        if (entry.getEliminatedByPlayerId() != null) {
            doc.setEliminatedByPlayerId(entry.getEliminatedByPlayerId().toString());
        }
        doc.setEliminatedAt(entry.getEliminatedAt());
        return doc;
    }

    private PlayoffMatchup mapMatchupToDomain(PlayoffMatchupDocument doc) {
        PlayoffMatchup matchup = new PlayoffMatchup();
        matchup.setId(UUID.fromString(doc.getId()));
        matchup.setBracketId(UUID.fromString(doc.getBracketId()));
        matchup.setRound(PlayoffRound.valueOf(doc.getRound()));
        matchup.setMatchupNumber(doc.getMatchupNumber());
        matchup.setStatus(MatchupStatus.valueOf(doc.getStatus()));

        if (doc.getPlayer1Id() != null) {
            matchup.setPlayer1(
                UUID.fromString(doc.getPlayer1Id()),
                doc.getPlayer1Name(),
                doc.getPlayer1Seed()
            );
        }
        if (doc.getPlayer2Id() != null) {
            matchup.setPlayer2(
                UUID.fromString(doc.getPlayer2Id()),
                doc.getPlayer2Name(),
                doc.getPlayer2Seed()
            );
        }

        if (doc.getWinnerId() != null) {
            matchup.setWinnerId(UUID.fromString(doc.getWinnerId()));
        }
        if (doc.getLoserId() != null) {
            matchup.setLoserId(UUID.fromString(doc.getLoserId()));
        }
        matchup.setMarginOfVictory(doc.getMarginOfVictory());
        matchup.setUpset(doc.isUpset());
        matchup.setCreatedAt(doc.getCreatedAt());
        matchup.setCompletedAt(doc.getCompletedAt());

        return matchup;
    }

    private PlayoffMatchupDocument mapMatchupToDocument(PlayoffMatchup matchup) {
        PlayoffMatchupDocument doc = new PlayoffMatchupDocument();
        doc.setId(matchup.getId().toString());
        doc.setBracketId(matchup.getBracketId().toString());
        doc.setRound(matchup.getRound().name());
        doc.setMatchupNumber(matchup.getMatchupNumber());
        doc.setStatus(matchup.getStatus().name());

        if (matchup.getPlayer1Id() != null) {
            doc.setPlayer1Id(matchup.getPlayer1Id().toString());
            doc.setPlayer1Name(matchup.getPlayer1Name());
            doc.setPlayer1Seed(matchup.getPlayer1Seed());
        }
        if (matchup.getPlayer2Id() != null) {
            doc.setPlayer2Id(matchup.getPlayer2Id().toString());
            doc.setPlayer2Name(matchup.getPlayer2Name());
            doc.setPlayer2Seed(matchup.getPlayer2Seed());
        }

        if (matchup.getWinnerId() != null) {
            doc.setWinnerId(matchup.getWinnerId().toString());
        }
        if (matchup.getLoserId() != null) {
            doc.setLoserId(matchup.getLoserId().toString());
        }
        doc.setMarginOfVictory(matchup.getMarginOfVictory());
        doc.setUpset(matchup.isUpset());
        doc.setCreatedAt(matchup.getCreatedAt());
        doc.setCompletedAt(matchup.getCompletedAt());

        return doc;
    }

    private RosterScore mapRosterScoreToDomain(RosterScoreDocument doc) {
        List<PositionScore> positionScores = doc.getPositionScores().stream()
            .map(this::mapPositionScoreToDomain)
            .collect(Collectors.toList());

        return new RosterScore(
            UUID.fromString(doc.getLeaguePlayerId()),
            doc.getPlayerName(),
            PlayoffRound.valueOf(doc.getRound()),
            positionScores
        );
    }

    private RosterScoreDocument mapRosterScoreToDocument(RosterScore score) {
        RosterScoreDocument doc = new RosterScoreDocument();
        doc.setId(score.getId().toString());
        doc.setLeaguePlayerId(score.getLeaguePlayerId().toString());
        doc.setPlayerName(score.getPlayerName());
        doc.setRound(score.getRound().name());
        doc.setTotalScore(score.getTotalScore());
        doc.setTotalTouchdowns(score.getTotalTouchdowns());
        doc.setTotalTurnovers(score.getTotalTurnovers());
        doc.setCalculatedAt(score.getCalculatedAt());
        doc.setComplete(score.isComplete());

        List<RosterScoreDocument.PositionScoreDocument> positionScores = score.getPositionScores().stream()
            .map(this::mapPositionScoreToDocument)
            .collect(Collectors.toList());
        doc.setPositionScores(positionScores);

        return doc;
    }

    private PositionScore mapPositionScoreToDomain(RosterScoreDocument.PositionScoreDocument doc) {
        PositionScore.PositionStats stats = null;
        if (doc.getStats() != null) {
            stats = PositionScore.PositionStats.builder()
                .passingYards(doc.getStats().getPassingYards())
                .passingTouchdowns(doc.getStats().getPassingTouchdowns())
                .interceptions(doc.getStats().getInterceptions())
                .rushingYards(doc.getStats().getRushingYards())
                .rushingTouchdowns(doc.getStats().getRushingTouchdowns())
                .receivingYards(doc.getStats().getReceivingYards())
                .receivingTouchdowns(doc.getStats().getReceivingTouchdowns())
                .receptions(doc.getStats().getReceptions())
                .fumblesLost(doc.getStats().getFumblesLost())
                .sacks(doc.getStats().getSacks())
                .defensiveInterceptions(doc.getStats().getDefensiveInterceptions())
                .fumbleRecoveries(doc.getStats().getFumbleRecoveries())
                .defensiveTouchdowns(doc.getStats().getDefensiveTouchdowns())
                .pointsAllowed(doc.getStats().getPointsAllowed())
                .fieldGoalsMade0to39(doc.getStats().getFieldGoalsMade0to39())
                .fieldGoalsMade40to49(doc.getStats().getFieldGoalsMade40to49())
                .fieldGoalsMade50Plus(doc.getStats().getFieldGoalsMade50Plus())
                .extraPointsMade(doc.getStats().getExtraPointsMade())
                .build();
        }

        return new PositionScore(
            Position.valueOf(doc.getPosition()),
            doc.getNflPlayerId(),
            doc.getPlayerName(),
            doc.getNflTeam(),
            doc.getPoints(),
            doc.getStatus(),
            stats
        );
    }

    private RosterScoreDocument.PositionScoreDocument mapPositionScoreToDocument(PositionScore score) {
        RosterScoreDocument.PositionScoreDocument doc = new RosterScoreDocument.PositionScoreDocument();
        doc.setPosition(score.getPosition().name());
        doc.setNflPlayerId(score.getNflPlayerId());
        doc.setPlayerName(score.getPlayerName());
        doc.setNflTeam(score.getNflTeam());
        doc.setPoints(score.getPoints());
        doc.setStatus(score.getStatus());

        if (score.getStats() != null) {
            RosterScoreDocument.PositionStatsDocument statsDoc = new RosterScoreDocument.PositionStatsDocument();
            statsDoc.setPassingYards(score.getStats().getPassingYards());
            statsDoc.setPassingTouchdowns(score.getStats().getPassingTouchdowns());
            statsDoc.setInterceptions(score.getStats().getInterceptions());
            statsDoc.setRushingYards(score.getStats().getRushingYards());
            statsDoc.setRushingTouchdowns(score.getStats().getRushingTouchdowns());
            statsDoc.setReceivingYards(score.getStats().getReceivingYards());
            statsDoc.setReceivingTouchdowns(score.getStats().getReceivingTouchdowns());
            statsDoc.setReceptions(score.getStats().getReceptions());
            statsDoc.setFumblesLost(score.getStats().getFumblesLost());
            statsDoc.setSacks(score.getStats().getSacks());
            statsDoc.setDefensiveInterceptions(score.getStats().getDefensiveInterceptions());
            statsDoc.setFumbleRecoveries(score.getStats().getFumbleRecoveries());
            statsDoc.setDefensiveTouchdowns(score.getStats().getDefensiveTouchdowns());
            statsDoc.setPointsAllowed(score.getStats().getPointsAllowed());
            statsDoc.setFieldGoalsMade0to39(score.getStats().getFieldGoalsMade0to39());
            statsDoc.setFieldGoalsMade40to49(score.getStats().getFieldGoalsMade40to49());
            statsDoc.setFieldGoalsMade50Plus(score.getStats().getFieldGoalsMade50Plus());
            statsDoc.setExtraPointsMade(score.getStats().getExtraPointsMade());
            doc.setStats(statsDoc);
        }

        return doc;
    }

    private PlayoffRanking mapRankingToDomain(PlayoffRankingDocument doc) {
        return PlayoffRanking.builder()
            .leaguePlayerId(UUID.fromString(doc.getLeaguePlayerId()))
            .playerName(doc.getPlayerName())
            .rank(doc.getRank())
            .previousRank(doc.getPreviousRank())
            .score(doc.getScore())
            .round(PlayoffRound.valueOf(doc.getRound()))
            .isCumulative(doc.isCumulative())
            .roundsSurvived(doc.getRoundsSurvived())
            .status(PlayerPlayoffStatus.valueOf(doc.getStatus()))
            .build();
    }

    private PlayoffRankingDocument mapRankingToDocument(PlayoffRanking ranking) {
        PlayoffRankingDocument doc = new PlayoffRankingDocument();
        doc.setLeaguePlayerId(ranking.getLeaguePlayerId().toString());
        doc.setPlayerName(ranking.getPlayerName());
        doc.setRank(ranking.getRank());
        doc.setPreviousRank(ranking.getPreviousRank());
        doc.setScore(ranking.getScore());
        doc.setRound(ranking.getRound().name());
        doc.setCumulative(ranking.isCumulative());
        doc.setRoundsSurvived(ranking.getRoundsSurvived());
        doc.setStatus(ranking.getStatus().name());
        doc.setUpdatedAt(ranking.getUpdatedAt());
        return doc;
    }
}
