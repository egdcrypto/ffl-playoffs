package com.ffl.playoffs.infrastructure.websocket;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ffl.playoffs.application.dto.LiveScoreDTO;
import com.ffl.playoffs.application.dto.WebSocketMessageDTO;
import com.ffl.playoffs.application.service.LiveScoringService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.time.Instant;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * WebSocket handler for live score updates
 * Handles subscriptions to leagues, rosters, and leaderboards
 */
@Slf4j
@Component
public class LiveScoreWebSocketHandler extends TextWebSocketHandler {

    private final ObjectMapper objectMapper;
    private final LiveScoringService liveScoringService;

    public LiveScoreWebSocketHandler(ObjectMapper objectMapper, @Lazy LiveScoringService liveScoringService) {
        this.objectMapper = objectMapper;
        this.liveScoringService = liveScoringService;
    }

    // All connected sessions
    private final Set<WebSocketSession> sessions = new CopyOnWriteArraySet<>();

    // Subscriptions by league ID
    private final Map<String, Set<WebSocketSession>> leagueSubscriptions = new ConcurrentHashMap<>();

    // Subscriptions by league player ID (for roster-specific updates)
    private final Map<String, Set<WebSocketSession>> rosterSubscriptions = new ConcurrentHashMap<>();

    // Session metadata (userId, leagueId, etc.)
    private final Map<String, SessionMetadata> sessionMetadata = new ConcurrentHashMap<>();

    // Last activity timestamp per session for idle timeout
    private final Map<String, Instant> lastActivity = new ConcurrentHashMap<>();

    // Throttling: last message time per subscription
    private final Map<String, Long> lastMessageTime = new ConcurrentHashMap<>();
    private static final long THROTTLE_MS = 1000; // Minimum 1 second between messages

    // Idle timeout
    private static final long IDLE_TIMEOUT_MS = 30 * 60 * 1000; // 30 minutes

    // Connection limits
    private static final int MAX_CONNECTIONS = 12000;
    private static final int WARNING_THRESHOLD = 11500;

    // Background cleanup scheduler
    private final ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();

    public void init() {
        // Schedule idle connection cleanup
        scheduler.scheduleAtFixedRate(this::cleanupIdleConnections, 5, 5, TimeUnit.MINUTES);
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        if (sessions.size() >= MAX_CONNECTIONS) {
            log.warn("Connection limit reached, rejecting new connection");
            sendMessage(session, Map.of(
                    "type", "error",
                    "message", "Server at capacity, please try again later"
            ));
            session.close(CloseStatus.SERVICE_OVERLOAD);
            return;
        }

        sessions.add(session);
        lastActivity.put(session.getId(), Instant.now());

        log.info("Live score WebSocket connection established: {}", session.getId());

        if (sessions.size() >= WARNING_THRESHOLD) {
            log.warn("High connection count: {}", sessions.size());
        }

        // Send welcome message
        sendMessage(session, Map.of(
                "type", "connected",
                "message", "Connected to Live Scores WebSocket",
                "sessionId", session.getId()
        ));
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        sessions.remove(session);

        // Remove from all subscriptions
        leagueSubscriptions.values().forEach(set -> set.remove(session));
        rosterSubscriptions.values().forEach(set -> set.remove(session));
        sessionMetadata.remove(session.getId());
        lastActivity.remove(session.getId());

        log.info("Live score WebSocket connection closed: {} - {}", session.getId(), status.getReason());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        lastActivity.put(session.getId(), Instant.now());

        try {
            Map<String, Object> payload = objectMapper.readValue(message.getPayload(), Map.class);
            String action = (String) payload.get("action");

            if (action == null) {
                sendError(session, "Missing 'action' field");
                return;
            }

            switch (action) {
                case "subscribe_league" -> handleSubscribeLeague(session, payload);
                case "unsubscribe_league" -> handleUnsubscribeLeague(session, payload);
                case "subscribe_roster" -> handleSubscribeRoster(session, payload);
                case "unsubscribe_roster" -> handleUnsubscribeRoster(session, payload);
                case "get_snapshot" -> handleGetSnapshot(session, payload);
                case "ping" -> handlePing(session);
                default -> sendError(session, "Unknown action: " + action);
            }
        } catch (Exception e) {
            log.error("Error handling WebSocket message", e);
            sendError(session, "Invalid message format");
        }
    }

