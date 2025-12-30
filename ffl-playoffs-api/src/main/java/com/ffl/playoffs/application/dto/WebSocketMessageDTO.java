package com.ffl.playoffs.application.dto;

import java.time.LocalDateTime;
import java.util.Map;

/**
 * Data Transfer Object for WebSocket Messages
 * Used for all live scoring WebSocket communication
 */
public class WebSocketMessageDTO {
    private MessageType messageType;
    private String leagueId;
    private String leaguePlayerId;
    private Object payload;
    private LocalDateTime timestamp;

    public WebSocketMessageDTO() {
        this.timestamp = LocalDateTime.now();
    }

    public static WebSocketMessageDTO scoreUpdate(String leaguePlayerId, LiveScoreDTO score) {
        WebSocketMessageDTO msg = new WebSocketMessageDTO();
        msg.setMessageType(MessageType.SCORE_UPDATE);
        msg.setLeaguePlayerId(leaguePlayerId);
        msg.setPayload(score);
        return msg;
    }

    public static WebSocketMessageDTO positionUpdate(String leaguePlayerId, LiveScoreDTO.PositionScoreDTO position) {
        WebSocketMessageDTO msg = new WebSocketMessageDTO();
        msg.setMessageType(MessageType.POSITION_UPDATE);
        msg.setLeaguePlayerId(leaguePlayerId);
        msg.setPayload(position);
        return msg;
    }

    public static WebSocketMessageDTO rankChange(String leaguePlayerId, Map<String, Object> rankData) {
        WebSocketMessageDTO msg = new WebSocketMessageDTO();
        msg.setMessageType(MessageType.RANK_CHANGE);
        msg.setLeaguePlayerId(leaguePlayerId);
        msg.setPayload(rankData);
        return msg;
    }

    public static WebSocketMessageDTO leaderboard(String leagueId, LiveLeaderboardDTO leaderboard) {
        WebSocketMessageDTO msg = new WebSocketMessageDTO();
        msg.setMessageType(MessageType.LEADERBOARD_UPDATE);
        msg.setLeagueId(leagueId);
        msg.setPayload(leaderboard);
        return msg;
    }

    public static WebSocketMessageDTO gameCompleted(String leagueId, Map<String, Object> gameData) {
        WebSocketMessageDTO msg = new WebSocketMessageDTO();
        msg.setMessageType(MessageType.GAME_COMPLETED);
        msg.setLeagueId(leagueId);
        msg.setPayload(gameData);
        return msg;
    }

    public static WebSocketMessageDTO dataDelayWarning(String leagueId, String message, int delaySeconds) {
        WebSocketMessageDTO msg = new WebSocketMessageDTO();
        msg.setMessageType(MessageType.DATA_DELAY_WARNING);
        msg.setLeagueId(leagueId);
        msg.setPayload(Map.of(
                "message", message,
                "delaySeconds", delaySeconds
        ));
        return msg;
    }

    public MessageType getMessageType() {
        return messageType;
    }

    public void setMessageType(MessageType messageType) {
        this.messageType = messageType;
    }

    public String getLeagueId() {
        return leagueId;
    }

    public void setLeagueId(String leagueId) {
        this.leagueId = leagueId;
    }

    public String getLeaguePlayerId() {
        return leaguePlayerId;
    }

    public void setLeaguePlayerId(String leaguePlayerId) {
        this.leaguePlayerId = leaguePlayerId;
    }

    public Object getPayload() {
        return payload;
    }

    public void setPayload(Object payload) {
        this.payload = payload;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    public enum MessageType {
        SCORE_UPDATE,
        POSITION_UPDATE,
        RANK_CHANGE,
        LEADERBOARD_UPDATE,
        GAME_COMPLETED,
        DATA_DELAY_WARNING,
        CONNECTION_CLOSING,
        SNAPSHOT
    }
}
