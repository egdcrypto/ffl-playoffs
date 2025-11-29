package com.ffl.playoffs.infrastructure.websocket;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;

/**
 * WebSocket handler for NFL real-time data updates
 * Supports subscription to specific games or players for live updates
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class NFLDataWebSocketHandler extends TextWebSocketHandler {

    private final ObjectMapper objectMapper;

    // All connected sessions
    private final Set<WebSocketSession> sessions = new CopyOnWriteArraySet<>();

    // Subscriptions by game ID
    private final Map<String, Set<WebSocketSession>> gameSubscriptions = new ConcurrentHashMap<>();

    // Subscriptions by player ID
    private final Map<String, Set<WebSocketSession>> playerSubscriptions = new ConcurrentHashMap<>();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        sessions.add(session);
        log.info("WebSocket connection established: {}", session.getId());

        // Send welcome message
        sendMessage(session, Map.of(
                "type", "connected",
                "message", "Connected to NFL updates WebSocket",
                "sessionId", session.getId()
        ));
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        sessions.remove(session);

        // Remove from all subscriptions
        gameSubscriptions.values().forEach(set -> set.remove(session));
        playerSubscriptions.values().forEach(set -> set.remove(session));

        log.info("WebSocket connection closed: {} - {}", session.getId(), status.getReason());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        try {
            Map<String, Object> payload = objectMapper.readValue(message.getPayload(), Map.class);
            String action = (String) payload.get("action");

            if (action == null) {
                sendError(session, "Missing 'action' field");
                return;
            }

            switch (action) {
                case "subscribe_game" -> handleSubscribeGame(session, payload);
                case "unsubscribe_game" -> handleUnsubscribeGame(session, payload);
                case "subscribe_player" -> handleSubscribePlayer(session, payload);
                case "unsubscribe_player" -> handleUnsubscribePlayer(session, payload);
                case "ping" -> handlePing(session);
                default -> sendError(session, "Unknown action: " + action);
            }
        } catch (Exception e) {
            log.error("Error handling WebSocket message", e);
            sendError(session, "Invalid message format");
        }
    }

    private void handleSubscribeGame(WebSocketSession session, Map<String, Object> payload) throws IOException {
        String gameId = (String) payload.get("gameId");
        if (gameId == null) {
            sendError(session, "Missing 'gameId' for subscribe_game");
            return;
        }

        gameSubscriptions.computeIfAbsent(gameId, k -> new CopyOnWriteArraySet<>()).add(session);
        log.info("Session {} subscribed to game {}", session.getId(), gameId);

        sendMessage(session, Map.of(
                "type", "subscribed",
                "subscription", "game",
                "gameId", gameId
        ));
    }

    private void handleUnsubscribeGame(WebSocketSession session, Map<String, Object> payload) throws IOException {
        String gameId = (String) payload.get("gameId");
        if (gameId == null) {
            sendError(session, "Missing 'gameId' for unsubscribe_game");
            return;
        }

        Set<WebSocketSession> subscribers = gameSubscriptions.get(gameId);
        if (subscribers != null) {
            subscribers.remove(session);
        }
        log.info("Session {} unsubscribed from game {}", session.getId(), gameId);

        sendMessage(session, Map.of(
                "type", "unsubscribed",
                "subscription", "game",
                "gameId", gameId
        ));
    }

    private void handleSubscribePlayer(WebSocketSession session, Map<String, Object> payload) throws IOException {
        String playerId = (String) payload.get("playerId");
        if (playerId == null) {
            sendError(session, "Missing 'playerId' for subscribe_player");
            return;
        }

        playerSubscriptions.computeIfAbsent(playerId, k -> new CopyOnWriteArraySet<>()).add(session);
        log.info("Session {} subscribed to player {}", session.getId(), playerId);

        sendMessage(session, Map.of(
                "type", "subscribed",
                "subscription", "player",
                "playerId", playerId
        ));
    }

    private void handleUnsubscribePlayer(WebSocketSession session, Map<String, Object> payload) throws IOException {
        String playerId = (String) payload.get("playerId");
        if (playerId == null) {
            sendError(session, "Missing 'playerId' for unsubscribe_player");
            return;
        }

        Set<WebSocketSession> subscribers = playerSubscriptions.get(playerId);
        if (subscribers != null) {
            subscribers.remove(session);
        }
        log.info("Session {} unsubscribed from player {}", session.getId(), playerId);

        sendMessage(session, Map.of(
                "type", "unsubscribed",
                "subscription", "player",
                "playerId", playerId
        ));
    }

    private void handlePing(WebSocketSession session) throws IOException {
        sendMessage(session, Map.of(
                "type", "pong",
                "timestamp", System.currentTimeMillis()
        ));
    }

    /**
     * Broadcast a game update to all subscribers of that game
     * @param gameId the game ID
     * @param update the update data
     */
    public void broadcastGameUpdate(String gameId, Object update) {
        Set<WebSocketSession> subscribers = gameSubscriptions.get(gameId);
        if (subscribers != null && !subscribers.isEmpty()) {
            Map<String, Object> message = Map.of(
                    "type", "game_update",
                    "gameId", gameId,
                    "data", update,
                    "timestamp", System.currentTimeMillis()
            );
            broadcastToSessions(subscribers, message);
        }
    }

    /**
     * Broadcast a player stat update to all subscribers of that player
     * @param playerId the player ID
     * @param update the update data
     */
    public void broadcastPlayerUpdate(String playerId, Object update) {
        Set<WebSocketSession> subscribers = playerSubscriptions.get(playerId);
        if (subscribers != null && !subscribers.isEmpty()) {
            Map<String, Object> message = Map.of(
                    "type", "player_update",
                    "playerId", playerId,
                    "data", update,
                    "timestamp", System.currentTimeMillis()
            );
            broadcastToSessions(subscribers, message);
        }
    }

    /**
     * Broadcast a message to all connected sessions
     * @param message the message to broadcast
     */
    public void broadcastToAll(Object message) {
        broadcastToSessions(sessions, message);
    }

    private void broadcastToSessions(Set<WebSocketSession> targetSessions, Object message) {
        for (WebSocketSession session : targetSessions) {
            try {
                if (session.isOpen()) {
                    sendMessage(session, message);
                }
            } catch (IOException e) {
                log.error("Error sending message to session {}", session.getId(), e);
            }
        }
    }

    private void sendMessage(WebSocketSession session, Object message) throws IOException {
        String json = objectMapper.writeValueAsString(message);
        session.sendMessage(new TextMessage(json));
    }

    private void sendError(WebSocketSession session, String errorMessage) throws IOException {
        sendMessage(session, Map.of(
                "type", "error",
                "message", errorMessage
        ));
    }

    /**
     * Get the number of connected sessions
     * @return the number of connected sessions
     */
    public int getConnectionCount() {
        return sessions.size();
    }

    /**
     * Get the number of game subscriptions
     * @param gameId the game ID
     * @return the number of subscribers
     */
    public int getGameSubscriptionCount(String gameId) {
        Set<WebSocketSession> subscribers = gameSubscriptions.get(gameId);
        return subscribers != null ? subscribers.size() : 0;
    }

    /**
     * Get the number of player subscriptions
     * @param playerId the player ID
     * @return the number of subscribers
     */
    public int getPlayerSubscriptionCount(String playerId) {
        Set<WebSocketSession> subscribers = playerSubscriptions.get(playerId);
        return subscribers != null ? subscribers.size() : 0;
    }
}