    private void handleSubscribeLeague(WebSocketSession session, Map<String, Object> payload) throws IOException {
        String leagueId = (String) payload.get("leagueId");
        String userId = (String) payload.get("userId");

        if (leagueId == null) {
            sendError(session, "Missing 'leagueId' for subscribe_league");
            return;
        }

        leagueSubscriptions.computeIfAbsent(leagueId, k -> new CopyOnWriteArraySet<>()).add(session);
        sessionMetadata.put(session.getId(), new SessionMetadata(userId, leagueId, null));

        log.info("Session {} subscribed to league {}", session.getId(), leagueId);

        sendMessage(session, Map.of(
                "type", "subscribed",
                "subscription", "league",
                "leagueId", leagueId
        ));
    }

    private void handleUnsubscribeLeague(WebSocketSession session, Map<String, Object> payload) throws IOException {
        String leagueId = (String) payload.get("leagueId");
        if (leagueId == null) {
            sendError(session, "Missing 'leagueId' for unsubscribe_league");
            return;
        }

        Set<WebSocketSession> subscribers = leagueSubscriptions.get(leagueId);
        if (subscribers != null) {
            subscribers.remove(session);
        }

        log.info("Session {} unsubscribed from league {}", session.getId(), leagueId);

        sendMessage(session, Map.of(
                "type", "unsubscribed",
                "subscription", "league",
                "leagueId", leagueId
        ));
    }

    private void handleSubscribeRoster(WebSocketSession session, Map<String, Object> payload) throws IOException {
        String leaguePlayerId = (String) payload.get("leaguePlayerId");
        String userId = (String) payload.get("userId");
        String leagueId = (String) payload.get("leagueId");

        if (leaguePlayerId == null) {
            sendError(session, "Missing 'leaguePlayerId' for subscribe_roster");
            return;
        }

        rosterSubscriptions.computeIfAbsent(leaguePlayerId, k -> new CopyOnWriteArraySet<>()).add(session);
        sessionMetadata.put(session.getId(), new SessionMetadata(userId, leagueId, leaguePlayerId));

        log.info("Session {} subscribed to roster {}", session.getId(), leaguePlayerId);

        sendMessage(session, Map.of(
                "type", "subscribed",
                "subscription", "roster",
                "leaguePlayerId", leaguePlayerId
        ));

        // Send current snapshot
        LiveScoreDTO snapshot = liveScoringService.getScoreSnapshot(leaguePlayerId);
        sendMessage(session, WebSocketMessageDTO.scoreUpdate(leaguePlayerId, snapshot));
    }

    private void handleUnsubscribeRoster(WebSocketSession session, Map<String, Object> payload) throws IOException {
        String leaguePlayerId = (String) payload.get("leaguePlayerId");
        if (leaguePlayerId == null) {
            sendError(session, "Missing 'leaguePlayerId' for unsubscribe_roster");
            return;
        }

        Set<WebSocketSession> subscribers = rosterSubscriptions.get(leaguePlayerId);
        if (subscribers != null) {
            subscribers.remove(session);
        }

        log.info("Session {} unsubscribed from roster {}", session.getId(), leaguePlayerId);

        sendMessage(session, Map.of(
                "type", "unsubscribed",
                "subscription", "roster",
                "leaguePlayerId", leaguePlayerId
        ));
    }

