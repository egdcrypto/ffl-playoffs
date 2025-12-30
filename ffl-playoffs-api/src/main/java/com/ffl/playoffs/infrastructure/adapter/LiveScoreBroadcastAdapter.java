package com.ffl.playoffs.infrastructure.adapter;

import com.ffl.playoffs.application.dto.LiveScoreDTO;
import com.ffl.playoffs.application.dto.WebSocketMessageDTO;
import com.ffl.playoffs.domain.event.GameCompletedEvent;
import com.ffl.playoffs.domain.event.LeaderboardRankChangedEvent;
import com.ffl.playoffs.domain.event.PlayerStatsUpdatedEvent;
import com.ffl.playoffs.domain.event.RosterScoreChangedEvent;
import com.ffl.playoffs.domain.model.RankChange;
import com.ffl.playoffs.domain.port.LiveScoreBroadcastPort;
import com.ffl.playoffs.infrastructure.websocket.LiveScoreWebSocketHandler;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Infrastructure adapter implementing the LiveScoreBroadcastPort
 * Bridges domain events to WebSocket broadcasts
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class LiveScoreBroadcastAdapter implements LiveScoreBroadcastPort {

    private final LiveScoreWebSocketHandler webSocketHandler;

    @Override
    public void broadcastScoreUpdate(RosterScoreChangedEvent event) {
        LiveScoreDTO scoreDto = new LiveScoreDTO();
        scoreDto.setLeaguePlayerId(event.getLeaguePlayerId());
        scoreDto.setPlayerName(event.getPlayerName());
        scoreDto.setCurrentScore(event.getNewScore());
        scoreDto.setPreviousScore(event.getPreviousScore());
        scoreDto.setScoreDelta(event.getScoreDelta());
        scoreDto.setStatus(event.getStatus());
        scoreDto.setLastUpdated(event.getOccurredAt());

        WebSocketMessageDTO message = WebSocketMessageDTO.scoreUpdate(
                event.getLeaguePlayerId(),
                scoreDto
        );

        // Broadcast to specific roster subscribers
        webSocketHandler.broadcastToRoster(event.getLeaguePlayerId(), message);

        // Also broadcast to league subscribers
        webSocketHandler.broadcastToLeague(event.getLeagueId(), message);

        log.debug("Broadcast score update for player {}: {} -> {}",
                event.getLeaguePlayerId(), event.getPreviousScore(), event.getNewScore());
    }

    @Override
    public void broadcastPositionUpdate(String leaguePlayerId, PlayerStatsUpdatedEvent event) {
        LiveScoreDTO.PositionScoreDTO positionDto = new LiveScoreDTO.PositionScoreDTO();
        positionDto.setNflPlayerId(event.getNflPlayerId());
        positionDto.setNflPlayerName(event.getNflPlayerName());
        positionDto.setGameInfo(event.getGameInfo());
        positionDto.setLastStatUpdate(event.getStatUpdate());

        WebSocketMessageDTO message = WebSocketMessageDTO.positionUpdate(
                leaguePlayerId,
                positionDto
        );

        webSocketHandler.broadcastToRoster(leaguePlayerId, message);

        log.debug("Broadcast position update for player {}: {} scored {}",
                leaguePlayerId, event.getNflPlayerName(), event.getPointsDelta());
    }

    @Override
    public void broadcastRankChanges(LeaderboardRankChangedEvent event) {
        for (RankChange change : event.getRankChanges()) {
            Map<String, Object> rankData = new HashMap<>();
            rankData.put("previousRank", change.getPreviousRank());
            rankData.put("newRank", change.getNewRank());
            rankData.put("rankDelta", change.getRankDelta());
            rankData.put("leaderName", change.getLeaderName());
            rankData.put("pointsBehindLeader", change.getPointsBehindLeader());
            rankData.put("currentScore", change.getCurrentScore());

            WebSocketMessageDTO message = WebSocketMessageDTO.rankChange(
                    change.getLeaguePlayerId(),
                    rankData
            );

            // Broadcast to the specific player's roster subscribers
            webSocketHandler.broadcastToRoster(change.getLeaguePlayerId(), message);
        }

        // Broadcast summary to league
        Map<String, Object> leagueData = new HashMap<>();
        leagueData.put("changesCount", event.getRankChanges().size());
        leagueData.put("timestamp", event.getOccurredAt());

        webSocketHandler.broadcastToLeague(event.getLeagueId(), Map.of(
                "type", "RANK_CHANGES",
                "data", leagueData
        ));

        log.debug("Broadcast {} rank changes for league {}",
                event.getRankChanges().size(), event.getLeagueId());
    }

    @Override
    public void broadcastGameCompleted(GameCompletedEvent event) {
        Map<String, Object> gameData = new HashMap<>();
        gameData.put("gameId", event.getNflGameId());
        gameData.put("homeTeam", event.getHomeTeam());
        gameData.put("awayTeam", event.getAwayTeam());
        gameData.put("homeScore", event.getHomeScore());
        gameData.put("awayScore", event.getAwayScore());
        gameData.put("isOvertime", event.isOvertime());
        gameData.put("summary", event.getGameSummary());

        // Broadcast to all connected clients
        WebSocketMessageDTO message = new WebSocketMessageDTO();
        message.setMessageType(WebSocketMessageDTO.MessageType.GAME_COMPLETED);
        message.setPayload(gameData);

        webSocketHandler.broadcastToAll(message);

        log.info("Broadcast game completion: {}", event.getGameSummary());
    }

    @Override
    public void broadcastLeaderboard(String leagueId, List<Map<String, Object>> leaderboard) {
        webSocketHandler.broadcastToLeague(leagueId, Map.of(
                "type", "LEADERBOARD_UPDATE",
                "leagueId", leagueId,
                "leaderboard", leaderboard,
                "timestamp", System.currentTimeMillis()
        ));

        log.debug("Broadcast leaderboard update for league {} with {} entries",
                leagueId, leaderboard.size());
    }

    @Override
    public void broadcastDataDelayWarning(String leagueId, String message, int delaySeconds) {
        WebSocketMessageDTO wsMessage = WebSocketMessageDTO.dataDelayWarning(
                leagueId,
                message,
                delaySeconds
        );

        webSocketHandler.broadcastToLeague(leagueId, wsMessage);

        log.warn("Broadcast data delay warning to league {}: {} ({}s delay)",
                leagueId, message, delaySeconds);
    }

    @Override
    public int getActiveConnectionCount(String leagueId) {
        return webSocketHandler.getLeagueSubscriptionCount(leagueId);
    }

    @Override
    public boolean isPlayerConnected(String leaguePlayerId) {
        return webSocketHandler.isPlayerConnected(leaguePlayerId);
    }
}