    private void handleGetSnapshot(WebSocketSession session, Map<String, Object> payload) throws IOException {
        String leaguePlayerId = (String) payload.get("leaguePlayerId");
        if (leaguePlayerId == null) {
            sendError(session, "Missing 'leaguePlayerId' for get_snapshot");
            return;
        }

        LiveScoreDTO snapshot = liveScoringService.getScoreSnapshot(leaguePlayerId);
        WebSocketMessageDTO msg = WebSocketMessageDTO.scoreUpdate(leaguePlayerId, snapshot);
        msg.setMessageType(WebSocketMessageDTO.MessageType.SNAPSHOT);
        sendMessage(session, msg);
    }

    private void handlePing(WebSocketSession session) throws IOException {
        sendMessage(session, Map.of(
                "type", "pong",
                "timestamp", System.currentTimeMillis()
        ));
    }

    /**
     * Broadcast to all subscribers of a league
     */
    public void broadcastToLeague(String leagueId, Object message) {
        Set<WebSocketSession> subscribers = leagueSubscriptions.get(leagueId);
        if (subscribers != null && !subscribers.isEmpty()) {
            // Apply throttling
            String throttleKey = "league:" + leagueId;
            if (shouldThrottle(throttleKey)) {
                log.debug("Throttling message to league {}", leagueId);
                return;
            }

            broadcastToSessions(subscribers, message);
        }
    }

    /**
     * Broadcast to all subscribers of a roster
     */
    public void broadcastToRoster(String leaguePlayerId, Object message) {
        Set<WebSocketSession> subscribers = rosterSubscriptions.get(leaguePlayerId);
        if (subscribers != null && !subscribers.isEmpty()) {
            // Apply throttling
            String throttleKey = "roster:" + leaguePlayerId;
            if (shouldThrottle(throttleKey)) {
                log.debug("Throttling message to roster {}", leaguePlayerId);
                return;
            }

            broadcastToSessions(subscribers, message);
        }
    }

    /**
     * Broadcast to all connected sessions
     */
    public void broadcastToAll(Object message) {
        broadcastToSessions(sessions, message);
    }

    private boolean shouldThrottle(String key) {
        long now = System.currentTimeMillis();
        Long lastTime = lastMessageTime.get(key);

        if (lastTime != null && (now - lastTime) < THROTTLE_MS) {
            return true;
        }

        lastMessageTime.put(key, now);
        return false;
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

    private void cleanupIdleConnections() {
        Instant now = Instant.now();
        int closedCount = 0;

        for (WebSocketSession session : sessions) {
            Instant last = lastActivity.get(session.getId());
            if (last != null && now.toEpochMilli() - last.toEpochMilli() > IDLE_TIMEOUT_MS) {
                try {
                    sendMessage(session, Map.of(
                            "type", "CONNECTION_CLOSING",
                            "reason", "Idle timeout"
                    ));
                    session.close(CloseStatus.GOING_AWAY);
                    closedCount++;
                } catch (IOException e) {
                    log.warn("Error closing idle session {}", session.getId(), e);
                }
            }
        }

        if (closedCount > 0) {
            log.info("Closed {} idle connections", closedCount);
        }
    }

    /**
     * Get connection count
     */
    public int getConnectionCount() {
        return sessions.size();
    }

    /**
     * Get league subscription count
     */
    public int getLeagueSubscriptionCount(String leagueId) {
        Set<WebSocketSession> subscribers = leagueSubscriptions.get(leagueId);
        return subscribers != null ? subscribers.size() : 0;
    }

    /**
     * Get roster subscription count
     */
    public int getRosterSubscriptionCount(String leaguePlayerId) {
        Set<WebSocketSession> subscribers = rosterSubscriptions.get(leaguePlayerId);
        return subscribers != null ? subscribers.size() : 0;
    }

    /**
     * Check if a player is connected
     */
    public boolean isPlayerConnected(String leaguePlayerId) {
        Set<WebSocketSession> subscribers = rosterSubscriptions.get(leaguePlayerId);
        return subscribers != null && !subscribers.isEmpty();
    }

    private record SessionMetadata(String userId, String leagueId, String leaguePlayerId) {}
}
